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
<title>���ӹ���༭ҳ��</title>
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.editor.min.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/BulletinAction.js"></script>

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

	<div class="top_header_wrap" >
		<div class="thw_title">�༭������Ϣ</div>
		<div id="thw_operate" class="thw_operate" style="margin-right: 12px;display: none">
			<span uitype="button" label="����" id="saveBtn" on_click="doSave"></span>
		</div>
	</div>

	
	<div class="top_content_wrap">
		<table class="form_table">
			<tr>
				<td class="td_label" width="12%"><span class="top_required">*</span>�������</td>	
					<td>
					<span uitype="Input" id="title" name="title"
						databind="data.title" width="60%" maxlength="100"
						validate="������ⲻ��Ϊ��" emptytext="��д�������">
						</span>
					</td>
			</tr>
			
			<tr>
				<td class="td_label"><span class="top_required" id ="">*</span>��������</td>
					<td>
						<div class="demoContainer">
						<div id="contentClob1" uitype="editor" min_frame_height="100"  toolbars ="toolbars"  server_url="x"
							  style="width:600px" validate="�������ݲ���Ϊ��" emptytext="��д��������"></div>
						</div>
					</td>
			</tr>
		
		
			<tr>
				<td class="td_label"><span class="top_required">*</span>�����̶�</td>
				<td>
				<span id ="urgent" uitype="RadioGroup" name="urgent" value="0" databind="data.urgent"> 
					<input type="radio" value="0" text="һ��" />
					<input type="radio" value="1" text="����" />
				</span>
				</td>
			</tr>

		</table>
	</div>
	
	
	<script type='text/javascript'>
	
var varBulletinId = "<c:out value='${param.bulletinId}'/>";
var data = {};
var isAdminManager = <%=isAdminManager%>;
var toolbars = [
				[
					'undo','redo','|','bold','italic','underline','strikethrough','fontfamily','fontsize',
					'fontcolor','backcolor','formatmatch','removeformat','|',
					'insertunorderedlist','insertorderedlist','|',
					'justifyleft','justifyright','justifycenter','justifyjustify','paragraph',
					'indent','rowspacingbottom','rowspacingtop','lineheight','|',
					'date','time','selectall','cleardoc','fullscreen'
				]
			];
window.onload = function(){

	/*  var editor = new UE.ui.Editor({ initialFrameWidth:5,initialFrameHeight:"100"  });
	  editor.render("contentClob"); */

    if (varBulletinId) {//�༭ҳ��
    	
    	if(isAdminManager)
    	{
    		document.getElementById("thw_operate").style.display="inline";
    	}
    	
        BulletinAction.readBulletin(varBulletinId, function(bulletinData){
            data = bulletinData; 
            comtop.UI.scan(); 
           
            cui("#contentClob1").setHtml(data.contentClob);    
        });
    	$("#saveBtn").attr("label","����");
        $(".thw_title").html("�༭������Ϣ");
    }else {//����ҳ��
    	if(isAdminManager)
    	{document.getElementById("thw_operate").style.display="inline";
    	}
        $(".thw_title").html("����������Ϣ");
        comtop.UI.scan(); 
    } 
   
}



 


//���淽��
function doSave(){	
	
	 var map = window.validater.validAllElement();
	
	if(map[2]){
		
		var vo =$.extend({},data,{contentClob:cui("#contentClob1").getHtml()});
		BulletinAction.saveBulletin(vo, function(result) {
			if (varBulletinId) {
				window.parent.cui.message('�޸Ĺ���ɹ���', 'success');
					window.parent.addCallBack();
				window.parent.dialog.hide();
			} else {
				window.parent.cui.message('��������ɹ���', 'success');
				window.parent.addCallBack();
				window.parent.dialog.hide();
			}
		});
		
	}
	

		}
	</script>
</body>
</html>