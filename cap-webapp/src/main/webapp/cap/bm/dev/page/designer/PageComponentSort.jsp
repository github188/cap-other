<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<html ng-app="uisortApp">
<head>
<meta http-equiv="Content-Type" content="text/html; UTF-8">
<title>组件排序</title>
<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"></top:link>
<top:link href="/cap/bm/dev/page/designer/css/table-layout.css"></top:link>
</head>
<body ng-controller="uisortCtr">
<div  class="cap-area" style="text-align: left;">
	<div class="clearfix" style="margin:5px; ">
		<div style="float: left;">
			<span uitype="button" label="向上" on_click="moveUp"></span>
			<span uitype="button" label="向下" on_click="moveDown"></span>
		</div>
		<div style="float: right;">
			<span uitype="button" label="确定" button_type="green-button" on_click="okaction"></span>
			<span uitype="button" label="取消" on_click="closewin"></span>
		</div>
	</div>
	<div style="padding:5px;">
		<span id="listbox" uitype="ListBox" multi=true value_field="id" label_field="title" width="250" height="440" hei datasource="getDataByLoad" ></span>
	</div>
</div>

<top:script  src="/cap/bm/common/base/js/angular.js"></top:script>	
<top:script src="/cap/bm/common/cui/js/comtop.ui.all.js"></top:script>
<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
<script type="text/javascript">
	var $ = comtop.cQuery;
</script>
<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
<top:script src="/cap/bm/dev/page/designer/js/utils.js"></top:script>
<top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
<script type="text/javascript">
	var _cdata = window.opener._cdata;
	var id =URL.dataId;
    var ntable = _cdata.getMapData().get(id);
    var getDataByLoad = ntable.children
    comtop.UI.scan();
    
    function moveUp(){
    	cui("#listbox").moveUp();
    }
    function moveDown(){
    	cui("#listbox").moveDown();
    }
    /* function moveRow(){
    	cui("#listbox").moveRow()
    } */
    function okaction(){
    	var uis = cui("#listbox").getAllRows();
    	
    	_.forEach(uis,function(n){
    		_cdata.delete(n.id)
    		_cdata.insert(ntable.id,n);
    	})
    	window.close();
    }
    function closewin(){
    	window.close();
    }
	angular.module("uisortApp",["cui"]).controller("uisortCtr",["$scope",function($scope){
		
	}])
	
</script>
</body>
</html>