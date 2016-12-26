<!doctype html>
<%
  /**********************************************************************
	*  方法参数编辑
	* 2016-6-1 林玉千 新增
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ page import="java.util.*" %>

<html>
<head>
<title>参数编辑页面</title>
	<top:link href="/cap/bm/common/top/css/top_base.css"></top:link>
	<top:link href="/cap/bm/common/top/css/top_sys.css"></top:link>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
</head>
<style>
.top_header_wrap {
	padding-right: 5px;
}
</style>
<body>
	<div class="top_header_wrap">
		<div class="thw_title">参数信息编辑</div>
		<div class="thw_operate">
			<span uitype="button" label="保存" on_click="save"></span> 
			<span uitype="button" label="关闭" on_click="closeWin"></span>
		</div>
	</div>
	<div id="editDiv"  class="top_content_wrap cui_ext_textmode" >
		<table class="form_table" style="table-layout:fixed;">
			<colgroup>
				<col width="30%" />
				<col width="70%" />
			</colgroup>
			<tr>
				<td class="td_label"><span class="top_required"></span>参数名称：</td>
				<td><span uitype="input" id="parameterName" name="parameterName"
					 maxlength="50"></span>
				</td>
			</tr>
			<tr>
				<td class="td_label"><span class="top_required">*</span>中文名称：</td>
				<td>
					<span uitype="input" id="parameterChName" name="parameterChName"  
						></span>
				</td>
			</tr>
		</table>
	</div>
	<script type="text/javascript">
	//属性
	var objectVO = $.extend(true, {}, parent.objectVO);
	//初始化 
	window.onload = function(){
		comtop.UI.scan();
		init();
   	}
	function init(){
		cui("#parameterName").setValue(objectVO.parameterName);
		cui("#parameterChName").setValue(objectVO.parameterChName);
		cui("#parameterName").setReadonly(true);
	}
	//保存数据
	function save(){
		objectVO.parameterName = cui("#parameterName").getValue();
		objectVO.parameterChName = cui("#parameterChName").getValue();
		parent.editParameterBack(objectVO);
		closeWin();
	}
	//关闭窗口
	function closeWin() {
		parent.dialog.hide();
	}
	</script>
</body>
</html>