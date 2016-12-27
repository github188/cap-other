<%
    /**********************************************************************
	 * ��ϵ���б�
	 * 2014-07-15 л��  �½�
	 **********************************************************************/
%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
    String version = formatter.format(new Date());
%>
<%//360�����ָ��webkit�ں˴�%>
<meta name="renderer" content="webkit">
<%//�ر�ie����ģʽ,ʹ����߰汾�ĵ�ģʽ��Ⱦҳ��%>
<meta http-equiv="x-ua-compatible" content="IE=edge" >
<html> 
<head>
<title>ͨѶ¼����</title>
   <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/message/css/message.css"/>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
 <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/ContactbookAction.js"></script>
<link rel="shortcut icon" href="${pageScope.cuiWebRoot}/top/workbench/base/img/logo.ico">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/base/css/base.css?v=<%=version%>"/>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/component/requirejs/require.js?v=<%=version%>"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/component/requirejs/require.config.js?v=<%=version%>"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js?v=<%=version%>"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/base/js/base.js?v=<%=version%>"></script>
 <style type="text/css">
 
 
 .list_header_wrap{
     height:25px;
     margin-right: 12px;
 }
 </style>
</head>

<body style="background-color: #ffffff">
<c:if test="${param.isShowHeader == 1}">
	<%@ include file="/top/workbench/base/MainNav.jsp"%>
</c:if>

<div id="centerMain">
   <div class="list_header_wrap" >
 	 <div class="thw_title">ͨѶ¼�б�</div>
		<div id="top_float_right" class="top_float_right" >
			<span uitype="button" id="button_add" label="����" on_click="Add"></span>
			<span uitype="button" label="ɾ��" id="button_del" on_click="del"></span>
		</div>
	</div>
	<div id="grid_wrap" style="margin: 0 12px">
		<table id="grid" uitype="grid"  pagesize_list="[10,20,30]" datasource="initData" primarykey="contactId" 
		       colrender="columnRenderer" resizewidth="resizeWidth"  resizeheight="resizeHeight" >
		 <thead>
			<tr>
				<th style="width:5%"><input type="checkbox" /></th>
				<th bindName="contacter" renderStyle="text-align: left"  style="width:30%" sort="true">��ϵ��</th>
				<th bindName="tel"  renderStyle="text-align: center"  style="width:30%" >��ϵ�绰</th>
				<th bindName="remark"  style="width:35%" sort="true" renderStyle="text-align: left">��ע</th>
			</tr>
		 </thead>
		</table>
	</div>
</div>	
<script type="text/javascript">


	//���ڶ���
	var dialog; 
    var isShowHeader = "<c:out value='${param.isShowHeader}'/>";
    
	window.onload=function(){		
		require(['cui'],function(){  
			  comtop.UI.scan();		
		}); 
		
		$('#grid_wrap').height(function(){
			if(isShowHeader == '1'){
				return (document.documentElement.clientHeight || document.body.clientHeight) - 100;
			}
			return (document.documentElement.clientHeight || document.body.clientHeight) - 45;		
	});
	}
	/**
	* ��������.
	**/
	function Add(){
		var url = '${pageScope.cuiWebRoot}/top/sys/tools/contactbook/EditContactbook.jsp';
		var title = "����ͨѶ¼";
		var height = 300;  
		var width = 700;  
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
		dialog.show(url);  
	 }
	
		//�༭��ϵ��
		function edit(contactId){
			var grid = cui('#grid').getValue(); 
			var url = '${pageScope.cuiWebRoot}/top/sys/tools/contactbook/EditContactbook.jsp?contactId='+contactId;
			var title = "�༭ͨѶ¼";
			var height = 300;  
			var width = 700;  
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
		
		
		
		//��Ⱦҳ������
		function initData(tableObj,query){ 
			var sortFieldName = query.sortName[0];
		    var sortType = query.sortType[0];
		    var condition = {pageNo:query.pageNo,pageSize:query.pageSize,
					sortFieldName:sortFieldName,
					sortType:sortType};
			dwr.TOPEngine.setAsync(false);
			ContactbookAction.queryContactBookList(condition,function(data){
				var totalSize = data.count;
				var dataList = data.list;
				tableObj.setDatasource(dataList,totalSize);
			});
			dwr.TOPEngine.setAsync(true);
		}
	
	/**
	* ����Ⱦ
	**/
	function columnRenderer(initData,field) {
		if(field === 'contacter'){
			var contacter = initData["contacter"];
			var tel =initData["tel"];
			var remark =initData["remark"];
			return "<a class='a_link' href='javascript:edit(\""+initData["contactId"]+"\");'>"+contacter+"</a>";
		}
	}
	
	//grid���
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 24;
	} 
	
	//grid�߶�
	function resizeHeight(){
		if(isShowHeader == '1'){
			return (document.documentElement.clientHeight || document.body.clientHeight) - 100;
		}
		return (document.documentElement.clientHeight || document.body.clientHeight) - 45;
	} 
	
	/**
	**�ص�����
	**/
	function addCallBack(selectedKey){
		console.log(selectedKey);
		cui("#grid").loadData();
		cui("#grid").selectRowsByPK(selectedKey);
	}

	//ɾ������
	function del(){
		var selectData = cui("#grid").getSelectedPrimaryKey();	
		if (selectData.length == 0) {
		    cui.alert("��ѡ��Ҫɾ������ϵ��");
		} else {
		    var msg = "ȷ��Ҫɾ��ѡ�е���ϵ����";
		    cui.confirm(msg, {
		        onYes: function () {
		            dwr.TOPEngine.setAsync(false);   
		            ContactbookAction.deleteContactBook(selectData, function(data){
                    	if(data == 1){            	
	                        var cuiTable = cui("#grid");
	                        cuiTable.removeData(cuiTable.getSelectedIndex());
	                        cui.message("ɾ����ϵ�˳ɹ�", "success");
	                        cui("#grid").loadData();
                    	}
                    });
		            dwr.TOPEngine.setAsync(true);
		        }
		    });
		}
	}
	
	
</script>
</body>
</html>
