//使用该文件之前，必须引用lodash.js
/**
 * 属性值类型转换(注：Json类型不须转换)
 * @param data 控件属性对象
 * @param propertiesMap 控件属性集如：{'uicomponent.common.component.button'：propertyVo},key：modelId，value：属性对象
 */
function dataTypeConversion(data, propertiesMap){
	var propertiesKeySet = propertiesMap.keySet();
	for(var i in propertiesKeySet){
		var key = propertiesKeySet[i];
		var type = propertiesMap.get(key).type;
		if(data[key] == null || data[key] == ''){
			continue;
		}
		if(type === 'Number'){
			data[key] = Number(data[key]);
		} else if(type === "Boolean"){
			data[key] = data[key] === "true" ? true : false;
		} else {
			data[key] = data[key];
		} 
	}
}

//RadioGroup、CheckboxGroup、Tree在设计器上初始化的数据
var defaultVal4special = [{text: '值1', value: '1', title: '设备类别结构', key: 'k1'},{text: '值2', value: '2', title: 'Folder 2', key: 'k2', isFolder: 'true'},{text: '值3', value: '3', title: '其他', key: 'k3', hideCheckbox: 'true'}];//在设计器上设置占位符，避免变成一点; 

/**
 * 通过字符串版options生成对象版ObjectOptions
 * @param data 控件属性对象
 * @param propertiesMap 控件属性集如：{'uicomponent.common.component.button'：propertyVo},key：modelId，value：属性对象
 */
function options2ObjectOptions(options, propertiesMap){
	var objectOptions = jQuery.extend(true, {}, options);
	var jsonAttrs = _.map(_.filter(propertiesMap.values(), {type: 'Json'}), 'ename');
	stringToObjectByObjectOptions(objectOptions, jsonAttrs);
	return objectOptions;
}

/**
 * 对objectOptions对象中的属性类型为json的进行类型转换
 * @param objectOptions 控件属性对象版
 * @param jsonAttrs 控件属性类型为json的属性名称集合
 */
function stringToObjectByObjectOptions(objectOptions, jsonAttrs){
	for(var i=0, len=jsonAttrs.length; i<len; i++){
		var key = jsonAttrs[i];
		var flag = (objectOptions.uitype === "RadioGroup" || objectOptions.uitype === "CheckboxGroup" || objectOptions.uitype === "Tree") && 
			(key === "checkbox_list" || key === "radio_list" || key === "datasource" || key === "children");
		if(objectOptions[key] != null && objectOptions[key] != ""){
			if(flag){//单选框和复选框、tree特殊处理
				var reg = /^\[{/;
		        if(objectOptions[key] == null || !reg.test(objectOptions[key])){ 
		        	objectOptions[key] = defaultVal4special;
		        	continue;
		        } 
			} 
			try{
				objectOptions[key] = eval(objectOptions[key]);
 		  	} catch (e){ 
	  		  	if(objectOptions.uitype === "Button" && key === "menu" && /^\{/.test(objectOptions[key])){
					objectOptions[key] = {};
				} else {
					delete objectOptions[key];
				}
 		  	}
		} else if(flag){//单选框和复选框、tree特殊处理
		 	objectOptions[key] = defaultVal4special;
		} 
	}
}

/**
 * 控件属性对象版数据过滤
 * @param data 控件属性对象
 * @param properties 属性数据集
 */
function filterObjectOptionsByRule(data, componentVo){
	filterPropertiesByRule(data, componentVo.properties);
	filterEventsByRule(data, componentVo.events);
}

/**
 * 属性数据过滤
 * @param data 控件属性对象
 * @param properties 属性数据集
 */
function filterPropertiesByRule(data, properties){
	for(var i in properties){
		var filterRule = properties[i].filterRule;
		if(!filterRule || !data[properties[i].ename]){
			continue;
		}
		filterRule = eval("("+filterRule+")");
		var value = data[properties[i].ename];
		if(_.isArray(value)){
			for(var key in filterRule){
				for(var j in value){
					dataHandleByRule(value[j], filterRule, key);
				}
			}
		} else {
			for(var key in filterRule){
				dataHandleByRule(data, filterRule, key);
			}
		}
	}
}

//数据处理
function dataHandleByRule(data, filterRule, key){
	if(typeof filterRule[key] === 'object'){
		var obj = filterRule[key];
		if(obj.operate === '$replace$' && data[key]){
			_.set(data, key, data[key].replace(obj.regexp.indexOf("/") == 0 ? eval(obj.regexp) : obj.regexp, obj.replacement));
		}
	} else {
		if(filterRule[key] === '$delete$'){
			delete data[key];
		} else {
			_.set(data, key, filterRule[key]);
		}
	}
}

/**
 * 行为数据过滤
 * @param data 控件属性对象
 * @param properties 属性数据集
 */
function filterEventsByRule(data, events){
	for(var k in events){
		var filterRule = events[k].filterRule;
		if(!filterRule || !data[events[k].ename]){
			continue;
		}
		filterRule = eval("("+filterRule+")");
		for(var key in filterRule){
			var actionIdkey = key + "_id";
			if(filterRule[key] === '$delete$'){
				delete data[key];
				delete data[actionIdkey];
			} else {
				_.set(data, key, filterRule[key]);
				_.set(data, actionIdkey, filterRule[key]);
			}
		}
	}
}

/**
 * 获取值相同的属性(针对批量操作)
 * @param keyMaps key对象
 * @param dataList 数据源
 */
function commonValue(keyMaps, dataList){
	var commonData = {};
	for(var i in keyMaps){
		var key = keyMaps[i].ename;
		var compareValue = dataList[0].options != null ? dataList[0].options[key] : '';
		for(var j=1, len=dataList.length; j < len; j++){
			if(compareValue != dataList[j].options[key]){
				compareValue = null;
				break;
			}
		}
		if(compareValue != null){
			commonData[key] = compareValue;
		}
	}
	return commonData;
}

/**
 * 根据行模式，修改表头
 * @param data 数据源
 * @param selectrows 行模式
 */
function updateColumnsBySelectrows(data, selectrows){
	var columns = data.columns;
	columns = columns != '' ? JSON.parse(columns) : [];
	if(_.isArray(columns[0])){//判断是否是多表头
		var firstColumn = columns[0][0];
		if(selectrows == 'multi' || selectrows == ''){
			if(firstColumn.width != null){
				firstColumn.type = 'checkbox';
			} else {
				columns[0] = _.union([{rowspan:columns.length,width:60,type:'checkbox'}], columns[0]);
			}
		} else if(selectrows == 'single') {
			if(firstColumn.width != null){
				firstColumn.name = '';
				delete firstColumn.type;
			} else {
				columns[0] = _.union([{rowspan:columns.length,width:60,name:''}], columns[0]);
			}
		} else if(selectrows == 'no' && firstColumn.width != null){
			columns[0].splice(0, 1); 
		}
		data.columns = JSON.stringify(columns);
	}
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
 * 获取随机数
 * @param prefix 前缀
 */
function getRandomId(prefix){
	return prefix +"_"+ (90*Math.random()+10).toString().replace(".","");
}
