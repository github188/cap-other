<!doctype html>
<%
  /**********************************************************************
	* 公告基本信息编辑
	* 2015-9-25 CAP 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<html>
<head>
<title>公告基本信息编辑</title>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.all.js" />
	<top:link href="/cap/bm/common/styledefine/css/top_base.css" />
	<top:link href="/cap/bm/common/styledefine/css/top_sys.css" />
	<top:link href="/cap/bm/common/styledefine/css/public.css"/>
	<top:link href="/cap/bm/common/cui/themes/smartGrid/css/comtop.ui.min.css"/>
	<top:link href="/cap/bm/common/styledefine/editstyle.css"/>
</head>
<style>
	.form_table .divTitle{
		position:relative;
		background: url("<c:out value='${pageScope.cuiWebRoot}'/>/cap/bm/common/styledefine/images/title.png") 0 3px no-repeat;
		padding: 2px 5px 8px 15px;
	}
</style>
<body class="top_body">
	<div class="top_header_wrap" style="text-align: center;">
		<div class="thw_title">公告基本信息编辑</div>
			<div style="float:right">
			<span uitype="button" id="btnSave" icon="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/smartGrid/images/button/save_white.gif" on_click="btnSave" hide="false" button_type="blue-button" disable="false" label="保存"></span> 
			<span uitype="button" on_click="btnBack" id="btnBack" icon="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/smartGrid/images/button/back_white.gif" hide="false" button_type="blue-button" disable="false" label="返回"></span> 
		</div>
	</div>
	<div id="editDiv"  class="top_content_wrap">
		<table class="form_table" style="table-layout:fixed;">
			<colgroup>
				<col width="20%" />
				<col width="80%" />
				<!-- <col width="16%" />
				<col width="34%" /> -->
			</colgroup>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">公告标题<span class="top_required">*</span>：</span></td>
					<td>
						<span uitype="Input" id="title" maxlength="200" byte="true" textmode="false" maskoptions="{}" align="left" width="85%" databind="CapPtcNotice.title" type="text" readonly="false" validate="validateForTitle"></span>
					</td>					
					<%--<td class="td_label"><span style="padding-left: 10px;">公告类型<span class="top_required">*</span>：</span></td>
					<td>
						<span uitype="PullDown" select="-1" width="85%" label_field="text" value_field="id" must_exist="true" validate="[{'type':'required', 'rule':{'m': '公告类型不能为空！'}}]" editable="true" mode="Single" empty_text="请选择" id="type" height="200" auto_complete="false" filter_fields="[]" databind="CapPtcNotice.type" readonly="false" datasource="typeData"</span>
					</td> --%>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">公告内容：</span></td>
					<td>
						<span uitype="Editor" id="noticeContent" min_frame_height="320" width="95%" word_count="true" textmode="false" word_count="true" databind="CapPtcNotice.content" toolbars="[]" focus="true" readonly="false"></span>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.editor.all.js"/>
	<top:script src="/cap/bm/common/cui/js/uedit/dialogs/capattachment/capAttachmentDialog.js"/>
	<top:script src="/cap/bm/common/cui/js/cui.extend.dictionary.js" /> 
	<top:script src="/top/js/jquery.js" />
	<top:script src="/cap/bm/common/js/cap.bm.common.js" />
	<top:script src="/cap/dwr/engine.js" />
	<top:script src="/cap/dwr/util.js" /> 
	<top:script src="/cap/dwr/interface/CapPtcNoticeAction.js" />

<script language="javascript"> 
	var CapPtcNoticeId = "${param.CapPtcNoticeId}";
	var isView=false;
	var CapPtcNotice = {};
	var fromPage = "${param.fromPage}";
	if("${param.isView}"){
		isView = "${param.isView}";
	}
	var typeData = [
	             {id:'item1',text:'选项1'},
	             {id:'item2',text:'选项2'},
	             {id:'item3',text:'选项3'},
	             {id:'item4',text:'选项4'},
	             {id:'item5',text:'选项5'},
	             {id:'item6',text:'选项6'},
	             {id:'item7',text:'选项7'},
	             {id:'item8',text:'选项8'}
	         ];
	var validateForTitle=[{
        type: 'required',
        rule: {
            m: '公告标题不能为空'
        }

    },{'type':'custom','rule':{'against':isBlank, 'm':'公告标题不能为空'}}];
   	window.onload = function(){
   		init();
   	}
   	
	function init() {
		if(CapPtcNoticeId != "") {
			dwr.TOPEngine.setAsync(false);
			CapPtcNoticeAction.queryCapPtcNoticeById(CapPtcNoticeId,function(bResult){
				CapPtcNotice = bResult;
			});
			dwr.TOPEngine.setAsync(true);
		}
		if (typeof(myBeforeInit) == "function") {
			eval("myBeforeInit()");
		}

		comtop.UI.scan();
		cui("#content").set("width", (document.documentElement.clientWidth || document.body.clientWidth) - 280);
		if(isView){
			cui("#title").setReadonly(true);
			cui("#type").setReadonly(true);
			cui("#noticeContent").setReadonly(true);
			cui("#btnSave").hide();
		}
		var isHideAddNewContinueBtn = true;
		if(CapPtcNoticeId=="" || CapPtcNoticeId==null){
			isHideAddNewContinueBtn = false;
		}
		setAddNewContinueBtnIsHide(isHideAddNewContinueBtn);
		if (typeof(afterInit) == "function") {
			eval("afterInit()");
		}
		
		if (typeof(myAfterInit) == "function") {
			eval("myAfterInit()");
		}
	}
	
	function setAddNewContinueBtnIsHide(isHide){
		if(cui("#btnAddNewContinue")!=null){
			if(isHide==true){
				cui("#btnAddNewContinue").hide();
			}else{
				cui("#btnAddNewContinue").show();
			}
			
		}
	}
	
	function btnAddNewContinue(){
		var saveSuccess = btnSave(false);
		if(saveSuccess){
			window.parent.cui.success('新增成功。',function(){
 	 			window.location.reload();
 	 		});
		}
	}
	
	function saveNoBack(){
		var saveSuccess = btnSave(false);
		if(saveSuccess){
			window.parent.cui.message('修改成功。','success');
		}
	}
	
	function btnSave(isBack) {
		var str = "";
		if(window.validater){
			window.validater.notValidReadOnly = true;
			var map = window.validater.validAllElement();
			var inValid = map[0];
			var valid = map[1];
			//验证消息
			if(inValid.length > 0) { //验证失败
				for(var i=0; i<inValid.length; i++) {
					str += inValid[i].message + "<br/>";
				}
			}
			if(str != ""){
				return false;
			}
		}
	
		if (typeof(beforeSave) == "function") {
			eval("beforeSave()");
        }
        
		var result = true;
		if (typeof(myBeforeSave) == "function") {
			result = eval("myBeforeSave()");
        }
        if(!result && typeof(result) != "undefined"){
        	return;
        }
		dwr.TOPEngine.setAsync(false);
		CapPtcNoticeAction.saveCapPtcNotice(CapPtcNotice, function(bResult){
 			//保存数据
 			if(bResult && isBack) {
 				if(CapPtcNotice.id && CapPtcNotice.id != "") {
 					window.opener.cui.message('修改成功。','success');
 				} else {
 					CapPtcNotice.id = bResult;
 	 				window.opener.cui.message('新增成功。','success');
 				}
 			}
 			CapPtcNotice.id = bResult;
 			window.opener.fresh(bResult);
 			window.close();
		});
		dwr.TOPEngine.setAsync(true);

		if (typeof(myAfterSave) == "function") {
			eval("myAfterSave()");
        }
        // 保存成功
		return true;
	}
	

	
		//保存前处理事件
	function beforeSave() {
		alertMessage = "";
		if(!CapPtcNotice.creatorId){
			CapPtcNotice.creatorId = globalCapEmployeeId;
			CapPtcNotice.creatorName=globalCapEmployeeName;
		}
		if(CapPtcNotice.id == "" || CapPtcNotice.id==null){
			CapPtcNotice.cdt=new Date();
		}
	}

	//初始化后处理事件，回显操作
  	function afterInit(){
  	}
	
	//空格过滤
	function isBlank(data){
		if(data.replace("&nbsp", " ")==" "){
			return false;
		}
		return true;
	}
	
	function btnBack() {
		window.close();
	}
</script>
</body>
</html>