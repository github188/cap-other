var MConstants = {
		LEFT : 30,
		TOP : 30,
		LEVEL1_TITLE_HEIGHT : 70, //第一级标题的高度
		LEVEL1_PADDING : 10,
		
		LEVEL2_TITLE_HEIGHT : 50, //第二级标题的高度
		LEVEL2_PADDING : 10,
		LEVEL2_CELL_H_SPACING : 10, //二级单元格水平间隙
		LEVEL2_CELL_V_SPACING : 10, //二级单元格垂直间隙

		LEVEL3_CELL_HEIGHT : 40,
		LEVEL3_CELL_H_SPACING : 10, //三级单元格水平间隙
		LEVEL3_CELL_V_SPACING : 10 //三级单元格垂直间隙
};


var level1CellWidth = 580;

var level2CellWidth = function (childCount) {
	var level2CellWidthForOne = (level1CellWidth - MConstants.LEVEL1_PADDING * 2 - MConstants.LEVEL2_CELL_H_SPACING * 2) / 3;
	if(childCount <= 1){
		return level2CellWidthForOne;
	}
	return level1CellWidth - MConstants.LEVEL1_PADDING * 2;
}

var level2CellHeight = function (childCount) {
	var level2CellHeightForOne = MConstants.LEVEL2_TITLE_HEIGHT + MConstants.LEVEL3_CELL_HEIGHT + MConstants.LEVEL2_PADDING;
	if(childCount == 1){
		return level2CellHeightForOne;
	}
	var level2CellHeightForZero = (level2CellHeightForOne - MConstants.LEVEL2_CELL_V_SPACING) / 2;
	if(childCount == 0){
		return level2CellHeightForZero;
	}
	var lineCount = Math.floor((childCount - 1) / 3);
	return lineCount * (MConstants.LEVEL3_CELL_HEIGHT + MConstants.LEVEL3_CELL_V_SPACING) + level2CellHeightForOne; 
	
}

var level3CellWidth = function(parentWidth, count){
	if(count <= 1) {
		return parentWidth - 2 * MConstants.LEVEL2_PADDING;
	} else if(count == 2){
		return (parentWidth - 2 * MConstants.LEVEL2_PADDING - MConstants.LEVEL3_CELL_H_SPACING) / 2;
	} else {
		return (parentWidth - 2 * MConstants.LEVEL2_PADDING - MConstants.LEVEL3_CELL_H_SPACING * 2) / 3;
	}
}

function getDisplayData(data){
	if(!data){
		return null;
	}
	setLevel2Cell(data);
	
	return data;
}
 
function setLevel2Cell(data){
	if(!data.innerModuleVOList){
		data.innerModuleVOList = [];
	}
	var level2Cells = data.innerModuleVOList;
	var startPosition = {x : MConstants.LEFT + MConstants.LEVEL1_PADDING, y : MConstants.TOP + MConstants.LEVEL1_TITLE_HEIGHT};
	for (var i = 0; i < level2Cells.length; i++) {
		var level2Cell = level2Cells[i];
		var childCount = level2Cell.innerModuleVOList == null ? 0 : level2Cell.innerModuleVOList.length;
		level2Cell.x = startPosition.x;
		level2Cell.y = startPosition.y;
		level2Cell.width = level2CellWidth(childCount);
		level2Cell.height = level2CellHeight(childCount);
		setLevel3Cell(level2Cell);
		
		startPosition = getNextCellStartPosition(level2Cell);
	}
	setLevel1Cell(data);
}

function setLevel1Cell(data){
	var level2Cells = data.innerModuleVOList;
	var lastLevel2Cell = level2Cells.length == 0 ? null : level2Cells[level2Cells.length - 1];
	data.x = MConstants.LEFT;
	data.y = MConstants.TOP;
	data.width = level1CellWidth;
	if(lastLevel2Cell == null){
		data.height = MConstants.LEVEL1_TITLE_HEIGHT;
	}else{
		data.height = lastLevel2Cell.y + lastLevel2Cell.height + MConstants.LEVEL1_PADDING - MConstants.TOP;
	}
}

var level2CellForOneChildCount = 0; //二级单元格中子节点只有一个的数量
var level2CellForZeroChildCount = 0;
function getNextCellStartPosition(currentCell){
	var nextStartPostion = {};
	var childCount = currentCell.innerModuleVOList == null ? 0 : currentCell.innerModuleVOList.length;
	if(childCount >= 2){
		nextStartPostion.x = currentCell.x;
		nextStartPostion.y = currentCell.y + currentCell.height + MConstants.LEVEL2_CELL_V_SPACING;
	} else if (childCount == 1){
		level2CellForOneChildCount++;
		var nextCol = level2CellForOneChildCount % 3;
		nextStartPostion.x = MConstants.LEFT + MConstants.LEVEL1_PADDING + (level2CellWidth(1) + MConstants.LEVEL2_CELL_H_SPACING) * nextCol;
		if(nextCol == 0){
			nextStartPostion.y = currentCell.y + currentCell.height + MConstants.LEVEL2_CELL_V_SPACING;
		} else {
			nextStartPostion.y = currentCell.y;
		}
	} else {
		level2CellForZeroChildCount++;
		var fillCount = level2CellForOneChildCount % 3 == 0 ? 0 : (3 -  level2CellForOneChildCount % 3) * 2;
		if(level2CellForZeroChildCount < fillCount){
			var nextRow = level2CellForZeroChildCount % 2;
			if(nextRow == 0) {
				nextStartPostion.x = currentCell.x + level2CellWidth(1) + MConstants.LEVEL2_CELL_H_SPACING;
				nextStartPostion.y = currentCell.y - MConstants.LEVEL2_CELL_H_SPACING - level2CellHeight(0);
			}else{
				nextStartPostion.x = currentCell.x;
				nextStartPostion.y = currentCell.y + level2CellHeight(0) + MConstants.LEVEL2_CELL_V_SPACING;
			}
		}else{
			var nextCol = (level2CellForZeroChildCount - fillCount) % 3;
			nextStartPostion.x = MConstants.LEFT + MConstants.LEVEL1_PADDING + (level2CellWidth(1) + MConstants.LEVEL2_CELL_H_SPACING) * nextCol;
			if(nextCol == 0){
				nextStartPostion.y = currentCell.y + currentCell.height + MConstants.LEVEL2_CELL_V_SPACING;
			} else {
				nextStartPostion.y = currentCell.y;
			}
		}
	}
	return nextStartPostion;
}


function setLevel3Cell(level2Cell){
	var level3Cells = level2Cell.innerModuleVOList;
	if(!level2Cell.innerModuleVOList){
		level2Cell.innerModuleVOList = [];
		return;
	}
	var startPosition = {
			x : level2Cell.x + MConstants.LEVEL2_PADDING, 
			y : level2Cell.y + MConstants.LEVEL2_TITLE_HEIGHT
		};
	var childCount = level3Cells.length;
	for (var i = 0; i < childCount; i++) {
		var level3Cell = level3Cells[i];
		level3Cell.x = startPosition.x;
		level3Cell.y = startPosition.y;
		level3Cell.width = level3CellWidth(level2Cell.width, childCount);
		level3Cell.height = MConstants.LEVEL3_CELL_HEIGHT;
		var col = i % 3;
		if(col == 2){
			startPosition.x = level2Cell.x + MConstants.LEVEL2_PADDING;
			startPosition.y = level3Cell.y + level3Cell.height + MConstants.LEVEL3_CELL_V_SPACING;
		} else{
			startPosition.x = level3Cell.x + level3Cell.width + MConstants.LEVEL3_CELL_H_SPACING;
			startPosition.y = level3Cell.y;
		}
	}
}
