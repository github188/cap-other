
<%
    /**********************************************************************
			 * CIP元数据建模----团队管理
			 * 2015-10-15 姜子豪 新增
	**********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
<title>团队管理</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/cap/bm/common/top/css/top_base.css" type="text/css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/cap/bm/common/top/css/top_sys.css" type="text/css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/cap/bm/common/cui/themes/default/css/comtop.ui.min.css" type="text/css">
<script type="text/javascript" src="<%=request.getContextPath()%>/cap/bm/common/top/js/jquery.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/engine.js'></script>
<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/util.js'></script>
</head>
<style>
.top_header_wrap {
	padding-right: 5px;
}

.spanTop {
	font-family: "Microsoft Yahei";
	font-size: 20px;
	color: #0099FF;
	margin-left: 20px;
	float: left;
	line-height: 45px;
}

.divTitle {
	font-family: "Microsoft Yahei";
	font-size: 14px;
	color: #0099FF;
	margin-left: 20px;
	float: left;
}

.editGrid {
	margin-left: 100px;
}
</style>
<body onload="window.status='Finished';">
	<div uitype="Borderlayout" is_root="true">
		<div class="top_header_wrap">
			<div class="thw_operate">
				<span uitype="button" id="btnEdit" label="编  辑" on_click="editTeamInfo"></span>
				<span uitype="button" id="btnSave" label="保  存" on_click="saveTeamInfo"></span> 
				<span uitype="button" id="btnCancel" label="取  消" on_click="cancel"></span>
			</div>
		</div>
		<div class="top_content_wrap cui_ext_textmode">
			<table class="form_table" style="table-layout: fixed;">
				<colgroup>
					<col width="15%" />
					<col width="35%" />
					<col width="15%" />
					<col width="35%" />
				</colgroup>
				<tr>
					<td class="divTitle">团队信息</td>
				</tr>
				<tr>
					<td class="td_label"><span class="top_required">*</span>名称：</td>
					<td><span uitype="input" id="teamName" name="teamName" validate="teamNamevalidate" databind="teamInfoData.teamName" maxlength="32" width="85%"></span></td>
					<td></td>
					<td></td>
				</tr>
			</table>

			<div id="PersonDiv" class="top_content_wrap cui_ext_textmode"
				align="center">
				<div class="top_header_wrap">
					<div class="divTitle">人员信息</div>
					<div class="thw_operate" id="operateDiv">
						<span uitype="button" id="btnEmployeeImp" label="导入" on_click="impEmployee"></span>
						<span uitype="button" id="btnPersonAdd" label="新增" on_click="addEmployee"></span> 
						<span uitype="button" id="btnPersonDel" label="删除" on_click="delEmployee"></span>
					</div>
				</div>
				<div class="editGrid">
					<table uitype="EditableGrid" id="EmployeeGrid" edittype="employeeEditType" editbefore="editbefore" primarykey="id" sorttype="1" datasource="initPersonData" pagination="false" selectrows="${param.editType == 'read' ? 'no' : 'multi'}" gridwidth="750px" resizewidth="resizeWidth" gridheight="500px" resizeheight="resizeheight" colrender="columnRenderer">
						<tr>
							${param.editType == 'read' ? '' : '<th style="width: 5%"><input type="checkbox" /></th>'}
							<th style="width: 20%" bindName="employeeName"  renderStyle="text-align: center;">人员姓名</th>
							<th style="width: 20%" bindName="employeeAccount" renderStyle="text-align: center;">人员账号</th>
							<th style="width: 5%"  bindName="sex"  render="sexSet" renderStyle="text-align: center;">性别</th>
							<th style="width: 20%" bindName="mobilePhone"  renderStyle="text-align: center;">联系电话</th>
							<th style="width: 30%" bindName="roleSetName" render="" renderStyle="text-align: center;">角色设置</th>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</div>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/TeamAction.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/CapRoleAction.js'></script>
	<script type="text/javascript">
	var selectedTeamId = "${param.selectedTeamId}";//选中团队ID
	var editType = "${param.editType}";
	var parentId = "${param.parentId}";
	var teamInfoData = {};//团队基本信息 
	var roleObjectData = {};//角色对象
	var roleSelection=[];//角色列表 
	var teamNameList=[];
	if(parentId=="_1"){
		parentId=" ";
	}
	//初始化 
	window.onload = function(){
   		init();
   		//按钮隐藏控制、 页面只读控制
   		pageStausSet(editType);
   		getTeamNameList();
   	}
	var teamNamevalidate=[{
		type: 'required',
		rule: {
		m: '团队名称不能为空'}
	},
    {
		type: 'custom',
		rule: {
			against:'checkTeamName',
			m:'已存在相同名称的团队'
		}
	}];
	//角色设置下拉框数据源 
	function roleSelectionSet(){
		dwr.TOPEngine.setAsync(false);
		CapRoleAction.queryCapRoleList(roleObjectData,function(data){
			for(var i=0;i<data.list.length;i++){
				var item={'id':data.list[i].id,'text':data.list[i].roleName};
				roleSelection.push(item);
			}
		});
		dwr.TOPEngine.setAsync(true);
	}

	//编辑grid编辑列属性设置 
	employeeEditType = {
		    "roleSetName" : {
		    	uitype:"PullDown",
		    	mode:"Multi",
		    	datasource:roleSelection
		    }
		};
	function sexSet(rd, index, col) {
		if(rd["sex"]==1){
			return "男";
		}
		return "女";
	}
	//按钮隐藏控制、 页面只读控制
	function pageStausSet(editType){
		if(editType == "read"){
   			buttonCanSave(false);
   			comtop.UI.scan.setReadonly(true);
   		}else if(editType == "insert"){
   			selectedTeamId="";
   			buttonCanSave(true);
   			comtop.UI.scan.setReadonly(false);
   			cui('.top_required').show();
   		}else{
   			buttonCanSave(true);
   			comtop.UI.scan.setReadonly(false);
   			cui('.top_required').show();
   		}
	}
	
	//编辑区域按钮控制
	function buttonCanSave(flag){
		if(flag){
			cui("#btnEdit").hide();
			cui("#btnSave").show();
			cui("#btnCancel").show();
			cui("#btnPersonAdd").show();
			cui("#btnPersonDel").show();
			cui("#btnEmployeeImp").show();
		}else{
			cui("#btnEdit").show();
			cui("#btnSave").hide();
			cui("#btnCancel").hide();
			cui("#btnEmployeeImp").hide();
			cui("#btnPersonAdd").hide();
			cui("#btnPersonDel").hide();
		}
	}
	
	
	//编辑事件 
	function editTeamInfo(){
		parent.editLoad(selectedTeamId);	
	}
	
	//初始化加载  	
   	function init() {
   		roleSelectionSet();
   		comtop.UI.scan();
   		if(selectedTeamId){
   			dwr.TOPEngine.setAsync(false);
   			TeamAction.queryTeamVOByTeamId(selectedTeamId,function(data){
   				cui("#teamName").setValue(data.teamName);
   			});
   			dwr.TOPEngine.setAsync(true);
   		}
   		cui('.top_required').hide();
   	}

	//取消事件 
	function cancel(){
		var flag=isSave();
		if(!flag){
			cui.confirm("有未保存的数据，确定退出编辑页面？",{
				onYes:function(){
					parent.cancelLoad(selectedTeamId);}
				});
		}
		else{
			parent.cancelLoad(selectedTeamId);
		}
	}
	
	//方法数据源
	function initPersonData(gridObj,query) {
		dwr.TOPEngine.setAsync(false);
		TeamAction.queryEmployeeByTeamId(selectedTeamId,function(data){
			var t=data;
			gridObj.setDatasource(data);
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 110;
	}
	
	//grid 宽度
	function resizeheight(){
		return (document.documentElement.clientHeight || document.body.clientHeight) - 400;
	}
	
	//新增人员方法事件 
	function addEmployee(){
		var title="人员新增";
		var url = "EmployeeEdit.jsp";
		var height = 500; //600
		var width =  810; // 680;
		
		dialog = cui.dialog({
			title : title,
			src : url,
			width : width,
			page_scroll : true,
			height : height
		})
		dialog.show(url);
	}
	
 	//导入人员 
	function impEmployee() {
 		var id="RoleSelection";
		var url = "CheckMulPersonnel.jsp";
		var title="选择人员";
		var height = 500;
		var width =  600;
		
		dialog = cui.dialog({
			id:id,
			title : title,
			src : url,
			width : width,
			height : height
		})
		dialog.show(url);
	}
 	
 	//保存团队信息  
 	function saveTeamInfo(){
 		var str = "";
 		var employeeVOList={};
		if(window.validater){
			window.validater.notValidReadOnly = true;
			var map = window.validater.validAllElement();
			var inValid = map[0];
			var valid = map[1];
			//验证消息
			if(inValid.length > 0) { //验证失败
				for(var i=0; i<inValid.length; i++) {
					str += inValid[i].message + "<br/>";
				}
			}
			if(str != ""){
				return false;
			}
		}
		if(selectedTeamId){
			teamInfoData.id=selectedTeamId;
			teamInfoData.teamName=cui("#teamName").getValue();
			teamInfoData.paterTeamId=parentId;
		}
		else{
			teamInfoData.teamName=cui("#teamName").getValue();
			teamInfoData.paterTeamId=parentId;
		}
		dwr.TOPEngine.setAsync(false);
		teamInfoData.teamName=trim(teamInfoData.teamName);
		TeamAction.saveTeam(teamInfoData,function(data){
 			if(data) {
 				if(teamInfoData.id) {
 					window.parent.cui.message('保存成功。','success');
 					window.parent.loadTree(data,0,parentId,teamInfoData.teamName);
 				} else {
 					selectedTeamId = teamInfoData.id;
 					window.parent.cui.message('新增成功。','success');
 					window.parent.loadTree(data,1,parentId,teamInfoData.teamName);
 				}
 				selectedTeamId=data;
 			}else{
 				if(teamInfoData.id) {
 					cui.message('保存失败。','error');
 				} else {
	 				cui.message('新增失败。','error');
 				}
 			}
			
		});
		dwr.TOPEngine.setAsync(true);
		employeeVOList=cui("#EmployeeGrid").getData();
		var relationVOList=[];
		if(employeeVOList){
			for(var i=0;i<employeeVOList.length;i++){
				if(!employeeVOList[i].roleSetName){
					cui.alert("所有团队成员的角色必须设置，不能为空");
					return;
				}
				else{
					var relationVO={id:employeeVOList[i].relId,'teamId':selectedTeamId,'employeeId':employeeVOList[i].id,'roleId':employeeVOList[i].roleSetName};
					relationVOList.push(relationVO);
				}
			}
			dwr.TOPEngine.setAsync(false);
			TeamAction.saveEmployeeToTeam(relationVOList,function(data){
				if(!data){
					return;
				}
			});
			dwr.TOPEngine.setAsync(true);
		}
 	}
 	//删除团队人员 
 	function delEmployee(){
 		var selects = cui("#EmployeeGrid").getSelectedRowData();
		if(selects != null && selects.length > 0){
			cui.confirm("确定要删除这"+selects.length+"个人员吗？",{
				onYes:function(){
					var relationVOList=[];
					for(var i=0;i<selects.length;i++){
							var relationVO={id:selects[i].relId,'teamId':selectedTeamId,'employeeId':selects[i].id,'roleId':selects[i].roleSetName};
							relationVOList.push(relationVO);
					}
					dwr.TOPEngine.setAsync(false);
					TeamAction.deleteTeamEmployee(relationVOList);
					dwr.TOPEngine.setAsync(true);
					cui("#EmployeeGrid").loadData();
					window.parent.cui.message('删除成功。','success');
				}
			});
		}else {
			cui.alert("请选择需要删除的人员。");
		}
 	}
	//新增团队人员 
	function insertReqQueryRow(EmployeeVO) {
		cui("#EmployeeGrid").insertRow({id:EmployeeVO.id,employeeName:EmployeeVO.employeeName,employeeAccount:EmployeeVO.employeeAccount,sex:EmployeeVO.sex,mobilePhone:EmployeeVO.mobilePhone,roleSetName:"developer"});
	}
	
	//导入回调方法 
	function chooseEmployee(selectEmployee,teamId){
		if(selectEmployee){
			var allData = cui("#EmployeeGrid").getData();
			var allDataIdList=[];
			for(var i=0;i<allData.length;i++){
				allDataIdList[i]=allData[i].id;
			}
			for(var i=0;i<selectEmployee.length;i++){
				var count =0;
				for(var j=0;j<allDataIdList.length;j++){
					if(selectEmployee[i].id != allDataIdList[j]){
						count++;
					}
				}
				if(count == allDataIdList.length){
					insertReqQueryRow(selectEmployee[i]);
				}
			}
		}
	}
	
	//获取团队名称列表 
	function getTeamNameList(){
		dwr.TOPEngine.setAsync(false);
		TeamAction.queryTeamList(function(data){
			var count=0;
			for(var i=0;i<data.list.length;i++){
				if(selectedTeamId != data.list[i].id){
					teamNameList[count]=data.list[i].teamName;
					count++;
				}
	    		}
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//检查团队名称 
	function checkTeamName(){
		var myTeamName=trim(cui("#teamName").getValue());
   		for(var i=0;i<teamNameList.length;i++){
   			if(teamNameList[i] == myTeamName){
   				return false;
   			}
   		}
   		return true;
	}
	
	//检查可编辑列编辑条件
	function editbefore(rowData, bindName){
		if (bindName == "roleSetName") {
			if(editType=="read"){
				return false;
			}
			else{
				return {             
					uitype: "PullDown",
					mode: "Multi",
					datasource:roleSelection
					}
			}
		}
	}
	
	//判断是否保存修改过的数据 
	function isSave(){
		var gridData=cui("#EmployeeGrid").getChangeData()
		var insertData=gridData.insertData;
		var changeData=gridData.updateData;
		if(changeData || insertData){
			return false;
		}
		return true;
	}
	
 	//去左右空格;
 	function trim(str){
 	    return str.replace(/(^\s*)|(\s*$)/g, "");
 	}
</script>
</body>
</html>