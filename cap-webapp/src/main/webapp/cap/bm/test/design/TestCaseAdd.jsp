<%
/**********************************************************************
* 测试用例基本信息编辑
* 2016-06-29 李小芬  新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>测试用例编辑</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:link href="/cap/bm/common/base/css/base.css"></top:link>
	<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
    <top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src="/cap/dwr/interface/TestCaseFacade.js"></top:script>
</head>
<style>
	.top_header_wrap{
		padding-right:5px;
	}
</style>
<body>
<div uitype="Borderlayout"  id="body" is_root="true">	
	<div class="top_header_wrap" style="padding:10px 30px 10px 25px">
		<div class="thw_operate" style="float:right;height: 28px;">
			<span uitype="button" id="saveTestCase" label="保存"  on_click="saveTestCase" ></span>
			<span uitype="button" id="close" label="关闭"  on_click="close" ></span>
		</div>
	</div>
		<div class="cap-area" style="width:100%;padding:25px 0px 20px 0px">
		<table class="cap-table-fullWidth">
			<colgroup>
				<col width="27%" />
				<col width="73%" />
			</colgroup>
			<tr>
				<td class="cap-td" style="text-align: right;"><font color="red">*</font>用例中文名称：</td>
				<td class="cap-td" style="text-align: left;">
				<span uitype="input" id="name" name="name" databind="data.name" maxlength="50" width="93%"
	               validate="validateName" readonly="false"></span>
				</td>
			</tr>
			<tr>
				<td class="cap-td" style="text-align: right;"><font color="red">*</font>用例英文名称：</td>
				<td class="cap-td" style="text-align: left;">
				<span uitype="input" id="modelName" name="modelName" databind="data.modelName" maxlength="50" width="93%"
	               validate="validateEngName" readonly="false"></span>
				</td>
			</tr>
			<tr>
				<td class="cap-td" style="text-align: right;"><font color="red">*</font>用例类型：</td>
				<td class="cap-td" style="text-align: left;">
	               <span id="type" uitype="PullDown" value_field="id" label_field="text" select=0
	               		databind="data.type" width="93%" datasource="testCaseType" on_change="changeTestCaseType"></span>
				</td>
			</tr>
			<!-- 
			<tr id="pageAction_div" style="display: none;">
				<td class="cap-td" style="text-align: right;">界面行为：</td>
				<td class="cap-td" style="text-align: left;">
	               <span uitype="ClickInput" id="pageActionId" width="93%" on_iconclick="selPageAction"></span>
				</td>
			</tr>
			<tr id="entityMethod_div" style="display: none;">
				<td class="cap-td" style="text-align: right;">实体方法：</td>
				<td class="cap-td" style="text-align: left;">
	               <span uitype="ClickInput" id="entityMethodId" width="93%" on_iconclick="selEntityMethod"></span>
				</td>
			</tr>
			<tr id="serviceMethod_div" style="display: none;">
				<td class="cap-td" style="text-align: right;">服务方法：</td>
				<td class="cap-td" style="text-align: left;">
	               <span uitype="ClickInput" id="serviceMethodId" width="93%" on_iconclick="selServiceMethod"></span>
				</td>
			</tr> -->
			<tr>
				<td class="cap-td" style="text-align: right;">测试场景：</td>
				<td class="cap-td" style="text-align: left;">
				<span uitype="Textarea" id="scene" name="scene" databind="data.scene" maxlength="100" 
					  width="93%" height="100px" readonly="false"></span>
				</td>
			</tr>
			<tr id="desc_div" style="display: none;">
				<td class="cap-td" style="text-align: right;">用例描述：</td>
				<td class="cap-td" style="text-align: left;">
				<span uitype="Textarea" id="description" name="description" databind="data.description" maxlength="100" 
					  width="93%" height="100px" readonly="false"></span>
				</td>
			</tr>
		</table>
	</div>
</div>
	<script type="text/javascript">
	   var packageId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
	   var moduleCode = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("moduleCode"))%>;
	   var data={};
	   var metadata;
	   
	   var testCaseType = [
	               		{id:'FUNCTION',text:'界面功能'},
	               		{id:'API',text:'后台API'},
	               		{id:'SERVICE',text:'业务服务'}
	    ]
	   
	  //页面渲染
	  jQuery(document).ready(function(){
	       comtop.UI.scan();
	       cui("#pageAction_div").show();
	  });
	   
	 //切换用例类型 
		  function changeTestCaseType(v){
			  if(v.id === "FUNCTION"){
				  cui("#pageAction_div").show();
				  cui("#entityMethod_div").hide();
				  cui("#serviceMethod_div").hide();
			  }else if(v.id === "API"){
				  cui("#pageAction_div").hide();
				  cui("#entityMethod_div").show();
				  cui("#serviceMethod_div").hide();
			  }else if(v.id === "SERVICE"){
				  cui("#pageAction_div").hide();
				  cui("#entityMethod_div").hide();
				  cui("#serviceMethod_div").show();
			  }
		  }
	 
		  //选择界面行为
		  var dialog;
		  function selPageAction(){
			  	var url = "SelPageActionMain.jsp?packageId=" + packageId;
				var title="界面行为选择";
				var height = 520; 
				var width =  680; 
				dialog = cui.dialog({
					title : title,
					src : url,
					width : width,
					height : height
				})
				dialog.show(url);
		  }
		//选择实体方法
		  function selEntityMethod(){
			  	var url = "SelEntityMethodMain.jsp?packageId=" + packageId;
				var title="实体方法选择";
				var height = 520; 
				var width =  680; 
				dialog = cui.dialog({
					title : title,
					src : url,
					width : width,
					height : height
				})
				dialog.show(url);
		  }
		//选择服务方法
		  function selServiceMethod(){
			    var url = "SelServiceMethodMain.jsp?packageId=" + packageId;
				var title="服务方法选择";
				var height = 520; 
				var width =  680; 
				dialog = cui.dialog({
					title : title,
					src : url,
					width : width,
					height : height
				})
				dialog.show(url);
		  }
		  
			//界面行为选择回调
			// objArgMap.put("pageActionId", "pageModelId:actionid:actiontype");
		 function selPageActionBack(selectData,pageModelId) {
			var actionModelId = selectData[0].actionDefineVO.modelId;
			var actionId = selectData[0].pageActionId;
			var actionType = selectData[0].methodOption.actionType;
			metadata = pageModelId + ":" + actionId + ":" + actionType;
			cui("#pageActionId").setValue(actionModelId);
			if(dialog){
					dialog.hide();
			}
		}
			//实体方法回调
		 // objArgMap.put("metadata", "entityId:methodName"); com.comtop.XX:method
		 function selEntityMethodBack(selectData,entityModelId) {
			 var methodName = selectData[0].engName;
			 metadata = entityModelId + ":" +  methodName;
			 cui("#entityMethodId").setValue(methodName);
			 if(dialog){
						dialog.hide();
			 }
			}
		 //服务方法回调
		 function selServiceMethodBack(selectData) {
			 metadata = selectData[0].engName;
			 cui("#serviceMethodId").setValue(metadata);
			 if(dialog){
						dialog.hide();
			 }
			}
	
	//保存
	function saveTestCase(){
		var map = window.validater.validAllElement();
        var inValid = map[0];
        var valid = map[1];
       	//验证消息
		if(inValid.length > 0){//验证失败
			var str = "";
            for (var i = 0; i < inValid.length; i++) {
				str += inValid[i].message + "<br />";
			}
		}else{ 
			data.packageId=packageId;
			data.metadata = metadata;
			window.parent.saveTestCaseCallBack(data,moduleCode);
		}
	}
	
	//关闭窗口
	function close(){
		window.parent.closeTestCaseWindow();
	}
	
	//中文名称检测
	var validateName = [
		      {'type':'required','rule':{'m':'用例中文名称不能为空。'}},
		      {'type':'custom','rule':{'against':checkNameIsExist, 'm':'用例中文名称已经存在。'}}
	];
	
	//名称检测
	var validateEngName = [
		      {'type':'required','rule':{'m':'用例英文名称不能为空。'}},
		      {'type':'custom','rule':{'against':checkNameChar, 'm':'必须为英文字符、数字或者下划线。'}},
		      {'type':'custom','rule':{'against':checkEngNameIsExist, 'm':'用例英文名称已经存在。'}}
	];
	    
	//校验实体名称字符
	function checkNameChar(data) {
	  		var regEx = "^[a-zA-Z0-9_]*$";
	  		if(data){
				var reg = new RegExp(regEx);
				return (reg.test(data));
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

	</script>
</body>
</html>