<%
/**********************************************************************
* �û�������־չ��
* 2012-10-30 ����   �½�
**********************************************************************/
%>

<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK"></meta>
	<title>��־����</title>
	<link rel="stylesheet" href="<c:out value='${pageScope.cuiWebRoot}'/>/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="<c:out value='${pageScope.cuiWebRoot}'/>/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	
	<style>
		body{
			margin:0;
		}
	</style>
</head>
<body>
	<div class="list_header_wrap">
		<div class="top_float_left">
			<span uitype="Calender" id="startTimeId1" maxdate="-0d" width="125px"></span>
		</div>
		<div class="top_float_right">
			<span uitype="button" label="��&nbsp;ѯ" on_click="doQuery"></span>
			<span uitype="button" label="��&nbsp;��" on_click="doExport"></span>
		</div>
	</div>
 	<table  uitype="grid" id="userOnlineGrid" primarykey="strGridId" datasource="initData" selectrows="no" pagesize_list="[10,20,30]" 
		adaptive="true" resizewidth="resizeWidth" resizeheight="resizeHeight" colrender="columnRenderer"  >
		<tr>
			<th style="width:150px" sort="false" bindName="orgName" rowspan="2">��������</th>
			<th style="width:150px" sort="false" bindName="account" rowspan="2">�û��ʺ�</th>
			<th style="width:150px" sort="false" bindName="userName" rowspan="2">�û���</th>
			<th style="width:150px" sort="false" bindName="operateName" rowspan="2">��������</th>
			<th style="width:200px" sort="false" colspan="2">����ʱ��</th>
			<th style="width:200px" sort="false" colspan="2">�û�����</th>
			<th style="width:200px" sort="false" colspan="2">�û�����</th>
		</tr>
		<tr>
			<th style="width:200px" sort="false" format="yyyy-MM-dd hh:mm:ss" bindName="loginTime">����ʱ��</th>
			<th style="width:200px" sort="false" format="yyyy-MM-dd hh:mm:ss" bindName="exitTime">�˳�ʱ��</th>
			<th style="width:200px" sort="false" bindName="remoteAddr">IP</th>
			<th style="width:200px" sort="false" bindName="remoteHost">����</th>
			<th style="width:200px" sort="false" bindName="envBrowser">�����</th>
			<th style="width:200px" sort="false" bindName="envSystem">����ϵͳ</th>
		</tr>
	</table>
	
<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/component/topui/cui/js/comtop.ui.min.js'></script>
<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/js/jquery.js' ></script>
<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/js/commonUtil.js' ></script>
<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/dwr/engine.js'></script>
<script type="text/javascript" src="<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/dwr/util.js"></script>
<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/dwr/interface/UserOnlineAction.js'></script>

<script language="javascript">
	var queryCondition={};
	$(function(){
		comtop.UI.scan();
	});
	
	//��Ⱦ�б�����
	function initData(grid, query){
		var statisticsTime = cui('#startTimeId1').getValue();
		if(statisticsTime ==''){
			grid.setDatasource(null, 0);
			return;
		}
		queryCondition.statisticsTime = statisticsTime;
		queryCondition.pageNo = query.pageNo;
		queryCondition.pageSize = query.pageSize;
		UserOnlineAction.queryUserAccessList(queryCondition, function(data){
	        var totalSize = data.count;
	        var dataList = data.list; 
	        grid.setDatasource(dataList, totalSize);
	    });
	}
	
	function resizeWidth(){
	    return (document.documentElement.clientWidth || document.body.clientWidth) - 3;
	}

	function resizeHeight(){
	    return (document.documentElement.clientHeight || document.body.clientHeight) - 40;
	}

	/*
	* ִ�в�ѯ
	* param:��ѯ����, ��տ��ٲ�ѯ����
	*/
	function doQuery(){
		var statisticsTime = cui('#startTimeId1').getValue();
		if(statisticsTime ==''){
			cui.alert("��ѡ���ѯ����");
			return;
		}

		queryCondition = {};
		cui("#userOnlineGrid").setQuery({pageNo:1});
		queryCondition.statisticsTime = statisticsTime;
		queryCondition.fastQuery = 'no';
		cui("#userOnlineGrid").loadData();
		//������ٲ�ѯ������
		cui("#speedScan").setValue("");
	}

	/*
	* ִ�в�ѯ
	* param:��ѯ����, ��տ��ٲ�ѯ����
	*/
	function doExport(){
		
        //var url = <c:out value='${pageScope.cuiWebRoot}'/>;
		var statisticsTime = cui('#startTimeId1').getValue();
		if(statisticsTime ==''){
			cui.alert("��ѡ�񵼳�����");
			return;
		}
		cui.handleMask.show();
		queryCondition.statisticsTime = statisticsTime;
		UserOnlineAction.exportUserAccessList(queryCondition, function(data){
			cui.handleMask.hide();
			if(data=="OK"){
	 	        var url = "${pageScope.cuiWebRoot}/top/sys/log/downloadUserAccessList.ac";
	 	        location.href = url;
	        }else{
	        	cui.alert("����ʧ�ܣ�����ϵ����Ա��");
	        }	       
	    });
	}
	
	
	//��ղ�ѯ����
	function clearCondition(){
		cui("#organizationName").setValue('');
		cui("#account").setValue('');
	}
	
	/**
	**���ٲ�ѯ, ��վ�ȷ��ѯ����
	**/
	function keyWordQuery(){
		var keyWord = handleStr(cui("#speedScan").getValue());
		queryCondition = {};
		if(keyWord!="�ؼ�������"){
			queryCondition.fastQueryValue = keyWord;
			queryCondition.fastQuery = "yes";
		}else{
			queryCondition.fastQuery = "no";			
		}
		cui("#userOnlineGrid").loadData();
		clearCondition();
	} 
</script>
</body>
</html>