
<%
    /**********************************************************************
	 * ��ϵ���б�
	 * 2014-07-15 л��  �½�
	 **********************************************************************/
%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<%@ page import="com.comtop.top.sys.accesscontrol.gradeadmin.GradeAdminConstants" %>
<%@page import="com.comtop.top.sys.usermanagement.user.model.UserDTO"%>
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
 <%		
	UserDTO objUserInfo = (UserDTO)pageContext.getAttribute("userInfo");
	boolean isAdminManager = GradeAdminConstants.isManagerByUserId(objUserInfo.getUserId());
	%>
<head>
<title>��ϵ���б�</title>
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/ContactPersonAction.js"></script>
<link rel="shortcut icon" href="${pageScope.cuiWebRoot}/top/workbench/base/img/logo.ico">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/base/css/base.css?v=<%=version%>"/>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/component/requirejs/require.js?v=<%=version%>"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/component/requirejs/require.config.js?v=<%=version%>"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/base/js/base.js?v=<%=version%>"></script>
</head>

<body style="background-color: #ffffff">
<c:if test="${param.isShowHeader == 1}">
<%@ include file="/top/workbench/base/MainNav.jsp"%>
</c:if>
	<div  uitype="bpanel"  position="center" id="centerMain"  style="margin-left: 10px;"    height="400">
<div class="list_header_wrap" style="margin-right: 12px">
	 <div class="thw_title">��ϵ���б�</div>
		<div  id ="top_float_right" class="top_float_right" style="DISPLAY: none" >
		<% if(isAdminManager){%>
			<span uitype="button" id="button_add" label="������ϵ��" on_click="Add"></span>
			<span uitype="button" label="ɾ����ϵ��" id="button_del" on_click="del"></span>
		<%} %>
		</div>
	</div>
	<div id="grid_wrap">
	<table id="grid" uitype="grid" pagesize_list="[10,20,30]" datasource="initData"
	 primarykey=contactId colrender="columnRenderer" resizewidth="resizeWidth"  resizeheight="resizeHeight" >
		<tr>
			<th style="width:5%"><input type="checkbox" /></th>
			<th bindName="contactContent" style="width:75%"  renderStyle="text-align: left" >��ϵ����Ϣ</th>
			<th bindName="updateTime" style="width:25%" sort="true" renderStyle="text-align: center" sort ="true" >����ʱ��</th>
			
		</tr>
	</table>
	</div>
</div>
	
<script language="javascript">

	//���ڶ���
	var dialog;
	var isAdminManager = <%=isAdminManager%>;
    var isShowHeader = "<c:out value='${param.isShowHeader}'/>";
	window.onload = function(){
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
		var url = '${pageScope.cuiWebRoot}/top/sys/tools/contactperson/ContactPersonEdit.jsp';
		var title = "������ϵ��";
		var height = 350; //300
		var width = 700; // 560;
	//	var height = (document.documentElement.clientHeight || document.body.clientHeight)-300; //300
		//var width = (document.documentElement.clientWidth || document.body.clientWidth)-350; // 560;
		if(!dialog)
		dialog = cui.dialog({
			title: title,
			src:url,
			width:width,
			height:height
		});
		dialog.setTitle(title);
		dialog.show(url); 
		
		
		}
	
		//�༭��ϵ��
		function edit(contactId){
			var grid = cui('#grid').getValue(); 
			if (isAdminManager) {
			var url = '${pageScope.cuiWebRoot}/top/sys/tools/contactperson/ContactPersonEdit.jsp?contactId='+contactId;
			var title = "�༭��ϵ��";
			}else{
				var url = '${pageScope.cuiWebRoot}/top/sys/tools/contactperson/ContactPersonEdit.jsp?contactId='+contactId;
				var title = "������ϵ��";
			}
			var height = 350; //300
			var width = 700; // 560;
			//var height = (document.documentElement.clientHeight || document.body.clientHeight)-300; //300
			//var width = (document.documentElement.clientWidth || document.body.clientWidth)-250; // 560;
			if(!dialog)
			dialog = cui.dialog({
				title: title,
				src:url,
				width:width,
				height:height
				});
			dialog.setTitle(title);
			dialog.show(url); 
		
		}
		
		
		
		//��Ⱦҳ������
		function initData(tableObj,query){
			if (isAdminManager) {			
				document.getElementById("top_float_right").style.display="";
			}
			var sortFieldName = query.sortName[0];
		    var sortType = query.sortType[0];
			var condition = {pageNo:query.pageNo,pageSize:query.pageSize,
					sortFieldName:sortFieldName,
					sortType:sortType};
			  ContactPersonAction.queryContactPersonList(condition,function(data){
				var totalSize = data.count;
				var dataList = data.list;
				tableObj.setDatasource(dataList,totalSize);
			});
		}
		
	
	/**
	* ����Ⱦ
	**/
	function columnRenderer(initData,field) {
		if(field === 'contactContent'){
			var contactContent = initData["contactContent"];
			return "<a class='a_link' href='#' onclick='edit(\""+initData["contactId"]+"\");'>"+contactContent+"</a>";
		}else if(field === 'updateTime'){
			var StrUpdateTime = initData["updateTime"];
			StrUpdateTime = StrUpdateTime.substring(0,StrUpdateTime.length - 5);
			return StrUpdateTime;
		}
		
	}
	
	//grid���
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 22;
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
/* 	function addCallBack(selectedKey){
		cui("#grid").setQuery({pageNo:1,sortType:[],sortName:[]});
		cui("#grid").loadData();
		cui("#grid").selectRowsByPK(selectedKey);
	} */


	function addCallBack(){
		cui("#grid").loadData();
		
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
		           // dwr.TOPEngine.setAsync(false);   
		            ContactPersonAction.deleteContactPerson(selectData, function(data){
                    	if(data == 1){
	                        var cuiTable = cui("#grid");
	                        cuiTable.removeData(cuiTable.getSelectedIndex());
	                        cui.message("ɾ����ϵ�˳ɹ�", "success");
	                        cui("#grid").loadData();
                    	}
                    });
		           // dwr.TOPEngine.setAsync(true);
		        }
		    });
		}
	}
	
	
</script>
</body>
</html>
