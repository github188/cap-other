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
    <title>open子页面3</title>
    <link rel="stylesheet" href="lib/cui/themes/default/css/comtop.ui.min.css"/>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/top/js/jquery.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/cui/js/cui.utils.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/jct/js/jct.js"></script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <script type="text/javascript">
	    var pageStorage = new cap.PageStorage("com.comtop.user");
		var pageObj = pageStorage.get("globalPage");//getGlobalData();	
    	function getIframeChildrenPageDate(){
    		var page = pageStorage.get("globalPage");
    		console.log(page);
    	}
    	
    	//监听变量变化后通知页面基本信息
        function watchChange(){
    		//不传递数据，被通知的页面直接拿本地数据即可。
       		window.opener.opener.opener.parent.sendMessage('pageInfoFrame',{type:'changeInfo',data:null});//
       		cap.MessageManager.getInstance("sendMessage").sendMessage('pageInfoFrame',{type:'changeInfo',data:null});
       		//window.opener.opener.opener.postMessage({type:'changeInfo',data:null},"*");
        	cap.addObserve(pageObj,watchChange);
    	}
        cap.addObserve(pageObj,watchChange);
    	
    	
    	jQuery(document).ready(function(){
    		jQuery("#test1").attr("src","iframe2.jsp");
 	    });
    	
    	angular.module('myapp', []).controller('testController', function ($scope) {
	  		$scope.pageObj = pageObj;
	  	});
    	
    	
    	
    </script>
</head>
<body ng-controller="testController">
     <button onclick="getIframeChildrenPageDate()">从open子页面3上去取数据</button>
     <input type='text' ng-model="pageObj.pageInfo.pageCharset" />
     <hr>
        pageCharset：{{pageObj.pageInfo.pageCharset}}
     <!-- <iframe id="test1"   frameborder="0"  style="height: 100%; width: 100%; position: static; left: 0px; top: 0px;display:block"></iframe> -->
     
</body>
</html>