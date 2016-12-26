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
	margin-left :0px;
	margin-top :18px;
	}
</style>
<body>
	<div class="divTreeBtn">
		<span id="butImport" uitype="button" label="新增" on_click="importRelInfo"></span>
		<span id="butDelete" uitype="button" label="删除" on_click="deleteRelInfo"></span>
	</div>
	<div>
		<div id="BizRelInfoTree" uitype="Tree" checkbox="false" select_mode="1" on_click="clickCallback" children="BizRelInfoData"></div>
	</div>
<top:script src="/cap/dwr/interface/BizRelInfoAction.js" />
<script type="text/javascript">
	var domainId = "${param.domainId}";
	var BizProcessInfoId = "<c:out value='${param.BizProcessInfoId}'/>";
	var BizProcessnodeId = "${param.BizProcessnodeId}";
	var BizRelInfoId = "${param.BizRelInfoId}";
	var BizRelInfo = {};
	var firstNodeKey ="";
	BizRelInfo.roleaNodeId = BizProcessnodeId;
	window.onload = function(){
		comtop.UI.scan();
		setTimeout(function(){
			if(BizRelInfoId){
				cui("#BizRelInfoTree").getNode(BizRelInfoId).activate(true);	
				editRelInfo(BizRelInfoId);
			}else if(firstNodeKey !=""){
				cui("#BizRelInfoTree").getNode(firstNodeKey).activate(true);
				editRelInfo(firstNodeKey);
			}
		},100);
	}
	//初始加载根节点 (tree)
	function BizRelInfoData(obj){
		if(BizProcessnodeId!=null && BizProcessnodeId !=""){
			BizRelInfo.roleaNodeId = BizProcessnodeId;
			dwr.TOPEngine.setAsync(false);
			BizRelInfoAction.queryBizRelInfoList(BizRelInfo,function(data){
				if(data.list !='[]'){
					var initData = [];
					for(var i=0;i<data.list.length;i++){
						var item={'title':data.list[i].name,'key':data.list[i].id}; 
						initData.push(item);
					}
					obj.setDatasource(initData);
					firstNodeKey = data.list[0].id;
				}
			});
			dwr.TOPEngine.setAsync(true);
		}
	}
	
	//删除数据
	function deleteRelInfo(){
			var selectNode=cui("#BizRelInfoTree").getActiveNode();
			if(selectNode){
				var selectNodeKey=selectNode.getData('key');
				var selectNodeTitle = selectNode.getData('title');
				parent.cui.confirm("确定要删除名称为"+selectNodeTitle+"的业务关联吗？",{
					onYes:function(){
						BizRelInfo.id = selectNodeKey;
						dwr.TOPEngine.setAsync(false);
						BizRelInfoAction.deleteBizRelInfo(BizRelInfo,function(data){
							cui("#BizRelInfoTree").getNode(selectNodeKey).remove();
							var url = 'BizRelInfoEdit.jsp?domainId='+domainId+'&BizProcessInfoId='+BizProcessInfoId+'&BizProcessnodeId='+BizProcessnodeId;
							parent.setCenterUrl(url);
							parent.parent.parent.parent.cui.message("删除成功!","success");
						});
						dwr.TOPEngine.setAsync(true);
					}
				});
			}else{
				parent.cui.alert("请选定业务关联！");
			}
	}	
	
	//单击事件
	function clickCallback(flag){
		var selectNode=cui("#BizRelInfoTree").getActiveNode();
		var selectNodeKey=selectNode.getData('key');
		var url = 'BizRelInfoEdit.jsp?domainId='+domainId+'&BizProcessInfoId='+BizProcessInfoId+'&BizProcessnodeId='+BizProcessnodeId;
		url+="&BizRelInfoId="+selectNodeKey;
		parent.setCenterUrl(url);
	}
	
	function editRelInfo(selectNodeKey){
		var url = 'BizRelInfoEdit.jsp?domainId='+domainId+'&BizProcessInfoId='+BizProcessInfoId+'&BizProcessnodeId='+BizProcessnodeId;
		url+="&BizRelInfoId="+selectNodeKey;
		parent.setCenterUrl(url);
	}
	
	//新增业务关联
	function importRelInfo(){
		var url = 'BizRelInfoEdit.jsp?domainId='+domainId+'&BizProcessInfoId='+BizProcessInfoId+'&BizProcessnodeId='+BizProcessnodeId;
		parent.setCenterUrl(url);
	}
	
</script>
</body>
</html>