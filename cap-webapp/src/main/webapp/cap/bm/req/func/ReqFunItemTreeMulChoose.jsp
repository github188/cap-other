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
.queryBtn{
	padding-left:165px
	}
</style>
<body>
	<div class="top_header_wrap">
		<div class="thw_operate">
			<span uitype="button" id="btnSave" label="确 定" on_click="checkBtn"></span> 
			<span uitype="button" id="btnReturn" label="取 消" on_click="cancelBtn"></span>
		</div>
	</div>
	<div>
		<span uitype="ClickInput" id="keyword" name="keyword" emptytext="请输入节点名称关键字查询" on_iconclick="fastQuery"  icon="search" enterable="true"
			  editable="true" width="200" on_keydown="keyDownQuery"></span>
		</br>
		<div class="queryBtn" id="queryDiv">
			<img title="上一个" src="<%=request.getContextPath() %>/top/sys/images/func_up.png" style="cursor:pointer" onclick="nextResult()">
			<img title="下一个" src="<%=request.getContextPath() %>/top/sys/images/func_down.png" style="cursor:pointer" onclick="preResult()">
		</div>
		<div id="funItemTree" uitype="Tree" checkbox="true" select_mode="2" children="domainData" click_folder_mode="1"></div>
	</div>
	<top:script src="/cap/dwr/interface/ReqTreeAction.js" />
<script type="text/javascript">
	var selectNodeId = "<c:out value='${param.domainId}'/>";
	var callSelectedFuncItemFlag = "<c:out value='${param.callSelectedFuncItemFlag}'/>";
	var selectedData = "<c:out value='${param.selectedData}'/>";
	var ReqTreeVO = {};
	var queryResultList=[];
	var position=0;
	var rootIdList=[];
	window.onload = function(){
		comtop.UI.scan();
		$('#queryDiv').hide();
		if(rootIdList){
			childNodeLode(rootIdList);
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
		    			var item={'title':data.list[i].name,'key':data.list[i].id,'type':data.list[i].type,'parentId':data.list[i].parentId,'sortNo':data.list[i].sortNo,'hideCheckbox':true};
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
	
	//加载子节点
	function lodeNode(parentId){
		dwr.TOPEngine.setAsync(false);
		ReqTreeAction.queryViewReqListById(parentId,function(data){
			if(data.length>0){
				sortReqTree(data);
		    	for(var i=0;i<data.length;i++){
		    		if(data[i].type=='1'){
		    			var item={'title':data[i].name,'key':data[i].id,'type':data[i].type,'parentId':data[i].parentId,'sortNo':data[i].sortNo,'hideCheckbox':true};
		    		}
		    		else{
		    			var item={'title':data[i].name,'key':data[i].id,'type':data[i].type,'parentId':data[i].parentId,'sortNo':data[i].sortNo};
		    		}
		    		if(callSelectedFuncItemFlag == "true"){
		    			selectedNode(item);
		    		}
		    		cui("#funItemTree").getNode(parentId).addChild(item);
		    		lodeNode(data[i].id);
		    	}
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	/**
	* 初始化时选中已选的节点
	* @param item 需要判断的功能项或功能子项
	*/
	function selectedNode(item){
		var funcItem = selectedData.split(",");
		if(!funcItem || funcItem.length == 0){
			return ;
		}
		for(var i = 0 ; i < funcItem.length ; i++ ){
			if(funcItem[i] == item.key){
				item.select = true;
			}
		}
		
	}
	
	//
	function checkBtn(){
		if(cui("#funItemTree").getSelectedNodes("false").length >0){
			var nodeList=cui("#funItemTree").getSelectedNodes("false");
			var nodeData=[];
			for(var i=0;i<nodeList.length;i++){
				nodeData.push(nodeList[i].dNode.data)
			}
			window.opener.chooseFunItemCallBack(nodeData);
			window.close();
		}
		else{
			cui.alert("未选择任何功能项或功能子项,点击确定关闭当前界面");
		}
	}
	
	function cancelBtn(){
		//parent.dialog.hide();
		window.close();
	} 
	
	//键盘回车键快速查询 
	function keyDownQuery() {
		if ( event.keyCode ==13) {
			fastQuery();
		}
	}
	
	//快速查询
	function fastQuery(){
		position=0;
		var keyword = cui('#keyword').getValue();
		if(keyword){
			$('#queryDiv').show();
			var ReqTreeVO={'name':keyword};
			dwr.TOPEngine.setAsync(false);
			ReqTreeAction.queryViewReqTreeList(ReqTreeVO,function(data){
				queryResultList=sortReqTree(data.list);
			});
			dwr.TOPEngine.setAsync(true);
			cui("#funItemTree").getNode(queryResultList[0].id).activate(true);
		}
		else{
			$('#queryDiv').hide();
		}
	}
	
	function nextResult(){
		var length=queryResultList.length-1;
		position+=1;
		if(position>length){
			position=0;
		}
		cui("#funItemTree").getNode(queryResultList[position].id).activate(true);
	}
	
	function preResult(){
		var length=queryResultList.length-1;
		position-=1;
		if(position<0){
			position=length;
		}
		cui("#funItemTree").getNode(queryResultList[position].id).activate(true);
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