/**
 * 自动绑定数据源
 * @param $scope 上下文对象
 * @param methodTemplate 行为模版Id
 * @param methodName 函数名称
 */
function autoBindDatasource($scope, methodTemplate, methodName){
	var methodTemplate = typeof methodTemplate != 'undefined' && methodTemplate ? methodTemplate : 'req.actionlibrary.bestPracticeAction.gridAction.action.gridDatasource';
	$scope.actionDefineVO = $scope.actionDefineVO ? $scope.actionDefineVO : getActionDefineByModelId(methodTemplate);
	var newPageActionVO = {
			pageActionId: (new Date()).valueOf() + '', 
			ename: typeof methodName != 'undefined' && methodName ? methodName :'gridDatasource', 
			cname: '初始化查询行为', 
			description: '初始化列表数据方法', 
			methodTemplate: methodTemplate, 
			methodBodyExtend: $scope.testDatasource.length > 0 ? {before: "\tgridData = " + jsCodeformatter(JSON.stringify(scope.testDatasource)).replace(/([{|}])/ig, "\t$1").replace(/\t{/, "{") + "\n\tgridDataCount = gridData.length;"} : {},
			actionDefineVO: $scope.actionDefineVO
		};
	var pageActions = pageSession.get("action");
	if(window.opener.scope.data.datasource != ''){
		if(_.find(pageActions, {pageActionId: window.opener.scope.data.datasource_id})){
			newPageActionVO.pageActionId = window.opener.scope.data.datasource_id;
		}
	} else {
		if(_.find(pageActions, {ename: newPageActionVO.ename})){
			newPageActionVO.ename += _.random(100, false);
		}
		if(_.find(pageActions, {pageActionId: newPageActionVO.pageActionId})){
			newPageActionVO.pageActionId += _.random(10000, false);
		}
		window.opener.scope.data.datasource = newPageActionVO.ename;
		window.opener.scope.data.datasource_id = newPageActionVO.pageActionId;
	}
	window.opener.parent.parent.jQuery("#actionFrame")[0].contentWindow.postMessage({type:'pageActionChange',data: newPageActionVO}, '*');
}

/**
 * 格式化js代码
 * @param txt js代码
 */
function jsCodeformatter(txt){
	return js_beautify(txt.replace(/^\s+/, ''), 8, ' ');
}

/**
 * 初始化测试数据列表
 * @param getTestData 数据源
 * @param columns 列集合
 * @param edittype 控件定义对象集
 */
function initEitableGrid(getTestData, columns, edittype){
	$("#container").empty().append("<table id=\"editgridtable\"></table>");
	cui("#editgridtable").editableGrid({
        datasource: getTestData,
        columns: columns,
        primarykey: "ID",
        selectrows:"multi",
        resizewidth: getBodyWidth,
        edittype: edittype
    });
	comtop.UI.scan("container");
}

/**
 * 插入一行数据
 */
function insertRow() {
	cui("#editgridtable").insertRow({});
}

/**
 * 删除选择行
 */
function deleteSelectedRow() {
	cui("#editgridtable").deleteSelectRow();
}

/**
 * 复制选择行
 */
function copyRow(){
	_.forEach(cui("#editgridtable").getSelectedRowData(), function(rowData, key){
		cui("#editgridtable").insertRow(rowData);
	});
}

/**
 * 根据行为Id，获取行为模版对象
 * @param propertyName 属性名称
 * @param propertyValue 属性值
 */
function getActionDefineByModelId(modelId){
	var ret = {};
	dwr.TOPEngine.setAsync(false);
	ActionDefineFacade.loadModelByModelId(modelId, function(data){
		ret = data;
	});
	dwr.TOPEngine.setAsync(true);
	return ret;
}

/**
 * 自适应Grid宽度计算
 * @returns {number}
 */
function getBodyWidth () {
    return (document.documentElement.clientWidth || document.body.clientWidth) - 10;
}

/**
 * 自适应Grid高度计算
 * @returns {number}
 */
function getBodyHeight () {
    return (document.documentElement.clientHeight || document.body.clientHeight) - 52;
}

/**
 * 复杂模型回调函数
 * @param propertyName 属性名称
 * @param propertyValue 属性值
 */
function openWindowCallback(propertyName, propertyValue){
	cui("#"+propertyName).setValue(propertyValue);
}

/**
 * 切换面板（表头结构、测试数据）
 * @param $scope 上下文对象
 * @param msg 值
 * @param arr 属性名称
 */
function showPanel($scope, msg, arr){
	if($scope[arr] === msg){
		return;
	}
	if(arr === 'table_active' && msg === 'datasource' && $scope.customHeaders.length > 0){
		var result = execValidateAll();
 	  	if(!result.validFlag){
 	  		cui.alert(result.message); 
 	  		return;
 	  	}
		var hasMultiTableHeader = _.pluck(_.sortBy($scope.customHeaders, 'level'), 'level').reverse()[0] > 1 ? true : false;
		var customHeaders = [];
		if(hasMultiTableHeader){//多表头
			var customHeaders = getMultiLineHeaders($scope.customHeaders);
			if(customHeaders.length <= 0){
				cui.error("多表头结构设置有误，不能添加数据列"); 
				return;
			} 
			if(selectrows == null || selectrows == '' || selectrows == 'multi'){
				customHeaders[0] = _.union([{rowspan:customHeaders.length,width:60,type:'checkbox'}], customHeaders[0]);
			}
		} else {
			customHeaders = $scope.customHeaders;
		}
		
		initEitableGrid(function(obj, query) {
	    	var datasource = $scope.testDatasource;
	    	obj.setDatasource(datasource, datasource.length);
	    }, customHeaders, (function(){
	    	var edittype = {};
			_.forEach(scope.customHeaders, function(obj, key){
				if(obj.bindName != '' && obj.bindName != 1){
    				edittype[obj.bindName] = {uitype: "Input", width: "100%"};
				}
			})
			return edittype;
	    })());
	} else if(cui("#editgridtable").isCUI){
		$scope.testDatasource = cui("#editgridtable").getData();
	}
	$scope[arr]=msg;
}

var bindNameValRule = [{type:'format', rule:{pattern:'^\\w+$', m:'只能输入由字母、数字或者下划线组成的字符串'}}];
var nameValRule = [{type:'required',rule:{m:'列名称不能为空'}},{type:'exclusion', rule:{within:['\\'], partialMatch:true, caseSensitive:true, allowNull: true, m:'不能输入‘\\’字符'}}];
	    
//统一校验函数
function nameValidate(){
	var validate = new cap.Validate();
	var valRule = {name: nameValRule};
	var gridCloumns = scope.customHeaders;
	return validate.validateAllElement(gridCloumns, valRule);
}

//执行校验函数
function execValidateAll(){
	var result = validateAll();
  	if(!result.validFlag){
  		return result;
  	}
	result = nameValidate();
  	if(!result.validFlag){
  		return result;
  	}
  	return result;
}

/**
 * 打开业务对象转表数据---业务对象属性选择 
 * @param domainIds
 * @param packageId
 */
function openSelectBizObjectMainWin(domainIds, packageId){
	var width=800; //窗口宽度
    var height=600; //窗口高度
    var top=(window.screen.availHeight-height)/2;
    var left=(window.screen.availWidth-width)/2;
    var url=webPath + '/cap/bm/biz/info/SelectBizObjectMain.jsp?tabLen=2&showValueFlag=false&&domainIds=' + domainIds;
    window.open(url, "selectBizObjectMain", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
} 

/**
 * 打开业务对象转表数据回调函数(批量插入数据)
 * @param datasource 业务对象属性对象集合
 */
function callbackConfirm(datasource){
	_.forEach(datasource, function(obj, key){
		_.forEach(obj.dataItems, function(dataItem, key){
			if(!_.find(scope.customHeaders, {name: dataItem.name})){
				scope.addCustomHeader({customHeaderId: (new Date()).valueOf() + key + '', name: dataItem.name, bindName: pinyin.getFullChars(dataItem.name).toLowerCase().replace(/[^a-z|0-9|\_]/ig, ""), sort: 'false', hide: 'false', disabled: 'false', level: 1, indent:'', edittype:{data:{}}});
			}
		});
	});
	cap.digestValue(scope);
}

/**
 * 根据子功能项获取业务域Id
 * @param reqFunSubItemId 功能子项ID
 */
function getDomainId(reqFunSubItemId){
	var ret = '';
	dwr.TOPEngine.setAsync(false);
	ReqFunctionSubitemAction.queryDomainByfuncSubId(reqFunSubItemId, function(data){
		ret = data ? data.id : ret;
	});
	dwr.TOPEngine.setAsync(true);
	return ret;
}

/**
 * uitype下拉框赋值
 * @param obj 下拉框dom对象
 */
function initUItypeData(obj){
	dwr.TOPEngine.setAsync(false);
	ComponentFacade.queryComponentList('edittype', ['req'], function(data){
		var datasource = [];
		for(var key in data){
			datasource.push({id:data[key].modelName, text: data[key].modelName});
		}
		obj.setDatasource(datasource);
	});
	dwr.TOPEngine.setAsync(true);
}
