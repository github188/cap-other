<!-- saved from url=(0014)about:internet -->
<%@ page contentType="text/html; charset=GBK" %>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="shortcut icon" href="../../cap/ptc/index/image/deploy.png">
<!--  BEGIN Browser History required section -->
<link rel="stylesheet" type="text/css" href="history/history.css" />
<!--  END Browser History required section -->

<title>&#x4e1a;&#x52a1;&#x6d41;&#x7a0b;&#x76d1;&#x63a7;&#x7ba1;&#x7406;&#x5e73;&#x53f0;</title>
<script src="AC_OETags.js" language="javascript"></script>

<!--  BEGIN Browser History required section -->
<script src="history/history.js" language="javascript"></script>
<script src="MonitorUI.js" language="javascript"></script>
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
</script>
</head>

<body scroll="no">
<script language="JavaScript" type="text/javascript">
<!--
// Version check for the Flash Player that has the ability to start Player Product Install (6.0r65)
var hasProductInstall = DetectFlashVer(6, 0, 65);

// Version check based upon the values defined in globals
var hasRequestedVersion = DetectFlashVer(requiredMajorVersion, requiredMinorVersion, requiredRevision);

if ( hasProductInstall && !hasRequestedVersion ) {
	// DO NOT MODIFY THE FOLLOWING FOUR LINES
	// Location visited after installation is complete if installation is required
	var MMPlayerType = (isIE == true) ? "ActiveX" : "PlugIn";
	var MMredirectURL = encodeURI(window.location);
    document.title = document.title.slice(0, 47) + " - Flash Player Installation";
    var MMdoctitle = document.title;
	AC_FL_RunContent(
		"src", "playerProductInstall",
		"FlashVars", "MMredirectURL="+MMredirectURL+'&MMplayerType='+MMPlayerType+'&MMdoctitle='+MMdoctitle+"",
		"width", "100%",
		"height", "100%",
		"align", "middle",
		"wmode", "opaque",
		"id", "DesignerUI",
		"quality", "high",
		"bgcolor", "#869ca7",
		"name", "DesignerUI",
		"allowScriptAccess","sameDomain",
		"type", "application/x-shockwave-flash",
		"pluginspage", "http://www.adobe.com/go/getflashplayer"
	);
} else if (hasRequestedVersion) {
	// if we've detected an acceptable version
	// embed the Flash Content SWF when all tests are passed
	AC_FL_RunContent(
			"src", "DesignerUI",
			"width", "100%",
			"height", "100%",
			"align", "middle",
			"flashVars", "perID=<%=request.getParameter("perID")%>&perAct=<%=request.getParameter("perAct")%>&perPwd=<%=request.getParameter("perPwd")%>&perAlias=<%=request.getParameter("perAlias")%>&webRootUrl=<%=request.getParameter("webRootUrl")==null?request.getContextPath():request.getParameter("webRootUrl")%>&fileType=<%=request.getParameter("fileType")%>&operateType=<%=request.getParameter("operateType")%>&deployId=<%=request.getParameter("deployId")%>",
			"id", "DesignerUI",
			"wmode", "opaque",
			"quality", "high",
			"bgcolor", "#869ca7",
			"name", "DesignerUI",
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
// -->
</script>
<noscript>
  	<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
			id="DesignerUI" width="100%" height="100%"
			codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">
			<param name="movie" value="DesignerUI.swf" />
			<param name="quality" value="high" />
			<param name="bgcolor" value="#869ca7" />
			<param name="allowScriptAccess" value="sameDomain" />
			<param name="flashVars" value="perID=<%=request.getParameter("perID")%>&perAct=<%=request.getParameter("perAct")%>&perPd=<%=request.getParameter("perPwd")%>&perAlias=<%=request.getParameter("perAlias")%>&webRootUrl=<%=request.getParameter("webRootUrl")==null?request.getContextPath():request.getParameter("webRootUrl")%>&fileType=<%=request.getParameter("fileType")%>&operateType=<%=request.getParameter("operateType")%>&deployId=<%=request.getParameter("deployId")%>"/>
			<embed src="DesignerUI.swf" quality="high" bgcolor="#869ca7"
				width="100%" height="100%" name="DesignerUI" align="middle"
				play="true"
				loop="false"
				quality="high"
				allowScriptAccess="sameDomain"
				FlashVars="perID=<%=request.getParameter("perID")%>&perAct=<%=request.getParameter("perAct")%>&perPd=<%=request.getParameter("perPwd")%>&perAlias=<%=request.getParameter("perAlias")%>&webRootUrl=<%=request.getParameter("webRootUrl")==null?request.getContextPath():request.getParameter("webRootUrl")%>&fileType=<%=request.getParameter("fileType")%>&operateType=<%=request.getParameter("operateType")%>&deployId=<%=request.getParameter("deployId")%>"
				type="application/x-shockwave-flash"
				swLiveConnect="true"
				pluginspage="http://www.adobe.com/go/getflashplayer">
			</embed>
	</object>
</noscript>
</body>
</html>
