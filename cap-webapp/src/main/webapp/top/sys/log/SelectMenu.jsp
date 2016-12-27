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
<cui:link href="/top/css/top_base.css" />
<cui:link href="/top/component/topui/cui/themes/default/css/comtop.ui.min.css" />
</head>
<body>
    <div uitype="Borderlayout" is_root="true" id="border">
	    <div uitype="Panel" position="center" id="cneterMain" width="220" height="100"  collapsable="true" >
			<div uitype="ClickInput" editable="true" id="keyword" name="keyword" on_iconclick="fastQuery" enterable="true" 
				emptytext="������Ŀ¼���ƹؼ��ֲ�ѯ" icon="<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/images/querysearch.gif" width="200"></div>
			<cui:multiNav id="fastQueryList" datasource="initBoxData" />
			<div id="menuDir">
				<cui:tree  children="initData" on_lazy_read="loadNode" on_click="treeClick" id="menuTree" click_folder_mode="1"/>
			</div>     
		</div> 
		<div uitype="Panel" position="bottom" id="selectSystemAccessBottomMain" gap="0px 0px 0px 0px" height="40">
		    <div style="background:#F0F0F0;width:100%;height:100%;text-align: center;">
				 <cui:button id="confirmButton" label="&nbsp;ȷ&nbsp;��&nbsp;" on_click="confirmClick"></cui:button>
				 &nbsp;
				 <cui:button id="clearButton" label="&nbsp;��&nbsp;��&nbsp;" on_click="clearSelectedData"></cui:button>
				 &nbsp;
				 <cui:button id="closeButton" label="&nbsp;��&nbsp;��&nbsp;" on_click="closeWindow"></cui:button>
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
		var monuObj={"parentMenuId":"-1"};
		MenuAction.queryMenuConfigTree(monuObj,function(data){
			var treeData = jQuery.parseJSON(data);
			treeData.expand = true;
	    	obj.setDatasource(treeData);
	     });
		dwr.TOPEngine.setAsync(true);
	}

	//���click�¼����ؽڵ㷽��
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

	//���ٲ�ѯ�б�����Դ
	function listBoxData(keyword){
		dwr.TOPEngine.setAsync(false);
		var menuVo = {"menuName":keyword};
		FunctionUseAction.fastQueryMenu(keyword,function(data){
			if (data.length == 0) {
				initBoxData=[{name:"û������"}];
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

	//ȷ��
	function confirmClick(){
		var node = cui("#menuTree").getActiveNode();
		var data = node.getData();
		opener.selectMenuCallback(data);
		window.close();
	}

	//�����ѡ�������
    function clearSelectedData(){
    	var node = cui("#menuTree").getActiveNode();
    	if(node){
    		node.select(false);
    	}
    	opener.selectMenuCallback({});
    	window.close();
    }

    /**
    * ����б�˵�
    */
    function selectMultiNavClick(menuId,menuName){
		var data = {'key':menuId,'title':menuName};
		opener.selectMenuCallback(data);
		window.close();
    }

	//�رմ���
	function closeWindow(){
		window.close();
	}
</script>
</body>
</html>