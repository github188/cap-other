<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.slf4j.org/taglib/tld" prefix="log"%> 
<%@ taglib uri="http://www.szcomtop.com/top" prefix="top"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@page import="com.comtop.top.component.common.systeminit.ServerConstant"%>
<%@page import="com.comtop.top.sys.login.util.LoginConstant"%>
<%@page import="com.comtop.top.sys.usermanagement.user.model.UserDTO"%>
<%@page import="com.comtop.cap.ptc.login.utils.CapLoginUtil"%>
<%@page import="com.comtop.cap.ptc.login.model.CapLoginVO"%>
<%@page import="com.comtop.cap.runtime.base.action.ServiceInvokehelper"%>
<top:noCache/>
<%		
	response.setHeader("Content-Type", "text/html; charset=UTF-8");
	request.setCharacterEncoding("UTF-8");
	pageContext.setAttribute("pageEncoding", "UTF-8");
	UserDTO objUserDTO =(UserDTO)session.getAttribute(LoginConstant.SECURITY_CURR_USER_INFO_KEY);
	pageContext.setAttribute("userInfo",objUserDTO);
	pageContext.setAttribute("cuiWebRoot",request.getContextPath()); 
	CapLoginVO objCAPLoginVO =(CapLoginVO)session.getAttribute(CapLoginUtil.CAP_CURRENT_USER);
	pageContext.setAttribute("capEmployee",objCAPLoginVO);
	//是否隐藏系统功能按钮 true 隐藏 false 不隐藏，值登录时写入
	Boolean objHideSystemBtn = (Boolean)session.getAttribute(LoginConstant.HIDE_SYSTEM_BTN);
	boolean isHideSystemBtn = false;
	if(objHideSystemBtn != null && objHideSystemBtn){
	    isHideSystemBtn = true; 
	}
	if(!ServiceInvokehelper.isDevelopRunningModel()){
		ServiceInvokehelper.setRunningModelToDevelopModel();
	}
%>
<script language="javascript">
	var globalUserId ='${userInfo.userId}';
	var globalUserName ='${userInfo.employeeName}';
	var globalOrganizationId ='${userInfo.orgId}';
	var globalOrganizationName ='${userInfo.orgName}'; 
	//cap全局变量（登陆人员，团队信息）
	var globalCapEmpAccount = '${capEmployee.account}';
	var globalCapEmployeeId = '${capEmployee.bmEmployeeId}';
	var globalCapEmployeeName = '${capEmployee.bmEmployeeName}';
	var globalCapTeamId = '${capEmployee.bmTeamId}';
	var globalCapRoleIds = '${capEmployee.roleIds}';
// 	var globalCapTeamName = '${capEmployee.bmTeamName}';
	var webPath = '<top:webRoot/>';
</script>
<log:debug category="jsp.request">
  <!-- 平台版本:<%=ServerConstant.VERSION%>,平台更新日期:<%=ServerConstant.PULISH_DATE%> -->
 <top:info type="url"/>
</log:debug>
