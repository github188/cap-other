<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ page import="com.comtop.top.sys.accesscontrol.gradeadmin.GradeAdminConstants" %>
<%@page import="com.comtop.top.sys.usermanagement.user.model.UserDTO"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<html>
 <%		
 	SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
 	String version = formatter.format(new Date());
	UserDTO objUserInfo = (UserDTO)pageContext.getAttribute("userInfo");
	boolean isAdminManager = GradeAdminConstants.isManagerByUserId(objUserInfo.getUserId());
	%>
<head>
	<%//360浏览器指定webkit内核打开%>
	<meta name="renderer" content="webkit">
	<%//关闭ie兼容模式,使用最高版本文档模式渲染页面%>
	<meta http-equiv="x-ua-compatible" content="IE=edge" >
	<meta http-equiv="Content-Type" content="text/html; charset=GBK"/>
   	<title>系统资料及控件管理</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/base/css/base.css?v=<%=version%>"/> 
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js?v=<%=version%>"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/base/js/base.js?v=<%=version%>"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js?v=<%=version%>"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/FileAction.js"></script>
</head>

<body style="background-color: #ffffff">
<div  uitype="bpanel"  position="center" id="centerMain" style="margin-left: 10px;">
<div class="list_header_wrap"  style="margin-right: 12px">
	<div class="top_float_left" >
 		 <span uiType="ClickInput" id="myClickInput" name="clickInput" enterable="true" emptytext="请输入文件名称" editable="true" width="300" on_iconclick="iconclick" 
 			        		icon="search" iconwidth="18px"></span> 
 	</div>
	<div  Id="top_float_right" class="top_float_right" style="DISPLAY: none"  >
	<% if(isAdminManager){%>
		<span uitype="button" label="上传" icon="upload" id="button_add"  on_click="add"></span>
		<span uitype="button"  label="删&nbsp;除" icon="trash-o" id="button_del"  on_click="deletefile"></span>
		<%} %>
	</div>
</div>
<div id="grid_wrap">
<table id="grid" uitype="grid" datasource="initData" primarykey="fileId" colrender="columnRenderer" resizewidth="resizeWidth"  resizeheight="resizeHeight" >
	<tr>
		<th style="width:5%"><input type="checkbox" /></th>
		<th bindName="fileName" style="width:35%;" renderStyle="text-align: left" >文件名称</th>
		<th bindName="fileShortName" style="width:30%;"  renderStyle="text-align: left" >文件描述</th>
		<th bindName="fileSize" style="width:10%;" renderStyle="text-align: left" >文件大小</th>
		<th bindName="createTime" style="width:15%;" format="yyyy年MM月dd日" renderStyle="text-align: center" sort="true">上传时间</th>
		<th name="download"  bindName="download" style="width:5%;"  renderStyle="text-align: center;"  render="setIcon" >下载</th>
	</tr>
</table>
</div>
</div>
<script language="javascript"> 
	//窗口对象
	var dialog;
	var keyword = '';
	var isAdminManager = <%=isAdminManager%>;
    var fileClassifyId = "<c:out value='${param.fileClassifyId}'/>";
	window.onload = function(){
		comtop.UI.scan();		
	}

	//grid宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) -22
	} 
	
	//grid高度
	function resizeHeight(){
		return (document.documentElement.clientHeight || document.body.clientHeight) - 45;
	}
	
	/**
	* 弹出窗口.
	**/
	function add(){
		var url = '${pageScope.cuiWebRoot}/top/sys/tools/file/UploadFile.jsp?fileClassify=' + fileClassifyId;
		var title = "上传文件";
		var height = 260; //300
		var width = 500; // 560;
		dialog = cui.dialog({
			title: title,
			src:url,
			width:width,
			height:height
		});
		dialog.show(); 
	}
	
	function edit(downloadId){
		if (isAdminManager) {
		var url = '${pageScope.cuiWebRoot}/top/sys/tools/file/fileinfo.jsp?downloadId='+downloadId;
		var title = "文件编辑";
		}else
		{var url = '${pageScope.cuiWebRoot}/top/sys/tools/file/UploadFile.jsp?downloadId='+downloadId;
		var title = "文件查看";
		}
		var height = 200; //300
		var width = 500; // 560;
		
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
			document.all.top_float_right.style.display="";
		}
		var sortFieldName = query.sortName[0];
	    var sortType = query.sortType[0];
		var condition = {pageNo:query.pageNo,pageSize:query.pageSize,
				sortFieldName:sortFieldName,
				sortType:sortType};
		if (fileClassifyId && fileClassifyId != '0') {
			condition.fileClassify = fileClassifyId;
		}
		condition.fileName = keyword;
		dwr.TOPEngine.setAsync(false);
		FileAction.queryFileList(condition,function(data){
			var totalSize = data.count;
			var dataList = data.list;
			//console.log(data);
			dataList=initFileSize(dataList);
			tableObj.setDatasource(dataList,totalSize);
			table_obj = tableObj;
		}); 
		dwr.TOPEngine.setAsync(true);
	}

	
	
	/**
	* 列渲染
	**/
	function columnRenderer(data,field) {
	}
	function setIcon(rowdata){
		   return  "<a target='a_blank'  onclick='down(\""+rowdata["fileId"]+"\");' title='下载文件'><img src='images/download.png'/></a>";    
				
	}
	
	function down(fileId){
		var url = "${pageScope.cuiWebRoot}/top/sys/tools/file/downloadFile.ac?downloadId="+fileId;
		window.location=url;
	}
	
	/**
	**回调函数
	**/
	function addCallBack(){
		cui("#grid").loadData();
		
	}
	
	
	
	//删除公告
	function deletefile(){
		var selectData =cui("#grid").getSelectedPrimaryKey();
		if (selectData.length == 0) {
		    cui.alert("请选择要删除的文件");
		} else {
		    var msg = "确定要删除选中的文件吗？";
		    cui.confirm(msg, {
		        onYes: function () {
                    FileAction.deleteFile(selectData, function(data){     	
                    	if(data == 1){
	                        var cuiTable = cui("#grid");
	                        cuiTable.removeData(cuiTable.getSelectedIndex());
	                        cui.message("删除文件成功", "success");
	                        table_obj.loadData();
                    	}
                    });
		        }
		    });
		}
	}
	
	//显示文件大小
	function initFileSize(data){
		if(data==null || data==''){
			return data;
		}
		for(var i=0;i<data.length;i++){
			if(data[i].fileSize/1024>1){
				data[i].fileSize = data[i].fileSize/1024;
				data[i].fileSize=data[i].fileSize.toFixed(2);
				if(data[i].fileSize/1024>1){
					data[i].fileSize = data[i].fileSize/1024;
					data[i].fileSize=data[i].fileSize.toFixed(2);
					data[i].fileSize+="MB";
				} else{
					data[i].fileSize+="KB";
				}
			} else{
				data[i].fileSize+="字节";
			}
		}
		return data;
	}
	
	//搜索响应
	function iconclick() {
		keyword = cui("#myClickInput").getValue().replace(new RegExp("/", "gm"), "//");
		keyword = keyword.replace(new RegExp("%", "gm"), "/%");
		keyword = keyword.replace(new RegExp("_","gm"), "/_");
		keyword = keyword.replace(new RegExp("'","gm"), "''");
	   	cui("#grid").setQuery({pageNo:1});
	   //刷新列表
		cui("#grid").loadData();
	}
 </script>
</body>


</html>