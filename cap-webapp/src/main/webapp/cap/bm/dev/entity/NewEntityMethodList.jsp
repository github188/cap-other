
<%
/**********************************************************************
* 元数据建模：实体方法列表
* 2015-10-13 凌晨 新建
* 2016-06-06 许畅 修改
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!doctype html>
<html ng-app='entityMethodList'>
<head>
	<meta charset="UTF-8"/>
    <title>实体方法</title>
    <top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/dev/page/uilibrary/css/base.css"/>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <top:link href="/cap/bm/common/codemirror/lib/codemirror.css"></top:link>
  	<top:link href="/cap/bm/common/codemirror/theme/eclipse.css"></top:link>
  	<top:link href="/cap/bm/dev/entity/css/queryModel.css"></top:link>
   	<top:link href="/cap/bm/dev/entity/css/NewEntityMethod.css"></top:link>
    
    <script type="text/javascript">
	//获得传递参数
	var modelId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
	var checkUrl="<%=request.getContextPath() %>/cap/bm/dev/consistency/ConsistencyCheckResult.jsp?checkType=main&init=true";
	var isSubQuery=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("isSubQuery"))%>;
	var globalReadState=eval(<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("globalReadState"))%>);
	</script>
    
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
    <top:script src="/cap/bm/common/base/js/validate.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/bm/common/base/js/easy.js"></top:script>
	
	<top:script src="/cap/bm/common/codemirror/lib/codemirror.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/mode/sql/sql.js"></top:script>
	
	<top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src="/cap/dwr/interface/EntityFacade.js"></top:script>
	<top:script src="/cap/dwr/interface/EntityOperateAction.js"></top:script>
	<top:script src="/cap/dwr/interface/QueryPreviewFacade.js"></top:script>
	
	<top:script src="/cap/bm/dev/entity/js/entityMethodList.js"></top:script>
	<top:script src="/cap/bm/dev/entity/js/queryModel.js"></top:script>
	<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
	
	<style type="text/css">
		.bm-code{
			font-size: .8rem;
			color: #777; 
		}
	</style>
</head>
<body ng-controller="entityMethodController" data-ng-init="ready()">
<div class="cap-page">
<div class="cap-area" style="width:100% ;height:100%; overflow: auto;">
	<!-- 方法列表 -->
	<div ng-class="root.entityMethods.length > 0?'div_method_list':'div_method_list div_method_list_right_boder'">
		<!-- tab页 -->
        <ul class="tab method_list_tab"> 	
			<li ng-class="{'method':'active'}[active]" class="notUnbind" ng-click="showPanel('method')">实体方法</li>
			<li ng-class="{'parentMethod':'active'}[active]" class="notUnbind" ng-click="showPanel('parentMethod')">父实体方法</li>
		</ul>
        <!-- 本实体方法列表 -->
        <div ng-show="active=='method'" style="padding: 5px 5px 5px 0">
        	<div style="text-align: right;">
        		<span cui_input  id="filterChar" ng-model="filterChar" width="170px" emptytext="请输入方法英文/中文名称" style="float:left"></span>
				<span cui_button id="add" ng-click="addEntityMethod()" label="新增" ></span>
				<span uitype="button" id="copy" label="复制" ng-click="copyEntityMethod()" ng-hide="hideButtonFlag"></span>
				<span cui_button id="delete" ng-click="deleteEntityMethod()" label="删除" ></span>
				<span uitype="button" label="更多" id="moreAction"  menu="moreAction" ng-hide="hideMoreActionFlag"></span>
        	</div>
        	<div>
				<table class="custom-grid" style="width: 100%; margin-top: 10px;">
				   <thead>
				      <tr>
					     <th style="width:30px">
					         <input type="checkbox" name="objCheckAll.entityMethodsCheckAll" ng-model="objCheckAll.entityMethodsCheckAll" ng-change="allCheckBoxCheck(root.entityMethods,objCheckAll.entityMethodsCheckAll)" ng-hide="filterChar">
					     </th>
					     <th>
				         	方法名称
					     </th>
					     <th>
					     	中文名称
					     </th>
				      </tr>
				   </thead>
			       <tbody>
			          <tr ng-repeat="entityMethodVo in  root.entityMethods track by $index" ng-if="!entityMethodVo.isFilter && entityMethodVo.methodId.indexOf('count') == -1 && entityMethodVo.methodId.indexOf('pagination') == -1" style="background-color: {{selectEntityMethodVO.methodId == entityMethodVo.methodId ? '#99ccff' : '#ffffff'}}">
			              <td style="text-align: center;">
			                  <input type="checkbox" name="{{'entityMethodVo'+($index + 1)}}" ng-model="entityMethodVo.check" ng-change="checkBoxCheck(root.entityMethods,'objCheckAll.entityMethodsCheckAll')">
			              </td>
			              <td style="text-align:left;cursor:pointer" class="notUnbind" ng-click="methodTdClick(entityMethodVo,false)">
			                  {{entityMethodVo.engName}}
			              </td>
			              <td style="text-align: center;" class="notUnbind" ng-click="methodTdClick(entityMethodVo,false)">
			                  {{entityMethodVo.chName}}
			              </td>
			          </tr>
			          <tr ng-if="!hasMethod()">
			               <td colspan="3" class="grid-empty">本列表暂无记录</td>
			           </tr>
			       </tbody>
				</table>
			</div>
        </div>
        <!-- 父实体方法列表 -->
        <div ng-show="active=='parentMethod'">
        	<table class="custom-grid" style="width: 100%">
				<thead>
					<tr>
					   <th style="width:52px">
					   </th>
					   <th>
					   	方法名称
					   </th>
					   <th>
				                中文名称
					   </th>
					</tr>
				</thead>
			    <tbody>
			           <tr ng-repeat="pEntityMethodVo in  parentEntityMethods" style="background-color: {{selectEntityMethodVO.methodId == pEntityMethodVo.methodId ? '#99ccff' : '#ffffff'}}">
			                 <td style="text-align:left;">
			                      <input type="button" style="" id="overrideParent" ng-click="overrideParent(pEntityMethodVo)" ng-show="{{(pEntityMethodVo.assoMethodName==null || pEntityMethodVo.assoMethodName=='') 
			                                  && pEntityMethodVo.queryExtend!=null && pEntityMethodVo.queryExtend!='' }}" value="重写"/>
			                 </td>
			                 <td style="text-align:left;cursor:pointer" class="notUnbind" ng-click="methodTdClick(pEntityMethodVo,true)">
			                       {{pEntityMethodVo.engName}}
			                 </td>
			                 <td style="text-align: center;" class="notUnbind" ng-click="methodTdClick(pEntityMethodVo,true)">
			                       {{pEntityMethodVo.chName}}
			                 </td>
			           </tr>
			           <tr ng-if="!parentEntityMethods || parentEntityMethods.length == 0">
			                 <td colspan="3" class="grid-empty"> 本列表暂无记录</td>
			           </tr>
			    </tbody>
			</table>
        </div>
	</div>
	<!-- 方法详情 -->
	<div id="methodDetail" ng-class="selectEntityMethodVO.methodId?'div_method_Detail div_method_Detail_left_boder':'div_method_Detail'" style="padding: 5px 2px 5px 5px;">
		
		<div id="comment_new_method_label" ng-if="!selectEntityMethodVO.methodId">
			请新增方法
		</div>
		<!-- 本实体方法详情 -->
		<div ng-show="!displayPMethod && selectEntityMethodVO.methodId">
			<%@include file="/cap/bm/dev/entity/method/MethodName.jsp" %>
		</div>
		<!-- 父实体方法详情 -->
		<div ng-if="displayPMethod && selectEntityMethodVO.methodId">
			<!-- 方法签名 -->
			<div>
				<span id="parent_mehtod_sign_name" class="notUnbind cap-group">方法签名</span>
				<span ng-if="entitySource !='exist_entity_input'" cui_button id="sqlPreview" ng-click="sqlPreview('isView')" label="SQL预览"></span>
			</div>
			<div id="parent_mehtod_sign_name_div" class="method-div-group">
				<div class="method-name">
					<span>{{javaMethodName}}</span>
				</div>
			</div>
			<!-- 方法注释 -->
			<div>
				<span id="parent_method_comment" class="notUnbind cap-group">方法注释</span>
		    </div>
			<div id="parent_method_comment_div" class="method-div-group">
				<div>
					<span class="span-label">中文名称：</span>
					<span>{{selectEntityMethodVO.chName}}</span>
					<span class="span-label" style="padding-left: 60px;">方法别名：</span>
					<span>{{selectEntityMethodVO.aliasName}}</span>
				</div>
				<div>
					<span class="span-label">方法描述：</span>
					<div class="method-desc-mar">
						<span readonly="true" cui_textarea emptytext="方法描述,生成代码时为方法的详细注释" id="parent_description" ng-model="selectEntityMethodVO.description" width="100%" height="80px" ></span>
					</div>
				</div>
			</div>
			<!-- 方法逻辑 -->
			<div>
				<span id="parent_method_body_logic" class="notUnbind cap-group">方法逻辑</span>
			</div>
			<div id="parent_method_body_logic_div" class="method-div-group">
				<div>
					<span class="span-label">服务增强：</span>
					<div readonly="true" cui_radiogroup  id="parent_serviceExRadioGroup" name="serviceEx" ng-model="selectEntityMethodVO.serviceEx" >
						<input type="radio" name="serviceEx" value="none" />无
						<input type="radio" name="serviceEx" value="before" />前
						<input type="radio" name="serviceEx" value="after" />后
						<input type="radio" name="serviceEx" value="before_after" />前后
					</div>
					<span class="span-label">标注只读事务：</span>
					<span><input id="parent_transactionCheckBox" type="checkbox" name="transaction" ng-model="selectEntityMethodVO.transaction" ng-checked="selectEntityMethodVO.transaction" ng-disabled="true"></span>
				</div>
				<div >
					<span class="span-label">方法类型</span>
					<div readonly="true" cui_radiogroup  id="parent_methodTypeRadioGroup" name="methodType" ng-model="selectEntityMethodVO.methodType">
						<input type="radio" name="methodType" value="blank" />空方法
						<input type="radio" name="methodType" value="cascade" />级联操作
						<input type="radio" name="methodType" value="procedure"  />存储过程调用
						<input type="radio" name="methodType" value="function" />函数调用
						<input type="radio" name="methodType" value="userDefinedSQL" />自定义SQL调用
						<input type="radio" name="methodType" value="queryModeling" />查询建模
						<input type="radio" name="methodType" value="queryExtend" readonly="readonly"/>查询重写
					</div>
				</div>
				<div>
					<span class="span-label">操作类型</span>
					<div readonly="true" cui_radiogroup  id="parent_methodOperateTypeRadioGroup" name="methodOperateType" ng-model="selectEntityMethodVO.methodOperateType" ng-change="changeMethodOperateType(selectEntityMethodVO.methodOperateType)">
						<input type="radio" name="methodOperateType" value="insert" />新增
						<input type="radio" name="methodOperateType" value="query" />读取
						<input type="radio" name="methodOperateType" value="update" />更新
						<input type="radio" name="methodOperateType" value="delete" />删除
						<input type="radio" name="methodOperateType" value="save"/>保存
					</div>
					<span>
						<span class="span-label">生成相关方法：</span>
						<span>
							<input id="parent_needCount" type="checkbox" name="needCount" ng-model="selectEntityMethodVO.needCount" ng-checked="selectEntityMethodVO.needCount" ng-disabled="true"/><label for="needCount">记录数方法</label>
							<input ng-disabled="true" id="parent_needPagination" type="checkbox" name="needPagination" ng-model="selectEntityMethodVO.needPagination" ng-checked="selectEntityMethodVO.needPagination" ng-change="changeNeedPagination(selectEntityMethodVO.needPagination)"/><label for="needPagination">分页方法</label>
						</span>
					</span>
				</div>
				<!-- sql查询重写界面  -->
				<div ng-if="false">
				  	<div ng-show="entitySource =='exist_entity_input'">
				  		<span class="span-label">selectId:</span>
				  		<span cui_input id="parent_selectId" name="selectId" ng-model="selectEntityMethodVO.queryExtend.selectId" width="25%" ></span>
				  		<a style="color:red;">注:selectId默认情况下不需要填,它影响生成的sql.xml的select id,如果是特殊命名才需要修改.</a>
				  	</div>
				  	<div>
				  		<span class="span-label">SQL内容:</span>
				  		<span ng-if="entitySource !='exist_entity_input'" cui_button id="parent_sqlPreview" ng-click="sqlPreview('isView')" label="SQL预览"></span>
				  		<div style="margin-top:5px;height:400px">
				  			<!-- <textarea disabled="disabled" style="background-color:#ffffff;width: 99%;height: 100%">{{selectEntityMethodVO.queryExtend.mybatisSQL}}</textarea> -->
				  			<span cui_code id="parent_mybatisSQL" disabled="disabled" name="mybatisSQL" ng-model="selectEntityMethodVO.queryExtend.mybatisSQL"></span>
						</div>
				  	</div>
				</div>
			</div>
		</div>
	</div>
</div>	
</div>
<script type="text/javascript">

	//js自定义文本域指令
	CUI2AngularJS.directive('cuiCode', ['$interpolate',function ($interpolate) {
	    return {
	        restrict: 'A',
	        replace: false,
	        require: 'ngModel',
	        scope: {
	            ngModel: '=',
	             id:'@',
	             disabled:'@'
	        },
	        template: '<textarea id="textarea_{{id}}" disabled="disabled" name="code"></textarea>',
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
	            	var readOnly = attrs['disabled'] === 'disabled' || (typeof globalReadState === 'undefined' || globalReadState == false) ? false : true;
	                if(editor==null){
	                    editor = CodeMirror.fromTextArea(document.getElementById("textarea_"+attrs.id), {
	                    	lineNumbers: true,
	    	                theme: 'eclipse',
	    	                mode: 'text/x-sql',
	    	                lineWrapping: true,
	    	                readOnly: readOnly,
	    	                extraKeys: {
	    	                	"F11": function(cm) {
	    	                        setFullScreen(cm, !isFullScreen(cm));
	    	                      },
	    	                      "Esc": function(cm) {
	    	                        if (isFullScreen(cm)) setFullScreen(cm, false);
	    	                      }
	    	                  }
	                    });
	                   
	                    //editor.doc.cantEdit = attrs['disabled'] === 'disabled';
	                    
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
	                //此处解决多个codeMirror互相影响BUG需要异步刷新 
					var tmp = function() {
						editor.refresh();
					}
					setTimeout(tmp, 50);
	            },true);
	        }
	    }
	}]);

</script>
</body>
</html>