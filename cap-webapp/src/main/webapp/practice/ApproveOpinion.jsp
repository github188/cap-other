<%
/**********************************************************************
* 审批意见
* 2016-03-30 杜祺  新建
* 2016-04-25 许畅  修改
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/rt/common/workflow/flowmanage/AttachManager.jsp" %>
<head>
  <top:script src='/cap/dwr/interface/CommonOpinionFacade.js'></top:script>
</head>

<div class="pannel-title">审批意见</div>
<div class="panel-content" id="fillContent"></div>
<script type="text/html" id="template">
    <table class="cap-table-fullWidth">
	{{
		for(var i=0; i < displayData.length; i++){
			var dataItem = displayData[i];
			var status = dataItem.status;
			var hideBackButton = dataItem.hideBackButton;
			var hideCountersignButton = dataItem.hideCountersignButton;
			if(status == 1){
	}}
        <tr class="row">

		    <td width="20%">
				<div class="col-title">
					<span class="col-image-light-blue"></span>
					<span class="col-title-text">{{= dataItem.nodeName}}</span>
				</div>
			</td>
			<td width="80%" class="col-second-td">
				<div class="col-content">
					<div class="col-content-text">{{= dataItem.msg}}</div>
					<div style="height:35px;">
						{{ 
							if(dataItem.showUndo){
						}}
						<span id="cancelBack" uitype="Button" label="撤回" style="float:left;" on_click="approveUndoData"></span>
						{{ 
							}
						}}
						<span style="float:right;">
							<span style="font-weight:bold;">处理时间:</span>&nbsp;{{= dataItem.overTime}}
						</span>
						<span style="float:right;margin-right:5px;">
							<span style="font-weight:bold;">处理人:</span>&nbsp;{{= dataItem.userName}}；&nbsp;
						</span>
					</div>

	                <!-- 已办附件上传   // -->
	                <div class="col-done-attach">
						<attach id="atm_done_div_{{= i }}" uitype="AtmSep" hrefName ="附件上传" operateMode ="10" jobTypeCode ="attachment" creatorId="{{= dataItem.userId}}" creatorName="{{= dataItem.userName}}" title="附件列表" atmAttr="atmAttr"
						  operationRight ="no" displayMode ="1" showFields="download" objId ="{{= dataItem.nodeTrackId + dataItem.userId }}" dwrUrl ="${cuiWebRoot}/cap/dwr" frameHeight ="50" valign="middle" align="left" hiddenId="{{= dataItem.nodeTrackId }}" icon="${cuiWebRoot}/practice/image/download.png" 
						  style="border-right-style:none;border-left-style:none;border-top-style:none;border-bottom-style:none" >
						</attach>
	                </div> 

				</div>
			</td>
			
        </tr>
	{{	
			}else if(status == 2){
				var fontColor = "";
				if(dataItem.msg == ""){
					dataItem.msg = ApprovePageConstants.OPTION_TIP;
					fontColor = "color:grey;";
				}
	}}
	<tr class="row-todo">
		
		<td width="20%" >
			<div class="col-title-todo">
				<span class="col-image-dark-blue"></span>
				<span class="col-title-text">{{= dataItem.nodeName}}</span>
			</div>
		</td>	
		<td width="80%" class="col-second-td">
			<div class="col-content-todo">
			    <div class="col-todo-commonOpinion">
			      <div class="left-col">
			         <span class="col-content-todo-text">{{= dataItem.userName}}</span>
			      </div>

			      <div class="right-col">
				      <a class="opinion-tip">常用审批语:</a>  <span id="commonOpinion" uitype="PullDown" mode="Single" value_field="id" label_field="text" datasource="initOpinion"></span>
				      <span uitype="Button" label="确定" on_click="sureAction"></span>
			      </div>
			    </div>
				
				<span width="100%" height="100px">
					<div class="textarea_textarea_wrap" style="width: 100%;">
						<div class="cui_textarea_box">
							<div class="cui_textarea_empty"></div>
							<textarea id="opnionTextarea" class="textarea_textarea" style="height: 90px;{{= fontColor}}"
								maxlength="2000" onblur="opnionTextareaBlur()" onfocus="opnionTextareaFocus()">{{= dataItem.msg}}</textarea>
						</div>
					</div>
				</span>

                <!-- 待办附件上传  // -->
                <div class="col-todo-attach">
					<attach id="atm_todo_div" uitype="AtmSep" hrefName ="附件上传" operateMode ="10" jobTypeCode ="attachment" creatorId="{{= dataItem.userId}}"  creatorName="{{= dataItem.userName}}" title="附件列表" atmAttr="atmAttr"
					  operationRight ="*" displayMode ="1" objId ="{{= dataItem.nodeTrackId + dataItem.userId }}" dwrUrl ="${cuiWebRoot}/cap/dwr" frameHeight ="50" valign="middle" align="left" hiddenId="{{= dataItem.nodeTrackId }}"  icon="${cuiWebRoot}/practice/image/download.png" showFields="download;delete" style="border-right-style:none;border-left-style:none;border-top-style:none;border-bottom-style:none" >
					</attach>
                </div> 

				<div class="col-content-todo-oper">
				   
                    <!-- 
                    <span uitype="Button" label="另存为常用意见" class="todo-last-button" on_click="saveCommonOpinion"></span>
                    <span uitype="Button" label="常用意见" class="todo-button" on_click="openCommonOpinion"></span>
                    // -->
                    
                    <span uitype="Button" label="保存意见" class="todo-last-button" on_click="saveOpinion"></span>
					{{ if(!hideBackButton){ }}
					<span uitype="Button" label="回退申请人" class="todo-button" on_click="approveBackReport"></span>
					<span uitype="Button" label="回退" class="todo-button" on_click="approveBackData"></span>
					{{ } }}
					<span uitype="Button" label="发送" class="todo-button" on_click="approveSendData"></span>
					{{ if(!hideCountersignButton){ }}
					<input uitype="Menu" trigger="click" datasource="approveReassignMenuData" type="button" 
						on_click="approveReassignData" class="countersign-button" value="增加会签人"/>
					{{ } }}
				</div>
	            
			</div>
		</td>	
		
	</tr>	
	{{	
			}else{
				var fontColor = status == 3 ? "color:red;" : "color:grey;";
	}}
	<tr class="row">
		
		<td width="20%">
			<div class="col-title">
				<span class="col-image-grey"></span>
				<span class="col-title-text">{{= dataItem.nodeName}}</span>
			</div>
		</td>	
		<td width="80%" class="col-second-td">
			<div class="col-content">
				<span style="{{= fontColor}}">{{= dataItem.userName}}</span>

	           <!-- 待办以下  // -->
	           <div class="col-content-attach"> 
					<attach id="atm_content_div_{{= i }}" uitype="AtmSep" hrefName ="附件上传" operateMode ="10" jobTypeCode ="attachment" creatorId="{{= dataItem.userId}}" creatorName="{{= dataItem.userName}}" title="附件列表" atmAttr="atmAttr"
					  operationRight ="no" displayMode ="1" showFields="download" objId ="{{= dataItem.nodeTrackId + dataItem.userId }}" dwrUrl ="${cuiWebRoot}/cap/dwr" frameHeight ="50" valign="middle" align="left" hiddenId="{{= dataItem.nodeTrackId }}" icon="${cuiWebRoot}/practice/image/download.png" 
					  style="border-right-style:none;border-left-style:none;border-top-style:none;border-bottom-style:none">
					</attach>
	           </div>  
			</div>

		</td>	
		
	</tr>	
	{{
			}
		}
    }}

    </table>
</script>

<script type="text/javascript">
	//流程实例id
	var processInsId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("processInsId"))%>;
	var processId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("processId"))%>;
	var viewType = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("viewType"))%>;
	
	var approveReassignMenuData=[{id:'item1',label:'提交后返回本人'},
	                             {id:'item2',label:'提交后不返回本人'}];
	
	//另存为常用意见
	function saveCommonOpinion() {
		
		if(!valiadateApproveOpnion())
			return;
		
		var opinion = {
			opinion: $("#opnionTextarea").val(),
			personId: globalUserId,
			workId: '${param.primaryValue}'
		};
		dwr.TOPEngine.setAsync(false);
		CommonOpinionFacade.saveAction(opinion, function(modelId) {
			if (modelId) {
				cui.message('常用意见另存成功.', 'success');
			}else{
				cui.alert("常用意见内容重复,请重新填写内容.");
			}
		});
		dwr.TOPEngine.setAsync(true);
	}

    //初始化常用意见下拉数据源
    var initOpinion = [];
     
     //常用意见确定
     function sureAction(){
     	var commonOpinion=cui("#commonOpinion").getText();
     	if(!commonOpinion){
     		cui.alert("常用意见为空,请选择常用意见.");
     	}

     	$("#opnionTextarea").attr("value",commonOpinion);
     	$("#opnionTextarea").css("color","black");
     }

	//打开常用意见
	function openCommonOpinion() {
		var url = '${cuiWebRoot}/cap/rt/common/workflow/flowmanage/CommonOpinionList.jsp?primaryValue=${param.primaryValue}&personId=' + globalUserId;

		var width = 800; //窗口宽度
		var height = 400; //窗口高度
		var top = (window.screen.height - 30 - 500) / 2;
		var left = (window.screen.width - 10 - width) / 2;
		window.open(url, "_blank", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width=" + width + " ,Height=" + height + ",top=" + top + ",left=" + left);
	}
	
	//常用意见回调
	function commonOpinionCallback(rowData){
		$("#opnionTextarea").attr("value",rowData["opinion"]);
	}
		
</script>