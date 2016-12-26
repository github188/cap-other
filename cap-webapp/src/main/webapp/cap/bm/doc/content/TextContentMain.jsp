<%
  /**********************************************************************
	* 文本内容
	* 2015-11-13  李小芬  新增
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="UTF-8"%>

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
	<script type="text/javascript" src="<%=request.getContextPath() %>/eic/js/comtop.ui.emDialog.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.editor.min.js"></script>
</head>
<style>
</style>
<body>
	<div class="top_header_wrap">
		<div class="thw_operate" style="float:right;">
			<span uitype="button" id="saveText" label="保 存" on_click="saveText"></span>
		</div>
	</div>
	<div class="top_content_wrap cui_ext_textmode">
		<table class="form_table" style="table-layout:fixed;">
			<tr>
				<td >
					<span uitype="Editor" id="textContent" width="80%" min_frame_height="420"  word_count="false" textmode="false" word_count="true"  
						toolbars="toolbars" focus="true"></span>
				</td>
			</tr>
		</table>
	</div>
	<script type="text/javascript">
		var DocEditorAttribute = parent.editEditor;
		var divId = "${param.divId}";
		
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
		
	
		window.onload = function(){
	   		init();
	   	}
		                
		//初始化加载  	
	   	function init() {
			comtop.UI.scan();
			cui("#textContent").setHtml(DocEditorAttribute.html);
	    }
		
		function saveText(){
			var docChapterContentStruct = {};
			docChapterContentStruct.uri = DocEditorAttribute.uri;
			docChapterContentStruct.documentId = DocEditorAttribute.documentId;
			docChapterContentStruct.sortNo = DocEditorAttribute.sortNo;
			docChapterContentStruct.containerType = DocEditorAttribute.containerType;
			docChapterContentStruct.contentType = "Text";
			DocEditorAttribute.html = cui("#textContent").getHtml();
			docChapterContentStruct.docEditorAttributeVO = DocEditorAttribute;
			dwr.TOPEngine.setAsync(false);
			DocChapterContentStructAction.saveDocChapterContentStruct(docChapterContentStruct,function(bResult){
				var divHtml = DocEditorAttribute.html;
				/**var divHtml = "<button style='float:right;padding-bottom:4px;' onclick='editText(\""; 
				divHtml += divId + "\")' >编 辑</button>";
				divHtml += "<span>"
				if(!cui("#textContent").getHtml()){
					divHtml += "&nbsp;&nbsp;&nbsp;&nbsp;此处可编辑文本内容";
				}else{
					divHtml += DocEditorAttribute.html;
				}
				divHtml += "</span><br>";**/
				window.parent.editTextCallBack(divId,divHtml);
				cui.message('保存成功。','success');
				closeSelf();
				
			});
			dwr.TOPEngine.setAsync(true);
		}
		
		//关闭窗口
		function closeSelf(){
			window.parent.dialog.hide();
		}
	
</script>
</body>
</html>