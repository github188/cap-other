<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
	<title>功能结构图</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <style>
			body{
				margin:0;
			}
			
			.blank{
				display:none;
				position: absolute;
				width:200px;
				left:50%;
				margin-left:-100px;
				margin-top: 150px;
			}
			
			.cell_text_1,.cell_text_2,.cell_text_3 {
	            text-align: center;
	            overflow:hidden;
	            word-wrap:normal;
	            white-space:nowrap;
	            text-overflow:ellipsis;
	        }
	        .cell_text_1{
	        	width:500px;
	        }
	        .cell_text_2{
	        	width:160px;
	        }
	        .cell_text_3{
	        	width:150px;
	        }
    </style>
    <script id="moduleStructDiagram" type="text/x-dot-template">
<mxGraphModel grid="1" guides="1" tooltips="1" connect="1" fold="1" page="0" pageScale="1" pageWidth="826" pageHeight="1169">
  <root>
    <mxCell id="0"/>
    <mxCell id="1" parent="0"/>
    <mxCell id="{{=it.moduleId}}" value="&lt;div title='{{=it.moduleName}}' class='cell_text_1'&gt;{{=it.moduleName}}&lt;/div&gt;" 
		style="cellLevel1" parent="1" vertex="1">
      <mxGeometry x="{{=it.x}}" y="{{=it.y}}" width="{{=it.width}}" height="{{=it.height}}" as="geometry"/>
    </mxCell>
	{{
        var level2Cells = it.innerModuleVOList;
        for(var i=0; i < level2Cells.length; i++ ){
        	var level2Cell=level2Cells[i];
    }}
	<mxCell id="{{=level2Cell.moduleId}}" value="&lt;div title='{{=level2Cell.moduleName}}' class='cell_text_2'&gt;{{=level2Cell.moduleName}}&lt;/div&gt;" 
		style="cellLevel2" parent="1" vertex="1">
      <mxGeometry x="{{=level2Cell.x}}" y="{{=level2Cell.y}}" width="{{=level2Cell.width}}" height="{{=level2Cell.height}}" as="geometry"/>
    </mxCell>
	{{
			var level3Cells = level2Cell.innerModuleVOList;
        	for(var j=0; j < level3Cells.length; j++ ){
				var level3Cell=level3Cells[j];
	}}
	<mxCell id="{{=level3Cell.moduleId}}" value="&lt;div title='{{=level3Cell.moduleName}}' class='cell_text_3'&gt;{{=level3Cell.moduleName}}&lt;/div&gt;" 
		style="cellLevel3" parent="1" vertex="1">
      <mxGeometry x="{{=level3Cell.x}}" y="{{=level3Cell.y}}" width="{{=level3Cell.width}}" height="{{=level3Cell.height}}" as="geometry"/>
    </mxCell>
	{{
			}
		}
	}}
  </root>
</mxGraphModel>

    </script>
</head>

<!-- Page passes the container for the graph to the program -->
<body>
	<!-- Creates a container for the graph with a grid wallpaper -->
	<div id="graphContainer" class="geDiagramContainer"
		style="position: absolute;overflow-y:auto;width:650px;height:100%;background:url('./editor/images/grid.gif')">
		<div id="blank_tip" class="blank">该模块下无任何数据。</div>
	</div>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/graph/js/mxClient.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/graph/js/doT.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/graph/js/Shapes.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/graph/js/moduleStructHelp.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/engine.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/util.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/GraphAction.js'></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/top/js/jquery.js"></script>
	<script type="text/javascript">
		var moduleId = "${param.moduleId}";//模块ID
		main(document.getElementById('graphContainer'));
		function main(container)
		{
			// Checks if browser is supported
			if (!mxClient.isBrowserSupported())
			{
				// Displays an error message if the browser is
				// not supported.
				mxUtils.error('Browser is not supported!', 200, false);
                return;
			}
            // Creates the graph inside the DOM node.
            var graph = initGraph(container);
            
            var xml = getxml();
            if(xml == null){
            	document.getElementById('blank_tip').style.display = 'block';
            }else{
            	var doc = mxUtils.parseXml(xml);
                var codec = new mxCodec(doc);
                codec.decode(doc.documentElement, graph.getModel());
               
            }
            
            $("svg").each(function(i){//去除滚动条
            	this.style.height = "99%";
            });
		};
		
		function initGraph(container){
			var graph = new mxGraph(container);
			graph.setEnabled(true);
			graph.isHtmlLabel = function(cell) {
				var state = this.view.getState(cell);
				var style = (state != null) ? state.style : this
						.getCellStyle(cell);

				return style['html'] == '1';
			};
			initStyleSheet(graph);
			return graph;
		}
		
		function initStyleSheet(graph){
			cellLevel1Style = [];
            cellLevel1Style[mxConstants.STYLE_SHAPE] = mxConstants.SHAPE_RECTANGLE;
            cellLevel1Style[mxConstants.STYLE_FILLCOLOR] = '#f2f2f2';
            cellLevel1Style[mxConstants.STYLE_STROKECOLOR] = '#d9d4d8';
            cellLevel1Style[mxConstants.STYLE_VERTICAL_ALIGN] = 'top';
            cellLevel1Style[mxConstants.STYLE_LABEL_PADDING] = 10;
            cellLevel1Style[mxConstants.STYLE_FONTSIZE] = 38;
            cellLevel1Style[mxConstants.STYLE_FONTSTYLE] = mxConstants.FONT_BOLD;
            cellLevel1Style['html'] = 1;
            
            cellLevel2Style = [];
            cellLevel2Style[mxConstants.STYLE_SHAPE] = mxConstants.SHAPE_RECTANGLE;
            cellLevel2Style[mxConstants.STYLE_FILLCOLOR] = '#ffffff';
            cellLevel2Style[mxConstants.STYLE_STROKECOLOR] = '#d9d4d8';
            cellLevel2Style[mxConstants.STYLE_VERTICAL_ALIGN] = 'top';
            cellLevel2Style[mxConstants.STYLE_LABEL_PADDING] = 10;
            cellLevel2Style[mxConstants.STYLE_FONTSIZE] = 20;
            cellLevel2Style[mxConstants.STYLE_FONTSTYLE] = mxConstants.FONT_BOLD;
            cellLevel2Style['html'] = 1;
            
            cellLevel3Style = [];
            cellLevel3Style[mxConstants.STYLE_SHAPE] = mxConstants.SHAPE_RECTANGLE;
            cellLevel3Style[mxConstants.STYLE_FILLCOLOR] = '#e1f3fe';
            cellLevel3Style[mxConstants.STYLE_STROKECOLOR] = '#7db5de';
            cellLevel3Style[mxConstants.STYLE_GRADIENTCOLOR] = 'none';
            cellLevel3Style[mxConstants.STYLE_STROKEWIDTH] = 0;
            cellLevel3Style[mxConstants.STYLE_FONTSIZE] = 12;
            cellLevel3Style[mxConstants.STYLE_FONTSTYLE] = 0;
            cellLevel3Style['html'] = 1;

            graph.getStylesheet().putCellStyle('cellLevel1', cellLevel1Style);
            graph.getStylesheet().putCellStyle('cellLevel2', cellLevel2Style);
            graph.getStylesheet().putCellStyle('cellLevel3', cellLevel3Style);
		}
		
		function getxml(){
            var def = {};
			var requestData;
			dwr.TOPEngine.setAsync(false);
            GraphAction.queryThreeChildrenModuleVOList(moduleId, function(data) {
			    requestData = data;
			});
			dwr.TOPEngine.setAsync(true);
			var displayData = getDisplayData(requestData);
			if(displayData == null){
				return null;
			}
            var pagefn = doT.template(document.getElementById('moduleStructDiagram').text, undefined, def);
            return pagefn(displayData);
        }
	</script>

</body>
</html>
