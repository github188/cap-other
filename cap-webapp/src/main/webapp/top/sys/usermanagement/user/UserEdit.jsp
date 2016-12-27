<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<%@ page import="com.comtop.top.sys.usermanagement.user.util.UomCommonUtil" %>
<%		
	//是否隐藏系统人员组织功能按钮 true 隐藏 false 不隐藏
    boolean isHideSystemBtnInUserOrg = UomCommonUtil.getHideSystemBtnInUserOrgCfg();
%>

<html>
<head>
    <title>人员信息</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/UserManageAction.js"></script>
     <style type="text/css">
        html{
            padding-top:35px;  /*上部设置为50px*/
            -webkit-box-sizing: border-box;
            -moz-box-sizing: border-box;
            box-sizing: border-box;
            overflow:hidden;
        }
        html,body{
            margin:0;
            height: 100%;
            width:100%;
        }
      .top{
            width:100%;
            height:38px;  /*高度和padding设置一样*/
            margin-top: -35px; /*值和padding设置一样*/                     
            overflow: auto;
            position:relative;
      }
     .main{
          height: 100%;
            width:100%;
            overflow: auto;
     }
    </style>
</head>
<body>
<div class="top">
<div class="top_header_wrap">
      <div class="thw_operate" style = "padding-right:20px;">
      	<top:verifyAccess pageCode="TopUserAdmin" operateCode="updateUser">
            <span uiType="Button" id="editButton" label="编辑"  on_click="editUser" ></span>
      	</top:verifyAccess>
            <span uiType="Button" id="saveButton" label="保存" on_click="saveUser" ></span>
            <span uiType="Button" id="saveAndGoButton" label="保存继续" on_click="saveUserAndGo" ></span>
           <% if(!isHideSystemBtn){ %> 
              <% if(!isHideSystemBtnInUserOrg){ %>
            <span uiType="Button" id="activateUserButton" label="激活"    on_click="activateUser" ></span>
                 <% } %>
            <% } %>
            <span uiType="Button" id="clearButton" label="清空" on_click="clearAll" ></span>
            <span uiType="Button" id="returnReadButton" label="返回" on_click="returnRead" ></span>
			<span uiType="Button" id="closeButton" label="取消" on_click="closeSelf" ></span>
      </div>
</div>
</div>

<div class="main">
 <div id="editDiv"  class="top_content_wrap cui_ext_textmode" >
 <table id="editTable"  class="form_table" style="table-layout:fixed;">
         <colgroup>
	     	<col width="15%"/>
	     	<col width="35%"/>
	     	<col width="15%"/>
	     	<col width="35%"/>
	     </colgroup>
	     <tr ><td class="divTitle">基本信息</td></tr>
	        <tr>         
				<td class="td_label" ><span class="top_required">*</span>姓名：</td>
				<td ><span uiType="input"   class="cui_ext_textmode"  id="employeeName" name="employeeName" databind="data.employeeName" maxlength="50" width="90%"
				validate="[{'type':'required', 'rule':{'m': '姓名不能为空。'}},{'type':'custom','rule':{'against':'isNameContainSpecial','m':'姓名只能为中英文、数字或下划线。'}},{'type':'custom','rule':{'against':'isExsitUserName','m':'同一组织下该姓名已存在。'}}]"></span></td>
			    
			    <td class="td_label" ><span  class="top_required">*</span>账号：</td>
				<td ><span uiType="input"    id="account" name="account" databind="data.account" maxlength="100" width="90%" 
				validate="[{'type':'required', 'rule':{'m': '账号不能为空。'}},{'type':'custom','rule':{'against':'isExsitAccount','m':'账号已存在于在职用户中。'}},{'type':'custom','rule':{'against':'isExsitAccountInDel','m':'账号已存在于注销用户中。'}},{'type':'custom','rule':{'against':'isAccountContainSpecial','m':'账号只能为中英文、数字、下划线或小数点或@。'}}]"></span></td>
			</tr>
			
			
	    <tr>         
			<td id="passwordTD" class="td_label"  style="display: none"><span  class="top_required">*</span>密码：</td>
			<td ><span uiType="input"  type="password"    id="password" name="password" databind="data.password" maxlength="100" width="90%" 
			validate="[{'type':'required', 'rule':{'m': '密码不能为空。'}},{'type':'custom','rule':{'against':'checkPassword','m':'密码不符合规则。'}}]"></span></td>
		    <td id="validatePasswordTD" class="td_label"  style="display: none"><span  class="top_required">*</span>确认密码：</td>
			<td >
			 <span uiType="input"   type="password" id="validatePassword" name="validatePassword" databind="data.validatePassword" maxlength="100"  width="90%" 
			 validate="[{'type':'required', 'rule':{'m': '确认密码不能为空。'}},{'type':'confirmation', 'rule':{'match': 'password','m':'两次输入的密码不一致，请重新输入。'}}]"></span>
			</td>
		</tr>
		
		
		
		 <tr>         
			<td class="td_label" >人员编码：</td>
			<td ><span uiType="input"    id="code" name="code" databind="data.code" maxlength="20" width="90%" ></span></td>
			<td class="td_label" >所属组织：</td>
		    <td ><span uiType="input"     id="orgName" name="orgName" databind="data.orgName" width="90%"  maxlength="100" width="90%"  readonly=true></span></td>      
		</tr>
		
		 <tr>         
		    <td class="td_label" >工作性质：</span></td>
			<td >
			<span uiType="PullDown"   mode="Single"    id="jobStatus" name="jobStatus" databind="data.jobStatus" empty_text="" width="90%" datasource="jobStatusSource" label_field="text" value_field="id" ></span>
			</td> 
		    <td class="td_label" >学历：</span></td>
			<td >
			 <span uitype="singlePullDown" id="education" name="education" databind="data.education" datasource="initEducationSource" empty_text="" width="90%"	editable="false" label_field="educationName" value_field="educationCode" ></span>
			</td>
		</tr>
		
		 <tr>
		    <td class="td_label" >性别：</td>
			<td ><span uiType="PullDown"    mode="Single"    id="sex" name="sex" databind="data.sex" width="90%" empty_text="" datasource="sexSource" label_field="text" value_field="id" ></span></td>        
			
			<td class="td_label" >婚姻状况：</td>
			<td >
			<span uiType="PullDown"   mode="Single"    id="marriage" name="marriage" databind="data.marriage" empty_text="" width="90%" datasource="marriageSource" label_field="text" value_field="id" ></span>
			</td>  
		</tr>
		
		
		
		 <tr>
		    <td class="td_label" >身份证号：</td>
			<td ><span uiType="input"    id="identityCard" name="identityCard" databind="data.identityCard" maxlength="50" width="90%"
			validate="[{'type':'custom','rule':{'against':'isIdentityCardReg','m':'身份证号只能输入数字和字母。'}}]"/></td>     
		    
			<td class="td_label" >出生日期：</td>
		    <td ><span uitype="calender"    id="birthDay" name="birthDay"  databind="data.birthDay"  maxdate="-0d"  format="yyyy-MM-dd" ></span></td>
		</tr>
		
		<tr>         
		    <td class="td_label" >民族：</span></td>
		    <td >
		    <span uitype="singlePullDown" id="nationality" name="nationality" databind="data.nationality" datasource="initNationalitySource" empty_text="" width="90%"	editable="false" label_field="nationalityName" value_field="nationalityCode" ></span>
		    </td>       
			
		    <td class="td_label" >职称：</span></td>
			<td ><span uiType="input"    id="title" name="title"  databind="data.title" maxlength="50"  width="90%" ></span></td> 
		</tr>
		
		
		 <tr>
		        
		    <td class="td_label" >职务：</td>
			<td ><span uiType="input"    id="duty" name="duty" databind="data.duty" maxlength="50" width="90%"/></td>
		</tr>
		
		
		<tr>
		    <td class="td_label" valign="top">描述：</td>
			<td  colspan="3">
				<div style="width:95%;">
				<span uiType="Textarea"    id="note" name="note" width="100%" databind="data.note"  height="50px" maxlength="300" relation="defect1" ></span>
			       <div id="applyRemarkLengthFontDiv" style="float:right;display: none">
					 <font id="applyRemarkLengthFont" >(您还能输入<label id="defect1" style="color:red;"></label> 字符)</font>
				   </div>
			    </div>
			</td>
		</tr>
		
		  <tr>
		     <td class="divTitle">联系方式</td>
		  </tr>
		
		
		
		
		<tr>         
			<td class="td_label" >QQ：</td>
			<td ><span uiType="input"    id="qq" name="qq" databind="data.qq" maxlength="30" width="90%" validate="[{'type':'custom','rule':{'against':'isZipReg','m':'QQ只能数字'}}]"></span></td>
		    <td class="td_label" >移动电话：</td>
			<td ><span uiType="input"    id="mobilePhone" name="mobilePhone" databind="data.mobilePhone" maxlength="30" width="90%"
			validate="[{'type':'custom','rule':{'against':'isMobilePhoneReg','m':'移动电话只能输入数字、+。'}}]"></span></td>
		</tr>
		
		
		<tr>         
			<td class="td_label" >传真：</td>
			<td ><span uiType="input"    id="fax" name="fax" databind="data.fax" maxlength="30" width="90%" ></span></td>
		    <td class="td_label" >住宅电话：</td>
			<td ><span uiType="input"    id="honePhone" name="honePhone" databind="data.honePhone" maxlength="30" width="90%"
			validate="[{'type':'custom','rule':{'against':'isFixPhoneReg','m':'住宅电话只能输入数字、-、/。'}}]"></span></td>
		</tr>
		
		<tr>         
			<td class="td_label" >固定电话：</td>
			<td ><span uiType="input"    id="fixPhone" name="fixPhone" databind="data.fixPhone" maxlength="30" width="90%"
			validate="[{'type':'custom','rule':{'against':'isFixPhoneReg','m':'固定电话只能输入数字、-、/。'}}]"></span></td>
		    <td class="td_label" >电子邮箱：</td>
			<td ><span uiType="input"     id="email" name="email" databind="data.email" maxlength="60" width="90%"
			 validate="[{'type':'email', 'rule':{'m': '电子邮箱格式不正确。'}}]"></span></td>
		</tr>
		
		<tr>         
			<td class="td_label" >住址：</td>
			<td ><span uiType="input"    id="address" name="address" databind="data.address" maxlength="200" width="90%" ></span></td>
		    <td class="td_label" >邮编：</td>
			<td ><span uiType="input"    id="zip" name="zip" databind="data.zip" maxlength="10" width="90%"
			validate="[{'type':'custom','rule':{'against':'isZipReg','m':'邮编只能数字'}}]"></span></td>
		</tr>
	 </table>
	 <div id="divTitleForExtendId"  class="divTitleForExtend">扩展属性</div>
	 <div  id="extendFieldForEdit"></div>	 
 </div>
</div> 


<script language="javascript">
     
        var userId = "<c:out value='${param.userId}'/>";//人员ID
        var state = "<c:out value='${param.state}'/>";//人员状态
		var orgId ="<c:out value='${param.orgId}'/>";//组织ID
		var orgName = decodeURIComponent(decodeURIComponent("<c:out value='${param.orgName}'/>"));//组织名称 
		var orgStructureId = "<c:out value='${param.orgStructureId}'/>"; //为了消息记录中必须要记录组织结构ID 
		var password;
		var pattern;//密码规则
		var specialChar;//web配置文件中配置的特殊字符 表达 式对象
		var patternMessage;//密码不符合规则时的提示信息
		var emDialogId=""; //新增的addUser  编辑的editUser
        var data = {};
      //是否隐藏系统功能按钮 true 隐藏 false 不隐藏
		var isHideSystemBtn = '<%=isHideSystemBtn %>';
		 //是否隐藏系统人员组织功能按钮 true 隐藏 false 不隐藏
		var isHideSystemBtnInUserOrg = '<%=isHideSystemBtnInUserOrg %>';
        //学历数据
    	var educationSource=[  
    	                    {id:"博士研究生",text:"博士研究生"},
    	                    {id:"硕士研究生",text:"硕士研究生"},
    	                    {id:"本科",text:"本科"},
    	                    {id:"专科",text:"专科"},
    	                    {id:"中专",text:"中专"},
    	                    {id:"高中",text:"高中"},
    	                    {id:"初中",text:"初中"},
    	                    {id:"其他",text:"其他"}];
		
       //性别数据
        var sexSource=[  
    		                    {id:"1",text:"男"},
    		                    {id:"2",text:"女"}
    		                    
    		                    ];

        //状态数据
        var stateSource=[  
    		                    {id:"1",text:"在职"},
    		                    {id:"2",text:"离职"}
    		                    
    		                    ];

        //婚宴状况数据 
        var marriageSource=[  
    		                    {id:"1",text:"未婚"},
    		                    {id:"2",text:"已婚"},
    		                    {id:"3",text:"离异"},
    		                    {id:"4",text:"其他"}
    		                    ];
        
        //工作性质
        var jobStatusSource=[  
    		                    {id:"1",text:"正式员工"},
    		                    {id:"2",text:"领导"},
    		                    {id:"3",text:"临时用工"},
    		                    {id:"4",text:"劳务人员"},
    		                    {id:"5",text:"第三方人员"},
    		                    {id:"6",text:"其他"}
    		                    ];
        
    	//初始化民族下拉框数据
	 	function initNationalitySource(obj){
	 		dwr.TOPEngine.setAsync(false);
	 		UserManageAction.getNationalitySource(function(resultData){
					obj.setDatasource(jQuery.parseJSON(resultData));
				});
	 		dwr.TOPEngine.setAsync(true);
	 	}
    	
        
    	//初始化学历下拉框数据
	 	function initEducationSource(obj){
	 		dwr.TOPEngine.setAsync(false);
	 		UserManageAction.getEducationSource(function(resultData){
					obj.setDatasource(jQuery.parseJSON(resultData));
				});
	 		dwr.TOPEngine.setAsync(true);
	 	}
        

		window.onload = function(){
			
			//控制激活按钮显示
			if(state==1){
				cui('#activateUserButton').hide();
			}else if(state==2){//注销时
				cui('#saveAndGoButton').hide();
				cui('#activateUserButton').hide();
			}
			
			
			
			
			 if(userId){
				    emDialogId="editUser";
				    //编辑，开始是只读页面
				     cui('#clearButton').hide();
				     cui('#saveButton').hide();
				     cui('#saveAndGoButton').hide();
				     cui('#returnReadButton').hide();
			    	 var obj = {userId:userId};
					 dwr.TOPEngine.setAsync(false);
			    		UserManageAction.readUserInfo(obj,function(userData){
				    		//填充数据
			    			data = userData;
			    			orgId=userData.orgId;
			    			data.validatePassword = userData.password;
			    		
						});
			         //读取扩展属性值
			         setExtendFieldValue(obj);
			    	 dwr.TOPEngine.setAsync(true);
			    	 //全局只读
			    	 comtop.UI.scan.readonly=true;
			    	 //密码隐藏 
			    	 cui('#password').hide();
			    	 cui('#validatePassword').hide();
			    	 //必填项隐藏
			         $('.top_required').hide();
			    	 comtop.UI.scan();
			    	 //动态加载动态表单结构
					 userDataProvider(); 
					 //扩展属性的必填项，动态加载动态表单结构才能隐藏
			         $('.td_required').hide();
			    	 
			    }else{
			    	 emDialogId="addUser";
			    	 //动态加载动态表单结构
					  userDataProvider(); 
				    //新增
				    editUser("add");
				    cui('#saveAndGoButton').show();
				    cui('#returnReadButton').hide();
			    	//设置所属部门信息
				    data.orgName=orgName;
				    comtop.UI.scan();
				   
			    }
			 
			
		}
		
		 //进入编辑用户
		function editUser(type){
			
			
			 //移除只读样式并取消只读
			 $('.cui_ext_textmode').attr('cui_ext_textmode02');
			 comtop.UI.scan.setReadonly(false, $('#editDiv'))
			 cui('#saveButton').show();
		     cui('#returnReadButton').show();
		     cui('#editButton').hide();
		     if(type!="add"){
		         cui('#orgName').setReadonly(true);
		     }
	    	 
	    	 $("#passwordTD").show();
	    	 $("#validatePasswordTD").show(); 
			 //密码显示
		     cui('#password').show();
	    	 cui('#validatePassword').show();
	    	 $("#applyRemarkLengthFontDiv").attr('style', 'float:right;display:');
	    	 //必填项显示
	         $('.top_required').show();
	         //扩展属性的必填项
	         $('.td_required').show();
	    	 if(state==2){//注销页面
	    		 
	    		 cui('#activateUserButton').show();
	    	 }
	    	 
	    	 //全局基本信息只读20150330添加基本信息屏蔽的功能
	       if(isHideSystemBtn== 'true'){ //true 基本信息不可编辑，扩展属性可编辑
	    	     comtop.UI.scan.setReadonly(true, $('#editTable'));
	    	     $("#applyRemarkLengthFontDiv").attr('style', 'float:right;display:none');
		      }else{  //总开关关闭后，以isHideSystemBtnInUserOrg为准   20150429添加
		    	  if(isHideSystemBtnInUserOrg== 'true'){ //true 基本信息不可编辑，扩展属性可编辑
			    	     comtop.UI.scan.setReadonly(true, $('#editTable'));
			    	     $("#applyRemarkLengthFontDiv").attr('style', 'float:right;display:none');
				      }
		      }
		}
		
		
		 //返回查看
		function returnRead(){
			location.reload();
		}
		
		
		 //关闭窗口
		function closeSelf(){
			window.parent.dialog.hide();
		}
		 
		//保存人员信息
		function saveUser(){
			
			//验证表单
	         var map = window.validater.validAllElement();
	         var inValid = map[0];//放置错误信息
	         var valid = map[1]; //放置成功信
	         
	         if (inValid.length > 0) {
	             var str = "";
	             for (var i = 0; i < inValid.length; i++) {
	 					str +=  inValid[i].message + "<br />";
	 				}
	 			//错误信息多了，定位到第一个错误
	 			var top = $('#' + map[0][0].id).offset().top;
	 			$(document).scrollTop(top-10);
	         }else {
	                 
					 //获取表单信息
		        	var vo = cui(data).databind().getValue();
		        	    vo.orgId = orgId;  
		 	            vo.orgStructureId = orgStructureId;
			            vo.userId = userId;
			            //获得date格式
			            vo.birthDay = cui('#birthDay').getDateRange();
			           
			            if(userId){//编辑
			            	
		                	 UserManageAction.updateUser(vo,function(userId) {
		                		 if(userId){
		                		   window.parent.dialog.hide();
		                	       window.parent.cui.message("修改人员成功。",'success');
		                		   window.parent.editCallBack("edit",userId);
		                		 }else{
		                			 window.parent.cui.message("修改录入失败。",'error');
		                		 }
								  
			 				});
		                      
		                }else{
		                	   
		                	   //新增
					           dwr.TOPEngine.setAsync(false);
					            UserManageAction.saveUser(vo,function(userId){
					            	if(userId){
						               //刷新列表
									   window.parent.dialog.hide();
			                	       window.parent.cui.message("人员录入成功。",'success');
			                	       window.parent.editCallBack("add",userId);
					            	}else{
						            	window.parent.cui.message("人员录入失败。",'error');
					            	}
					    		});
					    		dwr.TOPEngine.setAsync(true);
		                     }
			            
					    		
	         }	    		
		}
		
		
		//保存人员信息并继续
		function saveUserAndGo(){
			//验证表单
	         var map = window.validater.validAllElement();
	         var inValid = map[0];//放置错误信息
	         var valid = map[1]; //放置成功信
	         
	         if (inValid.length > 0) {
	             var str = "";
	             for (var i = 0; i < inValid.length; i++) {
	 					str +=  inValid[i].message + "<br />";
	 				}
	 			//错误信息多了，定位到第一个错误
	 			var top = $('#' + map[0][0].id).offset().top;
	 			$(document).scrollTop(top-10);
	         }else {
			         
					 //获取表单信息
		        	var vo = cui(data).databind().getValue();
		        	    vo.orgId = orgId;  
		 	            vo.orgStructureId = orgStructureId;
			            vo.userId = userId;
			          //获得date格式
			            vo.birthDay = cui('#birthDay').getDateRange();
			           
			                      //新增
					           dwr.TOPEngine.setAsync(false);
					            UserManageAction.saveUser(vo,function(data){
					            	if(data){
							            //刷新列表
				                	    window.parent.cui.message("人员录入成功。",'success');
				                		window.parent.refreshList();
					            	}else{
					            		window.parent.cui.message("人员录入失败。",'error');
					            	}
					    		});
					    		dwr.TOPEngine.setAsync(true);
					    		//清空数据
					            cui(data).databind().setEmpty(); 
					            cui('#orgName').setValue(orgName);
					    		
	         }	    		
		}
		
		  /*
		* 判断名称是否包含特殊字符
		*/
		function isNameContainSpecial(data){
			var reg = new RegExp("^[\u4E00-\u9FA5A-Za-z0-9_]+$");
			return (reg.test(data));
		}
		  
		  
		/**
		* 同一组织下不能重名
		*/
		function isExsitUserName(data){ 
			
			var flag = true;
			if(data != ""){
				dwr.TOPEngine.setAsync(false);
				UserManageAction.isExsitUserName(data,userId,orgId,function(data){
					if(data){
						flag = false;
					}else{
						flag = true;
					}
				});
				dwr.TOPEngine.setAsync(true);
			}
			return flag;
		} 
		
		/**
		* 从在职查账号不能重复
		*/
		function isExsitAccount(data){ 
			
			var flag = true;
			if(data != ""){
				dwr.TOPEngine.setAsync(false);
				UserManageAction.isExsitAccount(data,userId,function(data){
					if(data){
							flag = false;
					}else{
							flag = true;
					}
				});
				dwr.TOPEngine.setAsync(true);
			}
			return flag;
		}
		
		
		/**
		* 从注销查账号不能重复
		*/
		function isExsitAccountInDel(data){ 
			
			var flag = true;
			if(data != ""){
				dwr.TOPEngine.setAsync(false);
				UserManageAction.isExsitAccountInDel(data,userId,function(data){
					if(data){
							flag = false;
					}else{
							flag = true;
					}
				});
				dwr.TOPEngine.setAsync(true);
			}
			return flag;
		}
		
		/*
		* 判断账号是否包含特殊字符
		*/
		function isAccountContainSpecial(data){
			
			var reg = new RegExp("^[\u4E00-\u9FA5A-Za-z0-9_.@]+$");
			return (reg.test(data));
		}
		
		/**校验密码规则-需要去配置平台读取*/
		function checkPassword(){
			password = cui('#password').getValue();
			password = toTrim(password);
			if(!pattern){
				//从配置平台获取密码规则
				dwr.TOPEngine.setAsync(false);
				UserManageAction.getPasswordRule(function(result){
					if(result){
						if(result.pattern){
							pattern = new RegExp(result.pattern);
						}
						if(result.special){
							specialChar = new RegExp(result.special);
						}
						if(result.message){
							patternMessage=result.message;
						}else{
							patternMessage="不符合规则";
						}
					}
				});
				dwr.TOPEngine.setAsync(true);
			
			}
			if((pattern&&!pattern.test(password))||(specialChar&&specialChar.test(password))){
				setTimeout(function(){
					cui('#password').onInValid(null, patternMessage);
				},100);
				return false;
			}
			return true;
		}
		
		/*
		* 判断移动电话 是否包含特殊字符
		*/
		function isMobilePhoneReg(data){
			
			if(data){
				var reg = new RegExp("^[0-9+]+$");
				return (reg.test(data));
			}
			return true;
		}
	      
		
		/*
		* 判断固定电话是否包含特殊字符
		*/
		function isFixPhoneReg(data){
			if(data){
				var reg = new RegExp("^[0-9-/]+$");
				return (reg.test(data));
			}
			return true;
		}
		
		/*
		* 判断邮编是否为六位数字
		*/
		function isZipReg(data){
			if(data){
				var reg = new RegExp("^[0-9]+$");
				return (reg.test(data));
			}
			return true;
		}
		
		
		
		/*
		* 判断身份证号是否为数字和字母组成的
		*/
		function isIdentityCardReg(data){
			if(data){
				var reg = new RegExp("^[A-Za-z0-9]+$");
				return (reg.test(data));
			}
			return true;
		}
		
		
		//特殊字符替换 
		function toTrim(str){
			return str.replace(/(^\s*)|(\s*$)/g,'');
		}
		
		//新增清空 
		function clearAll(){
			  cui(data).databind().setEmpty();  
			  cui('#orgName').setValue(orgName);
		}
		
		
		


		//激活人员信息
		function activateUser(){
	     //设置验证获取信息
	     var map = window.validater.validAllElement();
	   	 var inValid = map[0];//放置错误信息
	   	 var valid = map[1]; //放置成功信息
	   	 
	   	 
	     if (inValid.length > 0) {
             var str = "";
             for (var i = 0; i < inValid.length; i++) {
 					str +=  inValid[i].message + "<br />";
 				}
 			//错误信息多了，定位到第一个错误
 			var top = $('#' + map[0][0].id).offset().top;
 			$(document).scrollTop(top-10);
         }else {
			     //验证部门是否注销
			  	if(!isDeptValidate()){
			  		
			            //获取表单信息
			            var vo = cui(data).databind().getValue();
				            vo.orgId = orgId;  
			 	            vo.orgStructureId = orgStructureId;
				            vo.userId = userId;
			               if(userId){//编辑
			            	  
			               	 UserManageAction.activeUser(vo,function(data) {
								
								 window.parent.dialog.hide();
		                	     window.parent.cui.message("人员激活成功。",'success');
		                		 window.parent.refreshList();
			  				});
			               }
			       	 	
					}
              }
		}
		
		/*
		* 判断部门是否注销 
		*/
		function isDeptValidate(){
			var falg = false;
			
			
		    dwr.TOPEngine.setAsync(false);
				UserManageAction.isDeptValidate(orgId,function(data){
					falg = data;
				});
		    dwr.TOPEngine.setAsync(true);
			
			if(falg){
				cui.warn('所属组织已经注销，无法激活。<br>',function() {})
				return true;
			}
			return false;
		}
		
		 //读取扩展属性值
		function setExtendFieldValue(obj){
			//扩展属性初始值的设置
			UserManageAction.queryExtendValueByUserId(obj,function(extendFieldData){
				data.attribute_1=extendFieldData.attribute_1;
				data.attribute_2=extendFieldData.attribute_2;
				data.attribute_3=extendFieldData.attribute_3;
				data.attribute_4=extendFieldData.attribute_4;
				data.attribute_5=extendFieldData.attribute_5;
				data.attribute_6=extendFieldData.attribute_6;
				data.attribute_7=extendFieldData.attribute_7;
				data.attribute_8=extendFieldData.attribute_8;
				data.attribute_9=extendFieldData.attribute_9;
				data.attribute_10=extendFieldData.attribute_10;
				data.attribute_11=extendFieldData.attribute_11;
				data.attribute_12=extendFieldData.attribute_12;
				data.attribute_13=extendFieldData.attribute_13;
				data.attribute_14=extendFieldData.attribute_14;
				data.attribute_15=extendFieldData.attribute_15;
				data.attribute_16=extendFieldData.attribute_16;
				data.attribute_17=extendFieldData.attribute_17;
				data.attribute_18=extendFieldData.attribute_18;
				data.attribute_19=extendFieldData.attribute_19;
				data.attribute_20=extendFieldData.attribute_20;
				
			});
			
		}
		 
		//动态加载动态表单结构
		function userDataProvider(){
			dwr.TOPEngine.setAsync(false);
			UserManageAction.producePageCUI(userId,function(data){
				if(data.length == 0){
			       $('#extendFieldForEdit').hide();
			        //隐藏扩展属性div
					$('#divTitleForExtendId').hide();
				}else{
					$('#divTitleForExtendId').show();
					for(var i=0;i<data.length;i++){
						var obj=data[i];
						if(obj.datasource!=null&&obj.datasource!=''){
							 //将字符串转json格式
							obj.datasource = jQuery.parseJSON(obj.datasource); 
						}
					}
					
					cui('#extendFieldForEdit').customform({
						datasource:data
					});
					
					//设置扩展属性非空验证
					var validate = window.validater;//comtop.UI.scan()在前使用这种方法
					for(var i=0;i<data.length;i++){
						var obj=data[i];
						if(obj.required == true){
							validate.add(obj.id,'required',{m:obj.label+'不能为空。'});
					 	}
					}
					
				}
		 	});
			dwr.TOPEngine.setAsync(true);
		}
		 
		
</script>
</body>
</html>