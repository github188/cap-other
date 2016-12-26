<%
/**********************************************************************
* 设计器中设置控件状态（js）
* 2015-8-11 凌晨 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app='SetJsExpressionState'>
<head>
    <meta charset="UTF-8">
    <title>页面状态</title>
    <top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <style type="text/css">
    	
    </style>
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/top/sys/dwr/engine.js"></top:script>
	<top:script src="/top/sys/dwr/util.js"></top:script>
	<top:script src='/cap/dwr/interface/EnvironmentVariablePreferenceFacade.js'></top:script>
    <script type="text/javascript">
	    var pageId="<%=request.getParameter("modelId")%>";
	    var packageId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
	    //从设计器传过来的需要设置的UI的状态
	    var state="<%=request.getParameter("state")%>";
	    var pageSession = new cap.PageStorage(pageId);
	    //取出所有表达式
	    var expressions=pageSession.get("expression");
	    var page = pageSession.get("page");
	    var dataStore = pageSession.get("dataStore");
	    //当表达式为空时，初始化为数组
	    expressions=expressions==null?[]:expressions;
	    var root={expressions:expressions};
	    
	    //表达式属性树
	    var expressAttrSelectTreeData = [{
	        title: "表达式变量",
	        key: "root",
	        expand: true,
	        isFolder: true,
	        children: []
	    }];
	    
	    //初始化表达式属性数数据
	    function initExpressAttrSelectTree(){
	    	//每次都清空节点,重新生成
	    	expressAttrSelectTreeData[0].children=[];
	    	var pageAttributeVOList=page.pageAttributeVOList;
	    	var rightsVariableVO=dataStore[2];
	    	var pageAttributeNodeArr=[];
	    	for(var i=0;i<pageAttributeVOList.length;i++){
	    		var pageAttributeVO=pageAttributeVOList[i];
	    		pageAttributeNodeArr.push({
	                title: pageAttributeVO.attributeName,
	                key: pageAttributeVO.attributeName
	            });
	    	}
	    	var pageAttributeNode={
	            title: "页面参数",
	            key: "pageAttributeRoot",
	            isFolder: true,
	            expand: true,
	            children: pageAttributeNodeArr
		    };
	    	
	    	var rightsVariableNodeArr=[];
	    	for(var i=0;i<rightsVariableVO.verifyIdList.length;i++){
	    		var rightVO =rightsVariableVO.verifyIdList[i];
	    		rightsVariableNodeArr.push({
	                title: rightVO.funcCode,
	                key: rightVO.funcCode
	            });
	    	}
	    	var rightsVariableNode={
		            title: "操作权限",
		            key: "rightsVariableVO",
		            isFolder: true,
			        expand: true,
			        children:rightsVariableNodeArr
			};
	    	
	    	var environmentVariableVOList=loadEnvironmentVariableVOList();
	    	var environmentVariableNodeArr=[];
	    	for(var i=0;i<environmentVariableVOList.length;i++){
	    		var environmentVariableVO =environmentVariableVOList[i];
	    		environmentVariableNodeArr.push({
	                title: environmentVariableVO.attributeName,
	                key: environmentVariableVO.attributeName
	            });
	    	}
	    	var environmentVariableNode={
		            title: "全局环境变量",
		            key: "environmentVariableVO",
		            isFolder: true,
			        expand: true,
			        children:environmentVariableNodeArr
			};
	    	
	    	
	    	var dataStoreVOs=[];
	    	for(var i=0;i<dataStore.length;i++){
	    		if(dataStore[i].modelType=="object"){
	    			var entityVO=dataStore[i].entityVO;
	    			if(entityVO!=null){
	    				var entityAttributeNodeArr=[];
		    			var attributes=entityVO.attributes;
		    			if(attributes!=null){
		    				for(var j=0;j<attributes.length;j++){
			    				entityAttributeNodeArr.push({
			    					title: attributes[j].engName,
					                key: attributes[j].engName
			    				});
			    			}
			    			
			    			dataStoreVOs.push({
				                title: dataStore[i].ename,
				                key: dataStore[i].ename,
				                isFolder: true,
						        expand: true,
						        children:entityAttributeNodeArr
				            });
		    			}
	    			}
	    		}
	    	}
	    	var dataStoreNode={
		            title: "数据集",
		            key: "dataStoreVO",
		            isFolder: true,
			        expand: true,
			        children:dataStoreVOs
			};
	    	
	    	expressAttrSelectTreeData[0].children.push(pageAttributeNode);
	    	expressAttrSelectTreeData[0].children.push(rightsVariableNode);
	    	expressAttrSelectTreeData[0].children.push(environmentVariableNode);
	    	expressAttrSelectTreeData[0].children.push(dataStoreNode);
	    }
	    
	    function loadEnvironmentVariableVOList(){
	    	var result=[];
    		var page = pageSession.get("page");
			var includeFileList=page.includeFileList;
			var filePaths=[];
			for(var i=0;i<includeFileList.length;i++){
				filePaths.push(includeFileList[i].filePath);
			}
			dwr.TOPEngine.setAsync(false);
    		EnvironmentVariablePreferenceFacade.queryListByFileName(filePaths,function(data){
    			if(data!=null){
    				result=data;
    			}
    		});
    		dwr.TOPEngine.setAsync(true);
    		return result;
    	}
	    
	    //监听数据集变化
	    function watchPageConstantChange(){
	    	cap.addObserve(page,watchPageConstantChange);
	    	initExpressAttrSelectTree();
    		cui("#expressAttrSelectTreeData").setDatasource(expressAttrSelectTreeData);
		}
	    cap.addObserve(page,watchPageConstantChange);
	    
	    //监听数据集变化
	    function watchDataStoreChange(){
	    	cap.addObserve(dataStore,watchDataStoreChange);
	    	initExpressAttrSelectTree();
    		cui("#expressAttrSelectTreeData").setDatasource(expressAttrSelectTreeData);
		}
	    cap.addObserve(dataStore,watchDataStoreChange);
	    
	    //拿到angularJS的scope
	    var scope=null;
	    var hasSetState = false;
	    angular.module('SetJsExpressionState', ["cui"]).controller('jsExpressionStateCtrl',['$scope', function ($scope) {
	    	$scope.root=root;
			
	    	//从设计器传过来的需要设置的UI的状态.默认都校验
	    	$scope.component = {"UIstate" : state,"needValidate":true};
	    	//遍历看是否有可供选择的表达式
	    	var hasSelectable = false; //默认没有可供选择的表达式
	    	//设置状态看是否有js表达式可选
	    	for(var k = 0; k < root.expressions.length; k++){
	    		if(root.expressions[k].expressionType == 'js'){
	    			hasSelectable = true;
	    			break;
	    		}
	    	}
	    	
	    	//改变“控件状态”的radioGroup，“是否验证”的radioGroup联动
	    	$scope.UIstateChange = function(_state) {
	    		$scope.component.needValidate = _state =='edit' ? 'true' : 'false';
	    	}
	    	
	    	//如果需要设置的状态为“编辑”，则默认选中“校验”；否则默认选中“不校验”
	    	$scope.UIstateChange($scope.component.UIstate);
	    	
	    	//初始化设置UI状态的模式（选择表达式 or 设计表达式）。true：选择表达式；false：设计表达式
		    $scope.chooseExpression = true;
	    	
	    	$scope.ready=function(){
		    	comtop.UI.scan();
		    	scope=$scope;
		    }
	    	
	    	//页面显示的数据集合
 	    	$scope.showItems={'itemsArray':[]};
	    	
	    	//声明变量来控制表格的多选、全选、反选。初始化全选为false
	 		$scope.check = {'chkAll':false,'chkItem':[]};
	 		//初始化check.chkItem数组。只初始化一次。数组的元素个数与显示的数据有多少行一致。全部初始化为false。
			$scope.initChkItem=function(){
				//如果当前有数据，并且check.chkItem数组里面没值，则对check.chkItem进行初始化。下次进来则不再初始化（只初始化一次）。（如果页面列表的数据发生变化，而页面又没刷新的话，则需要重新初始化。）
				if($scope.check.chkItem.length==0 && $scope.showItems.itemsArray.length>0){
					for(var i=0;i<$scope.showItems.itemsArray.length;i++){
						//把每行数据的checkbox都初始化为false（未选中状态）
						$scope.check.chkItem[i]=false;
					}
				}
				
			}
	 		
			//定义一个选中的表达式的数组
	    	$scope.selectExpressionVO = [];
	 		
			/**
			 * 点击单条数据的checkbox
			 *
			 * @param vo 当前行的数据
			 * @param chkflag 当前行点击之前的选中状态
			 * @param index 当前行的索引号
			 *
			 */
			$scope.clickItem = function(vo,chkflag,index){
				$scope.initChkItem();
				
				$scope.check.chkItem[index] = !chkflag;
				//当前选中就去做判断是否所有都选中，若是，则全选设为选中。
				//当前取消选中，则直接把全选设为不选中
				if(!$scope.check.chkItem[index]){
					$scope.check.chkAll = false;
					//取消表达式选中，就把表达式从数组中移除
	    			for(var i = 0; i < $scope.selectExpressionVO.length; i++){
	    				if($scope.selectExpressionVO[i].expressionId == vo.expressionId){
	    					$scope.selectExpressionVO.splice(i,1);
	    					break;
	    				}
	    			}
				}else{
					//判断选中一条记录后，所有的记录是否全都是选中状态，是则把全选设为选中状态。
					var isAllChecked = true;
					for(var i=0;i<$scope.check.chkItem.length;i++){
						if(!$scope.check.chkItem[i]){
							isAllChecked = false;
							break;
						}
					}
					if(isAllChecked){
						$scope.check.chkAll = true;
					}
					//选中表达式，就把表达式加到数组中 
					$scope.selectExpressionVO.push(vo);
				}
			}
			
			/**
			 * 全选和全反选
			 * 
			 * @param flag 全选checkbox点击之后的状态
			 */
			$scope.clickAllObj=function(flag){
				$scope.initChkItem();
				for(var i=0;i<$scope.check.chkItem.length;i++){
					$scope.check.chkItem[i]=flag;
				}
				if(flag){
					$scope.selectExpressionVO=$scope.showItems.itemsArray;
				}else{
					$scope.selectExpressionVO=[];
				}
			}
	    	
	    	var newExpression={expressionId:(new Date()).valueOf(), expression:'', expressionType:'js', hasSetState:true, pageComponentStateList:[]};
	    	$scope.addExpression=function(){
	    		$scope.expressionVO=newExpression;
	    	}
	    	
	    	//在“选择表达式”与“设计表达式”两种模式中切换
	    	$scope.changeSetModel = function() {
	    		$scope.chooseExpression = $scope.chooseExpression == true ? false : true;
	    		//若为“设计表达式”模式
	    		if(!$scope.chooseExpression){
	    			$scope.addExpression();
	    		}
	    	}
	    	
	    	//关闭窗口
	    	$scope.stateDialogClose = function(){
	    		window.parent.cuiClose();
	    	}
	    	
	    	//点击确认按钮
	    	$scope.confirm=function (){
	    		//判断当前设置状态的模式（选择表达式 or 设计表达式）
	    		if($scope.chooseExpression){ 
	    			//选择表达式
	    			if($scope.selectExpressionVO.length == 0){
	    				cui.alert(!hasSelectable ? "没有可供选择的表达式。" : "请选择表达式。");
	    				return;
	    			} else{
	    				//获取缓存中的需要设置状态的UI。
	    				var UIObjArray = pageSession.get("setJsExpressionState");
	    				//把UI设置到表达式数组中的每个表达式中。
	    				$scope.getSelectData(UIObjArray,$scope.selectExpressionVO);
	    				//页面关闭前把缓存中的UI组件移除
	    				//pageSession.remove("setJsExpressionState");
	    				delete window.parent[pageId+'setJsExpressionState'];
	    				$scope.stateDialogClose(); //确认操作完毕后，关闭窗口
	    			}
	    		}else{
	    			//设计表达式
	    			var msg =  new cap.Validate().validateAllElement($scope.expressionVO,{expression:expressionValRule});;
	    			if(msg.validFlag){ //验证通过
	    				//获取缓存中的需要设置状态的UI。
	    				var UIObjArray = pageSession.get("setJsExpressionState");
	    				//把UI设置到表达式数组中的每个表达式中。
	    				var _expressionArray = [$scope.expressionVO];
	    				$scope.getSelectData(UIObjArray,_expressionArray);
	    				//判断缓存中是否已存在此表达式
						var isContains = false;
						for(var i = 0; i < $scope.root.expressions.length; i++){
							if($scope.root.expressions[i].expressionId == $scope.expressionVO.expressionId){
								isContains = true;
								break;
							}
						}
						//如果缓存中之前不存在此表达式，则把表达式放到缓存中。
						if(!isContains){
							$scope.root.expressions.push($scope.expressionVO);
						}
						//页面关闭前把缓存中的UI组件移除
						//pageSession.remove("setJsExpressionState");
						delete window.parent[pageId+'setJsExpressionState'];
						$scope.stateDialogClose(); //确认操作完毕后，关闭窗口
	    			}else{
	    				cui.alert(msg.message);
	    				return;
	    			}
	    		}
	    	}
	    	
	    	/**
	    	 * 把UI设置到表达式中.
	    	 * @UIObjArray UI对象的数组
	    	 * @_expression 选中的表达式的数组或新设计的表达式的数组
	    	 */
	    	$scope.getSelectData = function(UIObjArray,_expression) {
	    		if(UIObjArray == null || UIObjArray.length == 0){
	    			return;
	    		}
	    		//循环遍历选中的表达式的数组或新设计的表达式的数组，把每个UI设置到表达式数组中的每个表达式中
	    		for(var n = 0; n < _expression.length; n++){
			    	//循环把设计器传过来的UI对象设到表达式中
			    	for(var i = 0; i < UIObjArray.length; i++) {
			    		var UIObj = UIObjArray[i];
			    		
			    		var pageComponentStateList = _expression[n].pageComponentStateList;
		    			var pageComponentStateVO = {componentId:UIObj.id, cname:UIObj.options.label, ename:UIObj.options.name == undefined ? UIObj.options.uitype : UIObj.options.name, state: $scope.component.UIstate, hasValidate:eval($scope.component.needValidate)};
			    		//判断表达式中是否已存在该UI，如果存在，则update该UI，否则add该UI。
		    			var isAdd = true;
				    	for(var j = 0; j < pageComponentStateList.length; j++) {
				    		if(pageComponentStateList[j].componentId == UIObj.id) {
				    			pageComponentStateList[j]=pageComponentStateVO;
				    			isAdd = false;
				    			break;
				    		}
				    	}
			    		if(isAdd) {
			    			pageComponentStateList.push(pageComponentStateVO);
			    		}
			    	}
	    		}
	    	}
	    	
        }]);
	    
	    //设计表达式时的校验
	    var expressionValRule = [{'type':'required', 'rule':{'m': '表达式不能为空。'}}];
	    
	  	//双击“表达式变量”树节点，为“表达式”框设置变量名称
	    function insertExpression(node){
	    	scope.expressionVO.expression = scope.expressionVO.expression + getExpressionStr(node);
	    	scope.$digest();
	    	cui("#expressionInput").focus();
	    }
	  	
	    /**
	  	 * 根据当前双击的node，获取表达式的字符串
	  	 *
	  	 * @param 当前点击的node
	  	 */
	  	function getExpressionStr(node){
	  		//点击非数据集节点返回的字符串
	  		var noOperateStr = node.getData().key;
	  		//点击数据集节点及其子节点返回的字符串
	  		var str=node.getData().key;
	  		//当前点击的节点是否为数据集
			var flag = node.getData().key == "dataStoreVO" ? true : false;
	  		//获取当前节点的父节点
			var parentNode = node.parent();
	  		//开始遍历所有父节点（往上遍历父节点）
	  		while(!flag && parentNode.getData().key != '_1'){
	  			//如果碰到数据集节点，则把flag改为true，从而结束循环
	  			if(parentNode.getData().key == 'dataStoreVO'){
	  				flag = true;
	  			}else{ //如果遍历的节点不是父节点，则开始拼字符串
	  				str = parentNode.getData().key+"."+str;	
	  			}
	  			//获取遍历节点的父节点
	  			parentNode = parentNode.parent();
	  		}
	  		//最后看经过处理之后，是否碰到了数据集节点，如果没有，直接返回noOperateStr，否则返回经过处理拼接的字符串
	  		return flag ? str : noOperateStr;
	  	}

    </script>
</head>
<body style="background-color:#f5f5f5;" ng-controller="jsExpressionStateCtrl"  data-ng-init="ready()">
<div class="cap-page">
	<div class="cap-area" style="width:100%;">
		<div style="text-align: right;padding-right: 4px;padding-top: 5px;">
			  <span uitype="button" id="confirm"  button_type="blue-button" label="确定" ng-click="confirm()"></span>  
			  <span uitype="button" id="close"  label="关闭" ng-click="stateDialogClose()"></span>
		</div>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;width:400px;vertical-align: top">
		        	<table class="cap-table-fullWidth">
					    <tr>
					        <td  class="cap-form-td" style="text-align: left;" colspan="2">
								<span>控件状态：</span>
					        	<span cui_radiogroup id="UIstate" name="UIstate" ng-change="UIstateChange(component.UIstate)" ng-model="component.UIstate">
									<input type="radio" name="UIstate" value="edit" />编辑
									<input type="radio" name="UIstate" value="readOnly" />只读
									<input type="radio" name="UIstate" value="hide" />隐藏
								</span>								
					        </td>
					    </tr>
					    <tr>
					        <td  class="cap-form-td" style="text-align: left;" colspan="2">
								<table class="cap-table-fullWidth">
									<tr>
										<td>
											<span>是否校验：</span>
								        	<span cui_radiogroup id="needValidate" name="needValidate" ng-model="component.needValidate">
												<input type="radio" name="needValidate" value="true" />是
												<input type="radio" name="needValidate" value="false" />否
											</span>
										</td>
										<td style="text-align: right;">
											<a href="#" ng-model="chooseExpression" ng-click="changeSetModel()" style="text-decoration:underline;font-style: italic;font-size:1px;padding-right:4px" >{{chooseExpression==true?"设计表达式":"选择表达式"}}</a>
										</td>
									</tr>
								</table>
					        </td>
					    </tr>
					    <tr ng-if="chooseExpression">
					    	<td class="cap-form-td" colspan="2">
					            <table class="custom-grid" style="width: 100%" >
					                <thead>
					                    <tr>
					                    	<th style="width:30px">
					                    		<input type="checkbox"  ng-click="check.chkAll=!check.chkAll;clickAllObj(check.chkAll)"  ng-checked="check.chkAll" style="cursor:pointer"/>
					                        </th>
					                        <th>
				                            	表达式
					                        </th>
					                        <th style="width:80px">
				                            	类型
					                        </th>
					                    </tr>
					                </thead>
			                        <tbody>
			                            <tr ng-repeat="expressionVo in showItems.itemsArray=(root.expressions | filter:{'expressionType':'js'}) track by $index"  style="background-color: {{check.chkItem[$index] ? '#99ccff':'#ffffff'}}">
			                            	<td style="text-align: center;">
			                                    <input type="checkbox" id="{{'expression'+($index + 1)}}" name="{{'expression'+($index + 1)}}" ng-click="clickItem(expressionVo,check.chkItem[$index]==undefined?false:check.chkItem[$index],$index)" ng-checked="check.chkItem[$index]" style="cursor:pointer"/>
			                                </td>
			                                <td style="text-align:left;cursor:pointer" ng-click="clickItem(expressionVo,check.chkItem[$index]==undefined?false:check.chkItem[$index],$index)">
			                                    {{expressionVo.expression}}
			                                </td>
			                                <td style="text-align: center;">
			                                    {{expressionVo.expressionType}}
			                                </td>
			                            </tr>
			                       </tbody>
					            </table>
					    	</td>
					    </tr>
					    <tr ng-hide="chooseExpression">
					        <td class="cap-form-td" style="text-align: left;" colspan="2">
					        	<span cui_input  id="expressionInput" ng-model="expressionVO.expression" width="100%" emptytext="请输入表达式" validate="expressionValRule"></span>
					        </td>
						</tr>
					</table>
		        </td>
		        <td style="text-align: left;border-right:1px solid #ddd;padding-left:5px;width: 1px;" ng-if="!chooseExpression">
		        </td>
		        <td class="cap-td" style="text-align: left;width:200px" ng-if="!chooseExpression"><!-- ng-hide="chooseExpression" -->
		        	<table class="cap-table-fullWidth">
					    <tr>
					        <td class="cap-form-td" style="text-align: left;padding-bottom: 10px">
					        	<div id="scanTreeDiv">
						        	<span id="expressAttrSelectTreeData" uitype="Tree" children="expressAttrSelectTreeData" click_folder_mode="1" on_dbl_click="insertExpression"></span>
						        	<script type="text/javascript">
						        		//局部扫描生成树
						        		initExpressAttrSelectTree(); //组装树需要的各个节点的数据
						        		comtop.UI.scan('#scanTreeDiv'); //扫描生成树
									</script>
								</div>
					        </td>
					    </tr>
					</table>
		        </td>
		    </tr>
		</table>
	</div>
</div>
</body>
</html>