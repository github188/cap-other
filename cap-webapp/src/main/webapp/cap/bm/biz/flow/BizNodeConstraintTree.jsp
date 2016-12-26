<%
  /**********************************************************************
	* 业务流程节点
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
<title>业务对象管理</title>
		<top:link href="/cap/bm/common/top/css/top_base.css" />
		<top:link href="/cap/bm/common/top/css/top_sys.css" />
		<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
		<top:link href="/cap/bm/common/styledefine/css/public.css"/>
		<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js" />
		<top:script src="/cap/dwr/engine.js" />
		<top:script src="/cap/dwr/util.js" />
		<top:script src="/cap/bm/common/top/js/jquery.js" />
		<top:script src="/cap/bm/common/js/capCommon.js" />
</head>
<style>
.divTreeBtn {
	margin-left :10px;
	margin-top :18px;
	}
</style>
<body>
	<div class="divTreeBtn">
		<span id="butImport" uitype="button" label="导入" on_click="importObj"></span>
		<span id="butDelete" uitype="button" label="删除" on_click="deleteObj"></span>
	</div>
	<div>
		<div id="objTree" uitype="Tree" checkbox="false" select_mode="1" on_click="clickCallback" children="objData"></div>
	</div>
<top:script src="/cap/dwr/interface/BizProcessNodeAction.js" />
<top:script src="/cap/dwr/interface/BizNodeConstraintAction.js" />
<script type="text/javascript">
	var domainId = "${param.domainId}";
	var BizProcessnodeId = "${param.BizProcessnodeId}";
	var bizObjId = "<c:out value='${param.bizObjId}'/>";
	var BizNodeConstraint = {};
	BizNodeConstraint.nodeId = BizProcessnodeId;
	window.onload = function(){
		comtop.UI.scan();
		if(bizObjId){
			cui("#objTree").getNode(bizObjId).activate(true);	
		}
	}
	//初始加载根节点 (tree)
	function objData(obj){
		BizNodeConstraint.pageSize = 1000;
		if(BizNodeConstraint.nodeId!=null && BizNodeConstraint.nodeId !=""){
			dwr.TOPEngine.setAsync(false);
			BizNodeConstraintAction.queryBizNodeConstraintGroupObjId(BizNodeConstraint,function(data){
				if(data.list !='[]'){
					var initData = [];
					for(var i=0;i<data.list.length;i++){
						var item={'title':data.list[i].name,'key':data.list[i].id}; 
						initData.push(item);
					}
					obj.setDatasource(initData);
				}
			});
			dwr.TOPEngine.setAsync(true);
		}
	}
	
	//删除数据
	function deleteObj(){
			var selectNode=cui("#objTree").getActiveNode();
			if(selectNode){
				var selectNodeKey=selectNode.getData('key');
				var selectNodeTitle = selectNode.getData('title');
				parent.cui.confirm("确定要删除名称为"+selectNodeTitle+"的业务对象吗？",{
					onYes:function(){
						BizNodeConstraint.bizObjId = selectNodeKey;
						dwr.TOPEngine.setAsync(false);
						BizNodeConstraintAction.deleteBizNodeConstraintByObjId(BizNodeConstraint,function(data){
							cui("#objTree").getNode(selectNodeKey).remove();
							var url = 'BizNodeConstraintGrid.jsp?BizProcessnodeId='+BizProcessnodeId+"&bizObjId="+selectNodeKey;
							parent.setCenterUrl(url);
							parent.parent.parent.parent.cui.message("删除成功!","success");
						});
						dwr.TOPEngine.setAsync(true);
					}
				});
			}else{
				parent.cui.alert("请选定业务对象！");
			}
	}	
	
	function clickCallback(flag){
		var selectNode=cui("#objTree").getActiveNode();
		var selectNodeKey=selectNode.getData('key');
		var url = 'BizNodeConstraintGrid.jsp?BizProcessnodeId='+BizProcessnodeId+"&bizObjId="+selectNodeKey;
		parent.setCenterUrl(url);
	}
	
	//新增数据
	function importObj(){
		window.parent.selectObjInfoItem();
	}
</script>
</body>
</html>