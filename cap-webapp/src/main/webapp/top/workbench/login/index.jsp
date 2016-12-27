<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%
    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
    String version = formatter.format(new Date());
%>
<html>
<head>
<title>登录-中国南方电网</title>
<%
    //360浏览器指定webkit内核打开
%>
<meta name="renderer" content="webkit">
<%
    //关闭ie兼容模式,使用最高版本文档模式渲染页面
%>
<meta http-equiv="x-ua-compatible" content="IE=edge">
<link rel="shortcut icon"
	href="${pageScope.cuiWebRoot}/top/workbench/base/img/logo.ico">
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/workbench/base/css/base.css?v=<%=version%>" />
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/workbench/login/css/login.css?v=<%=version%>" />
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css"
	type="text/css">
<script type="text/javascript"
	src='${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js'></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/js/jquery.js?v=<%=version%>"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/workbench/component/cui/cStorage/cStorage.full.min.js?v=<%=version%>"></script>
<c:if
	test="${requestScope.loginPictureId!=null && requestScope.loginPictureId!=''}">
<style type="text/css">
/* 更换背景图片 */
html {
	background-image:
		url("${pageScope.cuiWebRoot}/top/workbench/loginpicture/display.ac?id=${requestScope.loginPictureId}");
}
</style>
</c:if>
<style type="text/css">
em {
	font-weight: normal;
	font-style: normal
}

.SD-tipbox {
	background-color: #FFFFE9;
	border: 1px solid #FFDE8E;
	padding: 5px 25px 5px 10px;
	margin: 10px;
	position: absolute;
	z-index: 100;
	font-size: 12px;
	-moz-border-radius: 5px;
	-webkit-border-radius: 5px;
	border-radius: 5px;
	-moz-box-shadow: 1px 1px 2px rgba(0, 0, 0, .2);
	-webkit-box-shadow: 1px 1px 2px rgba(0, 0, 0, .2);
	box-shadow: 1px 1px 2px rgba(0, 0, 0, .2);
	margin-top: 20px;
}

.SD-tipbox .SD-tipbox-direction {
	position: absolute;
}

.SD-tipbox .SD-tipbox-direction em,.SD-tipbox .SD-tipbox-direction span
	{
	height: 19px;
	width: 17px;
	font-family: Simsun;
	font-size: 16px;
	line-height: 21px;
	overflow: hidden;
	position: absolute;
}

.SD-tipbox .SD-tipbox-direction em {
	color: #FFDE8E;
}

.SD-tipbox .SD-tipbox-direction span {
	color: #FFFFE9;
}

.SD-tipbox .SD-tipbox-up {
	left: 50%;
	margin-left: -8px;
	top: -10px;
	*top: -11px;
	_top: -10px;
}

.SD-tipbox .SD-tipbox-up span {
	top: 1px
}
</style>
</head>
<body>
	<div class="top-bar">
		<h2 class="workbench-logo"></h2>
		<a id="addFav" href="#" class="fav" hidefocus="true"><i>＋</i><span>点击收藏</span></a>
	</div>
	<div class="contact">
		<div class="login-wrap">
			<h2 id="chineseSystemName"></h2>
			<div id="loginTip" class="login-tip">请输入有效的用户名或密码！</div>
			<form id="loginForm" class="login-form"
				action="<c:out value='${pageScope.cuiWebRoot}/login.ac'/>"
				method="post">
				<input type="hidden" id="mainUrl" name="mainUrl" />
				<!-- value="<c:out value='${param.url}'/>" -->
				<input type="hidden" id="url" name="url"
					value="<c:out value='${param.url}'/>" />
				<div id="loginUserName" class="login-input-wrap">
					<span>用户名</span>
					<div>
						<input id="userName"  autocomplete="off"  name="account" type="text"
							value="<c:out value='${param.account}'/>">
					</div>
				</div>
				<div id="loginPassWord" class="login-input-wrap">
					<span>密码</span>
					<div>
					    <input type="password" style="display: none;">
						<input id="passWordHidden" name="password" type="hidden" value="">
						<input id="passWord" autocomplete="off" type="password" value="" onkeypress="detectCapsLock()" onkeyup="onkeyupCapsLock()" onfocus="onfocusCapsLock()" onblur="onfocusCapsLock()">
					</div>
				</div>
				<div class="SD-tipbox"
					style="top: 185px; left: 113px; max-width: 150px; position: absolute; display: none;"
					id="capital">
					<div class="cntBox">大写锁定打开，保持大写锁定打开可能会使您错误输入密码</div>
					<div class="SD-tipbox-direction SD-tipbox-up" style="left: 20px">
						<em>&#9670;</em><span>&#9670;</span>
					</div>
				</div>
			</form>
			<div class="login-entries">
				<label for="rememberMe" hidefocus="true"> <input
					type="checkbox" name="" id="rememberMe" /> 记住我
				</label>
			</div>
			<a id="loginBtn" href="javascript:;" hidefocus="true"
				class="login-btn">登录</a>
			<p class="forget-password-tip" id="forget-password-tip"></p>
		</div>
		<div class="login-wrap-ie6"></div>
	</div>
	<div class="footer-bar">
		<p>Copyright&copy;&nbsp;1999-2014&nbsp;Shenzhen&nbsp;Comtop&nbsp;Co.,Ltd.</p>
		<p>深圳市康拓普信息技术有限公司</p>
		<p>粤ICP备06044847号</p>
		<div class="footer-bar-ie6"></div>
	</div>
	<script type="text/javascript"
		src="${pageScope.cuiWebRoot}/top/workbench/login/js/login.js?v=<%=version%>"
		charset="utf-8"></script>
	<script>
        var loginMsg = eval(${requestScope.loginMessageVO})||{};
        var loginConfig = eval(${requestScope.initConfig})||{};
        if(!loginConfig.chineseSystemName){
            //如果没有配置，或者配置为空字符串，就给个默认的系统名称
        	loginConfig.chineseSystemName="企业级资产管理系统";
        }
        $("#chineseSystemName").html(loginConfig.chineseSystemName);
		$('#forget-password-tip').html(loginConfig.forgetPasswordTip);
		//单点登录
		if(loginConfig && loginConfig.SSO4ASwitch && loginConfig.SSO4ASwitch === '1'){
			$('#loginForm').attr('action','${pageScope.cuiWebRoot}/interface4ASSO.ac');
		}
		
        if(loginMsg && loginMsg.loginMessage){
            if( loginMsg.loginMessage == 'accountIsLocked' || (loginMsg.leaveErrorTime == 0 && loginMsg.loginMessage!='accountNotExist')){
                LoginAction.loginTipHandle(true,'您输入的账号已被锁定，请联系管理员');
            }else if(loginMsg.leaveErrorTime > 0){
                //生产要求删除“，还可以输入' + loginMsg.leaveErrorTime + '次”
                LoginAction.loginTipHandle(true,'您输入的账号或密码不正确');
            }else{
                LoginAction.loginTipHandle(true,'您输入的账号或密码不正确');
            }
            //登录失败,忘记密码
            LoginAction.forgetFormData();
        }
        <c:if test="${param.url == null || param.url == ''}" >
        if(loginConfig && loginConfig.mainFrameURL){
            var mainUrl = loginConfig.mainFrameURL;
            if(mainUrl.indexOf(webPath) > -1){
            	mainUrl = mainUrl.substring(webPath.length);
            	//TOP要求修改
                //mainUrl =webPath + '/' + mainUrl;
            }
            $('#mainUrl').val(mainUrl);
        }
        </c:if>
		var capital = false;
		//是否点击了CapsLock
		var isCapsLock=false;
		//开始大小写时的样式控制
		 function toggle(s){
				var sy = document.getElementById('capital').style; 
				var d = sy.display; 
				if(s){
				sy.display = s; 
				}else{
				sy.display = d =='none' ? '' : 'none'; 
				} 
		} 
		//检查是否开启大小写
        function detectCapsLock(event){
			if(capital){return}; 
			var e = event||window.event; 
			var keyCode = e.keyCode||e.which; // 按键的keyCode 
			var isShift = e.shiftKey ||(keyCode == 16 ) || false ; // shift键是否按住 
			if (((keyCode >= 65 && keyCode <= 90 ) && !isShift) // Caps Lock 打开，且没有按住shift键 
					|| ((keyCode >= 97 && keyCode <= 122 ) && isShift)// Caps Lock 打开，且按住shift键 
					){
				   toggle('block');
				   isCapsLock=true;
				   capital=true;
				}else{
					toggle('none');
					isCapsLock=false;
				} 
	    }
      //焦点在密码框,按大小写切换时，检测键盘大小写
		function onkeyupCapsLock(event){
			var e = event||window.event; 
			if(e.keyCode == 20 && capital){
				toggle(); 
			    return false; 
			   } 
		}
		//密码框获取焦点，检测键盘大小写
		function onfocusCapsLock(event){
			capital=false;
			if(isCapsLock){
				toggle('block');
			}
			detectCapsLock();
		}
		//密码框失去焦点，检测键盘大小写
		function onblurCapsLock(event){
			capital=false;
			toggle('none');
		}
    </script>
</body>
</html>