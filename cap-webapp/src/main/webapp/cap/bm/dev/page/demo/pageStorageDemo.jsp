<%
/**********************************************************************
* 示例页面
* 2015-5-13 郑重 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app="myapp">
<head>
    <meta charset="UTF-8">
    <title>数据页面存储方案</title>
    <link rel="stylesheet" href="lib/cui/themes/default/css/comtop.ui.min.css"/>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/top/js/jquery.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/base/js/comtop.cap.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/cui/js/cui.utils.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/jct/js/jct.js"></script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/rt/common/base/js/comtop.cap.rt.js"></top:script>
    <script type="text/javascript">
    var key = 'com.comtop.user.globalPage';//pageId
    window[key] = {
			"expression":['exp4','exp5','exp6','exp7'],
			"pageInfo":{
				'pageCharset':'UTF-8',
				'includeFile':[
				               'page/demo/1.js',
				               'page/demo/2.jsp',
				               'page/demo/3.css'
				               ],
						},
			"screenSize":'1024*768'
			};
    	
	    jQuery(document).ready(function(){
	 	   jQuery("#tabBodyDiv").css("height",$(window).height()-61);
	        comtop.UI.scan();
	        initIframe();
	    });
        
        
	  	//初始化iframe
	    function initIframe(){
// 	 	   var attr="modelId="+pageId+"&packageId="+packageId+"&modelPackage="+modelPackage;
	        jQuery("#pageInfoFrame").attr("src","iframe1.jsp");
	        /* jQuery("#desingerFrame").attr("src","PageDesigner.jsp?"+attr);
	        jQuery("#pageStateFrame").attr("src","PageState.jsp?"+attr);
	        jQuery("#dataModelFrame").attr("src","PageDataStore.jsp?"+attr);
	        jQuery("#actionFrame").attr("src","PageAction.jsp?"+attr); */
	    }
	  	function getData(){
	  		console.log(window[key]);
	  	}
	  	
	  	angular.module('myapp', []).controller('testController', function ($scope) {
	  		scope=$scope;
	  		$scope.globalPage = window[key];
	  	});
	  	var scope=null;
	  	function messageHandle(e) {
	    	if(e.data.type=="changeInfo123"){
    			scope.globalPage=window[key];//e.data.data;
        		scope.$digest();
	    	}
	    }
	    window.addEventListener("message", messageHandle, false); 
	  	//跨页面发送消息
	    function sendMessage(frameId,data){
	    	//不使用传递的数据，直接拿本window的数据即可。
	  		data.data = window[key];
	 	   jQuery("#"+frameId)[0].contentWindow.postMessage(data, '*');
	    }
	  	
    </script>
</head>
<body style="background-color:#f5f5f5"  ng-controller="testController">
 	<div class="cui-tab" style="border:solid 1px #e6e6e6;background:#f5f5f5">
 		<span class="tabs-scroller-left cui-icon" style="display: none;"></span>
 		<span class="tabs-scroller-right cui-icon" style="display: none; right: 22px;"></span>
        <div class="cui-tab-head" style="margin: 0px;font-size:11pt">
        	<table style="width:100%;border-spacing: 0px">
        		<tr>
        			<td style="text-align:left;padding:0px">
        				<ul class="cui-tab-nav" style="height:40px;width:100%;padding:0px 0 0 0px;background-color:#f5f5f5">
			                <li id="pageInfoTab" title="页面信息" class="cui-active" style="width:65px;height:40px;line-height:40px;margin-left:8px" onclick="">
			                	<span class="cui-tab-title">页面信息</span>
			                    <a href="#" class="cui-tab-close cui-icon" style="display:none;"></a>
			                </li>
			                <!-- <li id="desingerTab" title="设计器" class="" style="width:65px;height:40px;line-height:40px;background-color:#f5f5f5" onclick="tabClick('desinger')">
			                	<span class="cui-tab-title">设计器</span>
			                	<a href="#" class="cui-tab-close cui-icon" style="display:none;"></a>
			                </li>
			                <li id="pageStateTab" title="控件状态" class="" style="width:65px;height:40px;line-height:40px;background-color:#f5f5f5" onclick="tabClick('pageState')">
			                	<span class="cui-tab-title">控件状态</span>
			                	<a href="#" class="cui-tab-close cui-icon" style="display:none;"></a>
			                </li>
			                <li id="dataModelTab" title="数据模型" class="" style="width:65px;height:40px;line-height:40px;background-color:#f5f5f5" onclick="tabClick('dataModel')">
			                	<span class="cui-tab-title">数据模型</span>
			                	<a href="#" class="cui-tab-close cui-icon" style="display:none;"></a>
			                </li>
			                <li id="actionTab" title="行为" class="" style="width:65px;height:40px;line-height:40px;background-color:#f5f5f5" onclick="tabClick('action')">
			                	<span class="cui-tab-title">行为</span>
			                	<a href="#" class="cui-tab-close cui-icon" style="display:none;"></a>
			                </li> -->
			            </ul>
        			</td>
        			<td style="text-align:left;width:450px;padding-right:0px">
        				<span id="id11" uitype="Button" label="获取GlobalPage" icon="file-o" onclick="getData()"></span>
        				<!-- <span id="save" uitype="Button" label="保存" icon="file-text-o" onclick="save()"></span>
        				<span id="saveTemplate" uitype="Button" label="保存为模板" onclick="selectTemplate()"></span>
        				<span id="insert" uitype="Button" label="代码生成"onclick="generateById()"></span>
        				<span id="insert" uitype="Button" label="预览" icon="desktop" onclick="preview()"></span>
			        	<span id="return" uitype="Button" label="返回" onclick="back()"></span> -->
			        	<!-- <input type='text' ng-model="charset"/> -->
			        	{{globalPage.pageInfo.pageCharset}}
        			</td>
        		</tr>
        	</table>
        </div>
        <div class="cui-tab-content"  id="tabBodyDiv" style="border-top:3px solid #4585e5">
        	<iframe id="pageInfoFrame"   frameborder="0"  style="height: 100%; width: 100%; position: static; left: 0px; top: 0px;display:block"></iframe>
        	<!-- <iframe id="desingerFrame"   frameborder="0"  style="height: 100%; width: 100%; position: static; left: 0px; top: 0px;display:none"></iframe>
        	<iframe id="pageStateFrame"   frameborder="0"  style="height: 100%; width: 100%; position: static; left: 0px; top: 0px;display:none"></iframe>
        	<iframe id="dataModelFrame"   frameborder="0"  style="height: 100%; width: 100%; position: static; left: 0px; top: 0px;display:none"></iframe>
        	<iframe id="actionFrame"  frameborder="0"  style="height: 100%; width: 100%; position: static; left: 0px; top: 0px;display:none"></iframe> -->
        </div>
   	</div>
</body>
</html>