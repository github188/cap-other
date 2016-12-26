<%
/**********************************************************************
* 页面选择界面
* 2016-11-2 zhuhuanhui 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <title>页面选择界面</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
    <top:script src='/cap/dwr/engine.js'></top:script>
    <top:script src='/cap/dwr/util.js'></top:script>
    <top:script src='/cap/dwr/interface/ReqTreeAction.js'></top:script>
    <top:script src='/cap/dwr/interface/BizDomainAction.js'></top:script>
    <top:script src='/cap/dwr/interface/ReqFunctionItemAction.js'></top:script>
    <top:script src='/cap/dwr/interface/ReqFunctionSubitemAction.js'></top:script>
    <top:script src='/cap/dwr/interface/PrototypeFacade.js'></top:script>
	<style type="text/css">
		img{
		  margin-left:5px;
		}
	</style>
</head>
<body>
	<div uitype="Borderlayout" id="body" is_root="true" on_sizechange="sizechange"> 
		<div id="top-area" position="top" style="overflow:hidden" height="40">
			<div style="margin: 5px;">
				<span uitype="Label" value="选择界面列表" class="cap-label-title" size="12pt"></span>
				<div style="float: right;">
					<span id="saveToPage" uitype="Button" onclick="ensure()" label="确定"></span> 
					<span id="closeTemplate" uitype="Button" onclick="colseWin()" label="关闭"></span> 
				</div>       
			</div>
        </div>
		<div id="left-area" position="left" style="overflow:hidden" width="200" collapsable="true" show_expand_icon="true">       
			<div id="treeDivHight" style="overflow:auto;height:100%; padding-left:5px;">
				<div id="domainTree" uitype="Tree" checkbox="false" select_mode="1" children="domainData" on_click="onclickNode" on_lazy_read="childData"></div>
			</div>
        </div>
		<div id="center-area" position ="center">
			<table class="cap-table-fullWidth">
			    <tr>
			        <td class="cap-td">
			        	<table uitype="Grid" id="prototypeList" primarykey="url" selectrows="single" colhidden="false" datasource="initPrototypeData" pagination="false"
						 	resizewidth="getBodyWidth" resizeheight="getBodyHeight">
							<thead>
								<tr>
								    <th style="width:25px"></th>
									<th style="width:35px" renderStyle="text-align: center;" bindName="1">序号</th>
									<th style="width:30%" renderStyle="text-align: left" bindName="cname">页面中文名</th>
									<th style="width:25%" renderStyle="text-align: left" bindName="modelName">页面英文名</th>
									<th style="width:30%" renderStyle="text-align: left" bindName="description">描述</th>
								</tr>
							</thead>
						</table>
			        </td>
			    </tr>
			</table>
		</div>
	</div>
	<script type="text/javascript">
	var reqFunctionSubitemId = "<%=request.getParameter("reqFunctionSubitemId")%>";
	var modelIds = "${param.modelIds}";	// 使用;区别
	var callbackMethod = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("callbackMethod"))%>;
	var propertyName = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("propertyName"))%>;
	var value = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("value"))%>;
	var rootIdList=[];
	var ReqTreeVO = {};

	$(document).ready(function(){
		if(modelIds) {
			var modelId = modelIds.split(";")[0];
			dwr.TOPEngine.setAsync(false);
			PrototypeFacade.loadModel(modelId, function (prototypeVO) {
				reqFunctionSubitemId = prototypeVO.functionSubitemId;
				value = prototypeVO.url;
			});
			dwr.TOPEngine.setAsync(true);

		}

		comtop.UI.scan();
		if(reqFunctionSubitemId){
			positionTreeNode(reqFunctionSubitemId);
			cui("#prototypeList").selectRowsByPK(value.replace(/\"/g, '').replace(/\.\.\//g, ''), true);
		}

	});
	
	/**
	 * 定位树节点
	 * @param nodeId 节点Id
	 * @param query Json包含分页信息和题头排序信息
	 */
	function positionTreeNode(nodeId){
		loadPNode(nodeId);
		var sourceNode = reqFunctionSubitemId ? cui("#domainTree").getNode(reqFunctionSubitemId) : null;
    	if(sourceNode) {	//有来源实体需要自动定位到对应实体应用方便于用户选择
    		sourceNode.activate();
			//定位到对应的选中的项
    		$("#treeDivHight").scrollTop($(".dynatree-active").offset().top-($(".bl_box_left").height()/3));
    	}
	}
	
	//初始加载根节点 (tree)
	function domainData(obj){
		dwr.TOPEngine.setAsync(false);
		ReqTreeAction.queryViewReqTreeList(ReqTreeVO,function(data){
			if(data.count>0){
				var initData = [];		
				var count=0;
				sortReqTree(data.list);
		    	for(var i=0;i<data.list.length;i++){
		    		if(data.list[i].parentId ==null || data.list[i].parentId ==""){
		    			rootIdList[count]=data.list[i].id;
		    			var hasChild=false;
		    			ReqTreeAction.queryViewReqListById(data.list[i].id, function(data){
		    				if(data.length>0){
		    					hasChild=true;
		    				}
		    			});
		    			if(hasChild){
		    				var item={'title':data.list[i].name,'key':data.list[i].id,'type':data.list[i].type,'parentId':data.list[i].parentId,'sortNo':data.list[i].sortNo,'isLazy':true};
		    			}
		    			else{
		    				var item={'title':data.list[i].name,'key':data.list[i].id,'type':data.list[i].type,'parentId':data.list[i].parentId,'sortNo':data.list[i].sortNo,'isLazy':false};
		    			}
			    		initData.push(item);	
			    		count++;
		    		}
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
			sortReqTree(data);
			if(data.length>0){
		    	for(var i=0;i<data.length;i++){
		    		var hasChild=false;
	    			ReqTreeAction.queryViewReqListById(data[i].id,function(data){
	    				if(data.length>0){
	    					hasChild=true;
	    				}
	    			});
	    			if(hasChild){
	    				var item={'title':data[i].name,'key':data[i].id,'type':data[i].type,'parentId':data[i].parentId,'sortNo':data[i].sortNo,'isLazy':true};
	    			}
	    			else{
	    				var item={'title':data[i].name,'key':data[i].id,'type':data[i].type,'parentId':data[i].parentId,'sortNo':data[i].sortNo,'isLazy':false};
	    			}
		    		node.addChild(item);
		    	}
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//排序业务域
	function sortReqTree(domainList){
		if(domainList.length>1){
			var temp;
			for(var i=0;i<domainList.length-1;i++){
				for(var j=i+1;j<domainList.length;j++){
					if(domainList[i].sortNo>domainList[j].sortNo){
						temp=domainList[i];
						domainList[i]=domainList[j];
						domainList[j]=temp;
					}
				}
			}
		}
		return domainList;
	}
	
	function loadPNode(nodeId){
		dwr.TOPEngine.setAsync(false);
		ReqTreeAction.queryViewPTreeById(nodeId,function(data){
			if(data){
				for(var i=data.length-1; i>0; i--){
					var node=cui("#domainTree").getNode(data[i].id);
					childData(node);
				}
			}
		});
		dwr.TOPEngine.setAsync(true);
	}

	/**
	 * 初始化页面模板列表
	 * @param gridObj 表格组件对象
	 * @param query Json包含分页信息和题头排序信息
	 */
	function initPrototypeData(gridObj, query) {
		var datasource = [];
		dwr.TOPEngine.setAsync(false);
		PrototypeFacade.queryPrototypesByXpath("prototype[functionSubitemId='" + reqFunctionSubitemId + "']", function(data) {
			datasource = data;
		});
		dwr.TOPEngine.setAsync(true);
		gridObj.setDatasource(datasource, datasource.length);
	}
	
	/**
	 * 树节点点击事件
	 * @param node 节点对象
	 * @param event 事件对象
	 */
	function onclickNode(node, event){
		var type = node.getData("type");
		var id = node.getData("key");
		if(type == '1' || type == '2'){
			cui("#prototypeList").setDatasource([], 0);
		} else if(type == '3'){
			reqFunctionSubitemId = id;
			cui("#prototypeList").loadData();
		}
	}
	
	/**
	 * 根据业务域ID查询业务域编码
	 * @param domainId 业务域ID
	 */
	function getBizDomainCode(domainId){
		var code = "";
		dwr.TOPEngine.setAsync(false);
		BizDomainAction.queryDomainById(domainId, function(data){
			code = data ? data.code : code;
		});
		dwr.TOPEngine.setAsync(true);
		return code;
	}
	
	/**
	 * 通过功能项ID查询功能项编码
	 * @param reqFunItemId 功能项ID
	 */
	function getReqFunItemCode(reqFunItemId){
		var code = "";
		dwr.TOPEngine.setAsync(false);
		ReqFunctionItemAction.queryReqFunctionItemById(reqFunItemId, function(data){
				code = data ? data.code : code;
		});
		dwr.TOPEngine.setAsync(true);
		return code;
	}
	
	/**
	 * 表格自适应宽度
	 */
	function getBodyWidth() {
	    return parseInt(jQuery("#center-area").css("width")) - 10;
	}

	/**
	 * 表格自适应高度
	 */
	function getBodyHeight() {
	    return (document.documentElement.clientHeight || document.body.clientHeight) - 71;
	}
	
	//确定按钮回调函数
	function ensure(){
		var rowData = cui("#prototypeList").getSelectedRowData();
		if(rowData){
			window.opener[callbackMethod](propertyName, rowData[0]);
			colseWin();
		} else {
			cui.alert("请选择界面.");
		}
	}
	
	//关闭窗口
	function colseWin(){
		window.close();
	}
	
	//布局宽高改变时回调函数
	function sizechange(){
		cui("#prototypeList").resize();
	}
		
	</script>
</body>
</html>