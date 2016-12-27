<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
	<title>class diagram example for mxGraph</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <style>
			body{
				margin:0;
			}
			
			.package{
				margin-top:6px;
				/**background: #008000;*/
				width: 85px;
				height: 45px;
				border:0; 
				cellpadding:0;
				cellspacing:0;
			}
			.package td{
				word-break:break-all;
				white-space:pre-wrap;
				vertical-align: middle; 
			}
			
			.component{
				/**background: #008000;*/
				width: 60px;
				height: 53px;
				border:0; 
				cellpadding:0;
				cellspacing:0;
			}
			.component td{
				word-break:break-all;
				white-space:pre-wrap;
				vertical-align: middle; 
			}
			.ellipsis{
				height:20px;
				line-height:20px;
				overflow:hidden;
				word-wrap:normal;
				white-space:nowrap;
				text-overflow:ellipsis;
			}
			
			.blank{
				display:none;
				position: absolute;
				width:200px;
				left:50%;
				margin-left:-100px;
				margin-top: 150px;
			}
			
			.load-tip{
			    position: absolute;
			    left: 45%;
			    top: 40%;
			    text-align: center;
			    font-size: 8px;
			    z-index: 20;
			    padding-left: 20px;
			    background: url(images/loading.gif) 0 50% no-repeat;
			    color: rgb(136, 136, 136);
			}
    </style>

	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="js/mxClient.js"></script>
    <script type="text/javascript" src="js/doT.js"></script>
    <script type="text/javascript" src="js/moduleHelp.js"></script>
    <script type="text/javascript" src="js/Shapes.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/engine.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/util.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/GraphAction.js'></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/top/js/jquery.js"></script>
	
	<script type="text/javascript">
	
		var moduleId = "${param.moduleId}";//模块ID
		var moduleName;
		dwr.TOPEngine.setAsync(false);
		GraphAction.queryGraphModuleNameByModuleId(moduleId, function(data) {
			moduleName = data.moduleName;
		});
		dwr.TOPEngine.setAsync(true);
		
		var graph;
		function main(container)
		{
			//加上进度条
			//cui.handleMask.show();
			$(".load-tip").show();
			// Checks if browser is supported
			if (!mxClient.isBrowserSupported())
			{
				// Displays an error message if the browser is
				// not supported.
				mxUtils.error('Browser is not supported!', 200, false);
                return;
			}
            // Creates the graph inside the DOM node.
            graph = new mxGraph(container);
			graph.setEnabled(false);
			graph.isHtmlLabel = function(cell) {
				var state = this.view.getState(cell);
				var style = (state != null) ? state.style : this
						.getCellStyle(cell);

				return style['html'] == '1';
			};
           /*  graph.addListener(mxEvent.DOUBLE_CLICK, function(sender, evt)
            {
            	var cell = evt.getProperty('cell');
            	if(cell == undefined || cell.vertex != 1){
            		evt.consume();
            		return;
            	}
            	var cellId = cell.id;
            	if(cellId.indexOf('text_') >= 0 || cellId.indexOf('icon_') >= 0 || cellId.indexOf('container_') >= 0){
            		evt.consume();
            		return;
            	}
            	var mName;
            	dwr.TOPEngine.setAsync(false);
            	GraphAction.queryGraphModuleByModuleId(cellId, function(data) {
            		mName = data.moduleName;
            	});
            	dwr.TOPEngine.setAsync(true);
                if(isFolder(cell)){
                	//打开模块关系图
                	parent.cui("#moduleRelationTab").addTab({id:'tab_' + cell.id, title:mName,url: 'ModuleRelationGraph.jsp?moduleId=' + cell.id, closeable: true});
                	parent.cui("#moduleRelationTab").switchTo(parent.cui("#moduleRelationTab").contents.length - 1);
                }else{
                	//打开应用内资源关系图
                	var tabTitle = mName + "资源关系";
                	parent.cui("#moduleRelationTab").addTab({id:'tab_' + cell.id, title:tabTitle,url: 'ClassRelationGraph.jsp?moduleId=' + cell.id, closeable: true});
                	parent.cui("#moduleRelationTab").switchTo(parent.cui("#moduleRelationTab").contents.length - 1);
                }
                
                evt.consume();
                function isFolder(cell)
             	{
             		var state = graph.view.getState(cell);
             		var style = (state != null) ? state.style : graph.getCellStyle(cell);
             		return style['shape'] == 'folder';
             	};  
            });
 */
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
            var p = getGraphModule();
 			p.done(function(_result) {
 				var xml = getxml(_result);
 				if(xml == null){
 	            	document.getElementById('blank_tip').style.display = 'block';
 	            }else{
 	            	var doc = mxUtils.parseXml(xml);
 	                var codec = new mxCodec(doc);
 	                codec.decode(doc.documentElement, graph.getModel());
 	            }
 	            $("svg").each(function(i){//去除滚动条
 	            	this.style.height = "95%";
 	            });
 	            graph.zoomTo(0.9);
 	            parent.resetPanelHeight ("ModuleGraph", "graphContainer", 30);
	    	}).always(function(_result) {
	    		//cui.handleMask.hide();
	    		$(".load-tip").hide();
	    	});
            
		};
		var canvas;
		function getxml(requestData){
            var def = {
            	centerContanierNode: document.getElementById('centerContanierNodeDiagram').text,
            	contanierNode: document.getElementById('contanierNodeDiagram').text,
                links: document.getElementById('linkDiagram').text
            };
			var displayData = getDisplayData(requestData);
			if(displayData == null){
				return null;
			}
            var pagefn = doT.template(document.getElementById('componentDiagram').text, undefined, def);
            return pagefn(displayData);
        }
		/**
	     * 获取图示化模块数据
	     * @param callback 回调函数
	     */
	   	function getGraphModule(){
			var def = $.Deferred();		   		
            GraphAction.queryGraphModuleByModuleId(moduleId, {
				callback: function (_result){
					def.resolve(_result);	
				},
				errorHandler: function(_result){
					def.reject(_result);
				}
			});
			return def.promise();
	   	}
	</script>

    <script id="componentDiagram" type="text/x-dot-template">
        <mxGraphModel grid="1" guides="1" tooltips="1" connect="1" fold="1" page="0" pageScale="1" pageWidth="826" pageHeight="1169">
            <root>
                <mxCell id="0" width="100%" height="100%"/>
                <mxCell id="1" parent="0" width="100%" height="100%"/>
                {{#def.centerContanierNode}}
				{{#def.contanierNode}}
                {{#def.links}}
            </root>
        </mxGraphModel>
    </script>
    <script id="centerContanierNodeDiagram" type="text/x-dot-template">
        {{
        	var centerContanierNode = it.centerContanierNode;
			var moduleNameFullPath = centerContanierNode.moduleNameFullPath.substr(1);
        }}
		<mxCell id="{{=centerContanierNode.id}}" value="&lt;div title='{{=moduleNameFullPath}}' 
			style='width:{{=centerContanierNode.width-30}}px'class='ellipsis'&gt;{{=moduleNameFullPath}}&lt;/div&gt;" style="swimlane;fillColor=#FFFFFF;gradientColor=#9EA4F5;strokeColor=#B9C2F5;html=1" vertex="1" parent="1">
      		<mxGeometry x="{{=centerContanierNode.X}}" y="{{=centerContanierNode.Y}}" width="{{=centerContanierNode.width}}" height="{{=centerContanierNode.height}}" as="geometry"/>
    	</mxCell>
		{{
            var nodes = centerContanierNode.nodes;
            for(var i=0; i < nodes.length; i++ ){
           		var node=nodes[i];
				var nodeModuleNameFullPath = node.moduleNameFullPath.substr(1);
				if(node.moduleType == 2){
		}}
		<mxCell id="{{=node.moduleId}}" value="&lt;table title='{{=nodeModuleNameFullPath}}' class='component'&gt;&lt;tr&gt;&lt;td&gt;{{=node.moduleName}}&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;" style="shape=component;align=left;spacingLeft=35;fillColor=#FFFFFF;gradientColor=#D9EAFF;strokeColor=#64b4e6;html=1" vertex="1" parent="{{=centerContanierNode.id}}">
      		<mxGeometry x="{{=node.X}}" y="{{=node.Y}}" width="{{=node.width}}" height="{{=node.height}}" as="geometry"/>
    	</mxCell>
		{{
				} else {
        }}
		<mxCell id="{{=node.moduleId}}" value="&lt;table title='{{=nodeModuleNameFullPath}}' class='package'&gt;&lt;tr&gt;&lt;td&gt;{{=node.moduleName}}&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;" style="shape=folder;fontStyle=1;spacingTop=0;spacingLeft=0;spacingRight=0;spacingBottom=0;tabWidth=40;tabHeight=14;tabPosition=left;fillColor=#FFFFFF;gradientColor=#F2F789;strokeColor=#DFD89D;html=1" vertex="1" parent="{{=centerContanierNode.id}}">
      		<mxGeometry x="{{=node.X}}" y="{{=node.Y}}" width="{{=node.width}}" height="{{=node.height}}" as="geometry"/>
    	</mxCell>
		{{
				}
            }
        }}
    </script>
    <script id="contanierNodeDiagram" type="text/x-dot-template">
        {{
        var contanierNodes = it.contanierNodes;
        for(var i=0; i < contanierNodes.length; i++ ){
        	var contanierNode=contanierNodes[i];
			if(contanierNode.nodes.length > 1){
        }}
		<mxCell id="{{=contanierNode.id}}" value="" style="dashed=1;fillColor=#FFFFFF;" vertex="1" parent="1">
      		<mxGeometry x="{{=contanierNode.X}}" y="{{=contanierNode.Y}}" width="{{=contanierNode.width}}" height="{{=contanierNode.height}}" as="geometry"/>
    	</mxCell>
        {{
			}
			var nodes = contanierNode.nodes;
			for(var j=0; j < nodes.length; j++ ){
				var node = nodes[j];
				var nodeModuleNameFullPath = node.moduleNameFullPath.substr(1);
				if(node.moduleType == 2){
		}}
		<mxCell id="{{=node.moduleId}}" value="&lt;table title='{{=nodeModuleNameFullPath}}' class='component'&gt;&lt;tr&gt;&lt;td&gt;{{=node.moduleName}}&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;" style="shape=component;align=left;spacingLeft=35;fillColor=#FFFFFF;gradientColor=#D9EAFF;strokeColor=#64b4e6;html=1" vertex="1" parent="{{=(contanierNode.nodes.length > 1 ? contanierNode.id : 1)}}">
      		<mxGeometry x="{{=node.X}}" y="{{=node.Y}}" width="{{=node.width}}" height="{{=node.height}}" as="geometry"/>
    	</mxCell>
		{{
				} else {
        }}
		<mxCell id="{{=node.moduleId}}" value="&lt;table title='{{=nodeModuleNameFullPath}}' class='package'&gt;&lt;tr&gt;&lt;td&gt;{{=node.moduleName}}&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;" style="shape=folder;fontStyle=1;spacingTop=10;tabWidth=40;tabHeight=14;tabPosition=left;fillColor=#FFFFFF;gradientColor=#F2F789;strokeColor=#DFD89D;html=1" vertex="1" parent="{{=(contanierNode.nodes.length > 1 ? contanierNode.id : 1)}}">
      		<mxGeometry x="{{=node.X}}" y="{{=node.Y}}" width="{{=node.width}}" height="{{=node.height}}" as="geometry"/>
    	</mxCell>
		{{
				}
			}
        }
        }}
    </script>
    <script id="linkDiagram" type="text/x-dot-template">
        {{
        var links = it.links;
        for(var i=0; i < links.length; i++ ){
        var link=links[i];
        }}
        <mxCell id="{{=link.id}}" value="" style="{{=link.style}}" edge="1" parent="{{=link.parent}}" source="{{=link.sourceId}}" target="{{=link.targetId}}">
             <mxGeometry as="geometry">
				<Array as="points">
					{{
						var points = link.points;
						if(points){
							for(var j=0; j < link.points.length; j++ ){
								var point = link.points[j];
					}}
          			<mxPoint x="{{=point.X}}" y="{{=point.Y}}"/>
					{{
							}
						}
					}}
				</Array>
            </mxGeometry>
        </mxCell>
        {{
        }
        }}
    </script>
</head>

<!-- Page passes the container for the graph to the program -->
<body onload="main(document.getElementById('graphContainer'))">
	<!-- Creates a container for the graph with a grid wallpaper -->
	<div id="graphImg" style="height: 24px;padding-left:30px;cursor: default;">
		<label style="font-size:12px;vertical-align:middle;">模块</label><img src="images/package.png" style="vertical-align:middle;padding-right:5px;"/>
		<label style="font-size:12px;vertical-align:middle;">应用</label><img src="images/app.png" style="vertical-align:middle;padding-right:5px;"/>
		<label style="font-size:12px;vertical-align:middle;">依赖线</label><img src="images/line.png" style="vertical-align:middle;padding-right:5px;"/>
	</div> 
	<div id="graphContainer"
		style="overflow-y:hidden;width:100%;">
		<div id="blank_tip" class="blank">该模块下无任何数据。</div>
		<div class="load-tip">正在加载中...</div>
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
<script type="text/javascript">
function exportToImage(){
	var bounds = graph.getGraphBounds(); 
	var w = Math.round(bounds.x + bounds.width + 30); 
	var h = Math.round(bounds.y + bounds.height + 30); 
	exportImageForm.imageXML.value = getImageXML();
	exportImageForm.fileName.value = encodeURIComponent("模块关系图-" + moduleName);
	exportImageForm.width.value = w;
	exportImageForm.height.value = h;
	exportImageForm.format.value = "png";
	exportImageForm.submit();
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
</body>
</html>
