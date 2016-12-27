<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<title>模块资源关系</title>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
<style>
	body{margin:0}
	.top_header_wrap {
		padding: 5px 0;
		height: 25px;
	}
	.thw_title{
		float:left;
		font:14px "宋体";
		margin-top:5px;
		margin-left:10px;
		font-weight:bold;
		color: #000;
	}
		
	.thw_operate{
		float:right;
	}
	
	.content{
		position: absolute;
		left:0px;
		top: 35px;
		bottom: 0px;
		right: 0px;
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

</head>
<body>
<div class="top_header_wrap" style="padding-top:3px">
	<div class="thw_title">
		<font id = "pageTittle" class="fontTitle">模块数据库ER图</font> 
	</div>
	<div class="thw_operate">
		<span uitype="button" id="new_same" label="返回"  on_click="returnToPage" ></span>
	</div>
</div>
<div class="content">
	<div id="graphContainer" class="geDiagramContainer" style="overflow:auto;width:100%;height: 100%;">
		<h1 id="noneGraph" style="top:40%; left:30%; width:100%; height:20%;display:none">该模块无数据,无法显示！</h1>
	</div>
</div>

<script type="text/javascript" src="<%=request.getContextPath()%>/cap/bm/graph/js/mxClient.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/cap/bm/graph/js/Shapes.js"></script>
<script type='text/javascript'
	src='<%=request.getContextPath()%>/cap/dwr/engine.js'></script>
<script type='text/javascript'
	src='<%=request.getContextPath()%>/cap/dwr/util.js'></script>
<script type='text/javascript'
	src='<%=request.getContextPath()%>/cap/dwr/interface/PdmFacade.js'></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/cap/bm/graph/js/er.js"></script>

<!-- Example code -->
<script type="text/javascript">
	var moduleId = "${param.moduleId}";//模块ID
	var moduleName = "${param.moduleName}";
	var title = moduleName + "数据库ER图";
	var returnUrl = "${param.returnUrl}";//模块ID
	
	//DOM加载完毕后，执行scan扫描生成组件
	comtop.UI.scan();
	
	function returnToPage(){
		window.open(returnUrl, '_self');
	}
	
	main(document.getElementById('graphContainer'));
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
		PdmFacade.exportPdm(moduleId, function(data) {
			requestData = data;
		});
		dwr.TOPEngine.setAsync(true);
		cui.handleMask.hide();
		
		var xml = getDisplayData(requestData);
		if(xml == null){
			document.getElementById('noneGraph').style.display = "block";
			document.getElementById('graphContainer').style.overflow="hidden";
			return;
		}
		return xml;
	}
	
</script>
</body>
</html>
