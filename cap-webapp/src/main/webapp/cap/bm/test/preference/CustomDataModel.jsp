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
		.CodeMirror {
			height:420px;
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
	<top:script src="/cap/bm/common/codemirror/lib/codemirror.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/mode/javascript/javascript.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/addon/hint/show-hint.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/addon/hint/javascript-hint.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/addon/display/fullscreen.js"></top:script>
	<top:script src="/cap/bm/common/base/js/jsformat.js"></top:script>
    <top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src="/cap/dwr/interface/ComponentFacade.js"></top:script>
</head>
<body class="body_layout">
<div class="cap-page">
	<div class="cap-area">
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
		        <td class="cap-td" style="text-align: right; width:40%; padding: 5px 2px" align="right">
		        	<span uitype="button" id="codeformatterBtn" label=" 格式化 " on_click="doFormat" ></span>
					<span uitype="button" on_click="saveData" label=" 保 存 " ></span>
		        </td>
		    </tr>
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        	<div class="readCodeArea" style="width: 340px"><textarea id="codeTmp" name="codeTmp"></textarea></div>
		        </td>
		        <td class="cap-td" style="text-align: left;" colspan="2">
		        	<div class="writeCodeArea" style="width: 360px"><textarea id="code" name="code"></textarea></div>
		        </td>
		    </tr>
		</table>
	</div>
</div>

	<script type="text/javascript">
		var propertyName = "<c:out value='${param.propertyName}'/>";
		var scopeName = "<c:out value='${param.scopeName}'/>";
		var scope = scopeName != '' ? eval("window.parent."+scopeName) : window.parent.scope;
		var initValue = scope.data.hasOwnProperty(propertyName) === true ? scope.data[propertyName] : "";
		var callbackMethod = "<c:out value='${param.callbackMethod}'/>";
		var propertyVo = queryProperty(propertyName);
		var uitype = queryProperty('uitype').defaultValue;
		var defaultValue = propertyVo.defaultValue;
		var propertyType = propertyVo.type;
		
		var defaultValues = {
				PullDown: {datasource: '[{id:"item1",text:"选项1"},{id:"item2",text:"选项2"},{id:"item3",text:"选项3"}]'}, 
				RadioGroup: {radio_list: '[{text:"值1",value:1},{text:"值2",value:2},{text:"值3",value:3}]'}, 
				CheckboxGroup: {checkbox_list: '[{text:"值1",value:1},{text:"值2",value:2},{text:"值3",value:3}]'},
				Button: {menu: '{datasource: [{id: "1",label:"值1"},{id: "2", label: "值2"}],on_click: function(obj) {}}'},
				Menu: {datasource: '[{id:"item1",label:"选项1"},{id:"item2",label:"选项2"},{id:"item3",label:"选项3"}]'},
				Tree: {children: '[{title:"设备类别结构",key:"k1"},{title:"Folder 2",key:"k2",isFolder:"true"},{title:"其他",key:"k3",hideCheckbox:"true"}]'},
				ListBox: {datasource: '[{id:"item1",text:"选项1"}, {id:"item2",text:"选项2"}, {id:"item3",text:"选项3"}]'},
				CodeArea: {text: '<!DOCTYPE html>\n<html>\n\t<head>\n\t\t<title>标题</title>\n\t\t<meta http-equiv="Content-Type" content="text/html charset=UTF-8">\n\t</head>\n\t<body>\n\t</body>\n</html>'}
		};
		
		/**
		 * 查找属性
		 * @param 属性英文名称
		 */
		function queryProperty(ename){
			var propertyVo = {};
			var properties = scope.componentVO.properties;
			for(var i in properties){
				if(properties[i].ename === ename){
					propertyVo = properties[i];
					break;
				}
			}
			return propertyVo;
		}
		
		//保存
		function saveData(){
			try{
				var val = $.trim(editor.getValue());
				if(propertyType == 'String'){
					val = val.replace(/"/g, '\\"');
				}
			    window.parent[callbackMethod](propertyName, val);
			    window.parent.codeEditDialog.hide();
			}catch(err){ 
				console.log(err);
			}
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
		
		jQuery(document).ready(function(){
			var title = uitype + '_' + propertyName + '属性编辑';
			$("title").text(title);
	        comtop.UI.scan();
	        if(propertyType == 'Json'){
		        editor.setValue(jsCodeformatter(initValue));
	        	editorTmp.setValue(jsCodeformatter(defaultValues[uitype][propertyName]));
	        } else if (propertyType == 'String'){
		        cui("#codeformatterBtn").hide();
	        	editor.setValue(initValue.replace(/\\/g, ''));
	        	editorTmp.setValue(defaultValues[uitype][propertyName]);
	        }
	    });
	</script>
</body>
</html>

