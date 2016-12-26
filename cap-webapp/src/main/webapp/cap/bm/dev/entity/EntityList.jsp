
<%
/**********************************************************************
* 实体列表
* 2015-9-27 章尊志  新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>实体列表</title>
<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
<top:link href="/cap/bm/common/base/css/base.css"></top:link>
<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"></top:link>

<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
<top:script src="/cap/bm/common/base/js/angular.js"></top:script>
<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
<top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
<top:script src='/cap/dwr/engine.js'></top:script>                        
<top:script src='/cap/dwr/util.js'></top:script>
<top:script src='/cap/dwr/interface/EntityOperateAction.js'></top:script>
<top:script src='/cap/dwr/interface/EntityFacade.js'></top:script>
<top:script src='/cap/bm/dev/consistency/js/consistency.js'></top:script>

<script type="text/javascript">
var GEN_CODE_PATH_CNAME = "GEN_CODE_PATH_CNAME";//生成代码路径key 
var _=cui.utils;
var packageId = "${param.packageId}";//包ID
var moduleCode = "${param.packageModuleCode}";

var menu_gen_data = {
					 datasource:
						[						
        				 {id:'gen_all',label:'生成所有代码',title:'生成所有后台Java代码与SQL配置文件'},
                     	 {id:'gen_vo',label:'生成VO代码',title:'生成VO类及SQL配置文件'},
                     	 {id:'gen_sql',label:'生成SQL脚本',title:'生成并执行SOA服务相关脚本'},
                     	 {id:'gen_biz',label:'生成业务代码',title:'生成除SQL配置文件生成所有后台代码'}
                      	],
					 on_click: function(obj){
						 var type = obj.id;
						 var genType = 0;
						 if("gen_all" === type){
							 genType = 0;
						 }else if("gen_vo" === type){
							 genType = 1;
						 }else if("gen_biz" === type){
							 genType = 2;
						 }else if("gen_sql" === type){
							 genType = 3;
						 }
						 generateCode(genType);
					 }
					};

var menu_add_entity = {
		 datasource:
				[						
			    {id:'biz_entity',label:'新增业务实体',title:'生成所有后台Java代码与SQL配置文件,只能通过导入数据表的方式创建'},
          	    {id:'query_entity',label:'新增查询实体',title:'只生成查询方法'},
          	 	{id:'data_entity',label:'新增数据实体',title:'只生成VO'},
          	 	{id:'exist_entity',label:'录入已有实体',title:'不生成代码',
          	 		items:[{id:'exist_query_entity',label:'查询实体'},
          	 	          {id:'exist_data_entity',label:'数据实体'}]}
           		],
				 on_click: function(obj){
					 //如果是业务实体，则直接跳到导入表的方式
					 if("biz_entity" == obj.id){
						cui.confirm("新增业务实体只能通过导入数据表的方式创建，是否创建业务实体?",{
							onYes:function(){
								importEntity();
							}
						});
					 }else if("query_entity" == obj.id){
					 	addEntity(obj.id,"user_create","新建查询实体");
					 }else if("data_entity" == obj.id){
					 	addEntity(obj.id,"user_create","新建数据实体");
					 }else if("exist_query_entity" == obj.id){
					 	addEntity("query_entity","exist_entity_input","录入已有查询实体");
					 }else if("exist_data_entity" == obj.id){
					 	addEntity("data_entity","exist_entity_input","录入已有数据实体");
					 }
			 }
			};

window.onload = function(){
	comtop.UI.scan();
}

//grid数据源
function initData(tableObj,query){
	dwr.TOPEngine.setAsync(false);
	EntityFacade.queryEntityList(packageId,function(data){
		tableObj.setDatasource(data, data.length);
	});
	dwr.TOPEngine.setAsync(true);
}


var dialog;
/**
* 新增实体
*@param entityType 实体类型
*@param entitySource 实体来源
*@param title 弹出框标题
*/
function addEntity(entityType,entitySource,title) {
	//window.location.href=getEditUrl("","",entityType);
	var height = 200;
	var width = 450;
	var url ='EntityNameEdit.jsp?entityType='+entityType+"&openType=listToMain&modelId=&packageId="+packageId+"&entitySource="+entitySource+"&moduleCode="+moduleCode;
	if(!dialog){
		dialog = cui.dialog({
		  	title : title,
		  	src : url,
		    width : width,
		    height : height
		});
	}
 	dialog.show(url);
}

//关闭实体名称编辑窗口
function closeEntityNameWindow(){
	dialog.hide();
}

var entity;
//实体名称编辑回调
function saveEntityNameCallBack(entity,openType,moduleCode){
		entity.modelType="entity";
	    entity.modelName=entity.engName;
	    entity.modelId=entity.modelPackage+"."+entity.modelType+"."+entity.modelName;
	    entity.packageId = packageId;
	    dwr.TOPEngine.setAsync(false);
		   EntityFacade.saveEntity(entity,function(result){
			  if(result){
			  }
		   });
		dwr.TOPEngine.setAsync(true);
		var url = "EntityMain.jsp?modelId=" + entity.modelId + "&packageId=" + entity.packageId + "&entityType="+entity.entityType+"&moduleCode="+moduleCode+"&openType=listToMain"; 
		window.location.href=url;
}

var importEntityWin = null;
// 导入实体
function importEntity() {
	var importEntityWin = "EntityImport.jsp?packageId=" + packageId +"&openType=listToMain";
	try {
		importEntityWin.close();
	}catch(e){}
	importEntityWin = window.open(importEntityWin,"importEntityWin");
}

//导入实体回调
function importCallback(){
	cui("#EntityGrid").loadData();
}

// 编辑实体
function updateEntity(id,modelId,entityType) {
	window.location.href=getEditUrl(id,modelId,entityType);
}


function getEditUrl(mId,modelId,entityType) {
	return "EntityMain.jsp?modelId=" + modelId + "&packageId=" + packageId + "&entityType="+entityType+"&moduleCode="+moduleCode+"&openType=listToMain"; 
}

var valIsAbleDelete = true;
// 删除方法
function delEntity() {
	//TODO..需要判断实体是否允许删除
	var selects = cui("#EntityGrid").getSelectedRowData();
	if(selects == null || selects.length == 0){
		cui.alert("请选择要删除的实体。");
		return;
	}
	
	
	cui.confirm("确定要删除这"+selects.length+"个实体吗？",{
		onYes:function(){
			dwr.TOPEngine.setAsync(false);
            //实体一致性校验
            if(!checkConsistency(cui("#EntityGrid").getSelectedRowData(),"entity")){
            	dwr.TOPEngine.setAsync(true);
            	return ;
            }

			var selectIds = cui("#EntityGrid").getSelectedPrimaryKey();
			EntityFacade.delEntitys(selectIds,function(data){
				if(data){
					cui.message("删除成功。","success");
				}
	 			cui("#EntityGrid").loadData();
	 		});
	 		dwr.TOPEngine.setAsync(true);
		}
	});
}



// 生成实体代码
function generateCode(type) {
	var selects = cui("#EntityGrid").getSelectedRowData();
	if(selects == null || selects.length == 0){
		cui.alert("请选择要生成代码的实体。");
		return;
	}
	
	for(var i=0;i<selects.length;i++){
		var select = selects[i];
		if(select.entitySource == "exist_entity_input" || select.entityType == "exist_entity"){
			cui.alert("已有实体不允许生成代码。");
			return;
		}
	}

	createCustomHM();
	EntityOperateAction.executeGenerateCode(cui("#EntityGrid").getSelectedRowData(), packageId, type, function(msg){
			removeCustomHM();
			if ("" == msg ){
				window.top.cui.message('生成代码成功。','success');
			}else{
				window.top.cui.message(msg,'error');
			}
		});
}

var objHandleMask;
//生成遮罩层
function createCustomHM(){
	objHandleMask = cui.handleMask({
        html:'<div style="padding:10px;border:1px solid #666;background: #fff;"><div class="handlemask_image_1"/><br/>正在生成实体，预计需要2~3分钟，请耐心等待。</div>'
    });
	objHandleMask.show();
}

//生成遮罩层
function removeCustomHM(){
	objHandleMask.hide();
}


//grid列渲染
function englishNameRenderer(rd, index, col) {
	return "<a href='javascript:;' onclick='updateEntity(\"" +rd.id+ '","'+rd.modelId+ '","'+rd.entityType+"\");'>" +rd.engName + "</a>";
}
//grid列渲染
function entityTypeRenderer(data,field){
	if(data.entityType == "biz_entity") {
		return "业务实体";
	}else if(data.entityType == "query_entity"){
		if(data.entitySource == "exist_entity_input"){
			return "已有实体";
		}
		return "查询实体";
	}else if(data.entityType == "data_entity"){
		if(data.entitySource == "exist_entity_input"){
			return "已有实体";
		}
		return "数据实体";
	}
}

//grid 宽度
function resizeWidth(){
	return (document.documentElement.clientWidth || document.body.clientWidth) - 30;
}

//grid高度
function resizeHeight(){
	return (document.documentElement.clientHeight || document.body.clientHeight) - 75;
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
	if(type=="entity"){
		EntityFacade.checkEntity4BeingDependOn(selectDatas,function(redata){
			if(redata){
				  if (!redata.validateResult) {//有错误
					  dependOnCurrentData = redata.dependOnCurrent==null?[]:redata.dependOnCurrent;
					  initOpenConsistencyImage(checkUrl);
					  checkflag = false;
					  cui.alert('当前选择实体不能被删除，请检查元数据一致性！');
				  }else{
					  initOpenConsistencyImage(checkUrl);//通过则关闭div和dialog
					  //checkflag = false;
					  //cui.alert('当前选择实体不能被删除，请检查元数据一致性！');
				  }
			  }else{
				  cui.error("元数据一致性效验异常，请联系管理员！"); 
			  }
		});
	}
	dwr.TOPEngine.setAsync(true);
	return checkflag;
}
</script>
</head>
<body>
	<div id="pageRoot" class="cap-page">
		<div class="cap-area" style="width: 100%;">
			<table class="cap-table-fullWidth">
				<tr>
					<td class="cap-td" style="text-align: left; padding: 5px">
						<span id="formTitle" uitype="Label" value="实体列表信息" class="cap-label-title" size="12pt"></span>
					</td>
					<td class="cap-td" style="text-align: right; padding: 5px">
                        <span uitype="button" label="新增" id="menu_add_entity"  menu="menu_add_entity"></span>
	                    <!--  <span uitype="button" label="新增" id="addEntity" on_click="addEntity"></span> -->
		                <span uitype="button" label="导入" id="button_add" on_click="importEntity"></span>
		                <span uitype="button" label="删除" id="button_del" on_click="delEntity"></span>
		                <span uitype="button" label="生成代码" id="button_executeGenerateCode"  menu="menu_gen_data"></span>
					</td>
				</tr>
			</table>
			<table class="cap-table-fullWidth">
				<tr>
					<td class="cap-td">
						<table uitype="Grid" id="EntityGrid" primarykey="modelId" colhidden="false" datasource="initData" pagination="false"
							resizewidth="resizeWidth" resizeheight="resizeHeight"
							colrender="columnRenderer">
							
							<thead>
								<tr>
									<th style="width: 30px" renderStyle="text-align: center;">
									<input type="checkbox"></th>
									<th style="width: 50px" renderStyle="text-align: center;" bindName="1">序号</th>
									<th style="width:18%;" renderStyle="text-align: left" render="englishNameRenderer" bindName="engName">实体名称</th>
									<th style="width:18%;" renderStyle="text-align: left" bindName="chName">中文名称</th>
									<th style="width:18%;" renderStyle="text-align: left" bindName="dbObjectName">对应表</th>
									<th style="width:24%;" renderStyle="text-align: center;" bindName="modelPackage">包路径</th>
									<th style="width:22%;" renderStyle="text-align: center;" render="entityTypeRenderer" bindName="entityType">实体类型</th>
								</tr>
							</thead>
						</table>
					</td>
				</tr>
				<tr>
					<td class="cap-td"></td>
				</tr>
			</table>
		</div>
	</div>
</body>
</html>