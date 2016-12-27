
<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/AccessTaglibs.jsp" %>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<html>
<head>
<title>非行政岗位</title>
<meta http-equiv="X-UA-Compatible" content="edge" />
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/js/jquery.js'></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js'></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/cfg/dwr/engine.js'></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/cfg/dwr/interface/PostOtherAction.js'></script>
</head>
<body>
	<div uitype="borderlayout"  id="le" is_root="true" gap="0px 0px 0px 0px">           
    	<div uitype="bpanel"  style="overflow:hidden" position="left" id="leftMain" width="300" max_size="550" min_size="50" collapsable="true" style="margin-left: 6px">
         	<div style="padding-top:55px;width:100%;position:relative;">
        	  	<div style="position:absolute;top:0;left:0;height:55px;width:100%;">
					<div id="associateDiv" style="text-align: left;width:186px;font:12px/25px Arial;margin-left: 3px;margin-bottom: 1px;" >
						<input type="checkbox" id="associateQuery" align="middle"  title="级联查询" onclick="setAssociate(0)" style="cursor:pointer;"/>
						<label  onclick="setAssociate(1)" style="cursor:pointer;" id="label"><font color="#2894FF">级联查询非行政岗位</font></label>
					</div>
     				<div  id="treeDivHight" style="overflow:auto;height:100%;">  
						<div style="padding-left: 10px;">
	 						<div uitype="multiNav" id="classifyNameBox" datasource="initBoxData"></div>
	 						<div id="div_tree" >
			  					<div id="ClassifyTree" uitype="Tree" children="treeData" on_lazy_read="loadNode"  on_click="treeClick" click_folder_mode="1"></div>
		    				</div>
						</div>
					</div>
				</div>
			</div>
		</div>
   		<div uitype="bpanel"  position="center" id="centerMain"></div> 
	</div>
<script type="text/javascript"> 
		//当前点击树节点id
		var clickNodeId = '-1';
		
		//当前选中的树节点  快速查询返回使用
		var curNodeId = '';
		
		//当前选中树节点名称
		var clickNodeName ="";
		
		//初始化查询的组织数据   
		var initBoxData=[];
		
		//根节点ID
		var rootOrgId = "";
		
		//设置授权管理员id
		var adminId = "<c:out value='${param.adminId}'/>";
		
		
		//页面渲染
		window.onload = function(){
		    comtop.UI.scan();
		    $("#treeDivHight").height($("#leftMain").height()-25);
		}
		
		window.onresize= function(){
			setTimeout(function(){
				$("#treeDivHight").height($("#leftMain").height()-25);
			},300);
		}
		
		//树加载
		function treeData(obj) {
			dwr.TOPEngine.setAsync(false);
			if(globalUserId == 'SuperAdmin'){
				PostOtherAction.queryChildrenPostClassifyWithoutPost("-1", function(data) {
			    	if(data&&data!==""){
			   			var treeData = jQuery.parseJSON(data);
			   			treeData.isRoot = true;
			   			curNodeId = treeData.key;
			   			obj.setDatasource(treeData);
			   			//激活根节点
			   			obj.getNode(treeData.key).activate(true);
			   			obj.getNode(treeData.key).expand(true);
			   			treeClick(obj.getActiveNode());
					}else{
						  var emptydata=[{title:"没有数据"}];
			   			  obj.setDatasource(emptydata);
			   			  setEditUrl(clickNodeId);
					}
			    });
			}else {
				var condition = {};
				condition.parentClassifyId = "-1";
				condition.creatorId = globalUserId;
				PostOtherAction.queryAssignClassify(condition, function(data){
					if(data&&data!==""){
			   			var treeData = jQuery.parseJSON(data);
			   			treeData.isRoot = true;
			   			curNodeId = treeData.key;
			   			obj.setDatasource(treeData);
			   			//激活根节点
			   			obj.getNode(treeData.key).activate(true);
			   			obj.getNode(treeData.key).expand(true);
			   			treeClick(obj.getActiveNode());
					}else{
						  var emptydata=[{title:"没有数据"}];
			   			  obj.setDatasource(emptydata);
			   			  setEditUrl(clickNodeId);
					}
				});
			}
			dwr.TOPEngine.setAsync(true);
		}
		
		//懒加载
		function loadNode(node) {
			dwr.TOPEngine.setAsync(false);
			if(globalUserId == 'SuperAdmin'){
				PostOtherAction.queryChildrenPostClassifyWithoutPost(node.getData("key"), function(data) {
						if(data&&data!=="{}"){
						    	var treeData = jQuery.parseJSON(data);
						    	curNodeId = node.getData().key;
						    	//加载子节点信息
						    	node.addChild(treeData.children);
						}else{
							  var emptydata=[{title:"没有数据"}];
							  cui('#ClassifyTree').setDatasource(emptydata);
						}
			    });
			} else {
				var condition = {};
				condition.parentClassifyId = node.getData("key");
				condition.creatorId = globalUserId;
				PostOtherAction.queryAssignClassify(condition, function(data){
					if(data&&data!=="{}"){
				    	var treeData = jQuery.parseJSON(data);
				    	curNodeId = node.getData().key;
				    	//加载子节点信息
				    	node.addChild(treeData.children);
					}else{
						  var emptydata=[{title:"没有数据"}];
						  cui('#ClassifyTree').setDatasource(emptydata);
					}
				});
			}
			dwr.TOPEngine.setAsync(true);
		}
		
		//设置级联  1为 级联查询，0为默认
		function setAssociate(type){
			var associate=$('#associateQuery')[0].checked;
			if(type==1){
				if(associate)$('#associateQuery')[0].checked=false;
				else $('#associateQuery')[0].checked=true;
			}
			//执行查询
		 	var node=cui('#ClassifyTree').getActiveNode();
		 	treeClick(node);
		}
		
		//树点击
		function treeClick(node) {
			clickNodeId = node.getData().key;
			clickNodeName = node.getData().title;
		    setEditUrl(clickNodeId,clickNodeName);
		}
		
		/**
		*  设置编辑页面的URL路径 
		*  设置节点ID
		*/
		function setEditUrl(classifyId,classifyName){
			//为1 级联查询
			var associateType=$('#associateQuery')[0].checked==true?1:0;
			var isRootNode = false;
			var url = "${pageScope.cuiWebRoot}/top/sys/accesscontrol/gradeadmin/AssignPostOtherList.jsp?" + "classifyId="+classifyId+"&associateType="+associateType+"&adminId="+adminId+"&classifyName="+classifyName;
			cui("#le").setContentURL("center",url); 
		}
</script>
</body>
</html>