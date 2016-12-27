/**
 * defined global namespace
 * @author lingchen WWW.SZCOMTOP.COM
 * @version 1.0
 * @date 2016-10-31
 * @type {{}}
 */
var cap = cap ? cap : {};

/**
 * 从页面的访问url去获取指定的参数
 * 
 * @param paramName 参数的名称。必填
 * @param url 页面的url，可不传。不传默认使用window.location.href去获取
 * @return 参数对应的值
 * @exception 当调用此方法，没有传任何参数，将抛出异常
 */
(function(cap){
	cap.getURLParameter = function(paramName,url){
		if(arguments.length == 0){
			throw new Error("the function named 'getParameter' must has one argument at least.");
		}
		var url = url ? url : window.location.href;
		var urlSplit = url.split("?");
		if(urlSplit.length == 1 || !urlSplit[1]){
			return null;
		}

		var params = urlSplit[1].split("&");
		for(var i = 0, len = params.length; i < len; i++){
			if(!params[i] || params[i].split("=").length < 2){
				continue;
			}
			if(paramName === params[i].split("=")[0]){
				return params[i].split("=")[1];
			}
		}

		return null;
	};
	
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
	 *	页面加载初始化
	 */
	cap.pageInit=function(){
		cap.beforeLoad();
		cap.initDataBind();
		cap.initValidate();
		//审批页面初始化函数
		cap.executeFunction("loadApprovePage");
		//附件页面
		cap.executeFunction("loadAttach");
	};
	
	/**
	 * 页面初始化前处理特殊控件绑定
	 */
	cap.beforeLoad=function(){
		for(var item in uiConfig){
			if(uiConfig[item].labelType){
			 eval("if(cap.beforeLoad"+uiConfig[item].uitype+"!=undefined){cap.beforeLoad"+uiConfig[item].uitype+"(item,uiConfig[item]);}");	
			}else{
			 eval("if(cap.beforeLoad"+uiConfig[item].uitype+"!=undefined){cap.beforeLoad"+uiConfig[item].uitype+"(item);}");
			}
	    }
	};

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
	 * 由于开发建模与需求建模中的行为存在共用，故需求建模中需要提供对应行为中使用的方法
	 * @param  {[type]} url [description]
	 * @return {[type]}     [description]
	 */
	cap.getforwardURL = function (url) {
		return url
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
	 };
	 
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
	 };
	 
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
	 };
	 
	 /**
	  * 异常信息回调函数
	  */
	 cap.errorCallback = function(msg, exception) {
	 	if(console){
	 		console.log("当前请求存在异常信息:"+msg);
	 	}
	 	return;
	 };

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
	 };

	 /**
	  * 可自定义设置回调函数
	  */
	 cap.setErrorCallback = function(fn) {
	 	dwr.TOPEngine.setErrorHandler(fn);
	 };
	
	
})(cap || (cap = {}));

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

/*---------------------------------（editableGrid-》edittype）第三方编辑器--------------------------------------*/
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