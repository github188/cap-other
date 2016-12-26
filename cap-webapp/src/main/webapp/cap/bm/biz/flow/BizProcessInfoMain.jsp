<%
  /**********************************************************************
	* CIP元数据建模----服务新增
	* 2015-6-30 李小芬 新增
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<!doctype html>
<html>
<head>
<title>服务新增</title>
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_sys.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/top/js/jquery.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/engine.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/util.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/BizItemsAction.js'></script>
</head>
<style>
.top_header_wrap {
	padding-right: 5px;
}
.spanTop {
  font-family: "Microsoft Yahei";
  font-size: 20px;
  color: #0099FF;
  margin-left: 20px;
  float: left;
  line-height:45px;
}
.divTitle {
  font-family: "Microsoft Yahei";
  font-size: 14px;
  color: #0099FF;
  margin-left: 20px;
  float: left;
}
.editGrid{
  margin-left: 100px;
}
</style>
<body>
<div uitype="Borderlayout" id="bizFlowMain" is_root="true" style="height: 100%" >
	<div position="left" width="180px" collapsable="true" show_expand_icon="true">
		<div class="thw_operate" id="BizProcessInfoDiv">
			<span uitype="ClickInput" id="keywords" on_iconclick="search" width="175" icon="search" maxlength="200" editable="true" emptytext="请输入名称、编码进行查询" on_keydown="keyDownQuery"></span>
		</div>
		<table uitype="Grid" id="BizMattersGrid" primarykey="id" sorttype="1" datasource="initBizMattersDatasource" pagination="false"
				gridwidth="180"  gridheight="auto"  selectrows="single" colrender="columnRenderer" rowclick_callback="selectOneMatters">
			<thead>
			<tr>
				<th style="width:30px;">&nbsp;</th>
				<th bindName="name" renderStyle="text-align: left;" style="width:85%;" >业务事项列表</th>
			</tr>
			</thead>
		</table>
    </div>
    <div position="center">
	</div>
</div>
<script type="text/javascript">
	//业务域ID
	var domainId = "${param.domainId}";
	var selItemsId = "${param.selItemsId}";
	//初始化
	window.onload = function(){
		var objectMainDiv= $("bizFlowMain");
		comtop.UI.scan();		
		if(selItemsId){
			cui("#BizMattersGrid").selectRowsByPK(selItemsId, true);
		}
	}
	//单击行事件 
	function selectOneMatters(rowData,isChecked,index){
		setCenterListUrl(rowData.id);
	}
	//获取业务事项列表
	function initBizMattersDatasource(tableObj,query) {
		dwr.TOPEngine.setAsync(false);
			query.keyWords=cui("#keywords").getValue();
			query.domainId = domainId;
			BizItemsAction.queryBizItemsList(query,function(data){
				 tableObj.setDatasource(data.list, data.count);
				 if(data.count>0 && selItemsId ==""){
					 selItemsId = data.list[0].id;
					 tableObj.selectRowsByPK(selItemsId);
				 }
				 setCenterListUrl(selItemsId);
			});
		dwr.TOPEngine.setAsync(true);
	}
	
	function setCenterListUrl(selItemsId){
		var url = "BizProcessInfoList.jsp?selItemsId=" + selItemsId+"&domainId="+domainId;
		cui("#bizFlowMain").setContentURL("center",url); 
	}
	
	//查找
	function search(){
		cui("#BizMattersGrid").loadData();
	}
	
	//键盘回车键快速查询 
	function keyDownQuery() {
		if ( event.keyCode ==13) {
			search();
		}
	}
	
	//流程编辑
	function editProcess(url){
		window.location.href = url;
		/**var title="业务流程编辑";
		var height = 800; //600
		var width =  1000; // 680;
		dialog = cui.dialog({
			title:title,
			src : url,
			width : width,
			height : height
		})
		dialog.show(url);**/
	}
	
	
</script>
</body>
</html>