<%
  /**********************************************************************
	* 文本内容
	* 2015-11-13  李小芬  新增
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<!doctype html>
<html>
<head>
<title>文档基本信息编辑页面</title>
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_sys.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/top/js/jquery.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/engine.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/util.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/DocChapterContentStructAction.js'></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/top/js/jct.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/eic/js/comtop.ui.emDialog.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.editor.min.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/uedit/dialogs/capattachment/capAttachmentDialog.js"></script>
</head>
<style>
button {
	float:right;
	margin-top:2px;
	margin-right:2px;
	margin-bottom:2px;
	margin-left:2px;
}
</style>
<body>
	<script type="text/javascript">
		var containerUri = decodeURIComponent("${param.containerUri}"); //章节ID 
		var containerType = "${param.containerType}";//容器类型 
		var documentId = "${param.documentId}";//文档ID
		var contentType = "${param.contentType}";//文本类型
		var xmlfullPath = decodeURIComponent("${param.xmlfullPath}"); //xml的路径
		var nodeId = decodeURIComponent("${param.nodeId}"); //xml的路径
		
		//edit组件工具栏
		var toolbars=[[
				   'source',
		           'undo', //撤销
		           'redo', //重做
		           'bold', //加粗
		           'indent', //首行缩进
		           'italic', //斜体
		           'underline', //下划线
		           'strikethrough', //删除线
		           'time', //时间
		           'date', //日期
		           'inserttable', //插入表格
		           'insertrow', //前插入行
		           'insertcol', //前插入列
		           'mergeright', //右合并单元格
		           'mergedown', //下合并单元格
		           'deleterow', //删除行
		           'deletecol', //删除列
		           'splittorows', //拆分成行
		           'splittocols', //拆分成列
		           'splittocells', //完全拆分单元格
		           'deletecaption', //删除表格标题
		           'inserttitle', //插入标题
		           'mergecells', //合并多个单元格
		           'deletetable', //删除表格
		           'insertparagraphbeforetable', //"表格前插入行"
		           'fontfamily', //字体
		           'fontsize', //字号
		           'paragraph', //段落格式
		           'insertimage',//多图上传 
		           'edittable', //表格属性
		           'edittd', //单元格属性
		           'link', //超链接
		           'spechars', //特殊字符
		           'justifyleft', //居左对齐
		           'justifyright', //居右对齐
		           'justifycenter', //居中对齐
		           'justifyjustify', //两端对齐
		           'forecolor', //字体颜色
		           'rowspacingtop', //段前距
		           'rowspacingbottom', //段后距
		           'pagebreak', //分页
		           'imagecenter', //居中
		           ]];
		
		var editOpenUrl = [
			{key:"docInfo=#Document(id=$documentId)",value:""},
			{key:"docInfo=#Document(id=$documentId)",value:""},
			{key:"docInfo=#Document(id=$documentId)",value:""},
			{key:"docInfo=#Document(id=$documentId)",value:""},
			{key:"docInfo=#Document(id=$documentId)",value:""},
			{key:"docInfo=#Document(id=$documentId)",value:""},
			{key:"docInfo=#Document(id=$documentId)",value:""},
			{key:"docInfo=#Document(id=$documentId)",value:""},
			{key:"docInfo=#Document(id=$documentId)",value:""},
			{key:"docInfo=#Document(id=$documentId)",value:""},
			{key:"docInfo=#Document(id=$documentId)",value:""},
			{key:"docInfo=#Document(id=$documentId)",value:""},
			{key:"docInfo=#Document(id=$documentId)",value:""},
			{key:"docInfo=#Document(id=$documentId)",value:""},
			{key:"docInfo=#Document(id=$documentId)",value:""}
		];
	
		
		
		window.onload = function(){
			// var docChapterContentStruct = {"containerUri":containerUri,"containerType":containerType,"documentId":documentId,"contentType":contentType,"xmlfullPath":xmlfullPath};
			var nodeData = parent.getSelectTree(nodeId);
			var docChapterContentStruct = nodeData.getData().data;
			var contentSegs;
			dwr.TOPEngine.setAsync(false);
			DocChapterContentStructAction.getChapterXmlContentById(docChapterContentStruct,function(data){
				//data为DocChapterContentVO的list,循环创建DIV 
				contentSegs = data;
				for(var i=0;i<data.length;i++){ 
					var docChapterContentStruct = data[i];
					if(i==0){
						var objdiv1 = document.createElement("div");
						objdiv1.innerHTML = '<span style="font-weight:bold;font-size:18px;">' + docChapterContentStruct.chapterWordNumber + '&nbsp;&nbsp;' +docChapterContentStruct.chapterName + '</span>';
						document.body.appendChild(objdiv1);
					}
					var objdiv = document.createElement("div");
					objdiv.id = docChapterContentStruct.id;
					objdiv.innerHTML = docChapterContentStruct.xmlContent;
					objdiv.docChapterContentStruct = docChapterContentStruct;
					document.body.appendChild(objdiv);
				}
		     });
			dwr.TOPEngine.setAsync(true);
	   		comtop.UI.scan();
	   		
	   		for(var i=0;i<contentSegs.length;i++){
	   			var docChapterContentStruct = contentSegs[i];
				if(docChapterContentStruct.contentType == "EXT_ROWS"){ //行扩展表需要设置数据源信息
					var gridData = docChapterContentStruct.gridDataVO.lstGrid;
					if(gridData){
						cui("#gridTable"+docChapterContentStruct.id).setDatasource(gridData,gridData.length);
					}else{
						cui("#gridTable"+docChapterContentStruct.id).setDatasource([],0);
					}
				}
				if(docChapterContentStruct.contentType == "TEXT" || docChapterContentStruct.contentType == "UNKNOWN" ){ //富文本编辑器--GRAPHIC
					if(docChapterContentStruct.editorHtml){
						cui("#Editor"+docChapterContentStruct.id).setHtml(docChapterContentStruct.editorHtml);
					}else{ //Editor控件缺陷，如果为空时只读效果不生效 
						cui("#Editor"+docChapterContentStruct.id).setHtml(" ");
					}
					//保存按钮隐藏
					 $("#SaveEditor"+docChapterContentStruct.id).hide();
					 UE.getEditor("Editor"+docChapterContentStruct.id).ready(function() {
						 $(this.container).find('.edui-editor-toolbarboxinner, .edui-editor-bottomContainer').hide();
					 });
				}
	   		}
	   	}
		/************************************************************Editor Start**************************************************/
		//编辑富文本 
		function EditEditorText(divId){
			$("#EditEditor"+divId).hide();
			$("#SaveEditor"+divId).show();
			cui("#Editor"+divId).setReadonly(false);
			$("#EditEditor"+divId).parent().find('.edui-editor-toolbarboxinner, .edui-editor-bottomContainer').show();
		}
		
		//保存富文本 
		function SaveEditorText(divId){
			var firstDocStructVO = document.getElementById(divId).docChapterContentStruct;
			firstDocStructVO.editorHtml = cui("#Editor"+divId).getHtml();
			dwr.TOPEngine.setAsync(false);
			DocChapterContentStructAction.saveDocChapterContentStruct(firstDocStructVO,function(bResult){
				cui.message('保存成功。','success');
			});
			dwr.TOPEngine.setAsync(true);
			$("#EditEditor"+divId).show();
			$("#SaveEditor"+divId).hide();
			cui("#Editor"+divId).setReadonly(true);
			$("#EditEditor"+divId).parent().find('.edui-editor-toolbarboxinner, .edui-editor-bottomContainer').hide();
		}
		/************************************************************Editor end**************************************************/
		/************************************************************Open Start**************************************************/
		//id参数必须 
		function editOpen(divId){
			var firstDocStructVO = document.getElementById(divId).docChapterContentStruct;
			var url;
			for(var i=0;i<editOpenUrl.length;i++){
				if(firstDocStructVO.mappingTo == editOpenUrl[i].key){
					url = editOpenUrl[i].value;
				}
			}
			var url = firstDocStructVO.openJspUrl;
			url += "?divId=" + divId;
			var title="文档表格编辑";
			var height = 600;
			var width =  800;
			dialog = cui.dialog({
				title : title,
				src : url,
				width : width,
				page_scroll : true,
				height : height
			})
			dialog.show(url);
		}
		
		function editOpenCallBack(divId,divHtml){
			document.getElementById(divId).innerHTML = divHtml;
		}
		
		/************************************************************Open end**************************************************/
		
		//grid数据源
		function initData(tableObj,query){
			tableObj.setDatasource([],0);
		}
		
		//tip 提示
		function titlerender(rowData,bindName){
			if(rowData[bindName] && rowData[bindName].length>100){
				var titleTip = rowData[bindName];
				if(titleTip.substr(0,3) == "<p>"){
					return rowData[bindName].substr(3,100)+"...";
				}
				return rowData[bindName].substr(0,100)+"...";
			}
			return rowData[bindName];
			
		}
		
		//grid 宽度
		function resizeWidth(){
			return (document.documentElement.clientWidth || document.body.clientWidth) - 20;
		}
		
		//grid高度
		function resizeHeight(){
			return (document.documentElement.clientHeight || document.body.clientHeight) - 320;
		}
</script>
</body>
</html>