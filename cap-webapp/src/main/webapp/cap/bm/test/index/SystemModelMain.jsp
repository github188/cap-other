<%
  /**********************************************************************
	* CIP元数据建模----系统建模主页面 
	* 2014-10-30  沈康 新增 
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<!doctype html>
<html>
<head>
<title>系统建模主页面</title>
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_sys.css" type="text/css">
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/engine.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/util.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/SystemModelAction.js'></script>
	<script type="text/javascript" src='<%=request.getContextPath() %>/cap/bm/common/top/js/jquery.js'></script>
	<script type="text/javascript" src='<%=request.getContextPath() %>/top/component/topui/cui/js/jquery.dynatree.min.js'></script>
	<script type="text/javascript" src='<%=request.getContextPath() %>/top/component/topui/cui/js/comtop.ui.tree.js'></script>
	
</head>
<style>
.top_header_wrap {
	padding-right: 5px;
}
</style>
<body>
	<div uitype="Borderlayout"  id="body"  is_root="true" > 
		<div id="leftMain" position="left" width="300" collapsabltie="true" show_expand_icon="true" collapsable="true">       
         <table width="95%" style="margin-left: 10px">
				<tr height="40px;">
					<td>
						<span uitype="ClickInput" id="keyword" name="keyword" emptytext="请输入系统，目录或应用名称关键字查询"
							on_iconclick="fastQuery"  icon="search" enterable="true"
							editable="true"	 width="260" on_keydown="keyDownQuery"></span>
					</td>
				</tr>
				<tr>
					<td>
						<div id="fastQueryList" uitype="MultiNav" datasource="initBoxData"></div> 
					</td>
				</tr>
				<tr id="tr_moduleTree">
					<td>
                     <div id="moduleTree" uitype="Tree" children="initData" 
                     on_dbl_click="dbClickNode" min_expand_level="1"  on_lazy_read="loadNode" on_click="treeClick" click_folder_mode="1"></div>
                    </td>
				</tr>
			</table>
         </div>
		<div id="centerMain" position ="center">
			
		</div>
	</div>


	<script type="text/javascript">
		var addType = '';
		
		//选中的树节点
		var selectedNodeId = "-1";
		$(document).ready(function(){
			comtop.UI.scan();   //扫描
		});
		
		//初始化数据 
		function initData(obj) {
			var moduleObj={"parentModuleId":"-1"};
			SystemModelAction.queryChildrenModule(moduleObj,function(data){
				if(data == null || data == "") {
					//当为空时，进行根节点新增操作
					isRootNodeAdd = "true";
					setRootNode(obj);
				} else {
					var treeData = jQuery.parseJSON(data);
					treeData.expand = true;
					treeData.activate = true;
			    	obj.setDatasource(treeData);
			    	nodeUrl(treeData.key);
				}
		     });
		}
		
		//点击click事件加载节点方法
		function loadNode(node) {
			selectedNodeId = node.getData().key;
			dwr.TOPEngine.setAsync(false);
			var moduleObj={"parentModuleId":node.getData().key};
			SystemModelAction.queryChildrenModule(moduleObj,function(data){
		    	var treeData = jQuery.parseJSON(data);
		    	var childData = treeData.children;
		    	treeData.activate = true;
		    	node.addChild(childData);
				node.setLazyNodeStatus(node.ok);
		     });
			dwr.TOPEngine.setAsync(true);
		}
		
		
		//设置右边的页面链接
		function nodeUrl(nodeId){
			var node = cui('#moduleTree').getNode(nodeId);
			parent.clickIframeBack(node);
			var data = node.getData();
			selectedNodeId = data.key;
			var parentData = node.parent().getData();
			var nodeTypeVal = 0;
			if(nodeId != 0){
				nodeTypeVal = data.data.moduleType;
			}
			var parentModuleType = "";
			if(parentData.key != "_1"){
				parentModuleType = parentData.data.moduleType;
			}
			
			var strParentName =  parentData.title;
			if(strParentName!="undefined"&&strParentName!=null&&strParentName!="null"){
				strParentName = encodeURIComponent(encodeURIComponent(strParentName));
			}

			if(nodeTypeVal == 2) { // 应用节点
				cui('#body').setContentURL("center" , "<%=request.getContextPath() %>/cap/bm/test/index/TestModelMain.jsp?packageId=" + nodeId + "&parentNodeId=" + parentData.key 
							+ "&testModel=testModel" + "&parentNodeName=" + strParentName);
			} else if(nodeTypeVal == 3) { // 目录节点
				cui('#body').setContentURL("center",'<%=request.getContextPath() %>/cap/bm/dev/systemmodel/DirectoryEdit.jsp?nodeId=' + nodeId + '&parentNodeId=' + parentData.key
						+ "&testModel=testModel"+ "&parentNodeName=" + strParentName);	
			} else { // 系统节点或其他
				var contentUrl = '<%=request.getContextPath() %>/cap/bm/dev/systemmodel/SystemModuleEdit.jsp?nodeId=' + nodeId + '&parentNodeId=' + parentData.key
					+ "&parentNodeName=" + strParentName + "&testModel=testModel";
				if(parentData.key == "_1"){//根节点
					cui('#body').setContentURL("center" , "<%=request.getContextPath() %>/cap/bm/graph/ModuleRelationGraphMain.jsp?moduleId=" + nodeId  + "&returnUrl=" + contentUrl + "&testModel=testModel");
				}else{
					cui('#body').setContentURL("center",contentUrl);	
				}
				
			}
		}
		
		//树点击事件
		function treeClick(node) {
			parent.clickIframeBack(node);
			var data = node.getData();
			var parentData = node.parent().getData();
			var nodeId = data.key;
			selectedNodeId = nodeId;
			var title = data.title;
			var url = '';
			
			var nodeTypeVal = 0;
			var parentModuleType = 0;
			if(nodeId != 0){
				nodeTypeVal = data.data.moduleType;
			}
			
			if(parentData.key != "_1") {
				parentModuleType = parentData.data.moduleType;
			}
			
			var strParentName =  parentData.title;
			if(strParentName!="undefined"&&strParentName!=null&&strParentName!="null"){
				strParentName = encodeURIComponent(encodeURIComponent(strParentName));
			}
			switch(nodeTypeVal) {
				case 1:
					var contentUrl = '<%=request.getContextPath() %>/cap/bm/dev/systemmodel/SystemModuleEdit.jsp?nodeId=' + nodeId + '&parentNodeId=' + parentData.key + '&parentNodeName=' + strParentName 
								+ '&nodeTypeVal=' + nodeTypeVal + '&parentModuleType=' + parentModuleType + "&testModel=testModel";
					if(parentData.key == "_1"){//根节点
						url = "<%=request.getContextPath() %>/cap/bm/graph/ModuleRelationGraphMain.jsp?moduleId=" + nodeId  + "&testModel=testModel" + "&returnUrl=" + contentUrl;
					}else{
						url = contentUrl;
					}
					break;
				case 2:
					url = '<%=request.getContextPath() %>/cap/bm/test/index/TestModelMain.jsp?packageId=' + nodeId + '&parentNodeId=' + parentData.key + '&parentNodeName=' + strParentName 
							+ '&nodeTypeVal=' + nodeTypeVal + '&parentModuleType=' + parentModuleType + '&testModel=testModel';
				  	break;
				case 3:
					url = '<%=request.getContextPath() %>/cap/bm/dev/systemmodel/DirectoryEdit.jsp?nodeId=' + nodeId + '&parentNodeId=' + parentData.key + '&parentNodeName=' + strParentName 
								+ '&nodeTypeVal=' + nodeTypeVal + '&parentModuleType=' + parentModuleType + '&testModel=testModel';
				  	break;
				default:
					url = '<%=request.getContextPath() %>/cap/bm/dev/systemmodel/SystemModuleEdit.jsp?nodeId=' + nodeId + '&parentNodeId=' + parentData.key + '&parentNodeName=' + strParentName + "&testModel=testModel";
			} 
			cui('#body').setContentURL("center",url);	
		}
		
		// 编辑树节点刷新事件 
		function editRefreshTree(moduleId,parentModuleId,moduleName){
			var treeObject = cui("#moduleTree");
			var pNode = treeObject.getNode(parentModuleId);
			var selectNode = treeObject.getNode(moduleId);
			if(selectNode && selectNode.dNode) {
				selectNode.setData("title",moduleName);
				selectNode.activate();
				treeClick(selectNode);
			} 
		}

		// 新增树节点刷新事件 
		function addRefreshTree(moduleId,parentModuleId) {
			var treeObject = cui("#moduleTree");
			var pNode = treeObject.getNode(parentModuleId);
			if(pNode && pNode.dNode) { 
				pNode.setData("isFolder",true);
				if(pNode.hasChild()) {
					var lstChildrenNodes = pNode.children();
					for(var i=0;i<lstChildrenNodes.length;i++) {
						var dNode = lstChildrenNodes[i];
						dNode.remove();
					}
				}
				loadNode(pNode);
				var dNode = treeObject.getNode(moduleId);
				dNode.activate();
				dNode.focus();
				treeClick(dNode);
			} 

		}
		
		//快速查询
		function fastQuery(){
			var keyword = cui('#keyword').getValue();
			if(keyword==''){
				$('#fastQueryList').hide();
				$('#moduleTree').show();
				addType = '';
				var node=cui('#moduleTree').getNode(selectedNodeId);
				if(node){
					treeClick(node);
				}
			}else{
				$('#fastQueryList').show();
				$('#moduleTree').hide();
				listBoxData(cui('#fastQueryList'));
				addType = 'fastQueryType';
			}
		}

		//键盘回车键快速查询 
		function keyDownQuery() {
			if ( event.keyCode ==13) {
				fastQuery();
			}
		}

		//快速查询列表数据源
		function listBoxData(obj){
			initBoxData = [];
			var keyword = cui("#keyword").getValue().replace(new RegExp("/","gm"), "//");
			keyword = keyword.replace(new RegExp("%", "gm"), "/%");
			keyword = keyword.replace(new RegExp("_","gm"), "/_");
			keyword = keyword.replace(new RegExp("'","gm"), "''");
			dwr.TOPEngine.setAsync(false);
			SystemModelAction.fastQueryModule(keyword,function(data){
				var len = data.length ;
				if(len != 0) {
					$.each(data,function(i,cData){
						if(cData.moduleName.length > 31) {
							path=cData.moduleName.substring(0,31)+"..";
						} else {
							path = cData.moduleName;
						}
						initBoxData.push({href:"#",name:path,title:cData.moduleName,onclick:"clickRecord('"+cData.moduleId+"','"+cData.moduleName+"')"});
					});
				} else {
					initBoxData.push({href:"#",name:"没有数据",title:"",onclick:""});
				}
			});
			cui("#fastQueryList").setDatasource(initBoxData);
			dwr.TOPEngine.setAsync(true);
		}
		
		//单击列表记录
		function clickRecord(moduleId, modulePath){
			var selectedModuleId = moduleId;
			var moduleName = "";
			var moduleType = "";
			var parentModuleId = "";
			var parentModuleName = "";
			var parentModuleType = "";
			dwr.TOPEngine.setAsync(false);
			SystemModelAction.getModuleInfo(selectedModuleId,function(data){
				var moduleVO = data;
				moduleName = moduleVO.moduleName;
				moduleType = moduleVO.moduleType;
				parentModuleId = moduleVO.parentModuleId;
			});	
			dwr.TOPEngine.setAsync(true);

			dwr.TOPEngine.setAsync(false);
			SystemModelAction.getModuleInfo(parentModuleId,function(data){
				var parentModuleVO = data;
				if(data == null) {
					parentModuleName = '';
				} else {
					parentModuleName = parentModuleVO.moduleName;
					parentModuleType = parentModuleVO.moduleType;
					if(parentModuleName!="undefined"&&parentModuleName!=null&&parentModuleName!="null"){
						parentModuleName = encodeURIComponent(encodeURIComponent(parentModuleName));
					}
				}
			});	
			dwr.TOPEngine.setAsync(true);
			
			if(moduleType == 2) { // 应用节点
				cui('#body').setContentURL("center" , "<%=request.getContextPath() %>/cap/ptc/index/AppDetail.jsp?packageId=" + selectedModuleId + '&parentNodeId=' + parentModuleId
						+ "&parentNodeName=" + parentModuleName);
				//cui('#body').setContentURL("center",'FuncModelEdit.jsp?nodeId=' + selectedModuleId + '&parentNodeId=' + parentModuleId
				//		+ "&parentNodeName=" + parentModuleName);
			} else if(moduleType == 3) { // 目录节点
				cui('#body').setContentURL("center",'<%=request.getContextPath() %>/cap/bm/dev/systemmodel/DirectoryEdit.jsp?nodeId=' + selectedModuleId + '&parentNodeId=' + parentModuleId
						+ "&parentNodeName=" + parentModuleName);	
			} else { // 系统节点或其他
				cui('#body').setContentURL("center",'<%=request.getContextPath() %>/cap/bm/dev/systemmodel/SystemModuleEdit.jsp?nodeId=' + selectedModuleId + '&parentNodeId=' + parentModuleId
						+ "&parentNodeName=" + parentModuleName);	
			}
		}
		
/* 		//上移、下移、置顶、置底方法 
		function moveNode(moveType) {
			var n = cui('#moduleTree').getActiveNode();
			var parentNode = n.parent();
			if(n && parentNode) {
				var obj = findRelativeNode(n,moveType);
				if(obj.moduleRelationsToBeUpdate && obj.relativeNode){
					dwr.TOPEngine.setAsync(false);
					SystemModelAction.updateModuleRelations(moveType,obj.moduleRelationsToBeUpdate,function(data){
						//交换节点位置并重新选中操作节点，否则会丢失其选中状态
						n.move(obj.relativeNode,obj.where);
					});
					dwr.TOPEngine.setAsync(true);
				}
			}else{
				cui.alert('请选择组织，根节点不能进行排序。');
				return;
			}
		} */
		
		/**
		 * 排序时找到需要与此节点进行交换的节点
		 * 
		 * @param n
		 * @param option
		 * @return
		 */
		function findRelativeNode(n,option){
			var relativeNode;	//排序参考节点
			var where;
			var moduleRelationsToBeUpdate;
			var parentNode = n.parent();
			switch(option){
				case 'top':
					//n不是其层级的第一个节点，则relativeNode为同层首节点
					if(parentNode.firstChild().getData().key != n.getData().key)
						relativeNode = parentNode.firstChild();
					if(relativeNode){
						where = 'before';
						moduleRelationsToBeUpdate = [n.getData().data,relativeNode.getData().data];
					}
					break;
				case 'bottom':
					if(parentNode.lastChild().getData().key != n.getData().key)
						relativeNode = parentNode.lastChild();
					if(relativeNode){
						where = 'after';
						moduleRelationsToBeUpdate = [n.getData().data,relativeNode.getData().data];
					}
						break;
				case 'up':
					if(parentNode.firstChild().getData().key!=n.getData().key)
						relativeNode = n.prev();
					if(relativeNode){
						where = 'before';
						moduleRelationsToBeUpdate = [n.getData().data,relativeNode.getData().data];
					}
						break;
				case 'down':
					if(parentNode.lastChild().getData().key != n.getData().key)
						relativeNode = n.next();
					if(relativeNode){
						where = 'after';
						moduleRelationsToBeUpdate = [n.getData().data,relativeNode.getData().data];
					}
					break;
				default:
			};
			return {'relativeNode':relativeNode,'where':where,'moduleRelationsToBeUpdate':moduleRelationsToBeUpdate};
		}

	</script>
</body>
</html>