<%@page import="com.comtop.top.sys.usermanagement.user.util.UomCommonUtil"%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<%		
	//是否隐藏系统人员组织功能按钮 true 隐藏 false 不隐藏
    boolean isHideSystemBtnInUserOrg = UomCommonUtil.getHideSystemBtnInUserOrgCfg();
%>
<html>
<head>
<title>用户设置</title>
<style type="text/css">
    .user-header{
        width:120px;
        height:120px;
    }
    
    table td{
        color:#666;
        font-size:14px;
    }
    
    .app-category {
	  margin-bottom: 10px;
	  font-size: 14px;
	  font-weight: bold;
	  border-left: 3px solid #6AA725;
	  height: 20px;
	}
	.app-category .place-left{
	   padding-left:5px;
	}
	.app-category hr {
	  height: 0px;
	  border: 0px;
	  border-bottom: 1px solid #ddd;
	}
	#personal-set{
	    background:#fff;
	    padding:10px;
	    border:1px solid #ccc;
	}
	.table-wrap{
	   margin-left:50px;
	}
	#personal-set .table-wrap table{
	   width:100%;
	   height:120px;
	}
	#personal-set .table-wrap table td{
       text-align: left;
       vertical-align:top;
    }
    .tip{
        color:red;
    }
    .label {
        display: inline-block;
        padding: 2px 4px;
        font-size: 10.152px;
        font-weight: bold;
        line-height: 14px;
        color: #fff;
        vertical-align: baseline;
        white-space: nowrap;
        text-shadow: 0 -1px 0 rgba(0,0,0,0.25);
        background-color: #3a87ad;
        border-radius: 3px;
        cursor: pointer;
        margin:2px 5px;
    }
</style>
</head>
<body>
<div id="personal-set">
	<div class="app-category clearfix">
		<div class="place-left">个人信息</div><hr>
	</div>
	<div  class="table-wrap">
    	<table>
    	    <tr>
    	        <td width="120px">
    	        	<img class="user-header" src="${pageScope.cuiWebRoot}/top/workbench/personal/img/default_head.jpg"/><br>
    	        	<span uitype="Button"  label="更换头像" on_click="changeHead" style="display:block;margin:10px 0 0 22px;"></span>
    	        </td>
    	        <td>
    	            <table width="100%" height="100px" style="padding-left:20px;table-layout: fixed;">
    	            <colgroup>
				        <col width=90 />
				        <col width= />
				        <col width=90 />
				        <col width=/>
				    </colgroup>
    	                <tr>
    						<td align="right" >姓 &nbsp; 名：</td>
    						<td align="left" >${userInfo.employeeName}</td>
    						<td align="right" >部 &nbsp; 门：</td>
    						<td align="left">${userInfo.nameFullPath}</td>
    					</tr>
    					<tr>
    					    <td align="right">邮 &nbsp; 箱：</td>
                            <td align="left">${userInfo.email}</td>
    						<td align="right">电 &nbsp; 话：</td>
    						<td align="left">${userInfo.mobilePhone}</td>
    					</tr>
    					<tr>
    						<td align="right">岗 &nbsp; 位：</td>
                            <td align="left" id="user-post" colspan="3"></td>
    					</tr>
    	            </table>
    	        </td>
    	    </tr>
    	</table>
	</div>
	<br>
	<div class="app-category clearfix">
		<div class="place-left">个性化设置</div><hr>
	</div>
	<div  class="table-wrap">
		<table>
			<tr>
				<td width="85px" align="center">登录后首页：</td>
				<td>
					<div id="platformId"></div>
				</td>
			</tr>
			<tr>
				<td  align="center">消息接收端：</td>
				<td>
					<div id="messageType"></div>
				</td>
			</tr>
			<tr>	
				<td align="left" colspan="2">
					<span uitype="Button" label="保存" on_click="saveMessageType"></span>
				</td>
			</tr>
		</table>
	</div>
	<br>
	<div class="app-category clearfix">
		<div class="place-left">委托代办</div><hr>
	</div>
	
	<div id="delegateInsertId" style="display:none" class="table-wrap">
		 <table>
			<tr>
				<td width="70px" align="center">受委托人：</td>
				<td>
					<span uitype="ChooseUser" validate="受委托人不能为空" id="entrustUser" chooseMode="1" width="190px" height="30px"  userType="1"  isSearch="true" ></span>
				</td>
			</tr>
			<tr>
				<td  align="center">委托时段：</td>
				<td><span uitype="Calender" isrange="true"  validate="[{'type':'custom','rule':{'against':'checkEntrustStartDate','m':'委托开始时段不能为空。'}},{ 'type':'custom','rule':{ 'against':'checkEntrustEndDate', 'm':'委托结束时段不能为空。'}}]" 
		           id="entrustDate" panel="2" width="225px"></span></td>
			</tr>
			<tr>	
				<td align="left" colspan="2">
					<span uitype="Button" label="保存" on_click="saveButton"></span> &nbsp;&nbsp;
					<span uitype="Button" label="重置" on_click="resetButton"></span> &nbsp;&nbsp;
					<span uitype="Button" label="委托记录" on_click="searchButton"></span>
				</td>
			</tr>
		</table>	
	</div>
	<div id="delegateUpdateId" style="margin-left:50px;line-height:30px;font-size:14px;">
    </div>
    <% if(!isHideSystemBtn){ %>
		<% if(!isHideSystemBtnInUserOrg){ %>
    <div class="app-category clearfix">
        <div class="place-left">修改密码</div><hr>
    </div>
    <div class="table-wrap">
        <table>
            <tr>
                <td width="85px" align="center">输入旧密码：</td>
                <td>
                    <span uitype="Input" id="oldPassword" type="password" 
      		 validate="[{'type':'required','rule':{'m':'密码不能为空！'}},{ 'type':'custom','rule':{ 'against':'validateOldPassword', 'm':'密码错误！'}}]"></span>
                </td>
            </tr>
            <tr>
                <td  align="center">输入新密码：</td>
                <td>
                    <span uitype="Input" id="newPassword" type="password" on_blur="validateEqual"
      		 validate="[{'type':'required','rule':{'m':'新密码不能为空！'}},{ 'type':'custom','rule':{ 'against':'validateEquals', 'm':'新旧密码不能相同，请重新输入新密码！'}}]"></span>
                    <span style="margin-left:15px;"></span><br/><span class="tip"></span>
                </td>
            </tr>
            <tr>    
                <td  align="center">确认新密码：</td>
                <td>
                    <span uitype="Input" id="newPasswordConfirm" type="password" maxlength="50" 
      		 validate="[{'type':'required','rule':{'m':'请输入确认密码！'}},{ 'type':'custom','rule':{ 'against':'validatePasswordConfirm', 'm':'两次输入的新密码不一致，请重新输入！'}}]"></span>
                </td>
            </tr>
            <tr>    
                <td align="left" colspan="2">
                    <span uitype="Button" label="修改密码" id="btn-reset-password"></span>
                </td>
            </tr>
        </table>
    </div>
	<% } %>
	<% } %>
	
	<div id="headDialog">
	</div>	
	
	<div id="delegateDialog">
	</div>
</div>

<script>
var pattern;
	require(['cui','workbench/dwr/interface/UserPersonalizationAction',
	          'workbench/dwr/interface/WorkbenchUserDelegateAction','uochoose','loginAction'], function() {
      comtop.UI.scan();
		UserPersonalizationAction.getUserPersonalization(function(data) {
			//获取消息接收端
			var messageType = data.personalInfo.messageType;
			var messageArray;
			if(messageType!=null){
				messageArray = messageType.split(",");
			}else{
				messageArray = new Array();
			}
			messageArray.push(0);
			cui('#messageType').checkboxGroup({
				checkbox_list: initMessageTypeData,
				value: messageArray,
				border:true
			});
			
			//获取用户头像信息
			if (data.personalInfo.isHasHead == 'Y') {
				$(".user-header").attr("src","${pageScope.cuiWebRoot}/top/workbench/workbenchServlet.ac?actionType=displayHead");
			}
			var postInfo = data.personalInfo.postInfo;
			if(postInfo&&postInfo.length>0){
                 var postName = [];
                 for(var i=0;i<postInfo.length;i++){
                	 if(postInfo[i].postName){
	                     postName.push($('<label class="label" >'+postInfo[i].postName+'</label>').data('post-info',postInfo[i]));
                	 }
                 }
                 $('#user-post').html(postName);
             }
			//获取登录后首页 下拉框
			var initPlatformData = data.platFormList;
       		cui('#platformId').pullDown({
       			mode: 'Single',
       			value_field:'platformId',
       			label_field:'platformName',
       			select:'0',
       			datasource :initPlatformData
       		});
       		//显示密码规则提示
       		showPasswordConfig(data.passwordConfig||[]);
		});
		
		//获取用户代理记录
		WorkbenchUserDelegateAction.queryUserValidDateDelegateInfo(function(data) {
			if(data.length > 0){
				for(var i=0;i<data.length;i++){
					var consignId = data[i].consignId;
					var startTime = data[i].startTime;
					var strStartTime =  startTime.getFullYear()+"-"+(startTime.getMonth() + 1)+"-"+startTime.getDate();
					var endTime = data[i].endTime;
					var strEndTime =  endTime.getFullYear()+"-"+(endTime.getMonth() + 1)+"-"+endTime.getDate();
					var nowTime = new Date();
					var str = "已委托"+data[i].delegatedUserName+"于"+strStartTime+"到"+strEndTime+"期间代办相关业务,";
					if(startTime<nowTime && nowTime<endTime){
						str = str + "当前已经开始。<br>"+"	<span uitype='Button' label='终止委托' mark='"+consignId+"' on_click='stopButton' ></span> <br>";
					}else if(nowTime<startTime){
						str = str + "当前尚未开始。<br>"+" <span uitype='Button' label='取消委托' mark='"+consignId+"' on_click='cancleButton' ></span> <br>";
					}
					$("#delegateUpdateId").append(str);
					comtop.UI.scan();
				}
			}else{
				$("#delegateInsertId").css("display","block");
				$("#delegateUpdateId").css("display","none");
			}
		});	
		
	});
	/**
	 *获取用户代理记录 
	 */
	function showPasswordConfig(passwordConfig){
	    var configMessage = [],$newPassword = $('#newPassword');
	    if(passwordConfig&&passwordConfig.length>0){
// 	    for(var i=0;i<passwordConfig.length;i++){
	        configMessage.push(passwordConfig[0].message);
		    pattern = new RegExp(passwordConfig[0].rule);
	    }
	    $newPassword.data('passwordConfig',passwordConfig);
	    $newPassword.next().html(configMessage.join('；'));
	    var message = configMessage.join('；') || "不符合密码规则！";
		cui().validate().add('newPassword', 'custom', {'against':'validateNewPassword', 'm':message});
	}
	//消息接收端类型 数据源
	function initMessageTypeData (obj) {
		var data = [{
		text: '消息中心(站内信)',
		readonly : "readonly", //初始化只读
		value: '0'
		}
		/*  目前没有实现以下两个接收端的功能，上面获取也是写死的，暂时屏蔽  2016-0517  by cjs
		,{
		text: '电子邮件',
		value: '1'
		},{
		text: '手机短信',
		value: '2'
		}*/
		];
		obj.setDatasource(data);
	}
	
	//更换头像
	function changeHead(){
		cui('#headDialog').dialog({
			modal: true,
			width:650,
			height:450,
			title:"更换头像",
			src: "${pageScope.cuiWebRoot}/top/workbench/personal/UploadPersonal.jsp"
			}).show();
	}
	
	//保存消息接收端类型
	function saveMessageType(){
		var platformId = cui("#platformId").getValue();
		var messageType = cui("#messageType").getValueString(",");
		UserPersonalizationAction.updatePersonalization(messageType,platformId,function(data) {
			cui.alert("保存成功!");
		});
	}
	
	
	//新增委托
	function saveButton(){
		window.validater.disValid('entrustUser', false);
		window.validater.disValid('entrustDate', false);
		var valids = window.validater.validElement('AREA', '#delegateInsertId');
	   
		if(valids[0].length == 0){//验证通过		
			var regEx = new RegExp("\\-","gi"); 
			var startTime = cui("#entrustDate").getValue()[0].replace(regEx,"/"); 
			var endTime = cui("#entrustDate").getValue()[1].replace(regEx,"/");
			
			var userDelegateDTO = new Object();
			userDelegateDTO.userId = globalUserId;
			userDelegateDTO.delegatedUserId = cui("#entrustUser").getValue()[0].id;
			userDelegateDTO.startTime =	Date.parse(startTime+" 00:00:01");
			userDelegateDTO.endTime = Date.parse(endTime+" 23:59:59");
			userDelegateDTO.delegatedUserName = cui("#entrustUser").getValue()[0].name;
			userDelegateDTO.state="1";
			WorkbenchUserDelegateAction.saveUserDelegate(userDelegateDTO,function(data) {
				if(data){
					window.location.reload();
				}
			});
		}
	}
	
	//重置
	function resetButton(){
		window.validater.disValid('entrustUser', true);
		window.validater.disValid('entrustDate', true);
		cui("#entrustUser").setValue("");
		cui("#entrustDate").setValue("");
	}
	
	//查询委托记录
	function searchButton(){
		cui('#delegateDialog').dialog({
			modal: true,
			title: '委托记录',
			width:680,
			height:450,
			src:"${pageScope.cuiWebRoot}/top/workbench/personal/UserDelegateList.jsp"
			}).show();
	}
	
	//终止委托
	function stopButton(event, self, mark){
		WorkbenchUserDelegateAction.stopUserDelegate(mark,function(data) {
			window.location.reload();
		});
		
	}
	
	//取消委托
	function cancleButton(event, self, mark){
		WorkbenchUserDelegateAction.deleteUserDelegate(mark,function(data) {
			window.location.reload();
		});
	}
	
	//验证旧密码是否正确
	function validateOldPassword(){
		var oldPassword = cui("#oldPassword").getValue();
		var value;
		dwr.TOPEngine.setAsync(false);
		LoginAction.isPasswordCorrect(oldPassword,function(isCorrect){
			value = isCorrect;
		});
		dwr.TOPEngine.setAsync(true);
		return value;
	}

	
	//验证新密码是否符合密码规则
	function validateNewPassword(){
		if(!pattern){return true}
		var newPassword = cui("#newPassword").getValue();
		if(!pattern.test(newPassword)){
			return false;
		}
		return true;
	}
	//验证新旧密码是否相等
	function validateEquals(){
		var newPassword = cui("#newPassword").getValue();
		var oldPassword = cui("#oldPassword").getValue();
		if(newPassword == oldPassword){
			return false;
		}
		return true;
	}
	
	//失去焦点的时候验证两个密码是否相等
	function validateEqual(){
		var newPasswordConfirm = cui("#newPasswordConfirm").getValue();
		if(newPasswordConfirm){
			 window.validater.validOneElement('newPasswordConfirm');
		}
	}
	
	//确认新密码校验
	function validatePasswordConfirm(){
		var newPassword = cui("#newPassword").getValue();
		var newPasswordConfirm = cui("#newPasswordConfirm").getValue();
		if(newPasswordConfirm != newPassword){
			return false;
		}
		return true;
	}
	
	require(['loginAction'],function(){
        $('#btn-reset-password').click(function(){
        	var validateMap = window.validater.validElement('CUSTOM',['oldPassword','newPassword','newPasswordConfirm']);
    		var inValid = validateMap[0];
    		var valid = validateMap[1];
    		if(inValid.length > 0){
    			return;
    		}
    		var newPassword = cui("#newPassword").getValue();
    		var oldPassword = cui("#oldPassword").getValue();
    		LoginAction.resetPassword(oldPassword,newPassword,function(data){
    			if(data=="oldPassWordNotCorrect"){
    				cui.alert("密码不正确。");
    			}else if(data=="FourAEncryptError"){
    				cui.alert("4A算法加密出错。");
    			}else if(data==='passWordNotMatchRule'){
    				cui.alert("新密码不符合规则。");
    			}else if(data==='passWordEquals'){
    				cui.alert("新密码与老密码一样，请修改。");
    			}else{
    				exitOut();
    			}
        	});	
        });	    
	});
	
	//退出系统
    function exitOut() {
    	 cui.success('密码修改成功，点击“确定”重新登录。',function(){
	       	 LoginAction.exit({callback:logoutCallback,errorHandler:logoutCallback});
    	 });
    }
    
	$('#user-post').on('click','.label',function(){
	   var postInfo = $(this).data('post-info');
	   cui.dialog({
	       src:webPath + '/top/workbench/personal/RoleListForPost.jsp?postId='+postInfo.postId,
            refresh:false,
            modal: true,
            title: '角色列表',
            width:600,
            height:400
	   }).show();
	});
	
	/*
	* 委托时段验证，使用日历组件属性设置成isrange=true 范围会有一个默认值,["", ""]
	*/
	function checkEntrustStartDate(data){
		     var startTime = cui("#entrustDate").getValue()[0]; 
		     if(startTime==''){
		    	 return false;
		     }
		     return true;
	}
	
	/*
	* 委托时段验证，使用日历组件属性设置成isrange=true 范围会有一个默认值,["", ""]
	*/
	function checkEntrustEndDate(data){
		     var endTime = cui("#entrustDate").getValue()[1];
		     if(endTime==''){
		    	 return false;
		     }
		     return true;
	}
      
</script>
</body>
</html>