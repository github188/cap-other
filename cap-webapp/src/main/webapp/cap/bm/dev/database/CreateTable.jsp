<%
  /**********************************************************************
	* 创建表SQL预览
	*
	* 2016-11-14 许畅 新增
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html ng-app='comparePreview'>
<head>
<meta charset="UTF-8"/>
<title>创建表</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/dev/page/uilibrary/css/base.css"/>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>

    <top:link href="/cap/bm/common/codemirror/lib/codemirror.css"></top:link>
    <top:link href="/cap/bm/common/codemirror/theme/eclipse.css"></top:link>

    <style type="text/css">
    	.CodeMirror {
			height:500px;
		}
		
		.right-area{
			border: 1px solid #ccc;
			width: 100%;
			overflow:auto;
			height:500px;
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
	<top:script src="/cap/dwr/interface/TableOperateAction.js"></top:script>
</head>
<body style="background-color:#f5f5f5;" ng-controller="comparePreviewController" data-ng-init="ready()">
<div class="cap-page">
    <div class="cap-area" style="width:100%;">
		<div >
		   <div style="float:left;">
			   <span>
		        	<blockquote class="cap-form-group">
						<span>建表语句</span>
					</blockquote>
			    </span>
		   </div>
		   
		    <div class="toolbar" style="float:right;margin-bottom:10px;">
		        <span cui_button id="syncAll" ng-click="syncAll()" label="同步全部"></span>
			    <span cui_button id="cancel" ng-click="cancel()" label="关闭"></span>
	        </div>
		</div>

		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align:left;" width="100%">
		        	<div class="right-area">
		        		<span cui_code id="sql" ng-model="sql"></span>
		        	</div>
		        </td>
		    </tr>
		</table>

    </div>
</div>	
<script type="text/javascript">
	 //获得传递参数
	 var packageId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
	 var packagePath = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packagePath"))%>;
	
	 //拿到angularJS的scope
	 var scope=null;
	 var sql="";
	 var table = window.parent.scope.tableData;
	 angular.module('comparePreview', [ "cui"]).controller('comparePreviewController', function ($scope) {
			$scope.sql = sql;
			$scope.table = table;
			$scope.ready=function(){
		    	comtop.UI.scan();
		    	scope=$scope;
		    	$scope.init();
		    };
			
			//页面初始化
			$scope.init = function() {
				$scope.preview();
			};

			//预览
			$scope.preview = function() {
				dwr.TOPEngine.setAsync(false);
				TableOperateAction.getCreateTableSQL($scope.table, packagePath,{
					callback: function(data) {
						$scope.sql =data;
					},
					errorHandler: function(message, exception) {
						$scope.sql ="预览失败:"+message;
					}
				});
				dwr.TOPEngine.setAsync(true);
			}
			
			//执行全部
			$scope.syncAll = function(){
				if(!$scope.sql){
					cui.alert("脚本内容为空,不允许执行!");
					return;
				}

				dwr.TOPEngine.setAsync(false);
				TableOperateAction.executeCreateTable($scope.sql, packageId,$scope.table,{
					callback: function(data) {
						cui.message("执行成功!", "success");
						$scope.sql ="";
				        window.parent.scope.applyTableExsit(true);
				        window.parent.scope.changeUrlNotRefreshWindow();
					},
					errorHandler: function(message, exception) {
						cui.message("执行失败:" + message, "error");
					}
				});
				dwr.TOPEngine.setAsync(true);
			}

			$scope.cancel = function() {
				window.parent.createTableDialog.hide();
			}

			//自定义查询条件值改变更新
			$scope.callbackUpdate = function(attribute, value) {
				$scope.sql = value;
			}
	 });

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
 	                editor.options.readOnly = true;
 	            },true);
 	        }
 	    }
 	}]);
	 
		
</script>

</body>
</html>