<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>自定义行为列表页面</title>
<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
<top:link href="/cap/bm/common/base/css/base.css"></top:link>
<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css" />

<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
<top:script src="/cap/dwr/engine.js"></top:script>
<top:script src="/cap/dwr/util.js"></top:script>
<top:script src="/cap/dwr/interface/ComponentFacade.js"></top:script>

</head>
<body>
	<div class="main">
		<table style="width: 100%">
			<tr>
				<td class="cap-td" style="text-align: left; padding: 5px;width: 50%">
					<span id="formTitle" uitype="Label" value="自定义控件列表" class="cap-label-title" size="12pt"></span>
				</td>
				<td class="cap-td" style="text-align: right; padding: 5px;width: 50%">
					<span id="createPage" uitype="Button" onclick="createCustomComponent()" label="新增"></span> 
					 <span id="deletePage" uitype="Button" onclick="deleteCustomComponent()" label="删除"></span>
				</td>
			</tr>
		</table>
		<table id="componentList" uitype="grid" datasource="initData" primarykey="modelId" ellipsis="false" pagination="false" resizewidth="resizeWidth" resizeheight="resizeHeight" >
			<thead>
				<tr>
					<th width="30px" bindName="fileName"><input type="checkbox"></th>
					<th style="width: 40px" renderStyle="text-align: center;" bindName="1">序号</th>
					<th renderStyle="text-align:center;" bindName="cname" width="20%" render="editComponentCname">中文名称</th>
					<th renderStyle="text-align:center;" bindName="modelName" width="20%" >英文名称</th>
					<th renderStyle="text-align:center;" bindName="description" width="40%">描述</th>
				</tr>
			</thead>
		</table>
	</div>
	<script>
		
		/**
		* 设置grid数据源
		*
		* @param grid 表格组件对象
		* @param query Json对象：包含分页信息和题头排序信息
		*/
		function initData(grid, query) {
			dwr.TOPEngine.setAsync(false);
			var expression = "component[contains(modelPackage,'uicomponent.custom')]";
			ComponentFacade.queryList(expression,function(data) {
				grid.setDatasource(data, data.length);
			});
			dwr.TOPEngine.setAsync(true);
		}
		
		//页面装载方法
		jQuery(document).ready(function(){
			comtop.UI.scan();
		});
		
		function createCustomComponent(){
				window.open("CustomComponentEdit.jsp","_self");
		}
		
		//跳转编辑页面列渲染
		function editComponentCname(rd, index, col){
			var modelId = rd["modelId"];
		   return "<a href='CustomComponentEdit.jsp?modelId="+modelId+"' target='_self'>" + rd['cname'] + "<a>";
		}
		
		//删除自定义行为
		function deleteCustomComponent(){
			var selectPrimaryDatas = cui("#componentList").getSelectedPrimaryKey();
			var selectDatas = cui("#componentList").getSelectedRowData();
			if(selectPrimaryDatas == null || selectPrimaryDatas.length == 0){
				cui.alert("请选择要删除的控件。");
				return;
			}
			cui.confirm("确定要删除这"+selectPrimaryDatas.length+"个控件吗？",{
				onYes:function(){
					createCustomHM();
					ComponentFacade.deleteList(selectPrimaryDatas,function(data) {
						removeCustomHM();
						cui("#componentList").loadData();
						if(data==null||data.length==0){
							cui.message("删除成功。","success");
						} else {
							var errorInfo = getErrorInfo(selectDatas,data);
							cui.alert(errorInfo);
						}
					}) 
				}
			});
		}
		
		//获取不能删除的提示信息
		function getErrorInfo(selectDatas,data){
			var errorInfo="";
			for(var i=0;i<data.length;i++){
				for(var j=0;j<selectDatas.length;j++){
					if(data[i]==selectDatas[j].modelId){
						errorInfo+=selectDatas[j].cname+"<br/>";
					}
				}
			}
			errorInfo +="等控件被页面已使用，不可删除！";
			 return errorInfo;
		}
		
		function resizeWidth() {
			return (document.documentElement.clientWidth || document.body.clientWidth) - 4;
		}
	
		function resizeHeight() {
			return (document.documentElement.clientHeight || document.body.clientHeight) - 50;
		}
		
		var objHandleMask;
		//生成遮罩层
		function createCustomHM(){
			objHandleMask = cui.handleMask({
		        html:'<div style="padding:10px;border:1px solid #666;background: #fff;"><div class="handlemask_image_1"/><br/>正在删除，请稍后。</div>'
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