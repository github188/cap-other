/*******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd All Rights
 * Reserved. 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、 复制、修改或发布本软件.
 * 
 * 实体元数据-实体方法JS
 * 
 * @author WWW.SZCOMTOP.COM 
 * @Date 2016-07-25
 ******************************************************************************/

var PageStorage = new cap.PageStorage(modelId);
var entity = PageStorage.get("entity");
if(isSubQuery){
	entity = $.extend(true,{},entity);
}
var packageId = entity.packageId;
if (!entity.methods) {
	entity.methods = [];
}
var root = {
	entityMethods: entity.methods,
	entityAliasName:entity.aliasName
};

/**
 * 响应实体的父实体ID变化发出的通知。
 *
 * @param <code>e</code>事件对象
 */
function messageHandle(e) {
	if (e.data.type == "parentEntityIdChange") {
		scope.loadParentMethods();
		cap.digestValue(scope);
	}
}
window.addEventListener("message", messageHandle, false);
//拿到angularJS的scope
var scope = null;

//调用angularjs
var entityMethodList = function($scope,$timeout) {
	$scope.root = root;
	$scope.displayFlag = false;
	$scope.entityType = entity.entityType;
	$scope.entitySource = entity.entitySource;
	//默认显示属性tab标签
	$scope.active = 'method';
	//控制全选checkbox的状态
	$scope.objCheckAll = {
		cascadAttributesCheckAll: false, //方法列表的checkbox全选状态
		entityMethodsCheckAll: false, //级联属性的checkbox全选状态
		methodParamsCheckAll: false, //参数列表的checkbox全选状态
		methodExceptionsCheckAll: false //异常列表的checkbox全选状态
	};

	//页面右侧是否显示父实体方法
	$scope.displayPMethod = false;

	//设置页面初始化选中的方法
	$scope.selectEntityMethodVO = root.entityMethods.length > 0 ? root.entityMethods[0] : {};
	
	$scope.hideButtonFlag = entity.entitySource=='exist_entity_input'?true:false;
	
	$scope.hideMoreActionFlag = entity.entityType=='query_entity'?true:false; 
	
	//查询建模嵌套子查询
	if(isSubQuery){
		if(window.opener.scope.refQueryModel && subQueryId && subQueryId.length>0){
			$scope.selectEntityMethodVO.queryModel = window.opener.scope.refQueryModel;
		}else{
			$scope.selectEntityMethodVO.queryModel = {select: {},from: {},where: {},orderBy: {},groupBy: {},previewSQL: ''}
		}
		$scope.selectEntityMethodVO.methodType="queryModeling";
		$scope.remark = window.opener.scope.subquery ? window.opener.scope.subquery.remark : "";
	}

	$scope.ready = function() {
		comtop.UI.scan();
		$scope.setMethodFixed();
		$scope.setReadonlyAreaState(typeof globalReadState != 'undefined' ? globalReadState : false);
		scope = $scope;
		$scope.init();
	};

	/**
	 * 已有实体设置方法固定
	 */
	$scope.setMethodFixed = function() {
		if (entity.entitySource == 'exist_entity_input') {
			$("#methodDetail").css({
				"position": "fixed",
				"right": "0"
			});
		}
	}

	/**
	 * 设置区域读写状态
	 * @param globalReadState 状态标识
	 */
	$scope.setReadonlyAreaState=function(globalReadState){
		//设置为控件为自读状态（针对于CAP测试建模）
	   	if(globalReadState){
	    	$timeout(function(){
	    		cap.setReadonlyArea("unReadonlyArea", ["*:not([class^='notUnbind'])"], ["input[type='checkbox']"]);
	    	}, 0);
    	}
	}
	
	/**
	 * 页面刷新
	 *
	 */
	$scope.init = function() {
		//初始化全选checkbox的选中状态
		//$scope.initCheckboxAllState();
		$scope.loadParentMethods();

		//允许为空和查询字段从boolean转换为字符串，为了ridio按钮自动选中
		for (var i in root.entityMethods) {
			root.entityMethods[i].privateService = root.entityMethods[i].privateService + "";
		}

		//设置java方法名
		$scope.javaMethodName = $scope.getJavaMethodName();
	};

	/**
	 * 加载当前实体的所有父实体的方法。
	 *
	 */
	$scope.loadParentMethods = function() {
		dwr.TOPEngine.setAsync(false);
		EntityFacade.getAllParentEntity(entity.parentEntityId, function(result) {
			//所有父实体的方法的集合
			$scope.parentEntityMethods = [];
			if (result) {
				result.forEach(function(item) {
					if (item.methods) {
						item.methods.forEach(function(_item) {
							//过滤掉父类实体count方法
							if (_item.assoMethodName == null || _item.assoMethodName == "") {
								$scope.parentEntityMethods.push(_item);
							}
						});
					}
				});
			}
		});
		dwr.TOPEngine.setAsync(true);
	};

	/**
	 * 初始化全选checkbox的选中状态。如刷新页面时，切换方法时。
	 *
	 */
	$scope.initCheckboxAllState = function() {
		$scope.checkBoxCheck($scope.selectEntityMethodVO.parameters, 'objCheckAll.methodParamsCheckAll');
		$scope.checkBoxCheck($scope.selectEntityMethodVO.exceptions, 'objCheckAll.methodExceptionsCheckAll');
	};

	//切换Tab标签
	$scope.showPanel = function(msg) {
		$scope.active = msg;
		//切换Tab标签时默认选中第一个方法
		if (msg == "method") {
			var method = $scope.root.entityMethods[0];
			if (!method)
				return;
			$scope.methodTdClick(method, false);
		} else {
			var method = $scope.parentEntityMethods[0];
			if (!method)
				return;
			$scope.methodTdClick(method, true);
		}
	};

	/**
	 * 监控当前选中的方法对象，如果对象的引用发生改变，则执行。
	 *
	 */
	$scope.$watch("selectEntityMethodVO", function() {
		if(isSubQuery)
			return;
		//初始化全选checkbox的选中状态
		$scope.initCheckboxAllState();

		//自定义SQL调用的查询参数
		$scope.queryParams = "";
		//自定义SQL调用的返回结果
		$scope.returnResult = "";
		//加载自定义SQL调用的查询参数以及返回结果
		if ($scope.selectEntityMethodVO.methodType == "userDefinedSQL" && $scope.selectEntityMethodVO.methodId.indexOf("count") == -1 && $scope.selectEntityMethodVO.methodId.indexOf("pagination") == -1) {
			if ($scope.selectEntityMethodVO.userDefinedSQL) {
				if (Array.isArray($scope.selectEntityMethodVO.userDefinedSQL.queryParams)) {
					$scope.selectEntityMethodVO.userDefinedSQL.queryParams.forEach(function(item, index, arr) {
						$scope.queryParams += (item + ";");
					});
				}
				if (Array.isArray($scope.selectEntityMethodVO.userDefinedSQL.returnResult)) {
					$scope.selectEntityMethodVO.userDefinedSQL.returnResult.forEach(function(item, index, arr) {
						$scope.returnResult += (item + ";");
					});
				}
			}
		}

		//设置方法操作类型-保存（save）的只读操作
		$scope.diableMethodOperate4Save();

		//级联操作把返回值相关元素设置为只读
		$scope.disabledElements();

		//初始化方法的级联属性
		$scope.initCascadingMethod();
		
		cap.validater.validOneElement("aliasName");
		if ($scope.selectEntityMethodVO.aliasName && $scope.selectEntityMethodVO.methodId) {
			//判断是否将方法别名设置为只读
			dwr.TOPEngine.setAsync(false);
			EntityFacade.isExistSameMethodAliasName($scope.selectEntityMethodVO.aliasName, modelId, $scope.selectEntityMethodVO.methodId, function(_result) {
				if (_result) {
					cui("#aliasName").setReadonly(true);
				} else {
					cui("#aliasName").setReadonly(false);
				}
			});
			dwr.TOPEngine.setAsync(true);
		}
	});

	//显示和隐藏引入文件的列表
	$scope.showOrHidenService = function(flag) {
		$scope.displayFlag = flag ? false : true;
	}

	/**
	 * 当方法为级联方法时，方法操作类型-保存（save）设置可用。非级联方法时，方法操作类型-保存（save）设置为只读，不可用。
	 * 如果方法为非级联方法，且方法操作类型为保存（save）时，自动设置为读取（query），并且把标注只读事务设置为true。
	 */
	$scope.diableMethodOperate4Save = function() {
		if ("setReadonly" in cui("#methodOperateTypeRadioGroup")) {
			if ($scope.selectEntityMethodVO.methodType == "cascade") {
				cui("#methodOperateTypeRadioGroup").setReadonly(false, ['save']);
			} else {
				if ($scope.selectEntityMethodVO.methodOperateType == "save") { //非级联方法，如果是save操作，则跟换成query操作。同时把标注只读事务设置为true
					$scope.selectEntityMethodVO.methodOperateType = "query";
					$scope.selectEntityMethodVO.transaction = true;
				}
				cui("#methodOperateTypeRadioGroup").setReadonly(true, ['save']);
			}
		}
	};

	/**
	 * 初始化出级联方法的级联属性。
	 *
	 */
	$scope.initCascadingMethod = function() {
		//方法类型为“级联操作”时，获取当前实体的级联属性
		if ($scope.selectEntityMethodVO.methodType == "cascade") {
			var result;
			//取得当前实体的所有级联属性（一级一级往下找，直到没有级联属性为止）
			dwr.TOPEngine.setAsync(false);
			EntityFacade.getCascadeAttribute(entity, $scope.selectEntityMethodVO.methodOperateType, '-1', 0, null, function(_result) {
				result = _result;
			});
			dwr.TOPEngine.setAsync(true);

			//获取实体的所有级联属性的集合
			var allCascadingAttributes = $scope.coverData2Flat(result);

			//在实体的所有级联属性的集合中初始化出本方法选中的级联属性
			if (allCascadingAttributes && allCascadingAttributes.length > 0 && $scope.selectEntityMethodVO.lstCascadeAttribute && $scope.selectEntityMethodVO.lstCascadeAttribute.length > 0) {
				//把本方法的树形数据结构的级联属性转换成平铺数据结构
				var tempArray = $scope.coverData2Flat($scope.selectEntityMethodVO.lstCascadeAttribute);
				//找出实体的级联属性与本方法的级联属性之间的交集，则把交集级联属性的check设置为true，页面上就显示为选中状态
				allCascadingAttributes.forEach(function(item, index, arr) {
					tempArray.some(function(_item, _index, _arr) {
						if (item.id == _item.id && item.parentId == _item.parentId) {
							item.check = true;
							return true;
						}
						return false;
					});
				});
			}

			//设置级联属性的全选checkbox状态
			$scope.checkBoxCheck(allCascadingAttributes, 'objCheckAll.cascadAttributesCheckAll');

			//把处理好的级联属性设置到scope中。触发cascadingAttributes的监听事件
			$scope.cascadingAttributes = allCascadingAttributes;

		}
	};


	/**
	 * 把级联属性的树形结构数据转换成平铺结构数据（一维数组），以便在表格中展示
	 *
	 * @param <code>data</code>级联属性树形结构数据
	 */
	$scope.coverData2Flat = function(data) {
		if (!data || data.length == 0) {
			return null;
		}
		var cascadingAttriArr = [];
		//递归树形结构数据，转换成“平铺”式一维数组数据
		(function(_data) {
			for (var i = 0, len = _data.length; i < len; i++) {
				cascadingAttriArr.push(_data[i]);
				if (_data[i].lstCascadeAttribute && _data[i].lstCascadeAttribute.length > 0) {
					arguments.callee(_data[i].lstCascadeAttribute);
				}
			}
		})(data);

		return cascadingAttriArr;
	};

	/**
	 * 监听级联属性的变化（其实就是监听级联属性VO的check属性的变化，即checkbox的状态[选中/取消]） 
	 *
	 */
	$scope.$watch("cascadingAttributes", function() {
		//每次变化都重新组装持久化的数据
		var persistenceHierarchical = $scope.coverData2Hierarchical();
		$scope.selectEntityMethodVO.lstCascadeAttribute = persistenceHierarchical;
	}, true);

	/**
	 * 把级联属性的平铺结构数据（一维数组）转换成树形数据结构，以便持久化
	 *
	 * @param <code>data</code>级联属性平铺结构数据
	 */
	$scope.coverData2Hierarchical = function() {
		//获得页面选中的级联属性
		if (!$scope.cascadingAttributes || $scope.cascadingAttributes.length <= 0) {
			return [];
		}
		var filterArray = $scope.cascadingAttributes.filter(function(item, index, arr) {
			if (item.check) {
				return item;
			}
		});

		//这里clone一份的原因是，后面会改persistenceFlat里面的内容（清空节点装子节点的容器），如果不clone一份的话，当persistenceFlat里面的内容改变，
		//会被$scope.$watch("cascadingAttributes",function(){...});方法监听到，从而又从头执行了一遍。浪费资源。
		var _ = cui.utils;
		var persistenceFlat = _.parseJSON(_.stringifyJSON(filterArray));

		//把级联属性转换成树形结构数据。可以持久化的数据。
		var persistenceHierarchical = [];
		persistenceFlat.forEach(function(item, index, arr) {
			if (item.parentId == "-1") {
				persistenceHierarchical.push(item);
				(function(rootItem, srcArr) {
					//先把节点的子节点容器（lstCascadeAttribute）清空
					rootItem.lstCascadeAttribute = null;
					for (var n = 0, _len = srcArr.length; n < _len; n++) {
						if (srcArr[n].parentId == rootItem.id) {
							//节点下面有子节点的话，就初始化装子节点的容器
							if (!rootItem.lstCascadeAttribute) {
								rootItem.lstCascadeAttribute = [];
							}
							rootItem.lstCascadeAttribute.push(srcArr[n]);
							//递归寻找子节点的子节点，直到没有子节点为止
							arguments.callee(srcArr[n], srcArr);
						}
					}
				})(item, arr);
			}
		});
		//返回可以持久化的数据
		return persistenceHierarchical;
	};

	/**
	 * 级联属性名称在表格中的缩进样式
	 *
	 * @param <code>indent</code> 缩进单位数（每个单位缩进4em）
	 */
	$scope.cascadAttiPadding = function(indent) {
		//缩进长度
		var paddingLength = indent * 4 + "em";
		return {
			'padding-left': paddingLength
		};
	};

	/**
	 * 监控全选checkbox，如果选择则联动选中列表所有数据
	 *
	 * @param <code>ar</code>记录数组
	 * @param <code>isCheck</code>全选按钮的状态（选中/未选中）
	 */
	$scope.allCheckBoxCheck = function(ar, isCheck) {
		if (ar) {
			for (var i = 0, len = ar.length; i < len; i++) {
				if (isCheck) {
					ar[i].check = true;
				} else {
					ar[i].check = false;
				}
			}
		}
	};

	/**
	 * 改变记录的checkbox状态触发的事件
	 *
	 * @param <code>ar</code>记录数组
	 * @param <code>allCheckBox</code>控制全选checkbox状态变量的字符串
	 * @param <code>type</code>点击的记录的类型
	 * @param <code>currentVO</code>点击的当前记录的VO
	 */
	$scope.checkBoxCheck = function(ar, allCheckBox, type, currentVO) {
		//当选中级联属性时，同步选中其所有父节点;当取消级联属性时，同步取消其子节点
		if (type == "cascade") {
			$scope.freshParentOrChildCheckBox(currentVO);
		}
		//监控是否要把全选checkbox设置为选中/未选中
		if (ar) {
			var checkCount = 0;
			var allCount = 0;
			for (var i = 0; i < ar.length; i++) {
				//如果是方法，不把Count方法和Pagination方法纳入检测
				if (ar[i].methodId) {
					if (ar[i].methodId.toString().indexOf("count") == -1 && ar[i].methodId.toString().indexOf("pagination") == -1) {
						if (ar[i].check) {
							checkCount++;
						}
						if (true) {
							allCount++;
						}
					}
				} else {
					if (ar[i].check) {
						checkCount++;
					}
					if (true) {
						allCount++;
					}
				}
			}
			if (checkCount == allCount && checkCount != 0) {
				eval("$scope." + allCheckBox + "=true");
			} else {
				eval("$scope." + allCheckBox + "=false");
			}
		} else { //可能ar为null
			eval("$scope." + allCheckBox + "=false");
		}
	};

	/**
	 * 选中方法
	 *
	 */
	$scope.methodTdClick = function(eMethodVo, isParentEntityMethod) {
		$scope.selectEntityMethodVO = eMethodVo;
		$scope.displayPMethod = isParentEntityMethod;
		$scope.javaMethodName = $scope.getJavaMethodName();
		$scope.setReadonlyAreaState(typeof globalReadState != 'undefined' ? globalReadState : false);
	};

	/**
	 * 新增方法
	 *
	 */
	$scope.addEntityMethod = function() {
		//创建一个method对象。
		var newEntityMethod = {
			methodId: (new Date()).valueOf().toString(),
			accessLevel: 'public',
			autoMethod: false,
			lstCascadeAttribute: [],
			chName: '',
			engName: '',
			aliasName: '',
			assoMethodName: '',
			description: '',
			exceptions: [],
			methodSource: 'entity',
			methodType: 'blank',
			parameters: [],
			returnType: {
				generic: null,
				type: 'String',
				value: null,
				source: 'primitive'
			},
			serviceEx: 'none',
			transaction: true,
			methodOperateType: '',
			dbObjectCalled: {
				objectId: '',
				objectName: '',
				lstParameters: []
			},
			userDefinedSQL: {
				queryParams: [],
				returnResult: [],
				querySQL: '',
				sortSQL: '',
				parameterType: '',
				resultType: ''
			},
			queryModel: {
				select: {},
				from: {},
				where: {},
				orderBy: {},
				groupBy: {},
				previewSQL: ''
			},
			needCount: false,
			needPagination: false,
			privateService: 'false'
		};
		$scope.selectEntityMethodVO = newEntityMethod;
		$scope.root.entityMethods.push(newEntityMethod);
		$scope.displayPMethod = false;
		$scope.checkBoxCheck($scope.root.entityMethods, "objCheckAll.entityMethodsCheckAll");

		//级联操作把返回值相关元素设置为只读
		$scope.disabledElements();
	};

	/**
	 * 根据方法英文名改变别名
	 * 
	 * @param <code>engName</code>方法英文名称
	 */
	$scope.changeAliasName = function(engName) {
		if (!cui("#aliasName").options.readonly) {
			engName = $.trim(engName); //去掉前后空格
			$scope.selectEntityMethodVO.aliasName = engName.substring(0, 1).toLowerCase() + engName.substring(1);
		}
	};


	/**
	 * 改变返回值类型
	 * 
	 * @param <code>returnType</code>返回值类型
	 */
	$scope.changeReturnType = function(returnType) {
		switch (returnType) {
			case 'java.util.List':
				var listValue = 'java.util.List<' + modelId + '>';
				$scope.setReturnType('collection', returnType, listValue, [{
					generic: null,
					type: 'entity',
					value: modelId,
					source: 'entity'
				}]); //source, type, value, generic
				break;
			case 'java.util.Map':
				if ($scope.selectEntityMethodVO.methodType == "procedure" || $scope.selectEntityMethodVO.methodType == "function" || $scope.selectEntityMethodVO.methodType == "userDefinedSQL") {
					var mapValueTemp = 'java.util.Map<String,java.lang.Object>';
					$scope.setReturnType('collection', returnType, mapValueTemp, [{
						generic: [],
						type: 'String',
						value: null,
						source: 'primitive'
					}, {
						generic: [],
						type: 'java.lang.Object',
						value: '',
						source: 'javaObject'
					}]);
				} else {
					var mapValue = 'java.util.Map<String,' + modelId + '>';
					$scope.setReturnType('collection', returnType, mapValue, [{
						generic: null,
						type: 'String',
						value: null,
						source: 'primitive'
					}, {
						generic: null,
						type: 'entity',
						value: modelId,
						source: 'entity'
					}]);
				}
				break;
			case 'entity':
				$scope.setReturnType('entity', returnType, modelId, null);
				break;
			case 'java.lang.Object':
				$scope.setReturnType('javaObject', returnType, '', null);
				break;
			case 'thirdPartyType':
				$scope.setReturnType('thirdPartyType', returnType, '', null);
				break;
			default:
				$scope.setReturnType('primitive', returnType, null, null);
		}
	};

	/**
	 * 改变方法类型
	 *
	 * @param <code>methodType</code>方法类型
	 */

	$scope.changeMethodType = function(methodType) {
		if (!methodType) {
			return;
		}
		//控制“操作类型”（methodOperateType）字段
		switch (methodType) {
			case "cascade":
				if (!$scope.selectEntityMethodVO.methodOperateType) {
					$scope.selectEntityMethodVO.methodOperateType = "query";
					$scope.selectEntityMethodVO.transaction = true;
				}
				//级联操作初始化返回值及参数
				$scope.initReturnTypeAndParam();
				$scope.initCascadingMethod();
				break;
			case "userDefinedSQL":
				if (!$scope.selectEntityMethodVO.methodOperateType) {
					$scope.selectEntityMethodVO.methodOperateType = "query";
					$scope.selectEntityMethodVO.transaction = true;
				}
				if (!$scope.selectEntityMethodVO.userDefinedSQL) {
					$scope.selectEntityMethodVO.userDefinedSQL = {
						queryParams: [],
						returnResult: [],
						querySQL: '',
						sortSQL: '',
						parameterType: '',
						resultType: ''
					};
				}
				break;
			case "procedure":
				if (!$scope.selectEntityMethodVO.methodOperateType) {
					$scope.selectEntityMethodVO.methodOperateType = "query";
					$scope.selectEntityMethodVO.transaction = true;
				}
				//改变方法类型后，先重置
				//{lstParameters: Array[0], objectId: "com.comtop.inventory.procedure.BPMS_PRO_INSTANCE_DELETE", objectName: "BPMS_PRO_INSTANCE_DELETE"}
				$scope.selectEntityMethodVO.dbObjectCalled = {
					lstParameters: [],
					objectId: "",
					objectName: ""
				};
				//设置返回值类型 为Map
				$scope.selectEntityMethodVO.returnType.type = 'java.util.Map';
				$scope.changeReturnType($scope.selectEntityMethodVO.returnType.type);
				break;
			case "function":
				if (!$scope.selectEntityMethodVO.methodOperateType) {
					$scope.selectEntityMethodVO.methodOperateType = "query";
					$scope.selectEntityMethodVO.transaction = true;
				}
				$scope.selectEntityMethodVO.dbObjectCalled = {
					lstParameters: [],
					objectId: "",
					objectName: ""
				};
				//设置返回值类型 为Map
				$scope.selectEntityMethodVO.returnType.type = 'java.util.Map';
				$scope.changeReturnType($scope.selectEntityMethodVO.returnType.type);
				break;
			case "queryModeling":
				if (!$scope.selectEntityMethodVO.methodOperateType) {
					$scope.selectEntityMethodVO.methodOperateType = "query";
					$scope.selectEntityMethodVO.transaction = true;
				}
				//设置返回值类型为List
				if ('java.util.List' != $scope.selectEntityMethodVO.returnType.type) {
					$scope.selectEntityMethodVO.returnType.type = 'java.util.List';
					$scope.changeReturnType($scope.selectEntityMethodVO.returnType.type);
				}
				$scope.addQueryModelparam();
				break;
			case "queryExtend":
			case "blank":
				break;
			default:
				throw new Error("some exception was happened. case by:the selected methodType is illegal.");
		}

		//设置方法操作类型-保存（save）的只读操作
		$scope.diableMethodOperate4Save();

		//级联操作,查询建模操作 ,把返回值相关元素设置为只读
		$scope.disabledElements();

		//检测参数的全选checkbox
		$scope.checkBoxCheck($scope.selectEntityMethodVO.parameters, 'objCheckAll.methodParamsCheckAll');

	};

	/**
	 * 级联操作,查询建模操作 把返回值相关元素设置为只读
	 *
	 */
	$scope.disabledElements = function() {
		if(isSubQuery)
			return;
		if ($scope.selectEntityMethodVO.methodType == "cascade") {
			cui("#returnType").setReadonly(true);
			if ('setReadonly' in cui("#type2")) {
				cui("#type2").setReadonly(true);
			}
			cui("#accessLevel").setReadonly(false);
			cui("#engName").setReadonly(false);
			cui("#chName").setReadonly(false);
			var valueList = ["blank", "cascade", "userDefinedSQL"];
			cui("#methodTypeRadioGroup").setReadonly(false, valueList);
		} else if ($scope.selectEntityMethodVO.methodType == "queryExtend") {
			var valueList = ["blank", "cascade", "userDefinedSQL"];
			cui("#methodTypeRadioGroup").setReadonly(true, valueList);

			cui("#returnType").setReadonly(true);
			cui("#accessLevel").setReadonly(true);
			if ('setReadonly' in cui("#type2")) {
				cui("#type2").setReadonly(true);
			}
			cui("#engName").setReadonly(true);
			cui("#chName").setReadonly(true);
			cui("#aliasName").setReadonly(true);
			cui("#description").setReadonly(true);
		} else if ($scope.selectEntityMethodVO.methodType == "procedure") {
			cui("#returnType").setReadonly(true);
			if ('setReadonly' in cui("#type1")) {
				cui("#type1").setReadonly(true);
			}
		} else if ($scope.selectEntityMethodVO.methodType == "function") {
			cui("#returnType").setReadonly(true);
			if ('setReadonly' in cui("#type1")) {
				cui("#type1").setReadonly(true);
			}
		} else {
			var valueList = ["blank", "cascade", "userDefinedSQL"];
			cui("#methodTypeRadioGroup").setReadonly(false, valueList);

			cui("#returnType").setReadonly(false);
			if ('setReadonly' in cui("#type2")) {
				cui("#type2").setReadonly(false);
			}
			if ('setReadonly' in cui("#type1")) {
				cui("#type1").setReadonly(false);
			}

			cui("#engName").setReadonly(false);
			cui("#chName").setReadonly(false);
			if ($.trim($scope.selectEntityMethodVO.aliasName) == "") {
				cui("#aliasName").setReadonly(false);
			}
			cui("#description").setReadonly(false);
			cui("#accessLevel").setReadonly(false);
		}
	};

	/**
	 * 方法为级联操作时，初始化返回值类型及参数
	 *
	 */
	$scope.initReturnTypeAndParam = function() {
		if ($scope.selectEntityMethodVO.methodType != "cascade") {
			return;
		}
		var operateType = $scope.selectEntityMethodVO.methodOperateType;
		switch (operateType) {
			case "insert":
				$scope.setReturnType('primitive', 'String', null, null);
				$scope.selectEntityMethodVO.parameters = [{
					parameterId: (new Date()).valueOf(),
					chName: "新增的实体VO",
					engName: "insertVO",
					sortNo: 0,
					description: "新增的实体VO",
					dataType: {
						source: "entity",
						type: "entity",
						value: modelId,
						generic: null
					}
				}];
				break;
			case "update":
				$scope.setReturnType('primitive', 'boolean', null, null);
				$scope.selectEntityMethodVO.parameters = [{
					parameterId: (new Date()).valueOf(),
					chName: "更新的实体VO",
					engName: "updateVO",
					sortNo: 0,
					description: "更新的实体VO",
					dataType: {
						source: "entity",
						type: "entity",
						value: modelId,
						generic: null
					}
				}];
				break;
			case "query":
				$scope.setReturnType('entity', 'entity', modelId, null);
				$scope.selectEntityMethodVO.parameters = [{
					parameterId: (new Date()).valueOf(),
					chName: "查询的实体Id",
					engName: "entityId",
					sortNo: 0,
					description: "查询的实体Id",
					dataType: {
						source: "primitive",
						type: "String",
						value: null,
						generic: null
					}
				}];
				break;
			case "delete":
				$scope.setReturnType('primitive', 'boolean', null, null);
				$scope.selectEntityMethodVO.parameters = [{
					parameterId: (new Date()).valueOf(),
					chName: "删除的实体VO集合",
					engName: "lstDelVO",
					sortNo: 0,
					description: "删除的实体VO集合",
					dataType: {
						source: "collection",
						type: "java.util.List",
						value: null,
						generic: [{
							source: 'entity',
							type: 'entity',
							value: modelId,
							generic: null
						}]
					}
				}];
				break;
			case "save":
				$scope.setReturnType('primitive', 'String', null, null);
				$scope.selectEntityMethodVO.parameters = [{
					parameterId: (new Date()).valueOf(),
					chName: "保存的实体VO",
					engName: "saveVO",
					sortNo: 0,
					description: "保存的实体VO",
					dataType: {
						source: "entity",
						type: "entity",
						value: modelId,
						generic: null
					}
				}];
				break;
			default:
				throw new Error("some exception was happened. case by:the methodOperateType is illegal.");
		}
	};

	/**
	 * 设置返回值类型
	 *
	 * @param source 来源
	 * @param type 类型
	 * @param value 值
	 * @param generic 泛型
	 */
	$scope.setReturnType = function(source, type, value, generic) {
		$scope.selectEntityMethodVO.returnType.source = source;
		$scope.selectEntityMethodVO.returnType.type = type;
		$scope.selectEntityMethodVO.returnType.value = value;
		$scope.selectEntityMethodVO.returnType.generic = generic;
	};


	/**
	 * 设置自定义SQL调用的paramterType和resultType。此两个属性是为了生成mybatis配置文件中的paramterType和resultType。
	 *
	 * @param <code>item</code> 方法vo
	 */
	$scope.initDefinedSQLParamAndResultType = function(item) {
		if (item.methodType != "userDefinedSQL" || item.methodId.indexOf("count") != -1 || item.methodId.indexOf("pagination") != -1) {
			return;
		}

		/**
		 * 根据类型设置resultType和parameterType
		 *
		 * @param <code>mybatisConfName</code> mybatis配置属性的名称 (即：resultType或parameterType)
		 * @param <code>type</code> 参数或返回值的类型
		 * @param <code>obj</code> 从obj中取类型(取返回值的类型，obj就是方法vo;取参数的类型，obj就是参数vo)
		 * @param <code>paramOrReturnName</code> obj类型的vo名称(即：dataType：参数类型vo的名称;returnType：方法返回值类型vo的名称)
		 */
		var setParamAndResultTypeByType = function(mybatisConfName, type, obj, paramOrReturnName) {
			//如果类型是java.util.List类型，则进行泛型的处理。
			if (type == "java.util.List") {
				var finalType = getGenericValue(obj[paramOrReturnName], mybatisConfName);
				item.userDefinedSQL[mybatisConfName] = processResultType(finalType);
			} else if (type == "entity") { //如果类型是entity类型，则进行modelId的处理
				var finalType = obj[paramOrReturnName].value;
				item.userDefinedSQL[mybatisConfName] = processResultType(finalType);
			} else if (type == "thirdPartyType") { //如果类型是thirdPartyType类型,则不进行modelId的处理
				item.userDefinedSQL[mybatisConfName] = obj[paramOrReturnName].value;
			} else if (type == "void") { //void类型，则不设置
				item.userDefinedSQL[mybatisConfName] = null;
			} else { //其他类型，直接把类型(如：int,boolean,String，Object等)返回
				item.userDefinedSQL[mybatisConfName] = type;
			}
		};

		/**
		 * 获得泛型的类型
		 * 
		 * @param <code>_obj</code> 从_obj为DataTypeVO
		 * <code>mybatisConfName</code> mybatis配置属性的名称 (即：resultType或parameterType) 
		 */
		var getGenericValue = function(_obj, mybatisConfName) {
			var dataTypeVO = cui.utils.parseJSON(cui.utils.stringifyJSON(_obj));
			//如果是返回结果
			if (mybatisConfName == "resultType") {
				while (true) {
					var temp = dataTypeVO.generic;
					if (temp && Object.prototype.toString.call(temp) === "[object Array]" && temp.length >= 1) {
						dataTypeVO = temp[0];
						if(dataTypeVO.type === "java.util.Map"){ //如果泛型是map，则不往下遍历了，直接取java.util.Map
							return dataTypeVO.type;
						}
					} else {
						return dataTypeVO.value ? dataTypeVO.value : dataTypeVO.type;
					}
				}
			} else if (mybatisConfName == "parameterType") { //如果是参数
				return dataTypeVO.type;
			}
		};

		/**
		 * 对modelId进行处理，设置为标准的VO路径。
		 *
		 * @param <code>finalType</code> 需要处理的modelId
		 */
		var processResultType = function(finalType) {
			//如果是标准的modelId(如：com.comtop.user.entity.User),则进行处理成标准的VO路径(如：com.comtop.user.model.UserVO)。
			if (finalType && typeof finalType == "string" && finalType.indexOf(".entity.") != -1) {
				var lastNum = finalType.lastIndexOf(".entity.");
				return finalType.substring(0, lastNum) + ".model." + finalType.substring(lastNum + ".entity.".length) + "VO";
			} else { //否则就不做任何处理，认为输入的就是标准的VO路径
				return finalType;
			}
		};

		//设置resultType
		var returnType = item.returnType.type;
		setParamAndResultTypeByType("resultType", returnType, item, "returnType");

		//设置parameterType
		//取得方法的参数属性
		var paramArray = item.parameters;
		//如果参数属性不为真或不是数组或是数据但没有元素，则直接返回
		if (!paramArray || !Array.isArray(paramArray) || paramArray.length <= 0) {
			item.userDefinedSQL.parameterType = null;
			return;
		}
		//如果有一个参数
		if (paramArray.length == 1) {
			//取的参数类型。
			var _paramType = paramArray[0].dataType.type;
			//根据参数类型对parameterType进行设置
			setParamAndResultTypeByType("parameterType", _paramType, paramArray[0], "dataType");
		} else { //如果有多个参数，则parameterType为java.util.Map
			item.userDefinedSQL.parameterType = "java.util.Map";
		}

	};

	/**
	 * 改变操作类型
	 *
	 * @param <code>methodOperateType</code> 操作类型
	 */
	$scope.changeMethodOperateType = function(methodOperateType) {

		//当methodOperateType为空的时候，直接返回。因此函数可被changeMethodType函数“间接”调用
		if (!methodOperateType) {
			return;
		}

		//如果是读取操作，则标注只读事务；否则不标注只读事务
		if (methodOperateType == "query") {
			$scope.selectEntityMethodVO.transaction = true;
		} else {
			$scope.selectEntityMethodVO.transaction = false;
		}

		$scope.initReturnType();

		//级联操作初始化返回值及参数
		$scope.initReturnTypeAndParam();

		//切换方法的操作类型，重新加载级联属性
		$scope.initCascadingMethod();
	};

	/**
	 * 当为用户自定义sql，并且是inset或update或delete操作时，设置返回值为int类型
	 */
	$scope.initReturnType = function() {
		if ($scope.selectEntityMethodVO.methodType == "userDefinedSQL") {
			var _methOperType = $scope.selectEntityMethodVO.methodOperateType;
			if (_methOperType == "insert" || _methOperType == "update" || _methOperType == "delete") {
				$scope.selectEntityMethodVO.returnType.type = "int";
			}
		}
	};

	/**
	 * 改变是否需要生成分页方法
	 *
	 * @param <code>flag</code>是否需要生成分页方法
	 */
	$scope.changeNeedPagination = function(flag) {
		if (flag) {
			$scope.selectEntityMethodVO.needCount = true;
		}
	};

	/**
	 * 复制选中的方法
	 *
	 */
	$scope.copyEntityMethod = function() {
		var copyedMethod = [];
		$scope.root.entityMethods.forEach(function(item, index, arr) {
			if (item.check) {
				var newMethod = jQuery.extend(true, {}, item);
				newMethod.methodId = ((new Date()).valueOf() + index).toString(); // +index 是为了保证ID不一样。
				newMethod.check = false;
				copyedMethod.push(newMethod);
			}
		});

		if(copyedMethod.length<1){
			cui.alert("请选择相应的方法");
			return;
		}

		//校验所选的方法是否存在查询重写
		if (!$scope.validateCopyMethod(copyedMethod)){
			return;
		}

		copyedMethod.forEach(function(_item) {
			$scope.root.entityMethods.push(_item);
		});
		//检测全选按钮状态
		$scope.checkBoxCheck($scope.root.entityMethods, "objCheckAll.entityMethodsCheckAll");
	};

	//复制校验当前方法不能存在查询重写
	$scope.validateCopyMethod = function(copyedMethod) {
		var validate = true;
		copyedMethod.forEach(function(_item) {
			if (_item.methodType == "queryExtend") {
				cui.alert("当前所选方法存在查询重写方法,该方法不允许复制.");
				validate = false;
			}
		});
		return validate;
	};

	/**
	 * 删除方法
	 *
	 */
	$scope.deleteEntityMethod = function() {
		//组装需要删除的方法的简单对象
		var delMethodArr = [];
		//删除的方法中是否包含当前选中的方法
		var isContainCurrMethod = false;
		//需要删除的方法完整对象
		var items = [];
		//取得需要删除的方法
		$scope.root.entityMethods.forEach(function(item, index, arr) {
			if (item.check) {
				delMethodArr.push({
					methodId: item.methodId,
					engName: item.engName
				});
				items.push(item);
			}
			//判断删除的方法中有没有当前选中的方法
			if (item.methodId == $scope.selectEntityMethodVO.methodId && item.check) {
				isContainCurrMethod = true;
			}
		});

		var deleteTitle = "";
		for (var k = 0; k < delMethodArr.length; k++) {
			deleteTitle += delMethodArr[k].engName + "<br/>";
		}
		if (delMethodArr.length > 0) {
			cui.confirm("确定要删除<br/>" + deleteTitle + "这些方法吗？", {
				onYes: function() {
					//删除时一致性校验
					if (!checkConsistency(items, entity)) {
						return;
					}

					//删除方法
					cap.array.remove($scope.root.entityMethods, delMethodArr, true);
					//检测全选按钮状态
					$scope.checkBoxCheck($scope.root.entityMethods, "objCheckAll.entityMethodsCheckAll");
					//如果包含当前方法，删除之后则把当前方法设置为第一个方法
					if (isContainCurrMethod) {
						if (root.entityMethods.length <= 0) {
							$scope.selectEntityMethodVO = {};
						} else {
							var result = root.entityMethods.some(function(_item) {
								if (_item.methodId.indexOf("count") == -1 && _item.methodId.indexOf("pagination") == -1) {
									$scope.selectEntityMethodVO = _item;
									return true;
								}
								return false;
							});
							if (!result) {
								$scope.selectEntityMethodVO = {};
							}
						}
					}
					$scope.$digest();
					cui.message("删除成功.");
				}
			});
		} else {
			cui.alert("请选择相应的方法.");
		}
	};

	/**
	 * 自定义SQL查询。选择实体属性
	 *
	 * @param <code>oprateType</code>操作类型。取值<code>queryParams</code>表示为查询参数选择实体属性；取值<code>returnResult</code>表示为返回结果选择实体属性。
	 */
	$scope.selectEntityAttrubute = function(oprateType) {
		var url = 'SelectEntityAttribute.jsp?modelId=' + modelId + '&methodId=' + $scope.selectEntityMethodVO.methodId + '&type=' + oprateType;
		var width = 800; //窗口宽度
		var height = 400; //窗口高度
		var top = (window.screen.height - 30 - height) / 2;
		var left = (window.screen.width - 10 - width) / 2;
		window.open(url, "_blank", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width=" + width + " ,Height=" + height + ",top=" + top + ",left=" + left);
	};

	/**
	 * 方法参数编辑
	 *
	 * @param <code>pId</code>参数Id
	 */
	$scope.editMethodParameter = function(pId) {
		var url = 'ParameterEdit.jsp?modelId=' + modelId + '&packageId=' + packageId + '&methodId=' + $scope.selectEntityMethodVO.methodId + '&methodType=' + $scope.selectEntityMethodVO.methodType;
		if (pId) {
			url += '&parameterId=' + pId;
		}

		var width = 400; //窗口宽度
		var height = 350; //窗口高度
		var top = (window.screen.height - 30 - height) / 2;
		var left = (window.screen.width - 10 - width) / 2;
		window.open(url, "_blank", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width=" + width + " ,Height=" + height + ",top=" + top + ",left=" + left);
		//编辑参数时会点中当前参数，所以要检查全选checkbox状态
		if (pId) {
			$scope.checkBoxCheck($scope.selectEntityMethodVO.parameters, "objCheckAll.methodParamsCheckAll");
		}
	};

	/**
	 * 点击参数、异常列表的单元格
	 *
	 */
	$scope.tdClick = function(emaVo, arrName, checkAllName, type) {
		emaVo.check = !emaVo.check;
		//当选中级联属性时，同步选中其所有父节点;当取消级联属性时，同步取消其子节点
		if (type == "cascade") {
			$scope.freshParentOrChildCheckBox(emaVo);
		}
		$scope.checkBoxCheck(eval("$scope." + arrName), checkAllName);
	}

	/**
	 * 级联属性的选择与取消的触发事件。
	 * 当选中级联属性时，同步选中其所有父节点;当取消级联属性时，同步取消其子节点
	 *
	 */
	$scope.freshParentOrChildCheckBox = function(currentVO) {
		//选中状态，就选中其所有父节点
		if (currentVO.check) {
			//获得所有父节点
			var parentArray = [];
			(function(parentId) {
				var parent;
				$scope.cascadingAttributes.some(function(item, index, arr) {
					if (item.id == parentId) {
						parent = item;
						return true;
					}
					return false;
				});
				if (parent) {
					parentArray.push(parent);
					//递归获取父节点
					arguments.callee(parent.parentId);
				}
			})(currentVO.parentId);
			//把所有父节点全部选中
			parentArray.forEach(function(item, index, arr) {
				$scope.cascadingAttributes.forEach(function(_item, _index, _arr) {
					if (item.id == _item.id && item.parentId == _item.parentId) {
						if (!_item.check) {
							_item.check = true;
						}
					}
				});
			});
		} else { //未选中状态，就取消所有子节点的选中状态
			var childArray = [];
			(function(id) {
				for (var m = 0, len = $scope.cascadingAttributes.length; m < len; m++) {
					if ($scope.cascadingAttributes[m].parentId == id) {
						childArray.push($scope.cascadingAttributes[m]);
						//递归获取子节点
						arguments.callee($scope.cascadingAttributes[m].id);
					}
				}
			})(currentVO.id);
			//把所有子节点全部设置为未选中
			childArray.forEach(function(item, index, arr) {
				$scope.cascadingAttributes.forEach(function(_item, _index, _arr) {
					if (item.id == _item.id && item.parentId == _item.parentId) {
						if (_item.check) {
							_item.check = false;
						}
					}
				});
			});
		}
	};

	/**
	 * 删除方法的参数
	 *
	 */
	$scope.deleteMethodParameters = function() {
		//存储需要删除的参数
		var targetArr = [];
		$scope.selectEntityMethodVO.parameters.forEach(function(item, index, arr) {
			if (item.check) {
				targetArr.push({
					parameterId: item.parameterId
				});
			}
		});
		cap.array.remove($scope.selectEntityMethodVO.parameters, targetArr, true);
		//删除参数后，再初始化所有参数的排序序号（从0开始）
		$scope.selectEntityMethodVO.parameters.forEach(function(item, index, arr) {
			item.sortNo = index;
		});
		$scope.checkBoxCheck($scope.selectEntityMethodVO.parameters, 'objCheckAll.methodParamsCheckAll');
	};

	/**
	 * 参数上移
	 *
	 */
	$scope.paramMoveUp = function() {
		//取得选中的参数
		var choosedParam = $scope.getChoosedParams();
		//判断选中的参数的个数，只支持一个参数的上移
		if (choosedParam.length > 1) {
			cui.alert("只支持一个参数执行上移操作");
			return;
		} else if (choosedParam.length <= 0) {
			cui.alert("请选择一个需要上移的参数");
			return;
		} else {
			if (choosedParam[0].sortNo == 0) {
				cui.alert("已经是第一个参数了，不能再上移了");
				return;
			} else {
				//获得当前选中的参数的序号
				var _sortNo = choosedParam[0].sortNo;
				//使用临时变量把上一个参数保存起来
				var temp = $scope.selectEntityMethodVO.parameters[_sortNo - 1];
				//上一个参数的index位置上存放当前选中的参数
				$scope.selectEntityMethodVO.parameters[_sortNo - 1] = choosedParam[0];
				//当前选中的参数的位置上存放临时变量保存的参数
				$scope.selectEntityMethodVO.parameters[_sortNo] = temp;

				//改变相互换位置的参数的sortNo
				$scope.selectEntityMethodVO.parameters[_sortNo - 1].sortNo -= 1;
				$scope.selectEntityMethodVO.parameters[_sortNo].sortNo += 1;

			}
		}
	};

	/**
	 * 取得选中的参数
	 *
	 */
	$scope.getChoosedParams = function() {
		var choosedParam = [];
		$scope.selectEntityMethodVO.parameters.forEach(function(item, index, arr) {
			if (item.check) {
				choosedParam.push(item);
			}
		});
		return choosedParam;
	};

	/**
	 * 参数下移
	 *
	 */
	$scope.paramMoveDown = function() {
		//取得选中的参数
		var choosedParam = $scope.getChoosedParams();
		//判断选中的参数的个数，只支持一个参数的下移
		if (choosedParam.length > 1) {
			cui.alert("只支持一个参数执行下移操作");
			return;
		} else if (choosedParam.length <= 0) {
			cui.alert("请选择一个需要下移的参数");
			return;
		} else {
			if (choosedParam[0].sortNo == ($scope.selectEntityMethodVO.parameters.length - 1)) {
				cui.alert("已经是最后个参数了，不能再下移了");
				return;
			} else {
				//获得当前选中的参数的序号
				var _sortNo = choosedParam[0].sortNo;
				//使用临时变量把下一个参数保存起来
				var temp = $scope.selectEntityMethodVO.parameters[_sortNo + 1];
				//下一个参数的index位置上存放当前选中的参数
				$scope.selectEntityMethodVO.parameters[_sortNo + 1] = choosedParam[0];
				//当前选中的参数的位置上存放临时变量保存的参数
				$scope.selectEntityMethodVO.parameters[_sortNo] = temp;

				//改变相互换位置的参数的sortNo
				$scope.selectEntityMethodVO.parameters[_sortNo + 1].sortNo += 1;
				$scope.selectEntityMethodVO.parameters[_sortNo].sortNo -= 1;
			}
		}
	};

	/**
	 * 选择方法throws的异常
	 *
	 */
	$scope.chooseExceptions = function() {
		var url = 'ExceptionList.jsp?packageId=' + packageId;

		var width = 800; //窗口宽度
		var height = 400; //窗口高度
		var top = (window.screen.height - 30 - height) / 2;
		var left = (window.screen.width - 10 - width) / 2;
		window.open(url, "_blank", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width=" + width + " ,Height=" + height + ",top=" + top + ",left=" + left);
	};

	/**
	 * 选择异常的回调，把选择的异常赋值到当前方法中
	 * 
	 * @param <code>exceptions</code>选择的异常（数据类型：Array）
	 */
	$scope.confirmExceptions = function(exceptions) {
		exceptions.forEach(function(item, index, arr) {
			var existFlag = false;
			$scope.selectEntityMethodVO.exceptions.forEach(function(_item, _index, _arr) {
				//如果异常已存在,则更新
				if (item.modelId == _item.modelId) {
					$scope.selectEntityMethodVO.exceptions[_index] = item;
					existFlag = true;
				}
			});
			//如果不存在，则添加
			if (!existFlag) {
				$scope.selectEntityMethodVO.exceptions.push(item);
			}
		});
		$scope.checkBoxCheck($scope.selectEntityMethodVO.exceptions, 'objCheckAll.methodExceptionsCheckAll');
	};

	/**
	 * 删除方法的异常
	 *
	 */
	$scope.deleteMethodExceptions = function() {
		if (!$scope.selectEntityMethodVO.exceptions) {
			return;
		}
		var targetArr = [];
		$scope.selectEntityMethodVO.exceptions.forEach(function(item) {
			if (item.check) {
				targetArr.push({
					modelId: item.modelId
				});
			}
		});
		cap.array.remove($scope.selectEntityMethodVO.exceptions, targetArr, true);
		$scope.checkBoxCheck($scope.selectEntityMethodVO.exceptions, 'objCheckAll.methodExceptionsCheckAll');
	};
	

    $scope.isParameterEdit=function(){
    	return $scope.selectEntityMethodVO && $scope.selectEntityMethodVO.methodType != 'cascade' && $scope.selectEntityMethodVO.methodType != 'queryExtend' && $scope.selectEntityMethodVO.methodType != 'procedure' && $scope.selectEntityMethodVO.methodType != 'function';
    }
    
    $scope.showMoveBtn=function(parameterVo,flag){
    	if(!parameterVo){
    		return;
    	}
    	parameterVo.showMovBtn = flag;
    }
    
    /**
   	 * 删除方法的参数
   	 *
   	 */
   	$scope.deleteMethodParameterById = function(pId){
   		//存储需要删除的参数
   		var targetArr = [];
   		$scope.selectEntityMethodVO.parameters.forEach(function(item,index,arr){
   			if(item.parameterId == pId){
   				targetArr.push({parameterId : item.parameterId});
   			}
   		});
   		cap.array.remove($scope.selectEntityMethodVO.parameters, targetArr, true);
   		//删除参数后，再初始化所有参数的排序序号（从0开始）
   		$scope.selectEntityMethodVO.parameters.forEach(function(item, index, arr){
   			item.sortNo = index;
   		});
   		//$scope.checkBoxCheck($scope.selectEntityMethodVO.parameters,'objCheckAll.methodParamsCheckAll');
   	};
   	
   	/**
   	 * 参数上移
   	 *
   	 */
   	$scope.paramMoveUpNew = function(parameterVo){
   			if(parameterVo.sortNo == 0){
   				cui.alert("已经是第一个参数了，不能再上移了");
   				return;
   			}else{
   				//获得当前选中的参数的序号
   				var _sortNo = parameterVo.sortNo;
   				//使用临时变量把上一个参数保存起来
   				var temp = $scope.selectEntityMethodVO.parameters[_sortNo-1];
   				//上一个参数的index位置上存放当前选中的参数
   				$scope.selectEntityMethodVO.parameters[_sortNo-1] = parameterVo;
   				//当前选中的参数的位置上存放临时变量保存的参数
   				$scope.selectEntityMethodVO.parameters[_sortNo] = temp;
   				
   				//改变相互换位置的参数的sortNo
   				$scope.selectEntityMethodVO.parameters[_sortNo-1].sortNo -= 1;
   				$scope.selectEntityMethodVO.parameters[_sortNo].sortNo += 1;
   				
   			}
   	};
   	
   	/**
   	 * 参数上移
   	 *
   	 */
   	$scope.paramMoveDownNew = function(parameterVo){
   			if(parameterVo.sortNo == ($scope.selectEntityMethodVO.parameters.length-1)){
   				cui.alert("已经是最后个参数了，不能再下移了");
   				return;
   			}else{
   				//获得当前选中的参数的序号
   				var _sortNo = parameterVo.sortNo;
   				//使用临时变量把下一个参数保存起来
   				var temp = $scope.selectEntityMethodVO.parameters[_sortNo+1];
   				//下一个参数的index位置上存放当前选中的参数
   				$scope.selectEntityMethodVO.parameters[_sortNo+1] = parameterVo;
   				//当前选中的参数的位置上存放临时变量保存的参数
   				$scope.selectEntityMethodVO.parameters[_sortNo] = temp;
   				
   				//改变相互换位置的参数的sortNo
   				$scope.selectEntityMethodVO.parameters[_sortNo+1].sortNo += 1;
   				$scope.selectEntityMethodVO.parameters[_sortNo].sortNo -= 1;
   			}
   	};
   	
   	/**
   	 * 删除方法的异常
   	 *
   	 */
   	$scope.deleteMethodExceptionById = function(eId){
   		var targetArr = [];
   		$scope.selectEntityMethodVO.exceptions.forEach(function(item){
   			if(item.modelId==eId){
   				targetArr.push({modelId : item.modelId});
   			}
   		});
   		cap.array.remove($scope.selectEntityMethodVO.exceptions, targetArr, true);
   		//$scope.checkBoxCheck($scope.selectEntityMethodVO.exceptions,'objCheckAll.methodExceptionsCheckAll');
   	};

	/**
	 * 自定义SQL调用选择查询SQL/排序SQL的回调
	 * 
	 * @param <code>attrName</code>标识是“查询SQL”还是“排序SQL”
	 * @param <code>value</code>选择的值
	 */
	$scope.callbackUpdate = function(attrName, value) {
		if (attrName == "querySQL") {
			scope.selectEntityMethodVO.userDefinedSQL.querySQL = value;
		} else if (attrName == "sortSQL") {
			scope.selectEntityMethodVO.userDefinedSQL.sortSQL = value;
		} else if (attrName == "mybatisSQL") {
			scope.selectEntityMethodVO.queryExtend.mybatisSQL = value;
			if (value == "") {
				scope.selectEntityMethodVO.queryExtend = null;
			}
			$("#sqlRewrite").css("width", window.screen.width - 350);

			$("#mybatisSQL .CodeMirror").css("height", $("#sqlRewrite").height());
		}
		//eval("scope.selectEntityMethodVO.userDefinedSQL." + attrName + "=" + "'" + value + "'") ;//不要使用eval，因为value里面可能包含回车符
	};

	/**
	 * 快速查找方法（过滤）
	 *
	 */
	$scope.$watch("filterChar", function() {
		if(isSubQuery)
			return;

		//过滤时，重置变量
		$scope.displayPMethod = false;

		//过滤动作把所有记录选中状态全部取消。
		root.entityMethods.forEach(function(item) {
			item.check = false;
		});
		//并且把全选也设置为false
		$scope.objCheckAll.entityMethodsCheckAll = false;
		var hasCurrMethod = false;
		$scope._filterArr = [];
		for (var i = 0, len = root.entityMethods.length; i < len; i++) {
			if (($scope.filterChar == "" || root.entityMethods[i].engName.indexOf($scope.filterChar) > -1 || root.entityMethods[i].chName.indexOf($scope.filterChar) > -1) && root.entityMethods[i].methodId.indexOf("count") == -1 && root.entityMethods[i].methodId.indexOf("pagination") == -1) {
				root.entityMethods[i].isFilter = false;
				$scope._filterArr.push(root.entityMethods[i]);
				if (root.entityMethods[i].methodId == scope.selectEntityMethodVO.methodId) {
					hasCurrMethod = true;
				}
			} else {
				root.entityMethods[i].isFilter = true;
			}
		}
		//检测全选checkbox状态
		//scope.checkBoxCheck(filterMethodArr,"objCheckAll.entityMethodsCheckAll");

		if ($scope._filterArr.length > 0) {
			if (!hasCurrMethod) {
				$scope.selectEntityMethodVO = $scope._filterArr[0];
			}
		} else {
			$scope.selectEntityMethodVO = null;
		}
	});

	/**
	 * 校验方法列表是否为空（排除Count方法和Pagination方法，即Count方法和Pagination方法不计算在内）
	 *
	 */
	$scope.hasMethod = function() {
		//实体没有方法
		if (root.entityMethods.length <= 0) {
			return false;
		}
		//实体有方法，但都是Count方法或Pagination方法
		var result = root.entityMethods.some(function(item) {
			if (item.methodId.indexOf("count") == -1 && item.methodId.indexOf("pagination") == -1) {
				return true;
			}
			return false;
		});
		if (!result) {
			return false;
		}
		//如果有做过滤
		if ($scope.filterChar) {
			//并且过滤的结果数组长度等于0
			if ($scope._filterArr.length <= 0) {
				return false;
			}
		}
		//其他情况表示列表有数据，不为空
		return true;
	};


	//选择存储过程界面
	$scope.selectProduceFromDB = function() {
		var url = 'SelectProduceFromDB.jsp?produreId=' + $scope.selectEntityMethodVO.dbObjectCalled.objectId + "&packagePath=" + entity.modelPackage;
		var width = 800; //窗口宽度
		var height = 400; //窗口高度
		var top = (window.screen.height - 30 - height) / 2;
		var left = (window.screen.width - 10 - width) / 2;
		window.open(url, "selectProduceFromDB", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width=" + width + " ,Height=" + height + ",top=" + top + ",left=" + left);
	};

	//选择函数界面
	$scope.selectFunctionFromDB = function() {
		var url = 'SelectFunctionFromDB.jsp?functionId=' + $scope.selectEntityMethodVO.dbObjectCalled.objectId + "&packagePath=" + entity.modelPackage;
		var width = 800; //窗口宽度
		var height = 400; //窗口高度
		var top = (window.screen.height - 30 - height) / 2;
		var left = (window.screen.width - 10 - width) / 2;
		window.open(url, "SelectFunctionFromDB", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width=" + width + " ,Height=" + height + ",top=" + top + ",left=" + left);
	};

	//sql编辑
	$scope.editSQL = function(from, selectEntityMethodVO) {
		var url = "QueryModelSql.jsp?modelId=" + modelId + "&packageId=" + packageId + "&methodName=" +
			selectEntityMethodVO.engName + "&methodId=" + selectEntityMethodVO.methodId + "&from=" + from +"&methodType="+selectEntityMethodVO.methodType;
		window.open(url);
		window.focus();
	};

	//保存查询重写
	$scope.saveQueryExtend = function(model) {
		if ($scope.selectEntityMethodVO.methodId == model.methodId) {
			$scope.selectEntityMethodVO.queryExtend = model;
		} else {
			var methods = entity.methods;
			for (var i = 0; i < methods.length; i++) {
				var method = methods[i];
				if (method.methodId == model.methodId) {
					method.queryExtend = model;
					break;
				}
			}
		}
		$scope.javaMethodName = $scope.getJavaMethodName();
		$scope.$digest();
	};

	//重写父类方法
	$scope.overrideParent = function(pEntityMethodVo) {
		//校验是否存在相同方法
		var sameMethod = isExsitSameMethod(pEntityMethodVo);
		if (sameMethod) {
			//切换到实现类实体
			$scope.showPanel("method");
			//设置java方法名
			$scope.javaMethodName = $scope.getJavaMethodName();
		} else {
			//不存在新增重写方法
			$scope.addQueryExtendMethod(pEntityMethodVo, true);

			$scope.displayPMethod = false;
			$scope.checkBoxCheck($scope.root.entityMethods, "objCheckAll.entityMethodsCheckAll");
			//禁用相关控件
			$scope.disabledElements();

			//切换到实现类实体
			$scope.showPanel("method");
			//设置java方法名
			$scope.javaMethodName = $scope.getJavaMethodName();
		}
	};

	//新增查询重写方法
	$scope.addQueryExtendMethod = function(pEntityMethodVo, isSelectList) {
		var newEntityMethod = jQuery.extend(true, {}, pEntityMethodVo);
		newEntityMethod.methodType = "queryExtend";
		newEntityMethod.aliasName = "override_" + newEntityMethod.aliasName;
		//此处需要特别注意,dwr引擎对boolean原型值转换不允许出现null,否则会报没有详情的异常信息,很难查找原因
		newEntityMethod.privateService = "false";
		if (isSelectList) {
			newEntityMethod.methodId = (new Date()).valueOf().toString() + 1;
			$scope.selectEntityMethodVO = newEntityMethod;
		} else {
			newEntityMethod.methodId = (new Date()).valueOf().toString() + 2;
			//联动设值count方法
			newEntityMethod.queryExtend.mybatisSQL = "SELECT COUNT(1) FROM \n (" + $scope.selectEntityMethodVO.queryExtend.mybatisSQL + ")";
		}
		$scope.root.entityMethods.push(newEntityMethod);
	};

	//sql预览
	$scope.sqlPreview = function(isView) {
		var packageName = entity.modelPackage + ".dbconfig.";
		var xmlName = entity.modelName.substring(0, 1).toUpperCase() +
			entity.modelName.substring(1) + "BaseSQL.xml";

		dwr.TOPEngine.setAsync(false);
		QueryPreviewFacade.isCanPreview(packageName, xmlName, $scope.selectEntityMethodVO.engName, entity.modelId,{
			callback: function(result) {
				if (result=="SUCCESS") {
					$scope.editSQL(isView, $scope.selectEntityMethodVO);
				} else {
					cui.alert(result);
					return;
				}
			},
			errorHandler: function(message, exception) {
				if (console) {
					console.log(message);
				}
			}
		});
		dwr.TOPEngine.setAsync(true);
	};

	//获取java方法返回值
	$scope.getJavaMethodName = function() {
		if ($scope.selectEntityMethodVO.queryExtend == null) {
			return "";
		}

		var returnVals = $scope.selectEntityMethodVO.returnType.type.split(".");
		var returnVal = returnVals[returnVals.length - 1];
		var javaMethodName = $scope.selectEntityMethodVO.accessLevel + " " + returnVal + "<" + entity.modelName + "VO" + ">" + " " + $scope.selectEntityMethodVO.engName + "(" + entity.modelName + "VO" + " " + "vo)";
		return javaMethodName;
	};

	// ------------------------------------------------查询建模开始------------------------------------------------//

	/**
	 *点击select属性选择 
	 */
	$scope.selectAttrClick = function() {
		//这是为了避免原有方法没有新建querymodel做的兼容
		var queryModel = $scope.selectEntityMethodVO.queryModel;
		initQueryModel();
		//默认带packageId和modelId 打开页面为当前实体
		var url = "SelectEntityAttrListMain.jsp?packageId=" + packageId + "&modelId=" + modelId + "&actionType=select";
		var title = "SELECT属性选择";
		var height = 600;
		var width = 1000;
		entityAttributeDialog = cui.dialog({
			title: title,
			src: url,
			width: width,
			height: height
		})
		entityAttributeDialog.show(url);
	};

	/**
	 * 属性批量更新
	 * 
	 * @param  actionType 操作类型
	 * @return {[type]}
	 */
	$scope.attrBatchUpdate = function(actionType) {
		//校验查询建模
		if (!$scope.validateQueryModel()) {
			cui.alert("From数据不能为空,请先选择From.");
			return;
		}
		var url = "SelectEntityAttrListMain.jsp?packageId=" + packageId + "&modelId=" + modelId + "&actionType=" + actionType;
		var title = "WHERE属性批量新增";
		if (actionType == 'groupBy') {
			title = 'GROUPBY属性批量新增';
		} else if (actionType == "orderBy") {
			title = 'ORDERBY属性批量新增';
		}
		var height = 600;
		var width = 850;

		attrBatchUpdateDiaglog = cui.dialog({
			title: title,
			src: url,
			width: width,
			height: height
		})
		attrBatchUpdateDiaglog.show(url);
	};

	/**
	 * From表名点击修改嵌套子查询对象属性
	 */
	$scope.updateTables = function(subquery) {
		$scope.refQueryModel = subquery.refQueryModel;
		$scope.subquery = subquery;
		if (subquery.refQueryModel) {
			$scope.addSubQueryModel("edit");
		}
	};

	/**
	 * 清空SELECT属性
	 */
	$scope.clearSelectAttr = function() {
		cui.confirm("确定要将所有SELECT属性清空吗？", {
			onYes: function() {
				$scope.selectEntityMethodVO.queryModel.select.selectAttributes=[];
				cap.digestValue(scope);
			}
		});
	};

	/**
	 * 点击左侧表别名同步右侧数据
	 */
	$scope.changeRightColumns = function(tableAlias, idIndex) {
		//是否嵌套子查询
		if(isRef2QueryModel(tableAlias)){
			//根据表别名找到查询对象的属性下拉数据源
			var pulldownDatas = refQueryModelDataSource(tableAlias);
			cui("#onRightColumnName" + idIndex).setDatasource(pulldownDatas);
			$scope.selectEntityMethodVO.queryModel.from.subquerys[idIndex-1].onRight.columnName ="";
		}else{
			var entityId = "";
			var allData = getAllTableAlias();
			for (var i = 0; i < allData.length; i++) {
				if (allData[i].subTableAlias == tableAlias) {
					entityId = allData[i].entityId;
					break;
				}
			}
			dwr.TOPEngine.setAsync(false);
			EntityFacade.queryBaseAttributes(entityId, function(data) {
				cui("#onRightColumnName" + idIndex).setDatasource(data.list);
				$scope.selectEntityMethodVO.queryModel.from.subquerys[idIndex-1].onRight.columnName ="";
			});
			dwr.TOPEngine.setAsync(true);
		}
	};

	/**
	 * 点击左侧表名同步右边pulldown
	 */
	$scope.changeRightColumnsByIdAndIndex = function(id, tableAlias, idIndex ,conditionAttribute) {
		//是否嵌套子查询
		if(isRef2QueryModel(tableAlias)){
			//根据表别名找到查询对象的属性下拉数据源
			var pulldownDatas = refQueryModelDataSource(tableAlias);
			cui("" + id + idIndex).setDatasource(pulldownDatas);
		}else{
			var entityId = "";
			var allData = getAllTableAlias();
			for (var i = 0; i < allData.length; i++) {
				if (allData[i].subTableAlias == tableAlias) {
					entityId = allData[i].entityId;
				}
			}
			dwr.TOPEngine.setAsync(false);
			EntityFacade.queryBaseAttributes(entityId, function(data) {
				cui("" + id + idIndex).setDatasource(data.list);
			});
			dwr.TOPEngine.setAsync(true);
			
		}
		//更新当前对象的其他属性
		if (id=='#onLeftWhereColumnName') {
			$scope.selectEntityMethodVO.queryModel.where.whereConditions[idIndex-1].conditionAttribute.columnName="";
		}else if (id=='#sortAttributeColumnName') {
			$scope.selectEntityMethodVO.queryModel.orderBy.sorts[idIndex-1].sortAttribute.columnName="";
		}else if(id=='#groupByAttrColumnName'){
			$scope.selectEntityMethodVO.queryModel.groupBy.groupByAttributes[idIndex-1].columnName="";
		}
		var froms = getAllTableAlias();
		var item = $scope.queryFromByTableAlias(froms, tableAlias);
		if(conditionAttribute){
			conditionAttribute.entityId = item ? item.entityId : "";
		}
	};

	/**
	 * 通过表别名查询From对象
	 * 
	 * @param  froms
	 * @param  表别名
	 * @return From
	 */
	$scope.queryFromByTableAlias = function(froms, tableAlias) {
		for (var i = 0; i < froms.length; i++) {
			if (froms[i].subTableAlias == tableAlias) {
				return froms[i];
			}
		};
		return {};
	};

	/**
	 * From 添加子查询
	 */
	$scope.addChildQuery = function() {
		var top = (window.screen.availHeight - 600) / 2;
		var left = (window.screen.availWidth - 800) / 2;
		window.open("SelectEntityListMain.jsp?systemModuleId=" + packageId + "&openType=multi&tableAlias=t", "queryModel", 'height=600,width=800,top=' + top + ',left=' + left + ',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no');
	};
	
	/**
	 * addSubQueryModel 添加嵌套子查询
	 */
	$scope.addSubQueryModel = function(operateType) {
		var top = (window.screen.availHeight - 600) / 2 - 100;
		var left = (window.screen.availWidth - 800) / 2 - 100;
		var subQueryId = "";
		if (operateType == "addNew") {
			//新增则清空subquery
			$scope.subquery = null;
			$scope.refQueryModel = null;
		} else {
			subQueryId = $scope.subquery ? $scope.subquery.subQueryId : "";
		}
		window.open("SubQueryModel.jsp?modelId=" + modelId + "&isSubQuery=" + true + "&tableAlias=t&subQueryId=" + subQueryId, "addSubQueryModel" + Math.random() * 100, 'height=800,width=1000,top=' + top + ',left=' + left + ',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no');
	};

	/**
	 * addWhereCondition 新增where条件
	 */
	$scope.addWhereCondition = function() {
		//校验查询建模
		if (!$scope.validateQueryModel()) {
			cui.alert("From数据不能为空,请先选择From.");
			return;
		}

		//主表信息
		var primaryTable = $scope.selectEntityMethodVO.queryModel.from.primaryTable;
		primaryTable = primaryTable ? primaryTable : {};

		//查询条件
		var whereConditions = $scope.selectEntityMethodVO.queryModel.where.whereConditions;
		whereConditions = whereConditions ? whereConditions : [];

		//当前实体属性
		var attr = getEntityPrimary();

		var whereCondition = {
			operatorType: whereConditions.length == 0 ? "" : "and",
			hasLeftBracket: false,
			conditionAttribute: {
				tableAlias: primaryTable.subTableAlias,
				columnName: attr ? attr.dbFieldId : "",
				entityId : primaryTable.entityId
			},
			wildcard: "=",
			transferValPattern: "constant",
			value: "",
			hasRightBracket: false,
			emptyCheck: true
		};
		whereConditions.push(whereCondition);
		$scope.selectEntityMethodVO.queryModel.where.whereConditions = whereConditions;
	};

    /**
     * 查询条件值点击事件
     * 
     * @param  whereCondition
     * @return {[type]}
     */
	$scope.whereConditionValue = function(whereCondition){
		$scope.whereCondition = whereCondition;
		var url = "SelectMethodParameter.jsp";
		var title = "方法参数选择";
		var height = 600;
		var width = 850;
		getWhereConditionDialog = cui.dialog({
			title: title,
			src: url,
			width: width,
			height: height
		})
		getWhereConditionDialog.show(url);
	};

    /**
     * 设置查询条件值回调
     * 
     * @param 条件值
     * @param 数据类型
     */
	$scope.setWhereConditionCallBack = function(whereConditionValue, dataType) {
		if ("java.util.List" == dataType) {
			if ($scope.whereCondition.wildcard != "IN" && $scope.whereCondition.wildcard != "NOT IN") {
				$scope.whereCondition.wildcard = "IN";
			}
		}
		$scope.whereCondition.value = whereConditionValue;
		$scope.$apply();
		getWhereConditionDialog.hide();
	};

	$scope.changeWhereConditionValue = function(value, index) {
		cui("#whereConditionValue" + index).setValue("");
	};

	/**
	 * 新增排序
	 */
	$scope.addOrderBy = function() {
		//校验查询建模
		if (!$scope.validateQueryModel()) {
			cui.alert("From数据不能为空,请先选择From.");
			return;
		}

		//主表信息
		var primaryTable = $scope.selectEntityMethodVO.queryModel.from.primaryTable;
		primaryTable = primaryTable ? primaryTable : {};

		//查询条件
		var sortConditions = $scope.selectEntityMethodVO.queryModel.orderBy.sorts;
		sortConditions = sortConditions ? sortConditions : [];

		//当前实体属性
		var attr = getEntityPrimary();
		var sortNo = getSortNo();
		var sortCondition = {
			sortNo: sortNo,
			sortType: 'desc',
			sortAttribute: {
				tableAlias: primaryTable.subTableAlias,
				columnName: attr ? attr.dbFieldId : ""
			}
		};
		sortConditions.push(sortCondition);
		if (isEmptyObject($scope.selectEntityMethodVO.queryModel.orderBy)) {
			$scope.selectEntityMethodVO.queryModel.orderBy.sortEnd = "NULLS LAST";
			$scope.selectEntityMethodVO.queryModel.orderBy.dynamicOrder = false;
		};
		$scope.selectEntityMethodVO.queryModel.orderBy.sorts = sortConditions;
	};

	/**
	 * 设置默认值
	 */
	$scope.setDeafaultValue=function(flag,tableAliasValue){
		if (flag&&tableAliasValue=='') {
			var pTable = scope.selectEntityMethodVO.queryModel.from.primaryTable;
			cui("#dynamicAttribute").setValue(pTable.subTableAlias);
		}
	}
	/**
	 * 新增分组函数
	 */
	$scope.addGroupBy = function() {
		//校验查询建模
		if (!$scope.validateQueryModel()) {
			cui.alert("From数据不能为空,请先选择From.");
			return;
		}

		//主表信息
		var primaryTable = $scope.selectEntityMethodVO.queryModel.from.primaryTable;
		primaryTable = primaryTable ? primaryTable : {};

		//查询条件
		var groupByAttributes = $scope.selectEntityMethodVO.queryModel.groupBy.groupByAttributes;
		groupByAttributes = groupByAttributes ? groupByAttributes : [];

		//当前实体属性
		var attr = getEntityPrimary();

		var groupByAttribute = {
			tableAlias: primaryTable.subTableAlias,
			columnName: attr ? attr.dbFieldId : ""
		};
		groupByAttributes.push(groupByAttribute);
		$scope.selectEntityMethodVO.queryModel.groupBy.groupByAttributes = groupByAttributes;
	};

	//根据下标删除SELECT属性
	$scope.delSelectAttr = function(index) {
		//当前页面中的属性
		var currentAttributes = scope.selectEntityMethodVO.queryModel.select.selectAttributes;
		currentAttributes = currentAttributes ? currentAttributes : [];
		currentAttributes.splice(index, 1);
	}


	//根据表别名和index删除
	$scope.delFromAttr = function(tableAlias, index) {
		var pTable = scope.selectEntityMethodVO.queryModel.from.primaryTable;
		var subQuerys = scope.selectEntityMethodVO.queryModel.from.subquerys;
		if (index!=-1) {
			subQuerys = subQuerys ? subQuerys : [];
			subQuerys.splice(index, 1);
		} else {
			//删除主表的情况
			if (subQuerys) {
				$scope.selectEntityMethodVO.queryModel.from.primaryTable = subQuerys[0];
				subQuerys.splice(0, 1);
			}else{
				$scope.selectEntityMethodVO.queryModel.from.primaryTable = null;
			}
		}
		//更新所有依赖
		delSelectAttrForTableAlias(tableAlias);
		//
		delWhereAttrForTableAlias(tableAlias);
		//
		delOrderByAttrForTableAlias(tableAlias);
		//
		delGroupByAttrForTableAlias(tableAlias);
		$timeout(function(){
			//延迟刷新FROM
			delFromAttrForTableAlias(tableAlias);
		} , 500);

	}

	//根据index删除
	$scope.delWhereAttr = function(index) {
		//查询条件
		var whereConditions = $scope.selectEntityMethodVO.queryModel.where.whereConditions;
		whereConditions = whereConditions ? whereConditions : [];
		whereConditions.splice(index, 1);
		
	}

	//根据表别名和index删除
	$scope.delOrderAttr = function(index) {
		//查询条件
		var sortConditions = $scope.selectEntityMethodVO.queryModel.orderBy.sorts;
		sortConditions = sortConditions ? sortConditions : [];
		sortConditions.splice(index, 1);
	}


	/**
	 * 根据序号删除
	 */
	$scope.delGroupAttr = function(index) {
		//查询条件
		var groupByAttributes = $scope.selectEntityMethodVO.queryModel.groupBy.groupByAttributes;
		groupByAttributes = groupByAttributes ? groupByAttributes : [];
		groupByAttributes.splice(index, 1);
		
	};

	/**
	 * 另存为公共条件
	 */
	$scope.saveCommonQueryCondition = function() {
		dwr.TOPEngine.setAsync(false);
		EntityOperateAction.saveCommonQueryCondition($scope.selectEntityMethodVO.queryModel, function(result) {
			entity.customSqlCondition = result;
			cui.alert("另存为公共条件成功,可在属性页签更多中的自定义查询按钮中预览.");
		});
		dwr.TOPEngine.setAsync(true);
	};
	

	//校验查询建模
	$scope.validateQueryModel = function() {
		var from = $scope.selectEntityMethodVO.queryModel.from;
		if (from && from.primaryTable) {
			return true;
		}
		if (!from || !from.primaryTable || !from.subquerys || from.subquerys.length < 1) {
			return false;
		}
		return true;
	};

	//添加自定义表达式
	$scope.addAttributeExp = function() {
		var relationEntityId = "";
		var returnType = $scope.selectEntityMethodVO.returnType.type;
		if (returnType == "entity" || returnType == "java.util.List") {
			dwr.TOPEngine.setAsync(false);
			EntityOperateAction.getRelationEntityId($scope.selectEntityMethodVO, function(result) {
				relationEntityId = result;
			});
			dwr.TOPEngine.setAsync(true);
		}
		var url = 'SelectAttributeExp.jsp?modelId=' + relationEntityId + '&packageId=' + packageId;
		var width = 500; //窗口宽度
		var height = 400; //窗口高度
		var top = (window.screen.height - 30 - height) / 2;
		var left = (window.screen.width - 10 - width) / 2;
		window.open(url, "_blank", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width=" + width + " ,Height=" + height + ",top=" + top + ",left=" + left);
	}

	//新增自定义查询条件
	$scope.customQueryCondition = function() {
		//校验查询建模
		if (!$scope.validateQueryModel()) {
			cui.alert("From数据不能为空,请先选择From.");
			return;
		}
		//主表信息
		var primaryTable = $scope.selectEntityMethodVO.queryModel.from.primaryTable;
		primaryTable = primaryTable ? primaryTable : {};

		//查询条件
		var whereConditions = $scope.selectEntityMethodVO.queryModel.where.whereConditions;
		whereConditions = whereConditions ? whereConditions : [];

		var whereCondition = {
			operatorType: whereConditions.length == 0 ? "" : "and",
			hasLeftBracket: false,
			customCondition: "",
			hasRightBracket: false,
			emptyCheck: false
		};
		whereConditions.push(whereCondition);
		$scope.selectEntityMethodVO.queryModel.where.whereConditions = whereConditions;
	}

	//select属性别名编辑
	$scope.selectAttributeClick = function(selectAttribute) {
		var width = 500; //窗口宽度
		var height = 400; //窗口高度
		var top = (window.screen.height - 30 - height) / 2;
		var left = (window.screen.width - 10 - width) / 2;
		var url = 'SelectAttribute.jsp?modelId=' + modelId + '&packageId=' + packageId;
		var returnType = $scope.selectEntityMethodVO.returnType.type;
		$scope.selectAttribute = selectAttribute;

		//根据返回类型判断显示类型
		var relationEntityId = "";
		if (returnType == "entity" || returnType == "java.util.List") {
			dwr.TOPEngine.setAsync(false);
			EntityOperateAction.getRelationEntityId($scope.selectEntityMethodVO, function(result) {
				relationEntityId = result;
			});
			dwr.TOPEngine.setAsync(true);
		} else {
			relationEntityId = "none";
		}

		if (selectAttribute.sqlScript && selectAttribute.sqlScript.length > 0) {
			url = 'SelectAttribute.jsp?modelId=' + modelId + '&packageId=' + packageId + '&relationEntityId=' + relationEntityId +'&isShowExpression=true';
		} else {
			url = 'SelectAttribute.jsp?modelId=' + modelId + '&packageId=' + packageId + '&relationEntityId=' + relationEntityId;
		}
		//打开页面
		window.open(url, "_blank", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width=" + width + " ,Height=" + height + ",top=" + top + ",left=" + left);
	}

	//添加查询建模参数
	$scope.addQueryModelparam = function() {
		var parameters = $scope.selectEntityMethodVO.parameters;
		if (parameters.length < 1) {
			$scope.selectEntityMethodVO.parameters = [{
				parameterId: (new Date()).valueOf(),
				chName: "查询VO",
				engName: "queryVO",
				sortNo: 0,
				description: "查询建模VO",
				dataType: {
					source: "entity",
					type: "entity",
					value: modelId,
					generic: null
				}
			}];
		}
	};

    //默认查询条件
	$scope.defaultQueryCondition = function(){
		var url = webPath + "/cap/bm/dev/entity/CustomSqlCondition.jsp?modelId=" + modelId + "&packageId=" + packageId + "&from=entityMethodList";
		window.open(url);
		window.focus();
	};
	
	//打开快速创建级联方法的窗口
	$scope.fastCascadeMethod = function(){
		var url = "FastCascadeMethod.jsp?modelId=" + modelId;
		var title = "快速创建级联方法";
		var height = 300;
		var width = 800;
		if(!fastCascadeMethodDialog){
			fastCascadeMethodDialog = cui.dialog({
				title: title,
				src: url,
				width: width,
				height: height
			})
		}
		fastCascadeMethodDialog.show(url);
	};

}

//调用angular Js
angular.module('entityMethodList', ["cui"]).controller('entityMethodController', ['$scope', '$timeout', entityMethodList]);

//主查询dialog
var entityAttributeDialog;
var attrBatchUpdateDiaglog;
var fastCascadeMethodDialog;

//是否存在同名同参的方法
function isExsitSameMethod(pEntityMethodVo) {
	var methods = entity.methods;
	for (var i = 0; i < methods.length; i++) {
		var method = methods[i];
		if (method.engName == pEntityMethodVo.engName && method.parameters.length == pEntityMethodVo.parameters.length) { //方法中参数长度一样
			for (var j = 0; j < method.parameters.length; j++) {
				var parameter = method.parameters[j];
				var parameter2 = pEntityMethodVo.parameters[j];
				if (parameter.dataType.type == parameter2.dataType.type && parameter.dataType.value == parameter2.dataType.value) { //方法中参数的数据类型一致
					return method;
				}

			}
		}
	}
	return null;
}

//关联实体属性选择界面
function setAttributeGeneric() {
	var url = "SetEntityAttributeGeneric.jsp?packageId=" + packageId + "&modelId=" + modelId;
	var title = "属性泛型设置";
	var height = 600;
	var width = 700;

	genericDialog = cui.dialog({
		title: title,
		src: url,
		width: width,
		height: height
	})
	genericDialog.show(url);
};

//泛型设置界面
var genericDialog;

//泛型设置回调
function setGeneric(genericString, genericDataList) {
	scope.selectEntityMethodVO.returnType.value = genericString;
	scope.selectEntityMethodVO.returnType.generic = genericDataList;
	scope.$digest();
	if (genericDialog) {
		genericDialog.hide();
	}
}

function getDataTypeGenericList() {
	return scope.selectEntityMethodVO.returnType.generic;
}

function getDataType() {
	return scope.selectEntityMethodVO.returnType.type;
}

/**
 * 保存时，对所有方法根据方法类型进行处理。把与当前方法类型无关的一些字段进行重置。
 *
 */
var processMethod4Save = function() {
	root.entityMethods.forEach(function(item, index, arr) {
		switch (item.methodType) {
			case "cascade":
				item.dbObjectCalled = null; //""
				item.userDefinedSQL = null; //""
				if (item.methodOperateType != "query") {
					item.needCount = false;
					item.needPagination = false;
				}
				break;
			case "userDefinedSQL":
				item.lstCascadeAttribute = null; //[]
				item.dbObjectCalled = null; //""
				if (item.methodOperateType != "query") {
					item.needCount = false;
					item.needPagination = false;
				}

				//改变返回值类型，如果是自定义SQL调用的话，要去设置paramterType和resultType。
				//放在这里调用，是为了简化代码。否则，就需要放在返回值改变事件以及参数改变事件中调。
				if (item.methodId.indexOf("count") == -1 && item.methodId.indexOf("pagination") == -1) {
					scope.initDefinedSQLParamAndResultType(item);
				}

				break;
			case "procedure":
			case "function":
				item.methodOperateType = null; //""
				item.needCount = false; //false
				item.needPagination = false; //false
				item.lstCascadeAttribute = null; //[]
				item.userDefinedSQL = null; //""
				break;
			case "queryModeling":
				item.methodOperateType = null; //""
				// item.needCount = false; //false
				// item.needPagination = false; //false
				item.lstCascadeAttribute = null; //[]
				item.dbObjectCalled = null; //""
				item.userDefinedSQL = null; //""
				break;
			case "blank":
				item.methodOperateType = null; //""
				item.needCount = false; //false
				item.needPagination = false; //false
				item.lstCascadeAttribute = null; //[]
				item.dbObjectCalled = null; //""
				item.userDefinedSQL = null; //""
				break;
			case "pagination":
				//do nothing
				break;
			case "queryExtend":
				//do nothing
				break;
			default:
				throw new Error("some exception happened.case by:the selected methodType is illegal.");
		}
	});

	if (scope.selectEntityMethodVO.methodType != 'userDefinedSQL') {
		scope.queryParams = "";
		scope.returnResult = "";
	}
	processCountPaginationMethod(root.entityMethods);
};

/**
 * 实体保存时处理Count方法及Pagination方法的删除与生成。
 *
 * @param <code>methodArray</code> 当前实体的所有方法的集合
 */
var processCountPaginationMethod = function(methodArray) {
	//1、先删除Count方法及Pagination方法
	if (!methodArray || methodArray.length <= 0) {
		return;
	}
	//找出需要删除的方法的ID
	var needDelArray = [];
	methodArray.forEach(function(_item, _index, _arr) {
		//如果存在Count方法或Pagination方法，并且是自动生成的方法，则删除。
		if (_item.methodId.indexOf("count") != -1 || _item.methodId.indexOf("pagination") != -1) {
			needDelArray.push({
				methodId: _item.methodId
			});
		}
	});
	//执行删除
	if (needDelArray.length > 0) {
		cap.array.remove(methodArray, needDelArray, true);
	}

	//2、再生成
	if (!methodArray || methodArray.length <= 0) {
		return;
	}
	//生成的方法的集合
	var genMethodArray = [];
	methodArray.forEach(function(inst, idex, ar) {
		if ((inst.methodType == "cascade" || inst.methodType == "userDefinedSQL") && inst.methodOperateType == "query") {
			if (inst.needPagination === true) {
				//生成Count方法和Pagination方法
				genMethod(inst, "count", genMethodArray);
				genMethod(inst, "pagination", genMethodArray);
			} else if (inst.needCount === true) {
				//生成Count方法
				genMethod(inst, "count", genMethodArray);
			} else {
				//no gen
			}
		}
		//查询建模同样需要生成分页方法
		if(inst.methodType == "queryModeling"){
			if (inst.needPagination === true) {
				//生成Count方法和Pagination方法
				genMethod(inst, "count", genMethodArray);
				genMethod(inst, "pagination", genMethodArray);
			} else if (inst.needCount === true) {
				//生成Count方法
				genMethod(inst, "count", genMethodArray);
			} else {
				//no gen
			}
		}
	});
	//把生成好的方法全部加到实体的方法集合中。
	if (genMethodArray.length > 0) {
		genMethodArray.forEach(function(genItem) {
			methodArray.push(genItem);
		});
	}
};
/**
 * 生成Count方法或Pagination方法
 *
 * @param <code>vo</code> 为当前方法(vo)生成Count或Pagination方法
 * @param <code>type</code> 生成什么方法，可取值为“count”或“pagination”
 * @param <code>lst</code> 生成的方法放到lst数组中。
 */
var genMethod = function(vo, type, lst) {
	var _chName, _engName, _aliasName, _returnType, _methodType, _userDefinedSQL, _methodOperateType;
	if (type == "count") {
		_chName = vo.chName + "数量";
		_engName = vo.engName + "Count";
		_aliasName = vo.aliasName + "Count";
		_returnType = {
			source: 'primitive',
			type: 'int',
			value: null,
			generic: null
		};
		_methodType = vo.methodType == "queryModeling" ? "queryModeling" : "userDefinedSQL";
		_userDefinedSQL = cui.utils.parseJSON(cui.utils.stringifyJSON(vo.userDefinedSQL));
		//组装Count方法的SQL。
		if (_userDefinedSQL && _userDefinedSQL.querySQL) {
			_userDefinedSQL.querySQL = "SELECT COUNT(1) FROM (" + _userDefinedSQL.querySQL + ")";
			_userDefinedSQL.sortSQL = null;
		}
		//设置mybatis的resultType为int类型
		if(_userDefinedSQL){
			_userDefinedSQL.resultType = "int";
		}
		_methodOperateType = "query";
	} else if (type == "pagination") {
		_chName = vo.chName + "(分页查询)";
		_engName = vo.engName + "Pagination";
		_aliasName = vo.aliasName + "Pagination";
		_returnType = {
			source: 'collection',
			type: 'java.util.Map',
			value: null,
			generic: [{
				generic: null,
				type: 'String',
				value: null,
				source: 'primitive'
			}, {
				generic: null,
				type: 'java.lang.Object',
				value: '',
				source: 'javaObject'
			}]
		};
		_methodType = "pagination";
		_userDefinedSQL = null;
		_methodOperateType = null;
	}

	//生成方法。
	var newEntityMethod = {
		methodId: vo.methodId + type,
		accessLevel: 'public',
		autoMethod: true,
		lstCascadeAttribute: null,
		chName: _chName,
		engName: _engName,
		aliasName: _aliasName,
		assoMethodName: vo.engName,
		description: _chName,
		exceptions: [],
		methodSource: 'entity',
		methodType: _methodType,
		parameters: cui.utils.parseJSON(cui.utils.stringifyJSON(vo.parameters)), //Count方法和Pagination方法的入参和当前方法的入参一样
		returnType: _returnType,
		serviceEx: 'none',
		transaction: true,
		methodOperateType: _methodOperateType,
		dbObjectCalled: null,
		userDefinedSQL: _userDefinedSQL,
		queryModel: vo.methodType == "queryModeling" ? $.extend(true,{},vo.queryModel) : null,
		needCount: false,
		needPagination: false
	};
	lst.push(newEntityMethod);
};

//验证规则

var checkColumnNeedRule = [{
	'type': 'required',
	'rule': {
		'm': '属性不能为空'
	}
}];

var methodEngNameValRule = [{
	'type': 'required',
	'rule': {
		'm': '方法名称不能为空'
	}
}, {
	'type': 'custom',
	'rule': {
		'against': checkEnNameChar,
		'm': '必须为英文字符、数字或者下划线，且必须以小写英文字符开头。'
	}
}];
var methodChNameValRule = [{
	'type': 'required',
	'rule': {
		'm': '中文名称不能为空'
	}
}];
var methodAliasNameValRule = [{
	'type': 'required',
	'rule': {
		'm': '方法别名不能为空'
	}
}, {
	'type': 'custom',
	'rule': {
		'against': checkEnNameChar,
		'm': '必须为英文字符、数字或者下划线，且必须以小写英文字符开头。'
	}
}, {
	'type': 'custom',
	'rule': {
		'against': checkMethodAliasNameIsExist,
		'm': '方法别名已经存在。'
	}
}];
//只提供给validateAll保存时做最终校验使用
var methodAliasNameValRuleTemp = [{
	'type': 'required',
	'rule': {
		'm': '方法别名不能为空'
	}
}, {
	'type': 'custom',
	'rule': {
		'against': checkEnNameChar,
		'm': '必须为英文字符、数字或者下划线，且必须以小写英文字符开头。'
	}
}];
//检验方法别名是否存在
function checkMethodAliasNameIsExist(aliasName) {
	var flag = false;
	var methodId = scope.selectEntityMethodVO.methodId;
	//遍历当前实体方法判断是否存在重复别名
	for (var i = 0; i < root.entityMethods.length; i++) {
		if (root.entityMethods[i].aliasName == aliasName && root.entityMethods[i].methodId != methodId) {
			flag = true;
			break;
		}
	}
	if (!flag) {
		for (var k = 0; k < scope.parentEntityMethods.length; k++) {
			if (scope.parentEntityMethods[k].aliasName == aliasName && scope.parentEntityMethods[k].methodId != methodId) {
				flag = true;
				break;
			}
		}
	}
	return !flag;
}

//保存时检验方法别名是否存在重复
function checkMethodAliasNameIsRepeat() {
	var arr = new Array();
	var repearMethodTemp = '';
	var flag = false;
	var currentMethods = root.entityMethods;
	var parentMethods = scope.parentEntityMethods;
	var allMethods = currentMethods.concat(parentMethods);
	//循环遍历当前实体方法列表
	for (var i = 0; i < currentMethods.length; i++) {
		var currentMethodAliasName = currentMethods[i].aliasName;
		var currentMethodId = currentMethods[i].methodId;
		var currentMethodName = currentMethods[i].engName;
		for (var k = 0; k < allMethods.length; k++) {
			//如果当前比对的方法别名跟其他方法别名相同并且方法id不同，则认为出现重复方法别名
			if (currentMethodAliasName == allMethods[k].aliasName && currentMethodId != allMethods[k].methodId) {
				flag = true;
				repearMethodTemp = currentMethodName;
				break;
			}
		}
		if (flag) {
			break;
		}
	}
	arr.unshift(flag);
	arr.unshift(repearMethodTemp);
	return arr;
}

//校验勾选分页方法时参数必填及第一个参数必须是实体类型
function checkParamTypeForPage() {
	var arr = new Array();
	var repearMethodTemp = '';
	var flag = false;
	var currentMethods = root.entityMethods;
	//循环遍历当前实体方法列表
	for (var i = 0; i < currentMethods.length; i++) {
		//分页标识
		var pageFlag = currentMethods[i].needPagination;
		var currentMethodName = currentMethods[i].engName;
		if (pageFlag) {
			var parameters = currentMethods[i].parameters;
			//没有参数
			if (parameters == null || typeof(parameters) == undefined || parameters.length == 0) {
				flag = true;
				repearMethodTemp = currentMethodName;
				break;
			} else {
				//第一个参数为非实体类型
				if (parameters[0].dataType.type != "entity") {
					flag = true;
					repearMethodTemp = currentMethodName;
					break;

				}
			}
		}
	}
	arr.unshift(flag);
	arr.unshift(repearMethodTemp);
	return arr;
}

var validate = new cap.Validate();
//统一校验函数
function validateAll() {
	var methodAliasNameIsRepeat = checkMethodAliasNameIsRepeat();
	if (methodAliasNameIsRepeat[1]) {
		return {
			message: methodAliasNameIsRepeat[0] + "方法别名存在重复，请改正后再保存!<br/>",
			validFlag: false
		};
	}
	
	var paramPageMsg = checkParamTypeForPage();
	if (paramPageMsg[1]) {
		return {
			message: paramPageMsg[0] + "分页方法必须有参数，第一个参数必须是实体类型(有pageSize和pageNo属性)!<br/>",
			validFlag: false
		};
	}
	
	var validateQueryModelRule = checkRightColumnNameNeedRule();
	if (validateQueryModelRule[1]) {
		return {
			message: validateQueryModelRule[0],
			validFlag: false
		};
	}

	var validateRule = {
		engName: methodEngNameValRule,
		chName: methodChNameValRule,
		aliasName:methodAliasNameValRuleTemp
	};
	var result = validate.validateAllElement(root.entityMethods, validateRule);
	//如果验证通过，则设置方法别名为只读
	if(result.validFlag){
		var aliasNameValue = $.trim(cui("#aliasName").getValue());
		if (aliasNameValue != "" && aliasNameValue.length > 0) {
			cui("#aliasName").setReadonly(true);
		}
	}
	return result;
}

function checkRightColumnNameNeedRule(){
	var methodType = scope.selectEntityMethodVO.methodType;
	if (methodType != "queryModeling") {
		return [true];
	}

	 var arr = new Array();
	 var repearMethodTemp = '';
	 var flag = false;
	 //子查询下拉框效验
	 var currentSubquerys = scope.selectEntityMethodVO.queryModel.from.subquerys;
	 currentSubquerys= currentSubquerys?currentSubquerys:[];
	 //循环遍历当前实体方法列表
	 for (var i = 0; i < currentSubquerys.length; i++) {
	 	var currentRightAliasName = currentSubquerys[i].onRight.columnName;
	 	var currentRightAlias = currentSubquerys[i].onRight.tableAlias;
	 	var currentLeftAliasName = currentSubquerys[i].onLeft.columnName;
	 	var subTableAlias = currentSubquerys[i].subTableAlias;
	 	if (currentLeftAliasName==null||currentLeftAliasName=='') {
	 		repearMethodTemp = "查询建模FROM下第"+(i+2)+"行，别名 "+subTableAlias + " 对应属性值为空，请改正后再保存!<br/>";
	 		flag = true;
	 	}else if (currentRightAliasName==null||currentRightAliasName=='') {
	 		repearMethodTemp = "查询建模FROM下第"+(i+2)+"行，别名 "+currentRightAlias + " 对应属性值为空，请改正后再保存!<br/>";
	 		flag = true;
	 	}
		if (flag) {
			arr.unshift(flag);
			arr.unshift(repearMethodTemp);
			return arr;
		}
	 }



	//WHERE下拉框效验
	var whereConditions = scope.selectEntityMethodVO.queryModel.where.whereConditions;
	whereConditions = whereConditions ? whereConditions : [];
	//循环遍历当前实体方法列表
	for (var i = 0; i < whereConditions.length; i++) {
		if (whereConditions[i].conditionAttribute) {
			var currentRightAliasName = whereConditions[i].conditionAttribute.columnName;
			var currentRightAlias = whereConditions[i].conditionAttribute.tableAlias;
			if (currentRightAliasName == null || currentRightAliasName == '') {
				repearMethodTemp = "查询建模WHERE下第" + (i + 1) + "行，别名 " + currentRightAlias + " 对应属性值为空，请改正后再保存!<br/>";
				flag = true;
			}
		}else if(whereConditions[i].customCondition==null||whereConditions[i].customCondition==''){
				repearMethodTemp = "查询建模WHERE下第" + (i + 1) + "行，自定义条件不能为空，请改正后再保存!<br/>";
				flag = true;
		}
		
		if (flag) {
			arr.unshift(flag);
			arr.unshift(repearMethodTemp);
			return arr;
		}
	}

	//ORDERBY下拉框效验
	var sortConditions = scope.selectEntityMethodVO.queryModel.orderBy.sorts;
	sortConditions = sortConditions ? sortConditions : [];
	//循环遍历当前实体方法列表
	for (var i = 0; i < sortConditions.length; i++) {
		var currentRightAliasName = sortConditions[i].sortAttribute.columnName;
		var currentRightAlias = sortConditions[i].sortAttribute.tableAlias;
		if (currentRightAliasName == null || currentRightAliasName == '') {
			repearMethodTemp = "查询建模ORDERBY下第" + (i + 1) + "行，别名 " + currentRightAlias + " 对应属性值为空，请改正后再保存!<br/>";
			flag = true;
		}
		if (flag) {
			arr.unshift(flag);
			arr.unshift(repearMethodTemp);
			return arr;
		}
	}

	//GROUPBY下拉框效验
	var groupByAttributes = scope.selectEntityMethodVO.queryModel.groupBy.groupByAttributes;
	groupByAttributes = groupByAttributes ? groupByAttributes : [];
	//循环遍历当前实体方法列表
	for (var i = 0; i < groupByAttributes.length; i++) {
		var currentRightAliasName = groupByAttributes[i].columnName;
		var currentRightAlias = groupByAttributes[i].tableAlias;
		if (currentRightAliasName == null || currentRightAliasName == '') {
			repearMethodTemp = "查询建模GROUPBY下第" + (i + 1) + "行，别名 " + currentRightAlias + " 对应属性值为空，请改正后再保存!<br/>";
			flag = true;
		}
		if (flag) {
			arr.unshift(flag);
			arr.unshift(repearMethodTemp);
			return arr;
		}
	}

	 arr.unshift(flag);
	 arr.unshift(repearMethodTemp);
	 return arr;
}

//文本域全屏
function isFullScreen(cm) {
	var a = /\bCodeMirror-fullscreen\b/.test(cm.getWrapperElement().className);
	return a;
}

function winHeight() {
	return window.innerHeight || (document.documentElement || document.body).clientHeight;
}

function winWidth() {
	return window.innerWidth || (document.documentElement || document.body).clientWidth;
}

function setFullScreen(cm, full) {
	var wrap = cm.getWrapperElement(),
		scroll = cm.getScrollerElement();
	if (full) {
		wrap.className += " CodeMirror-fullscreen";
		scroll.style.height = winHeight() + "px";
		var width = winWidth() - 80;
		var height = winHeight() - 80;
		cm.setSize(width, height);
		document.documentElement.style.overflow = "";
	} else {
		wrap.className = wrap.className.replace(" CodeMirror-fullscreen", "");
		scroll.style.height = "100px";
		cm.setSize("auto", "100px");
		document.documentElement.style.overflow = "";
	}
	cm.refresh();
}

//获取选择的存储过程或函数 
//参数dbObjects是数组对象,dbtype是类型：存储过程procedure，函数function
function selectedDBObjectCalled(dbObject, dbtype) {
	if (dbObject != null) {
		//重新初始化
		scope.selectEntityMethodVO.dbObjectCalled = {
			lstParameters: new Array(),
			objectId: "",
			objectName: ""
		};
		//给方法数据对象赋值
		scope.selectEntityMethodVO.dbObjectCalled.objectId = dbObject.modelId;
		scope.selectEntityMethodVO.dbObjectCalled.objectName = dbObject.engName;
		if ("procedure" == dbtype) {
			convertObject(dbObject.procedureColumns);
		}
		if ("function" == dbtype) {
			convertObject(dbObject.functionColumns);
		}
	}
	scope.$digest();
}

//对象转换
function convertObject(columns) {
	//将存储过程参数显示在方法列表中，只显示入参 ，返回值出参不显示
	if (columns && columns.length > 0) {
		var parameters = new Array();
		for (var i = columns.length - 1; i >= 0; i--) {
			var obDbObjectParam = {
				paramChName: "",
				paramName: "",
				value: "",
				paramType: "",
				paramCategory: "",
				transferValPattern: ""
			};
			obDbObjectParam.paramName = columns[i].parameterName;
			obDbObjectParam.paramChName = columns[i].parameterChName;
			obDbObjectParam.value = columns[i].parameterName;
			obDbObjectParam.paramType = tranfDatabaseTypeToJavaType(columns[i].dataType);
			obDbObjectParam.transferValPattern = "methodParam";
			obDbObjectParam.paramCategory = getParamCategoryString(columns[i].parameterType);
			scope.selectEntityMethodVO.dbObjectCalled.lstParameters.unshift(obDbObjectParam);

			var parameter = {
				parameterId: i + 100,
				chName: "",
				engName: "",
				sortNo: i,
				description: "",
				dataType: {
					source: "primitive",
					type: "",
					value: "",
					generic: null
				}
			}
			parameter.engName = columns[i].parameterName;
			parameter.chName = columns[i].parameterChName;
			parameter.dataType.type = tranfDatabaseTypeToJavaType(columns[i].dataType);
			var category = getParamCategoryString(columns[i].parameterType);
			parameter.description = category == 'in' ? '输入参数' : (category == 'out' ? '输出参数' : '返回值');
			parameters.unshift(parameter);
		}
		scope.selectEntityMethodVO.parameters = parameters;
	} else {
		scope.selectEntityMethodVO.parameters = null;
	}
}

//将数据对象类型转换为java类型
function tranfDatabaseTypeToJavaType(databaseType) {
	if (!databaseType || databaseType == null || databaseType == "") {
		return "";
	}
	if (databaseType == "VARCHAR2" || databaseType == "VARCHAR" || databaseType == "NVARCHAR") {
		return "String";
	} else if (databaseType == "DATE") {
		return "java.sql.Timestamp";
	} else if (databaseType == "LONG") {
		return "long";
	} else if (databaseType == "NUMBER" || databaseType == "INTEGER") {
		return "int";
	} else {
		return databaseType;
	}

}
//将数据对象类型转换参数类别
function getParamCategoryString(parameterType) {
	if (!parameterType || parameterType == null) {
		return "";
	}
	if (parameterType == "1" || parameterType == '') {
		return "in";
	} else if (parameterType == "3") {
		return "out";
	} else if (parameterType == "4" || parameterType == "5") {
		return "return";
	} else {
		return parameterType;
	}
}

/**
 *检查元数据一致性 是否通过
 *@items 当前所选对象数组 
 *@entity 数据类型
 */
function checkConsistency(items, entity) {
	var checkflag = true;
	dwr.TOPEngine.setAsync(false);
	//删除之前先检查元素一致性依赖
	window.parent.dependOnCurrentData = [];
	window.parent.currentDependOnData = [];
	//console.log("window.parent.dependOnCurrentData = [];"+window.parent.dependOnCurrentData);
	EntityFacade.checkEntityMethodBeingDependOn(items, entity, function(redata) {
		if (redata) {
			if (!redata.validateResult) { //有错误
				window.parent.dependOnCurrentData = redata.dependOnCurrent == null ? [] : redata.dependOnCurrent;
				window.parent.initOpenConsistencyImage(checkUrl);
				checkflag = false;
				cui.message('当前选择实体方法不能被删除，请检查元数据一致性！');
			} else {
				window.parent.initOpenConsistencyImage(checkUrl); //通过则关闭div和dialog
				//checkflag = false;
				//cui.alert('当前选择实体不能被删除，请检查元数据一致性！');
			}
		} else {
			cui.error("元数据一致性效验异常，请联系管理员！");
		}
	});
	dwr.TOPEngine.setAsync(true);
	return checkflag;
}

/**
 * 整合实体属性操作的按钮，把不是很常用的按钮整合到按钮下拉菜单中
 */
var moreAction = function (){
	var actionArray = [];
	//当实体存在多重性关系时。增加“快速创建级联方法”的菜单。
	//if(entity.lstRelation.length > 0){
	actionArray.push({id : "fastCascadeMethodCreate", label : "快速创建级联方法", click : "scope.fastCascadeMethod"});
	//}
	
	return {
		datasource : actionArray,
		on_click : function(obj){
			eval(obj.click)();
		 }
	};
};