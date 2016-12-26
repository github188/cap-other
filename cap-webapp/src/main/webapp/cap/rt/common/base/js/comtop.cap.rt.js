/**
 * CAP生产代码公共JS
 * Created by 郑重 on 2015-05-29.
 */

//cap命名空间
var cap = cap?cap:{};
var webRoot = webPath;
cap.sessionAttribute={};
cap.dwrAction={};

/**
 * 通过变量名称从session中获取缓存的值
 * @param keys 变量名称
 * @return 从session中获取的值
 */
cap.getSessionAttributes = function(keys){
	var result = null;
	dwr.TOPEngine.setAsync(false);
	CapSessionAttributeUtil.sessionAttributeToJson(keys, function(datas){
		result = datas;
	});
	dwr.TOPEngine.setAsync(true);
	return result;
};

/**
 * 通过attrName从cap.sessionAttribute中获取值
 * @param attrName 属性名称
 * @param isArray attrName是否为数组
 * @return 返回获取的值
 */
cap.getSessionAttribute = function(attrName, isArray){
	if(cap.sessionAttribute && cap.sessionAttribute != null){
		return cap.sessionAttribute[attrName] ? cap.sessionAttribute[attrName] : isArray ? [] : {};
	}
};

/**
 * 把变量attr缓存到session中
 * @param attr 需要缓存到session中的变量
 */
cap.setSessionAttribute=function(attr){
	if(cap.dwrAction && cap.dwrAction !=null && cap.dwrAction.setAttributeToSession){
		dwr.TOPEngine.setAsync(false);
		try{
			var sessionAttr = {};
			for(var name in attr){
				sessionAttr[name] = cui.utils.stringifyJSON(attr[name]);
			}
			cap.dwrAction.setAttributeToSession(sessionAttr,function(result){
				if(result === true){
					for(var name in attr){
						cap.sessionAttribute[name]=attr[name];
					}
				}
			});
		}catch(e){
			console.log('failed to put attribute to session because:', e);
		}
		dwr.TOPEngine.setAsync(true);
	}
};

/**
 * 把gird的查询对象信息赋值给session中的对象，以便能保存到session中。
 * @param source Gird的query对象 （主要是pageNo\pageSize\sortname\sorttype）
 * @param target session中缓存的查询对象
 */
cap.cacheGridAttributes = function(source, target){
	target.pageSize = source.pageSize;
	target.pageNo = source.pageNo;
	target.sortNames = source.sortName;
	target.sortTypes = source.sortType;
	return target;
};


/*------------------------------------EditGrid公共代码--------------------------------------------------------*/

/**
 * 因为edit列渲染不支持命名空间写法
 * @param rd
 * @param index
 * @param col
 * @returns {String}
 */
function renderEditGridDeleteOperator(rd, index, col) {
	var gridId=this.el.attr("id");
	return '<a title="删除" style="cursor:pointer;text-decoration: none;" onclick="cap.deleteRowByIcon(\''+gridId+'\',this)"><span class="cui-icon" style="font-size:12pt;color:rgb(255, 68, 0)">&#xf00d;</span></a>';
}

/**
 * 渲染编辑表格删除按钮列
 */
cap.renderEditGridDeleteOperator=function(rd, index, col) {
	var gridId=this.el.attr("id");
	return '<a title="删除" style="cursor:pointer;text-decoration: none;" onclick="cap.deleteRowByIcon(\''+gridId+'\',this)"><span class="cui-icon" style="font-size:12pt;color:rgb(255, 68, 0)">&#xf00d;</span></a>';
}

/**
 * 编辑表格列头新增行图标
 */
cap.insertRowByIcon=function(gridId){
	cui("#"+gridId).insertRow({});
}
	
/**
 * 编辑表格新增行按钮
 */
cap.insertRowByButton=function(event, self, mark){
	cui("#"+mark).insertRow({});
}

/**
 * 编辑表格删除行图标
 */
cap.deleteRowByIcon=function(gridId,self){
	var index = $(self).closest("tr").get(0).rowIndex;
	cui("#"+gridId).deleteRowByIndex(index-1);
}
	
/**
 * 删除选中行按钮
 */
cap.deleteSelectRowByButton=function(event, self, mark){
	cui("#"+mark).deleteSelectRow();
}

/**
 * 编辑Grid数据加载
 * @param obj {Object} Grid组件对象
 * @param query {Object} 查询条件
 */
cap.editGridDatasource=function(obj, query) {
	if(eval(obj.options.databind+"!=null")){
		 setTimeout(function () {
			 eval('obj.setDatasource('+obj.options.databind+','+obj.options.databind+'.length);');
         },0);
	}else{
		obj.setDatasource([],0);
	}
}

/*---------------------------------EditGrid公共代码--------------------------------------*/


/*---------------------------------Grid公共代码--------------------------------------*/
/**
 * 表格自适应宽度
 */
function getBodyWidth () {
    return parseInt(jQuery("#pageRoot").css("width"))- 20;
}

/**
 * 表格自适应高度
 */
function getBodyHeight () {
	var _hei = parseInt(jQuery("#pageRoot").css("height"))- 20;
    return _hei > 200 ? _hei : 200;
}

/**
 * 重写Date的toJSON方法，Date类型转换成毫秒数的字符串
 * cui工具中的cui.utils.stringifyJSON方法转换Date类型属性的时候调用的就是Date的toJSON方法。
 */
Date.prototype.toJSON = function(){
    return this.getTime() + "";  
};

/*---------------------------------CAP dwr处理 start--------------------------------------*/

/**
 * getDwrInvokeParam
 */
cap.getDwrInvokeParam = function(){
	if(arguments.length < 2 ){
		throw new Error("the arguments length less than 2 of the function names 'getDwrInvokeParam'.");
	}
	
	if(typeof arguments[0] != 'string' || typeof arguments[1] != 'string'){
		throw new Error("the first argument or the second argument is a string of the function names 'getDwrInvokeParam'.");
	}
	
	if(arguments.length >= 3 && !(Object.prototype.toString.call(arguments[2]) === '[object Array]')){
		throw new Error("the third argument is not an array of the function names 'getDwrInvokeParam'.");
	}
	
	
	var entityId = arguments[0];
	var entityMethodName = arguments[1];
	
	if(entityId == null || entityId === '' || entityMethodName == null || entityMethodName === ''){
		throw new Error("the first argument or the second argument is null or '' of the function names 'getDwrInvokeParam'.");
	}
	
	
	//分割实体id，拿到实体名称
	var entityName = entityId.split(".")[entityId.split(".").length-1];
	//把实体名称首字母转换成小写
	entityName = entityName.charAt(0).toLowerCase() + entityName.substring(1);
	
	
	var param = {};
	//设置soa服务Id
	param.soaServiceId = entityName + "Facade" + "." + entityMethodName;
	param.facadeSeviceFullName = entityId.replace(/.entity./,'.facade.')+'Facade';	
	param.paramJosn = [];
	
	if(arguments.length >= 3){
		for(var i = 0; i < arguments[2].length; i++){
			var strParam = cui.utils.stringifyJSON(eval(arguments[2][i]));
			param.paramJosn.push(strParam.replace(/{}/g,null));//js中的空对象转换为null
		}
	}
	
	return param;
} 


/**
 * 异常信息回调函数
 */
cap.errorCallback = function(msg, exception) {
	if(console){
		console.log("当前请求存在异常信息:"+msg);
	}
	return;
}

/**
 * 后台请求异常信息处理
 */
cap.errorHandler = function(fn) {

	if (!dwr || !dwr.TOPEngine || !dwr.TOPEngine.setErrorHandler)
		return;
	//异常信息函数回调
	var errorCallback = cap.errorCallback;

	if (fn && typeof(fn) == "function") {
		errorCallback = fn;
	}

	dwr.TOPEngine.setErrorHandler(errorCallback);
}

/**
 * 可自定义设置回调函数
 */
cap.setErrorCallback = function(fn) {
	dwr.TOPEngine.setErrorHandler(fn);
}

/*---------------------------------CAP dwr处理 end--------------------------------------*/

/**
 * 获取表单查询条件
 */
cap.getQueryObject=function(query,pageQuery){
	cap.beforeSave();
	var query = jQuery.extend(true,{},query,pageQuery);
	if(query.sortName){
		query.sortFieldName = query.sortName[0];
	}
	if(query.sortType){
		query.sortType = query.sortType[0];
	}
	return query;
}

/*---------------------------------Grid公共代码--------------------------------------*/


/*---------------------------------页面公共代码--------------------------------------*/
/**
 * 页面UI扫描之前初始化回调管理器
 */
cap.beforePageInit = $.Callbacks();

//menu
cap.beforePageInit.add(function(){
	$.each($("[uitype='Menu']"),function(index,menuitem){
		var menuId = menuitem.id;
		var label = uiConfig[menuId].label;
		menuitem.innerHTML = '<a class="u-menu" >'+label+'</a></span>';
	});
});

/**
 * 判断window上是否有相应的函数，如果有，则执行它
 * @param funName 函数的名称
 */
cap.executeFunction = function(funName){
	if(window[funName] && typeof(window[funName]) == "function"){
		window[funName]();
	}
};

/**
 * 通过分隔符标识取得数组最后一条数据
 */
cap.getStringLastValue = function(value, sign) {
	if (value && value.split(sign)) {
		var length = value.split(sign).length;
		return value.split(sign)[length - 1];
	}
	return "";
}

/**
 * 转换为树形参数结构
 */
cap.getTreeInvokeParam = function(entityId, data, mapping) {
	var param = {};

	if (entityId) {
		var entityVO = entityId.replace(/.entity./, '.model.') + 'VO';
		param["entityVO"] = entityVO;
	} else {
		throw new Error("entityId can not be null");
	}
	if (data && !data.length) {
		throw new Error("the tree data Source is not Array !");
	}

	if (data && mapping) {
		param["treeData"] = data;
		param["treeParam"] = mapping;
	} else {
		throw new Error("the tree data or mapping can not be null");
	}

	return param;
}

/**
 * 递归查找子节点去除最末节点的懒加载,转换为正确的树形结构数据
 * 
 * @param  后台返回的树形结构子节点数据
 * @author xuchang
 */
cap.lookupTreeChild = function(childrens) {
	if (childrens) {
		for (var i = 0; i < childrens.length; i++) {
			var data = childrens[i];
			if (data.children) {
				cap.lookupTreeChild(data.children);
			} else {
				data.isLazy = false;
			}
		}
	}
}

/**
 * @Deprecated
 */
cap.initAfterLoad = function(){
	//空实现。为了兼容已生成的页面。过段时间会去掉。
}

/**
 *	页面加载初始化
 */
cap.pageInit=function(){
	cap.beforeLoad();
	cap.initDataBind();
	cap.initValidate();
	cap.initAtmObject();
	cap.initAutoGenNumber();	
	//审批页面初始化函数
	cap.executeFunction("loadApprovePage");
	//附件页面
	cap.executeFunction("loadAttach");
}

/**
 *	页面加载初始化附件
 */
cap.initAtmObject=function(){
	 for(var item in uiConfig){
		 if(uiConfig[item].uitype =='AtmSep'){
			 try{
				var varName = 'atm_'+item;
				window[varName] = new Attachment();
				for ( var attr in uiConfig[item]) {
					if(cap.isUndefinedOrNullOrBlank(uiConfig[item].webRoot)){
						uiConfig[item].webRoot = webPath;
					}
					if(attr == 'uitype' || attr == 'atmAttr' || attr == 'objectIdList_id'){
						continue;
					}
					if(attr == 'objId'){
						if(uiConfig[item][attr].substring(0,1) == "$"){
							var expression = uiConfig[item][attr].substring(1,uiConfig[item][attr].length);
							window[varName].objId = eval(expression);
						}else{
							window[varName].objId = uiConfig[item][attr];
						}
						continue;
					}
					if(attr == 'objectIdList' && uiConfig[item][attr] instanceof Function){
						window[varName].objectIdList = uiConfig[item][attr]();
						continue;
					}
					var methodName = 'set'+attr.charAt(0).toUpperCase () + attr.substring(1);
					eval("window['"+varName+"']."+methodName+"('"+uiConfig[item][attr]+"');")
				}
				window[varName].creatorId=globalUserId;
				window[varName].creatorName=globalUserName;
				window[varName].init(item);
			} catch(e) {
				var divName = '#'+item;
				if(1==uiConfig[item].operateMode || 3==uiConfig[item].operateMode) {
					var html = "<table width='100%'><tr><td align='center' style='color:red;font-size:15px'>附件管理暂时不能提供服务，请联系附件管理维护人员。</td></tr></table>";
					jQuery(divName).html(html);
				}else if(2==uiConfig[item].operateMode) {
					if(1==uiConfig[item].displayMode) {
						jQuery(divName).html("<input type='button' class='btn_href' value='附件管理' onclick='javascript:alert(\"附件管理暂时不能提供服务，请联系附件管理维护人员。\");'>");
					}else if(2==uiConfig[item].displayMode) {
						jQuery(divName).html("<a onclick='javascript:alert(\"附件管理暂时不能提供服务，请联系附件管理维护人员。\");' style='font-size:15px'>附件管理</a>");
					}
				}
			}
		 }
	}
}


/**
 * 渲染自动编码控件
 */
cap.initAutoGenNumber=function(){
	 for(var item in uiConfig){
		 if(uiConfig[item].uitype =='AutoGenNumber'){
			 //var flag = false;
			 var params={};
			 if(!cui("#"+item).getValue()){
				 if(uiConfig[item]["params"]){
					 var paramKey = '';
					 if(uiConfig[item]["params"].indexOf(".") != -1){
						 paramKey = uiConfig[item]["params"].split(".")[1];
					 }else{
						 paramKey = uiConfig[item]["params"];
					 }
					 var paramVal = eval(uiConfig[item]["params"]);
					 params[paramKey]=encodeURI(paramVal);
				 }
				 if(!primaryValue){
					 if(uiConfig[item]["showOnNew"] == true){
						 //flag = true;
						 cui("#"+item).setAutoGenNumValue(JSON.stringify(params));
					 }
				 }else{
					 //flag = true;
					 cui("#"+item).setAutoGenNumValue(JSON.stringify(params));
				 }
				 /*for (var attr in uiConfig[item]) {
					 if(!primaryValue){
						 if(attr == 'showOnNew' && uiConfig[item][attr] == true){
							 flag = true;
						 }
					 }else{
						 flag = true;
					 }
					 if(attr == 'params'){
						var paramKey = uiConfig[item][attr].split(".")[1];
						var paramVal = eval(uiConfig[item][attr]);
						if(paramVal){
							params[paramKey]=encodeURI(paramVal);
						}
						continue;
					 }
				 }
				 if(flag){
					 cui("#"+item).setAutoGenNumValue(JSON.stringify(params));
				 }*/
			 }else{
				 break;
			 }
		 }
	}
}

cap.getforwardURL=function(url){
	if(url){
		return url;
	}
	return '';
}
 
/**
 * 通过uiConfig databind属性设置数据绑定
 */
cap.initDataBind=function(){
     for(var item in uiConfig){
         if(uiConfig[item].databind){
        	 var arr=uiConfig[item].databind.split(".");
        	 var bindObject = {};
        	 var bindName = null;
        	 if(arr.length > 1){
        		 bindObject = cap.getBindObject(arr);
        		 bindName = arr[arr.length-1];
        	 }else{
        		 bindObject[bindName] = window[arr[0]];
        		 bindName = arr[0];
        	 }
             cui(bindObject).databind().addBind('#'+item, bindName);
         }
     }
 }

/**
 * 获取控件的databind的对象
 */
cap.getBindObject = function(arr){
	var _bindObject = window;
	for(var i = 0; i < arr.length-1; i++){
		_bindObject[arr[i]] = _bindObject[arr[i]] ? _bindObject[arr[i]] : {};
		_bindObject = _bindObject[arr[i]];
	}
	return _bindObject;
}


/**
 * 保存之前处理控件数据绑定
 */
cap.beforeSave=function(){
	for(var item in uiConfig){
		eval("if(cap.beforeSave"+uiConfig[item].uitype+"){cap.beforeSave"+uiConfig[item].uitype+"(item);}");
    }
	//重新设置自动编码值
	 for(var item in uiConfig){
		 if(uiConfig[item].uitype =='AutoGenNumber'){
			 if(!cui("#"+item).getValue()){
				 var params={};
				 for (var attr in uiConfig[item]) {
					 if(attr == 'params'){
						var paramKey = uiConfig[item][attr].split(".")[1];
						var paramVal = eval(uiConfig[item][attr]);
						if(paramVal){
							params[paramKey]=encodeURI(paramVal);
						}
						continue;
					 }
				 }
				cui("#"+item).setAutoGenNumValue(JSON.stringify(params));
			 }
		 }
	}
}

/**
 * 保存前处理人员选择控件
 */
cap.beforeSaveChooseUser=function(item){
	var chooseUsers = eval(uiConfig[item].databind);
	clearAttr(item, "null");
	if(chooseUsers != null && chooseUsers.length > 0){
		clearAttr(item, "''");
		for(var i = 0; i < chooseUsers.length; i++){
			var chooseUser = chooseUsers[i];
			if(i == chooseUsers.length - 1){
				eval(uiConfig[item].idName+"="+uiConfig[item].idName+"+"+"chooseUser['id']");
	   			eval(uiConfig[item].valueName+"="+uiConfig[item].valueName+"+"+"chooseUser['name']");
	   			if(uiConfig[item].opts){
	   			eval(eval('(' +uiConfig[item].opts+ ')').codeName+"="+eval('(' +uiConfig[item].opts+ ')').codeName+"+"+"chooseUser['orgCode']");
	   			}
			}else{
				eval(uiConfig[item].idName+"="+uiConfig[item].idName+"+"+"chooseUser['id']"+"+';'");
	   			eval(uiConfig[item].valueName+"="+uiConfig[item].valueName+"+"+"chooseUser['name']"+"+';'");
	   			if(uiConfig[item].opts){
	   			eval(eval('(' +uiConfig[item].opts+ ')').codeName+"="+eval('(' +uiConfig[item].opts+ ')').codeName+"+"+"chooseUser['orgCode']"+"+';'");
	   			}
			}
   		}	
	}
	
	function clearAttr(item, value){
		eval(uiConfig[item].idName + "=" + value);
		eval(uiConfig[item].valueName + "=" + value);
		if(uiConfig[item].opts){
			eval(eval('(' + uiConfig[item].opts + ')').codeName + "=" + value);
		}
	} 
}

/**
 * 保存前处理人员选择控件
 */
cap.beforeSaveChooseOrg=function(item){
	cap.beforeSaveChooseUser(item);
}
	
/**
 * 保存前处理表格编辑控件
 */
cap.beforeSaveEditableGrid=function(item){
	if(cui("#"+item).getData){
		eval(uiConfig[item].databind+"="+'cui("#'+item+'").getData()');
	}
}

/**
 * 页面初始化前处理特殊控件绑定
 */
cap.beforeLoad=function(){
	for(var item in uiConfig){
		 eval("if(cap.beforeLoad"+uiConfig[item].uitype+"!=undefined){cap.beforeLoad"+uiConfig[item].uitype+"(item,uiConfig[item]);}");	
    }
}

/**
 * 数据加载时候处理人员选择控件
 */
cap.beforeLoadChooseUser=function(item){
		var chooseUsers=[];
		var idNames=eval(uiConfig[item].idName);
		var valueNames=eval(uiConfig[item].valueName);
		if(uiConfig[item].opts){
			var codeNames = eval(eval('(' +uiConfig[item].opts+ ')').codeName);
		}
		if(idNames != null){
			var ids=idNames.split(";");
			var names=valueNames.split(";");
			if(uiConfig[item].opts){
				var strCodes = codeNames.split(";");
			}
			for(var i=0;i<ids.length;i++){
				if(uiConfig[item].opts){
				   chooseUsers[i]={id:ids[i],name:names[i],orgCode:strCodes[i]};
				}else{
				   chooseUsers[i]={id:ids[i],name:names[i]};
				}
			}
			eval(uiConfig[item].databind+"="+"chooseUsers");
		}
}

/**
 * 数据加载时候处理部门选择控件
 */
cap.beforeLoadChooseOrg=function(item){
	cap.beforeLoadChooseUser(item);
}
	
/**
 * 数据加载时候处理表格编辑控件
 */
cap.beforeLoadEditableGrid=function(item){

	if(cui("#"+item).getData().length == 0){
		//应用场景：编辑页面时editableGrid加载的数据源是在pageInitLoadData方法里加载的。add by yangsai 2016年7月8日12:49:00
		cui("#"+item).loadData();
	}
	if(typeof pageMode === "string"){
		if(pageMode==="textmode"){
			cui("#"+item).setReadonly(true)
		}
	}
}

/**
 * 数据加载时候处理表格编辑控件
 */
cap.beforeLoadTab=function(itemid,item){
	if(item.height){
		cui("#"+itemid).resize(item.height);
	}else{
		cui("#"+itemid).resize(jQuery(window).height()-10);	
	}
}
	
/**
 * 校验表单并弹出校验错误信息
 */
cap.validateForm=function(){
	var result=true;
	var validOjb=cap.validater.validAllElement();
    var validateResult=validOjb[2];
    var validateMessage=validOjb[0];
    var str="";
    var validateEditGridResult=cap.validateEditGrid();
    if(!validateResult || !validateEditGridResult.flag){
        for(var i=0;i<validateMessage.length;i++){
            str=str+validateMessage[i].message+"<br/>";
        }
        result=false;
        cui.error("请修正表单错误再进行操作：<br/>"+str+validateEditGridResult.message);
    }
    return result;
}

/**
 * 校验页面上的编辑表格控件
 */
cap.validateEditGrid=function(){
 	var result=true;
 	var result={flag:true,message:''};
 	var message="";
 	for(var item in uiConfig){
       if(uiConfig[item].uitype=="EditableGrid"){
       	if(!cui("#"+item).getValidateResult()[2]){
       		result.flag=false;
       		var validateMessage=cui("#"+item).getValidateResult()[0];
			for(var i=0;i<validateMessage.length;i++){
				message=message+validateMessage[i].message+"<br/>";
			}
       		result.message=message;
       		break;
       	}
       }
   }
   return result;
}
	
/**
 * 根据模型生成校验对象
 */
cap.validater = cui().validate();
cap.initValidate=function(){
    for(var item in uiConfig){
        if(uiConfig[item].validate){
            for(var validateNode in uiConfig[item].validate){
                var vl=uiConfig[item].validate[validateNode];
                cap.validater.add(item, vl.type, vl.rule);
            }
        }
    }
}

/**
 * 构建URL
 */
cap.buildURL=function(url,data){
   var result="";
   for(var name in data){
	   //判断传进来的url中是否已存在此参数
	   var index = url.indexOf(name+"=");
	   //如果存在，则进行如下处理
	   if(index != -1){
		   //判断此参数后面是否还跟有参数
		   var joinIndex = url.indexOf("&",index); 
		   //截取url的前半部分
		   var front = url.substring(0,index);
		   //如果后面还有参数，则下面的url的拼接需要拼接后面的参数部分
		   if(joinIndex != -1){
			   //截取拿到后面的参数字符串
			   var tail = url.substring(joinIndex);
			   //利用字符串的拼接，把此参数的值替换成传来的新值
			   url = front + name + "=" + data[name] + tail;
		   }else{ //此参数后面不再有参数的处理
			   url = front + name + "=" + data[name];
		   }
	   }else{ //如果不存在，则组装参数字符串
		   result=result+"&"+name+"="+data[name];
	   }
   }
   
   if(url.indexOf("&")==url.length-1 || url.indexOf("?")==-1 || url.indexOf("?")==url.length-1){
	   result=result.substring(1);
   }
   
   if(url.indexOf("?") ==-1){
	   result="?"+result;
   }
   
   return url+result;
}

/**
 * 根据页面参数生成URL字符串
 */
cap.getPageAttrString=function(){
   var result="";
   for(var i in arguments){
	   result=result+"&"+arguments[i]+"="+eval(arguments[i]);
   }
   if(result !=""){
	   result="?"+result.substring(1)
   }
   return result;
}

/**
 * 根据页面参数生成URL字符串
 */
cap.buildPageAttrString=function(pageAttributeVOList){
	var result="";
	for(var i=0;i<pageAttributeVOList.length;i++){
		if(pageAttributeVOList[i].attributeName!=null && pageAttributeVOList[i].attributeName!=""){
			if(pageAttributeVOList[i].attributeValue!=null && pageAttributeVOList[i].attributeValue!=""){
				if(pageAttributeVOList[i].attributeValue.indexOf("@{")!=-1){
					var attributeValue=pageAttributeVOList[i].attributeValue;
					attributeValue=attributeValue.replace("@{","");
					attributeValue=attributeValue.replace("}","");
					result+="&"+pageAttributeVOList[i].attributeName+"="+eval(attributeValue);
				}else{
					result+="&"+pageAttributeVOList[i].attributeName+"="+pageAttributeVOList[i].attributeValue;
				}
			}
		}
	}
	if(result !=""){
		result="?"+result.substring(1)
	}
	return result;
}

/**
 * 页面跳转
 */
cap.pageJump=function(url,target,pageObject){
	//新窗口打开模式
	if(target=="win"){
		var targetWin =  window.open(url,"_blank");
		targetWin.focus();
	}else if(pageObject!=null){
		//跳转到指定location
		pageObject.location=url;
	}else{
		//当前窗口打开模式
 		window.location=url;
 	}
}

/**
 * 页面刷新
 */
cap.pageRefresh=function(refreshTarget,customPage){
	var refreshObj = null;
	if(refreshTarget == "custom"){
		refreshObj = customPage;
	}else if(refreshTarget=="parent"){
		//刷新父页面
		refreshObj = window.parent;
	}else if(refreshTarget=="opener"){
		//刷新父窗口
		refreshObj = window.opener;
	}else{
		//刷新当前页面
		refreshObj = window;
 	}
	if(refreshObj && refreshObj.location){
		refreshObj.location.reload();
	}else{
		alert('请设置正确的刷新页面。');
	}
}

/**
 * 获得数据字典数据值。需要jquery ajax支持。
 * @param {} key 数据字典项全编码
 * @return {} 数据字典数据集合[{}],要求数据字典按必须有id,value,text三个属性，id与value的值相同。
 */
cap.getDicData=function(key){
	if(!key){
		return [];
	}
	var webRoot = (webPath||$('#cuiExtendDictionary').attr('webRoot')||'/web') + '/top/cfg/getAllValue.ac';
	var retData =null;
	$.ajax({
        url: webRoot,
        data: "&fullcode=" + key,
        dataType: "json",
        async: false,
        success: function(result){
        	retData=result;
        },
        error:function(){
        	console.log("获取"+key+"数据字典数据失败。");
        }
    });
	return !retData ? [] : retData;
}

/**
 * 获得数据字典数据值。需要jquery ajax支持。
 * @param {} key 数据字典项全编码集合，‘;’分隔
 * @return {} 数据字典数据集合[{}],要求数据字典按必须有id,value,text三个属性，id与value的值相同。
 */
cap.getDicDataSet=function(keys){
	if(!keys){
		return [];
	}
	var webRoot = (webPath||$('#cuiExtendDictionary').attr('webRoot')||'/web') + '/top/cfg/getDicDataSet.ac';
	var retData =null;
	$.ajax({
        url: webRoot,
        data: "&fullcode=" + keys,
        dataType:"json",
        async: false,
        success: function(result){
        	retData=result;
        },
        error:function(){
        	console.log("获取"+keys+"数据字典数据失败。");
        }
    });
	return !retData ? [] : retData;
}

/**
 * 获得数据字典类数据值对应的文本
 * @param {} dicDataSet 数据字典数据集[{id:xx,value:xx,text:xx},{id:xx,value:xx,text:xx}]
 * @param {} curValue 当前值集合。值之间用';'分隔
 */
cap.getTextOfDicValue=function(dicDataSet,curValue){
	if(curValue == undefined || curValue==null){
		return "";
	}
	if(!dicDataSet){
		return curValue;
	}
	var valueList = [curValue];
	if(typeof(curValue)==="string" && curValue.indexOf(";")>0){
		valueList = curValue.split(";");
	}
	var text = "";
	for(var i = 0; i < valueList.length; i++ ){
		var v = valueList[i];
		for(var t in dicDataSet){
			if(dicDataSet[t].id == v || dicDataSet[t].value == v){
				if(i>0 && text){
					text += ";";
				}
				text += dicDataSet[t].text;
				break;
			}
		}
	}
	if(!text && curValue != null){
		text = curValue;
	}
	return text;
}

/**
 * 判断是否为以下值：undefined、null、'undefined'、'null'、''
 * @param val 被检查的数据
 * @return 检查是否通过
 */
cap.isUndefinedOrNullOrBlank=function(val){
	return typeof(val) == 'undefined' || val == null || val == 'undefined' || val == 'null' || val == '';
}

/*---------------------------------Grid相关操作，如上移、下移、置顶、置底--------------------------------------*/
	
//上移
cap.rowsUp=function(gridId){
	var grid=cui("#" + gridId);
	var indexs =  grid.getSelectedIndex();
	var index = indexs[0];
	if(index == 0){
		return;
	}
	for(var i=0;i<indexs.length;i++){
		var datas = grid.getData();
		var currentData   = datas[indexs[i]];
		var  frontData = datas[indexs[i]-1];
		var temp = currentData.sortNO;
		currentData.sortNO = frontData.sortNO;
		frontData.sortNO = temp;
		
		if(currentData.areaItemId && !frontData.areaItemId){
			frontData.areaItemId = currentData.areaItemId;
			frontData.areaId = currentData.areaId;
			delete currentData.areaItemId;
			delete currentData.areaId;
		}
		if(!currentData.areaItemId && frontData.areaItemId){
			currentData.areaItemId = frontData.areaItemId;
			currentData.areaId = frontData.areaId;
			delete frontData.areaItemId;
			delete frontData.areaId;
		}
		
		grid.changeData(currentData, indexs[i] - 1,true,true);
		grid.changeData(frontData,indexs[i],true,true);
		grid.selectRowsByIndex(indexs[i] -1, true);
		grid.selectRowsByIndex(indexs[i], false);
	}
}
	
//下移
cap.rowsdown=function(gridId){
	var grid=cui("#" + gridId);
	var indexs =  grid.getSelectedIndex();
	var index = indexs[indexs.length-1];
	var datas = grid.getData();
	if(index === datas.length - 1){
		return;
	}
	for(var i=indexs.length-1;i>=0;i--){
		var datas =grid.getData();
		var currentData = datas[indexs[i]];
		var nextData = datas[indexs[i] + 1];
		
		var temp = currentData.sortNO;
		currentData.sortNO = nextData.sortNO;
		nextData.sortNO = temp;
		
		if(currentData.areaItemId && !nextData.areaItemId){
			nextData.areaItemId = currentData.areaItemId;
			nextData.areaId = currentData.areaId;
			delete currentData.areaItemId;
			delete currentData.areaId;
		}
		
		if(!currentData.areaItemId && nextData.areaItemId){
			currentData.areaItemId = nextData.areaItemId;
			currentData.areaId = nextData.areaId;
			delete nextData.areaItemId;
			delete nextData.areaId;
		}
		
		grid.changeData(currentData, indexs[i] + 1,true,true);
		grid.changeData(nextData, indexs[i],true,true);
		grid.selectRowsByIndex(indexs[i], false);
		grid.selectRowsByIndex(indexs[i] + 1, true);
	}
}
	
//置顶
cap.rowsToFisrt=function(gridId){
	var grid=cui("#" + gridId);
	var indexs =  grid.getSelectedIndex();
	var datas = grid.getData();
	var firstSortNo = datas[0].sortNO;
	var largeIndex = indexs[indexs.length-1];
	for(var i=indexs.length-1;i>=0;i--){
		firstSortNo--;
		var datas = grid.getData();
		var currentData = datas[largeIndex];
		currentData.sortNO = firstSortNo;
		
		if(currentData.areaItemId){
			delete currentData.areaItemId;
			delete currentData.areaId;
		}
		//咨询CUI，没提供move方法，先采用先删后增
		grid.deleteRowByIndex(largeIndex);
		grid.insertRow(currentData,0);
		grid.selectRowsByIndex(0, true);
	}
}
	
//置底
cap.rowsToLast=function(gridId){
	var grid=cui("#" + gridId);
	var indexs =  grid.getSelectedIndex();
	var datas = grid.getData();
	var lastSortNo = datas[datas.length-1].sortNO;
	var minIndex = indexs[0];
	for(var i=0;i<indexs.length;i++){
		lastSortNo++;
		var datas = grid.getData();
		var currentData = datas[minIndex];
		currentData.sortNO = lastSortNo;
		
		if(currentData.areaItemId){
			delete currentData.areaItemId;
			delete currentData.areaId;
		}
		//咨询CUI，没提供move方法，先采用先删后增
		grid.deleteRowByIndex(minIndex);
		grid.insertRow(currentData,datas.length-1);
		grid.selectRowsByIndex(datas.length-1, true);
	}
}

/**
 * 获得编辑grid人员组织控件初始化数据
 * @param {} ids 人员或组织的id集
 * @param {} names 人员或组织的名称
 * @param {} codeNames 人员或组织的编码
 * @return {}人员或组织对象数组，格式为[{id:xx,name:xx,codeName:xx}]
 */
cap.initUserOrgChoose=function(ids,names,codeNames){
	if(!ids){
		return [];
	}
	var idarray =ids.split(";");
	var namearray =names.split(";");
	var ret=[];
	for(var i=0;i<idarray.length;i++){
		if(codeNames[i]){
		    ret.push({id:idarray[i],name:namearray[i],codeName:codeNames[i]});
		}else{
			ret.push({id:idarray[i],name:namearray[i]});	
		}
	}
	return ret;
}

/**
 * 获得编辑grid人员组织控件选择数据后的字符串值
 * @param {} objArray 人员或组织的对象数据集[{}]
 * @return {}人员或组织对象字符串，格式为{value:xx,text:xx,codeName:xx}，xx中以';'分隔多个字符串
 */
cap.createUserOrgChooseStringTextValue=function(objArray){
	if(!objArray){
		return {value:"",text:"",codeName:""};
	}
	var text = [];
	var vals = [];
	var codeNames = [];
	for(var i = 0, len = objArray.length; i < len; i ++){
		text.push(objArray[i].name);
		vals.push(objArray[i].id);
		codeNames.push(objArray[i].orgCode);
	}
	var ret = {
		//值
		value: vals.join(';'),
		//显示文字
		text: text.join(';'),
		//部门编码
		codeName: codeNames.join(';')
	}
	return ret;
}

//页面使用的数据字典数据
cap.dicDatas=[];
cap._dicDataMapByCode={};
cap._dicDataMapByAttr={};

//根据数据字典code返回数据字典集合
cap.getDicByCode=function(code){
	var result=[];
	if(cap._dicDataMapByCode[code]!=null){
		result=cap._dicDataMapByCode[code];
	}else{
		for(var i=0;i<cap.dicDatas.length;i++){
			var obj=cap.dicDatas[i];
			if(code==obj.code){
				result=obj.list;
				cap._dicDataMapByCode[code]=obj.list;
				break;
			}
		}
	}
	return result;
}

//根据实体属性名称返回数据字典集合
cap.getDicByAttr=function(attr){
	var result=[];
	if(cap._dicDataMapByAttr[attr]!=null){
		result=cap._dicDataMapByAttr[attr];
	}else{
		for(var i=0;i<cap.dicDatas.length;i++){
			var obj=cap.dicDatas[i];
			for(var j=0;j<obj.attrs.length;j++){
				if(attr==obj.attrs[j]){
					result=obj.list;
					cap._dicDataMapByAttr[obj.attrs[j]]=obj.list;
					break;
				}
			}
			if(result.length>0){
				break;
			}
		}
	}
	return result;
}

//设置控件状态
cap.setUIState=function(id,state){
	var stateOperate = function(id,operateType){
		var _cuiObj = cui('#'+id);
		var _prototyObj = _cuiObj.constructor.prototype;
		if(_prototyObj.options && _prototyObj.options.uitype == "Calender"){
			eval("var temp=_prototyObj."+operateType+";delete _prototyObj."+operateType+";_cuiObj."+operateType+"();_prototyObj."+operateType+"=temp;");
		}else{
			eval("_cuiObj." + operateType + "()");
		}
	};
	
	try{
		if(cui('#'+id).isCUI){
			if(state=="readOnly"){
				cui('#'+id).setReadonly(true);
				stateOperate.call(null,id,"show");
			}else if(state=="hide"){
				stateOperate.call(null,id,"hide");
			}else if(state=="edit"){
				cui('#'+id).setReadonly(false);
				stateOperate.call(null,id,"show");
			}
		}else{
			if(state=="hide"){				
				$("#"+id).hide()
			}else{
				$("#"+id).show();
			}
		}
	}catch(e){}
}

/**
 * 是否取消某元素验证
 */
cap.disValid=function(id, disable){
	if(cui("#"+id).isCUI){
		cap.validater.disValid(id, disable);
	} else {
		var spanDom = $("#"+id).find("span[uitype],div[uitype]");
		for(var i=0,len=spanDom.length; i<len; i++){
			if(cui("#"+spanDom[i].id).isCUI){
				cap.validater.disValid(spanDom[i].id, disable);
			}
		}
	}
}

/*---------------------------------页面公共代码--------------------------------------*/

/*---------------------------------（editableGrid-》edittype）第三方编辑器--------------------------------------*/
//人员和组织控件公共的注册方式
cap.userOrgCommonRegistrationForm = function(uitype){
	return {
		create: function (box, rowData, options) {
			var idNames = "";
			var valueNames = "";
			if(options != null){
				idNames = options.idName != null && options.idName != '' ? rowData[options.idName] : idNames;
				valueNames = options.valueNames != null && options.valueNames != '' ? rowData[options.valueNames] : valueNames;
			}
			var codeNames = "";
			if(options != null&&options.opts){
				 codeNames = eval('(' +options.opts+ ')').codeName!=null&&eval('(' +options.opts+ ')').codeName!=''?rowData[eval('(' +options.opts+ ')').codeName]: codeNames;
			}
			//处理控件溢出问题
			var defaultWidth = "200px";
			if(options.width == null){
				defaultWidth = $(box).parent().width() - 40 + "px";
			}
		    cui(box)[uitype]($.extend({}, {
		        width:defaultWidth,
		        height:"28px",
		        chooseMode:"1",
		        isAllowOther:"true",
		        callback: function(selected){
		        	cui(box).setValue(selected);
					var textValue = cap.createUserOrgChooseStringTextValue(selected);
					valueNames = textValue.text;
					idNames = textValue.value;
					codeNames = textValue.codeName;
		        },
		        isSearch:"true"
		    }, options));
		    var initValue = cap.initUserOrgChoose(idNames, valueNames,codeNames);
		    cui(box).setValue(initValue);
		},
        returnValue: function (box, rowData, options) {
            var chooseObj = cui(box);
        	var val = chooseObj.getValue();
        	var ret = cap.createUserOrgChooseStringTextValue(val);
        	if(options != null){
        		if(options.idName != null && options.idName != ''){
        			rowData[options.idName] = ret.value;
        		}
        		if(options.valueName != null && options.valueName != ''){
        			rowData[options.valueName] = ret.text;
        		}
        	}
        	if(options != null&&options.opts){
        		rowData[eval('(' +options.opts+ ')').codeName] = ret.codeName;
        	}
        	return ret;
        }
	}
}

cap.Editor = {
	"ChooseOrg": cap.userOrgCommonRegistrationForm("chooseOrg"),
    "ChooseUser": cap.userOrgCommonRegistrationForm("chooseUser")
}
/*---------------------------------第三方编辑器End--------------------------------------*/

/**
 * 让当前页面上获得焦点的元素先失去焦点，再重获焦点
 */
cap.resetFocus = function(){
	var _element = document.activeElement;
	if(_element){
		_element.blur();
		_element.focus();
	}
};



/**
 * 
 * 本函数实现数组删除元素的功能。
 * 
 * 说明：
 * 1.支持js原始类型数据的删除，e.g.: boolean\number(包括Infinity和-Infinity,但不包括NaN)\string\null\undefined
 * 2.支持js中typeof运算后为object的对象数据删除。但不支持使用原始数据类型的包装器类型new出的对象(e.g.: new Number(1)\new Boolean(false)\new String("hello"))以及空对象(e.g.: new Oject()\{})
 * 3.支持js中自定义的类对象删除，要求对象必须至少有一个属性来承担比较的key.注意：本函数只支持单key比较，key为对象元素for in出来的第一个属性，即target数组里面的对象元素for in出来的第一个属性为key，若有多个属性，除第一个属性外，其他属性将被忽略。
 * 4.不支持function类型元素的删除。
 * 5.不支持对多维数组元素的删除，只支持一纬数组。
 * <pre>
 * function Human(name,age){
 * 		this.name = name;
 * 		this.age = age;
 * }
 * 
 * var source = [1,2,3,1,4,3,5,true,"false",null,undefined,Infinity,new Human("z3",20),new Human("w5",22),{id:20,text:"some data"}];
 * var target = [0,1,3,5,"false","true",null,undefined,Infinity,new Human("z3",55),{name:"w5"},{id:20}];
 * 
 * var result = cap.array.remove(source,target,true);
 * 
 * result:[2,4,true]
 * </pre>
 * 
 * @author lingchen WWW.SZCOMTOP.COM
 * @Date 2015-09-16
 * 
 * @param source 需要删除元素的数组 (必须) e.g.: [1,2,5,3,4,3,5] 
 * @param target 哪些元素需要删除组成的数组 (必须) e.g.: [3,5,6],3、5、6就是需要从source里面准备删除的元素
 * @param flag 是否从source里面一并删除重复的元素 true or false （可选） e.g.: source里面的重复项3、5在删除的时候是全部删掉还是只删除第一个。(号外：如果target里面也有两个3、5，则就算falg = false，也会把source里面的重复项3、5一起删除)
 * @return source经过删除后的结果（同一引用）。
 */
(function(cap){
	cap.array = {
		remove : function(source,target,flag) {
			//验证输入合法性
			if(arguments.length < 2){
				throw new Error("the remove method must have two parameters of the array type at least.");
			}
			if(Object.prototype.toString.call(arguments[0]) !== "[object Array]" || Object.prototype.toString.call(arguments[1]) !== "[object Array]"){
				throw new Error("the first two parameters for the remove method must all be the type of array.");
			}
			if(arguments.length >= 3 && typeof arguments[2] != "boolean"){
				throw new Error("the thirdly parameter for the remove method must be the type of boolean, e.g.: true or false.");
			}
			
			//定义是否匹配到了源数组的元素。
			var matched = false;
			
			//开始进行匹配
			for(var i = 0, len = target.length; i < len; i++){
				for(var k = 0, _len = source.length; k < _len; k++){
					//对象类型匹配,不支持new Boolean(true)\new String("123")\new Number(123)\new Object或{}空对象\function类型\NaN进行匹配。
					//不支持多维数组匹配。
					if(target[i] && typeof target[i] == "object"){ 
						if(source[k] && typeof source[k] == "object"){
							
							//深度遍历对象属性进行匹配
							var recursion = function(_target,_source){
								var key;
								for(var attr in _target){
									key =  attr;
									break;
								}
								if(key){
									if(typeof _target[key] == "object" && typeof _source[key] == "object"){
										return arguments.callee(_target[key],_source[key]); //递归深度遍历属性
									}else{
										if(_target[key] === _source[key]){
											return true;
										}
										return false;
									}
								}
								return false;
							}
							
							var result = recursion(target[i],source[k]);
							
							if(result){
								matched = true;
								source.splice(k,1);//删除
								break;
							}
						}
					}else{ //原始类型匹配
						if(target[i] === source[k]){
							matched = true;
							source.splice(k,1);//删除
							break;
						}
					}
				}
				if(matched && flag){ //开启源数组重复项全部删除
					--i;
					matched = false;
				}
			}
			
			return source;
		},
		/**
		 * 在数组的指定位置插入一个元素
		 * 
		 * @param item 待插入的元素
		 * @param index 插入的位置
		 * @param arr 插入到arr数组中
		 */
		insert : function(item,index,arr){
			//验证输入合法性
			if(arguments.length < 3){
				throw new Error("the insert method must have three parameters of the array type at least.");
			}
			//验证输入合法性
			if(!/^\d+$/.test(arguments[1])){
				throw new Error("the second parameter must be a digit.");
			}
			//验证输入合法性
			if(Object.prototype.toString.call(arguments[2]) !== "[object Array]"){
				throw new Error("the thirdly parameter must be an array.");
			}
			arr.splice(index, 0, item);  
		}
	};
})(cap || (cap = {}));

/**
 * if the iteratively window has parent and the parent is not itself and the parent is not current window,
 * then judge the parent window has or hasn't we need <code>key</code>.
 * if has,return immediately,else assignment the parent window to the iteratively window,then enter the next each.
 *  
 * else if the iteratively window has opener and the opener is not itself and the opener is not current window,
 * then judge the opener window has or hasn't we need <code>key</code>.
 * if has,return immediately,else assignment the opener window to the iteratively window,then enter the next each.
 * 
 * if the iteratively window has not parent and opener,return null.
 * 
 * @author lingchen WWW.SZCOMTOP.COM 
 * @Date 2015-09-02
 * @param key the key for search parent window
 */
(function(cap){
	cap.searchParentWindow = function(key){
		//get key from current window
		if(window[key]){
			return window;
		}
		
		var _window = window;
		//each window
		while(true){
			try{
				if(_window.parent && _window.parent != _window && _window.parent != window){
					if(_window.parent[key]){
						return _window.parent;
					}else{
						_window = _window.parent;
					}
				}else if(_window.opener && _window.opener != _window && _window.opener != window){
					if(_window.opener[key]){
						return _window.opener;
					}else{
						_window = _window.opener;
					}
				}else if(_window == window){
					return null;
				}else{
					return null;
				}
			}catch(err){
				return null;
			}
		}
	};
})(cap || (cap = {}));


/**
*
* 本函数实现对目标对象中的字符串属性进行trim操作。
*
* 目标对象：可以是基础类型的字符串，可以是String对象，也可以是数组或Object。
*
* 该函数支持是否对目标对象的属性（如对象中的Object、Array、String属性）深度遍历进行trim操作。但永远不会对原型链上的属性进行trim。
*
* 调用方式如下：
* <pre>
*
* var result = cap.trim(target);
* 或
* var result = cap.trim(target, true);
* 或
* var result = cap.trim(target, false);
*
* </pre>
*
* @author lingchen WWW.SZCOMTOP.COM
* @Date 2016-05-10
*
* @param target 目标对象
* @param true/false 是否对目标对象进行深入遍历trim(若不传此参数，则默认为深度遍历)
* @return target经过trim后的结果（同一引用）。
*/
(function(cap){
    cap.trim = function(){
        //trim函数必须至少要有一个参数
        if(arguments.length === 0){
            throw new Error("the trim function needs to have at least one parameter.");
        }
        //有第二个参数，就必须是boolean类型
        if(arguments.length >= 2 && typeof arguments[1] !== "boolean"){
            throw new Error("the second parameter of the trim function must be a boolean variable.");
        }
        
        //默认为深度遍历
        var flag = true;
        if(arguments.length >= 2){
            flag = arguments[1];
        }
        var target = arguments[0];
        //处理字符串类型
        if(typeof target === "string"){
            return target.replace(/^(\s|\u00A0)+/,'').replace(/(\s|\u00A0)+$/,'');
        }
        //处理对象类型
        if(Object.prototype.toString.call(target) === "[object Object]"){
            for(var attr in target){
                //原型链上的属性不处理
                if(Object.prototype.hasOwnProperty.call(target,attr) && !( /^jQuery\d+$/.test(attr))){
                    if(flag || typeof target[attr] === "string"){
                        target[attr] = arguments.callee(target[attr]);
                    }
                }
            }
        }
        //处理String对象
        if(Object.prototype.toString.call(target) === "[object String]"){
            target = new String(target.replace(/^(\s|\u00A0)+/,'').replace(/(\s|\u00A0)+$/,''));
        }
        //处理数组类型
        if(Object.prototype.toString.call(target) === "[object Array]"){
            for(var k = 0; k < target.length; k++){
                if(flag || typeof target[k] === "string"){
                    target[k] = arguments.callee(target[k]);
                }
            }
        }

        return target;
    };
})(cap || (cap = {}));

/**
 * cap.money.format实现对金额的格式化;
 * cap.money.parse实现对格式化的金额字符串转number类型。
 *
 * 格式化规则为从整数末尾计算，每三位后加个英文逗号分隔符，如12,735,920.64
 * 解析金额字符串规则为去英文逗号
 *
 * 格式化函数支持接收string类型和number类型的金额格式化，支持正负数，支持.52这种格式的参数。
 * 格式化校验规则，以下被认定为非法金额数：
 * 1、number类型的NaN|Infinity|-Infinity；
 * 2、string类型包含两个及以上的小数点；
 * 3、string类型不包含任何数字。
 *
 * e.g.:
 * <pre>
 *     var formatStr = cap.money.format("+123456.520"); // +123,456.520
 *     var formatStr = cap.money.format("+.520"); //+.520
 *     var formatStr = cap.money.format(+123456.520); // 123,456.52
 *     var formatStr = cap.money.format("123a456b.52d0"); // 123,456.520
 *
 *     var parseNum = cap.money.parse("123,456.520"); // 123456.52
 *     var parseNum = cap.money.parse("+12a3,4b56.5d20"); // 123456.52
 *     var parseNum = cap.money.parse("-123,456.5"); // -123456.5
 *     var parseNum = cap.money.parse("+123,456.5"); // 123456.5
 *     var parseNum = cap.money.parse("+.5"); // 0.5
 * </pre>
 *
 * 解析函数只支持接收string类型参数。
 * 解析校验规则，以下被认定为非法金额数：
 * 1、非string类型；
 * 2、string类型包含两个及以上的小数点；
 * 3、string类型不包含任何数字。
 *
 * @author lingchen WWW.SZCOMTOP.COM
 * @Date 2016-05-26
 *
 * @param money 金额的字符串表现形式或number类型的数据
 *
 * @return 金额格式化后的字符串表现形式或解析后的金额的number类型数值
 */
(function(cap){
    cap.money = {
        format : function() {
            //must have on parameter at least
            if(arguments.length == 0){
                throw new Error("the format method must have one parameter at least.");
            }
            //parameter must be string or number
            if(Object.prototype.toString.call(arguments[0]) !== "[object String]" && Object.prototype.toString.call(arguments[0]) !== "[object Number]"){
                throw new Error("the parameter is illegal.");
            }
            //exclude NaN|Infinity|-Infinity
            if(arguments[0] !== arguments[0] || arguments[0] === Infinity || arguments[0] === -Infinity){
                throw new Error("the parameter is illegal.");
            }

            //validate and process
            var moneyStr = cap.money.innerFunction(arguments[0]);

            var _array = /([\d\-\+]*)[.]?(\d*)/g.exec(moneyStr);
            //process integer
            var integer = '';
            if(_array[1]){
                //string reverse
                var _revers = _array[1].split("").reverse().join("");
                for(var i = 1; i <= _revers.length; i++){
                    integer += _revers.charAt(i-1);
                    if(i % 3 === 0 && i !== _revers.length && /[^\-\+]/.test(_revers.charAt(i))){
                        integer += ",";
                    }
                }
            }
            //reverse ingeter
            if(integer){
                integer = integer.split("").reverse().join("");
            }
            //append decimals and return
            return integer + (_array[2] ? ("." + _array[2]) : "");
        },
        parse : function() {
            //must have on parameter at least
            if(arguments.length == 0){
                throw new Error("the parse method must have one parameter at least.");
            }

            //parameter must be string
            if(Object.prototype.toString.call(arguments[0]) !== "[object String]"){
                throw new Error("the parameter is illegal.");
            }

            //validate and process
            var moneyStr = cap.money.innerFunction(arguments[0]);
            //drop "," char
            moneyStr = moneyStr.replace(/[,]/g,"");

            return parseFloat(moneyStr);
        },
        innerFunction : function() {
            //case to string
            var moneyStr = arguments[0] + "";
            //exclude have two point
            var matcher = moneyStr.match(/\./g);
            if(matcher && matcher.length > 1){
                throw new Error("the parameter is illegal.");
            }

            //drop the illegal chars
            moneyStr = moneyStr.replace(/[^\d\.\-\+]/g, '');
            if(moneyStr === ''){
                throw new Error("the parameter is illegal.");
            }

            //drop extra '-' and '+' chars
            var moneyFirstChar = moneyStr.substring(0, 1);
            moneyStr = moneyFirstChar + moneyStr.substring(1).replace(/[\-\+]/g, '');

            //if the last char is point, drop it
            if(moneyStr.charAt(moneyStr.length-1) === "."){
                moneyStr = moneyStr.substring(0, moneyStr.length-1);
                if(moneyStr === ''){
                    throw new Error("the parameter is illegal.");
                }
            }
            return moneyStr;
        }
    };
})(cap || (cap={}));

/**
 * uuid生成器(源自jQuery)
 * 
 * @author lingchen WWW.SZCOMTOP.COM
 * @Date 2016-08-05
 */
(function(cap){
    var CHARS = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.split('');
    cap.Math = {
        uuid : function (len, radix) {
            var chars = CHARS, uuid = [], i;
            radix = radix || chars.length;

            if (len) {
                // Compact form
                for (i = 0; i < len; i++) uuid[i] = chars[0 | Math.random()*radix];
            } else {
                // rfc4122, version 4 form
                var r;

                // rfc4122 requires these characters
                uuid[8] = uuid[13] = uuid[18] = uuid[23] = '-';
                uuid[14] = '4';

                // Fill in random data.  At i==19 set the high bits of clock sequence as
                // per rfc4122, sec. 4.1.5
                for (i = 0; i < 36; i++) {
                    if (!uuid[i]) {
                        r = 0 | Math.random()*16;
                        uuid[i] = chars[(i == 19) ? (r & 0x3) | 0x8 : r];
                    }
                }
            }
            return uuid.join('');
        }
    };
})(cap || (cap = {}));
