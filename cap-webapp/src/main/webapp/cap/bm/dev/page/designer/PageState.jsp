<%
/**********************************************************************
* 控件状态
* 2015-5-27 郑重 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app='pageState'>
<head>
    <meta charset="UTF-8">
    <title>控件状态</title>
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
	<top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src='/cap/dwr/interface/EnvironmentVariablePreferenceFacade.js'></top:script>
    <script type="text/javascript">
    
	    var pageId="<%=request.getParameter("modelId")%>";
	    var packageId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
	    var globalReadState=eval(<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("globalReadState"))%>);
	    var pageSession = new cap.PageStorage(pageId);
	    var expressions=pageSession.get("expression");
	    
	    var root={
	    	expressions:expressions	
	    }
	    
	  	//监听变量变化后自动保存
	    function watchExpressions(){
	    	cap.addObserve(root,watchExpressions);
	    	cap.digestValue(scope);
    	}
	    cap.addObserve(root,watchExpressions); 
	    
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
	    	var page = pageSession.get("page");
	    	var pageAttributeVOList=page.pageAttributeVOList;
	    	var dataStore = pageSession.get("dataStore");
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
			var expressionTypeValue = 'java';
    		EnvironmentVariablePreferenceFacade.queryListByFileName(filePaths,expressionTypeValue,function(data){
    			if(data!=null){
    				result=data;
    			}
    		});
    		dwr.TOPEngine.setAsync(true);
    		return result;
    	}
	    
	    function messageHandle(e) {
	    	if(e.data.type=="pageAttributeChange"){
	    		initExpressAttrSelectTree();
	    		//判断是否有prototype上是否有esetDatasource方法
	    		if('setDatasource' in cui("#expressAttrSelectTreeData")){
	    			cui("#expressAttrSelectTreeData").setDatasource(expressAttrSelectTreeData);
	    		}
	    	}
	    	
	    	//处理设计器删除控件发送过来的通知
	    	if(e.data.type=="delUIChange"){
	    		//从设计器传过来的需要删除的控件ID的数组
	    		var _delUIArray=e.data.data;
	    		//记录哪些表达式中应该要删除哪些控件
	    		var _recordArray = [];
	    		//找出哪些表达式应该删除哪些控件
	    		for(var i = 0; i < root.expressions.length; i++){
	    			var _exprObj = root.expressions[i];
	    			for(var j = 0; j < _exprObj.pageComponentStateList.length; j++){
	    				var _uiObj = _exprObj.pageComponentStateList[j];
	    				for(var m = 0; m < _delUIArray.length; m++){
	    					if(_uiObj.componentId == _delUIArray[m]){
	    						_recordArray.push({'expressionId':_exprObj.expressionId,'componentId':_delUIArray[m]});
	    					}
	    				}
	    			}
	    		}
	    		
	    		//遍历所有表达式，对表达式应该删除的控件进行删除
	    		for(var n = 0; n < root.expressions.length; n++){
	    			var iteratorExpression = root.expressions[n];
	    			for(var m = 0; m < _recordArray.length; m++){
	    				//当表达式的id与传进来的表达式ID一样，则进行移除处理
    					if(iteratorExpression.expressionId == _recordArray[m].expressionId){
    						//循环这个表达式的所有控件，找出需要移除的控件在数组中的位置。然后移除
    						for(var k = 0; k < iteratorExpression.pageComponentStateList.length; k++){
    							if(iteratorExpression.pageComponentStateList[k].componentId == _recordArray[m].componentId){
    								//移除
    								iteratorExpression.pageComponentStateList.splice(k,1);
    								break;
    							}
    						}
    					}
	    			}
	    		}
	    		scope.$digest();
	    	}
	    }
	    window.addEventListener("message", messageHandle, false);
	    
	    var _chooseUIDialog; //选择控件的弹出框
	    
	    //拿到angularJS的scope
	    var scope=null;
	    var hasSetState = false;
	    angular.module('pageState', ["cui"]).controller('pageStateCtrl',['$scope', '$timeout', function ($scope, $timeout) {
	    	$scope.root=root;
	    	$scope.expressionsCheckAll=false;
	    	$scope.selectExpressionVO=root.expressions.length>0?root.expressions[0]:{};
	    	hasSetState = $scope.selectExpressionVO.hasSetState;
	    	//表达式过滤关键字
	    	$scope.expressionFilter="";
	    	
	    	$scope.ready=function(){
	    		$scope.resizePageHeight();
	    		initExpressAttrSelectTree();
		    	comtop.UI.scan();
		    	$scope.setReadonlyAreaState(globalReadState);
		    	scope=$scope;
		    }
	    	
	    	$scope.resizePageHeight=function(){
		    	$(".cap-page").css("height", $(window).height()-20);
				$(window).resize(function(){//开启监控，第一次初始化时，不会进入此方法
			       jQuery(".cap-page").css("height", $(window).height()-20);
			    });
		    }
	    	
	    	/**
			 * 设置区域读写状态
			 * @param globalReadState 状态标识
			 */
			$scope.setReadonlyAreaState=function(globalReadState){
				//设置为控件为自读状态（针对于CAP测试建模）
			   	if(globalReadState){
			    	$timeout(function(){
			    		cap.setReadonlyArea("unReadonlyArea", ["*:not([class^='notUnbind'])"], ["input[type='checkbox'], input[type='button'], input[type='radio']"]);
			    		cui("#expressAttrSelectTreeData").disable();
			    	}, 0);
		    	}
			}
	    	
	    	//选中表达式行
	    	$scope.expressionTdClick=function(expressionVo){
	    		$scope.selectExpressionVO=expressionVo;
	    		hasSetState = $scope.selectExpressionVO.hasSetState;
	    		var expressionTypeValue = $scope.selectExpressionVO.expressionType;
	    		if(expressionTypeValue=="js"){
	    			$scope.selectExpressionVO.hasSetState= true;
	    		}else{
	    			$scope.selectExpressionVO.hasSetState= hasSetState;
	    		}
	    		//设置为控件为自读状态（针对于CAP测试建模）
	    		$scope.setReadonlyAreaState(globalReadState);
		    }
	    	
	    	//监控全选checkbox，如果选择则联动选中列表所有数据
	    	$scope.allCheckBoxCheck=function(ar,isCheck){
	    		if(ar!=null){
	    			for(var i=0;i<ar.length;i++){
		    			if(isCheck && !ar[i].isFilter){
		    				ar[i].check=true;
			    		}else{
			    			ar[i].check=false;
			    		}
		    		}	
	    		}
	    	}
	    	
	    	//表达式类型改变事件
	    	$scope.changeExpressionType = function(){
	    		var expressionTypeValue = cui("#expressionType").getValue();
	    		reloadEnvironmentVariableVOList(expressionTypeValue);
	    		//如果为js，则隐藏设置状态功能，并默认为设置状态
	    		if(expressionTypeValue=="js"){
	    			$scope.selectExpressionVO.hasSetState= true;
	    			cui("#hasSetState").hide();
	    			cui("#setState").hide();
	    		}else{
	    			cui("#hasSetState").show();
	    			cui("#setState").show();
	    			$scope.selectExpressionVO.hasSetState= hasSetState;
	    			
	    			//如果当前改变为java表达式，并且此表达式中存在控件，则进行校验（一个控件只能存在于一个java表达式中）
	    			if( $scope.selectExpressionVO.pageComponentStateList != "undefined" && $scope.selectExpressionVO.pageComponentStateList.length > 0){
	    				var nodes = $scope.selectExpressionVO.pageComponentStateList;
	    				//存放控件存在于其他java表达式的提示信息。
	    	    		var existUIMsg ="以下控件在其他java表达式中已设置：<br/>";
	    				//用于存放其他java表达式存在本次设置的控件的集合。以便从其他表达式中删除这些控件。
	    	    		var existUIArray = [];
	    		    	for(var i=0;i<nodes.length;i++){
	    		    		var node=nodes[i];
	    		    		//
    		    			//检查控件在其他的java表达式中是否存在。遍历所有表达式(除了自己)，看每个表达式中是否存在本次设置的控件。（一个控件只能存在于一个java表达式中）
    		    			for(var n = 0; n < root.expressions.length; n++){
    							var iteratorExpression = root.expressions[n];
    							//是java表达式则去判断,否则不判断
    		    				if(iteratorExpression.expressionType == "java" && iteratorExpression.expressionId != $scope.selectExpressionVO.expressionId){
    		    					//把表达式中每个控件进行遍历，看是否存在本次设置的控件
    		    					for(var m = 0; m < iteratorExpression.pageComponentStateList.length; m++){
    		    						var iteratorUIObj = iteratorExpression.pageComponentStateList[m];
    		    						if(iteratorUIObj.componentId == node.componentId){
    		    							existUIMsg += "控件："+node.cname+"("+node.ename+");"+"表达式："+iteratorExpression.expression+"<br/>";
    		    							existUIArray.push({'expressionId':iteratorExpression.expressionId,'componentId':node.componentId});
    		    						}
    		    					}
    		    				}
    		    			}
	    		    	}
    		    		if(existUIArray.length > 0){
    			    		cui.confirm(existUIMsg+"确定从这些表达式中移除这些控件，并继续本次设置吗？", {
    				            onYes: function () {
    				            	//从其他表达式中移除控件
    				            	removeComponentFromExpression(existUIArray);
    				            	//添加控件到本次选中/设计的表达式中
    				            	//pushUIToExpression(nodes,scope.selectExpressionVO);
    				            	scope.$digest();
    				            },
    				            onNo : function(){
    				            	//取消的话，把java类型设回js类型，cui会自动再触发此change方法，把“设置状态”隐藏
    				            	cui("#expressionType").setValue("js");
    				            }
    				        });
    			    	}
	    			}
	    		}
	    	}
	    	
	    	//监控选中，如果列表所有行都被选中则选中allCheckBox
	    	$scope.checkBoxCheck=function(ar,allCheckBox){
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
	    	
	    	//新增表达式
	    	$scope.addExpression=function(){
	    		cui("#hasSetState").show();
    			cui("#setState").show();
	    		var newExpression={expressionId:(new Date()).valueOf(),checkAll:false,expression:'',expressionType:'js',hasSetState:true,pageComponentStateList:[]};
	    		$scope.selectExpressionVO=newExpression;
	    		$scope.root.expressions.push(newExpression);
	    		$scope.checkBoxCheck($scope.root.expressions,"expressionsCheckAll");
	    	}
	    	
	    	//删除表达式
	    	$scope.deleteExpression=function(){
	    		var deleteArr=[];
	    		var newArr=[];
                var deleteTitle = "";
                var  k=0;
                for(var i=0;i<$scope.root.expressions.length;i++){
                    if($scope.root.expressions[i].check){
                        newArr.push(i);
                        deleteArr.push($scope.root.expressions[i]);
                        k=i+1;
                    	deleteTitle+="第"+ k +"行"+$scope.root.expressions[i].expression+"<br/>";
                    }
                }
                
    			if(deleteArr.length>0){
    				cui.confirm("确定要删除<br/>"+deleteTitle+"这些表达式吗？",{
        				onYes:function(){ 
			                //根据坐标删除数据
			                for(var j=newArr.length-1;j>=0;j--){
			                	 $scope.root.expressions.splice(newArr[j],1);
			                }
			                //如果当前选中的行被删除则默认选择第一行
			                var isSelectIsDelete=true;
			                for(var i=0;i<$scope.root.expressions.length;i++){
			                    if($scope.root.expressions[i].expressionId==$scope.selectExpressionVO.expressionId){
			                        isSelectIsDelete=false;
			                        break;
			                    }
			                }
			                if(isSelectIsDelete){
			                	$scope.selectExpressionVO=$scope.root.expressions[0];
			                }
			                
			                $scope.checkBoxCheck($scope.root.expressions,"expressionsCheckAll");
        				}
        			});
    			}   
	    	}
	    	
	    	//表达式列表过滤
	    	$scope.$watch("expressionFilter",function(){
	    		for(var i = 0, len = $scope.root.expressions.length; i < len; i++){
	    			if($scope.expressionFilter == "" || $scope.root.expressions[i].expression.indexOf($scope.expressionFilter) > -1){
	    				$scope.root.expressions[i].isFilter=false;
	    			}else{
	    				$scope.root.expressions[i].isFilter=true;
	    			}
                }
	    		$scope.checkBoxCheck($scope.root.expressions,"expressionsCheckAll");
	    	});
	    	
	    	//删除控件
	    	$scope.deleteComponent=function(){
	    		var newArr=[];
                for(var i=0;i<$scope.selectExpressionVO.pageComponentStateList.length;i++){
                    if(!$scope.selectExpressionVO.pageComponentStateList[i].check){
                        newArr.push($scope.selectExpressionVO.pageComponentStateList[i])
                    }
                }
		        $scope.selectExpressionVO.pageComponentStateList = newArr;
		        $scope.checkBoxCheck($scope.selectExpressionVO.pageComponentStateList,"selectExpressionVO.pageComponentCheckAll");
	    	}
	    	
	    	//复制选中的表达式
	    	$scope.copyExpression=function(){
	    		for(var i=0;i<$scope.root.expressions.length;i++){
	    	        if($scope.root.expressions[i].check){
	    	        	var newExpression=jQuery.extend(true,{},$scope.root.expressions[i]);
	    	        	newExpression.expressionId=(new Date()).valueOf() + i; // +i 是为了保证ID不一样。
	    	        	newExpression.check = false;
	    	        	//若为java表达式复制，不复制表达式中的控件。因为需要遵循一个控件只能存在于一个表达式中的约束。
	    	        	//js表达式保持深度复制
	    	        	if(newExpression.expressionType == "java"){
	    	        		newExpression.pageComponentStateList = [];
	    	        	}
	    	        	$scope.root.expressions.push(newExpression);
	    	        }
	    	    }
	    		$scope.checkBoxCheck($scope.root.expressions,"expressionsCheckAll");
	    	}
	    	
	    	//从其他页面导入表达式
	    	$scope.openImportExpression=function(){
	    		var top=(window.screen.availHeight-600)/2;
	    		var left=(window.screen.availWidth-800)/2;
	    		window.open ('PageExpressSelect.jsp?packageId='+packageId,'importExpressionWin','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no') 
	    	}
	    	
	    	//打开页面控件选择页面
	    	$scope.openComponentSelect=function(){
	    		if(!$scope.selectExpressionVO.pageComponentStateList){
	    			cui.alert('请先在左边的表达式列表中添加表达式。');
	    			return;
	    		}
	    		//var top=(window.screen.availHeight-600)/2;
	    		//var left=(window.screen.availWidth-500)/2;
	    		var _url = 'PageComponentSelect.jsp?pageId='+pageId+"&selectMode=2";
	    		if(!_chooseUIDialog){
	    			_chooseUIDialog = cui("#chooseUIDialog").dialog({
	    				title:'控件选择',
        		        width:600,
        		        height:500,
        		        src:_url
        	    	});
        	    }
	    		_chooseUIDialog.show(_url);
	    		//window.open ('PageComponentSelect.jsp?pageId='+pageId,'pageComponentSelect','height=600,width=500,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no') 
	    	}
		    
        }]);
	    
	    //关闭选择控件的弹出框
	    function closeDialog(){
	    	_chooseUIDialog.hide();
	    }
	    
	    //导入表达式
	    function importExpression(expressions){
	    	for(var i=0;i<expressions.length;i++){
	    		expressions[i].expressionId=(new Date()).valueOf()+i;
	    		expressions[i].check=false;
	    		scope.root.expressions.push(expressions[i]);
	    	}
	    	scope.$digest();
	    }
	    
	  	//添加表达式关键字
	    function insertExpression(node){
	    	scope.selectExpressionVO.expression=scope.selectExpressionVO.expression+getExpressionStr(node);
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
	  	
	    //导入控件
	    function getSelectData(nodes){
	    	//存放控件存在于其他java表达式的提示信息。
    		var existUIMsg ="以下控件在其他java表达式中已设置：<br/>";
			//用于存放其他java表达式存在本次设置的控件的集合。以便从其他表达式中删除这些控件。
    		var existUIArray = [];
	    	for(var i=0;i<nodes.length;i++){
	    		var node=nodes[i];
	    		
	    		//如果是java表达式，则需要去检测，这次选中的这些控件在其他的java表达式中是否存在
	    		if(scope.selectExpressionVO.expressionType=='java'){
	    			//遍历所有表达式，看每个表达式中是否存在本次设置的控件。（一个控件只能存在于一个java表达式中）
	    			for(var n = 0; n < root.expressions.length; n++){
						var iteratorExpression = root.expressions[n];
						//是java表达式则去判断是否存在本次设置的控件。否则不判断
	    				if(iteratorExpression.expressionType == "java"){
	    					//把表达式中每个控件进行遍历，看是否存在本次设置的控件
	    					for(var m = 0; m < iteratorExpression.pageComponentStateList.length; m++){
	    						var iteratorUIObj = iteratorExpression.pageComponentStateList[m];
	    						if(iteratorUIObj.componentId == node.id){
	    							existUIMsg += "控件："+(node.options.label == undefined ? "" : node.options.label)+"("+(node.options.name == undefined ? node.options.uitype : node.options.name)+");"+"表达式："+iteratorExpression.expression+"<br/>";
	    							existUIArray.push({'expressionId':iteratorExpression.expressionId,'componentId':node.id});
	    						}
	    					}
	    				}
	    			}
	    		}else{  //如果是js表达式，先判断这些控件是否在此js表达式中已存在，存在则update，不存在则add
	    			var state="edit";
		    		var hasValidate=true;
		    		if(node.options.readonly || node.options.disable){
		    			state="readOnly";
		    			hasValidate=false;
		    		}else if(node.options.hide){
		    			state="hide";
		    			hasValidate=false;
		    		}
		    		
	    			var _pageComponentStateList=scope.selectExpressionVO.pageComponentStateList;
	    			var _pageComponentStateVO={componentId:node.id,cname:node.options.label,ename:node.options.name == undefined ? node.options.uitype : node.options.name,state:state,hasValidate:hasValidate};
	    			var isAdd=true;
			    	for(var j=0;j<_pageComponentStateList.length;j++){
			    		if(_pageComponentStateList[j].componentId==node.id){
			    			_pageComponentStateList[j]=_pageComponentStateVO; //存在，则更新
			    			isAdd=false;
			    			break;
			    		}
			    	}
		    		if(isAdd){
		    			_pageComponentStateList.push(_pageComponentStateVO);
		    		}
	    		}
	    	}
	    	//如果当前选中的是java表达式
	    	if(scope.selectExpressionVO.expressionType=='java'){
	    		if(existUIArray.length > 0){
		    		cui.confirm(existUIMsg+"确定从这些表达式中移除这些控件，并继续本次设置吗？", {
			            onYes: function () {
			            	//从其他表达式中移除控件
			            	removeComponentFromExpression(existUIArray);
			            	//添加控件到本次选中/设计的表达式中
			            	pushUIToExpression(nodes,scope.selectExpressionVO);
			            	scope.$digest();
			            	closeDialog();
			            }
			        });
		    	}else{
		    		//如果其他表达式中不存在本次需要设置的控件，那么直接那控件全部设置到本次选择/新增的表达式下即可。
		    		pushUIToExpression(nodes,scope.selectExpressionVO);
		    		scope.$digest();
		    		closeDialog();
		    	}
	    	}else{ //js表达式在上面循环中添加控件完毕，在这里digest
	    		scope.$digest();
	    		closeDialog();
	    	}
	    }
	    
	    /**
    	 * 从表达式中移除相应的控件
    	 *
    	 * @param _exitUIArray 表达式ID和控件ID对象的数组 {'expressionId':xxx,'componentId':xxx}
    	 */
    	function removeComponentFromExpression(_exitUIArray) {
    		//循环所有表达式
    		for(var n = 0; n < root.expressions.length; n++){
    			var iteratorExpression = root.expressions[n];
    			//当是java表达式时才进行处理，因为传进来的参数里面只会是java表达式
    			if(iteratorExpression.expressionType == "java"){
    				for(var m = 0; m < _exitUIArray.length; m++){
    					//当表达式的id与传进来的表达式ID一样，则进行移除处理
    					if(iteratorExpression.expressionId == _exitUIArray[m].expressionId){
    						//循环这个表达式的所有控件，找出需要移除的控件在数组中的位置。然后移除
    						for(var k = 0; k < iteratorExpression.pageComponentStateList.length; k++){
    							if(iteratorExpression.pageComponentStateList[k].componentId == _exitUIArray[m].componentId){
    								//移除
    								iteratorExpression.pageComponentStateList.splice(k,1);
    								break;
    							}
    						}
    					}
    				}
    			}
    		}
    	}
    	 
    	 
    	/**
    	 * 把一批控件加到指定的表达式下
    	 *
    	 * @param _uiArray 一批控件的数组
    	 * @param _expression 指定的表达式
    	 */
    	function pushUIToExpression(_uiArray,_expression) {
    		for(var t = 0; t < _uiArray.length; t++) {
        		var UIObj = _uiArray[t];
        		
        		var state="edit";
        		var hasValidate=true;
	    		if(UIObj.options.readonly || UIObj.options.disable){
	    			state="readOnly";
	    			hasValidate=false;
	    		}else if(UIObj.options.hide){
	    			state="hide";
	    			hasValidate=false;
	    		}
	    		
        		//如果是设置加载条件（即_hasSetState=false），则UI的state以及hasValidate分别默认为edit和true
    			var pageComponentStateVO = {componentId:UIObj.id, cname:UIObj.options.label, ename:UIObj.options.name == undefined ? UIObj.options.uitype : UIObj.options.name, state: state, hasValidate: hasValidate};
    			_expression.pageComponentStateList.push(pageComponentStateVO);
        	}
    	}
	    
	    //验证规则
	    var expressionValRule = [{'type':'required', 'rule':{'m': '表达式不能为空'}}];
	    
	    //统一校验函数
		function validateAll(){
	    	var validate = new cap.Validate();
	    	var validateRule = {expression:expressionValRule};
			return validate.validateAllElement(scope.root.expressions, validateRule, '&diams;表达式列表->第【{value}】行：');
		}
	    
	    function reloadEnvironmentVariableVOList(expressionType){
	    	var result=[];
    		var page = pageSession.get("page");
    		var expressionTypeValue =expressionType;
			var includeFileList=page.includeFileList;
			var filePaths=[];
			for(var i=0;i<includeFileList.length;i++){
				filePaths.push(includeFileList[i].filePath);
			}
			dwr.TOPEngine.setAsync(false);
    		EnvironmentVariablePreferenceFacade.queryListByFileName(filePaths,expressionTypeValue,function(data){
    			if(data!=null){
    				result=data;
    				var environmentVariableNodeArr=[];
    		    	for(var i=0;i<result.length;i++){
    		    		var environmentVariableVO =result[i];
    		    		environmentVariableNodeArr.push({
    		                title: environmentVariableVO.attributeName,
    		                key: environmentVariableVO.attributeName
    		            });
    		    	}
    				var treeData = expressAttrSelectTreeData[0].children;
    				for(var i = 0;i<treeData.length;i++){
    					if("environmentVariableVO"==treeData[i].key){
	    					treeData[i].children=environmentVariableNodeArr;
	    					cui("#expressAttrSelectTreeData").setDatasource(expressAttrSelectTreeData);
    					}
    				}
    			}
    		});
    		dwr.TOPEngine.setAsync(true);
    	 }
    </script>
</head>
<body style="background-color:#f5f5f5;" ng-controller="pageStateCtrl" data-ng-init="ready()">
<div class="cap-page">
	<div class="cap-area" style="width:100%; height: 100%; overflow-y: auto">
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        	<span id="formTitle" uitype="Label" value="控件状态设计" class="cap-label-title" size="12pt"></span>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth" style="width:100%; height: 95%;">
		    <tr>
		        <td class="cap-td" style="text-align: left;width:400px;vertical-align: top">
		        	<table class="cap-table-fullWidth">
					    <tr>
					        <td  class="cap-form-td" style="text-align: left;" colspan="2">
								<span class="cap-group">表达式列表</span>
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-form-td" style="text-align: left;width：155px;">
					        	<span cui_input  id="expressionFilter" ng-model="expressionFilter" width="150px" emptytext="请输入过滤条件"></span>
					        </td>
					        <td class="cap-form-td" style="text-align: right;">
					        	<span cui_button id="addExpression"  label="新增" ng-click="addExpression()"></span>
					        	<span cui_button id="copyExpression" label="复制" ng-click="copyExpression()"></span>
					        	<span cui_button id="openImportExpression"  label="导入表达式" ng-click="openImportExpression()"></span>
					        	<span cui_button id="deleteExpression"  label="删除" ng-click="deleteExpression()"></span>
					        </td>
					    </tr>
					    <tr>
					    	<td class="cap-form-td" colspan="2">
					            <table class="custom-grid" style="width: 100%">
					                <thead>
					                    <tr>
					                    	<th style="width:30px">
					                    		<input type="checkbox" name="expressionsCheckAll" ng-model="expressionsCheckAll" ng-change="allCheckBoxCheck(root.expressions,expressionsCheckAll)">
					                        </th>
					                        <th>
				                            	表达式
					                        </th>
					                        <th style="width:50px">
				                            	类型
					                        </th>
					                    </tr>
					                </thead>
			                        <tbody>
			                            <tr ng-repeat="expressionVo in root.expressions track by $index" ng-hide="expressionVo.isFilter" style="background-color: {{selectExpressionVO.expressionId==expressionVo.expressionId ? '#99ccff':'#ffffff'}}">
			                            	<td style="text-align: center;">
			                                    <input type="checkbox" name="{{'expression'+($index + 1)}}" ng-model="expressionVo.check" ng-change="checkBoxCheck(root.expressions,'expressionsCheckAll')">
			                                </td>
			                                <td style="text-align:left;cursor:pointer" class="notUnbind" ng-click="expressionTdClick(expressionVo)">
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
					</table>
		        </td>
		        <td style="text-align: center;border-left:1px solid #ddd;padding-left:5px;vertical-align:middle">
		        	<span style="opacity: 0.2;font-size:18px" ng-if="!selectExpressionVO.expressionId">请新增表达式</span>
		        </td>
		        <td class="cap-td" style="text-align: left;vertical-align: top" ng-show="selectExpressionVO.expressionId">
		        	<table class="cap-table-fullWidth">
					    <tr>
					        <td class="cap-form-td" style="text-align: left;">
								<span class="cap-group">表达式设计</span>
					        </td>
					    </tr>
					    <tr>
					        <td  style="text-align: left;">
						        <table class="cap-table-fullWidth">
								    <tr>
								        <td class="cap-form-td" style="text-align: left;">
								        	<span cui_radiogroup id="expressionType" name="expressionType" ng-change="changeExpressionType()" ng-model="selectExpressionVO.expressionType">
												<input type="radio" name="expressionType" value="java" />java表达式
												<input type="radio" name="expressionType" value="js" />js表达式
											</span>
								        </td>
								    </tr>
								    <tr>
								        <td class="cap-form-td" style="text-align: left;" colspan="2">
								        	<span cui_input  id="expressionInput" ng-model="selectExpressionVO.expression" width="100%" emptytext="请输入表达式（java表达式参考jstl表达式语法编写）" validate="expressionValRule"></span>
								        </td>
								    </tr>
								    <tr>
								        <td class="cap-form-td" style="text-align: left;">
								        	<span class="cap-group">控件列表</span>
								        </td>
								        <td class="cap-form-td" style="text-align: right;">
								        	<div id="chooseUIDialog"></div>
								        	<span ng-hide="selectExpressionVO.expressionType == 'js'" id="setState" uiType="Label" value="设置状态："></span>
								        	<input ng-hide="selectExpressionVO.expressionType == 'js'"  id="hasSetState" type="checkbox" name="hasSetState" ng-model="selectExpressionVO.hasSetState">
				                            <span cui_button id="addComponent"  label="添加控件" ng-click="openComponentSelect()"></span>
								        	<span cui_button id="deleteComponent" label="删除" ng-click="deleteComponent()"></span>
								        </td>
								    </tr>
								    <tr>
								    	<td class="cap-form-td" style="text-align: left;" colspan="2">
								    		<table class="custom-grid" style="width: 100%">
								                <thead>
								                    <tr>
								                    	<th style="width:30px">
							                            	<input type="checkbox" name="pageComponentCheckAll" ng-model="selectExpressionVO.checkAll" ng-change="allCheckBoxCheck(selectExpressionVO.pageComponentStateList,selectExpressionVO.checkAll)">
								                        </th>
								                        <th>
							                            	控件名称
								                        </th>
								                        <th ng-show="selectExpressionVO.hasSetState">
							                            	状态
								                        </th>
								                        <th style="width:85px" ng-show="selectExpressionVO.hasSetState">
							                            	是否校验
								                        </th>
								                    </tr>
								                </thead>
						                        <tbody>
						                            <tr ng-repeat="pageComponentStateVo in selectExpressionVO.pageComponentStateList">
						                            	<td style="text-align: center;">
						                                    <input type="checkbox" name="{{'componentCheck'+($index + 1)}}" ng-model="pageComponentStateVo.check" ng-change="checkBoxCheck(selectExpressionVO.pageComponentStateList,'selectExpressionVO.checkAll')">
						                                </td>
						                                <td style="text-align:left;" ng-click="pageComponentStateVo.check=!pageComponentStateVo.check;checkBoxCheck(selectExpressionVO.pageComponentStateList,'selectExpressionVO.checkAll')">
						                                    	{{pageComponentStateVo.cname}}({{pageComponentStateVo.ename}})
						                                </td>
						                                <td style="text-align: center;" ng-show="selectExpressionVO.hasSetState">
						                                    <input type="radio" name="{{'state'+($index + 1)}}"  value="hide" ng-model="pageComponentStateVo.state" ng-change="pageComponentStateVo.hasValidate=false">隐藏
						                                    <input type="radio" name="{{'state'+($index + 1)}}" value="readOnly" ng-model="pageComponentStateVo.state" ng-change="pageComponentStateVo.hasValidate=false">只读
						                                    <input type="radio" name="{{'state'+($index + 1)}}" value="edit" ng-model="pageComponentStateVo.state" ng-change="pageComponentStateVo.hasValidate=true">编辑
						                                </td>
						                                <td style="text-align: center;" ng-show="selectExpressionVO.hasSetState">
						                                    <input type="checkbox" name="{{'hasValidate'+($index + 1)}}" ng-model="pageComponentStateVo.hasValidate" > <!-- ng-disabled="pageComponentStateVo.state=='hide' || pageComponentStateVo.state=='readOnly'" -->
						                                </td>
						                            </tr>
						                       </tbody>
								            </table>
								    	</td>
								    </tr>
								    <tr>
								        <td class="cap-form-td" style="text-align: left;" colspan="2">
									        <span id="remark" style="font-weight:bold;color:red ">说明：</span>
									        <span id="remarkContent" style="font-weight:bold;">控件处于隐藏、只读状态时默认不进行校验</span>
								        </td>
								    </tr>
								</table>
					        </td>
					    </tr>
					</table>
		        </td>
		        <td  style="text-align: left;border-left:1px solid #ddd;padding-left:5px" ng-show="selectExpressionVO.expressionId">
		        </td>
		        <td class="cap-td" style="text-align: left;width:200px" ng-show="selectExpressionVO.expressionId">
		        	<table class="cap-table-fullWidth">
					    <tr>
					        <td class="cap-form-td" style="text-align: left;padding-bottom: 10px">
					        	<span id="expressAttrSelectTreeData" uitype="Tree" children="expressAttrSelectTreeData" click_folder_mode="1" on_dbl_click="insertExpression"></span>
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