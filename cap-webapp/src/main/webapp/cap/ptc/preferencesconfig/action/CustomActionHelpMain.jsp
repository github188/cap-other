<%
  /**********************************************************************
   * CAP自定义行为帮助
   *
   * 2016-10-31 肖威 新建
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<html >
<head>
<meta charset="UTF-8">
<title>自定义行为帮助</title>
<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>

<style type="text/css">
.cui-tab ul.cui-tab-nav li{
	padding:0 5px;
	margin-right:5px
}
</style>


<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
<top:script src="/cap/bm/dev/consistency/js/consistency.js"></top:script>
<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
<top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
<top:script src="/cap/bm/dev/page/uilibrary/js/component.js"></top:script>
<script type="text/javascript">

	jQuery(document).ready(function(){
		   jQuery("#tabBodyDiv").css("height",$(window).height()-61);
		   $(window).resize(function(){//开启监控，第一次初始化时，不会进入此方法
		      jQuery("#tabBodyDiv").css("height",$(window).height()-61);
		   });
	    	comtop.UI.scan();
	    	initPage();
	});
	//页面初始化函数
	function initPage(){
		initIframe();
	}
	
	//初始化iframe
	function initIframe(){
		jQuery("#imageHelpContent").attr("src","CustomActionImageHelp.jsp");
		jQuery("#docHelpContent").attr("src", "CustomActionDocHelp.jsp");
	}
	
	//tab页面选择
	function chooseHelp(tabId){
		var tabIds = ["imageHelp", "docHelp"];
		for(var i = 0; i< tabIds.length; i++){
			var tempTabId = tabIds[i];
			if(tabId == tempTabId){
				jQuery("#"+tempTabId+"Tab").css("background-color","");
				jQuery("#"+tempTabId+"Tab").addClass("cui-active");
				jQuery("#"+tempTabId+"Content").css("display","block");
			}else{
				jQuery("#"+tempTabId+"Tab").css("background-color","#f5f5f5");
				jQuery("#"+tempTabId+"Tab").removeClass("cui-active");
				jQuery("#"+tempTabId+"Content").css("display","none");
			}
		}
	}
	
	function closeWin(){
		window.close();
	}
</script>
</head>
<body  style="background-color:#f5f5f5">
<div class="cui-tab">
	<span class="tabs-scroller-left cui-icon" style="display: none;"></span>
 	<span class="tabs-scroller-right cui-icon" style="display: none; right: 22px;"></span>
	<div class="cui-tab-head" style="margin: 0px;font-size:11pt">
		<table  style="width:100%;border-spacing: 0px">
			<tr>
				<td style="text-align:left;padding:0px">
     						<ul class="cui-tab-nav" style="height:40px;width:100%;padding:0px 0 0 0px;background-color:#f5f5f5">
     							 <li id="imageHelpTab" title="图片说明" class="cui-active" style="width:65px;height:40px;line-height:40px;margin-left:8px" onclick="chooseHelp('imageHelp')">
     								<span class="cui-tab-title">图例说明</span>
     							</li>
     							 <li id="docHelpTab" title="文档说明" class=""  style="width:65px;height:40px;line-height:40px;margin-left:8px" onclick="chooseHelp('docHelp')">
     								<span class="cui-tab-title">文档说明</span>
     							</li>
     						</ul>
				</td>
				<td style="text-align:right;padding-right:0px;background-color:#f5f5f5">
						<span uitype="Button" id="closeButton" label="关闭"  onclick="closeWin();"></span>
				</td>
			</tr>
		</table>
	</div>
	<div  class="cui-tab-content"  id="tabBodyDiv" style="border-top:3px solid #4585e5">
		<iframe id="imageHelpContent" frameborder="0"  style="height: 100%; width: 100%; position: static; left: 0px; top: 0px;display:block"></iframe>
		<iframe id="docHelpContent" frameborder="0"  style="height: 100%; width: 100%; position: static; left: 0px; top: 0px;display:none"></iframe>
	</div>
</div>
</body>
</html>