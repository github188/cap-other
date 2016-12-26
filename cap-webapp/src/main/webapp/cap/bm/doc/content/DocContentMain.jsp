<%
  /**********************************************************************
	* 文档内容编辑主页面
	* 2015-11-13  李小芬  新增
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<!doctype html>
<html>
<head>
<title></title>
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_sys.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/engine.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/util.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/DocChapterContentStructAction.js'></script>
	<script type="text/javascript" src='<%=request.getContextPath() %>/cap/bm/common/top/js/jquery.js'></script>
	<script type="text/javascript" src='<%=request.getContextPath() %>/top/component/topui/cui/js/jquery.dynatree.min.js'></script>
	<script type="text/javascript" src='<%=request.getContextPath() %>/top/component/topui/cui/js/comtop.ui.tree.js'></script>
</head>
<style>
.divTreeBtn {
			  margin-left :15px;
		}
</style>
<body>
	<div uitype="Borderlayout"  id="body"  is_root="true" > 
		<div id="leftMain" position="left" width="300" resizable="true" show_expand_icon="true" collapsable="true">  
			<table width="95%" style="margin-left: 10px">
				<tr id="tr_moduleTree">
					<td>
	                    <div id="moduleTree" uitype="Tree" children="initData" on_click="treeClick" icon="false"
	                    	min_expand_level="1" click_folder_mode="1" on_lazy_read="loadNode"></div>
	                   </td>
				</tr>
			</table>
        </div>
		<div id="centerMain" position ="center">
		</div>
	</div>


	<script type="text/javascript">
		String.prototype.trim=function(){return this.replace(/(^\s*)|(\s*$)/g,"");}
		var documentId = "${param.documentId}";//文档ID
		var documentName = decodeURIComponent("${param.documentName}");//文档名称 
		var documentTitle = decodeURIComponent("${param.documentTitle}");//文档名称 
		
		//选中的树节点
		$(document).ready(function(){
			comtop.UI.scan();   //扫描
			document.title = documentTitle + "-编辑";
		});
		
		//初始化数据 
		function initData(obj) {
			//获取章节数据的所有内容
			dwr.TOPEngine.setAsync(false);
			//var DocumentVO = {"id":documentId,"name":documentName}
			var docChapterContentStructVO = {"documentId":documentId,"parentTreeId":"-1"}
			DocChapterContentStructAction.getChapterTree(docChapterContentStructVO,function(data){
				if(data == null || data == "") {
					//当为空时，文档解析异常
				} else {
					var treeData = jQuery.parseJSON(data);
					treeData.expand = true;
					treeData.activate = true;
			    	obj.setDatasource(treeData);
				}
		     });
			dwr.TOPEngine.setAsync(true);
		}
		
		function loadNode(node) {
			var docChapterContentStruct = node.getData().data;
			dwr.TOPEngine.setAsync(false);
			DocChapterContentStructAction.getChapterTree(docChapterContentStruct,function(data){
		    	var treeData = jQuery.parseJSON(data);
		    	var childData = treeData.children;
		    	treeData.activate = true;
		    	node.addChild(childData);
				node.setLazyNodeStatus(node.ok);
		     });
			dwr.TOPEngine.setAsync(true);
		}

		
		//树点击事件
		function treeClick(node) {
			var docChapterContentStruct = node.getData().data;
			//根节点右侧显示空页面
			if(docChapterContentStruct.parentUri == "-1"){
				cui('#body').setContentURL("center","");	
				return;
			}
			var contentType = docChapterContentStruct.contentType;
			var containerType = docChapterContentStruct.containerType;
			var chapterName = docChapterContentStruct.chapterName;
			var documentId = docChapterContentStruct.documentId;
			var xmlfullPath = docChapterContentStruct.xmlfullPath;
			var containerUri = docChapterContentStruct.containerUri;
			var data = node.getData();
			var nodeId = data.key; //形如：综述、编制目的
			if(containerUri!="undefined"&&containerUri!=null&&containerUri!="null"){
				containerUri = encodeURIComponent(encodeURIComponent(containerUri));
			}
			if(xmlfullPath!="undefined"&&xmlfullPath!=null&&xmlfullPath!="null"){
				xmlfullPath = encodeURIComponent(encodeURIComponent(xmlfullPath));
			}
			if(nodeId!="undefined"&&nodeId!=null&&nodeId!="null"){
				nodeId = encodeURIComponent(encodeURIComponent(nodeId));
			}
			
			var url = '<%=request.getContextPath() %>/cap/bm/doc/content/ChapterXmlContent.jsp?containerType=' + containerType + "&containerUri=" 
					+ containerUri + "&documentId=" + documentId + "&contentType=" + contentType + "&xmlfullPath=" + xmlfullPath + "&nodeId=" + nodeId;
			cui('#body').setContentURL("center",url);	
		}
		
		function getSelectTree(nodeId){
			var sourceNode = cui("#moduleTree").getNode(nodeId);
			return sourceNode;
		}
		
		//键盘回车键快速查询 
		function keyDownQuery() {
			if ( event.keyCode ==13) {
				fastQuery();
			}
		}
		
		//快速查询
		function fastQuery(){
			var keyword = cui('#keyword').getValue().trim();
			//清楚上次选中的值 
			selectNodeId = "";
			if(keyword){//定位节点 
				//查询匹配的节点ID
				addIndexOfMethod();
				var root = cui("#moduleTree").getRoot().dNode.childList[0];
				var keywordNodeId = queryKeywordNode(root,root.childList,keyword);
				var sourceNode = cui("#moduleTree").getNode(keywordNodeId);
		    	if(sourceNode) {	//有来源实体需要自动定位到对应实体应用方便于用户选择
		    		sourceNode.activate();
					sourceNode.expand();
					//定位到对应的选中的项
					$(".bl_box_center").scrollTop($(".dynatree-active").offset().top-($(".bl_box_center").height()/3));
		    	}
			}
		}
		
		//匹配keyword
		var selectNodeId;
		function queryKeywordNode(node, childrenNode,keyword) {
			if(node.data.title.indexOf(keyword) > -1){
				selectNodeId =  node.data.key;
			}else if(childrenNode && childrenNode.length > 0) {
				for (var i = 0; i < childrenNode.length; i++) {
					if(!selectNodeId){
						selectNodeId = queryKeywordNode(childrenNode[i], childrenNode[i].childList,keyword);
					}
				};
			}
			return selectNodeId;
		}
		
		//适应IE 
		function addIndexOfMethod(){
			if (!Array.prototype.indexOf){
			  	Array.prototype.indexOf = function(elt){
				    var len = this.length >>> 0;
				    var from = Number(arguments[1]) || 0;
				    from = (from < 0)? Math.ceil(from): Math.floor(from);
				    if (from < 0){
					      from += len;
				    }
				    for(; from < len; from++){
				      if (from in this && this[from] === elt){
					        return from;
				      }
				    }
				    return -1;
			  	};
			}
		}
	</script>
</body>
</html>