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
    <title>������</title>
	<top:link href="/top/component/topui/cui/themes/default/css/comtop.ui.min.css"/>
    <top:link href="/top/sys/usermanagement/orgusertag/css/userBatchGuide.css"/>
    <top:script src="/top/js/jquery.js"/>
    <top:script src="/top/component/topui/cui/js/comtop.ui.min.js"/>
</head>
<%
//��ȡ������Ϣ���
UserBatchImportDTO objUserImportDetailVO = (UserBatchImportDTO)request.getAttribute("objUserImportDetail");
String errorMessage = objUserImportDetailVO.getErrorMessage();
int totalCount = objUserImportDetailVO.getTotalCount();
int successCount = objUserImportDetailVO.getSuccessCount();
int repeatImportUserCount = objUserImportDetailVO.getRepeatImportUserCount();
int failCount = objUserImportDetailVO.getFailCount();
//�ظ��û���Ϣ
Map<String, List<OrgUserDTO>> repeatUserMap = objUserImportDetailVO.getRepeatUserMap();
Set repeatUserNameSet = repeatUserMap.keySet();
//�������û���Ϣ
Map<String, List<OrgUserDTO>> notExistsUserMap = objUserImportDetailVO.getNotExistsUserMap();
Set notExistsUserNameSet = notExistsUserMap.keySet();
//��ȡ��������Ϣ
List<OrgUserTreeDTO> rootDepartmentList = objUserImportDetailVO.getRootDepartmentList();
int rootDeptListSize = objUserImportDetailVO.getRootDepartmentListSize();
//��ò��������޽��Ƶ�ƥ���û���Ϣ
List<String> notExistsAndPossibleUserList = objUserImportDetailVO.getNotExistsAndPossibleUserList();
int notExistsAndPossibleUserListSize = objUserImportDetailVO.getNotExistsAndPossibleUserListSize(); 
//�����û��в��ҵ�����Ӧ�û� ����δ�����ظ��û�
List<OrgUserDTO> uniqueUserList = objUserImportDetailVO.getUniqueUserList();
%>
<body class="resultBody">
    <div id="resultBox" class="resultBox" >
        <div id="importMessage" class="import_process">
            <%if(StringUtil.isEmpty(errorMessage)){ %>
	        	��<%=totalCount %>�����ɹ�����<span style="color: green;"><%=successCount %></span>��
	        	<%if(repeatImportUserCount>0){ %>
		    		 �����ظ���¼<span style="color: red;"><%=repeatImportUserCount %></span>��
		        <%} %>
		        <%if(failCount>0){ %>
		          	����<span style="color: red;"><%=failCount %></span>��δ�ܵ��� ���¿�
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
	                <div class="error_description" >������Ա<span style="color: red;"><%=strRepeatUserName %></span>������������ѡ��</div>
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
	                	�ڸ����ţ�
	                	<%
	                		for(int j=0;j<rootDepartmentList.size(); j++){
	                	%>
	                		<%=rootDepartmentList.get(j).getTitle() %>
	                		   <%if(j!=(rootDeptListSize-1)){ %>��<%} %>
	                	    <%} %>����Χ�ڲ��Ҳ�����Ա<span style="color: red;">
	                		  <%=strNotExistsUserName %>
	                		  </span>�����Ƿ�Ҫ�ң�
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
		                	�ڵ�ǰ������Χ�ڣ�������Ϊ��
		                	<%
	                		for(int j=0;j<rootDepartmentList.size();j++){
	                		%>
	                		<%=rootDepartmentList.get(j).getTitle() %>
	                		   <%if(j!=(rootDeptListSize-1)){ %>��<%} %>
	                	    <%} %>�����Ҳ�����ƥ�����Ա��<br/>
	                	    <%
	                	    	for(int t=0;t<notExistsAndPossibleUserList.size();t++){
	                	    %>
		                		<span style="color: red;"><%=notExistsAndPossibleUserList.get(t) %></span>
		                		<%if(t!=(notExistsAndPossibleUserListSize-1)){ %>
		                			��
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
    	<span uitype="button" label="ȷ��" mark="1" on_click="confirmImport"></span>
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
	//����Ϸ����ݵ���Աѡ�����
	var userList =[];
	$.each($("input[id^='uniqueUser_']"),function(i, obj){
		var $Obj = $(obj);
		var name = $Obj.attr("userName");
		var fullName = $Obj.attr("departmentFullName")+"/"+name;
		var selectedUser = {"key":$Obj.attr("userId"), "title": name,
				"fullName":fullName};
	    userList.push(selectedUser);
	});
	var iSuccessAddConunt = parent.parent.addImportUserDataToSelected(userList);//parent.parent.addDataToSelectedBatch(userList);//�ɹ���ӵ���ѡ��
	var iFailAddCount = uniqueCount - iSuccessAddConunt;//ʧ����ӵ���ѡ��
	var uniqueCount = <%=successCount %>;//���������û�
	var totalCount = <%=totalCount %>;
	var repeatImportUserCount = <%=repeatImportUserCount %>;
	var currentFailCount = totalCount - iSuccessAddConunt - repeatImportUserCount;//����ʧ�ܵ����û�
	if(uniqueCount != iSuccessAddConunt){
		$("#importMessage").html(getTipMessage());
		var errorMessage = "<div class='error_object'><div class='error_list'><div class='error_description'>"
			+ "��<span style='color: green;'>" + (uniqueCount - iSuccessAddConunt) + "</span>�����������û�δ�ܵ��룬��������Ա��ѡ���Ѵﵽ��ѡ�������ơ�"
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
	//���������Ҫ��ʾ���
	parent.showResult(currentFailCount,isError);

	/**
	 * ���ȷ�ϴ����¼�������ѡ���û����뵽��Աѡ�����
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
	 * ����ѡ���û����뵽��Աѡ�����
	 */
	function getTipMessage(){
		var html = "��" + totalCount + "��"
			+ " �ɹ�����<span style='color: green;'>" + iSuccessAddConunt + "</span>��"
		if(repeatImportUserCount > 0){
			html += " �����ļ����ظ�����<span style='color: red;'>" + repeatImportUserCount + "</span>��";
		}
		if(currentFailCount > 0){
			html += " ����<span style='color: red;'>" + currentFailCount + "</span>��δ�ܵ��� ���¿�";
		}
		return html;
	}

</script>
</body>
</html>