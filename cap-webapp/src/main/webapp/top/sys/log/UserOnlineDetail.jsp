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
			<span uitype="ClickInput"  id="speedScan" name="speedScan" emptytext="�ؼ�������" 
				width="260px"  enterable="true" icon="<c:out value='${pageScope.cuiWebRoot}'/>/top/cfg/images/querysearch.gif" 
				on_iconclick="keyWordQuery" maxlength="50" editable="true">
			</span>
		</div>
		<div class="top_float_right">
			<span uitype="Input" id="organizationName" name="organizationName" emptytext="��������" width="120"></span>
		    &nbsp;<span uitype="Input" id="account" name="account" emptytext="�û��˺�"  width="120"></span>
			<span uitype="button" label="��&nbsp;ѯ" on_click="doQuery"></span>
		</div>
	</div>
 	<table  uitype="grid" id="userOnlineGrid" primarykey="strGridId" datasource="initData" selectrows="no"
		adaptive="true" resizewidth="resizeWidth" resizeheight="resizeHeight" colrender="columnRenderer" >
		<tr>
			<th style="width:150px" bindName="orgName" rowspan="2">��������</th>
			<th style="width:150px" bindName="account" rowspan="2">�û��ʺ�</th>
			<th style="width:150px" bindName="userName" rowspan="2">�û���</th>
			<th style="width:200px" format="yyyy-MM-dd hh:mm:ss" bindName="loginTime" rowspan="2">����ʱ��</th>
			<th style="width:200px" bindName="onlineHour" rowspan="2">����ʱ��</th>
			<th style="width:200px" colspan="2">�û�����</th>
			<th style="width:200px" colspan="2">�û�����</th>
		</tr>
		<tr>
			<th style="width:200px" bindName="remoteAddr">IP</th>
			<th style="width:200px" bindName="remoteHost">����</th>
			<th style="width:200px" bindName="envBrowser">�����</th>
			<th style="width:200px" bindName="envSystem">����ϵͳ</th>
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
		queryCondition.pageNo = query.pageNo;
		queryCondition.pageSize = query.pageSize;
		UserOnlineAction.queryOnlineUserList(queryCondition, function(data){
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
		queryCondition = {};
		queryCondition.orgName = cui("#organizationName").getValue();
		queryCondition.account = cui("#account").getValue();
		queryCondition.fastQuery = 'no';
		queryCondition.fastQueryValue  = cui('#speedScan').getValue();
		cui("#userOnlineGrid").loadData();
		//������ٲ�ѯ������
		cui("#speedScan").setValue("");
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