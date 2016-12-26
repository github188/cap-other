<%
/**********************************************************************
* 复制用例界面--编辑用例中英文名称、name/modelName
* 2016-8-4 李小芬  新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <title>用例名称编辑</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src='/cap/dwr/engine.js'></top:script>
    <top:script src='/cap/dwr/util.js'></top:script>
	<top:script src="/cap/dwr/interface/TestCaseFacade.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<style type="text/css">
		img{
		  margin-left:5px;
		}
	</style>
</head>
<body>
		<table class="cap-table-fullWidth" width="100%">
		    <tr>
		        <td class="cap-td" style="text-align: left;padding:5px">
		        	<span id="formTitle" uitype="Label" value="用例列表" class="cap-label-title" size="12pt"></span>
		        </td>
		        <td class="cap-td" style="text-align: right;padding:5px">
		        	 <span id="saveData" uitype="Button" onclick="saveData()" label="保存"></span> 
			         <span id="close" uitype="Button" onclick="testCaseClose()" label="关闭"></span> 
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth" width="100%">
		    <tr>
		        <td class="cap-td" width="100%">
		        	<table uitype="EditableGrid" id="testCaseGrid" primarykey="modelId" edittype="testCaseNameEdit" colhidden="false" datasource="initCopyTestCaseData"
		        		 pagination="false" resizewidth="getBodyWidth" selectrows="no" resizeheight="getBodyHeight" submitdata="savePageInfo"> 
						<thead>
							<tr>
							  <!--  <th style="width:5%"></th>  --> 
								<th  style="width:5%" renderStyle="text-align: center;" bindName="1">序号</th>
								<th  style="width:20%" renderStyle="text-align: left;" bindName="name">用例中文名</th>
								<th  style="width:20%" renderStyle="text-align: left" bindName="modelName">用例英文名</th>
								<th  style="width:25%" renderStyle="text-align: left" bindName="newName">新用例中文名</th>
								<th  style="width:25%" renderStyle="text-align: left" bindName="newModelName">新用例英文名</th>
							</tr>
						</thead>
					</table>
		        </td>
		    </tr>
		</table>
	<script type="text/javascript">
	var packageId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
	var moduleCode = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("moduleCode"))%>;
	var updatePage =[];
	
	$(document).ready(function(){
		comtop.UI.scan();   //扫描
	});
	
	//初始化数据 
	function initCopyTestCaseData(obj) {
		var testCasesInfo = window.opener.returnSelectTestCase();
		if(testCasesInfo == null || testCasesInfo == undefined || testCasesInfo.length == 0){
			obj.setDatasource([],0);
		}else{
			for(var i=0; i<testCasesInfo.length; i++){
				testCasesInfo[i].newModelName="";
				testCasesInfo[i].newName="";
			}
			obj.setDatasource(testCasesInfo,testCasesInfo.length);
			for(var i=0; i<testCasesInfo.length; i++){
				testCasesInfo[i].newModelName="Copyof"+testCasesInfo[i].modelName;
				testCasesInfo[i].newName="复制"+testCasesInfo[i].name;
				obj.changeData(testCasesInfo[i] ,i);
			}
		}
	}
	
	var testCaseNameEdit = {
		    "newModelName" : {
		        uitype: "Input",
		        validate:[{type:'required',rule:{m:'用例英文名不能为空。'}},{type:'format', rule:{pattern:'^[a-zA-Z0-9_]*$', m:'用例英文名必须为英文字符、数字或者下划线。'}}
		        			,{type:'custom',rule:{against:'checkEngNameIsExist', m:'用例英文名已经存在。'}},{type:'custom',rule:{against:'checkCopyEngNameIsExist', m:'用例中文名已经存在。'}}]
		    },
		    "newName" : {
		        uitype: "Input",
		        validate:[{type:'required',rule:{m:'用例中文名不能为空。'}},{type:'custom',rule:{against:'checkNameIsExist', m:'用例中文名已经存在。'}},{type:'custom',rule:{against:'checkCopyNameIsExist', m:'用例中文名已经存在。'}}],
			    maxlength: 100
		    },
	};
	
	//检验实体名称是否存在
	function checkCopyEngNameIsExist(name) {
			var validateData = cui("#testCaseGrid").getChangeData().updateData;
			var uExistNum = 0;
			for(var i = 0; i<validateData.length; i++){
				var oName = validateData[i].modelName;
				var newName = validateData[i].newModelName;
				if(name == oName || name == newName){
					uExistNum++;
				}
			}
			if(uExistNum>1){
				return false;
			}
			return true;
	}
	
	
	//检验实体名称是否存在
	function checkCopyNameIsExist(name) {
			var validateData = cui("#testCaseGrid").getChangeData().updateData;
			var uExistNum = 0;
			for(var i = 0; i<validateData.length; i++){
				var oName = validateData[i].name;
				var newName = validateData[i].newName;
				if(name == oName || name == newName){
					uExistNum++;
				}
			}
			if(uExistNum>1){
				return false;
			}
			return true;
	}
		
	//检验实体名称是否存在
	function checkNameIsExist(name) {
	  		var flag = true;
	  		dwr.TOPEngine.setAsync(false);
	  		TestCaseFacade.isExistSameNameTestCase(moduleCode,name,null,function(bResult){
				flag = !bResult;
			});
			dwr.TOPEngine.setAsync(true);
			return flag;
	}
	
	//检验实体名称是否存在
	function checkEngNameIsExist(engName) {
	  		var flag = true;
	  		dwr.TOPEngine.setAsync(false);
	  		TestCaseFacade.isExistSameEngNameTestCase(moduleCode,engName,null,function(bResult){
				flag = !bResult;
			});
			dwr.TOPEngine.setAsync(true);
			return flag;
	}
    
    function saveData(){
    	cui("#testCaseGrid").submit();
    }

	//确认复制页面信息
	function savePageInfo(){
		//已经填写后的页面信息集合
		updatePage = cui("#testCaseGrid").getChangeData().updateData;
		var iDataSize = cui("#testCaseGrid").getData().length;
		for(var i=0; i<iDataSize; i++){
			updatePage[i].modelName = updatePage[i].newModelName;
			updatePage[i].name = updatePage[i].newName;
		}
		//后台保存		
		var rsNum = 0;
		dwr.TOPEngine.setAsync(false);
		TestCaseFacade.copyTestCaseList(updatePage, function(result) {
			rsNum = result;
		});
		dwr.TOPEngine.setAsync(true);
		
		if (rsNum==iDataSize) {
			window.opener.copyTestCaseResult(true);
		} else if(rsNum==0){
			window.opener.copyTestCaseResult(false);
		} else{
			window.opener.copyTestCaseResult(rsNum);		
		}
		window.close();
		
	}
	
    //页面关闭
	function testCaseClose(){
		window.close();
	}
	
	/**
	 * 表格自适应宽度
	 */
	function getBodyWidth () {
	    return  ($("body").innerWidth()) - 10;
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