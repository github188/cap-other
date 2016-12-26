<%@ include file="/top/component/common/Taglibs.jsp" %>

<html>
<head>
    <%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK" %>
    <%@ include file="/top/workbench/base/Header.jsp" %>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/app/css/app.css"/>
	<script type='text/javascript' src='${pageScope.cuiWebRoot}/cap/dwr/interface/SystemModelAction.js'></script>
    <title>CUI智能平台首页</title>
</head>
<body style="overflow: hidden">
<%@ include file="/cap/ptc/treeIndex/CIPMainNav.jsp" %>
 <div class="workbench-container box">
            <div class="myapp-container" id="myapp-container">
                <iframe id="mainIframe" name="mainIframe" marginwidth="0" scrolling="no"
			marginheight="0" frameborder="0" src="" style="display:block;width:100%;height:100%"></iframe>
            </div>

            <div class="goto-top" title="回到顶部"> </div>
        </div>
        
        <script type="text/javascript">
	        require([ 'jquery', 'cui', 'workbench/dwr/interface/WorkbenchUserDelegateAction'], function() {
				dwr.TOPEngine.setAsync(false);
	        	var moduleObj={"parentModuleId":"-1"};
	    		SystemModelAction.queryChildrenModule(moduleObj,function(data){
	    			var url = "";
	    			if(data == null || data == "") {
	    				url = "${pageScope.cuiWebRoot}/cap/bm/dev/systemmodel/NoRootMain.jsp"
	    			} else {
	    				url = "${pageScope.cuiWebRoot}/cap/bm/dev/systemmodel/SystemModelMain.jsp?fromTreePage=true";
	    			}
	    			$('#mainIframe').attr("src",url);  ;
	    	     });
	    		dwr.TOPEngine.setAsync(true);
			});
	        
	        var nodeData;
	        function clickIframeBack(node) {
	        	nodeData = node;
	        }
        
            //初始化页面最小高度
            $(window).resize(function(){
            	jQuery("#myapp-container").css("height",$(window).height()-90);
            }).resize();
        </script>
</body>
</html>
