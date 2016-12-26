<!doctype html>
<%
  /**********************************************************************
	* 文档操作记录
	* 2015-9-25 CAP 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<html>
<head>
    <title>文档操作记录列表</title>
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
</style>
<body style="overflow-y:hidden;">
<div uitype="Borderlayout"  id="body"> 
	<div id="area" position="left" width="200" collapsable="true" show_expand_icon="true">
		<div>
			<div id="domainTree" uitype="Tree" checkbox="false" select_mode="1" children="domainData" on_click="onclickNode"></div>
		</div>
	</div>
	<div id="centerMain" position ="center">
	</div>
</div>
<top:script src="/cap/dwr/interface/BizDomainAction.js" />
<script language="javascript">
	var bizDomainId = "${param.bizDomainId}";
	var rootIdList=[];
	window.onload = function(){
		comtop.UI.scan();	
		if(rootIdList){
			childNodeLode(rootIdList);
		}
		cui("#domainTree").getNode(bizDomainId).activate(true);
		setCenterUrlForClik(bizDomainId,"read");
	}
	//初始加载根节点 (tree)
	function domainData(obj){
		dwr.TOPEngine.setAsync(false);
		BizDomainAction.queryDomainList(function(data){
			if(data.count>0){
				var initData = [];
				var count=0;
				sortDomian(data.list);
		    	for(var i=0;i<data.list.length;i++){
		    		if(data.list[i].paterId ==null || data.list[i].paterId ==""){
		    			rootIdList[count]=data.list[i].id;
		    			var item={'title':data.list[i].name,'key':data.list[i].id};
			    		initData.push(item);
			    		count++;
		    		}
		    	}
		    	obj.setDatasource(initData);
			}
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
			if(data.count>0){
				sortDomian(data.list);
				for(var i=0;i<data.list.length;i++){
					if(data.list[i].paterId == rootId){
						cui("#domainTree").getNode(rootId).addChild({'title':data.list[i].name,'key':data.list[i].id});
						lodeNode(data.list[i].id);
					}
				}
			}
		});
		dwr.TOPEngine.setAsync(true);
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
	
	//设置右侧Tab页 (单击业务域)
	function setCenterUrlForClik(selectDomainId,editType){ 
		var contentUrl = '<%=request.getContextPath() %>/cap/bm/doc/operLog/DocOperLogList.jsp?bizDomainId=' + selectDomainId;
		cui('#body').setContentURL("center",contentUrl);	
	}
	
	//点击节点查看团队 
	function onclickNode(node, event){
		selectDomainId=node.getData("key");
		setCenterUrlForClik(selectDomainId,"read");
	}
</script>
</body>
</html>