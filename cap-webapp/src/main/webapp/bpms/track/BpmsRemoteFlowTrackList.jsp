<!DOCTYPE HTML>
<%/****************************************************************************
	* 流程跟踪表页面
	* 2014-09-22 李欢 新建
	*****************************************************************************/%>
<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>
	<title>流程跟踪表</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <link rel="stylesheet" type="text/css" href="css/BpmsTrack.css" />
</head>
  <body>
  	<input id="windowId" type="hidden"></input>
    <div class="card-dailog" id="flow-list">
        <div id="loading_div" style="position: absolute; top: 45%; left: 45%;">
            <img style="display:block;margin:0 auto"alt="正在加载..." src="images/loader.gif" >
            <span style="display:block">正在加载...</span>
        </div>
        <table id="flowContentUl" style="list-style: none;margin:0;padding:5"></table>
	</div>
	<script type='text/javascript' src="js/bpmsTrack.js"></script>
	<script type='text/javascript' src="js/jquery-1.8.2.js"></script>
	<script type='text/javascript' src="js/enum-json.js"></script>
	<script type='text/javascript' src="js/underscore.js" ></script>
  	<script type='text/javascript' src='<%=request.getParameter("webRootUrl")%>/dwr/engine.js'></script>
  	<script type='text/javascript' src='<%=request.getParameter("webRootUrl")%>/dwr/interface/TrackDWR.js'></script>
	<script>
		<%
		String processId = request.getParameter("processId");
		String trackType = request.getParameter("trackType");
		String processInsId = request.getParameter("processInsId"); 
		String trackKey = request.getParameter("trackKey"); 
		String curNodeInsId = request.getParameter("curNodeInsId");
		String curNodeId = request.getParameter("curNodeId");
		String webRootUrl = request.getParameter("webRootUrl");
		String windowId = request.getParameter("windowId");
		%>
		var processId = "<%=processId%>";
		var trackType = "<%=trackType%>";
		var processInsId = "<%=processInsId%>";
		var trackKey= "<%=trackKey%>";
		var curNodeInsId= "<%=curNodeInsId%>";
		var curNodeId= "<%=curNodeId%>";
		var webRootUrl = "<%=webRootUrl%>";
		var windowId = "<%=windowId%>";
		document.getElementById("windowId").value = windowId;
		if(trackType == 4){
			//通过DWR去后台获取根据数据
			TrackDWR.getRemoteReceTrack(curNodeInsId,trackKey,function(returnData){
				$('#loading_div').hide();
				if (returnData === "" || returnData === null) {
					$("#flowContentUl").html("<div class='card-dailog'><span style='display:block'>未查询到远端流程数据，可能是网络中断或者是远端流程未审批完成！</span></div>");
					return false;
				}
	            $("#flowContentUl").html(getMainHTML(returnData,""));
			});
		}else{
			//通过DWR去后台获取根据数据
			TrackDWR.getRemoteSendTrack(processInsId,curNodeId,trackKey,function(returnData){
				$('#loading_div').hide();
				if (returnData === "" || returnData === null) {
					$("#flowContentUl").html("<div class='card-dailog'><span style='display:block'>未查询到远端流程数据，可能是网络中断或者是远端流程未审批完成！</span></div>");
					return false;
				}
	            $("#flowContentUl").html(getMainHTML(returnData,""));
			});
		}
	</script>
</body>
</html>