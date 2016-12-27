
<%
	/**********************************************************************
	 * 4Aͬ�������־
	 * 2014-08-22 ������  �½�
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<title>4Aͬ�������־</title>

<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/util.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/FouraSyncTailAction.js"></script>
<style type="text/css">
body,html {
	margin: 0;
	width: 100%;
}
</style>

</head>
<body>
	<div style="margin-left: 10px">
		<div uitype="bpanel" position="center" id="centerMain"
			header_title="4Aͬ�������־" height="500">
			<div class="list_header_wrap">
				<div class="top_float_left">
					<span uitype="ClickInput" id="myClickInput" name="clickInput"
						editable="true" emptytext="����������" on_keydown="keyDowngGridQuery"
						width="280" on_iconclick="iconclick"
						icon="${pageScope.cuiWebRoot}/top/sys/images/querysearch.gif"></span>
				</div>
			</div>
			<div id="grid_wrap" style="margin-top: 5px">
				<table uitype="grid" id="tailGrid" sorttype="1" selectrows="no"
					datasource="initGridData" pagesize_list="[20,30,50]" pagesize="20"
					primarykey="syncTailId" resizewidth="resizeWidth"
					resizeheight="resizeHeight" colrender="columnRenderer"
					titlerender="title">
					<th bindName="syncName" sort="true">����</th>
					<th bindName="syncDataType" sort="true">ͬ������</th>
					<th bindName="syncDataMethod" sort="true">��������</th>
					<th bindName="syncTime" sort="true"
						renderStyle="text-align: center" format="yyyy-MM-dd">��¼ʱ��</th>
					<th bindName="syncInfoNote" renderStyle="text-align: center">����</th>
					<th bindName="syncState" sort="true"
						renderStyle="text-align: center">״̬</th>

				</table>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		queryCondition = {};

		$(document).ready(function() {
			comtop.UI.scan();
		});

		//������ͼƬ����¼�
		var gridKeyword = "";
		function iconclick() {
			gridKeyword = cui("#myClickInput").getValue().replace(
					new RegExp("/", "gm"), "//");
			gridKeyword = gridKeyword.replace(new RegExp("'", "gm"), "''");
			gridKeyword = gridKeyword.replace(new RegExp("%", "gm"), "/%");
			gridKeyword = gridKeyword.replace(new RegExp("_", "gm"), "/_");
			cui("#tailGrid").setQuery({
				pageNo : 1
			});
			cui("#tailGrid").loadData();
		}

		//���̻س������ٲ�ѯ 
		function keyDowngGridQuery(event) {

			if (event.keyCode == 13) {
				iconclick();
			}
		}
		function initGridData(grid, query) {
			var sortFieldName = query.sortName[0];
			var sortType = query.sortType[0];
			queryCondition.syncName = gridKeyword;
			queryCondition.pageNo = query.pageNo;
			queryCondition.pageSize = query.pageSize;
			queryCondition.sortFieldName = sortFieldName;
			queryCondition.sortType = sortType;
			FouraSyncTailAction.querySyncTailList(queryCondition,
					function(data) {
						var totalSize = data.count;
						var dataList = data.list;
						grid.setDatasource(dataList, totalSize);
					});
		}

		//Grid�������Ӧ��Ȼص����������ظ߶ȼ���������
		function resizeWidth() {
			return $('body').width() - 20;
			//return (document.documentElement.clientWidth || document.body.clientWidth) - 297;
		}

		//Grid�������Ӧ�߶Ȼص����������ؿ�ȼ���������
		function resizeHeight() {
			return (document.documentElement.clientHeight || document.body.clientHeight) - 70;
		}

		function columnRenderer(data, field) {
			if (field == 'syncDataType') {
				var dataType = data['syncDataType'];
				if (dataType == 1) {
					return "��Ա"
				} else if (dataType == 2) {
					return "����";
				} else if (dataType == 3) {
					return "��λ";
				}
			}
			if (field == 'syncDataMethod') {
				var dataMethod = data['syncDataMethod'];
				if (dataMethod == 1) {
                    return "����";
				} else if (dataMethod == 2) {
					return "�޸�";
				} else if (dataMethod == 3) {
					return "ɾ��";
				}
			}
			if(field=='syncState'){
				var state=data['syncState'];
				if(state==11||state==21||state==31){
					return "������ ";
				}else if(state==12||state==22||state==32){
					return "���޸�";
				}else if(state==13||state==23||state==33){
					return "��ע��";
				}else if(state==14){
					return "�Ѽ�ְ";
				}else if(state==15){
					return "����ְ";
				}else if(state==16){
					return "�ѳ�ְ";
				}else if(state==17){
					return "������";
				}else if(state==18){
					return "�ѵ���";
				}else if(state==0){
					return "��ȷ�ϴ���";
				}else if(state==-1){
					return "�����쳣";
				}else{
					return "����";
				}
			}

		}
	</script>
</body>
</html>