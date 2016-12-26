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
<top:script src="/cap/dwr/interface/ActionDefineFacade.js"></top:script>

</head>
<body>
	<div class="main">
		<table style="width: 100%">
			<tr>
				<td class="cap-td" style="text-align: left; padding: 5px;width: 50%">
					<span id="formTitle" uitype="Label" value="自定义行为列表" class="cap-label-title" size="12pt"></span>
				</td>
				<td class="cap-td" style="text-align: right; padding: 5px;width: 50%">
					<span id="createPage" uitype="Button" onclick="createCustomAction()" label="新增"></span> 
					 <span id="deletePage" uitype="Button" onclick="deleteCustomAction()" label="删除"></span>
				</td>
			</tr>
		</table>
		<table id="actionList" uitype="grid" datasource="initData" primarykey="modelId" ellipsis="true" pagination="false" resizewidth="resizeWidth" resizeheight="resizeHeight" >
			<thead>
				<tr>
					<th width="30px" bindName="fileName"><input type="checkbox"></th>
					<th style="width: 40px" renderStyle="text-align: center;" bindName="1">序号</th>
					<th renderStyle="text-align:center;" bindName="cname" width="20%" render="editActionCname">中文名称</th>
					<th renderStyle="text-align:center;" bindName="modelName" width="20%" >英文名称</th>
					<th renderStyle="text-align:center;" bindName="modelPackageCnName" width="15%" render="showModelPackage">分组中文名</th>
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
			var expression = "action[contains(modelPackage,'actionlibrary.customAction')]";
			//expression = "action[type='custom']";
			ActionDefineFacade.queryList(expression,function(data) {
				grid.setDatasource(data, data.length);
			});
			dwr.TOPEngine.setAsync(true);
		}
		
		//页面装载方法
		jQuery(document).ready(function(){
			comtop.UI.scan();
		});
		
		function createCustomAction(){
				window.open("CustomActionEdit.jsp","_self");
		}
		
		//跳转编辑页面列渲染
		function editActionCname(rd, index, col){
			var modelId = rd["modelId"];
		   return "<a href='CustomActionEdit.jsp?modelId="+modelId+"' target='_self'>" + rd['cname'] + "<a>";
		}
		
		//分组中文名渲染
		function showModelPackage(rd, index, col){
			return rd["modelPackageCnName"];
		}

		//删除自定义行为
		function deleteCustomAction(){
			var selectPrimaryDatas = cui("#actionList").getSelectedPrimaryKey();
			var selectDatas = cui("#actionList").getSelectedRowData();
			if(selectPrimaryDatas == null || selectPrimaryDatas.length == 0){
				cui.alert("请选择要删除的元数据。");
				return;
			}
			cui.confirm("确定要删除这"+selectPrimaryDatas.length+"个自定义行为吗？",{
				onYes:function(){
					createCustomHM();
 					ActionDefineFacade.deleteList(selectPrimaryDatas,function(data) {
 						removeCustomHM();
 						cui("#actionList").loadData();
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
			errorInfo +="等行为被页面已使用，不可删除！";
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