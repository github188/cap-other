
<%
	/**********************************************************************
	 * 角色新增编辑界面
	 * 2014-7-21  杨卫清  新建
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<html>
<head>
<title>角色编辑</title>

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
				<span uitype="button" label="保存" id="saveRole" on_click="saveRole" ></span>
				<% } %>
				&nbsp;<span uitype="button" label="关闭" id="closeSelf" on_click="closeSelf" ></span>
			</div>
		</div>
		<div class="cui_ext_textmode" style="margin-top:5px;">
			<table class="form_table" style="table-layout: fixed;">
				<tr>
					<td class="td_label" width="20%"><span style="color: red">*</span>&nbsp;角色名称：</td>
					<td class="td_content">
					<div style="width:369px;">
					<span uitype="input" id="roleName"
						name="roleName" databind="data.roleName" maxlength="50"
						width="100%"
						validate="[{'type':'required', 'rule':{'m': '角色名称不能为空。'}},{'type':'custom','rule':{'against':'isNameContainSpecial','m':'角色名称只能为中英文、数字或下划线。'}},{'type':'custom','rule':{'against':'isExsitRoleName','m':'同一分类下该角色名称已存在。'}}]" /></td>

					
					</div>
					<span uitype="input" id="roleId" name="roleId"
						databind="data.roleId" ></span>
					<span uitype="input" id="roleClassifyId" name="roleClassifyId"
						databind="data.roleClassifyId" ></span>
					<span uitype="input" id="creatorId" name="creatorId"
						databind="data.creatorId" ></span>
				</tr>
				<tr>
					<td class="td_label" width="20%">描述：</td>
					<td class="td_content">
						<div style="width:380px;">
							<span uitype="textarea"  name="description"
								width="97%" databind="data.description" height="50px"
								maxlength="250" relation="defect1">
							</span>
							<div style="float:right;">
								<font>
								(您还能输入<label id="defect1" style="color: red"></label>个字符)
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
		var roleClassifyId = "<c:out value='${param.roleClassifyId}'/>";//用户ID
		var roleId = "<c:out value='${param.roleId}'/>";//组织ID
		var creatorId = globalUserId;
		var data = {};

		if ("" == creatorId) {
			creatorId = globalUserId;
		}
		//扫描，相当于渲染
		window.onload = function() {
			hideInput();
			if (roleId) {//编辑
				dwr.TOPEngine.setAsync(false);
				RoleAction.readRole(roleId, function(roleData) {
					data = roleData;
				});
				dwr.TOPEngine.setAsync(true);
			} else {//新增
			}
			comtop.UI.scan();
			if(roleId){
				$('#pageTittle').html('修改角色')
			}else{
				$('#pageTittle').html('新增角色')
			}
			if (chooes_type == 2) {
				cui("#saveRole").hide();
			}
		}

		//关闭窗口
		function closeSelf() {
			window.parent.dialog.hide();
		}

		//隐藏input
		function hideInput() {
			cui('#roleClassifyId').hide();
			cui('#roleId').hide();
			cui('#creatorId').hide();
		}

		//判断名称是否包含特殊字符
		function isNameContainSpecial(data) {
			var reg = new RegExp("^[\u4E00-\u9FA5A-Za-z0-9_]+$");
			return (reg.test(data));
		}

		//同一分类下不能重名
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

		//保存人员信息
		function saveRole() {

			var map = window.validater.validAllElement();
			var inValid = map[0];//放置错误信息
			var valid = map[1]; //放置成功信息

			if (inValid.length > 0) {
				var str = "";
				for (var i = 0; i < inValid.length; i++) {
					str += inValid[i].message + "<br />";
				}
				return;
			} else {
				//获取表单信息
				var vo = cui(data).databind().getValue();
				
				vo.roleClassifyId = roleClassifyId;
				vo.roleId = roleId;
				if (roleId) {//编辑
					vo.modifierId=creatorId;
					RoleAction.updateRole(vo, function(data) {
						window.parent.cui.message('角色调整成功。',"success");
						window.parent.editCallBack(roleId);
						window.parent.dialog.hide();
					});
				} else {
					vo.creatorId = creatorId;
					RoleAction.insertRole(vo, function(data) {
						window.parent.cui.message('角色录入成功。',"success");
						window.parent.addCallBack(data.roleId);
						window.parent.dialog.hide();
					});
				}
			}
		}
	</script>
</body>
</html>