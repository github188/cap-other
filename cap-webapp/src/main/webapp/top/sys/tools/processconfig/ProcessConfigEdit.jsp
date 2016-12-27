<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<title>流程配置管理</title>
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/ProcessConfigAction.js"></script>
	<style>
		.fontTitle{
			font-family:"微软雅黑";
			font-weight:bold;
			font-size:16px;
			float:left;		
		  	color:#0099FF;
		}	
	</style>
</head>
<body>
	<div class="top_header_wrap">
		<div class="fontTitle">编辑流程配置信息</div>
		<div id="top_float_right" class="thw_operate" style="margin-right: 12px"   >
				<span uitype="button" label="添加"  id="upload" on_click="save"></span>
		</div>
	</div>
	<div class="top_content_wrap">
		<table class="form_table">
			<tr>  
				<td class="td_label" width="15%">
					<span class="top_required">*</span>流程名称</td>     	
				<td> 
			  		<span id="processName" width="223px" uitype="Input" name="processName" databind="data.processName"  width="40%" maxlength="100"
			  			validate="[{'type':'required', 'rule':{'m': '流程名称不能为空。'}}]" readonly="false"></span></td>  
				<td class="td_label" width="15%">
					<span class="top_required">*</span>流程编号</td>     	
				<td> 
			  		<span id="processId" width="223px" uitype="Input" name="processId" databind="data.processId"  width="40%" maxlength="50"
			  			validate="[{'type':'required', 'rule':{'m': '流程编号不能为空。'}},{'type':'custom', 'rule':{'against':'isExist','m': '该编号已存在，不可为重复值'}}]" readonly="false" ></span></td>         
            </tr>
            <tr>    
				<td class="td_label" width="15%">
					<span class="top_required">*</span>是否工作流</td>     	
				<td> 
				<span id="isWorkflow" uitype="PullDown" name="isWorkflow"  databind="data.isWorkflow" 
					mode="Single" width="223px" value_field="id" label_field="text" value="Y">
					<a value="Y">是</a>
					<a value="N">否</a>
				</span>
				<td class="td_label" width="15%">应用编号</td>     	
				<td> 
			  		<span id="appId" width="223px" uitype="Input" name="appId" databind="data.appId"  width="40%" maxlength="50"
			  			readonly="false" ></span></td> 
            </tr>
            <tr>    
				<td class="td_label" width="20%">实现类</td>     	
				<td> 
			  		<span id="unworkflowClass" width="562px" height="50" uitype="Textarea" name="unworkflowClass" databind="data.unworkflowClass"  width="40%" maxlength="200"
			  			readonly="false" ></span></td>         
            </tr> 
            <tr>    
				<td class="td_label" width="15%">
					<span class="top_required">*</span>待办列表URL</td>     	
				<td> 
			  		<span id="todoUrl" width="562px" height="50" uitype="Textarea" name="todoUrl" databind="data.todoUrl"  width="40%" maxlength="500"
			  			validate="[{'type':'required', 'rule':{'m': '待办列表URL不能为空。'}}]" readonly="false" ></span></td>         
            </tr> 
            <tr>    
				<td class="td_label" width="20%">
					<span class="top_required">*</span>已办详情URL</td>     	
				<td> 
			  		<span id="doneUrl" width="562px" height="50" uitype="Textarea" name="doneUrl" databind="data.doneUrl"  width="40%" maxlength="500"
			  			validate="[{'type':'required', 'rule':{'m': '已办详情URL不能为空。'}}]" readonly="false" ></span></td>         
            </tr> 
		</table>
	</div>

<script type='text/javascript'>
	var flagId = "<c:out value='${param.processId}'/>";
	var menuData={};
	var data = {};
	var saveType = null;
	window.onload = function(){
		//初始化页面
	    if (flagId) {//编辑页面
	    	saveType = "edit";
	    	$("#upload").attr("label","保存");
	        dwr.TOPEngine.setAsync(false);
	        ProcessConfigAction.getProcessConfigById(flagId,function(processConfigData){
	            if(processConfigData.isWorkflow == 'y'){
	            	processConfigData.isWorkflow = 'Y';
	            } else if(processConfigData.isWorkflow == 'n'){
	            	processConfigData.isWorkflow = 'N';
	            }
	        	data = processConfigData;
	        });
	        dwr.TOPEngine.setAsync(true);
	        $(".fontTitle").html("编辑流程配置信息");
	    	comtop.UI.scan();
	    }else {//新增页面
	        saveType = "add";
	        $(".fontTitle").html("新增流程配置信息");
	    } 
	    comtop.UI.scan();
	}
	
	function isExist(processId){
		var flag = true;
		if(flagId == processId)
			return true;
		if(data){
			dwr.TOPEngine.setAsync(false);
			ProcessConfigAction.isExistProcessConfigId(processId,function(data){
				if(data == 1){
					flag = false;
				}else{
					flag = true;
				}
			});
			dwr.TOPEngine.setAsync(true);
		}
		return flag;
	}
	
	function save(){	
		  //验证消息
	    var map = window.validater.validAllElement();
	    var inValid = map[0];
	    if (inValid.length ==0){    
	 	var vo = cui(data).databind().getValue();
	 	vo.oldprocessId = flagId; 
	 	ProcessConfigAction.saveProcessConfig(flagId,vo,function(iProcessId){
	    	if(flagId){
	    		window.parent.cui.message('修改流程配置成功。', 'success');
	    		window.parent.addCallBack(saveType,iProcessId);
	    		window.parent.dialog.hide();   
	    	}else{
	    		window.parent.cui.message('添加流程配置成功。', 'success');
				window.parent.addCallBack(saveType,iProcessId);
				window.parent.dialog.hide();
	    	}
	    });
	   	}
	}

</script>
</body>
</html>