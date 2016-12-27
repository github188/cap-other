
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
<title>联系人编辑页面</title>
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
		<div class="thw_title">编辑联系人信息</div>
		<div id ="thw_operate" class="thw_operate" style="margin-right: 12px;display: none">
				<span uitype="button" label="添加" on_click="save" id="upload"></span>

		</div>
	</div>

	<div class="top_content_wrap">
		<table class="form_table">
			
			<tr>
				<td class="td_label" style="width: 20%">
					<span class="top_required">*</span>请输入联系人信息:</td>
				<td>
				<span id="contactContent" uitype="Textarea" name="contactContent" width="400" height="150"
              databind="data.contactContent" validate="内容不能为空" emptytext="填写联系人信息" maxlength="4000" relation="defect1"  readonly=false></span>	
				<div style="margin-right: 80px">
				<font id="applyRemarkLengthFont" >(您还能输入<label id="defect1" style="color:red;"></label> 字符)</font>
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
	//初始化页面
    if (contactId) {//编辑页面
	$("#upload").attr("label","保存");
        dwr.TOPEngine.setAsync(false);
        ContactPersonAction.readContactPerson(contactId,function(contactpersonData){
                    data = contactpersonData;         
        });
        dwr.TOPEngine.setAsync(true);
        $(".thw_title").html("编辑联系人信息");
	
     	if(isAdminManager)
    	{document.getElementById("thw_operate").style.display="inline";
    	}else{
 		comtop.UI.scan();
		cui("#contactContent").setReadonly(true);
}
    }else {//新增页面
        	
    	if(isAdminManager){
    		document.getElementById("thw_operate").style.display="inline";
    		
    	}
        saveType = "add";
        $(".thw_title").html("新增联系人信息");
        
    } 
    comtop.UI.scan();
   
}



//保存方法
function save(){	
    //验证消息
    var map = window.validater.validAllElement();	
    var inValid = map[0];
    if (inValid.length ==0){    
 	var vo = cui(data).databind().getValue();
    ContactPersonAction.saveContactPerson(vo,function(iFlag){
    	if(contactId){
    		window.parent.cui.message('修改联系人成功。', 'success');
    		//window.location.href = '${pageScope.cuiWebRoot}/top/sys/tools/contactperson/ContactPersonList.jsp';
    		window.parent.addCallBack();
	   		window.parent.dialog.hide();   
    	}else{
    		window.parent.cui.message('添加联系人成功。', 'success');
		//	window.location.href = '${pageScope.cuiWebRoot}/top/sys/tools/contactperson/ContactPersonList.jsp';
			window.parent.addCallBack();	
			window.parent.dialog.hide();
    	}
    	});
    
    	}
	}


//返回
function back(){
	window.location.href = '${pageScope.cuiWebRoot}/top/sys/tools/contactperson/ContactPersonList.jsp';
}


</script>
</body>
</html>