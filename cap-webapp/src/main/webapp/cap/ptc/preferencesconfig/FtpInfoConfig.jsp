<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>FTP服务器信息配置</title>
<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
<style type="text/css">
fieldset{
    border: 1px solid rgb(204, 204, 204);
}
legend{
   margin-left: 10px;
   font-family: 微软雅黑;
   color: #2b71d9;
   font-size: 14px;
}
.label{
	display:inline-block;
	text-align:right;
	width: 140px;
	font-family: 微软雅黑;
	font-size: 14px;
}
.field{
	margin-bottom: 5px;
}
</style>

<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
<top:script src='/cap/dwr/engine.js'></top:script>
<top:script src='/cap/dwr/util.js'></top:script>
<top:script src='/cap/dwr/interface/TopConfig4FtpConfigReader.js'></top:script>
</head>
<body>
<span style="text-align: right;display: block;"><span id="savebtn" uitype="button" label="保存" button_type="blue-button" on_click="saveFtpConfig"></span></span>
<!-- FTP服务信息配置 -->
<fieldset>
	<legend>***FTP服务信息配置***</legend>
	<div class="field">
		 <span class="label"><span style="color: red;">*</span>IP地址：</span>
	    <span id="ip" uitype="Input" databind="ftpConfig.cap_cdp_ftp_ip" validate="IP不能为空"></span>
	    <span title="配置FTP服务器的IP地址" style="color: #39c;font-family: 微软雅黑;font-size: 14px;">配置FTP服务器的IP地址</span>
	</div>
	<div class="field">
	    <span class="label"><span style="color: red;">*</span>端口：</span>
	    <span id="port" uitype="Input" databind="ftpConfig.cap_cdp_ftp_port" value="2121"></span>
	    <span title="配置FTP服务器的port" style="color: #39c;font-family: 微软雅黑;font-size: 14px;">配置FTP服务器的port,默认为2121</span>
	</div>
	<div class="field">
	    <span class="label"><span style="color: red;">*</span>用户名：</span>
	    <span id="ftpUserName" uitype="Input" databind="ftpConfig.cap_cdp_ftp_username" validate="FTP用户名不能为空"></span>
	    <span title="配置FTP服务器访问的用户名" style="color: #39c;font-family: 微软雅黑;font-size: 14px;">配置FTP服务器访问的用户名</span>
	</div>
	<div class="field">
	   <span class="label"><span style="color: red;">*</span>密码：</span>
	   <span id="ftpPsd" uitype="Input" type="password" databind="ftpConfig.cap_cdp_ftp_passwd" validate="FTP用户密码不能为空"></span>
	   <span title="配置FTP服务器访问的密码" style="color: #39c;font-family: 微软雅黑;font-size: 14px;">配置FTP服务器访问的密码</span>
	</div>
	<div class="field">
	    <span class="label"><span style="color: red;">*</span>FTP字符集：</span>
	    <span id="encoding" uitype="Input" databind="ftpConfig.cap_cdp_ftp_encoding" readonly="true" value="UTF-8"></span>
	    <span title="FTP字符集" style="color: #39c;font-family: 微软雅黑;font-size: 14px;">FTP字符集，目前统一为UTF-8</span>
	</div>
	<div class="field">
	    <span class="label"><span style="color: red;">*</span>FTP根路径：</span>
	    <span id="basepath" uitype="Input" databind="ftpConfig.cap_cdp_ftp_basepath" readonly="true" value="/"></span>
	    <span id="testFtp" uitype="button" button_type="orange-button" on_click="testFtp" label="连接测试"></span>
	</div>
</fieldset>
<fieldset>
	<legend>***文档管理文件上传方式***</legend>
	<div>
		<span class="label"><label style="color:red">*</label>上传方式：</span>
		<span uitype="RadioGroup" name="ball" value="ftp" databind="ftpConfig.cap_file_upload_type" on_change="changeHandler">
	        <input type="radio" value="http" text="http" />
	        <input type="radio" value="ftp" text="ftp" />
	    </span>
		<div class="field">
		    <span class="label"><label style="color:red">*</label>http根据路径：</span>
		    <span id="httpBasePath" uitype="Input" databind="ftpConfig.cap_cdp_http_basepath" readonly="true" value="/http/uplod"></span>
		    <span title="FTP字符集" style="color: #39c;font-family: 微软雅黑;font-size: 14px;">http根据路径,上传文档存储的ftp路径。目前统一为:/http/uplod</span>
		</div>
	</div>
</fieldset>
<fieldset>
	<legend>***上传文件访问URL***</legend>
	<div class="field">
		   <span class="label"><label style="color:red">*</label>上传文件访问URL：</span>
		   <span id="visitUrl" uitype="Input" databind="ftpConfig.cap_cdp_file_visit_url" validate="上传文件访问URL不能为空"></span>
		   <span title="上传文件访问URL" style="color: #39c;font-family: 微软雅黑;font-size: 14px;">上传文件访问URL,访问已上传文件URL。格式为：http://ip:port/appname/</span>
	</div>
</fieldset>
<script type="text/javascript">
var ftpConfig={};
jQuery(document).ready(function() {
	var dwrCallBack={
				callback:function(config){
					cui(ftpConfig).databind().setValue(config);
					comtop.UI.scan();	
				},
				errorHandler:function(){
					comtop.UI.scan();
					cui('#savebtn').disable(true);
				}
				
		};
	TopConfig4FtpConfigReader.readFtpConfigFromTopConfig(dwrCallBack);
});

function saveFtpConfig(){
	var map = window.validater.validAllElement();
    var inValid = map[0];
    var valid = map[1];
  //验证消息
	if(inValid.length > 0){//验证失败
		var str = "";
        for (var i = 0; i < inValid.length; i++) {
			str += inValid[i].message + "<br />";
		}
	}else{
		var saveData = cui(ftpConfig).databind().getValue();
		TopConfig4FtpConfigReader.saveFtpConfig(saveData,function(result){
			if(result){
				cui.alert("保存成功!",function(){
					window.location.reload();
				});
			}else{
				cui.error("保存失败:"+result);
			}
		});
	}
}
function testFtp(){
	var map = window.validater.validAllElement();
    var inValid = map[0];
    var valid = map[1];
  //验证消息
	if(inValid.length > 0){//验证失败
		var str = "";
        for (var i = 0; i < inValid.length; i++) {
			str += inValid[i].message + "<br />";
		}
	}else{
		var saveData = cui(ftpConfig).databind().getValue();
		TopConfig4FtpConfigReader.testFtpConnect(saveData,function(result){
			if(result){
				cui.alert("连接成功!");
			}else{
				cui.error("连接失败,请检查ip、port、帐号、密码等关键信息是否正确！");
			}
		});
	}
}
</script>
</body>
</html>