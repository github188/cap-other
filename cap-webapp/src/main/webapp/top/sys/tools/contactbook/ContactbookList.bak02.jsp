<%
    /**********************************************************************
	 * 分级管理员列表
	 * 2014-07-08 谢阳  新建
	 **********************************************************************/
%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ page contentType="text/html; charset=GBK" %>
<%@ page import="com.comtop.top.sys.accesscontrol.gradeadmin.GradeAdminConstants" %>
<%@page import="com.comtop.top.sys.usermanagement.user.model.UserDTO"%>
<html>
 <%		
	UserDTO objUserInfo = (UserDTO)pageContext.getAttribute("userInfo");
	boolean isAdminManager = GradeAdminConstants.isManagerByUserId(objUserInfo.getUserId());
	%>
<head>
<title>通讯录管理</title>
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/ContactbookAction.js"></script>
</head>

<body>
	<div class="list_header_wrap">
				
		<div class="top_float_right">
			<span uitype="button" id="button_add" label="新增通讯录" on_click="Add"></span>
			<span uitype="button" label="删除通讯录" id="button_del" on_click="del"></span>
		</div>
	</div>
	<table id="grid" uitype="grid" pagesize_list="[10,20,30]" datasource="initData" primarykey="contactId" colrender="columnRenderer" resizewidth="resizeWidth"  resizeheight="resizeHeight" >
			<tr>
				<th style="width:5%"><input type="checkbox" /></th>
				<th bindName="contacter" renderStyle="text-align: center" sort="true">联系人</th>
				<th bindName="tel"  renderStyle="text-align: center">联系电话</th>
				<th bindName="remark"  style="width:45%" sort="true" renderStyle="text-align: center">备注</th>
			</tr>
	</table>
	
<script language="javascript">

//窗口对象
var dialog;
var isAdminManager = <%=isAdminManager%>;
	window.onload = function() {
		comtop.UI.scan();
	}
	
	/**
	* 弹出窗口.
	**/
	function Add(){
		var url = '${pageScope.cuiWebRoot}/top/sys/tools/contactbook/EditContactbook.jsp';
		var title = "新增通讯录";
		var height = (document.documentElement.clientHeight || document.body.clientHeight)-300; //300
		var width = (document.documentElement.clientWidth || document.body.clientWidth)-200; // 560;
		if(!dialog)
		dialog = cui.dialog({
			title: title,
			src:url,
			width:width,
			height:height
		});
		dialog.setTitle(title);
		dialog.show(url);  	
	
	//编辑联系人
	function edit(contactId){
		
		var grid = cui('#grid').getValue(); 
		var url = '${pageScope.cuiWebRoot}/top/sys/tools/contactbook/EditContactbook.jsp?contactId='+contactId;
		var title = "编辑通讯录";
		var height = (document.documentElement.clientHeight || document.body.clientHeight)-300; //300
		var width = (document.documentElement.clientWidth || document.body.clientWidth)-200; // 560;
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
		
		tableObj.setDatasource([{},{}],10);
		
		return;
		
		if (isAdminManager) {
			document.getElementById("top_float_right").style.display="";
		}
		var sortFieldName = query.sortName[0];
	    var sortType = query.sortType[0];
	    var condition = {pageNo:query.pageNo,pageSize:query.pageSize,
				sortFieldName:sortFieldName,
				sortType:sortType};
	    
		ContactbookAction.queryContactBookList(condition,function(data){
			var totalSize = data.count;
			var dataList = data.list;
			tableObj.setDatasource(dataList,totalSize);
		});
	}
	


	/**
	* 列渲染
	**/
	function columnRenderer(initData,field) {
		if(field === 'contacter'){
			var contacter = initData["contacter"];
			var tel =initData["tel"];
			var remark =initData["remark"];
			return "<a class='a_link' href='javascript:edit(\""+initData["contactId"]+"\");'>"+contacter+"</a>";
		}
		
	}
	
	//grid宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 24;
	} 
	
	//grid高度
	function resizeHeight(){
		
		var h=(document.documentElement.clientHeight || document.body.clientHeight) - 100;		
		
		return h;
	} 
	

	/**
	**回调函数
	**/
	function addCallBack(selectedKey){
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
		            dwr.TOPEngine.setAsync(false);   
		          
		            ContactbookAction.deleteContactBook(selectData, function(data){
		            
                    	if(data == 1){            	
	                        var cuiTable = cui("#grid");
	                        cuiTable.removeData(cuiTable.getSelectedIndex());
	                        cui.message("删除联系人成功", "success");
	                        cui("#grid").loadData();
                    	}
                    });
		            dwr.TOPEngine.setAsync(true);
		        }
		    });
		}
	}
	
	

	

	/**
	**回调函数
	**/
	function addCallBack(selectedKey){
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
		            dwr.TOPEngine.setAsync(false);   
		          
		            ContactbookAction.deleteContactBook(selectData, function(data){
		            
                    	if(data == 1){            	
	                        var cuiTable = cui("#grid");
	                        cuiTable.removeData(cuiTable.getSelectedIndex());
	                        cui.message("删除联系人成功", "success");
	                        cui("#grid").loadData();
                    	}
                    });
		            dwr.TOPEngine.setAsync(true);
		        }
		    });
		}
	
	}}
	

</script>
</body>
</html>
