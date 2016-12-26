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
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/AppDetailAction.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/EntityFacade.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/PageFacade.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/MetadataPageConfigFacade.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/MetadataTmpTypeFacade.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/TableOperateAction.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/DictionaryOperateAction.js'></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/CipWorkFlowListAction.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/NewPageAction.js'></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/cfg/dwr/interface/ConfigItemAction.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.min.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/bm/common/cui/js/cui.utils.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/eic/js/comtop.ui.emDialog.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/eic/js/comtop.eic.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/bm/dev/consistency/js/consistency.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/ReqFunctionSubitemAction.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/BizObjInfoAction.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/PreferenceConfigAction.js'></script>
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
  -webkit-transition: all 0.5s ease-in-out 0.1s;
  -moz-transition: all 0.5s ease-in-out 0.1s;
  -o-transition: all 0.5s ease-in-out 0.1s;
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
	    <span uitype="button" id="upload" label="pdm导入"  on_click="upload" ></span>
		<span uitype="button" id="exportWord" label="导出文档"  menu="exportWord" ></span>
		<span uitype="Button" id="assignRight" label="分配" button_type="" icon="pencil-square-o" on_click="assignRight"></span>
		<span uitype="Button" id="storeUp" label="收藏" button_type="" icon="pencil-square-o" on_click="storeUp"></span>
		<span uitype="Button" id="cancelStore" label="取消收藏" button_type="" icon="pencil-square-o" on_click="cancelStore"></span>
		<span uitype="Button" id="quickBuild" label="快速构建" button_type="" icon="pencil-square-o" on_click="quickBuild"></span>
		<span uitype="Button" id="returnEditFunc" label="返回" button_type="green-button" icon="reply" on_click="returnEditFunc"></span>
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
					<span uitype="button" label="新增" id="menu_add_entity"  menu="menu_add_entity"></span>
					<span uitype="Button" label="导入" mark="importEntity" on_click="openEntityWindowOrUrl"></span>
					<span uitype="Button" label="删除" on_click="entityDelete"></span>
					<span uitype="button" label="生成代码" id="button_entityGenerateCode"  menu="menu_entity_gen_data"></span>
				</div>
				<img class="place-right" src="image/off.png">
				<!-- <hr> -->
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
						<span uitype="button" label="新增" id="menu_add_page"  menu="menu_add_page"></span>
						<span uitype="Button" label="预览" icon="desktop" onclick="preview()"></span>
						<span uitype="Button" label="删除" on_click="pageOrMetaDel"></span>
						<span uitype="button" label="生成代码" id="button_pageGenerateCode"  menu="menu_page_gen_data"></span>
					</div>
				<img class="place-right" src="image/off.png">
				<!-- <hr> -->
			</div>
				<div class="app_items"  id="pagePanel">
					
					<div style="clear:both;" ></div> 
					<div class="app_items_content"  id="pagePanelArea">
					</div>
				</div>
		</div>
		<div class="app_attr clearfix">
			<div class="app-category clearfix">
				<div class="place-left"><font color="">工作流</font><em id="workflowPanelCount"></em></div>
				<div class="app_items_btn" >
					<span uitype="checkboxGroup" id="checkAllWorkflow" name="checkAllWorkflow" on_change="checkAllWorkflow">
					 		<input type="checkbox" name="checkWorkflow"   value="1"> 全选
					</span>
					<span uiType="ClickInput" width="200px" id="workflowClickInput" name="workflowClickInput" enterable="true" emptytext="请输入名称关键字查询" editable="true" width="300" on_iconclick="workflowSimpleQuery" 
				 			 on_keyup="workflowSimpleQuery" 	icon="search" iconwidth="18px"></span> 
			 		<span uiType="PullDown" mode="Single" editable="false" id="workflowType" datasource="initWorkflowType"  label_field="text" value_field="id"  width="80"  on_change="workflowSimpleQuery"></span>
					<span uitype="Button" label="新增" on_click="addWorkflow"></span>
					<span uitype="Button" label="删除" on_click="workflowBatchDel"></span>
				</div>
				<img class="place-right" src="image/off.png">
				<!-- <hr> -->
			</div>
			<div class="app_items"  id="workflowPanel">
				
				<div style="clear:both;" ></div> 
				<div class="app_items_content"  id="workflowPanelArea">
				</div>
			</div>
		</div>
		<div class="app_attr clearfix">
			<div class="app-category clearfix">
				<div class="place-left"><font color="">数据库</font><em id="databasePanelCount"></em></div>
				<div class="app_items_btn" >
					<span uitype="checkboxGroup" id="checkAllDatabase" name="checkAllDatabase" on_change="checkAllDatabase">
					 		<input type="checkbox" name="checkDatabase"   value="1"> 全选
					</span>
					<span uiType="ClickInput" width="200px" id="databaseClickInput" name="databaseClickInput" enterable="true" emptytext="请输入名称关键字查询" editable="true" width="300" on_iconclick="databaseSimpleQuery" 
				 			 on_keyup="databaseSimpleQuery" 	icon="search" iconwidth="18px"></span> 
			 		<span uiType="PullDown" mode="Single" editable="false" id="databaseType" datasource="initDatabaseType"  label_field="text" value_field="id"  width="80"  on_change="databaseSimpleQuery"></span>
					<span uitype="button" label="新增" id="menu_add_database"  menu="menu_add_database"></span>
					<span uitype="Button" label="删除" on_click="databaseBatchDel"></span>
					<span uitype="button" label="导出SQL" id="menu_gen_database_SQL"  menu="menu_gen_database_SQL"></span>
				</div>
				<img class="place-right" src="image/off.png">
				<!-- <hr> -->
			</div>
			<div class="app_items"  id="databasePanel">
				
				<div style="clear:both;" ></div> 
				<div class="app_items_content"  id="databasePanelArea">
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
					<span uitype="Button" label="新增" on_click="addNewService"></span>
					<span uitype="Button" label="删除" on_click="serviceBatchDel"></span>
				</div>
				<img class="place-right" src="image/off.png">
				<!-- <hr> -->
			</div>
			<div class="app_items" id="servicePanel">
				
				<div style="clear:both;" ></div> 
				<div class="app_items_content"  id="servicePanelArea">
				</div>
			</div>
		</div>
		<div class="app_attr clearfix">
			<div class="app-category clearfix">
				<div class="place-left"><font color="">数据项</font><em id="dictionaryPanelCount"></em></div>
				<div class="app_items_btn" >
					<span uitype="checkboxGroup" id="checkAllDictionary" name="checkAllDictionary" on_change="checkAllDictionary">
					 		<input type="checkbox" name="checkDictionary"   value="1"> 全选
					</span>
					<span uiType="ClickInput" width="200px" id="dictionaryClickInput" name="dictionaryClickInput" enterable="true" emptytext="请输入名称关键字查询" editable="true" width="300" on_iconclick="dictionarySimpleQuery" 
				 			 on_keyup="dictionarySimpleQuery" 	icon="search" iconwidth="18px"></span> 
					<span uitype="Button" label="新增" on_click="openDicPage"></span>
					<span uitype="Button" label="导出SQL" on_click="batchExportDicSQL"></span>
				</div>
				<img class="place-right" src="image/off.png">
				<!-- <hr> -->
			</div>
			<div class="app_items"  id="dictionaryPanel">
				
				<div style="clear:both;" ></div> 
				<div class="app_items_content"  id="dictionaryPanelArea">
				</div>
			</div>
		</div>
		<div class="app_attr clearfix">
			<div class="app-category clearfix">
				<div class="place-left"><font color="">工作台配置</font><em id="workbenchConfigPanelCount"></em></div>
				<div class="app_items_btn" >
					<span uitype="checkboxGroup" id="checkAllWorkbench" name="checkAllWorkbench" on_change="checkAllWorkbench">
					 		<input type="checkbox" name="checkWorkbench"   value="1"> 全选
					</span>
					<span uiType="ClickInput" width="200px" id="workbenchConfigClickInput" name="workbenchConfigClickInput" enterable="true" emptytext="请输入名称关键字查询" editable="true" width="300" on_iconclick="workbenchConfigSimpleQuery" 
				 			 on_keyup="workbenchConfigSimpleQuery" 	icon="search" iconwidth="18px"></span> 
					<span uitype="Button" label="新增" on_click="addWorkbenchConfig"></span>
					<span uitype="Button" label="删除" on_click="workbenchBatchDel"></span>
				</div>
				<img class="place-right" src="image/off.png">
				<!-- <hr> -->
			</div>
			<div class="app_items"  id="workbenchConfigPanel">
				<div style="clear:both;" ></div> 
				<div class="app_items_content"  id="workbenchConfigPanelArea">
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
					<li class="main" target="_blank" title="<@=item.modelName@>" data-mainframe="false" data-url="<@=editEntityUrl@>&modelId=<@=item.modelId@>&entitySource=<@=item.entitySource@>&entityType=<@=item.entityType@>">
						<div class="item_content" >
							<img src="<@ if(item.entityType == "biz_entity"){ @>image/biz_entity.png<@}else if(item.entityType == "query_entity"){ if(item.entitySource == "exist_entity_input"){@>image/exist_entity.png<@}else{@>image/query_entity.png<@}}else if(item.entityType == "data_entity"){if(item.entitySource == "exist_entity_input"){@>image/exist_entity.png<@}else{@>image/data_entity.png<@}}@>">
							<span><@=item.modelName@></span>
						</div>
						<i class="colsebtn" data-id="<@=item.modelId@>" data-type="<@=id@>"></i>
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
							<span><@ if(item.pageType == 1){ @>[页面]<@}else{@>[自定义]<@}@><@=item.modelName@></span>
						</div>
						<i class="colsebtn" data-id="<@=item.modelId@>" data-type="<@=id@>" data-pagetype="page"></i>
					</li>
				</ul>
			</li>
	<@})@>
	 <@ _.each(metaDatas,function(item){ @>
		<li>
				<ul  class="app_item">
					<li class="first">
						<div class="item_checkbox"><input type="checkbox" name="meta"  value="<@=item.modelId@>"/> </div>
					</li>
					<li class="main" target="_blank" title="[模板]<@=item.modelName@>" data-mainframe="false" data-url="<@=editMetadataGenerateUrl@>&metadataGenerateModelId=<@=item.modelId@>">
						<div class="item_content" >
							<!--<i class="cui-icon">&#xf0c2;</i>-->
							<img src="image/template.png">
							<span>[模板]<@=item.modelName@></span>
						</div>
						<i class="colsebtn" data-id="<@=item.modelId@>" data-type="<@=id@>" data-pagetype="metaData"></i>
					</li>
				</ul>
			</li>
	<@})@>
	<li class="lastcui" ><img  src="image/on.png"></img></li>
<ul>
</script>
<!-- 工作流展现方式 -->
<script type="text/template" id="workflowTemplate">
<ul>
		<@ _.each(datas,function(item){ @>
			<li>
				<ul  class="app_item">
					<li class="first">
						<div class="item_checkbox"><input type="checkbox" name="unDeploy"  value="<@=item.deployeId@>"/> </div>
					</li>
					<li class="main" target="_blank" title="[草稿]<@=item.processId@>" data-mainframe="false" data-url="<@=unUrl@>&deployId=<@=item.deployeId@>">
						<div class="item_content" >
							<img src="image/undeploy.png">
							<span>[草稿]<@=item.processId@></span>
						</div>
						<i class="colsebtn" data-id="<@=item.deployeId@>" data-type="unDeployWorkflow"></i>
					</li>
				</ul>
			</li>
		<@})@>
		<@ _.each(deDatas,function(item){ @>
			<li>
				<ul  class="app_item">
					<li class="first">
						<div class="item_checkbox"><input type="checkbox" name="deploy"  value="<@=item.deployeId@>"/> </div>
					</li>
					<li class="main" target="_blank" title="[已部署]<@=item.processId@>" data-mainframe="false" data-url="<@=deUrl@>&deployId=<@=item.deployeId@>">
						<div class="item_content" >
							<img src="image/deploy.png">
							<span>[已部署]<@=item.processId@></span>
						</div>
						<i class="colsebtn" data-id="<@=item.deployeId@>" data-type="deployWorkflow"></i>
					</li>
				</ul>
			</li>
		<@})@>
		<li class="lastcui" ><img  src="image/on.png"></img></li>
</ul>
</script>
<!-- 工作台配置  -->
<script type="text/template" id="workbenchConfigTemplate">
<ul>
		<@ _.each(datas,function(item){ @>
			<li>
				<ul  class="app_item">
					<li class="first">
						<div class="item_checkbox"><input type="checkbox" name="workbench"  value="<@=item.processId@>"/> </div>
					</li>
					<li class="main" target="_blank" title="[配置流程]<@=item.processId@>" data-mainframe="false" data-url="<@=workbenchConfigUrl@>&modelId=<@=item.processId@>&packageModuleCode=<@=item.packageModuleCode@>">
						<div class="item_content" >
							<img src="image/workbench.png">
							<span>[配置流程]<@=item.processId@></span>
						</div>
						<i class="colsebtn" data-id="<@=item.processId@>" data-type="workbenchConfig"></i>
					</li>
				</ul>
			</li>
		<@})@>
		<li class="lastcui" ><img  src="image/on.png"></img></li>
</ul>
</script>

<!-- 数据库展现方式 -->
<script type="text/template" id="databaseTemplate">
<ul>
		<@ _.each(datas,function(item){ @>
			<li>
				<ul  class="app_item">
					<li class="first">
						<div class="item_checkbox"><input type="checkbox" name="table"  value="<@=item.modelId@>"/> </div>
					</li>
					<li class="main" target="_blank" title="[表]<@=item.engName@>" data-mainframe="false" data-url="<@=editTableUrl@>&modelId=<@=item.modelId@>">
						<div class="item_content" >                                      
							<img src="image/table.png">
							<span>[表]<@=item.engName@></span>
						</div>
						<i class="colsebtn" data-id="<@=item.modelId@>" data-type="delTable"></i>
					</li>
				</ul>
			</li>
		<@})@>
		<@ _.each(viewDatas,function(item){ @>
			<li>
				<ul  class="app_item">
					<li class="first">
						<div class="item_checkbox"><input type="checkbox" name="view"  value="<@=item.modelId@>"/> </div>
					</li>
					<li class="main" target="_blank" title="[视图]<@=item.engName@>" data-mainframe="false"  data-url="<@=editViewUrl@>&modelId=<@=item.modelId@>">
						<div class="item_content" >
							<img src="image/view.png">
							<span>[视图]<@=item.engName@></span>
						</div>
						<i class="colsebtn" data-id="<@=item.modelId@>" data-type="delView"></i>
					</li>
				</ul>
			</li>
		<@})@>
		<@ _.each(produceDatas,function(item){ @>
			<li>
				<ul  class="app_item">
					<li class="first">
						<div class="item_checkbox"><input type="checkbox" name="produce"  value="<@=item.modelId@>"/> </div>
					</li>
					<li class="main" target="_blank" title="[存储过程]<@=item.engName@>" data-mainframe="false"  data-url="<@=editProduceUrl@>&modelId=<@=item.modelId@>">
						<div class="item_content" >
							<img src="image/produce.png">
							<span>[存储过程]<@=item.engName@></span>
						</div>
						<i class="colsebtn" data-id="<@=item.modelId@>" data-type="delProduce"></i>
					</li>
				</ul>
			</li>
		<@})@>
		<@ _.each(functionDatas,function(item){ @>
			<li>
				<ul  class="app_item">
					<li class="first">
						<div class="item_checkbox"><input type="checkbox" name="function"  value="<@=item.modelId@>"/></div>
					</li>
					<li class="main" target="_blank" title="[函数]<@=item.engName@>" data-mainframe="false" data-url="<@=editFunctionUrl@>&modelId=<@=item.modelId@>">
						<div class="item_content" >
							<img src="image/function.png">
							<span>[函数]<@=item.engName@></span>
						</div>
						<i class="colsebtn" data-id="<@=item.modelId@>" data-type="delFunction"></i>
					</li>
				</ul>
			</li>
		<@})@>
		<li class="lastcui" ><img  src="image/on.png"></img></li>
</ul>
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
						<i class="colsebtn" data-id="<@=item.modelId@>" data-type="<@=id@>"></i>
					</li>
				</ul>
			</li>
		<@})@>
		<li class="lastcui" ><img  src="image/on.png"></img></li>
</ul>
</script>
<!-- 数据项展现方式 -->
<script type="text/template" id="dictionaryTemplate">
<ul>
		<@ _.each(datas,function(item){ @>
			<li>
				<ul  class="app_item">
					<li class="first">
						<div class="item_checkbox"><input type="checkbox" name="dictionary"  value="<@=item.configItemFullCode@>"/> </div>
					</li>
					<li class="main" target="_blank" title="<@=item.configItemName@>[<@=item.configItemFullCode@>]" data-mainframe="false" onclick="openDicEditPage('<@=editDicUrl@>&configItemId=<@=item.configItemId@>&dataType=<@=item.configItemType@>')">
						<div class="item_content" >
							<img src="image/dictionary.png">
							<span><@=item.configItemName@>[<@=item.configItemFullCode@>]</span>
						</div>
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
	
	//导出文档 
	var exportWord = {
	    	datasource: [
	     	            {id:'exportLLD',label:'详细设计说明书'},
	     	            {id:'exportDBD',label:'数据库设计说明书'}
	     	        ],
			on_click:function(obj){
	     	        	if(obj.id=='exportHLD'){
	     	        		exportWordMain('HLD');
	     	        	}else if(obj.id=='exportLLD'){
	     	        		exportWordMain('LLD');
	     	        	}else if(obj.id=='exportDBD'){
	     	        		exportWordMain('DBD');
	    	        	}
			}
	};
	
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
			workflowPanel:false,
			databasePanel:false,
			dictionaryPanel:false
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
	//草稿流程 
	var unDeployeWorkflow;
	//已部署流程
	var deployeWorkflow;
	//数据表信息
	var tables;
	//视图信息
	var views;
	//存储过程信息
	var produces;
	//函数信息
	var functions;
	//应用下的数据项信息
	var dictionary;
	//工作台配置信息
	var workbenchConfig;	
	//数据库类型
	var dbType;
	
	//==================应用下的数据查询区域==========================================================
	dwr.TOPEngine.setAsync(false);
	var app = {"id" : myAppId,"employeeId":globalCapEmployeeId,"appId":funcId,"appType":2};
	var query = {configClassifyId:funcId,sysModule:"Yes"};
	AppDetailAction.getInitMetaData(funcId, app, query, function(data){
		func = data.func;
		funcFullCode = func.fullPath;
		appVO = data.appVO;
		entity = data.entity;
		page = data.page;
		pageMetadata = data.pageMetadata;
		unDeployeWorkflow = data.unDeployeWorkflow;
		deployeWorkflow = data.deployeWorkflow;
		workbenchConfig = data.workbenchConfig;
		tables = data.tables;
		views = data.views;
		produces = data.produces;
		functions = data.functions;
		service = data.service;
		dictionary = data.dictionary;
		dbType = data.dbType;
	});
	dwr.TOPEngine.setAsync(true);
	
	//元数据链接 - 新版实体
	var addBizEntityUrl;
	var addQueryEntityUrl;
	var addDataEntityUrl;
	var addExistQueryEntityUrl;
	var addExistDataEntityUrl;
	var editEntityUrl;
	var importEntityUrl;
	addBizEntityUrl = "<%=request.getContextPath() %>/cap/bm/dev/entity/EntityNameEdit.jsp?modelId=&entityType=biz_entity&packageId=" + funcId+"&moduleCode="+func.funcCode+"&entitySource=table_metadata_import";
	addQueryEntityUrl = "<%=request.getContextPath() %>/cap/bm/dev/entity/EntityNameEdit.jsp?modelId=&entityType=query_entity&packageId=" + funcId+"&moduleCode="+func.funcCode+"&entitySource=user_create";
	addDataEntityUrl = "<%=request.getContextPath() %>/cap/bm/dev/entity/EntityNameEdit.jsp?modelId=&entityType=data_entity&packageId=" + funcId+"&moduleCode="+func.funcCode+"&entitySource=user_create";
	addExistQueryEntityUrl = "<%=request.getContextPath() %>/cap/bm/dev/entity/EntityNameEdit.jsp?modelId=&entityType=query_entity&packageId=" + funcId+"&moduleCode="+func.funcCode+"&entitySource=exist_entity_input";
	addExistDataEntityUrl = "<%=request.getContextPath() %>/cap/bm/dev/entity/EntityNameEdit.jsp?modelId=&entityType=data_entity&packageId=" + funcId+"&moduleCode="+func.funcCode+"&entitySource=exist_entity_input";
	editEntityUrl = "<%=request.getContextPath() %>/cap/bm/dev/entity/EntityMain.jsp?packageId=" + funcId+"&moduleCode="+func.funcCode;
    importEntityUrl = "<%=request.getContextPath() %>/cap/bm/dev/entity/EntityImport.jsp?packageId=" + funcId;
	
	//实体导入成功回调
	function importCallback(){
		window.setTimeout('refresh()',600);
	}
	
	var entityNamedialog;
	//打开实体名称编辑页面
	function openEntityName(entityType){
		var height = 200;
		var width = 450;
		var url ="";
		var strTitle='实体新增';
		if(entityType=="biz_entity") {
			//url = addBizEntityUrl;
			cui.confirm("新增业务实体只能通过导入数据表的方式创建，是否创建业务实体?",{
				onYes:function(){
					window.open(importEntityUrl);
				}
			});
			return;
		}else if(entityType=="query_entity"){
			url = addQueryEntityUrl;
			strTitle='新增查询实体';
		}else if(entityType=="data_entity"){
			url = addDataEntityUrl;
			strTitle='新增数据实体';
		}else if(entityType=="exist_query_entity"){
			url = addExistQueryEntityUrl;
			strTitle='录入已有查询实体';
		}else if(entityType=="exist_data_entity"){
			url = addExistDataEntityUrl;
			strTitle='录入已有数据实体';
		}
// 		if(!entityNamedialog){
		entityNamedialog = cui.dialog({
		  	title : strTitle,
		  	src : url,
		    width : width,
		    height : height
		});
// 		}
		entityNamedialog.show(url);
	}
	
	var entity;
	//实体名称编辑回调
	function saveEntityNameCallBack(entity,openType,moduleCode){
			entity.modelType="entity";
		    entity.modelName=entity.engName;
		    entity.modelId=entity.modelPackage+"."+entity.modelType+"."+entity.modelName;
		    dwr.TOPEngine.setAsync(false);
			   EntityFacade.saveEntity(entity,function(result){
				  if(result){
					  refresh();//刷新页面
				  }
			   });
			dwr.TOPEngine.setAsync(true);
			var url = "<%=request.getContextPath() %>/cap/bm/dev/entity/EntityMain.jsp?modelId=" + entity.modelId + "&packageId=" + entity.packageId + "&entityType="+entity.entityType+"&moduleCode="+moduleCode+"&openType="; 
			if(entityNamedialog){
				entityNamedialog.hide();
			}
			window.open(url, "_blank");
	}
	
	//关闭实体名称编辑窗口
	function closeEntityNameWindow(){
		entityNamedialog.hide();
	}
	
	
	//实体代码生成
	function generateCode(type){
		var strTitle =""; 
		if(type==0){
		     strTitle = "是否要生成当前模块所选实体代码（除录入已有实体）？";
		}else if(type==1){
			 strTitle = "是否要生成当前模块所选实体VO代码？";
		}else if(type==2){
			 strTitle = "是否要生成当前模块所选实体业务代码？";
		}else if(type==3){
			 strTitle = "是否要生成当前模块所选实体SQL脚本？";
		}
		//获取当前所选实体
		var selectData = [];
		var reArrData = [];
		$('input[name="entity"]:checked').each(function(){ 
			reArrData.push($(this).val()); 
		});
		
		//根据selectData过滤并获取最新元数据
		dwr.TOPEngine.setAsync(false);
		AppDetailAction.queryEntityVOByIds(reArrData,funcId, function(data){
			selectData = data;
		});
		dwr.TOPEngine.setAsync(true);
		//判断是否选中了数据
		if (selectData == null || selectData.length == 0) {
			cui.alert("请选择实体(除录入已有实体)。");
			return;
		}
		//实体代码生成前的数据完整性效验
		if(!checkEntityInfo(selectData)) return;
		cui.confirm(strTitle,{
			onYes:function(){
				createCustomHM("entity");//funcId 包路径
				AppDetailAction.executeGenerateCode(selectData,funcId, type, function(msg){
						objHandleMask.hide();
						if ("" == msg ){
							window.top.cui.message('生成代码成功。','success');
						}else{
							window.top.cui.message(msg,'success');
						}
					});
			}
		});
	}

	//检查实体元素完整性
	function checkEntityInfo(selectDataArr){
		var msg = "";
		var checkFlag = true;
		for(var i=0;i<selectDataArr.length;i++){
			if(selectDataArr[i].state == false){
				var index = i+1;
				msg+=index+"、实体"+selectDataArr[i].engName+"是暂存状态不能生成代码！<br>"
				checkFlag = false;
			}
		}
		if(!checkFlag){
			cui.alert("<strong>数据校验失败</strong><br/><font color='red'>" + msg + "</font>",null,{width:400});
		} 
		return checkFlag;
	}

	var objHandleMask;
	//生成遮罩层
	function createCustomHM(type){
		if(type == "entity"){
			objHandleMask = cui.handleMask({
		        html:'<div style="padding:10px;border:1px solid #666;background: #fff;"><div class="handlemask_image_1"/><br/>正在生成实体，预计需要2~3分钟，请耐心等待。</div>'
		    });
		}else{
			objHandleMask = cui.handleMask({
		        html:'<div style="padding:10px;border:1px solid #666;background: #fff;"><div class="handlemask_image_1"/><br/>正在生成界面，预计需要2~3分钟，请耐心等待。</div>'
		    });
		}
		
		objHandleMask.show();
	}

	//元数据链接 - 新版界面
	var addPageUrl;
	var addTemplateURL;
	var fromTemplateUrl;
	var copyFromOtherUrl;
	var addDefinedPageUrl;
	var editPageMainUrl;
	var editSelfPageUrl;
	var workbenchConfigUrl;
	addPageUrl = "<%=request.getContextPath() %>/cap/bm/dev/page/designer/PageMain.jsp?packageId=" + funcId;
	addTemplateURL = "<%=request.getContextPath() %>/cap/bm/dev/page/template/EditMetadataTmpType.jsp?operationType=add&parentemplateTypeCode=pageMetadataTmp";
	fromTemplateUrl = "<%=request.getContextPath() %>/cap/bm/dev/page/template/MetadataTmpSelect.jsp?packageId=" + funcId;
	copyFromOtherUrl = "<%=request.getContextPath() %>/cap/bm/dev/page/designer/CopyPageListMain.jsp?systemModuleId=" + funcId+"&openType=copyPage";
	addDefinedPageUrl = "<%=request.getContextPath() %>/cap/bm/dev/page/designer/EntrySelfPage.jsp?modelId=&packageId=" + funcId;
	editPageMainUrl = "<%=request.getContextPath() %>/cap/bm/dev/page/designer/PageMain.jsp?packageId=" + funcId;
	editMetadataGenerateUrl = "<%=request.getContextPath() %>/cap/bm/dev/page/template/MetadataGenerateEdit.jsp?packageId=" + funcId+"&operationType=edit";
	editSelfPageUrl = "<%=request.getContextPath() %>/cap/bm/dev/page/designer/EntrySelfPage.jsp?packageId=" + funcId;
	workbenchConfigUrl="<%=request.getContextPath() %>/cap/bm/dev/page/designer/WorkflowWorkbenchEdit.jsp?viewType=metadata&packageId=" + funcId;
	
	//界面代码生成
	function generatePageCode(){
		//获取当前所选页面
		var selectData = [];
		var reArrData = [];
		$('input[name="page"]:checked').each(function(){ 
			reArrData.push($(this).val()); 
		});
		//根据selectData从page里面获取对应的数据
		selectData = parsePageDateUnWithUserDefined(reArrData);
		if (selectData == null || selectData.length == 0) {
			cui.alert("请选择页面(除自定义页面、暂存页面以及模板)。");
			return;
		}else{
			//获取选择页面对象信息
			var selectPages=[];
			for(var i=0; i<selectData.length; i++){
				for(var j=0; j<page.length; j++){
					var selectPage = page[j];
					if(selectData[i]==selectPage.modelId){
						selectPages.push(selectPage);
					}
				}
			}
			var validateMessage = "";
			for(var i=0, len=selectPages.length; i<len; i++){
				var selectedRowData = selectPages[i];
				if(selectedRowData.pageType==2){
					validateMessage += "页面："+selectedRowData.cname+"是自定义界面不能生成代码！</br>"
				}
				if(!selectedRowData.state){
					validateMessage += "页面："+selectedRowData.cname+"是暂存状态不能生成代码！</br>"
				}
			}
			if(validateMessage != ""){
				cui.alert(validateMessage, null, {width: 400});
				return;
			}
		}
		cui.confirm("是否要生成当前模块所选页面（除自定义页面、暂存页面以及模板）代码？",{
			onYes:function(){
				createCustomHM("page");//funcId 包路径
				NewPageAction.generateByIdList(selectData,getModelPackage(),function(result){
					objHandleMask.hide();
				});
			},
			width: 450
		});
	}
	
	//根据已选择的下拉框数据获取除掉自定义类型的modeleId
	function parsePageDateUnWithUserDefined(selectData){
		var reData = [];
		for(var i=0;i<selectData.length;i++){
			for(var j=0;j<page.length;j++){
				var item = page[j];
				if(selectData[i]==item['modelId']&&item['pageType']!=2){
					reData.push(item['modelId']);
				}
			}
		}
		return reData;
	}
	
	/* //原有的界面生成
	function generateAllPageCode(){
		
		cui.confirm("是否要生成当前模块所有界面（除自定义界面以及暂存页面）代码？",{
			onYes:function(){
				createCustomHM("page");//funcId 包路径
				NewPageAction.generateByPackageName(getModelPackage(),function(result){
					objHandleMask.hide();
				});
			},
			width: 450
		});
	} */
	
	var ConfigItemListDialog;
	
	//配置项新增页面
	function openDicPage(){
		openDicEditPage(null);
	}
	//导出数据项SQL语句
	function batchExportDicSQL(){
		//获取当前所选页面
		var selectData = [];
		//获取选择的表modelId
		$('input[name="dictionary"]:checked').each(function(){ 
			selectData.push($(this).val()); 
		});
		if (selectData == null || selectData.length == 0) {
			cui.alert("请选择要导出的配置项。");
			return;
		}else {
			dwr.TOPEngine.setAsync(false);
			DictionaryOperateAction.genCreateDicSQL(selectData,funcFullCode,{
        		callback: function(msg) {
        			if(msg!=null){
        				cui.alert("导出数据项SQL成功。SQL存放路径为："+ msg);
        			}else{
        				cui.alert('导出数据项SQL失败。');
        			}
        		},
        		errorHandler: function(message, exception) {
        			cui.alert('导出数据项SQL失败。');
        		}
        	});
        	dwr.TOPEngine.setAsync(true);
		}
	}
	
	//打开配置项（数据字典/数据维护）新增页面
	function openDicEditPage(uri){
		var dialogURL;
		if(uri){
			dialogURL = uri;
		}else{
			dialogURL = addDicUrl;
		}
		
		var height = 420;
		var width = 750;
		if(!ConfigItemListDialog){
			ConfigItemListDialog = cui.dialog({
			  	title : "配置项编辑",
			  	src : dialogURL,
			    width : width,
			    height : height
			});
		}
		ConfigItemListDialog.show(dialogURL);
	}
	
	/*
	 * 生成典型模板界面相关方法
	 * see /cap/bm/dev/page/designer/js/pageList.js
  	 */
  	 
	//获取包路径
	function getModelPackage(){
		dwr.TOPEngine.setAsync(false);
		var modelPackage="";
		PageFacade.loadModel("",funcId,function(result){
			modelPackage = result.modelPackage;
		});
		dwr.TOPEngine.setAsync(true);
		return modelPackage;
	}
	//获取首选项中配置的工程路径
	function getProjectDir(){
		//首选项配置的工程路径
		var projectDir;
		dwr.TOPEngine.setAsync(false);
		PreferenceConfigAction.getProjectDir(function(result){
			projectDir = result;
		});
		dwr.TOPEngine.setAsync(true);
		return projectDir;
	}
	//复制页面选中的页面，回调
	function selectPageData(selectPageDate){
		var inserPageModelPackage = "";
		dwr.TOPEngine.setAsync(false);
		PageFacade.loadModel("",funcId,function(result){
			inserPageModelPackage = result.modelPackage;
		});
		dwr.TOPEngine.setAsync(true);
    	var modelId = selectPageDate.modelId;
     	param="?modelId="+modelId+"&packageId="+funcId+"&saveType=pageTemplate&modelPackage="+inserPageModelPackage;
		window.open("<%=request.getContextPath() %>/cap/bm/dev/page/designer/PageMain.jsp"+param, "_blank");
	}
	
	//元素超链接-工作流
	var addUnDeployWorkflowUrl;
	var editUnDeployWorkflowUrl;//需要带上deployId= deployId
	var editDeployWorkflowUrl;//需要带上deployId= deployId
	addUnDeployWorkflowUrl = '<%=request.getContextPath() %>/bpms/flex/DesignerUI.jsp?perID='+globalUserId+'&perAct='+userAccount+'&perPwd='+userPassword+'&perAlias='+globalUserName+'&webRootUrl='+webPath+'&fileType=undeploy&operateType=newFile&timeStamp='+ new Date().getTime();
	editUnDeployWorkflowUrl = '<%=request.getContextPath() %>/bpms/flex/DesignerUI.jsp?perID='+globalUserId+'&perAct='+userAccount+'&perPwd='+userPassword+'&perAlias='+globalUserName+'&webRootUrl='+webPath+'&fileType=undeploy&operateType=editFile&timeStamp='+ new Date().getTime();
	editDeployWorkflowUrl = '<%=request.getContextPath() %>/bpms/flex/DesignerUI.jsp?perID='+globalUserId+'&perAct='+userAccount+'&perPwd='+userPassword+'&perAlias='+globalUserName+'&webRootUrl='+webPath+'&fileType=deploy&operateType=editFile&timeStamp='+ new Date().getTime();
	var addWorkbenchConfigUrl = "<%=request.getContextPath() %>/cap/bm/dev/page/designer/WorkflowWorkbenchEdit.jsp?packageId=" + funcId+"&packageModuleCode="+func.funcCode+"&viewType=NewWay";
	//元素超链接 - 数据库
	var impViewUrl;
	var impProduceUrl;
	var impFunctionUrl;
	var impBizObjUrl;
	var editTableUrl;
	var editViewUrl;
	var editProduceUrl;
	var editFunctionUrl;
	impViewUrl = "<%=request.getContextPath() %>/cap/bm/dev/database/ViewImport.jsp?packageId=" + funcId +"&packagePath="+funcFullCode;
	impProduceUrl = "<%=request.getContextPath() %>/cap/bm/dev/database/ProcedureImport.jsp?packageId=" + funcId +"&packagePath="+funcFullCode;
	impFunctionUrl = "<%=request.getContextPath() %>/cap/bm/dev/database/FunctionImport.jsp?packageId=" + funcId +"&packagePath="+funcFullCode;
	impBizObjUrl = "<%=request.getContextPath() %>/cap/bm/biz/info/SelectBizObjectMain.jsp?packageId=" + funcId +"&packagePath="+funcFullCode+"&tabLen=1&showValueFlag=false";
	if (dbType == "oracle") {
		editTableUrl = "<%=request.getContextPath() %>/cap/bm/dev/database/TableModelEdit.jsp?packageId=" + funcId + "&packagePath=" + funcFullCode + "&funcCode=" + func.funcCode;
	} else if (dbType == "mysql") {
		editTableUrl = "<%=request.getContextPath() %>/cap/bm/dev/database/TableModelEdit_mysql.jsp?packageId=" + funcId + "&packagePath=" + funcFullCode + "&funcCode=" + func.funcCode;
	} else {
	    editTableUrl = "<%=request.getContextPath() %>/cap/bm/dev/database/TableModelEdit.jsp?packageId=" + funcId + "&packagePath=" + funcFullCode + "&funcCode=" + func.funcCode;
	}
	editViewUrl = "<%=request.getContextPath() %>/cap/bm/dev/database/ViewModelView.jsp?packageId=" + funcId +"&packagePath="+funcFullCode;
	editProduceUrl = "<%=request.getContextPath() %>/cap/bm/dev/database/ProcedureModelView.jsp?packageId=" + funcId +"&packagePath="+funcFullCode;
	editFunctionUrl = "<%=request.getContextPath() %>/cap/bm/dev/database/FunctionModelView.jsp?packageId=" + funcId +"&packagePath="+funcFullCode;
	//元素超链接 - 服务
	var addServiceUrl;
	var editServiceUrl;
	addServiceUrl = "<%=request.getContextPath() %>/cap/bm/dev/serve/ServiceObjectMain.jsp?appInsertFlag=true&packageId=" + funcId +"&packagePath="+funcFullCode+ "&editType=insert";
	editServiceUrl = "<%=request.getContextPath() %>/cap/bm/dev/serve/ServiceObjectMain.jsp?appEditFlag=true&packageId=" + funcId +"&packagePath="+funcFullCode+ "&editType=edit";

	
	//元素超链接 - 数据字典
	var addDicUrl;
	var editDicUrl;
	addDicUrl = "<%=request.getContextPath() %>/cap/bm/dev/page/dictionary/AddDictionary.jsp?sysModule=Yes&classifyId="+funcId;
	editDicUrl = "<%=request.getContextPath() %>/cap/bm/dev/page/dictionary/EditDictionary.jsp?classifyId="+ funcId;
	
	
	
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
	
		
	
	//===============================生成菜单====================================
	//实体新增菜单	
	var menu_add_entity={
			datasource:[
    		{id:'item1',label:"新增业务实体",target:"_blank"},
    		{id:'item2',label:"新增查询实体",target:"_blank"},
    		{id:'item3',label:"新增数据实体",target:"_blank"},
    		{id:'item4',label:"录入已有实体",target:"_blank",
    			items:[{id:'item41',label:'查询实体'},
    		           {id:'item42',label:'数据实体'}
    		          ]}],
    		type:"button",
    		width:100,
    		trigger:"mouseover",
    		on_click:function(obj){
    			var type = obj.id;
    			if("item1"==type){
    				openEntityName("biz_entity");
    			}else if("item2"==type){
    				openEntityName("query_entity");
    			}else if("item3"==type){
    				openEntityName("data_entity");
    			}else if("item41"==type){
    				openEntityName("exist_query_entity");
    			}else if("item42"==type){
    				openEntityName("exist_data_entity");
    			}
    		}	
	};
	
	//实体生成代码菜单
	var menu_entity_gen_data={
		datasource:[
		{id:'item6',label:"生成所有代码",target:"_blank"},
		{id:'item7',label:"生成VO代码",target:"_blank"},
		{id:'item8',label:"生成SQL脚本",target:"_blank"},
		{id:'item9',label:"生成业务代码",target:"_blank"}],
		type:"button",
		width:100,
		trigger:"mouseover",
		on_click:function(obj){
			var type = obj.id;
			if("item6"==type){
				generateCode(0);
			}else if("item7"==type){
				generateCode(1);
			}else if("item9"==type){
				generateCode(2);
			}else if("item8"==type){
				generateCode(3);
			}
		}
	};
	
	//界面新增菜单
	var menu_add_page={
			datasource:[
			{id:'item1',label:"新建页面",target:"_blank",href:addPageUrl},
			{id:'prototype',label:"从原型页面创建"},
			{id:'metadataPageConfigTmp',label:"从模板创建页面"},
			{id:'copyPage',label:"复制选择页面"},
			{id:'item4',label:"复制其他页面",target:"_blank",href:copyFromOtherUrl,separator:true},
			{id:'item5',label:"录入自定义页面",target:"_blank",href:addDefinedPageUrl}
			],
			type:"button",
			on_click:function(e){
				if(e.id=="metadataPageConfigTmp"){
					selectTemplate();
				}else if(e.id=="copyPage"){
					selectPage();
				}else if(e.id == 'prototype') {
					addPageFromPrototype()
				}
			},
			width:100,
			trigger:"mouseover"
		};
	
	//界面生成代码菜单
	var menu_page_gen_data={
			datasource:[
			{id:'pageCodeGenerate',label:"生成代码",separator:true,title:'生成后台action代码与前端页面jsp代码'},
			{id:'addTemplate',label:"生成典型模块模板"}],
			type:"button",
			on_click:function(e){
				if(e.id=="pageCodeGenerate"){
					generatePageCode();
				}else if(e.id=="addTemplate"){
					addTemplate();
				}
			},
			width:100,
			trigger:"mouseover"
		};
	
	//数据库新增导入菜单
	var menu_add_database={
			datasource:[
			{id:'item2',label:"导入视图",target:"_blank",href:impViewUrl},
			{id:'item3',label:"导入存储过程",target:"_blank",href:impProduceUrl},
			{id:'item4',label:"导入函数",target:"_blank",href:impFunctionUrl},
			{id:'item1',label:"业务对象导入表",separator:true,title:'业务对象导入表'}],
			type:"button",
			on_click:function(e){
				importBizObject(e.id);
			},
			width:100,
			trigger:"mouseover"
		};
	
	var menu_gen_database_SQL = {
			datasource:[
				{id:'createSQL',label:"导出全量SQL",separator:true,title:'导出数据表的全量SQL语句'},
				{id:'updateSQL',label:"导出增量SQL",separator:true,title:'导出数据表的增量SQL语句'}],
				type:"button",
				on_click:function(e){
					genDatabaseSQL(e.id);
				},
				width:100,
				trigger:"mouseover"	
	};
	//业务对象操作dialog
	var bizObjDialog;
	// 表对象数据
	var tableData;
	
	//导入对象
	function importBizObject(itemId){
		if('item1' == itemId){
			openBizObjDialog();
		}
	}
	//打开业务对象Dialog操作页面
	function openBizObjDialog(){
		var strDomainIds = "";
		dwr.TOPEngine.setAsync(false);
		ReqFunctionSubitemAction.queryDomainListByfuncCode(func.funcCode, function(res){
			if(res){
				for(var i = 0; i <res.length ; i++){
					if(i == res.length-1){
						strDomainIds = strDomainIds+res[i].id;
					}else{
						strDomainIds = strDomainIds+res[i].id +",";
					}
				}
			}
		});
		dwr.TOPEngine.setAsync(true);
		if(strDomainIds){
			impBizObjUrl = impBizObjUrl+"&domainIds="+strDomainIds;
			if(!bizObjDialog){
				bizObjDialog = cui.dialog({
					title : "业务对象属性选择主页",
					src : impBizObjUrl,
					width : 800,
					height : 600
				});
			}else{
				bizObjDialog.reload(impBizObjUrl);
			}
			bizObjDialog.show();
		}else{
			cui.alert("当前应用无关联业务域，无法获取业务对象,请先在应用中添加功能项!");
		}
	}
	
	//回调关闭
	function callbackClose(){
		bizObjDialog.hide();
	}
	
	//业务对象点击确定后回调
	function callbackConfirm(bizObjInfos) {
		dwr.TOPEngine.setAsync(false);
		BizObjInfoAction.parserBizToTable(bizObjInfos, function(result) {
			tableData = result;
		});
		dwr.TOPEngine.setAsync(true);
		var url;
		if (dbType == "mysql") {
			url = "<%=request.getContextPath() %>/cap/bm/dev/database/TableModelEdit_mysql.jsp?packageId=" + funcId + "&packagePath=" + funcFullCode + "&funcCode=" + func.funcCode;
		} else {
			url = "<%=request.getContextPath() %>/cap/bm/dev/database/TableModelEdit.jsp?packageId=" + funcId + "&packagePath=" + funcFullCode + "&funcCode=" + func.funcCode;
		}
		window.open(url);
		bizObjDialog.hide();
	}

	//生成数据表SQL
	function genDatabaseSQL(SQLType){
		//获取当前所选页面
		var selectData = [];
		//获取选择的表modelId
		$('input[name="table"]:checked').each(function(){ 
			selectData.push($(this).val()); 
		});
		if (selectData == null || selectData.length == 0) {
			cui.alert("请选择需要导出的数据表!");
			return;
		}
		// 生成增量SQL
		if(SQLType == 'updateSQL'){
			
			dwr.TOPEngine.setAsync(false);
        	TableOperateAction.genIncrementSQL(selectData,funcFullCode, {
        		callback: function(msg) {
        			if('tableEqual' == msg){
    					cui.alert('表结构没有变化,无增量SQL导出!');
    					return;
    				}else if('tableNotExists' == msg){
    					cui.alert('所选表已不存在，请重新选择!');
    					return;
    				}
        			
        			if (msg !=null){
    					cui.alert("导出增量SQL成功。SQL存放路径为："+ msg);
    				}else{
    					cui.alert('导出增量SQL失败');
    				}
        		},
        		errorHandler: function(message, exception) {
        			cui.alert('导出增量SQL失败');
        		}
        	});
        	dwr.TOPEngine.setAsync(true);
		}else{ //生成全量SQL
			dwr.TOPEngine.setAsync(false);
        	TableOperateAction.genCreateTableSQL(selectData, funcFullCode, false , {
        		callback: function(msg) {
        			if(msg!=null){
        				cui.alert("导出建表SQL成功。SQL存放路径为："+ msg);
        			}else{
        				window.top.cui.message('导出全量SQL失败','error');
        			}
        		},
        		errorHandler: function(message, exception) {
        			window.top.cui.message('导出全量SQL失败','error');
        		}
        	});
        	dwr.TOPEngine.setAsync(true);
		}
	}
	
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
		$("#"+id+"PanelCount").text(obj.length+pageMetadata.length);
		$("#"+id+"PanelArea").html(dataArea);
	}
	//工作流渲染
	function workflowRender(id,unData,deData){
		var dataArea = _.template($("#"+id+"Template").html(),{
			datas:unData,
			deDatas:deData,
			id:id,
			funcId:funcId,
			unUrl:editUnDeployWorkflowUrl,
			deUrl:editDeployWorkflowUrl}
		);
		$("#"+id+"PanelCount").text(unData.length+deData.length);
		$("#"+id+"PanelArea").html(dataArea);
	}
	
	//工作台配置
	function workbenchConfigRender(id,wbConfigData){
		var dataArea = _.template($("#"+id+"Template").html(),{
			datas:wbConfigData,
			id:id,
			funcId:funcId,
			editUrl:workbenchConfigUrl
	    });
		$("#"+id+"PanelCount").text(wbConfigData.length);
		$("#"+id+"PanelArea").html(dataArea);
	}
	
	//数据库渲染
	function databaseRender(id,tableObj,viewObj,produceObj,functionObj){
		var dataArea = _.template($("#"+id+"Template").html(),{
			datas:tableObj,
			viewDatas:viewObj,
			produceDatas:produceObj,
			functionDatas:functionObj,
			id:id,
			editTableUrl:editTableUrl,
			editViewUrl:editViewUrl,
			editProduceUrl:editProduceUrl,
			editFunctionUrl:editFunctionUrl}
		);
		$("#"+id+"PanelCount").text(tableObj.length+viewObj.length+produceObj.length+functionObj.length);
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
	//数据字典渲染
	function dictionaryRender(id,dicObj){
		var dataArea = _.template($("#"+id+"Template").html(),{
			datas:dicObj,
			id:id,
			editDicUrl:editDicUrl}
		);
		$("#"+id+"PanelCount").text(dicObj.length);
		$("#"+id+"PanelArea").html(dataArea);
	}
	
//==================应用事件处理区域==================
	//快速构建
	function quickBuild(event, self, mark){
		window.open("<%=request.getContextPath() %>/cap/bm/dev/wizard/Index.jsp?packageId=" + funcId + "&moduleCode=" + func.funcCode);
	}

	//收藏事件
	function storeUp(event, self, mark){
		var app = {"employeeId":globalCapEmployeeId,"appId":funcId,"appType":2};
		dwr.TOPEngine.setAsync(false);
		AppDetailAction.storeUpApp(app,function(data){ 
			if(data){
				var app = {"employeeId":globalCapEmployeeId,"appId":funcId,"appType":2};
				AppDetailAction.queryStoreApp(app,function(data){
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
		AppDetailAction.cancelAppStore(app,function(data){ 
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
		var url = "<%=request.getContextPath() %>/cap/ptc/team/CheckMulPersonnel.jsp?teamId="+globalCapTeamId+"&appId="+ funcId;
		var title="选择开发人员";
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

	/**
	 * 弹出Pdm导入窗口.
	 **/
	function upload() {
		var returnParentNodeName = decodeURIComponent(decodeURIComponent(parentNodeName));
		if (returnParentNodeName != "undefined" && returnParentNodeName != null && returnParentNodeName != "null") {
			returnParentNodeName = encodeURIComponent(encodeURIComponent(returnParentNodeName));
		}

		var url = "/web/cap/bm/dev/pdm/PdmUpload.jsp?packageId=" + funcId + "&parentNodeId=" +
			parentNodeId + "&parentNodeName=" + returnParentNodeName;
		var title = "PDM导入";
		var height = 200; //300
		var width = 500; // 560;
		dialog = cui.dialog({
			title: title,
			src: url,
			width: width,
			height: height
		});
		dialog.show();
	}

	
	//分配后回调 
	function chooseEmployee(selects,teamId){
		dwr.TOPEngine.setAsync(false);
		AppDetailAction.assignApp(selects,funcId,teamId,function(data){ 
			if(data == 1) {
				cui.message('分配成功！','success');
			}else{
				cui.message('分配失败', "error");
			} 
	    });
		dwr.TOPEngine.setAsync(true);
	}
	
	
	//应用编辑事件
	function returnEditFunc(event, self, mark){
		var returnParentNodeName  = decodeURIComponent(decodeURIComponent(parentNodeName));
		if(returnParentNodeName!="undefined"&&returnParentNodeName!=null&&returnParentNodeName!="null"){
			returnParentNodeName = encodeURIComponent(encodeURIComponent(returnParentNodeName));
		}
		var returnUrl = '<%=request.getContextPath() %>/cap/bm/dev/systemmodel/FuncModelEdit.jsp?nodeId=' + funcId + '&parentNodeId=' + parentNodeId
		+ "&parentNodeName=" + returnParentNodeName;
		window.open(returnUrl, '_self');
	}
	
	
	
	function closeWin(){
		window.close();
	}
	
	//==================元数据事件处理区域===========================================================
	
	 //实体批量删除事件 id为arr
	 function entityBatchDel(idArr) {
	 	//重写后 id可能是arr
	 	var deleteEntityList = idArr;
	 	//检查元数据一致性检查不通过则终止执行
	 	if (!validateEntityConsistency(deleteEntityList)) {
	 		return;
	 	}

	 	dwr.TOPEngine.setAsync(false);
	 	EntityFacade.delEntitys(deleteEntityList, function(data) {
	 		if (data) {
	 			cui.message("删除实体成功。", "success");
	 			refreshWindowByOperateType("entity");
	 		} else {
	 			cui.message("删除实体失败。", "error");
	 		}
	 	});
	 	dwr.TOPEngine.setAsync(true);
	 }

    /**
     * 实体一致性校验
     * 
     * @param  deleteEntityList [description]
     * @return                  [description]
     */
	function validateEntityConsistency(deleteEntityList) {
	    var flag = true;
		dwr.TOPEngine.setAsync(false);
		dependOnCurrentData = [];
		var selectDataVOs = parseAllEntityDate(deleteEntityList);
		EntityFacade.checkEntity4BeingDependOn(selectDataVOs, function(redata) {
			if (redata) {
				if (!redata.validateResult) { //有错误
					dependOnCurrentData = redata.dependOnCurrent == null ? [] : redata.dependOnCurrent;
					initOpenConsistencyImage(checkUrl);
					cui.alert('当前选择实体不能被删除，请检查元数据一致性！');
					flag = false;
				} else { //测试加
					initOpenConsistencyImage(checkUrl); //通过则关闭div和dialog
				}
			} else {
				cui.error("元数据一致性效验异常，请联系管理员！");
				flag = false;
			}
		});
		dwr.TOPEngine.setAsync(true);
		return flag;
	}
		
    //实体删除事件
    function entityDel(id) {
    	//检查元数据一致性检查不通过则终止执行
    	if (!validateEntityConsistency([id])) {
    		return;
    	}

    	//需要判断实体是否允许删除
    	dwr.TOPEngine.setAsync(false);
    	var deleteEntity = [id];
    	EntityFacade.delEntitys(deleteEntity, function(data) {
    		if (data) {
    			cui.message("删除实体成功。", "success");
    			refreshWindowByOperateType("entity");
    		} else {
    			cui.message("删除实体失败。", "error");
    		}
    	});
    	dwr.TOPEngine.setAsync(true);
    }
	
	//刷新当前页面函数
	function refresh(){
		window.location.reload();
	}
	//页面删除事件
	function pageDel(id){
		var deletePage = [id];
		id instanceof Array?deletePage=id:deletePage = [id];
		//检查元数据一致性检查不通过则终止执行
		if(!checkConsistency(deletePage,"page")){
			return;
		}
		
		dwr.TOPEngine.setAsync(false);
		PageFacade.deleteModels(deletePage, function(result) {
			//如果是单个操作则弹出消息，刷新当前区域
			if(result){
				cui.message("删除成功。","success");
				refreshWindowByOperateType("page");
			 }else{
				cui.message("删除失败。","error"); 
			 }
        });
    	dwr.TOPEngine.setAsync(true);
	}
	//页面模板删除
	function pageMetaDel(id){
		var deletePageMetas;
		id instanceof Array?deletePageMetas=id:deletePageMetas = [id];
		dwr.TOPEngine.setAsync(false);
		AppDetailAction.deleteModels(deletePageMetas,function(data) {
			if(data){
				cui.message("删除成功。","success");
				refreshWindowByOperateType("page");
			} else {
				cui.message("删除失败。","error");
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//工作流删除事件
	function workflowDel(id){
		var deleteWorkflow; 
		id instanceof Array?deleteWorkflow=id:deleteWorkflow = [id];
		dwr.TOPEngine.setAsync(false);
		CipWorkFlowListAction.deleteDeployeById(func.funcCode,deleteWorkflow,globalUserId,function(result){
			if(result == "SUCCESS") {
				cui.message("删除成功。","success");
				refreshWindowByOperateType("workflow");
			} else {
				cui.message("删除失败。","error");							
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	//工作流卸载事件
	function workflowUninstall(id){
		var deleteWorkflow;
		 id instanceof Array?deleteWorkflow=id:deleteWorkflow = [id];
		dwr.TOPEngine.setAsync(false);
		CipWorkFlowListAction.uninstallDeployeById(func.funcCode,deleteWorkflow,globalUserId,function(result){
			if(result == 'SUCCESS') {
				cui.message("卸载成功。","success");
				refreshWindowByOperateType("workflow");
			} else {
				cui.message(result,"error");							
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	//删除服务 
	function delServiceObject(id){
		var deleteWorkflow;
		 id instanceof Array?deleteWorkflow=id:deleteWorkflow = [id];
		dwr.TOPEngine.setAsync(false);
		AppDetailAction.delServiceObjectList(deleteWorkflow, function(result) {
				if(data){
					cui.message("删除成功。","success");
					refreshWindowByOperateType("service");
				}else{
					cui.message("删除失败。","error");
				}
				
            });
    	dwr.TOPEngine.setAsync(true);
	}
	
	//表删除事件
	function delTable(id){
		var deleteTable;
		id instanceof Array?deleteTable = id:deleteTable = [id];
		dwr.TOPEngine.setAsync(false);
		AppDetailAction.delTables(deleteTable,function(data){
			if(data){
				cui.message("删除成功。","success");
				refreshWindowByOperateType("database");
			}else{
				cui.message("删除失败。","error");
			}
 		});
 		dwr.TOPEngine.setAsync(true);
	}
	
	//视图删除事件
	function delView(id){
		var deleteView ;
		id instanceof Array?deleteView = id:deleteView = [id];
		dwr.TOPEngine.setAsync(false);
		AppDetailAction.delVeiws(deleteView,function(data){
			if(data){
				cui.message("删除成功。","success");
				refreshWindowByOperateType("database");
			}else{
				cui.message("删除失败。","error");
			}
 		});
 		dwr.TOPEngine.setAsync(true);
	}
	
	//存储过程删除事件
	function delProduce(id){
		var deleteProduce ;
		id instanceof Array?deleteProduce = id:deleteProduce = [id];
		dwr.TOPEngine.setAsync(false);
		AppDetailAction.delProcedures(deleteProduce,function(data){
			if(data){
				cui.message("删除成功。","success");
				refreshWindowByOperateType("database");
			}else{
				cui.message("删除失败。","error");
			}
 		});
 		dwr.TOPEngine.setAsync(true);
	}
	
	//函数删除事件
	function delFunction(id){
		var deleteFunction = [id];
		id instanceof Array?deleteFunction = id:deleteFunction = [id];
		dwr.TOPEngine.setAsync(false);
		AppDetailAction.delFunctions(deleteFunction,function(data){
			if(data){
				cui.message("删除成功。","success");
				refreshWindowByOperateType("database");
			}else{
				cui.message("删除失败。","error");
			}
 		});
 		dwr.TOPEngine.setAsync(true);
	}
	
	//删除工作台配置
	function delWorkbenchConfig(id){
		var deleteFunction = [id];
		id instanceof Array?deleteFunction = id:deleteFunction = [id];
		dwr.TOPEngine.setAsync(false);
		AppDetailAction.deleteAction(deleteFunction,function(data) {
			cui.message("删除工作台配置成功。","success");
			refreshWindowByOperateType("workbenchConfig");
		});
		dwr.TOPEngine.setAsync(true);
	}
	var addWBConfigDialog;
//==================事件处理区域End==================================================
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
		workflowRender("workflow",unDeployeWorkflow||[],deployeWorkflow||[]);
		workbenchConfigRender("workbenchConfig",workbenchConfig||[]);//工作台配置渲染
		
		databaseRender("database",tables||[],views||[],produces||[],functions||[]);
		serviceRender("service",service||[]);
		dictionaryRender("dictionary",dictionary||[]);
		//创建点击事件
		buildClickFn(null);		
	});
	
	//根据当前checkbox的name获得其全选按钮的id
	function getCurAllCheckBoxIdByName(name){
		var reName = "";
		if(name=='entity'){
			reName = "checkAllEntity";
		}else if(name=='service'){
			reName = "checkAllService";
		}else if(name=='dictionary'){
			reName = "checkAllDictionary";
		}else if(name=='workbench'){
			reName = "checkAllWorkbench";
		}else if(name=='page'||name=='meta'){
			reName = "checkAllPage";
		}else if(name=='unDeploy'||name=='deploy'){
			reName = "checkAllWorkflow";
		}else if(name=='table'||name=='view'||name=='produce'||name=='function'){
			reName = "checkAllDatabase";
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
		}else if(name=='dictionary'){
			reName = "dictionaryPanelArea";
		}else if(name=='workbench'){
			reName = "workbenchConfigPanelArea";
		}else if(name=='page'||name=='meta'){
			reName = "pagePanelArea";
		}else if(name=='unDeploy'||name=='deploy'){
			reName = "workflowPanelArea";
		}else if(name=='table'||name=='view'||name=='produce'||name=='function'){
			reName = "databasePanelArea";
		}
		return reName;
	}
	
	//导出文档
	function exportWordMain(type){
		dwr.TOPEngine.setAsync(false);
		AppDetailAction.exportDocumentOutDoc(funcId,type,function(result){
			var code = result.code;
			if("Success" === code){
				cui.success(result.message);
			}else if("Error" === code){
				cui.warn(result.message);
			}else{
				cui.alert(result.message);
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	
	//========================add by liucheng ==========================================
	
	//=========================初始化下拉框===================================
	// 初始化实体选择类型
	function initEntityType(obj){
		var initData = [
		        {id:'0',text:'全部'},
		      	{id:'biz_entity',text:'业务实体'},
		      	{id:'query_entity',text:'查询实体'},
		      	{id:'data_entity',text:'数据实体'}
		      	//,{id:'exist_entity_input',text:'已有实体'}
		      ]
		             
		obj.setDatasource(initData);
	}
	
	// 初始化界面选择类型
	function initPageType(obj){
		var initData = [
		        {id:'0',text:'全部'},
		      	{id:'page',text:'页面'},
		      	{id:'userPage',text:'自定义'},
		      	{id:'meta',text:'模板'}
		      ]
		             
		obj.setDatasource(initData);
	}
	
	// 初始化工作流选择类型
	function initWorkflowType(obj){
		var initData = [
		        {id:'0',text:'全部'},
		      	{id:'unDeploye',text:'草稿'},
		      	{id:'deploye',text:'已部署'}
		      ]
		             
		obj.setDatasource(initData);
	}

	// 初始化数据库选择类型
	function initDatabaseType(obj){
		var initData = [
		        {id:'0',text:'全部'},
		      	{id:'table',text:'数据表'},
		      	{id:'view',text:'视图'},
		      	{id:'produce',text:'存储过程'},
		      	{id:'function',text:'函数'}
		      ]
		             
		obj.setDatasource(initData);
	}
	//=================================end下拉框初始化===================================
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
	
	//工作流全选
	function checkAllWorkflow(){
		var values = cui('#checkAllWorkflow').getValue(); 
		if(values &&  values.length == 1 && values[0] == 1){
			$('input[name="unDeploy"]').attr("checked", true);
			$('input[name="deploy"]').attr("checked", true);
		} else {
			$('input[name="unDeploy"]').attr("checked", false);
			$('input[name="deploy"]').attr("checked", false);
		}
	}
	
	//数据库全选
	function checkAllDatabase(){
		var values = cui('#checkAllDatabase').getValue(); 
		if(values &&  values.length == 1 && values[0] == 1){
			$('input[name="table"]').attr("checked", true);
			$('input[name="view"]').attr("checked", true);
			$('input[name="produce"]').attr("checked", true);
			$('input[name="function"]').attr("checked", true);
		} else {
			$('input[name="table"]').attr("checked", false);
			$('input[name="view"]').attr("checked", false);
			$('input[name="produce"]').attr("checked", false);
			$('input[name="function"]').attr("checked", false);
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
	
	//数据项全选
	function checkAllDictionary(){
		var values = cui('#checkAllDictionary').getValue(); 
		if(values &&  values.length == 1 && values[0] == 1){
			$('input[name="dictionary"]').attr("checked", true);
		} else {
			$('input[name="dictionary"]').attr("checked", false);
		}
	}
	
	//工作台全选
	function checkAllWorkbench(){
		var values = cui('#checkAllWorkbench').getValue(); 
		if(values &&  values.length == 1 && values[0] == 1){
			$('input[name="workbench"]').attr("checked", true);
		} else {
			$('input[name="workbench"]').attr("checked", false);
		}
	}
	/**
	*根据操作类型刷新部分区域
	*
	*@operateType 操作类型 
	*/
	function refreshWindowByOperateType(operateType){
		dwr.TOPEngine.setAsync(false);
		if(operateType=="entity"){
			EntityFacade.queryEntityList(func.parentFuncId,function(data){ //实体
				entity = data;
			});
			entitySimpleQuery();
		}else if(operateType=="page"){
			PageFacade.queryPageList(func.parentFuncId, function(data){
				page = data;
			});
			AppDetailAction.queryMetadataGenerateList(func.parentFuncId, function(data){
				pageMetadata = data;
			});
			pageSimpleQuery();
		}else if(operateType=="workflow"){
			CipWorkFlowListAction.queryUnDeployeProcessByDirCode(func.funcCode,globalCapEmployeeId,1,100,function(data){
				unDeployeWorkflow = data.list;
			});
			CipWorkFlowListAction.queryDeployeEdProcesses(func.funcCode,globalCapEmployeeId,1,100,function(data){
				deployeWorkflow = data.list;
			});
			workflowSimpleQuery();
		}else if(operateType=="workbenchConfig"){
			AppDetailAction.getListData(func.funcCode,function(data) {
				workbenchConfig = data ? data["list"] : [];
			});
			workbenchConfigSimpleQuery();
		}else if(operateType=="database"){
			AppDetailAction.queryTableList(funcFullCode,function(data){
				tables = data;
			});
			AppDetailAction.queryViewList(funcFullCode,function(data){
				views = data;
			});
			AppDetailAction.queryProcedureList(funcFullCode,function(data){
				produces = data;
			});
			AppDetailAction.queryFuntionList(funcFullCode,function(data){
				functions = data;
			});
			databaseSimpleQuery();
		}else if(operateType=="service"){
			AppDetailAction.queryServiceObjectList(funcId,function(data){
				service = data;
			});
			serviceSimpleQuery();
		}else if(operateType=="dictionary"){
			ConfigItemAction.queryConfigItemList(query, function(data) {
				dictionary = data.list;
			});
			dictionarySimpleQuery();
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
		}else if(type=='page'){
			curId = "#pagePanelArea";
		}else if(type=='workflow'){
			curId = "#workflowPanelArea";
		}else if(type=='service'){
			curId = "#servicePanelArea";
		}else if(type=='workbenchConfig'){
			curId = "#workbenchConfigPanelArea";
		}else if(type=='database'){
			curId = "#databasePanelArea";
		}else if(type=='dictionary'){
			curId = "#dictionaryPanelArea";
		}else if(type=='entity'){
			curId = "#entityPanelArea";
		}
		
		//更新数据后重建菜单
		$(curId+" .app_item").on("click",".colsebtn",function(e){
			var that = this;
			e.stopPropagation();
			cui.confirm('确认要删除信息吗？', {
				onYes: function(){
					var type = $(that).data("type"),id=$(that).data("id"),pagetype=$(that).data("pagetype");
					if(type=="entity"){
						entityDel(id)
					}else if(type=="page"){
						//确定是页面删除，还是页面原数据删除
						if(pagetype=="page"){
						   pageDel(id);
						}else if(pagetype=="metaData"){
						   pageMetaDel(id);
						}
					}else if(type=="unDeployWorkflow"){
						workflowDel(id);
					}else if(type=="deployWorkflow"){
						workflowUninstall(id);
					}else if(type=="service"){
						delServiceObject(id);
					}else if(type=="delTable"){
						delTable(id);
					}else if(type=="delView"){
						delView(id);
					}else if(type=="delProduce"){
						delProduce(id);
					}else if(type=="delFunction"){
						delFunction(id);
					}else if(type=="workbenchConfig"){
						delWorkbenchConfig(id);
					}
				},
				onNo: function(){
					//do nothing
				}
			});
		});
		
		$(curId+" .app_item li.first").click(function(){
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
		
		$(curId+" .app_item li.first").find(":checkbox").click(function(arg){
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
		
		
		$(curId+" .lastcui").click(function(){
			$(this).parent().parent().parent().toggle();//内容区域
			$(this).parent().parent().parent().prev().find(".app_items_btn").toggle();
			$(this).parent().parent().parent().prev().find(".app_items_btn").siblings("img.place-right").show();
			
			//使用缓存记录下用户点击张开过的项
			if(cst.exists("appStorage")){
				var data = cst.use("appStorage").get("displayArea");
				data[$(this).parent().parent().parent().attr("id")] = $(this).parent().parent().parent().is(":visible");
				cst.use("appStorage").set("displayArea",data);
			}
		});
	}
	//打开新窗口
	function openEntityWindowOrUrl(event, obj, arg){
		if("importEntity"==arg){//导入
			window.open(importEntityUrl);
		}
	}
	
	//打开数据库按钮
	function openDatabaseWindowOrUrl(event, obj, arg){
		if("view"==arg){
			window.open(impViewUrl);
		}else if("produce"==arg){
			window.open(impProduceUrl);
		}else if("function"==arg){
			window.open(impFunctionUrl);
		}
	}
	

	//新增工作流
	function addWorkflow(){
// 		cui("#addProcessDialog").dialog({
// 			modal: true, 
// 			draggable: false,
// 			title: "流程修改",
// 			src : addUnDeployWorkflowUrl,
// 			width: (document.documentElement.clientWidth || document.body.clientWidth) - 0,
// 			height: (document.documentElement.clientHeight || document.body.clientHeight) - 40,
// 			beforeClose: function () {
//                 refreshWindowByOperateType("workflow");
//             }
// 		 }).show();
		var winObj = window.open(addUnDeployWorkflowUrl);
		var loop = setInterval(function() {   
		    if(winObj.closed) {  
		        clearInterval(loop);  
		        window.setTimeout(refreshWindowByOperateType("workflow"),600);
		    }  
		}, 1000); 
	}
	
	//添加新的服务项
	function addNewService(){
		window.open(addServiceUrl);
	}
	//实体批量删除事件
	function entityDelete(){
		
		var entityArr = [];
		//获取所有被选中的实体id
		$('input[name="entity"]:checked').each(function(){ 
			entityArr.push($(this).val()); 
		});
		if(entityArr.length==0&&entityArr.length==0){
			cui.alert("请选择要删除的实体信息。");
		}else{
			cui.confirm("确认要删除当前实体信息吗？",{
				onYes:function(){
					entityBatchDel(entityArr);
				}
			});
		}
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
	
	
	//页面删除事件
	function pageOrMetaDel(){
		//获取所有被选中的页面id
		var pageArr = [];
		var metaArr = [];
		//获取所有被选中的模板id
		$('input[name="page"]:checked').each(function(){ 
			pageArr.push($(this).val()); 
		});
		$('input[name="meta"]:checked').each(function(){ 
			metaArr.push($(this).val()); 
		});
		if(pageArr.length==0&&metaArr.length==0){
			cui.alert("请选择要删除的界面信息。");
		}else{
			cui.confirm("确认要删除当前界面信息吗？",{
				onYes:function(){
					if(pageArr.length>0){pageDel(pageArr);}
					if(metaArr.length>0){pageMetaDel(metaArr);}
				}
			});
		}
		//调用页面或模板删除的方法
	}
	
	//工作流删除事件
	function workflowBatchDel(){
		var deployeArr = [];
		var undeployeArr = [];
		$('input[name="unDeploy"]:checked').each(function(){ 
			undeployeArr.push($(this).val()); 
		});
		$('input[name="deploy"]:checked').each(function(){ 
			deployeArr.push($(this).val()); 
		});

		if(deployeArr.length==0&&undeployeArr.length==0){
			cui.alert("请选择要删除的工作流信息。");
		}else{
			cui.confirm("确认要删除当前工作流信息吗？",{
				onYes:function(){
					if(undeployeArr.length>0){workflowDel(undeployeArr);}
					if(deployeArr.length>0){workflowUninstall(deployeArr);}
				}
			});
		}
	}
	
	//数据库删除事件
	function databaseBatchDel(){
		var tableArr = [];
		var viewArr = [];
		var produceArr = [];
		var functionArr = [];
		$('input[name="table"]:checked').each(function(){ 
			tableArr.push($(this).val()); 
		});
		$('input[name="view"]:checked').each(function(){ 
			viewArr.push($(this).val()); 
		});
		$('input[name="produce"]:checked').each(function(){ 
			produceArr.push($(this).val()); 
		});
		$('input[name="function"]:checked').each(function(){ 
			functionArr.push($(this).val()); 
		});
		if(tableArr.length==0&&viewArr.length==0&&produceArr.length==0&&functionArr.length==0){
			cui.alert("请选择要删除的数据库信息。");
		}else{
			cui.confirm("确认要删除当前数据库信息吗？",{
				onYes:function(){
					if(tableArr.length>0){delTable(tableArr);}
					if(viewArr.length>0){delView(viewArr);}
					if(produceArr.length>0){delProduce(produceArr);}
					if(functionArr.length>0){delFunction(functionArr);}
				}
			});
		}
	}
	
	
	//服务批量删除事件
	function serviceBatchDel(){
		var serviceArr = [];
		$('input[name="service"]:checked').each(function(){ 
			serviceArr.push($(this).val()); 
		});
		if(serviceArr.length==0){
			cui.alert("请选择要删除的服务信息。");
		}else{
			cui.confirm("确认要删除当前服务信息吗？",{
				onYes:function(){
					delServiceObject(serviceArr);
				}
			});
		}
	}
	
	//工作台批量删除事件delWorkbenchConfig
	function workbenchBatchDel(){
		var workbenchConfigArr = [];
		$('input[name="workbench"]:checked').each(function(){ 
			workbenchConfigArr.push($(this).val()); 
		});
		if(workbenchConfigArr.length==0){
			cui.alert("请选择要删除的工作台信息。");
		}else{
			cui.confirm("确认要删除当前工作台信息吗？",{
				onYes:function(){
					delWorkbenchConfig(workbenchConfigArr);
				}
			});
		}
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
		if(dataTyp!='entity'&&dataTyp!='page'&&(keyword==null||keyword=="")){
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
		}else{
			return arr;
		}
		for(var i=0;i<arr.length;i++){
			var objItem = arr[i];
			//如果是实体类型
			if (dataTyp=='entity'&&pulltype!='0'&&pulltype!="") {
				if(objItem['entityType']==pulltype &&compare(objItem[columnName],keyword)){
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
			}else{
				if (compare(objItem[columnName],keyword)){
					reArr.push(objItem);
				}
			}
			
		}
		return reArr;
	}
	
	
	//工作流事件
	//工作流查询
	function workflowSimpleQuery(){
		//每次查询的时候全选按钮不选择
		cui('#checkAllWorkflow').unSelectAll(); 
		//关键字查询
		var keyword = getRegKeyWord(cui("#workflowClickInput").getValue());
			
		//下拉框
		var type = cui("#workflowType").getValue();
		var deployeArr = deployeWorkflow;//已部署
		var undeployeArr = unDeployeWorkflow;//草稿
		if('deploye'==type){
			undeployeArr = [];
		}else if('unDeploye'==type){
			deployeArr = [];
		}
		
		//解析deployeArr和undeployeArr的内容 和keyword进行匹配
		var reDeployeArr = [];
		var reUndeployeArr = [];
		reDeployeArr = parseArrayWithKeyWord(keyword,deployeArr,'deploye',null);
		reUndeployeArr = parseArrayWithKeyWord(keyword,undeployeArr,'unDeploye',null);
		workflowRender("workflow",reUndeployeArr||[],reDeployeArr||[]);
		buildClickFn("workflow");
	}
	
	//工作台新增方法
	function addWorkbenchConfig( ){
		if(!addWBConfigDialog){
			addWBConfigDialog = cui.dialog({
				modal: true, 
				draggable: true,
				title: "工作台配置",
				src : addWorkbenchConfigUrl,
				width: 800,
				height: 600
			    }).show();
		}else{
			addWBConfigDialog.reload(addWorkbenchConfigUrl);
		}
		addWBConfigDialog.show();
	}
	//数据库查询
	function databaseSimpleQuery(){
		//每次查询的时候全选按钮不选择
		cui('#checkAllDatabase').unSelectAll(); 
		//关键字查询
		var keyword = getRegKeyWord(cui("#databaseClickInput").getValue());
			
		//下拉框
		var type = cui("#databaseType").getValue();
		var tableArr = tables;//table
		var viewsArr = views;//view
		var produceArr = produces;//produces
		var functionArr = functions;
		
		if('table'==type){
			viewsArr = [];
			produceArr = [];
			functionArr = [];
		}else if('view'==type){
			tableArr = [];
			functionArr = [];
			produceArr = [];
		}else if('produce'==type){
			tableArr = [];
			viewsArr = [];
			functionArr = [];
		}else if('function'==type){
			tableArr = [];
			viewsArr = [];
			produceArr = [];
		}
		
		//解析table类型的内容 和keyword进行匹配
		var reTableArr = [];
		var reViewsArr = [];
		var reProduceArr = [];
		var reFunctionArr = [];
		reTableArr = parseArrayWithKeyWord(keyword,tableArr,'table',null);
		reViewsArr = parseArrayWithKeyWord(keyword,viewsArr,'view',null);
		reProduceArr = parseArrayWithKeyWord(keyword,produceArr,'produce',null);
		reFunctionArr = parseArrayWithKeyWord(keyword,functionArr,'function',null);
		databaseRender("database",reTableArr||[],reViewsArr||[],reProduceArr||[],reFunctionArr||[]);
		buildClickFn("database");
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

	//数据项查询
	function dictionarySimpleQuery(){
		//每次查询的时候全选按钮不选择
		cui('#checkAllDictionary').unSelectAll();
		//关键字查询
		var keyword = getRegKeyWord(cui("#dictionaryClickInput").getValue());
		var dictionaryArr = dictionary;//
		//解析dictionaryArr的内容 和keyword进行匹配
		var reDictionaryArr = [];
		reDictionaryArr = parseArrayWithKeyWord(keyword,dictionaryArr,'dictionary',null);
		dictionaryRender("dictionary",reDictionaryArr||[]);
		buildClickFn("dictionary");
	}
	
	//工作台查询
	function workbenchConfigSimpleQuery(){
		//每次查询的时候全选按钮不选择
		cui('#checkAllWorkbench').unSelectAll();
		//关键字查询
		var keyword = getRegKeyWord(cui("#workbenchConfigClickInput").getValue());
		var workbenchConfigArr = workbenchConfig;//
		//解析workbenchConfigArr的内容 和keyword进行匹配
		var reWorkbenchConfigArr = [];
		reWorkbenchConfigArr = parseArrayWithKeyWord(keyword,workbenchConfigArr,'workbenchConfig',null);
		workbenchConfigRender("workbenchConfig",reWorkbenchConfigArr||[]);//工作台配置渲染
		buildClickFn("workbenchConfig");
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
	
	//页面预览
   function preview(){
	  var selectData = [];
	  var reArrData = [];
	  $('input[name="page"]:checked').each(function(){ 
		  selectData.push($(this).val()); 
	  });
	  reArrData = parsePageDate(selectData);
	  if (selectData == null || selectData.length == 0) {
	  		if($('input[name="meta"]:checked').length > 0) {
	  			cui.alert("模板无法预览");
	  		}else {
				cui.alert("请选择要预览的页面");
	  		}
			return;
	  }else if(reArrData[0].pageId==null){
		  cui.alert('请在生成代码后再进行预览');
	  }
	  for(var i=0;i<reArrData.length;i++){
		  var pageItem = reArrData[i];
		  window.open('${pageScope.cuiWebRoot}'+pageItem.url);
	  }
   }

   function addPageFromPrototype() {
   		var url = webPath + '/cap/bm/req/prototype/design/uilibrary/SelectUrl.jsp';
		url += '?callbackMethod=pageSelectCallBack';
		var top=(window.screen.availHeight-600)/2;
		var left=(window.screen.availWidth-800)/2;
		window.open (url,'openDataStoreSelect','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
   }

   function pageSelectCallBack(propertyName, obj) {
		// console.log(propertyName, obj); 
		window.open(addPageUrl+'&prototypeId=' + obj.modelId);
	}
	
	//从选择页面复制
	function selectPage() {
		var selectData = [];
		var reArrData = [];
		$('input[name="page"]:checked').each(function(){ 
			reArrData.push($(this).val()); 
		});
		//根据selectData从page里面获取对应的数据
		selectData = parsePageDate(reArrData);
		if (selectData == null || selectData.length == 0) {
			cui.alert("请选择要复制的页面(除模板)。");
			return;
		} else {
			if(selectData.length>1){
				var url =  "<%=request.getContextPath() %>/cap/bm/dev/page/designer/PageNameEdit.jsp";
				var top=(window.screen.availHeight-600)/2;
	    		var left=(window.screen.availWidth-800)/2;
				window.open(url,'pageNameEdit','height=650,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no');
			}else{
				selectPageData(selectData[0], 'copyPage',null);
			}
		}
	}
	
	//根据已选择的下拉框数据获取完整的对应的page数据
	function parsePageDate(selectData){
		var reData = [];
		for(var i=0;i<selectData.length;i++){
			for(var j=0;j<page.length;j++){
				var item = page[j];
				if(selectData[i]==item['modelId']){
					reData.push(page[j]);
				}
			}
		}
		return reData;
	}
	
	//根据已选择的下拉框数据获取完整的对应的实体数据 
	function parseAllEntityDate(selectData){
		var reData = [];
		for(var i=0;i<selectData.length;i++){
			for(var j=0;j<entity.length;j++){
				var item = entity[j];
				if(selectData[i]==item['modelId']){
					reData.push(entity[j]);
				}
			}
		}
		return reData;
	}
	//返回被选择的页面 供其他页面调用
	function returnSelectPage(){
		var selectData = [];
		var reArrData = [];
		$('input[name="page"]:checked').each(function(){ 
			reArrData.push($(this).val()); 
		});
		selectData = parsePageDate(reArrData);
		return selectData;
	}
	
	//复制选择页面结果
	function copyPageResult(rs){
		if(typeof rs === 'number'){
			cui.message(rs+'个页面复制成功！', 'success');
		}
		if(typeof rs === 'boolean'){
			if (rs) {
				cui.message('页面复制成功！', 'success');
			} else {
				cui.error("页面复制失败！");
			} 
		}
		refresh();
	}
	
	var dependOnCurrentData =[];
	var currentDependOnData =[];
	var checkUrl = "<%=request.getContextPath() %>/cap/bm/dev/consistency/ConsistencyCheckResult.jsp?checkType=main&init=true";
	/**
	*检查元数据一致性 是否通过
	*@selectDatas 当前所选对象数组 
	*@type 数据类型
	*/
	function checkConsistency(selectDatas,type){
		var checkflag = true;
		dwr.TOPEngine.setAsync(false);
		//删除之前先检查元素一致性依赖
		dependOnCurrentData = [];
		var selectDataVOs = [];
		if(type=="entity"){
			selectDataVOs = parseAllEntityDate(selectDatas);
			EntityFacade.checkEntityBeingDependOn(selectDataVOs,function(redata){
				if(redata){
					  if (!redata.validateResult) {//有错误
						  dependOnCurrentData = redata.dependOnCurrent==null?[]:redata.dependOnCurrent;
						  initOpenConsistencyImage(checkUrl);
						  checkflag = false;
						  cui.alert('当前选择实体不能被删除，请检查元数据一致性！');
					  }else{//测试加
						  //cui.message('元数据一致性效验通过！', 'success');
						  initOpenConsistencyImage(checkUrl);//通过则关闭div和dialog
						  //cui.alert('当前选择实体不能被删除，请检查元数据一致性');
						  //checkflag = false;//直接返回 需要放上一层
					  }
				  }else{
					  cui.error("元数据一致性效验异常，请联系管理员！"); 
				  }
			});
		}else if(type=="page"){
			selectDataVOs = parsePageDate(selectDatas);
			PageFacade.pageConsistency4BeingDependOn(selectDataVOs,function(redata){
				if(redata){
					  if (!redata.validateResult) {//有错误
						  dependOnCurrentData = redata.dependOnCurrent==null?[]:redata.dependOnCurrent;
						  initOpenConsistencyImage(checkUrl);
						  cui.alert('当前选择页面不能被删除，请检查元数据一致性');
						  checkflag = false;
					  }else{//测试加
						  //cui.message('元数据一致性效验通过！', 'success');
						  initOpenConsistencyImage(checkUrl);//通过则关闭div和dialog
						  //cui.alert('当前选择页面不能被删除，请检查元数据一致性');
						  //checkflag = false;//直接返回 需要放上一层
					  }
				  }else{
					  cui.error("元数据一致性效验异常，请联系管理员！"); 
				  }
			});
		}else{
			return true;
		}
		dwr.TOPEngine.setAsync(true);
		return checkflag;
	}
	//=====================end=========================
	
</script>
</body>
</html>