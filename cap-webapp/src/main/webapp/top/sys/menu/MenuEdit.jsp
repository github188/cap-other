<%
/**********************************************************************
* 菜单管理页面:菜单编辑页
* 2014-7-4 石刚 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<html>
<head>
<title>菜单编辑页</title>
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/FuncAction.js"></script>
<style type="text/css">
 .imgMiddle {line-height:350px;text-align:center;}
</style> 
</head>
<body onload="window.status='Finished';">
		<div class="top_header_wrap">
			<div class="thw_title" style="font-size:14px">
				<font id = "pageTittle" class="fontTitle"></font> 
			</div>
			<div class="thw_operate">
				<% if(!isHideSystemBtn){ %>
					<span uitype="button" label="保存" id="saveBtn" on_click="saveFunc"></span>
				<% } %>
				<span uitype="button" label="关闭" id="closeBtn" on_click="closeWindow"></span>
			</div>
		</div>
		<div>
				<table class="form_table">
						<tr>
							<td class="td_label" width="15%"><span class="top_required">*</span><span id="nodeNameText"></span>名称：</td>
							<td class="td_content" width="20%" >
								<span uitype="input" id="funcName" name="funcName" databind="funcData.funcName"  width="200" maxlength="40"
									validate="[{'type':'required','rule':{'m':'请输入名称。'}}, {'type':'custom','rule':{'against':'checkName','m':'名称只能为汉字、数字、字母、下划线、正斜杠、中英文括号。'}}, {'type':'custom','rule':{'against':'isExistRename','m':'名称已被占用。'}}]"
								></span>
							</td>
							<td class="td_label" width="10%">上级名称：</td>
							<td class="td_content" width="25%" >
								<span uitype="input" id="parentFuncName" name="parentFuncName" databind="funcData.parentFuncName" width="200" readonly="true"/>
							</td>
						</tr>
						<tr id="funcCodeTr">
							<td class="td_label" width="15%"><span id="nodeCodeText"></span>编码：</td>
							<td class="td_content" width="20%">
								<span uitype="input" id="funcCode" name="funcCode" databind="funcData.funcCode"  width="200" <c:choose><c:when test='${param.funcNodeType == 2 or param.funcNodeType == 4}'>maxlength="100"</c:when><c:otherwise>maxlength="40"</c:otherwise></c:choose>
									validate="[{'type':'custom','rule':{'against':'checkCode','m':'编码只能为数字、字母、下划线。'}}, {'type':'custom','rule':{'against':'isExistCode','m':'编码已被占用。'}}]"
								></span>
							</td>
							<td class="td_label" width="10%" id="permissionTd"> <span class="top_required">*</span>需要授权： </td>
							<td class="td_content" width="25%">
								<span uitype="RadioGroup" name="permissionType" id="permissionType" value="2"  databind="funcData.permissionType" validate="请选择是否需要授权。"> 
									<input type="radio" name="permissionType" value="2"/>是
	                				<input type="radio" name="permissionType" value="1"/>否
								</span> 
							</td>
						</tr>
						<tr id="funcUrlTr">
							<td class="td_label"> <span id="funcUrlSpan" class="top_required" style="display:none">*</span> 链接地址：</td>
							<td class="td_content" colspan="3">
								<span uitype="input" id="funcUrl" name="funcUrl"  databind="funcData.funcUrl"  maxlength="500"
									 validate="[{'type':'custom', 'rule':{'against':'checkURL', 'm':'链接地址不能输入中文。'}}]"
									 width="492"></span>
							</td>
						</tr>
						<tr id="funcTagTr">
							<td class="td_label">菜单分类：</td>
							<td class="td_content" colspan="3">
<!-- 								<span uitype="RadioGroup" name="funcTag" id="funcTag" value="1"  databind="funcData.funcTag" validate="请选择菜单分类。">  -->
<!-- 									<input type="radio" name="funcTag" value="1"/>业务菜单 -->
<!-- 	                				<input type="radio" name="funcTag" value="2"/>查询菜单 -->
<!-- 	                				<input type="radio" name="funcTag" value="3"/>统计菜单 -->
<!-- 								</span> -->
								<span uitype="CheckboxGroup" name="funcTags" id="funcTags" value="['1']" databind="funcData.funcTags" validate="请选择菜单分类。"> 
									<input type="checkbox" name="funcTags" value="1" text="业务菜单" readonly="readonly"/>
	                				<input type="checkbox" name="funcTags" value="2" text="查询菜单"/>
	                				<input type="checkbox" name="funcTags" value="3" text="统计菜单"/>
								</span>
								
							</td>
						</tr>
						<tr>
							<td class="td_label">描述：
							</td>
							<td class="td_content" colspan="3">
								<div style="width:440px;">
									<span uitype="textarea" name="description" databind="funcData.description" 
										relation="remarkLength" maxlength="500" width="480px"></span>
									<div style="float:right">
										<font id="applyRemarkLengthFont" >(您还能输入<label id="remarkLength" style="color:red;"></label>&nbsp; 字符)</font>
									</div>
								</div>
							</td>
						</tr>
				</table>
	</div>
<!-- js脚本 -->
<script type="text/javascript">
	//actionType
	var actionType = "<c:out value='${param.actionType}'/>";
	//获得父节点类型
	var parentFuncType = "<c:out value='${param.parentFuncType}'/>";
	//当前节点ID
	var funcId = "<c:out value='${param.funcId}'/>";
	//父节点ID
	var parentFuncId = "<c:out value='${param.parentFuncId}'/>";
	//父节点名称
	var parentFuncName = decodeURIComponent(decodeURIComponent("<c:out value='${param.parentFuncName}'/>"));
	//当前节点类型 1目录 2菜单 3应用
	var funcNodeType = "<c:out value='${param.funcNodeType}'/>";
	//父节点权限状态
	var parentPermission = "<c:out value='${param.parentPermissionType}'/>";
	//当前节点权限状态
	var nodePermission = 0;
	
	var funcData = {}; 
	var nodeTypeName = "目录";
	var funcName = "";
	
	$(document).ready(function (){
		showField();
		if(actionType == "edit"){
			dwr.TOPEngine.setAsync(false);
			FuncAction.readFunc(funcId, function(data){
				funcData = data;
				funcName = funcData.funcName;
				nodePermission = funcData.permissionType;
			});		
			$("#pageTittle").html("编辑"+nodeTypeName);
			dwr.TOPEngine.setAsync(true);		
		}else {
			//新增要初始化部分数据
			funcData["parentFuncId"]= parentFuncId;
			funcData["parentFuncType"] = parentFuncType;
			funcData["funcNodeType"] = funcNodeType;
			if(parentFuncName == ''){
				//如果未传递父节点名称，此处需要通过功能ID获取到父节点的相关信息，名称和授权状态
				dwr.TOPEngine.setAsync(false);
				FuncAction.readFunc(parentFuncId, function(data){
					parentFuncName = data.funcName;
					parentPermission = data.permissionType;
				});		
				dwr.TOPEngine.setAsync(true);		
			}
			funcData["parentFuncName"]= parentFuncName; 
			//permissionType默认为必须授权
			if(funcNodeType == 5){
				funcData["permissionType"] = 2;
			}
			//funcData["funcTag"] = 1;
			funcData["status"] = 1;
			$("#pageTittle").html("新增"+nodeTypeName);
		}
		comtop.UI.scan();
		if(funcNodeType != 2){
			window.validater.disValid('funcTags', true);
		}else{
			$('#funcUrlSpan').show();
			 window.validater.add('funcUrl', 'required', {
	                m:'链接地址不能为空'
	            });
		} 
		if(funcNodeType == 5){
			//如果当前新建或者修改的是操作，下级操作必须要保证可授权，授权状态不能让其选择
			cui("#permissionType").setReadonly(true);
		}
		init();
	});
	
	function convertTagToArray(tagContent){
		if(tagContent){
			var tags = tagContent.split(',');
			return tags;
		}
		return [];
	}
	
	function convertTags(tags){
		var tag = "";
		if(tags && tags.length > 0){
			for(var i = 0;i<tags.length;i++){
				if(i > 0){
					tag = tag + ',';
				}
				tag = tag + tags[i];
			}
		}
		return tag;
	}
	
	//字段根据不同类型进行展示
	function showField(){
		if(funcNodeType == 1){
			nodeTypeName = "目录";
			$('#funcCodeTr').hide();
			$('#funcUrlTr').hide();
			$('#funcTagTr').hide();
		}else if(funcNodeType == 2){
			nodeTypeName = "菜单";
		}else if(funcNodeType == 4){
			nodeTypeName = "页面";
			$('#deleteBtn').hide();
			$('#funcTagTr').hide();
		}else if(funcNodeType == 5){
			nodeTypeName = "操作";
			$('#funcTagTr').hide();
		}
		$('#nodeNameText').html(nodeTypeName);
		$('#nodeCodeText').html(nodeTypeName);
	}

	function init(){
		if(actionType == "edit"){
			if($.trim(cui('#funcCode').getValue()) != ''){
				//权限相关的字段要设置为只读
				cui("#funcCode").setReadonly(true);
			}
		}
	}
	
	//关闭窗口
	function closeWindow(){
		window.parent.cuiEMDialog.dialogs['funcDialog'].hide();
	}
	
	function saveFunc(){
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
			var vo = cui(funcData).databind().getValue();
			if(actionType == "add"){
				dwr.TOPEngine.setAsync(false);
				//保存功能信息
				FuncAction.saveFunc(vo, function(data){
					window.parent.cuiEMDialog.dialogs['funcDialog'].hide();
					window.parent.cuiEMDialog.wins['funcDialog'].editFuncCallBack(actionType, parentFuncId);
				});
				dwr.TOPEngine.setAsync(true);
			}else{
				if(nodePermission != vo.permissionType){
					if(vo.permissionType == 1){
						//节点授权状态从”是“变为”否“，需要删除节点授权数据
						vo.cascadeOpen = 2;
					}
				}
				dwr.TOPEngine.setAsync(false);
				//修改功能信息
				FuncAction.updateFunc(vo, function(data){
					window.parent.cuiEMDialog.dialogs['funcDialog'].hide();
					window.parent.cuiEMDialog.wins['funcDialog'].editFuncCallBack(actionType, funcId); 
				});
				dwr.TOPEngine.setAsync(true);
			}
		}
	}
	
	//判断名称是否满足规范
	function checkName(data){
		var reg = new RegExp("^[\u4E00-\u9FA5A-Za-z0-9_/\(（\)）]+$");
		return (reg.test(data));
	}
	
	//判断名称是否重复
	function isExistRename(data){
		if(data){
			var flag = true;
			dwr.TOPEngine.setAsync(false);
			var conditionVO = {parentFuncId:parentFuncId, funcName:data, funcId:funcId};
			FuncAction.judgeNameRepeat(conditionVO, function(data){
				if(data == 'NameExists'){
					flag = false;
				}else{
					flag = true;
				}
			});	
			dwr.TOPEngine.setAsync(true);
			return flag;
		}
	}
	
	//只能为 英文、数字、下划线
	function checkCode(data) {
		if(data){
			var reg = new RegExp("^[A-Za-z0-9_]+$");
			return (reg.test(data));
		}
		return true;
	}
	
	/**
	* 检查编码全局是否唯一
	**/
	function isExistCode(data){
		var flag = true;
		if(actionType != 'add' || $.trim(data) == ''){//只有新增需要校验
			return flag;
		}else{
			dwr.TOPEngine.setAsync(false);
			var conditionVO = {funcCode:data, funcId:funcId};
			if(funcNodeType == 5){
				//如果是操作，则判断是否同一父节点下编码唯一，不是则判断全局唯一
				conditionVO.parentFuncId = parentFuncId; 
			}
			FuncAction.judgeCodeRepeat(conditionVO, function(data){
				if(data == 'CodeExists'){
					flag = false; //存在重复的编码	
				}else{
					flag = true;
				}
			});
			dwr.TOPEngine.setAsync(true);
			return flag;
	 	}
	}
	
	//链接地址不能输入中文
	function checkURL(data){
		 var flag = true;
		 var patrn = /[\u4E00-\u9FA5]/i;
		 if(data&&patrn.test(data)){
			flag = false;
		 }
		 return flag;
	}
</script>
</body>
</html>
