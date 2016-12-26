<%
  /**********************************************************************
	* CAP应用中心 
	* 2015-09-25  李小芬  新增
	* 2016-05-28  刘城 修改
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
    String version = formatter.format(new Date());
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<%//360浏览器指定webkit内核打开%>
	<meta name="renderer" content="webkit">
	<%//关闭ie兼容模式,使用最高版本文档模式渲染页面%>
	<meta http-equiv="x-ua-compatible" content="IE=edge" >
	<link rel="shortcut icon" href="${pageScope.cuiWebRoot}/top/workbench/base/img/logo.ico">
	<link href="${pageScope.cuiWebRoot}/cap/bm/common/base/css/base.css" rel="stylesheet">
	<link href="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/default/css/comtop.ui.min.css" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/eic/css/eic.css"/>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/component/requirejs/require.js?v=<%=version%>"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/component/requirejs/require.config.js?v=<%=version%>"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js?v=<%=version%>"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/base/js/base.js?v=<%=version%>"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/cui/cStorage/cStorage.full.min.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/dev/page/designer/js/pageList.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/bm/dev/page/pageHome.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/engine.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/util.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/FuncModelAction.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/EntityFacade.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/EntityOperateAction.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/PageFacade.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/CapAppAction.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/ServiceObjectAction.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/ServiceObjectFacade.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/NewPageAction.js'></script>
	<script type="text/javascript" src='<%=request.getContextPath() %>/cap/dwr/interface/MetadataGenerateFacade.js'></script>	
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.min.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/bm/common/cui/js/cui.utils.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/eic/js/comtop.ui.emDialog.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/eic/js/comtop.eic.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/DocumentAction.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/MetadataPageConfigFacade.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/MetadataTmpTypeFacade.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/TestCaseFacade.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/InvokeFacade.js'></script>
	<style type="text/css">

.app_items_btn{
	float: right;
	padding-bottom: 5px;
	display:none;
}

.app_items{
	display:none;
}
.app_item{
	float:left;
}
.app_item li.first{
	float: left;
    margin: 5px 0px 3px 5px;
    background-color: #fff;
    border: 0px ;
    position: relative;
    transition: all 0.8s cubic-bezier(0.175, 0.885, 0.32, 1);
    padding: 4px 2px 5px 3px;
    border-radius: 3px;
    width:auto;
}

.app_item li.first:hover {
  border: 0px solid #808080;
  cursor: pointer;
  background-color: #e5e5e5;
}

.app_item li.main {
  float: left;
  margin: 5px 5px 3px 0px;
  background-color: #fff;
  position: relative;
  transition: all 0.8s cubic-bezier(0.175, 0.885, 0.32, 1);
  padding: 3px;
  border-radius: 3px;
  width: 225px;
  height: 22px;
  white-space:nowrap;
  }
.app_item li.main:hover {
  border: 1px solid #808080;
  cursor: pointer;
  background-color: #e5e5e5;
}
.app_item li.main:hover .colsebtn {
  display: block;
}
.item_checkbox {
	float:left;
	position:relative;
}

.item_content {
	white-space:nowrap;
	text-overflow:ellipsis;
	overflow: hidden;
	height:30px;
}

.app_box{
	border: 0;
}
.app-category {
  height: 20px;
  border-left: 0px ;
  padding-left: 10px;
  margin: 3px 0;
  cursor: pointer;
  -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  -o-user-select: none;
  user-select: none;
}
.app_attr{
	padding: 5px;
	border: 1px solid #cccccc;
	background-color: #fff;
    margin:0 0 10px 0;
}

.app-category .place-left em {
    background-color: #03a41d;
    color: #fff;
    border-radius: 12px;
    padding: 0px 7px;
    margin: 0 0 0 5px;
}

.app-category .place-right {
  float: right;
  margin-right: 10px;
  margin-top:5px;
}

.lastcui{
	float:right;
	cursor:pointer;
	padding-right: 10px;
    padding-top: 10px;
}

.item_content img{
	float:left;
	margin-top:3px;
}

</style>
<title>应用列表</title>
</head>
<body class="myappbody">
<div class="app_nav clearfix">
	<b class="myapp_icon top_float_left"></b>
	<span class="app_name" id="entityTitle"></span>&nbsp;&nbsp;&nbsp;包路径：<span id="funcCode"  width="200"></span>
	<div class="top_float_right clearfix" style="margin: 8px 10px 0 0;">
		<span uitype="button" id="generateTestMenu" label="生成用例" menu="generateTestMenu" ></span>
		<span uitype="Button" id="assignRight" label="分配" button_type="" icon="pencil-square-o" on_click="assignRight"></span>
		<span uitype="Button" id="storeUp" label="收藏" button_type="" icon="pencil-square-o" on_click="storeUp"></span>
		<span uitype="Button" id="cancelStore" label="取消收藏" button_type="" icon="pencil-square-o" on_click="cancelStore"></span>
		<!--<span uitype="Button" id="returnEditFunc" label="返回" button_type="green-button" icon="reply" on_click="returnEditFunc"></span>-->
		<span uitype="Button" id="closeWin" label="关闭" button_type="green-button" icon="" on_click="closeWin"></span>
	</div>
</div>
<div class="app_box">
	<!-- <div class="app_container"> -->
		<div class="app_attr clearfix">
			<div class="app-category clearfix">
				<div class="place-left"><font color="">实体</font><em id="entityPanelCount"></em></div>
				<div class="app_items_btn" >
					<span uitype="checkboxGroup" id="checkAllEntity" name="checkAllEntity" on_change="checkAllEntity">
					 		<input type="checkbox" name="checkEntity"   value="1"> 全选
					</span>
					<span uiType="ClickInput" width="200px" id="entityClickInput" name="entityClickInput" enterable="true" emptytext="请输入名称关键字查询" editable="true" width="300" on_iconclick="entitySimpleQuery" 
				 			 on_keyup="entitySimpleQuery" 	icon="search" iconwidth="18px"></span> 
			 		<span uiType="PullDown" mode="Single" editable="false" id="entityType" datasource="initEntityType"  label_field="text" value_field="id"  width="80"  on_change="entitySimpleQuery"></span>
				</div>
				<img class="place-right" src="image/off.png">
			</div>
			<div class="app_items"  id="entityPanel">
				<div style="clear:both;" ></div> 
				<div class="app_items_content"  id="entityPanelArea">
				</div>
			</div>
		</div>
		<div class="app_attr clearfix">
			<div class="app-category clearfix">
				<div class="place-left"><font color="">界面</font><em id="pagePanelCount"></em></div>
				<div class="app_items_btn" >
						<span uitype="checkboxGroup" id="checkAllPage" name="checkAllPage" on_change="checkAllPage">
					 		<input type="checkbox" name="checkPage"   value="1"> 全选
						</span>
				 		<span uiType="ClickInput" width="200px" id="pageClickInput" name="pageClickInput" enterable="true" emptytext="请输入名称关键字查询" editable="true" width="300" on_iconclick="pageSimpleQuery" 
				 			 on_keyup="pageSimpleQuery" 	icon="search" iconwidth="18px"></span> 
				 		<span uiType="PullDown" mode="Single" editable="false" id="pageType" datasource="initPageType"  label_field="text" value_field="id"  width="80"  on_change="pageSimpleQuery"></span>
					</div>
				<img class="place-right" src="image/off.png">
			</div>
				<div class="app_items"  id="pagePanel">
					<div style="clear:both;" ></div> 
					<div class="app_items_content"  id="pagePanelArea">
					</div>
				</div>
		</div>
		<div class="app_attr clearfix">
			<div class="app-category clearfix">
				<div class="place-left"><font color="">服务</font><em id="servicePanelCount"></em></div>
				<div class="app_items_btn" >
					<span uitype="checkboxGroup" id="checkAllService" name="checkAllService" on_change="checkAllService">
					 		<input type="checkbox" name="checkService"   value="1"> 全选
					</span>
					<span uiType="ClickInput" width="200px" id="serviceClickInput" name="serviceClickInput" enterable="true" emptytext="请输入名称关键字查询" editable="true" width="300" on_iconclick="serviceSimpleQuery" 
				 			 on_keyup="serviceSimpleQuery" 	icon="search" iconwidth="18px"></span> 
				</div>
				<img class="place-right" src="image/off.png">
			</div>
			
			<div class="app_items" id="servicePanel">
				
				<div style="clear:both;" ></div> 
				<div class="app_items_content"  id="servicePanelArea">
				</div>
			</div>
		</div>
		<div class="app_attr clearfix">
			<div class="app-category clearfix">
				<div class="place-left"><font color="">测试</font><em id="testCasePanelCount"></em></div>
			    <div class="app_items_btn" >
					<span uitype="checkboxGroup" id="checkAllTest" name="checkAllTest" on_change="checkAllTest">
					 		<input type="checkbox" name="checkTest"   value="1"> 全选
					</span>
					<span uiType="ClickInput" width="200px" id="testCaseClickInput" name="testCaseClickInput" enterable="true" emptytext="输入中文名称查询" editable="true" width="300" on_iconclick="testCaseSimpleQuery" 
				 			 on_keyup="testCaseSimpleQuery" 	icon="search" iconwidth="18px"></span> 
				 	<span uiType="PullDown" mode="Single" editable="false" id="testCaseType" datasource="initTestCaseType"  select="0" label_field="text" value_field="id"  width="80"  on_change="testCaseSimpleQuery"></span>
				 	<span uiType="PullDown" mode="Single" editable="false" id="pageList" datasource="initPageList"  select="0" label_field="text" value_field="id"  width="160"  on_change="testCaseSimpleQuery"></span>
					<span uitype="Button" label="新增" id="menu_add_testCase"  menu="menu_add_testCase"></span>
					<span uitype="Button" label="删除" on_click="batchDelTestCase"></span>
				</div>
				<img class="place-right" src="image/off.png">
			</div>
			<div class="app_items"  id="testCasePanel">
				<div style="clear:both;" ></div> 
				<div class="app_items_content"  id="testCasePanelArea">
				</div>
			</div>
		</div>
	<!-- </div> -->
</div>
<!-- 实体展现方式  -->
<script type="text/template" id="entityTemplate">
<ul>
	<@ _.each(datas,function(item){  @>
			<li>
				<ul  class="app_item">
					<li class="first">
						<div class="item_checkbox"><input type="checkbox" name="entity"  value="<@=item.modelId@>"/></div>
					</li>
					<li class="main" target="_blank" title="<@=item.modelName@>" data-mainframe="false" data-url="<@=editEntityUrl@>&modelId=<@=item.modelId@>&entityType=<@=item.entityType@>">
						<div class="item_content" >
							<img src="<@ if(item.entityType == "biz_entity"){ @>image/biz_entity.png<@}else if(item.entityType == "query_entity"){ if(item.entitySource == "exist_entity_input"){@>image/exist_entity.png<@}else{@>image/query_entity.png<@}}else if(item.entityType == "data_entity"){if(item.entitySource == "exist_entity_input"){@>image/exist_entity.png<@}else{@>image/data_entity.png<@}}@>">
							<span><@=item.modelName@></span>
						</div>
					</li>
				</ul>
			</li>
	<@})@>
	<li class="lastcui"  ><img  src="image/on.png"></img></li>
<ul>
</script>
<!-- 页面展现方式 -->
<script type="text/template" id="pageTemplate">
<ul>
	<@ _.each(datas,function(item){  @>
			<li>
				<ul  class="app_item">
					<li class="first">
						<div class="item_checkbox"><input type="checkbox" name="page"  value="<@=item.modelId@>"/> </div>
					</li>
					<li class="main" target="_blank" title="[页面]<@=item.modelName@>" data-mainframe="false" data-url="<@ if(item.pageType == 1){ @><@=editPageMainUrl@>&modelId=<@= item.modelId @><@}else{@><@=editSelfPageUrl@>&modelId=<@= item.modelId @><@}@>">
						<div class="item_content" >
							<img src="<@ if(item.pageType == 1){ @>image/page.png<@}else{@>image/definePage.png<@}@>">
							<span><@=item.modelName@></span>
						</div>
					</li>
				</ul>
			</li>
	<@})@>
	<li class="lastcui" ><img  src="image/on.png"></img></li>
<ul>
</script>
<!-- 服务展现方式 -->
<script type="text/template" id="serviceTemplate">
<ul>
		<@ _.each(datas,function(item){ @>
			<li>
				<ul  class="app_item">
					<li class="first">
						<div class="item_checkbox"><input type="checkbox" name="service"  value="<@=item.modelId@>"/> </div>
					</li>
					<li class="main" target="_blank" title="<@=item.englishName@>" data-mainframe="false" data-url="<@=editServiceUrl@>&selectedObjectId=<@=item.modelId@>">
						<div class="item_content" >
							<img src="image/service.png">
							<span><@=item.englishName@></span>
						</div>
					</li>
				</ul>
			</li>
		<@})@>
		<li class="lastcui" ><img  src="image/on.png"></img></li>
</ul>
</script>
<!--测试展现方式 -->
<script type="text/template" id="testCaseTemplate">
<ul>
		<@ _.each(datas,function(item){ @>
			<li>
				<ul  class="app_item">
					<li class="first">
						<div class="item_checkbox"><input type="checkbox" name="testCase"  value="<@=item.modelId@>"/> </div>
					</li>
					<li class="main" target="_blank" title="<@=item.name@>" data-mainframe="false" data-url="<@=editTestCaseUrl@>&modelId=<@=item.modelId@>">
						<div class="item_content" >
							<img src="<@ if(item.type == 'API'){ @>image/test_api.png<@ }else if(item.type == 'SERVICE'){ @>image/test_service.png<@}else{@>image/test_function.png<@}@>">
							<span <@if(item.containCustomizedStep){@>style="color:red;"<@}@>><@=item.name@></span>
						</div>
                        <i class="colsebtn" data-id="<@=item.modelId@>" data-type="testCase"></i>
					</li>
				</ul>
			</li>
		<@})@>
		<li class="lastcui" ><img  src="image/on.png"></img></li>
</ul>
</script>
<script type="text/javascript">
	//返回应用编辑需要的参数
	var clickCome = "${param.clickCome}";
	var myAppId = "${param.id}";
	var parentNodeId = "${param.parentNodeId}";
	var parentNodeName = "${param.parentNodeName}";
	var nodeTypeVal = "${param.nodeTypeVal}";
	var parentModuleType = "${param.parentModuleType}";
	var userAccount =  "${userInfo.account}";
	var userPassword =  "${userInfo.password}";
	var testModel = "${param.testModel}";
	
	//load加载膜 
	//cui.handleMask({
	//    html: '<div class="custom_hmstyle"><span id="process"><font color="red" size="5">正在执行中,此过程可能需要耗费较长时间……</font></span></div>'
	//});
	var generateTestMenu = {
	    	datasource: [
		     	            {id:'generateTest',label:'生成用例'},
		     	            {id:'generateScript',label:'生成脚本'},
		     	           {id:'sendTest',label:'发送脚本'}
		     	        ],
				on_click:function(obj){
		     	        	if(obj.id=='generateTest'){
		     	        		generateTest();
		     	        	}else if(obj.id=='generateScript'){
		     	        		generateScript();
		     	        	}else if(obj.id=='sendTest'){
		     	        		sendTest();
		    	        	}
				}	
	}
	
	//生成用例
	function generateTest(){
		//获取选中的实体和界面
		var metaDataArr = [];
		$('input[name="entity"]:checked').each(function(){ 
			metaDataArr.push($(this).val()); 
		});
		$('input[name="page"]:checked').each(function(){ 
			metaDataArr.push($(this).val()); 
		});
		cui.handleMask.show();
		if(metaDataArr.length == 0){ //全部生成 
			TestCaseFacade.genTestcase(funcFullCode,function(data){
				cui.handleMask.hide();
				if(data){
					cui.message("生成用例成功。","success");
					refreshWindowByOperateType("testCase");
				}else{
					cui.message("生成用例失败。","error");
				}
			});
		}else{
			TestCaseFacade.genTestcaseByMetadata(metaDataArr,function(data){
				cui.handleMask.hide();
				if(data){
					cui.message("生成用例成功。","success");
					refreshWindowByOperateType("testCase");
				}else{
					cui.message("生成用例失败。","error");
				}
			});
		}
	}
	
	//生成本地脚本
	function generateScript(){
		var testCaseArr = [];
		$('input[name="testCase"]:checked').each(function(){ 
			testCaseArr.push($(this).val()); 
		});
		cui.handleMask.show();
		if(testCaseArr.length==0){ //生成全部 
			TestCaseFacade.genScriptByPackage(funcFullCode,function(data){
				cui.handleMask.hide();
				if(data){
					cui.message("生成脚本成功。","success");
					refreshWindowByOperateType("testCase");
				}else{
					cui.message("生成脚本失败。","error");
				}
			});
		}else{
			TestCaseFacade.genScriptByTestcaseIds(testCaseArr,function(data){
				cui.handleMask.hide();
				if(data){
					cui.message("生成脚本成功。","success");
					refreshWindowByOperateType("testCase");
				}else{
					cui.message("生成脚本失败。","error");
				}
			});
			
		}
	}
	
	//生成脚本并发送服务器
	function sendTest(){
		cui.handleMask.show();
		TestCaseFacade.sendTestcases(funcFullCode,function(data){
			cui.handleMask.hide();
			if(data && data.uploadScript){
				cui.message("发送用例成功。","success");
				refreshWindowByOperateType("testCase");
			}else{
				cui.message("发送用例失败。","error");
			}
		});
	}
	
	//个性化设置
	if(cst.exists("appStorage")){
		var data = cst.use("appStorage").get("displayArea");
		$.each(data,function(key,value){
			$("#"+key).parent().find("img.place-right").css("display",value?"none":"block");
			$("#"+key).css("display",value?"block":"none");
			$("#"+key).parent().find(".app_items_btn").css("display",value?"block":"none");//改变btndiv的显示
		})
	}else{
		var myStorage = cst.use("appStorage");
		//设置以个值
		myStorage.set("displayArea",{
			entityPanel:false,
			servicePanel:false,
			pagePanel:false,
			testCasePanel:false
		});
		$(".app_items").hide();
	}
	
	//应用ID
	var funcId = "${param.packageId}";
	//应用的VO信息--获得应用的名称（com.comtop.系统编码.目录编码.应用编码）
	var func;
	//包路径信息 
	var funcFullCode;
	//个人应用信息
	var appVO;
	//应用下的实体信息 
	var entity;
	//应用下的服务信息
	var service;
	//应用下的界面信息
	var page;
	//应用下的界面模板信息
	var pageMetadata;
	//测试用例
	var testCase;
	
	dwr.TOPEngine.setAsync(false);
	FuncModelAction.readFuncByModuleId(funcId,function(data){ //应用
		func = data;
		funcFullCode = func.fullPath;
	});
	CapAppAction.queryById(myAppId,function(data){
		appVO = data;
	});
	if(!myAppId){
		var app = {"employeeId":globalCapEmployeeId,"appId":funcId,"appType":2};
		CapAppAction.queryStoreApp(app,function(data){
			appVO = data;
		});
	}
	//==================应用下的数据查询区域==========================================================
	EntityFacade.queryEntityList(func.parentFuncId,function(data){ //实体
		entity = data;
	});
	PageFacade.queryPageList(func.parentFuncId, function(data){
		page = data;
	});
	MetadataGenerateFacade.queryMetadataGenerateList(func.parentFuncId, function(data){
		pageMetadata = data;
	});
	ServiceObjectFacade.queryServiceObjectList(funcId,function(data){
		service = data;
	});
	TestCaseFacade.queryTestCaseList(funcFullCode,function(data){
		testCase = data;
	});
	dwr.TOPEngine.setAsync(true);
	
	var addTestCaseUrl;
	var editTestCaseUrl;
	addTestCaseUrl = "<%=request.getContextPath() %>/cap/bm/test/design/TestCaseAdd.jsp?packageId=" + funcId +"&moduleCode="+funcFullCode;
	editTestCaseUrl = "<%=request.getContextPath() %>/cap/bm/test/design/TestCaseMain.jsp?packageId=" + funcId +"&moduleCode="+funcFullCode;
	//添加新的测试用例 
	var testCaseDialog;
	function addTestCase(){
		var height = 650;
		var width = 730;
		if(!testCaseDialog){
			testCaseDialog = cui.dialog({
			  	title : "新增测试用例",
			  	src : addTestCaseUrl,
			    width : width,
			    height : height
			});
		}
		testCaseDialog.show(addTestCaseUrl);
	}
	
	//新增编辑保存回调
	function saveTestCaseCallBack(data,moduleCode){
			data.modelPackage = funcFullCode;
		    dwr.TOPEngine.setAsync(false);
		    TestCaseFacade.saveTestCase(data,function(result){
				  if(result){
					  cui.message('保存成功。','success');
					  refresh();//刷新页面
				  }
			   });
			dwr.TOPEngine.setAsync(true);
			if(testCaseDialog){
				testCaseDialog.hide();
			}
	}
	
	//关闭测试用例编辑窗口
	function closeTestCaseWindow(){
		testCaseDialog.hide();
	}
	
	//测试用例批量删除事件batchDelTestCase
	function batchDelTestCase(){
		var testCaseArr = [];
		$('input[name="testCase"]:checked').each(function(){ 
			testCaseArr.push($(this).val()); 
		});
		if(testCaseArr.length==0){
			cui.alert("请选择要删除的测试用例。");
		}else{
			cui.confirm("确认要删除当前测试用例吗？",{
				onYes:function(){
					delTestCase(testCaseArr);
				}
			});
		}
	}
	
	//删除测试用例
	function delTestCase(ids){
		dwr.TOPEngine.setAsync(false);
		TestCaseFacade.delTestCases(ids,function(data){
			if(data){
				cui.message("删除用例成功。","success");
				refreshWindowByOperateType("testCase");
			}else{
				cui.message("删除用例失败。","error");
			}
 		});
 		dwr.TOPEngine.setAsync(true);
 		
	}
	//=========================初始化下拉框===================================
	// 初始化实体选择类型
	function initEntityType(obj){
		var initData = [
		        {id:'0',text:'全部'},
		      	{id:'biz_entity',text:'业务实体'},
		      	{id:'query_entity',text:'查询实体'},
		      	{id:'data_entity',text:'数据实体'},
		      	{id:'exist_entity',text:'已有实体'}
		      ]
		             
		obj.setDatasource(initData);
	}
	
	// 初始化界面选择类型
	function initPageType(obj){
		var initData = [
		        {id:'0',text:'全部'},
		      	{id:'page',text:'页面'},
		      	{id:'userPage',text:'自定义'}
		      ]
		             
		obj.setDatasource(initData);
	}
	
	//初始化测试用例类型 
	var initTestCaseType = [
		{id:'0',text:'全部类型'},
		{id:'FUNCTION',text:'界面功能'},
		{id:'API',text:'后台API'},
		{id:'SERVICE',text:'业务服务'}
	];
	
	//初始化全部界面
	function initPageList(obj){
		var jsonData = new Array({id:'0',text:'全部元数据'});
		for(var i=0; i < page.length; i++){
			var arr  = {
					"id" : page[i].modelId,         
					"text" : "界面_" + page[i].modelName   
					};
			jsonData.push(arr);
		}
		for(var i=0; i < entity.length; i++){
			var arr  = {
					"id" : entity[i].modelId,         
					"text" : "实体_" + entity[i].modelName
					};
			jsonData.push(arr);
		}
		obj.setDatasource(jsonData);
	}
	
	//界面新增菜单
	var menu_add_testCase = {
			datasource:[
			{id:'item1',label:"新建用例"},
			{id:'copyTestCase',label:"复制选择用例"}],
			type:"button",
			on_click:function(e){
				if(e.id=="item1"){
					addTestCase();
				}else if(e.id=="copyTestCase"){
					selectTestCase();
				}
			},
			width:100,
			trigger:"mouseover"
	};
	
	//从选择页面复制name="testCase"
	function selectTestCase() {
		var selectData = [];
		var reArrData = [];
		$('input[name="testCase"]:checked').each(function(){ 
			reArrData.push($(this).val()); 
		});
		//根据selectData从page里面获取对应的数据
		selectData = parseTestCaseData(reArrData);
		if (selectData == null || selectData.length == 0) {
			cui.alert("请选择要复制的用例。");
			return;
		} else {
			//if(selectData.length>1){ //复制多条
				var url =  "<%=request.getContextPath() %>/cap/bm/test/design/CopyTestCaseNameEdit.jsp?packageId="+funcId + "&moduleCode=" + funcFullCode;
				var top=(window.screen.availHeight-600)/2;
	    		var left=(window.screen.availWidth-800)/2;
				window.open(url,'copyTestCaseNameEdit','height=650,width=1000,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no');
			//}else{ //复制一条 
			//	copyTestCaseData(selectData[0], 'copyPage',null);
			//}
		}
	}
	
	//返回被选择的页面 供其他页面调用
	function returnSelectTestCase(){
		var selectData = [];
		var reArrData = [];
		$('input[name="testCase"]:checked').each(function(){ 
			reArrData.push($(this).val()); 
		});
		selectData = parseTestCaseData(reArrData);
		return selectData;
	}
	
	//复制选择页面结果
	function copyTestCaseResult(rs){
		if(typeof rs === 'number'){
			cui.message(rs+'个用例复制成功！', 'success');
		}
		if(typeof rs === 'boolean'){
			if (rs) {
				cui.message('用例复制成功！', 'success');
			} else {
				cui.error("用例复制失败！");
			} 
		}
		refresh();
	}
	
	//复制页面选中的页面，回调
	function copyTestCaseData(selectTestCaseDate){
    	var modelId = selectTestCaseDate.modelId;
     	param="?modelId="+modelId+"&packageId="+funcId+ "&moduleCode="+funcFullCode;
		window.open("<%=request.getContextPath() %>/cap/bm/test/design/TestCaseMain.jsp"+param, "_blank");
	}
	
	//根据已选择的下拉框数据获取完整的对应的page数据
	function parseTestCaseData(selectData){
		var reData = [];
		for(var i=0;i<selectData.length;i++){
			for(var j=0;j<testCase.length;j++){
				var item = testCase[j];
				if(selectData[i]==item['modelId']){
					reData.push(testCase[j]);
				}
			}
		}
		return reData;
	}
	
	//元数据链接 - 新版实体
	var editEntityUrl;
	editEntityUrl = "<%=request.getContextPath() %>/cap/bm/dev/entity/EntityMain.jsp?packageId=" + funcId+"&moduleCode="+func.funcCode + "&testModel="+testModel+"&globalReadState=true";
	
	//元数据链接 - 新版界面
	var editPageMainUrl;
	var editSelfPageUrl;
	var editMetadataGenerateUrl;
	editPageMainUrl = "<%=request.getContextPath() %>/cap/bm/dev/page/designer/PageMain.jsp?packageId=" + funcId + "&testModel=" + testModel + "&globalReadState=true";
	editMetadataGenerateUrl = "<%=request.getContextPath() %>/cap/bm/dev/page/template/MetadataGenerateEdit.jsp?packageId=" + funcId+"&operationType=edit";
	editSelfPageUrl = "<%=request.getContextPath() %>/cap/bm/dev/page/designer/EntrySelfPage.jsp?packageId=" + funcId;
	
	//元素超链接 - 服务
	var editServiceUrl;
	editServiceUrl = "<%=request.getContextPath() %>/cap/bm/dev/serve/ServiceObjectMain.jsp?appEditFlag=true&packageId=" + funcId +"&packagePath="+funcFullCode+ "&editType=edit";

	
	$(".app-category").click(function(){
		if($(this).next().is(":visible")){
			$(".app_items_btn",this).next().show();
		}else{
			$(".app_items_btn",this).next().hide();
		}
		$(this).next().toggle();
		$(".app_items_btn",this).toggle();
		//使用缓存记录下用户点张开过的现
		if(cst.exists("appStorage")){
			var data = cst.use("appStorage").get("displayArea");
			data[$(this).next().attr("id")] = $(this).next().is(":visible");
			cst.use("appStorage").set("displayArea",data);
		}
	});
	
	$(".app_items_btn").click(function(arg){
		var evnt=window.event?window.event:arg;
	    if(evnt.stopPropagation){
	    	evnt.stopPropagation();
	    }else{
	    	evnt.cancelBubble=true;
	    }
		//event.stopPropagation();
	});
	
	//实体渲染
	function entityRender(id,obj){
		var dataArea = _.template($("#"+id+"Template").html(),{
			datas:obj,
			id:id,
			editEntityUrl:editEntityUrl}
		);
		$("#"+id+"PanelCount").text(obj.length);
		$("#"+id+"PanelArea").html(dataArea);
	}
	//页面渲染
	function pageRender(id,obj,pageMetadata){
		var dataArea = _.template($("#"+id+"Template").html(),{
			datas:obj,
			metaDatas:pageMetadata,
			id:id,
			editPageMainUrl:editPageMainUrl,
			editSelfPageUrl:editSelfPageUrl}
		);
		$("#"+id+"PanelCount").text(obj.length);
		$("#"+id+"PanelArea").html(dataArea);
	}
	
	//服务渲染
	function serviceRender(id,serviceObj){
		var dataArea = _.template($("#"+id+"Template").html(),{
			datas:serviceObj,
			id:id,
			editServiceUrl:editServiceUrl}
		);
		$("#"+id+"PanelCount").text(serviceObj.length);
		$("#"+id+"PanelArea").html(dataArea);
	}
	
	//测试用例渲染
	function testCaseRender(id,testObj){
		var dataArea = _.template($("#"+id+"Template").html(),{
			datas:testObj,
			id:id,
			editTestCaseUrl:editTestCaseUrl}
		);
		$("#"+id+"PanelCount").text(testObj.length);
		$("#"+id+"PanelArea").html(dataArea);
	}
	
	//收藏事件
	function storeUp(event, self, mark){
		var app = {"employeeId":globalCapEmployeeId,"appId":funcId,"appType":2};
		dwr.TOPEngine.setAsync(false);
		CapAppAction.storeUpApp(app,function(data){ 
			if(data){
				var app = {"employeeId":globalCapEmployeeId,"appId":funcId,"appType":2};
				CapAppAction.queryStoreApp(app,function(data){
					appVO = data;
				});
				cui.message('收藏成功！','success');
				setTimeout(function(){
					cui("#storeUp").hide();
					cui("#cancelStore").show();
				},400);
			}else{
				cui.message('收藏失败', "error");
			} 
	    });
		dwr.TOPEngine.setAsync(true);
	}
	//取消收藏 
	function cancelStore(){
		var app = {"id":appVO.id};
		dwr.TOPEngine.setAsync(false);
		CapAppAction.cancelAppStore(app,function(data){ 
			if(data){
				cui.message('取消成功！','success');
				cui("#storeUp").show();
				cui("#cancelStore").hide();
			}else{
				cui.message('取消失败', "error");
			} 
	    });
		dwr.TOPEngine.setAsync(true);
	}
	
	//分配事件
	function assignRight(event, self, mark){
		var url = "<%=request.getContextPath() %>/cap/ptc/team/CheckMulTestPersonnel.jsp?teamId="+globalCapTeamId+"&appId="+ funcId;
		var title="选择测试人员";
		var height = 450; //600
		var width =  680; // 680;
		
		dialog = cui.dialog({
			title : title,
			src : url,
			width : width,
			height : height
		})
		dialog.show(url);
	}
	
	//分配后回调 
	function chooseEmployee(selects,teamId){
		dwr.TOPEngine.setAsync(false);
		CapAppAction.assignApp(selects,funcId,teamId,function(data){ 
			if(data == 1) {
				cui.message('分配成功！','success');
			}else{
				cui.message('分配失败', "error");
			} 
	    });
		dwr.TOPEngine.setAsync(true);
	}
	
	
	//返回事件 
	function returnEditFunc(event, self, mark){
		var returnParentNodeName  = decodeURIComponent(decodeURIComponent(parentNodeName));
		if(returnParentNodeName!="undefined"&&returnParentNodeName!=null&&returnParentNodeName!="null"){
			returnParentNodeName = encodeURIComponent(encodeURIComponent(returnParentNodeName));
		}
		var returnUrl = '<%=request.getContextPath() %>/cap/bm/dev/systemmodel/FuncModelEdit.jsp?nodeId=' + funcId + '&parentNodeId=' + parentNodeId
		+ "&parentNodeName=" + returnParentNodeName;
		window.open(returnUrl + "&testModel=testModel", '_self');
	}
	
	function closeWin(){
		window.close();
	}
	
	
	//刷新当前页面函数
	function refresh(){
		window.location.reload();
	}
	
	require(["underscore"],function(){
		var url = "<%=request.getContextPath() %>/cap/bm/doc/info/MonitorAsynTaskList.jsp?userId="+globalCapEmployeeId+"&init=true";
		initOpenBottomImage(url);
		comtop.UI.scan();
		//显示按钮控制 
		if(clickCome=="homepage"){
			cui("#assignRight").hide();
			cui("#storeUp").hide();
			cui("#returnEditFunc").hide();
			cui("#cancelStore").hide();
			cui("#closeWin").show();
		}else{
			cui("#assignRight").hide();
			var roleIds = globalCapRoleIds.split(';');
			for(var i = 0; i < roleIds.length; i++){
				if(roleIds[i] == 'pm'){
					cui("#assignRight").show();
				}
			}
			cui("#storeUp").show();
			cui("#returnEditFunc").show();
			cui("#cancelStore").hide();
			cui("#closeWin").hide();
		}
		if(clickCome=="homepage" && appVO.appType == 2){
			cui("#cancelStore").show();
		}else if(!clickCome && appVO && appVO.appType == 2){
			cui("#storeUp").hide();
			cui("#cancelStore").show();
		}
		
		//应用名称和包路径
		$("#entityTitle").text(func.funcName);
		cui("#funcCode").html(funcFullCode);
		
		//渲染每个item【实体，服务，工作流】panelId,data,url
		entityRender("entity",entity||[]);
		pageRender("page",page||[],pageMetadata||[]);
		serviceRender("service",service||[]);
		testCaseRender("testCase",testCase||[]);
		
		$(".app_item").on("click",".colsebtn",function(e){
			var that = this;
			e.stopPropagation();
			cui.confirm('确认要删除信息吗？', {
				onYes: function(){
					var type = $(that).data("type"),id=$(that).data("id"),pagetype=$(that).data("pagetype");
					if(type="testCase"){
						delTestCase([id]);
					}
				},
				onNo: function(){
					//do nothing
				}
			});
		});
		
		
		$(".app_item li.first").click(function(){
			var name = $(":checkbox",this).attr("name");
			var id = getCurAllCheckBoxIdByName(name);//获取全选矿cui组件的id
			if($(":checkbox",this).is(':checked')){
				$(":checkbox",this).attr("checked",false);
				
			   	 //如果当前为选中，判断全选是否被选中，是则取消选中
				 if($("#"+id).find(":checkbox").is(":checked")){//如果全选按钮是选中的
				    	$("#"+id).find(":checkbox").attr("checked",false);
				    	$("#"+id).find("label").css("color","black");
				  } 
			}else{
				$(":checkbox",this).attr("checked",true);
				
				//如果全选按钮是未选中的,并且当前所有checkbox已选择 选中
				if(!$("#"+id).find(":checkbox").is(":checked")){
					var divId = getCurDivIdByName(name);
			    	if($("#"+divId).find(":checkbox").length==$("#"+divId).find("input[type=checkbox]:checked").length){
			    		cui("#"+id).selectAll();
			    	}
			  	} 
			}
		});
		
		$(".app_item li.first").find(":checkbox").click(function(arg){
				var evnt=window.event?window.event:arg;
			    if(evnt.stopPropagation){
			    	evnt.stopPropagation();
			    }else{
			    	evnt.cancelBubble=true;
			    }
			    
			    var name = $(this).attr("name");
			    var id = getCurAllCheckBoxIdByName(name);//获取全选矿cui组件的id
			  	//如果当前为选中，判断全选是否被选中，是则取消选中
			    if(!$(this).is(':checked')&&$("#"+id).find(":checkbox").is(":checked")){//如果全选按钮是选中的
			    	$("#"+id).find(":checkbox").attr("checked",false);
			    	$("#"+id).find("label").css("color","black");
			    } else{
			    	var divId = getCurDivIdByName(name);
			    	if($("#"+divId).find(":checkbox").length==$("#"+divId).find("input[type=checkbox]:checked").length){
			    		cui("#"+id).selectAll();
			    	}
			    }
		});
		
		
		
		$(".lastcui").click(function(){
			$(this).parent().parent().parent().css("display","none");//内容区域
			$(this).parent().parent().parent().prev().find(".app_items_btn").css("display","none");
			$(this).parent().parent().parent().prev().find(".app_items_btn").siblings("img.place-right").show();
			
			//使用缓存记录下用户点击张开过的项
			if(cst.exists("appStorage")){
				var data = cst.use("appStorage").get("displayArea");
				data[$(this).parent().parent().parent().attr("id")] = $(this).parent().parent().parent().is(":visible");
				cst.use("appStorage").set("displayArea",data);
			}
		});
		
	});
	
	//根据当前checkbox的name获得其全选按钮的id
	function getCurAllCheckBoxIdByName(name){
		var reName = "";
		if(name=='entity'){
			reName = "checkAllEntity";
		}else if(name=='service'){
			reName = "checkAllService";
		}else if(name=='page'||name=='meta'){
			reName = "checkAllPage";
		}else if(name="testCase"){
			reName = "checkAllTest";
		}
		return reName;
	}
	
	//根据当前checkbox的name获得div容器的id
	function getCurDivIdByName(name){
		var reName = "";
		if(name=='entity'){
			reName = "entityPanelArea";
		}else if(name=='service'){
			reName = "servicePanelArea";
		}else if(name=='testCase'){
			reName = "testCasePanelArea";
		}else if(name=='page'||name=='meta'){
			reName = "pagePanelArea";
		}
		return reName;
	}
	
	//==================================全选按钮事件=====================================
	//实体全选
	function checkAllEntity(){
		var values = cui('#checkAllEntity').getValue(); 
		if(values &&  values.length == 1 && values[0] == 1){
			$('input[name="entity"]').attr("checked", true);
		} else {
			$('input[name="entity"]').attr("checked", false);
		}
	}
	
	//页面全选
	function checkAllPage(){
		var values = cui('#checkAllPage').getValue(); 
		if(values &&  values.length == 1 && values[0] == 1){
			$('input[name="page"]').attr("checked", true);
			$('input[name="meta"]').attr("checked", true);
		} else {
			$('input[name="page"]').attr("checked", false);
			$('input[name="meta"]').attr("checked", false);
		}
	}
	
	//服务全选
	function checkAllService(){
		var values = cui('#checkAllService').getValue(); 
		if(values &&  values.length == 1 && values[0] == 1){
			$('input[name="service"]').attr("checked", true);
		} else {
			$('input[name="service"]').attr("checked", false);
		}
	}
	
	//测试全选
	function checkAllTest(){
		var values = cui('#checkAllTest').getValue(); 
		if(values &&  values.length == 1 && values[0] == 1){
			$('input[name="testCase"]').attr("checked", true);
		} else {
			$('input[name="testCase"]').attr("checked", false);
		}
	}
	
	/**
	*根据操作类型刷新部分区域
	*
	*@operateType 操作类型 
	*/
	function refreshWindowByOperateType(operateType){
		dwr.TOPEngine.setAsync(false);
		if(operateType=="testCase"){
			TestCaseFacade.queryTestCaseList(funcFullCode,function(data){
				testCase = data;
			});
			testCaseSimpleQuery();
		}
		dwr.TOPEngine.setAsync(true);
	}
	
	/**
	*@更新数据后重建菜单
	*@type 类型
	*/
	function buildClickFn(type){
		var curId ;
		if(type==null||type==''){
			curId = "";
		}else if(type=='testCase'){
			curId = "#testCasePanelArea";
		}
		
		//更新数据后重建菜单
		$(curId+" .app_item").on("click",".colsebtn",function(e){
			var that = this;
			e.stopPropagation();
			cui.confirm('确认要删除信息吗？', {
				onYes: function(){
					var type = $(that).data("type"),id=$(that).data("id"),pagetype=$(that).data("pagetype");
					if(type="testCase"){
						delTestCase([id]);
					}
				},
				onNo: function(){
					//do nothing
				}
			});
		});
		
		$(".app_item li.first").click(function(){
			var name = $(":checkbox",this).attr("name");
			var id = getCurAllCheckBoxIdByName(name);//获取全选矿cui组件的id
			if($(":checkbox",this).is(':checked')){
				$(":checkbox",this).attr("checked",false);
				
			   	 //如果当前为选中，判断全选是否被选中，是则取消选中
				 if($("#"+id).find(":checkbox").is(":checked")){//如果全选按钮是选中的
				    	$("#"+id).find(":checkbox").attr("checked",false);
				    	$("#"+id).find("label").css("color","black");
				  } 
			}else{
				$(":checkbox",this).attr("checked",true);
				
				//如果全选按钮是未选中的,并且当前所有checkbox已选择 选中
				if(!$("#"+id).find(":checkbox").is(":checked")){
					var divId = getCurDivIdByName(name);
			    	if($("#"+divId).find(":checkbox").length==$("#"+divId).find("input[type=checkbox]:checked").length){
			    		cui("#"+id).selectAll();
			    	}
			  	} 
			}
		});
		
		$(".app_item li.first").find(":checkbox").click(function(arg){
				var evnt=window.event?window.event:arg;
			    if(evnt.stopPropagation){
			    	evnt.stopPropagation();
			    }else{
			    	evnt.cancelBubble=true;
			    }
			    
			    var name = $(this).attr("name");
			    var id = getCurAllCheckBoxIdByName(name);//获取全选矿cui组件的id
			  	//如果当前为选中，判断全选是否被选中，是则取消选中
			    if(!$(this).is(':checked')&&$("#"+id).find(":checkbox").is(":checked")){//如果全选按钮是选中的
			    	$("#"+id).find(":checkbox").attr("checked",false);
			    	$("#"+id).find("label").css("color","black");
			    } else{
			    	var divId = getCurDivIdByName(name);
			    	if($("#"+divId).find(":checkbox").length==$("#"+divId).find("input[type=checkbox]:checked").length){
			    		cui("#"+id).selectAll();
			    	}
			    }
		});
		
		
		$(".lastcui").click(function(e){
			$(this).parent().parent().parent().css("display","none");//内容区域
			$(this).parent().parent().parent().prev().find(".app_items_btn").css("display","none");
			$(this).parent().parent().parent().prev().find(".app_items_btn").siblings("img.place-right").show();
			
			//使用缓存记录下用户点击张开过的项
			if(cst.exists("appStorage")){
				var data = cst.use("appStorage").get("displayArea");
				data[$(this).parent().parent().parent().attr("id")] = $(this).parent().parent().parent().is(":visible");
				cst.use("appStorage").set("displayArea",data);
			}
			e.preventDefault();
			//return false;
		});
	}
	
	//关键字过滤
	function getRegKeyWord(keyword){
		keyword = keyword.replace(new RegExp("/", "gm"), "//");
		keyword = keyword.replace(new RegExp("%", "gm"), "/%");
		keyword = keyword.replace(new RegExp("_","gm"), "/_");
		keyword = keyword.replace(new RegExp("'","gm"), "''");
		return keyword;
	}
	
	/**
	*通过关键字和数据类型匹配arr内容返回新的arr
	*@keyword 关键字搜索
	*@arr 源数组
	*@dataTyp 传入的数据类型
	*@pulltype 仅当多种分类共用同一数据源数组时才传入pulldown类型
	*@return 返回匹配后的数组
	*/
	function parseArrayWithKeyWord(keyword,arr,dataTyp,pulltype){
		//如果不是实体，并且关键字为空  pulltype也为空
		if(dataTyp !='entity' && dataTyp!='page'  && dataTyp!='testCase' &&(keyword==null||keyword=="")){
			return arr;
		}else if(dataTyp=='entity'&&(keyword==null||keyword=="")&&(pulltype==""||pulltype=='0')){
			return arr;
		}else if(dataTyp=='page'&&(keyword==null||keyword=="")&&(pulltype==""||pulltype=='0')){
			return arr;
		}
		var reArr = [] ;
		var columnName = "";
		//根据pulltype判断取objItem里面的哪种类型
		if(dataTyp=='page'||dataTyp=='meta'||dataTyp=='entity'){//页面
			columnName = "modelName";
		}else if (dataTyp=='unDeploye'||dataTyp=='deploye') {//工作流
			columnName = "processId";
		}else if (dataTyp=='table'||dataTyp=='view'||dataTyp=='produce'||dataTyp=='function') {//数据库
			columnName = "engName";
		}else if (dataTyp=='workbenchConfig') {//工作台
			columnName = "processId";
		}else if (dataTyp=='service') {//服务
			columnName = 'englishName';
		}else if (dataTyp=='dictionary') {//数据项
			columnName = 'configItemName';
		}else if (dataTyp=='testCase') {//数据项
			columnName = 'name';
		}else{
			return arr;
		}
		for(var i=0;i<arr.length;i++){
			var objItem = arr[i];
			//如果是实体类型
			if (dataTyp=='entity'&&pulltype!='0'&&pulltype!="") {
				if(objItem['entityType']==pulltype&&compare(objItem[columnName],keyword)){
					reArr.push(objItem);
				}
			}else if(dataTyp=='dictionary'){
				if(compare(objItem[columnName]+objItem['configItemFullCode'],keyword)){
					reArr.push(objItem);
				}	
			}else if(dataTyp=='page'&&pulltype!='0'&&pulltype!=""){
				var pageType = pulltype=='page'?1:2;
				if(objItem['pageType']==pageType&&compare(objItem[columnName],keyword)){
					reArr.push(objItem);
				}	
			}else if(dataTyp=='testCase' && pulltype != '0' && pulltype != ""){
				if(objItem['type'] == pulltype && compare(objItem[columnName],keyword)){
						reArr.push(objItem);
				}
			}else{
				if (compare(objItem[columnName],keyword)){
					reArr.push(objItem);
				}
			}
			
		}
		return reArr;
	}
	
	//实体查询
	function entitySimpleQuery(){
		//每次查询的时候全选按钮不选择
		cui('#checkAllEntity').unSelectAll(); 
		//关键字查询
		var keyword = getRegKeyWord(cui("#entityClickInput").getValue());
		//下拉框
		var type = cui("#entityType").getValue();
		var entityArr = entity;
		//解析entityArr的内容 和keyword进行匹配
		var reEntityArr = [];
		reEntityArr = parseArrayWithKeyWord(keyword,entityArr,'entity',type);
		entityRender("entity",reEntityArr||[]);
		buildClickFn("entity");
	}
	
	//界面查询
	function pageSimpleQuery(){
		//每次查询的时候全选按钮不选择
		cui('#checkAllPage').unSelectAll(); 
		//关键字查询
		var keyword = getRegKeyWord(cui("#pageClickInput").getValue());
		//下拉框
		var type = cui("#pageType").getValue();
		var pageArr = page;
		var metaArr = pageMetadata
		if('page'==type||'userPage'==type){
			metaArr = [];
		}else if('meta'==type){
			pageArr = [];
		}
		
		//解析page和pageMetadata的内容 和keyword进行匹配
		var rePageArr = [];
		var reMetaArr = [];
		rePageArr = parseArrayWithKeyWord(keyword,pageArr,'page',type);
		reMetaArr = parseArrayWithKeyWord(keyword,metaArr,'meta',null);
		pageRender("page",rePageArr||[],reMetaArr||[]);
		buildClickFn("page");
	}
	
	//服务查询
	function serviceSimpleQuery(){
		//每次查询的时候全选按钮不选择
		cui('#checkAllService').unSelectAll(); 
		//关键字查询
		var keyword = getRegKeyWord(cui("#serviceClickInput").getValue());
		var serviceArr = service;//
		//解析page和pageMetadata的内容 和keyword进行匹配
		var reServiceArr = [];
		reServiceArr = parseArrayWithKeyWord(keyword,serviceArr,'service',null);
		serviceRender("service",reServiceArr||[]);
		buildClickFn("service");
	}
	
	//测试用例查询
	function testCaseSimpleQuery(){
		//每次查询的时候全选按钮不选择
		cui('#checkAllTest').unSelectAll();
		//关键字查询
		var keyword = getRegKeyWord(cui("#testCaseClickInput").getValue());
		//下拉框
		var type = cui("#testCaseType").getValue();
		//元数据下拉框
		var metadataModelId = cui("#pageList").getValue();
		var testCaseArr = testCase;
		//解析retestCaseArr的内容 和keyword进行匹配
		var retestCaseArr = [];
		retestCaseArr = parseArrayWithKeyWord(keyword,testCaseArr,'testCase',type);
		if(metadataModelId != 0){ //过滤界面和实体
			var newRetestCaseArr = [];
			newRetestCaseArr = parseArrayWithPageAndEntity(retestCaseArr,metadataModelId);
			testCaseRender("testCase",newRetestCaseArr||[]);
		}else{
			testCaseRender("testCase",retestCaseArr||[]);
		}
		buildClickFn("testCase");
	}
	
	//过滤界面
	function parseArrayWithPageAndEntity(retestCaseArr,modelId){
		var reArr = [] ;
		for(var i=0;i<retestCaseArr.length;i++){
			var objItem = retestCaseArr[i];
			var objItemMetadata = objItem.metadata;
			if(objItemMetadata){
				var metadataArr = objItemMetadata.split(":");
				if(metadataArr[0] == modelId){
					reArr.push(objItem);
				}
			}
		}
		return reArr;
	}

	//如果a包含b 或者b为""返回true
	/**
	* 验证a是否包含b b为""则直接返回 忽略大小写
	*@a 源字符串
	*@b 目标字符串
	*@return 如果a包含b 则返回true
	*/
	function compare(a,b){
		if(b==null||""==b){
			return true;
		}
		a=a.toLowerCase();
		b=b.toLowerCase();
		return a.indexOf(b)>=0;
	}
	
	
</script>
</body>
</html>