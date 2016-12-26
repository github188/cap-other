<%
/**********************************************************************
* 动态步骤-自动录入字段-选择页面
* 2016-7-8 李小芬  新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <title>选择编辑页面</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src='/cap/dwr/engine.js'></top:script>
    <top:script src='/cap/dwr/util.js'></top:script>
    <top:script src='/cap/dwr/interface/PageFacade.js'></top:script>
	<style type="text/css">
		img{
		  margin-left:5px;
		}
	</style>
</head>
<body>
<div uitype="Borderlayout"  id="body"  is_root="true"> 
		<div id="centerMain" position ="center">
		<table class="cap-table-fullWidth" width="100%">
		    <tr>
		        <td class="cap-td" style="text-align: left;padding:5px">
		        	<span id="formTitle" uitype="Label" value="界面列表" class="cap-label-title" size="12pt"></span>
		        </td>
		        <td class="cap-td" style="text-align: right;padding:5px">
		        	 <span id="selectPage" uitype="Button" onclick="selectPage()" label="确定"></span> 
		        	 <span uitype="button" label="关闭" on_click="closeSelf"></span>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td">
		        	<table uitype="Grid" id="pageGrid" primarykey="modelId" selectrows="single" colhidden="false" datasource="initPageData" pagination="false"
					 	resizewidth="getBodyWidth" resizeheight="getBodyHeight"  colrender="columnRenderer">
						<thead>
							<tr>
							    <th style="width:25px"></th>
								<th  style="width:35px" renderStyle="text-align: center;" bindName="1">序号</th>
								<th  style="width:20%" renderStyle="text-align: left" render="editPage" bindName="cname">页面标题</th>
								<th  style="width:25%" renderStyle="text-align: left" bindName="modelName">页面英文名</th>
								<th  style="width:30%" renderStyle="text-align: left" bindName="modelPackage">页面包路径</th>			 
							</tr>
						</thead>
					</table>
		        </td>
		    </tr>
		</table>
	</div>
</div>
	<script type="text/javascript">
	var appId = "0168DB7562CE4FB09C85D3D569237B78"; 
	var modelId = ""; 
	
	$(document).ready(function(){
		comtop.UI.scan();   //扫描
	});
	
	//选择页面
	function selectPage() {
		var selectData = cui("#pageGrid").getSelectedRowData();
		if (selectData == null || selectData.length == 0) {
			cui.alert("请选择界面。");
			return;
		} else {
			
		}
	}
	
    //页面关闭
	function closeSelf(){
		window.parent.dialog.hide(); 
	}
	
	//初始化列表
	function initPageData(gridObj, query) {
		PageFacade.queryPageList(appId,function(data) {
			//if(selectType=="jsp"){
			//	var jspData = getJspData(data);
			 // gridObj.setDatasource(jspData, jspData.length);
			//}else{
			  gridObj.setDatasource(data, data.length);
			//}
		})
	}
	
	//过滤自定义的jsp页面
	function getJspData(pageData){
		var retData = [];
		for(var i =0;i<pageData.length;i++){
			if(pageData[i].pageType==2){
				retData.push(pageData[i]);
			}
		}
		return retData;
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