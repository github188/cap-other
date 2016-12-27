<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!--[if IE]><meta http-equiv="X-UA-Compatible" content="IE=5,IE=9" ><![endif]-->
<html>
<head>
    <title>Graph Editor</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" type="text/css" href="styles/grapheditor.css">
    <script type="text/javascript"
	src="<%=request.getContextPath()%>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript">
		// Public global variables
		var MAX_REQUEST_SIZE = 10485760;
		var MAX_WIDTH = 6000;
		var MAX_HEIGHT = 6000;
	
		// URLs for save and export
		var EXPORT_URL = '<%=request.getContextPath() %>/graph/editor/export';
		var SAVE_URL = '<%=request.getContextPath() %>/graph/editor/save';
		var OPEN_URL = '<%=request.getContextPath() %>/graph/editor/open';
		var RESOURCES_PATH = 'resources';
		var RESOURCE_BASE = RESOURCES_PATH + '/grapheditor';
		var STENCIL_PATH = 'stencils';
		var IMAGE_PATH = 'images';
		var STYLE_PATH = 'styles';
		var CSS_PATH = 'styles';
		var OPEN_FORM = 'open.html';
	
		// Specifies connection mode for touch devices (at least one should be true)
		var tapAndHoldStartsConnection = true;
		var showConnectorImg = true;

		// Parses URL parameters. Supported parameters are:
		// - lang=xy: Specifies the language of the user interface.
		// - touch=1: Enables a touch-style user interface.
		// - storage=local: Enables HTML5 local storage.
		var urlParams = (function(url)
		{
			var result = new Object();
			var idx = url.lastIndexOf('?');
	
			if (idx > 0)
			{
				var params = url.substring(idx + 1).split('&');
				
				for (var i = 0; i < params.length; i++)
				{
					idx = params[i].indexOf('=');
					
					if (idx > 0)
					{
						result[params[i].substring(0, idx)] = params[i].substring(idx + 1);
					}
				}
			}
			
			return result;
		})(window.location.href);

		// Sets the base path, the UI language via URL param and configures the
		// supported languages to avoid 404s. The loading of all core language
		// resources is disabled as all required resources are in grapheditor.
		// properties. Note that in this example the loading of two resource
		// files (the special bundle and the default bundle) is disabled to
		// save a GET request. This requires that all resources be present in
		// each properties file since only one file is loaded.
		mxLoadResources = false;
		mxBasePath = '..';
		mxLanguage = urlParams['lang'];
		mxLanguages = ['de'];
	</script>
	<script type="text/javascript" src="../js/mxClient.min.js"></script>
	<script type="text/javascript" src="../js/Editor.js"></script>
	<script type="text/javascript" src="../js/Graph.js"></script>
	<script type="text/javascript" src="../js/Shapes.js"></script>
	<script type="text/javascript" src="../js/EditorUi.js"></script>
	<script type="text/javascript" src="../js/Actions.js"></script>
	<script type="text/javascript" src="../js/Menus.js"></script>
	<script type="text/javascript" src="../js/Sidebar.js"></script>
	<script type="text/javascript" src="../js/Toolbar.js"></script>
	<script type="text/javascript" src="../js/Dialogs.js"></script>
	<script type="text/javascript" src="jscolor/jscolor.js"></script>
	<script type='text/javascript'
		src='<%=request.getContextPath()%>/cap/dwr/engine.js'></script>
	<script type='text/javascript'
		src='<%=request.getContextPath()%>/cap/dwr/util.js'></script>
	<script type='text/javascript'
		src='<%=request.getContextPath()%>/cap/dwr/interface/DeployDiagramFacade.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/GraphAction.js'></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/top/js/jquery.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/graph/js/base64.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/graph/js/ExportImage.js"></script>
</head>
<body id="graphContainer" class="geEditor">
	<div id="imageContainer" style="position: absolute;width:0;height:0;opacity:0;z-index:-100;"></div>
	<iframe name="exportImageFrame" id="exportImageFrame" style="display:none;"></iframe>  
	<form name="exportImageForm" id="exportImageForm" style="display:none" 
		action="<%=request.getContextPath() %>/cap/bm/graph/exportImage.ac" method="POST"
		target="exportImageFrame">
		<input type="hidden" name="imageXML" value=""/>
		<input type="hidden" name="width" value=""/>
		<input type="hidden" name="height" value=""/>
		<input type="hidden" name="format" value=""/>
		<input type="hidden" name="fileName" value=""/>
	</form>
	<script type="text/javascript">
		// Extends EditorUi to update I/O action states
		var deployDiagramVO = {};
		deployDiagramVO.moduleId = "${param.moduleId}";//模块ID
		//文件名称,规定是一个模块对应一个物理部署图或者逻辑结构图文件
		deployDiagramVO.modelName = "drawing";
		deployDiagramVO.modelType = "graph";
		deployDiagramVO.diagramType ="${param.diagramType}";//类型
		//模块名称,用于导出图片
		var moduleName = "根模块";
		dwr.TOPEngine.setAsync(false);
			GraphAction.queryGraphModuleByModuleId(deployDiagramVO.moduleId, function(data) {
			moduleName = data.moduleName;
		});
		dwr.TOPEngine.setAsync(true);
		
		(function()
		{
			EditorUi.prototype.saveFile = function(forceDialog)
			{
				var xml = mxUtils.getPrettyXml(this.editor.getGraphXml());
				deployDiagramVO.content = xml;
				var requestData;
				dwr.TOPEngine.setAsync(false);
				DeployDiagramFacade.saveModel(deployDiagramVO, function(data) {
					requestData = data;
				});
				//cui.handleMask.hide();
				if(requestData && requestData == true) {
					mxUtils.alert("保存成功");
				} else {
					mxUtils.alert("保存失败");
				}
			};
			
			var editorUiInit = EditorUi.prototype.init;
			
			EditorUi.prototype.init = function()
			{
				editorUiInit.apply(this, arguments);
				this.actions.get('new').setEnabled(false);
				this.actions.get('open').setEnabled(false);
				this.actions.get('editFile').setEnabled(false);
				this.actions.get('import').setEnabled(false);
				this.actions.get('saveAs').setEnabled(false);
				this.actions.get('export').setEnabled(false);
			};
			
			EditorUi.prototype.open = function()
			{
				//editorUiInit.apply(this, arguments);
				
				var requestData;
				dwr.TOPEngine.setAsync(false);
				DeployDiagramFacade.queryListByModuleIdAndType(deployDiagramVO.moduleId, deployDiagramVO.diagramType, function(data) {
					requestData = data;
				});
				//cui.handleMask.hide();
				if(requestData && requestData.length > 0) {
					deployDiagramVO = requestData[0];
					try
					{
						var xmlString = deployDiagramVO.content;
						var doc = mxUtils.parseXml(xmlString); 
						this.editor.setGraphXml(doc.documentElement);
						this.editor.modified = false;
						this.editor.undoManager.clear();
						
						if (deployDiagramVO != null)
						{
							this.editor.filename = deployDiagramVO.modelName;
						}
					}
					catch (e)
					{
						mxUtils.alert('打开失败' + ': ' + e.message);
					}
				}
			};
		})();
			
		var editorUi = new EditorUi(new Editor());
		var graph = editorUi.editor.graph; 
		
		var isChrome = window.navigator.userAgent.indexOf("Chrome") !== -1;
		function exportToImage(){		
			if (isChrome) {
				var svg = $(".geDiagramContainer svg:first")[0];
				var diagramName = deployDiagramVO.diagramType == "logic" ? "逻辑部署图" : "物理部署图";
				var fileName = diagramName + "-" + moduleName + ".png";
				saveSvgAsPng(svg, fileName);
			}else{
				var bounds = graph.getGraphBounds(); 
				var w = Math.round(bounds.x + bounds.width + 30); 
				var h = Math.round(bounds.y + bounds.height + 30); 
				exportImageForm.imageXML.value = getImageXML();
				var diagramName = deployDiagramVO.diagramType == "logic" ? "逻辑部署图" : "物理部署图";
				exportImageForm.fileName.value = encodeURIComponent(diagramName + "-" + moduleName);
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
			console.log(xml);
			return xml = encodeURIComponent(xml);//这就是要提交到后台的xml代码
		}
	</script>
</body>
</html>
