<%
/**********************************************************************
* 常见意见编辑界面
* 2016-4-12 许畅 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>常用意见编辑</title>
    <top:link href="/cap/rt/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:link href="/cap/rt/common/base/css/base.css"></top:link>
    <top:link href="/cap/rt/common/base/css/comtop.cap.rt.css"/>
    <style type="text/css">
	   #processSelect{
	     margin-bottom: 8%;
	   }
	   textarea{
	     height: 100px;
		 width: 100%;
	   }
	   .cap-page{
	     padding-top: 5px;
	   }
    </style>
	 
	<top:script src="/cap/rt/common/base/js/jquery.js"></top:script>
	<top:script src="/cap/rt/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src="/cap/rt/common/base/js/comtop.cap.rt.js"></top:script>
	<top:script src="/cap/rt/common/cui/js/cui.utils.js"></top:script>
    
	<top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src='/cap/dwr/interface/CommonOpinionFacade.js'></top:script>
</head>
<body style="background-color:#f5f5f5;" >
<div class="cap-page">
	<div class="cap-area" style="width:100%;">
	  <div class="cui-tab-head" style="margin: 0px;font-size:11pt">
        	<table style="width:100%;border-spacing: 0px">
        		<tr>
        		    <td style="text-align:left;"></td>
        			<td style="text-align:right;padding-right:0px">
        				<span id="save" uitype="Button" label="常用意见保存" icon="file-text-o" onclick="save()"></span>
			        	<span id="return" uitype="Button" label="返回" onclick="back()"></span>
        			</td>
        		</tr>
        	</table>
        </div>
	
		<table class="cap-table-fullWidth">
		    <tr>
		        <td>
		            <!-- 意见添加 --> 
		        	<table class="cap-table-fullWidth" id="processSelect">
		        	
		        	    <tr> 
					        <td class="cap-td" style="text-align: left;width:100px" width="30%" id="processLabel">
								<span id="formTitle" uitype="Label" value="常用意见:" class="cap-label-title" size="12pt"></span>
					        </td>
					    </tr>
					    
					    <tr>
					        <td class="cap-td" style="text-align: left;" width="70%">
					        	<div class="cui_textarea_box">
					        	  <textarea class="textarea_textarea" id="opinion" ></textarea>
					        	</div>
					        </td>
					    </tr>
					    
					</table>
					
		        </td>
		    </tr>
		</table>
		
	</div>
</div>

<script type="text/javascript">
    //单据id
    var workId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("primaryValue"))%>;
    //员工id
	var personId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("personId"))%>;
	
	//常用意见主键id
	var modelId =<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))   %>
	
	var page={};
	
	//页面初始化
	$(function(){
		comtop.UI.scan();
		//界面初始化
		if(modelId){
			dwr.TOPEngine.setAsync(false);
			CommonOpinionFacade.loadData(modelId, function(data) {
				page=data;
				$("#opinion").attr("value",page["opinion"]);
			});
			dwr.TOPEngine.setAsync(true);
		}
	});
	//返回
   function back(){
	   var attr="primaryValue="+workId+"&personId="+personId;
	   window.location.href="CommonOpinionList.jsp?"+attr;	   
   }
	
	//保存
	function save(){
		var opinion=$("#opinion").val();
		if(!opinion){
			cui.alert("常用意见不能为空,请填写内容");
			return;
		}
		page.opinion=opinion;
		page.personId='${param.personId}'=="null" ?"" : '${param.personId}' ;
		page.workId='${param.primaryValue}' == "null" ? "" : '${param.primaryValue}';
	    //校验必填项
	    
		dwr.TOPEngine.setAsync(false);
		CommonOpinionFacade.saveAction(page, function(modelId) {
			if (modelId) {
				cui.message('常用意见保存成功.', 'success');
				var attr="primaryValue="+workId+"&personId="+personId;
				window.location.href="CommonOpinionList.jsp?"+attr;	   
			} else {
				cui.alert("常用意见内容重复,保存失败.");
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	function isNotEmpty(obj) {
		return obj != null && obj != "" && obj != "undefined"
	}
	
</script>
</body>
</html>