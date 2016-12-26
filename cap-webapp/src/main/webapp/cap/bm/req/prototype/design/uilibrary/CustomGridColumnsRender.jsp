<%
/**********************************************************************
* GridTable属性
* 2015-05-07 诸焕辉  
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app='customGridColumnsRender'>
<head>
	<title>渲染指定列数据</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
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
	<top:script src="/cap/bm/common/lodash/js/lodash.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cip_common.js"></top:script>
	<top:script src="/cap/bm/req/prototype/js/common.js"></top:script>
    <top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src="/cap/dwr/interface/ComponentFacade.js"></top:script>
</head>
<body ng-controller="customGridColumnsRenderCtrl" data-ng-init="ready()">
<div>
	<div class="cap-area">
		<table class="cap-table-fullWidth">
			<tr>
				<td class="cap-td" style="text-align: left; padding-bottom:5px" nowrap="nowrap">
		        	渲染方式 ：&nbsp;&nbsp;<span cui_pulldown id="render" ng-model="render" value_field="id" label_field="text" datasource="initRenderData"></span>
		        </td>
		        <td class="cap-td" style="text-align: right; padding-bottom:5px">
		        	<span cui_button id="saveButton" ng-click="save()" label="确定"></span>
		        </td>
		    </tr>
		    <tr style="border-top:1px solid #ddd;">
		        <td class="cap-td" style="text-align: center; padding: 2px; width: 30%;" colspan="2">
	        		<table class="cap-table-fullWidth" style="width: 100%;" ng-if="render == 'a'">
	                    <tr>
	                    	<td class="cap-td" style="text-align:right; width:100px">
	                    		链接地址：
	                        </td>
	                        <td class="cap-td" style="text-align:left;">
	                    		<span cui_clickinput id="title" name="title" on_iconclick="openSelectUrl" ng-model="options.url" width="100%"></span>
	                         </td>
	                    </tr>
	                    <tr>
	                        <td class="cap-td" style="text-align:right;">
                            	参数：
	                        </td>
	                        <td class="cap-td" style="text-align:left;">
                            	<span cui_input id="params" name="params" ng-model="options.params" width="100%"></span>
	                        </td>
	                    </tr>
	                    <tr>
	                        <td class="cap-td" style="text-align:right;">
                            	打开方式：
	                        </td>
	                         <td class="cap-td" style="text-align:left;">
                            	<span cui_pulldown id="targets" name="targets" ng-model="options.targets" value_field="id" label_field="text" width="100%">
									<a value="_blank">_blank</a>
									<a value="_self">_self</a>
									<a value="_parent">_parent</a>
									<a value="_top">_top</a>
								</span>
	                        </td>
	                    </tr>
	                    <tr>
	                        <td class="cap-td" style="text-align:right;">
                            	样式名称：
	                        </td>
	                        <td class="cap-td" style="text-align:left;">
                            	<span cui_input id="className" name="className" ng-model="options.className" width="100%"></span>
	                        </td>
	                    </tr>
	                    <tr>
	                        <td class="cap-td" style="text-align:right;">
                            	回调函数：
	                        </td>
	                        <td class="cap-td" style="text-align:left;">
                            	<span cui_clickinput id="clickEventCallBack" name="clickEventCallBack" ng-click="openSelectAction('clickEventCallBack')" ng-model="options.click" width="100%"></span>
	                        </td>
	                    </tr>
		            </table>
		            <table class="cap-table-fullWidth" style="width: 100%;" ng-if="render == 'button'">
	                    <tr>
	                    	<td class="cap-td" style="text-align:right; width:100px">
	                    		显示的文本：
	                        </td>
	                        <td class="cap-td" style="text-align:left;">
	                    		<span cui_input id="value" name="value" ng-model="options.value" width="100%"></span>
	                        </td>
	                    </tr>
	                    <tr>
	                        <td class="cap-td" style="text-align:right;">
                            	样式名称：
	                        </td>
	                        <td class="cap-td" style="text-align:left;">
                            	<span cui_input id="className" name="className" ng-model="options.className" width="100%"></span>
	                        </td>
	                    </tr>
	                    <tr>
	                        <td class="cap-td" style="text-align:right;">
                            	回调函数：
	                        </td>
	                        <td class="cap-td" style="text-align:left;">
	                            <span cui_clickinput id="clickEventCallBack" name="clickEventCallBack" ng-click="openSelectAction('clickEventCallBack')" ng-model="options.click" width="100%"></span>
	                        </td>
	                    </tr>
		            </table>
		            <table class="cap-table-fullWidth" style="width: 100%;" ng-if="render == 'image'">
	                    <tr>
	                    	<td class="cap-td" style="text-align:right; width:100px">
	                    		图片路径：
	                        </td>
	                        <td class="cap-td" style="text-align:left;">
	                    		<span cui_input id="title" name="title" ng-model="options.url" width="100%"></span>
	                       </td>
	                    </tr>
	                    <tr>
	                        <td class="cap-td" style="text-align:right;">
                            	关联的属性：
	                        </td>
	                        <td class="cap-td" style="text-align:left;">
                            	<span cui_input id="relation" name="relation" ng-model="options.relation" width="100%" readonly="true"></span>
	                        </td>
	                    </tr>
	                    <tr>
	                        <td class="cap-td" style="text-align:right;">
                            	设置图片：
	                        </td>
	                        <td class="cap-td" style="text-align:left;">
                            	<table class="custom-grid" style="width: 100%">
					                <thead>
					                    <tr>
					                        <th style="width:150px">
				                            	属性值
					                        </th>
					                        <th>
				                            	图片地址
					                        </th>
					                        <th style="text-align: center;width:150px">
				                            	<span class="cui-icon" style="font-size:12pt;color:#545454;cursor:pointer;" ng-click="insertCompare()">&#xf067;</span>
					                        </th>
					                    </tr>
					                </thead>
			                        <tbody>
			                            <tr ng-repeat="compare in compareList track by $index" style="background-color: {{compare.check? '#99ccff':'#ffffff'}}">
			                                <td style="text-align:left;">
			                                    <span cui_input id="{{'compareKey'+($index + 1)}}" ng-model="compare.key" width="100%"></span>
			                                </td>
			                                <td style="text-align: center;">
			                                	<span cui_input id="{{'compareValue'+($index + 1)}}" ng-model="compare.value" width="100%"></span>
			                                </td>
			                                <td style="text-align: center;">
			                                	<span class="cui-icon" style="font-size:14pt;cursor:pointer;color:rgb(255, 68, 0)" ng-click="compareList.splice($index,1); ">&#xf00d;</span>
			                                </td>
			                            </tr>
			                       </tbody>
					            </table>
	                        </td>
	                    </tr>
	                    <tr>
	                        <td class="cap-td" style="text-align:right;">
                            	样式名称：
	                        </td>
	                        <td class="cap-td" style="text-align:left;">
                            	<span cui_input id="className" name="className" ng-model="options.className" width="100%"></span>
	                        </td>
	                    </tr>
	                    <tr>
	                        <td class="cap-td" style="text-align:right;">
                            	回调函数：
	                        </td>
	                        <td class="cap-td" style="text-align:left;">
	                            <span cui_clickinput id="clickEventCallBack" name="clickEventCallBack" ng-click="openSelectAction('clickEventCallBack')" ng-model="options.click" width="100%"></span>
	                        </td>
	                    </tr>
	                    <tr>
	                        <td class="cap-td" style="text-align:right;">
                            	提示文字：
	                        </td>
	                        <td class="cap-td" style="text-align:left;">
                            	<table class="custom-grid" style="width: 100%">
					                <thead>
					                    <tr>
					                        <th style="width:150px">
				                            	属性值
					                        </th>
					                        <th>
				                            	提示语
					                        </th>
					                        <th style="text-align: center;width:150px">
				                            	<span class="cui-icon" style="font-size:12pt;color:#545454;cursor:pointer;" ng-click="insertTitle()">&#xf067;</span>
					                        </th>
					                    </tr>
					                </thead>
			                        <tbody>
			                            <tr ng-repeat="title in titleList track by $index" style="background-color: {{compare.check? '#99ccff':'#ffffff'}}">
			                                <td style="text-align:left;">
			                                    <span cui_input id="{{'titleKey'+($index + 1)}}" ng-model="title.key" width="100%"></span>
			                                </td>
			                                <td style="text-align: center;">
			                                	<span cui_input id="{{'titleValue'+($index + 1)}}" ng-model="title.value" width="100%"></span>
			                                </td>
			                                <td style="text-align: center;">
			                                	<span class="cui-icon" style="font-size:14pt;cursor:pointer;color:rgb(255, 68, 0)" ng-click="titleList.splice($index,1); ">&#xf00d;</span>
			                                </td>
			                            </tr>
			                       </tbody>
					            </table>
	                        </td>
	                    </tr>
		            </table>
		            <table class="cap-table-fullWidth" style="width: 100%;" ng-if="render == 'custom'">
			            <tr>
							<td class="cap-td" style="text-align:right; width:100px">
					        	渲染函数 ：
					        </td>
					         <td class="cap-td" style="text-align:left;">
	                            <span cui_clickinput id="customRender" name="customRender" ng-click="openSelectAction('customRender')" ng-model="customRender" width="100%"></span>
	                        </td>
					    </tr>
					</table>
		        </td>
		    </tr>
		</table>
	</div>
</div>

	<script type="text/javascript">
    	var namespaces = "<%=request.getParameter("namespaces")%>";
    	var reqFunctionSubitemId = "<%=request.getParameter("reqFunctionSubitemId")%>";
		var bindName = "<c:out value='${param.bindName}'/>";
		var callbackMethod = "<c:out value='${param.callbackMethod}'/>";
		var render = window.opener.scope.data.render;
		var options = window.opener.scope.data.options;
		options = options!=null && options!='' ? eval("("+options.replace(/'url'\s*:\s*(\w+)/, "'url':'$1'")+")") : {};
		var pageSession = new cap.PageStorage(namespaces);
		var page = pageSession.get("page");
		var pageActions = pageSession.get("action");
		var pageDataStores = pageSession.get("dataStore");
		//系统内置行为数据集
		var queryBuiltInAction = window.opener.opener.queryBuiltInAction;
	    var scope = {};
		angular.module('customGridColumnsRender', ["cui"]).controller('customGridColumnsRenderCtrl', function ($scope, $compile) {
			$scope.render = render != '' ? render: 'a';
			$scope.options = options;
			$scope.compareList=[];
			$scope.titleList=[];
			$scope.ready=function(){
				scope = $scope;
				if(_.size($scope.options) == 0 && $scope.render != 'a'){
					$scope.customRender = $scope.render;
					$scope.render = 'custom';
				}
				if(render === 'image'){
					for(var key in options.compare){
						$scope.compareList.push({key: key, value: options.compare[key]});
					}
					for(var key in options.title){
						$scope.titleList.push({key: key, value: options.title[key]});
					}
				}
				comtop.UI.scan();
	    	}
			
			$scope.init=function(key, obj){
				if(obj.length > 0){
					var jsonStr = '';
					for(var i in obj){
						jsonStr += "'" + obj[i].key + "':'" + obj[i].value + "',";
					}
					if(jsonStr != ''){
						jsonStr = "{" + jsonStr.substring(0, jsonStr.length-1) + "}";
					}
					$scope.options[key] = jsonStr;
				}
	    	};
			
			//保存
			$scope.save=function(){
				var jsonStr = '';
				if($scope.render === 'image'){
					$scope.init('compare', $scope.compareList);
					$scope.init('title', $scope.titleList);
				}
				
				for(var key in $scope.options){
    				if($scope.options[key] == null || $scope.options[key] == ''){
    					if(key === 'relation'){
    						$scope.options[key] = bindName;
    					} else {
	    					delete $scope.options[key];
	    					continue;
    					}
    				}
    				if($scope.options[key] != '' && ((key === 'url' && $scope.render != 'a' && $scope.render != 'image') || key === 'compare' || key === 'title')){
    					jsonStr += "'" + key + "':" + $scope.options[key] + ",";
    				} else {
    					jsonStr += "'" + key + "':'" + $scope.options[key] + "',";
    				}
    			}
				
				if(jsonStr != ''){
					jsonStr = "{" + jsonStr.substring(0, jsonStr.length-1) + "}";
				}
				window.opener[callbackMethod]('render', $scope.render != 'custom' ? $scope.render : cui("#customRender").getValue());
				window.opener[callbackMethod]('options', jsonStr);
				window.close();
			}
			
			$scope.$watch("render", function(newValue, oldValue){
	    		if(newValue != oldValue){
	    			$scope.options = newValue === 'image' ? {relation:bindName} : {};
	    			$scope.compareList=[];
	    			$scope.titleList=[];
	    		}
	    	}, true);
			
			$scope.insertCompare=function(){
				$scope.compareList.push({key:'',value:''});
	    	};
	    	
	    	$scope.insertTitle=function(){
				$scope.titleList.push({key:'',value:''});
	    	}
	    	
	    	$scope.openSelectAction=function(obj){
	    		var url='${pageScope.cuiWebRoot}/cap/bm/dev/page/designer/PageActionSelect.jsp?modelId='+namespaces+'&packageId='+namespaces+"&flag="+obj+"&type=req";
				var width=800; //窗口宽度
				var height=550;//窗口高度
			    var top=(window.screen.height-30-height)/2;
				var left=(window.screen.width-10-width)/2;
				openWindow(url, "pageActionEdit", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
	    	}
	    	
		});
		
		var initRenderData = [
       		{id:'a',text:'超链接'},
       		{id:'button',text:'按钮'},
       		{id:'image',text:'图片'},
       		{id:'custom',text:'自定义'}
       	];
		
		/**
		 * 获取回调函数集合
		 * @param obj 
		 */
		function clickEventCallBackFuncData(obj){
	    	var dataSource = [];
	    	var q = new cap.CollectionUtil(pageActions);
	    	var defaultPageActions = q.query("this.methodTemplate==''");
	    	defaultPageActions = defaultPageActions == null ? [] : defaultPageActions;
		    if(defaultPageActions == null || defaultPageActions.length == 0){
		    	defaultPageActions = pageActions;
		    }
		    for(var i in defaultPageActions){
		    	dataSource.push({id:defaultPageActions[i].ename,text:defaultPageActions[i].ename});
		    }
		    obj.setDatasource(dataSource);
	    }
		
		/**
		 * 获取渲染函数行为集合
		 * @param obj 
		 */
		function getCustomRenderFuncData(obj){
	    	var dataSource = [];
	    	var dataSource4built = getDataSourceByActionType("type", "gridRender", queryBuiltInAction);
	    	var dataSource4define = getDataSourceByActionType("actionDefineVO.type", "gridRender", new cap.CollectionUtil(pageActions));
	    	//合并
	    	dataSource = _.union(dataSource4built, dataSource4define);
	    	//过滤重复项
	    	_.uniq(dataSource, "id");
		    obj.setDatasource(dataSource);
	    }
		
		 /**
		 * 获取行为函数
		 * @param searchField 查询字段
		 * @param q 查询数据集
		 */
	    function getDataSourceByActionType(searchField, actionType, q){
	    	var dataSource = [];
	    	var result = q.query("this."+searchField+"=='"+actionType+"'");
	    	if(searchField === 'type'){
		    	for(var i in result){
			    	dataSource.push({id:result[i].actionMethodName,text:result[i].actionMethodName});
			    }
		    } else if(searchField === 'actionDefineVO.type'){
		    	for(var i in result){
			    	dataSource.push({id:result[i].pageActionId,text:result[i].ename});
			    }
		    }
		    return dataSource;
	    }
		
		function openWindow(url, winName, winAttrs){
          	//判断是否打开 (在新窗口打开页面（浏览器中只打开一次）)
            if (typeof objWin === 'undefined' || objWin.closed) { 
            	objWin = window.open(url, winName, winAttrs); 
            } else { 
            	objWin.location.replace(url); 
            } 
            objWin.focus(); 
		}
		
		/**
		 * 复杂模型回调函数
		 * @param propertyName 属性名称
		 * @param propertyValue 属性值
		 */
		function openWindowCallback(propertyName, propertyValue){
    		scope.options[propertyName] = propertyValue;
    		scope.$digest();
		}
		
		//选中的回调函数数据回调
		function selectPageActionData(objAction,flag){
			//获取方法名称
			var actionEname = objAction.ename;
			cui('#'+flag).setValue(actionEname);
		}
		
		//清空选中的回调函数数据回调
		function cleanSelectPageActionData(flag){
			cui('#'+flag).setValue("");
		}
    	
		//打开选择界面
		function openSelectUrl(event, self) {
			var url = 'SelectUrl.jsp?namespaces=' + namespaces + '&reqFunctionSubitemId=' + reqFunctionSubitemId + '&propertyName=' + self.options.name + '&callbackMethod=selectUrlCallback&value=' + self.$input[0].value;
			var top=(window.screen.availHeight-600)/2;
			var left=(window.screen.availWidth-800)/2;
			window.open(url,'selectUrl','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
		}

		/**
		 * 选择界面回调函数
		 * @param propertyName 属性名称
		 * @param propertyValue 属性值
		 */
		function selectUrlCallback(propertyName, data){
			var url = '';
			if(data && data.url != ''){
				url = cap.getRelativeURL(data.url, page.modelPackage);
			}
			cui("#"+propertyName).setValue(url);
		}
	</script>
	<%@ include file="/cap/bm/dev/page/uilibrary/PropertiesEditTmpl.jsp" %>
</body>
</html>
