<%
/**********************************************************************
* 工作流待办配置编辑界面
* 2016-2-24 许畅 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html ng-app='pageInfoEdit'>
<head>
<meta charset="UTF-8">
<title>工作流待办配置</title>
	<link rel="shortcut icon" href="${pageScope.cuiWebRoot}/cap/ptc/index/image/workbench.png">
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <style type="text/css">
     .required{
       color:red;
     }
    </style>
	 
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
	<top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src='/cap/dwr/interface/WorkflowWorkbenchAction.js'></top:script>
</head>
<body style="background-color:#f5f5f5;" ng-controller="pageInfoEditCtrl" data-ng-init="ready()">
<div class="cap-page">
	<div class="cap-area" style="width:100%; height: 100%">
	  <div class="cui-tab-head" style="margin: 0px;font-size:11pt">
        	<table style="width:100%;border-spacing: 0px">
        		<tr>
        			<td style="text-align:right;width:480px;padding-right:0px">
        				<span uitype="Button" id="fullscreen" label="全屏" icon="expand" on_click="fullscreen"></span>
        				<span id="save" uitype="Button" label="保存" icon="file-text-o" onclick="save()"></span>
			        	<span id="return" uitype="Button" label="返回" onclick="back()"></span>
        			</td>
        		</tr>
        	</table>
        </div>
		<table class="cap-table-fullWidth" style="margin-bottom: 20px;">
			<tr>
		        <td class="cap-td" style="text-align: left;">
		        	<span id="formTitle" uitype="Label" value="工作台待办配置信息" class="cap-label-title" size="12pt"></span>
		        </td>
		    </tr>
					    <tr>
					    	<td class="cap-td" style="text-align: right;width:100px" width="30%" id="processLabel">
								<a class="required">*</a>关联流程:
					        </td>
					        <td class="cap-td" style="text-align: left;" width="70%">
					        	<span cui_clickinput id="processName" ng-model="page.processName" width="80%" ng-click="openWorkflowProcess()" validate="processNameValRule"></span>
					        </td>
					    </tr>
					    
					    <tr>
					    	<td class="cap-td" style="text-align: right;width:100px" width="30%">
								流程名称:
					        </td>
					        <td class="cap-td" style="text-align: left;" width="70%">
					        	<span cui_input id="processName_l2" ng-model="page.processName" ng-show="true" width="80%"></span>
					        </td>
					    </tr>
					    <tr>
						    <td  class="cap-td" style="text-align: right;width:120px" width="30%" id="urlLabel1">
								 待办URL:
					        </td>
					        <td class="cap-td" style="text-align: left;" width="70%">
					            <span cui_clickinput id="todo_url"  editable="true" ng-model="page.todo_url" on_iconclick="openPageURL2" width="80%"></span>
					        </td>
					    </tr>
					    <tr>
						    <td  class="cap-td" style="text-align: right;width:120px" width="30%" id="urlLabel2">
								已办URL:
					        </td>
					        <td class="cap-td" style="text-align: left;" width="70%">
					        	<span cui_clickinput id="done_url" editable="true" ng-model="page.done_url" on_iconclick="openPageURL" width="80%"></span>
					        </td>
					    </tr>
		</table>
		
	</div>
</div>

<script type="text/javascript">
    //获得传递参数
    var modelId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
    //从元数据视图切换过来的
	var viewType ="${param.viewType}";
	var packageId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
	var page={};
	 //系统目录树的，应用模块编码
    var moduleCode = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageModuleCode"))%>;
    //生成代码路径key 
    var GEN_CODE_PATH_CNAME = "GEN_CODE_PATH_CNAME";
	//拿到angularJS的scope
    var scope=null;
	
    var processNameValRule = [{type:'required',rule:{m:'关联流程不能为空'}}];
    var doneURLValRule = [{type:'required',rule:{m:'待办页面URL不能为空'}}];
    var processIdValRule= [{type:'required',rule:{m:'关联流程id不能为空'}}];
    
	//页面初始化
	$(function(){
		$(".cap-page").css("height", $(window).height()-20);
		$(window).resize(function(){//开启监控，第一次初始化时，不会进入此方法
	       jQuery(".cap-page").css("height", $(window).height()-20);
	    });
		if(isNotEmpty(modelId)){
			cui("#processName").setReadonly(true);
			$("#processName").attr("readonly","true");
		}
		if(isNotEmpty(viewType)){
			$("#fullscreen").hide();
			$("#return").hide();
		}
	});
	
	//angular js开始
	angular.module('pageInfoEdit', [ "cui"]).controller('pageInfoEditCtrl', function ($scope) {
		$scope.page=page;
		$scope.displayFlag = false;
		$scope.ready=function(){
	    	comtop.UI.scan();
	    	$scope.initDefaultValue();
	    	scope=$scope;
	    }
		
		//初始化默认值
		$scope.initDefaultValue=function(){
			if(isNotEmpty(modelId)){
				dwr.TOPEngine.setAsync(false);
				WorkflowWorkbenchAction.loadData(modelId, function(map) {
					if(map["list"].length>0){
						var data=map["list"][0];
						page=data;
						$scope.page=data;
					    //$scope.$digest();
					}
				});
				dwr.TOPEngine.setAsync(true);
			}
		}
		
		//关联流程
    	$scope.openWorkflowProcess=function(){
			if($("#processName").attr("readonly"))
				return;
			
    		var url = "${pageScope.cuiWebRoot}/cap/bm/dev/entity/WorkFlowSelection.jsp?dirCode="+moduleCode+"&openType=1";
			var title="选择流程";
			var height = 500;
			var width =  680;
			
			dialog = cui.dialog({
				title : title,
				src : url,
				top:30,
				width : width,
				height : height
			})
			dialog.show(url);
    	}
		
	 });
	
	
	//已办页面URL
	var openPageURL2 = function(){
		var url = "WorkflowPageURL.jsp?packageId="+packageId+"&openType=2";
		var title="选择流程";
		var height = 500;
		var width =  680;
		
		dialog = cui.dialog({
			title : title,
			src : url,
			top:30,
			width : width,
			height : height
		})
		dialog.show(url);
	}
	
	//待办页面URL
	var openPageURL=function(){
		var url = "WorkflowPageURL.jsp?packageId="+packageId+"&openType=1";
		var title="选择流程";
		var height = 500;
		var width =  680;
		
		dialog = cui.dialog({
			title : title,
			src : url,
			top:30,
			width : width,
			height : height
		})
		dialog.show(url);
    }
	
	
	
  //全屏
  function fullscreen(){
	  if(cui("#fullscreen").getLabel()==="全屏"){
		   window.parent.cui("#body").setCollapse("left",true);
		   cui("#fullscreen").setLabel("退出全屏");
		   cui("#fullscreen")._setIcon("compress");
		   $(window.frameElement).css({"position":"fixed","top":0,"left":0});
		   $(window.parent.frameElement).css({"position":"fixed","top":0,"left":0});
		   window.parent.$(".bl_main .bl_border").css({"display":"none"});
	  } else{
	       window.parent.cui("#body").setCollapse("left",false);
		   cui("#fullscreen").setLabel("全屏");
		  	   cui("#fullscreen")._setIcon("expand");
		   $(window.frameElement).css({"position":"","top":"","left":""});
		   $(window.parent.frameElement).css({"position":"","top":"","left":""});
		   window.parent.$(".bl_main .bl_border").css({"display":"block"});
	  }
   }
	  
	//返回
   function back(){
   		//返回的时候退出全屏
   		if(cui("#fullscreen").getLabel()=="退出全屏"){
   			fullscreen();
   		}
		var attr="packageId="+packageId+"&packageModuleCode="+moduleCode;
		window.location.href="WorkflowWorkbenchList.jsp?"+attr;	   
   }
	
	//保存
	function save(){
		scope.$digest();
	    //校验必填项
		if(!validataPageRequired().validFlag)
			return;
	    if(!isNotEmpty(page.todo_url) && !isNotEmpty(page.done_url)){
	    	cui.message('待办页面URL和已办页面url不能都为空', 'error');
	    	return;
	    }
	    
	    //代码路径
	    var codePath = cui.utils.getCookie(GEN_CODE_PATH_CNAME);
	    
		dwr.TOPEngine.setAsync(false);
		WorkflowWorkbenchAction.saveAction(moduleCode,codePath,packageId,scope.page, function(modelId) {
			if (modelId) {
				if(viewType==="NewWay" || viewType==="metadata"){
					var pWindow = cap.searchParentWindow("refresh");
					if(pWindow && typeof pWindow["refresh"] === "function"){
						cui.message("页面保存成功!", 'success', {'callback':function(){
							 pWindow["refresh"]();
							 viewType ==="NewWay" ?  pWindow['addWBConfigDialog'].hide() : window.close();
				   		}});
					}
				}else{
					var attr="packageId="+packageId+"&packageModuleCode="+moduleCode;
					window.location.href="WorkflowWorkbenchList.jsp?"+attr;	   	
				}
			} else {
				cui.error("页面保存失败！");
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	
	//保存按钮调用
    function validataPageRequired(){
		var validate = new cap.Validate();
    	var valRule = {processName:processNameValRule,processId:processIdValRule};
    	return validate.validateAllElement(page,valRule);
    }
	
	//清空流程
	function cleanProcess(){
		scope.page.processId = "";
		scope.page.processName = "";
		scope.$digest();
	}

	//确定流程
	function selProcessBack(data) {
		scope.page.processId = data.processId;
		scope.page.processName = data.name;
		scope.$digest();
	}
	
	//清空页面URL
	function clearPageURL(openType){
		//待办页面
		if(openType==1){
			scope.page.done_url = "";
		}
		
		//已办页面
		if(openType==2){
			scope.page.todo_url = "";
		}
		scope.$digest();
	}

	//设置页面URL
	function setPageURL(data,openType) {
		//待办页面
		if(openType==1){
			scope.page.done_url = data.url;
		}
		
		//已办页面
		if(openType==2){
			scope.page.todo_url = data.url;
		}
		scope.$digest();
	}
	
	function isNotEmpty(obj) {
		return obj != null && obj != "" && obj != "undefined"
	}
	
</script>
</body>
</html>