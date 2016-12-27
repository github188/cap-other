<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ page isELIgnored="false" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.Set"%>
<%@ page import="com.comtop.top.core.util.StringUtil"%>
<%@ page import="com.comtop.top.sys.usermanagement.taglib.model.UserBatchImportDTO"%>
<%@ page import="com.comtop.top.sys.usermanagement.taglib.model.OrgUserDTO"%>
<%@ page import="com.comtop.top.sys.usermanagement.taglib.model.OrgUserTreeDTO"%>
<html>
<head>
    <title>导入结果</title>
	<top:link href="/top/component/topui/cui/themes/default/css/comtop.ui.min.css"/>
    <top:link href="/top/sys/usermanagement/orgusertag/css/userBatchGuide.css"/>
    <top:script src="/top/js/jquery.js"/>
    <top:script src="/top/component/topui/cui/js/comtop.ui.min.js"/>
</head>
<%
//获取导入信息结果
UserBatchImportDTO objUserImportDetailVO = (UserBatchImportDTO)request.getAttribute("objUserImportDetail");
String errorMessage = objUserImportDetailVO.getErrorMessage();
int totalCount = objUserImportDetailVO.getTotalCount();
int successCount = objUserImportDetailVO.getSuccessCount();
int repeatImportUserCount = objUserImportDetailVO.getRepeatImportUserCount();
int failCount = objUserImportDetailVO.getFailCount();
//重复用户信息
Map<String, List<OrgUserDTO>> repeatUserMap = objUserImportDetailVO.getRepeatUserMap();
Set repeatUserNameSet = repeatUserMap.keySet();
//不存在用户信息
Map<String, List<OrgUserDTO>> notExistsUserMap = objUserImportDetailVO.getNotExistsUserMap();
Set notExistsUserNameSet = notExistsUserMap.keySet();
//获取跟部门信息
List<OrgUserTreeDTO> rootDepartmentList = objUserImportDetailVO.getRootDepartmentList();
int rootDeptListSize = objUserImportDetailVO.getRootDepartmentListSize();
//获得不存在且无近似的匹配用户信息
List<String> notExistsAndPossibleUserList = objUserImportDetailVO.getNotExistsAndPossibleUserList();
int notExistsAndPossibleUserListSize = objUserImportDetailVO.getNotExistsAndPossibleUserListSize(); 
//导入用户中查找到了相应用户 并且未出现重复用户
List<OrgUserDTO> uniqueUserList = objUserImportDetailVO.getUniqueUserList();
%>
<body class="resultBody">
    <div id="resultBox" class="resultBox" >
        <div id="importMessage" class="import_process">
            <%if(StringUtil.isEmpty(errorMessage)){ %>
	        	共<%=totalCount %>条，成功导入<span style="color: green;"><%=successCount %></span>条
	        	<%if(repeatImportUserCount>0){ %>
		    		 导入重复记录<span style="color: red;"><%=repeatImportUserCount %></span>条
		        <%} %>
		        <%if(failCount>0){ %>
		          	另有<span style="color: red;"><%=failCount %></span>条未能导入 见下框：
		        <%} %>
			<%}else{ %>
    				<span style="color: red;">*</span>&nbsp;<%=errorMessage %>
			<%} %>
        </div>
        <%if(StringUtil.isEmpty(errorMessage)){ %>
       		<%if(failCount > 0){ %>
		    <div id="errorMessage" class="error_total">
		    <%
			    for(Iterator iterator=repeatUserNameSet.iterator();iterator.hasNext();){
			        String strRepeatUserName = (String)iterator.next();
			        List<OrgUserDTO> lstRepeatUserTagVO = repeatUserMap.get(strRepeatUserName);
		    %>
	            <div class="error_object">
	                <div class="error_description" >以下人员<span style="color: red;"><%=strRepeatUserName %></span>存在重名，请选择：</div>
	                <div class="error_list" >
	                    <table style="width: 100%;">
	                    <%
	                    	for(int i=0;i<lstRepeatUserTagVO.size();i++){
	                    	    OrgUserDTO repeatUser = lstRepeatUserTagVO.get(i);
	                    %>
	                        <tr>
	                        	<td class="col0"></td>
	                            <td class="col1">
	                            	<%=repeatUser.getName() %>
	                            </td>
	                            <td class="col2">
	                            	<%=repeatUser.getBelongOrgFullName() %>
	                            </td>
	                            <td class="col3">
	                                <input type="checkbox"
	                                	userId="<%=repeatUser.getUserId() %>"
	                                	userName="<%=repeatUser.getName() %>"
	                                	departmentFullName="<%=repeatUser.getBelongOrgFullName() %>"
	                                />
	                            </td>
	                        </tr>
	                        <%} %>
	                    </table>
	                </div>
	            </div>
	            <%} %>
	            <%
	            for(Iterator iterator=notExistsUserNameSet.iterator();iterator.hasNext();){
			        String strNotExistsUserName = (String)iterator.next();
			        List<OrgUserDTO> lstNotExistsUserTagVO = notExistsUserMap.get(strNotExistsUserName);
	            %>
	            <div class="error_object">
	                <div class="error_description" >
	                	在根部门（
	                	<%
	                		for(int j=0;j<rootDepartmentList.size(); j++){
	                	%>
	                		<%=rootDepartmentList.get(j).getTitle() %>
	                		   <%if(j!=(rootDeptListSize-1)){ %>；<%} %>
	                	    <%} %>）范围内查找不到人员<span style="color: red;">
	                		  <%=strNotExistsUserName %>
	                		  </span>，您是否要找：
	                </div>
	                <div class="error_list" >
	                    <table style="width: 100%;">
	                    	<%
	                    		for(int k=0;k<lstNotExistsUserTagVO.size();k++){
	                    		    OrgUserDTO notExistsUserTagVO = lstNotExistsUserTagVO.get(k);
	                    	%>
	      					<tr>
	      						<td class="col0"></td>
	                            <td class="col1">
	                            	<%=notExistsUserTagVO.getName() %>
	                            </td>
	                            <td class="col2">
	                            	<%=notExistsUserTagVO.getBelongOrgFullName() %>
	                            </td>
	                            <td class="col3">
	                                <input type="checkbox"
	                                	userId="<%=notExistsUserTagVO.getUserId() %>"
	                                	userName="<%=notExistsUserTagVO.getName() %>"
	                                	departmentFullName="<%=notExistsUserTagVO.getBelongOrgFullName() %>"
	                                />
	                            </td>
	                        </tr>
	                        <%} %>
	                    </table>
	                </div>
	            </div>
	            <%} %>
	            <%
	            	if(notExistsAndPossibleUserListSize>0){
	            %>
				<div class="error_object">
					<div class="error_list">
						<div class="error_description">
		                	在当前搜索范围内（根部门为：
		                	<%
	                		for(int j=0;j<rootDepartmentList.size();j++){
	                		%>
	                		<%=rootDepartmentList.get(j).getTitle() %>
	                		   <%if(j!=(rootDeptListSize-1)){ %>；<%} %>
	                	    <%} %>）查找不到可匹配的人员：<br/>
	                	    <%
	                	    	for(int t=0;t<notExistsAndPossibleUserList.size();t++){
	                	    %>
		                		<span style="color: red;"><%=notExistsAndPossibleUserList.get(t) %></span>
		                		<%if(t!=(notExistsAndPossibleUserListSize-1)){ %>
		                			；
		                		<%} %>
		                	<%} %>
						</div>
		            </div>
		        </div>
		        <%} %>
		    </div>
        <%}} %>
    </div>
    <%if(StringUtil.isEmpty(errorMessage)){ %>
    <div class="bottom">
    	<span uitype="button" label="确定" mark="1" on_click="confirmImport"></span>
    </div>
    <%} %>
	<%
		for(int n=0;n<uniqueUserList.size();n++){
		    OrgUserDTO uniqueUserTag = uniqueUserList.get(n);
	%>
 	<input type="hidden"
 		id="uniqueUser_<%=uniqueUserTag.getUserId() %>"
        userId="<%=uniqueUserTag.getUserId() %>"
        userName="<%=uniqueUserTag.getName() %>"
        departmentFullName="<%=uniqueUserTag.getBelongOrgFullName() %>"
    />
    <%} %>
<script type="text/javascript">
	comtop.UI.scan();
	//导入合法数据到人员选择框中
	var userList =[];
	$.each($("input[id^='uniqueUser_']"),function(i, obj){
		var $Obj = $(obj);
		var name = $Obj.attr("userName");
		var fullName = $Obj.attr("departmentFullName")+"/"+name;
		var selectedUser = {"key":$Obj.attr("userId"), "title": name,
				"fullName":fullName};
	    userList.push(selectedUser);
	});
	var iSuccessAddConunt = parent.parent.addImportUserDataToSelected(userList);//parent.parent.addDataToSelectedBatch(userList);//成功添加到已选框
	var iFailAddCount = uniqueCount - iSuccessAddConunt;//失败添加到已选框
	var uniqueCount = <%=successCount %>;//符合条件用户
	var totalCount = <%=totalCount %>;
	var repeatImportUserCount = <%=repeatImportUserCount %>;
	var currentFailCount = totalCount - iSuccessAddConunt - repeatImportUserCount;//真正失败导入用户
	if(uniqueCount != iSuccessAddConunt){
		$("#importMessage").html(getTipMessage());
		var errorMessage = "<div class='error_object'><div class='error_list'><div class='error_description'>"
			+ "有<span style='color: green;'>" + (uniqueCount - iSuccessAddConunt) + "</span>个符合条件用户未能导入，可能是人员已选或已达到可选人数限制。"
			+ "</div></div></div>";
		if($("#errorMessage").size() > 0){
			$("#errorMessage").prepend(errorMessage);
		}else{
            $("#resultBox").append("<div id='errorMessage' class='error_total'>" + errorMessage + "</div>");
		}

	}

	var isError = false;
	var vErrorMessage = '<%=errorMessage %>';
	if(vErrorMessage != 'null' && vErrorMessage != ''){
		isError = true;
	}
	//加载完后需要显示结果
	parent.showResult(currentFailCount,isError);

	/**
	 * 点击确认触发事件：将勾选的用户导入到人员选择框中
	 */
	function confirmImport(){
		userList =[];
		$.each($(":checkbox:checked"),function(i, obj){
			var $Obj = $(obj);
			var name = $Obj.attr("userName");
			var fullName = $Obj.attr("departmentFullName")+"/"+name;
			var selectedUser = {"key":$Obj.attr("userId"), "title": name,
					"fullName":fullName};
	  		userList.push(selectedUser);
		});
		parent.parent.addImportUserDataToSelected(userList);
		if(parent.parent.bacthImportDialog){
			parent.parent.bacthImportDialog.hide();
		}
	}

	/**
	 * 将勾选的用户导入到人员选择框中
	 */
	function getTipMessage(){
		var html = "共" + totalCount + "条"
			+ " 成功导入<span style='color: green;'>" + iSuccessAddConunt + "</span>条"
		if(repeatImportUserCount > 0){
			html += " 导入文件中重复数据<span style='color: red;'>" + repeatImportUserCount + "</span>条";
		}
		if(currentFailCount > 0){
			html += " 另有<span style='color: red;'>" + currentFailCount + "</span>条未能导入 见下框：";
		}
		return html;
	}

</script>
</body>
</html>