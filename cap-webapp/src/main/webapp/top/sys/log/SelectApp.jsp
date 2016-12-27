<%
/**********************************************************************
* �˵���־:ѡ��˵��Ľ���
* 2013-04-02 ����  �½�
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<title>ѡ��˵�</title>
<link rel="stylesheet" href="<c:out value='${pageScope.cuiWebRoot}'/>/top/css/top_base.css" type="text/css">
<link rel="stylesheet" href="<c:out value='${pageScope.cuiWebRoot}'/>/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
</head>
<body>
    <div uitype="Borderlayout" is_root="true" id="border">
	    <div uitype="bpanel" position="center" id="cneterMain" width="200"  height="100" >
			<div uitype="ClickInput" editable="true" id="keyword" name="keyword" on_iconclick="fastQuery" enterable="true"  
				emptytext="������Ŀ¼���ƹؼ��ֲ�ѯ" icon="<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/images/querysearch.gif" width="100%"></div>
				<div style="clear: both;"></div>
			<div uitype="MultiNav" id="fastQueryList" datasource="initBoxData" style="height: 280px;overflow: auto;"></div>
			<div id="menuDir" style="height: 280px;overflow: auto;">
				<div uitype="Tree" id="menuTree" children="initData" on_lazy_read="loadNode"   click_folder_mode="1" ></div>
			</div>     
		</div> 
		 
		<div uitype="bpanel" position="bottom" id="selectSystemAccessBottomMain" gap="0px 0px 0px 0px" height="40">
		    <div style="background:#F0F0F0;width:100%;height:100%;text-align: center;">
				 <span uitype="button" id="confirmButton" label="&nbsp;ȷ&nbsp;��&nbsp;" on_click="confirmClick"></span>
				 &nbsp;
				 <span uitype="button" id="clearButton" label="&nbsp;��&nbsp;��&nbsp;" on_click="clearSelectedData"></span>
				 &nbsp;
				 <span uitype="button" id="closeButton" label="&nbsp;��&nbsp;��&nbsp;" on_click="closeWindow"></span>
			</div>
		</div>
		
	</div>


<script type="text/javascript" src="<c:out value='${pageScope.cuiWebRoot}'/>/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript" src="<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/js/commonUtil.js"></script>
<script type="text/javascript" src="<c:out value='${pageScope.cuiWebRoot}'/>/top/js/jquery.js"></script>
<script type="text/javascript" src="<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/dwr/engine.js"></script>
<script type="text/javascript" src="<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/dwr/util.js"></script>
<script type="text/javascript" src="<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/dwr/interface/RoleAction.js"></script>
<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/dwr/interface/ModuleAction.js'></script>        
<script type="text/javascript">
    var initBoxData=[];

	//ɨ�裬�൱����Ⱦ
	window.onload=function(){
		comtop.UI.scan();
		var node = cui("#menuTree").getNode('NoMenuId');
		if(node != null ){
           node.remove();
		}
	}

	//���ٲ�ѯ
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

	//��ʼ������ 
	function initData(obj) {
		$('#fastQueryList').hide();
		dwr.TOPEngine.setAsync(false);
		
		var moduleObj={"parentModuleId":"-1"};
		ModuleAction.queryChildrenModule(moduleObj,function(data){
		    if(data != null){
			   var treeData = jQuery.parseJSON(data);
			       treeData.expand = true;
			       treeData.activate = true;
	    	       obj.setDatasource(treeData);
		    }
	     });
		dwr.TOPEngine.setAsync(true);
	}

	//���click�¼����ؽڵ㷽��
	function loadNode(node) {
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

	//���ٲ�ѯ�б�����Դ
	function listBoxData(keyword){
		dwr.TOPEngine.setAsync(false);
		var menuVo = {"menuName":keyword};
		ModuleAction.fastQueryModule(keyword,function(data){
			if (data.length == 0) {
				initBoxData=[{name:"û������",title:"",onclick:""}];
				cui("#fastQueryList").setDatasource(initBoxData);
   			}else{
   				initBoxData = [];
				$('#div_none').hide();
				 $.each(data,function(i,cData){
				     if(cData.moduleName.length > 31){
					    path=cData.moduleName.substring(0,31)+"..";
				     }else{
				        path = cData.moduleName;
				     }
					 initBoxData.push({href:"#",name:path,title:cData.moduleName,onclick:"clickRecord('"+cData.moduleId+"','"+cData.moduleName+"')"});
			 });
				 cui("#fastQueryList").setDatasource(initBoxData);
		   	}
		});
		dwr.TOPEngine.setAsync(true);
	}

	//ȷ��
	function confirmClick(){
		var node = cui("#menuTree").getActiveNode();
		var data = node.getData();
		window.parent.selectMenuCallback(data);
		window.parent.dialog.hide();
		/* opener.selectMenuCallback(data);
		window.close(); */
	}

	//�����ѡ�������
    function clearSelectedData(){
    	var node = cui("#menuTree").getActiveNode();
    	if(node){
    		node.select(false);
    	}
     parent.selectMenuCallback({});
	 parent.dialog.hide();
    	
    }

    /**
    * ����б�˵�
    */
    function clickRecord(menuId,menuName){
		var data = {'key':menuId,'title':menuName};
		window.parent.selectMenuCallback(data);
		window.parent.dialog.hide();
    }

	//�رմ���
	function closeWindow(){
		 parent.dialog.hide();
	}
</script>
</body>
</html>