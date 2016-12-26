<!doctype html>
<%
  /**********************************************************************
	* 业务流程节点编辑
	* 2015-11-12 CAP 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<html>
<head>
<title>业务流程编辑</title>
	<META http-equiv="X-UA-Compatible" content="IE=edge"/>
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_sys.css" type="text/css">
	<top:link  href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/top/js/jquery.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.editor.min.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/engine.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/util.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/BizProcessNodeAction.js'></script>
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
		<div class="thw_title">业务流程节点编辑</div>
			<div style="float:right">
			<span uitype="button" on_click="btnAddNewContinue" id="btnAddNewContinue" icon="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/smartGrid/images/button/save_white.gif" hide="false" button_type="blue-button" disable="false" label="保存并继续"></span> 
			<span uitype="button" on_click="saveNoClose" id="addSaveNoCloseButton" hide="false" button_type="blue-button" disable="false" label="保存不关闭"></span> 
			<span uitype="button" on_click="btnClose" id="btnClose" hide="false" button_type="blue-button" disable="false" label="关闭"></span>
		</div>
	</div>
	<div id="editDiv"  class="top_content_wrap">
		<table class="form_table" style="table-layout:fixed;">
			<colgroup>
				<col width="16%" />
				<col width="34%" />
				<col width="16%" />
				<col width="34%" />
			</colgroup>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">节点名称<span class="top_required">*</span>：</span></td>
					<td>
						<span uitype="Input" id="name" maxlength="36" byte="true" textmode="false" databind="BizProcessNode.name" width="85%" align="left"  type="text" readonly="false" validate="[{'type':'required', 'rule':{'m': '节点名称不能为空！'}}]"></span>
					</td>
					<td class="td_label"><span style="padding-left: 10px;">节点编号<span class="top_required">*</span>：</span></td>
					<td>
						<span uitype="Input" id="serialNo" maxlength="32" byte="true" textmode="false" databind="BizProcessNode.serialNo" width="85%" align="left" mask="Num" type="text" readonly="false" validate="serialNoValidate"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">IT实现<span class="top_required">*</span>：</span></td>
					<td>
						<span uitype="Input" id="sysName" maxlength="64" byte="true" textmode="false" databind="BizProcessNode.sysName" width="85%" align="left" maskoptions="{}" type="text" readonly="false" emptytext="如：OMS系统" validate="[{'type':'required', 'rule':{'m': 'IT实现不能为空！'}}]"></span>
					</td>
					<td class="td_label"><span style="padding-left: 10px;">节点标志：</span></td>
					<td>
						<span id="nodeFlag" uitype="PullDown" mode="Multi" value_field="id" label_field="text" databind="BizProcessNode.nodeFlag" datasource="initNodeFlag"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">管理层级：</span></td>
					<td>
						<span id="manageLevel" uitype="PullDown" mode="Single" value_field="id" label_field="text" databind="BizProcessNode.manageLevel" datasource="initLevelData"></span>
					</td>
					<td class="td_label"><span style="padding-left: 10px;">风险点：</span></td>
					<td>
						<span uitype="Input" id="riskArea" maxlength="256" byte="true" textmode="false" emptytext="该流程环节的风险点条款或描述" databind="BizProcessNode.riskArea" width="85%" align="left" maskoptions="{}" type="text" readonly="false"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">制度条款：</span></td>
					<td colspan="3">
						<span uitype="Input" id="clause" maxlength="256" byte="true" textmode="false" databind="BizProcessNode.clause" emptytext="本步骤有关制度条款"  width="94%" align="left" maskoptions="{}" type="text" readonly="false"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">关联角色：</span></td>
					<td colspan="3">
						<span uitype="ClickInput" id="roleNames" databind="BizProcessNode.roleNames" width="90%" on_iconclick="btnChooseRole"></span>
<!-- 						<span uitype="Input" id="roleNames" maxlength="256" byte="true" textmode="false" databind="BizProcessNode.roleNames" width="82%" align="left" maskoptions="{}" type="text" readonly="true"></span> -->
<!-- 						<span uitype="button" on_click="btnChooseRole" id="btnChooseRole" hide="false" button_type="blue-button" disable="false" label="选择角色"></span> -->
						<span uitype="button" on_click="btnClean" id="btnClean" hide="false" button_type="blue-button" label="清空"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">节点定义：</span></td>
					<td colspan="3">
						<span uitype="Editor" id="nodeDef" min_frame_height="90" word_count="true" textmode="false" word_count="true" width="95%" databind="BizProcessNode.nodeDef" toolbars="toolbars" focus="true" readonly="false"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">工作要求：</span></td>
					<td colspan="3">
						<span uitype="Editor" id="workDemand" min_frame_height="90" word_count="true" textmode="false" word_count="true" width="95%" databind="BizProcessNode.workDemand" toolbars="toolbars" focus="true" readonly="false"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">工作内容：</span></td>
					<td colspan="3">
						<span uitype="Editor" id="workContext" min_frame_height="90" word_count="true" textmode="false" word_count="true" width="95%" databind="BizProcessNode.workContext" toolbars="toolbars" focus="true" readonly="false"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">备注：</span></td>
					<td colspan="3">
						<span style="color:#999;">您还能输入<label id="remark_tip" style="color: red;"></label>个字！</span><br/>
						<span uitype="Textarea" relation="remark_tip" id="remark" height="150px" maxlength="1000" byte="true" textmode="false" databind="BizProcessNode.remark" width="95%" autoheight="false" name="remark_Textarea" readonly="false"></span>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
<script language="javascript"> 
	var BizProcessInfoId = "<c:out value='${param.BizProcessInfoId}'/>";
	var domainId = "<c:out value='${param.domainId}'/>";
	var BizProcessNode = {};
	var roleIds;
	var BizProcessNodeId = "<c:out value='${param.BizProcessnodeId}'/>";
   	window.onload = function(){
   		init();
   		if(cui("#roleNames").getValue()){
			cui("#btnClean").show();
		}
		else{
			cui("#btnClean").hide();
		}
   	}
   	
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
	           'rowspacingtop', //段前距
	           'rowspacingbottom', //段后距
	           'pagebreak', //分页
	           'imagecenter', //居中
	           ]]
   	
   	var serialNoValidate = [
              {'type':'required', 'rule':{'m': '节点编号不能为空！'}},
    	      {'type':'custom','rule':{'against':checkSerialNo, 'm':'节点编号只能为数字'}}
    	      ];
   	
   	var initNodeFlag = [{id:'关键业务节点',text:'关键业务节点'},
   	   	          		{id:'核心管控节点',text:'核心管控节点'},
   	   	          		{id:'一般管控节点',text:'一般管控节点'}
   	                    ]
   	
   	var initLevelData = [
   	   	          		{id:'网公司',text:'网公司'},
   	   	          		{id:'分子公司',text:'分子公司'},
   	   	          		{id:'省公司',text:'省公司'},
   	   	          		{id:'地市局',text:'地市局'},
   	   	          		{id:'基层单位',text:'基层单位'}
   	   	          		]
   	
	function init() {
		if(BizProcessNodeId != "") {
			dwr.TOPEngine.setAsync(false);
			BizProcessNodeAction.queryBizProcessNodeById(BizProcessNodeId,function(bResult){
				BizProcessNode = bResult;
				roleIds = bResult.roleIds;
				cui("#roleNames").setValue(bResult.roleNames);
			});
			dwr.TOPEngine.setAsync(true);
		}
		if (typeof(myBeforeInit) == "function") {
			eval("myBeforeInit()");
		}

		comtop.UI.scan();
		
		var isHideAddNewContinueBtn = true;
		if(BizProcessNodeId=="" || BizProcessNodeId==null){
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
			cui("#addSaveNoCloseButton").hide();
			cui("#btnClose").show();
			if (typeof(setReadonlyButton) == "function") {
				eval("setReadonlyButton()");
			}
		}
	}
	
	//要求流程节点编号必须为数字
	function checkSerialNo(data) {
		 var reg = new RegExp("^[0-9]*$");  
		 return reg.test(data);
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
			window.parent.opener.setLeftUrl();
			window.cui.message('保存成功。','success');
			setTimeout('refreshPage()',1000);
		}
	}
	
	function saveNoClose(){
		var saveSuccess = btnSave(false);
		if(saveSuccess){
			window.parent.opener.setLeftUrl();
			window.cui.message('保存成功。','success');
			if(!BizProcessNodeId){
				setTimeout('editNode()',1000);
			}
		}
	}
	
	//刷新页面
	function refreshPage(){
	 	window.location.reload();
	}
	
	//跳转到编辑页面
	function editNode(){
		var url = "TabList.jsp?BizProcessInfoId="+BizProcessInfoId+"&BizProcessnodeId="+BizProcessNode.id+"&domainId="+domainId;
		window.location.href = url;
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
        if(!result && typeof(result) != "undefined"){
        	return;
        }
			
		dwr.TOPEngine.setAsync(false);
		BizProcessNodeAction.saveBizProcessNode(BizProcessNode, function(bResult){
 			//保存数据
 			if(bResult && isBack) {
 				if(BizProcessNode.id && BizProcessNode.id != "") {
 					window.parent.cui.message('修改成功。','success');
 				} else {
 					BizProcessNode.id = bResult;
 	 				window.parent.cui.message('新增成功。','success');
 				}
	 			setTimeout('btnClose()',1000);
 			}
 			BizProcessNode.id = bResult;
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
		if(!BizProcessNode.creatorId){
			BizProcessNode.creatorId = globalUserId;
		}
		
		BizProcessNode.workDemand = cui("#workDemand").getValue();	  
		BizProcessNode.workContext = cui("#workContext").getValue();	  
		BizProcessNode.remark = cui("#remark").getValue();	  
		BizProcessNode.processId = BizProcessInfoId;
		BizProcessNode.dataFrom = 0;
		BizProcessNode.roleIds = roleIds;
		BizProcessNode.domainId = domainId;
	}

	//初始化后处理事件，回显操作
  	function afterInit(){
  	}

	//关闭事件
	function btnClose() {
		window.parent.parent.close(); 
	}
	
	function btnChooseRole(){
		var url = "${pageScope.cuiWebRoot}/cap/bm/biz/role/chooseMulRole.jsp?domainId="+domainId;
		var title="角色选择";
		var height = 550; //600
		var width =  700; // 680;
		dialog = cui.dialog({
			title : title,
			src : url,
			width : width,
			height : height
		})
		dialog.show(url);
	}
	
	//导入回调方法 
	function chooseRole(selectRole){
		var selNames = getArray(selectRole);
		if(roleIds ==""){
			cui.alert("选择的数据项已经导入。");
		}else{
			cui("#roleNames").setValue(selNames);
			cui("#btnClean").show();
		}
	}
	
	//判断是否重复
	function getArray(selects){
		var role = new Array()
		var bizRoleIds = "";
		var bizRroleNames = "";
		var ids = new Array();
		roleIds = "";
		if(roleIds !="" && roleIds !=null){
			ids = roleIds.split(",");
		}
		for(var i = 0;i<selects.length;i++){
			var flag = true;
			if(roleIds !="" && roleIds !=null){
				for(var j =0;j<ids.length;j++){
					if(selects[i].id == ids[j]){
						flag = false;
						break;
					}
				}
			}
			if(flag){
				bizRoleIds += selects[i].id+",";
				bizRroleNames += selects[i].roleName+",";
			}
		}
		roleIds = bizRoleIds.substring(0,bizRoleIds.length-1);
		return bizRroleNames.substring(0,bizRroleNames.length-1);
	}
	
	function btnClean(){
		cui("#roleNames").setValue("");
		roleIds="";
		cui("#btnClean").hide();
	}
</script>
</body>
</html>