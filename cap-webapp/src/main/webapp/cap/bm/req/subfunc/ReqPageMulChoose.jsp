<!doctype html>
<%
  /**********************************************************************
	* cap界面原型选择界面
	* 2016-1-05 CAP 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<html>
<head>
    <title>cap界面原型选择界面</title>
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
.buttonDiv{
	margin-right:10px;
	margin-bottom:4px;
	margin-top:4px;
}
.gridDiv{
	margin-left:10px;
}
</style>
<body style="overflow-y:hidden;">
<div uitype="Borderlayout"  id="body"> 
	<div id="area" position="left" width="200" collapsable="true" show_expand_icon="true">
		<div>
			<div id="domainTree" uitype="Tree" checkbox="false" select_mode="1" children="domainData" on_click="onclickNode" on_lazy_read="childData"></div>
		</div>
	</div>
	<div id="centerMain" position ="center">
		<div class="buttonDiv" style="float:right">
			<span uitype="button" on_click="checkBtn" id="btnCheck" label="确 定"></span> 
			<span uitype="button" on_click="cancleBtn" id="btnCancle" label="取 消"></span> 
		</div>
		<div class="gridDiv">
			<table uitype="Grid" id="ReqPageGrid" gridheight="auto" ellipsis="true"  colhidden="false"   pagination="false" selectrows="multi"  datasource="initGridData" resizeheight="resizeHeight"  resizewidth="resizeWidth" >
				<tr>
					<th width="5%"><input type="checkbox" /></th>
					<th bindName="cname" width="17%">界面标题</th>
					<th bindName="modelName" width="17%">界面文件名</th>
					<th width="51%" bindName="description">界面说明</th>
					<th width="10%" renderStyle="text-align: center;" render="pageView">预览</th>
					<!-- <th width="5%" renderStyle="text-align: center;" render="imageDownLoad">下载图片</th> -->
				</tr>
			</table>
		</div>
	</div>
</div>
<top:script src="/cap/dwr/interface/ReqTreeAction.js" />
<top:script src="/cap/dwr/interface/PrototypeFacade.js" />
<top:script src="/cap/dwr/interface/PrototypeAction.js" />
<script language="javascript">
	var selectNodeId = "${param.domainId}";
	var ReqTreeVO = {};
	//树节点的modelpackage
	var modelPackage = "";
	//图片预览，图片在服务器中的访问路径的前缀
	var imageVisitPrefix = "";
	window.onload = function(){
		comtop.UI.scan();
		//获取图片访问路径前缀
		getImageVisitPrefix();
		if(selectNodeId){
			var node = cui("#domainTree").getNode(selectNodeId);
			node.activate(true);
			//获取当前初始化选中的树节点的modelpackage
			modelPackage = getNodeModelPackage(node);
			//加载表格数据
			cui("#ReqPageGrid").loadData();
		}
	}
	
	//初始加载根节点 (tree)
	function domainData(obj){
		dwr.TOPEngine.setAsync(false);
		ReqTreeAction.queryViewReqTreeList(ReqTreeVO,function(data){
			if(data.count>0){
				var initData = [];		
		    	for(var i=0;i<data.list.length;i++){
		    		if(data.list[i].parentId ==null || data.list[i].parentId ==""){
		    			var item={'title':data.list[i].name,'key':data.list[i].id,'type':data.list[i].type,'parentId':data.list[i].parentId,'code' : data.list[i].code,'sortNo':data.list[i].sortNo,'isLazy':true};
			    		initData.push(item);	
		    		}
		    	}
		    	if(!selectNodeId){
	    			selectNodeId=initData[0].key;
	    		}
		    	obj.setDatasource(initData);
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//加载子节点
	function childData(node){
		var parentId=node.getData("key");
		dwr.TOPEngine.setAsync(false);
		ReqTreeAction.queryViewReqListById(parentId,function(data){
			if(data.length>0){
		    	for(var i=0;i<data.length;i++){
		    		var item={'title':data[i].name,'key':data[i].id,'type':data[i].type,'parentId':data[i].parentId,'code' : data[i].code,'sortNo':data[i].sortNo,'isLazy':true};
		    		node.addChild(item);
		    	}
			}
			else{
				node.setData('isLazy', false);
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 220;
	}
	
	//grid高度
	function resizeHeight(){
		return (document.documentElement.clientHeight || document.body.clientHeight) -60;
	}
	
	//grid数据源	
	function initGridData(tableObj,query){  
		if(!modelPackage){
			 tableObj.setDatasource([], 0);
			 return;
		}
		dwr.TOPEngine.setAsync(false);
		PrototypeFacade.queryPrototypesByModelPackage(modelPackage, function(data){
			 tableObj.setDatasource(data, data.length);
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	/**
	 * 点击树节点
	 */
	function onclickNode(node, event){
		var id = node.getData("key");
		selectNodeId=id;
		modelPackage = getNodeModelPackage(node);
		cui("#ReqPageGrid").loadData();
	}
	
	/**
	 * 获取树节点的modelpackage
	 */
	function getNodeModelPackage(node){
		var codeArray = [];
		while(node.getData("parentId")){
			codeArray.unshift(node.getData("code"));
			node = node.parent();
		}
		codeArray.unshift(node.getData("code"));
		return "com.comtop.prototype." + codeArray.join(".");
	}
	
	//选择确定
	function checkBtn(){
		var selects = cui("#ReqPageGrid").getSelectedRowData();
		if(selects == null || selects.length == 0){
			cui.alert("请选择界面原型");
			return;
		}
		
		if(window.parent.chooseReqPageCallback){
			window.parent.chooseReqPageCallback(selects);
			cancleBtn();
		}else if(window.opener && window.opener.chooseReqPageCallback){
			window.opener.chooseReqPageCallback(selects);
			window.close();
		}
	}
	//取消
	function cancleBtn(){
		if(window.opener){
			window.close();
		}else{
			window.parent.dialog.hide();	
		}
	}
	
	/**
   	 * 获取界面原型图片在服务器上的访问地址的前缀，用于图片预览
   	 */
   	function getImageVisitPrefix(){
   		dwr.TOPEngine.setAsync(false);
   		PrototypeAction.getImageVisitPrefix(function(data){
   			imageVisitPrefix = data;
		});
		dwr.TOPEngine.setAsync(true);
   	}
	
	//表格预览列渲染
	function pageView(rd, index, col){
		var operate = "";
		//录入已有界面原型，没有预览HTML的功能
		if(rd.type == 0){
			operate += "<span class='cui-icon' title='预览HTML' style='font-size:11pt;color:#545454;cursor:pointer' onclick=\"window.open('${pageScope.cuiWebRoot}/prototype/"+rd.url+"')\">&#xf002;</span>";
		}
		//如果无法获取预览图片地址路径的前缀，则不渲染预览按钮
		if(imageVisitPrefix){
			if(rd.type == 0){
				operate += "&nbsp;&nbsp;";
			}
			operate += "<span class='cui-icon' title='预览图片' style='font-size:11pt;color:#545454;cursor:pointer' onclick=\"window.open('"+imageVisitPrefix+rd.imageURL+"')\">&#xf03e;</span>"
		}
		return operate;
	}
	
</script>
</body>
</html>