<%
  /**********************************************************************
	* CIP元数据建模----新版团队管理
	* 2015-10-15 姜子豪 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
<title>团队管理</title>
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
	margin-left :15px;}
.spanTop {
	font-family: "Microsoft Yahei";
	font-size: 20px;
	color: #0099FF;
	margin-left: 20px;
	float: left;
	line-height:45px;}
</style>
<body>
	<div uitype="Borderlayout" id="border" is_root="true" style="position:relative;width: 100%;height:auto;">
		<div position="left" width="150px">
			<div class="divTreeBtn">
			    <span id="addNode" uitype="button" label="新增" menu="insertTeam"></span>
				<span id="deleteNode" uitype="button" label="删除" on_click="deleteTeam" ></span>
			</div>
			<div id="tree" uitype="Tree" checkbox="false" select_mode="1" children="teamListData" on_click="onclickNode"></div>
			</div>
		<div id="EmployeeList" position="center" url="">
		
		</div>
<!-- 		<div position="top" height="10px"> -->
<!-- 			<div class="spanTop">团队基本信息管理</div> -->
<!-- 		</div> -->
	</div>
	<top:script src="/cap/dwr/interface/TeamAction.js" />
<script type="text/javascript">
var rootIdList=[];
var selectTeamId;
var deleteNodeList=[];
window.onload = function(){
	comtop.UI.scan();
	if(cui("#tree").getNode(selectTeamId)){
		cui("#tree").getNode(selectTeamId).activate(true);
		childNodeLode(rootIdList);
		setCenterEditUrl(selectTeamId,"read");
	}
	}
	
/*
 * --------------左侧div部分---------------------
 */
//初始加载根节点 (tree)
	function teamListData(obj){
		dwr.TOPEngine.setAsync(false);
		TeamAction.queryTeamList(function(data){
			var initData = [];
			var count=0;
	    	for(var i=0;i<data.list.length;i++){
	    		if(data.list[i].paterTeamId==null || data.list[i].paterTeamId ==" "){
	    			rootIdList[count]=data.list[i].id;
	    			var item={'title':data.list[i].teamName,'key':data.list[i].id};
		    		initData.push(item);
		    		count++;
	    		}
	    	}
	    	obj.setDatasource(initData);
	    	selectTeamId=rootIdList[0];
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
		TeamAction.queryTeamList(function(data){
			for(var i=0;i<data.list.length;i++){
				if(data.list[i].paterTeamId == rootId){
					cui("#tree").getNode(rootId).addChild({'title':data.list[i].teamName,'key':data.list[i].id});
					lodeNode(data.list[i].id);
				}
			}
			});
		dwr.TOPEngine.setAsync(true);
	}
	
	//新增同级按钮初始化
  	var insertTeam = {
    	datasource: [
             {id:'insertSameTeam',label:'新增同级团队'},
             {id:'insertSubTeam',label:'新增下级团队'},
        ],
        on_click:function(obj){
        	if(obj.id=='insertSameTeam'){
        		insertSameTeam();
        	}else{
        		insertSubTeam();
        	}
        }
    };
  	//设置右侧编辑页面(新增团队)
  	function insertNewTeam(parentId,editType){ 
  		var url = "EmployeeList.jsp?parentId=" +parentId+ "&editType=" + editType;
  		cui("#border").setContentURL("center",url);
  	}
  	//新增同级团队
	function insertSameTeam(){
		var selectNode=cui("#tree").getActiveNode();
		if(selectNode && selectNode.getData('key')!="_1"){
			var parentId=selectNode.parent().getData('key');
			insertNewTeam(parentId,"insert");
		}
		else{
			insertNewTeam("_1","insert");
		}
	}
	//新增下级团队
	function insertSubTeam(){
		var selectNode=cui("#tree").getActiveNode();
		if(selectNode){
			var selectNodeKey=selectNode.getData('key');
			insertNewTeam(selectNodeKey,"insert");
		}
		else{
			cui.alert("请选定上级团队。");
		}
	}
	
	//编辑保存后刷新tree
	function loadTree(teamId,isInsert,parentId,teamName){
		var selectNode=cui("#tree").getActiveNode();
		if(selectNode && selectNode.parent()){
			if(isInsert==1){
				if(parentId != " "){
					parentNode=cui("#tree").getNode(parentId);
					parentNode.addChild({'title':teamName,'key':teamId});
				}
				else{
					selectNode=selectNode.parent();
					selectNode.addChild({'title':teamName,'key':teamId});
				}
			}
			else{
				cui("#tree").getNode(teamId).setData("title",teamName);
			}
			setCenterEditUrl(teamId,"read");
			cui("#tree").getNode(teamId).select(true);
			cui("#tree").getNode(teamId).activate(true);
		}
		else{
			document.location.reload();
		}
	}
	
	//删除事件
	function deleteTeam(){
		var selectNode=cui("#tree").getActiveNode();
		if(selectNode){
			var selectNodeKey=selectNode.getData('key');
			deleteNode(selectNodeKey);
		}
		else{
			cui.alert("请选定待删除团队。");
		}
	}
	
	//删除团队
	function deleteNode(selectNodeKey){
		cui.confirm("确定要删除这个团队及其下级所有团队吗？",{
			onYes:function(){
				var parentNode=cui("#tree").getNode(selectNodeKey).parent();
				if(parentNode.getData('key') != "_1"){
					var parentNode=cui("#tree").getNode(selectNodeKey).parent();
					cui("#tree").getNode(parentNode.getData('key')).activate(true);
					setCenterEditUrl(parentNode.getData('key'),"read");
				}
				else{
					document.location.reload();
				}
				getDeleteNodeList(cui("#tree").getNode(selectNodeKey));
				cui("#tree").getNode(selectNodeKey).remove();
				dwr.TOPEngine.setAsync(false);
				TeamAction.deleteTeamList(deleteNodeList);
		    	dwr.TOPEngine.setAsync(true);
		    	cui.message("删除成功。","success");
			}
		});
	}
	
	//获取待删除团队列表 
	function getDeleteNodeList(selectNode){
		var id=selectNode.getData('key');
		var teamName=selectNode.getData('title');
		var item={'id':id,'teamName':teamName};
		deleteNodeList.push(item);
		if(cui("#tree").getNode(id).children()){
			var childNode=cui("#tree").getNode(id).children();
			for(var i=0;i<childNode.length;i++){
				getDeleteNodeList(childNode[i]);
			}
		}
	}
	
	//点击节点查看团队 
	function onclickNode(node, event){
		selectTeamId=node.getData("key");
		setCenterEditUrl(selectTeamId,"read");
	}
	/*
	* --------------右侧div部分---------------------
	*/ 
	//设置右侧编辑页面(查看、编辑团队)
	function setCenterEditUrl(selectTeamId,editType){ 
		var url = "EmployeeList.jsp?selectedTeamId=" +selectTeamId+ "&editType=" + editType;
		cui("#border").setContentURL("center",url);
	}

	//查看、编辑团队
	function showTeam(selectTeamId,parentId,editType){ 
		var url = "EmployeeList.jsp?selectedTeamId=" +selectTeamId+ "&editType=" + editType+ "&parentId="+parentId;
		cui("#border").setContentURL("center",url);
	}
	
	//右侧点击编辑按钮，重新加载主要是为了方法的方法签名可编辑 
	function editLoad(selectId){
		var node=cui("#tree").getNode(selectId);
		var parentId=node.parent().getData("key");
		showTeam(selectId,parentId,"edit");
	}
	
	/**
	* 取消后重新加载
	*/
	function cancelLoad(editId){
		setTimeout(function(){
			if(editId){
				setCenterEditUrl(editId,"read");
			}else{
				setCenterEditUrl(selectTeamId,"read");
			}
			
		},50);
	}
</script>
</body>
</html>