<%
  /**********************************************************************
	* ģ�����ҳ��
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/AccessTaglibs.jsp" %>
<html>
<head>
    <title>ģ���������ҳ��</title>
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js'></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/engine.js'></script>
    <script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
    <script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/interface/ModuleAction.js'></script>
    <script type="text/javascript" src='${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.editor.min.js'></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/js/jquery.js'></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/component/topui/cui/js/jquery.dynatree.min.js'></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.tree.js'></script>
	<style type="text/css">
		img{
		  margin-left:5px;
		}
	</style>
</head>
<body>
<div uitype="Borderlayout"  id="body"  is_root="true"> 
		<div id="leftMain" position="left" style="overflow:hidden" width="280" collapsable="true" show_expand_icon="true">       
         <div style="padding-top:50px;width:100%;position:relative;">
          <div style="position:absolute;top:0;left:0;height:50px;width:100%;">
                   <div style = "padding-left:5px;padding-top:5px;">
						<span uitype="ClickInput" id="keyword" name="keyword" emptytext="������ϵͳ��Ŀ¼��Ӧ�����ƹؼ��ֲ�ѯ"
							on_iconclick="fastQuery"  icon="search" enterable="true"
							editable="true"	 width="260" on_keydown="keyDownQuery"></span>
					</div>
					<div id="moveModule" style = "padding-left:170px;padding-top:5px;">		
						<img title="�ö�" src="${cuiWebRoot}/top/sys/images/func_top.png" style="cursor:pointer" onclick="moveNode('top');">
						<img title="����" src="${cuiWebRoot}/top/sys/images/func_up.png" style="cursor:pointer" onclick="moveNode('up');">
						<img title="����" src="${cuiWebRoot}/top/sys/images/func_down.png" style="cursor:pointer" onclick="moveNode('down');">
						<img title="�õ�" src="${cuiWebRoot}/top/sys/images/func_bottom.png" style="cursor:pointer" onclick="moveNode('bottom');">
				    </div>
				 </div>     
               <div  id="treeDivHight" style="overflow:auto;height:100%;">
						<div id="fastQueryList" uitype="MultiNav" datasource="initBoxData"></div> 
                     <div id="moduleTree" uitype="Tree" children="initData" on_lazy_read="loadNode"  on_click="treeClick" click_folder_mode="1"></div>
				</div>
				</div>
         </div>
		<div id="centerMain" position ="center">
			
		</div>
	</div>
	<script type="text/javascript">

	//ϵͳͼƬ·��
	var systemIconPath = "${cuiWebRoot}/top/sys/images/func_sys.gif";
	var moduleIconPath = "${cuiWebRoot}/top/sys/images/func_dir.gif";
	var selectParentKey = "";
	var addType = '';
	var isRootNodeAdd = "false";
	var initBoxData = [];
	var path = "";
	//ѡ�е����ڵ�
	var curOrgId = "-1";

	$(document).ready(function(){
		comtop.UI.scan();   //ɨ��
		$("#treeDivHight").height($("#leftMain").height()-50);
	});
	
	window.onresize= function(){
		setTimeout(function(){
			$("#treeDivHight").height($("#leftMain").height()-50);
		},300);
	}
	
	//��ʼ������ 
	function initData(obj) {
		$('#fastQueryList').hide();
		 
		var moduleObj={"parentModuleId":"-1"};
		ModuleAction.queryChildrenModule(moduleObj,function(data){
			if(data == null || data == "") {
				//��Ϊ��ʱ�����и��ڵ���������
				isRootNodeAdd = "true";
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

	//���ڵ�����
	function setRootNode(obj) {
		$('#moduleTree').hide();
		var treeData = {title:"��������",key:"0"};
		treeData.activate = true;
		obj.setDatasource(treeData);
		nodeUrl(treeData.key);
	}

	//�����ұߵ�ҳ������
	function nodeUrl(moduleId){
		var node = cui('#moduleTree').getNode(moduleId);
		if(node == null){
			//ѡ�и��ڵ�
			node = cui('#moduleTree').getRoot().firstChild();
			moduleId = node.getData().key;
		}
		var data = node.getData();
		curOrgId = data.key;
		var parentData = node.parent().getData();
		var nodeTypeVal = 0;
		if(moduleId != 0){
			var nodeTypeVal = data.data.moduleType;
		}
		var parentModuleType = "";
		if(parentData.key != "_1"){
			parentModuleType = parentData.data.moduleType;
		}
		var strParentName =  parentData.title;
		if(strParentName!="undefined"&&strParentName!=null&&strParentName!="null"){
			strParentName = encodeURIComponent(encodeURIComponent(strParentName));
		}
		if(nodeTypeVal == 2){
			//�����Ӧ��ģ�飬��˴�������ת��Ӧ��ģ��༭ҳ��
			 cui('#body').setContentURL("center",urlList[1]+"?actionType=edit&moduleId="+moduleId+"&moduleName="+encodeURIComponent(encodeURIComponent(data.title)) 
					 + "&parentModuleId="+ parentData.key + "&parentModuleName="+encodeURIComponent(encodeURIComponent(parentData.title))+"&parentModuleType="+parentData.data.moduleType);
		}else{
			cui('#body').setContentURL("center",'${cuiWebRoot}/top/sys/module/ModuleEdit.jsp?moduleId=' + moduleId
					+ "&moduleType=" + data.data.moduleType + "&isRootNodeAdd=" + isRootNodeAdd+"&parentModuleType="+parentModuleType
					+"&parentId=" + parentData.key + "&parentName=" + strParentName + "&addType=" + addType);	
		}
    	
	}



	//���ٲ�ѯ
	function fastQuery(){
		var keyword = cui('#keyword').getValue();
		if(keyword==''){
			$('#fastQueryList').hide();
			$('#moveModule').show();
			$('#moduleTree').show();
			addType = '';
			var node=cui('#moduleTree').getNode(curOrgId);
			if(node){
				treeClick(node);
			}
		}else{
			$('#fastQueryList').show();
			$('#moveModule').hide();
			$('#moduleTree').hide();
			listBoxData(cui('#fastQueryList'));
			addType = 'fastQueryType';
		}
	}

	//���̻س������ٲ�ѯ 
	function keyDownQuery() {
		if ( event.keyCode ==13) {
			fastQuery();
		}
	}

	//���ٲ�ѯ�б�����Դ
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
				initBoxData.push({href:"#",name:"û������",title:"",onclick:""});
			}
		});
		cui("#fastQueryList").setDatasource(initBoxData);
		dwr.TOPEngine.setAsync(true);
	}

	//�����б��¼
	function clickRecord(moduleId, modulePath){
		var selectedModuleId = moduleId;
		var moduleName = "";
		var moduleType = "";
		var parentModuleId = "";
		var parentModuleName = "";
		var parentModuleType = "";
		dwr.TOPEngine.setAsync(false);
		ModuleAction.getModuleInfo(selectedModuleId,function(data){
			var moduleVO = data;
			moduleName = moduleVO.moduleName;
			moduleType = moduleVO.moduleType;
			parentModuleId = moduleVO.parentModuleId;
		});	
		dwr.TOPEngine.setAsync(true);

		dwr.TOPEngine.setAsync(false);
		ModuleAction.getModuleInfo(parentModuleId,function(data){
			var parentModuleVO = data;
			if(data == null) {
				parentModuleName = '';
			} else {
				parentModuleName = parentModuleVO.moduleName;
				parentModuleType = parentModuleVO.moduleType;
				if(parentModuleName!="undefined"&&parentModuleName!=null&&parentModuleName!="null"){
					parentModuleName = encodeURIComponent(encodeURIComponent(parentModuleName));
				}
			}
		});	
		dwr.TOPEngine.setAsync(true);
		//���ϵͳģ��ʱ�����ұ���չʾϵͳģ��༭ҳ�滹��Ӧ��
		if(moduleType == 2){
			//�����Ӧ��ģ�飬��˴�������ת��Ӧ��ģ��༭ҳ��
			 cui('#body').setContentURL("center",urlList[1]+"?actionType=edit&moduleId="+selectedModuleId+"&moduleName=" + encodeURIComponent(encodeURIComponent(moduleName))
					 + "&parentModuleId="+ parentModuleId + "&parentModuleName="+ parentModuleName + "&parentModuleType="+parentModuleType); 
		}else{
			cui('#body').setContentURL("center",'${cuiWebRoot}/top/sys/module/ModuleEdit.jsp?moduleId=' + selectedModuleId
				+"&name=" + encodeURIComponent(encodeURIComponent(moduleName)) + "&moduleType=" + moduleType + "&parentModuleType="+parentModuleType
				+"&parentId=" + parentModuleId + "&parentName=" + parentModuleName + "&addType=" + addType);
	
		}
	}
	
	//���click�¼����ؽڵ㷽��
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

	// �༭���ڵ�ˢ���¼� 
	function editRefreshTree(moduleId,parentModuleId,moduleName){
		var treeObject = cui("#moduleTree");
		var pNode = treeObject.getNode(parentModuleId);
		var selectNode = treeObject.getNode(moduleId);
		if(selectNode && selectNode.dNode) {
			selectNode.setData("title",moduleName);
			selectNode.activate();
			treeClick(selectNode);
		}else{
			if(selectNode == null){
				//ѡ�и��ڵ�
				var tnode = cui('#moduleTree').getRoot().firstChild();
				treeClick(tnode); 
			}
		} 
	}

	// �������ڵ�ˢ���¼� 
	function addRefreshTree(moduleId,parentModuleId) {
		var treeObject = cui("#moduleTree");
		var pNode = treeObject.getNode(parentModuleId);
		if(pNode && pNode.dNode) { 
			pNode.setData("isFolder",true);
			if(pNode.hasChild()) {
				var lstChildrenNodes = pNode.children();
				for(var i=0;i<lstChildrenNodes.length;i++) {
					var dNode = lstChildrenNodes[i];
					dNode.remove();
				}
			}
			loadNode(pNode);
			var dNode = treeObject.getNode(moduleId);
			dNode.activate();
			dNode.focus();
			treeClick(dNode);
		}else{
			if(pNode == null){
				//ѡ�и��ڵ�
				var tnode = cui('#moduleTree').getRoot().firstChild();
				treeClick(tnode); 
			}
		}
	}

	var urlList = ["${cuiWebRoot}/top/sys/module/ModuleEdit.jsp","${cuiWebRoot}/top/sys/menu/FuncEdit.jsp"];
	
	// �������¼�
	function treeClick(node){
		var data = node.getData();
		curOrgId = data.key;
		var parentData = node.parent().getData();
		var nodeTypeVal = data.data.moduleType;
		var parentModuleType = "";
		if(parentData.key != "_1"){
			parentModuleType = parentData.data.moduleType;
		}
		var strParentName =  parentData.title;
		if(strParentName!="undefined"&&strParentName!=null&&strParentName!="null"){
			strParentName = encodeURIComponent(encodeURIComponent(strParentName));
		}
		//���ϵͳģ��ʱ�����ұ���չʾϵͳģ��༭ҳ�滹��Ӧ��
		if(nodeTypeVal == 2){
			//�����Ӧ��ģ�飬��˴�������ת��Ӧ��ģ��༭ҳ��
			 cui('#body').setContentURL("center",urlList[1]+"?actionType=edit&moduleId="+data.key+"&moduleName=" + encodeURIComponent(encodeURIComponent(data.title))
					 + "&parentModuleId="+ parentData.key + "&parentModuleName="+encodeURIComponent(encodeURIComponent(parentData.title)) + "&parentModuleType="+parentData.data.moduleType); 
		}else{
			 //������������͵ģ���˴���ת���������ͽڵ�ı༭ҳ��
			cui('#body').setContentURL("center",'${cuiWebRoot}/top/sys/module/ModuleEdit.jsp?moduleId=' + data.key + "&parentModuleType="+parentModuleType
					+ "&moduleType=" + nodeTypeVal +"&parentId=" + parentData.key + "&parentName=" + strParentName + "&addType=" + addType);
		}
    
	}
	
	//���ơ����ơ��ö����õ׷��� 
	function moveNode(moveType) {
		var n = cui('#moduleTree').getActiveNode();
		var parentNode = n.parent();
		if(n && parentNode) {
			var obj = findRelativeNode(n,moveType);
			if(obj.moduleRelationsToBeUpdate && obj.relativeNode){
				dwr.TOPEngine.setAsync(false);
				ModuleAction.updateModuleRelations(moveType,obj.moduleRelationsToBeUpdate,function(data){
					//�����ڵ�λ�ò�����ѡ�в����ڵ㣬����ᶪʧ��ѡ��״̬
					n.move(obj.relativeNode,obj.where);
				});
				dwr.TOPEngine.setAsync(true);
			}
		}else{
			cui.alert('��ѡ����֯�����ڵ㲻�ܽ�������');
			return;
		}
	}
	
	/**
	 * ����ʱ�ҵ���Ҫ��˽ڵ���н����Ľڵ�
	 * 
	 * @param n
	 * @param option
	 * @return
	 */
	function findRelativeNode(n,option){
		var relativeNode;	//����ο��ڵ�
		var where;
		var moduleRelationsToBeUpdate;
		var parentNode = n.parent();
		switch(option){
			case 'top':
				//n������㼶�ĵ�һ���ڵ㣬��relativeNodeΪͬ���׽ڵ�
				if(parentNode.firstChild().getData().key != n.getData().key)
					relativeNode = parentNode.firstChild();
				if(relativeNode){
					where = 'before';
					moduleRelationsToBeUpdate = [n.getData().data,relativeNode.getData().data];
				}
				break;
			case 'bottom':
				if(parentNode.lastChild().getData().key != n.getData().key)
					relativeNode = parentNode.lastChild();
				if(relativeNode){
					where = 'after';
					moduleRelationsToBeUpdate = [n.getData().data,relativeNode.getData().data];
				}
					break;
			case 'up':
				if(parentNode.firstChild().getData().key!=n.getData().key)
					relativeNode = n.prev();
				if(relativeNode){
					where = 'before';
					moduleRelationsToBeUpdate = [n.getData().data,relativeNode.getData().data];
				}
					break;
			case 'down':
				if(parentNode.lastChild().getData().key != n.getData().key)
					relativeNode = n.next();
				if(relativeNode){
					where = 'after';
					moduleRelationsToBeUpdate = [n.getData().data,relativeNode.getData().data];
				}
				break;
			default:
		};
		return {'relativeNode':relativeNode,'where':where,'moduleRelationsToBeUpdate':moduleRelationsToBeUpdate};
	}
		
	</script>
</body>
</html>