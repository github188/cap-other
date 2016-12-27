<%
  /**********************************************************************
	* 模块管理
	* 2013-2-25 陈志伟  重构
	* 2013-3-12 沈康 cui重构
	* 2013-3-27 李小芬CUI重构
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<html>
<head>
	<title>目录管理编辑页面</title>
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js'></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.editor.min.js'></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/js/jquery.js'></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/engine.js'></script>
    <script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
    <script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/interface/ModuleAction.js'></script>
</head>
<style>
	.top_header_wrap{
		padding-right:5px;
	}
</style>
<body>
<div uitype="Borderlayout"  id="body" is_root="true">	
	<div class="top_header_wrap" style="padding-top:15px;padding-right:15px;">
		<div class="thw_title">
			<font id = "pageTittle" class="fontTitle"></font> 
		</div>
		<div class="thw_operate">
		<% if(!isHideSystemBtn){ %>
		<span uitype="button" id="new_same" label="新增同级"  menu="insertSame" ></span>
		<span uitype="button" id="new_sub" label="新增下级"  menu="insertSub"></span>
		<span uitype="button" label="编辑" id="updBtn" on_click="updateFunc"></span>
		<span uitype="button" id="save" label="保存"  on_click="save" ></span>
		<span uitype="button" id="delete" label="删除"  on_click="canDeleteModuleVO" ></span>
		<span uitype="button" id="back_to" label="返回"  on_click="backTo" ></span>
		<% } %>
		</div>
		
	</div>
	<div class="cui_ext_textmode" >
		<table class="form_table" style="table-layout:fixed;">
			<colgroup>
				<col width="30%" />
				<col width="70%" />
			</colgroup>
			<tr style = "display:none">
				<td class="td_label" width="25%">类型 ：<span style="color: red">*</span></td>
				<td>
					<span id="moduleTypeGroup" uitype="RadioGroup" name="moduleType" databind="data.moduleType"
			      readonly="true">
		        <input type="radio" name="moduleType" value="1" />
		                         系统
		        <input type="radio" name="moduleType" value="3" />
		                      目录 </span>
				</td>
				
			</tr>
			<tr>
				<td class="td_label">上级名称：</td>
				<td>
				<span uitype="input" name="parentName" id="parentName" databind="data.parentName" width="440px" readonly="true"></span>
				<span uitype="input" id="parentModuleId" name="parentModuleId" databind="data.parentModuleId" readonly="true"></span>	
				</td>
			</tr>
	        <tr>
	            <td class="td_label"> <span id="requiredName" class="top_required">*</span> 名称：</td>
	            <td>
	               <span uitype="input" id="moduleName" name="moduleName" databind="data.moduleName" maxlength="36" width="440px"
	                validate="validateModuleName">
	                </span>
	            </td>
	        	
	        </tr>
	        <tr>
	        	<td class="td_label"><span id="requiredModuleCode" class="top_required">*</span> 编码： </td>
				<td>
					<span uitype="input" id="moduleCode" name="moduleCode" databind="data.moduleCode" maxlength="28" width="440px"
	               validate="validateModuleCode" readonly="true"></span>
				</td>
	        </tr>
	        
			<tr> 
				<td class="td_label" valign="top">描述：
				</td>
				<td>
				<div style="width:440px;">
					<span uitype="textarea" id="description" name="description" width="428px" databind="data.description" 
						 maxlength="500" relation="remarkLength" ></span>
					<div style="float:right">
						<font id="applyRemarkLengthFont" >(您还能输入<label id="remarkLength" style="color:red;"></label>&nbsp; 字符)</font>
					</div>
				</div>
				</td>
			</tr>
		</table>
	</div>
</div>
	<script type="text/javascript">
	var inputModuleId = "<c:out value='${param.moduleId}'/>";//传入的目录ID
	var parentModuleId = "<c:out value='${param.parentId}'/>";
	var parentName = "<c:out value='${param.parentName}'/>";
	var moduleTypeVal = "<c:out value='${param.moduleType}'/>";
	var parentModuleType = "<c:out value='${param.parentModuleType}'/>";
	var actionType = "<c:out value='${param.actionType}'/>";
	if(parentName=="undefined"||parentName==null||parentName=="null"){
		parentName="";
	}else{
		parentName = decodeURIComponent(decodeURIComponent(parentName));
	}
	var addType = "<c:out value='${param.addType}'/>";
	var databindIns;//数据绑定实例 
	var insertFlag = 2;//保存时需要判断是新增保存还是更新保存,1表示新增，2表示更新 
	var isRootNodeAdd = "<c:out value='${param.isRootNodeAdd}'/>";
	var parentModuleIdVal = "";
	var parentModuleNameVal = "";
	
	$(document).ready(function(){
		//初始化编辑框数据
		if(actionType =="add"){
			comtop.UI.scan(); 
			insertFlag = 1;//表示新增
			//按钮处理 
			cui('#new_same').hide();
			cui('#new_sub').hide();
			cui('#delete').hide();
			cui('#back_to').show();
			cui('#parentModuleId').hide();
			cui('#save').show();
		   	cui('#updBtn').hide();
			getModuleTypeFlag(parentModuleId,moduleTypeVal);
			cui('#parentModuleId').setValue(parentModuleId);
			cui('#parentName').setValue(parentName);
			cui('#moduleCode').setReadonly(false);//设置编码字段为可编辑
		}else{
			dwr.TOPEngine.setAsync(false);
			ModuleAction.getModuleInfo(inputModuleId,function(moduleData){
				data = moduleData;//根据ID获得目录基本信息
				comtop.UI.scan();   //扫描
			});
			dwr.TOPEngine.setAsync(true);
			if(data.length != 0&&typeof(data.length)!="undefined") {
				parentModuleId = data.parentModuleId;
			};
		   comtop.UI.scan.setReadonly(true);	
		   
		   $('#applyRemarkLengthFont').hide();
		   cui('#parentModuleId').hide();		
		   cui('#back_to').hide();	
		   cui('#parentName').setValue(parentName);
		   cui('#save').hide();
		   cui('#updBtn').show();
		   cui('#requiredName').hide();
		   cui('#requiredModuleCode').hide();
	    }
		if(data.parentModuleId == '-1'){// 如果是根节点
			cui('#parentName').setValue("");
			cui('#new_same').hide();
			cui('#delete').hide();
		}
		if(isRootNodeAdd == "true") {
			cui('#new_same').hide();
			cui('#new_sub').hide();
			cui('#delete').hide();
			cui('#back_to').hide();
			cui('#moduleCode').setReadonly(false);//设置编码字段为可编辑
			cui('#moduleTypeGroup').radioGroup().setValue("1");
			cui('#centerMain').hide();
		}
		//设置标题
		if(moduleTypeVal==1){
			$('#pageTittle').html("系统基本信息");  
		}else if(moduleTypeVal == 3){
			$('#pageTittle').html("目录基本信息");  
		} 
		//控制菜单按钮的可用性
		checkButton();
	});
	
	//编辑
	function updateFunc(){
		initEditPage(moduleTypeVal);
	}
	
	function initEditPage(nodeType){
		comtop.UI.scan.setReadonly(false);		
		cui('#moduleCode').setReadonly(true);
		cui('#parentName').setReadonly(true);
		cui('#requiredName').show();
		cui('#requiredModuleCode').show();
		$('#applyRemarkLengthFont').show();
		//设置标题
		if(nodeType==1){
			$('#pageTittle').html("编辑系统信息");  
		}else if(nodeType == 3){
			$('#pageTittle').html("编辑目录信息");  
		} 
		cui('#save').show();
		cui('#updBtn').hide();
	}
	
	//控制菜单按钮的可用性
	function checkButton(){
		if(moduleTypeVal==2){
			 cui('#new_sub').getMenu().disable("insertSubSys",true);	
			 cui('#new_sub').getMenu().disable("insertSubDirectory",true);	
		}else if(moduleTypeVal==3){
			 cui('#new_sub').getMenu().disable("insertSubSys",true);	
			 if(parentModuleType ==3){
				 cui('#new_same').getMenu().disable("insertSameSys",true);	 
			 }
		}
	}
	
	//新增下级
	function insertSubSysOrDirectory(nodeType){
		initEditPage(nodeType);
		insertFlag = 1;//表示新增
		//按钮处理 
		cui('#new_same').hide();
		cui('#new_sub').hide();
		cui('#delete').hide();
		cui('#back_to').show();
		//字段处理
		var moduleNameVal = cui('#moduleName').getValue();
		cui(data).databind().setEmpty();
		cui('#parentName').setValue(moduleNameVal);//设置上级名称字段
		cui('#parentModuleId').setValue(inputModuleId);
		getModuleTypeFlag(inputModuleId,nodeType);
		cui('#moduleCode').setReadonly(false);//设置编码字段为可编辑
	}
	
	//新增下级应用
	function insertSubApplication(){
		var moduleNameVal = cui('#moduleName').getValue();
		window.parent.cui('#body').setContentURL("center","${cuiWebRoot}/top/sys/menu/FuncEdit.jsp?actionType=add&backId="
				+inputModuleId+"&parentModuleId="+inputModuleId+"&parentModuleName="+encodeURIComponent(encodeURIComponent(moduleNameVal))+"&addType"+addType); 
	}

	//新增同级
	function insertSameSysOrDirectory(nodeType){
		initEditPage(nodeType);
		insertFlag = 1;//表示新增
		//按钮处理 
		cui('#new_same').hide();
		cui('#new_sub').hide();
		cui('#delete').hide();
		cui('#back_to').show();
		//字段处理
		cui(data).databind().setEmpty();
		getModuleTypeFlag(parentModuleId,nodeType);
		cui('#parentModuleId').setValue(parentModuleId);
		cui('#parentName').setValue(parentName);
		cui('#moduleCode').setReadonly(false);//设置编码字段为可编辑
	}
	
	//新增同级应用
	function insertSameApplication(){
		window.parent.cui('#body').setContentURL("center","${cuiWebRoot}/top/sys/menu/FuncEdit.jsp?actionType=add&backId="
				+inputModuleId+"&parentModuleId="+parentModuleId+"&parentModuleName="+encodeURIComponent(encodeURIComponent(parentName))+"&addType"+addType); 
	}
	
	/**
 	*  返回
	*/
	function backTo(){
		//判断左侧树结构是否已经是列表展示的
		if($('#moduleTree',window.parent.document).is(":hidden")){
			window.parent.clickRecord(inputModuleId, '');
		}else{
			window.parent.nodeUrl(inputModuleId);	
		}
	}

	//新增同级或下级时判断能否新增系统
	function getModuleTypeFlag(parentModuleId,nodeType){
		cui('#moduleTypeGroup').radioGroup().setValue(nodeType);
		cui('#moduleTypeGroup').radioGroup().setReadonly(true);
	}

	//检查编码长度
	function checkLength() {
		var moduleIdLength = cui('#moduleId').getValue().length;
		if(moduleIdLength > 50) {
			return false;
		}
		return true;
	}

	//保存根节点方法
	function saveRootNode(moduleVO) {
		moduleVO.parentModuleId = "-1";
		moduleVO.moduleType = cui('#moduleTypeGroup').radioGroup().getValue();
		dwr.TOPEngine.setAsync(false);
		ModuleAction.insertModuleVO(moduleVO,function(data){
			if(data && data.moduleId) {
				//重新初始化树 
				window.parent.cui.message("新增成功。", "success");
				window.parent.location.reload();
			}else{
				window.parent.cui.message("新增失败。", "error");
			}
		});
		dwr.TOPEngine.setAsync(true);	
	}

	//保存方法
	function save(){
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
			//验证全局编码唯一性 
			var moduleVO = cui(data).databind().getValue();
			moduleVO.moduleType =  cui('#moduleTypeGroup').radioGroup().getValue();
			var strModuleType = moduleVO.moduleType;
			if(isRootNodeAdd == "true"){
				saveRootNode(moduleVO);
				return false;
			}
			if(insertFlag == 1){//新增 
				dwr.TOPEngine.setAsync(false);
				ModuleAction.insertModuleVO(moduleVO,function(data){
					if(data && data.moduleId) {
						//隐藏listbox展示属性结构，定位到新增节点  
						showTree();
						//刷新树
						parent.addRefreshTree(data.moduleId,data.parentModuleId);
						if(strModuleType==1){
							window.parent.cui.message('系统新增成功。',"success");
						}else if(strModuleType ==3){
							window.parent.cui.message('目录新增成功。',"success");
						}
					}else{
						if(strModuleType==1){
							window.parent.cui.message('系统新增失败。',"error");
						}else if(strModuleType ==3){
							window.parent.cui.message('目录新增失败。',"error");
						}
					}
				});
				dwr.TOPEngine.setAsync(true);	
			}else{//更新
				dwr.TOPEngine.setAsync(false);
				ModuleAction.updateModuleVO(moduleVO,function(data){
					if(data && data.moduleId){
						//隐藏listbox展示属性结构，定位到新增节点  
						showTree();
						parent.editRefreshTree(data.moduleId,data.parentModuleId,data.moduleName);
						if(strModuleType==1){
							window.parent.cui.message('系统修改成功。',"success");
						}else if(strModuleType ==3){
							window.parent.cui.message('目录修改成功。',"success");
						}
					}else{
						if(strModuleType==1){
							window.parent.cui.message('系统修改失败。',"error");
						}else if(strModuleType ==3){
							window.parent.cui.message('目录修改失败。',"error");
						}
					}
				});
				dwr.TOPEngine.setAsync(true);
			}
		}
	}

	//树形结构展示
	function showTree() {
		parent.cui('#keyword').setValue('');
		parent.$('#fastQueryList').hide();
		parent.$('#moduleTree').show();
		parent.addType = '';
	}

	//只能为 英文、数字、下划线
	function checkModuleCode(data) {
		if(data){
			var reg = new RegExp("^[A-Za-z0-9_]+$");
			return (reg.test(data));
		}
		return true;
	}
	
	/**     
	 * 只能为汉字、数字、字母、下划线
	 */     
	function checkName(data) {  
		var flag = true;
		if(data == null || data == ''){
			return flag;
		}
		var patrn = /^[\uff08 \uff09 \u0028 \u0029\u4E00-\u9FA5A-Za-z0-9_/\(（\)）]+$/; 
		if (!patrn.exec(data)) flag= false;
		return flag;
	}

	/**
	* function:检测系统目录名称是否唯一
	*/
	function checkNameUnique(data){
		var flag = true;
		var moduleVO = {moduleName:data,parentModuleId:parentModuleId,moduleId:inputModuleId};
		if(insertFlag == 1) {
			moduleVO.parentModuleId = cui("#parentModuleId").getValue();
			moduleVO.moduleId = '';
		}
		if(data!=""){
			dwr.TOPEngine.setAsync(false);
			ModuleAction.isModuleNameExist(moduleVO,function(result){
				if(result){
					flag = false;
				}else{
					flag = true;
				}			
			});
			dwr.TOPEngine.setAsync(true);
		}
		return flag;
	}

	/**
	* function:检测编码是否唯一
	*/
	function checkCodeUnique(data){
		var flag = true;
		if(insertFlag == 2) {
			return flag;
		}
		var moduleDTO = {moduleCode:data,parentModuleId:parentModuleId};
		if(insertFlag == 1) {
			moduleDTO.parentModuleId = cui("#parentModuleId").getValue();
		}
		dwr.TOPEngine.setAsync(false);
		if(data != ""){
			ModuleAction.isModuleCodeExist(moduleDTO,function(result){
				if(result){
					flag = false;
				}else{
					flag = true;
				}
			});
		}
		dwr.TOPEngine.setAsync(true);
		return flag;
	}

	// 删除系统或者目录
	function canDeleteModuleVO(){
		var vo = {moduleId:inputModuleId,parentModuleId:parentModuleId};
		var moduleVO = cui(data).databind().getValue();
		var strModuleType = moduleVO.moduleType;
		var isHasChildren = "false";
		var deleteMessage = "";
		dwr.TOPEngine.setAsync(false);
		ModuleAction.hasSubModule(inputModuleId,function(data){
			isHasChildren = data.isDelete;
			deleteMessage = data.deleteMessage;
			
		});
		dwr.TOPEngine.setAsync(true);
		if(moduleVO.moduleType == 3&&isHasChildren =="true"&&deleteMessage!=""&&deleteMessage!=null){
			cui.warn("无法删除该目录，该目录下存在子"+deleteMessage);
			return false;
		}
		if(moduleVO.moduleType == 2&&isHasChildren =="true"&&deleteMessage!=""&&deleteMessage!=null){
			cui.warn("无法删除该应用，该应用下存在子"+deleteMessage);
			return false;
		}
		
		if(moduleVO.moduleType == 1&&isHasChildren =="true"&&deleteMessage!=""&&deleteMessage!=null){
			cui.warn("无法删除该系统，该系统下存在子"+deleteMessage);
			return false;
		}
		if(isHasChildren =="true"&& moduleVO.moduleType == 3) {
			cui.warn("无法删除该目录，该目录下存在子目录或子应用");
			return false;
		}
		if(isHasChildren =="true"&& moduleVO.moduleType == 2) {
			cui.warn("无法删除该应用，该应用下存在子应用。");
			return false;
		}
		if(isHasChildren =="true"&& moduleVO.moduleType == 1) {
			cui.warn("无法删除该系统，该系统下存在子系统，子目录或子应用。");
			return false;
		}

		cui.confirm("确定要删除这条数据吗？",{
			onYes: function(){
				dwr.TOPEngine.setAsync(false);
				ModuleAction.deleteModuleVO(vo,function(){
					if(strModuleType==1){
						window.parent.cui.message('系统删除成功。',"success");
					}else if(strModuleType ==3){
						window.parent.cui.message('目录删除成功。',"success");
					}
				});
				dwr.TOPEngine.setAsync(true);
				delRefresh(inputModuleId,parentModuleId);
			}
		}); 
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
		var isHasChildren = "false";
		dwr.TOPEngine.setAsync(false);
		ModuleAction.hasSubModule(parentModuleId,function(data){
			isHasChildren = data;
		});
		dwr.TOPEngine.setAsync(true);
		if(isHasChildren.isDelete == "false") {
			pNode.setData("isFolder",false);
		} 
		parent.nodeUrl(parentModuleId);
	}

	//系统目录名称和编码的检测
	var validateModuleName = [
	      {'type':'required','rule':{'m':'名称不能为空。'}},
	      {'type':'custom','rule':{'against':checkName, 'm':'名称只能为汉字、数字、字母、下划线、正斜杠、中英文括号。'}},
	      {'type':'custom','rule':{'against':checkNameUnique, 'm':'名称不能重复。'}}
	    ],
	    validateModuleCode = [
	      {'type':'required','rule':{'m':'编码不能为空。'}},
	      {'type':'custom','rule':{'against':checkModuleCode, 'm':'编码只能为数字、字母、下划线。'}},
	      {'type':'custom','rule':{'against':checkCodeUnique, 'm':'编码不能重复。'}}
	    ],
	    data={};
	
	//新增下级
 	var insertSub = {
 	    	datasource: [
 	            {id:'insertSubSys',label:'新增下级系统'},
 	            {id:'insertSubDirectory',label:'新增下级目录'},
 	            {id:'insertSubApplication',label:'新增下级应用'},
 	        ],
 	        on_click:function(obj){
 	        	if(obj.id=='insertSubSys'){
 	        		insertSubSysOrDirectory(1);
 	        	}else if(obj.id=='insertSubDirectory'){
 	        		insertSubSysOrDirectory(3);
 	        	}else if(obj.id=='insertSubApplication'){
 	        		insertSubApplication();
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
 	     	        		insertSameApplication();
 	    	        	}
 	     	        }
 	     	    };
	
	</script>
</body>
</html>