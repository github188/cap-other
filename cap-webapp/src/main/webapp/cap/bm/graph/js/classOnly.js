//类图变量
var classOnlyConstants = {	
		//开始X坐标
		START_X: 30,
		//开始Y坐标
		START_Y: 40,
		//显示列数
		COL_NUM: 4,
		//当前实体所在列
		CURRENT_ENTITY_COL: 0,
		//当前实体高度
		CURRENT_ENTITY_H:0,
		//下个绘制点X坐标
		NEXT_X: 0,
		//下一个绘制点Y坐标
		NEXT_Y: 0,
		//实体宽度
		ENTITY_WIDTH:260,
		//实体水平间隔
		ENTITY_HSPACE:40,
		//实体垂直间隔
		ENTITY_VSPACE:10
};

/**
 * 获得graph数据
 */
function getDisplayData(data) {
	var classJsonObj=data;
	if(!classJsonObj || !classJsonObj.graphEntityVOs || classJsonObj.graphEntityVOs.length == 0){
		return null;
	}
	var graphXMLStr = createXMLHeader(classJsonObj);
	graphXMLStr += createDescXML();
	//初始化每列的高度
	var colHeights = new Array(classOnlyConstants.COL_NUM);
	for (var j = 0; j < classOnlyConstants.COL_NUM; j++) {
		colHeights[j] = 0;
	}
	classOnlyConstants.NEXT_X = classOnlyConstants.START_X;
	classOnlyConstants.NEXT_Y = classOnlyConstants.START_Y;
	var graphEntityVOs = classJsonObj.graphEntityVOs;
	for (var i = 0; i < graphEntityVOs.length; i++) {
		var entityVO = graphEntityVOs[i];
		var entityXMLStr = createEntityXML(entityVO);
		//如果实体类的位置在第一行,不进行补全算法,第二行开始进行补全算法
		if(i < classOnlyConstants.COL_NUM - 1) {
			colHeights[i] = classOnlyConstants.CURRENT_ENTITY_H + classOnlyConstants.ENTITY_VSPACE;
			classOnlyConstants.NEXT_X += classOnlyConstants.ENTITY_WIDTH + classOnlyConstants.ENTITY_HSPACE;
		} else {
			if(i == classOnlyConstants.COL_NUM - 1) {
				colHeights[i] = classOnlyConstants.CURRENT_ENTITY_H + classOnlyConstants.ENTITY_VSPACE;
			}  else {
				colHeights[classOnlyConstants.CURRENT_ENTITY_COL] += classOnlyConstants.CURRENT_ENTITY_H + classOnlyConstants.ENTITY_VSPACE;
			}
			//获得最低高度
			var minH = Math.min.apply(null, colHeights);
			var minCol = 0;
			//循环各个列高度,只要小于或者等于该高度，就认为该列是要进行补全的列
			for (var h = 0; h < classOnlyConstants.COL_NUM; h++) {
				if(colHeights[h] <= minH) {
					classOnlyConstants.CURRENT_ENTITY_COL = h;
					classOnlyConstants.NEXT_X = classOnlyConstants.START_X + (classOnlyConstants.ENTITY_HSPACE + classOnlyConstants.ENTITY_WIDTH) * h;
					classOnlyConstants.NEXT_Y = classOnlyConstants.START_Y + colHeights[h] + classOnlyConstants.ENTITY_VSPACE;
					break;
				}
			}
		}
		graphXMLStr += entityXMLStr;					
	}
	
	var graphEntityRelaVOs = classJsonObj.graphEntityRelaVOs;
	if(graphEntityRelaVOs != undefined) {
		for (var k = 0; k < graphEntityRelaVOs.length; k++) {
			var entityRelaVO = graphEntityRelaVOs[k];
			var entityRelaXMLStr = createEntityRelaXML(entityRelaVO);
			graphXMLStr += entityRelaXMLStr;
		}
	}
	
	var graphEntityExtendVOs = classJsonObj.graphEntityExtendVOs;
	if(graphEntityExtendVOs != undefined) {
		for (k = 0; k < graphEntityExtendVOs.length; k++) {
			var entityExtendVO = graphEntityExtendVOs[k];
			var entityExtendXMLStr = createEntityExtendXML(entityExtendVO);
			graphXMLStr += entityExtendXMLStr;
		}
	}
	
	graphXMLStr += createXMLFooter(classJsonObj);
	return graphXMLStr;
}

function createDescXML() {	
	var descArray = [{
			image: "images/legend_class.png",
			label: "实体",
			image_width: 24,
			image_height: 24,
			width: 58,
			height :24
		},{
			image: "images/legend_line.png",
			label: "依赖",
			image_width: 24,
			image_height: 24,
			width: 58,
			height :24
		}];
	var descXMLStr = '';
	var ox = 23;
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

function createEntityRelaXML(entityRelaVO) {
	var entityRelaXMLStr = '<mxCell id="'
			+ Math.random()
			+ '" value="'
			+ entityRelaVO.multiple
			+ '" style="edgeStyle=elbowEdgeStyle;elbow=horizotal;endArrow=open;endSize=10;dashed=1" edge="1" parent="1" source="'
			+ entityRelaVO.sourceEntityId + '" target="'
			+ entityRelaVO.targetEntityId + '">' + '<mxGeometry as="geometry">'
			+ '<mxPoint as="sourcePoint"/>'
			+ '<mxPoint as="targetPoint"/>' + '</mxGeometry>'
			+ '</mxCell>';
	return entityRelaXMLStr;
}

function createEntityExtendXML(entityExtendVO) {
	var entityExtendXMLStr = '<mxCell id="'
			+ Math.random()
			+ '" value="" style="endArrow=block;endSize=16;endFill=0;dashed=1" edge="1" parent="1" source="'
			+ entityExtendVO.childEntityId + '" target="'
			+ entityExtendVO.parentEntityId + '">' + '<mxGeometry as="geometry">'
			+ '<mxPoint as="sourcePoint"/>'
			+ '<mxPoint as="targetPoint"/>' + '</mxGeometry>'
			+ '</mxCell>';
	return entityExtendXMLStr;
}

function createEntityXML(entityVO) {
	var entityWidth = 160;
	var entityHeight = 70;	
	var entityXMLStr ='';
	var subCellXMLStr ='&lt;div style=&quot;width:' + (classOnlyConstants.ENTITY_WIDTH - 2) +';cursor:default;&quot;&gt;';
	
	var graphAttributes = entityVO.attributes;
	subCellXMLStr += '&lt;hr color=#FFC90E size=1/&gt;';
	
	if(graphAttributes == undefined || graphAttributes.length == 0) {	
		entityHeight += 25;
	}

	if(graphAttributes != undefined && graphAttributes.length > 0) {		
		for (var i = 0; i < graphAttributes.length; i++) {
			entityHeight += 17;
			var attributeVO = graphAttributes[i];
			var attributeXMLStr = '&lt;div  style=&quot;height:'+17 +'px;font-size:12px&quot;&gt;';
			attributeXMLStr +=createAttributeXML(attributeVO);
			attributeXMLStr += '&lt;/div&gt;';
			subCellXMLStr += attributeXMLStr;
		}
	}
	
	var graphMethods = entityVO.methods;
	if(graphMethods == undefined) {
		subCellXMLStr += '&lt;div style=&quot;height:'+ 25 +'px;&quot;&gt;&lt;/div&gt;';
	}
	subCellXMLStr += '&lt;hr color=#FFC90E size=1/&gt;';
	
	if(graphMethods == undefined || graphMethods.length == 0) {	
		entityHeight += 25;
	}
	if(graphMethods != undefined && graphMethods.length > 0) {		
		for (var i = 0; i < graphMethods.length; i++) {
			entityHeight += 17;
			var method = graphMethods[i];
			var methodXMLStr = '&lt;div  style=&quot;height:'+17 +'px;font-size:12px&quot;&gt;';
			methodXMLStr +=createMethodXML(method);
			methodXMLStr+= '&lt;/div&gt;';
			subCellXMLStr += methodXMLStr;
		}
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
	
	entityXMLStr += ' style="verticalAlign=top;align=left;fontSize=12;fontFamily=Helvetica;html=1;fillColor=#FFFFFF;gradientColor=#FFF2CC;strokeColor=#FFC90E" vertex="1" parent="1">'
		+ '<mxGeometry x="' +classOnlyConstants.NEXT_X +'" y="'+ classOnlyConstants.NEXT_Y  +'" width="'+ classOnlyConstants.ENTITY_WIDTH +'" height="'
		+ entityHeight + '" as="geometry">' 
		+ '</mxGeometry></mxCell>';
	classOnlyConstants.CURRENT_ENTITY_H = entityHeight;
	return entityXMLStr;
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
