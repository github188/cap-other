//类图变量
var erConstants = {	
		//开始X坐标
		START_X: 30,
		//开始Y坐标
		START_Y: 40,
		//显示列数
		COL_NUM: 4,
		//当前所在列
		CURRENT_COL: 0,
		//当前高度
		CURRENT_H:0,
		//下个绘制点X坐标
		NEXT_X: 0,
		//下一个绘制点Y坐标
		NEXT_Y: 0,
		//实体宽度
		WIDTH:260,
		//实体水平间隔
		HSPACE:40,
		//实体垂直间隔
		VSPACE:10
};

/**
 * 是否为空数据
 * @param requestData 
 * @returns {Boolean}
 */
function isEmptyData(data){
	if(!data) {
		return true;
	}
	if(data.tables && data.tables.length > 0){
		return false;
	}
	if(data.views && data.views.length > 0){
		return false;
	}
	return true;
}

/**
 * 获得graph数据
 */
function getDisplayData(data) {
	var erJsonObj=data;
	if(isEmptyData(data)){
		return null;
	}
	var graphXMLStr = createXMLHeader(erJsonObj);
	graphXMLStr += createDescXML();
	//初始化每列的高度
	var colHeights = new Array(erConstants.COL_NUM);
	for (var j = 0; j < erConstants.COL_NUM; j++) {
		colHeights[j] = 0;
	}
	erConstants.NEXT_X = erConstants.START_X;
	erConstants.NEXT_Y = erConstants.START_Y;
	var tables = erJsonObj.tables;
	var views = erJsonObj.views;
	var references = erJsonObj.references;
	
	//生成数据库表
	if(tables && tables.length > 0) {
		for (var i = 0; i < tables.length; i++) {
			var table = tables[i];
			var tableXMLStr = createTableXML(table);
			//如果表的位置在第一行,不进行补全算法,第二行开始进行补全算法
			if(i < erConstants.COL_NUM - 1) {
				colHeights[i] = erConstants.CURRENT_H + erConstants.VSPACE;
				erConstants.NEXT_X += erConstants.WIDTH + erConstants.HSPACE;
			} else {
				if(i == erConstants.COL_NUM - 1) {
					colHeights[i] = erConstants.CURRENT_H + erConstants.VSPACE;
				}  else {
					colHeights[erConstants.CURRENT_COL] += erConstants.CURRENT_H + erConstants.VSPACE;
				}
				//获得最低高度
				var minH = Math.min.apply(null, colHeights);
				var minCol = 0;
				//循环各个列高度,只要小于或者等于该高度，就认为该列是要进行补全的列
				for (var h = 0; h < erConstants.COL_NUM; h++) {
					if(colHeights[h] <= minH) {
						erConstants.CURRENT_COL = h;
						erConstants.NEXT_X = erConstants.START_X + (erConstants.HSPACE + erConstants.WIDTH) * h;
						erConstants.NEXT_Y = erConstants.START_Y + colHeights[h] + erConstants.VSPACE;
						break;
					}
				}
			}
			graphXMLStr += tableXMLStr;					
		}
	}
	
	//生成数据库表
	if(views && views.length > 0) {
		for (var j = 0; j < views.length; j++) {
			var view = views[j];
			var viewXMLStr = createViewXML(view);
			//加上表的个数计算，如果视图的位置在第一行,不进行补全算法,第二行开始进行补全算法
			if(i + tables.length < erConstants.COL_NUM - 1) {
				colHeights[i + tables.length] = erConstants.CURRENT_H + erConstants.VSPACE;
				erConstants.NEXT_X += erConstants.WIDTH + erConstants.HSPACE;
			} else {
				if(i + tables.length == erConstants.COL_NUM - 1) {
					colHeights[i + tables.length] = erConstants.CURRENT_H + erConstants.VSPACE;
				}  else {
					colHeights[erConstants.CURRENT_COL] += erConstants.CURRENT_H + erConstants.VSPACE;
				}
				//获得最低高度
				var minH = Math.min.apply(null, colHeights);
				var minCol = 0;
				//循环各个列高度,只要小于或者等于该高度，就认为该列是要进行补全的列
				for (var k = 0; k < erConstants.COL_NUM; k++) {
					if(colHeights[k] <= minH) {
						erConstants.CURRENT_COL = k;
						erConstants.NEXT_X = erConstants.START_X + (erConstants.HSPACE + erConstants.WIDTH) * k;
						erConstants.NEXT_Y = erConstants.START_Y + colHeights[k] + erConstants.VSPACE;
						break;
					}
				}
			}
			graphXMLStr += viewXMLStr;					
		}
	}
	
	//主表与字表的关联
	//生成数据库表
	if(tables && tables.length > 0) {
		for (var i = 0; i < tables.length; i++) {
			var table = tables[i];
			if(table.references && table.references.length > 0) {
				var references = table.references;
				for (var j = 0; j < references.length; j++) {
					var reference = references[j];
					var referenceXMLStr = createReferenceXML(reference,table);
					graphXMLStr += referenceXMLStr;
				}
			}
		}
	}
		
	graphXMLStr += createXMLFooter(erJsonObj);
	return graphXMLStr;
}

function createDescXML() {	
	var descArray = [{
			image: "images/legend_table.png",
			label: "表",
			image_width: 24,
			image_height: 24,
			width: 50,
			height :24
		},{
			image: "images/legend_view.png",
			label: "视图",
			image_width: 24,
			image_height: 24,
			width: 58,
			height :24
		},{
			image: "images/legend_ref.png",
			label: "关联",
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

function createReferenceXML(reference,table) {
	var childTable = reference.childTable;
	var referenceXMLStr = '<mxCell id="'
			+ Math.random()
			+ '" style="edgeStyle=elbowEdgeStyle;elbow=vertical;endSize=10;dashed=0" edge="1" parent="1" source="'
			+ childTable.code + '" target="'
			+ table.code + '">' + '<mxGeometry as="geometry">'
			+ '<mxPoint as="sourcePoint"/>'
			+ '<mxPoint as="targetPoint"/>' + '</mxGeometry>'
			+ '</mxCell>';
	return referenceXMLStr;
}

function createTableXML(table) {
	var tableWidth = 160;
	var tableHeight = 70;	
	var tableXMLStr ='';
	var subCellXMLStr ='&lt;div style=&quot;width:' + (erConstants.WIDTH - 2) +';cursor:default;&quot;&gt;';
	
	var columns = table.columns;
	subCellXMLStr += '&lt;hr color=#0ACCF5 size=1/&gt;';
	
	if(columns == undefined || columns.length == 0) {	
		tableHeight += 25;
	}

	if(columns != undefined && columns.length > 0) {		
		for (var i = 0; i < columns.length; i++) {
			tableHeight += 17;
			var column = columns[i];
			var columnXMLStr = '&lt;div  style=&quot;height:'+17 +'px;font-size:12px&quot;&gt;';
			columnXMLStr +=createColumnXML(column);
			columnXMLStr += '&lt;/div&gt;';
			subCellXMLStr += columnXMLStr;
		}
	}
	
	subCellXMLStr += '&lt;/div&gt;';
	
	tableXMLStr += '<mxCell id="'
		+ table.code
		+ '" value="&lt;p style=&quot;margin:0px;margin-top:4px;text-align:center;&quot;&gt;&lt;b&gt;'
		+ table.chName
		+ '&lt;/b&gt;&lt;br/&gt;&lt;b&gt;'
		+ table.engName
		+ '&lt;/b&gt;&lt;/p&gt;';
	
	tableXMLStr += subCellXMLStr;
	tableXMLStr += '"';
	
	tableXMLStr += ' style="verticalAlign=top;align=left;fontSize=12;fontFamily=Helvetica;html=1;fillColor=#FFFFFF;gradientColor=#CCE4FD;strokeColor=#0ACCF5;strokeWidth=1" vertex="1" parent="1">'
		+ '<mxGeometry x="' +erConstants.NEXT_X +'" y="'+ erConstants.NEXT_Y  +'" width="'+ erConstants.WIDTH +'" height="'
		+ tableHeight + '" as="geometry">' 
		+ '</mxGeometry></mxCell>';
	erConstants.CURRENT_H = tableHeight;
	return tableXMLStr;
}

function createColumnXML(column) {
	var columnXMLStr = column.engName + ' : ' + column.dataType;
	if(column.isPrimaryKEY == true) {
		columnXMLStr = '&lt;u&gt;' + columnXMLStr + ' : pk' + '&lt;/u&gt;';
	}
	if(column.isForeignKey == true) {
		columnXMLStr = '&lt;u&gt;' + columnXMLStr + ' : fk'+ '&lt;/u&gt;';
	}
	return columnXMLStr;
}

function createViewXML(view) {
	var viewWidth = 160;
	var viewHeight = 70;	
	var viewXMLStr ='';
	var subCellXMLStr ='&lt;div style=&quot;width:' + (erConstants.WIDTH - 2) +';cursor:default;&quot;&gt;';
	
	var columns = view.columns;
	subCellXMLStr += '&lt;hr color=#8481C0 size=1/&gt;';
	
	if(columns == undefined || columns.length == 0) {	
		viewHeight += 25;
	}

	if(columns != undefined && columns.length > 0) {		
		for (var i = 0; i < columns.length; i++) {
			viewHeight += 17;
			var column = columns[i];
			var columnXMLStr = '&lt;div  style=&quot;height:'+17 +'px;font-size:12px&quot;&gt;';
			columnXMLStr +=createColumnXML(column);
			columnXMLStr += '&lt;/div&gt;';
			subCellXMLStr += columnXMLStr;
		}
	}
	
	subCellXMLStr += '&lt;/div&gt;';
	
	viewXMLStr += '<mxCell id="'
		+ view.engName
		+ '" value="&lt;p style=&quot;margin:0px;margin-top:4px;text-align:center;&quot;&gt;&lt;b&gt;'
		+ view.chName
		+ '&lt;/b&gt;&lt;br/&gt;&lt;b&gt;'
		+ view.engName
		+ '&lt;/b&gt;&lt;/p&gt;';
	
	viewXMLStr += subCellXMLStr;
	viewXMLStr += '"';
	
	viewXMLStr += ' style="verticalAlign=top;align=left;fontSize=12;fontFamily=Helvetica;html=1;fillColor=#FFFFFF;gradientColor=#D6D6FF;strokeColor=#8481C0;strokeWidth=1" vertex="1" parent="1">'
		+ '<mxGeometry x="' +erConstants.NEXT_X +'" y="'+ erConstants.NEXT_Y  +'" width="'+ erConstants.WIDTH +'" height="'
		+ viewHeight + '" as="geometry">' 
		+ '</mxGeometry></mxCell>';
	erConstants.CURRENT_H = viewHeight;
	return viewXMLStr;
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
