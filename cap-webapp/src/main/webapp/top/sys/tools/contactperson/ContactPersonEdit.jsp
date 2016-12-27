
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ page import="com.comtop.top.sys.accesscontrol.gradeadmin.GradeAdminConstants" %>
<%@page import="com.comtop.top.sys.usermanagement.user.model.UserDTO"%>
<html>
 <%		
	UserDTO objUserInfo = (UserDTO)pageContext.getAttribute("userInfo");
	boolean isAdminManager = GradeAdminConstants.isManagerByUserId(objUserInfo.getUserId());
	%>
<head>
<title>��ϵ�˱༭ҳ��</title>
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css" />
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css" />
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/ContactPersonAction.js"></script>


<style type="text/css">
.table {
	border: 1px solid #ccc;
	border-width: 1px 0 0 1px;
	width: 100%;
}

.table td {
	padding: 2px;
	border: 1px solid #ccc;
	border-width: 0 1px 1px 0;
	background: #fff;
}

.table .label {
	text-align: right;
	background: #1d67a6;
	color: #fff;
	width: 42px;
}

html,body {
	
}

.button_box {
	*margin-right: 6px;
}
</style>
</head>
<body>
	<div class="top_header_wrap">
		<div class="thw_title">�༭��ϵ����Ϣ</div>
		<div id ="thw_operate" class="thw_operate" style="margin-right: 12px;display: none">
				<span uitype="button" label="���" on_click="save" id="upload"></span>

		</div>
	</div>

	<div class="top_content_wrap">
		<table class="form_table">
			
			<tr>
				<td class="td_label" style="width: 20%">
					<span class="top_required">*</span>��������ϵ����Ϣ:</td>
				<td>
				<span id="contactContent" uitype="Textarea" name="contactContent" width="400" height="150"
              databind="data.contactContent" validate="���ݲ���Ϊ��" emptytext="��д��ϵ����Ϣ" maxlength="4000" relation="defect1"  readonly=false></span>	
				<div style="margin-right: 80px">
				<font id="applyRemarkLengthFont" >(����������<label id="defect1" style="color:red;"></label> �ַ�)</font>
				</div>
				</td>
				
				
			</tr>
			
		</table>
	</div>
	



<script type='text/javascript'>
var contactId = "<c:out value='${param.contactId}'/>";
var menuData={};
var data = {};
var isAdminManager = <%=isAdminManager%>;

window.onload = function(){
	//��ʼ��ҳ��
    if (contactId) {//�༭ҳ��
	$("#upload").attr("label","����");
        dwr.TOPEngine.setAsync(false);
        ContactPersonAction.readContactPerson(contactId,function(contactpersonData){
                    data = contactpersonData;         
        });
        dwr.TOPEngine.setAsync(true);
        $(".thw_title").html("�༭��ϵ����Ϣ");
	
     	if(isAdminManager)
    	{document.getElementById("thw_operate").style.display="inline";
    	}else{
 		comtop.UI.scan();
		cui("#contactContent").setReadonly(true);
}
    }else {//����ҳ��
        	
    	if(isAdminManager){
    		document.getElementById("thw_operate").style.display="inline";
    		
    	}
        saveType = "add";
        $(".thw_title").html("������ϵ����Ϣ");
        
    } 
    comtop.UI.scan();
   
}



//���淽��
function save(){	
    //��֤��Ϣ
    var map = window.validater.validAllElement();	
    var inValid = map[0];
    if (inValid.length ==0){    
 	var vo = cui(data).databind().getValue();
    ContactPersonAction.saveContactPerson(vo,function(iFlag){
    	if(contactId){
    		window.parent.cui.message('�޸���ϵ�˳ɹ���', 'success');
    		//window.location.href = '${pageScope.cuiWebRoot}/top/sys/tools/contactperson/ContactPersonList.jsp';
    		window.parent.addCallBack();
	   		window.parent.dialog.hide();   
    	}else{
    		window.parent.cui.message('�����ϵ�˳ɹ���', 'success');
		//	window.location.href = '${pageScope.cuiWebRoot}/top/sys/tools/contactperson/ContactPersonList.jsp';
			window.parent.addCallBack();	
			window.parent.dialog.hide();
    	}
    	});
    
    	}
	}


//����
function back(){
	window.location.href = '${pageScope.cuiWebRoot}/top/sys/tools/contactperson/ContactPersonList.jsp';
}


</script>
</body>
</html>