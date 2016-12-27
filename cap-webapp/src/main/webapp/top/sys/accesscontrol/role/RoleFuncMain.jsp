
<%
	/**********************************************************************
	 * ��ɫ��Դ
	 * 2014-7-21 ������ �½�
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<title>Ӧ����Ȩ</title>
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css"
	type="text/css">
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/util.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/RoleAction.js"></script>
<script type="text/javascript"
	src='${pageScope.cuiWebRoot}/top/sys/dwr/interface/ModuleAction.js'></script>

<style type="text/css">
img {
	margin-left: 5px;
}

#addRoleButton {
	margin-right: 5px;
}

.grid_container input {
	margin-left: -3px;
}
</style>
</head>
<body onload="window.status='Finished';">

	<div uitype="Borderlayout" id="body" is_root="true">
		<!-- ���ģ���� -->
		<div uitype="bpanel" id="leftMain" style="overflow:hidden" position="left" width="288" show_expand_icon="true">
		  <div style="padding-top:40px;width:100%;position:relative;">
          <div style="position:absolute;top:0;left:0;height:40px;width:100%;">
			<div style = "padding-left:15px;padding-top:5px;">
				<span uitype="ClickInput" id="keyword" name="keyword"
						emptytext="������ϵͳӦ�����ƹؼ��ֲ�ѯ" on_iconclick="fastQuery" icon="search"
						enterable="true" editable="true" width="240"
						on_keydown="keyDownQuery"></span>
				</div>
				 </div>     
				 <div style="float:left;padding-left:15px;padding-top:5px;">
					<input type="checkbox" id="associateQuery" align="middle"  title="ֻ��ʾ����ȨӦ��"  onclick="getAccessApp(0)" style="cursor:pointer;"/>
				</div>     
				<div style="float:left;padding-top:2.5px;">
					<label onclick="getAccessApp(1)" style="cursor:pointer;" id="label">&nbsp;ֻ��ʾ����ȨӦ��</label>
				</div>	
               <div id="treeDivHight" style="overflow:auto;height:100%;float:left;width:274px;padding-left:9px;">
					<div id="fastQueryList" uitype="MultiNav" datasource="initBoxData"></div>
					<div id="moduleTree" uitype="Tree" children="initDataModule"
						on_lazy_read="loadNode" on_click="treeClick"
						click_folder_mode="1"></div>
					<div id="accessTree"></div>
				</div>
			</div>
		</div>
		<div uitype="bpanel" position="center" id="centerMain" header_title="��ɫ�б�" height="500"></div>
	</div>

	<script type="text/javascript">
		var activeRoleClassifyId = "";
		var curNodeId = "<c:out value='${param.moduleId}'/>";
		var roleId = "<c:out value='${param.roleId}'/>";
		var initBoxData = [];
		var tempMultiNavClickId = "";
		var tempMultiNavClickFatherId = "";
		var tempMultiNavClickName = "";
		var isShowAccessApp = 0;
		var dialog;
		var chooes_type = "<c:out value='${param.chooes_type}'/>";
		queryCondition = {};
		queryCondition = {};
		var roleWin;
		//��ǰѡ�е����ڵ�
		$(document).ready(function() {
			comtop.UI.scan();
			$("#treeDivHight").height($("#leftMain").height()-70);
		});
		
		window.onresize= function(){
			$("#treeDivHight").height($("#leftMain").height()-70);
		}
		
		//ֻ��ʾ����Ȩ��Ӧ��
		function getAccessApp(type){
			var associate=$('#associateQuery')[0].checked;
			if(type == '1'){
	       		if(associate){
	       			$('#associateQuery')[0].checked=false;
	       		}else{
	       			$('#associateQuery')[0].checked=true;
	       		}
       		}
			
			isShowAccessApp = $('#associateQuery')[0].checked==true?1:0;
			if(isShowAccessApp == 0){
				cui('#moduleTree').show(); 
				//��������Ȩ��Ӧ����
				cui('#accessTree').hide();
				cui('#fastQueryList').hide();
				
			}else{
				cui('#moduleTree').hide();
				cui('#fastQueryList').hide();
				//��ʾ����Ȩ��Ӧ����
				initAccessAppTree();
				fastQuery();
			}
			
		}
		
		//��ʼ������Ȩ��Ӧ����
		function initAccessAppTree(){
			dwr.TOPEngine.setAsync(false);
			RoleAction.queryChildrenAccessApp({roleId:roleId},function(data){
				var objTree = jQuery.parseJSON(data);
				if(cui("#accessTree").isCUI){
					cui("#accessTree").setDatasource(objTree.children);
				}else{
					cui("#accessTree").tree({
						children: objTree.children, 
						select_mode:3, 
						on_click: function(node, event){
							curNodeId = node.getData().key;
							cui('#body').setContentURL(
									"center",
									'RoleFuncList.jsp?moduleId=' + node.getData().key + "&roleId="
											+ roleId + "&chooes_type=" + chooes_type);
						}
					});
				}
				cui('#accessTree').show();
			});
			dwr.TOPEngine.setAsync(true); 
		}

		function showFuncList() {
			//��������ֻ��ʾ����ȨӦ��
			var node = [];
			if(isShowAccessApp == 1){
				node = cui("#accessTree").getNode(curNodeId);
			}else{
				node = cui("#moduleTree").getNode(curNodeId);
			}
			if (node != null) {
				node.activate(true);
			}
			cui('#body').setContentURL(
					"center",
					'RoleFuncList.jsp?moduleId=' + curNodeId + "&roleId="
							+ roleId + "&chooes_type=" + chooes_type);
		}
		//չ��ָ���ڵ�
		function expandToNode() {
			cui("#moduleTree").getNode("<c:out value='${param.moudleId}'/>").focus();
			showFuncList();
		}

		//---------------------------------------------------------------	

		//��ʼ������ 
		function initDataModule(obj) {
			$('#fastQueryList').hide();

			var moduleObj = {
				"parentModuleId" : "-1"
			};
			dwr.TOPEngine.setAsync(false);
			ModuleAction.queryChildrenModule(moduleObj, function(data) {

				if (data == null || data == "") {
					//��Ϊ��ʱ�����и��ڵ���������
					return;
				} else {
					var treeData = jQuery.parseJSON(data);
					treeData.expand = true;
					treeData.activate = true;
					obj.setDatasource(treeData);
					nodeData = treeData;
				}
			});
			dwr.TOPEngine.setAsync(true);
			autoloadNode();
		}
		//�Զ�չ����
		function autoloadNode() {
			if (curNodeId != null && curNodeId != '') {
				RoleAction.queryModuleThreeByChildrenId(curNodeId, function(
						data) {
					if (data != null && data != '') {
						var dataList = data.list;
						for (var i = dataList.length; i > 0; i--) {

							objData = dataList[i - 1];

							if (objData.parentModuleId != "-1"
									&& objData.moduleId != curNodeId) {
								var objNode = cui("#moduleTree").getNode(
										objData.moduleId);
								loadNode(objNode);
							} else if (objData.moduleId == curNodeId) {
								showFuncList();
							}
						}
					}
				});
			}
		}
		// �������¼�
		function treeClick(node) {
			var data = node.getData();
			curNodeId = data.key;
			node.select();
			showFuncList();
		}

		function showTree() {
			cui('#keyword').setValue('');
			cui('#fastQueryList').hide();
			cui('#moduleTree').show();
			cui.addType = '';
		}

		//���click�¼����ؽڵ㷽��
		function loadNode(node) {
			dwr.TOPEngine.setAsync(false);
			var moduleObj = {
				"parentModuleId" : node.getData().key
			};
			ModuleAction.queryChildrenModule(moduleObj, function(data) {
				var treeData = jQuery.parseJSON(data);
				treeData.activate = true;
				node.addChild(treeData.children);
				node.setLazyNodeStatus(node.ok);
			});
			dwr.TOPEngine.setAsync(true);
		}

		//���ٲ�ѯ�б�����Դ
		function listBoxData(obj) {
			initBoxData = [];
			var keyword = cui("#keyword").getValue().replace(
					new RegExp("/", "gm"), "//");
			keyword = keyword.replace(new RegExp("%", "gm"), "/%");
			keyword = keyword.replace(new RegExp("_", "gm"), "/_");
			keyword = keyword.replace(new RegExp("'", "gm"), "''");
			dwr.TOPEngine.setAsync(false);
			RoleAction.fastQueryModule(keyword, isShowAccessApp, roleId, function(data) {
				var len = data.length;
				if (len != 0) {
					$.each(data, function(i, cData) {
						if (cData.moduleName.length > 31) {
							path = cData.moduleName.substring(0, 31) + "..";
						} else {
							path = cData.moduleName;
						}
						initBoxData.push({
							href : "#",
							name : path,
							title : cData.moduleName,
							onclick : "clickRecord('" + cData.moduleId + "','"
									+ cData.moduleName + "')"
						});
					});
				} else {
					initBoxData.push({
						href : "#",
						name : "û������",
						title : "",
						onclick : ""
					});
				}
			});
			cui("#fastQueryList").setDatasource(initBoxData);
			dwr.TOPEngine.setAsync(true);
		}

		function fastQuery() {
			var keyword = cui('#keyword').getValue();
			if (keyword == '') {
				$('#fastQueryList').hide();
				var node = [];
				if(isShowAccessApp == 1){
					initAccessAppTree(); 
					$('#moduleTree').hide();
					node = cui('#accessTree').getNode(curNodeId);
				}else{
					$('#moduleTree').show();
					$('#accessTree').hide();
					node = cui('#moduleTree').getNode(curNodeId);
				}
				addType = '';
				if (node) {
					treeClick(node);
				}
			} else {
				$('#fastQueryList').show();
				$('#moduleTree').hide();
				$('#accessTree').hide();
				listBoxData(cui('#fastQueryList'));
				addType = 'fastQueryType';
			}
		}

		//���̻س������ٲ�ѯ 
		function keyDownQuery() {
			if (event.keyCode == 13) {
				fastModuleQuery();
			}
		}

		function clickRecord(moduleId, modulePath) {
			var selectedModuleId = moduleId;
			var moduleName = "";
			var moduleType = "";
			var parentModuleId = "";
			var parentModuleName = "";
			var parentModuleType = "";
			dwr.TOPEngine.setAsync(false);
			ModuleAction.getModuleInfo(selectedModuleId, function(data) {
				var moduleVO = data;
				moduleName = moduleVO.moduleName;
				moduleType = moduleVO.moduleType;
				parentModuleId = moduleVO.parentModuleId;
			});
			dwr.TOPEngine.setAsync(true);

			dwr.TOPEngine.setAsync(false);
			ModuleAction.getModuleInfo(parentModuleId, function(data) {
				var parentModuleVO = data;
				if (data == null) {
					parentModuleName = '';
				} else {
					parentModuleName = parentModuleVO.moduleName;
					parentModuleType = parentModuleVO.moduleType;
				}
			});
			dwr.TOPEngine.setAsync(true);
			curNodeId = moduleId;
			showFuncList();

		}
	</script>
</body>
</html>
