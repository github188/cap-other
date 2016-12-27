
<%
    /**********************************************************************
	 * ��ɫ������λ�б���Ϣ
	 * 2016-01-14 shigang  �½�
	 **********************************************************************/
%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ page contentType="text/html; charset=GBK" %>
<html>
<head>
<title>�����λ�б�</title>

<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/RoleAction.js"></script>
</head>

<body>
	<div class="list_header_wrap">
		<div class="top_float_left">
			<span uitype="ClickInput" editable="true" id="speedScan" name="keyword" emptytext="�������λ���ơ�ȫƴ����ƴ" 
				width="250" maxlength="500" icon="search" on_keydown="keyDownQuery" on_iconclick="keyWordQuery" ></span><br/>
		</div> 
	</div>
	<table id="grid" uitype="grid" pagesize_list="[10,20,30]" datasource="dataProvider" primarykey="OTHER_POST_ID" colrender="columnRenderer" resizewidth="resizeWidth"  resizeheight="resizeHeight" >
		<tr>
			<th style="width:5%"><input type="checkbox" /></th>
			<th bindName="OTHER_POST_NAME" style="width:25%" sort="true" renderStyle="text-align: left" >��λ����</th>
			<th bindName="OTHER_POST_CODE" style="width:25%" sort="true" renderStyle="text-align: left" >��λ����</th>
			<th bindName="ORG_NAME" style="width:30%" sort="true" renderStyle="text-align: left" >��������ȫ·��</th>
			<th bindName="OTHER_POST_FLAG" style="width:20%" sort="true" renderStyle="text-align: left" >�Ƿ��Ǳ�׼��λ</th>
		</tr>
	</table>
	
<script language="javascript">
	var roleId = "<c:out value='${param.roleId}'/>"; 
	var dataList = null; 
	window.onload = function() {
		comtop.UI.scan();
	}
	
	var query = {};
	// ���ڶ���
	var dialog;
	
	//����grid��� 
	function resizeWidth() {
		return (document.documentElement.clientWidth || document.body.clientWidth) - 21;
	}

	//����grid�߶�
	function resizeHeight(){
		return (document.documentElement.clientHeight || document.body.clientHeight) - 70;
	}
	//չʾҳ������
	function dataProvider(tableObj,query){
		//��ȡ�����ֶ���Ϣ
		var sortFieldName = query.sortName[0];
	    var sortType = query.sortType[0];
		var condition = {pageNo:query.pageNo,pageSize:query.pageSize,
				classifyName:sortFieldName,
				sortType:sortType};
		var fastQueryValue = cui("#speedScan").getValue().replace(new RegExp("%", "gm"), "/%");
		fastQueryValue = fastQueryValue.replace(new RegExp("_", "gm"), "/_");
		fastQueryValue = fastQueryValue.replace(new RegExp("'","gm"), "''");
		fastQueryValue = fastQueryValue.replace(new RegExp("/","gm"), "//");
		if(fastQueryValue != '') {
			condition.fastQueryValue = fastQueryValue;
		}
		condition.roleId = roleId;
		dwr.TOPEngine.setAsync(false);
		RoleAction.queryOtherPostListByRoleId(condition, function(data){
			dataList = data.list;
	    	tableObj.setDatasource(data.list, data.count);
		}); 
		dwr.TOPEngine.setAsync(true); 
	}

	/**
	*����Ⱦ
	**/
	function columnRenderer(data,field) {
		if(field == 'OTHER_POST_FLAG'){
			if(data['OTHER_POST_FLAG']==2){
				return '��';
			}else if(data['OTHER_POST_FLAG']==1){
				return '��';
			}
		}
	}

	/**
	**�ص�����
	**/
	function addCallBack(selectedKey){
		cui("#speedScan").setValue("");
		cui("#grid").setQuery({pageNo:1,sortType:[],sortName:[]});
		cui("#grid").loadData();
		cui("#grid").selectRowsByPK(selectedKey);
	}
	 
	function keyWordQuery(){
		var fastQueryValue = cui('#speedScan').getValue(); 
		var tableObj = cui('#grid');
		tableObj.setQuery({pageNo:1});
		tableObj.loadData();
	}
	
	//���̻س������ٲ�ѯ 
	function keyDownQuery() {
		if ( event.keyCode ==13) {
			keyWordQuery();
		}
	} 
</script>
</body>
</html>
