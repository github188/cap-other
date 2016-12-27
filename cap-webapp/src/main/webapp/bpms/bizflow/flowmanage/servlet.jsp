<%@ page import="java.util.Date"%>
<%@ page import="java.lang.String"%>
<%@ page import="com.comtop.bpms.client.IHumanNodeServiceClient"%>
<%@ page import="com.comtop.bpms.client.ClientFactory"%>
<%@ page import="com.comtop.bpms.common.model.NodeInfo"%>
<%@ page import="com.comtop.bpms.common.model.WorkFlowParamVO"%>
<%@ page import="com.comtop.bpms.common.model.UserInfo"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.lang.System"%>
<%@ page import="net.sf.json.JSONArray"%>
<%
/**
	URL实例：
	type1: http://10.10.5.188:9090/web/bpms/bizflow/flowmanage/servlet.jsp?action=1&processId=us_test_001&orgId=&toTaskId=2758de701d1c413583dcad56c9659db6_10&userId=SuperAdmin
  type2: http://10.10.5.188:9090/web/bpms/bizflow/flowmanage/servlet.jsp?action=2&processId=us_test_001&orgId=&version=1&nodeId=Task_2&nameKeyWord=&pageNo=1&pageSize=8
  type3: http://10.10.5.188:9090/web/bpms/bizflow/flowmanage/servlet.jsp?action=3&processId=us_test_001&orgId=&version=1&nodeId=Task_3&nameKeyWord=
*/

request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");

String action = request.getParameter("action");

String processId = request.getParameter("processId");
String toTaskId = request.getParameter("toTaskId");
String userId = request.getParameter("userId");
String orgId = request.getParameter("orgId");
String version = request.getParameter("version");
String nodeId = request.getParameter("nodeId");
String nameKeyWord = request.getParameter("nameKeyWord");
String pageNo = request.getParameter("pageNo");
String pageSize = request.getParameter("pageSize");
System.out.println("nameKeyWord1="+nameKeyWord);
if (null != nameKeyWord) {
    nameKeyWord = new String(nameKeyWord.getBytes("ISO8859-1"), "UTF-8");
}
System.out.println("nameKeyWord2="+nameKeyWord);

String returnStr = "";
IHumanNodeServiceClient objClient = ClientFactory.getHumanNodeService();
Map<String, Integer> objParameterMap = new HashMap<String, Integer>();
//objParameterMap.put("val", 3000);

objParameterMap.put("age", 25);
WorkFlowParamVO objWorkFlowParamVO = new WorkFlowParamVO();
objWorkFlowParamVO.setProcessId(processId);
objWorkFlowParamVO.setOrgId(orgId);

if ("1".equals(action)) {//查询节点接口

		NodeInfo[] nodeInfoArr = objClient.querySpecialForeUserNodes(processId, toTaskId, userId, objParameterMap);
		returnStr = JSONArray.fromObject(nodeInfoArr).toString();

} else if ("2".equals(action)) {//查询节点用户接口
		version = (null == version) ? "1" : version;
		UserInfo[] userInfoArr = objClient.queryNodeAllPostUsers(objWorkFlowParamVO, Integer.valueOf(version), nodeId, nameKeyWord, objParameterMap);
		returnStr = JSONArray.fromObject(userInfoArr).toString();

} else if ("3".equals(action)) {//查询节点用户数接口
	
		int n = objClient.queryNodePostUsersCount(objWorkFlowParamVO, Integer.valueOf(version), nodeId, nameKeyWord, objParameterMap);
		returnStr = String.valueOf(n);
}

out.print(returnStr);
out.flush();

%>