<%
  /**********************************************************************
	* CAP业务基本信息
	* 2015-11-03 姜子豪 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
<title>基本信息管理</title>
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
.top_header_wrap{
				margin-right:28px;
				margin-top: 4px;
				margin-bottom:4px;
}
</style>
<body>
		<div class="top_header_wrap">
			<div class="thw_operate">
				<span uitype="button" id="btnMove" label="新增功能项" on_click="addFunItem"  button_type="blue-button"></span>
<!-- 				<span uitype="button" id="btnCancel" label="功能分布" on_click="cancel"></span> -->
			</div>
		</div>
		<div class="top_content_wrap cui_ext_textmode">
			<table class="form_table" style="table-layout: fixed;">
				<colgroup>
					<col width="15%" />
					<col width="35%" />
					<col width="15%" />
					<col width="35%" />
				</colgroup>
				<tr>
					<td class="divTitle">业务域信息</td>
				</tr>
				<tr>
					<td class="td_label">上级名称：</td>
					<td><span uitype="input" id="parentName" name="parentName" databind="domainInfo.parentName" maxlength="200" width="85%" readonly="true"></span></td>
					<td class="td_label">编码：</td>
					<td><span uitype="input" id="code" name="code" databind="domainInfo.code" maxlength="250" width="85%" readonly="true"></span></td>
				</tr>
				<tr>
					<td class="td_label">名称：</td>
					<td><span uitype="input" id="name" name="name" databind="domainInfo.name" maxlength="200" width="85%" readonly="true"></span></td>
					<td class="td_label">简称：</td>
					<td><span uitype="input" id="shortName" name="shortName" databind="domainInfo.shortName" maxlength="36" width="85%" readonly="true"></span></td>
				</tr>
			</table>
		</div>
	<top:script src="/cap/dwr/interface/BizDomainAction.js" />
<script type="text/javascript">
	var selectDomainId = "${param.selectDomainId}";
	window.onload = function(){
		init();
		}
	
	//初始化界面加载
	function init(){
		if(selectDomainId){
   			dwr.TOPEngine.setAsync(false);
   			BizDomainAction.queryDomainById(selectDomainId,function(data){
   				if(data){
   					domainInfo=data;
   	   				parentId=data.paterId;
   				}
   			});
   			dwr.TOPEngine.setAsync(true);
   		}
		if(parentId){
			dwr.TOPEngine.setAsync(false);
			BizDomainAction.queryDomainById(parentId,function(data){
   				domainInfo.parentName=data.name;
   			});
   			dwr.TOPEngine.setAsync(true);
		}
		comtop.UI.scan();
	}
	
	//
	function addFunItem(){
		var url = "<%=request.getContextPath() %>/cap/bm/req/func/ReqFunctionItemEdit.jsp?domainId="+selectDomainId;
		window.location.href = url;
	}
</script>
<top:script src="/cap/bm/biz/domain/js/DomainInfo.js" />
</body>
</html>