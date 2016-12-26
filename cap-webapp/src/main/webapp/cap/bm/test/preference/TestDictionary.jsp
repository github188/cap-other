<%
/**********************************************************************
* 测试建模数字字典管理
* 2016-6-23 zhangzunzhi 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <title>测试建模数字字典管理</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<style type="text/css">
	</style>
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
    <top:script src='/cap/dwr/engine.js'></top:script>
    <top:script src='/cap/dwr/util.js'></top:script>
    <top:script src='/cap/dwr/interface/MetadataTmpTypeFacade.js'></top:script>
    <top:script src='/cap/dwr/interface/TestmodelDicClassifyAction.js'></top:script>
    <top:script src='/cap/dwr/interface/TestmodelDicItemAction.js'></top:script>
</head>
<style>
.thw_title{
    margin-left: 0px;
    font-weight: bold;
    font-size: 12pt;
    float: left;
</style>
<body>
	<div uitype="Borderlayout" id="body" is_root="true" on_sizechange="setGridWidth">
        <div id="leftMain" position="left" style="overflow:hidden" width="250" collapsable="true" show_expand_icon="true"> 
	        <div style="padding-top:1px;width:100%;position:relative;">
	           	<div style="padding-bottom:10px;padding-left:5px;padding-top:10px;">
	            	<span uitype="button" id ="addTestDictionaryBtn" label="新增分类" on_click="openEditTestDictionary"></span>
	             	<span uitype="button" id ="editTestDictionaryBtn" label="编辑分类" disable="false" on_click="openEditTestDictionary"></span>
	             	<span uitype="button" id ="delTestDictionaryBtn" label="删除分类" disable="false" on_click="deleteTestDictionary"></span>
	            </div>
	            <span uitype="ClickInput"  id="keyword"  name="keyword"  emptytext="请输入分类名称关键字查询" on_iconclick="searchDictionary" on_keydown="keyDownQuery" icon="search" editable="true" width="229"></span>
			</div>
			<div id="treeDivHight" style="overflow:auto;height:100%;">
				 <div id="fastQueryList" uitype="MultiNav" datasource="initBoxData"></div> 
	             <div id="dictionaryTypeTree" uitype="Tree" children="initTreeData" on_lazy_read="loadNode" on_click="dictionaryTypeTreeClick" click_folder_mode="1"></div>
		    </div>
        </div>
		<div id="centerMain" position ="center">
			<table class="cap-table-fullWidth" width="100%">
			   <!--  <tr>
			        <td class="cap-td" colspan="2" style="text-align: left;padding:5px">
			        	<span class="thw_title">测试建模字典配置</span>
			        </td>
			    </tr> -->
			     <tr>
			        <td class="cap-td" style="text-align: left;padding:5px" nowrap="nowrap">
			        	<span uitype="PullDown" id ="dictionaryType" mode="Single" value_field="id" label_field="text" value="all" width="100" datasource="initDictionaryType" on_change="itemTypeChange"></span>
			        <span id="testDictionaryFilter" uitype="ClickInput" emptytext="请输入编码或名称" on_iconclick="searchDictionaryItem" on_keydown="keyDown" icon="search" editable="true" width="250"></span>
			        </td>
			        <td class="cap-td" style="text-align: right;padding:5px" nowrap="nowrap">
			        	<span uitype="button" id ="addDictionary" label="新增" on_click="addDictionary"></span>
	             	    <span uitype="button" id ="delDictionary" label="删除" on_click="delDictionary"></span>
			        </td>
			    </tr>
			</table>
			<table class="cap-table-fullWidth">
			    <tr>
			        <td class="cap-td">
						<table uitype="Grid" id="testDictionaryItem" primarykey="id" colhidden="false" datasource="initTestDictionaryData" pagination="false"
						 	resizewidth="getBodyWidth" resizeheight="getBodyHeight"  colrender="columnRenderer">
							<thead>
								<tr>
									<th style="width:25px" renderStyle="text-align: center;"></th>
									<th style="width:20%" renderStyle="text-align: left" bindName="dictionaryName">名称</th>
									<th style="width:30%" renderStyle="text-align: left" bindName="dictionaryCode">全局编码</th>
									<th style="width:15%" renderStyle="text-align: left" bindName="dictionaryType">类型</th>
									<th style="width:20%" renderStyle="text-align: left" bindName="dictionaryValue">数据值</th>
								</tr>
							</thead>
						</table>
			        </td>
			    </tr>
			</table>
		</div>
	</div>
	<script type="text/javascript">
	    var testDictionaryTypeVO = {};
		var curNodeId = "";
		var rootId = "";
		$(document).ready(function(){
			comtop.UI.scan();   //扫描
		});
		
		//初始化数据 
		function initTreeData(obj) {
			dwr.TOPEngine.setAsync(false);
			var objClassify = {parentId:"-1"};
	 		TestmodelDicClassifyAction.queryClassifyTreeNode(objClassify, function(data){
	 			if(data!=null&&data!=""){
	 				var treeData = jQuery.parseJSON(data);
					treeData.expand = true;
					treeData.activate = true;
					obj.setDatasource(treeData);
					curNodeId = treeData.key;
					rootId = treeData.key;
			    	//nodeUrl(treeData.key);
		 		}else{
		 			var treeData = {title:"暂无数据",key:"0"};
	    			treeData.activate = true;
	    			obj.setDatasource(treeData);
		 		}
			});
			dwr.TOPEngine.setAsync(true);
		}
		
		//初始化模板列表
		function initTestDictionaryData(gridObj, query) {
			var datasource = [];
			if(curNodeId != ''){
				var keyword = cui("#testDictionaryFilter").getValue().replace(new RegExp("/","gm"), "//");
				keyword = keyword.replace(new RegExp("%", "gm"), "/%");
				keyword = keyword.replace(new RegExp("_","gm"), "/_");
				keyword = keyword.replace(new RegExp("'","gm"), "''");
				var dictionaryItemType = cui("#dictionaryType").getValue();
				if(dictionaryItemType=="all"){
					dictionaryItemType="";
				}
				var queryVO = {classifyId:curNodeId,dictionaryType:dictionaryItemType,dictionaryName:keyword};
				dwr.TOPEngine.setAsync(false);
				TestmodelDicItemAction.queryDicListByClassifyId(queryVO, function(data){
					datasource = data;
				});
				dwr.TOPEngine.setAsync(true);
			}
			gridObj.setDatasource(datasource, datasource.length);
		}
		
		//打开新增编辑模板分类页面
	    var addDictionaryDialog;
	    function openEditTestDictionary(event, el){
			var height = 240;
			var width = 450;
			var title = '新增测试字典分类';
			var url = 'EditTestDictionaryType.jsp';
			var node = cui('#dictionaryTypeTree').getActiveNode();
			var nodeId = node.getData().key;
			var nodeParentId;
			if(nodeId=="0"){
				nodeParentId ="-1";
			}else{
				nodeParentId = node.getData().data.parentId;
			}
			if(el.options.label=='编辑分类'){
				url += '?operationType=edit&id='+nodeId+"&parentId="+nodeParentId;
				title = "编辑测试字典分类";
			}else{
				url += '?operationType=add&id='+nodeId+"&parentId="+nodeParentId;
			}
			if(!addDictionaryDialog){
				addDictionaryDialog = cui.dialog({
				  	title : title,
				  	src : url,
				    width : width,
				    height : height
				    //left:'30%',
				    // top:'30%'
				});
			} else {
				addDictionaryDialog.title=title;
				addDictionaryDialog.src = url;
			}
			addDictionaryDialog.show(url);
		}
	    
	    //打开新增编辑字典项页面
	    var addDicItemDialog
	    function addDictionary(event, el){
			var url = 'EditTestDictionaryItem.jsp?operationType=add&classifyId='+curNodeId+"&id=";
			if(!addDicItemDialog){
				addDicItemDialog = cui.dialog({
				  	title : '新增测试字典',
				  	src : url,
				    width : 480,
				    height : 300
				});
			} 
			addDicItemDialog.show(url);
	    }
	    
	    //编辑字典项
	    function editDictionaryItem(id,classifyId){
	    	var url = 'EditTestDictionaryItem.jsp?operationType=edit&id='+id+"&classifyId="+classifyId;
			if(!addDicItemDialog){
				addDicItemDialog = cui.dialog({
				  	title : '编辑测试字典',
				  	src : url,
				    width : 480,
				    height : 300
				});
			} 
			addDicItemDialog.show(url);
	    }
	    
	    //编辑字典项行渲染
	    function columnRenderer(data,field){
	    	if(field == 'dictionaryName'){
				//替换显示
				var dictionaryName = data["dictionaryName"];
				return "<a  href='javascript:editDictionaryItem(\""+data["id"]+ "\",\""+data["classifyId"]+ "\");'>"+dictionaryName+"</a>";
			}else if(field == 'dictionaryType'){
				var dictionaryType = data["dictionaryType"];
				var dictionaryTypeDes = "";
				for(var i=0;i<initDictionaryType.length;i++){
		    		if(initDictionaryType[i].id==dictionaryType){
		    			dictionaryTypeDes =  initDictionaryType[i].text;
		    		}
		    	}
				return dictionaryTypeDes;
			}
	    }
	    
	    //删除字典项
	    function delDictionary(){
	    	var ids = cui("#testDictionaryItem").getSelectedPrimaryKey();
	    	var data = cui("#testDictionaryItem").getSelectedRowData();
	    	if(ids.length==0){
	    		cui.alert("请先选择需要删除的字典项！");
	    		return;
	    	}
	    	var itemName = "";
	    	for(var i=0;i<data.length;i++){
	    		itemName += data[i].dictionaryName;
	    		if(i<data.length-1){
	    			itemName += ",";
	    		}
	    	}
	    	if(ids&&ids.length>0){
	    		cui.confirm("确定要删除【<font color='red'>" + itemName + "</font>】吗？", {
			        onYes: function(){
		    		dwr.TOPEngine.setAsync(false);
					TestmodelDicItemAction.deleteDicItemVOById(ids, function(data){
			 			if(data){
				 			window.parent.cui.message('字典删除成功。',"success");
			 			}else{
			 				window.parent.cui.message('字典删除失败。',"error");
			 			}
			 			cui("#testDictionaryItem").loadData();
			 		})
			 		dwr.TOPEngine.setAsync(true);	
			        }
		    	});
	    	}
	    }
	    
	    /*
	    *nodeId当前节点ID
	    *parentNodeIdnodeId当前节点父ID
	    *directory新增节点目录的类型，same：新增同级目录，child新增下级目录
	    */
	    // 新增树节点刷新事件 
		function addRefreshTree(nodeId,parentNodeId,directory) {
			 if(directory=="same"&&parentNodeId=="-1"){
				 initTreeData(cui("#dictionaryTypeTree"));
			 }else{
				var treeObject = cui("#dictionaryTypeTree");
				var pNode = treeObject.getNode(parentNodeId); 
				if(pNode && pNode.dNode) { 
					pNode.setData("isFolder",true);
					if(pNode.hasChild()) {
						var lstChildrenNodes = pNode.children();
						for(var i=0;i<lstChildrenNodes.length;i++) {
							var dNode = lstChildrenNodes[i];
							dNode.remove();
						}
					}
					if(!pNode.hasChild()&&directory=="child"){
						pNode.setData('icon','${pageScope.cuiWebRoot}/top/sys/images/func_sys.gif');    
					}
				}
				loadNode(pNode);
				var dNode = treeObject.getNode(nodeId);
				dNode.activate();
				dNode.focus();
				dictionaryTypeTreeClick(dNode);
			 }
	    }
	    
		// 编辑树节点刷新事件 
		function editRefreshTree(id,parentId,dictionaryName){
			var treeObject = cui("#dictionaryTypeTree");
			var selectNode = treeObject.getNode(id);
			if(selectNode && selectNode.dNode) {
				selectNode.setData("title",dictionaryName);
				selectNode.activate();
				dictionaryTypeTreeClick(selectNode);
			} 
		}
		
		//字典项新增，编辑后的刷新
		function editCallBack(type,key){
			selectedKey=key;
			//新增信息
			if(type=="add"){
				cui("#testDictionaryFilter").setValue("");
			}
			cui("#testDictionaryItem").loadData();
			cui("#testDictionaryItem").selectRowsByPK(key);
		}
	    
		//点击click事件加载节点方法
		function loadNode(node) {
		    curNodeId = node.getData().key;
			dwr.TOPEngine.setAsync(false);
			var classifyChildObj={id:node.getData().key};
			TestmodelDicClassifyAction.queryClassifyTreeNode(classifyChildObj,function(data){
		    	var treeData = jQuery.parseJSON(data);
		    	treeData.activate = true;
		    	node.addChild(treeData.children);
				node.setLazyNodeStatus(node.ok);
		     });
			dwr.TOPEngine.setAsync(true);
		}
	    
		//删除模板分类
		function deleteTestDictionary(){
			var node = cui('#dictionaryTypeTree').getActiveNode();
			var nodeName = node.getData().data.dictionaryName;
			var nodeId =  node.getData().key;
			//根据字典分类ID检测是否可以删除，有子节点不可删除，有字典项不可删除
			if(isChildClassify(nodeId)){
				cui.alert("有子分类不可删除！");
				return;
			}
			if(isDictionaryItem(nodeId)){
				cui.alert("分类上有字典项不可删除！");
				return;
			}
			var nodeParentId = node.getData().data.parentId;
				cui.confirm("确定要删除【<font color='red'>" + nodeName + "</font>】吗？", {
			        onYes: function(){
			        	dwr.TOPEngine.setAsync(false);
			        	var deleteVO = {id:nodeId};
			        	TestmodelDicClassifyAction.deleteClassifyVOById(deleteVO, function(data){
			        		if(data){
			    				cui.message("分类删除成功","success");
			    			}else{
			    				cui.message("分类删除失败","error");
			    			}
						});
			        	dwr.TOPEngine.setAsync(true);
						delRefresh(nodeId,nodeParentId);
			        }
		    	});
		}
		
		// 删除操作后刷新树 
		function delRefresh(nodeId,nodeParentId){
		   if(nodeParentId=="-1"){
			   initTreeData(cui("#dictionaryTypeTree"));
		   }else{
				var treeObject = cui("#dictionaryTypeTree");
				var pNode = treeObject.getNode(nodeParentId);
				var selectNode = treeObject.getNode(nodeId);
				if(selectNode && selectNode.dNode) {
					pNode.activate(true);
					pNode.getData().isLazy = false;
					// 删除节点
					selectNode.remove();
				}
				var childrenList = pNode.children();
				if(!pNode.hasChild()){
					pNode.setData("isFolder",false);
					pNode.setData('icon','${pageScope.cuiWebRoot}/top/sys/images/func_dir.gif');    
				}
				dictionaryTypeTreeClick(pNode);
		   }
		}
		
		//树快速搜索
		function keyDownQuery() {
			if (event.keyCode ==13) {
				searchDictionary();
			}
		}
		
		//字典项快速搜索
		function keyDown(){
			if (event.keyCode ==13) {
				searchDictionaryItem();
			}
		}
		
		//分类树搜索
		function searchDictionary(){
			var keyword = cui('#keyword').getValue();
			if(keyword==''){
				$('#fastQueryList').hide();
				$('#dictionaryTypeTree').show();
				cui("#addDictionary").disable(false);
				cui("#delDictionary").disable(false);
				cui("#addTestDictionaryBtn").disable(false);
				cui("#editTestDictionaryBtn").disable(false);
				cui("#delTestDictionaryBtn").disable(false);
				var node=cui('#dictionaryTypeTree').getNode(rootId);
				if(node){
					dictionaryTypeTreeClick(node);
				}
			}else{
				$('#fastQueryList').show();
				$('#dictionaryTypeTree').hide();
				listBoxData(cui('#fastQueryList'));
			}
		}
		
		//初始化分类搜索结果
		function listBoxData(obj){
			initBoxData = [];
			var keyword = cui("#keyword").getValue().replace(new RegExp("/","gm"), "//");
			keyword = keyword.replace(new RegExp("%", "gm"), "/%");
			keyword = keyword.replace(new RegExp("_","gm"), "/_");
			keyword = keyword.replace(new RegExp("'","gm"), "''");
			var queryData =[];
			dwr.TOPEngine.setAsync(false);
			TestmodelDicClassifyAction.fastQueryClassify(keyword,function(data){
				var len = data.length ;
				queryData = data;
				if(len != 0) {
					$.each(data,function(i,cData){
						if(cData.dictionaryName.length > 31) {
							path=cData.dictionaryName.substring(0,31)+"..";
						} else {
							path = cData.dictionaryName;
						}
						initBoxData.push({href:"#",name:path,title:cData.dictionaryName,onclick:"clickRecord('"+cData.id+"','"+cData.dictionaryCode+"')"});
					});
				} else {
					initBoxData.push({href:"#",name:"没有数据",title:"",onclick:""});
				}
			});
			cui("#fastQueryList").setDatasource(initBoxData);
			dwr.TOPEngine.setAsync(true);
			 if(queryData&&queryData.length>0){
				clickRecord(queryData[0].id,queryData[0].dictionaryCode);
				cui("#addDictionary").disable(false);
				cui("#delDictionary").disable(false);
			}else{
				clickRecord("-100","");
				cui("#addDictionary").disable(true);
				cui("#delDictionary").disable(true);
			}
			 cui("#addTestDictionaryBtn").disable(true);
			 cui("#editTestDictionaryBtn").disable(true);
			 cui("#delTestDictionaryBtn").disable(true);
			 $("#fastQueryList").find("a:first").attr("class","multinav-checked")
		}
		
		//分类搜索点击事件
		function clickRecord(id,code){
			cui("#testDictionaryFilter").setValue("");
			curNodeId = id;
			cui("#testDictionaryItem").loadData();
		}
		
		// 检验是否可以删除
		function isChildClassify(dictionaryClassifyId){
			var ret = false;
			dwr.TOPEngine.setAsync(false);
			var classifyChildObj={id:dictionaryClassifyId};
			TestmodelDicClassifyAction.queryClassifyTreeNode(classifyChildObj,function(data){
		    	var treeData = jQuery.parseJSON(data);
		    	if(treeData.children){
		    		ret = true;
		    	}
		     });
			dwr.TOPEngine.setAsync(true);
			return ret;
		}
		
		//判断是否有字典项
		function isDictionaryItem(dictionaryClassifyId){
			var ret = false;
			dwr.TOPEngine.setAsync(false);
			var queryVO = {classifyId:dictionaryClassifyId};
			TestmodelDicItemAction.queryDicListByClassifyId(queryVO, function(data){
				if(data&&data.length>0){
					ret = true;
				}
			});
			dwr.TOPEngine.setAsync(true);
			return ret;
		}
		
		//树单击事件
	    function dictionaryTypeTreeClick(node){
	    	cui("#testDictionaryFilter").setValue("");
	    	var data = node.getData();
	    	curNodeId = node.getData().key;
	    	cui("#testDictionaryItem").loadData();
	    }
		
		//字典项类型切换事件
		function itemTypeChange(data,oldData){
			cui("#testDictionaryItem").loadData();
		}
		
		//字典项快速搜索
		function searchDictionaryItem(){
			cui("#testDictionaryItem").loadData();
		}
		
		var initDictionaryType = [
				{id:'all',text:'全部分类'},
				{id:"String",text:"字符串"},
	        	{id:"Time",text:"数字"},
	        	{id:"Number",text:"日期型"},
	        	{id:"Bool",text:"布尔型"}
		]
			
		/**
		 * 表格自适应宽度
		 */
		function getBodyWidth () {
		    return parseInt(jQuery("#centerMain").css("width"))- 10;
		}
	
		/**
		 * 表格自适应高度
		 */
		function getBodyHeight () {
		    return (document.documentElement.clientHeight || document.body.clientHeight) - 80;
		}
		
		function setGridWidth(){
	        cui("#centerMain").resize();
		}
	</script>
</body>
</html>