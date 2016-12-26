<%
  /**********************************************************************
	* CAP业务域管理
	* 2015-11-03 姜子豪 新增
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
<title>业务域管理</title>
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_sys.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>cap/bm/common/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/top/js/jquery.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/engine.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/util.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/BizDomainAction.js'></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/cui.utils.js"></script>
</head>
<style>
.divTreeBtn {
	margin-left :20px;
	margin-top :18px;
	}
</style>
<body>
	<div class="top_header_wrap">
		<div class="thw_operate">
			<span uitype="button" id="but_confirm" label="确定" on_click="btnCheck"></span>
			<span uitype="button" label="关闭" on_click="btnClose"></span>
		</div>
	</div>
    <div position="center">
		<div id="domainTree" uitype="Tree" checkbox="false" select_mode="1" children="domainData" on_click="onclickNode"></div>
	</div>
	
<script type="text/javascript">
	var rootIdList=[];
	var selectDomainId="${param.selectDomainId}";
	window.onload = function(){
		comtop.UI.scan();
		childNodeLode(rootIdList);
		if(selectDomainId){
			cui("#domainTree").getNode(selectDomainId).activate(true);
		}
	}
	//初始加载根节点 (tree)
	function domainData(obj){
		dwr.TOPEngine.setAsync(false);
		BizDomainAction.queryDomainList(function(data){
			var initData = [];
			var count=0;
			sortDomian(data.list);
	    	for(var i=0;i<data.list.length;i++){
	    		if(data.list[i].paterId ==null || data.list[i].paterId ==" "){
	    			rootIdList[count]=data.list[i].id;
	    			var item={'title':data.list[i].name,'key':data.list[i].id};
		    		initData.push(item);
		    		count++;
	    		}
	    	}
	    	obj.setDatasource(initData);
			});
		dwr.TOPEngine.setAsync(true);
	}
	
	//加载子节点(tree)(递归加载) 
	function childNodeLode(rootList){
		for(var i=0;i<rootList.length;i++){
			lodeNode(rootList[i]);
		}
	}
	
	//加载子节点(tree)(递归加载) 
	function lodeNode(rootId){
		dwr.TOPEngine.setAsync(false);
		BizDomainAction.queryDomainList(function(data){
			sortDomian(data.list);
			for(var i=0;i<data.list.length;i++){
				if(data.list[i].paterId == rootId){
					cui("#domainTree").getNode(rootId).addChild({'title':data.list[i].name,'key':data.list[i].id});
					lodeNode(data.list[i].id);
				}
			}
			});
		dwr.TOPEngine.setAsync(true);
	}
	
	//点击节点查看团队 
	function onclickNode(node, event){
		selectDomainId=node.getData("key");
	}
	
	function btnCheck(){
		var selectNode = cui("#domainTree").getActiveNode();
		if(selectNode){
			window.parent.chooseDomainCallback(selectNode.getData("key"),selectNode.getData("title"));
		}
		else{
			parent.cui.alert("请选择业务域!");
			return;
		}
		btnClose();
	}
	
	//关闭
	function btnClose(){
		window.parent.dialog.hide(); 
	}
	
	//排序业务域
	function sortDomian(domainList){
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