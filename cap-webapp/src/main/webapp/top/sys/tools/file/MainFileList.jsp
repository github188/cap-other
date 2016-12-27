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
	<%//360�����ָ��webkit�ں˴�%>
	<meta name="renderer" content="webkit">
	<%//�ر�ie����ģʽ,ʹ����߰汾�ĵ�ģʽ��Ⱦҳ��%>
	<meta http-equiv="x-ua-compatible" content="IE=edge" >
	<meta http-equiv="Content-Type" content="text/html; charset=GBK"/>
   	<title>ϵͳ���ϼ��ؼ�����</title>
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
 		 <span uiType="ClickInput" id="myClickInput" name="clickInput" enterable="true" emptytext="�������ļ�����" editable="true" width="300" on_iconclick="iconclick" 
 			        		icon="search" iconwidth="18px"></span> 
 	</div>
	<div  Id="top_float_right" class="top_float_right" style="DISPLAY: none"  >
	<% if(isAdminManager){%>
		<span uitype="button" label="�ϴ�" icon="upload" id="button_add"  on_click="add"></span>
		<span uitype="button"  label="ɾ&nbsp;��" icon="trash-o" id="button_del"  on_click="deletefile"></span>
		<%} %>
	</div>
</div>
<div id="grid_wrap">
<table id="grid" uitype="grid" datasource="initData" primarykey="fileId" colrender="columnRenderer" resizewidth="resizeWidth"  resizeheight="resizeHeight" >
	<tr>
		<th style="width:5%"><input type="checkbox" /></th>
		<th bindName="fileName" style="width:35%;" renderStyle="text-align: left" >�ļ�����</th>
		<th bindName="fileShortName" style="width:30%;"  renderStyle="text-align: left" >�ļ�����</th>
		<th bindName="fileSize" style="width:10%;" renderStyle="text-align: left" >�ļ���С</th>
		<th bindName="createTime" style="width:15%;" format="yyyy��MM��dd��" renderStyle="text-align: center" sort="true">�ϴ�ʱ��</th>
		<th name="download"  bindName="download" style="width:5%;"  renderStyle="text-align: center;"  render="setIcon" >����</th>
	</tr>
</table>
</div>
</div>
<script language="javascript"> 
	//���ڶ���
	var dialog;
	var keyword = '';
	var isAdminManager = <%=isAdminManager%>;
    var fileClassifyId = "<c:out value='${param.fileClassifyId}'/>";
	window.onload = function(){
		comtop.UI.scan();		
	}

	//grid���
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) -22
	} 
	
	//grid�߶�
	function resizeHeight(){
		return (document.documentElement.clientHeight || document.body.clientHeight) - 45;
	}
	
	/**
	* ��������.
	**/
	function add(){
		var url = '${pageScope.cuiWebRoot}/top/sys/tools/file/UploadFile.jsp?fileClassify=' + fileClassifyId;
		var title = "�ϴ��ļ�";
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
		var title = "�ļ��༭";
		}else
		{var url = '${pageScope.cuiWebRoot}/top/sys/tools/file/UploadFile.jsp?downloadId='+downloadId;
		var title = "�ļ��鿴";
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
	
	//��Ⱦ�б�����
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
	* ����Ⱦ
	**/
	function columnRenderer(data,field) {
	}
	function setIcon(rowdata){
		   return  "<a target='a_blank'  onclick='down(\""+rowdata["fileId"]+"\");' title='�����ļ�'><img src='images/download.png'/></a>";    
				
	}
	
	function down(fileId){
		var url = "${pageScope.cuiWebRoot}/top/sys/tools/file/downloadFile.ac?downloadId="+fileId;
		window.location=url;
	}
	
	/**
	**�ص�����
	**/
	function addCallBack(){
		cui("#grid").loadData();
		
	}
	
	
	
	//ɾ������
	function deletefile(){
		var selectData =cui("#grid").getSelectedPrimaryKey();
		if (selectData.length == 0) {
		    cui.alert("��ѡ��Ҫɾ�����ļ�");
		} else {
		    var msg = "ȷ��Ҫɾ��ѡ�е��ļ���";
		    cui.confirm(msg, {
		        onYes: function () {
                    FileAction.deleteFile(selectData, function(data){     	
                    	if(data == 1){
	                        var cuiTable = cui("#grid");
	                        cuiTable.removeData(cuiTable.getSelectedIndex());
	                        cui.message("ɾ���ļ��ɹ�", "success");
	                        table_obj.loadData();
                    	}
                    });
		        }
		    });
		}
	}
	
	//��ʾ�ļ���С
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
				data[i].fileSize+="�ֽ�";
			}
		}
		return data;
	}
	
	//������Ӧ
	function iconclick() {
		keyword = cui("#myClickInput").getValue().replace(new RegExp("/", "gm"), "//");
		keyword = keyword.replace(new RegExp("%", "gm"), "/%");
		keyword = keyword.replace(new RegExp("_","gm"), "/_");
		keyword = keyword.replace(new RegExp("'","gm"), "''");
	   	cui("#grid").setQuery({pageNo:1});
	   //ˢ���б�
		cui("#grid").loadData();
	}
 </script>
</body>


</html>