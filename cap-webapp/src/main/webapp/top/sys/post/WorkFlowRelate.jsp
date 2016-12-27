<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
    <title>关联流程节点</title>
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js'></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/engine.js'></script>
    <script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
    <script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/interface/ModuleAction.js'></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/js/jquery.js'></script>
	<style type="text/css">
		img{
		  margin-left:5px;
		}
	</style>
</head>
<body>
<div uitype="Borderlayout"  id="body"  is_root="true"> 
		<div id="leftMain" position="left" width="280" collapsable="true" style="overflow: hidden;" show_expand_icon="true">       
			  <div style="margin-left: 5px;margin-top:5px;position: relative;"> 
				<span uitype="ClickInput" id="keyword" name="keyword" emptytext="请输入系统，目录或模块名称关键字查询"
					on_iconclick="fastQuery"  icon="search" enterable="true"
					editable="true"	 width="260" on_keydown="keyDownQuery"></span>
			  </div> 
			<div id="div_list" style="display: none;margin-left: 5px;">
				<div id="fastQueryList" uitype="MultiNav" datasource="initBoxData"></div> 
			</div>
			<div   class="tree_box" id="moduleTreeDiv">
                 <div id="moduleTree" uitype="Tree" children="initData" on_lazy_read="loadNode"  on_click="treeClick" click_folder_mode="1"></div>
			</div>
         </div>
		<div id="centerMain" position ="center">
		</div>
	</div>
	<script type="text/javascript">
	var initBoxData = [];
	var path = "";
	//选中的树节点
	var curOrgId = "-1";
	
	var postId = "<c:out value='${param.postId}'/>"; 
	var postName = decodeURIComponent(decodeURIComponent("<c:out value='${param.postName}'/>"));
	var orgName= decodeURIComponent(decodeURIComponent("<c:out value='${param.orgName}'/>"));

	$(document).ready(function(){
		comtop.UI.scan();   //扫描
		var winHeight = $(window.top).height()-100;
		winHeight = winHeight - 50;
		$("#moduleTreeDiv").css("height",winHeight)
	});
	
	//初始化数据 
	function initData(obj) {
		$('#div_list').hide();
		 
		var moduleObj={"parentModuleId":"-1"};
		ModuleAction.queryChildrenModule(moduleObj,function(data){
			if(data == null || data == "") {
				setRootNode(obj);
			} else {
				var treeData = jQuery.parseJSON(data);
				treeData.expand = true;
				treeData.activate = true;
		    	obj.setDatasource(treeData);
		    	nodeUrl(treeData.key);
			}
	     });
	}

	//根节点新增
	function setRootNode(obj) {
		var treeData = {title:"暂无数据",key:"0"};
		treeData.activate = true;
		obj.setDatasource(treeData);
		nodeUrl(treeData.key);
	}

	//设置右边的页面链接
	function nodeUrl(moduleId){
		var node = cui('#moduleTree').getNode(moduleId);
		var data = node.getData();
		curOrgId = data.key;
		treeClick(node);
	}



	//快速查询
	function fastQuery(){
		var keyword = cui('#keyword').getValue();
		if(keyword==''){
			$('#div_list').hide();
			$('#moduleTree').show();
			var node=cui('#moduleTree').getNode(curOrgId);
			if(node){
				treeClick(node);
			}
		}else{
			$('#div_list').show();
			$('#moduleTree').hide();
			listBoxData(cui('#fastQueryList'));
		}
	}

	//键盘回车键快速查询 
	function keyDownQuery() {
		if ( event.keyCode ==13) {
			fastQuery();
		}
	}

	//快速查询列表数据源
	function listBoxData(obj){
		initBoxData = [];
		var keyword = cui("#keyword").getValue().replace(new RegExp("/","gm"), "//");
		keyword = keyword.replace(new RegExp("%", "gm"), "/%");
		keyword = keyword.replace(new RegExp("_","gm"), "/_");
		keyword = keyword.replace(new RegExp("'","gm"), "''");
		dwr.TOPEngine.setAsync(false);
		ModuleAction.fastQueryModule(keyword,function(data){
			var len = data.length ;
			if(len != 0) {
				$.each(data,function(i,cData){
					if(cData.moduleName.length > 31) {
						path=cData.moduleName.substring(0,31)+"..";
					} else {
						path = cData.moduleName;
					}
					initBoxData.push({href:"#",name:path,title:cData.moduleName,onclick:"clickRecord('"+cData.moduleId+"','"+cData.moduleName+"')"});
				});
			} else {
				initBoxData.push({href:"#",name:"没有数据",title:"",onclick:""});
			}
		});
		cui("#fastQueryList").setDatasource(initBoxData);
		dwr.TOPEngine.setAsync(true);
	}

	//单击列表记录
	function clickRecord(moduleId, modulePath){
		var selectedModuleId = moduleId;
		dwr.TOPEngine.setAsync(false);
		ModuleAction.getModuleInfo(selectedModuleId,function(data){
			var moduleVO = data;
			setContent(moduleVO.moduleCode);
		});	
		dwr.TOPEngine.setAsync(true);
	}
	
	//点击click事件加载节点方法
	function loadNode(node) {
		curOrgId = node.getData().key;
		dwr.TOPEngine.setAsync(false);
		var moduleObj={"parentModuleId":node.getData().key};
		ModuleAction.queryChildrenModule(moduleObj,function(data){
	    	var treeData = jQuery.parseJSON(data);
	    	treeData.activate = true;
	    	node.addChild(treeData.children);
			node.setLazyNodeStatus(node.ok);
	     });
		dwr.TOPEngine.setAsync(true);
	}

	
	// 树单击事件
	function treeClick(node){
		var data = node.getData();
		setContent( data.data.moduleCode);
	}
	
	/**
	 设置右边的页面
	*/
	function setContent(moduleCode){
		var contentUrl = webPath+"/bpms/flex/ChooseNode.jsp";
		var param = "?orgName="+encodeURIComponent(encodeURIComponent(orgName))+"&postName="+encodeURIComponent(encodeURIComponent(postName))+"&postId="+postId+"&moduleCode="+moduleCode+"&userId="+globalUserId +"&userName="+encodeURIComponent(encodeURIComponent(globalUserName));
		contentUrl = contentUrl+param;
		cui('#body').setContentURL("center",contentUrl);
	}
	</script>
</body>
</html>