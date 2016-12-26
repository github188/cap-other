<%
  /**********************************************************************
	* 实体元数据-查询重写sql预览界面
	* 2016-06-01 许畅 新增
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html ng-app='cutomSqlCondition'>
<head>
<meta charset="UTF-8"/>
<title>SQL预览</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/dev/page/uilibrary/css/base.css"/>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <top:link href="/cap/bm/common/codemirror/lib/codemirror.css"></top:link>
  	<top:link href="/cap/bm/common/codemirror/theme/eclipse.css"></top:link>
  	
    <style type="text/css">
    	.CodeMirror {
			height:760px;
		}
		
		.right-area{
			border: 1px solid #ccc;
			width: 100%;
			overflow:auto;
			height:760px;
		}
		
	    .CodeMirror-fullscreen {
	       display: block;
	       position: absolute;
	       top: 0;
	       left: 0;
	       width: 100%;
	       z-index: 9999;
	    }
    </style>
    
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
    <top:script src="/cap/bm/common/base/js/validate.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	
	<top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src="/cap/dwr/interface/EntityFacade.js"></top:script>
	<top:script src="/cap/dwr/interface/QueryPreviewFacade.js"></top:script>
	
	<top:script src="/cap/bm/common/codemirror/lib/codemirror.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/mode/sql/sql.js"></top:script>
	
</head>
<body style="background-color:#f5f5f5;" ng-controller="customSqlConditionCtrl" data-ng-init="ready()">
<div class="cap-page">
    <div class="cap-area" style="width:100%;">
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        	<span>
			        	<blockquote class="cap-form-group">
							<span ng-if="from=='isView'">SQL预览</span>
							<span ng-if="from!='isView'">SQL录入</span>
						</blockquote>
					</span>
		        </td>
		        <td class="cap-td" style="text-align: right;" >
		          <div class="toolbar">
		            <span cui_button id="save" ng-click="saveSQL()" label="确定" ng-if="from!='isView'"></span>
				    <span cui_button id="sqlPreview" ng-click="sqlPreview()" icon="bug" label="调试SQL" ng-if="from=='isView'"></span>
				    <span cui_button id="executeSQL" ng-click="executeSQL()" icon="cog" label="执行SQL" ng-if="from=='isView'"></span>
				    <span cui_button id="customPreview" ng-click="customPreview()" label="自定义调试" ng-if="from=='isView'"></span>
				    <span cui_button id="cancel" ng-click="cancel()" label="取消"></span>
		          </div>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr ng-show="from=='isView'">
		        <td class="cap-td" style="text-align:right;" width="10%">
		        	mybatis命名空间:
		        </td>
		        <td class="cap-td" style="text-align:left;" width="20%">
		        	<span cui_input id="namespace" name="namespace" ng-model="queryPreview.namespace" readOnly="true"></span>
		        </td>

		        <td class="cap-td" style="text-align:right;" width="15%">
		        	查询方法:
		        </td>
		        <td class="cap-td" style="text-align:left;" width="20%">
		        	<span cui_clickinput id="statementId" name="statementId" editable="true" on_iconclick="statementIdClick" ng-model="queryPreview.statementId" ></span>
		        </td>

		        <td class="cap-td" style="text-align:right;" width="10%">
		        	实体:
		        </td>
		        <td class="cap-td" style="text-align:left;" width="20%">
		        	<span cui_clickinput id="entityName" name="entityName" ng-model="queryPreview.entityName" on_iconclick="selectEntity" ></span>
		        </td>
		    </tr>

		    <tr>
		    	<td class="cap-td" style="text-align:right;" width="10%" ng-show="from=='parent'">
		    		方法签名:
		    	</td>
		    	<td id="td_methodName" class="cap-td" style="text-align:left;" width="20%" ng-show="from=='parent'">
		    		<span cui_input id="methodName" name="methodName" ng-model="model.methodName" readonly="true"></span>
		    	</td>

		    	<td class="cap-td" style="text-align:right;" width="15%" ng-if="from=='isView'">
		        	查询参数:
		        </td>
		        <td class="cap-td" style="text-align:left;" width="20%" ng-if="from=='isView'" colspan="2">
		        	<span cui_clickinput  id="params" name="params" ng-model="queryPreview.params" on_iconclick="paramsClick" editable="true"></span>
		        	<div style="color:red;">参数为JSON格式</div>
		        </td>
	             
		        <td width="15%">
		        </td>
		        <td width="15%">
		        	
		        </td>
		    </tr>
		</table>

		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align:right;vertical-align:top" width="10%">
		        	SQL内容:
		        </td>
		        
		        <td class="cap-td" style="text-align:left;" width="90%">
			        <div class="right-area">
			        	<span cui_code id="mybatisSQL" name="mybatisSQL" ng-model="model.mybatisSQL"></span>
			        </div>
		        </td>
		    </tr>
		</table>
		  
    </div>
</div>	
<script type="text/javascript">
	 //获得传递参数
	 var modelId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
	 var packageId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
	 var methodName = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("methodName"))%>;
	 var methodId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("methodId"))%>;
	 var from = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("from"))%>;
	 var methodType = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("methodType"))%>;
	 
	 var pageStorage = new cap.PageStorage(modelId);
	 var entity = pageStorage.get("entity");

	 if(!entity){
	 	dwr.TOPEngine.setAsync(false);
	 	EntityFacade.loadEntity(modelId, packageId, function(rst) {
	 		entity = rst;
	 	});
	 	dwr.TOPEngine.setAsync(true);
	 }
	
	 //拿到angularJS的scope
	 var scope=null;
	 var model={};
	 var queryPreview ={};
	 angular.module('cutomSqlCondition', [ "cui"]).controller('customSqlConditionCtrl', function ($scope) {
			$scope.model= model;
			$scope.from = from;
			$scope.queryPreview = queryPreview;

			$scope.ready=function(){
		    	comtop.UI.scan();
		    	scope=$scope;
		    	$scope.init();
		    }
			
			//页面初始化
			$scope.init =function(){
				var namespace=entity ? entity.modelPackage+".model" : entity;
                var entityName = entity.engName.substring(0, 1).toUpperCase() + entity.engName.substring(1);

                scope.model.methodName = methodName;
                scope.model.methodId = methodId;

                scope.queryPreview.namespace =namespace;
                if(methodType=="blank" || methodType=="queryExtend"){
                	scope.queryPreview.statementId = (methodName.indexOf("ByTaskId")>-1) ? methodName.replace("VO",entityName+"VO") : methodName.replace("VO",entityName);
                }else if(methodType=="queryModeling" || methodType=="userDefinedSQL"){
			        scope.queryPreview.statementId = $scope.firstCharLowerCase(entityName) + "_" + methodName;
                }else{
                	scope.queryPreview.statementId = methodName;
                }
                scope.queryPreview.entityName = entityName;
                scope.queryPreview.modelId = modelId;
                scope.queryPreview.methodName = methodName;

				$scope.initSqlEntering();
				$scope.initSqlPreview();
			}
			
			//首字符小写
			$scope.firstCharLowerCase = function(str){
				if(!str || str.length==0){
					return str;
				}
				return str.substring(0,1).toLowerCase()+str.substring(1);//首字符小写
			}
            
			//初始化sql预览
			$scope.initSqlPreview = function() {
				if(from == "isView"){
					//SQL预览
					$scope.sqlPreview();
				}
			}

			//初始化sql录入
			$scope.initSqlEntering = function() {
				if (from != "isView") {
					document.title="SQL录入";
					$("#td_methodName").attr("width","90%");

					var method = getMethod(methodId);
					if (method) {
						$scope.model.mybatisSQL = method.queryExtend ? method.queryExtend.mybatisSQL : "";
					}
				}
			}
			
			//将自定义sql保存至元数据中
			$scope.saveSQL=function(){
				window.opener.scope.saveQueryExtend($scope.model);
				window.close();
			}
			
			//取消
			$scope.cancel=function(){
				window.close();
			}
			
			//自定义查询条件值改变更新
			$scope.callbackUpdate=function(attribute,value){
				$scope.model.mybatisSQL = value;
			}
			
			//sql预览
			$scope.sqlPreview = function(){
				if(!$scope.validateAll())
					return;
				
				dwr.TOPEngine.setAsync(false);
				QueryPreviewFacade.previewSQL($scope.queryPreview,{callback:function(result){
						$scope.model.mybatisSQL = result.sql;
					},errorHandler:function(message, exception){
						$scope.model.mybatisSQL = "预览发生异常: \n" + message;
					}
				});
				dwr.TOPEngine.setAsync(true);
			}
			
			//调试校验
			$scope.validateAll = function(){
				var entityName = scope.queryPreview.entityName;
		    	var namespace = scope.queryPreview.namespace;
		    	var statementId = scope.queryPreview.statementId;
		    	if(!entityName){
		    		cui.alert("实体不能为空.");
		    		return false;
		    	}
		    	if(!namespace){
		    		cui.alert("mybatis命名空间不能为空.");
		    		return false;
		    	}
		    	if(!statementId){
		    		cui.alert("查询方法ID不能为空.");
		    		return false;
		    	}
		    	return true;
			};
			
			//转自定义预览
			$scope.customPreview = function(){
				cui("#namespace").setReadonly(false);
				cui("#statementId").setReadonly(false);
				cui("#entityName").setReadonly(false);
				$("#customPreview").hide();
			};
			
			//参数回调
			$scope.paramsCallback = function(result){
				$scope.queryPreview.params=result;
				$scope.$digest();
			};
			
			//执行SQL
			$scope.executeSQL = function(){
				if(!$scope.validateAll())
					return;
				
				//SQL预览
				$scope.sqlPreview();
				
				var sql = $scope.model.mybatisSQL;
				if(!sql){
					cui.alert("SQL内容不能为空.");
					return;
				}
				if(sql.indexOf("预览发生异常")>-1){
					cui.alert("预览发生异常不允许执行SQL.");
					return;
				}
			
				var top = (window.screen.availHeight - 600) / 2;
				var left = (window.screen.availWidth - 800) / 2;
				window.open("SqlPreviewExecute.jsp?modelId=" + modelId + "&packageId="+ packageId +"&from="+from, "sqlPreviewExecute", 'height=600,width=800,top=' + top + ',left=' + left + ',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no');
			};
			
	 });
	 
		 /**
	      * [参数点击事件]
	      * 
	      * @return {[type]} [description]
	      */
		function paramsClick(){
			var top = (window.screen.availHeight - 600) / 2;
			var left = (window.screen.availWidth - 800) / 2;
			window.open("SqlPreviewParams.jsp?modelId=" + modelId + "&packageId="+ packageId +"&from="+from, "sqlPreviewParams", 'height=600,width=800,top=' + top + ',left=' + left + ',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no');
		}
	    
	 
	    //获取实体方法
	    function getMethod(methodId){
	    	var methods=entity.methods;
	    	for(var i=0;i<methods.length;i++){
	    		var method=methods[i];
	    		if(method.methodId==methodId){
	    			return method;
	    		}
	    	}
	    	return "";
	    }
	    
	    //statementId on_iconclick 事件
	    function statementIdClick(){
	    	var top = (window.screen.availHeight - 600) / 2;
			var left = (window.screen.availWidth - 800) / 2;
			window.open("SqlPreviewMethod.jsp?modelId=" + modelId + "&packageId="+ packageId +"&from="+from, "sqlPreviewMethod", 'height=600,width=800,top=' + top + ',left=' + left + ',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no');
	    }
	    
	    //statementId on_iconclick 事件回调
	    function statementIdCallback(result){
	    	scope.queryPreview.statementId = result;
	    	if(scope.queryPreview.namespace && scope.queryPreview.statementId && scope.queryPreview.entityName){
	    		scope.sqlPreview();
	    	}
	    	scope.$digest();
	    }
	    
	    //实体选择
		var dialog;
	    function selectEntity(){
	    	var url = "SelSystemModelMain.jsp?sourcePackageId=" + packageId + "&isSelSelf=true&showClean=false&sourceEntityId="+modelId;
			var title="选择目标实体";
			var height = 600; //600
			var width =  400; // 680;
			var top = '10%';
			
			dialog = cui.dialog({
				title : title,
				src : url,
				width : width,
				height : height,
				top : top
			})
			dialog.show(url);
	    }
	    
	    //实体选择回调
	    function selEntityBack(selectNodeData,propertyName){
	    	scope.queryPreview.entityName = selectNodeData.modelName;
	    	scope.queryPreview.namespace = selectNodeData.modelPackage +".model";
	    	scope.queryPreview.statementId = null;
	    	scope.queryPreview.modelId = selectNodeData.modelId;
	    	modelId  = selectNodeData.modelId;
	    	scope.$digest();
	    	dialog.hide();
	    }
	    
	    //close回调
	    function closeEntityWindow(){
	    	if(dialog){
	    		dialog.hide();
			}
	    }
		
		//查询条件代码编辑器文本域指令
		CUI2AngularJS.directive('cuiCode', ['$interpolate',function ($interpolate) {
		    return {
		        restrict: 'A',
		        replace: false,
		        require: 'ngModel',
		        scope: {
		            ngModel: '=',
		             id:'@'
		        },
		        template: '<textarea id="textarea_{{id}}" name="code"></textarea>',
		        link: function (scope, element, attrs, controller) {
		        	scope.safeApply = function (fn) {
		        		var phase = this.$root.$$phase;
		                if (phase == '$apply' || phase == '$digest') {
		                    if (fn && (typeof(fn) === 'function')) {
		                        fn();
		                    }
		                } else {
		                    this.$apply(fn);
		                }
		            };
		            
		            var editor = null;
		            scope.$watch("ngModel",function(newValue, oldValue, scope){
		                if(editor==null){
		                    editor = CodeMirror.fromTextArea(document.getElementById("textarea_"+attrs.id), {
		                    	lineNumbers: true,
		    	                theme:'eclipse',
		    	                mode: 'text/x-sql',
		    	                lineWrapping: true
		                    });
		                   
		                    //监听CodeMirror editor的变化
	                       editor.on('change', function(instance, changeObj) {
		                      	scope.safeApply(function(){
		                      	    //把editor的值设置到ngModel中。触发这里的$watch方法，把ng-model的值写到editor上。
		                      		scope.$parent.callbackUpdate(attrs.id, instance.getValue());
		                      	});
	   	            	  });
		                }
		                //改变前获取光标位置
		               	var curPosition = editor.getCursor();
		                editor.setValue(newValue ? newValue:"");
		              	//改变后定位光标位置
		                editor.setCursor(curPosition);
		                //禁用
		                if(from=="isView"){
		                	editor.options.readOnly = true;
		                }

		            },true);
		        }
		    }
		}]);
		
</script>

</body>
</html>