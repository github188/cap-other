//编辑区域控件指令
CUI2AngularJS.directive('cuiEditCodeArea', ['$interpolate','$compile', function ($interpolate,$compile) {
    return {
    	restrict: 'A',
        transclude: true,
        scope: {
        	ngObject: '=' //scope.root[xxx]对象，xxx表示控件id
        },
        controller: function($scope) {
        	$scope.entityId = $scope.ngObject.scope.entityId;
        	$scope.entityAlias = $scope.ngObject.scope.entityAlias;
        	$scope.attributes = $scope.ngObject.scope.attributes;
        	$scope.datasource4SubEntity = $scope.entityId != '' ? getDatasource4SubEntity($scope.entityId) : [];//关联子实体数据源（pulldown）
        	$scope.components = $scope.ngObject.scope.components;
        	
        	$scope.$watch("entityAlias", function(newValue, oldValue){
	    		if(newValue != oldValue){
	    			var data = cui("#selectEntity_"+$scope.ngObject.metaComponentDefine.id).getData();//实体下拉框可选状态
	    			$scope.entityId = data != null ? data.entityVO.modelId : $scope.entityId;
	    			$scope.reloadData();
	    		} else {
	    			cui("#addEditableGridCodeArea_"+$scope.ngObject.metaComponentDefine.id).disable($scope.datasource4SubEntity.length == 0);
	    		}
	    	}, false);
        	
        	// 重新初始化table数据
        	$scope.reloadData=function(){
        		var componentInfo = $scope.ngObject.metaComponentDefine.uiConfig.componentInfo;
        		if(componentInfo == null){
        			$scope.attributes = getAttributes($scope.entityId);
	    			$scope.datasource4SubEntity = getDatasource4SubEntity($scope.entityId);
	    			$scope.components = [];
        			var isDisable = $scope.entityId == null || $scope.entityId == '' ? true : false;
	    			cui("#addFormCodeArea_"+$scope.ngObject.metaComponentDefine.id).disable(isDisable);
	    			cui("#addFieldsetCodeArea_"+$scope.ngObject.metaComponentDefine.id).disable(isDisable);
	    			cui("#addEditableGridCodeArea_"+$scope.ngObject.metaComponentDefine.id).disable($scope.datasource4SubEntity.length == 0);
        		} else {
        			$scope.attributes = getAttributes($scope.entityId);
        			$scope.datasource4SubEntity = getDatasource4SubEntity($scope.entityId);
        			for(var i in $scope.components){
        				var componentVo = $scope.components[i];
        				if(componentVo.uitype == 'editFormCodeArea'){
        					componentVo.scope.entityId = $scope.entityId;
        					componentVo.scope.entityAlias = $scope.entityAlias;
        					componentVo.scope.attributes = jQuery.extend(true, [], $scope.attributes);
        					componentVo.scope.components = [];
        				} else {
        					cui("#selectSubEntity_"+$scope.ngObject.metaComponentDefine.id+"_"+componentVo.id).setDatasource($scope.datasource4SubEntity);
        					componentVo.scope.entityId = '';
        					componentVo.scope.attributes = [];
        					componentVo.scope.customHeaders = [];
        				}
        			}
        		}
    	    }
        	
        	$scope.clearData=function(){
	    		$scope.attributes = [];
	    		$scope.components = [];
	    		cui("#addFormCodeArea_"+$scope.ngObject.metaComponentDefine.id).disable(true);
    			cui("#addFieldsetCodeArea_"+$scope.ngObject.metaComponentDefine.id).disable(true);
    			cui("#addEditableGridCodeArea_"+$scope.ngObject.metaComponentDefine.id).disable(true);
	    	};
        	
        	//保存
        	$scope.save=function(){
    	    	var retData = {id: $scope.ngObject.metaComponentDefine.id, entityId: $scope.entityId, entityAlias: $scope.entityAlias, groupingBarList:[], formAreaList:[], editGridAreaList:[], subComponentLayoutSortList:[]};
    	    	_.forEach($scope.components, function(componentVo) {
    	    		if(componentVo.uitype === 'editFormCodeArea'){
    	    			var data = componentVo.scope.save();
    	    			retData.formAreaList.push({id: componentVo.id, areaId: componentVo.areaId, area: componentVo.uitype, col: data.col, rowList: data.components});
    	    		} else if(componentVo.uitype === 'editGridCodeArea'){
    	    			var data = componentVo.scope.save();
    	    			retData.editGridAreaList.push({id: componentVo.id, areaId: componentVo.areaId, area: componentVo.uitype, includeFileList: data.includeFileList, entityId: componentVo.scope.entityId, options: data.options});
    	    		} else{
    	    			retData.groupingBarList.push({id: componentVo.id, areaId: componentVo.id, value: componentVo.value});
    	    		}
    	    		retData.subComponentLayoutSortList.push(componentVo.id);
    	    	});
        		return retData;
    	    }
        	
        	//添加表单
	    	$scope.addFormCodeArea=function(){
	    		if(!cui("#addFormCodeArea_"+$scope.ngObject.metaComponentDefine.id).options.disable){
	    			$scope.components.push({id: getRandomId('form'), uitype:'editFormCodeArea', scope:{entityId: $scope.entityId, entityAlias: $scope.entityAlias, attributes: jQuery.extend(true, [], $scope.attributes)}});
	    		}
	    	}
        	
	    	//添加分组栏
	    	$scope.addFieldset=function(){
	    		if(!cui("#addFieldsetCodeArea_"+$scope.ngObject.metaComponentDefine.id).options.disable){
	    			$scope.components.push({id: getRandomId('fieldset'), value: '', uitype:''});
	    		}
	    	}

	    	//添加EditableGrid
	    	$scope.addEditableGrid=function(){
	    		if(!cui("#addEditableGridCodeArea_"+$scope.ngObject.metaComponentDefine.id).options.disable){
	    			$scope.components.push({id: getRandomId('editGrid'), uitype:'editGridCodeArea', scope:{entityId: $scope.datasource4SubEntity.length > 0 ? $scope.datasource4SubEntity[0].id : ''}});
	    		}
	    	}
	    	
	    	//下移模块
	    	$scope.downCodeArea=function(){
	    		var id = $(this)[0].componentVo.id;
	    		for(var i=0, len=$scope.components.length; i<len; i++){
                    if(i != len-1 && $scope.components[i].id === id){
                    	var nextData = $scope.components[i+1];
						$scope.components.splice(i+1, 1, $scope.components[i]);
						$scope.components.splice(i, 1, nextData);
						break;
                    } 
                }
	    	}
	    	
	    	//上移模块
	    	$scope.upCodeArea=function(){
	    		var id = $(this)[0].componentVo.id;
	    		for(var i=0, len=$scope.components.length; i<len; i++){
                    if(i != 0 && $scope.components[i].id === id){
                    	var frontData = $scope.components[i-1];
                    	$scope.components.splice(i-1, 2, $scope.components[i]);
						$scope.components.splice(i, 0, frontData);
						break;
                    } 
                }
	    	}
	    	//删除模块
	    	$scope.deleteCodeArea=function(){
	    		var newArr=[];
                for(var i=0, len=$scope.components.length; i<len; i++){
                    if($scope.components[i].id != $(this)[0].componentVo.id){
                    	newArr.push($scope.components[i]);
                    } 
                }
                $scope.components = newArr;
	    	}
	    	
        },
        link: function (scope, element, attrs, controller) {
        	var jct = new jCT($('#editCodeArea').html());
			jct.ngObject = scope.ngObject;
			var html = jct.Build().GetView();
			element.html(html).show();
			
	        $compile(element.contents())(scope);
	        comtop.UI.scan();
	        scope.ngObject.scope = scope;
        }
    }
}]);

//编辑网格区域指令
CUI2AngularJS.directive('cuiEditGridCodeArea', ['$interpolate','$compile', function ($interpolate,$compile) {
    return {
    	restrict: 'A',
        transclude: true,
        scope: {
        	ngComponentDefineId:'@',//scope.root[ngComponentDefineId]
        	datasource4SubEntity: '=',
        	parentEntityId:'=',
        	parentObject:'='//scope.root[ngModel].scope.components---vo,
        },
        controller: function($scope) {
        	//数据模型属性（左侧表格数据源）
			$scope.attributes　=　$scope.parentObject.scope.attributes != null ? $scope.parentObject.scope.attributes : [];
	    	$scope.attributesCheckAll　=　false;
	    	$scope.customHeadersCheckAll　=　false;
	    	$scope.label = $scope.parentObject.scope.label;
	    	//列头属性（右侧表格数据源）
	    	$scope.customHeaders　=　$scope.parentObject.scope.customHeaders != null ? $scope.parentObject.scope.customHeaders : [];
	    	//被选中的列头属性对象
	    	$scope.data　=　$scope.customHeaders.length > 0 ? $scope.customHeaders[0] : {};
	    	$scope.component　=　{};
	    	$scope.hasHideNotCommonProperties = true;
	    	$scope.hasBatchEdittypeOperation = false;
	    	//批量修改只能修改edittype对象
	    	$scope.batchEdittype = [];
	    	$scope.batchEditProperties = {};
	    	$scope.batchEditBindNameVo = {};
	    	$scope.uitype = $scope.customHeaders.length > 0 ? $scope.customHeaders[0].edittype.data.uitype : null;
			//默认显示属性tab标签
	    	$scope.active='property';
	    	$scope.entityId = $scope.parentObject.scope.entityId;
	    	$scope.selectrows = $scope.parentObject.scope.selectrows;
	    	
        	$scope.$watch("entityId", function(newValue, oldValue){
        		if(newValue != oldValue){
        			$scope.attributes = [];
        			$scope.customHeaders = [];
        			if(newValue != ''){
        				$scope.attributes = getAttributes(newValue);
        			} else {
        				$scope.data = {};
        			}
        		} 
	    	}, false);
        	
	    	//加载控件属性
	    	$scope.loadComponent=function(componentName){
	    		if(componentName != null && componentName != ''){
	    			var group = componentName == 'ChooseOrg' || componentName == 'ChooseUser' ? 'expand' : 'common';
		    		var modelId = "uicomponent."+ group +".component."+componentName.substring(0, 1).toLowerCase()+componentName.substring(1);
	    			$scope.component = getComponentByModelId(modelId, toolsdata);
	    			//常用属性
    				$scope.component.commonProperties = [];
    				//非常用属性
    				$scope.component.notCommonProperties = [];
    				var properties = _.remove($scope.component.properties, function(n) {
  					  	return n.ename != 'databind';
  					});
    				$scope.component.properties = properties;
    				for(var i in properties){
    					if(properties[i].commonAttr){
    						$scope.component.commonProperties.push(properties[i]);
    					} else {
    						$scope.component.notCommonProperties.push(properties[i]);
    					}
    				}
	    			if($scope.batchEdittype.length > 0){
	    				$scope.hasBatchEdittypeOperation = true;
	    			} else {
	    				$scope.hasBatchEdittypeOperation = false;
	    				if(componentName === 'RadioGroup' 
    						&& ($scope.data.edittype.data.name == null || $scope.data.edittype.data.name == '')){
	    					$scope.data.edittype.data.name = $scope.data.bindName;
	    				}else if((componentName === 'ChooseOrg' || componentName === 'ChooseUser')
    						&& ($scope.data.edittype.data.idName == null || $scope.data.edittype.data.idName == '')){
    						$scope.data.edittype.data.idName = $scope.data.bindName;
    					}
	    			}
	    			//实体属性默认值绑定到控件对应的属性中（目前只有数据字典和枚举）
	    			setAttrDefault2ComponentOptions(componentName, $scope.attributes, $scope.data.customHeaderId, $scope.data.edittype.data);
	    			$scope.data.edittype.data.componentModelId = $scope.component.modelId;
	    			$scope.compileTmpl();
	    		}
	    	}
	    	
	    	//加载模版以及解析dom
	    	$scope.compileTmpl=function(){
	    		$scope.component.prefix = 'edittype';
	    		var domStr = '<span cui_edittype ng-component-define-id="'+$scope.ngComponentDefineId+'" parent-object="parentObject"></span>';
	    		var idName = 'properties-div-'+$scope.ngComponentDefineId+'-'+$scope.parentObject.id;
	    		$('#'+idName).html(domStr);
        		$compile($('#'+idName).contents())($scope);
        		cap.validater.destroy();
        		cap.validater.add('bindName', 'format', {pattern:'^\\w+$', m:'只能输入由字母、数字或者下划线组成的字符串'});
        		//cap.validater.add('name', 'format', {pattern:'^[a-zA-Z_0-9()（）\u4e00-\u9fa5]+$', m:'只能输入由字母、数字、汉字或者下划线组成的字符串'});
        		cap.validater.add('name', 'exclusion', {within:[ '\\','$' ], partialMatch:true, caseSensitive:true , m:'不能输入$\字符'});
	    	}
			
	    	//切换展现非常用属性开关
	    	$scope.switchHideArea=function(flag){
	    		$scope[flag] = !$scope[flag];
	    	}
	    	
	    	//处理表头列所对应的控件类型
	    	$scope.saveEdittypeBefore=function(_customHeaders){
	    		var customHeaders = jQuery.extend(true, [], _customHeaders);
	    		var edittype = {};
				for(var i in customHeaders){
					var customHeader = customHeaders[i];
		    		if(customHeader.bindName != null && _.size(customHeader.edittype.data) > 0){
		    			deleteNullAndEmpty(customHeader.edittype.data);
		    			if(customHeader.edittype.propertiesType != null && _.size(customHeader.edittype.propertiesType) > 0){
			    			transformEdittype(customHeader.edittype.data, customHeader.edittype.propertiesType);
		    			}
		    			var hasThrdUI = hasThrdComponent(customHeader.edittype.data.uitype);
		    			if(hasThrdUI){
		    				customHeader.edittype.data.thrdui = true;
		    			}
		    			// wrapOptions(customHeader.edittype.data);
		    			edittype[customHeader.bindName] = customHeader.edittype.data;
		    		}
				}
				return edittype;
	    	}
	    	
	    	$scope.saveCustomHeaderBefore=function(customHeader){
	    		for(var j in customHeader){
	    			delete customHeader[j].customHeaderId;
	    			delete customHeader[j].check;
	    			delete customHeader[j].level;
	    			delete customHeader[j].indent;
	    			delete customHeader[j].rowNo;
	    			delete customHeader[j].edittype;
	    			var modeVo = customHeader[j];
	    			for(var key in modeVo){
	    				if((modeVo[key] == null || modeVo[key] == '' || modeVo[key] === 'null') && key != 'name'){
	    					delete modeVo[key];
	    				}
	    			}
	    		}
	    	}
	    	
	    	//校验
	    	$scope.validate=function(){
	    		var resData = {result: "success"};
	    		if($scope.customHeaders.length > 0){
					var hasMultiTableHeader = _.pluck(_.sortBy($scope.customHeaders, 'level'), 'level').reverse()[0] > 1 ? true : false;
					if(hasMultiTableHeader){//多表头
						var customHeaders = getMultiLineHeaders($scope.customHeaders);
						if(customHeaders.length == 0){
							 resData.result = "error";
							 resData.message = "编辑网格多表头结构设置有误。";
						} 
					} 
				} 
	    		return resData;
	    	}
	    	
	    	//保存
			$scope.save=function(){
				var data = {includeFileList: [], options: {}};
				if($scope.customHeaders.length > 0){
					var hasMultiTableHeader = _.pluck(_.sortBy($scope.customHeaders, 'level'), 'level').reverse()[0] > 1 ? true : false;
					var customHeaders = [];
					if(hasMultiTableHeader){//多表头
						customHeaders = getMultiLineHeaders($scope.customHeaders);
						if(customHeaders.length > 0){
							var addSelectrowsColumnVo = {};
							if($scope.selectrows == null || $scope.selectrows == '' || $scope.selectrows == 'multi'){
								addSelectrowsColumnVo = {rowspan:customHeaders.length,width:60,type:'checkbox'};
								customHeaders[0] = _.union([addSelectrowsColumnVo], customHeaders[0]);
							} else if($scope.selectrows == 'single'){
								addSelectrowsColumnVo = {rowspan:customHeaders.length,width:60,name:''};
								customHeaders[0] = _.union([addSelectrowsColumnVo], customHeaders[0]);
							} 
							for(var i in customHeaders){
								$scope.saveCustomHeaderBefore(customHeaders[i]);
							}
						} else {
							//cui.error("多表头结构设置有误。"); 
							return;
						}
					} else {
						customHeaders = jQuery.extend(true, [], $scope.customHeaders);
						$scope.saveCustomHeaderBefore(customHeaders);
					}
					
					var customHeadersToExtras = jQuery.extend(true, [], $scope.customHeaders);
					for(var i=0, len=customHeadersToExtras.length; i<len; i++){//编辑时，默认选中第一项
						customHeadersToExtras[i].check = i == 0 ? true : false;
					}
					var edittype = $scope.saveEdittypeBefore($scope.customHeaders);
					var attributeVo = _.find($scope.attributes, {primaryKey: true});
					var primaryKey = attributeVo != null ? attributeVo.engName : '';
					var entityVo = _.find(scope.entityList, {'modelId': $scope.parentEntityId});
					var include = {hasIncludeUserOrgFileList: false, hasIncludeDictionaryFileList: false};//是否需要引用文件条件
					var databind = '';
		        	if(entityVo != null){
		        		var suffix = entityVo.suffix;
		        		var relationVariableName = cui("#selectSubEntity_"+$scope.ngComponentDefineId+'_'+$scope.parentObject.id).selectData.relationVariableName;
		        		if(relationVariableName == ''){//绑定数据集自身实体对象
			 				databind = suffix;
		 				} else if(relationVariableName != null){//绑定子实体对象
		 					databind = suffix + '.' + relationVariableName;
		 				}
		        		_.forEach(edittype, function(chr) {
 							if(!include.hasIncludeUserOrgFileList && (chr.uitype === "ChooseUser" || chr.uitype === "ChooseOrg")){
 								include.hasIncludeUserOrgFileList = true;
 							}
 							if(!include.hasIncludeDictionaryFileList && chr.dictionary != null){
 								include.hasIncludeDictionaryFileList = true;
 							}
 						});
		        	}
		        	data.includeFileList = getIncludeFile(include);//获取引用文件
					data.options = {primarykey: primaryKey, databind: databind, columns: JSON.stringify(customHeaders), edittype: JSON.stringify(edittype), selectrows: $scope.selectrows != '' ? $scope.selectrows : null, extras: JSON.stringify({entityId: $scope.entityId, tableHeader: customHeaders.length > 0 ? JSON.stringify(customHeadersToExtras) : '[]'})};
				} 
				return data;
			}
	    	
	    	//显示隐藏数据
	    	$scope.showAttributeVO=function(engNames){
	    		for(var i=0, len=engNames.length; i<len; i++){
	    			for(var j=0, len2=$scope.attributes.length; j<len2; j++){
	    				if($scope.attributes[j].engName == engNames[i]){
	    					$scope.attributes[j].isFilter = false;
	    					break;
	    				}
	    			}
	    		}
	    		$scope.checkBoxCheckAttribute($scope.attributes, false);
	    		$scope.attributesCheckAll=false;
	    	}
	    	
	    	//新增列
	    	$scope.addCustomHeader=function(customHeaderVo){
	    		$scope.data = customHeaderVo;
	    		$scope.customHeaders.push(customHeaderVo);
	    		for(var i in $scope.customHeaders){
    				$scope.customHeaders[i].check = false;
	    		}
	    		customHeaderVo.check = true;
	    		$scope.batchEdittype = [];
	    		if($scope.uitype != $scope.data.edittype.uitype){
		    		$scope.uitype = $scope.data.edittype.uitype;
		    		$scope.loadComponent($scope.data.edittype.uitype);
	    		}
	    		$scope.customHeadersCheckAll　=　false;
	    	}
	    	
	     	//删除自定义表头
	    	$scope.deleteCustomHeader=function(){
               	var newArr=[];
               	var delCustomHeaderIds=[];
                for(var i=0, len=$scope.customHeaders.length; i<len; i++){
                    if(typeof($scope.customHeaders[i].check) == 'undefined' || !$scope.customHeaders[i].check){
                    	newArr.push($scope.customHeaders[i]);
                    } else {
                    	delCustomHeaderIds.push($scope.customHeaders[i].customHeaderId);
                    }
                }
                $scope.customHeaders = newArr;
                $scope.showAttributeVO(delCustomHeaderIds);
                var isExist = (_.filter(delCustomHeaderIds, function(chr) { return chr == $scope.data.customHeaderId;})).length > 0 ? true : false;
                if(isExist){
                	$scope.data = {};
                }
                $scope.customHeadersCheckAll = false;
                $scope.hasBatchEdittypeOperation = false;
	    	}
	    	
	    	//监控全选checkbox，如果选择则联动选中列表所有数据
	    	$scope.allCheckBoxCheckAttribute=function(ar,isCheck){
	    		if(ar!=null && isCheck){
	    			for(var i=0, len=ar.length; i<len; i++){
	    				if(!ar[i].isFilter){
	    					var newComponentVo = createComponentVo4Attribute(ar[i]);
	    					if(ar[i].attributeType.source === 'dataDictionary' || ar[i].attributeType.source === 'enumType'){
		    					newComponentVo.render = 'actionlibrary.bestPracticeAction.gridAction.action.gridDicRender';
		    	    		}
		    	    		$scope.addCustomHeader(newComponentVo);
		    	    		$scope.uitype = newComponentVo.edittype.data.uitype;
    					}
		    		}	
	    		}
	    	}
	    	
	    	//监控选中，如果列表所有行都被选中则选中allCheckBox
	    	$scope.checkBoxCheckAttribute=function(ar,allCheckBox){
	    		if(ar!=null){
	    			var checkCount=0;
	    			var allCount=0;
		    		for(var i=0;i<ar.length;i++){
		    			if(ar[i].check){
		    				checkCount++;
		    				var newComponentVo = createComponentVo4Attribute(ar[i]);
		    				if(ar[i].attributeType.source === 'dataDictionary' || ar[i].attributeType.source === 'enumType'){
		    					newComponentVo.render = 'actionlibrary.bestPracticeAction.gridAction.action.gridDicRender';
		    	    		}
		    	    		$scope.addCustomHeader(newComponentVo);
		    	    		$scope.uitype = newComponentVo.edittype.data.uitype;
			    		}
		    			
		    			if(!ar[i].isFilter){
		    				allCount++;
		    			}
		    		}
		    		if(checkCount==allCount && checkCount!=0){
		    			eval("$scope."+allCheckBox+"=true");
		    		}else{
		    			eval("$scope."+allCheckBox+"=false");
		    		}
	    		}
	    	}
	    	
	    	//选中属性(数据模型属性)
	    	$scope.gridAttributeTdClick=function(attributeVo){
	    		var newComponentVo = createComponentVo4Attribute(attributeVo);
	    		if(attributeVo.attributeType.source === 'dataDictionary' || attributeVo.attributeType.source === 'enumType'){
	    			newComponentVo.render = 'actionlibrary.bestPracticeAction.gridAction.action.gridDicRender';
	    		}
	    		$scope.addCustomHeader(newComponentVo);
	    		$scope.uitype = newComponentVo.edittype.data.uitype;
		    }
	    	
	    	//选中(定义表头表格)
	    	$scope.customHeaderTdClick=function(customHeaderVo){
    			$scope.data = customHeaderVo;
	    		if($scope.batchEdittype.length > 0){//此前是批量操作
	    			$scope.batchEdittype = [];
    				$scope.uitype = customHeaderVo.edittype.data.uitype != null ? customHeaderVo.edittype.data.uitype : '';
    				if($scope.uitype != ''){
		    			$scope.loadComponent($scope.uitype);
	    			} 
	    		} else if($scope.uitype === customHeaderVo.edittype.data.uitype){//单个操作，但控件类型一样
	    			$scope.loadComponent($scope.uitype);
	    		} else {//不同控件类型
	    			$scope.uitype = customHeaderVo.edittype.data.uitype != null ? customHeaderVo.edittype.data.uitype : '';
	    		}
	    		for(var i in $scope.customHeaders){
    				$scope.customHeaders[i].check = false;
	    		}
	    		customHeaderVo.check = true;
	    		$scope.customHeadersCheckAll　=　$scope.customHeaders.length == 1 ? true : false;
	    		$scope.level = customHeaderVo.level;
		    }
	    	
	    	//监控全选checkbox，如果选择则联动选中列表所有数据
	    	$scope.allCheckBoxCheckCustomHeader=function(ar,isCheck){
	    		if(ar!=null){
	    			$scope.batchEdittype = [];
	    			for(var i=0;i<ar.length;i++){
		    			if(isCheck){
		    				ar[i].check=true;
		    				$scope.batchEdittype.push(ar[i]);
			    		}else{
			    			ar[i].check=false;
			    		}
		    		}
	    			
	    			if(isCheck){
		    			if(ar.length > 1 && $scope.hasSameType() === true){
			    			var data = jQuery.extend(true, {}, $scope.batchEdittype[0]);
			    			data.edittype.data = {};
			    			$scope.data = jQuery.extend(true, {}, data);
			    			var selectedValue = $scope.batchEdittype[0].edittype.data.uitype != null ? $scope.batchEdittype[0].edittype.data.uitype : '';
		    				if($scope.uitype === selectedValue){
				    			$scope.loadComponent(selectedValue);
				    		} else {
				    			$scope.uitype = selectedValue;
				    		}
	    				} else if (ar.length == 1){
	    					$scope.data = ar[0];
	    					$scope.uitype = ar[0].edittype.data.uitype != null ? ar[0].edittype.data.uitype : '';
	    				} else {
	    					$scope.uitype = '';
	    					$scope.data = {};
		    				$('#propertyEditorUI').html('');
	    				}
		    		} else {
		    			$scope.data = {};
		    			$scope.uitype = '';
		    			$('#propertyEditorUI').html('');
		    		}
	    		}
	    		$scope.level = '';
	    	}
	    	
	    	//监控选中，如果列表所有行都被选中则选中allCheckBox
	    	$scope.checkBoxCheckCustomHeader=function(ar,allCheckBox){
	    		if(ar!=null){
	    			var checkCount=0;
	    			var allCount=ar.length;
	    			var selectedValue = '';
	    			$scope.batchEdittype = [];
		    		for(var i=0;i<allCount;i++){
		    			if(ar[i].check){
		    				checkCount++;
		    				$scope.batchEdittype.push(ar[i]);
			    		}
		    		}
		    		if(checkCount==allCount && checkCount!=0){
		    			eval("$scope."+allCheckBox+"=true");
		    		}else{
		    			eval("$scope."+allCheckBox+"=false");
		    		}
		    		
		    		if(checkCount == 1) {//单个操作
		    			selectedValue = $scope.batchEdittype[0].edittype.data.uitype != null ? $scope.batchEdittype[0].edittype.data.uitype : '';
			    		$scope.data = $scope.batchEdittype[0];
			    		$scope.batchEdittype = [];
		    		} else if(checkCount > 1 && $scope.hasSameType() == true){//批量操作
		    			var data = jQuery.extend(true, {}, $scope.batchEdittype[0]);
		    			data.edittype.data = {};
		    			$scope.data = jQuery.extend(true, {}, data);
		    			selectedValue = $scope.batchEdittype[0].edittype.data.uitype != null ? $scope.batchEdittype[0].edittype.data.uitype : '';
		    		} else {//选中了多个复选框，但控件类型不一致、未选中任何表头行
		    			$scope.data = {};
		    			$scope.hasBatchEdittypeOperation = false;
		    		}
		    		if($scope.uitype === selectedValue){
		    			$scope.loadComponent(selectedValue);
		    		} else {
		    			$scope.uitype = selectedValue;
		    		}
	    		}
	    		$scope.level = '';
	    	}
	    	
	    	//批量修改编辑控件，判断是否是同一类控件类型
	    	$scope.hasSameType=function(){
	    		var ret = true;
	    		if($scope.customHeaders.length > 0){
	    			var q = new cap.CollectionUtil($scope.customHeaders);
	    			var customHeaders = q.query("this.check==true");
	    			var uitype = customHeaders[0].edittype.data.uitype != null ? customHeaders[0].edittype.data.uitype : '';
	    			for(var i=1, len=customHeaders.length; i<len; i++){
	    				var nextuitype = customHeaders[i].edittype.data.uitype != null ? customHeaders[i].edittype.data.uitype : '';
	    				if(uitype != nextuitype){
	    					ret = false;
	    					break;
	    				} 
		    		}
	    		} else {
	    			ret = false;
	    		}
    			return ret;
	    	}
	    	
	    	//上移
			$scope.up=function(){
	    		if($scope.customHeaders.length > 0 && $scope.customHeaders[0].check){
	    			return;
	    		}
	    		var mobileHeaders = [];
	    		for(var i in $scope.customHeaders){
	    			if($scope.customHeaders[i].check){
	    				mobileHeaders.push($scope.customHeaders[i]);
	    			}
	    		}
	    		for(var i in mobileHeaders){
	    			var currentData = mobileHeaders[i];
					if(currentData.customHeaderId != null){
						var currentIndex = 0;
						var frontData = {};
						for(var i in $scope.customHeaders){
							if($scope.customHeaders[i].customHeaderId == currentData.customHeaderId){
								currentIndex = i;
								break;
							}
						}
						if(currentIndex > 0){
							frontData = $scope.customHeaders[currentIndex - 1];
							$scope.customHeaders.splice(currentIndex - 1, 2, currentData);
							$scope.customHeaders.splice(currentIndex, 0, frontData);
						} 
					}
	    		}
			}
			
			//下移
			$scope.down=function(){
				var len = $scope.customHeaders.length;
	    		if(len > 0 && $scope.customHeaders[len-1].check){
	    			return;
	    		}
	    		var mobileHeaders = [];
	    		for(var i in $scope.customHeaders){
	    			if($scope.customHeaders[i].check){
	    				mobileHeaders.push($scope.customHeaders[i]);
	    			}
	    		}
	    		mobileHeaders = mobileHeaders.reverse();
	    		for(var i in mobileHeaders){
	    			var currentData = mobileHeaders[i];
					if(currentData.customHeaderId != null){
						var currentIndex = 0;
						var nextData = {};
						for(var i in $scope.customHeaders){
							if($scope.customHeaders[i].customHeaderId == currentData.customHeaderId){
								currentIndex = i;
								break;
							}
						}
						if(currentIndex < len-1){
							nextData = $scope.customHeaders[parseInt(currentIndex) + 1];
							$scope.customHeaders.splice(parseInt(currentIndex) + 1, 1, currentData);
							$scope.customHeaders.splice(currentIndex, 1, nextData);
						}
					}
	    		}
			}
			
	    	$scope.$watch("uitype", function(newValue, oldValue){
	    		if(newValue == null){
	    			return;
	    		}
	    		if(newValue != null && newValue != ""){
	    			if($scope.data.edittype.data.uitype != newValue){//同一个列表更改控件定义类型，需要重新初始化$scope.data.edittype.data
	    				$scope.data.edittype.data = {};
	    			}
	    			$scope.loadComponent(newValue);
	    		} else {
	    			cui("#uitype_"+$scope.ngComponentDefineId+"_"+$scope.parentObject.id).setReadonly($scope.data.bindName != '' ? false : true);
	    			if(_.size($scope.data) > 0 && $scope.data.edittype != null){
		    			$scope.data.edittype.data = {};
	    			}
	    			$('#properties-div-'+$scope.ngComponentDefineId+'-'+$scope.parentObject.id).html("");
	    		}
	    	}, false);
	    	
	    	$scope.$watch("data.bindName", function(newValue, oldValue){
	    		if(newValue == null){
	    			return;
	    		}
	    		if(newValue == null || newValue == ''){
	    			if($scope.uitype != ''){
		    			$scope.uitype = '';
	    			} else {
	    				cui("#uitype_"+$scope.ngComponentDefineId+"_"+$scope.parentObject.id).setReadonly($scope.data.bindName != '' ? false : true);
	    			}
	    		} else if(cui("#uitype_"+$scope.ngComponentDefineId+"_"+$scope.parentObject.id).readonly){
	    			cui("#uitype_"+$scope.ngComponentDefineId+"_"+$scope.parentObject.id).setReadonly(false);
	    		}
	    	}, false);
	    	
	    	//通过监控控制控件类型下拉框状态
	    	$scope.$watch("batchEdittype", function(newValue, oldValue){
	    		if(newValue == null){
	    			return;
	    		}
	    		var len  = newValue.length;
	    		if(len > 0){
		    		var hasSameType = $scope.hasSameType();
		    		cui("#uitype_"+$scope.ngComponentDefineId+"_"+$scope.parentObject.id).setReadonly(!hasSameType);
	    		} else {
	    			$scope.hasBatchEdittypeOperation = false;
	    		}
	    	}); 
	    	
	    	//批量修改
			$scope.batchUpdate=function(){
				cui.confirm('您确定要执行批量修改操作？',{
					onYes:function(){
						var commonProperyVo = {};
						if($scope.uitype != ''){
			    			for(var key in $scope.batchEditProperties){
			    				if($scope.batchEditProperties[key] === true){
				    				commonProperyVo[key] = $scope.data.edittype.data[key];
			    				}
				    		}
			    			commonProperyVo.uitype = $scope.uitype;
						} 
						for(var i in $scope.batchEdittype){
			    			$scope.batchEdittype[i].edittype.data = jQuery.extend(true, $scope.uitype == $scope.batchEdittype[i].edittype.data.uitype ? $scope.batchEdittype[i].edittype.data : {}, commonProperyVo);
			    			$scope.batchEdittype[i].edittype.propertiesType = $scope.data.edittype.propertiesType;
			    		}
			    		cui.message('批量修改成功！', 'success');
			    		$scope.customHeaderTdClick($scope.customHeaders[0]);
						$scope.$digest();
					}
				});
			}
	    	
			//点击属性控件，联动选中对应的复选框
	    	$scope.clickEvent=function(ename){
	    		$scope.batchEditProperties[ename] = true;
	    	}
	    	
	    	//切换Tab标签
	    	$scope.showPanel=function(msg){
	    		$scope.active=msg;
	    	}
	    	
	    	//设置级别
	    	$scope.setLevel=function(){
	    		var level = $scope.level;
	    		for(var i in $scope.customHeaders){
					if($scope.customHeaders[i].check){
		    			$scope.customHeaders[i].level = parseInt(level);
		    			var indent = '';
		    			for(var j=1; j<level; j++){
		    				indent += '~';
		    			}
		    			$scope.customHeaders[i].indent = indent;
					}
	    		}
	    	}
	    	
	    	//升级
	    	$scope.upGrade=function(){
	    		for(var i in $scope.customHeaders){
	    			if($scope.customHeaders[i].check && $scope.customHeaders[i].level > 1){
		    			$scope.customHeaders[i].level--;
		    			$scope.customHeaders[i].indent = $scope.customHeaders[i].indent.substr(0, $scope.customHeaders[i].indent.length-1);
					}
	    		}
	    	}
	    	
	    	//降级
			$scope.downGrade=function(){
				for(var i in $scope.customHeaders){
					if($scope.customHeaders[i].check){
		    			$scope.customHeaders[i].level++;
		    			$scope.customHeaders[i].indent += '~';
					}
	    		}
	    	}
        },
        link: function (scope, element, attrs, controller) {
        	window["customColumnButtonGroup2EditGrid_"+scope.ngModel] = _.bind(customColumnButtonGroup2EditGrid, {id : scope});
			var jct = new jCT($('#editableGridCodeArea').html());
			jct.scope = scope;
			var html = jct.Build().GetView();
			element.html(html).show();
	        $compile(element.contents())(scope);
	    	cui("#selectSubEntity_"+scope.ngComponentDefineId+"_"+scope.parentObject.id).setDatasource(scope.datasource4SubEntity);
	    	if(scope.attributes.length == 0){//初始化时
	    		scope.attributes = getAttributes(scope.entityId);
	    	}
	        comtop.UI.scan();
			scope.parentObject.scope = scope;
        }
    };
}]);

//编辑网格定义控件类型指令
CUI2AngularJS.directive('cuiEdittype', ['$interpolate','$compile', function ($interpolate,$compile) {
	return {
    	restrict: 'A',
        transclude: true,
        require : '^?cuiEditGridCodeArea',
        scope: {
        	ngComponentDefineId:'@',//scope.root[ngComponentDefineId]
        	parentObject:'='//scope.root[ngComponentDefineId].scope.components---vo
        },
        controller: function($scope) {
        	$scope.edittype = {data:$scope.parentObject.scope.data.edittype.data};
	    	$scope.batchEditProperties = $scope.parentObject.scope.batchEditProperties;
	    	$scope.component = $scope.parentObject.scope.component;
	    	
	    	//切换展现非常用属性开关
	    	$scope.switchHideArea=function(flag){
	    		$scope[flag] = !$scope[flag];
	    	}
	    	
	    	//获取值相同的属性
	    	$scope.commonPropertyValue=function(){
		    	var commonPropertyVo = {};
		    	var properties = _.remove($scope.component.properties, function(n) {
					  	return n.ename != 'databind';
					});
				$scope.component.properties = properties;
		    	for(var i in properties){
		    		var key = properties[i].propertyEditorUI.script.name;
		    		var compareValue = $scope.parentObject.scope.batchEdittype[0].edittype.data != null ? $scope.parentObject.scope.batchEdittype[0].edittype.data[key] : '';
		    		for(var j=1, len=$scope.parentObject.scope.batchEdittype.length; j < len; j++){
		    			if(compareValue != $scope.parentObject.scope.batchEdittype[j].edittype.data[key]){
		    				compareValue = null;
		    				break;
		    			}
		    		}
		    		if(compareValue != null){
		    			commonPropertyVo[key] = compareValue;
		    		}
		    	}
	    		return commonPropertyVo;
	    	}
        },
        link: function (scope, element, attrs, cuiColumnsCtrl) {
	    	var properties = scope.component.properties;
		    var propertiesType = new HashMap();
	    	for(var i in properties){
				properties[i].propertyEditorUI.script = eval("("+properties[i].propertyEditorUI.script+")");
				var key = properties[i].propertyEditorUI.script.name;
				propertiesType.put(key, properties[i].type);
				if(key === 'uitype'){
					scope.edittype.data[key] = properties[i].defaultValue;
				} else if(scope.edittype.data[key] != null){
					var value = scope.edittype.data[key];
					if(properties[i].type === 'Json' && typeof value === 'object'){
						scope.edittype.data[key] = JSON.stringify(value);
					} else {
						scope.edittype.data[key] = value + '';
					}
				}
			}
	    	
	    	scope.parentObject.scope.data.edittype.propertiesType = propertiesType;
	    	if(scope.parentObject.scope.batchEdittype.length > 0){
	    		scope.batchEditProperties = scope.parentObject.scope.batchEditProperties;
	    		scope.batchEditProperties.uitype = true;
	    		scope.edittype.data = jQuery.extend(true, scope.edittype.data, scope.commonPropertyValue());
	    	}
	    	
	    	var jct = new jCT($("#"+(scope.parentObject.scope.hasBatchEdittypeOperation ? 'propertiesBatchEditTmpl':'propertiesEditTmpl')).html());
			jct.scope = scope;
			element.html(jct.Build().GetView()).show();
			
			//给绑定了ng-model的控件添加标记，主要回调赋值做标记
			var spanDom = $("#properties-div-"+scope.ngComponentDefineId+'-'+scope.parentObject.id).find("span");
			for(var i=0,len=spanDom.length; i<len; i++){
				$(spanDom[i]).attr("componentDefineId", scope.ngComponentDefineId).attr("subComponentDefineId", scope.parentObject.id).attr("rowId", scope.parentObject.scope.data.customHeaderId).attr("subComponentDefineType", scope.parentObject.uitype);
			}
	        $compile(element.contents())(scope);
	        scope.parentObject.scope.embeddedDirectiveScope = scope;
	        if((scope.edittype.data.uitype === 'ChooseUser' || scope.edittype.data.uitype === 'ChooseOrg') 
	    			&& scope.edittype.data.chooseMode != null){//针对值不在pulldown数据源内的值处理
	    		setTimeout(function () {
		    		var propertyVo = _.find(scope.component.properties,{ename: 'chooseMode'});
	    			var id = propertyVo.propertyEditorUI.script.id;
	    			if(cui("#"+id).selectData == null){
	    				cui("#"+id).$text[0].value = scope.edittype.data.chooseMode;
	    				cui("#"+id).setValue(scope.edittype.data.chooseMode);
	    			}
	    		}, 0);
	    	}
        }
	};
}]);

//列表区域指令
CUI2AngularJS.directive('cuiListCodeArea', ['$interpolate','$compile', function ($interpolate,$compile) {
    return {
    	restrict: 'A',
        transclude: true,
        scope: {
        	ngObject:'=' //scope.root[xxx]对象，xxx表示控件id
        },
        controller: function($scope) {
        	//数据模型属性（左侧表格数据源）
			$scope.attributes　= $scope.ngObject.scope.attributes;
	    	$scope.attributesCheckAll　=　false;
	    	$scope.customHeadersCheckAll　=　false;
	    	//列头属性（右侧表格数据源）
	    	$scope.customHeaders　=　$scope.ngObject.scope.customHeaders;
	    	//被选中的列头属性对象
	    	$scope.data　=　$scope.ngObject.scope.data;
	    	$scope.component　=　{};
	    	$scope.hasHideNotCommonProperties = true;
	    	//默认显示属性tab标签
	    	$scope.active = 'property';
	    	$scope.entityId = $scope.ngObject.scope.entityId;
	    	$scope.entityAlias = $scope.ngObject.scope.entityAlias;
	    	$scope.selectrows = $scope.ngObject.scope.selectrows;
	    	$scope.label = $scope.ngObject.scope.label;
	    	
	    	$scope.$watch("entityAlias", function(newValue, oldValue){
	    		if(newValue != oldValue){
	    			var data = cui("#selectEntity_"+$scope.ngObject.metaComponentDefine.id).getData();//实体下拉框可选状态
	    			$scope.entityId = data != null ? data.entityVO.modelId : $scope.entityId;
	    			$scope.reloadData();
	    		} 
	    	}, false);
        	
        	// 重新初始化table数据
        	$scope.reloadData=function(){
        		$scope.attributes = [];
    			$scope.customHeaders = [];
    			if($scope.entityId != ''){
    				$scope.attributes = getAttributes($scope.entityId);
    			} else {
    				$scope.data = {};
    			}
        	}
	    	
	    	$scope.saveCustomHeaderBefore=function(customHeader){
	    		for(var j in customHeader){
	    			delete customHeader[j].customHeaderId;
	    			delete customHeader[j].check;
	    			delete customHeader[j].level;
	    			delete customHeader[j].indent;
	    			delete customHeader[j].rowNo;
	    			var modeVo = customHeader[j];
	    			for(var key in modeVo){
	    				if((modeVo[key] == null || modeVo[key] == '' || modeVo[key] === 'null') && key != 'name'){
	    					delete modeVo[key];
	    				}
	    			}
	    		}
	    	}
	    	
	    	//校验
	    	$scope.validate=function(){
	    		var resData = {result: "success"};
	    		if($scope.customHeaders.length > 0){
					var hasMultiTableHeader = _.pluck(_.sortBy($scope.customHeaders, 'level'), 'level').reverse()[0] > 1 ? true : false;
					if(hasMultiTableHeader){//多表头
						var customHeaders = getMultiLineHeaders($scope.customHeaders);
						if(customHeaders.length == 0){
							 resData.result = "error";
							 resData.message = "网格多表头结构设置有误。";
						} 
					} 
				} 
	    		return resData;
	    	}
	    	
	    	//保存
			$scope.saveCustomHeader=function(){
				var hasMultiTableHeader = _.pluck(_.sortBy($scope.customHeaders, 'level'), 'level').reverse()[0] > 1 ? true : false;
				var customHeaders = [];
				if(hasMultiTableHeader){//多表头
					customHeaders = getMultiLineHeaders($scope.customHeaders);
					if(customHeaders.length > 0){
						var addSelectrowsColumnVo = {};
						if($scope.selectrows == null || $scope.selectrows == '' || $scope.selectrows == 'multi'){
							addSelectrowsColumnVo = {rowspan:customHeaders.length,width:60,type:'checkbox'};
							customHeaders[0] = _.union([addSelectrowsColumnVo], customHeaders[0]);
						} else if($scope.selectrows == 'single'){
							addSelectrowsColumnVo = {rowspan:customHeaders.length,width:60,name:''};
							customHeaders[0] = _.union([addSelectrowsColumnVo], customHeaders[0]);
						} 
						for(var i in customHeaders){
							$scope.saveCustomHeaderBefore(customHeaders[i]);
						}
					} else {
						//cui.error("多表头结构设置有误。"); 
						return;
					}
				} else {
					customHeaders = jQuery.extend(true, [], $scope.customHeaders);
					$scope.saveCustomHeaderBefore(customHeaders);
				}
				
				var customHeadersToExtras = jQuery.extend(true, [], $scope.customHeaders);
				for(var i=0, len=customHeadersToExtras.length; i<len; i++){//编辑时，默认选中第一项
					customHeadersToExtras[i].check = i == 0 ? true : false;
				}
				var attributeVo = _.find($scope.attributes, {primaryKey: true});
				var primaryKey = attributeVo != null ? attributeVo.engName : '';
				var options = {primarykey: primaryKey, columns: JSON.stringify(customHeaders), selectrows: $scope.selectrows !='' ? $scope.selectrows : null, extras: JSON.stringify({entityId: $scope.entityId, tableHeader: customHeaders.length > 0 ? JSON.stringify(customHeadersToExtras) : '[]'})};
				var metaComponentDefine = $scope.ngObject.metaComponentDefine;
				var areaId = metaComponentDefine.uiConfig.componentInfo != null ? metaComponentDefine.uiConfig.componentInfo.listCodeArea[0].areaId : null;
				return {id: metaComponentDefine.id, areaId: areaId, area: metaComponentDefine.uiType, entityId: $scope.entityId, entityAlias: $scope.entityAlias, options:options};
			}
			
	    	//显示隐藏数据
	    	$scope.showAttributeVO=function(engNames){
	    		for(var i=0, len=engNames.length; i<len; i++){
	    			for(var j=0, len2=$scope.attributes.length; j<len2; j++){
	    				if($scope.attributes[j].engName == engNames[i]){
	    					$scope.attributes[j].isFilter = false;
	    					break;
	    				}
	    			}
	    		}
	    		$scope.checkBoxCheckAttribute($scope.attributes, false);
	    		$scope.attributesCheckAll=false;
	    	}
	    	
	    	//新增列
	    	$scope.addCustomHeader=function(customHeaderVo){
	    		$scope.data = customHeaderVo;
	    		$scope.customHeaders.push(customHeaderVo);
	    		for(var i in $scope.customHeaders){
    				$scope.customHeaders[i].check = false;
	    		}
	    		customHeaderVo.check = true;
	    		$scope.customHeadersCheckAll　=　false;
	    	}
	    	
	     	//删除自定义表头
	    	$scope.deleteCustomHeader=function(){
               	var newArr=[];
               	var delCustomHeaderIds=[];
                for(var i=0, len=$scope.customHeaders.length; i<len; i++){
                    if(typeof($scope.customHeaders[i].check) == 'undefined' || !$scope.customHeaders[i].check){
                    	newArr.push($scope.customHeaders[i]);
                    } else {
                    	delCustomHeaderIds.push($scope.customHeaders[i].customHeaderId);
                    }
                }
                $scope.customHeaders = newArr;
                $scope.showAttributeVO(delCustomHeaderIds);
                $scope.customHeadersCheckAll = false;
	    	}
	    	
	    	//监控全选checkbox，如果选择则联动选中列表所有数据
	    	$scope.allCheckBoxCheckAttribute=function(ar,isCheck){
	    		if(ar!=null){
	    			for(var i=0;i<ar.length;i++){
		    			if(isCheck){
		    				ar[i].check=true;
		    				for(var i=0, len=ar.length; i<len; i++){
		    					if(!ar[i].isFilter){
		    						var newCustomHeader = $scope.createCustomHeaderVo4Attribute(ar[i])
				    	    		$scope.addCustomHeader(newCustomHeader);
		    					}
		                    }
			    		}else{
			    			ar[i].check=false;
			    		}
		    		}	
	    		}
	    	}
	    	
	    	//监控选中，如果列表所有行都被选中则选中allCheckBox
	    	$scope.checkBoxCheckAttribute=function(ar,allCheckBox){
	    		if(ar!=null){
	    			var checkCount=0;
	    			var allCount=0;
		    		for(var i=0;i<ar.length;i++){
		    			if(ar[i].check){
		    				checkCount++;
		    				var newCustomHeader = $scope.createCustomHeaderVo4Attribute(ar[i])
		    	    		$scope.addCustomHeader(newCustomHeader);
			    		}
		    			
		    			if(!ar[i].isFilter){
		    				allCount++;
		    			}
		    		}
		    		if(checkCount==allCount && checkCount!=0){
		    			eval("$scope."+allCheckBox+"=true");
		    		}else{
		    			eval("$scope."+allCheckBox+"=false");
		    		}
	    		}
	    	}
	    	
	    	//选中属性(数据模型属性)
	    	$scope.gridAttributeTdClick=function(attributeVo){
	    		var newCustomHeader = $scope.createCustomHeaderVo4Attribute(attributeVo)
	    		$scope.addCustomHeader(newCustomHeader);
		    }
	    	
	    	//创建customHeaderVo对象
	    	$scope.createCustomHeaderVo4Attribute=function(attributeVo){
	    		var newCustomHeader = {customHeaderId: attributeVo.engName, name: attributeVo.chName, bindName: attributeVo.engName, level: 1, indent:'', format: (attributeVo.attributeType.type === 'java.sql.Date' || attributeVo.attributeType.type === 'java.sql.Timestamp' ? 'yyyy-MM-dd' : '')};
	    		attributeVo.isFilter=true;
	    		attributeVo.check=false;
	    		if(attributeVo.attributeType.source === 'dataDictionary' ||  attributeVo.attributeType.source === 'enumType'){
	    			newCustomHeader.render = 'actionlibrary.bestPracticeAction.gridAction.action.gridDicRender';
	    		}
	    		return newCustomHeader;
	    	}
	    	
	    	//选中(定义表头表格)
	    	$scope.customHeaderTdClick=function(customHeaderVo){
	    		for(var i in $scope.customHeaders){
    				$scope.customHeaders[i].check = false;
	    		}
	    		customHeaderVo.check = true;
	    		$scope.data = customHeaderVo;
	    		$scope.level = customHeaderVo.level;
		    }
	    	
	    	//监控全选checkbox，如果选择则联动选中列表所有数据
	    	$scope.allCheckBoxCheckCustomHeader=function(ar,isCheck){
	    		if(ar!=null){
	    			for(var i=0;i<ar.length;i++){
		    			if(isCheck){
		    				ar[i].check=true;
			    		}else{
			    			ar[i].check=false;
			    		}
		    		}	
	    		}
	    		$scope.data={};
	    		$scope.level = '';
	    	}
	    	
	    	//监控选中，如果列表所有行都被选中则选中allCheckBox
	    	$scope.checkBoxCheckCustomHeader=function(ar,allCheckBox){
	    		if(ar!=null){
	    			var checkCount=0;
	    			var allCount=0;
		    		for(var i=0;i<ar.length;i++){
		    			if(ar[i].check){
		    				checkCount++;
		    				$scope.data = ar[i];
			    		}
		    		}
		    		if(checkCount==allCount && checkCount!=0){
		    			eval("$scope."+allCheckBox+"=true");
		    		}else{
		    			eval("$scope."+allCheckBox+"=false");
		    		}
	    		}
	    		if(checkCount > 1){
	    			$scope.data={};
	    		} 
	    		$scope.level = '';
	    	}
	    	
	    	//上移
			$scope.up=function(){
	    		if($scope.customHeaders.length > 0 && $scope.customHeaders[0].check){
	    			return;
	    		}
	    		var mobileHeaders = [];
	    		for(var i in $scope.customHeaders){
	    			if($scope.customHeaders[i].check){
	    				mobileHeaders.push($scope.customHeaders[i]);
	    			}
	    		}
	    		for(var i in mobileHeaders){
	    			var currentData = mobileHeaders[i];
					if(currentData.customHeaderId != null){
						var currentIndex = 0;
						var frontData = {};
						for(var i in $scope.customHeaders){
							if($scope.customHeaders[i].customHeaderId == currentData.customHeaderId){
								currentIndex = i;
								break;
							}
						}
						if(currentIndex > 0){
							frontData = $scope.customHeaders[currentIndex - 1];
							$scope.customHeaders.splice(currentIndex - 1, 2, currentData);
							$scope.customHeaders.splice(currentIndex, 0, frontData);
						} 
					}
	    		}
			}
			
			//下移
			$scope.down=function(){
				var len = $scope.customHeaders.length;
	    		if(len > 0 && $scope.customHeaders[len-1].check){
	    			return;
	    		}
	    		var mobileHeaders = [];
	    		for(var i in $scope.customHeaders){
	    			if($scope.customHeaders[i].check){
	    				mobileHeaders.push($scope.customHeaders[i]);
	    			}
	    		}
	    		mobileHeaders = mobileHeaders.reverse();
	    		for(var i in mobileHeaders){
	    			var currentData = mobileHeaders[i];
					if(currentData.customHeaderId != null){
						var currentIndex = 0;
						var nextData = {};
						for(var i in $scope.customHeaders){
							if($scope.customHeaders[i].customHeaderId == currentData.customHeaderId){
								currentIndex = i;
								break;
							}
						}
						if(currentIndex < len-1){
							nextData = $scope.customHeaders[parseInt(currentIndex) + 1];
							$scope.customHeaders.splice(parseInt(currentIndex) + 1, 1, currentData);
							$scope.customHeaders.splice(currentIndex, 1, nextData);
						}
					}
	    		}
			}
			
			//切换展现非常用属性开关
	    	$scope.switchHideArea=function(flag){
	    		$scope[flag] = !$scope[flag];
	    	}
			
	    	//切换Tab标签
	    	$scope.showPanel=function(msg){
	    		$scope.active=msg;
	    	}
	    	
	    	//设置级别
	    	$scope.setLevel=function(){
	    		var level = $scope.level;
	    		for(var i in $scope.customHeaders){
					if($scope.customHeaders[i].check){
		    			$scope.customHeaders[i].level = parseInt(level);
		    			var indent = '';
		    			for(var j=1; j<level; j++){
		    				indent += '~';
		    			}
		    			$scope.customHeaders[i].indent = indent;
					}
	    		}
	    	}
	    	
	    	//升级
	    	$scope.upGrade=function(){
	    		for(var i in $scope.customHeaders){
	    			if($scope.customHeaders[i].check && $scope.customHeaders[i].level > 1){
		    			$scope.customHeaders[i].level--;
		    			$scope.customHeaders[i].indent = $scope.customHeaders[i].indent.substr(0, $scope.customHeaders[i].indent.length-1);
					}
	    		}
	    	}
	    	
	    	//降级
			$scope.downGrade=function(){
				for(var i in $scope.customHeaders){
					if($scope.customHeaders[i].check){
		    			$scope.customHeaders[i].level++;
		    			$scope.customHeaders[i].indent += '~';
					}
	    		}
	    	}

			$scope.clearData=function(){
	    		$scope.attributes = [];
	    		$scope.customHeaders = [];
	    		$scope.data = {};
	    		$scope.entityId = '';
	    	};
        },
        link: function (scope, element, attrs, controller) {
        	//window["entitySelectedOnChangeEvent_"+scope.ngObject.metaComponentDefine.id] = _.bind(entitySelectedOnChangeEvent, {id : scope});
        	window["customColumnButtonGroup2Grid_"+scope.ngObject.metaComponentDefine.id] = _.bind(customColumnButtonGroup2Grid, {id : scope});
        	var jct = new jCT($('#listCodeArea').html());
			jct.ngObject = scope.ngObject;
			jct.label = scope.label;
			var html = jct.Build().GetView();
			element.html(html).show();
	        $compile(element.contents())(scope);
	        //setTimeout(function(){ cui("#selectEntity_"+scope.ngObject.metaComponentDefine.id).setValue(scope.entityAlias); });
	        comtop.UI.scan();
			scope.ngObject.scope = scope;
        }
    };
}]);

//控件属性编辑器
CUI2AngularJS.directive('cuiProperty', ['$interpolate','$compile', function ($interpolate,$compile) {
    return {
    	restrict: 'A',
        transclude: true,
        scope: {
        	ngModel: '=',//components数据集或componentVo对象
        	ngRowId:'@',//componentVo对象下的id
        	ngComponentDefineId:'@',//当前控件对于的id
        	ngSubComponentDefineId:'@',//子区域控件id
        	ngSubComponentDefineType:'@'//控件类型
        },
        controller: function($scope) {
        	$scope.parentObj = {};
        	if($scope.ngRowId != null && $scope.ngRowId != ''){
        		$scope.parentObj = _.find($scope.ngModel, {'id': $scope.ngRowId});
        	} else {
        		$scope.parentObj = $scope.ngModel;
        		$scope.ngRowId = $scope.ngModel.id != null ? $scope.ngModel.id : '';
        	}
        	
        	$scope.isShow = false;
        	$scope.component = {};
        	$scope.data = {};
        	//加载控件属性
	    	$scope.loadComponent=function(modelId){
	    		if(modelId != null && modelId != ''){
	    			$scope.component = getComponentByModelId(modelId, window.toolsdata);
	    			//常用属性
    				$scope.component.commonProperties = [];
    				//非常用属性
    				$scope.component.notCommonProperties = [];
    				var properties = $scope.component.properties;
    				for(var i in properties){
    					if(properties[i].commonAttr){
    						$scope.component.commonProperties.push(properties[i]);
    					} else {
    						$scope.component.notCommonProperties.push(properties[i]);
    					}
    					properties[i].propertyEditorUI.script = eval("("+properties[i].propertyEditorUI.script+")");
    					var key = properties[i].propertyEditorUI.script.name;
    					$scope.data[key] = $scope.parentObj.options[key];//控件类型切换，过滤非自身属性
    				}
    				//原控件类型如果是人员（组织）控件，databind数据值需重新赋值
    				if($scope.data.uitype === 'ChooseUser' || $scope.data.uitype === 'ChooseOrg'){
    					var databind = $scope.data.databind != null ? $scope.data.databind : '';
    					var reg = /ChooseUser|ChooseOrg$/;
    					if(reg.test(databind)){
    						$scope.data.databind = databind.substr(0, databind.lastIndexOf('ChooseUser') + databind.lastIndexOf('ChooseOrg') + 1);
    					}
    				}
    				$scope.data.uitype = _.find(properties, {ename: 'uitype'}).defaultValue;
    				if($scope.data.uitype === 'RadioGroup'){
						$scope.data.name = $scope.parentObj.id;
					}
	    		}
	    	}
        	
	    	$scope.$watch("data", function(newValue, oldValue){
	    		if(_.size(newValue) > 0){
		    		$scope.parentObj.options = newValue;
	    		}
	    	}, true);
        },
        link: function (scope, element, attrs, controller) {
        	scope.loadComponent(scope.parentObj.componentModelId);
        	var uitype = scope.data.uitype;
        	if(uitype === 'ChooseUser' || uitype === 'ChooseOrg' || uitype === 'RadioGroup' 
        		|| uitype === 'CheckboxGroup' || uitype === 'PullDown'){
        		if(scope.data.validate != null && scope.data.validate != ''){
        			var validate = _.find(JSON.parse(scope.data.validate), {type: 'required'});
        			scope.data.validate = validate != null ? JSON.stringify([validate]) : '';
        		}
        		if(scope.data.databind != null && scope.data.databind !='' && 
        				(uitype === 'ChooseUser' || uitype === 'ChooseOrg')){
        			scope.data.idName = scope.data.idName != null && scope.data.idName != '' ? scope.data.idName : scope.data.databind;
        			scope.data.databind = scope.data.idName + scope.data.uitype;
        		}
        	}
        	var jct = new jCT($('#editPropertiesCodeArea').html());
			jct.scope = scope;
			var html = jct.Build().GetView();
			element.html(html).show();
			//给绑定了ng-model的控件添加标记，主要回调赋值做标记
			var spanDom = $("#properties_"+scope.ngComponentDefineId+"_"+scope.ngSubComponentDefineId+"_"+scope.ngRowId).find("span");
			for(var i=0,len=spanDom.length; i<len; i++){
				$(spanDom[i]).attr("componentDefineId", scope.ngComponentDefineId).attr("subComponentDefineId", scope.ngSubComponentDefineId).attr("rowId", scope.ngRowId).attr("subComponentDefineType", scope.ngSubComponentDefineType);
			}
	        $compile(element.contents())(scope);
	        comtop.UI.scan();
	        scope.parentObj.scope = scope;
	        if((scope.data.uitype === 'ChooseUser' || scope.data.uitype === 'ChooseOrg') 
	        		&& scope.data.chooseMode != null){//针对值不在pulldown数据源内的值处理
	        	setTimeout(function () {
	        		var propertyVo = _.find(scope.component.properties,{ename: 'chooseMode'});
	        		var id = propertyVo.propertyEditorUI.script.id;
	        		if(cui("#"+id).selectData == null){
	        			cui("#"+id).$text[0].value = scope.data.chooseMode;
	        			cui("#"+id).setValue(scope.data.chooseMode);
	        		}
	        	}, 0);
	        }
        }
    }
}]);

//查询区域控件指令
CUI2AngularJS.directive('cuiQueryCodeArea', ['$interpolate','$compile', function ($interpolate,$compile) {
    return {
    	restrict: 'A',
        transclude: true,
        scope: {
        	ngObject:'=' //scope.root[xxx]对象，xxx表示控件id
        },
        controller: function($scope) {
        	$scope.entityId = $scope.ngObject.scope.entityId;
        	$scope.entityAlias = $scope.ngObject.scope.entityAlias;
        	$scope.components = $scope.ngObject.scope.components;
        	
        	$scope.$watch("entityAlias", function(newValue, oldValue){
	    		if(newValue != oldValue){
	    			var data = cui("#selectEntity_"+$scope.ngObject.metaComponentDefine.id).getData();//实体下拉框可选状态
	    			$scope.entityId = data != null ? data.entityVO.modelId : $scope.entityId;
	    			$scope.reloadData();
	    		} 
	    	}, false);
        	
        	// 重新初始化table数据
        	$scope.reloadData=function(){
        		$scope.attributes = getAttributes($scope.entityId);
    			for(var i in $scope.components){
    				var componentVo = $scope.components[i];
    				componentVo.scope.entityId = $scope.entityId;
    				componentVo.scope.entityAlias = $scope.entityAlias;
					componentVo.scope.attributes = jQuery.extend(true, [], $scope.attributes);
					componentVo.scope.components = [];
    			}
    	    }
        	
        	//保存
        	$scope.save=function(){
    	    	var components = [];
    	    	var tempData = {queryFixedCodeArea:[], queryMoreCodeArea:[]};
    	    	_.forEach($scope.components, function(componentVo) {
    	    		var data = componentVo.scope.save();
    	    		tempData[componentVo.uitype].push({id: componentVo.id, areaId: componentVo.areaId, area: componentVo.uitype, col: data.col, rowList: data.components});
    	    	});
        		return {id: $scope.ngObject.metaComponentDefine.id, entityAlias: $scope.entityAlias, entityId: $scope.entityId, fixedQueryAreaList: tempData.queryFixedCodeArea, moreQueryAreaList: tempData.queryMoreCodeArea};
    	    }
        	
        	$scope.initEmbeddedDirectiveScope=function(flag, entityId, attributes){
        		$scope.ngObject[flag].scope.attributes = attributes;
    			$scope.ngObject[flag].scope.components = [];
    			$scope.ngObject[flag].scope.data = {};
    			$scope.ngObject[flag].scope.entityId = entityId;
        	}
        	
        	$scope.clearData=function(){
        		$scope.entityId = '';
        	}
        },
        link: function (scope, element, attrs, controller) {
        	var jct = new jCT($('#queryCodeArea').html());
			jct.ngObject = scope.ngObject;
			var html = jct.Build().GetView();
			element.html(html).show();
	        $compile(element.contents())(scope);
	        scope.ngObject.scope = scope;
        }
    }
}]);

//表单区域指令
CUI2AngularJS.directive('cuiFormArea', ['$interpolate','$compile', function ($interpolate,$compile) {
    return {
    	restrict: 'A',
        transclude: true,
        scope: {
        	ngComponentDefineId:'@',//scope.root[ngComponentDefineId]
        	parentObject:'='//scope.root[ngModel].scope.components---vo
        },
        controller: function($scope) {
        	//数据模型属性（左侧表格数据源）
			$scope.attributes　=　$scope.parentObject.scope.attributes != null ? $scope.parentObject.scope.attributes : [];
	    	$scope.attributesCheckAll　=　false;
	    	$scope.componentsCheckAll　=　false;
	    	$scope.col = $scope.parentObject.scope.col != null ? $scope.parentObject.scope.col : 2;
	    	$scope.components = $scope.parentObject.scope.components != null ? $scope.parentObject.scope.components : [];
	    	$scope.entityId = $scope.parentObject.scope.entityId != null ? $scope.parentObject.scope.entityId : '';
	    	$scope.entityAlias = $scope.parentObject.scope.entityAlias != null ? $scope.parentObject.scope.entityAlias : '';
	    	$scope.label = $scope.parentObject.scope.label;
	    	$scope.dataToColPulldown = [{id:'1', text:'1列'}];
	    	$scope.flag = true;
	    	$scope.clearData=function(){
	    		$scope.attributes = [];
	    		$scope.components = [];
	    	};
	    	
	    	$scope.$watch("col", function(newValue, oldValue){
	    		$scope.dataToColPulldown = [];
	    		for(var i=1, len = newValue != null ? newValue : 1; i<=newValue; i++){
	    			$scope.dataToColPulldown.push({id:i+'', text:i+'列'});
	    		}
	    		if(newValue != oldValue){
	    			var pulldowns = $("span[id^="+$scope.ngComponentDefineId+"_"+$scope.parentObject.id+"_colspan]");
	    			_.forEach(pulldowns, function(node){
	    				cui(node).setDatasource($scope.dataToColPulldown);
	    				cui(node).setValue("1");
	    			});
	    		}
	    		window["colPulldown_"+$scope.ngComponentDefineId+"_"+$scope.parentObject.id] = _.bind(colPulldown, {data : $scope.dataToColPulldown});
	    	}, false);
	    	
	    	//保存
	    	$scope.save=function(){
	    		var data = {col: $scope.col, components:[]};
	    		if($scope.components.length > 0){
	    			data.entityId = $scope.entityId;
	    			data.components = [];
	    			_.forEach($scope.components, function(chr){
	    				var node = getComponentNodeData(chr.componentModelId);
	    				deleteNullAndEmpty(chr.options);
	    				var options = transformDataType(chr.options, node.propertiesType);
	    				data.components.push({id:chr.id, cname: chr.cname, componentModelId: chr.componentModelId, colspan: chr.colspan, options:options});
	    			});
	    		} 
	    		return data;
	    	}
	    	
	 	    $scope.isShowCodeArea=function(){
	 	    	$scope.isShow = !$scope.isShow;
	    	}
	 	    
	    	//显示隐藏数据
	    	$scope.showAttributeVO=function(engNames){
	    		for(var i=0, len=engNames.length; i<len; i++){
	    			for(var j=0, len2=$scope.attributes.length; j<len2; j++){
	    				if($scope.attributes[j].engName == engNames[i]){
	    					$scope.attributes[j].isFilter = false;
	    					break;
	    				}
	    			}
	    		}
	    		$scope.checkBoxCheckAttribute($scope.attributes, false);
	    		$scope.attributesCheckAll=false;
	    	}
	    	
	    	//新增控件
	    	$scope.addComponent=function(componentVo){
	    		$scope.components.push(componentVo);
	    		for(var i in $scope.components){
    				$scope.components[i].check = false;
	    		}
	    		componentVo.check = true;
	    		$scope.componentsCheckAll　=　false;
	    	}
	    	
	     	//删除控件
	    	$scope.deleteComponet=function(){
               	var newArr=[];
               	var delComponentIds=[];
                for(var i=0, len=$scope.components.length; i<len; i++){
                    if(typeof($scope.components[i].check) == 'undefined' || !$scope.components[i].check){
                    	newArr.push($scope.components[i]);
                    } else {
                    	delComponentIds.push($scope.components[i].id);
                    }
                }
                $scope.components = newArr;
                $scope.showAttributeVO(delComponentIds);
                $scope.componentsCheckAll = false;
	    	}
	    	
	    	//监控全选checkbox，如果选择则联动选中列表所有数据
	    	$scope.allCheckBoxCheckAttribute=function(ar,isCheck){
	    		if(ar!=null && isCheck){
	    			for(var i=0, len=ar.length; i<len; i++){
	    				if(!ar[i].isFilter){
	    					var newComponentVo = $scope.createComponentVo4Attribute(ar[i], $scope.entityAlias);
				    		$scope.addComponent(newComponentVo);
    					}
		    		}	
	    		}
	    	}
	    	
	    	//监控选中，如果列表所有行都被选中则选中allCheckBox
	    	$scope.checkBoxCheckAttribute=function(ar,allCheckBox){
	    		if(ar!=null){
	    			var checkCount=0;
	    			var allCount=0;
		    		for(var i=0;i<ar.length;i++){
		    			if(ar[i].check){
		    				checkCount++;
			    			var newComponentVo = $scope.createComponentVo4Attribute(ar[i], $scope.entityAlias);
				    		$scope.addComponent(newComponentVo);
			    		}
		    			
		    			if(!ar[i].isFilter){
		    				allCount++;
		    			}
		    		}
		    		if(checkCount==allCount && checkCount!=0){
		    			eval("$scope."+allCheckBox+"=true");
		    		}else{
		    			eval("$scope."+allCheckBox+"=false");
		    		}
	    		}
	    	}
	    	
	    	//选中属性(数据模型属性)
	    	$scope.gridAttributeTdClick=function(attributeVo){
	    		var newComponentVo = $scope.createComponentVo4Attribute(attributeVo, $scope.entityAlias);
	    		$scope.addComponent(newComponentVo);
    		}
	    	
	    	//创建componentVo对象
	    	$scope.createComponentVo4Attribute=function(attributeVo, entityEngName){
	    		attributeVo.isFilter = true;
	    		attributeVo.check = false;
	    		var options = {databind: entityEngName+'.'+attributeVo.engName};
	    		var validate = generateValidate(attributeVo, '', $scope.parentObject.uitype);
				options.validate = validate.length > 0 ? JSON.stringify(validate) : '';
				var componentModelId = getComponentModelIdByAttType(attributeVo.attributeType.type);
				var sourceType = attributeVo.attributeType.source;
				if(sourceType === 'dataDictionary' || sourceType === 'enumType'){
					if(attributeVo.attributeType.type == 'boolean'){ //布尔类型，默认单选框控件
						componentModelId = 'uicomponent.common.component.radioGroup';
						options.name = attributeVo.engName;
					} else { //不是布尔类型，默认下拉框控件
						componentModelId = 'uicomponent.common.component.pullDown';
					}
					var keys = {dataDictionary: 'dictionary', enumType: 'enumdata'};
					options[keys[sourceType]] = attributeVo.attributeType.value;
				} 
				return {id:attributeVo.engName, cname: attributeVo.chName, componentModelId: componentModelId, colspan: 1, options:options, scope:{isShow:false}};
	    	}
	    	
	    	//监控全选checkbox，如果选择则联动选中列表所有数据
	    	$scope.allCheckBoxCheckComponent=function(ar,isCheck){
	    		if(ar!=null){
	    			for(var i=0;i<ar.length;i++){
		    			if(isCheck){
		    				ar[i].check=true;
			    		}else{
			    			ar[i].check=false;
			    		}
		    		}
	    		}
	    	}
	    	
	    	//监控选中，如果列表所有行都被选中则选中allCheckBox
	    	$scope.checkBoxCheckComponent=function(ar,allCheckBox){
	    		if(ar!=null){
	    			var checkCount=0;
	    			var allCount=0;
		    		for(var i=0;i<ar.length;i++){
		    			if(ar[i].check){
		    				checkCount++;
			    		}
		    			
		    			if(!ar[i].isFilter){
		    				allCount++;
		    			}
		    		}
		    		if(checkCount==allCount && checkCount!=0){
		    			eval("$scope."+allCheckBox+"=true");
		    		}else{
		    			eval("$scope."+allCheckBox+"=false");
		    		}
	    		}
	    	}
	    	
	    	//上移
			$scope.up=function(){
	    		if($scope.components.length > 0 && $scope.components[0].check){
	    			return;
	    		}
	    		var mobileComponents = [];
	    		for(var i in $scope.components){
	    			if($scope.components[i].check){
	    				mobileComponents.push($scope.components[i]);
	    			}
	    		}
	    		for(var i in mobileComponents){
	    			var currentData = mobileComponents[i];
					if(currentData.id != null){
						var currentIndex = 0;
						var frontData = {};
						for(var i in $scope.components){
							if($scope.components[i].id == currentData.id){
								currentIndex = i;
								break;
							}
						}
						if(currentIndex > 0){
							frontData = $scope.components[currentIndex - 1];
							$scope.components.splice(currentIndex - 1, 2, currentData);
							$scope.components.splice(currentIndex, 0, frontData);
						} 
					}
	    		}
			}
			
			//下移
			$scope.down=function(){
				var len = $scope.components.length;
	    		if(len > 0 && $scope.components[len-1].check){
	    			return;
	    		}
	    		var mobileComponents = [];
	    		for(var i in $scope.components){
	    			if($scope.components[i].check){
	    				mobileComponents.push($scope.components[i]);
	    			}
	    		}
	    		mobileComponents = mobileComponents.reverse();
	    		for(var i in mobileComponents){
	    			var currentData = mobileComponents[i];
					if(currentData.id != null){
						var currentIndex = 0;
						var nextData = {};
						for(var i in $scope.components){
							if($scope.components[i].id == currentData.id){
								currentIndex = i;
								break;
							}
						}
						if(currentIndex < len-1){
							nextData = $scope.components[parseInt(currentIndex) + 1];
							$scope.components.splice(parseInt(currentIndex) + 1, 1, currentData);
							$scope.components.splice(currentIndex, 1, nextData);
						}
					}
	    		}
			}
			
			//置顶
			$scope.setTop=function(){
	    		var selectedComponents = [];
	    		var notSelectedComponents = [];
	    		for(var i in $scope.components){
	    			if($scope.components[i].check){
	    				selectedComponents.push($scope.components[i]);
	    			} else {
	    				notSelectedComponents.push($scope.components[i]);
	    			}
	    		}
	    		$scope.components = _.union(selectedComponents, notSelectedComponents);
			}
			
			//置底
			$scope.setBottom=function(){
	    		var selectedComponents = [];
	    		var notSelectedComponents = [];
	    		for(var i in $scope.components){
	    			if($scope.components[i].check){
	    				selectedComponents.push($scope.components[i]);
	    			} else {
	    				notSelectedComponents.push($scope.components[i]);
	    			}
	    		}
	    		$scope.components = _.union(notSelectedComponents, selectedComponents);
			}
			
			//添加
			$scope.addBtn=function(){
				$scope.components.push({id: (new Date()).valueOf()+'', cname: "用户", componentModelId:'uicomponent.common.component.input', colspan:1, options:{width:'100px'}, scope:{isShow:false}});
			}
			
			//加载控件类型
			$scope.loadComponent=function(id, componentId){
				$("#"+id).html('<span cui_property ng-model="components" ng-row-id="'+componentId+'" ng-component-define-id="'+$scope.ngComponentDefineId+'" ng-sub-component-define-id="'+$scope.parentObject.id+'" ng-sub-component-define-type="'+$scope.parentObject.uitype+'"></span>');
				$compile($("#"+id).contents())($scope);
			}
        },
        link: function (scope, element, attrs, controller) {
			var jct = new jCT($('#formCodeArea').html());
			jct.scope = scope;
			var html = jct.Build().GetView();
			element.html(html).show();
			$compile(element.contents())(scope);
	        comtop.UI.scan();
			scope.parentObject.scope = scope;
        }
    };
}]);

