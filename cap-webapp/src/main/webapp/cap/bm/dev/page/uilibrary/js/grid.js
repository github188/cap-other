/**
 * 设置表头单元格列合并项
 * @param customHeaders 多表头集合
 * @param currLevel 当前级别
 * @param index customHeaders下标号
 */
function setColspan(customHeaders, currLevel, index){
	var upLevel = currLevel-1;
	for(var j=index-1; j>=0; j--){
		if(customHeaders[j].level == upLevel){
			customHeaders[j].colspan = customHeaders[j].colspan != null && customHeaders[j].colspan != '' ? (customHeaders[j].colspan+1) : 1;
			if(upLevel == 1){
				break;
			}
			upLevel--;
		}
	}
}

/**
 * 设置表头单元格行合并项
 * @param customHeaders 多表头集合
 * @param maxLevel 最大级别
 * @param currLevel 当前级别
 * @param index customHeaders下标号
 */
function setRowspan(customHeaders, maxLevel, currLevel, index){
	var hasCurrColumnRowSpan = false;
	for(var j=index-1; j>=0; j--){//往前推（兄弟层级）
		if(customHeaders[j].level > currLevel){
			hasCurrColumnRowSpan = true;
			break;
		} else if(customHeaders[j].level < currLevel || customHeaders[j].level == (currLevel-1)){
			for(var k=index+1, len=customHeaders.length; k<=len; k++){//往后推（兄弟层级）
				if(customHeaders[k].level > currLevel){
					hasCurrColumnRowSpan = true;
					break;
				} else if(customHeaders[k].level < currLevel){
					break;
				}
			}
			break;
		} 
	}
	var rowspan = maxLevel - currLevel + 1;
	if(hasCurrColumnRowSpan){
		customHeaders[index].rowspan = rowspan;
	} else {
		customHeaders[index-1].rowspan = rowspan;
	}
}

/**
 * 处理绑定数据的表头行（注：根节点为表头第一行的单元格，父节点下的子节点至少要有两个）
 * @param _customHeaders 多表头集合
 */
function getMultiLineHeaders(_customHeaders){
	var multiLineHeaders = [];
	var customHeaders = jQuery.extend(true, [], _customHeaders);
	var maxLevel = _.pluck(_.sortBy(customHeaders, 'level'), 'level').reverse()[0];
	if(maxLevel > 1 && customHeaders[0].level == 1){
		var frontHeaders = customHeaders[0];
		var nextLevel = customHeaders[0].level+1;
		if(customHeaders[1].level != nextLevel){//是否是叶子
			customHeaders[0].rowspan = maxLevel;
		}
		customHeaders[0].rowNo = 1;
		//合并列、行
		for(var i=1,len=customHeaders.length; i<len; i++){
			var frontLevel = frontHeaders.level;
			var currLevel = customHeaders[i].level;
			var gradeDiff = currLevel - frontLevel;
			if(currLevel == 1){//1级
				nextLevel = currLevel+1;
				if(customHeaders[i+1] == null || 
						(customHeaders[i+1] != null && customHeaders[i+1].level != nextLevel)){//是否是叶子
					customHeaders[i].rowspan = maxLevel;
				}
				customHeaders[i].rowNo = 1;
				frontHeaders = customHeaders[i];
			} else if(gradeDiff == 0 && currLevel > 1){//子级同级
				var nextLevel = currLevel+1;
				if(customHeaders[i+1] == null || 
						(customHeaders[i+1] != null && customHeaders[i+1].level != nextLevel)){//是否是叶子
					setColspan(customHeaders, currLevel, i);
					if(maxLevel != currLevel){
						setRowspan(customHeaders, maxLevel, currLevel, i);
					}
				}
				customHeaders[i].rowNo = parseInt(customHeaders[i-1].rowNo);
				frontHeaders = customHeaders[i];
			} else if(gradeDiff == 1){//下一级（子节点）
				nextLevel = currLevel+1;
				if(customHeaders[i+1] != null && customHeaders[i+1].level != nextLevel){//是否是叶子
					setColspan(customHeaders, currLevel, i);
					if(maxLevel != currLevel){
						setRowspan(customHeaders, maxLevel, currLevel, i);
					}
				} 
				customHeaders[i].rowNo = parseInt(customHeaders[i-1].rowNo) + (customHeaders[i-1].rowspan != null && customHeaders[i-1].rowspan != '' ? parseInt(customHeaders[i-1].rowspan) : 1);
				frontHeaders = customHeaders[i];
			} else if(currLevel > 1 && gradeDiff < 0){//长辈同级兄弟
				nextLevel = currLevel+1;
				if(customHeaders[i+1] == null || 
						(customHeaders[i+1] != null && customHeaders[i+1].level != nextLevel)){//是否是叶子
					setColspan(customHeaders, currLevel, i);
					if(maxLevel != currLevel){
						setRowspan(customHeaders, maxLevel, currLevel, i);
					}
				}
				for(var j=i-1; j>=0; j--){
					if(customHeaders[j].level == currLevel){//同级兄弟
						customHeaders[i].rowNo = parseInt(customHeaders[j].rowNo);
						break;
					}
				}
				frontHeaders = customHeaders[i];
			} else { //结构错误
				customHeaders = [];
				break;
			}
		}
		if(customHeaders.length > 0){
			for(var i=1; i<=maxLevel; i++){//多表头分组
    			var customHeader = _.filter(customHeaders, 'rowNo', i)
    			multiLineHeaders.push(customHeader);
    		}
		}
	} else {
		customHeaders = [];
	}
	return multiLineHeaders;
}

/**
 * 列头属性数据类型转换
 * @param customHeader 表头行
 * @param attrsType 控件对象属性类型
 */
function transformColumns(customHeader, attrsType){
	for(var j in customHeader){
		delete customHeader[j].customHeaderId;
		delete customHeader[j].check;
		delete customHeader.edittype;
		var modeVo = customHeader[j];
		for(var key in modeVo){
			var type = attrsType.get(key);
			if((modeVo[key] == null || modeVo[key] == '' || modeVo[key] === 'null') && key != 'name'){
				delete modeVo[key];
				continue;
			}
			if(type === 'Number'){
				modeVo[key] = Number(modeVo[key]);
			} else if(type === "Boolean"){
				modeVo[key] = modeVo[key] === "true" ? true : false;
			} else if(type === "Array" || type === "Json"){
				modeVo[key] = eval("("+ modeVo[key] +")");
			} else if(type == null && key != 'type' && key != 'componentModelId'){
				delete modeVo[key];
			}
		}
	}
}

/**
 * 控件类型数据转换
 * @param obj 控件对象
 * @param attrsType 控件对象属性类型
 */
function transformEdittype(obj, attrsType){
	for(var key in obj){
		var type = attrsType.get(key);
		if(obj[key] == null || obj[key] == ''){
			delete obj[key];
			continue;
		}
		if(type === 'Number'){
			obj[key] = Number(obj[key]);
		} else if(type === "Boolean"){
			obj[key] = obj[key] === "true" ? true : false;
		} else if(type === "Json"){
			try{
				var evalValue = eval("("+ obj[key] +")");
				obj[key] = evalValue != null ? evalValue : obj[key];
			}catch(e){
				obj[key] = obj[key];
			}
		} 
	}
}

/**
 * 判断是否是第三方控件
 * @param uitype 控件类型
 */
function hasThrdComponent(uitype){
	var ret = false;
	var thrdComponents = ['ChooseUser', 'ChooseOrg'];
	for(var i=0, len=thrdComponents.length; i<len; i++){
    	if(uitype === thrdComponents[i]){
    		ret = true;
    		break;
    	}
	}
	return ret;
}

/**
 * uitype下拉框赋值
 * @param obj 下拉框dom对象
 */
function initUItypeData(obj){
	dwr.TOPEngine.setAsync(false);
	ComponentFacade.queryComponentList('edittype', ['dev'], function(data){
		var datasource = [];
		for(var key in data){
			datasource.push({id:data[key].modelName, text: data[key].modelName});
		}
		obj.setDatasource(datasource);
	});
	dwr.TOPEngine.setAsync(true);
}

/**
 * 剔除对象中属性值为空或null属性
 * @param data 对象
 */
function deleteNullAndEmpty(data){
	_.forEach(data, function(value, key){
		if(value === '' || value == null){
			delete data[key];
		}
	});
}

function wrapOptions(data){
	//编辑grid：控件定义类型，如果遇到数字字典就会报错，cui处理问题，目前在这里处理，避免cui处理错误，等cui改造完在剔除该部分；
	if(data.uitype === 'CheckboxGroup' && data.checkbox_list == null){ 
		data.checkbox_list = '';
	} else if (data.uitype === 'RadioGroup' && data.radio_list == null){
		data.radio_list = '';
	} else if (data.uitype === 'PullDown' && data.datasource == null){
		data.datasource = '';
	} 
}

/**
 * 根据实体属性类型匹配控件ID
 * @param attributeType 属性类型
 */
function getComponentModelIdByAttType(attributeType){
	var componentModelId = "uicomponent.common.component.input";
	if(attributeType === 'java.sql.Date' || attributeType === 'java.sql.Timestamp'){
		componentModelId = "uicomponent.common.component.calender";
	} else if(attributeType === 'boolean'){
		componentModelId = "uicomponent.common.component.radioGroup";
	}
    return componentModelId;
}

/**
 * 根据实体属性类型匹配控件类型
 * @param attributeType 属性类型
 */
function getUItypeByAttrType(attributeType){
	var uitype = "Input";
	if(attributeType === 'java.sql.Date' || attributeType === 'java.sql.Timestamp'){
		uitype = "Calender";
	} else if(attributeType === 'boolean'){
		uitype = "RadioGroup";
	}
    return uitype;
}

/**
 * 根据实体属性对象,匹配出CUI控件，并返回控件属性对象
 * @param attributeType 属性类型
 */
function getCompAttrObjByEntityAttrVo(attributeVo){
	var options = {uitype: 'Input', componentModelId: 'uicomponent.common.component.input'};
	var type = attributeVo.attributeType.type;
	var source = attributeVo.attributeType.source;
	if(source === 'dataDictionary' || source === 'enumType'){
		if(type != 'boolean'){ //不是布尔类型，强行更改为下拉框控件
			options.uitype = 'PullDown';
		} else { //是布尔类型，默认单选框控件
			options.name = attributeVo.engName;
			options.uitype = 'RadioGroup'
		}
		var keys = {dataDictionary: 'dictionary', enumType: 'enumdata'};
		options[keys[source]] = attributeVo.attributeType.value;
	} else {
		if(type === 'java.sql.Date' || type === 'java.sql.Timestamp'){
			options.uitype = "Calender";
			options.format = 'yyyy-MM-dd';
		} else if(type === 'boolean'){
			options.uitype = "RadioGroup";
			options.name = attributeVo.engName;
		}
	}
    return options;
}

/**
 * 创建列对象(editableGrid)
 * @param attributeVo 属性对象
 */
function createComponentVo4Attribute(attributeVo){
	attributeVo.isFilter = true;
	attributeVo.check = false;
	var options = getCompAttrObjByEntityAttrVo(attributeVo);
	return {customHeaderId: attributeVo.engName, name: attributeVo.chName, bindName: attributeVo.engName, level: 1, indent:'', format: options.uitype === 'Calender' ? 'yyyy-MM-dd' : '', edittype:{data: options}};
}

//获取人员或组织引用文件
function getIncludeUserOrgFileList(){
	return [{defaultReference: false, fileName: "choose", filePath : "/top/sys/usermanagement/orgusertag/js/choose.js", fileType: "js"},
			   {defaultReference: false, fileName: "engine", filePath : "/cap/dwr/engine.js", fileType: "js"},
			   {defaultReference: false, fileName: "util", filePath : "/cap/dwr/util.js", fileType: "js"},
			   {defaultReference: false, fileName: "ChooseAction", filePath : "/top/sys/dwr/interface/ChooseAction.js", fileType: "js"},
			   {defaultReference: false, fileName: "choose", filePath : "/top/sys/usermanagement/orgusertag/css/choose.css", fileType: "css"}];
}

//获取数字字典引用文件
function getIncludeDictionaryFileList(){
	return [{defaultReference: false, fileName: "dictionary", filePath : "/cap/rt/common/cui/js/cui.extend.dictionary.js", fileType: "js"}];
}

//引用人员或组织、数字字典引用文件
function importIncludeFileList(edittype, page){
	var hasIncludeUserOrgFileList = false;
	var hasIncludeDictionaryFileList = false;
	if(typeof edittype == "object"){
		_.forEach(edittype, function(chr) {
			if(!hasIncludeUserOrgFileList && (chr.uitype === "ChooseUser" || chr.uitype === "ChooseOrg")){
				hasIncludeUserOrgFileList = true;
			}
			if(!hasIncludeDictionaryFileList && chr.dictionary != null){
				hasIncludeDictionaryFileList = true;
			}
		});
	}
	if(hasIncludeUserOrgFileList || hasIncludeDictionaryFileList){
		if(hasIncludeUserOrgFileList){
			addIncludeFileList(page.includeFileList, getIncludeUserOrgFileList());
		} else if(!hasIncludeUserOrgFileByOtherEditGrid()){
			deleteIncludeUserOrgFileList(page);
		}
		if(hasIncludeDictionaryFileList){
			addIncludeFileList(page.includeFileList, getIncludeDictionaryFileList());
		} else if(!hasIncludeDicFileByOtherEditGrid()){
			deleteIncludeDictionaryFileList(page);
		}
	} else {//修改前是控件定义类型有人员或组织、数字字典，修改后已不存在，如果符合以下条件，则删除相关引用文件
		if(!hasIncludeUserOrgFileByOtherEditGrid()){
			deleteIncludeUserOrgFileList(page);
		}
		if(!hasIncludeDicFileByOtherEditGrid()){
			deleteIncludeDictionaryFileList(page);
		}
	}
};

/**
 * 删除人员（组织）引用文件（js、css）
 * @param page pageVo对象
 */
function deleteIncludeUserOrgFileList(page){
	var includeUserOrgFileList = getIncludeUserOrgFileList();
	_.forEach(includeUserOrgFileList, function(chr) {
		page.includeFileList = _.remove(page.includeFileList, function(n){
			  return chr.filePath != n.filePath;
		});
	});
}

/**
 * 删除数字字典引用文件（js、css）
 * @param page pageVo对象
 */
function deleteIncludeDictionaryFileList(page){
	var includeDictionaryFileList = getIncludeDictionaryFileList();
	page.includeFileList = _.remove(page.includeFileList, function(n){
		  return includeDictionaryFileList[0].filePath != n.filePath;
	});
}

/**
 * 删除数字字典引用文件（js、css）
 */
function hasIncludeDicFileByOtherEditGrid(){
	var hasIncludeDictionaryFileList = false;
	var uiData = window.opener.parent._cdata.getUIData();
	var currComponentId = window.opener.scope.layoutVO.id;
	_.forEach(uiData, function(obj) {//扫描设计器上的其他EditableGrid控件是否也使用了人员或组织、数字字典
		if(currComponentId != obj.id && obj.objectOptions != null && obj.objectOptions.uitype === 'EditableGrid' && 
				obj.objectOptions.edittype != null && obj.objectOptions.edittype != ''){
			_.forEach(obj.objectOptions.edittype, function(bindNameVo){
				if(bindNameVo.dictionary != null && bindNameVo.dictionary != ''){
					hasIncludeDictionaryFileList = true;
				}
			});
		}
	});
	return hasIncludeDictionaryFileList;
}

/**
 * 删除人员（组织）引用文件（js、css）
 */
function hasIncludeUserOrgFileByOtherEditGrid(){
	var hasIncludeUserOrgFileList = false;
	var uiData = window.opener.parent._cdata.getUIData();
	var currComponentId = window.opener.scope.layoutVO.id;
	_.forEach(uiData, function(obj) {//扫描设计器上的其他EditableGrid控件是否也使用了人员或组织、数字字典
		if(currComponentId != obj.id && obj.objectOptions != null && obj.objectOptions.uitype === 'EditableGrid' 
			&& obj.objectOptions.edittype != null && obj.objectOptions.edittype != ''){
			_.forEach(obj.objectOptions.edittype, function(bindNameVo){
				if(bindNameVo.uitype === "ChooseUser" || bindNameVo.uitype === "ChooseOrg"){
					hasIncludeUserOrgFileList = true;
				}
			});
		}
	});
	return hasIncludeUserOrgFileList;
}

/**
 * 添加引用文件（js、css）
 * @param includeFileList page.includeFileList引用文件
 * @param addIncludeFileList 新增引用文件
 */
function addIncludeFileList(includeFileList, addIncludeFileList){
	_.forEach(addIncludeFileList, function(obj) {
		var isExist = _.find(includeFileList, {filePath: obj.filePath});
		if(isExist == null){
			includeFileList.push(obj);
		}
	});
}

/**
 * 根据实体Id，获取实体属性对象
 * @param entityId 实体id
 * @param pageDataStores 数据集
 */
function getAttributesByCondition(entityId, pageDataStores){
	var attributes = [];
	var parents = _.pluck(_.filter(pageDataStores,function(n){
		return n.modelType=="object";
	}),"entityVO");
	
	var subs =	_.flatten(_.pluck(_.filter(pageDataStores,function(n){
			return n.modelType=="object";
		}),"subEntity"));
	attributes = _.map(_.result(_.find(_.union(parents,subs),function(n){
		return n != null && n.modelId == entityId;
	}),"attributes"),function(n){
		return n;
	});
	return attributes;
}

/**
 * 实体属性默认值绑定到控件对应的属性中（目前只有数据字典和枚举）
 * @param uitype 控件类型
 * @param attributes 实体属性集合
 * @param attrEngName 属性名称
 * @param data 控件属性对象
 */
function setAttrDefault2ComponentOptions(uitype, attributes, attrEngName, data){
	if(uitype === "PullDown" || uitype === "CheckboxGroup" || uitype === "RadioGroup") {
    	var attr = _.find(attributes, {engName: attrEngName});
    	var sourceType = attr != null && attr.attributeType != null ? attr.attributeType.source : null;
    	if(sourceType != null){
	    	var keys = {dataDictionary: 'dictionary', enumType: 'enumdata'};
	    	data[keys[sourceType]] = attr.attributeType.value;
    	}
    }
}
