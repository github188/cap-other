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
    <title>iframe子页面1</title>
    <link rel="stylesheet" href="lib/cui/themes/default/css/comtop.ui.min.css"/>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/top/js/jquery.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/base/js/comtop.cap.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/cui/js/cui.utils.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/jct/js/jct.js"></script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/rt/common/base/js/comtop.cap.rt.js"></top:script>
    <script type="text/javascript">
    	var pageStorage = new cap.PageStorage("com.comtop.user");
    	var pageObj = pageStorage.get("globalPage");//getGlobalData();
    	function getIframeChildrenPageDate(){
    		var page = pageStorage.get("globalPage");//getGlobalData();
    		page.pageInfo.pageCharset='gbk';
    		console.log(page);
    	}
    	
    	function openAWindow(){
    		window.parent.open ('openwindow1.jsp','iframe1','height=600,width=800,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
    	}
    	
    	var scope=null;
	  	function messageHandle(e) {
	    	//就算不进行处理，openwindow3改变数据，主窗口数据也会同步。
	  		if(e.data.type=="changeInfo"){
	    			//直接degest，无需传值过来
	    			//console.log(pageObj);
	    			//pageObj = data.data;
	        		scope.$digest();
	    	} 
	    }
	    window.addEventListener("message", messageHandle, false);
    	
    	angular.module('myapp', []).controller('testController', function ($scope) {
	  		scope=$scope;
	  		$scope.pageObj = pageObj;
	  	});
    	
    	//监听变量变化后通知页面基本信息
        function watchChange(){
    		//不传递数据，被通知的页面直接拿本地数据即可。
//        		window.opener.opener.opener.parent.sendMessage('pageInfoFrame',{type:'changeInfo',data:null});//
       		window.parent.postMessage({type:'changeInfo123',data:null},"*");
        	cap.addObserve(pageObj,watchChange);
    	}
        cap.addObserve(pageObj,watchChange);
    	
    </script>
</head>
<body ng-controller="testController">
     <button onclick="getIframeChildrenPageDate()">从iframe子页面1上去取数据</button>
     <button onclick="openAWindow()">open一个子页面</button>
     <hr>
     {{pageObj.pageInfo.pageCharset}}
     <hr>
     输入进行改变（同步主窗口）：<input type='text' ng-model="pageObj.pageInfo.pageCharset"/>
     
</body>
</html>