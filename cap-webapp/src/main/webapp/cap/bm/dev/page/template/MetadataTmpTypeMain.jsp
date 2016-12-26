<%
/**********************************************************************
* 元数据模板分类管理
* 2015-12-30 诸焕辉 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <title>元数据模板分类管理</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<style type="text/css">
	</style>
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
    <top:script src='/cap/dwr/engine.js'></top:script>
    <top:script src='/cap/dwr/util.js'></top:script>
    <top:script src='/cap/dwr/interface/MetadataTmpTypeFacade.js'></top:script>
</head>
<body>
	<div uitype="Borderlayout" id="body" is_root="true">
        <div id="leftMain" position="left" style="overflow:hidden" width="250" collapsable="true" show_expand_icon="true"> 
	        <div style="padding-top:1px;width:100%;position:relative;">
	           	<div style="padding-bottom:10px;padding-left:10px;padding-top:10px;">
	            	<span uitype="button" id ="addMeatadataTmpTypeBtn" label="新增分类" on_click="openEditMetadataTmpType"></span>
	             	<span uitype="button" id ="editMeatadataTmpTypeBtn" label="编辑分类" disable="true" on_click="openEditMetadataTmpType"></span>
	             	<span uitype="button" id ="delMeatadataTmpTypeBtn" label="删除分类" disable="true" on_click="deleteMetadataTmpType"></span>
	            </div>
	            <div style="padding-left:5px;padding-top:5px;padding-bottom:3px;background-color:#ebeced;color:#000">模板分类列表：</div>
			</div>
			<div id="treeDivHight" style="overflow:auto;height:100%;">
	             <div id="templateTypeTree" uitype="Tree" children="initTreeData" on_lazy_read="loadNode" on_click="metadataTmpTypeTreeClick" click_folder_mode="1"></div>
		    </div>
        </div>
		<div id="centerMain" position ="center">
			<table class="cap-table-fullWidth" width="100%">
			    <tr>
			        <td class="cap-td" style="text-align: left;padding:5px">
			        	<span class="cap-group">模板列表</span>
			        </td>
			    </tr>
			</table>
			<table class="cap-table-fullWidth">
			    <tr>
			        <td class="cap-td">
						<table uitype="Grid" id="metadataTemplate" primarykey="id" selectrows="no" colhidden="false" datasource="initMetadataTmpData" pagination="false"
						 	resizewidth="getBodyWidth" resizeheight="getBodyHeight"  colrender="columnRenderer">
							<thead>
								<tr>
									<th style="width:35px" renderStyle="text-align: center;" bindName="1">序号</th>
									<th style="width:20%" renderStyle="text-align: left" bindName="cname">模板中文名</th>
									<th style="width:25%" renderStyle="text-align: left" bindName="ename">模板英文名</th>
									<th style="width:20%" renderStyle="text-align: left" bindName="description">描述</th>
								</tr>
							</thead>
						</table>
			        </td>
			    </tr>
			</table>
		</div>
	</div>
	<script type="text/javascript">
		var selectTemplateCode=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("selectTemplateCode"))%>;
		var openType = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("openType"))%>;//listToMain
	    var modelPackage = "";
	    var metadataConfigModelId = "";
		//当前点击树节点分类编码
		var clickNodeTemplateCode = '-1';
		
		$(document).ready(function(){
			comtop.UI.scan();   //扫描
		});
		
		//初始化数据 
		function initTreeData(obj) {
			dwr.TOPEngine.setAsync(false);
			MetadataTmpTypeFacade.queryMetadataTmpTypeView(function(data) {
				obj.setDatasource(data);
			})
			dwr.TOPEngine.setAsync(true);
		}
		
		//初始化模板列表
		function initMetadataTmpData(gridObj, query) {
			var datasource = [];
			if(metadataConfigModelId != ''){
				dwr.TOPEngine.setAsync(false);
				MetadataTmpTypeFacade.queryPageTmpList(metadataConfigModelId, function(data){
					datasource = data;
				});
				dwr.TOPEngine.setAsync(true);
			}
			gridObj.setDatasource(datasource, datasource.length);
		}
		
		//打开新增编辑模板分类页面
	    var addTemplateDialog;
	    function openEditMetadataTmpType(event, el){
			var height = 200;
			var width = 450;
			var title = '新增模版分类';
			var url = '../template/EditMetadataTmpType.jsp';
			if(el.options.label=='编辑分类'){
				var node = cui('#templateTypeTree').getNode(clickNodeTemplateCode);
				var clickNodeTemplateName = node.getData().title;
				url += '?operationType=edit&temlateTypeName='+encodeURIComponent(encodeURIComponent(clickNodeTemplateName))+'&temlateTypeCode='+clickNodeTemplateCode;
				title = "编辑模版分类";
			}else{
				url += '?operationType=add';
			}
			if(!addTemplateDialog){
				addTemplateDialog = cui.dialog({
				  	title : title,
				  	src : url,
				    width : width,
				    height : height
				    //left:'30%',
				    // top:'30%'
				});
			} else {
				addTemplateDialog.title=title;
				addTemplateDialog.src = url;
			}
			addTemplateDialog.show(url);
		}
		
		function saveTemplateType(obj, type){
			if(type === 'add'){
				addMetadataTmpType(obj);
			} else {
				editMetadataTmpType(obj);
			}
		}
		
		//新增模板分类
		function addMetadataTmpType(obj){
			var metadataTmpTypeVO ={typeCode:obj.templateTypeCode, typeName:obj.templateTypeName};
			var isSuccess = false;
			dwr.TOPEngine.setAsync(false);
			MetadataTmpTypeFacade.addMetadataTmpTypeNode(metadataTmpTypeVO, obj.parentemplateTypeCode, function(data){
				if(data){
					isSuccess = true;
					cui.message("分类新增成功","success");
				} else {
					cui.message("分类新增失败","error");
				}
			});
			dwr.TOPEngine.setAsync(true);
			if(isSuccess){
				refrushNode("add", obj.templateTypeCode)
			}
		}
		
		//编辑模板分类
		function editMetadataTmpType(obj){
			var metadataTmpTypeVO ={typeCode:obj.templateTypeCode, typeName:obj.templateTypeName};
			var isSuccess = false;
			dwr.TOPEngine.setAsync(false);
			MetadataTmpTypeFacade.updateMetadataTmpTypeNode(metadataTmpTypeVO, function(data){
				if(data){
					isSuccess = true;
					cui.message("分类编辑成功","success");
				} else {
					cui.message("分类编辑失败","error");
				}
			});
			dwr.TOPEngine.setAsync(true);
			if(isSuccess){
				refrushNode("edit", clickNodeTemplateCode);
			}
		}
		
		//删除模板分类
		function deleteMetadataTmpType(){
			var templateData = cui("#metadataTemplate").getData();
			var node = cui('#templateTypeTree').getNode(clickNodeTemplateCode);
			var nodeName = node.getData().title;
			var valData = isGenerateMetadata(clickNodeTemplateCode);
			if(valData.result === '1'){
				cui.confirm("确定要删除【<font color='red'>" + nodeName + "</font>】吗？", {
			        onYes: function(){
			        	MetadataTmpTypeFacade.deleteMetadataTmpType(clickNodeTemplateCode, function(data){
			        		if(data){
			    				cui.message("分类删除成功","success");
			    				cui("#editMeatadataTmpTypeBtn").disable(true);
			    		    	cui("#delMeatadataTmpTypeBtn").disable(true);
			    				refrushNode("delete", '');
			    			}else{
			    				cui.message("分类删除失败","error");
			    			}
						});
			        }
		    	});
			} else {
				cui.alert("选择的【<font color='red'>"+nodeName+"</font>】分类界面模版已被使用，请到【模板实例化元数据列表】页面上删除以下文件，再执行该操作:<br/>"+valData.message);
			}
		}
		
		// 检验是否可以删除
		function isGenerateMetadata(typeCode){
			var ret = {};
			dwr.TOPEngine.setAsync(false);
			MetadataTmpTypeFacade.isGenerateMetadata(typeCode, function(data){
				ret = data;
			});
			dwr.TOPEngine.setAsync(true);
			return ret;
		}
		
		//刷新树
		function refrushNode(type, templateTypeCode){
			dwr.TOPEngine.setAsync(false);
			var obj = cui("#templateTypeTree");
			MetadataTmpTypeFacade.queryMetadataTmpTypeView(function(data){
				obj.setDatasource(data);
				if (type === "edit"){
					obj.getNode(templateTypeCode).activate(true);
					metadataTmpTypeTreeClick(obj.getActiveNode());
				} else if(type === "add"){
					obj.getNode(templateTypeCode).activate(true);
					metadataTmpTypeTreeClick(obj.getActiveNode());
				} else if(type === "delete"){
					metadataConfigModelId = templateTypeCode;
					cui("#metadataTemplate").loadData();
				}
			});
			dwr.TOPEngine.setAsync(true);
		}
		
		//树单击事件
	    function metadataTmpTypeTreeClick(node){
	    	var data = node.getData();
	    	clickNodeTemplateCode = data.key;
	    	metadataConfigModelId = node.getData("metadataPageConfigModelId");
	    	cui("#editMeatadataTmpTypeBtn").disable(data.folder);
	    	cui("#delMeatadataTmpTypeBtn").disable(data.folder || data.defaultTemplate);
	    	cui("#metadataTemplate").loadData();
	    }
			
		/**
		 * 表格自适应宽度
		 */
		function getBodyWidth () {
		    return parseInt(jQuery("#centerMain").css("width"))- 10;
		}
	
		/**
		 * 表格自适应高度
		 */
		function getBodyHeight () {
		    return (document.documentElement.clientHeight || document.body.clientHeight) - 71;
		}
	</script>
</body>
</html>