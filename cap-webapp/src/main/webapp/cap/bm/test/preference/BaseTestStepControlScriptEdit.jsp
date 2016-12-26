<%
/**********************************************************************
* 基本测试步骤帮助编辑页面
* 2015-6-30 zhangzunzhi 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>基本测试步骤帮助编辑</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.editor.min.js"></top:script>
    <top:link href="/cap/bm/common/codemirror/lib/codemirror.css"></top:link>  
    <top:link href="/cap/bm/common/codemirror/theme/eclipse.css"></top:link>
    <top:link href="/cap/bm/common/codemirror/addon/hint/show-hint.css"></top:link>
    <top:link href="/cap/bm/common/codemirror/addon/display/fullscreen.css"></top:link>      
	<top:script src="/cap/bm/common/codemirror/lib/codemirror.js"></top:script>   
	<top:script src="/cap/bm/common/codemirror/mode/javascript/javascript.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/addon/hint/show-hint.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/addon/hint/javascript-hint.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/addon/display/fullscreen.js"></top:script>	
	<style type="text/css">
    	.codeArea{
    		width:98%; 
    		background: whitesmoke;
    		border-radius: 3.01px;
    		transition: border .3s linear 0s;
    		border: 1px solid #ccc;
    		padding:5px 0px 5px 0px;
    		margin: 25px 1px 5px 5px;
			-moz-transition:border .3s linear 0s;
			-webkit-transition:border .3s linear 0s;
			-o-transition:border .3s linear 0s
		}
		.CodeMirror {
			width:100%;
			height: auto;
			background: rgb(232, 229, 229);
		}
    </style> 
    <script type="text/javascript">
	var flag=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("flag"))%>;
	var componetId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("componetId"))%>;
	var index = parseInt(flag);
	var ctrlScript = window.parent.scope.arguments[index].ctrl.script==null?"":window.parent.scope.arguments[index].ctrl.script;
   var editor;
	
	window.onload = function(){
   	 
   	var textarea = document.getElementById("ctrlOptions");
   	 editor = CodeMirror.fromTextArea(textarea, { //script_once_code为你的textarea的ID号
   		       lineNumbers: true,//是否显示行号
   		       mode: {name: "javascript", globalVars: true},
   		       lineWrapping:true, //是否强制换行
               theme:'eclipse',
               viewportMargin:1000 //默认只显示11行数据，这里设置显示一千行数据
   		 });
   	editor.on('keypress', function(instance, event) {
        if(event.charCode>=46 || (event.charCode>=65 && event.charCode<=90) || (event.charCode>=97 && event.charCode<=122)){
            setTimeout(function(){
              editor.showHint();  //满足自动触发自动联想功能  
            },1)
        }         
    }); 
   	$("#code").find('.CodeMirror').css({background: "#F5F5F5"});//设置背景色
   	editor.setValue(ctrlScript);
   	console.log(ctrlScript);
   	comtop.UI.scan();
   	}
   	
   	
   	//确定保存数据
   	function saveCtrl(){
   		var ctrlScript = editor.getValue();//cui("#ctrlOptions").getValue();
   		window.parent.scope.arguments[index].ctrl.script = ctrlScript;
   		closeCtrl();
   	}
   	
   	//关闭窗口
   	function closeCtrl(){
   		window.parent.scriptDialog.hide();
   	}
	</script>
</head>
<style>
	.top_header_wrap{
		padding-right:5px;
	}
</style>
<body>
<div uitype="Borderlayout" id="body" is_root="true">	
		<div class="top_header_wrap" style="padding:10px 20px 10px 25px;">
			<div class="thw_operate" style="float:right;height: 28px;">
				<span uitype="button" id="saveCtrl" label="确定"  on_click="saveCtrl" ></span>
				<span uitype="button" id="closeCtrl" label="取消"  on_click="closeCtrl" ></span>
			</div>
		</div>
		<div id="code" class="codeArea" style="width:96%;height:585px;overflow:auto;">
		<textarea id="ctrlOptions" name="code"></textarea>
		<!--  <span uitype="Textarea" id="ctrlOptions" name="help" width="92%" height="300px"></span>-->
		</div>
</div>
</body>
</html>