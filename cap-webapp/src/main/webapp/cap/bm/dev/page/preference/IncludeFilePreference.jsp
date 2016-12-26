<%
/**********************************************************************
* 引入文件首选项页面
* 2015-5-28 诸焕辉
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app='includeFilePreference'>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>引入文件首选项</title>
    <top:link href="/cap/bm/common/top/css/top_base.css"></top:link>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
    <top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
	<top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src="/cap/dwr/interface/IncludeFilePreferenceFacade.js"></top:script>
	<style type="text/css">
		.header, .main {
			margin: 2px;
		}
	</style>
</head>
<body class="body_layout" ng-controller="includeFilePreferenceCtrl" data-ng-init="ready()">
	<div class="header">
		<span uitype="PullDown" mode="Single" id="fileType" empty_text="请选择文件类型" datasource="pullDatasource" value_field="id" label_field="text" width="120" on_change="filterFileTypeChangeEvent"></span>
		<span uiType="ClickInput" id="quickSearch" name="clickInput" enterable="true" emptytext="请输入文件名称或路径进行过滤" editable="true" width="240" on_iconclick="keyWordQuery" on_keydown="keyDownQuery" icon="search" iconwidth="18px"></span> 
		<div class="thw_operate">
			<span uitype="button" label="确定" id="saveBtn" on_click="saveIncludeFile" ></span>
		</div>
	</div>
	<div class="main">
		<table id="grid">
			<thead>
				<tr>
					<th width="5%" bindName="fileName"><input type="checkbox" ng-if="selectrows == 'multi'"></th>
					<th renderStyle="text-align:center;" bindName="fileType" width="25%">文件类型</th>
					<th renderStyle="text-align:left;" bindName="filePath" width="70%">文件路径</th>
				</tr>
			</thead>
		</table>
	</div>
	<script type="text/javascript">
		//选中的primaryKey
		var selectedPrimaryKey = [];
		//后台获取的所有引用文件集合
		var gridDatasource = [];
		//选中的文件类型
		var fileType = "";
		//搜索框图片点击事件
	    var keyWord = ""; 
		//all：所有引用文件、required：必须引用文件、optional：可选引用文件       默认：optional
		var flag = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("flag"))%>;
		flag = flag != null && flag != "" ? flag : 'optional';
		//选择模式
		var selectrows = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("selectrows"))%>;
		selectrows = selectrows != null && selectrows != '' ?  selectrows : 'multi'
		var scope=null;
		angular.module('includeFilePreference', [ "cui"]).controller('includeFilePreferenceCtrl', function ($scope) {
			//控件依赖文件变更配置
			$scope.componentDependFilesConfigVO = {};
			$scope.selectrows = selectrows;
			//是否是编辑状态
			$scope.hasEditState = false;
			$scope.ready=function(){
		    	comtop.UI.scan();
		    	scope=$scope;
		    }
			
	    	$scope.init=function(){
	    		
	    	}
			
	    });
		
		cui("#grid").grid({
	        datasource : initData,
	        primarykey: "filePath",
	        selectrows : selectrows,
	        ellipsis : false,
	        pagination : false,
	        sortstyle : 1,
	        resizewidth : resizeWidth,
	        resizeheight : resizeHeight,
	        rowclick_callback : rowclickcallback,
	        selectall_callback : selectallcallback
	    });
		
	   /**
		* Grid组件点击行时的回调函数
		*
		* @param rowData 当前行数据
		* @param isChecked 是否是全选
		* @param index 当前被点击行的索引号
		*/
		function rowclickcallback(rowData, isChecked, index){
			var filePath = rowData.filePath;
			if(isChecked){
				var indexNo = $.inArray(filePath, selectedPrimaryKey); 
				if(indexNo < 0){
					selectedPrimaryKey.push(filePath);
				}
			} else{
				var indexNo = $.inArray(filePath, selectedPrimaryKey); 
				if(indexNo >= 0){
					selectedPrimaryKey.splice(indexNo, 1);
				}
			}
		}
		
	   /**
		* Grid组件点击全选checkbox时的回调函数
		*
		* @param data 全选的数据
		* @param isChecked 是否是全选
		*/
		function selectallcallback(data, isChecked){
			if(isChecked){
				for(var i in data){
					var filePath = data[i].filePath;
					var indexNo = $.inArray(filePath, selectedPrimaryKey); 
					if(indexNo < 0){
						selectedPrimaryKey.push(filePath);
					}
				}
			} else{
				for(var i in data){
					var filePath = data[i].filePath;
					var indexNo = $.inArray(filePath, selectedPrimaryKey); 
					if(indexNo >= 0){
						selectedPrimaryKey.splice(indexNo, 1);
					}
				}
			}
		}
		
		//下拉框数据源
		var pullDatasource = [
			{id:'', text:'all'},
            {id:'jsp', text:'jsp'},
            {id:'js', text:'js'},
            {id:'css', text:'css'}
  	    ];

	   /**
		* 设置grid数据源
		*
		* @param grid 表格组件对象
		* @param query Json对象：包含分页信息和题头排序信息
		*/
		function initData(grid, query) {
			dwr.TOPEngine.setAsync(false);
			IncludeFilePreferenceFacade.queryAllIncludeFile(function(data) {
				if(flag == 'all'){
					gridDatasource = data;
				} else if(flag == 'required'){
					gridDatasource = _.filter(data, {defaultReference: true});
				} else{
					gridDatasource = _.filter(data, {defaultReference: false});
				}
				grid.setDatasource(gridDatasource, gridDatasource.length);
			});
			dwr.TOPEngine.setAsync(true);
		}
		
	   /**
		* 过滤文件类型
		*
		* @param data 当前选中对象
		* @param oldData 上一次选中对象
		*/
		function filterFileTypeChangeEvent(data, oldData){
			fileType = data.id;
			keyWord = cui('#quickSearch').getValue(); 
			query();
		}
		
		//快速查询
		function keyWordQuery(){
			keyWord = cui('#quickSearch').getValue(); 
			query();
		}
		
		//通过sql过滤查询
		function query(){
			var obj = new cap.CollectionUtil(gridDatasource);
			var datasource = gridDatasource;
			if(fileType != '' && keyWord != ''){
				datasource = obj.query("this.fileType == '" + fileType + "' && (this.fileName.indexOf('"+ keyWord +"') != -1 || this.filePath.indexOf('"+ keyWord +"') != -1)");
			} else if(fileType != '' && keyWord == ''){
				datasource = obj.query("this.fileType == '" + fileType + "'");
			} else if(fileType == '' && keyWord != ''){
				datasource = obj.query("this.fileName.indexOf('"+ keyWord +"') != -1 || this.filePath.indexOf('"+ keyWord +"') != -1");
			} 
			cui('#grid').setDatasource(datasource, datasource.length);
			initSelectedStatus();
		}
		
		function initSelectedStatus(){
			cui('#grid').selectRowsByPK(selectedPrimaryKey, true);
		}
		
		//键盘回车键快速查询 
		function keyDownQuery() {
			if ( event.keyCode ==13) {
				keyWordQuery();
			}
		} 
		
		//选择引用文件
		function saveIncludeFile(){
			if (selectedPrimaryKey == null || selectedPrimaryKey.length == 0) {
				cui.alert("请选择要引用的文件。");
			} else {
				var obj = new cap.CollectionUtil(gridDatasource);
				var sql = '';
				for(var i=0, len=selectedPrimaryKey.length; i<len; i++){
					sql += "this.filePath == '"+ selectedPrimaryKey[i] + "'";
					if(i < len -1){
						sql += " || ";
					} 
				}
				var selectedFiles = obj.query(sql);
				window.opener.refreshFiles(selectedFiles);
				window.close();
			}
		}
		
		function resizeWidth() {
			return (document.documentElement.clientWidth || document.body.clientWidth) - 4;
		}
	
		function resizeHeight() {
			return (document.documentElement.clientHeight || document.body.clientHeight) - 40;
		}
		
	</script>
</body>
</html>