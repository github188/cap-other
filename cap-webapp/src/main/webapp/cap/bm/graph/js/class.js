var classConstants = {
		SELFCONTAINER_START_X: 30,
		SELFCONTAINER_START_Y: 10,
		
		SELFCONTAINER_WIDTH: 0,
		SELFCONTAINER_HEIGHT: 0,
		
		SELFCONTAINER_LINE_MAX_WIDTH: 0,
		SELFCONTAINER_LINE_MAX_HEIGHT: 0,
		SELFCONTAINER_LINE_UNIT_NUM: 3,
				
		INSIDE_UNIT_START_X: 30,
		INSIDE_UNIT_START_Y: 30,
		
		INSIDE_UNIT_LINE_START_X: 30,
		INSIDE_UNIT_LINE_START_Y: 30,
				
		INSIDE_UNIT_MAX_WIDTH: 0,
		INSIDE_UNIT_MAX_HEIGHT: 0,
		
		INSIDE_NEXT_X: 30,
		INSIDE_NEXT_Y: 30,
		
		ENTITY_WIDTH:260,
		ENTITY_HEIGHT:30,
		
		PAGE_WIDTH:100,
		PAGE_HEIGHT:90,
		PAGE_NUM:3,	
		PAGE_HSPACE:20,
		PAGE_VSPACE:10,
		
		HAVE_DATABASE:false,
		DATABASE_WIDTH:180,
		DATABASE_HEIGHT:60,
		
		HAVE_PROCESS:false,
		PROCESS_WIDTH:140,
		PROCESS_HEIGHT:60,
		
		FROMCONTAINER_MAX_WIDTH: 0,
		FROMCONTAINER_WIDTH: 200,
		FROMCONTAINER_HEIGHT: 200,
		FROMCONTAINER_HSPACE: 30,
		FROMCONTAINER_VSPACE: 30,
		FROM_NEXT_X: 30,
		FROM_NEXT_Y: 30,
		
		TOCONTAINER_MAX_WIDTH: 0,
		TOCONTAINER_WIDTH: 200,
		TOCONTAINER_HEIGHT: 200,
		TOCONTAINER_HSPACE: 30,
		TOCONTAINER_VSPACE: 30,
		TO_NEXT_X: 30,
		TO_NEXT_Y: 30
};

/**
 * 生成图层
 */
function createLayerXML() {
	var resultXMLStr = '';
	var pageLayerXMLStr = '<mxCell id="3" parent="2"/>';
	resultXMLStr += pageLayerXMLStr;
	var processLayerXMLStr = '<mxCell id="4" parent="2"/>';
	resultXMLStr += processLayerXMLStr;
	var databaseLayerXMLStr = '<mxCell id="5" parent="2"/>';
	resultXMLStr += databaseLayerXMLStr;
	var fromModuleLayerXMLStr = '<mxCell id="6" parent="1"/>';
	resultXMLStr += fromModuleLayerXMLStr;
	var toModuleLayerXMLStr = '<mxCell id="7" parent="1"/>';
	resultXMLStr += toModuleLayerXMLStr;
	return resultXMLStr;
}

/**
 * json to graph XML
 */
function getDisplayData(data) {
	var classJsonObj=data;
	if(!classJsonObj || !classJsonObj.graphEntityVOs || classJsonObj.graphEntityVOs.length == 0){
		return null;
	}
	var graphXMLStr = createXMLHeader(classJsonObj);
	//graphXMLStr += createDescXML();
	graphXMLStr += createLayerXML();
	var graphEntityVOs = classJsonObj.graphEntityVOs;
	for (var i = 0; i < graphEntityVOs.length; i++) {
		var entityVO = graphEntityVOs[i];
		classConstants.INSIDE_UNIT_START_X = classConstants.INSIDE_NEXT_X;
		classConstants.INSIDE_UNIT_START_Y = classConstants.INSIDE_NEXT_Y;
		var pageXMLStr = createPageXML(entityVO);
		graphXMLStr += pageXMLStr;
		
		var entityXMLStr = createEntityXML(entityVO);
		graphXMLStr += entityXMLStr;

		var processXMLStr = createProcessXML(entityVO);
		graphXMLStr += processXMLStr;

		var databaseXMLStr = createDatabaseXML(entityVO);
		graphXMLStr += databaseXMLStr;
		
		if(classConstants.HAVE_DATABASE == true && classConstants.HAVE_PROCESS ==true) {
			classConstants.INSIDE_UNIT_MAX_HEIGHT += (classConstants.PROCESS_HEIGHT > classConstants.DATABASE_HEIGHT ? classConstants.PROCESS_HEIGHT : classConstants.DATABASE_HEIGHT );
		} else if(classConstants.HAVE_DATABASE == true) {
			classConstants.INSIDE_UNIT_MAX_HEIGHT += classConstants.DATABASE_HEIGHT ;
		} else if(classConstants.HAVE_PROCESS == true) {
			classConstants.INSIDE_UNIT_MAX_HEIGHT += classConstants.PROCESS_HEIGHT ;
		}
		
		classConstants.HAVE_PROCESS = false;
		classConstants.HAVE_DATABASE = false;
			
		classConstants.INSIDE_NEXT_X = 	classConstants.INSIDE_UNIT_START_X + classConstants.INSIDE_UNIT_MAX_WIDTH + 30;	
		classConstants.INSIDE_NEXT_Y = 	classConstants.INSIDE_UNIT_START_Y;	
		classConstants.SELFCONTAINER_LINE_MAX_WIDTH += classConstants.INSIDE_UNIT_MAX_WIDTH +30;
		classConstants.SELFCONTAINER_LINE_MAX_HEIGHT = (classConstants.SELFCONTAINER_LINE_MAX_HEIGHT >classConstants.INSIDE_UNIT_MAX_HEIGHT ? classConstants.SELFCONTAINER_LINE_MAX_HEIGHT : classConstants.INSIDE_UNIT_MAX_HEIGHT);
		if((i+1)%classConstants.SELFCONTAINER_LINE_UNIT_NUM == 0 || i == graphEntityVOs.length - 1) {
			classConstants.INSIDE_UNIT_LINE_START_Y += classConstants.SELFCONTAINER_LINE_MAX_HEIGHT;
			classConstants.SELFCONTAINER_WIDTH = classConstants.SELFCONTAINER_WIDTH > classConstants.SELFCONTAINER_LINE_MAX_WIDTH ? classConstants.SELFCONTAINER_WIDTH : classConstants.SELFCONTAINER_LINE_MAX_WIDTH;
			classConstants.INSIDE_NEXT_X = classConstants.INSIDE_UNIT_LINE_START_X;
			classConstants.INSIDE_NEXT_Y = classConstants.INSIDE_UNIT_LINE_START_Y + 30;
        	classConstants.SELFCONTAINER_HEIGHT += classConstants.SELFCONTAINER_LINE_MAX_HEIGHT +30;
        	classConstants.SELFCONTAINER_LINE_MAX_HEIGHT = 0; 
        	classConstants.SELFCONTAINER_LINE_MAX_WIDTH = 0; 
        } 	
        classConstants.INSIDE_UNIT_MAX_WIDTH = 0;
		classConstants.INSIDE_UNIT_MAX_HEIGHT = 0;
	}
	
	graphXMLStr += createSelfContainerXML(classJsonObj.moduleName);
	
	classConstants.FROM_NEXT_X = classConstants.SELFCONTAINER_START_X;
	classConstants.FROM_NEXT_Y = classConstants.SELFCONTAINER_START_Y + classConstants.SELFCONTAINER_HEIGHT + 15; 
	for (var j = 0; j < graphEntityVOs.length; j++) {
		var entityVO = graphEntityVOs[j];
		var entityFromContainerXMLStrs = createEntityFromContainerXML(entityVO);
		graphXMLStr += entityFromContainerXMLStrs;
	}	
	
	classConstants.TO_NEXT_X = classConstants.SELFCONTAINER_START_X + classConstants.SELFCONTAINER_WIDTH + 15;
	classConstants.TO_NEXT_Y = classConstants.SELFCONTAINER_START_Y; 
	for (var k = 0; k < graphEntityVOs.length; k++) {
		var entityVO = graphEntityVOs[k];
		var entityToContainerXMLStrs = createEntityToContainerXML(entityVO);
		graphXMLStr += entityToContainerXMLStrs;
	}
	
	var graphEntityRelaVOs = classJsonObj.graphEntityRelaVOs;
	if(graphEntityRelaVOs != undefined) {
		for (var i = 0; i < graphEntityRelaVOs.length; i++) {
			var entityRelaVO = graphEntityRelaVOs[i];
			var entityRelaXMLStr = createEntityRelaXML(entityRelaVO);
			graphXMLStr += entityRelaXMLStr;
		}
	}
	
	graphXMLStr += createXMLFooter(classJsonObj);
	return graphXMLStr;
}

function createDescXML() {	
	var descArray = [{
			image: "../images/legend_module.png",
			label: "模块",
			image_width: 24,
			image_height: 24,
			width: 58,
			height :24
		},{
			image: "../images/legend_page.png",
			label: "页面",
			image_width: 24,
			image_height: 24,
			width: 58,
			height :24
		},{
			image: "../images/legend_class.png",
			label: "实体",
			image_width: 24,
			image_height: 24,
			width: 58,
			height :24
		},{
			image: "../images/legend_process.png",
			label: "流程",
			image_width: 24,
			image_height: 24,
			width: 58,
			height :24
		},{
			image: "../images/legend_database.png",
			label: "数据库",
			image_width: 24,
			image_height: 24,
			width: 72,
			height :24
		},{
			image: "../images/legend_line.png",
			label: "依赖",
			image_width: 24,
			image_height: 24,
			width: 58,
			height :24
		}];
	var descXMLStr = '';
	var ox = 30;
	var oy = 0;
	for (var i = 0; i < descArray.length; i++) {
		var descObject = descArray[i];
		descXMLStr +=  '<mxCell id="' + (Math.ceil(Math.random()*100000000)) +'" value="'
			+descObject.label
			+'" style="shape=label;image='
			+descObject.image 
			+';imageWidth='
			+descObject.image_width
			+';imageHeight='
			+descObject.image_height
			+';fillColor=#FFFFFF;gradientColor=#FFFFFF;verticalAlign=bottom;align=right;fontSize=12;fontFamily=Helvetica;strokeColor=#FFFFFF" vertex="1" parent="1">'
			+'<mxGeometry x="'
			+ox
			+'" y="'
			+oy
			+'" width="'
			+descObject.width
			+'" height="'
			+descObject.height
			+'" as="geometry"/>'
			+ '</mxCell>';
		ox += descObject.width + 10;
	}
	return descXMLStr;
}

function createEntityFromContainerXML(entityVO) {
	var resultXMLStr = '';
	var graphModules = entityVO.graphFromModules;
	if(graphModules  != undefined) {
		for (var i = 0; i < graphModules.length; i++) {
			var relaModuleVO = graphModules[i];
			var moduleCellId = Math.random() * 1000000000000000000000 ;
			var containerXMLStr = '<mxCell id="'+ moduleCellId +'" value="' + relaModuleVO.moduleName +'" style="swimlane;gradientColor=#b1baf5;fillColor=#FFFFFF;entityFromDiagram=1" parent="6" vertex="1" moduleId="' + relaModuleVO.moduleId + '">'
				+ '<mxGeometry x="' +classConstants.FROM_NEXT_X  +'" y="' +classConstants.FROM_NEXT_Y +'" width="'+classConstants.FROMCONTAINER_WIDTH+'" height="'+classConstants.FROMCONTAINER_HEIGHT+'" as="geometry"/>'
				+ '</mxCell>';
			resultXMLStr += containerXMLStr;
			var graphEntityVOs = relaModuleVO.graphEntityVOs;
			if(graphEntityVOs != undefined) {
				for(var j=0;j < graphEntityVOs.length; j ++) {
					var relaEntityVO = graphEntityVOs[j];
					if(j < 4) { 
						var classCellId = Math.random() * 1000000000000000000000 ;
						var x = (j%2 == 0 ? 10  : 100);
						var y = (Math.floor(j/2) ) * 70 + 30;
						var classXMLStr = '<mxCell id="'
							+ classCellId 
							+'" value="&lt;div style=&quot;width:' 
							+ (80 - 2) 
							+'px;height:60px;cursor:default;word-wrap:break-word;&quot;&gt; '
							+relaEntityVO.chName
							+'&lt;hr color=#FFC90E size=1/&gt;&lt;div style=&quot;height:2px;&quot;&gt;&lt;/div&gt;&lt;hr color=#FFC90E size=1/&gt;&lt;/div&gt;" style="verticalAlign=top;align=left;overflow=hidden;fontSize=12;fontFamily=Helvetica;html=1;fillColor=#FFFFFF;gradientColor=#FFF4C3;strokeColor=#FFC90E" vertex="1" parent="'
							+moduleCellId
							+'">'
						    + '<mxGeometry x="' + x +'" y="' + y +'" width="80" height="60" as="geometry"/>'
						    + '</mxCell>';
						resultXMLStr += classXMLStr;
					} else {
						var apostropheCellId = Math.random() * 1000000000000000000000 ;
						var apostropheXMLStr = '<mxCell id="' + apostropheCellId + '" value="" style="endArrow=none;endSize=10;dashed=1;noEdgeStyle=1;fontStyle=1;strokeWidth=2" edge="1" parent="'+ moduleCellId +'">'
						      +'<mxGeometry x="-14.113009830076521" y="-53.25023259077477" as="geometry">'
						      +'<mxPoint x="10" y="181.49976740922511" as="sourcePoint"/>'
						      +'<mxPoint x="140" y="181.49976740922511" as="targetPoint"/>'
						      +'</mxGeometry>'
						      +'</mxCell>';
						resultXMLStr += apostropheXMLStr;
					}
				}
			}
			var relaCellId = Math.random() * 1000000000000000000000 ;
			var relaXMLStr = '<mxCell id="'+relaCellId+'" value="" style="edgeStyle=entityRelationEdgeStyle;elbow=horizontal;endArrow=open;endSize=10;'
				  +'exitX=1;exitY=0.83;'				
				  +'dashed=1" edge="1" source="'+ entityVO.modelId +'" target="'+ moduleCellId +'" parent="6">'
			      +'<mxGeometry  as="geometry">'
			      +'<mxPoint as="sourcePoint"/>'
			      +'<mxPoint as="targetPoint"/>'
			      +'</mxGeometry>'
			      +'</mxCell>';
			resultXMLStr +=relaXMLStr;
			classConstants.FROM_NEXT_X +=  classConstants.FROMCONTAINER_WIDTH + classConstants.FROMCONTAINER_HSPACE;	
			if((classConstants.FROM_NEXT_X + classConstants.FROMCONTAINER_WIDTH) > 
				(classConstants.SELFCONTAINER_START_X + classConstants.SELFCONTAINER_WIDTH)) {
				classConstants.FROM_NEXT_X = classConstants.SELFCONTAINER_START_X;
				classConstants.FROM_NEXT_Y += classConstants.FROMCONTAINER_HEIGHT + classConstants.FROMCONTAINER_VSPACE;
			}
		}
	}
	return resultXMLStr;
}

function createEntityToContainerXML(entityVO) {
	var resultXMLStr = '';
	var graphModules = entityVO.graphToModules;
	if(graphModules  != undefined) {
		for (var i = 0; i < graphModules.length; i++) {
			var relaModuleVO = graphModules[i];
			var moduleCellId = Math.random() * 1000000000000000000000 ;
			var containerXMLStr = '<mxCell id="'+ moduleCellId +'" value="' + relaModuleVO.moduleName +'" style="swimlane;gradientColor=#b1baf5;fillColor=#FFFFFF;entityToDiagram=1" parent="7" vertex="1" moduleId="' + relaModuleVO.moduleId + '">'
				+ '<mxGeometry x="' +classConstants.TO_NEXT_X  +'" y="' +classConstants.TO_NEXT_Y +'" width="'+classConstants.TOCONTAINER_WIDTH+'" height="'+classConstants.TOCONTAINER_HEIGHT+'" as="geometry"/>'
				+ '</mxCell>';
			resultXMLStr += containerXMLStr;
			var graphEntityVOs = relaModuleVO.graphEntityVOs;
			if(graphEntityVOs != undefined) {
				for(var j=0;j < graphEntityVOs.length; j ++) {
					var relaEntityVO = graphEntityVOs[j];
					if(j < 4) { 
						var classCellId = Math.random() * 1000000000000000000000 ;
						var x = (j%2 == 0 ? 10  : 100);
						var y = (Math.floor(j/2) ) * 70 + 30;
						var classXMLStr = '<mxCell id="'
							+ classCellId 
							+'" value="&lt;div style=&quot;width:' 
							+ (80 - 2) 
							+'px;height:60px;cursor:default;word-wrap:break-word;&quot;&gt; '
							+relaEntityVO.chName
							+'&lt;hr color=#FFC90E size=1/&gt;&lt;div style=&quot;height:2px;&quot;&gt;&lt;/div&gt;&lt;hr color=#FFC90E size=1/&gt;&lt;/div&gt;" style="verticalAlign=top;align=left;overflow=hidden;fontSize=12;fontFamily=Helvetica;html=1;fillColor=#FFFFFF;gradientColor=#FFF4C3;strokeColor=#FFC90E" vertex="1" parent="'
							+moduleCellId
							+'">'
						    + '<mxGeometry x="' + x +'" y="' + y +'" width="80" height="60" as="geometry"/>'
						    + '</mxCell>';
						resultXMLStr += classXMLStr;
					} else {
						var apostropheCellId = Math.random() * 1000000000000000000000 ;
						var apostropheXMLStr = '<mxCell id="' + apostropheCellId + '" value="" style="endArrow=none;endSize=10;dashed=1;noEdgeStyle=1;fontStyle=1;strokeWidth=2" edge="1" parent="'+ moduleCellId +'">'
						      +'<mxGeometry x="-14.113009830076521" y="-53.25023259077477" as="geometry">'
						      +'<mxPoint x="10" y="181.49976740922511" as="sourcePoint"/>'
						      +'<mxPoint x="140" y="181.49976740922511" as="targetPoint"/>'
						      +'</mxGeometry>'
						      +'</mxCell>';
						resultXMLStr += apostropheXMLStr;
					}
				}
			}
			var relaCellId = Math.random() * 1000000000000000000000 ;
			var relaXMLStr = '<mxCell id="'+relaCellId+'" value="" style="edgeStyle=entityRelationEdgeStyle;elbow=horizotal;endArrow=open;endSize=10;'
				  +'dashed=1" edge="1" source="'+moduleCellId+'" target="'+entityVO.modelId +'" parent="7">'
			      +'<mxGeometry  as="geometry">'
			      +'<mxPoint as="sourcePoint"/>'
			      +'<mxPoint as="targetPoint"/>'
			      +'</mxGeometry>'
			      +'</mxCell>';
			resultXMLStr +=relaXMLStr;
			classConstants.TO_NEXT_Y +=  classConstants.TOCONTAINER_HEIGHT + classConstants.TOCONTAINER_VSPACE;	
			if((classConstants.TO_NEXT_Y + classConstants.TOCONTAINER_HEIGHT) > 
				(classConstants.SELFCONTAINER_START_Y + classConstants.SELFCONTAINER_HEIGHT)) {
				classConstants.TO_NEXT_X += classConstants.TOCONTAINER_WIDTH + classConstants.TOCONTAINER_HSPACE;
				classConstants.TO_NEXT_Y = classConstants.SELFCONTAINER_START_Y;
			}
		}
	}
	return resultXMLStr;
}


function createEntityRelaXML(entityRelaVO) {
	var entityRelaXMLStr = '<mxCell id="'
			+ Math.random()
			+ '" value="'
			+ entityRelaVO.multiple
			+ '" style="edgeStyle=elbowEdgeStyle;elbow=horizotal;endArrow=open;endSize=10;dashed=1" edge="1" parent="2" source="'
			+ entityRelaVO.sourceEntityId + '" target="'
			+ entityRelaVO.targetEntityId + '">' + '<mxGeometry as="geometry">'
			+ '<mxPoint as="sourcePoint"/>'
			+ '<mxPoint as="targetPoint"/>' + '</mxGeometry>'
			+ '</mxCell>';
	return entityRelaXMLStr;
}

function createSelfContainerXML(moduleName) {
	classConstants.SELFCONTAINER_WIDTH += 30;
	var containerXMLStr = '<mxCell id="2" value="' + moduleName + '" style="swimlane;gradientColor=#d2d3d3;fillColor=#FFFFFF" parent="1" vertex="1">'
			+ '<mxGeometry x="'+ classConstants.SELFCONTAINER_START_X +'" y="' +classConstants.SELFCONTAINER_START_Y +'" width="'+classConstants.SELFCONTAINER_WIDTH+'" height="'+classConstants.SELFCONTAINER_HEIGHT+'" as="geometry"/>'
			+ '</mxCell>';
	return containerXMLStr;
}

function createEntityXML(entityVO) {
	var entityWidth = 160;
	var entityHeight = 0;	
	var entityXMLStr ='';
	var subCellXMLStr ='&lt;div style=&quot;width:' + (classConstants.ENTITY_WIDTH - 2) +'px;cursor:default;&quot;&gt;';
	
	var graphAttributes = entityVO.attributes;
	subCellXMLStr += '&lt;hr color=#FFC90E size=1/&gt;';
	if(graphAttributes != undefined && graphAttributes.length > 0) {		
		subCellXMLStr += '&lt;p style=&quot;margin:0px;margin-left:4px;&quot;&gt;';
		for (var i = 0; i < graphAttributes.length; i++) {
			entityHeight += 17;
			var attributeVO = graphAttributes[i];
			var attributeXMLStr = '&lt;div  style=&quot;height:'+17 +'px;font-size:12px&quot;&gt;';
			attributeXMLStr +=createAttributeXML(attributeVO);
			//if (i != graphAttributes.length - 1) {
				//attributeXMLStr += '&lt;/br&gt;';
			//}
			attributeXMLStr += '&lt;/div&gt;';
			subCellXMLStr += attributeXMLStr;
		}
		subCellXMLStr += '&lt;/p&gt;';
	}
	
	var graphMethods = entityVO.methods;
	if(graphMethods == undefined) {
		subCellXMLStr += '&lt;div style=&quot;height:'+ 25 +'px;&quot;&gt;&lt;/div&gt;';
	}
	subCellXMLStr += '&lt;hr color=#FFC90E size=1/&gt;';
	if(graphMethods != undefined && graphMethods.length > 0) {		
		//subCellXMLStr += '&lt;p style=&quot;margin:0px;margin-left:4px;&quot;&gt;';
		for (var i = 0; i < graphMethods.length; i++) {
			entityHeight += 17;
			var method = graphMethods[i];
			var methodXMLStr = '&lt;div  style=&quot;height:'+17 +'px;font-size:12px&quot;&gt;';
			methodXMLStr +=createMethodXML(method);
			//if (i != graphMethods.length - 1) {
				//methodXMLStr += '&lt;/br&gt;';
			//}
			methodXMLStr+= '&lt;/div&gt;';
			subCellXMLStr += methodXMLStr;
		}
		//subCellXMLStr += '&lt;/p&gt;"';
	}
	subCellXMLStr += '&lt;/div&gt;';
	
	entityXMLStr += '<mxCell id="'
		+ entityVO.modelId
		+ '" value="&lt;p style=&quot;margin:0px;margin-top:4px;text-align:center;&quot;&gt;&lt;b&gt;'
		+ entityVO.chName
		+ '&lt;/b&gt;&lt;br/&gt;&lt;b&gt;'
		+ entityVO.engName
		+ '&lt;/b&gt;&lt;/p&gt;';
	
	entityXMLStr += subCellXMLStr;
	entityXMLStr += '"';
	
	entityXMLStr += ' style="verticalAlign=top;align=left;fontSize=12;fontFamily=Helvetica;html=1;classDiagram=1;fillColor=#FFFFFF;gradientColor=#FFF2CC;strokeColor=#FFC90E" vertex="1" parent="2" collapsed="1">'
		+ '<mxGeometry x="' +classConstants.INSIDE_NEXT_X +'" y="'+ classConstants.INSIDE_NEXT_Y  +'" width="'+ classConstants.ENTITY_WIDTH +'" height="'
		+ (118) + '" as="geometry">' 
		+'<mxRectangle x="' +classConstants.INSIDE_NEXT_X +'" y="'+ classConstants.INSIDE_NEXT_Y  +'" width="'+ classConstants.ENTITY_WIDTH +'" height="'
		+ (entityHeight + 85) 
		+'" as="alternateBounds"/>'
		+ '</mxGeometry></mxCell>';
	
	classConstants.INSIDE_NEXT_Y += 105 + 50;	
	classConstants.INSIDE_UNIT_MAX_WIDTH = (classConstants.INSIDE_UNIT_MAX_WIDTH > classConstants.ENTITY_WIDTH ? classConstants.INSIDE_UNIT_MAX_WIDTH : classConstants.ENTITY_WIDTH);
	classConstants.INSIDE_UNIT_MAX_HEIGHT += 105  + 90;
	return entityXMLStr;
}

function createDatabaseXML(entityVO) {
	var resultXMLStr = '';
	var tableName = entityVO.dbObjectName || '';
	if(tableName != '') {
		classConstants.HAVE_DATABASE = true;
		var databaseXMLStr = '<mxCell id="'
				+ tableName
				+ '" value="&lt;table style=&quot;font-size:12;border:none;border-collapse:collapse;width:'
				+ classConstants.DATABASE_WIDTH 
				+'px;height:'
				+ classConstants.DATABASE_HEIGHT
				+ 'px&quot;&gt;&lt;tr height=&quot;'
				+ (classConstants.DATABASE_HEIGHT/2)
				+ 'px&quot;&gt;&lt;td colspan=&quot;2&quot; style=&quot;border:1px solid #e4b483;background:#fde1c5;&quot;&gt;'
				+ tableName
				+ '&lt;/td&gt;&lt;/tr&gt;&lt;tr  height=&quot;'
				+ (classConstants.DATABASE_HEIGHT/6)
				+'px&quot;&gt;&lt;td style=&quot;border:1px solid #e4b483;&quot;&gt; &lt;/td&gt;&lt;td style=&quot;border:1px solid #e4b483;&quot;&gt; &lt;/td&gt;&lt;/tr&gt;'
				+'&lt;tr height=&quot;'
				+ (classConstants.DATABASE_HEIGHT/6)
				+'px&quot;&gt;&lt;td style=&quot;border:1px solid #e4b483;&quot;&gt; &lt;/td&gt;&lt;td style=&quot;border:1px solid #e4b483;&quot;&gt; &lt;/td&gt;&lt;/tr&gt;'
				+'&lt;tr height=&quot;'
				+ (classConstants.DATABASE_HEIGHT/6)
				+'px&quot;&gt;&lt;td style=&quot;border:1px solid #e4b483;&quot;&gt;&lt;/td&gt;&lt;td style=&quot;border:1px solid #e4b483;&quot;&gt; &lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;" style="strokeColor=#e4b483;verticalAlign=top;align=left;overflow=fill;html=1;fillColor=#FFFFFF;gradientColor=#FFFFFF" vertex="1" parent="5">'
				+ '<mxGeometry x="'+ classConstants.INSIDE_NEXT_X +'" y="'+ classConstants.INSIDE_NEXT_Y +'" width="'+ classConstants.DATABASE_WIDTH +'" height="'+ classConstants.DATABASE_HEIGHT +'" as="geometry"/>'
				+ '</mxCell>';
		var entityDatabaseRelaXMLStr = '<mxCell id="'
				+ Math.random()
				+ '" value="" style="edgeStyle=elbowEdgeStyle;elbow=horizontal;endArrow=open;endSize=10;dashed=1" edge="1" parent="5" source="'
				+ entityVO.modelId + '" target="' + tableName + '">'
				+ '<mxGeometry as="geometry">' + '<mxPoint as="sourcePoint"/>'
				+ '<mxPoint as="targetPoint"/>' + '</mxGeometry>'
				+ '</mxCell>';
		classConstants.INSIDE_UNIT_MAX_WIDTH = classConstants.INSIDE_UNIT_MAX_WIDTH > (classConstants.DATABASE_WIDTH + classConstants.PROCESS_WIDTH + 60) ? classConstants.INSIDE_UNIT_MAX_WIDTH : 	(classConstants.DATABASE_WIDTH + classConstants.PROCESS_WIDTH + 60) ;	
		resultXMLStr = databaseXMLStr + entityDatabaseRelaXMLStr;
	}
	return resultXMLStr;
}

function createProcessXML(entityVO) {
	var resultXMLStr = '';
	var processId = entityVO.processId || '';
	if( processId != '') {
		classConstants.HAVE_PROCESS = true;
		var valueStr = processId;
		if(entityVO.processName) {
			valueStr =  entityVO.processName + '&lt;br/&gt;' + valueStr;
		}
		
		var processCellId = Math.random();
		var processXMLStr = '<mxCell id="'
				+ processCellId
				+ '" value="'
				+ valueStr
				+ '" style="strokeColor=#009900;rounded=1;fontSize=12;fontFamily=Helvetica;fillColor=#FFFFFF;gradientColor=#98FFB5;html=1" vertex="1" parent="4">'
				+ '<mxGeometry x="'+classConstants.INSIDE_NEXT_X +'" y="' + classConstants.INSIDE_NEXT_Y +  '" width="'+ classConstants.PROCESS_WIDTH+ '" height="' +classConstants.PROCESS_HEIGHT + '" as="geometry"/>'
				+ '</mxCell>';
		var relaXMLStr = '<mxCell id="'
				+ Math.random()
				+ '" value="" style="edgeStyle=elbowEdgeStyle;elbow=horizontal;endArrow=open;endSize=10;dashed=1" edge="1" parent="4" source="'
				+ entityVO.modelId + '" target="' +processCellId + '">'
				+ '<mxGeometry as="geometry">' + '<mxPoint as="sourcePoint"/>'
				+ '<mxPoint  as="targetPoint"/>' + '</mxGeometry>'
				+ '</mxCell>';
		classConstants.INSIDE_NEXT_X += classConstants.PROCESS_WIDTH + 30;	
		resultXMLStr = processXMLStr +relaXMLStr;
	}
	return  resultXMLStr;
}

function createPageXML(entityVO) {
	var allPageXMLStr = "";
	var graphPages = entityVO.graphPages;
	if(graphPages == undefined  || graphPages.length <=0) {
		return;
	}
	
	//计算横向线间距离
	var pageNum = graphPages.length; 
	var pageLineNum = Math.floor(pageNum/classConstants.PAGE_NUM) + 1;
	var pageStartX = classConstants.INSIDE_NEXT_X;
	var pageStartY = classConstants.INSIDE_NEXT_Y;
	for (var i = 0; i < graphPages.length; i++) {
		var pageVO = graphPages[i];
		var pageId = Math.random();
		var valueStr = pageVO.englishName;
		if(pageVO.title) {
			valueStr = pageVO.title + '&lt;br/&gt;' + valueStr;
		}
		
		valueStr = '&lt;table style=&quot;width:'+ classConstants.PAGE_WIDTH 
			+ ';height:'+ classConstants.PAGE_HEIGHT +';overflow:hidden;WORD-WRAP:break-word;word-break:break-all;&quot; &gt;'
			+'&lt;tr style=&quot;width:'+ classConstants.PAGE_WIDTH +';height:'+classConstants.PAGE_HEIGHT +';overflow:hidden;WORD-WRAP:break-word;word-break:break-all;&quot;&gt;'
			+'&lt;td style=&quot;font-size:12;padding-top:20px;text-align:center;width:'+ classConstants.PAGE_WIDTH +';height:'+classConstants.PAGE_HEIGHT +';overflow:hidden;WORD-WRAP:break-word;word-break:break-all;&quot;&gt;'
			+ valueStr
			+'&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;'
		
		
		/*valueStr = '&lt;div '
			+ 'style=&quot;padding-top:60px;overflow:hidden;WORD-WRAP:break-word;TABLE-LAYOUT:fixed;word-break:break-all;&quot;&gt;'
			+ valueStr 
			+ '&lt;/div&gt;';*/
		//valueStr = '&lt;div&gt;' + valueStr + '&lt;/div&gt;'; 
		/*valueStr = '&lt;div style=&quot;width:'
			+  classConstants.PAGE_WIDTH 
			+';height:'
			+ classConstants.PAGE_HEIGHT
			+';word-wrap:break-word;word-break:break-all;overflow:hidden;vertical-align=middle;padding-top:'
			+(classConstants.PAGE_HEIGHT/2 + 15)
			+'px&quot;&gt;'
			+ valueStr + '&lt;/div&gt;';*/
		var pageXMLStr = '<mxCell id="'
				+ pageId
				+ '" value="'
				+ valueStr
				+ '" style="shape=note;strokeColor=#34a7db;strokeWidth=0;verticalAlign=middle;overflow=hidden;fillColor=#FFFFFF;gradientColor=#93DFFE;html=1;pageDiagram=1" vertex="1" parent="3">'
				+ '<mxGeometry x="'+ classConstants.INSIDE_NEXT_X+'" y="'+ classConstants.INSIDE_NEXT_Y
				+'" width="' + classConstants.PAGE_WIDTH + '" height="'+classConstants.PAGE_HEIGHT +'" as="geometry"/>'
				+ '</mxCell>';
		var entityPageRelaXMLStr = '<mxCell id="'
				+ Math.random()
				+ '" value="" style="edgeStyle=elbowEdgeStyle;elbow=horizontal;endArrow=open;endSize=10;';
		if((i) % classConstants.PAGE_NUM > 1 ) {
			entityPageRelaXMLStr +='entryX=1;entryY=0.25;';			
		}		
		entityPageRelaXMLStr +='dashed=1" edge="1" parent="3" source="'
				+ pageId  + '" target="' +entityVO.modelId + '">'
				+ '<mxGeometry as="geometry">' + '<mxPoint as="sourcePoint"/>'
				+ '<mxPoint  as="targetPoint"/>'
				+' <Array as="points">'
          		+'	<mxPoint x="' +(classConstants.INSIDE_NEXT_X + classConstants.PAGE_WIDTH + classConstants.PAGE_HSPACE/2) +'" y="'+ (classConstants.INSIDE_NEXT_Y + classConstants.PAGE_HEIGHT/2) +'"/>'
        		+'	</Array></mxGeometry></mxCell>';
        if((i+1)%classConstants.PAGE_NUM == 0 && i != graphPages.length - 1) {
        	classConstants.INSIDE_NEXT_X = pageStartX;
        	classConstants.INSIDE_NEXT_Y = classConstants.INSIDE_NEXT_Y + classConstants.PAGE_HEIGHT + classConstants.PAGE_VSPACE;
        } else {
        	classConstants.INSIDE_NEXT_X = classConstants.INSIDE_NEXT_X + classConstants.PAGE_WIDTH + classConstants.PAGE_HSPACE;
        }		
        		
		allPageXMLStr += pageXMLStr;
		allPageXMLStr += entityPageRelaXMLStr;
	}
	var pageMaxWidthTemp = (graphPages.length > classConstants.PAGE_NUM ?  classConstants.PAGE_NUM : graphPages.length);
	classConstants.INSIDE_UNIT_MAX_WIDTH =  (classConstants.PAGE_WIDTH + classConstants.PAGE_HSPACE)* pageMaxWidthTemp;
	classConstants.INSIDE_UNIT_MAX_HEIGHT = (classConstants.PAGE_HEIGHT + classConstants.PAGE_VSPACE)* pageLineNum;
	
	classConstants.INSIDE_NEXT_X = pageStartX;
	classConstants.INSIDE_NEXT_Y += classConstants.PAGE_HEIGHT + 30;
	classConstants.INSIDE_UNIT_MAX_HEIGHT += 30;
	
	return allPageXMLStr;
}

function createMethodXML(method) {
	var operateStr = '+';
	switch(method.accessLevel) {
		case "private" : operateStr = '-';break;
		case "public" : operateStr = '+';break;
		case "protected" : operateStr = '#';break;
		case "package" : operateStr = '~';break;
		default :
			operateStr = '+';break;
	}
	var reType = '';
	if(method.returnType != undefined) {
		reType = method.returnType.type.replace("<","&lt;").replace(">", "&gt;");
	}
	var parametersStr = '';
	if(method.parameters != undefined) {
		for(var i = 0; i < method.parameters.length; i ++ ) {
			parametersStr += method.parameters[i].dataType.type.replace("<","&lt;").replace(">", "&gt;");
			parametersStr += '  ';
			parametersStr += method.parameters[i].engName;
			if(i != method.parameters.length - 1) {
				parametersStr += ',';
			}
		}
	}
	
	var methodXMLStr = operateStr + ' ' + method.engName + '():' + reType;
	return methodXMLStr;
}

function createAttributeXML(attributeVO) {
	var operateStr = '+';
	switch(attributeVO.accessLevel) {
		case "private" : operateStr = '-';break;
		case "public" : operateStr = '+';break;
		case "protected" : operateStr = '#';break;
		case "package" : operateStr = '~';break;
		default :
			operateStr = '+';break;
	}
	var attriType = '';
	if(attributeVO.attributeType != undefined) {
		attriType = attributeVO.attributeType.type.replace("<","&lt;").replace(">", "&gt;");
	}
	var attrXMLStr = operateStr +' ' + attributeVO.engName + ':' + attriType;
	return attrXMLStr;
}

function createXMLHeader(jsonObj) {
	var header = '<mxGraphModel grid="1" guides="1" tooltips="1" connect="1" fold="1" page="0" pageScale="1" pageWidth="100%" pageHeight="100%">'
			+ '<root>' + '<mxCell id="0" width="100%" height="100%" />' + '<mxCell id="1" parent="0" width="100%" height="100%" />';
	return header;
}

function createXMLFooter(jsonObj) {
	var footer = '</root>' + '</mxGraphModel>';
	return footer;
}
