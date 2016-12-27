
<%
    /**********************************************************************
	 * 联系人列表
	 * 2014-07-15 谢阳  新建
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
<%//360浏览器指定webkit内核打开%>
<meta name="renderer" content="webkit">
<%//关闭ie兼容模式,使用最高版本文档模式渲染页面%>
<meta http-equiv="x-ua-compatible" content="IE=edge" >
<html>
 <%		
	UserDTO objUserInfo = (UserDTO)pageContext.getAttribute("userInfo");
	boolean isAdminManager = GradeAdminConstants.isManagerByUserId(objUserInfo.getUserId());
	%>
<head>
<title>联系人列表</title>
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
	 <div class="thw_title">联系人列表</div>
		<div  id ="top_float_right" class="top_float_right" style="DISPLAY: none" >
		<% if(isAdminManager){%>
			<span uitype="button" id="button_add" label="新增联系人" on_click="Add"></span>
			<span uitype="button" label="删除联系人" id="button_del" on_click="del"></span>
		<%} %>
		</div>
	</div>
	<div id="grid_wrap">
	<table id="grid" uitype="grid" pagesize_list="[10,20,30]" datasource="initData"
	 primarykey=contactId colrender="columnRenderer" resizewidth="resizeWidth"  resizeheight="resizeHeight" >
		<tr>
			<th style="width:5%"><input type="checkbox" /></th>
			<th bindName="contactContent" style="width:75%"  renderStyle="text-align: left" >联系人信息</th>
			<th bindName="updateTime" style="width:25%" sort="true" renderStyle="text-align: center" sort ="true" >更新时间</th>
			
		</tr>
	</table>
	</div>
</div>
	
<script language="javascript">

	//窗口对象
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
	* 弹出窗口.
	**/
	function Add(){
		var url = '${pageScope.cuiWebRoot}/top/sys/tools/contactperson/ContactPersonEdit.jsp';
		var title = "新增联系人";
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
	
		//编辑联系人
		function edit(contactId){
			var grid = cui('#grid').getValue(); 
			if (isAdminManager) {
			var url = '${pageScope.cuiWebRoot}/top/sys/tools/contactperson/ContactPersonEdit.jsp?contactId='+contactId;
			var title = "编辑联系人";
			}else{
				var url = '${pageScope.cuiWebRoot}/top/sys/tools/contactperson/ContactPersonEdit.jsp?contactId='+contactId;
				var title = "新增联系人";
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
		
		
		
		//渲染页面数据
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
	* 列渲染
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
	
	//grid宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 22;
	} 
	
	//grid高度
	function resizeHeight(){
		if(isShowHeader == '1'){
			return (document.documentElement.clientHeight || document.body.clientHeight) - 100;
		}
		return (document.documentElement.clientHeight || document.body.clientHeight) - 45;
	} 
	
	
	/**
	**回调函数
	**/
/* 	function addCallBack(selectedKey){
		cui("#grid").setQuery({pageNo:1,sortType:[],sortName:[]});
		cui("#grid").loadData();
		cui("#grid").selectRowsByPK(selectedKey);
	} */


	function addCallBack(){
		cui("#grid").loadData();
		
	}

	
 
	//删除公告
	function del(){
		var selectData = cui("#grid").getSelectedPrimaryKey();
		if (selectData.length == 0) {
		    cui.alert("请选择要删除的联系人");
		} else {
		    var msg = "确定要删除选中的联系人吗？";
		    cui.confirm(msg, {
		        onYes: function () {
		           // dwr.TOPEngine.setAsync(false);   
		            ContactPersonAction.deleteContactPerson(selectData, function(data){
                    	if(data == 1){
	                        var cuiTable = cui("#grid");
	                        cuiTable.removeData(cuiTable.getSelectedIndex());
	                        cui.message("删除联系人成功", "success");
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
