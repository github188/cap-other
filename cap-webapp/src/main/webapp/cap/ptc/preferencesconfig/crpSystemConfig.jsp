	
<%
  /**********************************************************************
	* CRP系统配置
	* 2016-5-11 杜祺 新增
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>

<!doctype html>
<html>
<head>
	<title>CRP系统配置</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:link href="/cap/bm/common/base/css/base.css"></top:link>
	<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css" />
	
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
</head>
<style>
.top_header_wrap {
	padding-right: 5px;
}
</style>
<body>
	<div class="main">
		<table style="width: 100%">
			<tr>
				<td class="cap-td" style="text-align: left; padding: 5px;width: 50%">
					<span id="formTitle" uitype="Label" value="CRP系统信息配置" class="cap-label-title" size="12pt"></span>
				</td>
				<td class="cap-td" style="text-align: right; padding: 5px;width: 50%">
					<span id="save" uitype="Button" onclick="save()" label="保存"></span> 
				</td>
			</tr>
		</table>
		<table class="form_table" style="table-layout:fixed;">
			<colgroup>
				<col width="30%" />
				<col width="70%" />
			</colgroup>
			<tr>
				<td class="td_label">CRP服务地址：</td>
				<td style="white-space:nowrap;">
				 	<span uitype="Input" id="crpServerPath" width="350px"></span>
				</td>
			</tr>
			<tr>
				<td class="td_label">CRP登录凭证：</td>
				<td style="white-space:nowrap;">
					<span uitype="Input" id="crpCredential" width="350px"></span>
				</td>
			</tr>
		</table>
	</div>

<script type="text/javascript">

var CRP_SERVER_PATH = "JENKINS_SETVER_PATH";
var CRP_CREDENTIAL = "CRP_CREDENTIAL";
var _=cui.utils;

window.onload = function(){
	comtop.UI.scan();
	var crpServerPath = _.getCookie(CRP_SERVER_PATH);
	if(crpServerPath){
		cui("#crpServerPath").setValue(trim(crpServerPath));
	}
	
	var crpCredential = _.getCookie(CRP_CREDENTIAL);
	if(crpCredential){
		cui("#crpCredential").setValue(trim(crpCredential));
	}
}

/**
 * 保存配置
 */
function save(){
	var crpServerPath = trim(cui("#crpServerPath").getValue());
	if(crpServerPath.length > 0){
		_.setCookie(CRP_SERVER_PATH,crpServerPath, new Date(2100,10,10).toGMTString(), '/');
	}
	
	var crpCredential = trim(cui("#crpCredential").getValue());
	if(crpCredential.length > 0){
		_.setCookie(CRP_CREDENTIAL,crpCredential, new Date(2100,10,10).toGMTString(), '/');
	}
}

/**
 * 去掉字符串前后空格
 * @param 字符串
 * @return 去掉前后空格后的字符串
 */
function trim(str){ 
	return str.replace(/(^\s*)|(\s*$)/g, ""); 
}

</script>
</body>
</html>