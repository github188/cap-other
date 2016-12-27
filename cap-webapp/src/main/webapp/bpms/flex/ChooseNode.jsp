<%@ page contentType="text/html; charset=GBK"%>

<!-- saved from url=(0014)about:internet -->
<html lang="en">

<!--
Smart developers always View Source.

This application was built using Adobe Flex, an open source framework
for building rich Internet applications that get delivered via the
Flash Player or to desktops via Adobe AIR.

Learn more about Flex at http://flex.org
// -->

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<!--  BEGIN Browser History required section -->
<link rel="stylesheet" type="text/css" href="history/history.css" />
<!--  END Browser History required section -->

<title>&#x6d41;&#x7a0b;&#x8ddf;&#x8e2a;</title>
<script src="AC_OETags.js" language="javascript"></script>

<!--  BEGIN Browser History required section -->
<script src="history/history.js" language="javascript"></script>
<!--  END Browser History required section -->

<style>
body { margin: 0px; overflow:hidden }
</style>
<script language="JavaScript" type="text/javascript">
<!--
// -----------------------------------------------------------------------------
// Globals
// Major version of Flash required
var requiredMajorVersion = 10;
// Minor version of Flash required
var requiredMinorVersion = 0;
// Minor version of Flash required
var requiredRevision = 0;
// -----------------------------------------------------------------------------
// -->

var moduleId = "${param.moduleCode}";//模块ID
var height = "${param.height}";//自定义岗位选择界面高度
var postId = "${param.postId}";//岗位ID
var userId = "${param.userId}";//用户ID
var postName = decodeURIComponent(decodeURIComponent("${param.postName}"));//岗位名称
var deptName = decodeURIComponent(decodeURIComponent("${param.orgName}"));//部门名称
var userName = decodeURIComponent(decodeURIComponent("${param.userName}"));//用户名称
</script>
</head>

<body scroll="no" onload="setHeight();" onresize="setHeight();">
<script language="JavaScript" type="text/javascript">

<!--
function setHeight(){
	if (height=="undefined" || height==null || height==""){
		ChooseNode.percentHeight = 100;
	}else{
		ChooseNode.height = height;
	}
}

// Version check for the Flash Player that has the ability to start Player Product Install (6.0r65)
var hasProductInstall = DetectFlashVer(6, 0, 65);

// Version check based upon the values defined in globals
var hasRequestedVersion = DetectFlashVer(requiredMajorVersion, requiredMinorVersion, requiredRevision);

if ( hasProductInstall && !hasRequestedVersion ) {
	// DO NOT MODIFY THE FOLLOWING FOUR LINES
	// Location visited after installation is complete if installation is required
	var MMPlayerType = (isIE == true) ? "ActiveX" : "PlugIn";
	var MMredirectURL = window.location;
    document.title = document.title.slice(0, 47) + " - Flash Player Installation";
    var MMdoctitle = document.title;

	AC_FL_RunContent(
		"src", "playerProductInstall",
		"FlashVars", "MMredirectURL="+MMredirectURL+'&MMplayerType='+MMPlayerType+'&MMdoctitle='+MMdoctitle+"",
		"width", "100%",
		//"height", "100%",
		"height", "100%",
		"align", "middle",
		"flashVars", "webRootUrl=<%=request.getParameter("webRootUrl")%>",
		"wmode", "opaque",
		"id", "ChooseNode",
		"quality", "high",
		"bgcolor", "#ffffff",
		"name", "ChooseNode",
		"allowScriptAccess","sameDomain",
		"type", "application/x-shockwave-flash",
		"pluginspage", "http://www.adobe.com/go/getflashplayer"
	);
} else if (hasRequestedVersion) {
	// if we've detected an acceptable version
	// embed the Flash Content SWF when all tests are passed
	AC_FL_RunContent(
			"src", "ChooseNode",
			"width", "100%",
			//"height", "100%",
			"height", "100%",
			"align", "middle",
			"flashVars", "webRootUrl=<%=request.getParameter("webRootUrl")%>",
			"id", "ChooseNode",
			"quality", "high",
			"bgcolor", "#ffffff",
			"name", "ChooseNode",
			"allowScriptAccess","sameDomain",
			"type", "application/x-shockwave-flash",
			"pluginspage", "http://www.adobe.com/go/getflashplayer"
	);
  } else {  // flash is too old or we can't detect the plugin
    var alternateContent = 'Alternate HTML content should be placed here. '
  	+ 'This content requires the Adobe Flash Player. '
   	+ '<a href=http://www.adobe.com/go/getflash/>Get Flash</a>';
    document.write(alternateContent);  // insert non-flash content
  }

  function onNsRightClick(e){
if(e.which == 3){
   ChooseNode.openRightClick(e.clientX,e.clientY);
   e.stopPropagation();
}
return false;
}

function onIeRightClick(e){
if(event.button > 1){
   ChooseNode.openRightClick(event.clientX,event.clientY);
   parent.frames.location.replace('javascript: parent.falseframe');
}
return false;
}


if(navigator.appName == "Netscape"){
document.captureEvents(Event.MOUSEDOWN);
document.addEventListener("mousedown", onNsRightClick, true);
}
else{
document.onmousedown=onIeRightClick;
}

function startChooseNode(){
	ChooseNode.receiveParam(moduleId,postId,postName,deptName,userId,userName);
}
// -->
</script>

<%--
<noscript>
  	<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
			id="ChooseNode" width="100%" height="100%"
			codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">
			<param name="movie" value="ChooseNode.swf" />
			<param name="quality" value="high" />
			<param name="bgcolor" value="#ffffff" />
			<param name="allowScriptAccess" value="always" />
			<param name="flashVars" value="webRootUrl=<%=request.getParameter("webRootUrl")%>"/>
			<embed src="ChooseNode.swf"  quality="high" bgcolor="#ffffff"
				width="100%" height="100%" name="ChooseNode" align="middle"
				play="true"
				loop="false"
				quality="high"
				allowScriptAccess="sameDomain"
				FlashVars="webRootUrl=<%=request.getParameter("webRootUrl")%>"
				type="application/x-shockwave-flash"
				pluginspage="http://www.adobe.com/go/getflashplayer">
			</embed>
	</object>
</noscript>
--%>

</body>
</html>
