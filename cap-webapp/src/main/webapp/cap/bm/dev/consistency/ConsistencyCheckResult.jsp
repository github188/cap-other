<%
    /**********************************************************************
	 * 一致性检查结果页面
	 * 2016-6-23  刘城 新建
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<html>
<head>
<meta charset="UTF-8">
<link rel="shortcut icon" href="${pageScope.cuiWebRoot}/cap/ptc/index/image/biz_entity.png">
<title>一致性检查</title>
<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
<top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
<top:script src="/cap/bm/dev/page/uilibrary/js/component.js"></top:script>
<top:script src="/cap/dwr/engine.js"></top:script>
<top:script src="/cap/dwr/util.js"></top:script>
<top:script src="/cap/dwr/interface/EntityFacade.js"></top:script>
<top:script src="/cap/dwr/interface/PageFacade.js"></top:script>
<style type="text/css">
    .cui-tab .cui-tab-content {
        border-bottom: 0;
        border-left: 0;
        border-right: 0;
        padding: 0;
    }
    .cui-tab ul.cui-tab-nav{
        padding-left:10px;
    }
</style>
<script type="text/javascript">
	
	var funcId = "${param.packageId}";
	var checkType = "${param.checkType}";
	var tabs = [ {
        title: "我依赖的",
        html: document.getElementById("currentDependOn")
    },{
        title: "依赖我的",
        html: document.getElementById("dependOnCurrent")
    }];

	jQuery(document).ready(function() {
		comtop.UI.scan();
		if(window.parent.currentDependOnData.length==0){
			cui("#dt1").switchTo(1);
		}
		//console.log(cui("#currentDependOnGrid").getRowsDataByPK("0").id);
	});

	/**
	*初始化grid数据
	*/
	function initCurrentDependOnData(gridObj, query){
		var reDataArr = window.parent.currentDependOnData;
		var sourceData = [];
		//根据query.pageSize 和pageNo 截取reDataArr传递数据
		//只需要获取开始的下表和最后一个的下标 1 5
		var startIndex = query.pageSize*(query.pageNo-1);
		var endIndex = query.pageSize*query.pageNo-1;
		for (var i = 0; i < reDataArr.length; i++) {
			if (i>=startIndex&&i<=endIndex) {
				sourceData.push(reDataArr[i]);
			}
		}
		gridObj.setDatasource(sourceData,reDataArr.length);
	}


	/**
	*初始化grid数据
	*/
	function initDependOnCurrentData(gridObj, query){
		var reDataArr = window.parent.dependOnCurrentData;
		var sourceData = [];
		var startIndex = query.pageSize*(query.pageNo-1);
		var endIndex = query.pageSize*query.pageNo-1;
		for (var i = 0; i < reDataArr.length; i++) {
			if (i>=startIndex&&i<=endIndex) {
				sourceData.push(reDataArr[i]);
			}
		}
		
		gridObj.setDatasource(sourceData,reDataArr.length);
		
	}
	/**
	*确定当前链接是定位到什么地方
	*@operateType 对应原有数据的type
	*@type 我依赖的和依赖我的
	@id rowdata的主键
	*/
	function jumpTo(operateType,type,id){
		var attrMap;
		var jumpToAttr =operateType.substr(0,4);
		if (type=="depend") {
			attrMap = cui("#currentDependOnGrid").getRowsDataByPK(id)[0].attrMap;
			
			if (jumpToAttr=="page") {
				toPage(operateType,attrMap);
			}else{
				toEntity(operateType,attrMap);
			}
		}else{
			attrMap = cui("#dependOnCurrentGrid").getRowsDataByPK(id)[0].attrMap;
			
			if (jumpToAttr=="page") {
				toLayoutOutPage(operateType,attrMap);
			}else{
				toLayoutOutEntity(operateType,attrMap);
			}
		}
	}
	
	/**
	*根据类型打开外部页面 modelId
	*/
	function toLayoutOutPage(operateType,attrMap){
		var url = "<%=request.getContextPath() %>/cap/bm/dev/page/designer/PageMain.jsp?modelId="+attrMap.modelId+"&operateType="+getPageRelationByOperateType(operateType);
		
		if (window.parent) {
			window.parent.open(url);
		}
		
	}
	

	
	/**
	*根据类型打开到外部页面
	*entityId
	*/
	function toLayoutOutEntity(operateType,attrMap){
		var	url = "<%=request.getContextPath() %>/cap/bm/dev/entity/EntityMain.jsp?modelId="+attrMap.modelId+"&operateType="+getEntityRelationByOperateType(operateType);
		if (window.parent) {
			window.parent.open(url);
		}
		
	}
	
	//根据operateType获取pageTab的id
	function getPageRelationByOperateType(operateType){
		var pageType ;
		if(operateType=="pageBaseInfo"){
			pageType="pageInfo";
		}else if (operateType=="pageLayout") {
			pageType="desinger";
		}else if (operateType=="pageRight") {
			pageType="pageState";
		}else if (operateType=="pageDataStore") {
			pageType="dataModel";
		}else if (operateType=="pageAction") {
			pageType="action";
		}
		return pageType;
	}
	
	//根据operateType获取entityTab的id
	function getEntityRelationByOperateType(operateType){
		var entityType;
		if(operateType=="entityBaseInfo"){
			entityType="entity";
		}else if (operateType=="entityMethod") {
			entityType="entityMethod";
		}else if (operateType=="entityAttribute") {
			entityType="entityAttribute";
		}else if (operateType=="entityRelation") {
			entityType="relationship";
		}
		return entityType;
	}

	/**
	*定位到page
	*@operateType 操作类型
	*@attrMap 属性map
	*/
	function toPage(operateType,attrMap){
		var pageType =getPageRelationByOperateType(operateType);
		window.parent.jumpToTab(pageType);
	}

	
	/**
	*定位到entity
	*@operateType 操作类型
	*@attrMap 属性map
	*/
	function toEntity(operateType,attrMap){
		var entityType = getEntityRelationByOperateType(operateType);
		window.parent.jumpToTab(entityType);
	}
	
	/**
	 *列渲染函数
	 *@data grid对象
	 *@field td元素属性
	 */
	function columnRender(data,field){
		if(field == 'type'){
			//替换显示
			var operateType = data["type"];
			return "<a class='a_link'    onclick='javascript:jumpTo(\""+data["type"]+ "\",\"depend\",\""+data["id"]+"\");'>操作</a>";
		}
	}

	/**
	 *列渲染函数
	 *@data grid对象
	 *@field td元素属性
	 */
	function dependedColumnRender(data,field){
		if(field == 'type'){
			//替换显示
			var operateType = data["attrMap"];
			return "<a class='a_link'    onclick='javascript:jumpTo(\""+data["type"]+ "\",\"depended\",\""+data["id"]+"\");'>操作</a>";
		}
	}
	
	
</script>
<title>元数据效验结果</title>
</head>
<body>
	<div id="dt1" uitype="tab" tabs="tabs">
	<div id="currentDependOn" style="display:block" data-options='{"title":"我依赖的"}'>
		<div  style="border-top:3px solid #4585e5">
			<table id="currentDependOnGrid" uitype="Grid" class="cui_grid_list" datasource="initCurrentDependOnData" primarykey="id" gridheight="auto" gridwidth="430"
			oddevenrow="true" colrender="columnRender" pagesize_list=[5,10,20] ellipsis="true" selectrows="no">
				<thead>
					<tr>
						<th bindName="message" renderStyle="text-align: center;" sort="false">问题描述</th>
						<th bindName="type" renderStyle="text-align: center;" style="width:60px" sort="false">操作</th>
					</tr>
				</thead>
			</table>
		</div>
		
	</div>
	<div id="dependOnCurrent" data-options='{"title":"依赖我的"}'>
		<div  style="border-top:3px solid #4585e5">
			<table id="dependOnCurrentGrid" uitype="Grid" class="cui_grid_list" datasource="initDependOnCurrentData" primarykey="id" gridheight="auto" gridwidth="430"
			oddevenrow="true" colrender="dependedColumnRender" pagesize_list=[5,10,20] ellipsis="true" selectrows="no">
				<thead>
					<tr>
						<th bindName="message" renderStyle="text-align: center;" sort="false">问题描述</th>
						<th bindName="type" renderStyle="text-align: center;" style="width:60px" sort="false">操作</th>
					</tr>
				</thead>
			</table>
		</div>
		
	</div>
</body>
</html>