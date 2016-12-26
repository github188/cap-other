<%
  /**********************************************************************
	* CAP业务表单管理
	* 2015-11-03  姜子豪  新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>业务表单管理</title>
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
.thw_operate{
	margin-bottom: 4px;
}
.top_header_wrap {
	margin-left :4px;
	}
.editGrid{
  margin-top: 25px;
}
</style>
<body>
	<div uitype="Borderlayout" id="border" is_root="true">
		<div id="formList" position="left" width="220px" collapsable="true" show_expand_icon="true">
			<div class="thw_operate" id="BizFormDiv">
				<span uitype="ClickInput" id="keywords" on_iconclick="search" width="200" icon="search" maxlength="200" editable="true" emptytext="请输入名称、编码进行查询" on_keydown="keyDownQuery"></span>
			</div>
			<div class="top_header_wrap">
				<span id="addNode" button_type="blue-button" uitype="button" label="新增" on_click="insertForm"></span>
				<span id="deleteNode" button_type="blue-button" uitype="button" label="删除" on_click="deleteForm" ></span>
			</div>
			<div class="editGrid">
				<table uitype="EditableGrid" id="BizFormGrid" primarykey="id" datasource="initBizFormDataSource" gridwidth="200"  pagination="false"  gridheight="auto" selectrows="single" 
					colrender="columnRenderer" rowclick_callback="selectOneObject">
					<thead>
					<tr>
						<th style="width:20px;"></th>
						<th render="BizFormRender" renderStyle="text-align: left;" >业务对象列表</th>
					</tr>
					</thead>
			</table>
			</div>
		</div>
		<div id="tablePage" position="center" url="">
		</div>
	</div>
	<top:script src="/cap/dwr/interface/BizFormAction.js" />
<script type="text/javascript">
	var formVO={};
	var formCount=0;
	var selectFromId;
	var selectDomainId = "${param.selectDomainId}";
	window.onload = function(){
		init();
		setRightUrl(selectDomainId,selectFromId,"read");
	}
	
	//初始化界面加载
	function init(){
		comtop.UI.scan();
	}
	
	//业务对象
	function BizFormRender(rd, index, col) {
		if(rd.code){
			return rd.name+"【"+rd.code+"】";
		}
		else{
			return rd.name;
		}
		
	}
	
	//业务对象数据源
	function initBizFormDataSource(tableObj,query) {
		formVO.keyWords=cui("#keywords").getValue();
		dwr.TOPEngine.setAsync(false);
		BizFormAction.queryFormListByDomainId(selectDomainId,formVO,function(data){
		    tableObj.setDatasource(data, data.length);
		    if(data.length>0){
		    	if(!selectFromId){
		    		selectFromId = data[0].id;
		    	}
		    	tableObj.selectRowsByPK(selectFromId);
		    }
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//单击行事件 
	function selectOneObject(rowData,isChecked,index){
		if(rowData.entityId){
			isEntity = true;
		}
		cui("#BizFormGrid").selectRowsByPK(rowData.id);
		setRightUrl(selectDomainId,rowData.id,"read");
	}
	
	//设置左侧布局链接界面 
	function setRightUrl(selectDomainId,selectFromId,editType){ 
		var url = "${pageScope.cuiWebRoot}/cap/bm/biz/form/bizFormInfo.jsp?selectDomainId="+selectDomainId+"&selectFromId="+selectFromId+"&editType="+editType;
		cui("#border").setContentURL("center",url);
	}
	
	//编辑保存后刷新grid
	function loadGrid(formId){
		selectFromId = formId;
		cui("#BizFormGrid").loadData();
	}
	
	//点击节点
	function onclickNode(node, event){
		selectFromId=node.getData("key");
		setRightUrl(selectDomainId,selectFromId,"read");
	}
	
	//编辑保存后刷新tree
	function loadTree(formId,isInsert,formName){
		var rootNode=cui("#formTree").getRoot();
		if(isInsert){
			cui.message('新增成功。','success');
			rootNode.addChild({'title':formName,'key':formId});
		}
		else{
			cui.message('保存成功。','success');
			cui("#formTree").getNode(formId).setData("title",formName);
		}
		setRightUrl(selectDomainId,formId,"read");
		cui("#formTree").getNode(formId).activate(true);
	}
	
	//排序序号
	function sortForm(formList){
		if(formList.length>1){
			var temp;
			for(var i=0;i<formList.length-1;i++){
				for(var j=i+1;j<formList.length;j++){
					if(formList[i].sortNo >formList[j].sortNo){
						temp=formList[i];
						formList[i]=formList[j];
						formList[j]=temp;
					}
				}
			}
		}
		return formList;
	}
	
	//新增业务表单
	function insertForm(){
		var url = "${pageScope.cuiWebRoot}/cap/bm/biz/form/bizFormInfo.jsp?selectDomainId="+selectDomainId+"&editType="+"insert";
		cui("#border").setContentURL("center",url);
	}
	
	//删除
	function deleteForm(){
		var selectNodeKey=cui("#BizFormGrid").getSelectedPrimaryKey();
		var message="";
		var iCount=0;
		selectNodeKey = selectNodeKey[0];
		if(selectNodeKey){
			dwr.TOPEngine.setAsync(false);
			BizFormAction.checkFormIsUse(selectNodeKey,function(data){
				iCount=data;
			});
	    	dwr.TOPEngine.setAsync(true);
			if(iCount>0){
				cui.alert("所选表单已被引用或表单还存在数据项,无法删除！");
			}
			else{
				cui.confirm("确定要删除所选业务表单吗？",{
					onYes:function(){
						dwr.TOPEngine.setAsync(false);
						BizFormAction.deleteForm(selectNodeKey);
					    dwr.TOPEngine.setAsync(true);
						cui("#BizFormGrid").loadData();
					    parent.cui.message("删除成功","success");
					    setRightUrl(selectDomainId,selectFromId,"read");
					}
				});
			}
		}
		else{
			cui.alert("请选定待业务域");
		}
	} 
	
	//查找
	function search(){
		cui("#BizFormGrid").loadData();
	}
	
	//键盘回车键快速查询 
	function keyDownQuery() {
		if ( event.keyCode ==13) {
			cui("#BizFormGrid").loadData();
		}
	}
</script>
</body>
</head>
</html>