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
<script type="text/javascript" src="js/class.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/top/js/jquery.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/graph/js/base64.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/graph/js/ExportImage.js"></script>

<!-- Example code -->
<script type="text/javascript">
	var moduleId = "${param.moduleId}";//模块ID
	
	var moduleName;
	dwr.TOPEngine.setAsync(false);
	GraphAction.queryGraphModuleNameByModuleId(moduleId, function(data) {
		moduleName = data.moduleName;
	});
	dwr.TOPEngine.setAsync(true);
	
	var graph;
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
			graph = new mxGraph(container);
			setStyle(graph);
			graph.setTooltips(true);
			graph.setEnabled(true);
			
			graph.addListener(mxEvent.DOUBLE_CLICK, function(sender, evt) {
		    	var cell = evt.getProperty('cell');
		        if(cell == undefined){
		        	evt.consume();
		            return;
		        }
				
		        if(isEntityRelaModule(cell)) {
		            //打开模块关系图
		            var relaModuleId = cell.moduleId;
		            var relaTitle = cell.value + "资源关系";
		            parent.cui("#moduleRelationTab").addTab({title:relaTitle,url: 'ClassRelationGraph.jsp?moduleId=' + relaModuleId, closeable: true});
		            parent.cui("#moduleRelationTab").switchTo(parent.cui("#moduleRelationTab").contents.length - 1);
		        }
		                
		        evt.consume();
		        function isEntityRelaModule(cell) {
		        	var state = graph.view.getState(cell);
		        	var style = (state != null) ? state.style : graph.getCellStyle(cell);
		        	return style['entityFromDiagram'] == '1' || style['entityToDiagram'] == '1';
		       	};  
		   	});
			
			graph.isHtmlLabel = function(cell) {
				var state = this.view.getState(cell);
				var style = (state != null) ? state.style : this
						.getCellStyle(cell);

				return style['html'] == '1';
			};

			graph.isCellFoldable = function(cell, collapse) {
				var isCellFoldable = mxGraph.prototype.isCellFoldable.apply(
						this, arguments);
				if (isCellFoldable) {
					return isCellFoldable;
				}
				var state = this.view.getState(cell);
				var style = (state != null) ? state.style : this
						.getCellStyle(cell);
				return style['classDiagram'] == '1';
			};

			// Scroll events should not start moving the vertex
			graph.cellRenderer.isLabelEvent = function(state, evt) {
				var source = mxEvent.getSource(evt);

				// FIXME: No scroll events in GC
				return state.text != null
						&& source != state.text.node
						&& source != state.text.node
								.getElementsByTagName('div')[0];
			};

			var oldRedrawLabel = graph.cellRenderer.redrawLabel;
			graph.cellRenderer.redrawLabel = function(state) {
				oldRedrawLabel.apply(this, arguments); // "supercall"
				var graph = state.view.graph;
				var style = state.style;
				if (style['classDiagram'] == '1' && state.text != null) {
					var s = graph.view.scale;
					var div = state.text.node.getElementsByTagName('div')[0];

					if (div != null) {
						div.style.overflow = "hidden";
						div.style.width = '100%';
						div.style.height = (state.height / s) + 'px';
						div.style.zoom = s;

					}
				}
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
			var pageLayer = graph.getModel().getCell("3");
			var processLayer = graph.getModel().getCell("4");
			var databaseLayer = graph.getModel().getCell("5");
			var fromModuleLayer = graph.getModel().getCell("6");
			var toModuleLayer = graph.getModel().getCell("7");
			
			var graphPage = document.getElementById('graphPage');
			graphPage.onclick = function(){
				graph.getModel().beginUpdate();
				try{
					graph.getModel().setVisible(pageLayer, this.checked);
					graph.view.invalidate();
				}finally{
					graph.getModel().endUpdate();
				}
			}
			
			var graphProcess = document.getElementById('graphProcess');
			graphProcess.onclick = function(){
				graph.getModel().beginUpdate();
				try{
					graph.getModel().setVisible(processLayer, this.checked);
					graph.view.invalidate();
				}finally{
					graph.getModel().endUpdate();
				}
			}
			
			var graphDatabase = document.getElementById('graphDatabase');
			graphDatabase.onclick = function(){
				graph.getModel().beginUpdate();
				try{
					graph.getModel().setVisible(databaseLayer, this.checked);
					graph.view.invalidate();
				}finally{
					graph.getModel().endUpdate();
				}
			}
			
			var graphFromModule = document.getElementById('graphFromModule');
			graphFromModule.onclick = function(){
				graph.getModel().beginUpdate();
				try{
					graph.getModel().setVisible(fromModuleLayer, this.checked);
					graph.view.invalidate();
				}finally{
					graph.getModel().endUpdate();
				}
			}
			
			var graphToModule = document.getElementById('graphToModule');
			graphToModule.onclick = function(){
				graph.getModel().beginUpdate();
				try{
					graph.getModel().setVisible(toModuleLayer, this.checked);
					graph.view.invalidate();
				}finally{
					graph.getModel().endUpdate();
				}
			}
		}
		
		$("svg").each(function(i){//去除滚动条
        	this.style.height = "99%";
        });
	};

	/**
	 * Creates and returns an empty graph inside the given container.
	 */
	function setStyle(graph) {
		style = [];
		style[mxConstants.STYLE_SHAPE] = mxConstants.SHAPE_SWIMLANE;
		style[mxConstants.STYLE_PERIMETER] = mxPerimeter.RectanglePerimeter;
		style[mxConstants.STYLE_STROKECOLOR] = 'gray';
		style[mxConstants.STYLE_FONTCOLOR] = 'black';
		style[mxConstants.STYLE_FILLCOLOR] = '#E0E0DF';
		style[mxConstants.STYLE_GRADIENTCOLOR] = 'white';
		style[mxConstants.STYLE_ALIGN] = mxConstants.ALIGN_CENTER;
		style[mxConstants.STYLE_VERTICAL_ALIGN] = mxConstants.ALIGN_TOP;
		style[mxConstants.STYLE_STARTSIZE] = 24;
		style[mxConstants.STYLE_FONTSIZE] = '12';
		style[mxConstants.STYLE_FONTSTYLE] = 1;
		style[mxConstants.STYLE_HORIZONTAL] = true;
		graph.getStylesheet().putCellStyle('swimlane', style);

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
	
	var isChrome = window.navigator.userAgent.indexOf("Chrome") !== -1;
	
	function exportToImage(){
		if (isChrome) {
			var svg = $("svg:first")[0];
			var fileName = "资源关系图-" + moduleName + ".png";
			saveSvgAsPng(svg, fileName);
		}else{
			var bounds = graph.getGraphBounds(); 
			var w = Math.round(bounds.x + bounds.width + 30); 
			var h = Math.round(bounds.y + bounds.height + 30); 
			exportImageForm.imageXML.value = getImageXML();
			exportImageForm.fileName.value = encodeURIComponent("资源关系图-" + moduleName);
			exportImageForm.width.value = w;
			exportImageForm.height.value = h;
			exportImageForm.format.value = "png";
			exportImageForm.submit();
		}
	}

	function getImageXML(){
		var xmlDoc = mxUtils.createXmlDocument(); 
		var root = xmlDoc.createElement('output'); 
		xmlDoc.appendChild(root);
		var xmlCanvas = new mxXmlCanvas2D(root); 
		var imgExport = new mxImageExport(); 
		imgExport.drawState(graph.getView().getState(graph.model.root), xmlCanvas); 
		var xml = mxUtils.getXml(root);
		xml = "<output>" + xml + "</output>";
		return xml = encodeURIComponent(xml);//这就是要提交到后台的xml代码
	}
	
</script>
</head>

<!-- Page passes the container and control to the main function -->
<body onload="main(document.getElementById('graphContainer'));">
	<div id="graphImg" style="height: 24px;padding-left:30px;cursor: default;">
		<label style="font-size:12;vertical-align:middle;">实体</label><img src="images/legend_class.png" style="vertical-align:middle;padding-right:5px;"/>
		<label style="font-size:12;vertical-align:middle;"><input id="graphPage" name="page" type="checkbox" value="" style="vertical-align:middle;" checked/>页面</label><img src="images/legend_page.png" style="vertical-align:middle;padding-right:5px;"/>
		<label style="font-size:12;vertical-align:middle;"><input id="graphProcess" name="process" type="checkbox" value="" style="vertical-align:middle;" checked/>流程</label><img src="images/legend_process.png"  style="vertical-align:middle;padding-right:5px;"/>
		<label style="font-size:12;vertical-align:middle;"><input id="graphDatabase" name="database" type="checkbox" value="" style="vertical-align:middle;" checked/>数据库</label><img src="images/legend_database.png"  style="vertical-align:middle;padding-right:5px;"/>
		<label style="font-size:12;vertical-align:middle;"><input id="graphFromModule" name="fromModule" type="checkbox" value="" style="vertical-align:middle;" checked/>依赖模块</label><img src="images/legend_module.png"  style="vertical-align:middle;padding-right:5px;"/>
		<label style="font-size:12;vertical-align:middle;"><input id="graphToModule" name="toModule" type="checkbox" value="" style="vertical-align:middle;" checked/>被依赖模块</label><img src="images/legend_module.png"  style="vertical-align:middle;padding-right:5px;"/>
		<label style="font-size:12;vertical-align:middle;">依赖线</label><img src="images/legend_line.png"  style="vertical-align:middle;"padding-right:5px;/>
	</div> 
	<!-- Acts as a container for the graph -->
	<div id="graphContainer" class="geDiagramContainer"
		style="position: absolute;top:24px;width:100%; bottom : 0;overflow: auto;">
		<h1 id="noneGraph" style="position:absolute; top:40%; left:30%; width:100%; height:20%;display:none">该模块无数据,无法显示！</h1>
		<div id="imageContainer" style="position: absolute;width:0;height:0;opacity:0;z-index:-100;"></div>
	</div>
	<iframe name="exportImageFrame" id="exportImageFrame" style="display:none;"></iframe>  
	<form name="exportImageForm" id="exportImageForm" style="display:none" 
		action="<%=request.getContextPath() %>/cip/graph/exportImage.ac" method="POST"
		target="exportImageFrame">
		<input type="hidden" name="imageXML" value=""/>
		<input type="hidden" name="width" value=""/>
		<input type="hidden" name="height" value=""/>
		<input type="hidden" name="format" value=""/>
		<input type="hidden" name="fileName" value=""/>
	</form>
</body>
</html>
