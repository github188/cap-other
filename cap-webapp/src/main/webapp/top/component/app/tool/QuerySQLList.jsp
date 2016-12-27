<%
/**********************************************************************
* select语句-列表
* 2014-12-18 zhangzunzhi  新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
    <title>人员扩展属性定义</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/SQLQueryAction.js"></script>
	<style type="text/css">
		th{
		    font-weight: bold;
		    font-size:14px;
		}
	</style>
</head>
<body class="body_layout">
	<div class="list_header_wrap">
		<div class="top_float_right" style="padding:15px">
			<span uitype="button" id="add" label="确定" on_click="checkQuerySQL" ></span>
			&nbsp;<span uitype="button" label="新增" id="sqlInsert" on_click="sqlInsert" ></span>
			&nbsp;<span uitype="button" id="delete" label="删除" on_click="deleteExpand"></span>
			&nbsp;<span uitype="button" id="cancel" label="取消" on_click="cancel"></span>
		</div>
	</div>
	<div id="userGridWrap" style="padding:0 15px 0 15px">
	<table uitype="grid" id="grid" primarykey="queryId"  selectrows="single"  datasource="initData" pagination="false"  adaptive="true" resizewidth="resizeWidth" sortstyle="3" resizeheight="resizeHeight" colrender="columnRenderer">
		<tr>
	        <th style="width:5%"></th>
	        <th renderStyle="width:20%;text-align:left;" bindName="description">描述</th>
	        <th renderStyle="width:80%;text-align:left;" bindName="querySQL">SELECT语句</th>
		</tr>
	</table>
	</div>
   <script language="javascript">
   	   // 选中行id
	   var selectedRowId="<c:out value='${param.selectedRowId}'/>";//查询sql ID
	   window.onload=function(){
			comtop.UI.scan();
	   }  
	   
	    //渲染列表数据
		function initData(grid,query){
			//获取排序字段信息
		    var sortFieldName = query.sortName[0];
		    var sortType = query.sortType[0];
		    var queryObj = {pageNo:query.pageNo,pageSize:query.pageSize,sortFieldName:sortFieldName,sortType:sortType};
				dwr.TOPEngine.setAsync(false);
				SQLQueryAction.queryQuerySQLList(queryObj,function(data){
			    	var totalSize = data.count;
					var dataList = data.list;
					grid.setDatasource(dataList);
					if(selectedRowId){
						grid.selectRowsByPK(selectedRowId);
					}
				});
				dwr.TOPEngine.setAsync(true);
			
	  	}
	    //Grid组件自适应宽度回调函数，返回高度计算结果即可
		function resizeWidth(){
			return (document.documentElement.clientWidth || document.body.clientWidth)-30;
		}

		//Grid组件自适应高度回调函数，返回宽度计算结果即可
		function resizeHeight(){
			return (document.documentElement.clientHeight || document.body.clientHeight) - 65;
		}

		/**
		 * 删除扩展属性
		 */
		function deleteExpand(){
			var selectRow= cui("#grid").getSelectedRowData();
			if(selectRow.length==0){
				cui.alert("没有选中记录。");
				return;
			}
			if(selectRow !=null && selectRow.length>0){
						dwr.TOPEngine.setAsync(false);
						SQLQueryAction.deleteQuerySQL(selectRow,function(){
							selectedRowId="";
							cui("#grid").loadData();
							cui.message("SQL删除成功。","success");
				        });
						dwr.TOPEngine.setAsync(true);
			}
		}

		 //编辑
		//var dialog;
		function editExpandDefine(queryId){
			var title="";//"人员扩展属性编辑";
			var height = 600; //600
			var width =  800; // 680;
			var url='${pageScope.cuiWebRoot}/top/component/app/tool/SQLQueryEdit.jsp';
			if(typeof(queryId)=='string'){
				url += '?queryId='+queryId;
			}
			if(!window.parent.dialog){
				dialog = cui.dialog({
					title : title,
					src : url,
					width : width,
					height : height
				})
			}
			window.parent.dialog.show(url);
		}
		
		//新增sql
		function sqlInsert(){
		  var url = '${pageScope.cuiWebRoot}/top/component/app/tool/SQLQueryEdit.jsp';
		  var title = "";
		  var height = 600;
		  var width = 800;
		  if(!window.parent.dialog){
			    dialog = cui.dialog({
				    title : title,
				    src : url,
				    width : width,
				    height : height
			    })
		    }
		    window.parent.dialog.show(url);
		}

		//列渲染
		function columnRenderer(data,field) {
			if(field == 'querySQL'){
				var attriName = data["querySQL"];
				return "<a class='a_link' onclick='javascript:editExpandDefine(\""+data["queryId"]+ "\");'>"+attriName+"</a>";
		      }
	    }
		
		//确定选择查询语句
		function checkQuerySQL(){
			var selectRow= cui("#grid").getSelectedRowData();
			if(selectRow.length==0){
				cui.alert("没有选中记录。");
				return;
			}
			if(selectRow !=null && selectRow.length>0){
						dwr.TOPEngine.setAsync(false);
						SQLQueryAction.readQuerySQL(selectRow[0].queryId,function(data){
							window.parent.cui("#querySQL").setValue(data.querySQL);
							window.parent.dialog.hide();
				        });
						dwr.TOPEngine.setAsync(true);
			}
		}
		
		//取消，关闭窗口
		function cancel(){
			window.parent.dialog.hide();
		}
		
   </script>
</body>
</html>
