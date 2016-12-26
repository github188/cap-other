<!doctype html>
<%
  /**********************************************************************
	* 人员基本信息编辑
	* 2015-9-22 姜子豪 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<html>
<head>
<title>人员基本信息编辑</title>
	<top:link href="/cap/bm/common/styledefine/css/top_base.css" />
	<top:link href="/cap/bm/common/styledefine/css/top_sys.css" />
	<top:link href="/cap/bm/common/styledefine/css/public.css"/>
	<top:link href="/cap/bm/common/cui/themes/smartGrid/css/comtop.ui.min.css"/>
	<top:link href="/top/sys/usermanagement/orgusertag/css/choose.css"/>
</head>
<style>
</style>
<body class="top_body">
	<div style="margin: 0 auto; width:auto;">
	<div class="top_header_wrap" style="text-align: center;margin-top:5px;">
		<div class="thw_title" style="float:left">人员基本信息编辑</div>
		<div style="float:right;margin-right:45px;">
			<span uitype="button" id="btnSave" on_click="btnSave" icon="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/smartGrid/images/button/save_white.gif" hide="false" button_type="blue-button" disable="false" label="保存" ></span> 
		    <span uitype="button" on_click="btnClose" id="btnClose" icon="remove" hide="false" button_type="blue-button" disable="false" label="关闭"></span> 
		</div>
	</div>
	<div id="editDiv"  class="top_content_wrap">
		<table class="form_table" style="table-layout:fixed;">
			<colgroup>
				<col width="16%" />
				<col width="34%" />
				<col width="16%" />
				<col width="34%" />
			</colgroup>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">人员姓名<span class="top_required">*</span>：</span></td>
					<td>
						<span uitype="Input" id="employeeName" maxlength="200" byte="true" textmode="false" width="85%" align="left" maskoptions="{}" databind="employee.employeeName" type="text" readonly="false" validate="[{'type':'required', 'rule':{'m': '人员姓名不能为空！'}}]"></span>
					</td>
					<td class="td_label"><span style="padding-left: 10px;">人员账号<span class="top_required">*</span>：</span></td>
					<td>
						<span uitype="Input" id="employeeAccount" maxlength="100" byte="true" textmode="false" width="85%" align="left" maskoptions="{}" databind="employee.employeeAccount" type="text" readonly="false" validate="EmployeeAccount" on_blur="checkAccount"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">账号密码<span class="top_required">*</span>：</span></td>
					<td>
						<span uitype="Input" id="employeePassword" maxlength="50" byte="true" textmode="false" maskoptions="{}" align="left" width="85%" databind="employee.employeePassword" type="password" readonly="false" validate="[{'type':'required', 'rule':{'m': '账号密码不能为空！'}}]"></span>
					</td>
					<td class="td_label"><span style="padding-left: 10px;">确认密码<span class="top_required">*</span>：</span></td>
					<td>
						<span uitype="Input" id="ensurePassword" maxlength="50" byte="true" textmode="false" maskoptions="{}" align="left" width="85%"  databind="employee.employeePassword"  type="password" readonly="false" validate="ensurePassword" on_blur="checkPassword"></span>
					</td>				
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">工作性质：</span></td>
					<td>
						<span uitype="PullDown" databind="employee.workingProperty" readonly="false" select="0" width="85%" label_field="text" value_field="id" must_exist="true" editable="true" empty_text="请选择" mode="Single" id="workingProperty" height="200" auto_complete="false" filter_fields="[]" datasource="WORK_PROPERTY"></span>
					</td>
					<td class="td_label"><span style="padding-left: 10px;">入职时间：</span></td>
					<td>
						<span uitype="Calender" panel="1" icon="true" maxdate="+0d" trigger="click" model="date" clearbtn="true" nocurrent="false" textmode="false" width="85%" format="yyyy-MM-dd" id="entryTime" okbtn="false" databind="employee.entryTime" isrange="false" iso8601="false" sunday_first="false" disable="false" readonly="false" separator="false" zindex="9999" entering="false" ></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">学历：</span></td>
					<td>
						<span uitype="PullDown" select="2" width="85%" label_field="text" value_field="id" must_exist="true" editable="true" empty_text="请选择" mode="Single" id="education" height="200" auto_complete="false" filter_fields="[]" databind="employee.education" readonly="false" datasource="EDUCATION" ></span>
					</td>
					<td class="td_label"><span style="padding-left: 10px;">性别：</span></td>
					<td>
						<span uitype="PullDown" select="0" width="85%" label_field="text" value_field="id" must_exist="true" editable="true" empty_text="请选择" mode="Single" id="sex" height="200" auto_complete="false" filter_fields="[]" databind="employee.sex" readonly="false" datasource="SEX"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">关联账户：</span></td>
					<td colspan="3">
						<span uitype="ChooseUser" id="relatedAccount" height="28px" width="34%"  databind="employee.relatedAccountObj" textmode="false"  canSelect="true"  isSearch="true"  isAllowOther="false" chooseMode="1" readonly="false" byByte="true"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">移动电话：</span></td>
					<td>
						<span uitype="Input" id="mobilePhone" name="mobilePhone" maxlength="36" byte="true" textmode="false" databind="employee.mobilePhone" width="85%" align="left" maskoptions="{}" type="text" readonly="false" validate="[{'type':'custom', 'rule':{'against':'validatemobile','m': '请输入有效的手机号码！'}}]"></span>
					</td>
					<td class="td_label"><span style="padding-left: 10px;">住宅电话：</span></td>
					<td>
						<span uitype="Input" id="areaCode" maxlength="4" databind="tell.areaCode" width="30%" align="left" validate="[{'type':'custom', 'rule':{'against':'isAreaCode','m': '请输入有效的区号！'}}]"></span> - 
						<span uitype="Input" id="number" maxlength="8" databind="tell.number" width="50%" align="left" validate="[{'type':'custom', 'rule':{'against':'istell','m': '请输入有效的电话号码！'}}]"></span>
<!-- 						<span uitype="Input" id="homePhone" name="homePhone" maxlength="36" byte="true" textmode="false" databind="employee.homePhone" width="85%" align="left" maskoptions="{}" type="text" readonly="false" validate="[{'type':'custom', 'rule':{'against':'istell','m': '请输入有效的电话号码！'}}]"></span> -->
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">电子邮箱：</span></td>
					<td colspan="3">
						<span uitype="Input" maxlength="48" id="electronicMail" name="electronicMail" byte="true" textmode="false" databind="employee.electronicMail" width="94%" align="left" maskoptions="{}" type="text" readonly="false" validate="[{'type':'custom', 'rule':{'against':'isemail','m': '请输入有效的邮箱地址！'}}]"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">地址：</span></td>
					<td colspan="3">
						<span uitype="Input" id="address" maxlength="1024" byte="true" textmode="false" databind="employee.address" maskoptions="{}" width="94%" align="left" type="text" readonly="false"></span>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<script type="text/javascript" src="<%=request.getContextPath()%>/cap/bm/common/cui/js/cui.utils.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/engine.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/util.js'></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/top/js/jquery.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/top/sys/usermanagement/orgusertag/js/choose.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/top/sys/usermanagement/orgusertag/js/userOrgUtil.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/top/sys/dwr/interface/ChooseAction.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/CapEmployeeAction.js'></script>

<script language="javascript"> 
	var EmployeelId = "<c:out value='${param.EmployeelId}'/>";
	var employee={};
	var tell={};
	var EmployeeVO = {};
	var accountList=[];
	var WORK_PROPERTY = [
	     			{id:'1',text:'正式职员'},
	     			{id:'2',text:'合作人员'},
	     			{id:'3',text:'临时职员'},
	     			{id:'4',text:'其他'}
	     			]
	var EDUCATION = [
			{id:'0',text:'博士'},
			{id:'1',text:'硕士'},
			{id:'2',text:'本科'},
			{id:'3',text:'大专'},
			{id:'4',text:'高中/中专'},
			{id:'5',text:'其他'}
			]
	var SEX = [
	     			{id:'1',text:'男'},
	     			{id:'2',text:'女'}
	     			]
	var EmployeeAccount=[{
			type: 'required',
			rule: {
			m: '账号不能为空'}
		},
	    {
			type: 'custom',
			rule: {
				against:'checkAccount',
				m:'账号已存在,请使用其他账号'
			}
		}];
	var ensurePassword=[{
			type: 'required',
			rule: {
			m: '确认密码不能为空'}
		},
	    {
			type: 'custom',
			rule: {
				against:'checkPassword',
				m:'两次输入的密码不一致'
		}
	}];
   	window.onload = function(){
   		getAccountList();
   		init();
   	}
   	
   	//关闭事件
	function btnClose() {
		parent.dialog.hide();
	}
   	
   	//检查两次输入密码是否一致 
   	function checkPassword(psssword){
   		var myPassword=cui("#employeePassword").getValue();
   		if(myPassword != psssword){
   			return false;
   		}
   		return true;
   	}
   	
   	//检查新建人员账号是否重复 
   	function checkAccount(){
   		var myAccount=cui("#employeeAccount").getValue();
   		for(var i=0;i<accountList.length;i++){
   			if(accountList[i] == myAccount){
   				return false;
   			}
   		}
   		return true;
   	}
   	
   	//获取所有账号，用来检查新建人员账号是否重复 
   	function getAccountList(){
   		var iCount=0;
   		CapEmployeeAction.queryEmployeeListNoPage(function(data){
   			if(data){
   					if(EmployeelId != ""){
   						for(var i=0;i<data.length;i++){
   							if(data[i].id != EmployeelId){
   								accountList[iCount]=data[i].employeeAccount;
   								iCount++;
   							}
   						}
   					}
   					else{
   						for(var i=0;i<data.length;i++){
   							accountList[i]=data[i].employeeAccount;
   						}
   					}
   				}
   			});
   	}
   	
	function init() {
		var relatedAccountObj={};
		if(EmployeelId != "" && EmployeelId) {
			dwr.TOPEngine.setAsync(false);
			CapEmployeeAction.queryCapEmployeeById(EmployeelId,function(bResult){
				employee = bResult;
				if(bResult.relatedAccount){
					relatedAccountObj=[{id:bResult.relatedUserId,name:bResult.relatedAccount}];
				}
				if(bResult.homePhone){
					var temp=bResult.homePhone.split("-");
					tell.areaCode=temp[0];
					tell.number=temp[1];
				}
			});
			dwr.TOPEngine.setAsync(true);
		}else{
			relatedAccountObj=[{id:"SuperAdmin",name:"超级管理员"}];
		}
		employee.relatedAccountObj=relatedAccountObj;
		comtop.UI.scan();
	}
	
	
	function btnSave(isBack) {
		var str = "";
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
		var EmployeeVO=employee;
		var relatedAccountObj=cui("#relatedAccount").getValue();
		EmployeeVO.entryTime = cui("#entryTime").getValue('date');
		if(cui("#areaCode").getValue()){
			EmployeeVO.homePhone=cui("#areaCode").getValue()+"-"+cui("#number").getValue();
		}
		if(relatedAccountObj[0]){
			//EmployeeVO.relatedAccount=relatedAccountObj[0].employeeAccount;
			EmployeeVO.relatedUserId=relatedAccountObj[0].id;
		}else{
			EmployeeVO.relatedAccount=null;
			EmployeeVO.relatedUserId=null;
		}
		EmployeeVO.employeeName=trim(EmployeeVO.employeeName);
		EmployeeVO.employeeAccount=trim(EmployeeVO.employeeAccount);
		EmployeeVO.cdt=new Date();
		if(EmployeeVO.mobilePhone){
			EmployeeVO.mobilePhone=trim(EmployeeVO.mobilePhone);
		}
		if(EmployeeVO.electronicMail){
			EmployeeVO.electronicMail=trim(EmployeeVO.electronicMail);
		}
		if(EmployeeVO.homePhone){
			EmployeeVO.homePhone=trim(EmployeeVO.homePhone);
		}
		if(EmployeeVO.address){
			EmployeeVO.address=trim(EmployeeVO.address);
		}
		dwr.TOPEngine.setAsync(false);
		CapEmployeeAction.saveEmployee(EmployeeVO,function(bResult){
			if(bResult){
				if(EmployeeVO.id){
					parent.cui.message('修改成功。','success');
				}
				else{
					parent.cui.message('新增成功。','success');
				}
				EmployeeVO.id=bResult;
			}
		});
		dwr.TOPEngine.setAsync(true);
		if(parent.insertReqQueryRow){
			parent.insertReqQueryRow(EmployeeVO);
		}
		if(parent.reflesh){
			parent.reflesh(EmployeeVO);
		}
		btnClose();
        // 保存成功
	}
	
	//校验手机号
 	function validatemobile()
	{
 		var mobile=cui('#mobilePhone').getValue();
 		mobile=mobile.replace(/(^\s*)|(\s*$)/g, "");
 		if(mobile!=""){
 			if(mobile.length != 11)
 	         {
 	              return false;
 	          }
 	         
 	     	var myreg = /^(((13[0-9]{1})|(1[0-9][0-9]))+\d{8})$/;
 		    if(!myreg.test(mobile)){
 		    	return false;
 		    	}
 		}
 		return true;
     }
 	 
 	//是否合法的邮箱地址
 	function isemail()
 	{
 	  var isemail=cui('#electronicMail').getValue();
 	 isemail=isemail.replace(/(^\s*)|(\s*$)/g, "");
 	  if(isemail!=""){
 		 var result=isemail.match(/^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/);
 	 	  if(result==null)
 	 	  {
 	 		return false;
 	 	  }
 	  }
 	 return true;
 	}
 	
 	//是否合法的电话号码
 	function istell()
 	{
 		
 	   var homePhone=cui('#number').getValue();
 	  	homePhone=homePhone.replace(/(^\s*)|(\s*$)/g, "");
 	   if(homePhone!=""){
 		   if(homePhone.length > 8 || homePhone.length < 7)
 		   {
 			  return false;
 		   }
 	   }
 	   return true;
 	}
 	
 	//是否合法的区号
 	function isAreaCode()
 	{
 		
 	   var areaCode=cui('#areaCode').getValue();
 	  areaCode=areaCode.replace(/(^\s*)|(\s*$)/g, "");
 	   if(areaCode!=""){
 		   if(areaCode.length > 4 || areaCode.length<3)
 		   {
 			  return false;
 		   }
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