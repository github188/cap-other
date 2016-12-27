<%
    /**********************************************************************
	 * ����̨���������б�
	 * 2016-08-12 ����  �½�
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
<title>�������ù���</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/base/css/base.css?v=<%=version%>"/>
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/ProcessConfigAction.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js?v=<%=version%>"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/base/js/base.js?v=<%=version%>"></script>
</head>

<body>
	<div id="centerMain">
		<div class="list_header_wrap"  style="margin: 0 12px">
			<div class="top_float_left" >
		 		 <span uiType="ClickInput" id="myClickInput" name="clickInput" enterable="true" emptytext="���������̱�ţ��������ƣ�URL��ѯ" editable="true" width="300" 
		 			        		icon="search" iconwidth="18px" on_keydown="keyDownQuery" on_iconclick="keyWordQuery"></span> 
		 	</div>
			<div  Id="top_float_right" class="top_float_right">
				<span uitype="button" label="����" icon="upload" id="button_add"  on_click="addBtn"></span>
				<span uitype="button"  label="ɾ��" icon="trash-o" id="button_del"  on_click="deleteBtn"></span>
			</div>
		</div>
		<div id="grid_warp" style="margin: 0 12px">
			<table id="grid" uitype="grid" pagesize_list="[10,20,30]" datasource="initData" primarykey="processId" 
		       colrender="columnRenderer" resizewidth="resizeWidth"  resizeheight="resizeHeight">
		    	<tr>
					<th style="width:5%"><input type="checkbox" /></th>
					<th bindName="processName" renderStyle="text-align: left"  style="width:15%">��������</th>
					<th bindName="processId" renderStyle="text-align: left"  style="width:15%">���̱��</th>
					<th bindName="isWorkflow" renderStyle="text-align: center"  style="width:7%">�Ƿ�����</th>
					<th bindName="appId"  renderStyle="text-align: center"  style="width:15%">Ӧ�ñ��</th>
					<th bindName="unworkflowClass" renderStyle="text-align: left"style="width:13%">ʵ����</th>
					<th bindName="todoUrl" renderStyle="text-align: left"  style="width:15%">�����б�URL</th>
					<th bindName="doneUrl" renderStyle="text-align: left"  style="width:15%">�Ѱ�����URL</th>
				</tr>
		   	</table>
		</div>
	</div>
	
	<script type="text/javascript">
		var iProcessId = null;
		
		var dialog;
		window.onload=function(){
			//ɨ��CUI
			comtop.UI.scan();	
		}
		
		//grid���
		function resizeWidth(){
			return (document.documentElement.clientWidth || document.body.clientWidth) - 24;
		} 
		
		//grid�߶�
		function resizeHeight(){
			return (document.documentElement.clientHeight || document.body.clientHeight) - 45;
		}
		
		//�б����ݳ�ʼ��
		function initData(grid,query){
			var sortFieldName = query.sortName[0];
		    var sortType = query.sortType[0];
		    var fastQueryValue = cui("#myClickInput").getValue().replace(new RegExp("%", "gm"), "/%");
			fastQueryValue = fastQueryValue.replace(new RegExp("_", "gm"), "/_");
			fastQueryValue = fastQueryValue.replace(new RegExp("'","gm"), "''");
			fastQueryValue = fastQueryValue.replace(new RegExp("/","gm"), "//");
		    var queryCondition = {pageNo:query.pageNo,pageSize:query.pageSize,
					sortFieldName:sortFieldName,
					sortType:sortType};
		    queryCondition.fastQueryValue = fastQueryValue;
		    queryCondition.processId = iProcessId;
		    dwr.TOPEngine.setAsync(false);
		    ProcessConfigAction.queryProcessConfigList(queryCondition,function(data){
		    	var dataCount = data.count;
				var dataList = data.list;
				grid.setDatasource(dataList,dataCount);
		    });
		    dwr.TOPEngine.setAsync(true);
		    iProcessId = null;
		}
		
		//��Ⱦ�б�����
		function columnRenderer(data,field){
			if(field === 'processName'){
				return "<a class='a_link' href='javascript:edit(\""+data["processId"]+"\");'>"+data["processName"]+"</a>";
			}
			if(field === 'isWorkflow'){
				var isWorkflow = data["isWorkflow"];
				if (isWorkflow == 'Y' || isWorkflow == 'y'){
					return '��';
				}
				else if (isWorkflow == 'N' || isWorkflow== 'n')
					return '��';
				else 
					return null;
			}
		}
		
		//ɾ��
		function deleteBtn(){
			var selectData =cui("#grid").getSelectedPrimaryKey();
			if (selectData.length == 0) {
			    cui.alert("��ѡ��Ҫɾ��������");
			} else {
			    var msg = "ȷ��Ҫɾ��ѡ�е�������";
			    cui.confirm(msg, {
			        onYes: function () {
	                    ProcessConfigAction.deleteProcessConfig(selectData, function(data){     	
		                    var cuiTable = cui("#grid");
		                    cuiTable.removeData(cuiTable.getSelectedIndex());
		                    cui.message("ɾ�����óɹ�", "success");
		                    cui('#grid').loadData();
	                    });
			        }
			    });
			}
		}
		
		//�����ѯ��ť
		function keyWordQuery(){
			var tableObj = cui('#grid');
			tableObj.setQuery({pageNo:1});
			tableObj.loadData();
		}
		
		//���̻س������ٲ�ѯ 
		function keyDownQuery() {
			if ( event.keyCode ==13) {
				keyWordQuery();
			}
		}
		
		//����
		function addBtn(){
			var url = '${pageScope.cuiWebRoot}/top/sys/tools/processconfig/ProcessConfigEdit.jsp';
			var title = "������������";
			var height = 350; //300
			var width = 700; // 560;
		//	var height = (document.documentElement.clientHeight || document.body.clientHeight)-300; //300
			//var width = (document.documentElement.clientWidth || document.body.clientWidth)-350; // 560;
			if(!dialog)
			dialog = cui.dialog({
				src:url,
				width:width,
				height:height
			});
			dialog.show(url); 
		}
		
		//�༭
		function edit(processId){
			var url = '${pageScope.cuiWebRoot}/top/sys/tools/processconfig/ProcessConfigEdit.jsp?processId='+processId;
			var title = "�༭��������";
			var height = 350; //300
			var width = 700; // 560;
		//	var height = (document.documentElement.clientHeight || document.body.clientHeight)-300; //300
			//var width = (document.documentElement.clientWidth || document.body.clientWidth)-350; // 560;
			if(!dialog)
			dialog = cui.dialog({
				src:url,
				width:width,
				height:height
			});
			dialog.show(url); 
		}
		
		/**
		**�ص�����
		**/
		function addCallBack(saveType,selectedKey){
			var tableObj = cui('#grid');
			iProcessId = selectedKey;
			tableObj.setQuery({pageNo:1,sortType:[],sortName:[]});
			tableObj.loadData();
			cui("#grid").selectRowsByPK(selectedKey);
		}
		
	</script>
</body>
</html>
