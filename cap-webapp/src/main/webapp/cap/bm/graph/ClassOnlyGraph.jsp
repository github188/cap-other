<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<title>模块内部资源关系</title>
<style>
	body {
		margin: 0;
	}
</style>
<!-- Sets the basepath for the library if not in same directory -->
<script type="text/javascript">
	mxBasePath = '.';
</script>
<link rel="stylesheet" type="text/css"
	href="<%=request.getContextPath()%>/cap/bm/common/cui/themes/default/css/comtop.ui.min.css" />
<link rel="stylesheet" type="text/css" href="css/grapheditor.css">
<link rel="stylesheet" type="text/css" href="css/common.css">
<script type="text/javascript"
	src="<%=request.getContextPath()%>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
<!-- Loads and initializes the library -->
<script type="text/javascript" src="js/mxClient.js"></script>
<script type="text/javascript" src="js/json2.js"></script>

<script type="text/javascript" src="js/Shapes.js"></script>
<script type='text/javascript'
	src='<%=request.getContextPath()%>/cap/dwr/engine.js'></script>
<script type='text/javascript'
	src='<%=request.getContextPath()%>/cap/dwr/util.js'></script>
<script type='text/javascript'
	src='<%=request.getContextPath()%>/cap/dwr/interface/GraphAction.js'></script>
<script type="text/javascript" src="js/json.js"></script>
<script type="text/javascript" src="js/classOnly.js"></script>

<!-- Example code -->
<script type="text/javascript">
	var moduleId = "${param.moduleId}";//模块ID
	function main(container) {
		//加上进度条
		cui.handleMask.show();

		// Checks if the browser is supported
		if (!mxClient.isBrowserSupported()) {
			// Displays an error message if the browser is not supported.
			mxUtils.error('Browser is not supported!', 200, false);
		} else {
			// Creates the graph inside the given container
			//var graph = createGraph(container);
			var graph = new mxGraph(container);
			setStyle(graph);
			//graph.setTooltips(true);
			graph.setEnabled(true);
						
			graph.isHtmlLabel = function(cell) {
				var state = this.view.getState(cell);
				var style = (state != null) ? state.style : this
						.getCellStyle(cell);

				return style['html'] == '1';
			};

			graph.getModel().beginUpdate();
			try {
				var doc = mxUtils.parseXml(getxml());
				var codec = new mxCodec(doc);
				codec.decode(doc.documentElement, graph.getModel());
			} finally {
				// Updates the display
				graph.getModel().endUpdate();
			}
		}
	};

	/**
	 * Creates and returns an empty graph inside the given container.
	 */
	function setStyle(graph) {
		graph.stylesheet.getDefaultVertexStyle()[mxConstants.STYLE_OVERFLOW] = 'hidden';
	};

	function getxml() {
		var requestData;
		dwr.TOPEngine.setAsync(false);
		GraphAction.queryModule(moduleId, function(data) {
			requestData = data;
		});
		cui.handleMask.hide();
		if(!requestData || !requestData.graphEntityVOs || requestData.graphEntityVOs.length == 0) {
			document.getElementById('noneGraph').style.display = "block";
			document.getElementById('graphContainer').style.overflow="hidden";
			return;
		}
		return getDisplayData(requestData);
	}
	
</script>
</head>

<!-- Page passes the container and control to the main function -->
<body onload="main(document.getElementById('graphContainer'));">
	<!-- Acts as a container for the graph -->
	<hr>
	<div id="graphContainer"
		style="overflow:-Scroll; width:98%; height:90%;">
		<h1 id="noneGraph" style="top:40%; left:30%; width:100%; height:20%;display:none">该模块无数据,无法显示！</h1>
	</div>
</body>
</html>
