
<%
  /**********************************************************************
	* CIP生成代码
	* 2014-8-6 沈康 新增
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>


<!doctype html>
<html>
<head>
<title>系统配置页面</title>
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" type="text/css" href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/engine.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/util.js'></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/cui.utils.js"></script>
	
</head>
<style>
.top_header_wrap {
	padding-right: 5px;
}
</style>
<body>
	<div class="top_header_wrap">
		<div class="thw_title">系统配置</div>
		<!--<div class="thw_operate">
			<span uitype="button" label="保存" on_click="save"></span> 
			<span uitype="button" label="关闭" on_click="closeSelf"></span>
		</div>-->
	</div>
	<div id="editDiv"  class="top_content_wrap cui_ext_textmode" >
		<table class="form_table" style="table-layout:fixed;">
			<colgroup>
				<col width="30%" />
				<col width="70%" />
			</colgroup>
			<tr>
				<td class="td_label"><span class="top_required">*</span>代码路径：</td>
				<td style="white-space:nowrap;">
					<span uitype="ClickInput" id="filePath" name="filePath" width="300px"
						on_iconclick="selectPath" editable="true">
					</span>
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<span uitype="button" label="保存" on_click="enSure"></span>
					<span uitype="button" label="取消" on_click="closeWin"></span>
				</td>
			</tr>
		</table>
	</div>


<script type="text/javascript">
var GEN_CODE_PATH_CNAME = "GEN_CODE_PATH_CNAME";
var _=cui.utils;
var reg = new RegExp(/^[a-zA-Z]:\\[a-zA-Z_0-9\\]*/);

function selectPath(){
	if(+[1,]) { 
		cui.alert("目前选择路径只能在IE浏览器下使用,其它浏览器请输入项目路径(例如：D:\\EAR)。");   
		return;
	}
	try {
		var strPath = new ActiveXObject("Shell.Application").BrowseForFolder(0, "请选择路径", 0, "").Items().Item().Path;
		cui("#filePath").setValue(strPath);
	}catch(e) {
		//cui.alert("选择路径需要将当前站点设置为信任站点。");
	}	
}
window.onload = function(){
	comtop.UI.scan();
	cui("#filePath").setValue(_.getCookie(GEN_CODE_PATH_CNAME));
}
function enSure() {
	var strPath = cui("#filePath").getValue();
	if(strPath == "") {
		cui.alert("请选择生成代码的路径。");
		return;
	}
	if(!reg.test(strPath)) {
		cui.alert("请输入合法的文件路径(例如：D:\\EAR)。");
		return;
	}
	_.setCookie(GEN_CODE_PATH_CNAME,strPath,new Date(2100,10,10).toGMTString(), '/');
	cui.alert("保存成功。",function(){
		window.close();
	});
}
//关闭窗口
function closeWin() {
	window.close();
}
</script>
</body>
</html>