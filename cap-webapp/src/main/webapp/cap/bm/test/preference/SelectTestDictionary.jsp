<%
/**********************************************************************
* 选择测试建模数字字典
* 2016-7-13 诸焕辉 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <title>选择测试建模数字字典</title>
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
<body>
	<div uitype="Borderlayout" id="body" is_root="true">
        <div id="leftMain" position="left" style="overflow:hidden" width="250" collapsable="true" show_expand_icon="true"> 
	        <div style="width:100%;position:relative; padding: 5px;">
	            <span uitype="ClickInput"  id="keyword"  name="keyword"  emptytext="请输入分类名称关键字查询" on_iconclick="searchDictionary" on_keydown="keyDownQuery" icon="search" editable="true" width="238"></span>
			</div>
			<div id="treeDivHight" style="overflow:auto;height:100%;">
				 <div id="fastQueryList" uitype="MultiNav" datasource="initBoxData"></div> 
	             <div id="dictionaryTypeTree" uitype="Tree" children="initTreeData" on_lazy_read="loadNode" on_click="dictionaryTypeTreeClick" click_folder_mode="1"></div>
		    </div>
        </div>
		<div id="centerMain" position ="center">
			<table class="cap-table-fullWidth" width="100%">
			     <tr>
			        <td class="cap-td" style="text-align: left;padding:5px" nowrap="nowrap">
			        	<span uitype="PullDown" id ="dictionaryType" mode="Single" value_field="id" label_field="text" value="all" width="100" datasource="initDictionaryType" on_change="itemTypeChange"></span>
			        	<span id="testDictionaryFilter" uitype="ClickInput" emptytext="请输入编码或名称" on_iconclick="searchDictionaryItem" on_keydown="keyDown" icon="search" editable="true" width="240"></span>
			        </td>
			        <td class="cap-td" style="text-align: right;padding:5px" nowrap="nowrap">
	             	    <span id="ensureDictionary" uitype="button" on_click="ensureDictionary" label="确定"></span>
	             	    <span id="clearBtn" uitype="Button" onclick="clearValue()" label="清空"></span>
						<span id="closeBtn" uitype="Button" onclick="closeWin()" label="取消"></span>
			        </td>
			    </tr>
			</table>
			<table class="cap-table-fullWidth">
			    <tr>
			        <td class="cap-td">
						<table uitype="Grid" id="testDictionaryItem" primarykey="dictionaryCode" colhidden="false" datasource="initTestDictionaryData" pagination="false" selectrows="single"
						 	resizewidth="getBodyWidth" resizeheight="getBodyHeight">
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
		var callbackMethod = "<c:out value='${param.callbackMethod}'/>";
		var sourceModuleId = '${param.sourceModuleId}';
		var codeVal = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("code"))%>;
		codeVal = codeVal != null ? codeVal.replace(/\\${([\w]*)}/g, "$1") : null;
	    var testDictionaryTypeVO = {};
		var curNodeId = "";
		$(document).ready(function(){
			comtop.UI.scan();   //扫描
			if(codeVal != null && codeVal != ""){
				var dicItem = queryDicItemVOByCode(codeVal);
				if(dicItem){
					var sourceNode = cui("#dictionaryTypeTree").getNode(dicItem.classifyId);
			    	if(sourceNode) {	//需要自动定位到对应实体应用方便于用户选择
			    		sourceNode.activate();
						sourceNode.expand();
						//定位到对应的选中的项
						$(".bl_box_left").scrollTop($(".dynatree-active").offset().top-($(".bl_box_left").height()/3));
						dictionaryTypeTreeClick(sourceNode);
						cui("#testDictionaryItem").selectRowsByPK(codeVal, true);
			    	}
				}
			}
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
		
	  	//确认选择字典项
	    function ensureDictionary(){
	    	var rowData = cui("#testDictionaryItem").getSelectedRowData();
	    	if(rowData && rowData.length > 0){
	    		window.opener[callbackMethod](rowData[0]);
	    		closeWin();
	    	} else {
	    		cui.alert("请选择选择数据字典。");
	    	}
	    }
	  	
	  	//清空
		function clearValue(){
			window.opener[callbackMethod]('');
			closeWin();
		}
		
		//关闭窗口
		function closeWin(){
			window.close();
		}
	    
	    /**
		 * 新增树节点刷新事件 
		 * @param nodeId当前节点ID
		 * @param parentNodeIdnodeId当前节点父ID
		 * @param directory新增节点目录的类型，same：新增同级目录，child新增下级目录
		 */
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
			var curNodeId = node.getData().key;
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
				var node=cui('#dictionaryTypeTree').getNode(curNodeId);
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
			dwr.TOPEngine.setAsync(false);
			TestmodelDicClassifyAction.fastQueryClassify(keyword,function(data){
				var len = data.length ;
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
	     * 根据字典编码获取字典
	     * 
	     * @param dictionaryCode 字典分类dictionaryCode
	     * @return 字典分类集合
	     */
		function queryDicItemVOByCode(dictionaryCode){
			var ret = null;
			dwr.TOPEngine.setAsync(false);
			TestmodelDicItemAction.readDicItemVOByCode(dictionaryCode, function(data){
				ret = data;
			});
			dwr.TOPEngine.setAsync(true);
			return ret;
		}
		
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
	</script>
</body>
</html>