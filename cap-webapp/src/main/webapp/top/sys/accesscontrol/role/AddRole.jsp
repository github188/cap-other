
<%
	/**********************************************************************
	 * ��ɫ������ͼ
	 * 2013-3-29  ��С�� �½�
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<title>��ɫ������ͼ</title>
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css"
	type="text/css">

<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/util.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/SubjectRoleAction.js"></script>
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
		<div uitype="bpanel" id="leftMain" position="left" width="288"
			show_expand_icon="true">
			<table width="95%" style="margin-left: 10px">
				<tr id="tr_moduleTree">
					<td style="height: 5px"></td>
				</tr>
				<tr>
					<td><span uitype="ClickInput" id="keyword" name="keyword"
						emptytext="������ϵͳ��ģ�����ƹؼ��ֲ�ѯ" on_iconclick="fastQuery"
						icon="${cuiWebRoot}/top/sys/images/querysearch.gif"
						enterable="true" editable="true" width="240"
						on_keydown="keyDownQuery"></span></td>
				</tr>

				<tr id="tr_moduleTree">
					<td>
						<div id="moduleTree" uitype="Tree" children="initDataModule"
							on_lazy_read="loadNode" on_click="treeClick"
							click_folder_mode="1"></div>
					</td>
				</tr>
			</table>
		</div>
		<div uitype="bpanel" position="center" id="centerMain"
			header_title="��ɫ�б�" height="500">
			<div class="list_header_wrap" style="">
				<div class="top_float_left">
					<span uitype="ClickInput" id="myClickInput" name="clickInput"
						editable="true" emptytext="�������ɫ����" on_keydown="keyDowngGridQuery"
						width="280" on_iconclick="iconclick"
						icon="${pageScope.cuiWebRoot}/top/sys/images/querysearch.gif"></span>
				</div>
				<div class="top_float_right">
					<span uitype="button" id="addRoleButton" label="����"
						on_click="savePostRole"></span>

				</div>
			</div>
			<div id="grid_wrap">
				<table uitype="grid" id="roleGrid" sorttype="1"
					datasource="initGridData" pagesize_list="[10,20,30]" pagesize="10"
					primarykey="roleId" resizewidth="resizeWidth"
					resizeheight="resizeHeight" colrender="columnRenderer"
					titlerender="title">
					<th style="width: 30px;"><input type="checkbox"></th>
					<th bindName="roleName" sort="true">��ɫ����</th>
					<th bindName="description" sort="true">����</th>
					<th bindName="creatorName" sort="true"
						renderStyle="text-align: center">������</th>
					<th bindName="createTime" sort="true"
						renderStyle="text-align: center" format="yyyy-MM-dd">��������</th>
					<th bindName="strRoleType" sort="true"
						renderStyle="text-align: center">��ɫ����</th>

				</table>
			</div>
		</div>
	</div>

	<script type="text/javascript">
		var subjectTypeCode = "";
		var activeRoleClassifyId="";
		var subjectId = "1";
		var initBoxData = [];
		var tempMultiNavClickId = "";
		var tempMultiNavClickFatherId = "";
		var tempMultiNavClickName = "";
		var dialog;

		queryCondition = {};
		var roleWin;
		//��ǰѡ�е����ڵ�
		var curNodeId = '';
		$(document).ready(function() {
			comtop.UI.scan();
			//cui('#body').setContentURL("left",'${pageScope.cuiWebRoot}/top/sys/accesscontrol/role/SysModuleThree.jsp');

		});

		//���ٲ�ѯ
		function fastQuery() {
			var keyword = cui('#keyword').getValue().replace(
					new RegExp("/", "gm"), "//");
			keyword = keyword.replace(new RegExp("'", "gm"), "''");
			keyword = keyword.replace(new RegExp("%", "gm"), "/%");
			keyword = keyword.replace(new RegExp("_", "gm"), "/_");
			if (keyword == '') {
				switchTreeListStyle("tree");
				//TODO ����ѡ��ڵ㣬��ˢ���Ҳ�iframe
				var node = cui('#roleClassifyTree').getNode(curNodeId);
				if (node) {
					treeClick(node);
				}
			} else {
				switchTreeListStyle("list");
				listBoxData(cui('#fastQueryList'), keyword);
			}
		}

		//----------------------------------------------------------------------------------Grid-------------------------------------------
		//----------------------------------------------------------------------------------------------------------------------------------

		//��Ⱦ�б�����
		function initGridData(grid, query) {
			var sortFieldName = query.sortName[0];
			var sortType = query.sortType[0];
			queryCondition.pageNo = query.pageNo;
			queryCondition.pageSize = query.pageSize;
			queryCondition.roleClassifyId = activeRoleClassifyId;
			queryCondition.fastQueryValue = gridKeyword;
			queryCondition.sortFieldName = sortFieldName;
			queryCondition.sortType = sortType;
			RoleAction.queryRoleList(queryCondition, function(data) {
				var totalSize = data.count;
				var dataList = data.list;
				grid.setDatasource(dataList, totalSize);
			});
		}

		//Grid�������Ӧ��Ȼص����������ظ߶ȼ���������
		function resizeWidth() {
			return $('body').width() - 292;
			//return (document.documentElement.clientWidth || document.body.clientWidth) - 297;
		}

		//Grid�������Ӧ�߶Ȼص����������ؿ�ȼ���������
		function resizeHeight() {
			return (document.documentElement.clientHeight || document.body.clientHeight) - 70;
		}

		//������ͼƬ����¼�
		var gridKeyword = "";
		function iconclick() {
			gridKeyword = cui("#myClickInput").getValue().replace(
					new RegExp("/", "gm"), "//");
			gridKeyword = gridKeyword.replace(new RegExp("'", "gm"), "''");
			gridKeyword = gridKeyword.replace(new RegExp("%", "gm"), "/%");
			gridKeyword = gridKeyword.replace(new RegExp("_", "gm"), "/_");
			cui("#roleGrid").setQuery({
				pageNo : 1
			});
			cui("#roleGrid").loadData();
		}
		//���̻س������ٲ�ѯ 
		function keyDowngGridQuery(event) {

			if (event.keyCode == 13) {
				iconclick();
			}
		}
		//������ɫ
		function savePostRole() {

			var selectIds = cui("#roleGrid").getSelectedPrimaryKey();//��ȡҪɾ����������
   			if(selectIds == null || selectIds.length == 0){
   				cui.alert("��ѡ��Ҫ��ӵĽ�ɫ��");
   				return;
   			}
   			var message = "ȷ��Ҫ�����"+selectIds.length+"����ɫ����λ���棿";
   			addRoles(selectIds,message);//ɾ����ɫ

		}
		 function addRoles(selectIds,message){
	   			cui.confirm(message, {
					buttons: [{
						name: 'ȷ��',
						handler: function(){
							dwr.TOPEngine.setAsync(false);
							SubjectRoleAction.savePostSubjectRoleList(selectIds,subjectId,function(){
		   						window.parent.cui.message("���"+selectIds.length+"����ɫ�ɹ�","success");
				            	window.parent.addCallBack();
				            	window.parent.dialog.hide();
				            	
		   			        });
		   					dwr.TOPEngine.setAsync(true);
	   			  		}
					},{
						name: 'ȡ��',
						handler: function(){
						}
					}]
				});
				
	    	}
	   		
		//���水ť
   		function saveRole(){
   			var selectIds = cui("#roleGrid").getSelectedPrimaryKey();//��ȡҪɾ����������
   			if(selectIds == null || selectIds.length == 0){
   				cui.alert("��ѡ��Ҫ��ӵĽ�ɫ��");
   				return;
   			}
   			var canDelete = true;
   			//������ǳ�������Ա������Ƿ���ί�еĽ�ɫ����������ɾ�� 
   	   		if(globalUserId != 'SuperAdmin'){
	   			var selectedDatas = cui("#roleGrid").getSelectedRowData();
	   			for(var data in selectedDatas){
					if(globalUserId != selectedDatas[data]["creatorId"] ){
						canDelete = false;
						break;
					}
	   	   		}

   	   	   	 }
   			var message = "ȷ��Ҫ�����"+selectIds.length+"����ɫ��";
   			addRoles(selectIds,message);//ɾ����ɫ
   		}
		
		//---------------------------------------------------------------	

		//��ʼ������ 
		function initDataModule(obj) {
			$('#fastQueryList').hide();

			var moduleObj = {
				"parentModuleId" : "-1"
			};
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
		}

		// �������¼�
		function treeClick(node) {

			var data = node.getData();
			curNodeId = data.key;
			node.select();
			activeRoleClassifyId = data.key;
			var query = cui("#roleGrid").getQuery();
			query.pageNo = 1;
			//��ղ�ѯ�����������ͷ��������
			cui("#myClickInput").setValue("");
			gridKeyword = "";
			cui("#roleGrid").setQuery(query)
			cui("#roleGrid").loadData();

		}

		function showTree() {
			cui('#keyword').setValue('');
			cui('#fastQueryList').hide();
			cui('#moduleTree').show();
			cui.addType = '';
		}
		//���click�¼����ؽڵ㷽��
		function loadNode(node) {
			curOrgId = node.getData().key;
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
	</script>
</body>
</html>
