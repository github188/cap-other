
<%
/**********************************************************************
* 元数据模版选择页面
* 2015-10-12 诸焕辉
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>元数据模版选择页面</title>
<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
<top:link href="/cap/bm/common/base/css/base.css"></top:link>
<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css" />
<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
<top:script src="/cap/bm/common/base/js/angular.js"></top:script>
<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
<top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
<top:script src='/cap/dwr/engine.js'></top:script>
<top:script src='/cap/dwr/util.js'></top:script>
<top:script src='/cap/dwr/interface/MetadataTmpTypeFacade.js'></top:script>
<style type="text/css">
    .treeArea {
    	height: 300px;
    	margin-top: 5px;
    	border-top:1px solid #e5e5e5;
    	overflow: auto;
    }	
</style>
</head>
<body>
	<div>
		<table class="cap-table-fullWidth">
			<tr>
				<td class="cap-td" style="text-align: left;">
					<span uitype="ClickInput" id="keyword" name="keyword" emptytext="请输入模版名称关键字查询"
						on_iconclick="fastQuery"  icon="search" enterable="true"
						editable="true" width="192" on_keydown="keyDownQuery" ng-model="keyword"></span>
				</td>
				<td class="cap-td" style="text-align: right;">
					<span uitype="Button" id="ensure" onclick="ensure()" label="确定" disable="true"></span>
				</td>
			</tr>
		</table>
		<div class="treeArea">
			<span id="metadataTmpTreeData" uitype="Tree" children="initTreeData" click_folder_mode="1" on_click="selectMetadataTmp"></span>
			<span id="fastQueryList" uitype="MultiNav" datasource="initBoxData"></span> 
		</div>
	</div>
	
	<script type="text/javascript">
		var packageId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
		var openType = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("openType"))%>;//listToMain 区分是从新版界面打开
		//元数据模版分类数据集
		var metadataTmpTypeList = getMetadataTmpType();
		
		var metadataTmpTreeData = [];
		
		// 选中的元数据模版modelId
		var selectPageConfigModelId = '';
		
		jQuery(document).ready(function(){
	        comtop.UI.scan();
	    });
		
		// 获取元数据模版分类数据集
		function getMetadataTmpType(){
			var metadataTmpTypeList = {};
			dwr.TOPEngine.setAsync(false);
			MetadataTmpTypeFacade.getCustomMetaTmpType(function(data) {
				metadataTmpTypeList = data;
			})
			dwr.TOPEngine.setAsync(true);
			return metadataTmpTypeList;
		}
		
		//初始化数据 
		function initTreeData(obj) {
			dwr.TOPEngine.setAsync(false);
			MetadataTmpTypeFacade.queryMetadataTmpTypeView(function(data) {
				metadataTmpTreeData = data;
			})
			dwr.TOPEngine.setAsync(true);
			obj.setDatasource(metadataTmpTreeData);
		}
		
		//键盘回车键快速查询 
		function keyDownQuery() {
			if (event.keyCode ==13) {
				fastQuery();
			}
		}
		
		//快速查询
		function fastQuery(){
			var keyword = cui('#keyword').getValue();
			if(keyword == ''){
				$('#fastQueryList').hide();
				$('#metadataTmpTreeData').show();
				cui("#metadataTmpTreeData").setDatasource(metadataTmpTreeData);
			}else{
				$('#fastQueryList').show();
				$('#metadataTmpTreeData').hide();
				listBoxData(cui('#fastQueryList'));
			}
			cui("#ensure").disable(true);
		}
		
		//快速查询列表数据源
		function listBoxData(obj){
			var keyword = cui("#keyword").getValue();
			var listData = filterData(keyword, metadataTmpTreeData);
			cui("#fastQueryList").setDatasource(listData);
		}
		
		/**
		 * 
		 * @param keyword 查询关键词
		 * @param treeData 元数据模版分类数据集
		 */
		function filterData(keyword, treeData){
			var listData = [];
			for(var i=0, len=treeData.length; i<len; i++){
				if(treeData[i].title.indexOf(keyword) != -1){
					if(treeData[i].folder){
						//获取目录下的所有模版
					} else {// 叶节点
						listData.push({href:"#", name:treeData[i].title, onclick:"selectMetadataTmp4MultiNav('"+treeData[i].metadataPageConfigModelId+"')"});
					}
				}
				if(treeData[i].children != null && treeData[i].children.length > 0){
					var subListData = filterData(keyword, treeData[i].children);
					listData = _.union(listData, subListData);
				}
			}
			return listData;
		}
		
		function selectMetadataTmp4MultiNav(selectPageConfigModelId){
			selectPageConfigModelId = selectPageConfigModelId;
           	cui("#ensure").disable(selectPageConfigModelId != 'null' ? false : true);
		}
		
		/**
		 * 设置生产元数据列表数据源
		 * @param typeCode 分类编码
		 * @param metadataTmpTypeList 元数据模版分类数据集
		 */
		function getTypeName(typeCode, metadataTmpTypeList){
			var retValue = '';
			if(typeCode === metadataTmpTypeList.typeCode){
				retValue = metadataTmpTypeList.typeName
			} else {
				for(var i in metadataTmpTypeList.metadataTmpTypeVOList){
					retValue = getTypeName(typeCode, metadataTmpTypeList.metadataTmpTypeVOList[i]);
					if(retValue != ''){
						break;
					}
				}
			}
			return retValue;
		}
	
		//选择元数据模版
	    function selectMetadataTmp(node, event){
           	selectPageConfigModelId = node.getData("metadataPageConfigModelId");
           	cui("#ensure").disable(selectPageConfigModelId != null ? false : true);
        }
		
		// 确定
		function ensure(){
			if(selectPageConfigModelId != null){
				var param = "?packageId="+packageId+"&metadataPageConfigModelId="+selectPageConfigModelId+"&operationType=insert&openType="+openType;
				var url = "${pageScope.cuiWebRoot}/cap/bm/dev/page/template/MetadataGenerateEdit.jsp"+param;
				if(openType=="listToMain"){
					window.opener.parent.location = url;
					window.close();
				}else{
					window.open(url, "_blank");
					if(window.parent&&window.parent.selectTemplateDialog){
						window.parent.selectTemplateDialog.hide();
					}
				}
			} 
	    }
	</script>
</body>
</html>