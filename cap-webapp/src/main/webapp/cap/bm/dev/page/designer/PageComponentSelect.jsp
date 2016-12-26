<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app="uiselectApp">
<head>
<title>控件选择</title>
<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"></top:link>
<top:link href="/cap/bm/dev/page/designer/css/table-layout.css"></top:link>
</head>
<body style="background-color:#f5f5f5" ng-controller="uiselectCtr" ng-cloak>
	<div class="cap-area" style="background-color:#fff;width: 96%;height:100%; border: 1px solid #ccc;padding:5px;">
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;width:420px">
		        	<div style="text-align:left;">
						<span cui_input ng-model="searchText" emptytext="搜索UI组件"></span>
						<span cui_pulldown id="multiTest" ng-model="set" datasource="searchType" value_field="key" label_field="key"></span>
					</div>
		        </td>
		         <td class="cap-td" style="text-align: right;">
		        	<span uitype="Button" label="确定" button_type="blue-button" on_click="getSelectData"></span>
					<span uitype="Button" label="关闭" on_click="canel"></span>
		        </td>
		    </tr>
		</table>
		<hr>
		<div style="height: 438px; overflow-y:auto;">
			<div ng-show="isSearch" class="m-plate" style="text-align:left;">
				<ul class="u-plate">
					<li ng-repeat="uiitem in uidata|filter:{uiType:set}|filter:{title:searchText}  as results">
						<input type="checkbox" id="pp-{{uiitem.id}}" ng-model="uiitem.select" ng-change="synTree(uiitem.select,uiitem.id)" ng-if="_selectMode">
						<input type="radio" id="pp-{{uiitem.id}}" ng-checked="uiitem.select" ng-click="uiitem.select= !uiitem.select;synTree(uiitem.select,uiitem.id)" ng-if="!_selectMode">
						<label for="pp-{{uiitem.id}}" ng-bind-template="{{uiitem.options.name}}({{uiitem.title}})"></label>
					</li>
				</ul>
				<div ng-show="results.length==0">没有匹配数据</div>
			</div>
			<div ng-hide="isSearch" style="width: 100%;height: auto;margin-bottom: 10px;overflow: auto;text-align:left;">
				<span id="treeui" uitype="tree"></span>
			</div>
		</div>
	</div>
<top:script  src="/cap/bm/common/base/js/angular.js"></top:script>	
<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
<script type="text/javascript">
	var $ = comtop.cQuery;
</script>
<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
<top:script src="/cap/bm/dev/page/designer/js/utils.js"></top:script>
<top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
<script type="text/javascript">
		var selectMode=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("selectMode"))%>;
		var propertyName=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("propertyName"))%>;
		var pageId="<%=request.getParameter("pageId")%>"
		var pageSession = new cap.PageStorage(pageId);
		var data = [];
		if(pageId){
			data = new CData(pageSession.get("layout"));
		}
		
		angular.module("uiselectApp",["cui"]).controller("uiselectCtr",['$scope',function($scope){
			$scope.uidata = _.cloneDeep(data.getUIData());
			//定义一个变量用于下拉列表过滤出来的数据选择是checkbox模式还是radio模式
			$scope._selectMode = selectMode != null ? parseInt(selectMode) != 1 :true;
			$scope.$watch("searchText",function(newvalue,old){
				if(newvalue || $scope.set){
					$scope.isSearch = true;
				}else{
					$scope.isSearch = false;
				}
			})
			
			$scope.$watch("set",function(newvalue){
				if(newvalue || $scope.searchText){
					$scope.isSearch = true;
				}else{
					$scope.isSearch = false;
				}
			})
			$scope.synTree = function(select,id){
				if(selectMode!=null && parseInt(selectMode)==1){
					cui("#treeui").getNode(id).activate(true); //cui树组件只会有一个node为activated状态。一个node设为activated状态，其他的node自动变为unactivated
					//以下for循环非核心代码  仅处理 当选中一个之后，其他的radio变为未选中，不能有多个radio同时选中的情况
					for(var i = 0; i < $scope.uidata.length; i++){
						if($scope.uidata[i].id != id){
							$scope.uidata[i].select = false;
						}
					}
				}else{
					cui("#treeui").selectNode(id,select);
				}
			}
		}]);

		var searchType = _.map(_.groupBy(data.getUIData(),"uiType"),function(n,key){
			return {key:key};
		});
		var isCheckbox=selectMode!=null?parseInt(selectMode)!=1:true;
		var select_mode=selectMode!=null?parseInt(selectMode):4;
        $("#treeui").tree({
        	children:data.getData(),
        	checkbox:isCheckbox,
        	select_mode:select_mode
        });
	
	comtop.UI.scan();
       
    function getSelectData(){
    	var result =null;
    	if(selectMode!=null && parseInt(selectMode)==1){
    		result = cui('#treeui').getActiveNode();
    	}else{
    		var selectNode = cui('#treeui').getSelectedNodes();
    		result = [];
    		$.each(selectNode,function(i,item){
    			result.push(item.getData());
    		});
    	}
    	if(window.opener && window.opener.getSelectData){
			window.opener.getSelectData.call(this,result,propertyName);
			window.close();
		}else if(window.parent.getSelectData){
			window.parent.getSelectData.call(this,result,propertyName);
		}
    }
    
    function canel(){
    	if(window.parent.closeDialog){
    		window.parent.closeDialog();
    	}else{
    		window.close();
    	}
    }
        
</script>
</body>
</html>