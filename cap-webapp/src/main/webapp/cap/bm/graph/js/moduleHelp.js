
/**
 * 将画布分为上中下左右五个版面
 * 1 中心容器整个版面 
 * 2 中心容器占用左中右版面 外部容器占用右边版面 上下版面大小为零
 * 3 中心容器占用中版面 外部容器占用左右版面
 * 4 中心容器占用中版面 外部容器占用上下左右版面
 */ 
var Constants = {
	nodeWidth : 100, //节点宽
	nodeHeight : 65, //节点高
	nodeHorizontalSpacing : 10, //水平间距
	nodeVerticalSpacing : 10, //竖直间距
	centerNodeHorizontalPadding : 15,
	centerNodeHorizontalSpacing : 35, //水平间距
	centerNodeVerticalSpacing : 30, //竖直间距
	left : 10,
	top : 10,
	containerHorizontalSpacing : 30,
	containerVerticalSpacing : 10
};

var dataSource;
var innerNodeData = [];
var outerContainerCount;
var centerContainerNode = {};
var contanierNodes = [];
function initConstants(data){
	var len = data.dependedOutModuleRelaVOList.length + data.dependOutModuleRelaVOList.length;
	if(len <= 1){
		Constants.centerNodeHorizontalSpacing = 200;
	} else {
		Constants.centerNodeHorizontalSpacing = 35;
	}
}

function getDisplayData(data){
	//dataSource = JSON.parse(strJson);
	dataSource = data;
	if(!dataSource || !dataSource.innerModuleVOList || dataSource.innerModuleVOList.length == 0){
		return null;
	}
	
	var arrInnerModule = convertDataStructure(dataSource);
	initConstants(data);
	setNodeData(arrInnerModule);
	return generateDisplayData();
}

/**
 * 生成显示需要的数据结构 并包含连接线数据的生成
 * @returns {___anonymous1301_1302}
 */
function generateDisplayData(){
	var displayData = {};
	displayData.centerContanierNode = centerContainerNode;
	displayData.contanierNodes = contanierNodes;
	displayData.links=[];

	generateInnerNodeLinks(displayData);
	generateContainerNodeLinks(displayData);
	
	return displayData;
}
/**
 * 生成中心容器内部节点的连接线
 * @param displayData
 */
function generateInnerNodeLinks(displayData){
	var modulePositionMap = {};
	for (var i = 0; i < innerNodeData.length; i++) {
		var arrInnerNode = innerNodeData[i];
		for (var j = 0; j < arrInnerNode.length; j++) {
			var innerNode =  arrInnerNode[j];
			if(innerNode != 0){
				modulePositionMap[innerNode.moduleId] = {row : i, col : j};
			}
		}
	}
	var maxRow = innerNodeData.length - 1;
	for (var i = 0; i < innerNodeData.length; i++) {
		var arrInnerNode = innerNodeData[i];
		for (var j = 0; j < arrInnerNode.length; j++) {
			var innerNode =  arrInnerNode[j];
			if(innerNode == 0){
				continue;
			}
			var dependedInnerModuleArray = innerNode.dependedInnerModuleArray;
			for (var k = 0; k < dependedInnerModuleArray.length; k++) {
				var sourceNode = dependedInnerModuleArray[k];
				var link = generateInnerNodeLink(sourceNode, innerNode, modulePositionMap, maxRow, 2);
				if(link != null){
					displayData.links.push(link);
				}
			}
		}
	}
	
}
/**
 * 生成外部容器与中心容器的连接线
 * @param displayData
 */
function generateContainerNodeLinks(displayData){
	for (var i = 0; i < contanierNodes.length; i++) {
		var contanierNode = contanierNodes[i];
		var link = generateContainerNodeLink(contanierNode);
		if(link != null){
			displayData.links.push(link);
		}
	}
}
/**
 * 单个容器与中心容器的连接线生成
 * @param contanierNode
 * @returns {___anonymous5232_5354}
 */
function generateContainerNodeLink(contanierNode){
	
	var linkId, sourceId, targetId;

	var currentNode;
	if(contanierNode.nodes.length == 1){
		currentNode = contanierNode.nodes[0];
		if(contanierNode.type == 'source'){
			sourceId = contanierNode.nodes[0].moduleId;
			targetId = contanierNode.targetModuleId;
		}else{
			sourceId = contanierNode.sourceModuleId;
			targetId = contanierNode.nodes[0].moduleId;
		}
		linkId = "link_" + sourceId + "_" + targetId;
	}else{
		currentNode = contanierNode;
		if(contanierNode.type == 'source'){
			sourceId = contanierNode.id;
			targetId = contanierNode.targetModuleId;
		}else{
			sourceId = contanierNode.sourceModuleId;
			targetId = contanierNode.id;
		}
		linkId = "link_" + sourceId + "_" + targetId;
	}
	var linkPostion, pointX, pointY;
	if(contanierNode.col == 0){
		pointX = currentNode.X + currentNode.width + Constants.containerHorizontalSpacing/2;
		pointY = currentNode.Y;
		if(contanierNode.type == 'source'){
			linkPostion = {entryX : 0, entryY : 0.25, exitX : 1, exitY : 0.5, edgeStyle : "elbowEdgeStyle"};
		}else{
			linkPostion = {entryX : 1, entryY : 0.5, exitX : 0, exitY : 0.75, edgeStyle : "elbowEdgeStyle"};
		}
	}else if(contanierNode.col == 2){
		pointX = currentNode.X - Constants.containerHorizontalSpacing/2;
		pointY = currentNode.Y;
		if(contanierNode.type == 'source'){
			linkPostion = {entryX : 1, entryY : 0.25, exitX : 0, exitY : 0.5, edgeStyle : "elbowEdgeStyle"};
		}else{
			linkPostion = {entryX : 0, entryY : 0.5, exitX : 1, exitY : 0.75, edgeStyle : "elbowEdgeStyle"};
		}
	}else if(contanierNode.row == 0){
		if(contanierNode.type == 'source'){
			linkPostion = {entryX : 0.5, entryY : 0, exitX : 0.5, exitY : 1, edgeStyle : "elbowEdgeStyle"};
		}else{
			linkPostion = {entryX : 0.5, entryY : 1, exitX : 0.5, exitY : 0, edgeStyle : "elbowEdgeStyle"};
		}
	}else{
		if(contanierNode.type == 'source'){
			linkPostion = {entryX : 0.5, entryY : 1, exitX : 0.5, exitY : 0, edgeStyle : "elbowEdgeStyle"};
		}else{
			linkPostion = {entryX : 0.5, entryY : 0, exitX : 0.5, exitY : 1, edgeStyle : "elbowEdgeStyle"};
		}
	}
	var style = getLinkStyle(linkPostion);
	var points;
	if(pointX && pointY){
		points = [{X : pointX , Y : pointY}];
	}
	return {
		id : linkId, 
		sourceId : sourceId, 
		targetId : targetId,
		style : style,
		points : points,
		parent : 1
	};
}
/**
 * 获取连接线样式
 * @param linkPosition
 * @returns {String}
 */
function getLinkStyle(linkPosition){
	if(linkPosition == undefined){
		return "edgeStyle=none;dashed=1;endArrow=open;endSize=8";
	}
	if(linkPosition.edgeStyle == undefined){
		linkPosition.edgeStyle = "none";
	}
	return "edgeStyle=" + linkPosition.edgeStyle + ";entryX=" + linkPosition.entryX + ";entryY=" + linkPosition.entryY + 
		";exitX=" + linkPosition.exitX + ";exitY=" + linkPosition.exitY + ";dashed=1;endArrow=open;endSize=8";
}

/**
 * 中心容器内部节点的连接线
 * @param sourceNode 源节点
 * @param targetNode 目标节点
 * @param modulePositionMap 模块与模块的坐位映射表 key : moduleId , value : {row : XXX , col : XXX}
 * @param maxRow 最大行 中心容器的行数
 * @param maxCol 最大列 中心容器的列数
 * @returns
 */
function generateInnerNodeLink(sourceNode, targetNode, modulePositionMap, maxRow, maxCol){
	var parent = centerContainerNode.id;
	var sourcePosition = modulePositionMap[sourceNode.moduleId];
	var targetPosition = modulePositionMap[targetNode.moduleId];
	var linkId = "link_" + sourceNode.moduleId + "_" + targetNode.moduleId;
	if(isNeighbor(sourcePosition, targetPosition, maxRow, maxCol)){//相邻元素
		return {id : linkId, sourceId : sourceNode.moduleId, targetId : targetNode.moduleId, parent : parent, style : getLinkStyle()};
	}
	if(sourcePosition.row == targetPosition.row){//同一行
		if(sourcePosition.row == 0) {
			var pointX = sourcePosition.col > targetPosition.col ? (targetNode.X + Constants.nodeWidth) : (sourceNode.X + Constants.nodeWidth);
			var pointY = sourceNode.Y + Constants.nodeHeight + Constants.centerNodeVerticalSpacing / 2;
			var linkPostion = sourcePosition.col < targetPosition.col ? 
					{entryX : 0.25, entryY : 1, exitX : 0.75, exitY : 1, edgeStyle : "elbowEdgeStyle"} 
					: {entryX : 0.75, entryY : 1, exitX : 0.25, exitY : 1, edgeStyle : "elbowEdgeStyle"};
			var style = getLinkStyle(linkPostion);
			return {
				id : linkId, 
				sourceId : sourceNode.moduleId, 
				targetId : targetNode.moduleId,
				style : style,
				points : [{X : pointX , Y : pointY}],
				parent : parent
			};
		}else{
			var pointX = sourcePosition.col > targetPosition.col ? (targetNode.X + Constants.nodeWidth) : (sourceNode.X + Constants.nodeWidth);
			var pointY = sourceNode.Y - Constants.centerNodeVerticalSpacing / 2;
			var linkPostion = sourcePosition.col < targetPosition.col ? 
					{entryX : 0.25, entryY : 0, exitX : 0.75, exitY : 0, edgeStyle : "elbowEdgeStyle"} 
					: {entryX : 0.75, entryY : 0, exitX : 0.25, exitY : 0, edgeStyle : "elbowEdgeStyle"};
			var style = getLinkStyle(linkPostion);
			return {
				id : linkId, 
				sourceId : sourceNode.moduleId, 
				targetId : targetNode.moduleId,
				style : style,
				points : [{X : pointX , Y : pointY}],
				parent : parent
			};
		}
	}
	
	if(sourcePosition.col == targetPosition.col){
		if(sourcePosition.col == 0) {
			var pointX = sourceNode.X + Constants.nodeWidth + Constants.centerNodeHorizontalSpacing / 2;
			var pointY = sourcePosition.row > targetPosition.row ? (sourcePosition.Y - Constants.nodeHeight) : (targetNode.Y - Constants.nodeWidth);
			var linkPostion = sourcePosition.row > targetPosition.row ? 
					{entryX : 1, entryY : 0.75, exitX : 1, exitY : 0.25, edgeStyle : "elbowEdgeStyle"} 
					: {entryX : 1, entryY : 0.25, exitX :1, exitY : 0.75, edgeStyle : "elbowEdgeStyle"};
			var style = getLinkStyle(linkPostion);
			return {
				id : linkId, 
				sourceId : sourceNode.moduleId, 
				targetId : targetNode.moduleId,
				style : style,
				points : [{X : pointX , Y : pointY}],
				parent : parent
			};
		}else{
			var pointX = sourceNode.X - Constants.centerNodeHorizontalSpacing / 2;
			var pointY = sourcePosition.row > targetPosition.row ? (sourcePosition.Y - Constants.nodeHeight) : (targetNode.Y - Constants.nodeWidth);
			var linkPostion = sourcePosition.row > targetPosition.row ? 
					{entryX : 0, entryY : 0.75, exitX : 0, exitY : 0.25, edgeStyle : "elbowEdgeStyle"} 
					: {entryX : 0, entryY : 0.25, exitX :0, exitY : 0.75, edgeStyle : "elbowEdgeStyle"};
			var style = getLinkStyle(linkPostion);
			return {
				id : linkId, 
				sourceId : sourceNode.moduleId, 
				targetId : targetNode.moduleId,
				style : style,
				points : [{X : pointX , Y : pointY}],
				parent : parent
			};
		}
	}
	
	var entryX = 0, entryY = 0, exitX = 0, exitY = 0;
	if(sourcePosition.row < targetPosition.row){
		entryY = 0;
		exitY = 1;
	}else{
		entryY = 1;
		exitY = 0;
	}
	if(sourcePosition.col < targetPosition.col){
		entryX = 0;
		exitX = 1;
	}else{
		entryX = 1;
		exitX = 0;
	}
	var linkPosition = {entryX : entryX, entryY : entryY, exitX : exitX, exitY : exitY};
	return {id : linkId, sourceId : sourceNode.moduleId, targetId : targetNode.moduleId, parent : parent, style : getLinkStyle(linkPosition)};
}

/**
 * 是否为相邻元素
 * @param sourcePosition {row : XXX , col : XXX}
 * @param targetPosition {row : XXX , col : XXX}
 * @param maxRow 最大行
 * @param maxCol 最大列
 * @returns {Boolean} 相邻true，反之false
 */
function isNeighbor(sourcePosition, targetPosition, maxRow, maxCol){
	if(sourcePosition.row == targetPosition.row && (Math.abs(sourcePosition.col - targetPosition.col) == 1)){
		return true;
	}
	
	if(sourcePosition.row == targetPosition.row && sourcePosition.row != 0 && sourcePosition.row != maxRow){
		return true;
	}
	if(sourcePosition.col == targetPosition.col 
			&& (Math.abs(sourcePosition.row - targetPosition.row) == 1 || sourcePosition.col == 1)){
		return true;
	}
	return false;
}

/**
 * 转换数据结构 生成显示数据所需要用到的数据结构
 * @param dataSource
 */
function convertDataStructure(dataSource){
	var dependOutModuleVOMap = [];
	var dependedOutModuleVOMap = [];
	var innerModuleVOMap = [];
	for(var i = 0; i < dataSource.dependOutModuleVOList.length; i++){
		var moduleId = dataSource.dependOutModuleVOList[i].moduleId;
		dependOutModuleVOMap[moduleId] = dataSource.dependOutModuleVOList[i];
	}
	for(var i = 0; i < dataSource.dependedOutModuleVOList.length; i++){
		var moduleId = dataSource.dependedOutModuleVOList[i].moduleId;
		dependedOutModuleVOMap[moduleId] = dataSource.dependedOutModuleVOList[i];
	}
	for(var i = 0; i < dataSource.innerModuleVOList.length; i++){
		var moduleId = dataSource.innerModuleVOList[i].moduleId;
		innerModuleVOMap[moduleId] = dataSource.innerModuleVOList[i];
	}
	
	var arrInnerModule = [];
	for(var i = 0; i < dataSource.innerModuleVOList.length; i++){
		var innerModule = dataSource.innerModuleVOList[i];
		var innerModuleId = innerModule.moduleId;
		innerModule.dependedInnerModuleArray = [];
		innerModule.dependedOuterrModuleArray = [];
		innerModule.dependOuterrModuleArray = [];
		for(var j = 0; j < dataSource.innerModuleRelaVOList.length; j++){
			var innerModuleRelaVO = dataSource.innerModuleRelaVOList[j];
			var sourceModuleId = innerModuleRelaVO.sourceModuleId;
			var targetModuleId = innerModuleRelaVO.targetModuleId;
			var sourceModule = innerModuleVOMap[sourceModuleId];
			if(innerModuleId == targetModuleId && sourceModule){
				innerModule.dependedInnerModuleArray.push(sourceModule);
			}
		}
		for(var j = 0; j < dataSource.dependedOutModuleRelaVOList.length; j++){
			var dependedOutModuleRelaVO = dataSource.dependedOutModuleRelaVOList[j];
			var sourceModuleId = dependedOutModuleRelaVO.sourceModuleId;
			var targetModuleId = dependedOutModuleRelaVO.targetModuleId;
			var sourceModule = dependedOutModuleVOMap[sourceModuleId];
			if(innerModuleId == targetModuleId && sourceModule){
				var outerrModuleArrayNew =cui.utils.stringifyJSON(sourceModule);
				outerrModuleArrayNew = cui.utils.parseJSON(outerrModuleArrayNew);
				outerrModuleArrayNew.moduleId = outerrModuleArrayNew.moduleId + "_" + innerModuleId;
				innerModule.dependedOuterrModuleArray.push(outerrModuleArrayNew);
			}
		}
		for(var j = 0; j < dataSource.dependOutModuleRelaVOList.length; j++){
			var dependOutModuleRelaVO = dataSource.dependOutModuleRelaVOList[j];
			var sourceModuleId = dependOutModuleRelaVO.sourceModuleId;
			var targetModuleId = dependOutModuleRelaVO.targetModuleId;
			var targetModule = dependOutModuleVOMap[targetModuleId];
			if(innerModuleId == sourceModuleId && targetModule){
				var outerrModuleArrayNew =cui.utils.stringifyJSON(targetModule);
				outerrModuleArrayNew = cui.utils.parseJSON(outerrModuleArrayNew);
				outerrModuleArrayNew.moduleId = outerrModuleArrayNew.moduleId + "_" + innerModuleId;
				innerModule.dependOuterrModuleArray.push(outerrModuleArrayNew);
			}
		}
		arrInnerModule.push(innerModule);
	}
	arrInnerModule.sort(function(elme1, elme2){
		return (elme2.dependedOuterrModuleArray.length + elme2.dependOuterrModuleArray.length) 
			- (elme1.dependedOuterrModuleArray.length + elme1.dependOuterrModuleArray.length);
	});
	return arrInnerModule;
}

/**
 * 设置中心容器节点，主要是位置大小信息
 * @param arrInnerModule
 */
function setCenterContainerNode(arrInnerModule){
	centerContainerNode.id = 'container_' + dataSource.moduleId;
	centerContainerNode.nodes = arrInnerModule;
	centerContainerNode.name = dataSource.moduleName;
	centerContainerNode.moduleNameFullPath = dataSource.moduleNameFullPath;
	centerContainerNode.width = getCenterContainerNodeWidth(arrInnerModule);
	centerContainerNode.height = getCenterContainerNodeHeight(arrInnerModule);
	var containerWidth = getFirstColumnMaxContainerWidth();
	if(containerWidth > 0) {
		centerContainerNode.X = Constants.left + containerWidth + Constants.containerHorizontalSpacing;
	}else{
		centerContainerNode.X = Constants.left;
	}
	centerContainerNode.Y = Constants.top;
}
/**
 * 获取的第一列的外部容器最大的宽度，它决定了中心容器的左边距
 * @returns {Number}
 */
function getFirstColumnMaxContainerWidth(){
	var maxWidth = 0;
	var tmpWidth = 0;
	for (var i = 0; i < innerNodeData.length; i++) {
		var arrInnerNode = innerNodeData[i];
		var firstColumnInnerNode = arrInnerNode[0];
		if(firstColumnInnerNode != 0){
			tmpWidth = getContainerNodeWidth(firstColumnInnerNode.dependedOuterrModuleArray);
			maxWidth = tmpWidth > maxWidth ? tmpWidth : maxWidth;
			tmpWidth = getContainerNodeWidth(firstColumnInnerNode.dependOuterrModuleArray);
			maxWidth = tmpWidth > maxWidth ? tmpWidth : maxWidth;
		}
	}
	return maxWidth;
}

/**
 * 生成了中心容器节点及外部容器节点的大小位置
 * @param arrInnerModule
 */
function setNodeData(arrInnerModule){
	var rows = getRows(arrInnerModule);
	for (var i = 0; i < rows; i++) {
		var arr = new Array(0,0,0);
		innerNodeData.push(arr);
	}
	if(rows == 1){
		var arr = new Array(0,0,0);
		innerNodeData.push(arr);
	}
	
	var currentRow = 1;
	//设置innerNode的大小及坐标，并存放到innerNodeData中
	//设置containerNode的大小，并存放到containerNodeData中
	for (var i = 0; i < arrInnerModule.length; i++) {
		arrInnerModule[i].width = Constants.nodeWidth;
		arrInnerModule[i].height = Constants.nodeHeight;
		if(i != 0 && i % 2 == 0){
			currentRow++;
		}
		if(currentRow <= rows && i % 2 == 1){
			var tmp = 2;
			if(arrInnerModule.length == 2){
				tmp = 1;
			}
			arrInnerModule[i].X = tmp * (Constants.nodeWidth + Constants.centerNodeHorizontalSpacing) + Constants.centerNodeHorizontalPadding;
			arrInnerModule[i].Y = Math.floor(i/2) * (Constants.nodeHeight + Constants.centerNodeVerticalSpacing) + Constants.centerNodeVerticalSpacing + 20;
			innerNodeData[currentRow - 1][2] = arrInnerModule[i];
		}else if(currentRow <= rows && i % 2 == 0){//第一列
			arrInnerModule[i].X = Constants.centerNodeHorizontalPadding;
			arrInnerModule[i].Y = Math.floor(i/2) * (Constants.nodeHeight + Constants.centerNodeVerticalSpacing) + Constants.centerNodeVerticalSpacing + 20;
			innerNodeData[currentRow - 1][0] = arrInnerModule[i];
		}else{
			if(i < arrInnerModule.length){
				arrInnerModule[i].X = 1 * (Constants.nodeWidth + Constants.centerNodeHorizontalSpacing) + Constants.centerNodeHorizontalPadding;
				arrInnerModule[i].Y = Constants.centerNodeVerticalSpacing + 20;
				innerNodeData[0][1] = arrInnerModule[i];
			}
			if(i + 1 < arrInnerModule.length){
				arrInnerModule[i + 1].width = Constants.nodeWidth;
				arrInnerModule[i + 1].height = Constants.nodeHeight;
				arrInnerModule[i + 1].X = 1 * (Constants.nodeWidth + Constants.centerNodeHorizontalSpacing) + Constants.centerNodeHorizontalPadding;
				arrInnerModule[i + 1].Y = (rows - 1) * (Constants.nodeHeight + Constants.centerNodeVerticalSpacing) + Constants.centerNodeVerticalSpacing + 20;
				innerNodeData[rows - 1][1] = arrInnerModule[i + 1];
			}
			break;
		}
	}
	
	setCenterContainerNode(arrInnerModule);
	//设置容器的坐标
	setContainerNode();
}

/**
 * 外部容器节点的大小位置
 */
function setContainerNode(){
	var firstColHeight = Constants.top;
	var thirdColHeight = Constants.top;
	for (var i = 0; i < innerNodeData.length; i++) {
		var arrInnerNode = innerNodeData[i];
		if(arrInnerNode[0] != 0){
			var dependedOuterrModuleArray = arrInnerNode[0].dependedOuterrModuleArray;
			var dependedContainerNode = addContainerNode(arrInnerNode[0], true, dependedOuterrModuleArray, i, 0, firstColHeight);
			if(dependedContainerNode){
				firstColHeight += dependedContainerNode.height + Constants.containerVerticalSpacing;
			}
			var dependOuterrModuleArray = arrInnerNode[0].dependOuterrModuleArray;
			var dependContainerNode = addContainerNode(arrInnerNode[0], false, dependOuterrModuleArray, i, 0, firstColHeight);
			if(dependContainerNode){
				firstColHeight += dependContainerNode.height + Constants.containerVerticalSpacing;
			}
		}
		if(arrInnerNode[2] != 0){
			var dependedOuterrModuleArray = arrInnerNode[2].dependedOuterrModuleArray;
			var dependedContainerNode = addContainerNode(arrInnerNode[2], true, dependedOuterrModuleArray, i, 2, thirdColHeight);
			if(dependedContainerNode){
				thirdColHeight += dependedContainerNode.height + Constants.containerVerticalSpacing;
			}
			var dependOuterrModuleArray = arrInnerNode[2].dependOuterrModuleArray;
			var dependContainerNode = addContainerNode(arrInnerNode[2], false, dependOuterrModuleArray, i, 2, thirdColHeight);
			if(dependContainerNode){
				thirdColHeight += dependContainerNode.height + Constants.containerVerticalSpacing;
			}
		}
	}
	
	var secondColHeight = Constants.top;
	
	var node1 = innerNodeData[0][1];
	if(node1 != 0){
		var dependedOuterrModuleArray = node1.dependedOuterrModuleArray;
		var dependedContainerNode = addContainerNode(node1, true, dependedOuterrModuleArray, 0, 1, secondColHeight);
		if(dependedContainerNode){
			secondColHeight += dependedContainerNode.height + Constants.containerVerticalSpacing;
		}
		var dependOuterrModuleArray = node1.dependOuterrModuleArray;
		var dependContainerNode = addContainerNode(node1, false, dependOuterrModuleArray, 0, 1, secondColHeight);
		if(dependContainerNode){
			secondColHeight += dependContainerNode.height + Constants.containerVerticalSpacing;
		}
	}

	centerContainerNode.Y = secondColHeight;
	secondColHeight += centerContainerNode.height + Constants.containerVerticalSpacing;
	
	if(innerNodeData.length > 2){
		var node2 = innerNodeData[innerNodeData.length - 1][1];
		if(node2 != 0){
			var dependedOuterrModuleArray = node2.dependedOuterrModuleArray;
			var dependedContainerNode = addContainerNode(node2, true, dependedOuterrModuleArray, innerNodeData.length - 1, 1, secondColHeight);
			if(dependedContainerNode){
				secondColHeight += dependedContainerNode.height + Constants.containerVerticalSpacing;
			}
			var dependOuterrModuleArray = node2.dependOuterrModuleArray;
			var dependContainerNode = addContainerNode(node2, false, dependOuterrModuleArray, innerNodeData.length - 1, 1, secondColHeight);
			if(dependContainerNode){
				secondColHeight += dependContainerNode.height + Constants.containerVerticalSpacing;
			}
		}
	}
}

/**
 * 单个外部容器节点的大小位置信息设置 并添加到外部容器数据中
 * @param innerModule 内部节点
 * @param from true 代表外部容器依赖该内部节点 false ： 内部节点依赖该外部容器
 * @param outerrModuleArray 外部模块数组
 * @param row 第几行
 * @param col 第几列
 * @param colHeight 列高度 它确定了该外部容器阶段的上边距
 * @returns
 */
function addContainerNode(innerModule, from, outerrModuleArray, row, col, colHeight){
	if(outerrModuleArray.length == 0){
		return null;
	}
	var containerNode = {};
	if(from){
		containerNode.id = "container_from_" + innerModule.moduleId;
		containerNode.type = 'source';
		containerNode.targetModuleId = innerModule.moduleId;
	}else{
		containerNode.id = "container_to_" + innerModule.moduleId;
		containerNode.type = 'target';
		containerNode.sourceModuleId = innerModule.moduleId;
	}
	containerNode.nodes = outerrModuleArray;
	containerNode.width = getContainerNodeWidth(outerrModuleArray);
	containerNode.height = getContainerNodeHeight(outerrModuleArray);
	if(col == 0) {
		containerNode.X = centerContainerNode.X - Constants.containerHorizontalSpacing - containerNode.width;
	}else if(col == 1){
		containerNode.X = centerContainerNode.X + (centerContainerNode.width - containerNode.width)/2;
	}else{
		containerNode.X = centerContainerNode.X + centerContainerNode.width + Constants.containerHorizontalSpacing;
	}
	containerNode.Y = colHeight;
	containerNode.row = row;
	containerNode.col = col;
	setContainerNodePosition(containerNode);
	contanierNodes.push(containerNode);
	return containerNode;
}
/**
 * 设置外部容器节点的大小位置信息
 * @param contanierNode
 */
function setContainerNodePosition(contanierNode){
	var innerNodes = contanierNode.nodes;
	if(innerNodes.length == 1){
		innerNodes[0].X = contanierNode.X;
		innerNodes[0].Y = contanierNode.Y;
		innerNodes[0].width = Constants.nodeWidth;
		innerNodes[0].height = Constants.nodeHeight;
		return;
	}
	for (var i = 0; i < innerNodes.length; i++) {
		innerNodes[i].X = (i%3) * (Constants.nodeWidth + Constants.nodeHorizontalSpacing) + Constants.nodeHorizontalSpacing;
		innerNodes[i].Y = Math.floor(i/3) * (Constants.nodeHeight + Constants.nodeVerticalSpacing) + Constants.nodeVerticalSpacing;
		innerNodes[i].width = Constants.nodeWidth;
		innerNodes[i].height = Constants.nodeHeight;
	}
}
/**
 * 获取初始的容器节点的信息
 * @param innerModule
 * @returns {___anonymous23148_23149}
 */
function getContainerNode(innerModule){
	var containerNode = {};
	containerNode.id = "container_" + innerModule.moduleId;
	containerNode.nodes = innerModule.dependedOuterrModuleArray;
	containerNode.targetModuleId = innerModule.moduleId;
	containerNode.width = getContainerNodeWidth(innerModule.dependedOuterrModuleArray);
	containerNode.height = getContainerNodeHeight(innerModule.dependedOuterrModuleArray);
	return containerNode;
}
/**
 * 计算容器节点的宽度
 * @param arrNode
 * @returns {Number}
 */
function getContainerNodeWidth(arrNode){
	if(arrNode.length == 1) {
		return Constants.nodeWidth;
	}
	var cols = arrNode.length <=3 ? arrNode.length : 3;
	return Constants.nodeWidth * cols + Constants.nodeHorizontalSpacing * (cols + 1);
}
/**
 * 计算容器节点的高度
 * @param arrNode
 * @returns {Number}
 */
function getContainerNodeHeight(arrNode){
	var rows = Math.ceil(arrNode.length/3);
	return Constants.nodeHeight * rows + Constants.nodeVerticalSpacing * (rows + 1);
}

/**
 * 计算中心容器节点的宽度
 * @param arrNode
 * @returns {Number}
 */
function getCenterContainerNodeWidth(arrNode){
	var cols = arrNode.length <=3 ? arrNode.length : 3;
	return Constants.centerNodeHorizontalPadding * 2 + Constants.nodeWidth * cols + Constants.centerNodeHorizontalSpacing * (cols - 1);
}

/**
 * 计算中心容器节点的高度
 * @param arrNode
 * @returns {Number}
 */
function getCenterContainerNodeHeight(arrNode){
	var rows = getRows(arrNode);
	return Constants.nodeHeight * rows + Constants.centerNodeVerticalSpacing * (rows + 1) + 20;
}

/**
 * 获得中心容器的行数
 * @param arrNode
 * @returns {Number}
 */
function getRows(arrNode){
	var row;
	var len = arrNode.length;
	if(arrNode.length <= 3){
		row = 1;
	}else if(arrNode.length <= 6){
		row = 2;
	}else{
		row = Math.ceil((arrNode.length - 2)/2);
	}
	return row;
}
