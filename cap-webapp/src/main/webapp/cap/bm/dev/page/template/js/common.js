//生成代码
function generateCode() {
	var selectIds = cui("#lstMetadataGenerate").getSelectedPrimaryKey();
	if (selectIds == null || selectIds.length == 0) {
		cui.alert("请选择要生成的元数据。");
		return;
	}
	var hasGenRowIndex = [];
	var selectedIndexs = cui("#lstMetadataGenerate").getSelectedIndex();
	for(var i=0, len=selectIds.length; i<len; i++){
		var hasGen = hasGeneratedCode({modelId: selectIds[i]});
		if(hasGen){
			hasGenRowIndex.push(selectedIndexs[i]+1);
		}
	}
	if(hasGenRowIndex.length > 0){
		cui.confirm("第"+hasGenRowIndex+'行已生成过页面元数据，是否执行覆盖？', {
            onYes: function () {
            	execGeneratePageMetaCode(selectIds);
            }
        });
	} else {
		execGeneratePageMetaCode(selectIds);
	}
}

/**
 * 请求后台api生成元数据代码
 * @param selectIds 生成元数据模型Id集合
 */
function execGeneratePageMetaCode(selectIds){
	dwr.TOPEngine.setAsync(false);
	MetadataGenerateFacade.generatePageJsonByIds(selectIds, function(data) {
		if (data != null) {
			if(data.result === '1'){
//				cui.message(data.message, "success");
				var retCout = 0;
				for(var i= 0;i<selectIds.length;i++){
				//更新页面元数据的行为方法体 
					var modelName = selectIds[i].substr(selectIds[i].lastIndexOf(".")+1,selectIds[i].length);
					var pageModelIdKey = modelName + "pageModelIds";
					var templateNumKey = modelName + "templateNum";
					var templateNum = eval("data."+ templateNumKey);
					var pageModelIds = eval("data."+ pageModelIdKey);
					var iCount = updatePageActionMethodBody(eval(pageModelIds));
					if(iCount == templateNum){
						retCout++;
					}
				}
				if(retCout==selectIds.length){
					cui.message(data.message, "success");	
				}else{
					var errorCount = selectIds.length - retCout;
					cui.message("成功生成元数据"+retCout+"条，生成元数据失败"+errorCount+"条", "success");	
				}
				window.parent.frames["pageFrame"].contentWindow.location.reload(true);
			} else {
				cui.message(data.message, "error");
			}
		} else {
			cui.message("生成元数据失败。", "error");
		}
	});
	dwr.TOPEngine.setAsync(true);
}

//检查是否已生成过页面元数据代码
function hasGeneratedCode(metadataGenerateVO){
	var result = false;
	dwr.TOPEngine.setAsync(false);
	MetadataGenerateFacade.isGeneratedCode(metadataGenerateVO, function(_result) {
		result = _result;
	});
	dwr.TOPEngine.setAsync(true);
	return result;
}

/**
 * 根据databind绑定的属性，生成对应校验规则
 * @param attribute 属性对象
 * @param uitype 控件类型
 * @param formComponentType 表单控件类型
 */
function generateValidate(attribute, uitype, formComponentType){
	var validate = [];
	var cname = attribute.chName;
	//查询区域不用增加校验是否为空
	if(!attribute.allowNull){// 校验是否为空
		if(typeof formComponentType == "undefined" || ( formComponentType != "queryFixedCodeArea" && formComponentType != "queryMoreCodeArea" )){
			validate.push({'type':'required', 'rule':{m: cname+'不能为空'}});
		}
	}
	var attributeType = attribute.attributeType.type;
	if(uitype != 'ChooseUser' && uitype != 'ChooseOrg' && uitype != 'RadioGroup' 
		&& uitype != 'CheckboxGroup' && uitype != 'PullDown' &&
			attribute.attributeType.source != 'dataDictionary' && 
			attribute.attributeType.source != 'enumType' && 
			attributeType != 'java.sql.Date' && attributeType != 'java.sql.Timestamp'){
		if(attribute.attributeLength > 0){// 最大长度
			if(attribute.precision > 0){
				//存在精度长度+1
				validate.push({'type':'length', 'rule':{max:attribute.attributeLength+1,maxm: cname+'长度不能大于'+(attribute.attributeLength+1)+'个字符'}});
			}else{
				validate.push({'type':'length', 'rule':{max:attribute.attributeLength,maxm: cname+'长度不能大于'+attribute.attributeLength+'个字符'}});
			}
		}
		if(attribute.precision > 0){// 校验数字精度
//			var regex = '^[0-9]+(.[0-9]{'+attribute.precision+'})?$';
//			validate.push({'type':'format', 'rule':{pattern: regex,m: "精度是"+attribute.precision+'位小数点'}});
			
			var regex = '^[0-9]{1,' + (attribute.attributeLength-attribute.precision) + '}(\\.[0-9]{1,'+attribute.precision+'})?$';
			validate.push({'type':'format', 'rule':{pattern: regex,m: "整数最多为"+(attribute.attributeLength-attribute.precision)+"位，小数最多为"+attribute.precision+'位'}});
		}
	}
	return validate;
}

/**
 * 从工具箱获取控件信息
 * @param componentModelId 控件ID
 */
function getComponentByModelId(componentModelId, toolsdata){
	return _.cloneDeep(_.find(getAllComponent4Toolsdata(toolsdata),{"modelId":componentModelId}));
}

/**
 * 从工具箱中过滤出所有控件（工具箱包括控件类型子节点LayoutVo，需过滤掉）
 * @param data 控件数据源（ComponentTypeFacade.queryList获取的数据，即工具箱数据源）
 */
function getAllComponent4Toolsdata(data){
  var ary = [];
  _.forEach(data,function(n){
      if(n.isFolder){
        ary = ary.concat(getAllComponent4Toolsdata(n.children));
      }else{
        ary.push(n.componentVo);
      }
  })
  return ary; 
}

/**
 * 获取实体属性对象
 * @param entityId 实体Id
 */
function getAttributes(entityId){
	var attributes = [];
	var entityVO = getEntity(entityId);
	if(entityVO != null){
		for(var i in entityVO.attributes){
			var sourceType = entityVO.attributes[i].attributeType.source;
			if(sourceType != "primitive" && sourceType != "dataDictionary" && sourceType != "enumType"){
				continue;
			}
			attributes.push(jQuery.extend(true, {}, entityVO.attributes[i]));
		}
	}
	return attributes;
}

/**
 * 转化成下拉框数据格式
 * @param entityList 实体数据集
 */
function entityDataToDatasource(entityList){
	var datasource = [];
	var hasRepeatEntity = {};
	_.forEach(entityList, function(entityVO){
		if(entityVO != null){
			hasRepeatEntity[entityVO.engName] = hasRepeatEntity[entityVO.engName] != null ? true : false;
		}
	});
	_.forEach(entityList, function(entityVO){
		if(entityVO != null && entityVO.modelId != null){
			var text = hasRepeatEntity[entityVO.engName] ? entityVO.engName+'【'+entityVO.suffix+'】' : entityVO.engName;
    		datasource.push({id: entityVO.suffix, text: text, entityVO: entityVO});
		}
	});
	return datasource;
}


/**
 * 实体封装成下拉框数据源(本身实体以及子实体)
 * @param entityId 实体Id
 */
function entityInfoToDatasource(entityId){
	var datasource = [];
	var entityVO = getEntity(entityId);
	if(entityVO != null){
		datasource.push({id: entityId, text: entityVO.engName, entityVO: entityVO, relationVariableName: ''});
		if(entityVO.lstRelation && Array.isArray(entityVO.lstRelation) && entityVO.lstRelation.length > 0){
			_.forEach(entityVO.lstRelation, function(obj){
				var entityVO = getEntity(obj.targetEntityId);
				var relationVariableName = "relation" + obj.engName.substring(0, 1).toUpperCase() + obj.engName.substring(1, obj.engName.length);
				datasource.push({id: entityVO.modelId, text: obj.engName+'->'+entityVO.engName, entityVO: entityVO, relationVariableName: relationVariableName});
			});
		}
	}
	return datasource;
}


/**
 * 关联子实体封装成下拉框数据源（"One-Many"、"Many-Many"）
 * @param entityId 实体Id
 */
function getDatasource4SubEntity(entityId){
	if(!entityId){
		return [];
	}
	var datasource = [];
	var entityVO = getEntity(entityId);
	if(entityVO.lstRelation && Array.isArray(entityVO.lstRelation) && entityVO.lstRelation.length > 0){
		_.forEach(entityVO.lstRelation, function(obj){
			if(obj.multiple == "One-Many" || obj.multiple == "Many-Many"){
				var subEntityVO = getEntity(obj.targetEntityId);
				var relationVariableName = "relation" + obj.engName.substring(0, 1).toUpperCase() + obj.engName.substring(1, obj.engName.length);
				datasource.push({id: subEntityVO.modelId, text: obj.engName+'->'+subEntityVO.engName, entityVO: subEntityVO, relationVariableName: relationVariableName});
			}
		});
	}
	return datasource;
}

/**
 * 转换成控件属性对应的类型
 * @param dataValue 对象
 * @param dataType 对象属性对应的类型
 */
function transformDataType(dataValue, dataType){
	var ret = {};
	_.forEach(dataValue, function(value, key){
		if(dataType[key] === 'Number'){
			ret[key] = Number(value);
		} else if(dataType[key] === "Boolean"){
			ret[key] = value === "true" ? true : false;
		} else {
			ret[key] = value;
		}
	});
	return ret;
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

//用于创建UI函数
function getComponentNodeData(componentModelId){
   	return _.cloneDeep(_.find(filter(toolsdata), {"componentModelId": componentModelId}));
}

//获取所有菜单子类
function filter(data){
	var ary = [];
    _.forEach(data,function(n){
    	if(n.isFolder){
        	ary = ary.concat(filter(n.children));
      	}else{
        	ary.push(n);
      	}
  	})
  	return ary;
}

/**
 * 校验数组值是否重复
 * @param arr
 */
function isRepeat(arr){
	var hash = {};
	for(var i in arr) {
		if(hash[arr[i]])
			return true;
		hash[arr[i]] = true;
	}
	return false;
}

/**
 * 网格（编辑网格）列render渲染函数
 * @param obj
 */
function getDefaultRenderMethods(){
	var pageTemplateActionVOList = [];
	dwr.TOPEngine.setAsync(false);
	PageTemplateActionPreferenceFacade.getDefaultPageTemplateActionPreference(function(data) {
		if(data != null){
			pageTemplateActionVOList = data.lstActions;
		}
	});
	dwr.TOPEngine.setAsync(true);
	var datasource = [];
	_.forEach(pageTemplateActionVOList, function(pageTemplateActionVO, key) {
		datasource.push({id: pageTemplateActionVO.actionDefineVO.modelId, text: pageTemplateActionVO.actionDefineVO.cname});
	});
	return datasource;
}

/**
 * 加载生成的元数据模版
 * @param metadataPageConfigModelId
 * @param packageId
 */
function getMetadataGenerate(metadataGenerateModelId, packageId){
	var metadataGenerateVO = null;
	dwr.TOPEngine.setAsync(false);
	MetadataGenerateFacade.loadModel(metadataGenerateModelId, packageId, function(data){
		metadataGenerateVO = data;
	});
	dwr.TOPEngine.setAsync(true);
	return metadataGenerateVO;
}

/**
 * 通过模版modelId获取页面配置信息
 * @param metadataPageConfigModelId
 */
function getMetadataPageConfig(metadataPageConfigModelId){
	var metadataPageConfigVO = null;
	dwr.TOPEngine.setAsync(false);
	MetadataPageConfigFacade.loadModel(metadataPageConfigModelId, function(data){
		metadataPageConfigVO = data;
	});
	dwr.TOPEngine.setAsync(true);
	return metadataPageConfigVO;
}

/**
 * 封装查询区域控件的初始化时所需的数据对象
 * @param metaComponentDefine 子控件控件对象信息
 * @param data 数据值
 */
function setQuerySubAreaData(metaComponentDefine, data){
	var componentInfo = metaComponentDefine.uiConfig.componentInfo;
	if(componentInfo != null){
		if(data == null){
			data = {fixedQueryAreaList: [], moreQueryAreaList: []};
		}
		var fixedAreaList = wrapperDataByQueryOrEditSubArea(componentInfo.queryFixedCodeArea, data.fixedQueryAreaList, 'queryFixedCodeArea');
		var moreAreaList = wrapperDataByQueryOrEditSubArea(componentInfo.queryMoreCodeArea, data.moreQueryAreaList,  'queryMoreCodeArea');
		return fixedAreaList.concat(moreAreaList);
	} else {
		return [{id: 'queryFixedCodeArea', uitype: 'queryFixedCodeArea', scope: {}}, {id: 'queryMoreCodeArea', uitype: 'queryMoreCodeArea', scope: {}}];
	}
}

/**
 * 封装编辑区域控件的初始化时所需的数据对象
 * @param metaComponentDefine 子控件控件对象信息
 * @param data 数据值
 */
function setEditSubAreaData(metaComponentDefine, data){
	var componentInfo = metaComponentDefine.uiConfig.componentInfo;
	if(componentInfo != null){
		if(data == null){
			data = {editFormCodeArea: [], editGridCodeArea: []};
		}
		var formAreaList = wrapperDataByQueryOrEditSubArea(componentInfo.editFormCodeArea, data.formAreaList, 'editFormCodeArea');
		var editableGridList = wrapperDataByQueryOrEditSubArea(componentInfo.editGridCodeArea, data.editGridAreaList, 'editGridCodeArea');
		return formAreaList.concat(editableGridList);
	} else {
		return [];
	}
}

/**
 * 封装查询子区域(或编辑子区域)控件初始化时所需的数据对象
 * @param subComponentList 查询子区域(或编辑子区域)控件控件对象信息
 * @param dataList 数据值
 * @param uitype 子控件类型
 */
function wrapperDataByQueryOrEditSubArea(subComponentList, dataList, uitype){
	var retValueList = [];
	_.forEach(subComponentList, function(componentVo, key) {
		var tempScope = {label: componentVo.pageURL != null ? JSON.stringify(componentVo.pageURL) : null, entityId: '', attributes: []};
		var id = getRandomId("uiid");
		for(var i in dataList){
			if(dataList[i].areaId == componentVo.areaId){
				id = dataList[i].id;
				break;
			}
		}
		retValueList.push({id: id, areaId: componentVo.areaId, uitype: uitype, scope: tempScope});
	});
	return retValueList;
}

/**
 * 获取随机数
 * @param prefix 前缀
 */
function getRandomId(prefix){
	return prefix +"_"+ (90*Math.random()+10).toString().replace(".","");
}

/**
 * 编辑区域子控件排版
 * @param componentList 编辑子区域控件集
 * @param sortList 控件排序的序号列表
 */
function sortByEditArea(componentList, sortList){
	var tempArray = jQuery.extend(true, [], componentList);
	componentList.splice(0, componentList.length);
	_.forEach(sortList, function(value) {
		var data = _.find(tempArray, {id: value});
		componentList.push(data);
	})
}

/**
 * 添加引用文件
 * @param prefix 前缀
 */
function getIncludeFile(include){
	var includeFileList = [];
	if(include.hasIncludeUserOrgFileList && include.hasIncludeDictionaryFileList){
		includeFileList = getIncludeDictionaryFileList().concat(getIncludeUserOrgFileList());
	} else if(include.hasIncludeUserOrgFileList && !include.hasIncludeDictionaryFileList){
		includeFileList = getIncludeUserOrgFileList();
	} else if(!include.hasIncludeUserOrgFileList && include.hasIncludeDictionaryFileList){
		includeFileList = getIncludeDictionaryFileList();
	} 
	return includeFileList;
}

/**
 * 获取默认的控件数据，用于控件定义类型
 * @param obj 下拉框dom对象
 */
function getDefaultComponentByEditType(){
	var datasource = [];
	dwr.TOPEngine.setAsync(false);
	ComponentFacade.queryComponentList('edittype', ['dev'], function(data){
		for(var key in data){
			datasource.push({componentModelId:data[key].modelId, modelName: data[key].modelName});
		}
	});
	dwr.TOPEngine.setAsync(true);
	return datasource;
}
