<%@ page contentType="text/html; charset=GBK" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>流程跟踪表</title>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<style type="text/css">
		body,html{font-family:'Microsoft YaHei','Hiragino Sans GB',Helvetica,Arial,'Lucida Grande',sans-serif;}
		table {border: 0; width: 100%; height: 100%;}
		tbody {border: 0; width: 100%; height: 100%;}
		tr {border: 0;}
		.tr_current_node {width: 100%; height: 50px; background-color: #E9F5FE;}
		.tr_start_node {width: 100%; height: 44px; background-color: #FFFFFF;}
		.tr_nomal_node_with_background {width: 100%; height: 60px; background-color: #F5F5F5;}
		.tr_nomal_node_no_background {width: 100%; height: 60px;}
		.td_left {width: 20%; height: 100%; text-align: center; vertical-align: middle;padding-left:55px;}
		.td_middle {width: 50%; height: 100%;}
		.td_right {width: 30%; height: 100%; text-align: center;}
		.node_current {font-size: 12px; color: #333333; font-weight: bold; height: 50px; text-align:center; line-height:50px;}
		.node_font {font-size: 14px; color: #333333;}
		.user_font {font-size: 12px; color: #0077FF;}
		.elapse_time {font-size: 12px; color: #888888;}
		.operate {font-size: 12px; color: #333333;}
		.msg_font {font-size: 12px; color: #333333;}
		.message {font-size: 12px; color: #333333; font-weight: bold;line-height:12px;overflow:hidden;overflow-x:hidden;}
		.floatDiv{line-height:30px;font-size: 12px; color: #333333;text-align:middle;filter:alpha(opacity=50);-moz-opacity:0.5;opacity:0.5;width:160px; height:30px;background-color:#FFD700;}
	</style>
</head>
	<body>
	<script type='text/javascript' src="js/jquery-1.8.2.js"></script>
	<script type='text/javascript' src="js/enum-json.js"></script>
	<script type='text/javascript' src="js/underscore.js" ></script>
  	<script type='text/javascript' src='<%=request.getParameter("webRootUrl")%>/dwr/engine.js'></script>
  	<script type='text/javascript' src='<%=request.getParameter("webRootUrl")%>/dwr/interface/TrackDWR.js?t=<%=Math.random() %>'></script>
  	<script type='text/javascript' src="js/track.js?t=<%=Math.random() %>"></script>
		<table id="trackTable" cellpadding="0" cellspacing="0">
			
		</table>
	</body>
	<script>
	<%
	String processId = request.getParameter("processId");
	String processInsId = request.getParameter("processInsId"); 
	String trackKey = request.getParameter("trackKey"); 
	String webRootUrl = request.getParameter("webRootUrl");
	//String windowId = request.getParameter("windowId");
	%>
	var processId = "<%=processId%>";
	var processInsId = "<%=processInsId%>";
	var trackKey= "<%=trackKey%>";
	var webRootUrl = "<%=webRootUrl%>";
	var remoteRecorder = 0; //\u8bb0\u5f55\u534f\u4f5c\u8ddf\u8e2a\u70b9\u51fb\u7684\u6b21\u6570  协作跟踪点击次数记录

	
	//通过DWR去后台获取根据数据
	TrackDWR.handleUserTaskTrack(processId,processInsId,trackKey,function(trackData){
		if (trackData === "" || trackData === null) {
			$('#trackTable').hide();
			return false;
		}
		$('#trackTable').append(generateTrackTable(trackData, trackKey));
		$('#floatDiv').text("\u603b\u8017\u65f6\uff1a"+totalTime);
		$(".message").click(function() {
			copyToClipBoard(this.title);
		});
		/**var windowWidth = window.innerWidth;
		var windowHeight = window.innerHeight;
		$('#floatDiv').css("top", windowHeight*88/100);
		$('#floatDiv').css("left", windowWidth*75/100);
		if (totalTime && totalTime != null) {
			$('#floatDiv').css("display","block");
			$('#floatDiv').text("\u603b\u8017\u65f6\uff1a"+totalTime);
			if ($('#floatDiv').text().length > 10) {
				$('#floatDiv').attr("title",$('#floatDiv').text());
				//$('#floatDiv').text($('#floatDiv').text().substring(0,7)+"...");
			}
		}
		**/
	});
	
	function copyToClipBoard(s) {
		if(window.clipboardData){
			window.clipboardData.setData("Text", s);
			alert("\u5df2\u7ecf\u590d\u5236\u5230\u526a\u5207\u677f\uff01"+ "\n" + s);
		}else if(navigator.userAgent.indexOf("Opera") != -1){
			window.location = s;
		}else if(window.netscape){
			try{
				netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			}catch (e) {
				alert("\u88ab\u6d4f\u89c8\u5668\u62d2\u7edd\uff01\n\u8bf7\u5728\u6d4f\u89c8\u5668\u5730\u5740\u680f\u8f93\u5165'about:config'\u5e76\u56de\u8f66\n\u7136\u540e\u5c06'signed.applets.codebase_principal_support'\u8bbe\u7f6e\u4e3a'true'");
			}
			var clip = Components.classes['@mozilla.org/widget/clipboard;1'].createInstance(Components.interfaces.nsIClipboard);
			if (!clip) return;
			var trans = Components.classes['@mozilla.org/widget/transferable;1'].createInstance(Components.interfaces.nsITransferable);
			if (!trans) return;
			trans.addDataFlavor('text/plain');
			var str = Components.classes["@mozilla.org/supports-string;1"].createInstance(Components.interfaces.nsISupportsString);
			var copytext = s;
			str.data = copytext;
			trans.setTransferData("text/plain", str, copytext.length * 2);
			var clipid = Components.interfaces.nsIClipboard;
			if (!clip) return false;
			clip.setData(trans, null, clipid.kGlobalClipboard);
			alert("\u5df2\u7ecf\u590d\u5236\u5230\u526a\u5207\u677f\uff01" + "\n" + s);
		}
	}
	</script>
</html>