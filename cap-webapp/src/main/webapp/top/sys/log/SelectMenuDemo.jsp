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
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
</head>
<body>
    <div uitype="Borderlayout" is_root="true" id="border">
	    <div uitype="bpanel" position="center" id="cneterMain" width="200" height="100" >
	    	<span uitype="ClickInput" id="keyword" name="keyword" emptytext="请输入菜单名称关键字查询"
							on_iconclick="fastQuery"  icon="search" enterable="true"
							editable="true"	 width="260" on_keydown="fastQuery"></span>
			<div uitype="MultiNav" id="fastQueryList" datasource="initBoxData" ></div>
			<div id="menuDir">
				<div uitype="Tree" id="menuTree" children="initData" on_lazy_read="loadNode" click_folder_mode="1" ></div>
			</div>     
		</div> 
		<div uitype="bpanel" position="bottom" id="selectSystemAccessBottomMain" gap="0px 0px 0px 0px" height="40">
		    <div style="background:#F0F0F0;width:100%;height:100%;text-align: center;">
				 <span uitype="button" id="confirmButton" label="&nbsp;确&nbsp;定&nbsp;" on_click="confirmClick"></span>
				 &nbsp;
				 <span uitype="button" id="closeButton" label="&nbsp;关&nbsp;闭&nbsp;" on_click="closeWindow"></span>
			</div>
		</div>
	</div>
	
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/js/commonUtil.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/util.js"></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/interface/MenuAction.js'></script>      
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
		if ( event.keyCode !=13) {
			return;
		}
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
		MenuAction.queryAllApp(function(data){
		    if(data != null){
			   var treeData = jQuery.parseJSON(data);
		       treeData.expand = true;
		       treeData.activate = true;
    	       obj.setDatasource(treeData.children);
		    }
	     });
		dwr.TOPEngine.setAsync(true);
	}

	//点击click事件加载节点方法
	function loadNode(node) {
		dwr.TOPEngine.setAsync(false);
		MenuAction.queryMenuByFuncId(node.getData().key, function(data){
			if(data != null && data != ''){ 
		    	var treeData = jQuery.parseJSON(data);
		    	treeData.activate = true;
		    	node.addChild(treeData.children);
			}else{
				node.addChild([]);
			}
			node.setLazyNodeStatus(node.ok);
	    });
		dwr.TOPEngine.setAsync(true);
	}

	//快速查询列表数据源
	function listBoxData(keyword){
		dwr.TOPEngine.setAsync(false);
		console.log(keyword);
		MenuAction.fastQueryMenu(keyword,function(data){
			if (data.length == 0) {
				initBoxData=[{name:"没有数据",title:"",onclick:""}];
				cui("#fastQueryList").setDatasource(initBoxData);
   			}else{
   				initBoxData = [];
				$('#div_none').hide();
				 $.each(data,function(i,cData){
				     if(cData.funcName.length > 31){
					    path=cData.funcName.substring(0,31)+"..";
				     }else{
				        path = cData.funcName;
				     }
					 initBoxData.push({href:"#",name:path,title:cData.menuFullName,onclick:"clickRecord('"+cData.funcId+"','"+cData.funcName+"')"});
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
		window.parent.selectMenuCallback(data);
		window.parent.dialog.hide();
	}

    /**
    * 点击列表菜单
    */
    function clickRecord(menuId,menuName){
		var data = {'key':menuId,'title':menuName};
		window.parent.selectMenuCallback(data);
		window.parent.dialog.hide();
    }

	//关闭窗口
	function closeWindow(){
		 parent.dialog.hide();
	}
</script>
</body>
</html>