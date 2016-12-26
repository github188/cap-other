<%
  /**********************************************************************
	* 数据库模型编辑页面
	* 2016-11-7 许畅 新建
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>

<!doctype html>
<html ng-app="tableModel">
<head>
<title>数据库表信息</title>
    <link rel="shortcut icon" href="${pageScope.cuiWebRoot}/cap/ptc/index/image/table.png">
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/dev/page/uilibrary/css/base.css"/>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <style type="text/css">
      .cap-td-label{
      	text-align: right;
      	width: 150px;
      }
      .cap-td-container{
      	text-align: left;
      	padding-right: 0;
      }
      .input-shadow{
      	width: 93%;
  	    padding: 4px 5px;
  	    height: 18px;
  	    line-height: 18px;
  	    overflow: hidden;
  	    border: 1px solid #ccc;
  	    border-radius: 3px;
  	    box-shadow: 0 2px 2px rgba(0,0,0,.1) inset;
      }
      .input-required{
      	border: 1px solid red;
      }
    </style>
    
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
    <top:script src="/cap/bm/common/base/js/validate.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/bm/dev/entity/js/lodash.js"></top:script>
	
	<top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src="/cap/dwr/interface/TableFacade.js"></top:script>
</head>

<body style="background-color:#f5f5f5;" ng-controller="tableModelController" data-ng-init="ready()">
<div class="cap-page">
    <div class="cap-area" style="height: 100%; overflow-y: auto; padding: 5px;">

        <div style="text-align: left;font-weight: bold;font-size: 16px;color: #0099FF;padding-left: 14px;padding-bottom: 14px;"> 数据库表信息 </div>

		<div style="clear: both;">
		   <div style="float:left;">
			   <span>
		        	<blockquote class="cap-form-group">
						<span>基本信息</span>
					</blockquote>
			    </span>
		   </div>
		    
		    <div class="toolbar" style="float:right;margin-bottom:10px;">
		    	<span cui_button id="save" ng-click="saveModel()" icon="file-text-o" label="保存"></span>
		    	<span uitype="button" id="sysnc_menu" label="数据同步" menu="sysnc_menu"></span>
		    	<span cui_button id="bizImport" ng-if="domainIds" ng-click="bizImport()" icon="folder-open-o" label="业务对象导入"></span>
			    <span cui_button id="close" ng-click="close()" ng-if="!openType" label="关闭"></span>
	        </div>
		</div>

        <!-- 表基本信息 -->
		<table class="cap-table-fullWidth" style="margin-bottom: 10px;">
			<tr>
				<td class="cap-td cap-td-label" width="7%"><a style="color:red;">*</a>表名:</td>
				<td class="cap-td cap-td-container" width="43%"><input type="text" maxlength="30" style="{{isTableExsit ? 'background: #f5f5f5;' : ''}}  " id="engName" class="input-shadow" ng-class="(!isTableNameLegal) ? 'input-required':''"  ng-model="tableData.engName" ng-change="tableEngNameChange(tableData.engName,tableData)" ng-disabled="isTableExsit" style="width: 100%"></td>

				<td class="cap-td cap-td-label" width="10%">中文名:</td>
				<td class="cap-td cap-td-container" width="40%"><span cui_input id="chName" ng-model="tableData.chName" width="100%"/></td>
			</tr>

			<tr>
				<td class="cap-td cap-td-label">描述:</td>
				<td class="cap-td cap-td-container" colspan="3">
                   <span cui_textarea id="description" ng-model="tableData.description" width="100%"></span>
				</td>
			</tr>
		</table>

		<div style="clear: both;">
		   <div style="float:left;">
			   <span>
		        	<blockquote class="cap-form-group">
						<span>列信息</span>
					</blockquote>
			    </span>
		   </div>
		   <span cui_button icon="plus" style="float:left;margin-bottom:5px;" id="addNewLine" ng-click="addNewLine()" label="新增行"></span>
		   <span cui_button icon="minus" style="float:left;margin-left:5px;" id="deleteLine" ng-click="deleteLine()" label="删除行"></span>
		   <span cui_button icon="plus" style="float:left;margin-left:5px;" id="addWorkflowColumn" ng-click="addWorkflowColumn()" label="新增流程字段"></span>
		</div>
		
		<!--  列信息 -->
		<table class="custom-grid" style="width: 100%">
			<thead>
			   <tr>
				   <th style="width:40px;">
				      序号
				   </th>
				   <th>
				      字段名
				   </th>
				   <th>
				      备注
				   </th>
				   <th>
			          数据类型        
				   </th>
				   <th>
			          长度                   
				   </th>
			   	   <th>
			          精度                      
			   	   </th>
		   	   	   <th>
		   	          默认值                    
		   	   	   </th>
		   	   	   <th style="width:80px;">
		   	          是否允许为空                      
		   	   	   </th>
	   	   	   	   <th>
	   	   	          中文名称     
	   	   	   	   </th>
			   </tr>
			</thead>
		    <tbody>
	           <tr ng-repeat="column in tableData.columns" style="background-color: {{$index == selectedIndex ? '#99ccff' : '#ffffff'}}" ng-click="rowClick(column,$index)">
	                 <td>
	                     <span>{{ $index+1 }}</span>
	                 </td>
	                 <td class="notUnbind" style="text-align: left;">
	                      <span>
	                      	<image ng-if="column.isPrimaryKEY" src="${cuiWebRoot}/cap/bm/dev/entity/images/zhujian.jpg">
	                      	<span ng-if="column.isPrimaryKEY"> {{ column.engName }} </span>
	                      	<input type="text" ng-if="!column.isPrimaryKEY" maxlength="32" class="input-shadow" ng-model="column.engName" ng-disabled="column.isPrimaryKEY" ng-class="column.isColumnNameLegal==false ? 'input-required':''" ng-change="engNameChange(column.engName,column)">
	                      </span>
	                 </td>
	                 <td style="text-align: left;" class="notUnbind" >
	                      <span>
	                      	<input type="text" class="input-shadow" ng-model="column.description" ng-class="!column.description ? 'input-required':''" ng-change="descriptionChange(column.description,column)">
	                      </span>
	                 </td>
	                  <td style="text-align:left;cursor:pointer" class="notUnbind" >
                      	<span cui_pulldown id="dataType" readonly="{{ column.isPrimaryKEY }}" ng-change="dataTypeChange(column.dataType,column)" ng-model="column.dataType" editable="false" value_field="id" label_field="text" width="100%">
							<a value="CHAR">CHAR</a>
							<a value="VARCHAR2">VARCHAR2</a>
							<a value="NVARCHAR2">NVARCHAR2</a>
							<a value="NUMBER">NUMBER</a>
							<a value="TIMESTAMP">TIMESTAMP</a>
							<a value="BLOB">BLOB</a>
							<a value="CLOB">CLOB</a>
						 </span>
	                 </td>
	                 <td style="text-align: left;" class="notUnbind">
	                      <span>
	                      	<input type="number" class="input-shadow" min="1" max="{{column.dataType=='NUMBER' ? '38':'' }}" ng-keydown="keydown()" ng-class="column.length==null || column.length<0 ? 'input-required':''" ng-model="column.length" ng-change="lengChange(column.length,column.dataType,column)" style="{{(column.dataType=='TIMESTAMP' || column.isPrimaryKEY || column.dataType=='BLOB' || column.dataType=='CLOB') ? 'background: #f5f5f5;':''}}" ng-disabled="column.dataType=='TIMESTAMP' || column.isPrimaryKEY || column.dataType=='BLOB' || column.dataType=='CLOB'">
	                      </span>
	                 </td>
	                 <td style="text-align: left;" class="notUnbind" >
	                      <span>
	                      	<input type="number" class="input-shadow" ng-keydown="keydown()" min="0" ng-class="column.precision==null || column.precision<0 ? 'input-required':''" ng-model="column.precision" style="{{(column.dataType!='NUMBER') ? 'background: #f5f5f5;':'' }}" ng-disabled="column.dataType!='NUMBER' ">
	                      </span>
	                 </td>

	                 <td style="text-align: left;" class="notUnbind" >
	                      <span>
	                      	<input type="number" class="input-shadow" ng-if="column.dataType=='NUMBER'" min="0" ng-model="column.defaultValue" style="{{(column.isPrimaryKEY) ? 'background: #f5f5f5;':''}}" ng-disabled="column.isPrimaryKEY">
	                      	<input type="text" class="input-shadow" ng-if="column.dataType!='NUMBER' && column.dataType!='TIMESTAMP'" ng-model="column.defaultValue" style="{{(column.isPrimaryKEY) ? 'background: #f5f5f5;':''}}" ng-disabled="column.isPrimaryKEY">
  	                      	<span cui_pulldown id="defaultValue" ng-if="column.dataType=='TIMESTAMP'" ng-model="column.defaultValue" editable="false" value_field="id" label_field="text" width="100%">
  								<a value="">无</a>
  								<a value="sysdate">系统日期</a>
  							 </span>
	                      </span>
	                 </td>

	                 <td style="text-align:center;" class="notUnbind" >
						 <input type="checkbox" ng-model="column.canBeNull" ng-disabled="column.isPrimaryKEY">
	                 </td>
	                 <td style="text-align: left;" class="notUnbind" >
	                      <span>
	                      <input type="text" class="input-shadow" style="background: #f5f5f5;" ng-model="column.chName" ng-disabled="true">
	                      </span>
	                 </td>
	           </tr>
	           <tr ng-if="!tableData.columns || tableData.columns.length == 0">
	                 <td colspan="8" class="grid-empty"> 本列表暂无记录</td>
	           </tr>
		    </tbody>
	    </table>
    </div>
</div>	

<script type="text/javascript">
var openType = "${param.openType}"; //listToMain
var packageId = "${param.packageId}"; //包ID
var modelId = "${param.modelId}"; //表ID
var packagePath = "${param.packagePath}"; //包路径
var funcCode = "${param.funcCode}";//应用名
var tableData = {};
var selectedColumn = {};
var sysncDataBaseDialog;
var bizObjDialog;
var createTableDialog;
var sysncToEntityDialog;
angular.module('tableModel', ["cui"]).controller('tableModelController', function($scope) {
	$scope.tableData = tableData;
	$scope.selectedColumn = selectedColumn;
	$scope.openType = openType;
	$scope.funcCode = funcCode;
	$scope.isTableExsit = true;
	$scope.isTableNameLegal = true;

	$scope.ready = function() {
		comtop.UI.scan();
		$scope.resizeHeight();
		scope = $scope;
		$scope.init();
	};

	$scope.resizeHeight = function(){
		$(".cap-page").css("height", $(window).height()-30);
		$(window).resize(function(){
	       jQuery(".cap-page").css("height", $(window).height()-30);
	    });
	}
	
	/**
	 * 页面初始化
	 * 
	 * @return {[type]} [description]
	 */
	$scope.init = function() {
		if (modelId) {
			$scope.initEdit();
		} else {
			$scope.initAddNew();
		}
		//数据库已有的表,表名不允许修改
		$scope.initBizControl();
	};

	/**
	 * 初始化编辑界面数据
	 * 
	 * @return {[type]} [description]
	 */
	$scope.initEdit = function() {
		dwr.TOPEngine.setAsync(false);
		TableFacade.queryTableById(modelId, function(data) {
			$scope.tableData = data;
			$scope.setSelectedRow($scope.tableData.columns[0], 0);
			$scope.formatDefaultValue();
		});
		dwr.TOPEngine.setAsync(true);
	}

	/**
	 * 如果数据类型为NUMBER类型默认值转换为NUMBER类型,解决angular js转换问题
	 * 
	 * @return {[type]} [description]
	 */
	$scope.formatDefaultValue = function() {
		$scope.tableData.columns.forEach(function(item, index, array) {
			if (item.dataType == 'NUMBER') {
				item.defaultValue = (item.defaultValue != null && item.defaultValue != '') ? Number(item.defaultValue) : item.defaultValue;
			}
		});
	}

	/**
	 * 初始化新增界面数据
	 * 
	 * @return {[type]} [description]
	 */
	$scope.initAddNew = function() {
		$scope.tableData = window.opener.tableData;
		$scope.setSelectedRow($scope.tableData.columns[0], 0);
	};

	/**
	 * 初始化业务控制
	 * 
	 * @return {[type]} [description]
	 */
	$scope.initBizControl = function() {
		dwr.TOPEngine.setAsync(false);
		TableFacade.initTableBizControl($scope.tableData.engName, $scope.funcCode, function(map) {
			$scope.isTableExsit = map.isTableExsit;
			$scope.initDomainIds(map.reqTreeVOs);
		});
		dwr.TOPEngine.setAsync(true);
	}
	/**
	 * 初始化域id集合
	 * 
	 * @param  {[type]} res [description]
	 * @return {[type]}     [description]
	 */
	$scope.initDomainIds = function(res) {
		var strDomainIds = "";
		if (res) {
			for (var i = 0; i < res.length; i++) {
				if (i == res.length - 1) {
					strDomainIds = strDomainIds + res[i].id;
				} else {
					strDomainIds = strDomainIds + res[i].id + ",";
				}
			}
		}
		$scope.domainIds = strDomainIds;
	};

	/**
	 * 行点击事件
	 * 
	 * @param  {[type]} column [description]
	 * @return {[type]}        [description]
	 */
	$scope.rowClick = function(column ,index) {
		$scope.setSelectedRow(column, index);
	};

	/**
	 * 设置选中和下标
	 * 
	 * @param {[type]} column [description]
	 * @param {[type]} index  [description]
	 */
	$scope.setSelectedRow = function(column, index) {
		$scope.selectedColumn = column;
		$scope.selectedIndex = index;
	};

	/**
	 * 保存并同步实体
	 * 
	 * @param  {Function} fn [description]
	 * @return {[type]}      [description]
	 */
	$scope.saveModel = function(fn) {
		//保存时业务校验
		if (!$scope.validateColumns())
			return;

		dwr.TOPEngine.setAsync(false);
		TableFacade.saveModel($scope.tableData, {
			callback: function(data) {
				if (fn) {
					(fn());
				} else {
					cui.message("保存成功.", "success");
					$scope.changeUrlNotRefreshWindow();
				}
				$scope.refreshParentWindow();
			},
			errorHandler: function(message, exception) {
				cui.message("执行失败:" + message, "error");
			}
		});
		dwr.TOPEngine.setAsync(true);
	};

    /**
     * 同步全部
     * 
     * @param  {Function} fn [description]
     * @return {[type]}      [description]
     */
	$scope.saveAndSysncEntity = function(fn) {
		//保存时业务校验
		if (!$scope.validateColumns())
			return;

		dwr.TOPEngine.setAsync(false);
		TableFacade.saveAndSysncEntity($scope.tableData, packageId, {
			callback: function(data) {
				if (fn) {
					(fn());
				} else {
					$scope.changeUrlNotRefreshWindow();
					cui.message("保存并同步成功.", "success");
				}
				$scope.refreshParentWindow();
			},
			errorHandler: function(message, exception) {
				cui.message("执行失败:" + message, "error");
			}
		});
		dwr.TOPEngine.setAsync(true);
	};

	/**
	 * 分析差异
	 * 
	 * @return {[type]} [description]
	 */
	$scope.analyzeDifferent = function() {
		dwr.TOPEngine.setAsync(false);
		TableFacade.analyzeDifferent($scope.tableData, packageId, {
			callback: function(data) {
				$scope.dataStorage = data;
				$scope.changeUrlNotRefreshWindow();
			},
			errorHandler: function(message, exception) {
				cui.message("执行失败:" + message, "error");
			}
		});
		dwr.TOPEngine.setAsync(true);
	}

	/**
	 * 同步至实体
	 * 
	 * @return {[type]} [description]
	 */
	$scope.sysncToEntity = function() {
		//保存时业务校验
		if (!$scope.validateColumns())
			return;

		if (!$scope.isTableExsit) {
			cui.confirm('当前表不存在,请先同步数据库后再同步实体.', {
				buttons: [{
					name: '是',
					handler: function() {
						$scope.sysncDataBase();
					}
				}, {
					name: ' 否',
					handler: function() {}
				}]
			});
			return;
		}

		$scope.analyzeDifferent();

		if ($scope.dataStorage.analyzeResults.length > 0) {
			$scope.openAnalyzeDifferent();
		} else {
			$scope.sysncBaseInfo();
		}
	}

    /**
     * 同步基础信息
     * 
     * @return {[type]} [description]
     */
	$scope.sysncBaseInfo = function() {
		dwr.TOPEngine.setAsync(false);
		TableFacade.sysncBaseInfo($scope.dataStorage, {
			callback: function(data) {
				cui.message("同步成功", "success");
				$scope.changeUrlNotRefreshWindow();
			},
			errorHandler: function(message, exception) {
				cui.message("执行失败:" + message, "error");
			}
		});
		dwr.TOPEngine.setAsync(true);
	}

    /**
     * 打开差异变化界面
     * 
     * @return {[type]} [description]
     */
	$scope.openAnalyzeDifferent = function() {
		var url = webPath + "/cap/bm/dev/database/TableSysncEntity.jsp?packageId=" + packageId + "&packagePath=" + packagePath + "&modelId=" + modelId + "&from=table";
		var title = "属性差异";
		var height = 600;
		var width = 800;
		if (!sysncToEntityDialog) {
			sysncToEntityDialog = cui.dialog({
				title: title,
				src: url,
				width: width,
				height: height
			})
		}
		sysncToEntityDialog.show(url);
	}

	/**
	 * 改变url不刷新页面
	 * 
	 * @return {[type]} [description]
	 */
	$scope.changeUrlNotRefreshWindow= function() {
		if (window.history.pushState && !(/^.*modelId=[^&\s].*$/.test(window.location.href))) {
			window.history.pushState({}, "", (window.location.href + "&modelId=" + $scope.tableData.modelId));
			modelId = $scope.tableData.modelId;
		}
		$scope.initBizControl();
	};

	/**
	 * 刷新父页面
	 * 
	 * @return {[type]} [description]
	 */
	$scope.refreshParentWindow = function() {
		if (!openType) { //AppDetail页面,树形结构页面无需刷新
			window.opener.refresh();
		}
	};

	$scope.applyTableExsit = function(isTableExsit){
		$scope.isTableExsit=isTableExsit;
		$scope.$apply();
	}

	/**
	 * 校验Table列信息
	 * 
	 * @return {[type]} [description]
	 */
	$scope.validateColumns = function() {
		if (!$scope.isTableExsit) {
			//table表名可编辑时组装modelId
			$scope.setModelId();
			//校验元数据中表名不能相同
			if ($scope.checkTableNameExsit()) {
				cui.alert("当前包下表名称[" + $scope.tableData.engName + "]已被使用,请重新填写.");
				return false;
			}
		}

		if(!$scope.tableData.engName){
			cui.alert("表名不能为空.");
			return false;
		}
		if (!$scope.legalCheck($scope.tableData.engName)) {
			cui.alert("表名[" + $scope.tableData.engName + "]存在非法字符,必须为英文字符、数字或者下划线");
			return false;
		}
		
		var arr = [];
		for (var i = 0; i < $scope.tableData.columns.length; i++) {
			var column = $scope.tableData.columns[i];
			if (!$scope.checkInteger(column.length)) {
				cui.alert("列长度不能为小数位.");
				return false;
			}
			if (!$scope.checkInteger(column.precision)) {
				cui.alert("列精度不能为小数位.");
				return false;
			}
			if (!column.engName) {
				cui.alert("字段名不能为空.");
				return false;
			}
			if (!column.dataType) {
				cui.alert("数据类型不能为空.");
				return false;
			}
			if (!column.length || column.length <= 0) {
				cui.alert("长度不能为空或者等于0");
				return false;
			}
			if (column.precision == null || column.precision < 0) {
				cui.alert("精度不能为空或者小于0");
				return false;
			}
			if (!column.description) {
				cui.alert("描述不能为空.");
				return false;
			}
			if (column.dataType == "NUMBER" && column.precision > column.length) {
				cui.alert("NUMBER类型精度不能大于长度.");
				return false;
			}
			if (!$scope.legalCheck(column.engName)) {
				cui.alert("列名[" + column.engName + "]存在非法字符,必须为英文字符、数字或者下划线");
				return false;
			}
			//列名转大写
			column.engName = column.engName.toUpperCase();
			column.code = column.code.toUpperCase();
			arr.push(column.engName);
		};
		//校验重复列
		var sameColumn = cap.array.isRepeat4(arr);
		if (sameColumn) {
			cui.alert("列名存在重复列[" + sameColumn + "]");
			return false;
		}
		return true;
	};

	$scope.setModelId = function() {
		if (!$scope.tableData.modelId) {
			$scope.tableData.modelId = $scope.tableData.modelPackage + "." + $scope.tableData.modelType + "." + $scope.tableData.engName;
		}
	}

	/**
	 * 校验表名在元数据中是否存在
	 * 
	 * @return {[type]} [description]
	 */
	$scope.checkTableNameExsit = function() {
		var isTableNameExsit = false;
		dwr.TOPEngine.setAsync(false);
		TableFacade.queryTableByName($scope.tableData, {
			callback: function(data) {
				isTableNameExsit = data.length > 0 ? true : false;
			},
			errorHandler: function(message, exception) {
				cui.message("执行失败:" + message, "error");
			}
		});
		dwr.TOPEngine.setAsync(true);
		return isTableNameExsit;
	}

	/**
	 * 同步数据库
	 * 
	 * @return {[type]} [description]
	 */
	$scope.sysncDataBase = function() {
		if (!$scope.isTableExsit) {
			if (!$scope.validateColumns())
				return;
			$scope.openCreateTable();
		} else {
			$scope.saveModel($scope.openCompareTableMain);
		}
	};
    
    //同步全部
	$scope.sysncAll = function(){
		if (!$scope.isTableExsit) {
			if (!$scope.validateColumns())
				return;
			$scope.openCreateTable();
		} else {
			$scope.saveAndSysncEntity($scope.openCompareTableMain);
		}
	}

	/**
	 * 打开创建表语句
	 * @return {[type]} [description]
	 */
	$scope.openCreateTable = function() {
		var url = webPath + "/cap/bm/dev/database/CreateTable.jsp?packageId=" + packageId + "&packagePath=" + packagePath + "&modelId=" + modelId + "&from=table";
		var title = "创建表SQL";
		var height = 600;
		var width = 800;
		if (!createTableDialog) {
			createTableDialog = cui.dialog({
				title: title,
				src: url,
				width: width,
				height: height
			})
		}
		createTableDialog.show(url);
	}

    /**
     * 打开表结构对比界面
     * 
     * [openCompareTableMain description]
     * @return {[type]} [description]
     */
	$scope.openCompareTableMain = function(){
		var url = webPath + "/cap/bm/dev/pdm/CompareTableMain.jsp?packageId=" + packageId + "&packagePath=" + packagePath + "&modelId=" + modelId + "&from=table";
		var title = "表结构比较";
		var height = 600;
		var width = 800;
		if(!sysncDataBaseDialog){
			sysncDataBaseDialog = cui.dialog({
				title: title,
				src: url,
				width: width,
				height: height
			})
		}
		sysncDataBaseDialog.show(url);
	}

	/**
	 * 校验整数
	 * 
	 * @param  {[type]} data [description]
	 * @return {[type]}      [description]
	 */
	$scope.checkInteger = function(data) {
		var regEx = "^-?\\d+$";
		if (data) {
			var reg = new RegExp(regEx);
			return (reg.test(data));
		}
		return true;
	}

    /**
     * 禁用负数和正数键
     * 
     * @return {[type]} [description]
     */
	$scope.keydown = function(){
		if(event.keyCode==189 || event.keyCode==187){
			event.returnValue=false;
		}
	}

	/**
	 * 字段名称值改变
	 * 
	 * @param  {[type]} engName [description]
	 * @param  {[type]} column  [description]
	 * @return {[type]}         [description]
	 */
	$scope.engNameChange = function(engName, column) {
		column.code = engName.toUpperCase();
		column.engName = engName.toUpperCase();
		if (!engName || !$scope.legalCheck(engName)) {
			column.isColumnNameLegal = false;
		} else {
			column.isColumnNameLegal = true;
		}
	};

    /**
     * 长度值改变
     * 
     * @param  {[type]} length [description]
     * @param  {[type]} column [description]
     * @return {[type]}        [description]
     */
	$scope.lengChange = function(length, dataType, column) {
		if (dataType == "NUMBER" && !length) {
			column.length = 38;
		}
	};

	/**
	 * 表名称值改变
	 * 
	 * @param  {[type]} tableName [description]
	 * @param  {[type]} Table     [description]
	 * @return {[type]}           [description]
	 */
	$scope.tableEngNameChange = function(tableName, table) {
		table.code = tableName.toUpperCase();
		table.modelName = tableName.toUpperCase();
		table.engName = tableName.toUpperCase();
		table.columns.forEach(function(item, index, array) {
			item.tableCode = tableName;
		});
		if (!tableName || !$scope.legalCheck(tableName)){
			$scope.isTableNameLegal=false;
		}else{
			$scope.isTableNameLegal=true;
		}
	}

	/**
	 * 数据类型值改变
	 * 
	 * @return {[type]} [description]
	 */
	$scope.dataTypeChange = function(value, column) {
		//TIMESTAMP length为11,精度为6
		if (value == "TIMESTAMP") {
			column.length = 11;
			column.precision = 6;
		} else if (value == "BLOB" || value == "CLOB") {
			column.length = 4000;
			column.precision = 0;
		} else if (value == "NUMBER") {
			column.defaultValue = (column.defaultValue != null && column.defaultValue != '') ? Number(column.defaultValue) : column.defaultValue;
		} else {
			column.precision = 0;
		}
	};

    /**
     * 列描述值改变
     * 
     * @param  {[type]} currentValue [description]
     * @param  {[type]} column       [description]
     * @return {[type]}              [description]
     */
	$scope.descriptionChange = function(currentValue,column){
		if (currentValue && currentValue.length > 20) {
			column.chName = currentValue.substring(0, 20);
		} else {
			column.chName = currentValue;
		}
	}

    /**
     * 窗口关闭
     * 
     * [close description]
     * @return {[type]} [description]
     */
	$scope.close = function(){
		$scope.refreshParentWindow();
		window.close();
	};

	/**
	 * 新增Table元数据行
	 */
	$scope.addNewLine = function() {
		var newColumn = {
			id: (new Date().getTime() + ""),
			canBeNull: true,
			isForeignKey: false,
			isPrimaryKEY: false,
			isUnique: false,
			precision: 0,
			tableCode: $scope.tableData.engName,
			isColumnNameLegal: false
		};
		$scope.tableData.columns.push(newColumn);
		$scope.setSelectedRow(newColumn, $scope.tableData.columns.length - 1);
	};

	/**
	 * 新增流程字段
	 */
	$scope.addWorkflowColumn = function() {
		dwr.TOPEngine.setAsync(false);
		TableFacade.getWorkflowMarchRule(function(data) {
			if (data.length <= 1) {
				cui.alert("首选项中找不到父流程实体匹配规则")
				return;
			}

			var flag = true;
			$scope.tableData.columns.forEach(function(item, index, arr) {
				if (item.engName == data[0] || item.engName == data[1]) {
					flag = false;
				}
			})
			if (!flag) {
				cui.alert("当前列已存在流程字段")
				return;
			}

			var newColumn = {
				id: (new Date().getTime() + ""),
				canBeNull: true,
				isForeignKey: false,
				isPrimaryKEY: false,
				isUnique: false,
				precision: 0,
				chName: "流程实例id",
				dataType: "VARCHAR2",
				length: 50,
				description: "流程实例id",
				engName: data[0],
				code: data[0],
				tableCode: $scope.tableData.engName,
				isColumnNameLegal: true
			};
			$scope.tableData.columns.push(newColumn);

			var newColumn2 = {
				id: (new Date().getTime() + ""),
				canBeNull: true,
				isForeignKey: false,
				isPrimaryKEY: false,
				isUnique: false,
				precision: 0,
				chName: "流程状态",
				dataType: "NUMBER",
				length: 2,
				description: "流程状态",
				engName: data[1],
				code: data[1],
				tableCode: $scope.tableData.engName,
				isColumnNameLegal: true
			};
			$scope.tableData.columns.push(newColumn2);
			$scope.setSelectedRow(newColumn2, $scope.tableData.columns.length - 1);
		});
		dwr.TOPEngine.setAsync(true);
	};

	/**
	 * 删除Table元数据行
	 * 
	 * @return {[type]} [description]
	 */
	$scope.deleteLine = function() {
		if ($scope.selectedIndex < 0) {
			cui.alert("请选择当前行");
			return;
		}
		//主键不能删除
		if ($scope.selectedColumn.isPrimaryKEY) {
			cui.alert("主键不允许删除.");
			return;
		}

		var field = $scope.selectedColumn.engName ? '[' + $scope.selectedColumn.engName + ']' : '';
		cui.confirm('确定是否要删除当前' + field + '字段?', {
			onYes: function() {
				$scope.tableData.columns.splice($scope.selectedIndex, 1);
				var lastIndex = $scope.tableData.columns.length - 1;
				$scope.setSelectedRow($scope.tableData.columns[lastIndex], lastIndex);
				$scope.$apply();
				cui.message("删除成功.", "success");
			},
			onNo: function() {}
		});
	};

	/**
	 * 合法校验
	 * 
	 * @return {[type]} [description]
	 */
	$scope.legalCheck = function(data) {
		var regEx = "^([A-Z])[a-zA-Z0-9_]*$";
		if (data) {
			var reg = new RegExp(regEx);
			return (reg.test(data));
		}
		return true;
	}
    /**
     * 业务对象导入
     * 
     * @return {[type]} [description]
     */
	$scope.bizImport = function(){
		var strDomainIds = $scope.domainIds;
		if(strDomainIds && strDomainIds.length>0){
			var impBizObjUrl =webPath + "/cap/bm/biz/info/SelectBizObjectMain.jsp?packageId=" + packageId +"&packagePath="+packagePath+"&domainIds="+strDomainIds+"&tabLen=1&showValueFlag=false";
			if(!bizObjDialog){
				bizObjDialog = cui.dialog({
					title : "业务对象属性选择主页",
					src : impBizObjUrl,
					width : 800,
					height : 600
				});
			}else{
				bizObjDialog.reload(impBizObjUrl);
			}
			bizObjDialog.show();
		}else{
			cui.alert("当前应用无关联业务域，无法获取业务对象!");
		}
	};
});

//同步的菜单
var sysnc_menu = {
	datasource: [{
		id: 'sysncAll',
		label: '同步全部',
		title: '表信息全部同步至实体,并分析出与数据库表差异变化'
	}, {
		id: 'sysncDataBase',
		label: '同步数据库',
		title: '表信息同步至数据库,分析出与数据库表结构差异信息'
	}, {
		id: 'sysncToEntity',
		label: '同步实体',
		title: '表信息同步至实体,并分析出差异变化'
	}],
	on_click: function(obj) {
		var type = obj.id;
		if ("sysncAll" === type) {
			scope.sysncAll();
		} else if ("sysncDataBase" === type) {
			scope.sysncDataBase();
		} else if ("sysncToEntity" === type) {
			scope.sysncToEntity();
		}
	}
};

/**
 * 业务回调关闭
 * 
 * @return {[type]} [description]
 */
function callbackClose() {
	bizObjDialog.hide();
}

/**
 * 业务对象点击确定后回调
 * 
 * @param  {[type]} bizObjInfos [description]
 * @return {[type]}             [description]
 */
function callbackConfirm(bizObjInfos) {
	for (var k = 0; k < bizObjInfos.length; k++) {
		var bizObjInfo = bizObjInfos[k];
		for (var i = 0; i < bizObjInfo.dataItems.length; i++) {
			var continueFlag = false;
			_.findIndex(scope.tableData.columns, function(n) {
				if (bizObjInfo.dataItems[i].code == n.engName || bizObjInfo.dataItems[i].name == n.chName) {
					continueFlag = true;
					return;
				}
			});
			if (continueFlag) {
				continue;
			}
			var objColumnVO = {
				id: bizObjInfo.dataItems[i].id,
				engName: bizObjInfo.dataItems[i].code?bizObjInfo.dataItems[i].code.replace("-", "_"):"",
				chName: bizObjInfo.dataItems[i].name,
				tableCode: bizObjInfo.tableCode,
				description: bizObjInfo.dataItems[i].name,
				dataType: "VARCHAR2",
				defaultValue: "",
				isForeignKey: false,
				isPrimaryKEY: false,
				isUnique: false,
				canBeNull: true,
				length: 100,
				precision: 0,
				code: bizObjInfo.dataItems[i].code?bizObjInfo.dataItems[i].code.replace("-", "_"):""
			};
			scope.tableData.columns.push(objColumnVO);
			scope.$apply();
		}
	}
	window.top.cui.message("导入成功!","success");
	bizObjDialog.hide();
}

</script>
</body>
</html>