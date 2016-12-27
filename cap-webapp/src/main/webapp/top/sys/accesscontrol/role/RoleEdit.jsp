
<%
	/**********************************************************************
	 * ��ɫ�����༭����
	 * 2014-7-21  ������  �½�
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<html>
<head>
<title>��ɫ�༭</title>

<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css"
	type="text/css">
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/util.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/RoleAction.js"></script>
<style type="text/css">
.imgMiddle {
	line-height: 350px;
	text-align: center;
}

.top_header_wrap {
	padding-right: 5px;
}
</style>
</head>
<body onload="window.status='Finished';">
	<div uitype="Borderlayout" id="body" is_root="true">
		<div class="top_header_wrap" >
			<div class="thw_title" style="padding-top: 3px;margin-top:0px;">
				<span><font id="pageTittle" class="fontTitle"></font></span>
			</div>
			<div class="thw_operate">
				<% if(!isHideSystemBtn){ %>
				<span uitype="button" label="����" id="saveRole" on_click="saveRole" ></span>
				<% } %>
				&nbsp;<span uitype="button" label="�ر�" id="closeSelf" on_click="closeSelf" ></span>
			</div>
		</div>
		<div class="cui_ext_textmode" style="margin-top:5px;">
			<table class="form_table" style="table-layout: fixed;">
				<tr>
					<td class="td_label" width="20%"><span style="color: red">*</span>&nbsp;��ɫ���ƣ�</td>
					<td class="td_content">
					<div style="width:369px;">
					<span uitype="input" id="roleName"
						name="roleName" databind="data.roleName" maxlength="50"
						width="100%"
						validate="[{'type':'required', 'rule':{'m': '��ɫ���Ʋ���Ϊ�ա�'}},{'type':'custom','rule':{'against':'isNameContainSpecial','m':'��ɫ����ֻ��Ϊ��Ӣ�ġ����ֻ��»��ߡ�'}},{'type':'custom','rule':{'against':'isExsitRoleName','m':'ͬһ�����¸ý�ɫ�����Ѵ��ڡ�'}}]" /></td>

					
					</div>
					<span uitype="input" id="roleId" name="roleId"
						databind="data.roleId" ></span>
					<span uitype="input" id="roleClassifyId" name="roleClassifyId"
						databind="data.roleClassifyId" ></span>
					<span uitype="input" id="creatorId" name="creatorId"
						databind="data.creatorId" ></span>
				</tr>
				<tr>
					<td class="td_label" width="20%">������</td>
					<td class="td_content">
						<div style="width:380px;">
							<span uitype="textarea"  name="description"
								width="97%" databind="data.description" height="50px"
								maxlength="250" relation="defect1">
							</span>
							<div style="float:right;">
								<font>
								(����������<label id="defect1" style="color: red"></label>���ַ�)
								</font>
							</div>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>

	<script language="javascript">
		var chooes_type = "<c:out value='${param.chooes_type}'/>";
		var roleClassifyId = "<c:out value='${param.roleClassifyId}'/>";//�û�ID
		var roleId = "<c:out value='${param.roleId}'/>";//��֯ID
		var creatorId = globalUserId;
		var data = {};

		if ("" == creatorId) {
			creatorId = globalUserId;
		}
		//ɨ�裬�൱����Ⱦ
		window.onload = function() {
			hideInput();
			if (roleId) {//�༭
				dwr.TOPEngine.setAsync(false);
				RoleAction.readRole(roleId, function(roleData) {
					data = roleData;
				});
				dwr.TOPEngine.setAsync(true);
			} else {//����
			}
			comtop.UI.scan();
			if(roleId){
				$('#pageTittle').html('�޸Ľ�ɫ')
			}else{
				$('#pageTittle').html('������ɫ')
			}
			if (chooes_type == 2) {
				cui("#saveRole").hide();
			}
		}

		//�رմ���
		function closeSelf() {
			window.parent.dialog.hide();
		}

		//����input
		function hideInput() {
			cui('#roleClassifyId').hide();
			cui('#roleId').hide();
			cui('#creatorId').hide();
		}

		//�ж������Ƿ���������ַ�
		function isNameContainSpecial(data) {
			var reg = new RegExp("^[\u4E00-\u9FA5A-Za-z0-9_]+$");
			return (reg.test(data));
		}

		//ͬһ�����²�������
		function isExsitRoleName(data) {
			var flag = true;
			if (data != "") {
				var obj = {
					roleName : data,
					roleClassifyId : roleClassifyId,
					roleId : roleId
				};
				dwr.TOPEngine.setAsync(false);
				RoleAction.isRoleNameExist(obj, function(data) {
					if (data) {
						flag = false;
					} else {
						flag = true;
					}
				});
				dwr.TOPEngine.setAsync(true);
			}
			return flag;
		}

		//������Ա��Ϣ
		function saveRole() {

			var map = window.validater.validAllElement();
			var inValid = map[0];//���ô�����Ϣ
			var valid = map[1]; //���óɹ���Ϣ

			if (inValid.length > 0) {
				var str = "";
				for (var i = 0; i < inValid.length; i++) {
					str += inValid[i].message + "<br />";
				}
				return;
			} else {
				//��ȡ����Ϣ
				var vo = cui(data).databind().getValue();
				
				vo.roleClassifyId = roleClassifyId;
				vo.roleId = roleId;
				if (roleId) {//�༭
					vo.modifierId=creatorId;
					RoleAction.updateRole(vo, function(data) {
						window.parent.cui.message('��ɫ�����ɹ���',"success");
						window.parent.editCallBack(roleId);
						window.parent.dialog.hide();
					});
				} else {
					vo.creatorId = creatorId;
					RoleAction.insertRole(vo, function(data) {
						window.parent.cui.message('��ɫ¼��ɹ���',"success");
						window.parent.addCallBack(data.roleId);
						window.parent.dialog.hide();
					});
				}
			}
		}
	</script>
</body>
</html>