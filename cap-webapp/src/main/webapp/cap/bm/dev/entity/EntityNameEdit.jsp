<%
/**********************************************************************
* 实体名称编辑
* 2015-11-20 章尊志 新建
* 2016-5-13 林玉千 添加实体别名
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html ng-app='pageInfoEdit'>
<head>
	<title>页面模板分类选择页面</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:link href="/cap/bm/common/base/css/base.css"></top:link>
	<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src="/cap/dwr/interface/EntityFacade.js"></top:script>
</head>
<style>
	.top_header_wrap{
		padding-right:5px;
	}
</style>
<body>
<div uitype="Borderlayout"  id="body" is_root="true">	
	<div class="top_header_wrap" style="padding:5px 30px 5px 25px">
		<div class="thw_operate" style="float:right;height: 20px;">
			<span uitype="button" id="saveName" label="确定"  on_click="saveName" ></span>
			<span uitype="button" id="close" label="关闭"  on_click="close" ></span>
		</div>
	</div>
		<div class="cap-area" style="width:100%;padding:25px 0px 20px 0px">
		<table class="cap-table-fullWidth" id="tableId">
			<colgroup>
				<col width="27%" />
				<col width="73%" />
			</colgroup>
			<tr>
				<td class="cap-td" style="text-align: right;"><font color="red">*</font>实体名称：</td>
				<td class="cap-td" style="text-align: left;">
				<span uitype="input" id="engName" name="engName" databind="data.engName" maxlength="28" width="290px"
	               validate="validateEntityName" readonly="false" emptytext="请录入实体名称，无需带VO"  ></span>
				</td>
			</tr>
			<tr>
				<td class="cap-td" style="text-align: right;"><font color="red">*</font>中文名称：</td>
				<td class="cap-td" style="text-align: left;">
				<span uitype="input" id="chName" name="chName" databind="data.chName" maxlength="28" width="290px"
	               validate="validateEntityChName" readonly="false"></span>
				</td>
			</tr>
			<tr>
				<td class="cap-td" style="text-align: right;"><font color="red">*</font>实体别名：</td>
				<td class="cap-td" style="text-align: left;">
				<span uitype="input" id="aliasName" name="aliasName" databind="data.aliasName" maxlength="28" width="290px"
	               validate="validateEntityAliasName" readonly="false"></span>
				</td>
			</tr>
			<tr id="trId" style="display:none;">
				<td class="cap-td" style="text-align: right;"><font style="font-size:12px;color:#39c;">温馨提示：</font></td>
				<td class="cap-td" style="text-align: left;">
					<span id="message" style="font-size:12px;"></span>
				</td>
			</tr>
			
		</table>
	</div>
</div>
	<script type="text/javascript">
	   var openType = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("openType"))%>;//listToMain
	   var modelId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
	   var packageId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
	   //新增的实体类型
	   var entityType = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("entityType"))%>;
	   //实体来源
	   var entitySource = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("entitySource"))%>;
	   //系统目录树的，应用模块编码
	   var moduleCode = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("moduleCode"))%>;
	   var entityVO;
	   var modelPackage="";
	//页面渲染
	jQuery(document).ready(function(){
		//根据包Id查询新建实体的基本信息
		setNewEntityInfo(packageId);
	    comtop.UI.scan();
	    //设置提示信息
	    setMessageInfo();
	    
	    $("#engName").change( function() {
	    	setAliasName();
    	});
	});
	
	
	//根据包Id查询新建实体的基本信息
	function setNewEntityInfo(packageId){
		dwr.TOPEngine.setAsync(false);
		   EntityFacade.loadEntity("",packageId,function(entity){
			   entityVO = entity;
			   entityVO.createrId = globalCapEmployeeId;
			   entityVO.createrName = globalCapEmployeeName;
			   entityVO.entityType = entityType;
			   entityVO.packageId = packageId;
			   modelPackage=entity.modelPackage;
		   });
		dwr.TOPEngine.setAsync(true);
	}
	//设置提示信息
	function setMessageInfo(){
		if(entityType == 'query_entity' && entitySource == 'exist_entity_input'){
			$('#trId').attr("style","display:''");
		    $("#message").html("<font style='color:#39c'>本地须存在一套完整的VO、AppService、Facade代码。</font>");
	    }else if(entityType == 'data_entity' && entitySource == 'exist_entity_input'){
	    	$('#trId').attr("style","display:''");
		    $("#message").html("<font style='color:#39c'>本地model包下须存在VO类。</font>");
	    }else {
	    	$("#message").html("");
	    }
	}
	
	//保存模板
	function saveName(){
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
			var engName = cui("#engName").getValue();
			var chName = cui("#chName").getValue();
			var aliasName = cui("#aliasName").getValue();
			entityVO.engName=engName;
			entityVO.chName=chName;
			entityVO.aliasName=aliasName;
			entityVO.entityType=entityType;
			entityVO.packageId=packageId;
			entityVO.entitySource=entitySource;
			//如果实体类型是录入已有实体，则需要验证实体是否存在
			if(entitySource == "exist_entity_input"){
			    dwr.TOPEngine.setAsync(false);
				   EntityFacade.checkExistEntityByInvoke(entityVO,function(result){
					  if(result){
						  window.parent.saveEntityNameCallBack(entityVO,openType,moduleCode);
					  }else{
						  cui.alert("所录入的实体不存在或者实体相关信息不完整!");
					  }
				   });
				dwr.TOPEngine.setAsync(true);
			}else{
				window.parent.saveEntityNameCallBack(entityVO,openType,moduleCode);
			}
		}
	}
	
	//关闭窗口
	function close(){
		window.parent.closeEntityNameWindow();
	}
	
		 	//实体名称检测
		var validateEntityName = [
		      {'type':'required','rule':{'m':'实体名称不能为空。'}},
		      {'type':'custom','rule':{'against':checkEntityNameChar, 'm':'必须为英文字符、数字或者下划线，且必须以大写英文字符开头。'}},
		      {'type':'custom','rule':{'against':checkEntityNameIsExist, 'm':'实体名称已经存在。'}}
		    ];
		//实体名称检测
		var validateEntityChName = [
		      {'type':'required','rule':{'m':'实体中文名称不能为空。'}},
		      {'type':'custom','rule':{'against':checkEntityChNameIsExist, 'm':'实体中文名称已经存在。'}}
		    ];
		//实体别名检测
		var validateEntityAliasName = [
				{'type':'required','rule':{'m':'实体别名不能为空。'}},
				{'type':'custom','rule':{'against':checkEntityAliasNameChar, 'm':'必须为英文字符、数字或者下划线，且必须以小写英文字符开头。'}},
				{'type':'custom','rule':{'against':checkEntityAliasNameIsExist, 'm':'实体别名已经存在。'}}
		    ];
	    data={};
		
		//校验实体名称字符
	  	function checkEntityNameChar(data) {
	  		var regEx = "^([A-Z])[a-zA-Z0-9_]*$";
	  		if(data){
				var reg = new RegExp(regEx);
				return (reg.test(data));
			}
			return true;
	  	}
	  //校验实体名称字符
	  	function checkEntityAliasNameChar(data) {
	  		var regEx = "^([a-z])[a-zA-Z0-9_]*$";
	  		if(data){
				var reg = new RegExp(regEx);
				return (reg.test(data));
			}
			return true;
	  	}
		
	  	//检验实体名称是否存在
	  	function checkEntityNameIsExist(engName) {
	  		var flag = true;
	  		dwr.TOPEngine.setAsync(false);
			EntityFacade.isExistSameNameEntity(modelPackage,engName,modelId,function(bResult){
				flag = !bResult;
			});
			dwr.TOPEngine.setAsync(true);
			return flag;
	  	}
	  	
	  	//检验实体中文名称是否存在
	  	function checkEntityChNameIsExist(chName) {
	  		var flag = true;
	  		dwr.TOPEngine.setAsync(false);
			EntityFacade.isExistSameChNameEntity(modelPackage,chName,modelId,function(bResult){
				flag = !bResult;
			});
			dwr.TOPEngine.setAsync(true);
			return flag;
	  	}
	  	
	  	//检验实体别名是否存在
	  	function checkEntityAliasNameIsExist(aliasName){
	  		var flag = true;
	  		dwr.TOPEngine.setAsync(false);
			EntityFacade.isExistSameAliasNameEntity(aliasName,modelId,function(bResult){
				flag = !bResult;
			});
			dwr.TOPEngine.setAsync(true);
			return flag;
	  	}
	  	
	  	function setAliasName(){
	  		var engName = cui("#engName").getValue();
	  		if(engName!=''){
		  		cui("#aliasName").setValue(engName.substring(0,1).toLowerCase() + engName.substring(1));
	  		}
	  	}

	</script>
</body>
</html>