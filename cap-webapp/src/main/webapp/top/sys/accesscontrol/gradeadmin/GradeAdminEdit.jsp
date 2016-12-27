<%
    /**********************************************************************
	 * 编辑分级管理员
	 * 2014-07-04 谢阳  新建
	 **********************************************************************/
%>

<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>

<html>
<head>
<title><c:if test="${not empty param.adminId}">编辑</c:if><c:if test="${empty param.adminId}">新增</c:if>分级管理员</title>
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	 <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/usermanagement/orgusertag/css/choose.css" type="text/css"/>	
	<style type="text/css">
	
	 html,body{
	 	height:100%;
	 	overflow:hidden;
	 }
	</style>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/usermanagement/orgusertag/js/choose.js" ></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/GradeAdminAction.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/ChooseAction.js" ></script>	
	
</head>

<body onload="window.status='Finished';">
		<div class="top_header_wrap">
			<div class="thw_title" style="margin-left:11px;margin-top:2px;">
				<font id = "pageTittle" class="fontTitle"><c:if test="${not empty param.adminId}">编辑</c:if><c:if test="${empty param.adminId}">新增</c:if>分级管理员</font>
			</div>
			<div class="thw_operate">
				<span uitype="button" label="保存" id="saveBtn" on_click="save"></span>
				<span uitype="button" label="关闭" id="deleteBtn" on_click="closeWin"></span>
			</div>
		</div>
		<div class="cui_ext_textmode">
			<table class="form_table">
				<tr>
					<td class="td_label" width="25%"><span class="top_required">*</span>分级管理员名称：</td>
					<td class="td_content" width="75%">
						<span uitype="Input" id="adminName" name="adminName" databind="data.adminName"  width="400" maxlength="50" 
							validate="[{'type':'required', 'rule':{'m': '分级管理员名称不能为空'}}]" ></span>
					</td>
				</tr>
				<tr>
					<td class="td_label" ><span class="top_required">*</span>管辖范围：</td>
					<td> 
						<span uitype="ChooseOrg" id="deptName" name="deptName" width="400px" height="29px" chooseMode='1'  isSearch="true" orgStructureId='A'
							validate="[{'type':'required', 'rule':{'m': '管辖范围不能为空'}}]">
						</span>
					</td>
				</tr> 
				<tr>
					<td class="td_label"><span class="top_required">*</span>选择人员：</td>
					<td>
						<span uitype="ChooseUser" id="userName" name="userName" width="400px" height="58px" chooseMode="0" userType="1"  isSearch="true" orgStructureId='A'
							validate="[{'type':'required', 'rule':{'m': '人员不能为空'}}]"></span>
					</td>
				</tr>
				
				<tr> 
					<td class="td_label">分级管理员描述：
					<td>
						<div style="width:400px;">
							<span uitype="Textarea" id="adminDesc" name="adminDesc" databind="data.adminDesc" 
								width="390px" maxlength="250" relation="defect1"></span>	
							<div style="float:right">
								<font id="applyRemarkLengthFont" >(您还能输入<label id="defect1" style="color:red;"></label> 字符)</font>
							</div>
						</div>
					</td>
					
				</tr>
			</table>
		</div>
	
<script language="javascript">
   	var adminId = "<c:out value='${param.adminId}'/>";
   	window.onload = function() {
   	   
    }
   	
   $(document).ready(function() {
	   var userName_arr = [];
	   var deptName_arr = [];
	   var orgId = '';
	   //如果当前管理员不是SuperAdmin,则获取orgId
	   if(globalUserId!='SuperAdmin'){
		   dwr.TOPEngine.setAsync(false);
		   GradeAdminAction.getGradeAdminOrgByUserId(globalUserId,function(result){
			   orgId = result;
			});
		   dwr.TOPEngine.setAsync(true);
	   }
		
	   if(adminId != ""){
			dwr.TOPEngine.setAsync(false);
			GradeAdminAction.getGradeAdmin(adminId,function(gradeAdminData){
				data = gradeAdminData;
				if(data!=null){
					var user_arr = data.userList;
					var dept_arr = data.deptList;
					for(var index in user_arr){
						var user = {"id":user_arr[index]["resourceId"],"name":user_arr[index]["resourceName"]};
						userName_arr.push(user);
					}
					for(var index in dept_arr){
						var dept = {"id":dept_arr[index]["resourceId"],"name":dept_arr[index]["resourceName"]};
						deptName_arr.push(dept);
					}
				}
			});
			dwr.TOPEngine.setAsync(true);
	   }

	   comtop.UI.scan();   //扫描

	   if(userName_arr.length>0){
		   cui("#userName").setValue(userName_arr);
	   }
	   if(deptName_arr.length>0){
		   cui("#deptName").setValue(deptName_arr);
	   }
	   //设置标签的rootId
	   if(orgId){
		   cui('#userName').setAttr('rootId',orgId);
		   cui('#deptName').setAttr('rootId',orgId);
	   }
	   
   });

	
	//保存分级管理员
	function save(){
		var map = window.validater.validAllElement();
        var inValid = map[0];
        var valid = map[1];
       	//验证消息
		if(inValid.length > 0){//验证失败
			var str = "";
            for (var i = 0; i < inValid.length; i++) {
				str += inValid[i].message + "<br />";
			}
			//cui.warn(str);
		}else{
			var vo = cui(data).databind().getValue();
			var user_arr = [];
			var user_arr_temp = cui("#userName").getValue();
			var dept_arr = [];
			var dept_arr_temp = cui("#deptName").getValue();

			for(var index in user_arr_temp){
				if(user_arr_temp[index]){
					var user = {};
					user.resourceId = user_arr_temp[index]["id"];
					user.creatorId = globalUserId;
					user_arr.push(user);
				}
			}
			for(var index in dept_arr_temp){
				if(dept_arr_temp[index]){
					var dept = {};
					dept.resourceId = dept_arr_temp[index]["id"];
					dept.creatorId = globalUserId;
					dept_arr.push(dept);
				}
			}
			vo.userList=user_arr;
			vo.deptList=dept_arr;
			vo.adminId = adminId;
			vo.modifierId = globalUserId;
			dwr.TOPEngine.setAsync(false);
			GradeAdminAction.mergeGradeAdmin(vo,function(result){
				if(result.indexOf('[{')!=-1){
					var error_obj_arr = jQuery.parseJSON(result);
					var names = '';
					var count = 0;
					var msg = '已经是管理员身份。';
					//不合法的用户超过5个，取前5个加“等等”字样来提示
					if(error_obj_arr.length > 5){
						count = 5;
						msg = '等等' + msg;javasscript:;
					}else{
						//如果不合法的用户少于5个就直接显示出来
						count = error_obj_arr.length;
					}
					for(var i = 0 ;i < count ; i++){
						names+=error_obj_arr[i].userName+';';
					}
					cui.error("<font color='red'>"+names.substring(0,names.length-1)+"</font>"+msg);
				}else{
					adminId = result;
					<c:if test="${not empty param.adminId}">
						//修改
						window.parent.cui.message('管理员修改成功。','success');
					</c:if>
					<c:if test="${empty param.adminId}">
						//新增
						window.parent.cui.message('管理员保存成功！','success');
					</c:if>
					window.parent.addCallBack(adminId);
					window.parent.dialog.hide();
				}
				
			});
			dwr.TOPEngine.setAsync(true);
		}	
	}

	//关闭窗口 
	function closeWin() {
		window.parent.dialog.hide();
	}
</script>
</body>
</html>