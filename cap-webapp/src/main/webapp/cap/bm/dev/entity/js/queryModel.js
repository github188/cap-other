/*******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd All Rights
 * Reserved. 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、 复制、修改或发布本软件.
 * 
 * 实体元数据-查询建模JS
 * 
 * @author xuchang WWW.SZCOMTOP.COM 
 * @Date 2016-07-25
 ******************************************************************************/

/**
 * select 回调方法
 * 
 * @param returnValue 返回数据
 */
function selectCallBack(returnValue) {
	//包装选择的SELECT属性集合
	var selectAttributes = wrapperSelectAttributes(returnValue.selectAttrData);

	//更新SELECT属性
	scope.selectEntityMethodVO.queryModel.select.selectAttributes = selectAttributes;

	//更新FROM属性 判断from里面是否存在对应的表别名，如果存在则不管，否则新增
	updateFromAttr(returnValue.tableAliasDataArr);

	scope.$digest();
	if (entityAttributeDialog) {
		entityAttributeDialog.hide();
	}
}

/**
 * 更新FROM区域 新增
 * 
 * @param tableAliasDataArr 表别名数组
 */
function updateFromAttr(tableAliasDataArr) {
	var pTable = scope.selectEntityMethodVO.queryModel.from.primaryTable;
	var subQuerys = scope.selectEntityMethodVO.queryModel.from.subquerys;
	var isCreatSubQuery = false;
	if (pTable == null) {
		//更新主表
		scope.selectEntityMethodVO.queryModel.from.primaryTable = {
			subTableAlias: tableAliasDataArr[0].tableAlias,
			subTableName: tableAliasDataArr[0].tableName,
			entityId: tableAliasDataArr[0].entityId
		};
		//检查是否大于1，大于1则新增字表
		if (tableAliasDataArr.length > 1) {
			for (var i = 0; i < tableAliasDataArr.length; i++) {
				if (i == 0) {
					continue;
				}
				isCreatSubQuery = true;
				createSubQueryFrom(tableAliasDataArr[i]);
			}
		}

	} else {
		var dataArr = getAllTableAlias();
		for (var i = 0; i < tableAliasDataArr.length; i++) {
			var isExist = false;
			for (var j = 0; j < dataArr.length; j++) {
				if (tableAliasDataArr[i].tableAlias == dataArr[j].subTableAlias) {
					isExist = true;
					break;
				}
			}
			if (!isExist) {
				isCreatSubQuery = true;
				createSubQueryFrom(tableAliasDataArr[i]);
			}
		}
	}

	//如果新建了SubQuery 刷新WHERE GROUP ORDER 区域 下拉列表
	if (isCreatSubQuery) {
		updateFROMSubqueryTableAlias(isCreatSubQuery, null, null);
		updateWHERETableAlias(isCreatSubQuery, null, null);
		updateORDERTableAlias(isCreatSubQuery, null, null);
		updateGROUPTableAlias(isCreatSubQuery, null, null);
	}

}

function createSubQueryFrom(subQueryData) {
	var primaryTable = scope.selectEntityMethodVO.queryModel.from.primaryTable;
	var subQuerys = scope.selectEntityMethodVO.queryModel.from.subquerys;
	subQuerys = subQuerys ? subQuerys : [];
	var primaryTable = primaryTable ? primaryTable : {};
	var primarykey = getEntityPrimary();
	var subQueryId = new Date().getTime() + "";
	var subQuery = {
		subTableName: subQueryData.tableName,
		subTableAlias: subQueryData.tableAlias,
		entityId: subQueryData.entityId,
		subQueryId: subQueryId,
		joinType: "left join",
		onLeft: {
			tableAlias: subQueryData.tableAlias,
			tableName: subQueryData.tableName,
			entityId: subQueryData.entityId,
			columnName: subQueryData.primarykey
		},
		onRight: {
			tableAlias: primaryTable.subTableAlias,
			tableName: primaryTable.subTableName,
			columnName: primarykey ? primarykey.dbFieldId : primarykey,
			columnAlias: primarykey ? primarykey.engName : primarykey,
			entityId: primaryTable.entityId
		}
	};
	subQuerys.push(subQuery);
	scope.selectEntityMethodVO.queryModel.from.subquerys = subQuerys;
}

/**
 * From子查询回调
 * 
 * @param selectDatas 起始表别名
 */
function fromCallBack(selectDatas) {
	var subQuerys = scope.selectEntityMethodVO.queryModel.from.subquerys;
	subQuerys = subQuerys ? subQuerys : [];
	//初始化主表
	initPrimaryTable(selectDatas);

	var primaryTable = scope.selectEntityMethodVO.queryModel.from.primaryTable;

	var primarykey = getEntityPrimary();
	//子表别名下标
	var index = getIndex() + 1;

	for (var i = 0; i < selectDatas.length; i++) {
		var selectData = selectDatas[i];
		var subquery = {};
		subquery.subTableName = selectData["dbObjectName"];
		subquery.subTableAlias = "t" + (index + i);
		subquery.entityId = selectData["modelId"];
		//连接类型
		subquery.joinType = "left join";
		//on左边
		subquery.onLeft = { tableAlias: "t" + (index + i), entityId: selectData["modelId"], tableName: selectData["dbObjectName"], columnName: "", columnAlias: "" };
		//on右边
		subquery.onRight = { tableAlias: primaryTable.subTableAlias, tableName: primaryTable.subTableName, columnName: primarykey ? primarykey.dbFieldId : primarykey, columnAlias: primarykey ? primarykey.engName : primarykey, entityId: primaryTable.entityId };
		//subQueryId
		subquery.subQueryId = (new Date().getTime() + i + "");
		subQuerys.push(subquery);
	}
	scope.selectEntityMethodVO.queryModel.from.subquerys = subQuerys;
	updateFROMSubqueryTableAlias(true, null, null);
	updateWHERETableAlias(true, null, null);
	updateORDERTableAlias(true, null, null);
	updateGROUPTableAlias(true, null, null);
	scope.$digest();
}

/**
 * From嵌套子查询回调
 * 
 * @param refQueryModel  
 * @param subQueryId 子查询Id 
 * @param remark 备注
 */
function fromRefQueryModelCallBack(refQueryModel, subQueryId, remark) {
	var subQuerys = scope.selectEntityMethodVO.queryModel.from.subquerys;
	subQuerys = subQuerys ? subQuerys : [];
	var primaryTable = scope.selectEntityMethodVO.queryModel.from.primaryTable;
	var defaultTableName = refQueryModel.from.primaryTable.subTableName;
	//子表别名下标
	var index = getIndex() + 1;
	var tableAliasTemp = null;
	if (!subQueryId) {//新增
		var primarykey = getEntityPrimary();
		var subquery = {};
		subquery.subTableName = defaultTableName;
		subquery.remark = cap.trim(remark);
		subquery.subTableAlias = primaryTable ? "t" + index : "t1";
		subquery.entityId = refQueryModel.from.primaryTable.entityId;
		subquery.subQueryId = (new Date().getTime() + "");
		subquery.refQueryModel = refQueryModel;
		if (primaryTable) {//新增子表
			//连接类型
			subquery.joinType = "left join";
			//on左边
			subquery.onLeft = {tableAlias: "t" + index, entityId: refQueryModel.from.primaryTable.entityId, tableName: refQueryModel.from.primaryTable.subTableName, columnName: "", columnAlias: "" };
			//on右边
			subquery.onRight = {tableAlias: primaryTable.subTableAlias, tableName: primaryTable.subTableName, columnName: primarykey ? primarykey.dbFieldId : primarykey, columnAlias: primarykey ? primarykey.engName : primarykey, entityId: primaryTable.entityId };
			subQuerys.push(subquery);
			scope.selectEntityMethodVO.queryModel.from.subquerys = subQuerys;
		}else{//新增主表
			scope.selectEntityMethodVO.queryModel.from.primaryTable = subquery;
		}
	} else { //编辑
		if (subQueryId == primaryTable.subQueryId) {
			scope.selectEntityMethodVO.queryModel.from.primaryTable.refQueryModel = refQueryModel;
			scope.selectEntityMethodVO.queryModel.from.primaryTable.subTableName = defaultTableName;
			scope.selectEntityMethodVO.queryModel.from.primaryTable.remark = cap.trim(remark);
			tableAliasTemp = scope.selectEntityMethodVO.queryModel.from.primaryTable.subTableAlias;
		} else {
			for (var i = 0; i < subQuerys.length; i++) {
				var subquery = subQuerys[i];
				if (subquery.subQueryId == subQueryId) {
					subquery.refQueryModel = refQueryModel;
					subquery.subTableName = defaultTableName;
					subquery.remark = cap.trim(remark);
					tableAliasTemp = subquery.subTableAlias; //记录当前编辑子查询的表别名
					subQuerys[i] = subquery;
				}
			}
			scope.selectEntityMethodVO.queryModel.from.subquerys = subQuerys;
		}
		//更新select
		updateSelectAttributeData(scope.selectEntityMethodVO.queryModel.select.selectAttributes, refQueryModel.select.selectAttributes, tableAliasTemp);
	}

	updateFROMSubqueryTableAlias(true, null, tableAliasTemp);
	updateWHERETableAlias(true, null, tableAliasTemp);
	updateORDERTableAlias(true, null, tableAliasTemp);
	updateGROUPTableAlias(true, null, tableAliasTemp);
	scope.$digest();
}

/**
 * where批量新增回调
 * 
 * @param reData
 */
function whereCallBack(reData) {
	var whereAttrDataArr = reData.selectAttrData;
	//查询条件
	var whereConditions = scope.selectEntityMethodVO.queryModel.where.whereConditions;
	whereConditions = whereConditions ? whereConditions : [];
	for (var i = 0; i < whereAttrDataArr.length; i++) {
		var whereCondition = {
			operatorType: whereConditions.length == 0 ? "" : "and",
			hasLeftBracket: false,
			conditionAttribute: {
				tableAlias: whereAttrDataArr[i].tableAlias,
				columnName: whereAttrDataArr[i].dbFieldId,
				entityId: whereAttrDataArr[i].entityId
			},
			wildcard: "=",
			transferValPattern: "constant",
			value: "",
			hasRightBracket: false,
			emptyCheck: true
		};
		whereConditions.push(whereCondition);
	}
	scope.selectEntityMethodVO.queryModel.where.whereConditions = whereConditions;
	scope.$digest();
	if (attrBatchUpdateDiaglog) {
		attrBatchUpdateDiaglog.hide();
	}
}

/**
 * orderBy批量新增回调
 * 
 * @param reData
 */
function orderByCallBack(reData) {
	var orderByAttrDataArr = reData.selectAttrData;
	//查询条件
	var sortConditions = scope.selectEntityMethodVO.queryModel.orderBy.sorts;
	sortConditions = sortConditions ? sortConditions : [];

	for (var i = 0; i < orderByAttrDataArr.length; i++) {
		var isExist = false;
		for (var j = 0; j < sortConditions.length; j++) {
			if (sortConditions[j].sortAttribute.tableAlias == orderByAttrDataArr[i].tableAlias && sortConditions[j].sortAttribute.columnName == orderByAttrDataArr[i].dbFieldId) {
				isExist = true;
				break;
			}
		}
		if (!isExist) {
			var sortNo = getSortNo();
			var sortCondition = {
				sortNo: sortNo,
				sortType: 'desc',
				sortAttribute: {
					tableAlias: orderByAttrDataArr[i].tableAlias,
					columnName: orderByAttrDataArr[i].dbFieldId
				}
			};
			sortConditions.push(sortCondition);
		}
	}

	if (isEmptyObject(scope.selectEntityMethodVO.queryModel.orderBy)) {
		scope.selectEntityMethodVO.queryModel.orderBy.sortEnd = "";
		scope.selectEntityMethodVO.queryModel.orderBy.dynamicOrder = false;
	}
	scope.selectEntityMethodVO.queryModel.orderBy.sorts = sortConditions;
	scope.$digest();
	if (attrBatchUpdateDiaglog) {
		attrBatchUpdateDiaglog.hide();
	}
}

/**
 * groupBy批量新增回调
 * 
 * @param reData
 */
function groupByCallBack(reData) {
	var groupByAttrDataArr = reData.selectAttrData;
	//查询条件
	var groupByAttributes = scope.selectEntityMethodVO.queryModel.groupBy.groupByAttributes;
	groupByAttributes = groupByAttributes ? groupByAttributes : [];

	for (var i = 0; i < groupByAttrDataArr.length; i++) {
		var isExist = false;
		for (var j = 0; j < groupByAttributes.length; j++) {
			if (groupByAttributes[j].tableAlias == groupByAttrDataArr[i].tableAlias && groupByAttributes[j].columnName == groupByAttrDataArr[i].dbFieldId) {
				isExist = true;
				break;
			}
		}
		if (!isExist) {
			var groupByAttribute = {
				tableAlias: groupByAttrDataArr[i].tableAlias,
				columnName: groupByAttrDataArr[i].dbFieldId
			};
			groupByAttributes.push(groupByAttribute);
		}
	}
	scope.selectEntityMethodVO.queryModel.groupBy.groupByAttributes = groupByAttributes;
	scope.$digest();
	if (attrBatchUpdateDiaglog) {
		attrBatchUpdateDiaglog.hide();
	}
}

//更新selectAttributes下的属性值变化
function updateSelectAttributes(oldTableAlias, tableAlias) {
	//当前页面中的属性
	var currentAttributes = scope.selectEntityMethodVO.queryModel.select.selectAttributes;
	currentAttributes = currentAttributes ? currentAttributes : [];
	//根据表的别名删除原有属性，加上新的
	var headArr = [];
	var endArr = [];
	var breakFlag = false; //截断标志
	for (var i = 0; i < currentAttributes.length; i++) {
		if (currentAttributes[i].tableAlias == oldTableAlias) {
			breakFlag = true;
		} else {
			if (!breakFlag) {
				headArr.push(currentAttributes[i]);
			} else {
				endArr.push(currentAttributes[i])
			}
		}

	}

	//增加子查询属性
	var all = _.union(headArr, selectAttributes);
	all = _.union(all, endArr);
	scope.selectEntityMethodVO.queryModel.select.selectAttributes = all;
}


//更新select表别名
function updateSelectTableAlias(oldTableAlias, tableAlias) {
	var currentAttributes = scope.selectEntityMethodVO.queryModel.select.selectAttributes;
	currentAttributes = currentAttributes ? currentAttributes : [];
	for (var i = 0; i < currentAttributes.length; i++) {
		if (currentAttributes[i].tableAlias == oldTableAlias) {
			currentAttributes[i].tableAlias = tableAlias;
		}
	}
}


/* 
 * 更新FROM下子查询依赖的tableAlias
 *（true,null,null)新增子查询时更新  (true,null,tableAlias)修改refquerymodel别名时更新talbeAlias和右侧下拉列表
 * @isCreatSubQuery  (false, oldTableAlias, tableAlias）修改表别名刷新 
 * @tableAlias 表别名
 */
function updateFROMSubqueryTableAlias(isCreatSubQuery, oldTableAlias, tableAlias) {

	var pTable = scope.selectEntityMethodVO.queryModel.from.primaryTable;
	var subQuerys = scope.selectEntityMethodVO.queryModel.from.subquerys;
	subQuerys = subQuerys ? subQuerys : [];
	if (!pTable) return;
	var dataArr = getAllTableAlias();

	for (var i = 0; i < subQuerys.length; i++) {
		var subQuery = subQuerys[i];

		if (!isCreatSubQuery) {
			if (subQuery.onRight.tableAlias == oldTableAlias) {
				subQuery.onRight.tableAlias = tableAlias;
			}
		}
		//更新后刷新下拉框 设法找到当前序列号
		updatePulldownTableAlias('onRightTableAlias', dataArr, subQuery.onRight.tableAlias, i);

		//左侧表别名跟新表别名相等并且是嵌套子查询，更新左侧下拉属性
		if (subQuery.onLeft.tableAlias == tableAlias && subQuery.refQueryModel) {
			var pulldownDatas = getRefQueryModelDateArr(subQuery.refQueryModel);
			updatePulldownTableAlias("onLeftColumnName", pulldownDatas, subQuery.onLeft.columnName, i);
		}
		//右侧表别名跟新表别名相等，更新右侧下拉属性
		if (subQuery.onRight.tableAlias == tableAlias) {
			//根据表别名找到查询对象的属性下拉数据源
			pulldownDatas = refQueryModelDataSource(tableAlias);
			updatePulldownTableAlias("onRightColumnName", pulldownDatas, subQuery.onRight.columnName, i);
		} else {
			updatePulldownColumns('onRightColumnName', subQuery.onRight.columnName, i);
		}
	}

	//刷新所有表别名下拉列表

}

/**
 * 更新where下依赖的tableAlias
 * 
 * @param  {Boolean} 
 * @param  {[type]}
 * @param  {[type]}
 * @return {[type]}
 */
function updateWHERETableAlias(isCreatSubQuery, oldTableAlias, tableAlias) {
	var whereConditions = scope.selectEntityMethodVO.queryModel.where.whereConditions;
	whereConditions = whereConditions ? whereConditions : [];
	var dataArr = getAllTableAlias();
	for (var i = 0; i < whereConditions.length; i++) {
		if (whereConditions[i].conditionAttribute == null) {
			continue;
		}
		//如果只是更新表别名 才重新赋值
		if (!isCreatSubQuery) {
			if (whereConditions[i].conditionAttribute.tableAlias == oldTableAlias) {
				whereConditions[i].conditionAttribute.tableAlias = tableAlias;
			}
		}
		//更新后刷新下拉框 设法找到当前序列号
		updatePulldownTableAlias('onLeftWhereCondition', dataArr, whereConditions[i].conditionAttribute.tableAlias, i);

		//根据表别名判断是否刷新右侧属性列
		if (isRefQueryModel(tableAlias, whereConditions[i].conditionAttribute.tableAlias)) {
			//根据表别名找到查询对象的属性下拉数据源
			var pulldownDatas = refQueryModelDataSource(tableAlias);
			updatePulldownTableAlias("onLeftWhereColumnName", pulldownDatas, whereConditions[i].conditionAttribute.columnName, i);
		} else {
			updatePulldownColumns('onLeftWhereColumnName', whereConditions[i].conditionAttribute.columnName, i);
		}
	}
}

/* 更新ORDER下依赖的tableAlias
 *
 *@isCreatSubQuery  是否创建了新的子表 在只是更新表别名 ，才重新赋值
 */
function updateORDERTableAlias(isCreatSubQuery, oldTableAlias, tableAlias) {
	var sortConditions = scope.selectEntityMethodVO.queryModel.orderBy.sorts;
	sortConditions = sortConditions ? sortConditions : [];
	var dataArr = getAllTableAlias();

	if (scope.selectEntityMethodVO.queryModel.orderBy.dynamicOrder) {
		var pTable = scope.selectEntityMethodVO.queryModel.from.primaryTable;
		//更新order是否动态排序别名选择框
		cui("#dynamicAttribute").setDatasource(dataArr);
		cui("#dynamicAttribute").setValue(scope.selectEntityMethodVO.queryModel.orderBy.dynamicAttribute.tableAlias);
	}
	for (var i = 0; i < sortConditions.length; i++) {
		if (!isCreatSubQuery) {
			if (sortConditions[i].sortAttribute.tableAlias == oldTableAlias) {
				sortConditions[i].sortAttribute.tableAlias = tableAlias;
			}
		}

		//更新后刷新下拉框 设法找到当前序列号
		updatePulldownTableAlias('sortAttribute', dataArr, sortConditions[i].sortAttribute.tableAlias, i);

		//根据表别名判断是否刷新右侧属性列
		if (isRefQueryModel(tableAlias, sortConditions[i].sortAttribute.tableAlias)) {
			//根据表别名找到查询对象的属性下拉数据源
			var pulldownDatas = refQueryModelDataSource(tableAlias);
			updatePulldownTableAlias("sortAttributeColumnName", pulldownDatas, sortConditions[i].sortAttribute.columnName, i);
		} else {
			updatePulldownColumns('sortAttributeColumnName', sortConditions[i].sortAttribute.columnName, i);
		}
	}
}


/* 更新GROUP下依赖的tableAlias
 *
 *@isCreatSubQuery  是否创建了新的子表 在只是更新表别名 ，才重新赋值
 */
function updateGROUPTableAlias(isCreatSubQuery, oldTableAlias, tableAlias) {
	var dataArr = getAllTableAlias();
	var groupByAttributes = scope.selectEntityMethodVO.queryModel.groupBy.groupByAttributes;
	groupByAttributes = groupByAttributes ? groupByAttributes : [];
	for (var i = 0; i < groupByAttributes.length; i++) {
		if (!isCreatSubQuery) {
			if (groupByAttributes[i].tableAlias == oldTableAlias) {
				groupByAttributes[i].tableAlias = tableAlias;
			}
		}
		//更新后刷新下拉框 设法找到当前序列号
		updatePulldownTableAlias('groupByAttr', dataArr, groupByAttributes[i].tableAlias, i);

		//根据表别名判断是否刷新右侧属性列
		if (isRefQueryModel(tableAlias, groupByAttributes[i].tableAlias)) {
			//根据表别名找到查询对象的属性下拉数据源
			var pulldownDatas = pulldownDatas = refQueryModelDataSource(tableAlias);
			updatePulldownTableAlias("groupByAttrColumnName", pulldownDatas, groupByAttributes[i].columnName, i);
		} else {
			updatePulldownColumns('groupByAttrColumnName', groupByAttributes[i].columnName, i);
		}
	}
}

//删除实体引起的删除SELECT 元素操作
function delSelectAttrForTableAlias(tableAlias) {
	var currentAttributes = scope.selectEntityMethodVO.queryModel.select.selectAttributes;
	currentAttributes = currentAttributes ? currentAttributes : [];
	for (var i = currentAttributes.length - 1; i >= 0; i--) {
		if (currentAttributes[i].tableAlias == tableAlias) {
			//删除当前元素 删除一个元素之后数组的长度会发生改变，从后开始删除
			currentAttributes.splice(i, 1);
		}
	}
}

//删除实体后只需修改From下依赖当前别名的下拉列表并设置为主表的默认值
function delFromAttrForTableAlias(tableAlias) {
	var dataArr = getAllTableAlias();
	var pTable = scope.selectEntityMethodVO.queryModel.from.primaryTable;
	var subQuerys = scope.selectEntityMethodVO.queryModel.from.subquerys;
	subQuerys = subQuerys ? subQuerys : [];
	for (var i = 0; i < subQuerys.length; i++) {
		if (subQuerys[i].onRight.tableAlias == tableAlias) {
			subQuerys[i].onRight.tableAlias = pTable.subTableAlias;
		}
		updatePulldownTableAlias('onRightTableAlias', dataArr, subQuerys[i].onRight.tableAlias, i);
	}
}

//删除实体引起的where条件依赖
function delWhereAttrForTableAlias(tableAlias) {
	var whereConditions = scope.selectEntityMethodVO.queryModel.where.whereConditions;
	whereConditions = whereConditions ? whereConditions : [];
	var dataArr = getAllTableAlias();
	//angularjs 的操作顺序是先更新数据，页面最后才发生改变
	for (var i = whereConditions.length - 1; i >= 0; i--) {
		if (whereConditions[i].conditionAttribute == null) {
			continue;
		}
		//刷新左侧表别名下拉框
		updatePulldownTableAlias('onLeftWhereCondition', dataArr, whereConditions[i].conditionAttribute.tableAlias, i);
	}
	for (var i = whereConditions.length - 1; i >= 0; i--) {
		//如果where 中存在对当前删除的依赖，则1、删除当前行,刷新左右列表
		if (whereConditions[i].conditionAttribute.tableAlias == tableAlias) {
			whereConditions.splice(i, 1);
		}
	}

}

//删除实体引起的order条件变化
function delOrderByAttrForTableAlias(tableAlias) {
	var sortConditions = scope.selectEntityMethodVO.queryModel.orderBy.sorts;
	sortConditions = sortConditions ? sortConditions : [];
	var dataArr = getAllTableAlias();
	if (scope.selectEntityMethodVO.queryModel.orderBy.dynamicOrder) {
		var pTable = scope.selectEntityMethodVO.queryModel.from.primaryTable;
		//更新order是否动态排序别名选择框
		cui("#dynamicAttribute").setDatasource(dataArr);
		cui("#dynamicAttribute").setValue(pTable.subTableAlias);
	}
	for (var i = sortConditions.length - 1; i >= 0; i--) {
		//更新后刷新下拉框 
		updatePulldownTableAlias('sortAttribute', dataArr, sortConditions[i].sortAttribute.tableAlias, i);
	}
	for (var i = sortConditions.length - 1; i >= 0; i--) {
		if (sortConditions[i].sortAttribute.tableAlias == tableAlias) {
			sortConditions.splice(i, 1);
		}
	}


}

function delGroupByAttrForTableAlias(tableAlias) {
	var dataArr = getAllTableAlias();
	var groupByAttributes = scope.selectEntityMethodVO.queryModel.groupBy.groupByAttributes;
	groupByAttributes = groupByAttributes ? groupByAttributes : [];

	for (var i = groupByAttributes.length - 1; i >= 0; i--) {
		//更新后刷新下拉框 
		updatePulldownTableAlias('groupByAttr', dataArr, groupByAttributes[i].tableAlias, i);
	}
	for (var i = groupByAttributes.length - 1; i >= 0; i--) {
		if (groupByAttributes[i].tableAlias == tableAlias) {
			groupByAttributes.splice(i, 1);
		}
	}

}

//更新左侧表别名下拉框
function updatePulldownTableAlias(id, dataArr, tableAlias, index) {
	index += 1;
	if (typeof(cui("#" + id + index).setDatasource) == 'undefined') {
		return;
	}
	cui("#" + id + index).setDatasource(dataArr);
	cui("#" + id + index).setValue(tableAlias);
}

//属性字段赋默认值
function updatePulldownColumns(id, value, index) {
	index += 1;
	if (typeof(cui("#" + id + index).setValue) == 'undefined') {
		return;
	}
	cui("#" + id + index).setValue(value);
}


function getRefQueryModelDateArr(refQueryModel) {
	var selectAttributes = refQueryModel.select.selectAttributes;
	var pulldownDatas = new Array();
	for (var j = 0; j < selectAttributes.length; j++) {
		var selectAttribute = selectAttributes[j];
		pulldownDatas.push({
			dbFieldId: selectAttribute.columnAlias
		});
	}
	return pulldownDatas;
}

/**
 * 初始化主表
 * 
 * @param  {[selectDatas]}
 * @return {[type]}
 */
function initPrimaryTable(selectDatas) {
	var primaryTable = scope.selectEntityMethodVO.queryModel.from.primaryTable;
	if (!primaryTable) {
		primaryTable = {};
		primaryTable.subTableName = selectDatas[0].dbObjectName;
		primaryTable.subTableAlias = "t1";
		primaryTable.entityId = selectDatas[0]["modelId"];
		scope.selectEntityMethodVO.queryModel.from.primaryTable = primaryTable;
		selectDatas.shift();
	}
}

/**
 * 获取表别名index
 * 
 * @return 别名index
 */
function getIndex() {
	var subQuerys = getAllTableAlias();
	var indexes = [];
	for (var i = 0; i < subQuerys.length; i++) {
		var index = subQuerys[i].subTableAlias.substring(1);
		indexes.push(index);
	}
	return Math.max.apply(Math, indexes);
}

/**
 * 是否存在重复元素
 */
function isExsitSame(currentAttributes, select) {
	for (var j = 0; j < currentAttributes.length; j++) {
		if (currentAttributes[j]["columnName"] == select["columnName"] && currentAttributes[j]["entityId"] == select["entityId"] && currentAttributes[j]["columnAlias"] == select["columnAlias"] && currentAttributes[j]["tableAlias"] == select["tableAlias"] && currentAttributes[j]["tableName"] == select["tableName"]) {
			return true;
		}
	}
	return false;
}

/**
 * 如果查询建模没有初始化将其初始化
 */
function initQueryModel() {
	if (!scope.selectEntityMethodVO.queryModel) {
		scope.selectEntityMethodVO.queryModel = {
			select: {},
			from: {},
			where: {},
			orderBy: {},
			groupBy: {},
			previewSQL: ''
		};
	}
}

/**
 * 获取当前实体主键信息
 */
function getEntityPrimary() {
	if (!entity) {
		return "";
	}

	var attributes = entity.attributes;
	for (var i = 0; i < attributes.length; i++) {
		var attr = attributes[i];
		if (attr.primaryKey) {
			return attr;
		}
	}
	return "";
}

/**
 * 初始化FROM等号左边的表别名数据源
 * 
 * @param  {[type]}
 * @return {[type]}
 */
function initLeftTableColumnAlias(obj) {
	//如果是嵌套子查询，直接取属性下拉框的，否则从后台读取对象基本属性
	var subquery = scope.selectEntityMethodVO.queryModel.from.subquerys[obj.options.index];
	if (subquery && subquery.refQueryModel) {
		setTableColumnAliasDataSource(obj, subquery);
	} else {
		var entityId = obj.options.entityid;
		dwr.TOPEngine.setAsync(false);
		EntityFacade.queryDbFieldAttributes(entityId, function(data) {
			obj.setDatasource(data.list);
		});
		dwr.TOPEngine.setAsync(true);
	}
}

/**
 * 初始化FROM等号右边的表别名数据源
 * 
 * @param  {[type]}
 * @return {[type]}
 */
function initRightTableColumnAlias(obj) {
	var rightTableAlias = obj.options.righttablealias;

	//如果是嵌套子查询设置嵌套子查询数据源
	var subquerys = getAllTableAlias();
	if (subquerys) {
		for (var j = 0; j < subquerys.length; j++) {
			if (subquerys[j].refQueryModel && rightTableAlias == subquerys[j].subTableAlias) {
				setTableColumnAliasDataSource(obj, subquerys[j]);
				return;
			}
		}
	}

	//根据左侧选择的别名找到对应的实体ID
	if (rightTableAlias != null && "" != rightTableAlias) {
		var curData = findQueryDataByTableAlias(rightTableAlias);
		var entityId = curData.entityId;
	}
	if (entityId == null || '' == entityId) {
		entityId = scope.selectEntityMethodVO.queryModel.from.primaryTable.entityId;
	}
	dwr.TOPEngine.setAsync(false);
	EntityFacade.queryDbFieldAttributes(entityId, function(data) {
		obj.setDatasource(data.list);
	});
	dwr.TOPEngine.setAsync(true);
}

/**
 *初始化表名选择
 */
function initTableAlias(obj) {
	var dataArr = getAllTableAlias();
	obj.setDatasource(dataArr);
}

//根据别名找到from中的对象
function findQueryDataByTableAlias(tableAlias) {
	var allDataArr = getAllTableAlias();
	var reData = null;
	for (var i = 0; i < allDataArr.length; i++) {
		if (allDataArr[i].subTableAlias == tableAlias) {
			reData = allDataArr[i];
		}
	}
	return reData;
}

/**
 *合并子查询和主查询数据
 */
function getAllTableAlias() {
	var dataArr = [];
	var pTable = scope.selectEntityMethodVO.queryModel.from.primaryTable;
	if (pTable) {
		//pTable.subTableAlias = pTable.subTableAlias;
		dataArr.push(pTable);
	}
	var subQuerys = scope.selectEntityMethodVO.queryModel.from.subquerys;
	if (subQuerys) {
		dataArr = _.union(dataArr, subQuerys);
	}
	return dataArr;
}

//判断对象是否为空
function isEmptyObject(obj) {
	for (var name in obj) {
		return false;
	}
	return true;
}

//判断对象不为空
function isNotEmptyObject(obj) {
	for (var name in obj) {
		return true;
	}
	return false;
}

var getWhereConditionDialog;

//获取orderby 中的序号
function getSortNo() {
	var sortNo = 1;
	var sorts = scope.selectEntityMethodVO.queryModel.orderBy.sorts;
	if (!sorts || sorts.length == 0) {
		return sortNo;
	}
	for (var i = 0; i < sorts.length; i++) {
		if (sorts[i].sortNo >= sortNo) {
			sortNo = sorts[i].sortNo;
		}
	}
	return sortNo + 1;
}

//获取表别名，默认规则为t+数字
function getTableAlias() {
	var tableAlias = "t";
	var allDataArr = getAllTableAlias();
	var sortNo = 1;
	for (var i = 0; i < allDataArr.length; i++) {
		var index = allDataArr[i].subTableAlias.substring(1);
		if (isNaN(index)) {
			continue;
		}
		if (index >= sortNo) {
			sortNo = index + 1;
		}
	}
	return tableAlias + sortNo;
}

//添加表达式脚本回调
function sqlScriptCallBack(queryAttribute, operate, oldColumnAlias) {
	var attributes = scope.selectEntityMethodVO.queryModel.select.selectAttributes;
	attributes = attributes ? attributes : [];
	if (operate && operate == "edit") {
		var newColumnAlias = queryAttribute.entityAttributeAlias;
		if (newColumnAlias == oldColumnAlias) {
			//更新sqlScript
			updateSqlScript(attributes, oldColumnAlias, queryAttribute);
			scope.$digest();
			return true;
		}
		//判断别名是否重复
		for (var i = 0; i < attributes.length; i++) {
			var attr = attributes[i];
			if (attr.columnAlias != oldColumnAlias && newColumnAlias == attr.columnAlias) {
				return false;
			}
		}
		//更新sqlScript
		updateSqlScript(attributes, oldColumnAlias, queryAttribute);
		scope.$digest();
	} else {
		for (var i = 0; i < attributes.length; i++) {
			var attr = attributes[i];
			if (attr.columnAlias == queryAttribute.entityAttributeAlias) {
				return false;
			}
		}
		var sqlScript = { columnAlias: queryAttribute.entityAttributeAlias, sqlScript: queryAttribute.sqlScript, entityId: queryAttribute.entityId, engName: queryAttribute.engName, chName: queryAttribute.chName, columnName: queryAttribute.dbFieldId };
		attributes.push(sqlScript);
		scope.selectEntityMethodVO.queryModel.select.selectAttributes = attributes;
		scope.$digest();
	}
	return true;
}

/**
 * 更新sqlScript
 */
function updateSqlScript(attributes, oldColumnAlias, queryAttribute) {
	//更新select表达式
	for (var i = 0; i < attributes.length; i++) {
		var attr = attributes[i];
		if (attr.columnAlias == oldColumnAlias) {
			var sqlScript = { columnAlias: queryAttribute.entityAttributeAlias, sqlScript: queryAttribute.sqlScript, entityId: queryAttribute.entityId, engName: queryAttribute.engName, chName: queryAttribute.chName };
			attributes[i] = sqlScript;
			break;
		}
	}
}

//自定义条件选择
function customConditionClick(param1, param2) {
	var clickinputid = param2.options.clickinputid;
	scope.customCondition = cui("#" + clickinputid).getValue();
	scope.$digest();

	var url = 'WhereCustomCondition.jsp?modelId=' + modelId + '&packageId=' + packageId + '&clickinputid=' + clickinputid;
	var width = 500; //窗口宽度
	var height = 400; //窗口高度
	var top = (window.screen.height - 30 - height) / 2;
	var left = (window.screen.width - 10 - width) / 2;
	window.open(url, "_blank", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width=" + width + " ,Height=" + height + ",top=" + top + ",left=" + left);
}

//自定义条件回调
function whereCustomConditionCallBack(data, clickinputid) {
	cui("#" + clickinputid).setValue(data.customCondition);
}

//select属性选择回调
function selectAttributeCallBack(newColumnAlias, oldColumnAlias, selectAttribute) {
	var selectAttributes = scope.selectEntityMethodVO.queryModel.select.selectAttributes;
	if (newColumnAlias == oldColumnAlias) {
		//更新select
		updateSelect(selectAttributes, oldColumnAlias, newColumnAlias, selectAttribute);
		return true;
	}
	//判断是否存在重复列别名
	for (var i = 0; i < selectAttributes.length; i++) {
		var attr = selectAttributes[i];
		if (attr.columnAlias != oldColumnAlias && newColumnAlias == attr.columnAlias) {
			return false;
		}
	}
	//更新select
	updateSelect(selectAttributes, oldColumnAlias, newColumnAlias, selectAttribute);
	return true;
}

function updateSelect(selectAttributes, oldColumnAlias, newColumnAlias, selectAttribute) {
	//更新select属性
	for (var i = 0; i < selectAttributes.length; i++) {
		var attr = selectAttributes[i];
		if (attr.columnAlias == oldColumnAlias) {
			attr.columnAlias = newColumnAlias;
			attr.sqlScript = selectAttribute.sqlScript;
			break;
		}
	}
	scope.$digest();
}

/**
 * 设置表属性下拉框数据源
 * @param obj pulldown数据源
 * @param 子查询对象
 */
function setTableColumnAliasDataSource(obj, subQuery) {
	var selectAttributes = subQuery.refQueryModel.select.selectAttributes;
	var pulldownDatas = new Array();
	for (var i = 0; i < selectAttributes.length; i++) {
		var selectAttribute = selectAttributes[i];
		pulldownDatas.push({
			dbFieldId: selectAttribute.columnAlias
		});
	}
	obj.setDatasource(pulldownDatas);
}

/**
 * 获取嵌套子查询的数据源
 * 
 * @param tableAlias 表别名
 */
function refQueryModelDataSource(tableAlias) {
	var pulldownDatas = [];
	var subQuerys = getAllTableAlias();
	for (var i = 0; i < subQuerys.length; i++) {
		var subQuery = subQuerys[i];
		if (subQuery.subTableAlias == tableAlias) {
			var selectAttributes = subQuery.refQueryModel.select.selectAttributes;
			for (var j = 0; j < selectAttributes.length; j++) {
				var selectAttribute = selectAttributes[j];
				pulldownDatas.push({
					dbFieldId: selectAttribute.columnAlias
				});
			}
			return pulldownDatas;
		}
	}

	return pulldownDatas;
}

/**
 * 是否嵌套子查询
 * 
 * @param  嵌套子查询表别名
 * @param  选中的表别名
 * @return {Boolean}
 */
function isRefQueryModel(refSubTableAlias, tableAlias) {
	var subquerys = getAllTableAlias();
	for (var i = 0; i < subquerys.length; i++) {
		if (subquerys[i].subTableAlias == refSubTableAlias && subquerys[i].refQueryModel && refSubTableAlias == tableAlias) {
			return true;
		}
	}
	return false;
}

/**
 * 判断当前查询是否嵌套子查询
 * 
 * @param  {[tableAlias]} 表别名
 * @return {Boolean}
 */
function isRef2QueryModel(tableAlias) {
	var subQuerys = getAllTableAlias();
	for (var i = 0; i < subQuerys.length; i++) {
		if (subQuerys[i].subTableAlias == tableAlias && subQuerys[i].refQueryModel) {
			return true;
		}
	};
	return false;
}

/*** 
 * addby linyuqian 20160817
 * 嵌套子查询方法回调时，更新select
 * @param selectQueryAttributes上一层select属性
 * @param subSelectQueryAttributes 嵌套子查询select属性
 * @param tableAliasTemp 表别名 所编辑的表别名
 */
function updateSelectAttributeData(selectQueryAttributes, subSelectQueryAttributes, tableAliasTemp) {
	//如果上一层的select属性列表不为空，执行过滤操作
	if (selectQueryAttributes) {
		//获取相同表别名的属性列表
		var hasSameTableAlias = getSameTableAliasAttributes(selectQueryAttributes,tableAliasTemp);
		//过滤出需要删掉的属性列表
		var delAttributesTemp = getDelAttributes(hasSameTableAlias,subSelectQueryAttributes,tableAliasTemp);
		//更新属性并刷新上一层的select属性对象
		scope.selectEntityMethodVO.queryModel.select.selectAttributes = updateAttributes(delAttributesTemp,selectQueryAttributes);
	}
}
/**
 * 找到同表别名的属性列表
 * @param selectQueryAttributes 上一层的select 对象中的属性列表
 * @param tableAliasTemp
 */
function getSameTableAliasAttributes(selectQueryAttributes,tableAliasTemp){
	var hasSameTableAlias = [];
	for (var j = 0; j < selectQueryAttributes.length; j++) {
		var selectAttribute = selectQueryAttributes[j];
		if (selectAttribute.tableAlias == tableAliasTemp) {
			hasSameTableAlias.push(selectAttribute);
		}
	}
	return hasSameTableAlias;
}

/**
 * 过滤出被删除的属性列表
 * @param hasSameTableAlias 相同表别名的属性列表
 * @param subSelectQueryAttributes 嵌套子查询返回的属性列表
 * @param tableAliasTemp 表别名
 */
function getDelAttributes(hasSameTableAlias,subSelectQueryAttributes,tableAliasTemp){
	var delFlag = true;
	var delAttributesTemp = [];
	//
	for (var i = 0; i < hasSameTableAlias.length; i++) {
		delFlag = true;
		var selectAttribute = hasSameTableAlias[i];
		for (var k = 0; k < subSelectQueryAttributes.length; k++) {
			var subSelectAttribute = subSelectQueryAttributes[k];
			if (selectAttribute.tableAlias == tableAliasTemp && selectAttribute.columnName == subSelectAttribute.columnAlias) {
				delFlag = false;
				break;
			}
		}
		if (delFlag) {
			delAttributesTemp.push(selectAttribute);
		}
	}
	return delAttributesTemp;
}
/**
 * 删除被删除的属性数据
 * @param delAttributesTemp 需要删除的属性列表
 * @param selectQueryAttributes 上一层的属性列表
 * @returns
 */
function updateAttributes(delAttributesTemp,selectQueryAttributes){
	for (var i = 0; i < delAttributesTemp.length; i++) {
		var index = _.findIndex(selectQueryAttributes, function(n) {
			return n.columnAlias == delAttributesTemp[i].columnAlias
		});
		selectQueryAttributes.splice(index, 1);
	}
	return selectQueryAttributes;
}

/**
 * 包装SELECT属性集合
 * 
 * @param  {[selectAttrData]} 选择的SELECT属性集合
 * @return {[type]}
 */
function wrapperSelectAttributes(selectAttrData) {
	var selectAttributes = [];
	for (var i = 0; i < selectAttrData.length; i++) {
		var selectAttribute = { columnName: selectAttrData[i].dbFieldId, columnAlias: selectAttrData[i].aliasName, tableAlias: selectAttrData[i].tableAlias, tableName: selectAttrData[i].tableName, entityId: selectAttrData[i].entityId, engName: selectAttrData[i].engName, chName: selectAttrData[i].chName };
		if (selectAttrData[i].sqlScript) {
			selectAttribute["sqlScript"] = selectAttrData[i].sqlScript;
		}
		selectAttributes.push(selectAttribute);
	}
	return selectAttributes;
}