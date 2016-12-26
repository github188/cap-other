<%
  /**********************************************************************
	* 查询建模 实体属性选择 
	* 2016-07-28  刘城 新增
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<%@ page import="java.util.*" %>


<!doctype html>
<html ng-app="fromTableApp">
<head>
<title>实体属性选择主页面</title>
    <top:link href="/cap/bm/common/top/css/top_base.css"></top:link>
    <top:link href="/cap/bm/common/top/css/top_sys.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/dwr/engine.js"></top:script>
    <top:script src="/cap/dwr/util.js"></top:script>
    <top:script src="/cap/dwr/interface/SystemModelAction.js"></top:script>
    <top:script src="/cap/dwr/interface/EntityFacade.js"></top:script>

    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
	<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
</head>
<style>
.top_header_wrap {
	padding-right: 5px;
}
</style>
<body>
	<div uitype="Borderlayout"  id="body"  is_root="true" >
		<div id="leftMain" position="left" width="200"  collapsable="true" show_expand_icon="true">       
	        <table width="95%" style="margin-left: 10px">
				<tr id="tr_moduleTree">
					<td>
	                    <div id="moduleTree" uitype="Tree" children="initData" on_click="treeClick"
	                    on_dbl_click="treeOndbClick" min_expand_level="1"  on_lazy_read="loadNode"  click_folder_mode="1"></div>
	                </td>
				</tr>
			</table>
         </div>
         
         <div id="centerMain" position ="center" width="200" ng-controller="fromTableCtrl">
			<table class="custom-grid" width="100%" >
				<thead>
					<tr>
						<th >已选实体</th>
					</tr>
				</thead>
				<tbody>
					<tr ng-repeat="tableAttrVo in tableAttributes track by $index">
						<td style="cursor:pointer;text-align:left;background-color:{{selectEntity==tableAttrVo ? '#99ccff':'#ffffff'}}"  ng-click="nodeOpen(tableAttrVo.entityId,tableAttrVo.tableAlias,tableAttrVo)">
							<a>{{tableAttrVo.tableName}}&nbsp;&nbsp;{{tableAttrVo.tableAlias}}</a>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		 <div id="rightMain" position ="right" width="650">
			
		</div>
	</div>


<script type="text/javascript">
var selectNodeId = "";
var selectNodeTitle = "";
var selectNodeType = true;
var selectNodeData = {};
var modelId = "${param.modelId}";
var packageId = "${param.packageId}";
var actionType = "${param.actionType}";//区分是从SELECT进来还是WHERE GROPU ORDER
var extras = window.parent.scope.selectEntityMethodVO.queryModel;
//var tableAliasDataArr = [];
var selectAttrDataArr = [];
var initCount = 0; // 0:代表页面初始化 ，非0 : 代表不是页面初始化，  解决节点展开刷新右侧页面问题 add by linyuqian 20160829

var scope = {};

angular.module('fromTableApp', ["cui"]).controller('fromTableCtrl', function ($scope, $compile) {
	//数据模型属性（左侧表格数据源）
	$scope.tableAttributes=[];
	scope=$scope;

	//初始化已选的FROM 实体table信息
    $scope.initTableAttributes=function(){
    	
    	var allTableAlisaArr = getAllTableAlias();
    	for (var i = 0; i < allTableAlisaArr.length; i++) {
    		var objTemp =  {tableAlias:allTableAlisaArr[i].subTableAlias,tableName:allTableAlisaArr[i].subTableName,entityId:allTableAlisaArr[i].entityId};
    		$scope.tableAttributes.push(objTemp);
    	}
    }

    $scope.nodeOpen = function(modelId,tableAlias,tableAttrVo){
    	$scope.selectEntity = tableAttrVo;
    	var url = "EntityMultiAttrSelect4Query.jsp?modelId=" + modelId+"&tableAlias="+tableAlias+"&actionType="+actionType;
		cui('#body').setContentURL("right", url);	
    }

});


window.onload = function(){
  		comtop.UI.scan();
  		isShowModuleTree();
  		initSelectAttrDataArr();
  		if(modelId!=""){
  		//根据实体ID获取所在包ID，定位树到相应的模块位置
  	    dwr.TOPEngine.setAsync(false);
	    EntityFacade.loadEntity(modelId,"",function(entity){
		   packageId = entity.packageId;
	    });
		dwr.TOPEngine.setAsync(true);
  	}
  		scope.initTableAttributes();
  		scope.$digest();
}

//控制左侧树是否显示，只有当actionType为select才显示
function isShowModuleTree(){
	if (actionType!="select") {
		cui('#body').setCollapse('left', true);
		cui('#body').setCollapsable('left', false);
	}
}

/*
*初始化已有的select属性，仅当actionType为select时
*
*/
function initSelectAttrDataArr(){
	if (actionType!='select') return;
	if (extras) {
			//根据别名找到需要初始化的对象
			if (isEmptyObject(extras.select)) {
				return;
			}
			var selectAttrArr = extras.select.selectAttributes;
			for (var i = 0; i < selectAttrArr.length; i++) {
				//处理数据
				var newCustomHeaderVo =  createCustomHeaderVoByExtra(selectAttrArr[i]);
	    		selectAttrDataArr.push(newCustomHeaderVo);
			}
		}
}

//转换为CustomHeaderVo
function createCustomHeaderVoByExtra(objSelectAttrVo){
	return {customHeaderId: objSelectAttrVo.engName, chName: objSelectAttrVo.chName,engName: objSelectAttrVo.engName,aliasName:objSelectAttrVo.columnAlias,dbFieldId:objSelectAttrVo.columnName,entityId: objSelectAttrVo.entityId,tableName: objSelectAttrVo.tableName,tableAlias:objSelectAttrVo.tableAlias,check:false,sqlScript:objSelectAttrVo.sqlScript};
}

//初始化数据 
function initData(obj) {
	SystemModelAction.getAllModuleTree(function(data){
		if(data == null || data == "") {
			//当为空时，进行根节点新增操作
			isRootNodeAdd = "true";
			setRootNode(obj);
		} else {
			var treeData = jQuery.parseJSON(data);
			treeData.expand = true;
			treeData.activate = true;
			doneTreeDataNode(treeData, treeData.children);
	    	obj.setDatasource(treeData);
	    	var sourceNode = packageId ? obj.getNode(packageId) : null;
	    	if(sourceNode) {	//有来源实体需要自动定位到对应实体应用方便于用户选择
	    		
	    		sourceNode.activate();
				sourceNode.expand();

				//如果没有子应用时会在展开时自动执行loadNode方法定位
				//有子应用时需要手动定位到具体的实体
				var children = sourceNode.children();
				if (children&&children.length>0) {
					nodeUrl(modelId);
					cui("#moduleTree").getNode(modelId).activate();
				}
				//定位到对应的选中的项
				$(".bl_box_left").scrollTop($(".dynatree-active").offset().top-($(".bl_box_left").height()/3));
	    	}
		}
     });
}

/**
 * 将所有的节点isFolder设置为true,叶子节点isLazy设置为true（点击叶子节点加载对应的实体VO）
 * @param  node         节点
 * @param  childrenNode 节点对应的子节点集合
 * @return              
 */
function doneTreeDataNode(node, childrenNode) {
	node.isFolder = true;
	if (childrenNode && childrenNode.length > 0) {
		for (var i = 0; i < childrenNode.length; i++) {
			doneTreeDataNode(childrenNode[i], childrenNode[i].children);
			if (node.data&&node.data.moduleType==2) {
				node.isLazy = true;
				loadNodeForInit(node);
			}
		}
	} else {
		node.isLazy = true;
	}
	

}

//初始化时查询应用下面实体信息，仅当应用下面还有子应用时会执行这个逻辑
//否则实体信息会在点击时动态加载
function loadNodeForInit(node){
	dwr.TOPEngine.setAsync(false);
	EntityFacade.queryEntityForNodeByEntityType(node.key,"biz_entity",function(data){
		node.children = _.union(node.children,data);
		
	});
	dwr.TOPEngine.setAsync(true);
}
//点击click事件加载节点方法
function loadNode(node) {
	dwr.TOPEngine.setAsync(false);
	EntityFacade.queryEntityForNodeByEntityType(node.getData().key, "biz_entity", function(data) {
		var nodeUrlData = "";
		//解决点击应用目录层时，会自动跳到modelId对应的那个实体
		if (isEmptyObject(data)) {
			node.setLazyNodeStatus(node.ok);
			return;
		}
		if (modelId != "") {
			node.addChild(data);
			node.setLazyNodeStatus(node.ok);
			nodeUrlData = modelId;
			cui("#moduleTree").getNode(modelId).activate();
		} else {
			node.addChild(data);
			node.setLazyNodeStatus(node.ok);
			nodeUrlData = node.getData().key;
		}
		 //如果是页面初始化，则需要初始化右侧页面
		if(initCount == 0){
			nodeUrl(nodeUrlData);
			initCount = 1;//设置为页面非初始化
		}
	});
	dwr.TOPEngine.setAsync(true);
}

//设置右边的页面链接
function nodeUrl(nodeId){
	var url = "EntityMultiAttrSelect4Query.jsp?modelId=" + nodeId+"&actionType="+actionType;
	//如果不是select第一次新增 或者 有已选实体，则默认选中第一个
	if (actionType!='select'||scope.tableAttributes.length>0){
		scope.nodeOpen(scope.tableAttributes[0].entityId,scope.tableAttributes[0].tableAlias,scope.tableAttributes[0]);
		scope.$digest();
		return;
	}
	cui('#body').setContentURL("right", url);	
}

//树双击事件
function treeOndbClick(node) {
	treeClick(node);
}

//树单击事件
function treeClick(node){
	var data = node.getData();
	//console.log(data.data.modelId);
	modelId = data.data.modelId;//重新设置modelId
	url = "EntityMultiAttrSelect4Query.jsp?modelId=" + modelId+"&actionType="+actionType;
	scope.selectEntity = {};
	scope.$digest();
	cui('#body').setContentURL("right", url);	
}
//判断对象是否为空
function isEmptyObject( obj ) {
    for ( var name in obj ) {
        return false;
    }
    return true;
}
//关闭窗口
function closeSelf(){
	window.parent.dialog.hide();
}

/**
*合并子查询和主查询数据
*/
function getAllTableAlias(){
	return window.parent.getAllTableAlias();
}
</script>
</body>
</html>