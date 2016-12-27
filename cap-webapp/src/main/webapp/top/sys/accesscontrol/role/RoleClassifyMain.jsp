
<%
	/**********************************************************************
	 * ��ɫ����
	 * 2014-7-21 ������ �½�
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>

<%@ include file="/top/component/common/AccessTaglibs.jsp" %>

<html>
<head>
<title>��ɫ����</title>
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css"
	type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">
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

th {
	font-weight: bold;
	font-size: 14px;
}

.img1 {
	width:16px;
	background: url(../../images/setting.png) no-repeat;
	height: 16px;
	cursor:pointer;
}

</style>
</head>
<body onload="window.status='Finished';" style="padding-left:5px">

	<div uitype="Borderlayout" id="body" is_root="true">
		<!-- ���ģ���� -->
		<div uitype="bpanel" id="leftMain" style="overflow:hidden" position="left" width="275" show_expand_icon="true">
			<div style="padding-top:60px;width:100%;position:relative;">
          <div style="position:absolute;top:0;left:0;height:60px;width:100%;">
          <div style = "padding-left:5px;padding-top:5px;">			
						<span uitype="ClickInput" id="keywordModule"
						name="keyword" emptytext="������ϵͳӦ�����ƹؼ��ֲ�ѯ"
						on_iconclick="fastModuleQuery"
						icon="search" enterable="true" editable="true" width="240"
						on_keydown="keyDownModuleQuery"></span>
						</div>
						<div style="float:left;padding-left:4px;padding-top:5px;">
							<input type="checkbox" id="associateQuery" align="middle"  title="������ѯ"  onclick="setAssociate(0)" style="cursor:pointer;"/>
						</div>
						<div style="float:left;padding-top:2.5px;"><label onclick="setAssociate(1)" style="cursor:pointer;" id="label">&nbsp;������ѯ��ɫ</label></div>	
						</div>  
						  <div  id="treeDivHight" style="overflow:auto;height:100%;">
						<div style="width:255px; border:1px solid #ccc;display:none;font: 12px/25px Arial;" id="moduleNameDivBox">
							<div id="fastQueryList" uitype="MultiNav" datasource="initBoxData"></div>
						</div>
						<div id="moduleTree" uitype="Tree" children="initDataModule"
							on_lazy_read="loadNode" on_click="treeClick"
							click_folder_mode="1"></div>
					</div>
					</div>
							
		</div>
	
		<div uitype="bpanel" position="center" id="centerMain"
			header_title="��ɫ�б�" height="500">
			<div class="list_header_wrap"  style="padding-top: 15px;padding-bottom: 15px;padding-left: 15px;padding-right:10px;">
				<div class="top_float_left">
					<span uitype="ClickInput" id="myClickInput" name="clickInput"
						editable="true" emptytext="�������ɫ���ƻ������ؼ��ֲ�ѯ" on_keydown="keyDowngGridQuery"
						width="280" on_iconclick="iconclick"
						icon="search"></span>
					&nbsp;<span uitype="RadioGroup" name="ball" id="radioGroup" value="1"
						br="[2, 4]" on_change="changeHandler"> <input type="radio"
						value="1" text="�Խ���ɫ" /><input type="radio" value="2"
						text="ί�н�ɫ" />
					</span>
				</div>
				<div class="top_float_right" <% if(isHideSystemBtn){ %> style="display:none" <% } %> style="margin-right:5px" >
					<span uitype="button" id="addRoleButton" label="������ɫ"
						on_click="addRole"></span>&nbsp;<span uitype="button"
						id="deleteRoleButton" label="ɾ����ɫ" on_click="deleteRole"></span>&nbsp;
						
				</div>
			</div>
			<div style="padding:0 15px 0 15px">
			<div id="grid_wrap">
				<table uitype="grid" id="roleGrid" 
					datasource="initGridData" pagesize_list="[10,20,30]" pagesize="20"
					primarykey="roleId" resizewidth="resizeWidth"
					resizeheight="resizeHeight" colrender="columnRenderer"
					titlerender="title">
					<th style="width:30px"><input type="checkbox" /></th>
					<th bindName="roleName" sort="true">��ɫ����</th>
					<th bindName="description" sort="true">����</th>
					<th bindName="classifyName" sort="true">����ϵͳӦ��</th>
					<th bindName="creatorName" sort="true"
						renderStyle="text-align: center">������</th>
					<th bindName="createTime" sort="true"
						renderStyle="text-align: center" format="yyyy-MM-dd">��������</th>
					<th bindName="operator" sort="false"
						renderStyle="text-align: center">����</th>
				</table>
			</div>
			<div id="grid_wrap2">
				<table uitype="grid" id="roleGrid2" sorttype="1" selectrows="no"
					datasource="initGridData" pagesize_list="[10,20,30]" pagesize="20"
					primarykey="roleId" resizewidth="resizeWidth"
					resizeheight="resizeHeight" colrender="columnRenderer"
					titlerender="title">
					<th bindName="roleName" sort="true">��ɫ����</th>
					<th bindName="description" sort="true">����</th>
					<th bindName="classifyName" sort="true">����ϵͳӦ��</th>
					<th bindName="creatorName" sort="true"
						renderStyle="text-align: center">������</th>
					<th bindName="createTime" sort="true"
						renderStyle="text-align: center" format="yyyy-MM-dd">��������</th>
					<th bindName="operator" sort="false"
						renderStyle="text-align: center">����</th>
				</table>
			</div>
</div>

		</div>
	</div>
	<script type="text/javascript">

		var isHideSystemBtn = '<%=isHideSystemBtn %>';
		var activeRoleClassifyId = "";
		var roleClassifyType = "";
		var initBoxData = [];
		var tempMultiNavClickId = "";
		var tempMultiNavClickFatherId = "";
		var tempMultiNavClickName = "";
		var dialog;
		var chooes_type = 0;
		//globalUserId="${param.userName}";
		queryCondition = {};
		var roleWin;
		var curOrgId = "-1";
		//��ǰѡ�е����ڵ�
		var curNodeId = '-1';
		var associateType ="";
		
		window.onload = function() {
			comtop.UI.scan();
			$("#treeDivHight").height($("#leftMain").height()-60);
			cui("#grid_wrap2").hide();
			if (globalUserId == 'SuperAdmin') {
				cui("#radioGroup").hide();
			} else {
				chooes_type = 1;
			}
		}
		
		window.onresize= function(){
			setTimeout(function(){
				$("#treeDivHight").height($("#leftMain").height()-60);
			},300);
		}
		
		  //���ü���  1Ϊ ������ѯ��0ΪĬ��
    	function setAssociate(type){
    		var associate=$('#associateQuery')[0].checked;
    		if(type==1){
        		if(associate){
        			$('#associateQuery')[0].checked=false;
        		}else{
        			$('#associateQuery')[0].checked=true;
        		}
        	}
    		 //Ϊ1 ������ѯ
      	    associateType=$('#associateQuery')[0].checked==true?1:0;
    		//�жϵ�ǰչʾ�����νṹ�����б��ѯ
    		if($('#moduleNameDivBox').is(":hidden")){
    			//�����δ����
    			var node = cui('#moduleTree').getActiveNode();
    			if(node){
	    			treeClick(node);
    			}
    		}else{
    			//������Ѿ����أ����жϿ��ٲ�ѯ�����Ľ�������Ƿ��м�¼��ѡ��
    			//ѡ�������������ѯ
    			var checkdata = cui('#fastQueryList').getCheckedData();
    			if(checkdata){
    				if(checkdata.data.moduleId){
	    				clickRecord(checkdata.data.moduleId, checkdata.data.moduleName);
    				}
    			}
    		} 
        }
		
		function changeHandler(value) {
			chooes_type = value;
			if (value == 2) {
				cui("#addRoleButton").hide();
				cui("#deleteRoleButton").hide();
				cui("#grid_wrap").hide();
				cui("#grid_wrap2").show();
				cui("#myClickInput").setValue("");
				gridKeyword = "";
				cui("#roleGrid2").setQuery({
					pageNo : 1,
					sortType : [],
					sortName : []
				});
				cui("#roleGrid2").loadData();
			} else if (value == 1) {
				cui("#addRoleButton").show();
				cui("#deleteRoleButton").show();
				cui("#grid_wrap2").hide();
				cui("#grid_wrap").show();
				cui("#myClickInput").setValue("");
				gridKeyword = "";
				cui("#roleGrid").setQuery({
					pageNo : 1,
					sortType : [],
					sortName : []
				});
				cui("#roleGrid").loadData();
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
			queryCondition.cascadeQuery = associateType;
			//�û��½���ɫ
			if (chooes_type == 1) {
				queryCondition.creatorId = globalUserId;
				RoleAction.queryRoleList(queryCondition, function(data) {
					var totalSize = data.count;
					var dataList = data.list;
					grid.setDatasource(dataList, totalSize);
				});
			}
			//ί�н�ɫ
			else if (chooes_type == 2) {
				queryCondition.creatorId = globalUserId;
				RoleAction.queryGradeAdminRoleList(queryCondition, function(data) {
					var totalSize = data.count;
					var dataList = data.list;
					grid.setDatasource(dataList, totalSize);
				});
			} else if(globalUserId=='SuperAdmin'){
				RoleAction.queryRoleList(queryCondition, function(data) {
					var totalSize = data.count;
					var dataList = data.list;
					grid.setDatasource(dataList, totalSize);
				});
			}
		}

		//Grid�������Ӧ��Ȼص����������ظ߶ȼ���������
		function resizeWidth() {
			return $('body').width() - 321;
			//return (document.documentElement.clientWidth || document.body.clientWidth) - 297;
		}

		//Grid�������Ӧ�߶Ȼص����������ؿ�ȼ���������
		function resizeHeight() {
			return (document.documentElement.clientHeight || document.body.clientHeight) - 70;
		}

		function title(rowData, bindName) {
			if (bindName == 'operator') {
				return " ";
			}
		}

		//����Ⱦ
		function columnRenderer(data, field) {
			if(field=='roleType'){
				return data['strRoleType'];
			}
			if (field == 'operator') {
				if (chooes_type==2) {
					var strRole = "<img src='${pageScope.cuiWebRoot}/top/sys/images/setting.png' style='cursor:pointer' title='��ɫȨ����ͼ' onclick='setRoleAccess(\""
					+ data["roleId"]
					+ "\",\""
					+ data["roleClassifyId"]
					+"\",\""
					+ data["roleName"]
					+ "\");'></img>";
					strRole = strRole + "&nbsp;&nbsp;<img src='${pageScope.cuiWebRoot}/top/sys/images/post.png' style='cursor:pointer' title='������λ��Ϣ'  onclick='showPost(\""
					+ data["roleId"]
					+ "\",\""
					+ data["roleName"]
					+ "\");'></img>";
					return strRole;
				} else  {
					var strRole = "<img src='${pageScope.cuiWebRoot}/top/sys/images/setting.png' style='cursor:pointer' title='��ɫ��Ȩ' onclick='setRoleAccess(\""
						+ data["roleId"] + "\",\"" + data["roleClassifyId"] +"\",\"" + data["roleName"] + "\");'></img>";
					if(isHideSystemBtn != 'true'){
						strRole = strRole + "&nbsp;&nbsp;<img src='${pageScope.cuiWebRoot}/top/sys/images/wrong_fork.gif' style='cursor:pointer' title='ɾ����ɫ' onclick='deleteOneRole(\""
								+ data["roleId"]
								+ "\",\""
								+ data["roleName"]
								+ "\");'></img>";
					}
					strRole = strRole + "&nbsp;&nbsp;<img src='${pageScope.cuiWebRoot}/top/sys/images/post.png' style='cursor:pointer' title='������λ��Ϣ'  onclick='showPost(\""
					+ data["roleId"]
					+ "\",\""
					+ data["roleName"]
					+ "\");'></img>";
					return strRole;
							
				} 
			}
			if (field == 'roleName') {
                if(chooes_type!=2){
				return "<a class='a_link' href='javascript:eidtRole(\""
						+ data["roleId"] + "\",\"" + data["creatorId"] + "\",\"" +data["roleClassifyId"] + "\");'>" 
							+ data["roleName"] + "</a>";
                 }

			}
			
		}
		
		//��ȡ��ɫ������λ��Ϣ
		function showPost(roleId, roleName){
			var height = (document.documentElement.clientHeight || document.body.clientHeight)-100; //300
			var width = (document.documentElement.clientWidth || document.body.clientWidth)-100; // 560;
			var url = 'RolePostMain.jsp?roleId='+roleId;
			var title = "��ɫ��"+ roleName + "�������ĸ�λ��Ϣ";
			dialog = cui.dialog({
				title : title,
				src : url,
				width : width,
				height : height
			});
			dialog.show(url);
		}
		
		//���ù���Ȩ��
		function setRoleAccess(roleId, roleClassifyId, roleName, roleType) {
			var height = (document.documentElement.clientHeight || document.body.clientHeight)-100; //300
			var width = (document.documentElement.clientWidth || document.body.clientWidth)-100; // 560;
			var url = 'RoleFuncMain.jsp?roleId=' + roleId + "&roleName=" + roleName
					+ "&moduleId=" + roleClassifyId + "&chooes_type="
					+ chooes_type;
			if ("app" == roleType) {
				url = url + "&roleType=app"
			}
			var title = "����ɫ��" + roleName + "������Ȩ��";
			dialog = cui.dialog({
				title : title,
				src : url,
				width : width,
				height : height
			});
			dialog.show(url);
		}

		//�༭ҳ��ص����� ִ�ж������ʱ����Դ����������ݲ������ж�ִ��ʲô������
		function editCallBack(roleId) {
			cui("#roleGrid").loadData();
			cui("#roleGrid").selectRowsByPK(roleId);
		}

		function addCallBack(roleId) {
			//��ղ�ѯ�����������ͷ��������
			cui("#myClickInput").setValue("");
			gridKeyword = "";
			cui("#roleGrid").setQuery({
				pageNo : 1,
				sortType : [],
				sortName : []
			});
			cui("#roleGrid").loadData();
			cui("#roleGrid").selectRowsByPK(roleId);
		}

		//������ͼƬ����¼�
		var gridKeyword = "";
		function iconclick() {
			gridKeyword = cui("#myClickInput").getValue().replace(
					new RegExp("/", "gm"), "//");
			gridKeyword = gridKeyword.replace(new RegExp("'", "gm"), "''");
			gridKeyword = gridKeyword.replace(new RegExp("%", "gm"), "/%");
			gridKeyword = gridKeyword.replace(new RegExp("_", "gm"), "/_");
			if (chooes_type == 2) {
				cui("#roleGrid2").setQuery({
					pageNo : 1
				});
				cui("#roleGrid2").loadData();
			} else {
				cui("#roleGrid").setQuery({
					pageNo : 1
				});
				cui("#roleGrid").loadData();
			}
		}

		//���̻س������ٲ�ѯ 
		function keyDowngGridQuery(event) {
			if (event.keyCode == 13) {
				iconclick();
			}
		}

		//������ɫ
		function addRole() {
			var url = '${pageScope.cuiWebRoot}/top/sys/accesscontrol/role/RoleEdit.jsp?roleClassifyId='
					+ activeRoleClassifyId;
			var title = "";
			var height = 200;
			var width = 500;
			dialog = cui.dialog({
				title : title,
				src : url,
				width : width,
				height : height
			});
			dialog.show(url);
		}

		//�༭��ɫ
		function eidtRole(roleId, creatorId, roleClassifyId) {
			var url = '${pageScope.cuiWebRoot}/top/sys/accesscontrol/role/RoleEdit.jsp?creatorId='
					+ creatorId
					+ '&roleClassifyId='
					+ roleClassifyId
					+ '&roleId=' + roleId;
			if (chooes_type == 2) {
				url += "&chooes_type=" + chooes_type;
			}
			var height = 200;
			var width = 500;
			dialog = cui.dialog({
				title : '',
				src : url,
				width : width,
				height : height
			});
			dialog.show(url);
		}

		//ɾ����ť
		function deleteRole() {
			var selectIds = cui("#roleGrid").getSelectedPrimaryKey();//��ȡҪɾ����������
			if (selectIds == null || selectIds.length == 0) {
				cui.alert("��ѡ��Ҫɾ���Ľ�ɫ��");
				return;
			}
			var canDelete = true;
			//������ǳ�������Ա������Ƿ���ί�еĽ�ɫ����������ɾ�� 
			if (globalUserId != 'SuperAdmin') {
				var selectedDatas = cui("#roleGrid").getSelectedRowData();
				for ( var data in selectedDatas) {
					if (globalUserId != selectedDatas[data]["creatorId"]) {
						canDelete = false;
						break;
					}
				}
			}
			var message = "��ͬʱɾ����Ա��ɫȨ�ޣ�ȷ��Ҫɾ����" + selectIds.length + "����ɫ��";
			deleteRoles(selectIds, message);//ɾ����ɫ
		}

		//�б���ɾ��
		function deleteOneRole(roleId, roleName) {
			cui("#roleGrid").selectRowsByPK(roleId);
			var message = "��ͬʱɾ����Ա��ɫȨ�ޣ�ȷ��Ҫɾ��&nbsp;<font color='red'>"
					+ roleName + "</font>&nbsp;��";
			var selectIds = new Array();//��ȡҪɾ����������
			selectIds[0] = roleId;
			deleteRoles(selectIds, message);//ɾ����ɫ
		}

		//ɾ����ɫ
		function deleteRoles(selectIds, message) {
			cui.confirm(message,
							{buttons : [{name : 'ȷ��',
											handler : function() {
												dwr.TOPEngine.setAsync(false);
												RoleAction.deleteRoles(selectIds,function() {
																	cui("#roleGrid").removeData(cui("#roleGrid").getSelectedIndex());
																	cui("#roleGrid").loadData();
																	cui.message("ɾ��"+ selectIds.length+ "����ɫ�ɹ�","success");
																});
												dwr.TOPEngine.setAsync(true);
											}
										}, {
											name : 'ȡ��',
											handler : function() {
											}
										} ]
							});

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
					var node = cui('#moduleTree').getNode(treeData.key);
					treeClick(node);
				}
			});
		}

		// �������¼�
		function treeClick(node) {
			var data = node.getData();
			curNodeId = data.key;
			node.select();
			loadRole( data.key);
		}

		function loadRole(id){
			activeRoleClassifyId = id;
			var query = cui("#roleGrid").getQuery();
			query.pageNo = 1;
			//��ղ�ѯ�����������ͷ��������
			cui("#myClickInput").setValue("");
			gridKeyword = "";
			if (chooes_type == 2) {
				cui("#roleGrid2").setQuery(query)
				cui("#roleGrid2").loadData();
			}else{
				cui("#roleGrid").setQuery(query)
				cui("#roleGrid").loadData();
			}
		}
		function showTree() {
			cui('#keyword').setValue('');
			cui('#fastQueryList').hide();
			cui('#moduleTree').show();
			cui.addType = '';
		}

		//���click�¼����ؽڵ㷽��
		function loadNode(node) {
			curNodeId = node.getData().key;
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
			var keyword = cui("#keywordModule").getValue().replace(
					new RegExp("/", "gm"), "//");
			keyword = keyword.replace(new RegExp("%", "gm"), "/%");
			keyword = keyword.replace(new RegExp("_", "gm"), "/_");
			keyword = keyword.replace(new RegExp("'", "gm"), "''");
			dwr.TOPEngine.setAsync(false);
			ModuleAction.fastQueryModule(keyword, function(data) {
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
							data : {moduleId:cData.moduleId,moduleName:cData.moduleName},
							title : cData.moduleName,
							onclick : "clickRecord('" + cData.moduleId + "','"
									+ cData.moduleName + "')"
						});
					});
				} else {
					initBoxData.push({
						href : "#",
						name : "û������",
						data : {},
						title : "",
						onclick : ""
					});
				}
			});
			cui("#fastQueryList").setDatasource(initBoxData);
			dwr.TOPEngine.setAsync(true);
		}

		function fastModuleQuery() {
			var keyword = cui('#keywordModule').getValue();
			if (keyword == '') {
				$('#fastQueryList').hide();
				$('#moduleTree').show();
				$('#moduleNameDivBox').hide();
				addType = '';
				var node = cui('#moduleTree').getNode(curNodeId);
				if (node) {
					treeClick(node);
				}
			} else {
				$('#fastQueryList').show();
				$('#moduleTree').hide();
				$('#moduleNameDivBox').show();
				listBoxData(cui('#fastQueryList'));
				addType = 'fastQueryType';
			}
		}

		//���̻س������ٲ�ѯ 
		function keyDownModuleQuery() {
        
			if (event.keyCode == 13) {
				fastModuleQuery();
			}
		}
		
		
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
				}
			});	
			dwr.TOPEngine.setAsync(true);
			loadRole(moduleId);
			
		}
	</script>
</body>
</html>
