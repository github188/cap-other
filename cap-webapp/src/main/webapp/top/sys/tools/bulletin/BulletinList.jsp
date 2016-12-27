<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ page import="com.comtop.top.sys.accesscontrol.gradeadmin.GradeAdminConstants" %>
<%@page import="com.comtop.top.sys.usermanagement.user.model.UserDTO"%>
<html>
 <%		
	UserDTO objUserInfo = (UserDTO)pageContext.getAttribute("userInfo");
	boolean isAdminManager = GradeAdminConstants.isManagerByUserId(objUserInfo.getUserId());
%>
<head>
    <title>电子公告列表</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/message/css/message.css"/>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
    <%@ include file="/top/workbench/base/Header.jsp"%>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/BulletinAction.js"></script>
</head>
<body style="background-color: #ffffff">
<c:if test="${param.isShowHeader == 1}">
	<%@ include file="/top/workbench/base/MainNav.jsp"%>
</c:if>
 <div  uitype="bpanel"  position="center" id="centerMain" style="margin-left: 10px;" height="400">
<div class="list_header_wrap" style="margin-right: 12px">
 <div class="thw_title">电子公告列表</div>
	<div id ="top_float_right" class="top_float_right" style="visibility:hidden" >
	<% if(isAdminManager){%>
		<span uitype="button" label="发布" id="button_add"  on_click="add" visibility="visible"></span>
		<span uitype="button" label="删除" id="button_del"  on_click="deleteBulletin"></span>
	<%} %>
	</div>
</div>
<div id="grid_wrap">
<table id="grid" uitype="grid" datasource="initData" primarykey="bulletinId" colrender="columnRenderer" resizewidth="resizeWidth"  resizeheight="resizeHeight" >
	<tr>
		<th style="width:5%"><input type="checkbox" /></th>
		<th bindName="title" style="width:55%;" sort="true" renderStyle="text-align: left" >公告标题</th>
		<th bindName="urgent" style="width:15%;" sort="true" renderStyle="text-align: center">紧急程度</th>
		<th bindName="updateTime" style="width:25%;" renderStyle="text-align: center" >更新时间</th>
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
	function add(){
		var url = '${pageScope.cuiWebRoot}/top/sys/tools/bulletin/BulletinEdit.jsp';
		var title = "电子公告新增";
		var height = 400; //300
		var width = 700; // 560;
		dialog = cui.dialog({
			title: title,
			src:url,
			width:width,
			height:height
		});
		dialog.show(); 
	}
	
	
	function addCallBack(){
		cui("#grid").loadData();
	}

	
	
	function edit(bulletinId){
		
		if (isAdminManager) {
		var url = '${pageScope.cuiWebRoot}/top/sys/tools/bulletin/BulletinEdit.jsp?bulletinId='+bulletinId;
		var title = "电子公告编辑";
		}else
		{var url = '${pageScope.cuiWebRoot}/top/sys/tools/bulletin/BulletinView.jsp?bulletinId='+bulletinId;
		var title = "电子公告查看";
		}
		var height = 400; //300
		var width = 700; // 560;
		dialog = cui.dialog({
			title: title,
			src:url,
			width:width,
			height:height
		});
		dialog.show(); 
		
		
	}
	
	//渲染列表数据
	function initData(tableObj,query){
		
		if (isAdminManager) {
			document.all.top_float_right.style.visibility="";
		}
		var sortFieldName = query.sortName[0];
	    var sortType = query.sortType[0];
		var condition = {pageNo:query.pageNo,pageSize:query.pageSize,
				sortFieldName:sortFieldName,
				sortType:sortType};
		BulletinAction.queryBulletinList(condition,function(data){
			var totalSize = data.count;
			var dataList = data.list;
			tableObj.setDatasource(dataList,totalSize);
			
		}); 
	}
	
	/**
	* 列渲染
	**/
	function columnRenderer(data,field) {
		if(field === 'title'){
			return "<a class='a_link' href='javascript:edit(\""+data["bulletinId"]+"\");'>"+data["title"]+"</a>";
		}else if(field === 'updateTime'){
			var StrUpdateTime = data["updateTime"];
			StrUpdateTime = StrUpdateTime.substring(0,StrUpdateTime.length - 5);
			return StrUpdateTime;
		}
		
		if(field==='urgent'){
			var urgent=data['urgent'];
			if(urgent==0){
				return "一般";
			}
			if(urgent==1){
				return "紧急";
			}
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
	
	
	//新增公告
	function addBulletion(bulletinId){
		 window.location.href = "<top:webRoot/>/top/sys/tools/bulletin/BulletinEdit.jsp";
		
	}
	
	/**
	**回调函数
	**/
	function addCallBack(selectedKey){
		cui("#grid").loadData();
	}
	

	//删除公告
	function deleteBulletin(){

		var selectData = cui("#grid").getSelectedPrimaryKey();
		if (selectData.length == 0) {
		    cui.alert("请选择要删除的公告");
		} else {
		    var msg = "确定要删除选中的公告吗？";
		    cui.confirm(msg, {
		        onYes: function () {
		            dwr.TOPEngine.setAsync(false);	    
		            BulletinAction.deleteBulletin(selectData, function(data){
                    	if(data == 1){
	                       var cuiTable = cui("#grid");
	                       cuiTable.removeData(cuiTable.getSelectedIndex());
	                       cui.message("删除数据成功", "success");
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