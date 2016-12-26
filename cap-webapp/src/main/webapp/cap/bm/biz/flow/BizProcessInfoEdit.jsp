<!doctype html>
<%
  /**********************************************************************
	* 业务流程编辑
	* 2015-11-12 CAP 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<html>
<head>
<title>业务流程编辑</title>
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_sys.css" type="text/css">
	<top:link  href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/top/js/jquery.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.editor.min.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/engine.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/util.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/BizProcessInfoAction.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/bm/common/base/js/cap_ui_attachment.js'></script>
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
		<div class="thw_title">业务流程编辑</div>
			<div style="float:right">
			<span uitype="button" hide="false" on_click="btnAddNewContinue" id="btnAddNewContinue" icon="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/smartGrid/images/button/save_white.gif" button_type="blue-button" label="保存并继续" disable="false"></span> 
			<span uitype="button" on_click="btnSave" id="btnSave" icon="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/smartGrid/images/button/save_white.gif" hide="false" button_type="blue-button" disable="false" label="保存"></span> 
			<span uitype="button" on_click="btnBack" id="btnBack" icon="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/smartGrid/images/button/back_white.gif" hide="false" button_type="blue-button" disable="false" label="返回"></span> 
		</div>
	</div>
	<div id="editDiv"  class="top_content_wrap">
		<table class="form_table" style="table-layout:fixed;">
			<colgroup>
				<col width="14%" />
				<col width="36%" />
				<col width="14%" />
				<col width="36%" />
			</colgroup>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">流程ID<span class="top_required">*</span>：</span></td>
					<td>
						<span uitype="Input" id="processId" maxlength="40" byte="true" textmode="false" maskoptions="{}" align="left" width="85%" databind="BizProcessInfo.processId" type="text" readonly="false" validate="processIdValidate"></span>
					</td>
					<td class="td_label"><span style="padding-left: 10px;">流程名称:<span class="top_required">*</span>：</span></td>
					<td>
						<span uitype="Input" id="processName" maxlength="200" byte="true" textmode="false" maskoptions="{}" align="left" width="85%" databind="BizProcessInfo.processName" type="text" readonly="false" validate="[{'type':'required', 'rule':{'m': '流程名称不能为空！'}}]"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">流程编码</td>
					<td>
						<span uitype="Input" id="code" maxlength="125" byte="true" textmode="false" maskoptions="{}" align="left" width="85%" databind="BizProcessInfo.code" type="text" readonly="true"></span>
					</td>
					<td class="td_label"><span style="padding-left: 10px;">流程层级：</span></td>
					<td >	
						<span id="processLevel" uitype="PullDown" mode="Multi" value_field="id" label_field="text" databind="BizProcessInfo.processLevel" width="85%" datasource="initLevelData"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label">管控策略：</td>
					<td><span uitype="PullDown" id="managePolicy" name="managePolicy" databind="BizProcessInfo.managePolicy" width="85%" datasource="managePolicyData"></span></td>
					<td class="td_label">统一规范策略：</td>
					<td><span uitype="PullDown" id="normPolicy" name="normPolicy" databind="BizProcessInfo.normPolicy" width="85%" datasource="normPolicyData"></span></td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">IT实现：</span></td>
					<td>
						<span uitype="Input" id="sysName" maxlength="32" byte="true" textmode="false" maskoptions="{}" align="left" width="85%" databind="BizProcessInfo.sysName" type="text" readonly="false" emptytext="实现的系统名称，如OMS系统"></span>
					</td>
					<td class="td_label"></td>
					<td>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">流程定义：</span></td>
					<td colspan="3">
						<span uitype="Editor" id="processDef" name="processDef" min_frame_height="110" width="95%" word_count="true" textmode="false" word_count="true" databind="BizProcessInfo.processDef" toolbars="toolbars" focus="true" readonly="false"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">工作要求：</span></td>
					<td colspan="3">
						<span uitype="Editor" id="workDemand" name="workDemand" min_frame_height="110" width="95%" word_count="true" textmode="false" word_count="true" databind="BizProcessInfo.workDemand" toolbars="toolbars" focus="true" readonly="false"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">工作内容：</span></td>
					<td colspan="3">
						<span uitype="Editor" id="workContext" name="workContext" min_frame_height="110" width="95%" word_count="true" textmode="false" word_count="true" databind="BizProcessInfo.workContext" toolbars="toolbars" focus="true" readonly="false"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">流程图：</span></td>
					<td colspan="3">
						<span uitype="Editor" id="flowChartId" name="flowChartId" min_frame_height="30" width="95%" word_count="false" databind="BizProcessInfo.flowChartId" toolbars="toolbars" readonly="false"></span>
					</td>
				</tr>
			</tbody>
		</table>
	</div>

<script language="javascript"> 
	var BizProcessInfoId = "<c:out value='${param.BizProcessInfoId}'/>";
	var domainId = "<c:out value='${param.domainId}'/>";
	var selItemsId = "<c:out value='${param.selItemsId}'/>";
	var BizProcessInfo = {};
	var managePolicyData = [
	                    	{id:'负责型+指导型',text:'负责型+指导型'},
	                    	{id:'负责型',text:'负责型'},
	                    	{id:'指导型',text:'指导型'},
	                    	{id:'无',text:'无'}
	                    	]
	var normPolicyData = [
	                    	{id:'全网统一',text:'全网统一'},
	                    	{id:'省内统一',text:'省内统一'},
	                    	{id:'地市局统一',text:'地市局统一'},
	                    	{id:'无',text:'无'}
	                    	]
	
	toolbars=[[
	           'undo', //撤销
	           'redo', //重做
	           'bold', //加粗
	           'indent', //首行缩进
	           'italic', //斜体
	           'underline', //下划线
	           'strikethrough', //删除线
	           'time', //时间
	           'date', //日期
	           'inserttable', //插入表格
	           'insertrow', //前插入行
	           'insertcol', //前插入列
	           'mergeright', //右合并单元格
	           'mergedown', //下合并单元格
	           'deleterow', //删除行
	           'deletecol', //删除列
	           'splittorows', //拆分成行
	           'splittocols', //拆分成列
	           'splittocells', //完全拆分单元格
	           'deletecaption', //删除表格标题
	           'inserttitle', //插入标题
	           'mergecells', //合并多个单元格
	           'deletetable', //删除表格
	           'insertparagraphbeforetable', //"表格前插入行"
	           'fontfamily', //字体
	           'fontsize', //字号
	           'paragraph', //段落格式
	           'edittable', //表格属性
	           'edittd', //单元格属性
	           'link', //超链接
	           'spechars', //特殊字符
	           'justifyleft', //居左对齐
	           'justifyright', //居右对齐
	           'justifycenter', //居中对齐
	           'justifyjustify', //两端对齐
	           'forecolor', //字体颜色
	           'insertimage',//多图上传 
	           'rowspacingtop', //段前距
	           'rowspacingbottom', //段后距
	           'pagebreak', //分页
	           'imagecenter', //居中
	           ]]
	
   	window.onload = function(){
   		init();
   	}
   	
   	var processIdValidate =  [{
	   	 type: 'required',
	     rule: {
	         m: '流程ID不能为空！'
	     	   }
		},
		{
	     type: 'custom',
	     rule: {
	         against:'checkProcessId',
	         m:'流程ID不能重复,请重新输入！'
		       }	
		 },
		 {
			 type:'custom',
			 rule:{against:'notCn', 
			 m:'流程ID不能含中文'}
		 }];
   	
   	//验证不为中文
	function notCn(data){
		if (/[\u4E00-\u9FA5]/i.test(data)){
			return false;
		  }
		return true;
	}
	
   	var initLevelData = [
   	          		{id:'公司总部',text:'公司总部'},
   	          		{id:'分子公司',text:'分子公司'},
   	          		{id:'地市单位',text:'地市单位'},
   	          		{id:'基层单位',text:'基层单位'}
   	          		]
   	
 	//检验processId不能重名
   	function checkProcessId(processId){
   		var Parameter = {};
		Parameter.processId = processId.replace(/(^\s*)|(\s*$)/g, "");
		Parameter.domainId = domainId;
		Parameter.queryId = BizProcessInfoId.replace(/(^\s*)|(\s*$)/g, "");
		var flag = true;
		dwr.TOPEngine.setAsync(false);
		BizProcessInfoAction.queryBizProcessInfoCount(Parameter, function(bResult){
			if(bResult >0) {
				flag = false;
			}
		});
		dwr.TOPEngine.setAsync(true);
		return flag;
   	}

   	function init() {
		if(BizProcessInfoId != "") {
			dwr.TOPEngine.setAsync(false);
			BizProcessInfoAction.queryBizProcessInfoById(BizProcessInfoId,function(bResult){
				BizProcessInfo = bResult;
			});
			dwr.TOPEngine.setAsync(true);
		}
		if (typeof(myBeforeInit) == "function") {
			eval("myBeforeInit()");
		}

		comtop.UI.scan();
		
		var isHideAddNewContinueBtn = true;
		if(BizProcessInfoId=="" || BizProcessInfoId==null){
			isHideAddNewContinueBtn = false;
		}
		setAddNewContinueBtnIsHide(isHideAddNewContinueBtn);
		if (typeof(afterInit) == "function") {
			eval("afterInit()");
		}
		
		if (typeof(myAfterInit) == "function") {
			eval("myAfterInit()");
		}
		
		if("<c:out value='${param.readOnly}'/>" == "true") {
			comtop.UI.scan.setReadonly(true);
			cui("#btnAddNewContinue").hide();
			cui("#btnSave").hide();
			cui("#btnBack").show();
			if (typeof(setReadonlyButton) == "function") {
				eval("setReadonlyButton()");
			}
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
			window.parent.cui.message('新增成功。','success');
 	 		window.location.reload();
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
				cui.alert(str);
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
		BizProcessInfoAction.saveBizProcessInfo(BizProcessInfo, function(bResult){
 			//保存数据
 			if(bResult && isBack) {
 				if(BizProcessInfo.id && BizProcessInfo.id != "") {
 					window.parent.cui.message('修改成功。','success');
 				} else {
 					BizProcessInfo.id = bResult;
 	 				window.parent.cui.message('新增成功。','success');
 				}
	 			setTimeout('btnBack()',1000);
 			}
 			BizProcessInfo.id = bResult;
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
		if(!BizProcessInfo.creatorId){
			BizProcessInfo.creatorId = globalUserId;
		}
		
		BizProcessInfo.processDef = cui("#processDef").getValue();	  
		BizProcessInfo.workDemand = cui("#workDemand").getValue();	  
		BizProcessInfo.workContext = cui("#workContext").getValue();	  
		BizProcessInfo.dataFrom = 0;
		BizProcessInfo.processId = cui("#processId").getValue().replace(/(^\s*)|(\s*$)/g, "");
		BizProcessInfo.processName = cui("#processName").getValue().replace(/(^\s*)|(\s*$)/g, "");
		BizProcessInfo.itemsId = selItemsId;
		BizProcessInfo.domainId = domainId;
	}

	//初始化后处理事件，回显操作
  	function afterInit(){
  	}

	//返回
	function btnBack() {
		if(BizProcessInfoId=="" || BizProcessInfoId ==null){
			var vUrl = "BizProcessInfoMain.jsp?domainId="+domainId+"&selItemsId="+selItemsId;	
			window.location.href = vUrl;	
		}
		window.parent.goback();
	}


</script>
</body>
</html>