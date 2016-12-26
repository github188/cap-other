<%
  /**********************************************************************
	* 实体元数据-自定义sql查询条件页面
	* 2016-5-9 许畅 新增
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html ng-app='cutomSqlCondition'>
<head>
<meta charset="UTF-8"/>
<title>自定义查询条件</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/dev/page/uilibrary/css/base.css"/>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <top:link href="/cap/bm/common/codemirror/lib/codemirror.css"></top:link>
  	<top:link href="/cap/bm/common/codemirror/theme/eclipse.css"></top:link>
  	
    <style type="text/css">
    	.CodeMirror {
			height:700px;
		}
		
		.right-area{
			border: 1px solid #ccc;
			width: 100%;
			overflow:auto;
			height:700px;
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
	
	<top:script src="/cap/bm/common/codemirror/lib/codemirror.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/mode/sql/sql.js"></top:script>
	
	<top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src="/cap/dwr/interface/EntityOperateAction.js"></top:script>
	<top:script src="/cap/dwr/interface/EntityFacade.js"></top:script>
</head>
<body style="background-color:#f5f5f5;" ng-controller="customSqlConditionCtrl" data-ng-init="ready()">
<div class="cap-page">
    <div class="cap-area" style="width:100%;">
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        	<span>
			        	<blockquote class="cap-form-group">
							<span>自定义查询条件</span>
						</blockquote>
					</span>
		        </td>
		        <td class="cap-td" style="text-align: right;" >
		          <div class="toolbar">
		            <span cui_button id="save" ng-click="saveSqlCondition()" label="确定"></span>
				    <span cui_button id="cancel" ng-click="cancel()" label="取消"></span>
				    <span cui_button id="close" ng-click="close()" label="关闭"></span>
		          </div>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align:right;" width="10%">
		        	是否启用:
		        </td>
		        <td class="cap-td" style="text-align:left;" width="90%">
		        	<input type="checkbox" ng-model="model.customSqlConditionEnable" ng-checked="model.customSqlConditionEnable" ng-click="changeOpenerQueryFieldReadOnly()"/>
		        </td>
		    </tr>
		    
		     <tr>
		        <td class="cap-td" style="text-align:right;vertical-align:top" width="10%">
		        	查询条件:
		        </td>
		        
		        <td class="cap-td" style="text-align:left;" width="90%">
			        <div class="right-area">
			        	<span cui_code id="customSqlCondition" ng-model="model.customSqlCondition"></span>
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
	 var from = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("from"))%>;
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
	 angular.module('cutomSqlCondition', [ "cui"]).controller('customSqlConditionCtrl', function ($scope) {
			$scope.model=model;
			$scope.ready=function(){
		    	comtop.UI.scan();
		    	scope=$scope;
		    	$scope.init();
		    }
			
			$scope.init =function(){
				dwr.TOPEngine.setAsync(false);
				EntityOperateAction.loadDefaultSqlCondition(entity, function(data) {
					if (data) {
						var result=cui.utils.parseJSON(data);
						$scope.model.customSqlCondition = result.customSqlCondition;
						$scope.model.customSqlConditionEnable = result.customSqlConditionEnable;
					}
				});
				dwr.TOPEngine.setAsync(true);
			}
			
			//监听事件
			$scope.$watch("",function(){
			});
			
			//将自定义sql保存至元数据中
			$scope.saveSqlCondition=function(){
				if(from){
					window.opener.parent.updateQueryCondition($scope.model);
				}else{
					window.opener.scope.saveSqlCondition($scope.model);
				}
				window.close();
			}
			
			//取消
			$scope.cancel=function(){
				window.close();
			}
			
			//关闭
			$scope.close=function(){
				window.close();
			}
			
			//自定义查询条件值改变更新
			$scope.callbackUpdate=function(attribute,value){
				$scope.model.customSqlCondition = value;
			}
			
			$scope.changeOpenerQueryFieldReadOnly=function(){
				window.opener.scope.changeQueryFieldReadOnly($scope.model.customSqlConditionEnable);
			}
	 });
	  	
		//统一校验函数
		function validateAll() {
			var validate = new cap.Validate();
			var valRule = {
			};
			var result = validate.validateAllElement(entity, valRule);
			return result;
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
		    	                lineWrapping: true,
		    	                extraKeys: {
		    	                	"F11": function(cm) {
		    	                        setFullScreen(cm, !isFullScreen(cm));
		    	                      },
		    	                      "Esc": function(cm) {
		    	                        if (isFullScreen(cm)) setFullScreen(cm, false);
		    	                      }
		    	                  }
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
		                editor.setValue(newValue);
		              	//改变后定位光标位置
		                editor.setCursor(curPosition);
		            },true);
		        }
		    }
		}]);
		
</script>

</body>
</html>