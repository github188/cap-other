
<%
    /**********************************************************************
	 * �ּ�����Ա�б�
	 * 2014-07-08 л��  �½�
	 **********************************************************************/
%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ include file="/top/component/common/AccessTaglibs.jsp" %>
<%@ page contentType="text/html; charset=GBK" %>
<html>
<head>
<title>�ּ�����Ա�б�</title>

<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/GradeAdminAction.js"></script>
</head>
<style type="text/css">
th {
	font-weight: bold;
	font-size: 14px;
}
</style>

<body>
	<div class="list_header_wrap" style="padding-bottom:10px;padding-left:10px;padding-right:12px;">
		<div class="top_float_left">
			<span uitype="ClickInput" editable="true" id="speedScan" name="keyword" emptytext="���������Ա���ƹؼ��ֲ�ѯ" 
				width="200" maxlength="500" icon="search" on_keydown="keyDownQuery" on_iconclick="keyWordQuery" ></span><br/>
		</div>
		
		<div class="top_float_right">
			<span uitype="button" id="button_add" label="��������Ա" on_click="add"></span>
			<span uitype="button" id="button_del" label="ɾ������Ա" on_click="deleteGradeAdmin"></span>
		</div>
	</div>
	<div id="gridWrap" style="padding:0 15px 0 10px">
	<table id="grid" uitype="grid" pagesize_list="[10,20,30]" datasource="dataProvider" primarykey="adminId" colrender="columnRenderer" resizewidth="resizeWidth"  resizeheight="resizeHeight" >
		<tr>
			<th style="width:30px"><input type="checkbox" /></th>
			<th bindName="adminName" style="width:15%"  renderStyle="text-align: left">����Ա����</th> 
			<th bindName="deptName" style="width:25%"   renderStyle="text-align: left">��Ͻ����</th>
			<th bindName="userName" style="width:30%"   renderStyle="text-align: left">��Ա</th>
			<th bindName="operation" style="width:10%"  renderStyle="text-align: center">Ȩ������</th>
		</tr>
	</table>
	</div>
	
<script language="javascript">

	window.onload = function() {
		comtop.UI.scan();
		$('#gridWrap').height(function(){
			return (document.documentElement.clientHeight || document.body.clientHeight) - 60;		
		});
	}
	var query = {};
	// ���ڶ���
	var dialog;
	
	//����grid��� 
	function resizeWidth() {
		return (document.documentElement.clientWidth || document.body.clientWidth) - 42;
	}

	//����grid�߶�
	function resizeHeight(){
		return (document.documentElement.clientHeight || document.body.clientHeight) - 68;
	}
	//չʾҳ������
	function dataProvider(tableObj,query){
		//��ȡ�����ֶ���Ϣ
		var sortFieldName = query.sortName[0];
	    var sortType = query.sortType[0];
		var condition = {pageNo:query.pageNo,pageSize:query.pageSize,
				sortFieldName:sortFieldName,
				sortType:sortType};
		var fastQueryValue = cui("#speedScan").getValue().replace(new RegExp("%", "gm"), "/%");
		fastQueryValue = fastQueryValue.replace(new RegExp("_", "gm"), "/_");
		fastQueryValue = fastQueryValue.replace(new RegExp("'","gm"), "''");
		fastQueryValue = fastQueryValue.replace(new RegExp("/","gm"), "//");
		if(fastQueryValue != '') {
			condition.fastQueryValue = fastQueryValue;
		}
		if('SuperAdmin'!=globalUserId){
			condition.creatorId = globalUserId;
		}
		dwr.TOPEngine.setAsync(false);
		GradeAdminAction.queryGradeAdminList(condition,function(data){
	    	tableObj.setDatasource(data.list, data.count);
		});
		dwr.TOPEngine.setAsync(true);
	}

	/**
	*����Ⱦ
	**/
	function columnRenderer(data,field) {
		if(field === 'adminName'){
			var adminName = data["adminName"];
			return "<a class='a_link' href='javascript:edit(\""+data["adminId"]+"\");'>"+adminName+"</a>";
		}
		if(field === 'operation'){
			return "<img src='${pageScope.cuiWebRoot}/top/sys/images/setting.png' style='cursor:pointer' onclick='openAssignAuthority(\""+data["adminId"]+"\",\""+data["orgId"]+"\");' title='����Ȩ������'/>";
		}
	}
	
	/**
	* �����༭����.
	**/
	function edit(adminId){
		var url = "${pageScope.cuiWebRoot}/top/sys/accesscontrol/gradeadmin/GradeAdminEdit.jsp?adminId=" + adminId;
		var title = "";
		var height = 300; 
		var width =  650;  
		if(!dialog){
			dialog = cui.dialog({
				title: title,
				src:url,
				width:width,
				height:height
			});
		}else{
			dialog.setSize({width:width, height:height});
			dialog.setTitle(title);
			dialog.reload(url);
		}
		dialog.show();
	}
	
	/**
	* ������������.
	**/
	function add(){
		var url = '${pageScope.cuiWebRoot}/top/sys/accesscontrol/gradeadmin/GradeAdminEdit.jsp';
		var title = "";
		var height = 300; 
		var width =  650; 
		if(!dialog){
			dialog = cui.dialog({
				title: title,
				src:url,
				width:width,
				height:height
			});
		}else{
			dialog.setSize({width:width, height:height});
			dialog.setTitle(title);
			dialog.reload(url);
		}
		dialog.show();
	}

	/**
	* ��������Ȩ�޷��䴰��.
	**/
	function openAssignAuthority(adminId,orgId){
		var url = '${pageScope.cuiWebRoot}/top/sys/accesscontrol/gradeadmin/AssignMain.jsp?adminId='+adminId+"&orgId="+orgId;
		var title = "����Ȩ�޷���";
		var height = (document.documentElement.clientHeight || document.body.clientHeight)-100; //300
		var width = (document.documentElement.clientWidth || document.body.clientWidth)-50; // 560;
		if(!dialog){
			dialog = cui.dialog({
				title: title,
				src:url,
				width:width,
				height:height
			});
		}else{
			dialog.setSize({width:width, height:height});
			dialog.setTitle(title);
			dialog.reload(url);
		}
		dialog.show(); 
	}

	/**
	**ɾ��ҳ��
	**/
	function deleteGradeAdmin(){
		var selectPageIds = [];
		selectPageIds = cui("#grid").getSelectedPrimaryKey();
		if(selectPageIds != null && selectPageIds.length>0){
			dwr.TOPEngine.setAsync(false);
			cui.confirm('ȷ���Ƿ�ɾ����',{
		        onYes:function () {
		         	GradeAdminAction.deleteGradeAdmins(selectPageIds,function(result){
		         		if(result=='success'){
		         			 cui("#grid").removeData(cui("#grid").getSelectedIndex());
			    			 cui.message('����Աɾ���ɹ���','success');
			    			 cui("#grid").loadData();
			    		 }
		    	 	});
		        }
		    });
			dwr.TOPEngine.setAsync(true);
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

	/**
	**���ٲ�ѯ, ��վ�ȷ��ѯ����
	**/
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
