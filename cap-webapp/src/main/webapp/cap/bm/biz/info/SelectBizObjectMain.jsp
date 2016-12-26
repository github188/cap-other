<%
  /**********************************************************************
	* 业务对象转表数据---业务对象属性选择 
	* 2016-11-02  林玉千  梁培 新增
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<%@ page import="java.util.*" %>


<!doctype html><head>
<title>业务对象属性选择主页面</title>
<top:link  href="/cap/bm/common/base/css/base.css"/>
<top:link  href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
<top:link  href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
</head>

<style>
body {
    display: block;
    margin: 5px;
}
.ctrl {
	position: fixed;
	right: 15px;
	top: 10px;
	z-index: 1;
}
.searchCondition {
    padding-top: 5px;
    padding-bottom: 5px;
}
.btn-arrow {
  height: 400px;
  /* margin: 10px 0 0 0; */
  position: relative;
}
.btn-arrow .tools-arrow {
  position: absolute;
  margin: auto;
  height: 100px;
  width: 30px;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
}
.btn-arrow .tools-arrow .arrow {
  -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  -o-user-select: none;
  user-select: none;
  display: inline-block;
  width: 30px;
  height: 24px;
  margin: 10px 0 0 -2px;
  color: #666;
  -webkit-border-radius: 3px 3px 3px 3px;
  -moz-border-radius: 3px 3px 3px 3px;
  border-radius: 3px 3px 3px 3px;
  line-height: 24px;
  text-align: center;
  cursor: pointer;
  background-color: #ffffff;
  background-image: -webkit-linear-gradient(top, #ffffff, #e6e6e6);
  background-image: -moz-linear-gradient(top, #ffffff, #e6e6e6);
  background-image: -o-linear-gradient(top, #ffffff, #e6e6e6);
  background-image: -ms-linear-gradient(top, #ffffff, #e6e6e6);
  background-image: linear-gradient(top, #ffffff, #e6e6e6);
  border: 1px solid #cccccc;
}
.btn-arrow .tools-arrow .arrow:hover {
  background-color: #f2f2f2;
  background-image: -webkit-linear-gradient(top, #f2f2f2, #dadada);
  background-image: -moz-linear-gradient(top, #f2f2f2, #dadada);
  background-image: -o-linear-gradient(top, #f2f2f2, #dadada);
  background-image: -ms-linear-gradient(top, #f2f2f2, #dadada);
  background-image: linear-gradient(top, #f2f2f2, #dadada);
  color: #3081fa;
}

/* 表头固定内容滚动的表格  */
.scroll {max-height:500px;overflow-y:auto;border-bottom:1px solid #ddd;}
.grid{
	width: 100%;
	table-layout: fixed;
	border-collapse: collapse;
	color: #333;
	font-size: 12px;
}
.grid th,.scroll .grid td{width:30px;padding:4px 2px;border:1px solid #ddd;}
.grid th{font-weight:bold; background:#eee;}
.grid thead th:last-child,.scroll tbody td:last-child{width:auto;}
.scroll .grid tbody tr:first-child td{border-top:0;}

</style>
</head>
<body ng-app="bizApp" ng-controller="bizCtrl" ng-init="initView()">

<div class="ctrl"> 
    <span cui_button id="saveButton" ng-click="saveTable()" label="确定" button_type="blue-button"></span> 
    <span cui_button id="cancelCustomHeader" label="取消" ng-click="closeWindow()"></span> 
</div>
<div id="tabs"></div>

<script type="text/html" id="objStr">
<div id="boderWrap" style="height:540px">
	<div uitype="Borderlayout" id="body" is_root="false">
		<div position="left" width="200" collapsable="true" show_expand_icon="true">
			<div id="searchCondition-{{= current }}" class="searchCondition"></div>
		
			<table id="BizObjGrid-{{= current }}">
				<thead>
					<tr>
						<th style="width:20px;"></th>
						<th renderStyle="text-align: left;" style="width:170px;">对象列表</th>
					</tr>
				</thead>
			</table>  
		 </div>
		<div id="centerMain-{{= current }}" position="center" width="100%">
			<h2 style="height:100px; line-height:100px;color:#666;text-align:center">请在左侧表格内选择业务对象</h2>
		</div>
	</div>
</div>
</script> 
<script type="text/html" id="tableStr">
	<table class="cap-table-fullWidth">
		<tr>
			<td class="cap-td" style="width: 34%;">   
				<table class="grid">
					<thead>
						<tr>
							<th style="width: 30px">
								<input type="checkbox" name="itemCheckAll" ng-model="itemCheckAll" ng-change="checkALLItem(items, itemCheckAll)">
							</th> 
							<th>
								数据项
							</th>						
						</tr>
					</thead>
				</table>
				<div class="scroll">
					<table class="grid">
						<tbody>
							<tr ng-repeat="item in items track by $index" ng-hide="item.isFilter" 
						    style="cursor:pointer;background-color: {{item.check == true ? '#99ccff':'#ffffff'}}" ng-cloak>
							<td style="text-align: center;">
							   <input type="checkbox" name="{{'item'+($index + 1)}}" ng-model="item.check" ng-change="checkItem(items)">
							</td>
							<td ng-click="rowClick(item)">
							   {{item.name}}
							</td>
							</tr>
						</tbody>
					</table>
				</div>
			</td>
			<td style="width: 6%;text-align: center; vertical-align: middle;" align="center">
				<div class="btn-arrow">
	      			<div class="tools-arrow">
		        		<span  class="cui-icon arrow" ng-click="chooseHandle()" title="全部右移动">&#xf04e;</span>
		        		<span class="cui-icon arrow" ng-click="cancleChooseHandle()" title="全部左移动">&#xf04a;</span>
	      			</div>
		        </div>
			</td>
			<td class="cap-td" style="width: 60%">
				<table class="grid" style="width: 100%">
					<thead>
						<tr>
							<th style="width:30px">
								<input type="checkbox" name="chooseCheckAll" ng-model="chooseCheckAll" ng-change="checkALLChooseItem(chooseItems, chooseCheckAll)">
							</th>
							<th style="width:{{showValue == true ? '130px': 'auto'}}">
								数据项
							</th>
							<th ng-if="showValue">
								数据值
							</th>
						</tr>
					</thead>
				</table>
				<div class="scroll">
					<table class="grid">
						<tbody>
							<tr ng-repeat="chooseItem in chooseItems track by $index" style="cursor:pointer;background-color: {{chooseItem.check == true ? '#99ccff':'#ffffff'}}">
								<td style="text-align: center;">
								   <input type="checkbox" name="customHeaderId" ng-model="chooseItem.check" ng-change="checkChooseItem(chooseItems)">
								</td>
								<td ng-click="chooseRowClick(chooseItem)" style="width:{{showValue == true ? '130px' :'auto'}}">
								   <div>{{chooseItem.name}}</div>
								</td>
								<td ng-if="showValue" ng-click="chooseRowClick(chooseItem)">
								  <span cui_input ng-model="chooseItem.remark"  width="100%"></span>
								</td>
							</tr>
				  	 	</tbody>
					</table>
				</div>
			</td>
		</tr>
	</table>
</script>
<script type="text/html" id="formStr">
</script>
<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
<top:script src="/cap/dwr/engine.js"></top:script>
<top:script src="/cap/dwr/util.js"></top:script>
<top:script src="/cap/dwr/interface/BizObjInfoAction.js"></top:script>
<top:script src="/cap/dwr/interface/BizObjDataItemAction.js" />
<top:script src="/cap/dwr/interface/BizFormAction.js" />
<top:script src="/cap/dwr/interface/BizFormDataAction.js" />
<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
<top:script src="/cap/bm/common/base/js/angular.js"></top:script>
<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>

<script type="text/javascript">
    //TODO: tabLen 控制TAB个数，需要从后台拿对应数据 
    // showValue是否显示Value
	var domainIds= "<c:out value='${param.domainIds}'/>";//多个业务域用逗号分开 如："CBFA312BBBD046A6A0CC326CEE4D7C16,9AD0750ACE474B5CAAB9404A59303A3B";
	var selectedObjectId = "";//列表选中的行ID 
	var packageId = "<c:out value='${param.packageId}'/>";
	//tablenValue用来判断显示页面的tab书，值为1：只显示业务对象列表tab  值为2:显示业务对象和业务表单两个tab
	var tabLenValue = "<c:out value='${param.tabLen}'/>";
	//showValueFlow 用于控制是否显示已选列表的数据项置值的信息 ，值为""时，代表显示，值不为""时不显示
	var showValueFlag = "<c:out value='${param.showValueFlag}'/>";
	showValueFlag = showValueFlag == "" ? true : false;
	var formVO = {};
	var BizObjInfo = {
		 currentTAB : 0,
		 tabLen: tabLenValue,
		 showValue:showValueFlag,
		 chooseItem : []
	};
	//解决模板的变量输出语法和JSP变量输出语法冲突问题
	_.templateSettings =  {
		evaluate    : /\{\{([\s\S]+?)\}\}/g,
		interpolate : /\{\{=([\s\S]+?)\}\}/g,
		escape      : /\{\{-([\s\S]+?)\}\}/g
	};
    +function ($, _) {
		//TDDO:冗余代码优化
		var Strategy = {
		  "0" : {
			   tabelInit :  function(){
				   
				   return function(tableObj){
						if(ClickInput.getValue()){
							BizObjInfo.keyWords = ClickInput.getValue();
						}else{
							BizObjInfo.keyWords = null;
						}
						var strDomains= []; 
						var dataArr = [];
						strDomains = domainIds.split(",");
						strDomains = _.uniq(strDomains);
						BizObjInfo.domainIdList = strDomains;
						dwr.TOPEngine.setAsync(false);
						BizObjInfoAction.queryBizObjInfoListByDomainIds(BizObjInfo,function(data){
							tableObj.setDatasource(data.list, data.count);
							BizObjInfo.dataArr = data.list;
						});
						dwr.TOPEngine.setAsync(true);
						if(dataArr.length>0 && !selectedObjectId){//列表存在记录
							selectedObjectId = dataArr[0].id;
							tableObj.selectRowsByPK(selectedObjectId);
						}
				   }
				},
			   formInit : function(){
				   return function($scope, BizObjInfoId){
						var query={};
						//父数据主键
						if(BizObjInfoId){
							query.bizObjId = BizObjInfoId;
							dwr.TOPEngine.setAsync(false);
							BizObjDataItemAction.queryBizObjDataItemList(query,function(data){
								if(data && data.list){
									var i = _.find(BizObjInfo.dataArr, function(o) { return o.id  ===  BizObjInfoId; });
									for(var k = 0; k < data.list.length; k++){
										data.list[k].bizObjInfo = i;							
									}
								}
								$scope.items = data.list;
								$scope.itemCheckAll = false;
							});
							dwr.TOPEngine.setAsync(true);
						} else {
						    $scope.items = [];
						}
				    }
				}
		   },
			"1" : {
			   tabelInit :  function(){
				   return function(tableObj){
						if(ClickInput.getValue()){
							formVO.keyWords = ClickInput.getValue();
						}else{
							formVO.keyWords = null;
						}
						var strDomains= []; 
						var dataArr = [];
						strDomains = domainIds.split(",");
						strDomains = _.uniq(strDomains);
						formVO.domainIdList = strDomains;
						dwr.TOPEngine.setAsync(false);
						BizFormAction.queryFormListByDomainIdList(formVO,function(data){
							tableObj.setDatasource(data.list, data.count);
							BizObjInfo.dataArr=data.list;
						});
						dwr.TOPEngine.setAsync(true);
						if(dataArr.length>0 && !selectedObjectId){//列表存在记录
							selectedObjectId = dataArr[0].id;
							tableObj.selectRowsByPK(selectedObjectId);
						}
				   }
				},
			   formInit : function() {
					return function($scope, BizObjInfoId){
						//父数据主键
						formVO.formId = BizObjInfoId;
                        if(BizObjInfoId){
							dwr.TOPEngine.setAsync(false);
							BizFormDataAction.queryFormDataListByFormId(formVO,function(data){
								if(data && data.list){
									var i = _.find(BizObjInfo.dataArr, function(o) { return o.id  ===  BizObjInfoId; });
									for(var k = 0; k < data.list.length; k++){
										data.list[k].bizFormByFromtofromdata = i;							
									}
								}
								$scope.items = data.list;
								$scope.itemCheckAll = false;
							});
							dwr.TOPEngine.setAsync(true);
						} else {
						    $scope.items = [];
						}
					}
			   }
			}
		};

		var BizObject = {
			version: '0.0.1',
			/**
			 * Default tabs Configration
			 *
			 * @prperty
			 */
			 defaults: {
			 },
			/**
			 * BizObject 对象的属性
			 *
			 * @prperty
			 */
			attributes: {},
			/**
			 * 设置部件属性
			 *
			 * @param config
			 * @returns {AutocJS}
			 */
			set: function ( config ) {
	
				if ( $.isPlainObject( config ) ) {
					$.extend( this.attributes, config );
				}
	
				return this;
			},	

	        /**
			 * 初始化程序
			 *
			 * @param {Object} tabs - 配置信息
			 * @param {Array} config.tabs
			 * @param {Numer} [config.tabLen]
			 * @param {String} [config.tabWrap]
			 */				
		    init: function (config){
				this.set( this.defaults ).set( config ).render();
				return this;
			},
			/**
			 * 页面组件渲染
			 */	
			render: function (){
			   Tab.render();
			   ClickInput.render();
               Grid.render();
			   comtop.UI.scan();
			   
			   return this;
			},
			/**
			 * 重新绘制TAB
			 *
			 * @param {Object} tab
			 * @returns {BizObject}
			 */
			reload: function ( tabs ) {
				this.destroy().init(tabs);
				return this;
			},
			
			destroy: function () {
				cui(this.attributes.tabWrap).destroy();
				return this;
			}
		},
		
   		Tab = {
		    defaults: {
				tabWrap : '#tabs',
				tabLen : BizObjInfo.tabLen || 2,
				tabs: [ {
					title: "业务对象",
					html:  _.template( $('#objStr').html() )({current : 0}),
					on_switch : function(tab){
					   return Tab.switchTab(tab)
					}
				},{
					title: "业务表单",
					html: _.template( $('#objStr').html() )({current : 1}),
					on_switch : function(tab){
					   return Tab.switchTab(tab)
					}
				}],
			 },
			 
			 setTabsLen: function (){
			     var config = this.defaults;
			     config.tabs.length = config.tabLen;
			     return this;
			 },
			/**
			 * Tab渲染
			 */	
			render: function (){
			   this.setTabsLen();
			   cui(this.defaults.tabWrap).tab(this.defaults);
			   return this;
			},
			
			switchTab : function (tab){
				var center = document.getElementById('centerMain-' + tab.toTab),
				    scope = angular.element(center).scope();
				
                BizObjInfo.currentTAB = tab.toTab;
				BizObject.init();
				scope.initView();
				scope.$apply();
			}
		},
         
		ClickInput	= {
		    defaults: {
				icon : 'search',
				maxlength : 150,
				editable : true,
				width: '98%',
				emptytext : "请输入名称、编码进行查询"
			},
			
			init : function(){
			    $.extend(this.defaults, {
					clickWrap : '#searchCondition-' + BizObjInfo.currentTAB,
					on_iconclick : this.search,
					on_keydown :  this.keyDownQuery
				});
			},
			
			render: function (){
			   this.init();
			   cui(this.defaults.clickWrap).clickInput(this.defaults);
			   return this;
			},
			
			search: function (){
			   Grid.loadData();
			},
			
			keyDownQuery: function(){
			    if ( event.keyCode == 13) {
					ClickInput.search();
				}
			},
			
			getValue : function(){
			   return cui(this.defaults.clickWrap).getValue();
			}

		}
		Grid = {
		    defaults: {
				primarykey : 'id',
				gridwidth : 195,
				pagination : false,
				gridheight : "500",
				selectrows : "single"
			},
			
			init : function(){
			    $.extend(this.defaults, {
					gridWrap : '#BizObjGrid-' + BizObjInfo.currentTAB,
					datasource : this.initData(BizObjInfo.currentTAB),
					colrender : this.columnRenderer,
					rowclick_callback :  this.selectOneObject
				});
			},
			
			render: function (){
			   this.init();
			   cui(this.defaults.gridWrap).grid(this.defaults);
			   return this;
			},
			
			initData : function(current){
				return Strategy[current].tabelInit();
			},
			
			selectOneObject: function (rowData,isChecked,index){
				var center = document.getElementById('centerMain-' + BizObjInfo.currentTAB),
				    scope = angular.element(center).scope();
					
				scope.initItems(BizObjInfo.currentTAB)(scope,rowData.id,rowData.domainId);
				scope.filterChoosedItems(scope.items, scope.chooseItems);
				scope.$apply();
			},
			
			columnRenderer: function(rd, index, col) {
				return rd.name;
// 				if(rd.code){
// 					return rd.name;
// 				}
// 				else{
// 					return rd.name;
// 				}
			},
			
			loadData : function(){
			   cui(this.defaults.gridWrap).loadData();
			}
		}

		var app = angular.module('bizApp', ["cui"]).controller('bizCtrl', function($scope, $compile) {
			//TODO:是否显示value列
			$scope.showValue = BizObjInfo.showValue;
			$scope.initView = function(){
				var BizObjInfoId = cui(Grid.defaults.gridWrap).getRowsDataByIndex(0)[0] ? 
				        cui(Grid.defaults.gridWrap).getRowsDataByIndex(0)[0].id : '',
					temp = $('#tableStr').html(),
					element = $('#centerMain-' + BizObjInfo.currentTAB);
				
				$scope.items = [];
				$scope.chooseItems = [];
				$scope.itemCheckAll = false;
				$scope.chooseCheckAll = false;

				//数据备份
				BizObjInfo.chooseItem.length ?  $scope.chooseItems = BizObjInfo.chooseItem : "" ;
				BizObjInfo.chooseItem = $scope.chooseItems;
                
				$scope.initItems(BizObjInfo.currentTAB)($scope, BizObjInfoId)
				//过滤items数据，右表中存在的，需要隐藏
				$scope.filterChoosedItems($scope.items, $scope.chooseItems);

				element.html(temp);
				$compile(element.contents())($scope);
				cui(Grid.defaults.gridWrap).selectRowsByIndex(0);		
			};
			
			$scope.initItems = function(current){
			    return Strategy[current || "0"].formInit();
			};
			
			$scope.filterChoosedItems = function(items, choosed){
				_.forEach(choosed, function(value) {		
					 _.find(items,function(Item) {
						if(Item.id === value.id){
						  Item.isFilter = true;
						}
					});
				});			
			};
			
			//待选行选中效果
			$scope.rowClick = function(obj){
				obj.check = !obj.check;
				$scope.checkItem($scope.items)
			};
			
			//已选行选中效果
			$scope.chooseRowClick = function(obj){
			    obj.check = !obj.check;
				$scope.checkChooseItem($scope.chooseItems);
			};
			
			//监控全选checkbox，如果选择则联动选中列表所有数据
			$scope.checkALLItem = function(arr, isCheck) {
				if (arr != null) {
					for (var i = 0, len = arr.length; i < len; i++) {
						if (!arr[i].isFilter) {
							arr[i].check = isCheck;
						}
					}
				}
			};
			//TDDO:冗余代码优化
			$scope.checkALLChooseItem = function(arr, isCheck) {
				if (arr != null) {
					for (var i = 0, len = arr.length; i < len; i++) {
						arr[i].check = isCheck;
					}
				}
			};
			
			//监控已选单个checkbox，控制全选按钮的变化
			$scope.checkItem = function(arr) {
				if (arr != null) {
					var items = arr,
					    count = 0,
					    filterCount = 0;
						
					for (var i = 0, len = items.length; i < len; i++) {
						if (!items[i].isFilter && items[i].check) {
							count = count +1;
						}
						if(items[i].isFilter){
						   filterCount ++;
						}
					}
					if(count == (items.length - filterCount)){
						$scope.itemCheckAll = true;
					}else{
						$scope.itemCheckAll = false;
					}
				}
			};
			//监控单个checkbox，控制全选按钮的变化
			//TDDO:冗余代码优化
			$scope.checkChooseItem = function(arr) {
				if (arr != null) {
					var items = arr;
					var count = 0;
					for (var i = 0, len = items.length; i < len; i++) {
						if (items[i].check) {
							count = count +1;
						}
					}
					if(count && count == items.length){
						$scope.chooseCheckAll = true;
					}else{
						$scope.chooseCheckAll = false;
					}
				}
			};
			//选入处理
			$scope.chooseHandle = function() {
				var items = $scope.items,
					choose = $scope.chooseItems,
					count = 0,
					redo = false;
				var leftItems = _.filter(items,function(m){
									return m.check&& !m.isFilter;
								});
				_.forEach(leftItems, function(value) {
					if(value.check){
						redo = _.find(choose,function(chooseItem) {
							if(chooseItem.name == value.name){
							   return true;
							}
						});
						value.remark = '';
						if(!redo){
							//放于push后，避免choose数据带fiter属性
							choose.push(value);
							count++;
							value.isFilter = true;
						}
					}
				});
				
				if(count && count === items.length){
					$scope.itemCheckAll = false;
				}
				$scope.checkChooseItem($scope.chooseItems);
			}
			//取消选入处理
			$scope.cancleChooseHandle = function() {
				var items = $scope.items,
					choose = $scope.chooseItems,
					length =  choose.length,
					count = 0,
					id = "";
				
				for (var i = 0, len = choose.length; i < len; i++) {
					if(choose[i].check){
						id = choose.splice(i, 1)[0].id;
						i--;
						len--;
						_.find(items,function(item) {
							if(item.id === id){
								item.isFilter = false;
								count ++;
							}
						});
					}
				}
				if(count === length){
					$scope.chooseCheckAll = false;
				}
				$scope.checkItem($scope.items);
			};
			
			//数据保存
			$scope.saveTable = function() {
				var choose = $scope.chooseItems;
				if(choose && choose.length<1){
					cui.alert("请选择数据");
					return;
				}
				$scope.sumitData = [];
				//根据业务对象Id或者表单ID对选择的数据进行分类，使每个选中数据项都分别挂在对应的对象上
				choose = _.groupBy(choose,function(n){
					return n.bizObjId ? n.bizObjId : n.formId;
				});
			    //循环分组后的每个业务对象或业务表单，将业务对象信息和对应的数据项转为指定的数据结构
				_.forEach(choose, function(value, key) {
				    var obj = null;
					var dataItems = [];
					
				    if(value[0].bizObjInfo){
				    	obj = value[0].bizObjInfo;
				    }else{
				    	obj = value[0].bizFormByFromtofromdata;
				    }

					if(obj){
						//遍历数据项，转为数据格式
						_.forEach(value, function(n) {
							dataItems.push({
							    "id": n.id,
								"name": n.name,
								"code": n.code,
								"value": n.remark,
								"description": n.description,
								"parentId": obj.id
							});
						});
						//设置返回结果对象
						$scope.sumitData.push({
						    "id": obj.id,
							"name": obj.name,
							"code": obj.code,
							"description":obj.description,
							"domainId": obj.domainId,
							"packageId": packageId,
							"dataItems": dataItems
						});
					}
				});
				if(window.parent.callbackConfirm){
					window.parent.callbackConfirm($scope.sumitData);
				} else {
					window.opener.callbackConfirm($scope.sumitData);
					window.close();
				}
			};
	
			$scope.closeWindow = function(){
				if(window.parent.callbackClose){
					window.parent.callbackClose();
				} else {
					window.close();
				}
			}
		});
        /**
		 * 界面初始化
		 */			
		BizObject.init();
    }(jQuery, _);

	</script>
</body>
</html>