<!DOCTYPE HTML>
<%/****************************************************************************
	* 流程跟踪表页面
	* 2014-07-28 李欢 新建
	*****************************************************************************/%>
<%@ page contentType="text/html; charset=GBK" %>
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
	<div id="message_box" style="position:absolute;left:350px;top:160px;width:500px;height:450px;
		filter:dropshadow(color=#666666,offx=3,offy=3,positive=2);z-index:1000; visibility:hidden">
		<div id= "message" style="border:1px #e6e7eb solid;width:95%; height:95%; background:#fff; color:#036; line-height:150%; border-top-left-radius: 7px;border-top-right-radius: 7px; 	border-bottom-right-radius: 7px;border-bottom-left-radius: 7px;">
		<!-- DIV弹出状态行：标题、关闭按钮 -->
			<div style="background:#e6e7eb; height:8%;font-family:Verdana, Arial, Helvetica, sans-serif;" >
				<span style="display:inline;width:100px; text-align:left;font-size:15px; float:left; font-weight:bold; padding-top:3px;padding-bottom:5px;">意见详情</span>
				<div style="display:inline; cursor:pointer" onclick="closeProc()">
					<span style="float:right;font-size:140%">×</span>
				</div>
			</div>
			<div id="msgDetail" style="width:100%;height:92%;overflow:auto;overflow-x:hidden;float:left;font-size:12px;" >				
			</div>
		</div>
	</div>
	<script type='text/javascript' src="js/bpmsTrack.js"></script>
	<script type='text/javascript' src="js/jquery-1.8.2.js"></script>
	<script type='text/javascript' src="js/enum-json.js"></script>
	<script type='text/javascript' src="js/underscore.js" ></script>
  	<script type='text/javascript' src='<%=request.getParameter("webRootUrl")%>/dwr/engine.js'></script>
  	<script type='text/javascript' src='<%=request.getParameter("webRootUrl")%>/dwr/interface/TrackDWR.js'></script>
	<script>
		/*-------------------------鼠标拖动---------------------*/
		var posX;
		var posY;
		var Idiv = document.getElementById("message_box");
		Idiv.onmousedown=function(e)
		{
			if(!e) e = window.event; //IE
			posX = e.clientX - parseInt(Idiv.style.left);
			posY = e.clientY - parseInt(Idiv.style.top);
			document.onmousemove = mousemove;
		}
		document.onmouseup = function()
		{
			document.onmousemove = null;
		}
		function mousemove(ev)
		{
			if(ev==null) ev = window.event;//IE
			Idiv.style.left = (ev.clientX - posX) + "px";
			Idiv.style.top = (ev.clientY - posY) + "px";			
		}
		<%
		String processId = request.getParameter("processId");
		String processInsId = request.getParameter("processInsId"); 
		String trackKey = request.getParameter("trackKey"); 
		String webRootUrl = request.getParameter("webRootUrl");
		String windowId = request.getParameter("windowId");
		%>
		var processId = "<%=processId%>";
		var processInsId = "<%=processInsId%>";
		var trackKey= "<%=trackKey%>";
		var webRootUrl = "<%=webRootUrl%>";
		var windowId = "<%=windowId%>";
		document.getElementById("windowId").value = windowId;

		//通过DWR去后台获取根据数据
		TrackDWR.handleTrack(processId,processInsId,trackKey,function(returnData){
			if (returnData === "" || returnData === null) {
				return false;
			}
            $('#loading_div').hide();
            $("#flowContentUl").html(getMainHTML(returnData,""));
		});
	</script>
</body>
</html>