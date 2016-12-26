
/**
 * 更新页面元数据的行为方法体
 * @param pageModelIds 页面元数据modelId集合
 */
function updatePageActionMethodBody(pageModelIds){
	//页面元数据通过ftl模板生成成功，但是行为的methodBody为空，通过元数据生成jsp页面时，会使用
	//methodBody直接生成行为，下面做行为的读取和methodBody的操作
	var lstPageVO = readPageVOList(pageModelIds);
	
	var actionIds = getActionIdsByPageVO(lstPageVO);
	
    //获取所有的行为,用于页面行为中的实时更新
    var queryActions = getListAction(actionIds);
    //设置页面元数据的行为方法体
    setPageVOActionMethodBody(lstPageVO,queryActions);
    var iCount = updatePageVOList(lstPageVO);
    
    return iCount;
}

/**
 * 根据页面元数据集合获取页面中的行为ID集合
 * @param lstPageVO 页面元数据集合
 * @return actionIds 行为模板ID集合
 */
function getActionIdsByPageVO(lstPageVO){
	var actionIds = [];
	for(var i=0;i<lstPageVO.length;i++){
		for(var j=0;j<lstPageVO[i].pageActionVOList.length;j++){
			var pageActionVO = lstPageVO[i].pageActionVOList[j];
			actionIds.push(pageActionVO.methodTemplate);
		}
	}
	return actionIds;
}

/**
 * 根据modelId获取模板元数据对象集合
 * @param pageModelIds 页面元数据modelId集合
 */
function readPageVOList(pageModelIds){
	var lstPageVO;
	dwr.TOPEngine.setAsync(false);
    PageFacade.loadModelByModelId(pageModelIds,function(result){
    	lstPageVO = result;
    });
    dwr.TOPEngine.setAsync(true);
    return lstPageVO;
}

/**
 * 更新页面元数据
 * @param lstPageVO 页面元数据集合
 */
function updatePageVOList(lstPageVO){
	var iCount=0;
    //页面元数据更新
    dwr.TOPEngine.setAsync(false);
    PageFacade.savePage(lstPageVO, function(result) {
    	if (result) {
    		iCount = result;
    	}
    })
    dwr.TOPEngine.setAsync(true);
    return iCount;
}

/**
 * 根据行为ID获取行为对象
 * @param actionIds 行为ID
 */
function getListAction(actionIds){
	var queryActions={};
	dwr.TOPEngine.setAsync(false);
	ActionDefineFacade.loadModelByModelIds(actionIds,function(result){
		queryActions = new cap.CollectionUtil(result);  
	})
	dwr.TOPEngine.setAsync(true);
	return queryActions;
}

/**
 * 设置页面元数据的行为方法体
 * @param lstPageVO 页面元数据集合
 * @param queryActions 行为模板集合
 */
function setPageVOActionMethodBody(lstPageVO,queryActions){
	for(var j=0;j<lstPageVO.length;j++){
        for(var i=0;i<lstPageVO[j].pageActionVOList.length;i++){
        	var pageActionVO = lstPageVO[j].pageActionVOList[i];
        	var methodTemplate = pageActionVO.methodTemplate;
        	var objActionArr = queryActions.query("this.modelId=='"+methodTemplate+"'");
        	var script="";
        	//替换页面对象中的属性值
        	var pageMatchRule={regExp:/\${\w+}/g,startNum:2,endNum:1};
			script = replaceScriptTmpPlaceholders(objActionArr[0].script,lstPageVO[j],pageMatchRule);
			script = replaceScriptTmpPlaceholders(script,pageActionVO.methodOption,pageMatchRule);
        	//行为模板中有些属性默认值，可能在FTL模板中没有，将此属性及其默认值添加到页面行为方法属性中
        	setDefalutMethodOption(pageActionVO,objActionArr[0]);
        	//根据angularjs 的{{}}值写法，替换对应的属性值
        	var angularjsMatchRule={regExp:/\{{\w+\.?\w+}}/g,startNum:2,endNum:2};
			script = replaceScriptTmpPlaceholders(script,pageActionVO,angularjsMatchRule);
        	//替换script脚本属性值
        	var scriptMatchRule={regExp:/<script name=\"\w+\"\/>/g,startNum:14,endNum:3};
        	script = replaceScriptTmpPlaceholders(script,pageActionVO.methodBodyExtend,scriptMatchRule,true);
        	lstPageVO[j].pageActionVOList[i].methodBody = script;
        }
    }
}

/**
 * 根据行为模板中的默认属性值设置页面行为中的默认属性值
 * @param pageActionVO 页面元数据中的行为对象
 * @param actionVO 行为模板对象
 */
function setDefalutMethodOption(pageActionVO,actionVO){
	for(var i=0;i<actionVO.properties.length;i++){
		var actionAttrName = actionVO.properties[i].ename;
		var isFlag = false;//页面行为模板不存在的属性标志
		for(var attr in pageActionVO.methodOption){
			if(attr === actionAttrName){
				isFlag = true;
				break;
			}
		}
		if(!isFlag){
			var actionAttrValue = actionVO.properties[i].defaultValue;
			eval("pageActionVO.methodOption."+actionAttrName+"=actionAttrValue");
		}
	}
}


/**
 * 替换script模版常量占位符
 * @param script js函数模版
 * @param object 行为模板依赖的对象数据
 * @param matchRule 替换的规则对象，{regExp:"匹配的正则表达式"，startNum:"匹配后的字符串前面的截取长度",endNum:"匹配后的字符串后面的截取长度"}
 * @param setNullFlag 正则截取出的字符，如果在对象中找不到，是否设置为空（空用""标示）
 */
function replaceScriptTmpPlaceholders(script,object,matchRule,setNullFlag){
	if(script!=null){
		var constantPlaceholders = script.match(matchRule.regExp);
		for(var i in constantPlaceholders){
			//去除'${'和'}'
			var name = constantPlaceholders[i].substring(matchRule.startNum, constantPlaceholders[i].length-matchRule.endNum);
			if(eval("object."+name)!=null){
				script = script.replace(constantPlaceholders[i], eval("object."+name));
			}else if(setNullFlag){
				script = script.replace(constantPlaceholders[i], "");
			}
		}
	}
	return script;
}