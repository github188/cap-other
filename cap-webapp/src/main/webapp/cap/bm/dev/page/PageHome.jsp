<%
    /**********************************************************************
	 * 新版界面
	 * 2015-10-11  诸焕辉  新建
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<html>
<head>
<meta charset="UTF-8">
<title>新版界面</title>
<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
<style type="text/css">
.cui-tab ul.cui-tab-nav li{
	padding:0 5px;
	margin-right:5px
}
</style>

<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
<top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
<top:script src="/cap/bm/dev/page/uilibrary/js/component.js"></top:script>
<top:script src='/cap/dwr/engine.js'></top:script>
<top:script src='/cap/dwr/util.js'></top:script>
<top:script src='/cap/dwr/interface/PageFacade.js'></top:script>
<top:script src='/cap/dwr/interface/NewPageAction.js'></top:script>
<top:script src='/cap/dwr/interface/ComponentFacade.js'></top:script>
<top:script src='/cap/dwr/interface/ComponentTypeFacade.js'></top:script>
<script type="text/javascript">
   var packageId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
   var selectedTabId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("selectedTabId"))%>;
   jQuery(document).ready(function(){
	   jQuery("#tabBodyDiv").css("height",$(window).height()-61);
	   $(window).resize(function(){//开启监控，第一次初始化时，不会进入此方法
	      jQuery("#tabBodyDiv").css("height",$(window).height()-61);
	   });
       comtop.UI.scan();
       initIframe();
   });
   
   //初始化iframe
   function initIframe(){
	   var attr = "packageId="+packageId;
       jQuery("#pageFrame").attr("src","designer/PageList.jsp?"+attr);
       jQuery("#metadataGenerateFrame").attr("src","template/MetadataGenerateList.jsp?"+attr);
       if(selectedTabId){
    	   tabClick(selectedTabId); 
       }
   }
   
   //tab页点击事件
   function tabClick(frameId){
	   var ar = ['page', 'metadataGenerate'];
	   for(var i=0;i<ar.length;i++){
		   if (frameId == ar[i]) {
			   jQuery("#"+ ar[i]+"Tab").css("background-color","");
			   jQuery("#"+ ar[i]+"Tab").addClass("cui-active");
               jQuery("#"+ ar[i]+"Frame").css("display", "block");

           } else {
        	   jQuery("#"+ ar[i]+"Tab").css("background-color","#f5f5f5");
               jQuery("#"+ ar[i]+"Tab").removeClass("cui-active");
               jQuery("#"+ ar[i]+"Frame").css("display", "none");
           }
	   }
   }
   
</script>
</head>
<body style="background-color:#f5f5f5">
 	<div class="cui-tab" style="border:solid 1px #e6e6e6;background:#f5f5f5">
 		<span class="tabs-scroller-left cui-icon" style="display: none;"></span>
 		<span class="tabs-scroller-right cui-icon" style="display: none; right: 22px;"></span>
        <div class="cui-tab-head" style="margin: 0px;font-size:11pt">
        	<table style="width:100%;border-spacing: 0px">
        		<tr>
        			<td style="text-align:left;padding:0px">
        				<ul class="cui-tab-nav" style="height:40px;width:100%;padding:0px 0 0 0px;background-color:#f5f5f5">
			                <li id="pageTab" title="页面" class="cui-active" style="width:85px;height:40px;line-height:40px;margin-left:8px" onclick="tabClick('page')">
			                	<span class="cui-tab-title">页面</span>
			                    <a href="#" class="cui-tab-close cui-icon" style="display:none;"></a>
			                </li>
			                <li id="metadataGenerateTab" title="模版界面" class="" style="width:85px;height:40px;line-height:40px;background-color:#f5f5f5" onclick="tabClick('metadataGenerate')">
			                	<span class="cui-tab-title">模版界面</span>
			                	<a href="#" class="cui-tab-close cui-icon" style="display:none;"></a>
			                </li>
			            </ul>
        			</td>
        		</tr>
        	</table>
        </div>
        <div class="cui-tab-content" id="tabBodyDiv" style="border-top:3px solid #4585e5">
        	<iframe id="pageFrame" frameborder="0" style="height: 100%; width: 100%; position: static; left: 0px; top: 0px;display:block"></iframe>
        	<iframe id="metadataGenerateFrame" frameborder="0" style="height: 100%; width: 100%; position: static; left: 0px; top: 0px;display:none"></iframe>
        </div>
   	</div>
</body>
</html>
