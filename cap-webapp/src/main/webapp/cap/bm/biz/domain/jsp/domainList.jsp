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
	margin-top :18px;
	}
</style>
<body>
	<div id="buttonDiv" class="divTreeBtn">
		<span id="addNode" uitype="button" label="新增" menu="inserDomain"></span>
		<span id="upBtn" uitype="button" label="操作" menu="operate"></span>
		<span id="deleteNode" uitype="button" label="删除" on_click="deleteDomain" ></span>
	</div>
	<div>
		<div id="domainTree" uitype="Tree" checkbox="false" select_mode="1" children="domainData" on_click="onclickNode"></div>
	</div>
	<top:script src="/cap/dwr/interface/BizDomainAction.js" />
<script type="text/javascript">
	var selectNodeId = "${param.selectNodeId}";
	var treeScope = "${param.treeScope}";
	var rootIdList=[];
	var selectDomainId;
	window.onload = function(){
		comtop.UI.scan();
		if(rootIdList){
			childNodeLode(rootIdList);
		}
		parent.setCenterUrlForClik(selectDomainId,"read");
		if(selectNodeId){
			cui("#domainTree").getNode(selectNodeId).activate(true);
			parent.setCenterUrlForClik(selectNodeId,"read");
		}
		else if(selectDomainId){
			cui("#domainTree").getNode(selectDomainId).activate(true);
		}
		
		if(treeScope == "document"){ //按钮隐藏
			cui("#buttonDiv").hide();
		}
		
	}
	
	//新增按钮初始化
	var inserDomain = {
	datasource: [
         {id:'insertSameDomain',label:'新增同级'},
         {id:'insertSubDomain',label:'新增下级'}
    ],
    on_click:function(obj){
    	if(obj.id=='insertSameDomain'){
    		insertSameDomain();
    	}else{
    		insertSubDomain();
    	}
    }
};
	//操作按钮初始化
	var operate = {
			datasource: [
		         {id:'upFunction',label:'上移'},
		         {id:'downFunction',label:'下移'}
		    ],
		     on_click:function(obj){
		     	if(obj.id=='upFunction'){
		     		upFunction();
		     	}else{
		     		downFunction();
		     	}
		     }
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
		    	selectDomainId=rootIdList[0];
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
	
	//新增同级
	function insertSameDomain(){
		var selectNode=cui("#domainTree").getActiveNode();
		if(selectNode && selectNode.getData('key')!="_1"){
			var parentId=selectNode.parent().getData('key');
			parent.setCenterUrlForInsert(parentId,"edit");
		}
		else{
			parent.setCenterUrlForInsert("_1","edit");
		}
	}
	
	//新增下级
	function insertSubDomain(){
		if(cui("#domainTree").getActiveNode()){
			var selectNode=cui("#domainTree").getActiveNode();
			var selectNodeId=selectNode.getData('key');
			parent.setCenterUrlForInsert(selectNodeId,"edit");
		}
		else{
			insertSameDomain();
		}
	}
	
	//点击节点查看团队 
	function onclickNode(node, event){
		selectDomainId=node.getData("key");
		parent.setCenterUrlForClik(selectDomainId,"read");
	}
	
	//
	function deleteDomain(){
		var selectNode=cui("#domainTree").getActiveNode();
		
		if(selectNode){
			if(selectNode.hasChild()){
				parent.cui.alert("所选业务域还存在子业务域，请先删除子业务域");
			}
			else{
				var selectNodeKey=selectNode.getData('key');
				var isDelete=0;
				dwr.TOPEngine.setAsync(false);
				BizDomainAction.checkDomainIsUse(selectNodeKey,function(data){
					isDelete=data;
				});
		    	dwr.TOPEngine.setAsync(true);
		    	if(isDelete >0){
		    		parent.cui.alert("所选业务域已被引用，无法删除");
		    	}
		    	else{
		    		deleteNode(selectNodeKey);
		    	}
			}
		}
		else{
			parent.cui.alert("请选定待业务域");
		}
	}
	
	//删除业务域
	function deleteNode(selectNodeKey){
		parent.cui.confirm("确定要删除所选业务域及其下级所有子业务域吗？",{
			onYes:function(){
				var parentNode=cui("#domainTree").getNode(selectNodeKey).parent();
				if(parentNode.getData('key') != "_1"){
					var parentNode=cui("#domainTree").getNode(selectNodeKey).parent();
					cui("#domainTree").getNode(parentNode.getData('key')).activate(true);
					parent.setCenterUrlForClik(parentNode.getData('key'),"read");
				}
				else{
					var firstNode=parentNode.firstChild();
					cui("#domainTree").getNode(firstNode.getData('key')).activate(true);
					parent.setCenterUrlForClik(firstNode.getData('key'),"read");
				}
				cui("#domainTree").getNode(selectNodeKey).remove();
				dwr.TOPEngine.setAsync(false);
				BizDomainAction.deleteDomain(selectNodeKey);
		    	dwr.TOPEngine.setAsync(true);
		    	parent.cui.message("删除成功","success");
			}
		});
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
	
	//上移
	function downFunction(){
		var selectNode=cui("#domainTree").getActiveNode();
		if(selectNode){
			var nextNode=selectNode.next();
			if(nextNode){
				var cutDdmianVO;
				var nextDdmianVO;
				var cutKey=selectNode.getData('key');
				var nextKey=nextNode.getData('key');
				dwr.TOPEngine.setAsync(false);
				BizDomainAction.queryDomainById(cutKey,function(data){
					cutDdmianVO=data;
				});
				BizDomainAction.queryDomainById(nextKey,function(data){
					nextDdmianVO=data;
				});
				dwr.TOPEngine.setAsync(true);
				var temp=cutDdmianVO.sortNo;
				cutDdmianVO.sortNo=nextDdmianVO.sortNo;
				nextDdmianVO.sortNo=temp;
				dwr.TOPEngine.setAsync(false);
				BizDomainAction.saveDomain(cutDdmianVO);
				BizDomainAction.saveDomain(nextDdmianVO);
				selectNode.move(nextNode, "after");
				dwr.TOPEngine.setAsync(true);
			}
		}
		else{
			parent.cui.message("请选定待移动节点","warn");
		}
	}
	
	//下移
	function upFunction(){
		var selectNode=cui("#domainTree").getActiveNode();
		if(selectNode){
			var preNode=selectNode.prev();
			if(preNode){
				var cutDdmianVO;
				var preDdmianVO;
				var cutKey=selectNode.getData('key');
				var preKey=preNode.getData('key');
				dwr.TOPEngine.setAsync(false);
				BizDomainAction.queryDomainById(cutKey,function(data){
					cutDdmianVO=data;
				});
				BizDomainAction.queryDomainById(preKey,function(data){
					preDdmianVO=data;
				});
				dwr.TOPEngine.setAsync(true);
				var temp=cutDdmianVO.sortNo;
				cutDdmianVO.sortNo=preDdmianVO.sortNo;
				preDdmianVO.sortNo=temp;
				dwr.TOPEngine.setAsync(false);
				BizDomainAction.saveDomain(cutDdmianVO);
				BizDomainAction.saveDomain(preDdmianVO);
				selectNode.move(preNode, "before");
				dwr.TOPEngine.setAsync(true);
			}
		}
		else{
			parent.cui.message("请选定待移动节点","warn");
		}
	}
</script>
</body>
</html>