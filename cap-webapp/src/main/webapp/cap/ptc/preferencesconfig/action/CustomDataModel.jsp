<%
/**********************************************************************
* dataModel属性
* 2015-05-07 诸焕辉  
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html>
<head>
	<title>数据模型属性</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <top:link href="/cap/bm/common/codemirror/lib/codemirror.css"></top:link>
    <top:link href="/cap/bm/common/codemirror/theme/eclipse.css"></top:link>
    <top:link href="/cap/bm/common/codemirror/addon/hint/show-hint.css"></top:link>
    <top:link href="/cap/bm/common/codemirror/addon/display/fullscreen.css"></top:link>
    <style type="text/css">
    	.cap-table-fullWidth{
			margin-bottom: 5px;
		}
		.CodeMirror {
			height:493px;
		}
		.readCodeArea, .writeCodeArea{
			border-radius: 3.01px;
    		box-shadow: 0 2px 2px rgba(0,0,0,.1) inset;
    		transition: border .3s linear 0s;
    		border: 1px solid #ccc;
			-moz-transition:border .3s linear 0s;
			-webkit-transition:border .3s linear 0s;
			-o-transition:border .3s linear 0s
		}
	</style>
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/lib/codemirror.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/mode/javascript/javascript.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/addon/hint/show-hint.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/addon/hint/javascript-hint.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/addon/display/fullscreen.js"></top:script>
	<top:script src="/cap/bm/common/base/js/jsformat.js"></top:script>
    <top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
</head>
<body class="body_layout">
	<div class="cap-page">
		<div class="header" style="position: absolute;right: 16px; top: 16px; z-index: 1000">
			<span id="resetBtn" uitype="Button" on_click="reset" label="重置"></span> 
			<span id="ensureBtn" uitype="button" on_click="ensure" label="确定" ></span>
			<span id="closeWinBtn" uitype="button" on_click="closeWin" label="关闭" ></span>
		</div>
		<div class="cap-area" id="tab_area" uitype="tab" closeable="true"> 
			<div data-options='{"closeable":"false","tab_width":"70","title":"自定义数据"}'>
		        <table class="cap-table-fullWidth">
					<tr>
				        <td class="cap-td" style="text-align: left;">
				        	<span>
					        	<blockquote class="cap-form-group" style="margin: 0">
									<span>样板区域</span>
								</blockquote>
							</span>
				        </td>
				        <td class="cap-td" style="text-align: left;">
				        	<span>
					        	<blockquote class="cap-form-group">
									<span>代码自定义区域</span>
								</blockquote>
							</span>
				        </td>
				        <td class="cap-td" style="text-align: right; width:40%; padding: 5px 5px 0 0" align="right">
				        	<span uitype="button" id="codeformatterBtn" label="格式化" on_click="doFormat" ></span>
				        </td>
				    </tr>
				    <tr>
				        <td class="cap-td" style="text-align: left;">
				        	<div class="readCodeArea" style="width: 354px"><textarea id="codeTmp" name="codeTmp"></textarea></div>
				        </td>
				        <td class="cap-td" style="text-align: left;" colspan="2">
				        	<div class="writeCodeArea" style="width: 400px"><textarea id="code" name="code"></textarea></div>
				        </td>
				    </tr>
				</table>
		    </div>
		</div>
	</div>
	<script type="text/javascript">
		var propertyName = "<c:out value='${param.propertyName}'/>";
		var uitype = "<c:out value='${param.uitype}'/>";
		var propertyType = "<c:out value='${param.propertyType}'/>";
		var initValue = window.opener.scope.script[propertyName];
		var callbackMethod = "<c:out value='${param.callbackMethod}'/>";
		var defaultValues = {
				PullDown: {datasource: "[{id:'item1',text:'选项1'},{id:'item2',text:'选项2'},{id:'item3',text:'选项3'}]"}, 
				RadioGroup: {radio_list: "[{text:'值1',value:1},{text:'值2',value:2},{text:'值3',value:3}]"}, 
				CheckboxGroup: {checkbox_list: "[{text:'值1',value:1},{text:'值2',value:2},{text:'值3',value:3}]"},
				Button: {menu: "{datasource: [{id: '1',label:'值1'},{id: '2', label: '值2'}],on_click: function(obj) {}}"},
				Menu: {datasource: "[{id:'item1',label:'选项1'},{id:'item2',label:'选项2'},{id:'item3',label:'选项3'}]"},
				Tree: {children: "[{title:'设备类别结构',key:'k1'},{title:'Folder 2',key:'k2',isFolder:'true'},{title:'其他',key:'k3',hideCheckbox:'true'}]"},
				ListBox: {datasource: "[{id:'item1',text:'选项1'}, {id:'item2',text:'选项2'}, {id:'item3',text:'选项3'}]"},
				CodeArea: {text: "<!DOCTYPE html>\n<html>\n\t<head>\n\t\t<title>标题</title>\n\t\t<meta http-equiv='Content-Type' content='text/html charset=UTF-8'>\n\t</head>\n\t<body>\n\t</body>\n</html>"},
				Editor: {toolbars: "[['anchor', 'redo', 'bold', 'indent', 'italic']]"}
		};
		
		
		//清空
		function reset(){
			editor.setValue('');
		}
		
		//确定（如果自定义数据和行为函数都有值，优先选择行为函数）
		function ensure(){
			var val = $.trim(editor.getValue());
			try{
				if(propertyType == 'String'){
					val = val.replace(/"/g, '\\"');
				}
				window.opener[callbackMethod](propertyName, val);
			    closeWin();
			}catch(err){ 
				console.log(err);
			}
	    }
		
		//关闭窗口
		function closeWin(){
			window.close();
		}
	
		//创建codeMirror组件
		var editorTmp = CodeMirror.fromTextArea(document.getElementById('codeTmp'), {
	    	lineNumbers: true,
	        //根据页面类型生成codeMirror类型
            viewportMargin: Infinity,
            theme: "eclipse",
            mode: "javascript",
            lineWrapping:true,
            readOnly:true
		});
		
		//创建codeMirror组件
		var editor = CodeMirror.fromTextArea(document.getElementById('code'), {
	    	lineNumbers: true,
	        //根据页面类型生成codeMirror类型
            viewportMargin: Infinity,
            theme: "eclipse",
            mode: "javascript",
            lineWrapping:true
		});
		
		//格式化json代码
		function doFormat(){
			var value = $.trim(editor.getValue());
			if(value != ''){
				editor.setValue(jsCodeformatter(value));
			}
		}
		
		/**
		 * 格式化js代码
		 * @param txt js代码
		 */
	 	function jsCodeformatter(txt){
	 		txt = txt.replace(/^\s+/, ''); 
	        if (txt && txt.charAt(0) === '<') {
	        	txt = style_html(txt, 4, ' ', 80);
	        } else {
	        	txt = js_beautify(txt, 4, ' ');
	        }
			return txt;
	 	}
		
		//初始化页面数据
		function initPage(){
			if(propertyType == 'Json'){
			    editor.setValue(jsCodeformatter(initValue));
	        } else {
	        	editor.setValue(initValue.replace(/\\/g, ''));
	        }
	        //初始化样板区域案例
	        if(propertyType == 'Json'){
	        	editorTmp.setValue(jsCodeformatter(defaultValues[uitype][propertyName]));
	        } else if (propertyType == 'String'){
		        cui("#codeformatterBtn").hide();
	        	editorTmp.setValue(defaultValues[uitype][propertyName]);
	        }
		}
		
		jQuery(document).ready(function(){
			var title = uitype + '_' + propertyName + '属性编辑';
			$("title").text(title);
	        comtop.UI.scan();
	        initPage();
	    });
	</script>
</body>
</html>

