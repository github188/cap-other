
<%
    /**********************************************************************
	 * �ּ�����Ա�����λ
	 * 2014-07-15 л��  �½�
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
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/AssignManageAuthorityAction.js"></script>


</head>

<body>
	<div class="list_header_wrap">
		<div class="top_float_left">
			<span uitype="ClickInput" editable="true" id="speedScan" name="keyword" emptytext="�������λ���ƹؼ��ֲ�ѯ" 
				width="200" maxlength="500" icon="search" on_keydown="keyDownQuery" on_iconclick="keyWordQuery" ></span><br/>
		</div>
		<div class="top_float_right">
			<span uitype="button" id="button_saveall" label="�������и�λ" on_click="doSaveAll"></span>
			<span uitype="button" id="button_add" label="����" on_click="doAdd"></span>
		</div>
	</div>
	<div id="doSaveAllBtn" style="display: none;text-align: left; margin-top:30px;margin-left:5px;line-height: 20px;"></div>
	<table id="grid" uitype="grid" pagesize_list="[10,20,30]" datasource="dataProvider" primarykey="POST_ID" colrender="columnRenderer" resizewidth="resizeWidth"  resizeheight="resizeHeight" >
		<tr>
			<th style="width:5%"><input type="checkbox" /></th>
			<th bindName="POST_NAME" style="width:25%" sort="true" renderStyle="text-align: left" sort="true">��λ����</th>
			<th bindName="ORG_NAME" style="width:25%" sort="true" renderStyle="text-align: left" sort="true">������֯</th>
			<th bindName="POST_CODE" style="width:25%" sort="true" renderStyle="text-align: left" sort="true">��λ����</th>
			<th bindName="POST_CLASSIFY" style="width:20%" sort="true" renderStyle="text-align: left" sort="true">��λ���</th>
		</tr>
	</table>
	
<script language="javascript">
	var adminId = "<c:out value='${param.adminId}'/>";
	var orgId = "<c:out value='${param.orgId}'/>";
	var associateType = "<c:out value='${param.associateType}'/>";
	var orgName = "<c:out value='${param.orgName}'/>";
	var dataList = null;
	var oldResourceId_arr = [];
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
				sortName:sortFieldName,
				sortType:sortType};
		var fastQueryValue = cui("#speedScan").getValue().replace(new RegExp("%", "gm"), "/%");
		fastQueryValue = fastQueryValue.replace(new RegExp("_", "gm"), "/_");
		fastQueryValue = fastQueryValue.replace(new RegExp("'","gm"), "''");
		fastQueryValue = fastQueryValue.replace(new RegExp("/","gm"), "//");
		if(fastQueryValue != '') {
			condition.fastQueryValue = fastQueryValue;
		}
		condition.adminId = adminId;
		condition.creatorId = globalUserId;
		condition.orgId = orgId;
		condition.isCascade = associateType
		dwr.TOPEngine.setAsync(false);
		if(globalUserId=='SuperAdmin'){
			//����
			AssignManageAuthorityAction.querySuperAssignPostList(condition,function(data){
				dataList = data.list;
		    	tableObj.setDatasource(data.list, data.count);
			});
		}else{
			AssignManageAuthorityAction.queryAssignPostList(condition,function(data){
				dataList = data.list;
		    	tableObj.setDatasource(data.list, data.count);
			});
		}
		dwr.TOPEngine.setAsync(true);
		//ѡ��
		oldResourceId_arr = [];
		for(var index in dataList){
			if(dataList[index].ISSELECTED==2){
				oldResourceId_arr.push(dataList[index].POST_ID);
				tableObj.selectRowsByPK(dataList[index].POST_ID);
			}
		}
	}

	/**
	*����Ⱦ
	**/
	function columnRenderer(data,field) {
		if(field == 'POST_CLASSIFY'){
			if(data['POST_CLASSIFY']==1){
				return '������';
			}else if(data['POST_CLASSIFY']==2){
				return '������';
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
	
	//������Ա����ָ�����������и�λ��ά��Ȩ��
	function doSaveAll(){
		var msg = "�Ƿ���Ҫ�����š�"+orgName+"���µ����и�λ�����ָ������Ա��";
		if(associateType == 1){
			msg = "�Ƿ���Ҫ�����š�"+orgName+"�������¼������µ����и�λ�����ָ������Ա��";
		}
		$('#doSaveAllBtn').html(msg);
		cui('#doSaveAllBtn').dialog({
			title:"��λ����",
			 buttons : [
                {
                    name : '&nbsp;&nbsp;��&nbsp;&nbsp;',
                    handler : function() {
                    	var condition = {};
                    	condition.adminId = adminId;
                		condition.orgId = orgId;
                		condition.isCascade = associateType;
                		condition.creatorId = globalUserId;
                		dwr.TOPEngine.setAsync(true);
                		AssignManageAuthorityAction.assignAllPost(condition, function(){
                			cui.message('��λ��Ȩ�ɹ���','success');
                			cui('#doSaveAllBtn').hide();
            				setTimeout('cui("#grid").loadData()',500);
                		});
                		dwr.TOPEngine.setAsync(true);
                    }
                }, {
                    name : '&nbsp;&nbsp;��&nbsp;&nbsp;',
                    handler : function() {this.hide();}
                }
            ]
		}).show(); 
	}

	function doAdd(){
		// isCascade orgId  resourceList
		if(!adminId){
			return;
		}
		var selected = [];
		selected = cui("#grid").getSelectedPrimaryKey();
		dwr.TOPEngine.setAsync(true);
		var condition = {};
		condition.adminId = adminId;
		condition.orgId = orgId;
		condition.isCascade = associateType;
		condition.creatorId = globalUserId;
		//ѭ����������ѡ�е��б�����
		var post_arr = [];
		if(selected!=null && selected.length>0){
			for(var i=0; i<selected.length; i++) {
				if(selected[i]){
					var post_obj = {};
					post_obj.subjectId= adminId;
					post_obj.resourceId= selected[i];
					post_obj.creatorId = globalUserId;
					post_arr.push(post_obj);
				}
			}
		}
		condition.resourceList = post_arr;
		condition.oldResourceIdList = oldResourceId_arr;
		dwr.TOPEngine.setAsync(false);
		AssignManageAuthorityAction.assignPost(condition,function(result) {
			if("success"==result){
				cui.message('��λ��Ȩ�ɹ���','success');
				setTimeout('cui("#grid").loadData()',500);
			}
		});
		dwr.TOPEngine.setAsync(true);
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
