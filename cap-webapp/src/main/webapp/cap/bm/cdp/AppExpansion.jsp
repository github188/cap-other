<%
    /**********************************************************************
	 * 调整副本个数
	 * 2016-09-30  李小芬  新建
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/rt/common/CapRtTaglibs.jsp" %>
<html>
<head>
<title>调整副本个数</title>
<top:link href="/cap/bm/common/top/css/top_base.css"/>
<top:link href="/cap/rt/common/cui/themes/default/css/comtop.ui.min.css"/>
<top:script src='/cap/rt/common/cui/js/comtop.ui.min.js'></top:script>
<top:script src='/cap/rt/common/base/js/jquery.js'></top:script>
<top:script src='/cap/rt/common/base/js/comtop.cap.rt.js'></top:script>
<top:script src='/cap/rt/common/cui/js/cui.utils.js'></top:script>
<top:script src='/cap/rt/common/globalVars.js'></top:script>
<top:script src='/cap/dwr/engine.js'></top:script>
<top:script src='/cap/dwr/util.js'></top:script>
<top:script src='/cap/dwr/interface/EvcontralListPageAction.js'></top:script>
<style type="text/css">
</style>
</head>
<body>
	<div class="top_header_wrap">
		<div id="top_float_right" class="thw_operate" style="margin-right: 3px"   >
		   <span uitype="button" label="确定"  id="operateId" on_click="expansionApp"></span>
           <span uitype="button" label="关闭" on_click="closeSelf"></span>
		</div>
	</div>
	<div class="top_content_wrap">
	  <table class="form_table">
	  	<colgroup>
				<col width="30%" />
				<col width="70%" />
		</colgroup>
         <tr>    
			<td class="td_label"><span class="top_required">*</span>副本个数：</td>     
			<td><span id="podCount"  uitype="Input" name="podCount"  maxlength="2" mask="Num"
			    validate="[{'type':'required', 'rule':{'m': '副本个数不能为空。'}}]" readonly=false width="100%"></span></td>
         </tr>
		</table>
	</div>
<script type='text/javascript'>
var rcName = '${param.rcName}';
var podCount = '${param.podCount}';
//初始化
window.onload = function(){
	//初始化页面
    comtop.UI.scan();
	cui("#podCount").setValue(podCount);
}

//保存方法
function expansionApp(){
    //验证消息
    var map = window.validater.validAllElement();	
    var inValid = map[0];
    if (inValid.length === 0){
    	EvcontralListPageAction.expansionApp(rcName,cui("#podCount").getValue(),{
			callback:function(){
		 			closeSelf(); 
		 			window.parent.gridReload(rcName);
		 			window.parent.cui.message('调整副本数成功。', 'success');
			},
			 errorHandler:function(message){
				 closeSelf(); 
				 window.parent.cui.error("调整副本数出错。");
			},
			 timeout:30000
		});
	}
}
	
//关闭窗口
function closeSelf(){
	window.parent.dialog.hide();
}

//grid 宽度
function areaResizeWidth(){
	return (document.documentElement.clientWidth || document.body.clientWidth) - 70;
}


</script>
</body>
</html>