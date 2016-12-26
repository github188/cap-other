<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>页面模板渲染行为列表"</title>
<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
<top:link href="/cap/bm/common/base/css/base.css"></top:link>
<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css" />

<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
<top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
<top:script src="/cap/dwr/engine.js"></top:script>
<top:script src="/cap/dwr/util.js"></top:script>
<top:script src="/cap/dwr/interface/PageTemplateActionPreferenceFacade.js"></top:script>
</head>
<body>
	<div class="main">
		<table style="width: 100%">
			<tr>
				<td class="cap-td" style="text-align: left; padding: 5px;width: 50%">
					<span id="formTitle" uitype="Label" value="行为模板列表" class="cap-label-title" size="12pt"></span>
				</td>
				<td class="cap-td" style="text-align: right; padding: 5px;width: 50%">
					<span id="createVariablePreference" uitype="Button" onclick="createPageTemplateAction()" label="新增"></span> 
					 <span id="deleteVariablePreference" uitype="Button" onclick="deletePageTemplateAction()" label="删除"></span>
				</td>
			</tr>
		</table>
		<table id="listPageTemplateAction" uitype="grid" datasource="initData" primarykey="actionId" ellipsis="false" pagination="false" resizewidth="resizeWidth" resizeheight="resizeHeight">
			<thead>
				<tr>
					<th width="5%" bindName="actionId"><input type="checkbox"></th>
					<th width="5%" renderStyle="text-align: center" disabled="true" bindName="1">序号</th>
					<th renderStyle="text-align:left;" bindName="actionDefineVO.cname" width="20%" >行为模板中文名</th>
					<th renderStyle="text-align:left;" bindName="actionId" width="40%">行为模板英文名</th>
					<th renderStyle="text-align:left;" bindName="actionDefineVO.description" width="30%" >描述</th>
				</tr>
			</thead>
		</table>
	</div>
	<script>
		var actionPreferenceVO = {};
		
		/**
		* 设置grid数据源
		*
		* @param grid 表格组件对象
		* @param query Json对象：包含分页信息和题头排序信息
		*/
		function initData(grid, query) {
			dwr.TOPEngine.setAsync(false);
			PageTemplateActionPreferenceFacade.getDefaultPageTemplateActionPreference(function(data) {
				if(data&& data != null){
					actionPreferenceVO = data;
					gridDatasource = actionPreferenceVO.lstActions;
					//gridDatasource = wrapperPageTemplateAction(data);
				}else{
					gridDatasource = [];
				}
				grid.setDatasource(gridDatasource, gridDatasource.length);
			});
			dwr.TOPEngine.setAsync(true);
		}
	   
		function resizeWidth() {
			return (document.documentElement.clientWidth || document.body.clientWidth) - 4;
		}
	
		function resizeHeight() {
			return (document.documentElement.clientHeight || document.body.clientHeight) - 50;
		}
		
		//页面装载方法
		jQuery(document).ready(function(){
			comtop.UI.scan();
		});
		
		/**
    	 * 打开window原生窗口
    	 * @param event
    	 * @param self
    	 */
		function createPageTemplateAction(){
    		var url='${pageScope.cuiWebRoot}/cap/bm/dev/page/actionlibrary/ActionTemplateList.jsp?callbackMethod=selectActionTmp';
    		var width=800; //窗口宽度
    	    var height=600;//窗口高度
    	    var top=(window.screen.height-30-height)/2;
    	    var left=(window.screen.width-10-width)/2;
    	    window.open(url, "_blank", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
		}
		
		function checkRenderActionExist(selectedActionTmp){
			var lstAction = actionPreferenceVO.lstActions;
			for(var i = 0;i< lstAction.length;i++){
				if(lstAction[i].actionId === selectedActionTmp.modelId){
					return true;
				}
			}
			return false;
		}
		
		/**
	     * 选择行为类型回调函数
	     * @param obj 行为模版对象
	     */
	    function selectActionTmp(obj){
	    	if(obj!=null){
	    		if(checkRenderActionExist(obj)){
	    			cui.alert('选择的行为模板:'+obj.cname+'已经存在。');
	    			return;
	    		}
	    		var pageTemplateActionVO={};
	    		pageTemplateActionVO.actionId=obj.modelId;
	    		actionPreferenceVO.lstActions.push(pageTemplateActionVO);
	    	} else {
	    		return;
	    	}
	    	dwr.TOPEngine.setAsync(false);
	    	PageTemplateActionPreferenceFacade.save(actionPreferenceVO,function(data) {
				rs = data;
				if(rs){
					cui.message('保存成功！', 'success');
					cui('#listPageTemplateAction').loadData();
				}else{
					cui.error("保存失败！"); 
				}
			});
			dwr.TOPEngine.setAsync(true);
	    }

		function deletePageTemplateAction(){
			var selectIndexs = cui("#listPageTemplateAction").getSelectedIndex();
			if(selectIndexs == null || selectIndexs.length == 0){
				cui.alert("请选择要删除的元数据。");
				return;
			}
			cui.confirm("确定要删除这"+selectIndexs.length+"个元数据吗？",{
				onYes:function(){
					for(var i=0;i< selectIndexs.length;i++){
						cui("#listPageTemplateAction").removeData(selectIndexs[i]);
					}
					actionPreferenceVO.lstActions = cui("#listPageTemplateAction").getData();
					PageTemplateActionPreferenceFacade.save(actionPreferenceVO,function(data) {
						if(data){
							cui("#listPageTemplateAction").loadData();
							cui.message("删除成功。","success");
						} else {
							cui.message("删除失败。","error");
						}
					})
				}
			});
		}
		
 	</script>
</body>
</html>