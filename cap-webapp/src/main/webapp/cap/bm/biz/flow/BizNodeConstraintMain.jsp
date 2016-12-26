<%
  /**********************************************************************
	* CAP业务流程编辑
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>业务模型管理</title>
		<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
		<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js" />
		<top:link href="/cap/bm/common/top/css/top_base.css" />
		<top:link href="/cap/bm/common/top/css/top_sys.css" />
		<top:link href="/cap/bm/common/styledefine/css/public.css"/>
		<top:script src="/cap/dwr/engine.js" />
		<top:script src="/cap/dwr/util.js" />
		<top:script src="/cap/bm/common/top/js/jquery.js" />
		<top:script src="/cap/bm/common/js/capCommon.js" />
</head>
<body>
	<div uitype="Borderlayout" id="border" is_root="true">
		<div id="objList" position="left" width="150px" url="">
		</div>
		<div id="dataItemList" position="center" width="690px" url="">
		</div>
	</div>
<top:script src="/cap/dwr/interface/BizNodeConstraintAction.js" />
<script type="text/javascript">
	var domainId = "${param.domainId}";
	var BizProcessnodeId = "${param.BizProcessnodeId}";
	//业务域ID
	window.onload = function(){
		comtop.UI.scan();
		var url = 'BizNodeConstraintGrid.jsp?BizProcessnodeId='+BizProcessnodeId;
		setCenterUrl(url);
		setLeftUrl('BizNodeConstraintTree.jsp?domainId='+domainId+'&BizProcessnodeId='+BizProcessnodeId);
	}
	//设置左侧布局链接界面 
	function setLeftUrl(url){
		cui("#border").setContentURL("left",url);
	}
	//设置中间布局链接页面
	function setCenterUrl(url){
		cui("#border").setContentURL("center",url);
	}
	
	//弹出流程节点维护页面
	function selectObjInfoItem(){
		var title="业务对象数据项选择";
		var url = "${pageScope.cuiWebRoot}/cap/bm/biz/info/BizObjInfoDataItemSelect.jsp?domainId="+domainId;
		var height = 800; //600
		var width =  1200; // 680;
		var y = (document.body.clientHeight -height)/2-10; 
		var x = (document.body.clientWidth-width)/2; 
		dialog = cui.dialog({
			title:title,
			src : url,
			top : y,
			left : x,
			width : width,
			height : height
		})
		dialog.show(url);
	}
	
	//选择数据对象数据回调函数
	function chooseBizObjInfoCallback(dataItems,BizObjInfoId){
		var allData = new Array();
		allData = getArray(dataItems,BizObjInfoId);
		if(allData == 0){
			cui.alert("选择的数据项已经导入。");
			return;
		}
		var flag=false;
		dwr.TOPEngine.setAsync(false);
		BizNodeConstraintAction.saveBizNodeConstraintList(allData, function(bResult){
			flag=bResult;
		});
		dwr.TOPEngine.setAsync(true);
		if(flag){
			cui.message('导入成功。','success');
			var url = 'BizNodeConstraintTree.jsp?domainId='+domainId+'&BizProcessnodeId='+BizProcessnodeId+"&bizObjId="+BizObjInfoId;
			setLeftUrl(url);
			setCenterUrl('BizNodeConstraintGrid.jsp?BizProcessnodeId='+BizProcessnodeId+"&bizObjId="+BizObjInfoId);
		}
	}
	
	function getArray(dataItems,BizObjInfoId){
		var query = {};
		var result = [];
		query.nodeId = BizProcessnodeId;
		query.bizObjId = BizObjInfoId;
		dwr.TOPEngine.setAsync(false);
		BizNodeConstraintAction.queryBizNodeConstraintList(query,function(data){
			if(data.count >0){
				result = data.list;
			}
		});
		dwr.TOPEngine.setAsync(true);
		var BizNodeConstraintLst = new Array();
		 for(var i = 0;i<dataItems.length;i++){
			 var flag = true;
			 for(var j = 0;j<result.length;j++){
				 if(dataItems[i].id == result[j].objDataId){
					 flag = false;
					 break;
				 }
			 }
			 if(flag){
				 var BizNodeConstraint={};
				 BizNodeConstraint.nodeId = BizProcessnodeId;
				 BizNodeConstraint.bizObjId = BizObjInfoId;
				 BizNodeConstraint.objDataId = dataItems[i].id;
				 BizNodeConstraintLst.push(BizNodeConstraint);
			 }
		 }
		 return BizNodeConstraintLst;
	}
</script>
</body>
</head>
</html>