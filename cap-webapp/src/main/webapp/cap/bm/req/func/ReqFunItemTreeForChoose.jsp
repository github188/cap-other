<%
  /**********************************************************************
	* CAP功能项管理
	* 2015-11-03 姜子豪 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
<title>功能项选择</title>
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
	<div class="top_header_wrap">
		<div class="thw_operate">
			<span uitype="button" id="btnSave" label="确 定" on_click="checkBtn"></span> 
			<span uitype="button" id="btnReturn" label="取 消" on_click="cencelBtn"></span>
		</div>
	</div>
	<div>
		<div id="domainTree" uitype="Tree" checkbox="false" select_mode="1" children="domainData" on_click="onclickNode" on_lazy_read="childData"></div>
	</div>
		<top:script src="/cap/dwr/interface/ReqTreeAction.js" />
	<top:script src="/cap/dwr/interface/BizDomainAction.js" />
	<top:script src="/cap/dwr/interface/ReqFunctionItemAction.js" />
<script type="text/javascript">
	var selectNodeId = "<c:out value='${param.selectNodeId}'/>";
	var rootIdList=[];
	var ReqTreeVO = {};
	window.onload = function(){
		comtop.UI.scan();
		if(rootIdList){
			for(var i=0;i<rootIdList.length;i++){
				cui("#domainTree").getNode(rootIdList[i]).setStyle('color:grey');
			}
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
		var type=node.getData("type");
		if(type != 2){
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
		    				if(data[i].type !=2){
		    					var item={'title':data[i].name,'key':data[i].id,'type':data[i].type,'parentId':data[i].parentId,'sortNo':data[i].sortNo,'isLazy':true};
		    				}
		    				else{
		    					var item={'title':data[i].name,'key':data[i].id,'type':data[i].type,'parentId':data[i].parentId,'sortNo':data[i].sortNo,'isLazy':false};
		    				}
		    			}
		    			else{
		    				var item={'title':data[i].name,'key':data[i].id,'type':data[i].type,'parentId':data[i].parentId,'sortNo':data[i].sortNo,'isLazy':false};
		    			}
			    		node.addChild(item);
			    		if(data[i].type != 2){
		    				cui("#domainTree").getNode(data[i].id).setStyle('color:grey');
		    			}
			    	}
				}
			});
			dwr.TOPEngine.setAsync(true);
		}
	}
	
	//
	function checkBtn(){
		if(cui("#domainTree").getActiveNode()){
			var selectNode=cui("#domainTree").getActiveNode();
			if(selectNode.getData("type") != 2){
				parent.cui.alert("该节点不是功能项！");
			}
			else{
				window.parent.chooseFunItemCallBack(selectNode.getData("title"),selectNode.getData("key"));
			}
		}
		else{
			parent.cui.alert("未选择功能项！");
		}
		cencelBtn();
	}
	
	function cencelBtn(){
		parent.dialog.hide();
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
</script>
</body>
</html>