<%
/**********************************************************************
* 应用新增:应用新增页
* 2014-7-4 石刚 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<html>
<head>
<title>应用编辑页</title>
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/js/comtop.ui.emDialog.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/FuncAction.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/ModuleAction.js"></script>
<style type="text/css">
 .imgMiddle {line-height:350px;text-align:center;}
.top_header_wrap{
	padding-right:5px;
}
</style> 
</head>
<body onload="window.status='Finished';">
<div uitype="Borderlayout"  id="body" is_root="true" on_sizechange="resizeTab">
	<div id="topMain" style="overflow:hidden;" position="top" height="330" gap="0px 0px 0px 0px" collapsable="true" show_expand_icon="true">
	<div class="top_header_wrap" style="padding-top:15px;padding-bottom:15px;padding-right:15px;">
		<div class="thw_title">
			<font id = "pageTittle" class="fontTitle">编辑应用信息</font> 
		</div>
		<div class="thw_operate" <% if(isHideSystemBtn){ %> style="display:none" <% } %>>
			<span uitype="button" label="查看权限" id="button_right" on_click="rightRecommend"></span>
			<span uitype="button" id="new_same" label="新增同级"  menu="insertSame" ></span>
			<span uitype="button" id="new_sub" label="新增下级"  menu="insertSub"></span>
			<span uitype="button" label="编辑" id="updBtn" on_click="updateFunc"></span>
			<span uitype="button" label="保存" id="saveBtn" on_click="saveFunc"></span>
			<span uitype="button" label="删除" id="delBtn" on_click="delFunc"></span>
			<span uitype="button" label="返回" id="back_to"   on_click="backTo" ></span>
		</div>
	</div>
	<div class="top_content_wrap cui_ext_textmode">
			<table class="form_table" style="table-layout:fixed;">
					<tr>
						<td class="td_label" width="10%"><span class="top_required">*</span><span id="nodeNameText"></span>应用名称：</td>
						<td class="td_content" width="40%" >
							<span uitype="input" id="funcName" name="funcName" databind="funcData.funcName"  width="240" maxlength="36"
								validate="[{'type':'required','rule':{'m':'请输入应用名称。'}}, {'type':'custom','rule':{'against':'checkName','m':'名称只能为汉字、数字、字母、下划线、正斜杠、中英文括号。'}}, {'type':'custom','rule':{'against':'isExistRename','m':'名称已被占用。'}}]"
							></span>
						</td>
						<td class="td_label" width="10%"><span class="top_required">*</span><span id="nodeCodeText"></span>应用编码：</td>
						<td class="td_content" width="40%" >
							<span uitype="input" id="funcCode" name="funcCode" databind="funcData.funcCode"  width="220" maxlength="28"
								validate="[{'type':'required','rule':{'m':'请输入应用编码。'}}, {'type':'custom','rule':{'against':'checkCode','m':'编码只能为数字、字母、下划线。'}}, {'type':'custom','rule':{'against':'isExistCode','m':'编码已被占用。'}}]"
							></span>
						</td>
					</tr>
					<tr>
						<td class="td_label"> <span class="top_required">*</span>应用状态： </td>
						<td>
							<span uitype="RadioGroup" name="status" id="status" value="1"  databind="funcData.status" validate="请选择应用状态。"> 
								<input type="radio" name="status" value="1"/>启用
                				<input type="radio" name="status" value="2"/>禁用
							</span> 
						</td>
						<td class="td_label"> <span class="top_required">*</span>需要授权：  </td>
						<td>
							<span uitype="RadioGroup" name="permissionType" id="permissionType" value="2"  databind="funcData.permissionType" validate="请选择是否需要授权。"> 
								<input type="radio" name="permissionType" value="2"/>是
                				<input type="radio" name="permissionType" value="1"/>否
							</span> 
						</td>
					</tr>
					<tr>
						<td class="td_label">更新时间：</td>
						<td class="td_content" >
							<span uitype="Calender" id="updateTime" name="updateTime" width="240" format="yyyy-MM-dd hh:mm" databind="funcData.updateTime"></span>
						</td>
						<td class="td_label">上级名称：</td>
						<td class="td_content" >
							<span uitype="input" id="parentFuncName" name="parentFuncName" width="220" databind="funcData.parentFuncName"></span>
						</td>
					</tr>
					<tr>
						<td class="td_label"  >主页地址：</td>
						<td class="td_content">
							<span uitype="input" id="funcUrl" name="funcUrl"  databind="funcData.funcUrl"  maxlength="500"
								 validate="[{'type':'custom', 'rule':{'against':'checkURL', 'm':'主页地址不能输入中文。'}}]"
								 width="98%"></span>
						</td>
						<td class="td_label"  >更新记录地址：</td>
						<td class="td_content">
							<span uitype="input" id="funcNoteUrl" name="funcNoteUrl"  databind="funcData.funcNoteUrl"  maxlength="500"
								 validate="[{'type':'custom', 'rule':{'against':'checkURL', 'm':'更新记录地址不能输入中文。'}}]"
								 width="98%"></span>
						</td>
					</tr>
					<tr>
						<td class="td_label">图标地址：</td>
						<td class="td_content">
							<span uitype="input" id="menuIconUrl" name="menuIconUrl"  databind="funcData.menuIconUrl"  maxlength="200"
								 validate="[{'type':'custom', 'rule':{'against':'checkURL', 'm':'图标地址不能输入中文。'}}]"
								 width="98%"></span>
						</td>
						<td class="td_label"  >帮助文档地址：</td>
						<td class="td_content">
							<span uitype="input" id="helpDocumentUrl" name="helpDocumentUrl"  databind="funcData.helpDocumentUrl"  maxlength="500"
								 validate="[{'type':'custom', 'rule':{'against':'checkURL', 'm':'更新记录地址不能输入中文。'}}]"
								 width="98%"></span>
						</td>
					</tr>
					<tr>
						<td class="td_label" valign="top">描述：
						</td>
						<td class="td_content" colspan = "3">
							<div>
								<span uitype="textarea" name="description" databind="funcData.description" 
									relation="remarkLength" maxlength="500" width="99%"></span>
								<div style="float:right">
									<font id="applyRemarkLengthFont" >(您还能输入<label id="remarkLength" style="color:red;"></label>&nbsp; 字符)</font>
								</div>
							</div>
						</td>
					</tr>
			</table>
	</div>
	</div>
	<div  id="centerMain" position="center" url="" gap="0px 0px 0px 0px" />
	
	</div>
</div>
<!-- js脚本 -->
<script type="text/javascript">

	//获得请求方式 add 新增 edit 修改
	var actionType = "<c:out value='${param.actionType}'/>";
	//模块ID
	var moduleId = "<c:out value='${param.moduleId}'/>";
	//模块名称
	var moduleName = decodeURIComponent(decodeURIComponent("<c:out value='${param.moduleName}'/>"));
	//返回ID
	var backId = "<c:out value='${param.backId}'/>";
	//父节点ID
	var parentModuleId = "<c:out value='${param.parentModuleId}'/>";
	//父节点名称
	var parentModuleName = decodeURIComponent(decodeURIComponent("<c:out value='${param.parentModuleName}'/>"));
	//父节点类型
	var parentModuleType = "<c:out value='${param.parentModuleType}'/>";
	
	//节点状态
	var nodeStatus = 0;
	var nodePermission = 0;
	
	//是否能正常启用
	var isUsing = true;
	
	var funcData = {}; 
	
	//获取应用分类信息
	function ajaxData(obj){
		dwr.TOPEngine.setAsync(false);
		FuncAction.getFuncTagList(function(data){
			obj.setDatasource(data);
		});
	}
	
	$(document).ready(function (){
		if(actionType == 'add'){
			//新增要初始化部分数据
			cui('#new_same').hide();
			cui('#new_sub').hide();
			cui('#delBtn').hide();
			cui('#button_right').hide();
			funcData["parentFuncId"]= parentModuleId;
			funcData["parentFuncType"] = "MODULE";
			funcData["funcNodeType"] = 3;
			funcData["permissionType"] = 2;
			funcData["parentFuncName"] = parentModuleName;
			funcData["status"] = 1;
		}else{
			cui('#back_to').hide();	
			
			dwr.TOPEngine.setAsync(false);
			FuncAction.readFuncByModuleId(moduleId, function(data){
				funcData = data;
				funcData.parentFuncName = parentModuleName;
				//得到应用节点状态及授权状态
				nodeStatus = data.status;
				if(nodeStatus == 2){
					//如果当前节点状态是禁用，则需判断其父节点应用状态是否为禁用
					FuncAction.readFuncByModuleId(parentModuleId, function(data1){
						if(data1 != null && data1.status == 2){
							//表示当前节点的父节点也是一个禁用的应用，此处不应该让其应用状态可以变成启用
							isUsing = false;
						}
					});
				}
				//funcData.funcTag = convertTagToArray(funcData.funcTag);
				nodePermission = data.permissionType;
				//该应用不需要授权，则隐藏授权信息按钮
				if(nodePermission != 2){
					cui('#button_right').hide();
				}
			});		
			dwr.TOPEngine.setAsync(true);		 
		}
		comtop.UI.scan();
		cui("#parentFuncName").setReadonly(true);
		if(actionType == 'edit'){
			cui("#funcCode").setReadonly(true);
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
	
	//新增下级
 	var insertSub = {
    	datasource: [
            {id:'insertSubApplication',label:'新增下级应用'}
        ],
        on_click:function(obj){
        	if(obj.id=='insertSubApplication'){
        		insertSubAppliation();
        	}
        }
    };
	
 	//新增同级
 	var insertSame = {
    	datasource: [
  	            {id:'insertSameSys',label:'新增同级系统'},
  	            {id:'insertSameDirectory',label:'新增同级目录'},
  	            {id:'insertSameApplication',label:'新增同级应用'},
  	        ],
  	        on_click:function(obj){
  	        	if(obj.id=='insertSameSys'){
  	        		insertSameSysOrDirectory(1);
  	        	}else if(obj.id=='insertSameDirectory'){
  	        		insertSameSysOrDirectory(3);
  	        	}else if(obj.id=='insertSameApplication'){
  	        		insertSameSysOrDirectory(2);
 	        	}
  	        }
    };
 	
 	/**
 	*  返回
	*/
	function backTo(){
		//判断左侧树结构是否已经是列表展示的
		if($('#moduleTree',window.parent.document).is(":hidden")){
			window.parent.clickRecord(backId, '');
		}else{
			window.parent.nodeUrl(backId);
		}
	}
 	//新增下级应用
 	function insertSubAppliation(){
 		var moduleName = funcData.funcName;
 		var url = "${cuiWebRoot}/top/sys/menu/FuncEdit.jsp?actionType=add&backId="+moduleId+"&parentModuleId="+moduleId+"&parentModuleName="+encodeURIComponent(encodeURIComponent(moduleName));
 		window.location.href = url;
 	}

	//新增同级
	function insertSameSysOrDirectory(nodeType){
		cui('#button_right').hide();
		var url = "";
		//新增同级应用
		if(nodeType == 2){
			url = "${cuiWebRoot}/top/sys/menu/FuncEdit.jsp?actionType=add&backId="+moduleId+"&parentModuleId="+parentModuleId+"&parentModuleName="+encodeURIComponent(encodeURIComponent(parentModuleName));
		}else{
			url = "${cuiWebRoot}/top/sys/module/ModuleEdit.jsp?actionType=add&moduleType="+nodeType+"&parentId="+parentModuleId+"&parentName="+encodeURIComponent(encodeURIComponent(parentModuleName))+"&moduleId="+moduleId+"&parentModuleType="+parentModuleType;
		}
		window.location.href = url;
	}
	
	//初始化应用资源列表链接
	function init(){
		if(actionType == 'add'){
			cui('#centerMain').hide();
			cui('#updBtn').hide();
		}else{
			comtop.UI.scan.setReadonly(true);	
			//如果当前节点状态为禁用时，默认隐藏掉所有的新增按钮
			if(nodeStatus == 2){
				cui('#new_same').hide();
				cui('#new_sub').hide();
			}
			//隐藏 *号
			cui('.top_required').hide();
			$('#pageTittle').html("应用基本信息");
			$('#applyRemarkLengthFont').hide();
			cui('#saveBtn').hide();
			//如果父节点是应用，下级只能建应用
			if(parentModuleType == 2){
				cui('#new_same').getMenu().disable("insertSameSys",true);
				cui('#new_same').getMenu().disable("insertSameDirectory",true);
			}else if(parentModuleType == 3){
				//如果父节点是目录，则下面只能建目录和应用
				cui('#new_same').getMenu().disable("insertSameSys",true);
			}
			//展示操作列表
			cui('#body').setContentURL("center",'${cuiWebRoot}/top/sys/menu/FuncList.jsp?parentResourceId='+funcData.funcId+"&parentResourceType=FUNC&parentName="+encodeURIComponent(encodeURIComponent(moduleName))+"&permissionType="+funcData.permissionType);
		}
	}
	
	//编辑
	function updateFunc(){
		comtop.UI.scan.setReadonly(false);		
		cui('.top_required').show();
		cui('#funcCode').setReadonly(true);
		cui('#parentFuncName').setReadonly(true);
		if(isUsing == false){
			//编辑状态应用状态设置为不可选
			cui('#status').setReadonly(true);
		}
		$('#applyRemarkLengthFont').show();
		$('#pageTittle').html("编辑应用信息");
		cui('#saveBtn').show();
		cui('#updBtn').hide();
		cui('#button_right').hide();
	}
	
	//删除
	function delFunc(){
		var isHasChildren = "false";
		var deleteMessage = "";
		//判断该应用下是否还有下级应用，如果有，则不允许删除。
		dwr.TOPEngine.setAsync(false);
		ModuleAction.hasSubModule(moduleId,function(data){
			isHasChildren = data.isDelete;
			deleteMessage = data.deleteMessage;
		});
		dwr.TOPEngine.setAsync(true);
		if(isHasChildren=="true"&&deleteMessage!=""&&deleteMessage!=null){
			cui.warn("无法删除该应用模块，该应用模块下存在子"+deleteMessage);
			return false;	
		}
		if(isHasChildren=="true"){
			cui.warn("无法删除该应用，该应用下存在子应用。");
			return false;	
		}
		//判断应用下级有没有菜单页面资源，如果有，则不让他删除 
		var selectData = [];
		selectData.push(funcData.funcId);
		dwr.TOPEngine.setAsync(false);
		FuncAction.getNoDelFuncId(selectData, function(data){
			if(data == null || data.length == 0){
				var msg = "确定要删除当前应用吗？";
				cui.confirm(msg, {
			        onYes: function () {
			        	var funcDTO = {};
						funcDTO.parentFuncId = moduleId;
						funcDTO.funcId = funcData.funcId;
						FuncAction.deleteFuncVOInModule(funcDTO, function(data){
							window.parent.cui.message('应用删除成功。',"success");
							cui('#button_right').hide();
							delRefresh(moduleId,parentModuleId);
						});
			        }
				});
				
			}else{
				cui.warn("无法删除该应用模块，该应用模块下存在资源数据。");	
			}
		});
		dwr.TOPEngine.setAsync(true);
		
	}
	
	// 删除操作后刷新树 
	function delRefresh(moduleId,parentModuleId){
		var treeObject = parent.cui("#moduleTree");
		var pNode = treeObject.getNode(parentModuleId);
		var selectNode = treeObject.getNode(moduleId);
		//隐藏listbox展示属性结构，定位到删除节点父节点   
		showTree();
		if(selectNode && selectNode.dNode) {
			pNode.activate(true);
			pNode.getData().isLazy = false;
			// 删除节点
			selectNode.remove();
		}
		var isHasChildren = false;
		dwr.TOPEngine.setAsync(false);
		ModuleAction.hasSubModule(parentModuleId,function(data){
			isHasChildren = data;
		});
		dwr.TOPEngine.setAsync(true);
		if(!isHasChildren) {
			pNode.getData().isFolder = false;
		} 
		parent.nodeUrl(parentModuleId);
	}
	
	//保存应用
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
			//转换tag
			//vo.funcTag = convertTags(vo.funcTag);
			if(actionType == 'add'){
				dwr.TOPEngine.setAsync(false);
				//保存应用信息
				FuncAction.saveFuncVOInModule(vo, function(data){
					if(data) {
						//隐藏listbox展示属性结构，定位到新增节点  
						showTree();
						//刷新树
						window.parent.cui.message('应用新增成功。',"success");
						parent.addRefreshTree(data, parentModuleId);
					}else{
						window.parent.cui.message("应用新增失败。", "error");
					} 
				});
				dwr.TOPEngine.setAsync(true);
			}else{
				//更新子节点状态
				if(nodeStatus != vo.status){
					dwr.TOPEngine.setAsync(false);
					var isEnableDis = false;
					FuncAction.isHasNormalFunc(moduleId, function(data){
						isEnableDis = data;
					});
					dwr.TOPEngine.setAsync(true);
					if(isEnableDis){
						cui.warn("无法禁用该应用模块，该应用模块下存在启用的子应用模块。");
						return false;	
					}
					vo.cascadeForbidden = 1;
				}
				if(vo.cascadeForbidden == 1 && vo.status == 2){
					var msg = "确定要禁用当前应用吗？";
					cui.confirm(msg, {
				        onYes: function () {
				        	updateFuncData(vo);
				        }
					});
				}else{
					updateFuncData(vo);
				}
			}
		}
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
	
	function updateFuncData(vo){
		if(nodePermission != vo.permissionType){
			if(vo.permissionType == 1){
				//节点授权状态从”是“变为”否“，需要删除节点授权数据
				vo.cascadeOpen = 2;
			}
		}
		dwr.TOPEngine.setAsync(false);
		moduleName = vo.funcName;
		//修改应用信息
		FuncAction.updateFuncVOInModule(vo, function(data){
			//隐藏listbox展示属性结构，定位到新增节点  
			nodeStatus = vo.status;
			nodePermission = vo.permissionType;
			showTree();
			window.parent.cui.message('应用修改成功。',"success");
			parent.editRefreshTree(moduleId, parentModuleId,moduleName);
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//树形结构展示
	function showTree() {
		parent.cui('#keyword').setValue('');
		parent.$('#fastQueryList').hide();
		parent.$('#moduleTree').show();
		parent.addType = '';
	}
	
	//判断名称是否满足规范
	function checkName(data){
		var reg = new RegExp("^[\uff08 \uff09 \u0028 \u0029 \u4E00-\u9FA5A-Za-z0-9_/\(（\)）]+$");
		return (reg.test(data));
	}
	
	//判断名称是否重复
	function isExistRename(data){
		if(data){
			var flag = true;
			dwr.TOPEngine.setAsync(false);
			var conditionVO = {parentModuleId:parentModuleId, moduleName:data, moduleId:moduleId};
			ModuleAction.isModuleNameExist(conditionVO, function(data){
				if(data){
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
			//编码需要保证全局唯一,此处判断模块是否唯一
			var conditionVO = {parentModuleId:parentModuleId, moduleCode:data, moduleId:moduleId};
			ModuleAction.isModuleCodeExist(conditionVO, function(data){
				if(data){
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
	
	//显示菜单的角色和岗位引用
	function rightRecommend(){
		var url = '${pageScope.cuiWebRoot}/top/sys/menu/RoleList.jsp?actionType=edit&funcId='+funcData.funcId;
		var title = funcData.funcName ;
		cui.extend.emDialog({
			id: 'roleDialog',
			title : title,
			src : url,
			width : 750,
			height : 390
	    }, window.parent.parent).show(url);
		
	}
</script>
</body>
</html>
