
/**
 * 页面加载完后打开右下角任务管理打开小图标
 * @param url 元素一致性监控页面url
 */
function initOpenConsistencyImage(url){
   try{
		if (document.all){
   		if (document.readyState=="complete"){
	        openConsistencyCheckResultList(url);
			}else{
			   document.onreadystatechange = function(){
			    if (document.readyState == "complete"){
			        openConsistencyCheckResultList(url);
			    }
			   }
			}
		  
		}
		else{
   		if (document.readyState=="complete"){
	        openConsistencyCheckResultList(url);
			}else{
			   document.onreadystatechange = function(){
			    if (document.readyState == "complete"){
			        openConsistencyCheckResultList(url);
			    }
			   }
			}
		  
		}
	}catch(e){
		var ccrWindowOnLoadAspectsObj = new ccrWindowOnLoadAspects();
		if(!window.onload){
			window.onload = function(){};
		}
		ccrWindowOnLoadAspectsObj.after(window, "onload", function(){
			openConsistencyCheckResultList(url);
		});
	}

}

//定义window.onload方法的aop拦截对象，避免标签里直接用window.onlaod触发右下角图标显示、多个标签引起多个window.onload被覆盖或浏览器不兼容问题
var ccrWindowOnLoadAspects = function(){};
//实现after方法 在window.onload执行之后调用
ccrWindowOnLoadAspects.prototype={
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


var consistencyCheckResultDialog = null;
var ccr_openDiv = null;
var ccr_TaskMonitorPageShowFlag = false;
var ccr_timerId = null;
/**
 * 打开任务监控右下角弹窗口 1创建是在entityMain.jsp 2点击触发是在
 * @param url 导入导出监控界面url
 */
function openConsistencyCheckResultList(url){
	 url = url.replace("&amp;","&");//top平台对传递的数据会转码
	 
	 
	 var reInit = /init=true/;
	 var initFlag = false;
	 if(true == reInit.test(url)){
		 initFlag = true;
		 url = url.replace(reInit,"");
	 }
	 //计算错误个数
	 var totalNum = currentDependOnData.length+dependOnCurrentData.length;
	 //如果没有错误 则隐藏div和dialog
	 if (totalNum==0) {
	 	
	 	if (ccr_TaskMonitorPageShowFlag) {
	 		consistencyCheckResultDialog.hide();

	 	}
	 	window.document.getElementById("eic_openConsistencyCheckResultList_openDivId").style.display = "none";
	 	return ;
	 }
	 var paramUrl = url;
	 url = url + "&pageSize=5&curtime="+Math.random();
	 if(null == ccr_openDiv){
		 var html = '<div id="eic_openConsistencyCheckResultList_openDivId" class="cui-dialog-container" style="width: 130px; right: 0px; bottom: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; display: block; filter: alpha(opacity=100); position: fixed; z-index: 10002; cursor: move; opacity: 1; background-color: rgb(64, 142, 230); border-top-color: #408ee6; border-right-color: #408ee6; border-bottom-color: #408ee6; border-left-color: #408ee6;">';
		 html = html + '<div id="ccr_TaskMonitorSpanTitId" onclick="openConsistencyCheckResultList(\''+paramUrl+'\')" style="filter:alpha(opacity=100);opacity:1;cursor: pointer;width: 75%;height: 23px;margin-top: 0px;padding-top:5px;" class="dialog-title">\u4e00\u81f4\u6027\u6548\u9a8c('+totalNum+')</div>';
		 html = html + '</div>';
		 var webRootArr = url.split("/");
		 var webRoot = "/"+webRootArr[1];
		 ccr_openDiv = document.createElement("div");
		 ccr_openDiv.innerHTML = html;
		 window.document.body.appendChild(ccr_openDiv);
		 eic_Drag("eic_openConsistencyCheckResultList_openDivId","eic_openConsistencyCheckResultList_openDivId");
		 //取值设置，让浏览器进行重新渲染
		 var objDivTemp = window.document.getElementById("eic_openConsistencyCheckResultList_openDivId");
		 objDivTemp.style.right = "0px";
		 objDivTemp.style.bottom = "0px";
		 objDivTemp.style.left =  "";
		 objDivTemp.style.top = "";
		 if (document.all){
	  		  window.attachEvent('onresize',function(){
	  		  var objDiv = window.document.getElementById("eic_openConsistencyCheckResultList_openDivId");
	   	  		  objDiv.style.right = "0px";
	   	  		  objDiv.style.bottom = "0px";
	   	  		  objDiv.style.left =  "";
	   	  		  objDiv.style.top = "";
   	  		  eic_Drag("ccr_TaskMonitorSpanTitId","eic_openConsistencyCheckResultList_openDivId");
	  		  });//IE中
	  		}
	  		else{
	  		  window.addEventListener('resize',function(){
	  			var objDiv = window.document.getElementById("eic_openConsistencyCheckResultList_openDivId");
	    	  		objDiv.style.right = "0px";
	    	  		objDiv.style.bottom = "0px";
	    	  		objDiv.style.left =  "";
	    	  		objDiv.style.top = "";
	    	  	eic_Drag("ccr_TaskMonitorSpanTitId","eic_openConsistencyCheckResultList_openDivId");
	  		  },false);//firefox
	  	}
		 //先计算好坐标后在隐藏
		 window.document.getElementById("eic_openConsistencyCheckResultList_openDivId").style.display = "none";
	 }else{
	 	window.document.getElementById("ccr_TaskMonitorSpanTitId").innerHTML = '\u4e00\u81f4\u6027\u6548\u9a8c('+totalNum+')';
	 }
	 if(null == consistencyCheckResultDialog){
		 consistencyCheckResultDialog = cui.dialog({
		 	 id:"consistencyCheckResultDialogId",
	         title: "\u4e00\u81f4\u6027\u6548\u9a8c",
	         src:url,
	         left: "100%",
	         top: "100%",
	         width: 465,
		     height: 388,
	         draggable: false,
	         modal: false,
	         beforeClose:function(){
			  window.document.getElementById("eic_openConsistencyCheckResultList_openDivId").style.display = "block";
			  return true;
		     },
		     onClose:function(){
		    	 ccr_TaskMonitorPageShowFlag = false;
		     }
	     });
		 try{
		   var colseBtn = (window.document.getElementById("consistencyCheckResultDialogId")).getElementsByTagName("a")[0];
		   colseBtn.setAttribute("title","\u6700\u5c0f\u5316");
		 }catch(e){}
		 //解决第一次打开空白问题
		 consistencyCheckResultDialog.show(url);
		 consistencyCheckResultDialog.hide();//关闭时会自动打开div 故再次关闭 最后显示
		 window.document.getElementById("eic_openConsistencyCheckResultList_openDivId").style.display = "none";
	 }else{
	 	consistencyCheckResultDialog.reload(url);
	 }
	 if(false == initFlag){//表示是从DIV打开
		 window.document.getElementById("eic_openConsistencyCheckResultList_openDivId").style.display = "none";
		 window.document.getElementById("eic_openConsistencyCheckResultList_openDivId").style.backgroundColor = "#408ee6";
		 window.document.getElementById("eic_openConsistencyCheckResultList_openDivId").style.borderColor = "#408ee6";
		 consistencyCheckResultDialog.show();
		 ccr_TaskMonitorPageShowFlag = true;
	 }else{//从效验按钮打开 增加判断 如果div已显示则直接打开dialog  否则显示div
	 	if (window.document.getElementById("eic_openConsistencyCheckResultList_openDivId").style.display == "block") {
	 		window.document.getElementById("eic_openConsistencyCheckResultList_openDivId").style.display = "none";
	 		consistencyCheckResultDialog.show();
	 		ccr_TaskMonitorPageShowFlag = true;	 
	 	}else{
	 		if (ccr_TaskMonitorPageShowFlag) {
	 			consistencyCheckResultDialog.show(url);
	 		}else{
	 			window.document.getElementById("eic_openConsistencyCheckResultList_openDivId").style.display = "block";
	 		}
	 		
	 	}
		 initFlag = false;
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

	                if (window.document.documentElement && window.document.documentElement.scrollTop) {
	                    return {
	                        x: ev.clientX + window.document.documentElement.scrollLeft - window.document.documentElement.clientLeft,
	                        y: ev.clientY + window.document.documentElement.scrollTop - window.document.documentElement.clientTop
	                    };
	                }
	                else if (document.body) {
	                    return {
	                        x: ev.clientX + window.document.body.scrollLeft - window.document.body.clientLeft,
	                        y: ev.clientY + window.document.body.scrollTop - window.document.body.clientTop
	                    };
	                }
	            },            
	            getItself: function(id) {
	                return "string" == typeof id ? window.document.getElementById(id) : id;
	            },
	            getViewportSize: { w: (window.innerWidth) ? window.innerWidth : (window.document.documentElement && window.document.documentElement.clientWidth) ? window.document.documentElement.clientWidth : window.document.body.offsetWidth, h: (window.innerHeight) ? window.innerHeight : (window.document.documentElement && window.document.documentElement.clientHeight) ? window.document.documentElement.clientHeight : window.document.body.offsetHeight },
	            isIE: document.all ? true : false,
	            setOuterHtml: function(obj, html) {
	                var Objrange = window.document.createRange();
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
	                    var ev = e || window.event || Common.getEvent();
	                    //只允许通过鼠标左键进行拖拽,IE鼠标左键为1 FireFox为0 IE9 0
	                    if (Common.isIE && (ev.button == 1 || ev.button == 0) || !Common.isIE && ev.button == 0) {
	                    }
	                    else {
	                        return false;
	                    }

	                    if (dragObj.keepOrigin) {
	                        dragObj.originDragDiv = window.document.createElement("div");
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
	                        window.captureEvents(Event.mousemove);
	                    }

	                    dragObj.SetOpacity(dragDiv, dragObj.opacity);

	                    //FireFox 去除容器内拖拽图片问题
	                    if (ev.preventDefault) {
	                        ev.preventDefault();
	                        ev.stopPropagation();
	                    }

	                    window.document.onmousemove = function(e) {
	                        if (dragObj.moveable) {
	                            var ev = e || window.event || Common.getEvent();
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
	                            	dragDiv.style.top = (Math.max(Math.min(movePos.y - dragObj.tmpY, dragObj.dragArea.maxBottom), dragObj.dragArea.maxTop) + window.document.documentElement.scrollTop) + "px";
	    		                }else{
	    		                	dragDiv.style.top = Math.max(Math.min(movePos.y - dragObj.tmpY, dragObj.dragArea.maxBottom), dragObj.dragArea.maxTop) + "px";
	    		                }
	                        }
	                    };

	                    window.document.onmouseup = function() {
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
	                                window.releaseEvents(dragDiv.mousemove);
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
	                var divs = window.document.getElementsByTagName("div");
	                for (z = 0; z < divs.length; z++) {
	                    maxZindex = Math.max(maxZindex, divs[z].style.zIndex);
	                }
	                return maxZindex;
	            }
	        }
	        new Drag(titleBar, dragDiv, { opacity: 100, keepOrigin: false });
}






/**
 * 定位到具体的tab页，以后扩展
 * @tabId tab对应的ID 
 */
function jumpToTab(tabId){
	   if(tabId){tabClick(tabId);}
}