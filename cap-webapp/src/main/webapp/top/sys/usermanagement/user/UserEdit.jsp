<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<%@ page import="com.comtop.top.sys.usermanagement.user.util.UomCommonUtil" %>
<%		
	//�Ƿ�����ϵͳ��Ա��֯���ܰ�ť true ���� false ������
    boolean isHideSystemBtnInUserOrg = UomCommonUtil.getHideSystemBtnInUserOrgCfg();
%>

<html>
<head>
    <title>��Ա��Ϣ</title>
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
            padding-top:35px;  /*�ϲ�����Ϊ50px*/
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
            height:38px;  /*�߶Ⱥ�padding����һ��*/
            margin-top: -35px; /*ֵ��padding����һ��*/                     
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
            <span uiType="Button" id="editButton" label="�༭"  on_click="editUser" ></span>
      	</top:verifyAccess>
            <span uiType="Button" id="saveButton" label="����" on_click="saveUser" ></span>
            <span uiType="Button" id="saveAndGoButton" label="�������" on_click="saveUserAndGo" ></span>
           <% if(!isHideSystemBtn){ %> 
              <% if(!isHideSystemBtnInUserOrg){ %>
            <span uiType="Button" id="activateUserButton" label="����"    on_click="activateUser" ></span>
                 <% } %>
            <% } %>
            <span uiType="Button" id="clearButton" label="���" on_click="clearAll" ></span>
            <span uiType="Button" id="returnReadButton" label="����" on_click="returnRead" ></span>
			<span uiType="Button" id="closeButton" label="ȡ��" on_click="closeSelf" ></span>
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
	     <tr ><td class="divTitle">������Ϣ</td></tr>
	        <tr>         
				<td class="td_label" ><span class="top_required">*</span>������</td>
				<td ><span uiType="input"   class="cui_ext_textmode"  id="employeeName" name="employeeName" databind="data.employeeName" maxlength="50" width="90%"
				validate="[{'type':'required', 'rule':{'m': '��������Ϊ�ա�'}},{'type':'custom','rule':{'against':'isNameContainSpecial','m':'����ֻ��Ϊ��Ӣ�ġ����ֻ��»��ߡ�'}},{'type':'custom','rule':{'against':'isExsitUserName','m':'ͬһ��֯�¸������Ѵ��ڡ�'}}]"></span></td>
			    
			    <td class="td_label" ><span  class="top_required">*</span>�˺ţ�</td>
				<td ><span uiType="input"    id="account" name="account" databind="data.account" maxlength="100" width="90%" 
				validate="[{'type':'required', 'rule':{'m': '�˺Ų���Ϊ�ա�'}},{'type':'custom','rule':{'against':'isExsitAccount','m':'�˺��Ѵ�������ְ�û��С�'}},{'type':'custom','rule':{'against':'isExsitAccountInDel','m':'�˺��Ѵ�����ע���û��С�'}},{'type':'custom','rule':{'against':'isAccountContainSpecial','m':'�˺�ֻ��Ϊ��Ӣ�ġ����֡��»��߻�С�����@��'}}]"></span></td>
			</tr>
			
			
	    <tr>         
			<td id="passwordTD" class="td_label"  style="display: none"><span  class="top_required">*</span>���룺</td>
			<td ><span uiType="input"  type="password"    id="password" name="password" databind="data.password" maxlength="100" width="90%" 
			validate="[{'type':'required', 'rule':{'m': '���벻��Ϊ�ա�'}},{'type':'custom','rule':{'against':'checkPassword','m':'���벻���Ϲ���'}}]"></span></td>
		    <td id="validatePasswordTD" class="td_label"  style="display: none"><span  class="top_required">*</span>ȷ�����룺</td>
			<td >
			 <span uiType="input"   type="password" id="validatePassword" name="validatePassword" databind="data.validatePassword" maxlength="100"  width="90%" 
			 validate="[{'type':'required', 'rule':{'m': 'ȷ�����벻��Ϊ�ա�'}},{'type':'confirmation', 'rule':{'match': 'password','m':'������������벻һ�£����������롣'}}]"></span>
			</td>
		</tr>
		
		
		
		 <tr>         
			<td class="td_label" >��Ա���룺</td>
			<td ><span uiType="input"    id="code" name="code" databind="data.code" maxlength="20" width="90%" ></span></td>
			<td class="td_label" >������֯��</td>
		    <td ><span uiType="input"     id="orgName" name="orgName" databind="data.orgName" width="90%"  maxlength="100" width="90%"  readonly=true></span></td>      
		</tr>
		
		 <tr>         
		    <td class="td_label" >�������ʣ�</span></td>
			<td >
			<span uiType="PullDown"   mode="Single"    id="jobStatus" name="jobStatus" databind="data.jobStatus" empty_text="" width="90%" datasource="jobStatusSource" label_field="text" value_field="id" ></span>
			</td> 
		    <td class="td_label" >ѧ����</span></td>
			<td >
			 <span uitype="singlePullDown" id="education" name="education" databind="data.education" datasource="initEducationSource" empty_text="" width="90%"	editable="false" label_field="educationName" value_field="educationCode" ></span>
			</td>
		</tr>
		
		 <tr>
		    <td class="td_label" >�Ա�</td>
			<td ><span uiType="PullDown"    mode="Single"    id="sex" name="sex" databind="data.sex" width="90%" empty_text="" datasource="sexSource" label_field="text" value_field="id" ></span></td>        
			
			<td class="td_label" >����״����</td>
			<td >
			<span uiType="PullDown"   mode="Single"    id="marriage" name="marriage" databind="data.marriage" empty_text="" width="90%" datasource="marriageSource" label_field="text" value_field="id" ></span>
			</td>  
		</tr>
		
		
		
		 <tr>
		    <td class="td_label" >���֤�ţ�</td>
			<td ><span uiType="input"    id="identityCard" name="identityCard" databind="data.identityCard" maxlength="50" width="90%"
			validate="[{'type':'custom','rule':{'against':'isIdentityCardReg','m':'���֤��ֻ���������ֺ���ĸ��'}}]"/></td>     
		    
			<td class="td_label" >�������ڣ�</td>
		    <td ><span uitype="calender"    id="birthDay" name="birthDay"  databind="data.birthDay"  maxdate="-0d"  format="yyyy-MM-dd" ></span></td>
		</tr>
		
		<tr>         
		    <td class="td_label" >���壺</span></td>
		    <td >
		    <span uitype="singlePullDown" id="nationality" name="nationality" databind="data.nationality" datasource="initNationalitySource" empty_text="" width="90%"	editable="false" label_field="nationalityName" value_field="nationalityCode" ></span>
		    </td>       
			
		    <td class="td_label" >ְ�ƣ�</span></td>
			<td ><span uiType="input"    id="title" name="title"  databind="data.title" maxlength="50"  width="90%" ></span></td> 
		</tr>
		
		
		 <tr>
		        
		    <td class="td_label" >ְ��</td>
			<td ><span uiType="input"    id="duty" name="duty" databind="data.duty" maxlength="50" width="90%"/></td>
		</tr>
		
		
		<tr>
		    <td class="td_label" valign="top">������</td>
			<td  colspan="3">
				<div style="width:95%;">
				<span uiType="Textarea"    id="note" name="note" width="100%" databind="data.note"  height="50px" maxlength="300" relation="defect1" ></span>
			       <div id="applyRemarkLengthFontDiv" style="float:right;display: none">
					 <font id="applyRemarkLengthFont" >(����������<label id="defect1" style="color:red;"></label> �ַ�)</font>
				   </div>
			    </div>
			</td>
		</tr>
		
		  <tr>
		     <td class="divTitle">��ϵ��ʽ</td>
		  </tr>
		
		
		
		
		<tr>         
			<td class="td_label" >QQ��</td>
			<td ><span uiType="input"    id="qq" name="qq" databind="data.qq" maxlength="30" width="90%" validate="[{'type':'custom','rule':{'against':'isZipReg','m':'QQֻ������'}}]"></span></td>
		    <td class="td_label" >�ƶ��绰��</td>
			<td ><span uiType="input"    id="mobilePhone" name="mobilePhone" databind="data.mobilePhone" maxlength="30" width="90%"
			validate="[{'type':'custom','rule':{'against':'isMobilePhoneReg','m':'�ƶ��绰ֻ���������֡�+��'}}]"></span></td>
		</tr>
		
		
		<tr>         
			<td class="td_label" >���棺</td>
			<td ><span uiType="input"    id="fax" name="fax" databind="data.fax" maxlength="30" width="90%" ></span></td>
		    <td class="td_label" >סլ�绰��</td>
			<td ><span uiType="input"    id="honePhone" name="honePhone" databind="data.honePhone" maxlength="30" width="90%"
			validate="[{'type':'custom','rule':{'against':'isFixPhoneReg','m':'סլ�绰ֻ���������֡�-��/��'}}]"></span></td>
		</tr>
		
		<tr>         
			<td class="td_label" >�̶��绰��</td>
			<td ><span uiType="input"    id="fixPhone" name="fixPhone" databind="data.fixPhone" maxlength="30" width="90%"
			validate="[{'type':'custom','rule':{'against':'isFixPhoneReg','m':'�̶��绰ֻ���������֡�-��/��'}}]"></span></td>
		    <td class="td_label" >�������䣺</td>
			<td ><span uiType="input"     id="email" name="email" databind="data.email" maxlength="60" width="90%"
			 validate="[{'type':'email', 'rule':{'m': '���������ʽ����ȷ��'}}]"></span></td>
		</tr>
		
		<tr>         
			<td class="td_label" >סַ��</td>
			<td ><span uiType="input"    id="address" name="address" databind="data.address" maxlength="200" width="90%" ></span></td>
		    <td class="td_label" >�ʱࣺ</td>
			<td ><span uiType="input"    id="zip" name="zip" databind="data.zip" maxlength="10" width="90%"
			validate="[{'type':'custom','rule':{'against':'isZipReg','m':'�ʱ�ֻ������'}}]"></span></td>
		</tr>
	 </table>
	 <div id="divTitleForExtendId"  class="divTitleForExtend">��չ����</div>
	 <div  id="extendFieldForEdit"></div>	 
 </div>
</div> 


<script language="javascript">
     
        var userId = "<c:out value='${param.userId}'/>";//��ԱID
        var state = "<c:out value='${param.state}'/>";//��Ա״̬
		var orgId ="<c:out value='${param.orgId}'/>";//��֯ID
		var orgName = decodeURIComponent(decodeURIComponent("<c:out value='${param.orgName}'/>"));//��֯���� 
		var orgStructureId = "<c:out value='${param.orgStructureId}'/>"; //Ϊ����Ϣ��¼�б���Ҫ��¼��֯�ṹID 
		var password;
		var pattern;//�������
		var specialChar;//web�����ļ������õ������ַ� ��� ʽ����
		var patternMessage;//���벻���Ϲ���ʱ����ʾ��Ϣ
		var emDialogId=""; //������addUser  �༭��editUser
        var data = {};
      //�Ƿ�����ϵͳ���ܰ�ť true ���� false ������
		var isHideSystemBtn = '<%=isHideSystemBtn %>';
		 //�Ƿ�����ϵͳ��Ա��֯���ܰ�ť true ���� false ������
		var isHideSystemBtnInUserOrg = '<%=isHideSystemBtnInUserOrg %>';
        //ѧ������
    	var educationSource=[  
    	                    {id:"��ʿ�о���",text:"��ʿ�о���"},
    	                    {id:"˶ʿ�о���",text:"˶ʿ�о���"},
    	                    {id:"����",text:"����"},
    	                    {id:"ר��",text:"ר��"},
    	                    {id:"��ר",text:"��ר"},
    	                    {id:"����",text:"����"},
    	                    {id:"����",text:"����"},
    	                    {id:"����",text:"����"}];
		
       //�Ա�����
        var sexSource=[  
    		                    {id:"1",text:"��"},
    		                    {id:"2",text:"Ů"}
    		                    
    		                    ];

        //״̬����
        var stateSource=[  
    		                    {id:"1",text:"��ְ"},
    		                    {id:"2",text:"��ְ"}
    		                    
    		                    ];

        //����״������ 
        var marriageSource=[  
    		                    {id:"1",text:"δ��"},
    		                    {id:"2",text:"�ѻ�"},
    		                    {id:"3",text:"����"},
    		                    {id:"4",text:"����"}
    		                    ];
        
        //��������
        var jobStatusSource=[  
    		                    {id:"1",text:"��ʽԱ��"},
    		                    {id:"2",text:"�쵼"},
    		                    {id:"3",text:"��ʱ�ù�"},
    		                    {id:"4",text:"������Ա"},
    		                    {id:"5",text:"��������Ա"},
    		                    {id:"6",text:"����"}
    		                    ];
        
    	//��ʼ����������������
	 	function initNationalitySource(obj){
	 		dwr.TOPEngine.setAsync(false);
	 		UserManageAction.getNationalitySource(function(resultData){
					obj.setDatasource(jQuery.parseJSON(resultData));
				});
	 		dwr.TOPEngine.setAsync(true);
	 	}
    	
        
    	//��ʼ��ѧ������������
	 	function initEducationSource(obj){
	 		dwr.TOPEngine.setAsync(false);
	 		UserManageAction.getEducationSource(function(resultData){
					obj.setDatasource(jQuery.parseJSON(resultData));
				});
	 		dwr.TOPEngine.setAsync(true);
	 	}
        

		window.onload = function(){
			
			//���Ƽ��ť��ʾ
			if(state==1){
				cui('#activateUserButton').hide();
			}else if(state==2){//ע��ʱ
				cui('#saveAndGoButton').hide();
				cui('#activateUserButton').hide();
			}
			
			
			
			
			 if(userId){
				    emDialogId="editUser";
				    //�༭����ʼ��ֻ��ҳ��
				     cui('#clearButton').hide();
				     cui('#saveButton').hide();
				     cui('#saveAndGoButton').hide();
				     cui('#returnReadButton').hide();
			    	 var obj = {userId:userId};
					 dwr.TOPEngine.setAsync(false);
			    		UserManageAction.readUserInfo(obj,function(userData){
				    		//�������
			    			data = userData;
			    			orgId=userData.orgId;
			    			data.validatePassword = userData.password;
			    		
						});
			         //��ȡ��չ����ֵ
			         setExtendFieldValue(obj);
			    	 dwr.TOPEngine.setAsync(true);
			    	 //ȫ��ֻ��
			    	 comtop.UI.scan.readonly=true;
			    	 //�������� 
			    	 cui('#password').hide();
			    	 cui('#validatePassword').hide();
			    	 //����������
			         $('.top_required').hide();
			    	 comtop.UI.scan();
			    	 //��̬���ض�̬���ṹ
					 userDataProvider(); 
					 //��չ���Եı������̬���ض�̬���ṹ��������
			         $('.td_required').hide();
			    	 
			    }else{
			    	 emDialogId="addUser";
			    	 //��̬���ض�̬���ṹ
					  userDataProvider(); 
				    //����
				    editUser("add");
				    cui('#saveAndGoButton').show();
				    cui('#returnReadButton').hide();
			    	//��������������Ϣ
				    data.orgName=orgName;
				    comtop.UI.scan();
				   
			    }
			 
			
		}
		
		 //����༭�û�
		function editUser(type){
			
			
			 //�Ƴ�ֻ����ʽ��ȡ��ֻ��
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
			 //������ʾ
		     cui('#password').show();
	    	 cui('#validatePassword').show();
	    	 $("#applyRemarkLengthFontDiv").attr('style', 'float:right;display:');
	    	 //��������ʾ
	         $('.top_required').show();
	         //��չ���Եı�����
	         $('.td_required').show();
	    	 if(state==2){//ע��ҳ��
	    		 
	    		 cui('#activateUserButton').show();
	    	 }
	    	 
	    	 //ȫ�ֻ�����Ϣֻ��20150330��ӻ�����Ϣ���εĹ���
	       if(isHideSystemBtn== 'true'){ //true ������Ϣ���ɱ༭����չ���Կɱ༭
	    	     comtop.UI.scan.setReadonly(true, $('#editTable'));
	    	     $("#applyRemarkLengthFontDiv").attr('style', 'float:right;display:none');
		      }else{  //�ܿ��عرպ���isHideSystemBtnInUserOrgΪ׼   20150429���
		    	  if(isHideSystemBtnInUserOrg== 'true'){ //true ������Ϣ���ɱ༭����չ���Կɱ༭
			    	     comtop.UI.scan.setReadonly(true, $('#editTable'));
			    	     $("#applyRemarkLengthFontDiv").attr('style', 'float:right;display:none');
				      }
		      }
		}
		
		
		 //���ز鿴
		function returnRead(){
			location.reload();
		}
		
		
		 //�رմ���
		function closeSelf(){
			window.parent.dialog.hide();
		}
		 
		//������Ա��Ϣ
		function saveUser(){
			
			//��֤��
	         var map = window.validater.validAllElement();
	         var inValid = map[0];//���ô�����Ϣ
	         var valid = map[1]; //���óɹ���
	         
	         if (inValid.length > 0) {
	             var str = "";
	             for (var i = 0; i < inValid.length; i++) {
	 					str +=  inValid[i].message + "<br />";
	 				}
	 			//������Ϣ���ˣ���λ����һ������
	 			var top = $('#' + map[0][0].id).offset().top;
	 			$(document).scrollTop(top-10);
	         }else {
	                 
					 //��ȡ����Ϣ
		        	var vo = cui(data).databind().getValue();
		        	    vo.orgId = orgId;  
		 	            vo.orgStructureId = orgStructureId;
			            vo.userId = userId;
			            //���date��ʽ
			            vo.birthDay = cui('#birthDay').getDateRange();
			           
			            if(userId){//�༭
			            	
		                	 UserManageAction.updateUser(vo,function(userId) {
		                		 if(userId){
		                		   window.parent.dialog.hide();
		                	       window.parent.cui.message("�޸���Ա�ɹ���",'success');
		                		   window.parent.editCallBack("edit",userId);
		                		 }else{
		                			 window.parent.cui.message("�޸�¼��ʧ�ܡ�",'error');
		                		 }
								  
			 				});
		                      
		                }else{
		                	   
		                	   //����
					           dwr.TOPEngine.setAsync(false);
					            UserManageAction.saveUser(vo,function(userId){
					            	if(userId){
						               //ˢ���б�
									   window.parent.dialog.hide();
			                	       window.parent.cui.message("��Ա¼��ɹ���",'success');
			                	       window.parent.editCallBack("add",userId);
					            	}else{
						            	window.parent.cui.message("��Ա¼��ʧ�ܡ�",'error');
					            	}
					    		});
					    		dwr.TOPEngine.setAsync(true);
		                     }
			            
					    		
	         }	    		
		}
		
		
		//������Ա��Ϣ������
		function saveUserAndGo(){
			//��֤��
	         var map = window.validater.validAllElement();
	         var inValid = map[0];//���ô�����Ϣ
	         var valid = map[1]; //���óɹ���
	         
	         if (inValid.length > 0) {
	             var str = "";
	             for (var i = 0; i < inValid.length; i++) {
	 					str +=  inValid[i].message + "<br />";
	 				}
	 			//������Ϣ���ˣ���λ����һ������
	 			var top = $('#' + map[0][0].id).offset().top;
	 			$(document).scrollTop(top-10);
	         }else {
			         
					 //��ȡ����Ϣ
		        	var vo = cui(data).databind().getValue();
		        	    vo.orgId = orgId;  
		 	            vo.orgStructureId = orgStructureId;
			            vo.userId = userId;
			          //���date��ʽ
			            vo.birthDay = cui('#birthDay').getDateRange();
			           
			                      //����
					           dwr.TOPEngine.setAsync(false);
					            UserManageAction.saveUser(vo,function(data){
					            	if(data){
							            //ˢ���б�
				                	    window.parent.cui.message("��Ա¼��ɹ���",'success');
				                		window.parent.refreshList();
					            	}else{
					            		window.parent.cui.message("��Ա¼��ʧ�ܡ�",'error');
					            	}
					    		});
					    		dwr.TOPEngine.setAsync(true);
					    		//�������
					            cui(data).databind().setEmpty(); 
					            cui('#orgName').setValue(orgName);
					    		
	         }	    		
		}
		
		  /*
		* �ж������Ƿ���������ַ�
		*/
		function isNameContainSpecial(data){
			var reg = new RegExp("^[\u4E00-\u9FA5A-Za-z0-9_]+$");
			return (reg.test(data));
		}
		  
		  
		/**
		* ͬһ��֯�²�������
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
		* ����ְ���˺Ų����ظ�
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
		* ��ע�����˺Ų����ظ�
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
		* �ж��˺��Ƿ���������ַ�
		*/
		function isAccountContainSpecial(data){
			
			var reg = new RegExp("^[\u4E00-\u9FA5A-Za-z0-9_.@]+$");
			return (reg.test(data));
		}
		
		/**У���������-��Ҫȥ����ƽ̨��ȡ*/
		function checkPassword(){
			password = cui('#password').getValue();
			password = toTrim(password);
			if(!pattern){
				//������ƽ̨��ȡ�������
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
							patternMessage="�����Ϲ���";
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
		* �ж��ƶ��绰 �Ƿ���������ַ�
		*/
		function isMobilePhoneReg(data){
			
			if(data){
				var reg = new RegExp("^[0-9+]+$");
				return (reg.test(data));
			}
			return true;
		}
	      
		
		/*
		* �жϹ̶��绰�Ƿ���������ַ�
		*/
		function isFixPhoneReg(data){
			if(data){
				var reg = new RegExp("^[0-9-/]+$");
				return (reg.test(data));
			}
			return true;
		}
		
		/*
		* �ж��ʱ��Ƿ�Ϊ��λ����
		*/
		function isZipReg(data){
			if(data){
				var reg = new RegExp("^[0-9]+$");
				return (reg.test(data));
			}
			return true;
		}
		
		
		
		/*
		* �ж����֤���Ƿ�Ϊ���ֺ���ĸ��ɵ�
		*/
		function isIdentityCardReg(data){
			if(data){
				var reg = new RegExp("^[A-Za-z0-9]+$");
				return (reg.test(data));
			}
			return true;
		}
		
		
		//�����ַ��滻 
		function toTrim(str){
			return str.replace(/(^\s*)|(\s*$)/g,'');
		}
		
		//������� 
		function clearAll(){
			  cui(data).databind().setEmpty();  
			  cui('#orgName').setValue(orgName);
		}
		
		
		


		//������Ա��Ϣ
		function activateUser(){
	     //������֤��ȡ��Ϣ
	     var map = window.validater.validAllElement();
	   	 var inValid = map[0];//���ô�����Ϣ
	   	 var valid = map[1]; //���óɹ���Ϣ
	   	 
	   	 
	     if (inValid.length > 0) {
             var str = "";
             for (var i = 0; i < inValid.length; i++) {
 					str +=  inValid[i].message + "<br />";
 				}
 			//������Ϣ���ˣ���λ����һ������
 			var top = $('#' + map[0][0].id).offset().top;
 			$(document).scrollTop(top-10);
         }else {
			     //��֤�����Ƿ�ע��
			  	if(!isDeptValidate()){
			  		
			            //��ȡ����Ϣ
			            var vo = cui(data).databind().getValue();
				            vo.orgId = orgId;  
			 	            vo.orgStructureId = orgStructureId;
				            vo.userId = userId;
			               if(userId){//�༭
			            	  
			               	 UserManageAction.activeUser(vo,function(data) {
								
								 window.parent.dialog.hide();
		                	     window.parent.cui.message("��Ա����ɹ���",'success');
		                		 window.parent.refreshList();
			  				});
			               }
			       	 	
					}
              }
		}
		
		/*
		* �жϲ����Ƿ�ע�� 
		*/
		function isDeptValidate(){
			var falg = false;
			
			
		    dwr.TOPEngine.setAsync(false);
				UserManageAction.isDeptValidate(orgId,function(data){
					falg = data;
				});
		    dwr.TOPEngine.setAsync(true);
			
			if(falg){
				cui.warn('������֯�Ѿ�ע�����޷����<br>',function() {})
				return true;
			}
			return false;
		}
		
		 //��ȡ��չ����ֵ
		function setExtendFieldValue(obj){
			//��չ���Գ�ʼֵ������
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
		 
		//��̬���ض�̬���ṹ
		function userDataProvider(){
			dwr.TOPEngine.setAsync(false);
			UserManageAction.producePageCUI(userId,function(data){
				if(data.length == 0){
			       $('#extendFieldForEdit').hide();
			        //������չ����div
					$('#divTitleForExtendId').hide();
				}else{
					$('#divTitleForExtendId').show();
					for(var i=0;i<data.length;i++){
						var obj=data[i];
						if(obj.datasource!=null&&obj.datasource!=''){
							 //���ַ���תjson��ʽ
							obj.datasource = jQuery.parseJSON(obj.datasource); 
						}
					}
					
					cui('#extendFieldForEdit').customform({
						datasource:data
					});
					
					//������չ���Էǿ���֤
					var validate = window.validater;//comtop.UI.scan()��ǰʹ�����ַ���
					for(var i=0;i<data.length;i++){
						var obj=data[i];
						if(obj.required == true){
							validate.add(obj.id,'required',{m:obj.label+'����Ϊ�ա�'});
					 	}
					}
					
				}
		 	});
			dwr.TOPEngine.setAsync(true);
		}
		 
		
</script>
</body>
</html>