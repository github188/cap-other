<%
/**********************************************************************
* CUI系统建模:应用编辑 
* 2014-10-30 沈康  新建
**********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<!doctype html>
<html>
<head>
<title>应用编辑页</title>
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
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/FuncModelAction.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/SystemModelAction.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/DocumentAction.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/SystemModuleAction.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/SyncMetadataFacade.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/SysmodelFacade.js'></script>
<style type="text/css">
 .imgMiddle {line-height:350px;text-align:center;}
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
</head>
<body onload="window.status='Finished';">
<div uitype="Borderlayout"  id="body" is_root="true">
	<div class="top_header_wrap" style="padding-top:3px">
		<div class="thw_title">
			<font id = "pageTittle" class="fontTitle">编辑应用信息</font> 
		</div>
		<div class="thw_operate">
			<span uitype="button" id="exportWord" label="导出文档"  menu="exportWord" ></span>
			<span uitype="button" id="new_same" label="新增同级"  menu="insertSame" ></span>
			<span uitype="button" id="new_sub" label="新增下级"  menu="insertSub"></span>
			<span uitype="button" id="view_model" label="查看模型"  menu="viewModel" ></span>
			<span uitype="button" id="moveBnt" label="移动"  on_click="moveSystem" ></span>
			<span uitype="button" id="upload" label="pdm导入"  on_click="upload" ></span>
			<span uitype="button" id="exportPdm" label="pdm导出"  on_click="exportPdm" ></span>
			<span uitype="button" label="编辑" id="updBtn" on_click="updateFunc"></span>
			<span uitype="button" label="保存" id="saveBtn" on_click="saveFunc"></span>
			<span uitype="button" label="删除" id="delBtn" on_click="delFunc"></span>
			<span uitype="button" id="back_to" label="返回"  on_click="backTo" ></span>
			<span uitype="Button" id="returnEditEntity" label="元数据" button_type="green-button" icon="reply" on_click="returnEditEntity"></span>
		</div>
	</div>
	<div class="cui_ext_textmode">
			<table class="form_table_style">
					<colgroup>
						<col width="15%" />
						<col width="85%" />
					</colgroup>
					<tr>
						<td class="td_label" width="20%"><span class="top_required">*</span><span id="nodeNameText"></span>应用名称：</td>
						<td class="td_content" width="30%" >
							<span uitype="input" id="funcName" name="funcName" databind="funcData.funcName"  width="240" maxlength="36" emptytext="请输入..."
								validate="[{'type':'required','rule':{'m':'请输入应用名称。'}}, {'type':'custom','rule':{'against':'checkName','m':'应用名称只能为汉字、数字、字母、下划线。'}}, {'type':'custom','rule':{'against':'isExistRename','m':'名称已被占用。'}}]"
							></span>
						</td>
					</tr>
					<tr id="hideElement" style="display: none;">
						<td class="td_label" width="20%"> <span class="top_required">*</span>应用状态：</td>
						<td>
							<span uitype="RadioGroup" name="status" id="status" value="1"  databind="funcData.status" validate="请选择应用状态。"> 
								<input type="radio" name="status" value="1"/>启用
                				<input type="radio" name="status" value="2"/>禁用
							</span> 
						</td>
					</tr>
					<tr style="display: none;">
						<td class="td_label" width="10%"> <span class="top_required">*</span>需要授权：</td>
						<td>
							<span uitype="RadioGroup" name="permissionType" id="permissionType" value="2"  databind="funcData.permissionType" validate="请选择是否需要授权。"> 
								<input type="radio" name="permissionType" value="2"/>是
                				<input type="radio" name="permissionType" value="1"/>否
							</span> 
						</td> 
					</tr>
					<tr>
						<td class="td_label" ><span class="top_required">*</span><span id="nodeCodeText"></span>应用编码：</td>
						<td class="td_content">
							<span uitype="input" id="funcCode" name="funcCode" databind="funcData.funcCode"  width="240" maxlength="28" emptytext="请输入..."
								validate="[{'type':'required','rule':{'m':'请输入应用编码。'}}, {'type':'custom','rule':{'against':'checkCode','m':'应用编码只能为数字、字母、下划线。'}}, {'type':'custom','rule':{'against':'isExistCode','m':'编码已被占用。'}}]"></span>
						</td>
					</tr>
					<tr>
						<td class="td_label"  ><span class="top_required">*</span>上级名称：</td>
						<td class="td_content">
							<span uitype="input" id="parentFuncName" name="parentFuncName" width="240" databind="funcData.parentFuncName" readonly="true"></span>
						</td>
					</tr>
					<tr>
			        	<td class="td_label"><span class="top_required">*</span>包路径：</td>
						<td>
							<span uitype="input" id="fullPath" name="fullPath" databind="funcData.fullPath" align="left" maxlength="50" width="365px" validate="validateFullPathName"></span>
							&nbsp;<span id="edit-fullPath-icon" class="cui-icon" title="编辑包路径" style="cursor:pointer; padding-right:10px; display: none" onclick="openFullPathEditState()">&#xf040;</span>	
						</td>
			        </tr>
			        <tr>
			        	<td class="td_label">实体代码工程路径：</td>
						<td><span uitype="input" id="javaCodePath" name="javaCodePath" databind="capPackageData.javaCodePath" align="left" width="365px" validate="validateJavaCodePathName"/></td>
			        </tr>
			        <tr>
			        	<td class="td_label">页面代码工程路径：</td>
						<td><span uitype="input" id="pagePath" name="pagePath" databind="capPackageData.pagePath" align="left" width="365px" validate="validatePagePathName"/></td>
			        </tr>
					<!-- <tr>
			        	<td class="td_label"><span class="top_required">*</span>简称：</td>
						<td>
							<span uitype="input" id="shortName" name="shortName" databind="funcData.shortName" width="240" maxlength="15" emptytext="请输入..." validate="validateShortName"></span>
							<span id="shortNamePS"><font style="color: #B5B5B5">用于生成数据库表前缀，不区分大小写，如：fwms</font></span>
						</td>
			        </tr> -->
					<!-- <tr>
						<td class="td_label">应用分类：</td>
						<td class="td_content" >
							<span id="funcTag" uitype="CheckboxGroup" name="funcTag" checkbox_list="ajaxData" databind="funcData.funcTag" ></span>
						</td>
					</tr> -->
					<tr>
						<td class="td_label">图标地址：</td>
						<td class="td_content" >
							<span uitype="input" id="menuIconUrl" name="menuIconUrl"  databind="funcData.menuIconUrl"  maxlength="200" emptytext="请输入..."
								 validate="[{'type':'custom', 'rule':{'against':'checkURL', 'm':'图标地址不能输入中文。'}}]"
								 width="440"></span>
						</td>
					</tr>
					<tr>
						<td class="td_label" valign="top">描述：</td>
						<td class="td_content" >
							<div style="width:440px;">
								<span uitype="textarea" name="description" databind="funcData.description" 
									relation="remarkLength" maxlength="500" width="428"></span>
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

<!-- js脚本 -->
<script type="text/javascript">
	//var nodeId = "${param.nodeId}";

	//获得请求方式 add 新增 edit 修改
	var actionType = "${param.actionType}";
	//模块ID
	var moduleId = "${param.nodeId}";
	//模块名称
	var moduleName = decodeURIComponent(decodeURIComponent("${param.moduleName}"));
	//返回ID
	var backId = "${param.backId}";
	//父节点ID
	var parentModuleId = "${param.parentNodeId}";
	//父节点名称
	var parentModuleName = decodeURIComponent(decodeURIComponent("${param.parentNodeName}"));
	//父节点类型
	var parentModuleType = "${param.parentModuleType}";
	//测试建模 
	var testModel = "${param.testModel}";
	
	//节点状态
	var nodeStatus = 0;
	var nodePermission = 0;
	
	//是否能正常启用
	var isUsing = true;
	var regEx = "^(?![0-9_])[a-zA-Z0-9_]+$";
	var backId = "${param.backId}";
	
	var validateShortName = [
      {'type':'required','rule':{'m':'简称不能为空。'}},
      {'type':'custom','rule':{'against':checkShortName, 'm':'简称只能为数字、字母、下划线，且必须以英文字符开头'}}
    ],
    funcData = {}; 
    capPackageData = {};
	
	var validateFullPathName = [
	                         {'type':'custom','rule':{'against':checkRequire, 'm':'包路径不能为空，且需要为com.comtop.xxx的形式！'}},
	                         {'type':'custom','rule':{'against':checkFullPathName, 'm':'包路径只能为数字、小写字母、下划线、英文句点，且必须以英文字符开头'}},
	                         {'type':'custom','rule':{'against':isExistPackageFullPath, 'm':'包路径已存在'}}
	                       ]
	
	var validateJavaCodePathName= [
	                               {'type':'custom','rule':{'against':checkJavaCodePathName, 'm':'路径必须为本地文件夹路径'}}
	                               ]
	var validatePagePathName= [
	                               {'type':'custom','rule':{'against':checkPagePathName, 'm':'路径必须为本地文件夹路径'}}
	                               ]
	var viewModel = {
 	    	datasource: [{id:'viewResource',label:'查看资源图'},
			      		    {id:'viewClass',label:'查看类图'},
			      		    {id:'viewDatabase',label:'查看数据库ER图'}],
	 	     	        on_click:function(obj){
	 	     	        	if(obj.id=='viewResource'){
	 	     	        		window.open("<%=request.getContextPath() %>/cap/bm/graph/ClassRelationGraphMain.jsp?moduleId=" + moduleId + "&moduleName=" + moduleName +"&returnUrl=" + window.location.href, "_self");
	 	     	        	}else if(obj.id=='viewClass'){
	 	     	        		window.open("<%=request.getContextPath() %>/cap/bm/graph/ClassOnlyGraphMain.jsp?moduleId=" + moduleId + "&moduleName=" + moduleName +"&returnUrl=" + window.location.href, "_self");
	 	     	        	}else if(obj.id=='viewDatabase'){
	 	     	        		window.open("<%=request.getContextPath() %>/cap/bm/graph/ERGraphMain.jsp?moduleId=" + moduleId + "&moduleName=" + moduleName +"&returnUrl=" + window.location.href, "_self");
	 	    	        	}
	 	     	        }
	 	     	    };	
	
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
		SystemModuleAction.queryReqTreeVOByModuleId(funcData.funcCode,function(res){
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
	
	//只能英文、数字、下划线，且以英文开头
	function checkShortName(data) {
		if(data){
			var reg = new RegExp(regEx);
			return (reg.test(data));
		}
		return true;
	}
	
	function checkRequire(data){
		var flag = true;
		if(data.length < 12){
			flag = false;
		}
		if(data.substr(0,10) != "com.comtop"){
			flag = false;
		}
		return flag;
	}
	
	//只能英文、数字、下划线、英文句点，且以英文开头
	function checkFullPathName(data) {
		if(data){
			var reg = new RegExp("^(?![._0-9_])[a-z0-9_.]+$");
			return (reg.test(data));
		}
		return true;
	}
	
	//获取应用分类信息
	function ajaxData(obj){
		dwr.TOPEngine.setAsync(false);
		FuncModelAction.getFuncTagList(function(data){
			obj.setDatasource(data);
		});
	}
	
	$(document).ready(function (){
		var url = "<%=request.getContextPath() %>/cap/bm/doc/info/MonitorAsynTaskList.jsp?userId="+globalCapEmployeeId+"&init=true";
		initOpenBottomImage(url);
		if(actionType == 'add'){
			//新增要初始化部分数据
			cui('#new_same').hide();
			cui('#new_sub').hide();
			cui('#delBtn').hide();
			cui("#moveBnt").hide();
			funcData["parentFuncId"]= parentModuleId;
			funcData["parentFuncType"] = "MODULE";
			funcData["funcNodeType"] = 3;
			funcData["permissionType"] = 2;
			funcData["parentFuncName"] = parentModuleName;
			funcData["status"] = 1;
			funcData["fullPath"] = "com.comtop.";
			cui("#view_model").hide();
		}else{
			dwr.TOPEngine.setAsync(false);
			FuncModelAction.readFuncByModuleId(moduleId, function(data){
				
				//替换掉com.comtop.便于显示
				//data.fullPath = data.fullPath.replace("com.comtop.","");
				cui(funcData).databind().setValue(data);
				funcData.parentFuncName = parentModuleName;
				funcData["oldfullPath"] = funcData["fullPath"];
				var modelId = funcData.fullPath+".package."+funcData.funcCode;
				readCapPackageInfoModuleVOById(modelId);//获取新增俩个属性的路径
				//得到应用节点状态及授权状态
				nodeStatus = data.status;
				if(nodeStatus == 2){
					//如果当前节点状态是禁用，则需判断其父节点应用状态是否为禁用
					FuncModelAction.readFuncByModuleId(parentModuleId, function(data1){
						if(data1 != null && data1.status == 2){
							//表示当前节点的父节点也是一个禁用的应用，此处不应该让其应用状态可以变成启用
							isUsing = false;
						}
					});
				}
				//funcData.funcTag = convertTagToArray(funcData.funcTag);
				nodePermission = data.permissionType;
			});		
			dwr.TOPEngine.setAsync(true);	
		}
		comtop.UI.scan();
		cui("#parentFuncName").setReadonly(true);
		if(actionType == 'edit'){
			cui("#funcCode").setReadonly(true);
		}
		if(testModel == "testModel"){ //测试建模过来的页面，操作按钮屏蔽
			cui("#new_same").hide();
			cui("#new_sub").hide();
			cui("#moveBnt").hide();
			cui("#upload").hide();
			cui("#updBtn").hide();
			cui("#saveBtn").hide();
			cui("#delBtn").hide();
		}
		init();
	});
	
	
	//包路径发生变更，该包下的元数据数据也要做相应同步修改操作
	function syncMetadataOperate(newfullPath, oldfullPath){
		var result = false;
		dwr.TOPEngine.setAsync(false);
		SyncMetadataFacade.syncOperate(newfullPath, oldfullPath, function(data){
			result = data;
		});
		dwr.TOPEngine.setAsync(true);
		return result;
	}
	
	//删除元数据
	function deleteMetadata(oldfullPath){
		var result = false;
		dwr.TOPEngine.setAsync(false);
		SyncMetadataFacade.deleteMetadataByPackage(oldfullPath, function(data){
			result = data;
		});
		dwr.TOPEngine.setAsync(true);
		return result;
	}
	
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
 	
 	//新增下级应用
 	function insertSubAppliation(){
 		var moduleName = funcData.funcName;
 		var url = "FuncModelEdit.jsp?actionType=add&backId=" + moduleId + "&parentNodeId=" + moduleId 
 				+ "&parentNodeName="+encodeURIComponent(encodeURIComponent(moduleName)) + "&parentModuleType=" + parentModuleType;
 		window.location.href = url;
 	}

	//新增同级
	function insertSameSysOrDirectory(nodeType){
		var url = "";
		//新增同级应用
		if(nodeType == 2){
			url = "FuncModelEdit.jsp?actionType=add&backId="+moduleId+"&parentNodeId="+parentModuleId+"&parentNodeName=" 
					+ encodeURIComponent(encodeURIComponent(parentModuleName)) + "&parentModuleType=" + parentModuleType;
		} else if(nodeType == 3) {
			url = "DirectoryEdit.jsp?actionType=add&moduleType="+nodeType+"&parentNodeId=" + 
					parentModuleId + "&parentNodeName=" + encodeURIComponent(encodeURIComponent(parentModuleName)) + 
					"&moduleId=" + moduleId + "&backId=" + moduleId;
		} else if(nodeType == 1) {
			url = "SystemModuleEdit.jsp?actionType=add&moduleType="+nodeType+"&parentNodeId=" + 
			parentModuleId + "&parentNodeName=" + encodeURIComponent(encodeURIComponent(parentModuleName)) + 
			"&moduleId=" + moduleId + "&backId=" + moduleId;
		}
		window.location.href = url;
	}
	
	/**
	* 弹出Pdm导入窗口.
	**/
	function upload(){
		var url = "<%=request.getContextPath() %>/cap/bm/dev/pdm/PdmUpload.jsp?packageId="+moduleId +"&parentNodeId=" + 
		parentModuleId + "&parentNodeName=" + encodeURIComponent(encodeURIComponent(parentModuleName)); 
		var title = "PDM导入";
		var height = 200; //300
		var width = 500; // 560;
		dialog = cui.dialog({
			title: title,
			src:url,
			width:width,
			height:height
		});
		dialog.show(); 
	}
	
	/**
	* 弹出Pdm导入窗口.
	**/
	function exportPdm(){
		  var url = '<cui:webRoot/>/cap/.pdmExport?packageId='+moduleId;
		  location.href = url;
	}
	
	//初始化应用资源列表链接
	function init(){
		var vo = cui(funcData).databind().getValue();
		if(actionType == 'add'){
			cui('#centerMain').hide();
			cui('#updBtn').hide();
			cui('#fullPath').setReadonly(false);
		}else{
			comtop.UI.scan.setReadonly(true);
			//如果当前节点状态为禁用时，默认隐藏掉所有的新增按钮
			if(nodeStatus == 2){
				cui('#new_same').hide();
				cui('#new_sub').hide();
				cui("#moveBnt").hide();
			}
			//隐藏 *号
			cui('.top_required').hide();
			$('#pageTittle').html("应用信息");
			$('#applyRemarkLengthFont').hide();
			cui('#saveBtn').hide();
			cui('#shortNamePS').hide();
			cui('#back_to').hide();
			//如果父节点是应用，下级只能建应用
			if(parentModuleType == 2){
				cui('#new_same').getMenu().disable("insertSameSys",true);
				cui('#new_same').getMenu().disable("insertSameDirectory",true);
			}else if(parentModuleType == 3){
				//如果父节点是目录，则下面只能建目录和应用
				cui('#new_same').getMenu().disable("insertSameSys",true);
			}
			cui('#funcItemDiv').hide();
		}
	}
	
	//编辑
	function updateFunc(){
		comtop.UI.scan.setReadonly(false);		
		cui('.top_required').show();
		cui('#shortNamePS').show();
		cui('#funcCode').setReadonly(true);
		cui('#fullPath').setReadonly(true);
		$("#edit-fullPath-icon").show()
		cui('#parentFuncName').setReadonly(true);
		if(isUsing == false){
			//编辑状态应用状态设置为不可选
			cui('#status').setReadonly(true);
		}
		$('#applyRemarkLengthFont').show();
		$('#pageTittle').html("编辑应用信息");
		cui('#saveBtn').show();
		cui('#updBtn').hide();
		cui('#back_to').show();
		backId = moduleId;
		cui("#view_model").hide();
		cui("#funcItemDiv").show();
	}
	
	//删除应用
	function delFunc(){
		var isHasChildren = "false";
		var deleteMessage = "";
		var isHasSomeInfo = "false";
		
		// 判断下级存在实体、表、服务、界面、常用数据类型、工作流等信息，否则不允许删除 
		dwr.TOPEngine.setAsync(false);
		FuncModelAction.hasSomeInfoByFunc(moduleId,function(data){
			isHasSomeInfo = data;
		});
		
		if(isHasSomeInfo == true) {
			cui.warn("无法删除该应用模块，该应用模块下存在实体、表、服务、界面、常用数据类型、工作流等信息");
			return false;	
		}
		
		//判断该应用下是否还有下级应用，如果有，则不允许删除
		dwr.TOPEngine.setAsync(false);
		SystemModelAction.hasSubModule(moduleId,function(data){
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
		FuncModelAction.getNoDelFuncId(selectData, function(data){
			if(data == null || data.length == 0){
				var msg = "确定要删除当前应用吗？";
				cui.confirm(msg, {
			        onYes: function () {
			        	var funcDTO = {};
						funcDTO.parentFuncId = moduleId;
						funcDTO.funcId = funcData.funcId;
						FuncModelAction.deleteFuncVOInModule(funcDTO, function(data){
							dwr.TOPEngine.setAsync(false);
							SystemModelAction.deleteModuleVO(funcDTO,function(){
								var moduleVO = {'moduleId':moduleId,'moduleName':funcData.funcName,'moduleCode':funcData.funcCode,'moduleType':2,'description':funcData.description};
								dwr.TOPEngine.setAsync(false);
								SystemModuleAction.deleteModuleFuncItem(moduleVO,function(res){
									if(res){
										var capPackageVO = cui(capPackageData).databind().getValue();
										deleteCapPackage4CodePath(capPackageVO);
										window.parent.cui.message('应用及功能项删除成功。',"success");
									}else{
										window.parent.cui.message('应用及功能项删除失败。',"error");
									}
								});
								dwr.TOPEngine.setAsync(true);
							});
							dwr.TOPEngine.setAsync(true);
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
		SystemModelAction.hasSubModule(parentModuleId,function(data){
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
			if(actionType == 'add'){
				dwr.TOPEngine.setAsync(false);
				//保存应用信息
				FuncModelAction.saveFuncVOInModule(vo, function(data){
					if(data) {
						//隐藏listbox展示属性结构，定位到新增节点  
						showTree();
						//刷新树
						//window.parent.cui.message('应用新增成功。',"success");
						parent.addRefreshTree(data, parentModuleId);
						var moduleVO = {'moduleId':moduleId,'moduleName':vo.funcName,'moduleCode':vo.funcCode,'moduleType':2,'description':vo.description};
						dwr.TOPEngine.setAsync(false);
						SystemModuleAction.saveModuleFuncItem(moduleVO,cui("#FuncItemGrid").getData(),function(res){
							if(res){
								saveCapPackage4CodePath(vo,"add");
								window.parent.cui.message('应用及功能项新增成功。',"success");
							}else{
								window.parent.cui.message('功能项新增失败。',"error");
							}
						});
						dwr.TOPEngine.setAsync(true);
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
					FuncModelAction.isHasNormalFunc(moduleId, function(data){
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
		moduleName = vo.funcName;
		var res = updateFuncVOInModuleApi(vo);
		//是否成功
		if(res){
			var message = '应用及功能项修改成功。';
			if(funcData.oldfullPath && funcData.oldfullPath != funcData.fullPath){
				res = syncMetadataOperate(funcData.fullPath, funcData.oldfullPath);
				if(!res){
					vo.fullPath = funcData.oldfullPath;
					res = updateFuncVOInModuleApi(vo);
					if(res){
						message = '功能项修改失败，因为当前包下的元数据信息迁移失败。';
					} else {
						message += '<br/>但旧包下的元数据信息迁移失败。'; 
					}
					window.parent.cui.message(message,"error");
				} else {
					cui.confirm('旧包下的元数据是否要删除？', {
			            onYes: function () {
			            	deleteMetadata(funcData.oldfullPath);
			            	executeParentMethod(moduleId, parentModuleId, moduleName);
			            	window.parent.cui.message(message,"success");
			            },
			            onNo: function () {
			            	executeParentMethod(moduleId, parentModuleId, moduleName);
			            	window.parent.cui.message(message,"success");
			            }
			        });
				} 
			} else {
				executeParentMethod(moduleId, parentModuleId, moduleName);
				window.parent.cui.message(message,"success");
			}
		}else{
			window.parent.cui.message('功能项修改失败。',"error");
		}
	}
	
	//修改应用信息
	function updateFuncVOInModuleApi(vo){
		var res = false;
		dwr.TOPEngine.setAsync(false);
		FuncModelAction.updateFuncVOInModule(vo, function(data){
			//隐藏listbox展示属性结构，定位到新增节点  
			nodeStatus = vo.status;
			nodePermission = vo.permissionType;
			var moduleVO = {'moduleId':moduleId,'moduleName':vo.funcName,'moduleCode':vo.funcCode,'moduleType':2,'description':vo.description};
			//根据模块id获取所对应的功能项及功能子项集合
			res = saveModuleFuncItemApi(moduleVO);
		});
		dwr.TOPEngine.setAsync(true);
		return res;
	}
	
	//保存新增的javaCodePath和pagePath到capPackageVO
	function saveCapPackage4CodePath(vo,operType){
		var capPackageVO = cui(capPackageData).databind().getValue();
		if (operType=='add') {
			capPackageVO.moduleCode = vo.funcCode;
			capPackageVO.modelPackage = vo.fullPath;
		}else{
			if(capPackageVO.moduleCode==null||''==capPackageVO.moduleCode){//用于原来没有数据保存时新增
				capPackageVO.moduleCode = vo.moduleCode;
				capPackageVO.modelPackage = funcData.fullPath;
			}
		}
		capPackageVO.moduleId = moduleId;
		var res = false;
		dwr.TOPEngine.setAsync(false);
		SystemModuleAction.saveCapPackage4CodePath(capPackageVO,function(_result){
			res = _result;
		});
		dwr.TOPEngine.setAsync(true);
		return res;
	}
	
	//根据modelId获取capPackageVO信息
	function readCapPackageInfoModuleVOById(modelId){
		dwr.TOPEngine.setAsync(false);
		SysmodelFacade.readCapPackage4CodePathById(modelId, function(data){
			cui(capPackageData).databind().setValue(data);
		});
		dwr.TOPEngine.setAsync(true);
	}

	//删除capPackageVO元数据
	function deleteCapPackage4CodePath(capPackageVO){
		var res = false;
		dwr.TOPEngine.setAsync(false);
		SysmodelFacade.deleteCapPackage4CodePath(capPackageVO,function(_result){
			res = _result;
		});
		dwr.TOPEngine.setAsync(true);
		return res;
	}
	//检查java代码路径
	function checkJavaCodePathName(data){
		if (data.indexOf('\/')>0) {
			replaceBackslash(data,"javaCodePath");
		}
		return true;
	}

	//检查页面代码路径
	function checkPagePathName(data){
		if (data.indexOf('\/')>0) {
			replaceBackslash(data,"pagePath");
		}
		return true;
	}

	//替换反斜杠/
	function replaceBackslash(data,id){
		var redata = data.replace("\/","\\");
		cui("#"+id).setValue(redata);
	}
	//根据模块id获取所对应的功能项及功能子项集合
	function saveModuleFuncItemApi(moduleVO){
		var res = false;
		dwr.TOPEngine.setAsync(false);
		SystemModuleAction.saveModuleFuncItem(moduleVO,cui("#FuncItemGrid").getData(),function(_result){
			res = _result;
			if(res){//更新新增的俩个属性
				res = saveCapPackage4CodePath(moduleVO,"update");
			}
		});
		dwr.TOPEngine.setAsync(true);
		return res;
	}
	
	//包全路径是否已存在
	function isExistPackageFullPath(data){
		var result = false;
		var packageVO = {id: funcData.parentFuncId, fullPath: data};
		dwr.TOPEngine.setAsync(false);
		SystemModuleAction.isExistPackageFullPath(packageVO, function(res){
			result = !res;
		});
		dwr.TOPEngine.setAsync(true);
		return result;
	}
	
	//执行父页面函数
	function executeParentMethod(moduleId, parentModuleId, moduleName){
		showTree();
		window.parent.editRefreshTree(moduleId, parentModuleId, moduleName);
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
		var reg = new RegExp("^[\u4E00-\u9FA5A-Za-z0-9_/\(（\)）]+$");
		return (reg.test(data));
	}
	
	//判断名称是否重复
	function isExistRename(data){
		if(data){
			var flag = true;
			dwr.TOPEngine.setAsync(false);
			var conditionVO = {parentModuleId:parentModuleId, moduleName:data, moduleId:moduleId};
			SystemModelAction.isModuleNameExist(conditionVO, function(data){
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
			SystemModelAction.isModuleCodeExist(conditionVO, function(data){
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
	
	// 返回
	function backTo(){
		window.parent.nodeUrl(backId);	
	}
	
	var dialog = null;
	//移动
	function moveSystem(){
		var url = "MoveSystemModel.jsp?moveObjId="+moduleId;
		
		dialog = cui.dialog({
			title : "请选择移动目标",
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
	
	function returnEditEntity(event, self, mark){
		var returnParentNodeName  = decodeURIComponent(decodeURIComponent(parentModuleName));
		if(returnParentNodeName!="undefined"&&returnParentNodeName!=null&&returnParentNodeName!="null"){
			returnParentNodeName = encodeURIComponent(encodeURIComponent(returnParentNodeName));
		}
		var returnUrl = '<%=request.getContextPath() %>/cap/ptc/index/AppDetail.jsp?packageId=' + moduleId + '&parentNodeId=' + parentModuleId
		+ "&parentNodeName=" + returnParentNodeName;
		if(testModel == "testModel"){ //测试建模过来的页面，操作按钮屏蔽
			returnUrl = '<%=request.getContextPath() %>/cap/bm/test/index/TestModelMain.jsp?packageId=' + moduleId + '&parentNodeId=' + parentModuleId
			+ "&parentNodeName=" + returnParentNodeName;
		}
		window.open(returnUrl+"&testModel="+testModel, '_self');
	}
	
	//导出文档
	function exportWordMain(type){
		dwr.TOPEngine.setAsync(false);
		DocumentAction.exportDocumentOutDoc(moduleId,type,function(result){
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
	
	// 打开包路径对应的控件编辑状态
	function openFullPathEditState(){
		cui('#fullPath').setReadonly(false);
	}
</script>
</body>
</html>
