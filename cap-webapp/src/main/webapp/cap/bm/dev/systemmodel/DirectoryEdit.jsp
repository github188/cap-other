<%
  /**********************************************************************
	* CUI系统建模: 目录编辑 
	* 2013-10-30 沈康 新建 
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!doctype html>
<html>
<head>
	<title>目录编辑页面</title>
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_sys.css" type="text/css">
	<top:link  href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
	<top:link  href="/eic/css/eic.css"/>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/top/js/jquery.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/eic/js/comtop.ui.emDialog.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/eic/js/comtop.eic.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/engine.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/util.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/SystemModelAction.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/DocumentAction.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/SystemModuleAction.js'></script>
</head>
<style>
	.top_header_wrap{
		padding-right:5px;
	}
	.form_table_style{
		width:100%;
		table-layout:fixed;
	}

	.form_table_style td{
		line-height:22px;
		padding:2px 5px 8px 3px;
	}
</style>
<body>
<div uitype="Borderlayout"  id="body" is_root="true">	
	<div class="top_header_wrap" style="padding-top:3px">
		<div class="thw_title">
			<font id = "pageTittle" class="fontTitle">目录信息编辑</font> 
		</div>
		<div class="thw_operate">
		<span uitype="button" id="exportWord" label="导出文档"  menu="exportWord" ></span>
		<span uitype="button" id="new_same" label="新增同级"  menu="insertSame" ></span>
		<span uitype="button" id="new_sub" label="新增下级"  menu="insertSub"></span>
		<span uitype="button" id="view_model" label="查看模型"  on_click="viewModel" ></span>
		<span uitype="button" id="moveBnt" label="移动"  on_click="moveSystem" ></span>
		<span uitype="button" label="编辑" id="updBtn" on_click="updateSysModule"></span>
		<span uitype="button" id="save" label="保存"  on_click="save" ></span>
		<span uitype="button" id="delete" label="删除"  on_click="canDeleteModuleVO" ></span>
		<span uitype="button" id="back_to" label="返回"  on_click="backTo" ></span>
		</div>
		
	</div>
	<div class="cui_ext_textmode" >
		<table class="form_table_style" style="table-layout:fixed;">
			<colgroup>
				<col width="15%" />
				<col width="85%" />
			</colgroup>
	        <tr>
	            <td class="td_label"> <span id="requiredName" class="top_required">*</span>上级名称：</td>
	            <td>
	                <span uitype="input" name="parentName" id="parentName" databind="data.parentName" width="440px" readonly="true"></span>
					<span uitype="input" id="parentModuleId" name="parentModuleId" databind="data.parentModuleId" readonly="true"></span>	
	            </td>
	        </tr>
	        <tr>
	            <td class="td_label"> <span id="requiredName" class="top_required">*</span>名称：</td>
	            <td>
	               <span uitype="input" id="moduleName" name="moduleName" databind="data.moduleName" maxlength="36" width="440px" emptytext="请输入..."
	                validate="validateModuleName">
	                </span>
	            </td>
	        </tr>
	        <tr>
	        	<td class="td_label"><span id="requiredModuleCode" class="top_required">*</span>编码：</td>
				<td>
					<span uitype="input" id="moduleCode" name="moduleCode" databind="data.moduleCode" maxlength="28" width="440px" emptytext="请输入..."
	               validate="validateModuleCode" ></span>
				</td>
	        </tr>	        
			<tr> 
				<td class="td_label" valign="top">描述：</td>
				<td class="td_content">
				<div style="width:440px;">
					<span uitype="textarea" id="description" name="description" width="428px" databind="data.description" 
						 maxlength="500" relation="remarkLength" ></span>
					<div style="float:right">
						<font id="applyRemarkLengthFont" >(您还能输入<label id="remarkLength" style="color:red;"></label>&nbsp; 字符)</font>
					</div>
				</div>
				</td>
			</tr>
			<tr> 
				<td class="td_label" valign="top">功能(子)项：</td>
				<td>
					<div style="float:left;">
						<table uitype="Grid" id="FuncItemGrid" primarykey="id" sorttype="1" colrender="funcItemRender" datasource="initFuncItemData" pagination="false"  pagesize_list="[1,2,3]"  
						 	adaptive="true" resizeheight="resizeHeight" selectrows="multi">
						 	<tr>
						 		<th style="width: 30px"><input type="checkbox"></th>
								<th bindName="id"  renderStyle="text-align: left;">编码</th>
								<th bindName="name"  renderStyle="text-align: left;" >名称</th>
								<th bindName="type" renderStyle="text-align: center;" width="100px">类型</th>
							</tr>
						</table>
					</div>
					<div id="funcItemDiv">
						&nbsp;&nbsp;&nbsp;
						<span uitype="button" id="funcItemLabel" label="选&nbsp;&nbsp;择" on_click="funcItemSelect"></span>
						<br><br>
						&nbsp;&nbsp;&nbsp;
						<span uitype="button" id="funcItemDeleteLabel" label="删&nbsp;&nbsp;除" on_click="funcItemDelete"></span>
						<br><br>
						&nbsp;&nbsp;&nbsp;
						<span uitype="button" id="funcItemCleanLabel" label="清&nbsp;&nbsp;空" on_click="funcItemClean"></span>
					</div>
				</td>
			</tr>
		</table>
	</div>
</div>

	<script type="text/javascript">
		var nodeId = "${param.nodeId}";
		var parentNodeId = "${param.parentNodeId}";
		var parentNodeName = "${param.parentNodeName}";
		var insertFlag = 2;//保存时需要判断是新增保存还是更新保存,1表示新增，2表示更新 
		var actionType = "${param.actionType}";
		var moduleTypeVal = "${param.moduleType}";
		var parentModuleType = "${param.parentModuleType}";
		var backId = "${param.backId}";
		var testModel = "${param.testModel}";
		
		//目录名称和编码的检测 
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
		    data = {};
		
		//功能项类型渲染函数
		 function funcItemRender(rowData, bindName) {
		        var value;
		        if (bindName == "type") {
		            value = rowData[bindName];
		            if (value == 1) {
		                return "业务域";
		            }else if (value == 2) {
		                return "功能项";
		            }else if(value == 3){
		            	 return "功能子项";
		            }else{
		            	return "未定义";
		            }
		        }
		  }
		
		//grid数据源
		function initFuncItemData(tableObj,query){
			dwr.TOPEngine.setAsync(false);
			SystemModuleAction.queryReqTreeVOByModuleId(data.moduleCode,function(res){
				tableObj.setDatasource(res, res.length);
			});
			dwr.TOPEngine.setAsync(true);
		}
		
		//打开功能(子)项选择界面
		function funcItemSelect(){
			var data = cui("#FuncItemGrid").getData();
			var selectedFuncItems = "";
			if(data && data.length>0){
				for(var i = 0 ; i< data.length ; i++ ){
					if(i == data.length-1){
						selectedFuncItems = selectedFuncItems+data[i].id;
					}else{
						selectedFuncItems = selectedFuncItems+data[i].id +",";
					}
				}
			}
			var url = "<%=request.getContextPath() %>/cap/bm/req/func/ReqFunItemTreeMulChoose.jsp?selectedData="+selectedFuncItems+"&callSelectedFuncItemFlag=true";
			var height = 550;
			var width = 325;
			var iTop = (window.screen.availHeight - 30 - height) / 2; // 获得窗口的垂直位置;
			var iLeft = (window.screen.availWidth - 10 - width) / 2; // 获得窗口的水平位置;
			window.open(url,"funcItemSelectWin", 'height=' + height + ',width=' + width + ',top=' + iTop + ',left=' + iLeft + ',toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no,status=no');
		}
		
		//清空功能项
		function funcItemClean(){
			cui("#FuncItemGrid").setDatasource([],0);
		}
		
		//功能(子)项选择回调
		function chooseFunItemCallBack(funItemList){
			var ds = [];
			for(var i=0;i<funItemList.length;i++){
    			var item={'id':funItemList[i].key,'name':funItemList[i].title,'type':funItemList[i].type};
    			ds[i] = item;
	    	}
			cui("#FuncItemGrid").setDatasource(ds, ds.length);
		}
		
		//grid高度
		function resizeHeight(){
			return (document.documentElement.clientHeight || document.body.clientHeight) - 500;
		}
		
		//导出文档 
		var exportWord = {
		    	datasource: [
		     	            {id:'exportHLD',label:'概要设计说明书'},
		     	            {id:'exportLLD',label:'详细设计说明书'},
		     	            {id:'exportDBD',label:'数据库设计说明书'}
		     	        ],
				on_click:function(obj){
		     	        	if(obj.id=='exportHLD'){
		     	        		exportWordMain('HLD');
		     	        	}else if(obj.id=='exportLLD'){
		     	        		exportWordMain('LLD');
		     	        	}else if(obj.id=='exportDBD'){
		     	        		exportWordMain('DBD');
		    	        	}
				}
		};
		
		function viewModel(){
			window.open("<%=request.getContextPath() %>/cap/bm/graph/ModuleRelationGraphMain.jsp?moduleId=" + nodeId + "&returnUrl=" + encodeURIComponent(window.location.href), "_self");
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
			var patrn = /^[\u4E00-\u9FA5A-Za-z0-9_/\(（\)）]+$/; 
			if (!patrn.exec(data)) flag= false;
			return flag;
		}

		/**
		* function:检测系统目录名称是否唯一
		*/
		function checkNameUnique(data){
			var flag = true;
			var moduleVO = {moduleName:data,parentModuleId:parentNodeId,moduleId:nodeId};
			if(insertFlag == 1) {
				moduleVO.parentModuleId = cui("#parentModuleId").getValue();
				moduleVO.moduleId = '';
			}
			if(data!=""){
				dwr.TOPEngine.setAsync(false);
				SystemModelAction.isModuleNameExist(moduleVO,function(result){
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
			var moduleDTO = {moduleCode:data,parentModuleId:parentNodeId};
			if(insertFlag == 1) {
				moduleDTO.parentModuleId = cui("#parentModuleId").getValue();
			}
			dwr.TOPEngine.setAsync(false);
			if(data != ""){
				SystemModelAction.isModuleCodeExist(moduleDTO,function(result){
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
	
		$(document).ready(function() {
			var url = "<%=request.getContextPath() %>/cap/bm/doc/info/MonitorAsynTaskList.jsp?userId="+globalCapEmployeeId+"&init=true";
			initOpenBottomImage(url);
			if(actionType == 'add') { // 新增 
				comtop.UI.scan();
				insertFlag = 1;//表示新增 
				// 隐藏编辑、删除、删除按钮 
				cui("#updBtn").hide();
				cui("#delete").hide();
				cui('#new_same').hide();
				cui('#new_sub').hide();
				cui("#moveBnt").hide();
				cui("#view_model").hide();
			} else {
				dwr.TOPEngine.setAsync(false);
				SystemModelAction.getModuleInfo(nodeId,function(moduleData){
					cui(data).databind().setValue(moduleData);
					comtop.UI.scan();   //扫描
					// 初始化编辑页面
					//cui("#FuncItemGrid").loadData();
					//initFuncItemData(cui("#FuncItemGrid"),null);
					initEditPage(); 
				});
				dwr.TOPEngine.setAsync(true);
			}
			parentNodeName = decodeURIComponent(parentNodeName);
			cui('#parentModuleId').hide();
			cui('#parentName').setValue(parentNodeName);
			cui('#parentModuleId').setValue(parentNodeId);
			if(testModel == "testModel"){ //测试建模过来的页面，操作按钮屏蔽
				cui("#new_same").hide();
				cui("#new_sub").hide();
				cui("#moveBnt").hide();
				cui("#updBtn").hide();
				cui("#save").hide();
				cui("#delete").hide();
			}
		});
		
		// 初始化编辑页面 
		function initEditPage() {
			//设置标题 
			$('#pageTittle').html("目录信息");  
			comtop.UI.scan.setReadonly(true);
			//隐藏 *号
			cui('.top_required').hide();
			cui('#save').hide();
			$('#applyRemarkLengthFont').hide();
			cui('#parentModuleId').hide();
			cui('#back_to').hide();
			cui('#funcItemDiv').hide();
		} 
		
		// 编辑目录节点 
		function updateSysModule() {
			insertFlag = 2;//表示编辑
			backId = nodeId;
			comtop.UI.scan.setReadonly(false);
			//显示 *号
			cui('.top_required').show();
			$('#applyRemarkLengthFont').show();
			cui('#save').show();
			cui('#updBtn').hide();
			cui("#parentName").setReadonly(true);
			cui('#back_to').show();
			cui("#moduleCode").setReadonly(true);//top原需求，系统编码不能修改，为防止已使用对关联数据造成影响
			cui("#view_model").hide();
			cui("#funcItemDiv").show();
		}
		
		// 保存
		function save() {
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
				var moduleVO = cui(data).databind().getValue();
				moduleVO.moduleType = 3;
				if(insertFlag == 1){//新增 
					dwr.TOPEngine.setAsync(false);
					SystemModelAction.insertModuleVO(moduleVO,function(data){
						if(data && data.moduleId) {
							//隐藏listbox展示属性结构，定位到新增节点  
							showTree();
							//刷新树
							parent.addRefreshTree(data.moduleId,data.parentModuleId);
							dwr.TOPEngine.setAsync(false);
							SystemModuleAction.saveModuleFuncItem(moduleVO,cui("#FuncItemGrid").getData(),function(res){
								if(res){
									window.parent.cui.message('目录及功能项新增成功。',"success");
								}else{
									window.parent.cui.message('功能项新增失败。',"error");
								}
							});
							dwr.TOPEngine.setAsync(true);
						}else{
							window.parent.cui.message('目录新增失败。',"error");
						}
					});
					dwr.TOPEngine.setAsync(true);
				}else{//更新
					dwr.TOPEngine.setAsync(false);
					SystemModelAction.updateModuleVO(moduleVO,function(data){
						if(data && data.moduleId){
							// 定位到新增节点  
							showTree();
							parent.editRefreshTree(data.moduleId,data.parentModuleId,data.moduleName);
							dwr.TOPEngine.setAsync(false);
							SystemModuleAction.saveModuleFuncItem(moduleVO,cui("#FuncItemGrid").getData(),function(res){
								if(res){
									window.parent.cui.message('目录及功能项修改成功。',"success");
								}else{
									window.parent.cui.message('功能项修改失败。',"error");
								}
							});
							dwr.TOPEngine.setAsync(true);
						}else{
							window.parent.cui.message('目录修改失败。',"error");
						}
					});
					dwr.TOPEngine.setAsync(true);
				}
			}
		}
		
		// 删除目录
		function canDeleteModuleVO(){
			var vo = {moduleId:nodeId,moduleCode:data.moduleCode,parentModuleId:parentNodeId};
			var moduleVO = cui(data).databind().getValue();
			var strModuleType = moduleVO.moduleType;
			var isHasChildren = "false";
			var deleteMessage = "";
			dwr.TOPEngine.setAsync(false);
			SystemModelAction.hasSubModule(nodeId,function(data){
				isHasChildren = data.isDelete;
				deleteMessage = data.deleteMessage;
				
			});
			dwr.TOPEngine.setAsync(true);
			
			if(moduleVO.moduleType == 3&&isHasChildren =="true"&&deleteMessage!=""&&deleteMessage!=null){
				cui.warn("无法删除该目录，该目录下存在子"+deleteMessage);
				return false;
			}
			if(isHasChildren =="true"&& moduleVO.moduleType == 3) {
				cui.warn("无法删除该目录，该目录下存在子目录或子应用");
				return false;
			}

			cui.confirm("确定要删除这条数据吗？",{
				onYes: function(){
					dwr.TOPEngine.setAsync(false);
					SystemModelAction.deleteModuleVO(vo,function(){
						dwr.TOPEngine.setAsync(false);
						SystemModuleAction.deleteModuleFuncItem(vo,function(res){
							if(res){
								window.parent.cui.message('目录及功能项删除成功。',"success");
							}else{
								window.parent.cui.message('目录及功能项删除失败。',"error");
							}
						});
						dwr.TOPEngine.setAsync(true);
					});
					dwr.TOPEngine.setAsync(true);
					delRefresh(nodeId,parentNodeId);
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
			SystemModelAction.hasSubModule(parentModuleId,function(data){
				isHasChildren = data;
			});
			dwr.TOPEngine.setAsync(true);
			if(isHasChildren.isDelete == "false") {
				pNode.setData("isFolder",false);
			} 
			parent.nodeUrl(parentModuleId);
		}
		
		//树形结构展示
		function showTree() {
			parent.cui('#keyword').setValue('');
			parent.$('#fastQueryList').hide();
			parent.$('#moduleTree').show();
			//parent.addType = '';
		}

		//新增下级目录
		function insertSubDirectory() {
			updateSysModule();
			insertFlag = 1;//表示新增
			
			//字段处理
			var moduleNameVal = cui('#moduleName').getValue();
			cui(data).databind().setEmpty();
			funcItemClean();
			cui('#parentName').setValue(moduleNameVal);//设置上级名称字段
			cui('#parentModuleId').setValue(nodeId);
			cui("#moduleCode").setReadonly(false);
			
			// 按钮处理
			cui('#new_sub').hide();
			cui('#new_same').hide();
			cui('#delete').hide();
			cui("#moveBnt").hide();
			
			backId = nodeId;
		}

		//新增下级系统或应用  
		function insertSubSysOrApp(nodeType) {
			var moduleNameVal = cui('#moduleName').getValue();
			if(moduleNameVal!="undefined"&&moduleNameVal!=null&&moduleNameVal!="null"){
				moduleNameVal = encodeURIComponent(encodeURIComponent(moduleNameVal));
			}
			
			var parentModuleType = moduleTypeVal;
			if(nodeType == 1) {
				window.parent.cui('#body').setContentURL("center","<%=request.getContextPath() %>/cap/bm/dev/systemmodel/SystemModuleEdit.jsp?actionType=add&parentNodeId=" + nodeId + "&parentNodeName=" + moduleNameVal
						+ "&actionType=add" + "&parentModuleType=" + parentModuleType + "&backId=" + nodeId); 
			}
			if(nodeType == 2) {
				window.parent.cui('#body').setContentURL("center","<%=request.getContextPath() %>/cap/bm/dev/systemmodel/FuncModelEdit.jsp?actionType=add&parentNodeId=" + nodeId + "&parentNodeName=" + moduleNameVal
						+ "&actionType=add" + "&parentModuleType=" + parentModuleType + "&backId=" + nodeId);  
			}
		}

		//新增下级 
		var insertSub = {
			datasource : [ {
				id : 'insertSubSys',
				label : '新增下级系统'
			}, {
				id : 'insertSubDirectory',
				label : '新增下级目录'
			}, {
				id : 'insertSubApplication',
				label : '新增下级应用'
			}, ],
			on_click : function(obj) {
				if (obj.id == 'insertSubSys') {
					insertSubSysOrApp(1);
				} else if (obj.id == 'insertSubDirectory') {
					insertSubDirectory();
				} else if (obj.id == 'insertSubApplication') {
					insertSubSysOrApp(2);
				}
			}
		};
		
		// 新增同级目录
		function insertSameDirectory() {
			updateSysModule();
			insertFlag = 1;//表示新增
			
			//字段处理
			cui(data).databind().setEmpty();
			funcItemClean();
			cui('#parentName').setValue(parentNodeName);//设置上级名称字段
			cui('#parentModuleId').setValue(parentNodeId);
			cui("#moduleCode").setReadonly(false);
			
			// 按钮处理
			cui('#new_sub').hide();
			cui("#new_same").hide();
			cui('#delete').hide();
			cui("#moveBnt").hide();
			
			backId = nodeId;
		}
		
		// 新增同级系统和应用  
		function insertSameSysOrApp(nodeType) {
			var parentNameVal =  parentNodeName;
			if(parentNameVal!="undefined"&&parentNameVal!=null&&parentNameVal!="null"){
				parentNameVal = encodeURIComponent(encodeURIComponent(parentNameVal));
			}
			
			if(nodeType == 1) {
				window.parent.cui('#body').setContentURL("center","<%=request.getContextPath() %>/cap/bm/dev/systemmodel/SystemModuleEdit.jsp?parentNodeId=" + parentNodeId + "&parentNodeName=" + parentNameVal
						+ "&actionType=add" + "&parentModuleType=" + parentModuleType  + "&backId=" + nodeId); 
			}
				
			if(nodeType == 2) {
				window.parent.cui('#body').setContentURL("center","<%=request.getContextPath() %>/cap/bm/dev/systemmodel/FuncModelEdit.jsp?parentNodeId=" + parentNodeId + "&parentNodeName=" + parentNameVal
						+ "&actionType=add" + "&parentModuleType=" + parentModuleType + "&backId=" + nodeId);  
			}
		}
		
		//新增同级
	 	var insertSame = {
	 	    	datasource: [
	 	     	            {id:'insertSameSys',label:'新增同级系统'},
	 	     	            {id:'insertSameDirectory',label:'新增同级目录'},
	 	     	            {id:'insertSameApplication',label:'新增同级应用'},
	 	     	        ],
	 	     	        on_click:function(obj){
	 	     	        	if(obj.id=='insertSameSys'){
	 	     	        		insertSameSysOrApp(1);
	 	     	        	}else if(obj.id=='insertSameDirectory'){
	 	     	        		insertSameDirectory();
	 	     	        	}else if(obj.id=='insertSameApplication'){
	 	     	        		insertSameSysOrApp(2);
	 	    	        	}
	 	     	        }
	 	     	    };
		
	 	// 返回
		function backTo(){
			window.parent.nodeUrl(backId);	
		}
		var dialog = null;
		//移动
		function moveSystem(){
			var url = "MoveSystemModel.jsp?moveObjId="+nodeId;
			
			dialog = cui.dialog({
				title : "请选择移动目的地",
				src : url,
				width : 365,
				height : 600
			})
			dialog.show(url);
		}
		
		function moveSystemCallBack(moveObj){
			window.parent.location.href =  "SystemModelMain.jsp?moveObjId="+moveObj.moduleId;
			dialog.hide();
		}
		
		//导出文档
		function exportWordMain(type){
			dwr.TOPEngine.setAsync(false);
			DocumentAction.exportDocumentOutDoc(nodeId,type,function(result){
				var code = result.code;
				if("Success" === code){
					cui.success(result.message);
				}else if("Error" === code){
					cui.warn(result.message);
				}else{
					cui.alert(result.message);
				}
			});
			dwr.TOPEngine.setAsync(true);
		}
		
		//删除功能项 
		function funcItemDelete(){
			var selectedIndex = cui("#FuncItemGrid").getSelectedIndex();
			if(selectedIndex==null || selectedIndex.length==0){
				cui.alert("请选择需要删除的数据。");
				return ;
			}
			cui("#FuncItemGrid").removeData(selectedIndex);
			cui.message("删除成功。","success");
		}
		
	</script>
</body>
</html>