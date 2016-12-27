
<%
	/**********************************************************************
	 * SQL查询页面
	 * 2014-12-17  zhangzunzhi  新建
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<title>SQL查询</title>

<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css"
	type="text/css">
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/util.js"></script>
<script type="text/javascript" 
    src='${pageScope.cuiWebRoot}/top/sys/dwr/interface/SQLQueryAction.js'></script>
<style type="text/css">
.imgMiddle {
	line-height: 350px;
	text-align: center;
}

.top_header_wrap {
	padding-right: 5px;
}
</style>
</head>
<body onload="window.status='Finished';">
	<div uitype="Borderlayout" id="body" is_root="true">
		<div class="top_header_wrap" >
			<div class="thw_title" style="padding-top: 3px;margin-top:0px;">
				<span><font id="pageTittle" class="fontTitle">数据列表</font></span>
			</div>

			<div class="thw_operate" style="padding-right:47px">
				<span uitype="button" label="导出" id="export" on_click="exportData" ></span>
			</div>
		</div>
		<div id="SQLQueryDataWrap"  class="cui_ext_textmode" style="margin-top:5px;padding-left:15px;padding-right:40px"/>
	</div>

	<script language="javascript">
	var totalSize ;
	var totalList ;
	window.onload = function() {
		var objSQLQueryDTO = {querySQL:window.parent.cui("#querySQL").getValue(),pageNo:1,pageSize:18};
		dwr.TOPEngine.setAsync(false);
		SQLQueryAction.executeQuerySQL(objSQLQueryDTO,function(data){
			 totalSize = data.count;
			 totalList = data.list;
		});
		dwr.TOPEngine.setAsync(true);
		var dataHtml ;
		dataHtml = '<table uitype="Grid" id="executeQuerySQL" gridwidth="1225" colmaxheight="400" adaptive="false" primarykey="executeQuerySQL" selectrows="no"  sorttype="1" datasource="initData" pageno="1" pagesize="18" pagesize_list="[18,50,100]"  resizewidth="resizeWidth" resizeheight="resizeHeight"  colrender="columnRenderer"';
		if(totalSize>0){
			var thMap = totalList[0];
			var ilength = 1 ;
			for(var key in thMap){
				ilength = ilength+1
			}
			var tablewidth = 1200;
			if(ilength*90>1200){
				tablewidth = ilength*90;
			}
			dataHtml = dataHtml +'tablewidth=' + tablewidth +'>';
			dataHtml = dataHtml + '<thead><tr>';
			for(var key in thMap){
				if(key != "OUTER_TABLE_ROWNUM"){
				 dataHtml = dataHtml + '<th renderStyle="text-align: center" bindName="';
				 dataHtml = dataHtml + key +'">'
				 dataHtml = dataHtml + key;	
				 dataHtml = dataHtml + '</th>';	
				}
			}
		}
		dataHtml = dataHtml + '</tr></thead></table>';
		document.getElementById('SQLQueryDataWrap').innerHTML =dataHtml;
		comtop.UI.scan();
	}

	//渲染列表数据
	function initData(grid,query){
	if(totalSize > 0){
		 grid.setDatasource(totalList,totalSize);
		 totalSize = 0;
		}else{
			var objSQLQueryDTO = {querySQL:window.parent.cui("#querySQL").getValue(),pageNo:query.pageNo,pageSize:query.pageSize};
			dwr.TOPEngine.setAsync(false);
			SQLQueryAction.executeQuerySQL(objSQLQueryDTO,function(data){
				var executeTotalSize = data.count;
				var executeDataList = data.list;
				 grid.setDatasource(executeDataList,executeTotalSize);
			});
			dwr.TOPEngine.setAsync(true);
			
		}
	}
	// 导出数据
	function exportData(){
		var exportResult = "";
		var selectSQL = window.parent.cui("#querySQL").getValue();
		selectSQL = trimStr(selectSQL);
		if((selectSQL.charAt(selectSQL.length-1)==";")==true){   
			selectSQL = selectSQL.substr(0, selectSQL.length - 1);
		}
 		if(checkSQL(selectSQL)){
 			window.parent.cui.handleMask.show();
			//dwr.TOPEngine.setAsync(false);
			SQLQueryAction.exportUserReportData(selectSQL,function(data){
				window.parent.cui.handleMask.hide();
				exportResult = data;
				if(exportResult=="ok"){
				var url = "${pageScope.cuiWebRoot}/downloadUserReportData.ac";
				    window.open(url,'_self');
				}else{
					alert("导出出现异常，请检查SQL语句。");
				} 
			});
		} 
	}
	
	function trimStr(str){
		return str.replace(/(^\s*)|(\s*$)/g,"");
	}
	/*
	String.prototype.endWith=function(endStr){   
		var d=this.length-endStr.length;   
		return (d>=0&&this.lastIndexOf(endStr)==d) 
	} 
	var str="I love antzone"; 
	console.log(str.endWith("ne"))
	*/
/* 	String.prototype.trim = function() {  
	    return (this.replace(/^\s+|\s+$/g,""));  
	}   */

	//SQL检查
	function checkSQL(selectSQL){
		if (selectSQL == null) {
            return false;
        }
		if(selectSQL.length == 0){
			return false;
		}
        var selectLowerSQL = selectSQL.toLowerCase();
        if(selectLowerSQL.indexOf(" into ")>-1||selectLowerSQL.indexOf(" set ")>-1||selectLowerSQL.indexOf(" set")>-1||selectLowerSQL.indexOf(" into")>-1){
        	 cui.alert("不能有新增和修改语句！");
        	 return false;
        }
        return true;
	}

	//SQL检查
	function checkSQL(selectSQL){
		if (selectSQL == null) {
            return false;
        }
		if(selectSQL.length == 0){
			return false;
		}
        var selectLowerSQL = selectSQL.toLowerCase();
        if(selectLowerSQL.indexOf(" into ")>-1||selectLowerSQL.indexOf(" set ")>-1||selectLowerSQL.indexOf(" set")>-1||selectLowerSQL.indexOf(" into")>-1){
        	 cui.alert("不能有新增和修改语句！");
        	 return false;
        }
        return true;
	}
	 	
	    //Grid组件自适应宽度回调函数，返回高度计算结果即可
		function resizeWidth(){
			return (document.documentElement.clientWidth || document.body.clientWidth)-55;
		}

		//Grid组件自适应高度回调函数，返回宽度计算结果即可
		function resizeHeight(){
			return (document.documentElement.clientHeight || document.body.clientHeight) - 300;
		}
	</script>
</body>
</html>