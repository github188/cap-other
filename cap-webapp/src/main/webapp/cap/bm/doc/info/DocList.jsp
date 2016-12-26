<%
/**********************************************************************
* 文档管理-列表
* 2015-11-9 李小芬  新建
**********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>文档列表页</title>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_sys.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"  type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/eic/css/eic.css"  type="text/css">
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/top/js/jquery.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/eic/js/comtop.ui.emDialog.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/eic/js/comtop.eic.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/engine.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/util.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/DocumentAction.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/BizDomainAction.js'></script>
	<style type="text/css">
	</style>
</head>
<body>
<div class="list_header_wrap">
	<div class="top_float_left">
		<div class="thw_title" style="margin-left:11px;margin-top:0px;">
			<font id="pageTittle" class="fontTitle">文档列表</font> 
		</div>
	</div>
	<div class="top_float_right">
		<span uitype="PullDown" id="docType" mode="Single" datasource="docTypeData" select="-1" empty_text="--文档类型--" editable="false" on_change ="fastQuery" ></span>
		<span uitype="button" label="新增" id="button_add" on_click="addDoc"></span>
		<span uitype="button" label="删除" id="button_del" on_click="delDoc"></span>
		<span uitype="button" label="导入" id="button_import" on_click="importDoc"></span>
		<span uitype="button" label="导出" id="button_export" on_click="exportDoc"></span>
		<span uitype="button" label="文档操作记录" id="button_operLog" on_click="checkOperLog"></span>
		
	</div>
</div>
<br>
 <table uitype="Grid" id="DocGrid" primarykey="id" sorttype="1" datasource="initData" pagination="false"  pagesize_list="[10,20,30]"  
 	resizewidth="resizeWidth" resizeheight="resizeHeight" colrender="columnRenderer" >  
 	<thead>
 	<tr>
		<th style="width:2%"><input type="checkbox"/></th>
		<th render="rowNoRender" renderStyle="text-align: center;" style="width:4%;">序号</th>
		<th bindName="name" style="width:30%;" renderStyle="text-align: left;"  render="">名称</th>
		<th bindName="status" style="width:10%;" renderStyle="text-align: center"  render="">状态</th>
		<th bindName="docType" style="width:9%;" renderStyle="text-align: left;" render="">类型</th>
		<th bindName="docTemplateName" style="width:35%;" renderStyle="text-align: left;" >模板配置</th>
		<th bindName="operating" style="width:10%;" renderStyle="text-align: center;">操作</th>
	</tr>
	</thead>
</table>

<script language="javascript"> 
	var bizDomainId = "${param.bizDomainId}";//业务域ID
	var bizDomainName = "${param.bizDomianName}";
	var docTypeData =  [
		{"id": "", "text":"--文档类型--"},            
		{"id": "BIZ_MODEL", "text":"业务模型说明书"},
		{"id": "SRS", "text":"需求规格说明书"},                   
		{"id": "HLD", "text":"概要设计说明书"},
		{"id": "DBD", "text":"数据库设计说明书"},
		{"id": "LLD", "text":"详细设计说明书"}
	];
	//onload 
	window.onload = function(){
		var url = "<%=request.getContextPath() %>/cap/bm/doc/info/MonitorAsynTaskList.jsp?userId="+globalCapEmployeeId+"&init=true"
		initOpenBottomImage(url);
		comtop.UI.scan();
		setInterval("fastQuery()",30000);
	}
	
	//grid数据源
	function initData(tableObj,query){
		query.bizDomain = bizDomainId;
		query.docType = cui("#docType").getValue();
		if(query.docType === "--文档类型--"){
			query.docType = "";
		}
		dwr.TOPEngine.setAsync(false);
		BizDomainAction.queryDomainById(bizDomainId,function(data){
			bizDomainName = data.name;
		});
		DocumentAction.queryDocumentList(query,function(data){
			tableObj.setDatasource(data.list, data.count);
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//快速查询
	function fastQuery(){
		cui("#DocGrid").loadData();
	}
	
	//序号 
	function rowNoRender(rowData, index, colName){
		return index+1;
	}
	
	//grid列渲染 
	function columnRenderer(data,field){
		var strDocType = "";
        switch (data.docType) {
          case "SRS":
        	  strDocType = "需求规格说明书";
            break;
          case "BIZ_MODEL":
        	  strDocType = "业务模型说明书";
            break;
          case "HLD":
        	  strDocType = "概要设计说明书";
            break;
          case "LLD":
        	  strDocType = "详细设计说明书";
            break;
          case "DBD":
        	  strDocType = "数据库设计说明书";
            break;
          default:
        	  strDocType = "";
        }
	    if(field == 'name') {
	        return "<a href='javascript:;' onclick='docContentEdit(\"" + data.id+ "\",\""+strDocType + "\",\""+data.name + "\");'>" + data.name + "</a>";
	    }else if(field == 'docType'){
	        return strDocType;
	    }else if(field == 'operating'){
			var resultHtml = "<a class='a_link' href='javascript:updateDoc(\""+data.id+"\");'>编辑</a>"; 
			return resultHtml;
		}
	    
	  }
	
	//创建新文档
	function addDoc() {
		var url = "DocEdit.jsp?bizDomainId=" + bizDomainId + "&bizDomainName=" + bizDomainName;
		showDialog(url);
	}
	
	// 编辑属性
	function updateDoc(id) {
	    var url = "DocEdit.jsp?documentId=" + id + "&bizDomainId=" + bizDomainId +"&bizDomainName=" +bizDomainName;	    	
	    showDialog(url);
	}
	
	//文档内容编辑
	function docContentEdit(id,title,name){
		if(name!="undefined"&&name!=null&&name!="null"){
			name = encodeURIComponent(encodeURIComponent(name));
		}
		if(title!="undefined"&&title!=null&&title!="null"){
			title = encodeURIComponent(encodeURIComponent(title));
		}
		var url = "<%=request.getContextPath() %>/cap/bm/doc/content/DocContentMain.jsp?documentId=" + id + "&documentName=" + name + "&documentTitle=" +title;
		window.open(url, "_blank");
	}
	
	function showDialog(url){
		var title="文档基本信息页面";
		var height = 310; //600
		var width =  620; // 680;
		dialog = cui.dialog({
			title : title,
			src : url,
			width : width,
			page_scroll : true,
			height : height
		})
		dialog.show(url);
	}
	
	// 删除界面
	function delDoc() {
		var selectRows = cui("#DocGrid").getSelectedRowData();
		if(selectRows == null || selectRows.length == 0){
			cui.alert("请选择要删除的文档。");
			return;
		}
		var bCanDelte = true;
		//删除业务模型说明书必须先删除需求规格说明书
		for(var i = 0; i < selectRows.length; i++){
			if(selectRows[i].docType == 'BIZ_MODEL'){ 
				//判断grid的列表中是否有需求规格说明书 
				var allRows = cui("#DocGrid").getData();
				for(var j = 0; j < allRows.length; j++){
					if(allRows[j].docType == 'SRS'){ 
						bCanDelte = false;
					}
				}

			}
		}
		if(!bCanDelte){
			cui.alert("删除业务模型说明书前必须先删除所有需求规格说明书。");	
			return;
		}
		cui.confirm("确定要删除这"+selectRows.length+"个文档吗？",{
			onYes:function(){
				dwr.TOPEngine.setAsync(false);
				DocumentAction.deleteDocumentList(cui("#DocGrid").getSelectedRowData(),function(msg){
				 	cui("#DocGrid").loadData();
				 	cui.message("删除成功！","success");
				});
		    	dwr.TOPEngine.setAsync(true);
			}
		});
	}
	
	//编辑回调
	function editCallBack(key) {
		cui("#DocGrid").loadData();
		cui("#DocGrid").selectRowsByPK(key);
	}
	
	//导入文档 
	function importDoc(){
		var url = "DocImportPage.jsp?bizDomainId="+bizDomainId+"&bizDomainName="+encodeURIComponent(encodeURIComponent(bizDomainName));
		var title="导入";
		var height = 380; //600
		var width = 650; // 680;
		
		dialog = cui.dialog({
			title : title,
			src : url,
			width : width,
			height : height
		})
		dialog.show(url);
	}
	
	//批量导出
	function exportDoc(){
		var selectRows = cui("#DocGrid").getSelectedRowData();
		if(selectRows == null || selectRows.length == 0){
			cui.alert("请选择要导出的文档。");
			return;
		}
		var notHLD;
		var notLLD;
		var notDBD;
		for(var i = 0; i < selectRows.length; i++){
			if(selectRows[i].docType == 'HLD'){
				notHLD = true;
			}else if(selectRows[i].docType == 'LLD'){
				notLLD = true;
			}else if(selectRows[i].docType == 'DBD'){
				notDBD = true;
			}
		}
		var notMessage;
		if(notHLD || notLLD || notDBD){
			notMessage = '不能导出';
		}
		if(notHLD){
			notMessage += '概要设计说明书、';
		}
		if(notLLD){
			notMessage += '详细设计说明书、';
		}
		if(notDBD){
			notMessage += '数据库设计说明书、';
		}
		if(notMessage){
			cui.alert(notMessage.substring(0,notMessage.length-1));
			return;
		}
		dwr.TOPEngine.setAsync(false);
		DocumentAction.exportDocument(cui("#DocGrid").getSelectedRowData(),function(result){
			var code = result.code;
			if("Success" === code){
				cui.success(result.message);
			}else if("Error" === code){
				cui.warn(result.message);
			}else{
				cui.alert(result.message);
			}
		});
    	dwr.TOPEngine.setAsync(true);
	}
	
	function openComm(){
		var url = "<%=request.getContextPath() %>/cap/bm/doc/content/CommModelDataEdit.jsp?uri=CAP.001.TZBB";
		var title="测试通用模型数据维护页面";
		var height = 600; //600
		var width =  700; // 680;
		dialog = cui.dialog({
			title : title,
			src : url,
			width : width,
			page_scroll : true,
			height : height
		})
		dialog.show(url);
	}
	
	function checkOperLog(){
		var url = "<%=request.getContextPath() %>/cap/bm/doc/operLog/DocOperLogMainPage.jsp?bizDomainId="+bizDomainId;
		var title="文档操作记录列表";
		var height = 600;
		var width =  900;
		dialog = cui.dialog({
			title : title,
			src : url,
			width : width,
			page_scroll : true,
			height : height
		})
		dialog.show(url);
	}

	
	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 20;
	}
	
	//grid高度
	function resizeHeight(){
		return (document.documentElement.clientHeight || document.body.clientHeight) - 80;
	}
 </script>
</body>
</html>