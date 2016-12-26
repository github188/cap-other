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
<title>业务域管理</title>
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
	margin-left :0px;
	margin-top :18px;
	}
</style>
<body>
	<div class="divTreeBtn">
		<span id="addNode" uitype="button" label="新增" on_click="insert"></span>
		<span id="deleteNode" uitype="button" label="删除" on_click="deleteNode"></span>
	</div>
	<div>
		<div id="flowTree" uitype="Tree" checkbox="false" select_mode="1" click_folder_mode = "2" on_dbl_click="updateNode" children="flowData"></div>
	</div>
	<top:script src="/cap/dwr/interface/BizProcessInfoAction.js" />
	<top:script src="/cap/dwr/interface/BizProcessNodeAction.js" />
<script type="text/javascript">
	var domainId = "${param.domainId}";
	var BizProcessInfoId = "<c:out value='${param.BizProcessInfoId}'/>";
	var BizProcessNode = {};
	BizProcessNode.processId = BizProcessInfoId;
	window.onload = function(){
		comtop.UI.scan();
		lodeNode(BizProcessInfoId);
	}
	//初始加载根节点 (tree)
	function flowData(obj){
		dwr.TOPEngine.setAsync(false);
		BizProcessInfoAction.queryBizProcessInfoById(BizProcessInfoId,function(data){
			if(data){
				var item = [{title:data.processName,key:data.id}];
				obj.setDatasource(item);
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	//加载子节点(tree)(递归加载) 
	function lodeNode(BizProcessInfoId){
		BizProcessNode.pageSize=1000;
		dwr.TOPEngine.setAsync(false);
		BizProcessNodeAction.queryBizNodeList(BizProcessNode,function(data){
			if(data !='[]'){
				for(var i=0;i<data.list.length;i++){
					var serialNo= data.list[i].serialNo=='null' || data.list[i].serialNo==null? '' : data.list[i].serialNo;
					var name= data.list[i].name=='null' || data.list[i].name==null? '' : data.list[i].name;
					cui("#flowTree").getNode(BizProcessInfoId).addChild({title:name+"【"+serialNo+"】",key:data.list[i].id});
				}
				cui("#flowTree").getNode(BizProcessInfoId).expand(true);
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//删除业务流程节点
	function deleteNode(){
		var selectNode=cui("#flowTree").getActiveNode();
		if(selectNode){
			var selectNodeKey=selectNode.getData('key');
			var selectNodeTitle = selectNode.getData('title');
			if(selectNodeKey == BizProcessInfoId){
				parent.cui.alert("请选定业务流程节点！");
				return;
			}else{
				var condition = {};
				condition.id = selectNodeKey;
				var vCount = 0;
				dwr.TOPEngine.setAsync(false);
				BizProcessNodeAction.queryUseBizProcessNodeCount(condition,function(data){
					vCount = data;
				});
				if(vCount>0){
					parent.cui.alert("该节点被引用或有下级数据，不能删除！");
				}else{
					dwr.TOPEngine.setAsync(true);
					parent.cui.confirm("确定要删除名称为"+selectNodeTitle+"的流程节点吗？",{
						onYes:function(){
							var BizProcessNodelst =  new Array()
							var BizProcessNodeVO = {};
							BizProcessNodeVO.id = selectNodeKey;
							BizProcessNodelst[0]=BizProcessNodeVO;
							dwr.TOPEngine.setAsync(false);
							BizProcessNodeAction.deleteBizProcessNodeList(BizProcessNodelst,function(data){
								cui("#flowTree").getNode(selectNodeKey).remove();
								parent.parent.cui.message("删除成功","success");
							});
							dwr.TOPEngine.setAsync(true);
						}
					});
			}
		}
		}else{
			parent.cui.alert("请选定业务流程节点！");
		}
	}
	
	//修改节点
	function updateNode(){
		var selectNode=cui("#flowTree").getActiveNode();
		if(selectNode){
			var selectNodeKey=selectNode.getData('key');
			var selectNodeTitle = selectNode.getData('title');
			if(selectNodeKey == BizProcessInfoId){
				return;
			}else{
				var url = "TabList.jsp?BizProcessInfoId="+BizProcessInfoId+"&BizProcessnodeId="+selectNodeKey+"&domainId="+domainId;
				parent.dialogNodePage(url);
			}
		}
	}
	//新增同级
	function insert(){
		var url = "BizProcessNodeEdit.jsp?BizProcessInfoId="+BizProcessInfoId+"&domainId="+domainId;
		parent.dialogNodePage(url);
	}
</script>
</body>
</html>