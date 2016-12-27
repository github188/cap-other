 <%
/**********************************************************************
* ί�й���:������Ա�б�
* 2013-04-22 ����  �½�
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK"/>
    <title>������Ա�б�鿴</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">    
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">

	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/js/commonUtil.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/UserDelegateAction.js"></script>
    
    <style type="text/css">
    .grid_container input{margin-left: -3px;} 
    th {
	font-weight: bold;
	font-size: 14px;
    }
    </style>
</head>
<body >	
	<div class="list_header_wrap" style="padding-bottom:10px;padding-left:10px;padding-right:12px;">
		<div class="top_float_left">
			<span uitype="ClickInput" id="myClickInput" name="userName"  
				emptytext="���������������" editable="true" width="280" 
				on_iconclick="iconclick"
				icon="search" 
				iconwidth="18px"
				width="250"
				enterable="true">
			</span>
	    </div>
		<div class="top_float_right">
			<span uitype="Button" label="�� ��" on_click="showAccess"></span>
			<span uitype="Button" label="ɾ ��" on_click="deleteConsignUser"></span>
		</div>
	</div>

	 <div>
	 <div id="gridWrap" style="padding:0 15px 0 10px">
	<table id="tableList" uitype="Grid" 
		datasource="initData" primarykey="consignId" sortstyle="1"
		resizeheight="resizeHeight" resizewidth="resizeWidth" pagesize_list="[10,20,30]">
		<thead>
			<tr>
				<th width="40px" align="center"><input type="checkbox" /></th>
				<th style="width:15%;" renderStyle="text-align: left" bindName="delegatedUserName"
					render="renderLink">����������</th>
				<th style="width:15%;" renderStyle="text-align: left" bindName="delegatedOrgName">������֯</th>
				<th style="width:15%;" renderStyle="text-align: center" bindName="startTime"
					format="yyyy-MM-dd hh:mm:ss">��ʼ����</th>
				<th style="width:15%;" renderStyle="text-align: center" bindName="endTime"
					format="yyyy-MM-dd hh:mm:ss">��������</th>
				<th style="width:15%;" renderStyle="text-align: center" 
					render="renderHasAllAccess">ί�����</th>
				<th style="width:15%;" renderStyle="text-align: center" 
					render="renderState">�Ƿ���Ч</th>
				<th style="width:15%;" renderStyle="text-align: center" bindName="managerAccess"
					render="cosignAccessRenderLink">����Ȩ��</th>
			</tr>
		</thead>
	</table>
	</div>
	</div>
	<script type="text/javascript">
		//ί����
		var userId = globalUserId;
		var name = globalUserName;
		
		var keyword = '';
		var dialog;
		
		//ҳ�����
		window.onload = function() {
			comtop.UI.scan();
			$('#gridWrap').height(function(){
				return (document.documentElement.clientHeight || document.body.clientHeight) - 60;		
			});
		}
		
		//��ʼ������
		function initData(obj, query) {
			//���ò�ѯ����
			var condition = {
				userId : userId,
				delegatedUserName : keyword,
				pageNo : query.pageNo,
				pageSize : query.pageSize,
				sortFieldName : query.sortName[0],
				sortType : query.sortType[0]
			};
			dwr.TOPEngine.setAsync(false);
			UserDelegateAction.queryDelegateInfoOfUser(condition, function(data) {
				//��������Դ
				obj.setDatasource(data.list, data.count);
			});
			dwr.TOPEngine.setAsync(true);
		}

		//����Ӧ���
		function resizeWidth() {
			return $('body').width() - 23;
		}
		//����Ӧ�߶�
		function resizeHeight() {
		  return (document.documentElement.clientHeight || document.body.clientHeight) - 68;
		}
		
		//��Ⱦ����
		function renderLink(rowData) {
			return '<a style="text-decoration: underline;" href="javascript:showAccess(\''
					+ rowData["consignId"]
					+ '\')">'
					+ rowData["delegatedUserName"] + '</a>';
		}
		//��Ⱦ�Ƿ���Ч
		function renderState(rowData) {
			if (rowData["state"] == 1) {
				return "<img src='${pageScope.cuiWebRoot}/top/sys/images/check_out.gif' title='��Ч'/>";
			} else {
				return "<img src='${pageScope.cuiWebRoot}/top/sys/images/check_in.gif' title='��Ч'/>";
			}
		}
		//��Ⱦ�Ƿ�ί��ȫ��Ȩ��
		function renderHasAllAccess(rowData) {
			if (rowData["hasAllAccess"] == 0) {
				return "ȫ��";
			} else {
				return "����";
			}
		}
		//��Ⱦ����ί��Ȩ�޵�ͼ��
		function cosignAccessRenderLink(rowData) {
			
			if (rowData["hasAllAccess"] == 0)  {
				return "<img src='${pageScope.cuiWebRoot}/top/sys/images/setting.png' style='cursor: hand;'  onclick='setConsignAccess();' title='����ί��Ȩ��'/>";
			} else {
				return "<img src='${pageScope.cuiWebRoot}/top/sys/images/setting.png' style='cursor: hand;'  onclick='setConsignAccess(\""
				+ rowData["consignId"] + "\");' title='����ί��Ȩ��'/>";
			}
			
		}
		//����ί��Ȩ��
		function setConsignAccess(consignId) {
			
			if(consignId==null||consignId==''){
				cui.alert("ȫ��ί�в���Ҫ����Ȩ�ޣ�");
				return;
			}
			
			var url = "${pageScope.cuiWebRoot}/top/sys/accesscontrol/userdelegate/ConsignAccess.jsp?userId="
					+ userId + "&consignId=" + consignId;
			var setConsignAccessDialog;
			if (!setConsignAccessDialog) {
				setConsignAccessDialog = cui.dialog({
					title : '����ί��Ӧ��',
					src : url,
					width : 600,
					height : 350
				})
			}
			setConsignAccessDialog.show(url);
		}
		//�鿴ί������
		function showAccess(consignId) {
			
			if(userId=="SuperAdmin"){
				cui.alert("��������Ա���ܽ���ί�д���")
				return;
			}
			
			var url = '${pageScope.cuiWebRoot}/top/sys/accesscontrol/userdelegate/ConsignEdit.jsp?userId='
					+ userId;
			if (typeof consignId == "string")
				url += "&consignId=" + consignId;
			if (!dialog) {
				dialog = cui.dialog({
					title : 'ί����Ϣ',
					src : url,
					width : 550,
					height : 380
				})
			}
			dialog.show(url);
		}
		
		//���ٲ�ѯ
		function iconclick() {
			keyword = handleStr(cui('#myClickInput').getValue());
			cui("#tableList").setQuery({
				pageNo : 1
			});
			cui("#tableList").loadData();
		}

		//ɾ�������˲���
		function deleteConsignUser() {
			var selectIds = cui("#tableList").getSelectedPrimaryKey();
			if (selectIds == null || selectIds.length == 0) {
				cui.alert("��ѡ��Ҫɾ���Ĵ����ˡ�");
				return;
			}
			
			cui.confirm("ɾ��������Ҳ��ɾ�������Ȩ��,ȷ��Ҫɾ����" + selectIds.length + "����������",
					{
						onYes : function() {
							dwr.TOPEngine.setAsync(false);
							UserDelegateAction.deleteUserDelegate(
									selectIds, function(data) {
										cui("#tableList").removeData(
												cui("#tableList")
														.getSelectedIndex());
										cui("#tableList").loadData();
										cui.message("ɾ��" + selectIds.length+ "�������˳ɹ���", "success");
									});
							dwr.TOPEngine.setAsync(true);
						}
					});
		}
		//�༭�ص�
		function editCallBack(type) {
			if (type == 'add') {
				cui('#myClickInput').setValue('');
				keyword = "";
				cui("#tableList").setQuery({
					pageNo : 1,
					sortType : [],
					sortName : []
				});
				cui("#tableList").loadData();
				cui("#tableList").selectRowsByIndex(0);
			} else {
				cui("#tableList").loadData();
			}
		}
	</script>
</body>
</html>


            