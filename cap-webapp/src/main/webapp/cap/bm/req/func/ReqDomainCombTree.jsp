<%
  /**********************************************************************
	* CAP业务域管理
	* 2015-11-03 姜子豪 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
<title>业务域管理</title>
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
.divTreeBtn {
	margin-top :12px;
	margin-left:20px;
	}
</style>
<body>
	<div id="buttonDiv" class="divTreeBtn">
		<span id="upButton" uitype="button" label="上移" on_click="nodeButtonUp"></span>
		<span id="downButton" uitype="button" label="下移" on_click="nodeButtonDown"></span>
	</div>
	<div>
		<div id="domainTree" uitype="Tree" checkbox="false" select_mode="1" children="domainData" on_click="onclickNode" on_lazy_read="childData"></div>
	</div>
	<top:script src="/cap/dwr/interface/ReqTreeAction.js" />
	<top:script src="/cap/dwr/interface/BizDomainAction.js" />
	<top:script src="/cap/dwr/interface/ReqFunctionItemAction.js" />
	<top:script src="/cap/dwr/interface/ReqFunctionSubitemAction.js" />
<script type="text/javascript">
	var selectNodeId = "<c:out value='${param.selectNodeId}'/>";
	var rootIdList=[];
	var ReqTreeVO = {};
	var PNodeIdList=[];
	window.onload = function(){
		comtop.UI.scan();
		if(rootIdList[0]){
			if(selectNodeId){
				loadPNode(selectNodeId);
				cui("#domainTree").getNode(selectNodeId).activate(true);
			}
			var node=cui("#domainTree").getNode(selectNodeId);
			parent.setCenterUrlForClik(selectNodeId,node.getData("type"),"read");
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
		    			ReqTreeAction.queryViewReqListById(data.list[i].id,function(data){
		    				if(data.length>0){
		    					hasChild=true;
		    				}
		    			});
		    			if(hasChild){
		    				var item={'title':data.list[i].name,'key':data.list[i].id,'type':data.list[i].type,'parentId':data.list[i].parentId,'code' : data.list[i].code,'sortNo':data.list[i].sortNo,'isLazy':true};
		    			}
		    			else{
		    				var item={'title':data.list[i].name,'key':data.list[i].id,'type':data.list[i].type,'parentId':data.list[i].parentId,'code' : data.list[i].code,'sortNo':data.list[i].sortNo,'isLazy':false};
		    			}
			    		initData.push(item);	
			    		count++;
		    		}
		    	}
		    	obj.setDatasource(initData);
		    	if(!selectNodeId){
		    		selectNodeId=rootIdList[0];
		    	}
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
	    				var item={'title':data[i].name,'key':data[i].id,'type':data[i].type,'parentId':data[i].parentId,'code' : data[i].code,'sortNo':data[i].sortNo,'isLazy':true};
	    			}
	    			else{
	    				var item={'title':data[i].name,'key':data[i].id,'type':data[i].type,'parentId':data[i].parentId,'code' : data[i].code,'sortNo':data[i].sortNo,'isLazy':false};
	    			}
		    		node.addChild(item);
		    	}
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	function onclickNode(node, event){
		var type = node.getData("type");
		var id = node.getData("key");
		var codeArray = [];
		while(node.getData("parentId")){
			codeArray.unshift(node.getData("code"));
			node = node.parent();
		}
		codeArray.unshift(node.getData("code"));
		parent.setCenterUrlForClik(id,type,"read",codeArray.join("."));
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
	
	//下移
	function nodeButtonDown(){
		var selectNode=cui("#domainTree").getActiveNode();
		if(selectNode){
			var nextNode=selectNode.next();
			if(nextNode){
				var cutKey=selectNode.getData('key');
				var nextKey=nextNode.getData('key');
				var cutType=selectNode.getData('type');
				var nextType=nextNode.getData('type');
				var cutSortNo=selectNode.getData('sortNo');
				var nextSortNo=nextNode.getData('sortNo');
				if(cutSortNo==nextSortNo){
					nextSortNo+=1;
				}
				changNodeSortNo(cutKey,cutType,nextSortNo);
				changNodeSortNo(nextKey,nextType,cutSortNo);
				selectNode.move(nextNode, "after");
			}
		}
		else{
			parent.cui.message("请选定待移动节点","warn");
		}
	}
	
	//上移
	function nodeButtonUp(){
		var selectNode=cui("#domainTree").getActiveNode();
		if(selectNode){
			var preNode=selectNode.prev();
			if(preNode){
				var cutKey=selectNode.getData('key');
				var preKey=preNode.getData('key');
				var cutType=selectNode.getData('type');
				var preType=preNode.getData('type');
				var cutSortNo=selectNode.getData('sortNo');
				var preSortNo=preNode.getData('sortNo');
				if(cutSortNo==preSortNo){
					cutSortNo+=1;
				}
				changNodeSortNo(cutKey,cutType,preSortNo);
				changNodeSortNo(preKey,preType,cutSortNo);
				selectNode.move(preNode, "before");
			}
		}
		else{
			parent.cui.message("请选定待移动节点","warn");
		}
	}
	
	function changNodeSortNo(id,type,sortNo){
		if(type=== "1"){
			dwr.TOPEngine.setAsync(false);
			BizDomainAction.updateSortNoById(id,sortNo);
			dwr.TOPEngine.setAsync(true);
		}
		else if(type=== "2"){
			dwr.TOPEngine.setAsync(false);
			ReqFunctionItemAction.updateSortNoById(id,sortNo);
			dwr.TOPEngine.setAsync(true);
		}
		else{
			dwr.TOPEngine.setAsync(false);
			ReqFunctionSubitemAction.updateSortNoById(id,sortNo);
			dwr.TOPEngine.setAsync(true);
		}
	}
	
	function loadPNode(nodeId){
		dwr.TOPEngine.setAsync(false);
		ReqTreeAction.queryViewPTreeById(nodeId,function(data){
			if(data){
				for(var i=data.length-1;i>0;i--){
					var node=cui("#domainTree").getNode(data[i].id);
					childData(node);
				}
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
</script>
</body>
</html>