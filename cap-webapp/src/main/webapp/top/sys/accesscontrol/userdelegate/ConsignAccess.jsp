
<%
	/**********************************************************************
	 * ί�й���:Ȩ�޷���--չ�ֲ˵�Ŀ¼��
	 * 2013-04-09 ����  �½�
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<title>ϵͳȨ��ҳ�����</title>
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
	src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/UserDelegateAction.js"></script>

</head>
    <style type="text/css">
    th {
	font-weight: bold;
	font-size: 14px;
    }
    </style>
<body>
	<div class="list_header_wrap" style="padding-bottom:15px;">
		<div class="top_float_right">
			<span uitype="Button" label="����" on_click="doSave"></span>
		</div>
	</div>

	<table id="tableList" uitype="Grid" class="cui_grid_list"
		datasource="initData" primarykey="funcId" 
		resizeheight="resizeHeight" resizewidth="resizeWidth">
		<thead>
			<tr>
				<th width="40px" align="center"><input type="checkbox" /></th>
				<th style="width: 85%;" renderStyle="text-align: left"
					bindName="funcName">�ҵ�Ӧ��</th>
			</tr>
		</thead>
	</table>
</body>
<script type="text/javascript">
	//��ǰ������
	var userId = "<c:out value='${param.userId}'/>";
	//ί��id
	var consignId = "<c:out value='${param.consignId}'/>";

	//��������
	var funcList = [];

	//var totalSize="";
	var moduleId = "";//�˵�id
	var moduleName = "";//�˵�Ŀ¼����
	var initBoxData = [];
	var nodeData = [];
	//ɨ�裬�൱����Ⱦ
	window.onload = function() {
		comtop.UI.scan();
	}

	//��ʼ������
	function initData(obj, query) {
		
		dwr.TOPEngine.setAsync(false);
		UserDelegateAction.getFuncAccessList(userId, function(data) {
			//��������Դ
			obj.setDatasource(data.list, data.count);
		});
		dwr.TOPEngine.setAsync(true);
		
		
		dwr.TOPEngine.setAsync(false);
		UserDelegateAction.queryUserDelegatedFunc(consignId, function(data) {
			funcList = data.list;
		});
		dwr.TOPEngine.setAsync(true);
		
		if(funcList != null && funcList.length != 0){
			var arr = []
			for(var i=0;i<funcList.length;i++){		
				arr[i] = funcList[i].resourceId;
			}
			obj.selectRowsByPK(arr);
		}
	
	}
	
	
	//����Ӧ���
	function resizeWidth() {
		return $('body').width() - 2;
	}
	//����Ӧ�߶�
	function resizeHeight() {
		return $(document).height() - 65;
	}
	
	//����ί��Ȩ��
	function doSave() {
		var funcIds = cui("#tableList").getSelectedPrimaryKey();
		dwr.TOPEngine.setAsync(false);
		UserDelegateAction.delegateUserAccess(consignId, funcIds, globalUserId,
				function(data) {
					if (data) {
						window.cui.message('ί��Ȩ�޸��³ɹ���');
					}
				});
		dwr.TOPEngine.setAsync(true);
	}
</script>
</html>
