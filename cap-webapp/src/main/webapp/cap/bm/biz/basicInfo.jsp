<%
  /**********************************************************************
	* CAP业务基本信息
	* 2015-11-03 姜子豪 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
<title>基本信息管理</title>
		<top:link href="/cap/bm/common/top/css/top_base.css" />
		<top:link href="/cap/bm/common/top/css/top_sys.css" />
		<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
		<top:link href="/cap/bm/common/styledefine/css/public.css"/>
		<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js" />
		<top:script src="/cap/dwr/engine.js" />
		<top:script src="/cap/dwr/util.js" />
		<top:script src="/cap/bm/common/top/js/jquery.js" />
		<top:script src="/cap/bm/common/js/capCommon.js" />
</head>
<style>
.top_header_wrap{
				margin-right:28px;
				margin-top: 4px;
				margin-bottom:4px;
}
</style>
<body>
		<div class="top_header_wrap">
			<div class="thw_operate">
				<span uitype="button" id="btnEdit" label="编  辑" button_type="blue-button" on_click="editTeamInfo"></span>
				<span uitype="button" id="btnSave" label="保  存" button_type="blue-button" on_click="saveTeamInfo"></span> 
				<span uitype="button" id="btnMove"label="移动" button_type="blue-button" menu=moveOperate></span>
				<span uitype="button" id="btnCancel" label="返 回" button_type="blue-button" on_click="cancel"></span>
			</div>
		</div>
		<div class="top_content_wrap cui_ext_textmode">
			<table class="form_table" style="table-layout: fixed;">
				<colgroup>
					<col width="15%" />
					<col width="35%" />
					<col width="15%" />
					<col width="35%" />
				</colgroup>
				<tr>
					<td class="divTitle">业务域信息</td>
				</tr>
				<tr>
					<td class="td_label">上级名称：</td>
					<td><span uitype="input" id="parentName" name="parentName" databind="domainInfo.parentName" maxlength="200" width="85%" readonly="true" ></span></td>
					<td class="td_label">编码：</td>
					<td><span uitype="input" id="code" name="code" databind="domainInfo.code" maxlength="250" width="85%" readonly="true"></span></td>
				</tr>
				<tr>
					<td class="td_label">名称<span class="top_required">*</span>：</td>
					<td><span uitype="input" id="name" name="name" databind="domainInfo.name" maxlength="200" width="85%" validate="domainName"></span></td>
					<td class="td_label">简称：</td>
					<td><span uitype="input" id="shortName" name="shortName" databind="domainInfo.shortName" maxlength="36" width="85%"></span></td>
				</tr>
			</table>

			<div id="PersonDiv" align="center">
				<div class="top_header_wrap">
					<div class="divTitle">角色信息</div>
					<div class="thw_operate" id="operateDiv">
						<span uitype="Button" id="addRole" label="新增" icon="plus" button_type="blue-button" on_click="insertRole"></span>
						<span uitype="Button" id="deleteRole" label="删除" icon="minus" button_type="blue-button" on_click="deleteRole"></span>
					</div>
				</div>
				<div class="editGrid">
					<table id="roleGrid" uitype="EditableGrid" datasource="initData" edittype="roleEditType" editbefore="editbefore" selectrows="${param.editType == 'read' ? 'no' : 'multi'}" 
					primarykey="id" colhidden="false" pagination="false" resizeheight="resizeHeight" ellipsis="false" resizewidth="resizeWidth" submitdata="saveRole" editafter="editafter">
						<thead>
							<tr>
								${param.editType == 'read' ? '' : '<th style="width: 5%"><input type="checkbox" /></th>'}
								<th width="15%" align="center" bindName="roleCode">编码</th>
								<th width="20%" align="center" bindName="roleName">名称<span class="top_required">*</span></th>
								<th width="15%" align="center" bindName="shortName">简称</th>
								<th width="25%" align="center" bindName="remark">备注/职责</th>
								<th width="20%" align="center" bindName="bizLevel">业务层级</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
	<top:script src="/cap/dwr/interface/BizDomainAction.js" />
	<top:script src="/cap/dwr/interface/BizRoleAction.js" />
<script type="text/javascript">
	var editType = "${param.editType}";
	var parentId = "${param.parentId}";
	var selectDomainId = "${param.selectDomainId}";
	var domainInfo={};
	var domainVO={};
	if(parentId==="_1"){
		parentId=null;
	}
	var initLevelData=[{'id':'HQ','text':'公司总部'},{'id':'CC','text':'分子公司'},{'id':'BU','text':'地市单位'},
					   {'id':'LU','text':'基层单位'},{'id':'CSG','text':'网公司'},{'id':'PROVINCE','text':'省公司'},
					   {'id':'PROVINCE_SD','text':'省公司系统部'},{'id':'BUREAU','text':'地市局'},{'id':'UHV','text':'超高压调峰调频'},
					   {'id':'EC','text':'能源公司'},{'id':'UNKNOWN','text':'未知层级'}];//角色层级
	//操作按钮初始化
	var moveOperate = {
			datasource: [
		         {id:'btnMove',label:'移动到'},
		         {id:'btnTop',label:'升为顶层'}
		    ],
		     on_click:function(obj){
		     	if(obj.id=='btnMove'){
		     		moveDomain();
		     	}else{
		     		topDomian();
		     	}
		     }
		}
	var vNull =[{'type':'custom','rule':{'against':'isBlank', 'm':'不能为空'}}];
	var domainName=[{'type':'custom','rule':{'against':'isBlank', 'm':'不能为空'}}
		, {
			'type': 'custom',
			'rule': {
				against:'checkDomainName',
				m:'存在相同名称的同级业务域'
			}
		}];
	
	window.onload = function(){
		init();
		pageStausSet(editType);
	}
	
	var validateRoleName=[{'type':'custom','rule':{'against':'isBlank', 'm':'不能为空'}}];
	//编辑grid编辑列属性设置 
		roleEditType = {
		    "roleName" : {
		    	uitype: "Input",
				maxlength: 200,
				validate:validateRoleName
		    },
		    "shortName" : {
		    	uitype: "Input",
				maxlength: 200
		    },
		    "remark" : {
		    	uitype: "Input",
				maxlength: 2000
		    },
		    "bizLevel" : {
				uitype: "PullDown",
				mode: "Single",
				datasource:initLevelData
				}
		    
		};
	
	function checkRoleName(data){
		var allData=cui("#roleGrid").getData();
		for(var i=0;i<allData.length;i++){
			for(var j=i+1;j<allData.length;j++){
				if(allData[i].roleName==allData[j].roleName){
					return false;
				}
			}
		}
		return true;
	}
	
	//初始化界面加载
	function init(){
		if(selectDomainId){
   			dwr.TOPEngine.setAsync(false);
   			BizDomainAction.queryDomainById(selectDomainId,function(data){
   				if(data){
   					domainInfo=data;
   	   				parentId=data.paterId;
   				}
   			});
   			dwr.TOPEngine.setAsync(true);
   		}
		if(parentId){
			dwr.TOPEngine.setAsync(false);
			BizDomainAction.queryDomainById(parentId,function(data){
   				domainInfo.parentName=data.name;
   			});
   			dwr.TOPEngine.setAsync(true);
		}
// 		dwr.TOPEngine.setAsync(false);
// 		BizRoleAction.getRoleLevel(function(data){
// 			initLevelData=eval(data);
// 		});
// 		dwr.TOPEngine.setAsync(true);
		comtop.UI.scan();
	}
	
	//grid数据源
	function initData(tableObj){
		if(selectDomainId){
			dwr.TOPEngine.setAsync(false);
			BizRoleAction.queryRoleByDomainId(selectDomainId,function(data){
		    	tableObj.setDatasource(data);
			});
			dwr.TOPEngine.setAsync(true);
		}
		else{
			tableObj.setDatasource(null);
		}
		}
	
	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 50;
	}
	
	//grid 宽度
	function resizeHeight(){
		return (document.documentElement.clientHeight || document.body.clientHeight) - 250;
	}
	
	
	//编辑事件 
	function editTeamInfo(){
		parent.parent.setCenterUrlForClik(selectDomainId,"edit");
	}
	
	//取消事件 
	function cancel(){
		if(selectDomainId){
			parent.parent.setCenterUrlForClik(selectDomainId,"read");
		}
		else{
			if(parentId){
				parent.parent.setCenterUrlForClik(parentId,"read");
			}
			else{
				dwr.TOPEngine.setAsync(false);
				BizDomainAction.queryDomainList(domainVO,function(data){
					sortDomian(data.list)
					selectDomainId=data.list[0].id;
				});
				dwr.TOPEngine.setAsync(true);
				parent.parent.setCenterUrlForClik(selectDomainId,"read");
				parent.parent.setLeftUrl(selectDomainId);
			}
		}
	}
	
	
	//保存事件
	function saveTeamInfo(){
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
		domainVO=cui(domainInfo).databind().getValue();
		if(parentId){
			domainVO.paterId=parentId;
		}
		else{
			domainVO.paterId="";
		}
		var rel=cui("#roleGrid").submit();
		if(rel === "fail"){
			return false;
		}
		else{
			dwr.TOPEngine.setAsync(false);
			BizDomainAction.saveDomain(domainVO,function(data){
	 			if(data) {
	 				selectDomainId=data;
	 				parent.loadTree(data);
	 				cui.message('保存成功。','success');
	 			}else{
	 				cui.message('保存失败。','error');
	 			}
			});
			dwr.TOPEngine.setAsync(true);
			var allRoleData=cui("#roleGrid").getData();
			if(allRoleData){
				for(var i=0;i<allRoleData.length;i++){
					if(!allRoleData[i].domainId){
						allRoleData[i].domainId=selectDomainId;
					}
				}
			}
			saveRole(allRoleData);
			parent.refleshDomain(selectDomainId,"read");
		}
	}
	
	//保存角色信息 
	function saveRole(data){
		dwr.TOPEngine.setAsync(false);
		BizRoleAction.saveRole(data);
		dwr.TOPEngine.setAsync(true);
	}
	
	//检查可编辑列编辑条件
	function editbefore(rowData, bindName){
		if (bindName == "roleName") {
			if(editType=="read"){
				return false;
			}
			else{
				return {             
					uitype: "Input",
					maxlength: 200,
					validate:validateRoleName
					}
			}
		}
		if (bindName == "shortName") {
			if(editType=="read"){
				return false;
			}
			else{
				if(rowData.shortName){
					return {             
						uitype: "Input",
						maxlength: 200
						}
				}
				else{
					return {             
						uitype: "Input",
						maxlength: 200,
						value:rowData.roleName
						}
				}
			
			}
		}
		if (bindName == "remark") {
			if(editType=="read"){
				return false;
			}
			else{
				return {             
					uitype: "Input",
					maxlength: 2000
					}
			}
		}
		if(bindName =="bizLevel"){
			if(editType=="read"){
				return false;
			}
			else{
				return{
					uitype: "PullDown",
					mode: "Single",
					datasource:initLevelData
					}
			}
		}
	}
	
	//需求元素grid插入新行
	function insertRole() {
		cui("#roleGrid").insertRow({},0);
	}
	
	//空格过滤
	function isBlank(data){
		if(data.replace(/\s/g, "")==""){
			return false;
		}
		return true;
	}
	
	//删除需求元素行
	function deleteRole(){
		var selects = cui("#roleGrid").getSelectedRowData();
		var deleteRoleList=[];
		var message="";
		var count=0;
		var deleteIdList=[];
		for(var i=0;i<selects.length;i++){
			dwr.TOPEngine.setAsync(false);
			BizRoleAction.checkRoleIsUse(selects[i],function(data){
				if(data>0){
					message+=selects[i].roleName+",";
					
				}
				else{
					deleteRoleList[count]=selects[i];
					deleteIdList[count]=selects[i].id;
					count++;
				}
			});
			dwr.TOPEngine.setAsync(true);
		}
		if(selects == null || selects.length == 0){
			cui.alert("请选择要删除的数据。");
			return;
		}
		if(message !=""){
			if(count >0){
				var str=message+"已被引用无法删除,是否要删除其他未被引用的数据?"
				deleteRoleLst(str,deleteRoleList,deleteIdList);
			}
			else{
				cui.alert("所选数据已被引用无法删除");
				return;
			}
		}
		else{
			var str="确定要删除这"+selects.length+"条数据吗?"
			deleteRoleLst(str,deleteRoleList,deleteIdList);	
		}
	}
	
	//
	function deleteRoleLst(str,deleteRoleList,deleteIdList){
		cui.confirm(str,{
			onYes:function(){
				dwr.TOPEngine.setAsync(false);
				BizRoleAction.deleteRoleList(deleteRoleList);
				dwr.TOPEngine.setAsync(true);
				cui("#roleGrid").deleteRow(deleteIdList);
				cui.message('删除成功。','success');
				}
			});
	}
	
	//移动
	function moveDomain(){
		var id="moveNode";
		var url = "${pageScope.cuiWebRoot}/cap/bm/biz/domain/jsp/DomainTree.jsp";
		var title="移动到";
		var height = 400;
		var width =  300;
		
		dialog = cui.dialog({
			id:id,
			title : title,
			src : url,
			width : width,
			height : height
		})
		dialog.show(url);
	}
	
	function topDomian(){
		var chooseDomainVO={};
		dwr.TOPEngine.setAsync(false);
		BizDomainAction.queryDomainById(selectDomainId,function(data){
			chooseDomainVO=data;
			chooseDomainVO.paterId=null;
		});
		BizDomainAction.saveDomain(chooseDomainVO);
		dwr.TOPEngine.setAsync(true);
		parent.parent.setCenterUrlForClik(selectDomainId,"read");
		parent.loadTree(selectDomainId);
	}
	
	//选择业务域回调方法 
	function chooseDomainCallback(key,title){
		var chooseDomainVO;
		var cutDomainVO;
		dwr.TOPEngine.setAsync(false);
		BizDomainAction.queryDomainById(key,function(data){
			chooseDomainVO=data;
		});
		BizDomainAction.queryDomainById(selectDomainId,function(data){
			cutDomainVO=data;
		});
		dwr.TOPEngine.setAsync(true);
		if(selectDomainId == key){
			cui.warn('不能将一个节点移动到其本身的下面！');
			return;
		}
		if(chooseDomainVO.paterId == selectDomainId){
			cui.warn('不能将一个节点移动到其子节点的下面！');
			return;
		}
		else{
			cutDomainVO.paterId=key;
			dwr.TOPEngine.setAsync(false);
			BizDomainAction.saveDomain(cutDomainVO);
			dwr.TOPEngine.setAsync(true);
			parent.parent.setCenterUrlForClik(selectDomainId,"read");
			parent.loadTree(selectDomainId);
		}
	}
	
	//DomainName是否重复
 	function checkDomainName(data){
 		data=trim(data);
 		var result;
 		var domainVO={'name':data,'paterId':parentId,'id':selectDomainId}
 		dwr.TOPEngine.setAsync(false);
		BizDomainAction.checkDomainName(domainVO,function(data){
			result=data;
		});
		dwr.TOPEngine.setAsync(true);
		return result;
 	}
	
	function editafter(rowData, bindName){
		if (bindName == "roleName") {
			if(rowData.shortName){
				rowData.shortName=rowData.shortName;
			}
			else{
				rowData.shortName=rowData.roleName;
			}
		}
		return rowData;
	}
</script>
<top:script src="/cap/bm/biz/domain/js/DomainInfo.js" />
</body>
</html>