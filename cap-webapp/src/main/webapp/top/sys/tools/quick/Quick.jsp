<%
/**********************************************************************
* 实施辅助工具
* 2012-01-13 陈佳山  新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/AccessTaglibs.jsp" %>
<html>
<head>
    <title>实施辅助工具</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/usermanagement/orgusertag/css/choose.css" type="text/css"/>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/usermanagement/orgusertag/js/choose.js" ></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/QuickOperateAction.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/AuthorityFinderAction.js" ></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/ChooseAction.js" ></script>
   	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/GradeAdminAction.js"></script>
   	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/dwr/interface/PlatFormAction.js"></script>
    
     <style type="text/css">
		.package{
			border: 1px solid #b1afa2;
			height: 120px;
		}
		.bar{
			width: 180px;
			font-family:"微软雅黑";
	  		font-weight:bold;
	        font-size:medium;    		
	  		color:#0099FF;
		}
		.img_bar{
			width: 14px; 
			height: 14px;
			padding-right: 10px;
		}
		.block{
			width: 500px;
			height: 23px; 
			padding-top: 5px; 
			padding-bottom: 5px; 
			padding-left: 10px;
		}
		.row{
			height: 36px; 
			margin-top: 20px; 
			margin-bottom: 5px;
		}
		.input{
			width: 240px;
			padding-left: 35px; 
			height: 29px;
			float: left;
			padding-top: 9px;
		}
		.message{
		   font:bold 1em "宋体",Arial,Times;
		   padding-left: 5px; 
		   padding-top: 15px; 
		   float: left;
		}
		
		.message2{
		   font:bold 1em "宋体",Arial,Times;
		   padding-left: 10px; 
		   padding-top: 5px; 
		   float: left;
		}
		
	</style>
</head>
  <body style="padding-left: 50px; padding-top: 50px; padding-right: 50px;">
	<div id="oneKeyDIV"  style="margin-bottom: 20px;display: none;">
		<div class="bar" title="收起"><img class="img_bar" src="${pageScope.cuiWebRoot}/top/sys/images/close.png">一键搞定</div>
		<div class="package" style="height:170px;">
			<div class="block">
				  <div style="float: left;"><span uiType="Button" label="组织转全拼简拼" on_click="initOrgSpell" id="btn_org"></span></div>
				  <div id="orgShowResult"  style="float: left;padding-left: 10px;"></div>
				  <div style="float: left;padding-left: 10px;"><img id="img_org" src="${pageScope.cuiWebRoot}/top/sys/images/loading.gif" style="width: 18px; height: 18px;display: none;"></div>
			</div>
			<div class="block">
				 <div style="float: left;"><span uiType="Button" label="人员转全拼简拼"" on_click="initEmployeeSpell" id="btn_employee"></span></div>
				  <div id="employeeShowResult"  style="float: left;padding-left: 10px;"></div>
				  <div style="float: left;padding-left: 10px;"><img id="img_employee" src="${pageScope.cuiWebRoot}/top/sys/images/loading.gif" style="width: 18px; height: 18px;display: none;"></div>
			</div>
			<div class="block">
				 <div style="float: left;"><span uiType="Button" label="组织全路径刷新"" on_click="initOrgFullPath" id="btn_orgFullPath"></span></div>
				 <div id="orgFullPathShowResult"  style="float: left;padding-left: 10px;"></div>
				 <div style="float: left;padding-left: 10px;"><img id="img_orgFullPath" src="${pageScope.cuiWebRoot}/top/sys/images/loading.gif" style="width: 18px; height: 18px;display: none;"></div>
			</div>
			<div class="block"  style="display: none;">
				 <div style="float: left;"><span uiType="Button" label="用户密码批量加密"" on_click="encryption" id="btn_encryption"></span></div>
				  <div id="encryptionShowResult"  style="float: left;padding-left: 10px;"></div>
				  <div style="float: left;padding-left: 10px;"><img id="img_encryption" src="${pageScope.cuiWebRoot}/top/sys/images/loading.gif" style="width: 18px; height: 18px;display: none;"></div>
			</div>
			<div class="block"  style="display: none;">
				<div style="float: left;"><span uiType="Button" label="用户密码批量解密"" on_click="decryption" id="btn_decryption"></span></div>
				<div id="decryptionShowResult"  style="float: left;padding-left: 10px;"></div>
				<div style="float: left;padding-left: 10px;"><img id="img_decryption" src="${pageScope.cuiWebRoot}/top/sys/images/loading.gif" style="width: 18px; height: 18px;display: none;"></div>
			</div>
		</div>
	</div>
	<div   id="queryPasswordDIV"  style="margin-bottom: 20px;display: none;">
		<div class="bar" title="展开"><img class="img_bar" src="${pageScope.cuiWebRoot}/top/sys/images/open.png">密码查询</div>
		<div class="package" style="display: none;">
			<div class="row">
				<div class="input">
			       <span uiType="ClickInput" id="account1" name="account1" enterable="true" emptytext="输入账号，按回车查询密码" editable="true" width="230" on_iconclick="fastQueryByAccount"
			        		icon="search" iconwidth="18px"></span>
				</div>
				<div id="message1" class="message"></div>
			</div>
			<div class="row">
			    <div style="float:left;padding-left: 35px;">
				<span uitype="ChooseUser" id="chooseUserId" name="chooseUserId"  width="230px" height="29px"  chooseMode="1" userType="1"  isSearch="true" callback="fastQueryByUserId" delCallback="setMessageStyle">
					</span>
				</div>
				<div id="message2" class="message2" ></div>
			</div>
		</div>
	</div>
	<div id="unlockAccountDIV"  style="margin-bottom: 20px;display: none;">
		<div class="bar" title="展开" id="accountLockUserDIV"><img class="img_bar" src="${pageScope.cuiWebRoot}/top/sys/images/open.png">账号解锁</div>
		<div class="package" style="display: none;height:310px;">
			  <div class="list_header_wrap ie6_list_header_wrap"  style="padding:15px 0 15px 15px;">
				    <span uiType="ClickInput" id="myClickInput" name="clickInput" enterable="true" emptytext="请输入姓名、全拼、简拼" editable="true" width="220" on_iconclick="iconclick"
			        		icon="search" iconwidth="18px"></span>
			        		&nbsp;&nbsp;&nbsp;<font color="red">注：</font>以下显示账号已锁的人员信息
			       <div class="top_float_right" style="padding-right: 15px;">
					    <span uiType="Button" label="解锁" on_click="unlockAllUserAccount" id="unlockAllUserID"></span>
					</div>
			</div>
		 <div id="userGridWrap" style="padding:0 15px 0 15px">
		     <table uitype="Grid" id="userGrid" primarykey="employeeId"   sorttype="1" datasource="initData" pagesize_list="[5,10,20]"  resizewidth="resizeWidth" resizeheight="resizeHeight"  colrender="columnRenderer">
				<th style="width:30px"><input type="checkbox"/></th>
				<th bindName="employeeName" sort="false" style="width:20%" >姓名</th>
				<th bindName="account" sort=""false""  style="width:20%" >账号</th>
				<th bindName="nameFullPath" sort=""false""  style="width:50%" >所属部门路径</th>
				<th bindName="islock" sort=""false"" style="width:10%;"   renderStyle="text-align: center" >账号状态</th>
			</table>
		 </div>
		</div>
	</div>
	
	<div id="updateSpellDIV"   style="margin-bottom: 20px;display: none;">
		<div class="bar" title="展开" ><img class="img_bar" src="${pageScope.cuiWebRoot}/top/sys/images/open.png">人员全拼简拼修改</div>
		<div class="package" style="display: none;height:80px; ">
			
			<div class="row">
			    <div style="float:left;padding-left: 35px;">
				<span uitype="ChooseUser" id="userId02" name="userId02"  width="230px" height="29px"  chooseMode="1" userType="1"  isSearch="true" callback="querySpellByUserId" delCallback="setSpellStyle">
					</span>
				</div>
				    <div id="SpellId" style="float:left;padding-left: 30px;display: none;">
							<div id="ShortSpellId"  style="float:left;padding-left: 30px;">
								<span  class="top_required">*</span> 简拼：<span uiType="input"    id="inputShortSpell" name="shortSpell"  maxlength="50" width="200px;"  validate="[{'type':'required', 'rule':{'m': '简拼不能为空。'}}]"></span>
							</div>
							<div id="FullSpellId"  style="float:left;padding-left: 10px;">
								 <span  class="top_required">*</span>全拼：<span uiType="input"    id="inputFullSpell" name="fullSpell"  maxlength="400" width="200px;"  validate="[{'type':'required', 'rule':{'m': '全拼不能为空。'}}]"></span>
							</div>
							<div id="updateButtonId"  style="float:left;padding-left: 10px;">
								   <span uiType="Button" id="updateButton" label="保存"  on_click="updateUserSpell" ></span>
							</div>
					</div>
			</div>
			
		</div>
	</div>
	
	<div id="resetPlatFormDIV"   style="margin-bottom: 20px;">
		<div class="bar" title="展开" ><img class="img_bar" src="${pageScope.cuiWebRoot}/top/sys/images/open.png">默认工作台重置</div>
		<div class="package" style="display: none;height:180px; ">
		<div style="height: 136px;margin-top: 20px;">
			<div style="float:left;padding-left: 25px;">
				<span uitype="ChooseUser" id="userId03" name="userId03"  width="730px" height="130px"  chooseMode="0" userType="1"  isSearch="true">
					</span>
			</div>
			<div style="float:left;padding-left: 25px;">
				<span uitype="Button" id="resetBtn" label="重置" on_click="resetPlatForm"></span>
			</div>
		</div>
		</div>
	</div>
    
    
   <script language="javascript">
	var imgOrg;
	var imgEmployee;
	var imgOrgFullPath;
	var showMessage="正在更新数据，请耐心等候......";
	var wrongMessage="更新失败，请查看系统日志。";
	var loadingImg="${pageScope.cuiWebRoot}/top/sys/images/loading.gif";
	var successImg="${pageScope.cuiWebRoot}/top/sys/images/succes.png";
	var wrongImg="${pageScope.cuiWebRoot}/top/sys/images/wrong_fork.gif";
	   //根节点ID
	var rootOrgId = "";
	
	window.onload = function(){
		init();
		//扫描 
		comtop.UI.scan();
		 //设置标签的rootId
		   if(rootOrgId){
			 cui('#chooseUserId').setAttr('rootId',rootOrgId);
			 cui('#userId02').setAttr('rootId',rootOrgId);
		   }
		 	var height =(document.documentElement.clientHeight || document.body.clientHeight) -300;
		 	document.body.style.height = height;
	}
	
	//更新人员全拼简拼
	function updateUserSpell(){
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
        	var vo={};
        	var result = false;
        	if(cui("#userId02").getValue()!=null && cui("#userId02").getValue().length>0){
	        	vo.userId=cui("#userId02").getValue()['0']['id'];
	        	vo.shortSpell=cui("#inputShortSpell").getValue();
	        	vo.fullSpell=  cui("#inputFullSpell").getValue();
	        	 dwr.TOPEngine.setAsync(false);
	        	QuickOperateAction.updateUserSpell(vo,function() {
	        	     	cui.message("更新成功","success");
					});
	        	dwr.TOPEngine.setAsync(true);
        	}
        }
	}
	
	function init(){
		imgOrg = document.getElementById('img_org');
		imgEmployee = document.getElementById('img_employee');
		imgOrgFullPath=document.getElementById('img_orgFullPath');
		imgEncryption = document.getElementById('img_encryption');
		imgDecryption = document.getElementById('img_decryption');
		
		//操作权限判断
		AuthorityFinderAction.verifyUserOperation(globalUserId,"quick","oneKey",function(flag){
			     if(flag){ //true拥有权限  显示
			    	  $('#oneKeyDIV').attr('style','display:');
			     }else{
			    	  $('#oneKeyDIV').attr('style','display:none');
			     }
		});
		
		AuthorityFinderAction.verifyUserOperation(globalUserId,"quick","queryPassword",function(flag){
		     if(flag){ //true拥有权限  显示
		    	  $('#queryPasswordDIV').attr('style','display:');
		     }else{
		    	  $('#queryPasswordDIV').attr('style','display:none');
		     }
	     });
		
		AuthorityFinderAction.verifyUserOperation(globalUserId,"quick","unlockAccount",function(flag){
		     if(flag){ //true拥有权限  显示
		    	  $('#unlockAccountDIV').attr('style','display:');
		     }else{
		    	  $('#unlockAccountDIV').attr('style','display:none');
		     }
	     });
		
		AuthorityFinderAction.verifyUserOperation(globalUserId,"quick","updateSpell",function(flag){
		     if(flag){ //true拥有权限  显示
		    	  $('#updateSpellDIV').attr('style','display:');
		     }else{
		    	  $('#updateSpellDIV').attr('style','display:none');
		     }
	     });
		
		 if(globalUserId != 'SuperAdmin'){
			    dwr.TOPEngine.setAsync(false);
			    //查询管辖范围
			    GradeAdminAction.getGradeAdminOrgByUserId(globalUserId, function(orgId){
			    	if(orgId){
						rootOrgId = orgId;
					}else{
						rootOrgId = null;
					}
				});
				dwr.TOPEngine.setAsync(true);
			}
		
		

	}
	
	//组织全拼简拼
	function initOrgSpell(){
		imgOrg.src=loadingImg;
		imgOrg.style.display = 'block';
		cui("#btn_org").disable(true);
	     $('#orgShowResult').html(showMessage);
	 	QuickOperateAction.initOrgSpellBatch(function(data){
			imgOrg.src=successImg;
			var showResult = "成功转换"+data+"条组织数据";
			$('#orgShowResult').html(showResult);
			cui("#btn_org").disable(false);
		}); 
	}
	
	//人员全拼简拼
	function initEmployeeSpell(){
		imgEmployee.src=loadingImg;
		imgEmployee.style.display = 'block';
		cui("#btn_employee").disable(true);
		 $('#employeeShowResult').html(showMessage);
		QuickOperateAction.initEmployeeSpellBatch(function(data){
			imgEmployee.src=successImg;
			var showResult = "成功转换"+data+"条人员数据";
			$('#employeeShowResult').html(showResult);
			cui("#btn_employee").disable(false);
		});
	}
	
	//组织全路径刷新
	function initOrgFullPath(){
		imgOrgFullPath.src=loadingImg;
		imgOrgFullPath.style.display = 'block';
		cui("#btn_orgFullPath").disable(true);
		 $('#orgFullPathShowResult').html(showMessage);
		QuickOperateAction.initOrgFullPath(function(data){
			imgOrgFullPath.src=successImg;
			var showResult = "成功更新"+data+"条组织数据";
			$('#orgFullPathShowResult').html(showResult);
			cui("#btn_orgFullPath").disable(false);
		});
	}
	
	//用户密码加密
	function encryption(){
		imgEncryption.src=loadingImg;
		imgEncryption.style.display = 'block';
		cui("#btn_encryption").disable(true);
		 $('#encryptionShowResult').html(showMessage);
		QuickOperateAction.encryptBatch(function(data){
			  if(data>=0)	{
				imgEncryption.src=successImg;
				var showResult = "成功加密"+data+"条明文的密码数据";
				$('#encryptionShowResult').html(showResult);
				cui("#btn_encryption").disable(false);
			   }else{
				cui("#btn_encryption").disable(false);
				   imgEncryption.src=wrongImg;
					$('#encryptionShowResult').html(wrongMessage);
			   }
		});
	}
	//用户密码解密
	function decryption(){
		imgDecryption.src=loadingImg;
		imgDecryption.style.display = 'block';
		cui("#btn_decryption").disable(true);
		$('#decryptionShowResult').html(showMessage);
		QuickOperateAction.decryptBatch(function(data){
			 if(data>=0)	{
				   imgDecryption.src=successImg;
					var showResult = "成功解密"+data+"条加密的密码数据";
					$('#decryptionShowResult').html(showResult);
					cui("#btn_decryption").disable(false);
				   }else{
					cui("#btn_decryption").disable(false);
					imgEncryption.src=wrongImg;
				    $('#decryptionShowResult').html(wrongMessage);
				   }
			
		});
	}
	
	$(function(){
		initEvent();
	});
	
	//初始化事件
	function initEvent(){
		$('.bar').mouseover(function(){
			$(this).css('background-color','#badcee');
		}).mouseout(function(){
			$(this).css('background-color','white');
		}).click(function(){
			if($(this).attr('title')=='收起'){
				$(this).next().hide('fast');
				$(this).attr('title','展开');
				$(this).children().attr('src','${pageScope.cuiWebRoot}/top/sys/images/open.png');
			}else{
				$(this).next().show('fast');
				$(this).attr('title','收起');
				$(this).children().attr('src','${pageScope.cuiWebRoot}/top/sys/images/close.png');
			}
		});
	
		
	
		$('#operate').click(function(){
			var accountValTow = cui('#account2').getValue(); 
			UserAction.unlockAccount(accountValTow,function(){
				$('#message3').html('已解锁');
				$('#operate').attr('class','');
			});
		});
	}

	//快速通过帐号查询密码
	function fastQueryByAccount() {
		var accountValOne = cui('#account1').getValue();
		  if(accountValOne!=null&&accountValOne!=''){
			  QuickOperateAction.getUserPasswordByAccount(accountValOne,rootOrgId,function(data){
					if(data==null){
						$('#message1').html('该账号不存在或无查询权限');
						$('#message1').attr('style','color:red');
						return;
					}
					$('#message1').attr('style','color:black');
					$('#message1').html('密码：'+data);
				});
		  }else{
			  $('#message1').html('');
		  }
	}
	
	
	//查询账号选择人员后的回调
	function fastQueryByUserId(selected){
		var userId_val = "";
		if(cui("#chooseUserId").getValue()!=null && cui("#chooseUserId").getValue().length>0){
			userId_val = cui("#chooseUserId").getValue()['0']['id'];
			  QuickOperateAction.getUserPasswordByUserId(userId_val,rootOrgId,function(data){
					$('#message2').attr('style','color:black');
					$('#message2').html('密码：'+data);
				});
		}
		
	}
	
	//查询账号删除人员的回调
	function setMessageStyle(){
		  $('#message2').html('');
	}
	
	
	//更新人员全拼简拼-选择人员后的回调
	function querySpellByUserId(selected){
		var userId_val = "";
		if(cui("#userId02").getValue()!=null && cui("#userId02").getValue().length>0){
			userId_val = cui("#userId02").getValue()['0']['id'];
			  QuickOperateAction.querySpellByUserId(userId_val,function(data){
					  if(data!=null){
						  $('#SpellId').attr('style','display:');
						  cui("#inputShortSpell").setValue(data.shortSpell);
						  cui("#inputFullSpell").setValue(data.fullSpell);
					  }
				});
		}
		
	}
	
	
	
	//更新人员全拼简拼-删除人员的回调
	function setSpellStyle(){
		$('#SpellId').attr('style','display:none');
	}
	
	
	//渲染列表数据
	function initData(grid,query){
		
	    //设置查询条件,keyword需要重新获取
	    keyword = cui("#myClickInput").getValue().replace(new RegExp("/", "gm"), "//");
		keyword = keyword.replace(new RegExp("%", "gm"), "/%");
		keyword = keyword.replace(new RegExp("_","gm"), "/_");
		keyword = keyword.replace(new RegExp("'","gm"), "''");
		var queryObj = {pageNo:query.pageNo,pageSize:query.pageSize,fastQueryValue:keyword,orgId:rootOrgId};
	    dwr.TOPEngine.setAsync(false);
	    QuickOperateAction.queryAccountLockUserList(queryObj,function(data){
	    	var totalSize = data.count;
			var dataList = data.list;
			//加载数据源
			grid.setDatasource(dataList,totalSize);
    	});
	    dwr.TOPEngine.setAsync(true);
		
  	}
	
	//Grid组件自适应宽度回调函数，返回高度计算结果即可
	function resizeWidth() {
		return (document.documentElement.clientWidth || document.body.clientWidth) -150;
	}

	//Grid组件自适应高度回调函数，返回宽度计算结果即可
	function resizeHeight() {
		return 245;
	}
	
	
	//列渲染
	function columnRenderer(data,field) {
		
		if(field == 'islock'){
			return "<img src='${pageScope.cuiWebRoot}/top/sys/images/check_in.gif' style='cursor:pointer' onclick='unLockAccount(\""+data["employeeId"]+"\");' title='点击解锁'/>";
		}
	
	}
	

	 //搜索框图片点击事件
	 function iconclick() {
		keyword = cui("#myClickInput").getValue().replace(new RegExp("/", "gm"), "//");
		keyword = keyword.replace(new RegExp("%", "gm"), "/%");
		keyword = keyword.replace(new RegExp("_","gm"), "/_");
		keyword = keyword.replace(new RegExp("'","gm"), "''");
       cui("#userGrid").setQuery({pageNo:1});
       //刷新列表
		cui("#userGrid").loadData();
    }
	 
	 
		//账号解锁
		function unLockAccount(employeeId){
			var selectIds=employeeId.split(";");
			QuickOperateAction.unlockAllUserAccount(selectIds,function(data){
	    	    cui("#userGrid").loadData();
				cui.message("解锁账号成功","success");
			});
		}
		
		
	 //解锁所有用户
	 function unlockAllUserAccount(){
			var selectIds = cui("#userGrid").getSelectedPrimaryKey();
			if(selectIds == null || selectIds.length == 0){
				cui.alert("请选择要解锁账号的人员。");
				return;
			}
	      QuickOperateAction.unlockAllUserAccount(selectIds,function(data){
	    	    cui("#userGrid").loadData();
				cui.message("解锁账号成功","success");
			});
	 }
	
	 
	 //重置工作台“重置”按钮点击函数
	 function resetPlatForm(){
		 var value = cui("#userId03").getValue();
		 var userIds = [];
		 //人员选择标签中选了人员
		 if(value.length != 0){
			 for(var i = 0;i<value.length;i++){
				 userIds.push(value[i].id);
			 }
			 dwr.TOPEngine.setAsync(false);
			//获取选择人员的默认模板
	     	 QuickOperateAction.getDefaultPlatForm(userIds,function(data) {
	     		//选择的人员中设定了默认模板
	     	    if(data){
	     	    	var resetError = [];
	     	    	var templateDelete = [];
	     	    	var platformIds = [];
	     	     	for(var i = 0;i<data.length;i++){
	     	     		var platformId = data[i].PLATFORMID?data[i].PLATFORMID:data[i].platformId;
	     	     		platformIds.push(platformId);
	     	     		//通过工作台ID重置工作台
		     	     	PlatFormAction.resetPlatform(platformId, function(result){
		     	     		switch (result){
		     	     			//重置模板成功
		                       case '1':
		                          break;
		                       //重置模板失败
		                       case '0':
		                    	  resetError.push(data[i].NAME?data[i].NAME:data[i].name);
		                          break;
		                       //模板已删除，不能重置
		                       case '-1':
		                    	  templateDelete.push(data[i].NAME?data[i].NAME:data[i].name);
		                   }
		         	    });
		     	     }
		     	     if(resetError.length == 0 && templateDelete.length == 0){
		     	    	cui.message("重置默认模板成功","success");
			     	}
		     	     else{//获得失败名单后，还要组合成失败信息
		     	    	 var message = '以下人员重置失败！'
		     	    	 if(resetError.length != 0){
		     	    		 message = message +'<br>' + '重置模板失败人员：'
		     	    		 for(var i = 0;i<resetError.length;i++){
		     	    			 message = message + resetError[i] + ','
		     	    		 }
		     	    		 message = message.substring(0,message.length-1);
		     	    	 }
		     	    	if(templateDelete.length != 0){
		     	    		message = message +'<br>' + '默认模板已删除，不能重置人员：'
		     	    			for(var i = 0;i<templateDelete.length;i++){
			     	    			 message = message + templateDelete[i] + ','
			     	    		 }
		     	    		message = message.substring(0,message.length-1);
		     	    	}
		     	    	cui.error(message);
		     	     }
	     	     }
	     	     
	     	    else{
	     	    	cui.message("重置默认模板成功","success");
	     	    }
			});
	     	 dwr.TOPEngine.setAsync(true);
		 }
		 //人员标签中没选择人员
		 else{
			 cui.error('请选择工作台重置人员');
		 }
	 }
	
   </script>

</html>
