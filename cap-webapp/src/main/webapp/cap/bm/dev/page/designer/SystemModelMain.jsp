<%
  /**********************************************************************
	* CIPԪ���ݽ�ģ----ϵͳ��ģ��ҳ�� 
	* 2014-10-30  �� ����
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<%@ page import="java.util.*" %>


<!doctype html>
<html>
<head>
<title>ϵͳ��ģ��ҳ��</title>
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_sys.css" type="text/css">
	<top:link  href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/engine.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/util.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/SystemModelAction.js'></script>
	<script type="text/javascript" src='<%=request.getContextPath() %>/cap/bm/common/top/js/jquery.js'></script>
	<script type="text/javascript" src='<%=request.getContextPath() %>/top/component/topui/cui/js/jquery.dynatree.min.js'></script>
	<script type="text/javascript" src='<%=request.getContextPath() %>/top/component/topui/cui/js/comtop.ui.tree.js'></script>
</head>
<style>
.top_header_wrap {
	padding-right: 5px;
}
</style>
<body>
	<div uitype="Borderlayout" id="body" is_root="true"> 
		<div id="leftMain" position="left" width="300" collapsabltie="true" show_expand_icon="true" collapsable="true">       
         <table width="95%" style="margin-left: 10px">
				<tr height="40px;">
					<td>
						<span uitype="ClickInput" id="keyword" name="keyword" emptytext="������ϵͳ��Ŀ¼��Ӧ�����ƹؼ��ֲ�ѯ"
							on_iconclick="fastQuery"  icon="search" enterable="true"
							editable="true"	 width="260" on_keydown="keyDownQuery"></span>
					</td>
				</tr>
				<tr id="tr_moduleTree" height="20">
					<td align="left" style="padding-left:170px">
						<img title="�ö�" src="<%=request.getContextPath() %>/top/sys/images/func_top.png" style="cursor:pointer" onclick="moveNode('top');">
						<img title="����" src="<%=request.getContextPath() %>/top/sys/images/func_up.png" style="cursor:pointer" onclick="moveNode('up');">
						<img title="����" src="<%=request.getContextPath() %>/top/sys/images/func_down.png" style="cursor:pointer" onclick="moveNode('down');">
						<img title="�õ�" src="<%=request.getContextPath() %>/top/sys/images/func_bottom.png" style="cursor:pointer" onclick="moveNode('bottom');">
					</td>
				</tr>
				<tr>
					<td>
						<div id="fastQueryList" uitype="MultiNav" datasource="initBoxData"></div> 
					</td>
				</tr>
				<tr id="tr_moduleTree">
					<td>
                     <div id="moduleTree" uitype="Tree" children="initData" 
                     on_dbl_click="dbClickNode" min_expand_level="1"  on_lazy_read="loadNode" on_click="treeClick" click_folder_mode="1"></div>
                    </td>
				</tr>
			</table>
         </div>
		<div id="centerMain" position ="center">
			
		</div>
	</div>


	<script type="text/javascript">
		var addType = '';
		
		//ѡ�е����ڵ�
		var selectedNodeId = "-1";
		$(document).ready(function(){
			comtop.UI.scan();   //ɨ��
		});
		
		var addData = [{"title": "ʵ��", "data": {"moduleType": 4}}, 
                       {"title": "��", "data": {"moduleType": 5}},
                       {"title": "����", "data": {"moduleType": 6}},
                       {"title": "����", "data": {"moduleType": 8}},
                       {"title": "�°����", "data": {"moduleType": 88}},
                       {"title": "������������", "data": {"moduleType": 9}},
                       {"title": "������", "data": {"moduleType": 10}}
                       ];
		
		//��ʼ������ 
		function initData(obj) {
			var moduleObj={"parentModuleId":"-1"};
			SystemModelAction.queryChildrenModule(moduleObj,function(data){
				if(data == null || data == "") {
					//��Ϊ��ʱ�����и��ڵ���������
					isRootNodeAdd = "true";
					setRootNode(obj);
				} else {
					var treeData = jQuery.parseJSON(data);
					treeData.expand = true;
					treeData.activate = true;
					if(treeData.children) {
						treeData.children = addSomeChildNode(treeData.children);
					}
			    	obj.setDatasource(treeData);
			    	nodeUrl(treeData.key);
				}
		     });
		}
		
		//���click�¼����ؽڵ㷽��
		function loadNode(node) {
			selectedNodeId = node.getData().key;
			dwr.TOPEngine.setAsync(false);
			var moduleObj={"parentModuleId":node.getData().key};
			SystemModelAction.queryChildrenModule(moduleObj,function(data){
		    	var treeData = jQuery.parseJSON(data);
		    	var childData = treeData.children;
		    	childData = addSomeChildNode(childData);
		    	treeData.activate = true;
		    	node.addChild(childData);
				node.setLazyNodeStatus(node.ok);
		     });
			dwr.TOPEngine.setAsync(true);
		}
		
		// ����ָ��Ŀ¼�ڵ�
		function addSomeChildNode(childData) {
			for(var i=0; i<childData.length; i++) { 
	    		if(childData[i].data.moduleType == 2) {
	    			if(childData[i].isFolder) {
	    				dwr.TOPEngine.setAsync(false);
	    				var moduleObj = {"parentModuleId":childData[i].key};
	    				SystemModelAction.queryChildrenModule(moduleObj,function(data){
	    			    	var treeData = jQuery.parseJSON(data);
	    			    	var childChildData = treeData.children;
	    			    	var newData = childChildData;
	    			    	for(var j=0; j<addData.length; j++) {
	    			    		newData.push(addData[j]);
	    			    	}
	    			    	childData[i].children = newData;
	    			    	if(childChildData) {
	    			    		addSomeChildNode(childChildData);
	    			    	}
	    			     });
	    				dwr.TOPEngine.setAsync(true);
	    			} else {
	    				childData[i].children = addData;
	    			}
	    		}
	    	} 
			return childData;
		}
		
		//�����ұߵ�ҳ������
		function nodeUrl(nodeId){
			var node = cui('#moduleTree').getNode(nodeId);
			parent.clickIframeBack(node);
			var data = node.getData();
			selectedNodeId = data.key;
			var parentData = node.parent().getData();
			var nodeTypeVal = 0;
			if(nodeId != 0){
				nodeTypeVal = data.data.moduleType;
			}
			var parentModuleType = "";
			if(parentData.key != "_1"){
				parentModuleType = parentData.data.moduleType;
			}
			
			var strParentName =  parentData.title;
			if(strParentName!="undefined"&&strParentName!=null&&strParentName!="null"){
				strParentName = encodeURIComponent(encodeURIComponent(strParentName));
			}

			if(nodeTypeVal == 2) { // Ӧ�ýڵ�
				cui('#body').setContentURL("center",'FuncModelEdit.jsp?nodeId=' + nodeId + '&parentNodeId=' + parentData.key
						+ "&parentNodeName=" + strParentName);
			} else if(nodeTypeVal == 3) { // Ŀ¼�ڵ�
				cui('#body').setContentURL("center",'DirectoryEdit.jsp?nodeId=' + nodeId + '&parentNodeId=' + parentData.key
						+ "&parentNodeName=" + strParentName);	
			} else { // ϵͳ�ڵ������
				cui('#body').setContentURL("center",'SystemModuleEdit.jsp?nodeId=' + nodeId + '&parentNodeId=' + parentData.key
						+ "&parentNodeName=" + strParentName);	
			}
		}
		
		//������¼�
		function treeClick(node) {
			parent.clickIframeBack(node);
			var data = node.getData();
			var parentData = node.parent().getData();
			var nodeId = data.key;
			selectedNodeId = nodeId;
			var title = data.title;
			var url = '';
			
			var nodeTypeVal = 0;
			var parentModuleType = 0;
			if(nodeId != 0){
				nodeTypeVal = data.data.moduleType;
			}
			
			if(parentData.key != "_1") {
				parentModuleType = parentData.data.moduleType;
			}
			
			var strParentName =  parentData.title;
			if(strParentName!="undefined"&&strParentName!=null&&strParentName!="null"){
				strParentName = encodeURIComponent(encodeURIComponent(strParentName));
			}
			
			switch(nodeTypeVal) {
				case 1:
					url = 'SystemModuleEdit.jsp?nodeId=' + nodeId + '&parentNodeId=' + parentData.key + '&parentNodeName=' + strParentName + '&nodeTypeVal=' + nodeTypeVal + '&parentModuleType=' + parentModuleType;
			  		break;
				case 2:
					url = 'FuncModelEdit.jsp?nodeId=' + nodeId + '&parentNodeId=' + parentData.key + '&parentNodeName=' + strParentName + '&nodeTypeVal=' + nodeTypeVal + '&parentModuleType=' + parentModuleType;
				  	break;
				case 3:
					url = 'DirectoryEdit.jsp?nodeId=' + nodeId + '&parentNodeId=' + parentData.key + '&parentNodeName=' + strParentName + '&nodeTypeVal=' + nodeTypeVal + '&parentModuleType=' + parentModuleType;
				  	break;
				case 4: // ʵ��
					url = "../entity/EntityList.jsp?packageId=" + node.parent().getData().key +"&packageModuleCode=" + parentData.data.moduleCode;
				  	break;
				case 5: // ��
					url = "../entity/TableModelList.jsp?packageId=" + node.parent().getData().key;
				  	break;
				case 6: // ����
					cui.alert("���ӵ�����ҳ��");
				  	break;
				case 7: // ��ѯ
					cui.alert("���ӵ���ѯ�б�ҳ��");
				  	break;
				case 8: // ����
					url = "../page/PageList.jsp?packageId=" + node.parent().getData().key;
				  	break;
				case 88: // �°����
					url = "<%=request.getContextPath() %>/cap/bm/dev/page/designer/PageList.jsp?packageId=" + node.parent().getData().key;
				  	break;
				case 9: // ������������
					url = "../entity/BusinessDataTypeList.jsp?packageId=" + node.parent().getData().key;
				  	break;
				case 10: // ������
					url = "../workflow/WorkFlowMainTab.jsp?packageModuleCode=" + parentData.data.moduleCode;
				  	break;
				default:
					url = 'SystemModuleEdit.jsp?nodeId=' + nodeId + '&parentNodeId=' + parentData.key + '&parentNodeName=' + strParentName;
			} 
			cui('#body').setContentURL("center",url);	
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
				if(pNode.getData().data.moduleType == 2){
					pNode.addChild(addData);
				}
				var dNode = treeObject.getNode(moduleId);
				dNode.activate();
				dNode.focus();
				treeClick(dNode);
			} 

		}
		
		//���ٲ�ѯ
		function fastQuery(){
			var keyword = cui('#keyword').getValue();
			if(keyword==''){
				$('#fastQueryList').hide();
				$('#moduleTree').show();
				addType = '';
				var node=cui('#moduleTree').getNode(selectedNodeId);
				if(node){
					treeClick(node);
				}
			}else{
				$('#fastQueryList').show();
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
			SystemModelAction.fastQueryModule(keyword,function(data){
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
			SystemModelAction.getModuleInfo(selectedModuleId,function(data){
				var moduleVO = data;
				moduleName = moduleVO.moduleName;
				moduleType = moduleVO.moduleType;
				parentModuleId = moduleVO.parentModuleId;
			});	
			dwr.TOPEngine.setAsync(true);

			dwr.TOPEngine.setAsync(false);
			SystemModelAction.getModuleInfo(parentModuleId,function(data){
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
			
			if(moduleType == 2) { // Ӧ�ýڵ�
				cui('#body').setContentURL("center",'FuncModelEdit.jsp?nodeId=' + selectedModuleId + '&parentNodeId=' + parentModuleId
						+ "&parentNodeName=" + parentModuleName);
			} else if(moduleType == 3) { // Ŀ¼�ڵ�
				cui('#body').setContentURL("center",'DirectoryEdit.jsp?nodeId=' + selectedModuleId + '&parentNodeId=' + parentModuleId
						+ "&parentNodeName=" + parentModuleName);	
			} else { // ϵͳ�ڵ������
				cui('#body').setContentURL("center",'SystemModuleEdit.jsp?nodeId=' + selectedModuleId + '&parentNodeId=' + parentModuleId
						+ "&parentNodeName=" + parentModuleName);	
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
					SystemModelAction.updateModuleRelations(moveType,obj.moduleRelationsToBeUpdate,function(data){
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