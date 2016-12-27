<%
/**********************************************************************
* 菜单日志:选择菜单的界面
* 2013-04-02 陈萌  新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<title>选择菜单</title>
<cui:link href="/top/css/top_base.css" />
<cui:link href="/top/component/topui/cui/themes/default/css/comtop.ui.min.css" />
</head>
<body>
    <div uitype="Borderlayout" is_root="true" id="border">
	    <div uitype="Panel" position="center" id="cneterMain" width="220" height="100"  collapsable="true" >
			<div uitype="ClickInput" editable="true" id="keyword" name="keyword" on_iconclick="fastQuery" enterable="true" 
				emptytext="请输入目录名称关键字查询" icon="<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/images/querysearch.gif" width="200"></div>
			<cui:multiNav id="fastQueryList" datasource="initBoxData" />
			<div id="menuDir">
				<cui:tree  children="initData" on_lazy_read="loadNode" on_click="treeClick" id="menuTree" click_folder_mode="1"/>
			</div>     
		</div> 
		<div uitype="Panel" position="bottom" id="selectSystemAccessBottomMain" gap="0px 0px 0px 0px" height="40">
		    <div style="background:#F0F0F0;width:100%;height:100%;text-align: center;">
				 <cui:button id="confirmButton" label="&nbsp;确&nbsp;定&nbsp;" on_click="confirmClick"></cui:button>
				 &nbsp;
				 <cui:button id="clearButton" label="&nbsp;清&nbsp;除&nbsp;" on_click="clearSelectedData"></cui:button>
				 &nbsp;
				 <cui:button id="closeButton" label="&nbsp;关&nbsp;闭&nbsp;" on_click="closeWindow"></cui:button>
			</div>
		</div>
	</div>
<cui:script src="/top/component/topui/cui/js/comtop.ui.min.js" />
<cui:script src="/dwr/engine.js" />
<cui:script src="/top/js/jquery.js" />
<cui:script src="/top/sys/dwr/interface/UserAccessViewAction.js"/>
<cui:script src="/top/sys/dwr/interface/MenuAction.js"/>
<cui:script src="/top/sys/dwr/interface/FunctionUseAction.js"/>

<cui:script src="/top/sys/js/commonUtil.js"/>
<script type="text/javascript">
    var initBoxData=[];

	//扫描，相当于渲染
	window.onload=function(){
		comtop.UI.scan();
		var node = cui("#menuTree").getNode('NoMenuId');
		if(node != null ){
           node.remove();
		}
	}

	//快速查询
	function fastQuery(){
		var keyword = handleStr(cui('#keyword').getValue());
		if(keyword==''){
			$('#fastQueryList').hide();
			$('#menuDir').show();
		}else{
			$('#fastQueryList').show();
			$('#menuDir').hide();
			listBoxData(keyword);
		}
	}

	//初始化数据 
	function initData(obj) {
		$('#fastQueryList').hide();
		dwr.TOPEngine.setAsync(false);
		var monuObj={"parentMenuId":"-1"};
		MenuAction.queryMenuConfigTree(monuObj,function(data){
			var treeData = jQuery.parseJSON(data);
			treeData.expand = true;
	    	obj.setDatasource(treeData);
	     });
		dwr.TOPEngine.setAsync(true);
	}

	//点击click事件加载节点方法
	function loadNode(node) {
		dwr.TOPEngine.setAsync(false);
		var moduleObj={"menuId":node.getData().key};
		MenuAction.queryMenuConfigTree(moduleObj,function(data){
	    	var treeData = jQuery.parseJSON(data);
	    	treeData.activate = true;
	    	treeData.expand = true;
	    	if(treeData.children&&treeData.children.length>0){
	    		node.addChild(treeData.children);
		    }
			node.setLazyNodeStatus(node.ok);
	     });
		dwr.TOPEngine.setAsync(true);
	}

	//快速查询列表数据源
	function listBoxData(keyword){
		dwr.TOPEngine.setAsync(false);
		var menuVo = {"menuName":keyword};
		FunctionUseAction.fastQueryMenu(keyword,function(data){
			if (data.length == 0) {
				initBoxData=[{name:"没有数据"}];
				cui("#fastQueryList").setDatasource(initBoxData);
   			}else{
   				initBoxData = [];
   				console.log(data);
				$('#div_none').hide();
				 $.each(data,function(i,cData){
					 path=cData.fullname.substring(0,25)+"..";
					 initBoxData.push({href:"#",name:path,title:cData.fullname,onclick:"selectMultiNavClick('"+cData.menuId+"','"+cData.menuName+"')"});
			 });
				 cui("#fastQueryList").setDatasource(initBoxData);
		   	}
		});
		dwr.TOPEngine.setAsync(true);
	}

	//确定
	function confirmClick(){
		var node = cui("#menuTree").getActiveNode();
		var data = node.getData();
		opener.selectMenuCallback(data);
		window.close();
	}

	//清除已选择的数据
    function clearSelectedData(){
    	var node = cui("#menuTree").getActiveNode();
    	if(node){
    		node.select(false);
    	}
    	opener.selectMenuCallback({});
    	window.close();
    }

    /**
    * 点击列表菜单
    */
    function selectMultiNavClick(menuId,menuName){
		var data = {'key':menuId,'title':menuName};
		opener.selectMenuCallback(data);
		window.close();
    }

	//关闭窗口
	function closeWindow(){
		window.close();
	}
</script>
</body>
</html>