<%
/**********************************************************************
* GridTable属性
* 2015-05-07 诸焕辉  
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app='customGridThead'>
<head>
	<title>数据模型属性</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <top:link href="/cap/bm/dev/page/uilibrary/css/base.css"/>
    <top:link href="/cap/bm/req/prototype/design/uilibrary/css/grid.css"/>
    <style type="text/css">
    	
    </style>
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/jct/js/jct.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.extend.dictionary.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cip_common.js"></top:script>
	<top:script src="/cap/bm/dev/page/uilibrary/js/selectDataModel.js"></top:script>
	<top:script src="/cap/bm/common/lodash/js/lodash.js"></top:script>
	<top:script src="/cap/bm/dev/page/uilibrary/js/grid.js"></top:script>
	<top:script src="/cap/bm/req/prototype/design/uilibrary/js/grid.js"></top:script>
	<top:script src="/cap/bm/dev/page/uilibrary/js/component.js"></top:script>
	<top:script src="/cap/bm/common/JSPinyin/pinyin.js"></top:script>
	<top:script src="/cap/bm/common/base/js/jsformat.js"></top:script>
    <top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src="/cap/dwr/interface/ComponentFacade.js"></top:script>
	<top:script src="/cap/dwr/interface/ActionDefineFacade.js"></top:script>
	<top:script src="/cap/dwr/interface/ReqFunctionSubitemAction.js"></top:script>
</head>
<body ng-controller="customGridTheadCtrl" data-ng-init="ready()">
	<div class="cap-page">
		<div class="header" style="position: absolute;right: 10px; top: 5px; z-index: 1000">
			<span cui_button id="saveButton" ng-click="saveCustomHeader()" label="确定"></span>
		</div>
		<ul class="cap-tab">
			<li ng-class="{'construction':'active'}[table_active]" ng-click="showPanel('construction', 'table_active')">表头结构</li>
			<li ng-class="{'datasource':'active'}[table_active]" ng-click="showPanel('datasource', 'table_active')" ng-show="customHeaders.length > 0">列表数据</li>
		</ul>
		<div id="tab_area"> 
			<div ng-show="table_active=='construction'">
				<table class="cap-table-fullWidth" style="margin: 2px 0 5px 0">
					<tr>
				        <td class="cap-td" style="text-align: left;" nowrap="nowrap">
				        	<span uitype="button" id="customColumn" label="添加" menu="customColumnButtonGroup"></span> 
						    <span cui_button id="deleteCustomHeader" label="删除" ng-click="deleteCustomHeader()"></span>
						    <span cui_button id="customHeaderUpButton" label="上移" ng-click="up()"></span> 
							<span cui_button id="customHeaderDownButton" label="下移" ng-click="down()"></span> 
							<a title="上一级" style="cursor:pointer;" ng-click="upGrade()">&nbsp;<span class="cui-icon" style="font-size:12pt; color:#333;">&#xf0d9;</span></a>
						    <span cui_pulldown id="level" ng-change="setLevel()" ng-model="level" value_field="id" label_field="text" empty_text="级别" width="45px">
								<a value="1">1</a>
								<a value="2">2</a>
								<a value="3">3</a>
								<a value="4">4</a>
								<a value="5">5</a>
							</span>
						    <a title="下一级" style="cursor:pointer;" ng-click="downGrade()"><span class="cui-icon" style="font-size:12pt; color:#333;">&#xf0da;</span></a>
				        </td>
				    </tr>
				 </table>
				 <table class="cap-table-fullWidth">
				    <tr style="border-top:1px solid #ddd;">
				        <td class="cap-td" style="text-align: center; padding: 2px; width: 50%">
				        	<div class="custom_div">
					        	<table class="custom-grid" style="width: 100%">
					                <thead>
					                    <tr>
					                    	<th style="width:30px">
					                    		<input type="checkbox" name="customHeadersCheckAll" ng-model="customHeadersCheckAll" ng-change="allCheckBoxCheckCustomHeader(customHeaders,customHeadersCheckAll)">
					                        </th>
					                        <th>
				                            	列名(columns)
					                        </th>
					                    </tr>
					                </thead>
			                        <tbody>
			                            <tr ng-repeat="customHeaderVo in customHeaders track by $index" style="background-color: {{customHeaderVo.check == true ? '#99ccff':'#ffffff'}}">
			                            	<td style="text-align: center;">
			                                    <input type="checkbox" name="{{'customHeader'+($index + 1)}}" ng-model="customHeaderVo.check" ng-change="checkBoxCheckCustomHeader(customHeaders,'customHeadersCheckAll')">
			                                </td>
			                                <td style="text-align:left;cursor:pointer" ng-click="customHeaderTdClick(customHeaderVo)">
			                                  {{customHeaderVo.indent}}&nbsp;{{customHeaderVo.name}}
			                                </td>
			                            </tr>
			                       </tbody>
					            </table>
				            </div>
				        </td>
				        <td style="text-align: left;border-right:1px solid #ddd;">
				        </td>
				        <td class="cap-td" style="text-align: left; padding: 2px; width: 50%;">
				       		<ul class="tab">
								<li class="active">表头属性</li>
							</ul>
							<div ng-show="data.check">
								<div id="tab_property" class="tab_panel"></div>
							</div>
				        </td>
				    </tr>
				</table>
		    </div>
		    <div ng-show="table_active=='datasource'">
		 		<div style="text-align: left; margin: 5px;">
			        <span uitype="button" on_click="insertRow" label="新增"></span>
			        <span uitype="button" on_click="deleteSelectedRow" label="删除"></span>
			        <span uitype="button" on_click="copyRow" label="复制"></span>
			    </div>
			    <div id="container"></div>
		    </div>
		</div>
	</div>

	<script type="text/javascript">
		var namespaces = "<%=request.getParameter("namespaces")%>";
		var reqFunctionSubitemId = "<%=request.getParameter("reqFunctionSubitemId")%>";
		var domainId;
		var propertyName = "<c:out value='${param.propertyName}'/>";
		var extras = window.opener.scope.data.extras;
		extras = extras != null && extras != '' ? JSON.parse(extras) : {};
		var pageSession = new cap.PageStorage(namespaces);
		var callbackMethod = "<c:out value='${param.callbackMethod}'/>";
		var selectrows = window.opener.scope.data.selectrows;
  	    var scope = {};
	    
		angular.module('customGridThead', ["cui"]).controller('customGridTheadCtrl', function ($scope, $compile) {
	    	$scope.customHeadersCheckAll　=　false;
	    	//列头属性（右侧表格数据源）
	    	$scope.customHeaders　= [];
	    	//被选中的列头属性对象
	    	$scope.data　=　{};
	    	$scope.component　=　{};
	    	$scope.propertyTypeMap =　new HashMap();
	    	$scope.hasHideNotCommonProperties = true;
	    	$scope.table_active = 'construction';
	    	$scope.testDatasource = extras.testDatasource ? JSON.parse(extras.testDatasource) : [];
	    	$scope.actionDefineVO = null;
	    	
	    	$scope.ready=function(){
		    	scope=$scope;
		    	$scope.loadColumnProperties();
		    	comtop.UI.scan();
				$scope.initTableHeaders();
				$(window).resize(function() {
		    		$(".custom-div").height(getBodyHeight);
	    		});
				domainId = getDomainId(reqFunctionSubitemId);
		    }
	    	
	    	//切换Tab标签
	    	$scope.showPanel=function(msg, arr){
	    		showPanel(this, msg, arr);
	    	}
	    	
	    	//加载表头属性
	    	$scope.loadColumnProperties=function(){
	    		dwr.TOPEngine.setAsync(false);
				ComponentFacade.query('req.uicomponent.common.component.grid', "properties[ename='columns']", function(data){
					$scope.component = data.propertyEditorUI;
					//常用属性
					$scope.component.commonProperties = [];
					//非常用属性
					$scope.component.notCommonProperties = [];
					var properties = $scope.component.properties;
					for(var i in properties){
						$scope.propertyTypeMap.put(properties[i].ename, properties[i].type);
						properties[i].propertyEditorUI.script = eval("("+properties[i].propertyEditorUI.script+")");
						var key = properties[i].propertyEditorUI.script.name;
						if(typeof($scope.data[key]) == 'undefined'){
							$scope.data[key] = properties[i].defaultValue;
						}
						if($scope.data[key] != null){
							$scope.data[key] = $scope.data[key] + '';
						}
						if(properties[i].commonAttr){
							$scope.component.commonProperties.push(properties[i]);
						} else {
							$scope.component.notCommonProperties.push(properties[i]);
						}
					}
				});
				dwr.TOPEngine.setAsync(true);
				$('#tab_property').html(new jCT($('#propertiesEditTmpl').html()).Build().GetView()); 
	        	$compile($('#tab_property').contents())($scope);
	    	}
	    	
	    	//初始化表头数据列
	    	$scope.initTableHeaders = function (){
	    		if(extras.tableHeader != null){
		    		$scope.customHeaders = eval("("+extras.tableHeader+")");
	    		} 
	    		if($scope.customHeaders.length > 0){
					$scope.data = $scope.customHeaders[0];
					$scope.customHeaders[0].check = true;
	    		}
	    	}
	    	
	    	//保存
			$scope.saveCustomHeader=function(){
				var result = execValidateAll();
	     	  	if(!result.validFlag){
	     	  		cui.alert(result.message); 
	     	  		return;
	     	  	}
				var hasMultiTableHeader = _.pluck(_.sortBy($scope.customHeaders, 'level'), 'level').reverse()[0] > 1 ? true : false;
				var customHeaders = [];
				if(hasMultiTableHeader){//多表头
					customHeaders = getMultiLineHeaders($scope.customHeaders);
					if(customHeaders.length > 0){
						var addSelectrowsColumnVo = {};
						if(selectrows == null || selectrows == '' || selectrows == 'multi'){
							addSelectrowsColumnVo = {rowspan:customHeaders.length,width:60,type:'checkbox'};
							customHeaders[0] = _.union([addSelectrowsColumnVo], customHeaders[0]);
						} else if(selectrows == 'single'){
							addSelectrowsColumnVo = {rowspan:customHeaders.length,width:60,name:''};
							customHeaders[0] = _.union([addSelectrowsColumnVo], customHeaders[0]);
						} 
						for(var i in customHeaders){
							var customHeader = customHeaders[i];
							transformColumns(customHeader, $scope.propertyTypeMap);
						}
					} else {
						cui.error("多表头结构设置有误。"); 
						return;
					}
				} else {
					customHeaders = jQuery.extend(true, [], $scope.customHeaders);
					transformColumns(customHeaders, $scope.propertyTypeMap);
				}
				for(var i in $scope.customHeaders){
					$scope.customHeaders[i].check = false;
				}
				var data = window.opener.scope.data;
				if(customHeaders.length > 0){
					data[propertyName] = JSON.stringify(customHeaders);
					if(cui("#editgridtable").isCUI){
		    			$scope.testDatasource = cui("#editgridtable").getData();
		    			$scope.filterTestData();
		    		}
					extras = {testDatasource: JSON.stringify($scope.testDatasource), tableHeader: customHeaders.length > 0 ? JSON.stringify($scope.customHeaders) : ''};
					data.extras = JSON.stringify(extras);
					data.primarykey = 'id';
				} else {
					data[propertyName] = '';
					data.extras = '';
					data.primarykey = '';
				}
				$scope.autoBindDatasource();
				cap.digestValue(window.opener.scope);
				window.close(); 
			}
	    	
	    	//过滤测试数据
	    	$scope.filterTestData=function(){
	    		_.forEach($scope.testDatasource, function(obj, key){
					var delKeys = [];
					if(delKeys.length == 0){
						_.forEach(obj, function(value, key){
							if(_.find($scope.customHeaders, {bindName: key}) == null){
								delKeys.push(key);
							}
						});
					} 
					_.forEach(delKeys, function(value, key){
						delete obj[value];
					});
				})
	    	}
	    	
	    	//自动绑定数据源
	    	$scope.autoBindDatasource=function(){
	    		autoBindDatasource($scope, null, window.opener.scope.data.datasource);
	    	}
	    	
			$scope.$watch("data.name", function(newValue, oldValue){
				if(oldValue != newValue && newValue != "序号" && typeof newValue != 'undefined'){
					$scope.data.bindName = pinyin.getFullChars(newValue).toLowerCase().replace(/[^a-z|0-9|\_]/ig, "");
				}
	    	}, false);
	    	
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
                $scope.customHeadersCheckAll = false;
                $scope.data = {};
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
	    });
		
		//列表按钮组
    	var customColumnButtonGroup = {
	        datasource: [
				{id:'batchInsertCol',label:'批量导入列'},
	            {id:'insertSerialCol',label:'添加序号列'},
	            {id:'insertBlankCol',label:'添加空白列'}
	        ],
	        on_click : function(obj){
	        	if(obj.id === 'batchInsertCol'){
	        		openSelectBizObjectMainWin(domainId);
	        	}else if(obj.id === 'insertSerialCol'){
	        		scope.addCustomHeader({customHeaderId: (new Date()).valueOf() + '', name: '序号', sort: 'false', hide: 'false', disabled: 'false', level: 1, indent:'', bindName:'1'});
	        		cap.digestValue(scope);
	        	}else if(obj.id === 'insertBlankCol'){
	        		scope.addCustomHeader({customHeaderId: (new Date()).valueOf() + '', name: '', sort: 'false', hide: 'false', disabled: 'false', level: 1, indent:''});
		        	cap.digestValue(scope);
	        	}
	        }
	    };
		
		function openRenderWindow(event, self){
			var width=800; //窗口宽度
		    var height=600; //窗口高度
		    var top=(window.screen.availHeight-height)/2;
		    var left=(window.screen.availWidth-width)/2;
		    var bindName = scope.data.bindName;
			var url='CustomGridColumnsRender.jsp?namespaces=' + namespaces + '&reqFunctionSubitemId=' + reqFunctionSubitemId + '&callbackMethod=openWindowCallback&bindName='+bindName;
		    window.open(url, "_blank", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
		}
		
	    //统一校验函数
		function validateAll(){
	    	var validate = new cap.Validate();
	    	var valRule = {bindName: bindNameValRule};
	    	var gridCloumns = scope.customHeaders;
	    	return validate.validateAllElement(gridCloumns, valRule);
	  	}
	  	
	</script>
	<%@ include file="/cap/bm/dev/page/uilibrary/PropertiesEditTmpl.jsp" %>
</body>
</html>
