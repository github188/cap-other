
<%
/**********************************************************************
* 测试用例列表
* 2016-8-16 李小芬 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>测试用例列表</title>
<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
<top:link href="/cap/bm/common/base/css/base.css"></top:link>
<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"></top:link>

<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
<top:script src="/cap/bm/common/base/js/angular.js"></top:script>
<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
<top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
<top:script src='/cap/dwr/engine.js'></top:script>                        
<top:script src='/cap/dwr/util.js'></top:script>
<top:script src='/cap/dwr/interface/TestCaseFacade.js'></top:script>
<top:script src='/cap/dwr/interface/EntityFacade.js'></top:script>
<top:script src='/cap/dwr/interface/PageFacade.js'></top:script>
<top:script src='/cap/bm/dev/consistency/js/consistency.js'></top:script>

<script type="text/javascript">
var packageId = "${param.packageId}";//包ID
var packagePath = "${param.packagePath}";//包路径

var entity;
var page;

//界面新增菜单
var menu_add_testCase = {
		datasource:[
		{id:'item1',label:"新建用例"},
		{id:'copyTestCase',label:"复制选择用例"}],
		type:"button",
		on_click:function(e){
			if(e.id=="item1"){
				addTestCase();
			}else if(e.id=="copyTestCase"){
				selectTestCase();
			}
		},
		width:100,
		trigger:"mouseover"
};

//从选择页面复制name="testCase"
function selectTestCase() {
	var selectData = cui("#TestCaseGrid").getSelectedRowData();
	if (selectData == null || selectData.length == 0) {
		cui.alert("请选择要复制的用例。");
		return;
	} else {
		var url =  "<%=request.getContextPath() %>/cap/bm/test/design/CopyTestCaseNameEdit.jsp?packageId="+packageId + "&moduleCode=" + packagePath;
		var top=(window.screen.availHeight-600)/2;
   		var left=(window.screen.availWidth-800)/2;
		window.open(url,'copyTestCaseNameEdit','height=650,width=1000,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no');
	}
}

//添加新的测试用例 
var testCaseDialog;
function addTestCase(){
	var addTestCaseUrl = "TestCaseAdd.jsp?packageId=" + packageId +"&moduleCode="+packagePath;
	var height = 650;
	var width = 730;
	if(!testCaseDialog){
		testCaseDialog = cui.dialog({
		  	title : "新增测试用例",
		  	src : addTestCaseUrl,
		    width : width,
		    height : height
		});
	}
	testCaseDialog.show(addTestCaseUrl);
}

//新增编辑保存回调
function saveTestCaseCallBack(data,moduleCode){
		data.modelPackage = packagePath;
	    dwr.TOPEngine.setAsync(false);
	    TestCaseFacade.saveTestCase(data,function(result){
			  if(result){
				  cui.message('保存成功。','success');
				  cui("#TestCaseGrid").loadData();//刷新页面
				  var modelId = data.modelPackage + ".testcase." + data.modelName; 
				  cui("#TestCaseGrid").selectRowsByPK(modelId);
			  }
		   });
		dwr.TOPEngine.setAsync(true);
		if(testCaseDialog){
			testCaseDialog.hide();
		}
}

//返回被选择的页面 供其他页面调用
function returnSelectTestCase(){
	var selectData = cui("#TestCaseGrid").getSelectedRowData();
	return selectData;
}

//复制选择页面结果
function copyTestCaseResult(rs){
	if(typeof rs === 'number'){
		cui.message(rs+'个用例复制成功！', 'success');
	}
	if(typeof rs === 'boolean'){
		if (rs) {
			cui.message('用例复制成功！', 'success');
		} else {
			cui.error("用例复制失败！");
		} 
	}
	 cui("#TestCaseGrid").loadData();//刷新页面
}

//新增测试用例页面关闭
function closeTestCaseWindow(){
	testCaseDialog.hide();
}

//测试用例修改
function updateTestCase(id,modelId,type){
	var editTestCaseUrl = "TestCaseMain.jsp?packageId=" + packageId +"&moduleCode="+packagePath+"&modelId="+modelId;
	window.open(editTestCaseUrl,"editTestCase");
}

//初始化测试用例类型 
var initTestCaseType = [
	{id:'0',text:'全部类型'},
	{id:'FUNCTION',text:'界面功能'},
	{id:'API',text:'后台API'},
	{id:'SERVICE',text:'业务服务'}
];

window.onload = function(){
	comtop.UI.scan();
}

//grid数据源
var testCase;
function initData(tableObj,query){
	//关键字查询
	var keyword = getRegKeyWord(cui("#testCaseClickInput").getValue());
	//下拉框
	var type = cui("#testCaseType").getValue();
	if(type=="0"){
		type = "";
	}
	dwr.TOPEngine.setAsync(false);
	TestCaseFacade.queryTestCaseList(packagePath,type,keyword,query.pageNo,query.pageSize,function(data){
		tableObj.setDatasource(data.list, data.size);
		testCase = data;
	});
	dwr.TOPEngine.setAsync(true);
}

//搜索
function testCaseSimpleQuery(){
	cui("#TestCaseGrid").loadData();
}

//grid列渲染
function nameRenderer(rd, index, col) {
	if(rd.containCustomizedStep){
		return "<a href='javascript:;' onclick='updateTestCase(\"" +rd.id+ '","'+rd.modelId+ '","'+rd.type+"\");'><font color=red>" +rd.name + "</font></a>";
	}
	return "<a href='javascript:;' onclick='updateTestCase(\"" +rd.id+ '","'+rd.modelId+ '","'+rd.type+"\");'>" +rd.name + "</a>";
}
//grid列渲染
function typeRenderer(data,field){
	if(data.type == "FUNCTION") {
		return "界面功能";
	}else if(data.entityType == "API"){
		return "后台API";
	}else if(data.entityType == "SERVICE"){
		return "业务服务";
	}
}

//测试用例批量删除事件batchDelTestCase
function batchDelTestCase(){
	var testCaseArr = cui("#TestCaseGrid").getSelectedPrimaryKey();
	if(testCaseArr.length==0){
		cui.alert("请选择要删除的测试用例。");
	}else{
		cui.confirm("确认要删除当前测试用例吗？",{
			onYes:function(){
				delTestCase(testCaseArr);
			}
		});
	}
}

//删除测试用例
function delTestCase(ids){
	dwr.TOPEngine.setAsync(false);
	TestCaseFacade.delTestCases(ids,function(data){
		if(data){
			cui.message("删除用例成功。","success");
			cui("#TestCaseGrid").loadData();
		}else{
			cui.message("删除用例失败。","error");
			cui("#TestCaseGrid").loadData();
		}
		});
		dwr.TOPEngine.setAsync(true);
}

//生成本地脚本
function generateScript(){
	var testCaseArr = cui("#TestCaseGrid").getSelectedPrimaryKey();
	cui.handleMask.show();
	if(testCaseArr.length==0){ //生成全部 
		TestCaseFacade.genScriptByPackage(packagePath,function(data){
			cui.handleMask.hide();
			if(data){
				cui.message("生成脚本成功。","success");
			}else{
				cui.message("生成脚本失败。","error");
			}
		});
	}else{
		TestCaseFacade.genScriptByTestcaseIds(testCaseArr,function(data){
			cui.handleMask.hide();
			if(data){
				cui.message("生成脚本成功。","success");
			}else{
				cui.message("生成脚本失败。","error");
			}
		});
	}
}

//生成脚本并发送服务器
function sendTest(){
	cui.handleMask.show();
	TestCaseFacade.sendTestcases(packagePath,function(data){
		cui.handleMask.hide();
		if(data && data.uploadScript){
			cui.message("发送用例成功。","success");
		}else{
			cui.message("发送用例失败。","error");
		}
	});
}

//生成用例
function generateTest(){
	cui.handleMask.show();
	TestCaseFacade.genTestcase(packagePath,function(data){
		cui.handleMask.hide();
		if(data){
			cui.message("生成用例成功。","success");
			cui("#TestCaseGrid").loadData();
		}else{
			cui.message("生成用例失败。","error");
			cui("#TestCaseGrid").loadData();
		}
	});
}

//如果a包含b 或者b为""返回true
/**
* 验证a是否包含b b为""则直接返回 忽略大小写
*@a 源字符串
*@b 目标字符串
*@return 如果a包含b 则返回true
*/
function compare(a,b){
	if(b==null||""==b){
		return true;
	}
	a=a.toLowerCase();
	b=b.toLowerCase();
	return a.indexOf(b)>=0;
}

//关键字过滤
function getRegKeyWord(keyword){
	keyword = keyword.replace(new RegExp("/", "gm"), "//");
	keyword = keyword.replace(new RegExp("%", "gm"), "/%");
	keyword = keyword.replace(new RegExp("_","gm"), "/_");
	keyword = keyword.replace(new RegExp("'","gm"), "''");
	return keyword;
}

//键盘回车键快速查询 
function keyDownQuery(event,self) {
	if ( event.keyCode ==13) {
		testCaseSimpleQuery();
	}
}

//grid 宽度
function resizeWidth(){
	return (document.documentElement.clientWidth || document.body.clientWidth) - 30;
}

//grid高度
function resizeHeight(){
	return (document.documentElement.clientHeight || document.body.clientHeight) - 75;
}	

var generateTestMenu = {
    	datasource: [
	     	            {id:'generateTest',label:'生成用例'},
	     	            {id:'generateScript',label:'生成脚本'},
	     	           {id:'sendTest',label:'发送脚本'}
	     	        ],
			on_click:function(obj){
	     	        	if(obj.id=='generateTest'){
	     	        		generateTest();
	     	        	}else if(obj.id=='generateScript'){
	     	        		generateScript();
	     	        	}else if(obj.id=='sendTest'){
	     	        		sendTest();
	    	        	}
			}	
}

</script>
</head>
<body>
	<div id="testCaseRoot" class="cap-page">
		<div class="cap-area" style="width: 100%;">
			<table class="cap-table-fullWidth">
				<tr>
					<td class="cap-td" style="text-align: left; padding: 5px">
							<!-- <span id="formTitle" uitype="Label" value="测试用例列表&nbsp;&nbsp;&nbsp;" class="cap-label-title" size="12pt"></span>  -->
			        		<span uiType="ClickInput" width="200px" id="testCaseClickInput" name="testCaseClickInput" enterable="true" emptytext="输入中文名称查询" editable="true" width="300" on_iconclick="testCaseSimpleQuery" 
				 			 on_keydown="keyDownQuery" 	icon="search" iconwidth="18px"></span> 
			        		<span uiType="PullDown" mode="Single" editable="false" id="testCaseType" datasource="initTestCaseType"  select="0" label_field="text" value_field="id"  width="120"  on_change="testCaseSimpleQuery"></span>
					</td>
					<td class="cap-td" style="text-align: right; padding: 5px">
                       	 	<span uitype="Button" label="新增" id="menu_add_testCase"  menu="menu_add_testCase"></span>
							<!-- <span uitype="button" id="generateTest" button_type="green-button" label="生成用例"  icon="check" on_click="generateTest" ></span>
							<span uitype="button" id="generateScript" button_type="green-button" label="生成脚本"  icon="file-o" on_click="generateScript" ></span>
							<span uitype="button" id="sendTest" button_type="green-button" label="发送脚本"  icon="sign-in" on_click="sendTest" ></span>
					         -->
					         <span uitype="button" id="generateTestMenu" label="生成用例" menu="generateTestMenu" ></span>
					        <span uitype="Button" label="删除" on_click="batchDelTestCase"></span>
					</td>
				</tr>
			</table>
			<table class="cap-table-fullWidth">
				<tr>
					<td class="cap-td">
						<table uitype="Grid" id="TestCaseGrid" primarykey="modelId" colhidden="false" datasource="initData" 
							resizewidth="resizeWidth" resizeheight="resizeHeight" pagesize_list="[18,25,50]" pagesize="25" pagination="true">
							<thead>
								<tr>
									<th style="width: 30px" renderStyle="text-align: center;">
									<input type="checkbox"></th>
									<th style="width: 50px" renderStyle="text-align: center;" bindName="1">序号</th>
									<th style="width:18%;" renderStyle="text-align: left" bindName="name" render="nameRenderer">用例中文名称</th>
									<th style="width:18%;" renderStyle="text-align: left" bindName="modelName">英文名称</th>
									<th style="width:18%;" renderStyle="text-align: left" bindName="type" render="typeRenderer" >类型</th>
								</tr>
							</thead>
						</table>
					</td>
				</tr>
				<tr>
					<td class="cap-td"></td>
				</tr>
			</table>
		</div>
	</div>
</body>
</html>