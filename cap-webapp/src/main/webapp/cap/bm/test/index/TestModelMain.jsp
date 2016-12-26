<%
    /**********************************************************************
	 * 测试建模建模主框架页面
	 * 2016-10-10  zhangzunzhi 新建
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<html>
<head>
<meta charset="UTF-8">
<title>测试建模主框架</title>
<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
<style type="text/css">
.cui-tab ul.cui-tab-nav li{
	padding:0 5px;
	margin-right:5px
}

</style>

<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
<top:script src='/cap/dwr/engine.js'></top:script>
<top:script src='/cap/dwr/util.js'></top:script>
<top:script src='/cap/dwr/interface/CapAppAction.js'></top:script>
<top:script src='/cap/dwr/interface/FuncModelAction.js'></top:script>
<top:script src='/cap/dwr/interface/TestCaseFacade.js'></top:script>

<script type="text/javascript">

//返回应用编辑需要的参数
var clickCome = "${param.clickCome}";
var packageId = "${param.packageId}";
var parentNodeName = "${param.parentNodeName}";
var parentNodeId = "${param.parentNodeId}";
var testModel = "${param.testModel}";
var myAppId = "${param.id}";
var appVO;
var funcFullCode;
var func;
var type;
   jQuery(document).ready(function(){
	   jQuery("#tabBodyDiv").css("height",$(window).height()-61);
	   $(window).resize(function(){
	      jQuery("#tabBodyDiv").css("height",$(window).height()-61);
	   });
	   dwr.TOPEngine.setAsync(false);
	   CapAppAction.queryById(myAppId,function(data){
			appVO = data;
		});
	   if(!myAppId){
		   var app = {"employeeId":globalCapEmployeeId,"appId":packageId,"appType":2};
			CapAppAction.queryStoreApp(app,function(data){
				appVO = data;
			});
	   }
	   
		FuncModelAction.readFuncByModuleId(packageId,function(data){ //应用
			func = data;
			funcFullCode = func.fullPath;
		});
		dwr.TOPEngine.setAsync(true);
       comtop.UI.scan();
       initIframe();
       
		//显示按钮控制 
		if(clickCome=="homepage"){
			cui("#assignRight").hide();
			cui("#storeUp").hide();
			//cui("#returnEditFunc").hide();
			cui("#cancelStore").hide();
			cui("#closeWin").show();
		}else{
			cui("#assignRight").hide();
			var roleIds = globalCapRoleIds.split(';');
			for(var i = 0; i < roleIds.length; i++){
				if(roleIds[i] == 'pm'){
					cui("#assignRight").show();
				}
			}
			cui("#storeUp").show();
			//cui("#returnEditFunc").show();
			cui("#cancelStore").hide();
			cui("#closeWin").hide();
		}
		if(clickCome=="homepage" && appVO.appType == 2){
			cui("#cancelStore").show();
		}else if(!clickCome && appVO && appVO.appType == 2){
			cui("#storeUp").hide();
			cui("#cancelStore").show();
		}
   });
   
   //初始化iframe
   function initIframe(){
	   type="FUNCTION";
	   var attr="&packageId="+packageId +"&funcFullCode="+funcFullCode+"&testModel="+testModel+"&type=FUNCTION";
       jQuery("#functionFrame").attr("src","TestCaseResultList.jsp?"+attr);
       //jQuery("#apiFrame").attr("src","TestApiList.jsp?"+attr);
       //jQuery("#serviceFrame").attr("src","TestServiveList.jsp?"+attr);
   }
   
   //根据测试用例名称搜索
   function testCaseSimpleQuery(){
	   var keyword = getRegKeyWord(cui("#testCaseClickInput").getValue());
	   var objWindow =document.getElementById("functionFrame").contentWindow; 
	   var pageSize = objWindow.cui("#functionTable").getQuery().pageSize;
		var pageNo = objWindow.cui("#functionTable").getQuery().pageNo;
		var objTestCase ={type:type,pageNo:pageNo,pageSize:pageSize,name:keyword};
		dwr.TOPEngine.setAsync(false);
		TestCaseFacade.queryTestCaseList(funcFullCode,packageId,objTestCase,function(data){
			objWindow.cui("#functionTable").setDatasource(data.list,data.size);
		});
		dwr.TOPEngine.setAsync(true);
   }
   
	//键盘回车键快速查询 
	function keyDownQuery(event,self) {
		if ( event.keyCode ==13) {
			testCaseSimpleQuery();
		}
	}
   
	var generateTestMenu = {
	    	datasource: [
		     	            {id:'generateTest',label:'生成用例'},
		     	            {id:'generateScript',label:'生成脚本'},
		     	            {id:'sendTest',label:'发送脚本'},
		     	            {id:'executeTest',label:'执行脚本'}
		     	        ],
				on_click:function(obj){
		     	        	if(obj.id=='generateTest'){
		     	        		generateTest();
		     	        	}else if(obj.id=='generateScript'){
		     	        		generateScript();
		     	        	}else if(obj.id=='sendTest'){
		     	        		sendTest();
		    	        	}else if(obj.id=='executeTest'){
		    	        		executeTest();
		    	        	}
				}	
	}
	
	//生成用例
	function generateTest(){
		//获取选中的实体和界面
		var objWindow =document.getElementById("functionFrame").contentWindow; 
		var selectData = objWindow.cui("#functionTable").getSelectedRowData();
		cui.handleMask.show();
		if(selectData.length == 0){ //全部生成 
			TestCaseFacade.genTestcase(funcFullCode,function(data){
				cui.handleMask.hide();
				if(data){
					cui.message("生成用例成功。","success");
					setTimeout("refresh()",1000);
				}else{
					cui.message("生成用例失败。","error");
				}
			});
		}else{
			var metaDataArr = [],hashResult={};
			for(var i=0;i<selectData.length;i++){
				if(selectData[i].metadata){
				 var metadataId = selectData[i].metadata.split(':')[0];
				  if(!hashResult[metadataId]){
				     metaDataArr.push(metadataId);
				     hashResult[metadataId] = true;
				  }
				}
			}
			TestCaseFacade.genTestcaseByMetadata(metaDataArr,function(data){
				cui.handleMask.hide();
				if(data){
					cui.message("生成用例成功。","success");
					setTimeout("refresh()",1000);
				}else{
					cui.message("生成用例失败。","error");
				}
			});
		}
	}
	
	//生成本地脚本
	function generateScript(){
		var objWindow =document.getElementById("functionFrame").contentWindow; 
		var testCaseArr = objWindow.cui("#functionTable").getSelectedPrimaryKey();
		cui.handleMask.show();
		if(testCaseArr.length==0){ //生成全部 
			TestCaseFacade.genScriptByPackage(funcFullCode,function(data){
				cui.handleMask.hide();
				if(data){
					cui.message("生成脚本成功。","success");
					setTimeout("refresh()",1000);
				}else{
					cui.message("生成脚本失败。","error");
				}
			});
		}else{
			TestCaseFacade.genScriptByTestcaseIds(testCaseArr,function(data){
				cui.handleMask.hide();
				if(data){
					cui.message("生成脚本成功。","success");
					setTimeout("refresh()",1000);
				}else{
					cui.message("生成脚本失败。","error");
				}
			});
		}
	}
	
	//生成脚本并发送服务器
	function sendTest(){
		cui.handleMask.show();
		TestCaseFacade.sendTestcases(funcFullCode,function(data){
			cui.handleMask.hide();
			if(data && data.uploadScript){
				cui.message("发送用例成功。","success");
				setTimeout("refresh()",1000);
			}else{
				cui.message("发送用例失败。","error");
			}
		});
	}
	
	//执行脚本
	function executeTest(){
		//获取参数
		var param;
		dwr.TOPEngine.setAsync(false);
		TestCaseFacade.getExecuteTestParam(function(data){
			param = data;
		});
		dwr.TOPEngine.setAsync(true);
		//设置远程启动Url：http://10.10.5.151:10010/testcase/exec
		var testServerRemotePort = "10010";
		var remoteStartUrl = param.serverUrl + ":" + testServerRemotePort + "/testcase/exec";
		$.ajax({
            type : "Post",
            url : remoteStartUrl,
            data : {
  	          "url": param.url,
  	          "username": param.userName,
  	          "password": param.password
  	        },
            datatype: "jsonp",
            crossDomain: true,
            success:function(autoTestId){
            	//updateTask(autoTestId);
            }
         });
	}
   
   //tab页点击事件
   function tabClick(frameId){
	   var ar = ['function', 'api', 'service'];
	   var arrType = ["FUNCTION","API","SERVICE"];
	   var attr="&packageId="+packageId +"&funcFullCode="+funcFullCode+"&testModel="+testModel;
	   for(var i=0;i<ar.length;i++){
		   if (frameId == ar[i]) {
			   type=arrType[i];
			   jQuery("#functionFrame").attr("src","TestCaseResultList.jsp?"+attr+"&type="+arrType[i]);
			   jQuery("#"+ ar[i]+"Tab").css("background-color","");
			   jQuery("#"+ ar[i]+"Tab").addClass("cui-active");
               //jQuery("#"+ ar[i]+"Frame").css("display", "block");
           } else {
        	   jQuery("#"+ ar[i]+"Tab").css("background-color","#f5f5f5");
               jQuery("#"+ ar[i]+"Tab").removeClass("cui-active");
              // jQuery("#"+ ar[i]+"Frame").css("display", "none");
              
           }
	   }
   }
	
	//返回事件 
	function returnEditFunc(event, self, mark){
		var returnParentNodeName  = decodeURIComponent(decodeURIComponent(parentNodeName));
		if(returnParentNodeName!="undefined"&&returnParentNodeName!=null&&returnParentNodeName!="null"){
			returnParentNodeName = encodeURIComponent(encodeURIComponent(returnParentNodeName));
		}
		var returnUrl = '<%=request.getContextPath() %>/cap/bm/dev/systemmodel/FuncModelEdit.jsp?nodeId=' + packageId + '&parentNodeId=' + parentNodeId
		+ "&parentNodeName=" + returnParentNodeName;
		window.open(returnUrl + "&testModel=testModel", '_self');
	}

	//收藏事件
	function storeUp(event, self, mark){
		var app = {"employeeId":globalCapEmployeeId,"appId":packageId,"appType":2};
		dwr.TOPEngine.setAsync(false);
		CapAppAction.storeUpApp(app,function(data){ 
			if(data){
				var app = {"employeeId":globalCapEmployeeId,"appId":packageId,"appType":2};
				CapAppAction.queryStoreApp(app,function(data){
					appVO = data;
				});
				cui.message('收藏成功！','success');
				setTimeout(function(){
					cui("#storeUp").hide();
					cui("#cancelStore").show();
				},400);
			}else{
				cui.message('收藏失败', "error");
			} 
	    });
		dwr.TOPEngine.setAsync(true);
	}
	//取消收藏 
	function cancelStore(){
		var app = {"id":appVO.id};
		dwr.TOPEngine.setAsync(false);
		CapAppAction.cancelAppStore(app,function(data){ 
			if(data){
				cui.message('取消成功！','success');
				cui("#storeUp").show();
				cui("#cancelStore").hide();
			}else{
				cui.message('取消失败', "error");
			} 
	    });
		dwr.TOPEngine.setAsync(true);
	}
	
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
	
	var addTestCaseUrl;
	var editTestCaseUrl;
	addTestCaseUrl = "<%=request.getContextPath() %>/cap/bm/test/design/TestCaseAdd.jsp?packageId=" + packageId +"&moduleCode="+funcFullCode;
	editTestCaseUrl = "<%=request.getContextPath() %>/cap/bm/test/design/TestCaseMain.jsp?packageId=" + packageId +"&moduleCode="+funcFullCode;
	//添加新的测试用例 
	var testCaseDialog;
	function addTestCase(){
		var testCase;
		dwr.TOPEngine.setAsync(false);
		TestCaseFacade.queryTestCaseList(funcFullCode,function(data){
			testCase = data;
		});
		dwr.TOPEngine.setAsync(true);
		console.log(testCase);
		if(testCase.length==0){
			cui.alert("请先配置元数据行为类型，生成用例!");
			return;
		}
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
			data.modelPackage = funcFullCode;
		    dwr.TOPEngine.setAsync(false);
		    TestCaseFacade.saveTestCase(data,function(result){
				  if(result){
					  cui.message('保存成功。','success');
					  refresh();//刷新页面
				  }
			   });
			dwr.TOPEngine.setAsync(true);
			if(testCaseDialog){
				testCaseDialog.hide();
			}
	}
	
	//关闭测试用例编辑窗口
	function closeTestCaseWindow(){
		testCaseDialog.hide();
	}
	
	//从选择页面复制name="testCase"
	function selectTestCase() {
		var objWindow =document.getElementById("functionFrame").contentWindow; 
		var selectData = objWindow.cui("#functionTable").getSelectedRowData();
		if (selectData == null || selectData.length == 0) {
			cui.alert("请选择要复制的用例。");
			return;
		} else {
				var url =  "<%=request.getContextPath() %>/cap/bm/test/design/CopyTestCaseNameEdit.jsp?packageId="+packageId + "&moduleCode=" + funcFullCode;
				var top=(window.screen.availHeight-600)/2;
	    		var left=(window.screen.availWidth-800)/2;
				window.open(url,'copyTestCaseNameEdit','height=650,width=1000,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no');
		}
	}
	
	//返回被选择的页面 供其他页面调用
	function returnSelectTestCase(){
		var objWindow =document.getElementById("functionFrame").contentWindow; 
		var selectData = objWindow.cui("#functionTable").getSelectedRowData();
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
		refresh();
	}
	
	//刷新当前页面函数
	function refresh(){
		window.location.reload();
	}
	
	//分配事件
	function assignRight(event, self, mark){
		var url = "<%=request.getContextPath() %>/cap/ptc/team/CheckMulTestPersonnel.jsp?teamId="+globalCapTeamId+"&appId="+ packageId;
		var title="选择测试人员";
		var height = 450; //600
		var width =  680; // 680;
		
		dialog = cui.dialog({
			title : title,
			src : url,
			width : width,
			height : height
		})
		dialog.show(url);
	}
	
	//分配后回调 
	function chooseEmployee(selects,teamId){
		dwr.TOPEngine.setAsync(false);
		CapAppAction.assignApp(selects,packageId,teamId,function(data){ 
			if(data == 1) {
				cui.message('分配成功！','success');
			}else{
				cui.message('分配失败', "error");
			} 
	    });
		dwr.TOPEngine.setAsync(true);
	}
	
	//测试用例批量删除事件batchDelTestCase
	function batchDelTestCase(){
		var objWindow =document.getElementById("functionFrame").contentWindow; 
		var testCaseArr = objWindow.cui("#functionTable").getSelectedPrimaryKey();
		if(!checkTestCase(testCaseArr)){
			cui.alert("没有测试用例可以删除，请先生成用例。");
			return;
		}
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
	
	//检查是否有测试用例
	function checkTestCase(testCaseArr){
		var isHas = false;
		for(var i=0;i<testCaseArr.length;i++){
			if(testCaseArr[i]!=""&&testCaseArr[i]!=null&&testCaseArr[i]!="null"){
				isHas = true;
			}
		}
		return isHas;
	}
	
	//删除测试用例
	function delTestCase(ids){
		dwr.TOPEngine.setAsync(false);
		TestCaseFacade.delTestCases(ids,function(data){
			if(data){
				cui.message("删除用例成功。","success");
				refresh();
			}else{
				cui.message("删除用例失败。","error");
			}
 		});
 		dwr.TOPEngine.setAsync(true);
 		
	}
	
	
	function closeWin(){
		window.close();
	}
	
	//关键字过滤
	function getRegKeyWord(keyword){
		keyword = keyword.replace(new RegExp("/", "gm"), "//");
		keyword = keyword.replace(new RegExp("%", "gm"), "/%");
		keyword = keyword.replace(new RegExp("_","gm"), "/_");
		keyword = keyword.replace(new RegExp("'","gm"), "''");
		return keyword;
	}
	
</script>
</head>
<body style="background-color:#f5f5f5">
 	<div class="cui-tab" style="border:solid 1px #e6e6e6;background:#f5f5f5">
 		<span class="tabs-scroller-left cui-icon" style="display: none;"></span>
 		<span class="tabs-scroller-right cui-icon" style="display: none; right: 22px;"></span>
        <div class="cui-tab-head" style="margin: 0px;font-size:11pt">
        	<table style="width:100%;border-spacing: 0px">
        		<tr>
        			<td style="text-align:left;padding:0px">
        				<ul class="cui-tab-nav" style="height:40px;width:100%;padding:0px 0 0 0px;background-color:#f5f5f5">
			                <li id="functionTab" title="界面功能" class="cui-active" style="width:60px;height:40px;line-height:40px;margin-left:8px" onclick="tabClick('function')">
			                	<span class="cui-tab-title">界面功能</span>
			                    <a href="#" class="cui-tab-close cui-icon" style="display:none;"></a>
			                </li>
			                <li id="apiTab" title="后台API" class="" style="width:60px;height:40px;line-height:40px;background-color:#f5f5f5" onclick="tabClick('api')">
			                	<span class="cui-tab-title">后台API</span>
			                	<a href="#" class="cui-tab-close cui-icon" style="display:none;"></a>
			                </li>
			                <li id="serviceTab" title="业务服务" class="" style="width:60px;height:40px;line-height:40px;background-color:#f5f5f5" onclick="tabClick('service')">
			                	<span class="cui-tab-title">业务服务</span>
			                	<a href="#" class="cui-tab-close cui-icon" style="display:none;"></a>
			                </li>
			            </ul>
        			</td>
        			<td style="text-align:right;padding-right:0px">
        			    <span uiType="ClickInput" width="200px" id="testCaseClickInput" name="testCaseClickInput" enterable="true" emptytext="输入用例名称查询" editable="true" width="300" on_iconclick="testCaseSimpleQuery" 
				 			 on_keydown="keyDownQuery" 	icon="search" iconwidth="18px"></span> 
        				<span uitype="Button" id="assignRight" label="分配" button_type="" on_click="assignRight"></span>
		                <span uitype="Button" id="storeUp" label="收藏" button_type="" on_click="storeUp"></span>
		                <span uitype="Button" id="cancelStore" label="取消收藏" button_type="" on_click="cancelStore"></span>
        				<span uitype="button" id="generateTestMenu" label="生成用例" menu="generateTestMenu" ></span>
        				<span uitype="Button" label="新增" id="menu_add_testCase"  menu="menu_add_testCase"></span>
        				<span uitype="Button" label="删除" on_click="batchDelTestCase"></span>
        				
			        <!-- 	<span uitype="Button" id="returnEditFunc" label="返回" button_type="green-button" icon="reply" on_click="returnEditFunc"></span>  -->
        			    <span uitype="Button" id="closeWin" label="关闭" button_type="green-button" icon="" on_click="closeWin"></span>
        			</td>
        		</tr>
        	</table>
        </div>
        <div class="cui-tab-content"  id="tabBodyDiv" style="border-top:3px solid #4585e5">
        	<iframe id="functionFrame" frameborder="0"  style="height: 100%; width: 100%; position: static; left: 0px; top: 0px;display:block"></iframe>
        	<!-- <iframe id="apiFrame"   frameborder="0"  style="height: 100%; width: 100%; position: static; left: 0px; top: 0px;display:none"></iframe>
        	<iframe id="serviceFrame"   frameborder="0"  style="height: 100%; width: 100%; position: static; left: 0px; top: 0px;display:none"></iframe>  -->
        </div>
   	</div>
</body>
</html>
