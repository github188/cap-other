<%
    /**********************************************************************
	 * 工作台流程配置列表
	 * 2016-08-12 马瑞  新建
	 **********************************************************************/
%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
    String version = formatter.format(new Date());
%>
<%//360浏览器指定webkit内核打开%>
<meta name="renderer" content="webkit">
<%//关闭ie兼容模式,使用最高版本文档模式渲染页面%>
<meta http-equiv="x-ua-compatible" content="IE=edge" >
<html> 
<head>
<title>流程配置管理</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/base/css/base.css?v=<%=version%>"/>
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/ProcessConfigAction.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js?v=<%=version%>"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/base/js/base.js?v=<%=version%>"></script>
</head>

<body>
	<div id="centerMain">
		<div class="list_header_wrap"  style="margin: 0 12px">
			<div class="top_float_left" >
		 		 <span uiType="ClickInput" id="myClickInput" name="clickInput" enterable="true" emptytext="请输入流程编号，流程名称，URL查询" editable="true" width="300" 
		 			        		icon="search" iconwidth="18px" on_keydown="keyDownQuery" on_iconclick="keyWordQuery"></span> 
		 	</div>
			<div  Id="top_float_right" class="top_float_right">
				<span uitype="button" label="新增" icon="upload" id="button_add"  on_click="addBtn"></span>
				<span uitype="button"  label="删除" icon="trash-o" id="button_del"  on_click="deleteBtn"></span>
			</div>
		</div>
		<div id="grid_warp" style="margin: 0 12px">
			<table id="grid" uitype="grid" pagesize_list="[10,20,30]" datasource="initData" primarykey="processId" 
		       colrender="columnRenderer" resizewidth="resizeWidth"  resizeheight="resizeHeight">
		    	<tr>
					<th style="width:5%"><input type="checkbox" /></th>
					<th bindName="processName" renderStyle="text-align: left"  style="width:15%">流程名称</th>
					<th bindName="processId" renderStyle="text-align: left"  style="width:15%">流程编号</th>
					<th bindName="isWorkflow" renderStyle="text-align: center"  style="width:7%">是否工作流</th>
					<th bindName="appId"  renderStyle="text-align: center"  style="width:15%">应用编号</th>
					<th bindName="unworkflowClass" renderStyle="text-align: left"style="width:13%">实现类</th>
					<th bindName="todoUrl" renderStyle="text-align: left"  style="width:15%">待办列表URL</th>
					<th bindName="doneUrl" renderStyle="text-align: left"  style="width:15%">已办详情URL</th>
				</tr>
		   	</table>
		</div>
	</div>
	
	<script type="text/javascript">
		var iProcessId = null;
		
		var dialog;
		window.onload=function(){
			//扫描CUI
			comtop.UI.scan();	
		}
		
		//grid宽度
		function resizeWidth(){
			return (document.documentElement.clientWidth || document.body.clientWidth) - 24;
		} 
		
		//grid高度
		function resizeHeight(){
			return (document.documentElement.clientHeight || document.body.clientHeight) - 45;
		}
		
		//列表数据初始化
		function initData(grid,query){
			var sortFieldName = query.sortName[0];
		    var sortType = query.sortType[0];
		    var fastQueryValue = cui("#myClickInput").getValue().replace(new RegExp("%", "gm"), "/%");
			fastQueryValue = fastQueryValue.replace(new RegExp("_", "gm"), "/_");
			fastQueryValue = fastQueryValue.replace(new RegExp("'","gm"), "''");
			fastQueryValue = fastQueryValue.replace(new RegExp("/","gm"), "//");
		    var queryCondition = {pageNo:query.pageNo,pageSize:query.pageSize,
					sortFieldName:sortFieldName,
					sortType:sortType};
		    queryCondition.fastQueryValue = fastQueryValue;
		    queryCondition.processId = iProcessId;
		    dwr.TOPEngine.setAsync(false);
		    ProcessConfigAction.queryProcessConfigList(queryCondition,function(data){
		    	var dataCount = data.count;
				var dataList = data.list;
				grid.setDatasource(dataList,dataCount);
		    });
		    dwr.TOPEngine.setAsync(true);
		    iProcessId = null;
		}
		
		//渲染列表数据
		function columnRenderer(data,field){
			if(field === 'processName'){
				return "<a class='a_link' href='javascript:edit(\""+data["processId"]+"\");'>"+data["processName"]+"</a>";
			}
			if(field === 'isWorkflow'){
				var isWorkflow = data["isWorkflow"];
				if (isWorkflow == 'Y' || isWorkflow == 'y'){
					return '是';
				}
				else if (isWorkflow == 'N' || isWorkflow== 'n')
					return '否';
				else 
					return null;
			}
		}
		
		//删除
		function deleteBtn(){
			var selectData =cui("#grid").getSelectedPrimaryKey();
			if (selectData.length == 0) {
			    cui.alert("请选择要删除的配置");
			} else {
			    var msg = "确定要删除选中的配置吗？";
			    cui.confirm(msg, {
			        onYes: function () {
	                    ProcessConfigAction.deleteProcessConfig(selectData, function(data){     	
		                    var cuiTable = cui("#grid");
		                    cuiTable.removeData(cuiTable.getSelectedIndex());
		                    cui.message("删除配置成功", "success");
		                    cui('#grid').loadData();
	                    });
			        }
			    });
			}
		}
		
		//点击查询按钮
		function keyWordQuery(){
			var tableObj = cui('#grid');
			tableObj.setQuery({pageNo:1});
			tableObj.loadData();
		}
		
		//键盘回车键快速查询 
		function keyDownQuery() {
			if ( event.keyCode ==13) {
				keyWordQuery();
			}
		}
		
		//新增
		function addBtn(){
			var url = '${pageScope.cuiWebRoot}/top/sys/tools/processconfig/ProcessConfigEdit.jsp';
			var title = "新增流程配置";
			var height = 350; //300
			var width = 700; // 560;
		//	var height = (document.documentElement.clientHeight || document.body.clientHeight)-300; //300
			//var width = (document.documentElement.clientWidth || document.body.clientWidth)-350; // 560;
			if(!dialog)
			dialog = cui.dialog({
				src:url,
				width:width,
				height:height
			});
			dialog.show(url); 
		}
		
		//编辑
		function edit(processId){
			var url = '${pageScope.cuiWebRoot}/top/sys/tools/processconfig/ProcessConfigEdit.jsp?processId='+processId;
			var title = "编辑流程配置";
			var height = 350; //300
			var width = 700; // 560;
		//	var height = (document.documentElement.clientHeight || document.body.clientHeight)-300; //300
			//var width = (document.documentElement.clientWidth || document.body.clientWidth)-350; // 560;
			if(!dialog)
			dialog = cui.dialog({
				src:url,
				width:width,
				height:height
			});
			dialog.show(url); 
		}
		
		/**
		**回调函数
		**/
		function addCallBack(saveType,selectedKey){
			var tableObj = cui('#grid');
			iProcessId = selectedKey;
			tableObj.setQuery({pageNo:1,sortType:[],sortName:[]});
			tableObj.loadData();
			cui("#grid").selectRowsByPK(selectedKey);
		}
		
	</script>
</body>
</html>
