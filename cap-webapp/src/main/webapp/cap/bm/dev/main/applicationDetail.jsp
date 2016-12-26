<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<%@ include file="/cap/bm/dev/main/header.jsp" %>
	<%@ include file="/cap/bm/dev/main/mainNav.jsp" %>
	<link href="${pageScope.cuiWebRoot}/cap/bm/common/base/css/base.css" rel="stylesheet">
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/cui/cStorage/cStorage.full.min.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/engine.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/util.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/FuncModelAction.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/SystemModelAction.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/EntityAction.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/PageAction.js'></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/CipWorkFlowListAction.js"></script>
<title>应用列表</title>
</head>
<body class="myappbody">
<div class="app_nav clearfix">
	<b class="myapp_icon top_float_left"></b>
	<span class="app_name" id="entityTitle"></span>
	  &nbsp;&nbsp;&nbsp;包路径：com.comtop.<span class="app_name" id="funcCode"  uitype="Input" width="200"></span>
	<span uitype="Button" label="保存" icon="floppy-o" on_click="funcSave"></span>
	<!-- <i class="cui-icon" id="funcSaveBtn" style="cursor: pointer;padding: 2px;">&#xf0c7;&nbsp;保存</i> -->
	<div  class="top_float_right clearfix" style="margin: 8px 10px 0 0;">
		<span uitype="Button" label="编辑" button_type="blue-button" icon="pencil-square-o" on_click="funEdit"></span>
	</div>
</div>
<div class="app_box">
	<div class="app_container">
		<div class="app_attr clearfix">
			<div class="app-category clearfix">
				<i class="place-left cui-icon">&#xf101;</i>
				<div class="place-left">实体<em id="entityPanelCount"></em></div>
				<hr>
			</div>
			<div class="app_items"  id="entityPanel">
			</div>
		</div>
		<div class="app_attr clearfix">
			<div class="app-category clearfix">
				<i class="place-left cui-icon">&#xf101;</i>
				<div class="place-left">服务<em id="servicePanelCount"></em></div>
				<hr/>
			</div>
			<div class="app_items" id="servicePanel">
			
			</div>
		</div>
		<div class="app_attr clearfix">
			<div class="app-category clearfix">
				<i class="place-left cui-icon">&#xf101;</i>
				<div class="place-left">界面<em id="pagePanelCount"></em></div>
				<hr>
			</div>
			<div class="app_items" id="pagePanel">
			</div>
		</div>
		<div class="app_attr clearfix">
			<div class="app-category clearfix">
				<i class="place-left cui-icon">&#xf101;</i>
				<div class="place-left">未部署工作流<em id="workflowPanelCount"></em></div>
				<hr>
			</div>
			<div class="app_items"  id="workflowPanel">
				
			</div>
		</div>
	</div>
</div>
<!-- 实体展现方式  -->
<script type="text/template" id="entityTemplate">
<ul class="app_item">
	<@ _.each(entitys,function(item){  @>
		<li target="_blank" data-url="<@=newurl@>&entityId=<@=item.id@>">
			<i class="cui-icon">&#xf0c2;</i>
			<span><@=item.englishName@>[<@=item.chineseName@>]</span>
			<i class="colsebtn" data-id="<@=item.id@>" data-type="<@=id@>"></i>
		</li>
	<@})@>
		<li class="last" id="entityAdd"><i class="cui-icon">&#xf067;</i><span>新增</span></li>
</ul>
</script>
<!-- 页面展现方式 -->
<script type="text/template" id="pageTemplate">
<ul class="app_item">
	<@ _.each(entitys,function(item){ @>
		<li target="_blank" data-url="<@=newurl@>&Id=<@=item.id@>">
			<i class="cui-icon">&#xf0c2;</i>
			<span><@=item.englishName@>[<@=item.title@>]</span>
			<i class="colsebtn" data-id="<@=item.id@>" data-type="<@=id@>"></i>
		</li>
	<@})@>
		<li class="last"  target="_blank" data-url="<@=newurl@>"><i class="cui-icon">&#xf067;</i><span>新增</span></li>
</ul>
</script>
<!-- 工作流展现方式 -->
<script type="text/template" id="workflowTemplate">
<ul class="app_item">
	<@ _.each(entitys,function(item){ @>
		<li target="_blank" data-url="<@=newurl@>&Id=<@=item.id@>">
			<i class="cui-icon">&#xf0c2;</i>
			<span><@=item.processId@>[<@=item.name@>]</span>
			<i class="colsebtn" data-id="<@=item.deployeId@>" data-type="<@=id@>"></i>
		</li>
	<@})@>
		<li class="last"  target="_blank" data-url="<@=newurl@>"><i class="cui-icon">&#xf067;</i><span>新增</span></li>
</ul>
</script>
<script type="text/javascript">
	
	//应用ID
	var funcId = "${param.packageId}";
	//个性化设置
	if(cst.exists("appStorage")){
		var data = cst.use("appStorage").get("displayArea");
		$.each(data,function(key,value){
			$("#"+key).parent().find(".cui-icon").html(value?"&#xf101;":"&#xf103;");
			$("#"+key).css("display",value?"block":"none");
		})
	}else{
		var myStorage = cst.use("appStorage");
		//设置以个值
		myStorage.set("displayArea",{
			entityPanel:false,
			servicePanel:false,
			pagePanel:false,
			workflowPanel:false
		});
		$(".app_items").hide();
	} 
	
	//应用的VO信息--获得应用的名称（com.comtop.系统编码.目录编码.应用编码）
	var func;
	//包路径信息 
	var funcFullCode;
	var moduleVO;
	//应用下的实体信息 
	var entity;
	//应用下的服务信息
	var service;
	//应用下的界面信息
	var page;
	//应用下的流程信息
	var workflow;
	
	dwr.TOPEngine.setAsync(false);
	FuncModelAction.readFunc(funcId,function(data){ //应用
		func = data;
	});
	SystemModelAction.queryConnectCodeByModuleId(func.parentFuncId,function(data){ //包路径
		moduleVO = data;
		funcFullCode = data.fullPath;
	});
	var query = {packageId:func.parentFuncId};
	EntityAction.queryEntityList(query,function(data){ //实体
		entity = data.list;
	});
	PageAction.queryPageList(query, function(data){
		page = data.list;
	});
	CipWorkFlowListAction.queryDeployeEdProcesses(func.funcCode,globalUserId,1,100,function(data){
		workflow = data.list;
	});
	dwr.TOPEngine.setAsync(true);
	
	$(".app-category").click(function(){
		var label = $(".cui-icon",this).text();
		if($(this).next().is(":visible")){
			$(".cui-icon",this).html("&#xf103;");
		}else{
			$(".cui-icon",this).html("&#xf101;");
		}
		$(this).next().toggle();
		//使用缓存记录下用户点张开过的现
		if(cst.exists("appStorage")){
			var data = cst.use("appStorage").get("displayArea");
			data[$(this).next().attr("id")] = $(this).next().is(":visible");
			cst.use("appStorage").set("displayArea",data);
		}
	})
	
	//渲染每个item【实体，服务，工作流】
	function renderer(id,obj){
		var entityArea = _.template($("#entityTemplate").html(),{
			entitys:obj,
			newurl:"/web/cap/bm/dev/entity/entityMainTab.jsp?mainFrame=false"}
		);
		$("#"+id+"Count").text(obj.length);
		$("#"+id).html(entityArea);
	}
	
	function pageRender(id,obj,url){
		var entityArea = _.template($("#"+id+"Template").html(),{
			entitys:obj,
			id:id,
			newurl:url}
		);
		$("#"+id+"PanelCount").text(obj.length);
		$("#"+id+"Panel").html(entityArea);
	}
	
//==================事件处理区域==================	
	//应用基本信息保存事件
	function funcSave(){
		var fullPath = cui("#funcCode").getValue();
		if(fullPath == null || $.trim(fullPath) == ""){
			cui.alert('包路径不能为空！');
		}else{
			moduleVO.fullPath = "com.comtop."+cui("#funcCode").getValue();
			dwr.TOPEngine.setAsync(false);
			SystemModelAction.updateModuleVO(moduleVO, function(data){
				if(data) {
					cui.message('保存成功！','success');
				}else{
					cui.message('保存失败', "error");
				} 
			});
			dwr.TOPEngine.setAsync(true);
		}
	}
	
	//应用编辑事件
	function funEdit(event, self, mark){
		if(self.getLabel()==="编辑"){
			self.setLabel("取消编辑");
		}else{
			self.setLabel("编辑");
		}
	}
	//实体删除事件
	function entityDel(id){
		//需要判断实体是否允许删除
		dwr.TOPEngine.setAsync(false);
		//验证能否被删除
 		EntityAction.isAbleDelete(id,function(data){
 			if(data != "") {
 				valIsAbleDelete = false;
 				cui.alert(data);
 			}else {
 				valIsAbleDelete = true;
 			}
 		});
		//如果不允许删除则直接返回
		if(!valIsAbleDelete) {
			dwr.TOPEngine.setAsync(true);
				return ;
		}
		var deleteEntity = [{id:id}];
 		EntityAction.delEntitys(deleteEntity,function(msg){
 			cui.message(msg,"success");
 		});
 		dwr.TOPEngine.setAsync(true);
	}
	//页面删除事件
	function pageDel(id){
		var deletePage = [id];
		dwr.TOPEngine.setAsync(false);
		PageAction.deletePageList(deletePage, function(result) {
				cui.message("删除成功。","success");
            });
    	dwr.TOPEngine.setAsync(true);
	}
	//工作流删除事件
	function workflowDel(id){
		var deleteWorkflow = [id];
		dwr.TOPEngine.setAsync(false);
		CipWorkFlowListAction.deleteDeployeById(func.funcCode,deleteWorkflow,globalUserId,function(result){
			if(result == 1) {
				cui.message("删除成功。","success");
			} else {
				cui.message("删除失败。","error");							
			}
		});
		dwr.TOPEngine.setAsync(true);
	}

//==================事件处理区域End==================
	require(["underscore","cui"],function(){
		comtop.UI.scan();
		
		pageRender("entity",entity||[],"/web/cap/bm/dev/entity/entityMainTab.jsp?mainFrame=false");
		pageRender("page",page||[],"/web/cap/bm/dev/entity/entityMainTab.jsp?mainFrame=false");
		pageRender("workflow",workflow||[],"/web/cap/bm/dev/entity/entityMainTab.jsp?mainFrame=false");
		renderer("servicePanel",service||[]);
		cui("#entityAdd").menu({
			datasource:[
			{id:'item1',label:"新增业务实体",target:"_blank",href:"/web/cap/bm/dev/entity/entityMainTab.jsp?entityType=bsEntity"},
			{id:'item1',label:"新增查询实体",target:"_blank",href:"/web/cap/bm/dev/entity/entityMainTab.jsp?entityType=queryEntity"}],
			type:"button",
			width:100,
			trigger:"mouseover"
			});
		
		
		//给标题赋值
		$("#entityTitle").text(func.funcName);
		cui("#funcCode").setValue(funcFullCode);
		
		$(".app_item").on("click",".colsebtn",function(e){
			var that = this;
			e.stopPropagation();
			cui.confirm('确认要删除信息吗？', {
				onYes: function(){
					var type = $(that).data("type"),id=$(that).data("id");
					if(type=="entity"){
						entityDel(id)
					}else if(type=="page"){
						pageDel(id);
					}else if(type=="workflow"){
						workflowDel(id);
					}
				},
				onNo: function(){
					//do nothing
				}
			});
		})
		
	});
</script>
</body>
</html>