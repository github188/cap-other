	
<%
  /**********************************************************************
   * 测试服务器配置
   *
   * 2016-6-22 zhangzunzhi 新建
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>

<!doctype html>
<html>
<head>
<title>测试服务器配置</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:link href="/cap/bm/common/base/css/base.css"></top:link>
	<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css" />
	
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src='/cap/dwr/interface/PreferenceConfigAction.js'></top:script>
	<top:script src='/cap/dwr/interface/TestServerConfigFacade.js'></top:script>
</head>
<style>
.top_header_wrap {
	padding-right: 5px;
}
.thw_title{
    margin-left: 0px;
    font-weight: bold;
    font-size: 12pt;
    float: left;
}
fieldset{
    border: 1px solid rgb(204, 204, 204);
}
legend{
   margin-left: 10px;
   font-family: 微软雅黑;
   color: #2b71d9;
   font-size: 14px;
}
.left{
  float: left;
  width: 50%;
}
#saveBtn{
  margin-left:5px;
}
.toolbar{
  padding-top: 5px;
  text-align: right;
}
#callSoaService{
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  display: block;
}
.desc{
  cursor: pointer;
}
</style>
<body >
	<div class="top_header_wrap">
		<div class="thw_title">测试服务器配置</div>
		<!-- 保存全部 -->
		<div class="toolbar">
		   <span id="saveAll" uitype="button" on_click="saveAll" label="保存"></span> 
		   <span id="testConnect" uitype="button" on_click="testConnect" label="测试连接"></span> 
		</div>
	</div>
	<hr/>
	<!-- 工程环境配置 -->
	<fieldset>
		<div id="codeConfigDiv"  class="top_content_wrap cui_ext_textmode" >
			<table class="form_table" style="table-layout:fixed;">
				<colgroup>
					<col width="15%" />
					<col width="85%" />
				</colgroup>
				<tr>
					<td class="td_label"><span class="top_required">*</span>测试服务器地址：</td>
					<td style="white-space:nowrap;">
						<span uitype="input" id="serverUrl" name="serverUrl" databind="data.serverUrl" width="60%" validate="validateServerUrl"></span>
						<a class="desc"></a>
					</td>
				</tr>
				
				<tr>
					<td class="td_label"><span class="top_required">*</span>测试服务器用户名：</td>
					<td style="white-space:nowrap;">
						<span uitype="input" id="serverName" name="serverName"  databind="data.serverName" width="60%" validate="validateServerName"></span>
						<a class="desc"></a>
					</td>
				</tr>
				
				<tr>
					<td class="td_label"><span class="top_required">*</span>测试服务器密码：</td>
					<td style="white-space:nowrap;">
						<span uitype="input" type="password" id="serverPassword" name="serverPassword"  databind="data.serverPassword"  width="60%" validate="validateServerPassword"></span>
						<a class="desc"></a>
					</td>
				</tr>
				
			</table>
		</div>
	</fieldset>
	
<script type="text/javascript">

//页面装载方法
$(document).ready(function(){
	initData();
	comtop.UI.scan();
});

//系统目录名称和编码的检测
var validateServerUrl = [
      {'type':'required','rule':{'m':'服务器地址不能为空。'}},
      { 'type':'format','rule':{'pattern':'http://.?', 'm':'服务器地址不正确'}},
    ],
    validateServerName = [
      {'type':'required','rule':{'m':'用户名不能为空。'}}
    ],
    validateServerPassword = [
       {'type':'required','rule':{'m':'密码不能为空。'}}
    ],
    data={};
    
function checkServerUrl(data){
	return true;
}    

//初始化数据
function initData(){
	dwr.TOPEngine.setAsync(false);
	PreferenceConfigAction.loadPreferenceConfig(function(result){
		data=result;
	});
	dwr.TOPEngine.setAsync(true);
}

//保持服务器配置
function saveAll(){
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
		var saveData = cui(data).databind().getValue();
		dwr.TOPEngine.setAsync(false);
		PreferenceConfigAction.savePreferenceConfig(saveData,function(result){
			if(result && result=="success"){
					cui.message('配置信息保存成功！', 'success');
					setTimeout(loadPage,600);
			}else{
				cui.error("配置信息保存失败！");
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
}

//测试连接
function testConnect(){
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
		var saveData = cui(data).databind().getValue();
		var saveRel = "false";
		dwr.TOPEngine.setAsync(false);
		PreferenceConfigAction.savePreferenceConfig(saveData,function(result){
			saveRel = result;
		});
		dwr.TOPEngine.setAsync(true);
		if(saveRel&&saveRel=="success"){
			dwr.TOPEngine.setAsync(false);
			TestServerConfigFacade.testConnect(saveData.serverUrl,saveData.serverName,saveData.serverPassword,function(result){
				if(result){
					cui.message('服务器连接成功！', 'success');
				}else{
					cui.error("服务器连接失败！");
				}
			});
			dwr.TOPEngine.setAsync(true);
		}else{
			cui.error("配置信息保存失败！");
		}
	}
}

function loadPage(){
	window.location.reload();
}
</script>
</body>
</html>