<html>
<head>
    <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
    <%@ include file="/cap/bm/dev/main/header.jsp" %>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/app/css/app.css"/>
	<script type='text/javascript' src='${pageScope.cuiWebRoot}/cap/dwr/interface/SystemModelAction.js'></script>
    <title>CUI智能平台首页</title>
</head>
<body style="overflow: hidden">
 <div class="workbench-container box" style="height: 100%">
            <div class="myapp-container" id="myapp-container">
                <iframe id="buildframe" name="buildframe" marginwidth="0" scrolling="no"
			marginheight="0" frameborder="0" src="" style="display:block;width:100%;height:100%"></iframe>
            </div>

            <div class="goto-top" title="回到顶部"> </div>
        </div>
        
        <script type="text/javascript">
	        require([ 'jquery', 'cui'], function() {
				dwr.TOPEngine.setAsync(false);
	        	var moduleObj={"parentModuleId":"-1"};
	    		SystemModelAction.queryChildrenModule(moduleObj,function(data){
	    			var url = "";
	    			if(data == null || data == "") {
	    				url = "${pageScope.cuiWebRoot}/cap/bm/dev/systemmodel/NoRootMain.jsp"
	    			} else {
	    				url = "${pageScope.cuiWebRoot}/cap/bm/dev/systemmodel/SystemModelMain.jsp";
	    			}
	    			$('#buildframe').attr("src",url);  ;
	    	     });
	    		dwr.TOPEngine.setAsync(true);
			});
	        
	        var nodeData;
	        function clickIframeBack(node) {
	        	nodeData = node;
	        }
        
            $(".workbench-container").css("height", $(window).height()-20);
            //初始化页面最小高度
            $(window).resize(function(){
            	var winHeight = $(window).height();
            	jQuery("#myapp-container").css("height", winHeight-10);
            	jQuery(".workbench-container").css("height", winHeight-20);
            });
            
        </script>
</body>
</html>
