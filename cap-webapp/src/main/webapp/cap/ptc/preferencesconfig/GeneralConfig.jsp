	
<%
  /**********************************************************************
   * CAP首选项常规配置
   *
   * 2016-5-25 许畅 新建
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>

<!doctype html>
<html ng-app="GeneralConfig">
<head>
<title>常规配置</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:link href="/cap/bm/common/base/css/base.css"></top:link>
	<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css" />
	
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/bm/common/base/js/angular.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
	<top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src='/cap/dwr/interface/PreferenceConfigAction.js'></top:script>
</head>
<style>
.top_header_wrap {
	padding-right: 5px;
}
.thw_title{
    margin-left: 0px;
    font-weight: bold;
    font-size: 12pt;
    float: left;
}
fieldset{
    border: 1px solid rgb(204, 204, 204);
}
legend{
   margin-left: 10px;
   font-family: 微软雅黑;
   color: #2b71d9;
   font-size: 14px;
}
.left{
  float: left;
  width: 50%;
  margin-top: 2px;
}
#saveBtn{
  margin-left:5px;
}
.toolbar{
  padding-top: 5px;
  text-align: right;
}
.desc{
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  display: block;
}
fieldset:last-child{
	margin-bottom:5px;
}
.form_table td {
	padding-left: 0;
}
</style>
<body ng-controller="generalConfigCtrl" data-ng-init="ready()">
	<div class="top_header_wrap">
		<div class="thw_title">常规配置</div>
		<!-- 保存全部 -->
		<div class="toolbar">
		   <span id="saveAll" uitype="button" ng-click="saveAll()" label="保存全部"></span> 
		   <span id="reset" uitype="button" ng-click="resetAll()" label="还原到默认"></span> 
		</div>
	</div>
	<div>
		<!-- 工程环境配置 -->
		<fieldset>
		    <legend>***工程环境配置***</legend>
			<div id="codeConfigDiv"  class="top_content_wrap cui_ext_textmode" >
				<table class="form_table" style="table-layout:fixed;">
					<colgroup>
						<col width="15%" />
						<col width="40%" />
						<col width="45%" />
					</colgroup>
					<tr>
						<td class="td_label"><span class="top_required">*</span>项目工程路径：</td>
						<td style="white-space:nowrap;">
							<span cui_clickinput id="filePath" ng-model="model.projectFilePath" on_iconclick="selectPath" editable="true" width="100%" validate="filePathRule"></span>
						</td>
						<td><a class="desc" title="主要用于目标系统的工程IO路径">说明:主要用于目标系统的工程IO路径</a></td>
					</tr>
					
					<tr>
						<td class="td_label"><span class="top_required">*</span>java代码路径：</td>
						<td style="white-space:nowrap;">
							<span cui_clickinput id="javaMainFilePath" ng-model="model.javaMainFilePath" editable="true" on_iconclick="selectJavaCodePath" width="100%"  validate="javaMainFilePathRule"></span>
						</td>
						<td><a class="desc" title="配置生成的java代码路径,相对于项目目录的相对位置">说明:配置生成的java代码路径,相对于项目目录的相对位置</a></td>
					</tr>
					
					<tr>
						<td class="td_label"><span class="top_required">*</span>配置文件路径：</td>
						<td style="white-space:nowrap;">
							<span cui_clickinput id="resourcesFilePath" ng-model="model.resourcesFilePath" editable="true" on_iconclick="selectResourcesFilePath" width="100%"  validate="resourcesFilePathRule"></span>
						</td>
						<td><a class="desc" title="配置生成的配置文件路径,相对于项目目录的相对位置">说明:配置生成的配置文件路径,相对于项目目录的相对位置</a></td>
					</tr>
					
					<tr>
						<td class="td_label"><span class="top_required">*</span>界面文件路径：</td>
						<td style="white-space:nowrap;">
							<span cui_clickinput id="webappFilePath" ng-model="model.webappFilePath" editable="true" on_iconclick="selectWebappFilePath" width="100%"  validate="webappFilePathRule"></span>
						</td>
						<td><a class="desc" title="配置生成的前端页面文件路径,相对于项目目录的相对位置">说明:配置生成的前端页面文件路径,相对于项目目录的相对位置</a></td>
					</tr>
					
					<tr>
						<td class="td_label">导出界面原型图片路径：</td>
						<td style="white-space:nowrap;">
							<span cui_clickinput id="prototypeImageFilePath" ng-model="model.prototypeImagePath" editable="true" on_iconclick="selectWebappFilePath" width="100%"  validate="prototypeImageFilePathRule"></span>
						</td>
						<td><a class="desc" title="导出界面原型图片路径,相对于项目目录的相对位置">说明:导出界面原型图片路径,相对于项目目录的相对位置</a></td>
					</tr>
					
					<tr>
						<td class="td_label">测试用例代码路径：</td>
						<td style="white-space:nowrap;">
							<span cui_clickinput id="testDemoCodePath" ng-model="model.testDemoCodePath" editable="true" on_iconclick="selectTestDemoCodePath" width="100%"  validate="testDemoCodePathRule"></span>
						</td>
						<td><a class="desc" title="配置生成的测试页面文件路径,相对于项目目录的相对位置">说明:配置生成的测试页面文件路径,相对于项目目录的相对位置</a></td>
					</tr>
					
					<tr>
						<td class="td_label">自动编译及文件变化监听路径：</td>
						<td style="white-space:nowrap;">
							<span cui_input id="pageCutPrefix" ng-model="model.compileThermalPath" width="100%" ng-show="true" emptytext="没有特殊需求，保持为空，无需填写" validate=""></span>
						</td>
						<td><a class="desc" title="CAP生成的代码的编译路径以及热加载文件变化监听路径，配置绝对路径（支持配置多个，以分号隔开；为空时，系统默认取/WEB-INF/classes目录）">说明:CAP生成的代码的编译路径以及热加载文件变化监听路径，配置绝对路径（支持配置多个，以分号隔开；为空时，系统默认取/WEB-INF/classes目录）</a></td>
					</tr>
								
				</table>
			</div>
		</fieldset>
		
		<!-- 代码生成及框架配置  -->
		<fieldset>
		    <legend>***代码生成及框架配置***</legend>
			<div id="CodeFrameWorkConfig"  class="top_content_wrap cui_ext_textmode" >
				<table class="form_table" style="table-layout:fixed;">
					<colgroup>
						<col width="15%" />
						<col width="40%" />
						<col width="45%" />
					</colgroup>
					<tr>
					    <td class="td_label"><span class="top_required">*</span>代码框架：</td>
						<td style="white-space:nowrap;">
							<table class="form_table">
								<tr>
									<td width="70%"><input type="radio" name="generateframework" ng-model="model.generateframework" value="jodd"/>JODD(MVC)+jodd(Spring)+Mybatis</td>
									<td width="30%" align="right">url后缀：<span  cui_input id="joddPageUrlSuffix" width="60px" ng-model="model.joddPageUrlSuffix" validate="pageUrlSuffixRule" ></span></td>
								</tr>
								<tr>
									<td width="70%"><input type="radio" name="generateframework" ng-model="model.generateframework" value="spring"/>Spring(MVC)+Spring+Mybatis</td>
									<td width="30%" align="right">url后缀：<span  cui_input id="springPageUrlSuffix"  width="60px" ng-model="model.springPageUrlSuffix" validate="pageUrlSuffixRule" ></span>
								</tr>
							</table>
						</td>
						<td>
							<table class="form_table">
								<tr>
									<td width="100%"><a class="desc" style="padding-top:2px;" title="框架采用JODD或者spring MVC,数据持久层采用mybatis">说明:框架采用JODD或者spring MVC,数据持久层采用mybatis</a></td>
								</tr>
								<tr>
									<td width="100%"><a class="desc" style="padding-top:5px;" title="Spring框架url后缀不能使用.ac、.do，修改后请在web.xml中进行同步配置。url中字母需小写。">说明:Spring框架url后缀不能使用.ac、.do，修改后请在web.xml中进行同步配置。url中字母需小写。</a></td>
								</tr>
							</table>
						
						</td>
					</tr>
					<tr>
						<td class="td_label"><span class="top_required">*</span>页面路径生成规则：</td>
						<td style="white-space:nowrap;">
							<span cui_input id="pageCutPrefix" ng-model="model.pagePrefixConfig" width="100%" ng-show="true" validate="pageCutPrefixRule"></span>
						</td>
						<td><a class="desc" title="配置生成的页面访问url">说明:配置生成的页面访问url</a></td>
					</tr>
					<tr>
					    <td class="td_label"><span class="top_required">*</span>执行soa远端服务：</td>
						<td style="white-space:nowrap; vertical-align: middle;">
						    <div>
						       <div class="left" >
						          <input type="checkbox" ng-model="model.callSoaService" ng-checked="model.callSoaService" />
						       </div>
						    </div>
						</td>
						<td><a class="desc" title="生成代码时默认是不调用soa远端服务,可以配置启用和禁用是否调用soa远端服务">说明:生成代码时默认不调用soa远端服务,可以通过此开关配置启用和禁用是否调用soa远端服务</a></td>
					</tr>
					<tr>
					    <td class="td_label"><span class="top_required">*</span>元数据一致性校验：</td>
						<td style="white-space:nowrap; vertical-align: middle;">
						    <div>
						       <div class="left" >
						          <input type="checkbox" ng-model="model.isConsistency" ng-checked="model.isConsistency" />
						       </div>
						    </div>
						</td>
						<td><a class="desc" title="说明:该校验开关是指操作时的一致性校验开关(包括保存,修改,删除等操作),默认为不执行一致性校验">说明:该校验开关是指操作时的一致性校验开关(包括保存,修改,删除等操作),默认为不执行一致性校验</a></td>
					</tr>
				</table>
		    </div>
		</fieldset>
		
		<!-- 实体代码配置  -->
		<fieldset>
		    <legend>***实体代码配置***</legend>
			<div id="entityCodeConfig"  class="top_content_wrap cui_ext_textmode" >
				<table class="form_table" style="table-layout:fixed;">
					<colgroup>
						<col width="15%" />
						<col width="40%" />
						<col width="45%" />
					</colgroup>
					<tr>
						<td class="cap-td" style="text-align: right;width:100px">
			        		<font color="red">*</font>父实体：
				        </td>
						<td class="cap-td" style="text-align: left;">
				        	<span cui_clickinput id="parentEntityId" ng-model="model.defaultParentEntityId" ng-click="selectParentEntity('parentEntityId')" width="100%" validate="parentEntityIdRule"></span>
				        </td>
				        <td><a class="desc" title="实体可以通过此配置项修改继承的父实体元数据">说明:实体可以通过此配置项修改继承的父实体元数据</a></td>
					</tr>
					<tr>
						<td class="cap-td" style="text-align: right;width:100px">
			        		<font color="red">*</font>父流程实体：
				        </td>
						<td class="cap-td" style="text-align: left;">
				        	<span cui_clickinput id="workflowParentEntityId" ng-model="model.defaultWorkflowParentEntityId" ng-click="selectParentEntity('workflowParentEntityId')" width="100%" validate="workflowParentEntityIdRule"></span>
				        </td>
				        <td><a class="desc" title="实体可以通过此配置项修改继承的工作流父实体元数据">说明:实体可以通过此配置项修改继承的工作流父实体元数据</a></td>
					</tr>
					<tr>
						<td class="cap-td" style="text-align: right;width:100px">
			        		<font color="red">*</font>父流程实体匹配规则：
				        </td>
						<td class="cap-td" style="text-align: left;">
				        	<span cui_input id="workflowParentEntityMatchRule" ng-model="model.defaultWorkflowMatchRule" width="100%" validate="workflowParentEntityMatchRuler"></span>
				        </td>
				        <td><a class="desc" title="实体的父流程实体匹配规则(表字段名,用英文逗号隔开)">说明:实体的父流程实体匹配规则<font style="color:red;">(表字段名,用英文逗号隔开)</font></a></td>
					</tr>
				</table>
		    </div>
		</fieldset>
		
		<!-- 实体导入数据源配置 -->
		<fieldset>
		    <legend>***实体导入数据源配置***</legend>
			<div id="importEntitySourceDiv"  class="top_content_wrap cui_ext_textmode" >
				<table class="form_table" style="table-layout:fixed;">
					<colgroup>
						<col width="15%" />
						<col width="40%" />
						<col width="45%" />
					</colgroup>
					<!-- <tr>
						<td class="td_label"><span class="top_required">*</span>数据库类型：</td>
						<td style="white-space:nowrap;">
							<span cui_pulldown id="pageCutPrefix" ng-model="model.driverClassName" datasource="jdbcDriver" editable="false" width="100%" ng-show="true" validate=""></span>
						</td>
						<td><a class="desc" title="实体导入的数据库的driver">说明:实体导入的数据库的driver</a></td>
					</tr> -->
					
					<tr>
						<td class="td_label">数据库连接：</td>
						<td style="white-space:nowrap;">
							<span cui_input id="pageCutPrefix" ng-model="model.jdbcURL" width="100%" ng-show="true" validate=""></span>
						</td>
						<td><a class="desc" title="实体导入的数据库的URL(默认无需配置自动取服务器启动时连接)">说明:实体导入的数据库的URL(默认无需配置自动取服务器启动时连接)</a></td>
					</tr>
					
					<tr>
						<td class="td_label">数据库用户名：</td>
						<td style="white-space:nowrap;">
							<span cui_input id="pageCutPrefix" ng-model="model.jdbcUserName" width="100%" ng-show="true" validate=""></span>
						</td>
						<td><a class="desc" title="实体导入的数据库的userName(默认无需配置自动取服务器启动时连接)">说明:实体导入的数据库的userName(默认无需配置自动取服务器启动时连接)</a></td>
					</tr>
					
					<tr>
						<td class="td_label">数据库密码：</td>
						<td style="white-space:nowrap;">
							<table width="100%">
								<tr>
									<td><span cui_input id="pageCutPrefix" ng-model="model.jdbcPassword" width="100%" ng-show="true" validate=""></span></td>
									<td style="width:72px;padding:0px;"><span id="testDB" uitype="button" button_type="orange-button" ng-click="testDB()" label="连接测试"></span></td>
								</tr>
							</table>
						</td>
						<td><a class="desc" title="实体导入的数据库的password(默认无需配置自动取服务器启动时连接)">说明:实体导入的数据库的password(默认无需配置自动取服务器启动时连接)</a></td>
					</tr>
				</table>
			</div>
		</fieldset>

	</div>
<script type="text/javascript">

//框架代码数据源
var initFrameWorkData=[{id:'jodd',text:'JODD(MVC)+jodd(Spring)+Mybatis'},
                       {id:'spring',text:'Spring(MVC)+Spring+Mybatis'}];

// var jdbcDriver = [{id:'oracle.jdbc.driver.OracleDriver',text:'ORACLE'},{id:'com.mysql.jdbc.Driver',text:'MYSQL'}];

var packageId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;		
var scope = null;
var entityDialog;
var model={};

angular.module('GeneralConfig', ["cui"]).controller('generalConfigCtrl', function ($scope) {
	$scope.model=model;
	
	//预加载方法
	$scope.ready = function() {
		comtop.UI.scan();
        $scope.initData();
		scope = $scope;
	}
	
	//页面初始化数据
	$scope.initData = function() {
		dwr.TOPEngine.setAsync(false);
		PreferenceConfigAction.loadPreferenceConfig(function(data){
			$scope.model=data;
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//保存全部
	$scope.saveAll=function(){
		//校验必填项
		if(!validataRequired().validFlag)
			return;
		
		//根据jdbcURL来判断使用的数据库类型，把数据库驱动设置进去
		var url = $scope.model.jdbcURL;
		$scope.model.driverClassName = $scope.oracleRegExp.test(url) ? $scope.getDBDriver("oracle") : ($scope.mysqlRegExp.test(url) ? $scope.getDBDriver("mysql") : "");
		if(url && !$scope.model.driverClassName){
			cui.warn("实体导入数据库连接URL配置有误，请修正。");
			return;
		}
		dwr.TOPEngine.setAsync(false);
		PreferenceConfigAction.savePreferenceConfig(scope.model,function(result){
			if(result && result=="success"){
				cui.alert("配置信息保存成功!",function(){
					window.location.reload();
				});
			}else{
				cui.error("配置信息保存失败:"+result);
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//还原到默认
	$scope.resetAll=function(){
		dwr.TOPEngine.setAsync(false);
		PreferenceConfigAction.loadDefaultPreferenceConfig(function(data){
			$scope.model=data;
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//父实体选择
	$scope.selectParentEntity=function(propertyName){
		var url = "${pageScope.cuiWebRoot}/cap/bm/dev/entity/SelSystemModelMain.jsp?sourcePackageId=" + packageId + "&isSelSelf=false"+"&propertyName="+propertyName;
		var title="选择目标实体";
		var height = 450; //600
		var width =  380; // 680;
		
		entityDialog = cui.dialog({
			title : title,
			src : url,
			width : width,
			height : height
		})
		entityDialog.show(url);
	}
	
	//监听是否执行soa远端
	$scope.$watch("model.callSoaService",function(newValue, oldValue, scope){
		if(typeof(newValue)=="string" && newValue=="true"){
			$scope.model.callSoaService =true;
		}else if(typeof(newValue)=="string" && newValue=="false"){
			$scope.model.callSoaService =false;
		}
	});
	
	$scope.$watch("model.isConsistency",function(newValue, oldValue, scope){
		if(typeof(newValue)=="string" && newValue=="true"){
			$scope.model.isConsistency =true;
		}else if(typeof(newValue)=="string" && newValue=="false"){
			$scope.model.isConsistency =false;
		}
	});
	//监听框架改变
	$scope.$watch("model.generateframework",function(newValue, oldValue, scope){
		var isReadonly = true;
		if(typeof(newValue)=="string" && newValue=="jodd"){
			isReadonly = false;
		}
		cui("#joddPageUrlSuffix").setReadonly(isReadonly);
		cui("#springPageUrlSuffix").setReadonly(!isReadonly);
	});
	
	/**
	 * 实体导入数据源配置的数据库连通性测试
	 */
	$scope.testDB = function() {
		var result = $scope.checkDBInfo();
		if(!result.flag){
			cui.warn("数据源配置信息不正确，请修正。");
			return;
		}
		var url = $scope.model.jdbcURL, name = $scope.model.jdbcUserName, pwd = $scope.model.jdbcPassword;
		dwr.TOPEngine.setAsync(false);
		PreferenceConfigAction.testDBConnection($scope.getDBDriver(result.dbType),url,name,pwd,function(result){
			if(result){
				cui.alert("连接成功。");
			}else{
				cui.warn("连接失败。");
			}
		});
		dwr.TOPEngine.setAsync(true);
	};
	
	$scope.oracleRegExp = /jdbc:oracle:[a-z]+:@(localhost|\d+[.]\d+[.]\d+[.]\d+):(\d+):(\w+)\b/;
	$scope.mysqlRegExp = /jdbc:mysql:\/\/(localhost|\d+[.]\d+[.]\d+[.]\d+):(\d+)\/(\w+)\b/;
	/**
	 * 实体导入数据源信息校验
	 *
	 */
	$scope.checkDBInfo = function() {
		var url = $scope.model.jdbcURL, name = $scope.model.jdbcUserName, pwd = $scope.model.jdbcPassword;
		if(url && name && pwd){
			if($scope.oracleRegExp.test(url)){
				return {flag : true, dbType : "oracle"};
			}
			if($scope.mysqlRegExp.test(url)){
				return {flag : true, dbType : "mysql"};
			}
		}
		return {flag : false};
	};
	
	//根据数据库类型获取数据库的驱动
	$scope.getDBDriver = function(dbType){
		if(dbType == "oracle"){
			return "oracle.jdbc.driver.OracleDriver";
		}else if(dbType == "mysql"){
			return "com.mysql.jdbc.Driver";
		}
		return "";
	};
});

//项目工程路径选择
function selectPath(){
	if(+[1,]) { 
		cui.alert("目前选择路径只能在IE浏览器下使用,其它浏览器请输入项目路径(例如：D:\\EAR)。");   
		return;
	}
	try {
		var strPath = new ActiveXObject("Shell.Application").BrowseForFolder(0, "请选择路径", 0, "").Items().Item().Path;
		cui("#filePath").setValue(strPath);
	}catch(e) {
		//cui.alert("选择路径需要将当前站点设置为信任站点。");
	}	
}

function rule_checkIsSameUrlSuffix(){
	var checkFlag = true;
	if (scope.model.springPageUrlSuffix!=null&&scope.model.springPageUrlSuffix!="") {
		checkFlag = scope.model.springPageUrlSuffix==scope.model.joddPageUrlSuffix ? false : true;
	}
	return checkFlag;
}
//效验url后缀
function rule_checkpageUrlSuffix(){
	var generateframework = scope.model.generateframework;
	var pageUrlSuffix = scope.model.joddPageUrlSuffix;
	if (generateframework == 'spring') {
		pageUrlSuffix = scope.model.springPageUrlSuffix;
		if (pageUrlSuffix=='.ac'||pageUrlSuffix=='.do') {
			return false;
		}
	}
	 var reg = new RegExp("^[\.\/][a-z]*$");
	if(reg.test(pageUrlSuffix)){
		return true;
	}
	return false;
}


//java代码路径选择
function selectJavaCodePath(){
	
}

//配置文件路径选择
function selectResourcesFilePath(){
	
}

//界面文件路径
function selectWebappFilePath(){
	
}

//测试用例代码路径选择
function selectTestDemoCodePath(){
	
}

//实体选择回调
function selEntityBack(selectNodeData,propertyName) {
	if(propertyName==="parentEntityId"){
		scope.model.defaultParentEntityId = selectNodeData.modelId;
	}else if(propertyName==="workflowParentEntityId"){
		scope.model.defaultWorkflowParentEntityId = selectNodeData.modelId;
	}
	scope.$digest();
	if(entityDialog){
		entityDialog.hide();
	}
}

//实体选择界面清空按钮
function setDefault(propertyName){
	if(propertyName==="parentEntityId"){
		scope.model.defaultParentEntityId ="";
	}else if(propertyName==="workflowParentEntityId"){
		scope.model.defaultWorkflowParentEntityId ="";
	}
	scope.$digest();
	if(entityDialog){
		entityDialog.hide();
	}
}
//实体选择界面取消按钮
function closeEntityWindow(){
	if(entityDialog){
		entityDialog.hide();
	}
}

var filePathRule = [{type:'required',rule:{m:'项目工程路径不能为空'}}];
var javaMainFilePathRule = [{type:'required',rule:{m:'java代码路径不能为空'}}];
var resourcesFilePathRule = [{type:'required',rule:{m:'配置文件路径不能为空'}}];
var testDemoCodePathRule = [{type:'required',rule:{m:'测试用例代码路径不能为空'}}];
var webappFilePathRule = [{type:'required',rule:{m:'界面文件路径不能为空'}}];
var prototypeImageFilePathRule = [{type:'required',rule:{m:'导出界面原型图片路径不能为空'}}];
var pageCutPrefixRule = [{type:'required',rule:{m:'页面路径生成规则不能为空'}}];
var parentEntityIdRule = [{type:'required',rule:{m:'父实体不能为空'}}];
var workflowParentEntityIdRule = [{type:'required',rule:{m:'父流程实体不能为空'}}];
var workflowParentEntityMatchRuler = [{type:'required',rule:{m:'父流程实体匹配规则不能为空'}}];
var pageUrlSuffixRule = [{ 'type':'custom','rule':{'against':'rule_checkpageUrlSuffix', 'm':'填写错误，请参考说明'}},{ 'type':'custom','rule':{'against':'rule_checkIsSameUrlSuffix', 'm':'两个框架的后缀不能相同'}}];
//保存按钮调用
function validataRequired() {
	var validate = new cap.Validate();
	var valRule = {
		projectFilePath: filePathRule,
		javaMainFilePath: javaMainFilePathRule,
		resourcesFilePath: resourcesFilePathRule,
		testDemoCodePath: testDemoCodePathRule,
		webappFilePath: webappFilePathRule,
		prototypeImageFilePath: prototypeImageFilePathRule,
		pagePrefixConfig: pageCutPrefixRule,
		defaultParentEntityId: parentEntityIdRule,
		defaultWorkflowParentEntityId: workflowParentEntityIdRule,
		defaultWorkflowMatchRule: workflowParentEntityMatchRuler,
		joddPageUrlSuffix: pageUrlSuffixRule,
		springPageUrlSuffix: pageUrlSuffixRule,
	};
	return validate.validateAllElement(scope.model, valRule);
}

/**
 * 去掉字符串前后空格
 * @param 字符串
 * @return 去掉前后空格后的字符串
 */
function trim(str){ 
	return str.replace(/(^\s*)|(\s*$)/g, ""); 
}

/**
 * 去掉路径中的文件夹或者文件名中前后空格
 * @param  path 
 * @return 去掉后的路径串
 */
function trimPath (path) {
	if(path) {
		var pathArray = path.split('\\');
		for (var i = 0; i < pathArray.length; i++) {
			pathArray[i] = Trim(pathArray[i]);
		};
		return pathArray.join('\\');
	}
}

function openFileIIs(filename){     
	filename = _.getCookie(GEN_CODE_PATH_CNAME);
    try{   
        var obj=new ActiveXObject("wscript.shell");   
        if(obj){   
            obj.Run("\""+filename+"\"", 1, false );  
            //obj.run("osk");/*打开屏幕键盘*/  
            //obj.Run('"'+filename+'"');   
            obj=null;   
        }   
    }catch(e){   
        alert("请确定是否存在该盘符或文件");   
    }   
}  

var objHandleMask;
//生成遮罩层
function createCustomHM(){
	objHandleMask = cui.handleMask({
        html:'<div style="padding:10px;border:1px solid #666;background: #fff;"><div class="handlemask_image_1"/><br/>正在生成实体，预计需要2~3分钟，请耐心等待。</div>'
    });
	objHandleMask.show()
}

//生成遮罩层
function removeCustomHM(){
	objHandleMask.hide()
}

</script>
</body>
</html>