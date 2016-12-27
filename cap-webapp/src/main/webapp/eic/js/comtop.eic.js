;(function($){
	var currentLang;
	if(navigator.userAgent.indexOf("MSIE")!=-1) { 
		currentLang = navigator.browserLanguage.toLowerCase();
	} else{
		currentLang = navigator.language.toLowerCase();
	}
	if(currentLang != "zh-cn" && currentLang != "en-us"){
		currentLang = "en-us";
	}
//	if(!+[1,]){
//		currentLang = navigator.browserLanguage.toLowerCase();
//	}else{
//		currentLang = navigator.language.toLowerCase();
//	}
	var root = $("script");
	var length = root.length;
	var src = null;
	for(var i = 0 ; i < length ; i++){
		src = root.get(i).getAttribute("src");
		if(src != null){
			if(src.substring(src.lastIndexOf("/")+1,src.lastIndexOf("/")+14) == "comtop.eic.js"){
				break;
			}
		}
		src = null;
	}
	var r = src;
	var index = r.lastIndexOf("/");
	r = r.substring(0,index);
	if(window.i18n==null||window.i18n==""){
		var script = window.document.createElement("script");
		script.setAttribute("type","text/javascript");
		script.setAttribute("src",r+"/i18n/message-"+currentLang+".js");
		window.document.getElementsByTagName("head")[0].appendChild(script);
	}
	var webRoot = src.substring(0,src.indexOf("/eic"));
	if(window.top!==window&&!window.top.doExcelImportByJs){
		var script =  window.top.document.createElement("script");
		script.setAttribute("type","text/javascript");
		//这个地址要根据实际地址来配置
		script.setAttribute("src",webRoot+"/eic/js/comtop.eic.js"); 
		window.top.document.getElementsByTagName("head")[0].appendChild(script); 
	} 
})(jQuery)

//window.onload = function(){
//	var webRoot = $("a[excelid]").attr("webRoot");
//	//在系统最顶层页面建立一个comtop.eic.js
//	if(window.top!==window&&!window.top.doExcelImportByJs){
//		var script =  window.top.document.createElement("script");
//		script.setAttribute("type","text/javascript");
//		//这个地址要根据实际地址来配置
//		script.setAttribute("src",webRoot+"/eic/js/comtop.eic.js"); 
//		
//		/*例如：生产子系统*/
//		//script.setAttribute("src","/web/lcam/fwms/eic/js/comtop.eic.js"); 
//		/*
//		script.onload = script.onreadystatechange = function(){
//		    if(!this.readyState || this.readyState == "loaded" || this.readyState == "complete"){
//		    	console.log("loaded");		    	
//		        script.onload = script.onreadystatechange =null;
//		    }
//		}*/
//		window.top.document.getElementsByTagName("head")[0].appendChild(script); 
//	} 
//};



var importDialog = null;
var rex = /^[\s\w]+\s*[(][\w()]*([);]|[\s]*$)/;
/**
 * 打开Excel导入界面
 * @param obj Excel导入控件
 */
function doExcelImport(obj) {
	var userId = obj.getAttribute("userId");
	var excelId= obj.getAttribute("excelId");
	var asyn= obj.getAttribute("asyn");
	var param= obj.getAttribute("param");
	var callback= obj.getAttribute("callback");
	var sysName= obj.getAttribute("sysName");
	var webRoot= obj.getAttribute("webRoot");
	doExcelImportByJs(webRoot,sysName,userId,excelId,asyn,callback,param);
}
/**
 * 通过JS调用打开Excel导入界面
 * @param webRoot 系统根路径
 * @param sysName 子系统名称
 * @param userId  用户ID
 * @param excelId ExcelID
 * @param asyn 是否异步执行
 * @param callback 回调函数
 * @param param 自定义参数
 */
function doExcelImportByJs(webRoot,sysName,userId,excelId,asyn,callback,param){
	var url = webRoot+"/eic/view/ExcelImport.jsp?excelId="+escape(excelId)+"&sysName="+escape(sysName)+"&asyn="
	 +asyn+"&userId="+escape(userId)+"&param="+encodeURIComponent(encodeURIComponent(param))+"&callback="+escape(callback);
	
	if (!importDialog) {
	    importDialog = cui.extend.emDialog({
	    	id:'importDialog',
	        title: i18n.importExcel,
	        src: url,
	        width: 400,
	        height: 150,
	        onClose: function(){
	    	if(callback!=null && callback!='null' && callback.length>0){
    			var event = "onClose";
    			if(rex.test(callback)){
    				eval(callback);
    				return;
    			}
    			var fun = eval(callback);
    			if(Object.prototype.toString.call(fun) === "[object Function]"){
    				fun(event);
    			}else{
    				eval(callback);
    			}
    		}
    		importDialog=null;
		    }
	    })
	}
	importDialog.show(url);
}

/**
 * 下载导入模板
 * @param obj 标签
 * @param iframeId 下载所用Iframe的ID，如果在标签中指定了标签的ID，那么iframeId则为：
 * "ExcelTemplateDownload_Iframe_+标签的ID"；否则为随机字符串。
 */
function doDownloadTemplate(obj,iframeId) {
	var userId = obj.getAttribute("userId");
	var excelId= obj.getAttribute("excelId");
	var webRoot= obj.getAttribute("webRoot");
	var sysName= obj.getAttribute("sysName");
	doDownloadTemplateByJs(webRoot,sysName,userId,excelId,iframeId);
}

/**
 * 利用JS调用下载导入模板
 * @param webRoot 系统根路径
 * @param sysName 子系统名称
 * @param userId 用户ID
 * @param excelId ExcelID
 * @param iframeId 下载所用Iframe的ID，如果在标签中指定了标签的ID，那么iframeId则为：
 * "ExcelTemplateDownload_Iframe_+标签的ID"；否则为随机字符串。
 */
function doDownloadTemplateByJs(webRoot,sysName,userId,excelId,iframeId){
	var url ="/eic/eic.excelImport?excelId="+escape(excelId)+"&sysName="+escape(sysName)+"&userId="+escape(userId)+"&actionType=downloadTemplate";
	if(sysName){
		if(sysName.indexOf("/") === 0){
			url= webRoot+sysName+url;
		}else{
			url= webRoot+"/"+sysName+url;
		}
	}else{
		url= webRoot+url;
	}
	var downloadTemplateFrame = document.getElementById(iframeId);
	var date = new Date();
	url+="&time=" + date.getTime();
	downloadTemplateFrame.src = url;
}

/**
 * 找不到模板时，弹出错误消息
 * @param webRoot 系统根路径
 * @param msg 错误消息
 */
function showTemplateNoFoundMsg(webRoot,msg,excelId,asyn,userId) {
	var url = webRoot+"/eic/view/ExcelImportError.jsp?errorInfo="+msg;
	if (!importDialog) {
	    importDialog = cui.extend.emDialog({
	    	id:'importErrorDialog',
	        title: i18n.downloadTem,
	        src: url,
	        width: 400,
	        height: 150,
	        onClose: function(){
    			importDialog=null;
	    	}
	    })
	}
	importDialog.show(url);
}

var dyColumnDialog = null;
/**
 * 动态列导入弹出框
 * @param webRoot 系统根路径
 * @param sysName 子系统名称 
 * @param excelId 配置的excel唯一标识
 * @param userId 用户id
 * @param exportType 导出类型
 * @param excelVersion excel版本
 * @param param 用户参数
 */
function openDyColumnDialog(objParams){
	var buttonId = objParams.buttonId;
	var webRoot = objParams.webRoot;
	var webRoot = objParams.webRoot;
	var sysName = objParams.sysName;
	var excelId = objParams.excelId;
	var userId = objParams.userId;
	var exportType = objParams.exportType;
	var excelVersion = objParams.excelVersion;
	var param = objParams.param;
	var asyn = objParams.asyn;
	var exportFileName = objParams.exportFileName;
	var defVersion = objParams.defVersion;
	if(sysName && null != sysName && "" != sysName){
		var pattern = new RegExp("^[/]"); // 以/开头
		if(!pattern.exec(sysName)) {
			sysName = "/" + sysName;
		}
	}
	var params ="?buttonId="+buttonId+"&userId="+userId+"&excelId="+excelId+"&excelVersion="+excelVersion+"&exportType="+exportType+"&param="+param+"&subSystem="+sysName+"&asyn="+asyn+"&exportFileName="+exportFileName; 
     var url = webRoot+"/eic/view/DynamicColumnConfig.jsp"+params;
     if(null == dyColumnDialog){
	     dyColumnDialog = cui.extend.emDialog({
	    	    id:'dyColumnDialog',
		        title: i18n.selectColumn,
		        src: url,
		        width: 400,
		        height: 350,
		        beforeClose: function (){
	                if(null != exportDialog){
	                	if(asyn == true){
	                		exportDialog.hide();
	                	}
	                }
	            }
		 });
     }
     dyColumnDialog.show(url);
}

var exportDialog =null;
var isDelExportDialog = false;
/**
 * Excel导出
 * @param webRoot 系统根路径
 * @param sysName 子系统名称
 * @param userId  用户ID
 * @param excelId ExcelID
 * @param exportType 导出类型
 * @param param 自定义参数
 */
function excelExport(obj) {

	var buttonId = obj.getAttribute("id");
	var userId = obj.getAttribute("userId");
	var excelId = obj.getAttribute("excelId");
	var webRoot = obj.getAttribute("webroot");
	var param = obj.getAttribute("param");
	var exportType = obj.getAttribute("exportType");
	var sysName = obj.getAttribute("sysname");
	var asyn = obj.getAttribute("asyn");
	var exportFileName = obj.getAttribute("exportFileName");
	var defVersion = obj.getAttribute("defVersion");
	var params = {"buttonId":buttonId,"userId": userId, "excelId": excelId,"exportType": exportType, "webRoot": webRoot, "param": encodeURIComponent(encodeURIComponent(param)), "sysName": sysName, "defVersion":defVersion, "asyn": asyn,"exportFileName": encodeURIComponent(encodeURIComponent(exportFileName))};
	iExcelExport(params);
}

function winHeight(){
	var h =window.innerHeight;	
	if(typeof h==="undefined"){		
		h= document.body.clientHeight?document.body.clientHeight:document.documentElement.clientHeight; 
	}
	if(h>500){
		h=500;
	}
	return h*0.25;	
}
function iExcelExport(params){
	
	var buttonId = params.buttonId;
	var userId = params.userId;
	var excelId = params.excelId;
	var webRoot = params.webRoot;
	var param = params.param;
	var exportType = params.exportType;
	var sysName = params.sysName;
	var asyn = params.asyn;
	var exportFileName = params.exportFileName;
	var defVersion = params.defVersion;
	if(null == sysName || "" == sysName || "null" == sysName){
		sysName = "";
	}
	var srtParams ="?&userId="+userId
	               +"&buttonId="+buttonId
		           +"&excelId="+excelId
		           +"&sysName="+sysName
		           +"&exportType="+exportType
		           +"&param="+param
	               +"&asyn="+asyn
	               +"&exportFileName="+exportFileName
	               +"&defVersion="+defVersion;
	var url = webRoot+"/eic/view/ExcelVersionOption.jsp"+srtParams;
	if (!exportDialog) {		
		exportDialog = cui.extend.emDialog({
			id:"exportDialog",
	        title: i18n.selectVersion,	 
	        src: url,
	        width: 400,
	        height: 90,
	        buttons:[{
	        	name:i18n.cancel, 
	        	disable:false,
	        	handler:function(){
	        	    exportDialog.hide();
	        	} 
	        }],
	        onClose:function(){  
			   return;
			   if(isDelExportDialog){
				   isDelExportDialog = false;
				   var child=document.getElementById("exportDialog"),
		            p=child.parentNode;
				    p.removeChild(child);
				    exportDialog=null;	
			   }
			}
	    })
	}
	exportDialog.setSize({height:110});
	exportDialog.setTitle(i18n.selectVersion);
	exportDialog.show(url);
}

/**
 * 同步下载找不到文件时弹出错误提示
 * @param webRoot 系统根路径
 * @param msg 错误消息
 */
var excelExportErrDialog = null;
function showExcelExportErrorInfo(webRoot,msg) {
	var url = webRoot+"/eic/view/ExcelExportError.jsp?errorInfo="+msg;
	if (!excelExportErrDialog) {
		excelExportErrDialog = cui.extend.emDialog({
			id:'excelExportErrDialog',
	        title: i18n.errorMessage,
	        src: url,
	        width: 400,
	        height: 150,
	        onClose: function(){
				excelExportErrDialog=null;
	    	}
	    })
	}
	excelExportErrDialog.show(url);
}
var wordExportDialog = null;
function wordExport(obj) {
	var userId = obj.getAttribute("userId");
	var wordId = obj.getAttribute("wordId");
	var asyn = obj.getAttribute("asyn");
	var webRoot = obj.getAttribute("webroot");
	var param = obj.getAttribute("param");
	var sysName = obj.getAttribute("sysname");
	var fileName = obj.getAttribute("fileName");
	
	var params = {"userId": userId, "wordId": wordId, "asyn": asyn, "webRoot": webRoot, "param": encodeURIComponent(encodeURIComponent(param)), "sysName": sysName, "fileName": encodeURIComponent(encodeURIComponent(fileName))};
	iWordExport(params);
}

function iWordExport(params) {
	var userId = params.userId;
	var wordId = params.wordId;
	var asyn = params.asyn;
	var webRoot = params.webRoot;
	var param = params.param;
	var sysName = params.sysName;
	var fileName = params.fileName;
	var url = webRoot + "/eic/view/WordExport.jsp?asyn=" + asyn + "&userId=" + userId + 
	"&wordId=" + wordId + "&exparam=" + param + "&webroot=" + webRoot + "&sysname=" + sysName+ "&fileName=" + fileName;
	if (!wordExportDialog) {
		wordExportDialog = cui.extend.emDialog({
			id:'wordExportDialog',
	        title: i18n.exportWord,
	        src: url,
	        width: 400,
	        height: 150
	    })
	}
	wordExportDialog.show(url);
}

var taskMonitorDialog = null;
var eic_openDiv = null;
var eic_TaskMonitorPageShowFlag = false;
var eic_timerId = null;
/**
 * 打开任务监控右下角弹窗口
 * @param url 导入导出监控界面url
 */
function openTaskMonitorList(url){
	 url = url.replace("&amp;","&");//top平台对传递的数据会转码
	  
/*	 cui.extend.emDialog({
		 id:"taskMonitorDialogId",
         title: "\u5bfc\u5165\u5bfc\u51fa\u7ba1\u7406",
         src:url,
         left: "100%",
         top: "100%",
         width: 465,
	     height: 258,
         draggable: false,
         modal: false,
         beforeClose:function(){
		  document.getElementById("eic_openTaskMonitorList_openDivId").style.display = "block";
		  return true;
	     },
	     onClose:function(){
	    	 eic_TaskMonitorPageShowFlag = false;
	     }
     }).show();*/
	 
 
	 
	 if(window != window.top){
		 //父窗口不存在taskMonitorDialog对象时在创建
		 var parentObj = window.parent;
		 var count = 0;
		 while(true){
			 //设置最大层为30层
			 if(count >= 30){
				 break;
			 }
			 if(parentObj && null != parentObj.taskMonitorDialog){
				   //父框架已经创建
				 break;
		     }
			 if(parentObj && parentObj.window.parent && !(parentObj.window.top === parentObj.window.parent)){
				 parentObj = parentObj.window.parent;
			 }else{
				 if(parentObj && parentObj.window.parent){
					 parentObj = parentObj.window.parent;
				 }
				 break;
			 }
			 count++;
		 }
		 if(parentObj){
			 if(null != parentObj.taskMonitorDialog){
			   parentObj.openTaskMonitorList(url);	 
			   //父框架已经创建
			   return;
			 }
		 }
	 }
	 var reInit = /&init=true/;
	 var initFlag = false;
	 if(true == reInit.test(url)){
		 initFlag = true;
		 url = url.replace(reInit,"");
	 }
	 var paramUrl = url;
	 url = url + "&pageSize=5&curtime="+Math.random();
	 if(null == eic_openDiv){
		 var html = '<div id="eic_openTaskMonitorList_openDivId" class="cui-dialog-container" style="width: 130px; right: 0px; bottom: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; display: block; filter: alpha(opacity=100); position: fixed; z-index: 10002; cursor: move; opacity: 1; background-color: rgb(64, 142, 230); border-top-color: #408ee6; border-right-color: #408ee6; border-bottom-color: #408ee6; border-left-color: #408ee6;">';
		 html = html + '<div id="eic_TaskMonitorSpanTitId" onclick="openTaskMonitorList(\''+paramUrl+'\')" style="filter:alpha(opacity=100);opacity:1;cursor: pointer;width: 100%;height: 23px;margin-top: 0px;padding-top:5px; text-align: center;" class="dialog-title">'+i18n.importAndExportManagment+'</div>';
		 html = html + '</div>';
		 var webRootArr = url.split("/");
		 var webRoot = "/"+webRootArr[1];
		 eic_openDiv = document.createElement("div");
		 eic_openDiv.innerHTML = html;
		 window.top.document.body.appendChild(eic_openDiv);
		 eic_Drag("eic_openTaskMonitorList_openDivId","eic_openTaskMonitorList_openDivId");
		 //取值设置，让浏览器进行重新渲染
		 var objDivTemp = window.top.document.getElementById("eic_openTaskMonitorList_openDivId");
		 objDivTemp.style.right = "0px";
		 objDivTemp.style.bottom = "0px";
		 objDivTemp.style.left =  "";
		 objDivTemp.style.top = "";
		 if (document.all){
	  		  window.top.attachEvent('onresize',function(){
	  		  var objDiv = window.top.document.getElementById("eic_openTaskMonitorList_openDivId");
	   	  		  objDiv.style.right = "0px";
	   	  		  objDiv.style.bottom = "0px";
	   	  		  objDiv.style.left =  "";
	   	  		  objDiv.style.top = "";
   	  		  eic_Drag("eic_TaskMonitorSpanTitId","eic_openTaskMonitorList_openDivId");
	  		  });//IE中
	  		}
	  		else{
	  		  window.top.addEventListener('resize',function(){
	  			var objDiv = window.top.document.getElementById("eic_openTaskMonitorList_openDivId");
	    	  		objDiv.style.right = "0px";
	    	  		objDiv.style.bottom = "0px";
	    	  		objDiv.style.left =  "";
	    	  		objDiv.style.top = "";
	    	  	eic_Drag("eic_TaskMonitorSpanTitId","eic_openTaskMonitorList_openDivId");
	  		  },false);//firefox
	  	}
		 //先计算好坐标后在隐藏
		 window.top.document.getElementById("eic_openTaskMonitorList_openDivId").style.display = "none";
	 }
	 if(null == taskMonitorDialog){
		 taskMonitorDialog = cui.dialog({
			 id:"taskMonitorDialogId",
	         title: i18n.importAndExportManagment,
	         src:url,
	         left: "100%",
	         top: "100%",
	         width: 465,
		     height: 270,
	         draggable: false,
	         modal: false,
	         beforeClose:function(){
			  window.top.document.getElementById("eic_openTaskMonitorList_openDivId").style.display = "block";
			  return true;
		     },
		     onClose:function(){
		    	 eic_TaskMonitorPageShowFlag = false;
		     }
	     });
		 try{
		   var colseBtn = (window.top.document.getElementById("taskMonitorDialogId")).getElementsByTagName("a")[0];
		   colseBtn.setAttribute("title",i18n.minimize);
		 }catch(e){}
		 //解决第一次打开空白问题
		 taskMonitorDialog.show(url);
		 taskMonitorDialog.hide();
	 }
	 if(false == initFlag){
		 window.top.document.getElementById("eic_openTaskMonitorList_openDivId").style.display = "none";
		 window.top.document.getElementById("eic_openTaskMonitorList_openDivId").style.backgroundColor = "#408ee6";
		 window.top.document.getElementById("eic_openTaskMonitorList_openDivId").style.borderColor = "#408ee6";
		   if(null != eic_timerId){
		     clearInterval(eic_timerId);
	         eic_timerId = null;
		   }
		   taskMonitorDialog.show(url);
		   eic_TaskMonitorPageShowFlag = true;
		 }else{
			 window.top.document.getElementById("eic_openTaskMonitorList_openDivId").style.display = "block";	 
		   initFlag = false;
	}
}

//异步导入导出任务完成通知回调函数
var eicAsynTaskCompleteCallBack = null;
/**
 * 消息提醒
 */
function eic_TaskMonitorPrompt(status){
	if(false == eic_TaskMonitorPageShowFlag && null == eic_timerId){
		window.top.document.getElementById("eic_openTaskMonitorList_openDivId").style.backgroundColor = "#cf863d";
		window.top.document.getElementById("eic_openTaskMonitorList_openDivId").style.borderColor = "#cf863d";
	    var i = 0;
	    eic_timerId = setInterval(function () {
	    i++;
	    if(0 == (i % 2)){
	    	window.top.document.getElementById("eic_openTaskMonitorList_openDivId").style.display = "none";
	    }else{
	    	window.top.document.getElementById("eic_openTaskMonitorList_openDivId").style.display = "block";
	    }
	    if(10 == i || true == eic_TaskMonitorPageShowFlag){
	    	if(true == eic_TaskMonitorPageShowFlag){
	    		window.top.document.getElementById("eic_openTaskMonitorList_openDivId").style.display = "none";
	    	}else{
	    		window.top.document.getElementById("eic_openTaskMonitorList_openDivId").style.display = "block";
	    	}
	    	clearInterval(eic_timerId);
	    	eic_timerId = null;
	    }
	    },350);
	}
	if(null != eicAsynTaskCompleteCallBack){
		if(Object.prototype.toString.call(eicAsynTaskCompleteCallBack) === "[object Function]"){
			eicAsynTaskCompleteCallBack(status);//回调
			//修改状态
		}
		eicAsynTaskCompleteCallBack = null;
	}
}

/**
 * 屏蔽事件向上传播
 * @param e 事件源
 */
function eic_stopBubble(e) {
	   //如果提供了事件对象，则这是一个非IE浏览器
	   if (e && e.stopPropagation){
	     //因此它支持W3C的stopPropagation()方法
	     e.stopPropagation();
	   }else{
	     //否则，我们需要使用IE的方式来取消事件冒泡
	     window.event.cancelBubble = true;
	   }
}

/**
 * 拖拽
 * @param titleBar 表头布局
 * @param dragDiv 拖拽布局
 */
function eic_Drag(titleBar, dragDiv){
	 var Common = {
	            getEvent: function() {//ie/ff
	                if (document.all) {
	                    return window.event;
	                }
	                func = getEvent.caller;
	                while (func != null) {
	                    var arg0 = func.arguments[0];
	                    if (arg0) {
	                        if ((arg0.constructor == Event || arg0.constructor == MouseEvent) || (typeof (arg0) == "object" && arg0.preventDefault && arg0.stopPropagation)) {
	                            return arg0;
	                        }
	                    }
	                    func = func.caller;
	                }
	                return null;
	            },
	            getMousePos: function(ev) {
	                if (!ev) {
	                    ev = this.getEvent();
	                }
	                if (ev.pageX || ev.pageY) {
	                    return {
	                        x: ev.pageX,
	                        y: ev.pageY
	                    };
	                }

	                if (window.top.document.documentElement && window.top.document.documentElement.scrollTop) {
	                    return {
	                        x: ev.clientX + window.top.document.documentElement.scrollLeft - window.top.document.documentElement.clientLeft,
	                        y: ev.clientY + window.top.document.documentElement.scrollTop - window.top.document.documentElement.clientTop
	                    };
	                }
	                else if (document.body) {
	                    return {
	                        x: ev.clientX + window.top.document.body.scrollLeft - window.top.document.body.clientLeft,
	                        y: ev.clientY + window.top.document.body.scrollTop - window.top.document.body.clientTop
	                    };
	                }
	            },            
	            getItself: function(id) {
	                return "string" == typeof id ? window.top.document.getElementById(id) : id;
	            },
	            getViewportSize: { w: (window.top.innerWidth) ? window.top.innerWidth : (window.top.document.documentElement && window.top.document.documentElement.clientWidth) ? window.top.document.documentElement.clientWidth : window.top.document.body.offsetWidth, h: (window.innerHeight) ? window.top.innerHeight : (window.top.document.documentElement && window.top.document.documentElement.clientHeight) ? window.top.document.documentElement.clientHeight : window.top.document.body.offsetHeight },
	            isIE: document.all ? true : false,
	            setOuterHtml: function(obj, html) {
	                var Objrange = window.top.document.createRange();
	                obj.innerHTML = html;
	                Objrange.selectNodeContents(obj);
	                var frag = Objrange.extractContents();
	                obj.parentNode.insertBefore(frag, obj);
	                obj.parentNode.removeChild(obj);
	            }
	        }
	        
	        ///------------------------------------------------------------------------------------------------------
	        var Class = {
	            create: function() {
	                return function() { this.init.apply(this, arguments); }
	            }
	        }
	        var Drag = Class.create();
	        Drag.prototype = {
	            init: function(titleBar, dragDiv, Options) {
	                //设置点击是否透明，默认不透明
	                titleBar = Common.getItself(titleBar);
	                dragDiv = Common.getItself(dragDiv);
	                var sizeValue = 0;
	                try{
		                //ie7 sizeValue设置为1
		                if(navigator.userAgent.indexOf("MSIE") > 0 && navigator.userAgent.indexOf("MSIE 7.0") > 0)
		                { 
		                	sizeValue = 1;
		                }
	                }catch(e){}
	                this.dragArea = { maxLeft: 0, maxRight: Common.getViewportSize.w - dragDiv.offsetWidth - sizeValue, maxTop: 0, maxBottom: Common.getViewportSize.h - dragDiv.offsetHeight - sizeValue};
	                if (Options) {
	                    this.opacity = Options.opacity ? (isNaN(parseInt(Options.opacity)) ? 100 : parseInt(Options.opacity)) : 100;                    
	                    this.keepOrigin = Options.keepOrigin ? ((Options.keepOrigin == true || Options.keepOrigin == false) ? Options.keepOrigin : false) : false;
	                    if (this.keepOrigin) { this.opacity = 50; }
	                    if (Options.area) {
	                        if (Options.area.left && !isNaN(parseInt(Options.area.left))) { this.dragArea.maxLeft = Options.area.left };
	                        if (Options.area.right && !isNaN(parseInt(Options.area.right))) { this.dragArea.maxRight = Options.area.right };
	                        if (Options.area.top && !isNaN(parseInt(Options.area.top))) { this.dragArea.maxTop = Options.area.top };
	                        if (Options.area.bottom && !isNaN(parseInt(Options.area.bottom))) { this.dragArea.maxBottom = Options.area.bottom };
	                    }
	                }
	                else {
	                    this.opacity = 100, this.keepOrigin = false;
	                }
	                this.originDragDiv = null;
	                this.tmpX = 0;
	                this.tmpY = 0;
	                this.moveable = false;

	                var dragObj = this;
                    var dragCursorCss = dragDiv.style.cursor;
	                titleBar.onmousedown = function(e) {
	                    var ev = e || window.top.event || Common.getEvent();
	                    //只允许通过鼠标左键进行拖拽,IE鼠标左键为1 FireFox为0 IE9 0
	                    if (Common.isIE && (ev.button == 1 || ev.button == 0) || !Common.isIE && ev.button == 0) {
	                    }
	                    else {
	                        return false;
	                    }

	                    if (dragObj.keepOrigin) {
	                        dragObj.originDragDiv = window.top.document.createElement("div");
	                        dragObj.originDragDiv.style.cssText = dragDiv.style.cssText;
	                        dragObj.originDragDiv.style.width = dragDiv.offsetWidth;
	                        dragObj.originDragDiv.style.height = dragDiv.offsetHeight;
	                        dragObj.originDragDiv.innerHTML = dragDiv.innerHTML;
	                        dragDiv.parentNode.appendChild(dragObj.originDragDiv);
	                    }

	                    dragObj.moveable = true;
	                    dragDiv.style.zIndex = dragObj.GetZindex() + 1;
	                    var downPos = Common.getMousePos(ev);
	                    dragObj.tmpX = downPos.x - dragDiv.offsetLeft;
	                    dragObj.tmpY = downPos.y - dragDiv.offsetTop;

	                    titleBar.style.cursor = "move";
	                    dragDiv.style.cursor = "move";
	                    if (Common.isIE) {
	                        dragDiv.setCapture();
	                    } else {
	                        window.top.captureEvents(Event.mousemove);
	                    }

	                    dragObj.SetOpacity(dragDiv, dragObj.opacity);

	                    //FireFox 去除容器内拖拽图片问题
	                    if (ev.preventDefault) {
	                        ev.preventDefault();
	                        ev.stopPropagation();
	                    }

	                    window.top.document.onmousemove = function(e) {
	                        if (dragObj.moveable) {
	                            var ev = e || window.top.event || Common.getEvent();
	                            //IE 去除容器内拖拽图片问题
	                            if (document.all) //IE
	                            {
	                                ev.returnValue = false;
	                            }
	                            var movePos = Common.getMousePos(ev);
	                            dragDiv.style.right = "";
	                            dragDiv.style.bottom = "";
	                            dragDiv.style.left = Math.max(Math.min(movePos.x - dragObj.tmpX, dragObj.dragArea.maxRight), dragObj.dragArea.maxLeft) + "px";
	                            if(navigator.userAgent.indexOf("MSIE") > 0 && navigator.userAgent.indexOf("MSIE 6.0") > 0)
	    		                { 
	                            	dragDiv.style.top = (Math.max(Math.min(movePos.y - dragObj.tmpY, dragObj.dragArea.maxBottom), dragObj.dragArea.maxTop) + window.top.document.documentElement.scrollTop) + "px";
	    		                }else{
	    		                	dragDiv.style.top = Math.max(Math.min(movePos.y - dragObj.tmpY, dragObj.dragArea.maxBottom), dragObj.dragArea.maxTop) + "px";
	    		                }
	                        }
	                    };

	                    window.top.document.onmouseup = function() {
	                        if (dragObj.keepOrigin) {
	                            if (Common.isIE) {
	                                dragObj.originDragDiv.outerHTML = "";
	                            }
	                            else {
	                                Common.setOuterHtml(dragObj.originDragDiv, "");
	                            }
	                        }
	                        if (dragObj.moveable) {
	                            if (Common.isIE) {
	                                dragDiv.releaseCapture();
	                            }
	                            else {
	                                window.top.releaseEvents(dragDiv.mousemove);
	                            }
	                            dragObj.SetOpacity(dragDiv, 100);
	                            titleBar.style.cursor = "default";
	                            dragDiv.style.cursor = dragCursorCss;
	                            dragObj.moveable = false;
	                            dragObj.tmpX = 0;
	                            dragObj.tmpY = 0;
	                        }
	                    };
	                }
	            },
	            SetOpacity: function(dragDiv, n) {
	            	try{
		                if (Common.isIE) {
		                    dragDiv.filters.alpha.opacity = n;
		                }
		                else {
		                    dragDiv.style.opacity = n / 100;
		                }
	            	}catch(e){}
	            },
	            GetZindex: function() {
	                var maxZindex = 0;
	                var divs = window.top.document.getElementsByTagName("div");
	                for (z = 0; z < divs.length; z++) {
	                    maxZindex = Math.max(maxZindex, divs[z].style.zIndex);
	                }
	                return maxZindex;
	            }
	        }
	        new Drag(titleBar, dragDiv, { opacity: 100, keepOrigin: false });
}

var dyErrorDialog = null;
function openErrorDialog(url){
	if(null == dyErrorDialog){
		dyErrorDialog = cui.extend.emDialog({
			id:"dyErrorDialogId",
			title: i18n.abnormalInformation,	 
			src: url,
			width: 400,
			height: 80,
			buttons:[{
				name:i18n.cancel, 
				disable:false,
				handler:function(){
					dyErrorDialog.hide();
				} 
			}]
	     });
	 }
	dyErrorDialog.show(url);
}

//定义window.onload方法的aop拦截对象，避免标签里直接用window.onlaod触发右下角图标显示、多个标签引起多个window.onload被覆盖或浏览器不兼容问题
var eicWindowOnLoadAspects = function(){};
//实现after方法 在window.onload执行之后调用
eicWindowOnLoadAspects.prototype={
  after:function(target,method,advice){
	var original = target[method];
	target[method] = function(){
		//arguments函数参数对象
		original.apply(target,arguments);
		(advice)();
	};
	return target;
  }		
};

/**
 * 页面加载完后打开右下角任务管理打开小图标
 * @param url 导入导出监控页面url
 */
function initOpenBottomImage(url){
	if(window.top!=window){
		setTimeout(function(){
			window.top.initOpenBottomImage(url);
		},5000);
		return;
	}
	var exit = false;
	if(window.onload){
	  var funcExit = /initOpenBottomImage/;
	  if(true == funcExit.test(window.onload)){
		exit = true;
	  }
	}
	if(true == exit){
	  openTaskMonitorList(url);
	}else{
	   try{
			if (document.all){
	   		if (document.readyState=="complete"){
		        openTaskMonitorList(url);
				}else{
				   document.onreadystatechange = function(){
				    if (document.readyState == "complete"){
				        openTaskMonitorList(url);
				    }
				   }
				}
			  //window.attachEvent('onload',function(){
				  //openTaskMonitorList(url);
			  //});//IE中
			}
			else{
	   		if (document.readyState=="complete"){
		        openTaskMonitorList(url);
				}else{
				   document.onreadystatechange = function(){
				    if (document.readyState == "complete"){
				        openTaskMonitorList(url);
				    }
				   }
				}
			  //window.addEventListener('load',function(){
				  //openTaskMonitorList(url);
			  //},false);//firefox
			}
		}catch(e){
			var eicWindowOnLoadAspectsObj = new eicWindowOnLoadAspects();
			if(!window.onload){
				window.onload = function(){};
			}
			eicWindowOnLoadAspectsObj.after(window, "onload", function(){
				openTaskMonitorList(url);
			});
		}
	}
}
/**
 * 异步导入导出任务执行完成回调
 * @return
 */
function eic_asynTaskCompleteCallBack(callback){
	if(callback && Object.prototype.toString.call(callback) === "[object Function]"){
		eicAsynTaskCompleteCallBack = callback;
    }
}