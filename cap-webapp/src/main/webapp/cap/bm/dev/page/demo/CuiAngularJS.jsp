<%
/**********************************************************************
* 页面状态
* 2015-5-27 郑重 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app='pageExpressSelect'>
<head>
    <meta charset="UTF-8">
    <title>AngularJS集成CUI</title>
    <top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <top:link href="/cap/bm/common/codemirror/lib/codemirror.css"></top:link>
    <top:link href="/cap/bm/common/codemirror/theme/eclipse.css"></top:link>
    <top:link href="/cap/bm/common/codemirror/addon/hint/show-hint.css"></top:link>
    <top:link href="/cap/bm/common/codemirror/addon/display/fullscreen.css"></top:link>
    <style type="text/css">
    	
    </style>
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.extend.dictionary.js"></top:script>
	<top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src="/top/sys/dwr/interface/ChooseAction.js"/>
	<top:script src="/cap/bm/common/codemirror/lib/codemirror.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/mode/javascript/javascript.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/addon/hint/show-hint.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/addon/hint/javascript-hint.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/addon/display/fullscreen.js"></top:script>
    <script type="text/javascript">
    
    var data = [{
        title: "设备类别结构",
        key: "k2",
        expand: true,
        isFolder: true,
        children: [{
            title: "无形资产",
            key: "k2-1",
            isFolder: true,
            expand: true,
            children: [{
                title: "土地使用权"
            }]
        }]
    }];
    
    var initData = [
		{id:'item1',text:'选项1'},
		{id:'item2',text:'选项2'},
		{id:'item3',text:'选项3'},
		{id:'item4',text:'选项4'}
	]
    
    var root={myInput:"新四军独立团团长车道宽",checkbox:['0', '1'],radio:1,calender:'2015-06-08',textarea:"dddd",
    		clickinput:'clickinput',pullDown:"1;2",dictionary:"1",tree:data,pullDowns:[{d:'2',list:[{id:'2',text:'2'}]},{d:'1',list:[{id:'1',text:'1'},{id:'2',text:'2'}]},{d:'2',list:[{id:'2',text:'2'}]}],
    		pullDowns2:[{d:'2'},{d:'2'}],
    		codemirrors:[
             {id:'code1',form:{ddd:'sdfsd',ss:'ddddd'},code:"function {{ddd}}(){ {{ss}} }",out:""},
             {id:'code2',form:{},code:"",out:""}]};
    
    angular.module('pageExpressSelect', [ "cui"]).controller('pageExpressSelectCtrl', function ($scope) {
    	
    	$scope.root=root;
    	
        $scope.changeInput = function () {
            $scope.root.myInput = "新设置的值：深圳市康拓普信息技术有限公司";
        }
        
        $scope.validate = function () {
        	cap.validateForm();
        }
        
        $scope.changeInput2 = function () {
        	console.log($scope.root.code);
        }
        
        $scope.changeTmp= function (){
        	$scope.root.codemirrors=[
        	                         {id:'code1',form:{ddd:'sdfsd',ss:'ddddd'},code:"function {{ddd}}(){fsdfsd {{ss}} }",out:""}];
        }
    });
    
    CUI2AngularJS.directive('cuiCode', function ($interpolate) {
        return {
            restrict: 'A',
            replace: false,
            require: 'ngModel',
            scope: {
                ngModel: '=',
                ngCode: '=',
                ngOut: '=',
                id:'@'
            },
            template: '<textarea id="textarea{{id}}" name="code"></textarea>',
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
            	
                var editor =null;
                scope.$watch("ngModel",function(){
                    var template=$interpolate(scope.ngCode);
                    if(editor==null){
                        editor = CodeMirror.fromTextArea(document.getElementById("textarea"+attrs.id), {
                        	lineNumbers: true,
        	                extraKeys: {
        	                	"Ctrl-Q": "autocomplete",
        	                	"F11": function(cm) {
          	                      cm.setOption("fullScreen", !cm.getOption("fullScreen"));
          	                    },
          	                    "Esc": function(cm) {
          	                      if (cm.getOption("fullScreen")) cm.setOption("fullScreen", false);
          	                    }
        	                },
        	                mode: {name: "javascript", globalVars: true},
        	                theme:'eclipse'
                        });
                        
                        editor.on('keypress', function(instance, event) {
        	                if(event.charCode>=46 || (event.charCode>=65 && event.charCode<=90) || (event.charCode>=97 && event.charCode<=122)){
        	                    setTimeout(function(){
        	                      editor.showHint();  //满足自动触发自动联想功能  
        	                    },1)
        	                }         
        	            }); 
                        
                        editor.on('change', function(instance, changeObj) {
                        	scope.safeApply(function(){
                        		scope.ngOut = instance.getValue();
                        	});
        	            });
                    }
                    editor.setValue(template(scope.ngModel));
                },true);
            }
        }
    });
    

    </script>
</head>
<body style="background-color:#f5f5f5;" ng-controller="pageExpressSelectCtrl">
<div class="cap-page" style="width:780px;">
	<div class="cap-area" >
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;width:180px">
		        	<span id="formTitle" uitype="Label" value="AngularJS集成CUI" class="cap-label-title"></span>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
			<tr>
		        <td class="cap-td" style="text-align: left;width:200px">
		        	<span cui_button  id="validate" ng-click="validate()" label="校验" icon="file-text-o"></span>
		        </td>
		    </tr>
		    <tr>
		        <td class="cap-td" style="text-align: left;width:200px">
		        	<span cui_button id="changeInput" ng-click="changeInput()" label="按钮样例" icon="file-text-o"></span>
		        	<span cui_input  id="myInput" name="input" ng-model="root.myInput" width="200px" readonly="{{root.myInput!=''}}" validate="[{'type':'required', 'rule':{'m': '学号不能为空'}}]"></span>
				    <span>{{root.myInput}}</span>
		        </td>
		    </tr>
		    
		    <tr>
		        <td class="cap-td" style="text-align: left;width:200px">
		        	<span cui_checkboxgroup id="myCheckboxGroup" ng-model="root.checkbox" name="like">
		        		<input type="checkbox" name="like" value="0" readonly="readonly" /> 足球
						<input type="checkbox" name="like" value="1" /> 篮球
						<input type="checkbox" name="like" value="2" /> 兵乓球
						<input type="checkbox" name="like" value="3" /> 羽毛球
		        	</span>
				    <span>{{root.checkbox}}</span>
		        </td>
		    </tr>
		    <tr>
		        <td class="cap-td" style="text-align: left;width:200px">
		        	<span cui_radiogroup id="myRadioGroup" ng-model="root.radio" name="sex">
						<input type="radio" name="sex" value="0" />男
						<input type="radio" name="sex" value="1" />女
					</span>
				    <span>{{root.radio}}</span>
		        </td>
		    </tr>
		    <tr>
		        <td class="cap-td" style="text-align: left;width:200px">
		        	<span cui_calender id="calender" ng-model="root.calender"></span>
				    <span>{{root.calender}}</span>
		        </td>
		    </tr>
		    <tr>
		        <td class="cap-td" style="text-align: left;width:200px">
		        	<span cui_textarea id="textarea" ng-model="root.textarea"></span>
				    <span>{{root.textarea}}</span>
		        </td>
		    </tr>
		    <tr>
		        <td class="cap-td" style="text-align: left;width:200px">
		        	<span cui_clickinput id="clickinput" ng-model="root.clickinput"></span>
				    <span>{{root.clickinput}}</span>
		        </td>
		    </tr>
		    <tr>
		        <td class="cap-td" style="text-align: left;width:200px">
		        	<span cui_pulldown id="multiTest" mode="Multi" ng-model="root.pullDown" value_field="id" label_field="text">
						<a value="1">html模板1</a>
						<a value="2">html模板2</a>
						<a value="3">html模板3</a>
						<a value="4">html模板4</a>
					</span>
				    <span>{{root.pullDown}}</span>
		        </td>
		    </tr>
		    <tr>
		        <td class="cap-td" style="text-align: left;width:200px">
		        	<span cui_pulldown id="singleTest" ng-model="root.singlePullDown" value_field="id" label_field="text" datasource="initData" editable="true" must_exist="false" select="1">
					</span>
				    <span>{{root.singlePullDown}}</span>
		        </td>
		    </tr>
		    <tr>
		        <td class="cap-td" style="text-align: left;width:200px">
		        	<span cui_pulldown id="dictionary"  ng-model="root.dictionary" value_field="value" label_field="text" dictionary="LCAM_zhengzhong_outageReasonTypeDic"></span>
				    <span>{{root.dictionary}}</span>
		        </td>
		    </tr>
		    <tr>
		        <td class="cap-td" style="text-align: left;width:200px">
		        	<span cui_tree id="tree" ng-model="root.tree" checkbox="true" select_mode="2" click_folder_mode="1" min_expand_level="2"></span>
		        	<div style="word-break:break-all;">{{root.tree}}</div>
		        </td>
		    </tr>
		    <tr ng-repeat="pullD in root.pullDowns" >
		    	<td>
		    		<span cui_pulldown id="{{'pullD'+($index + 1)}}"  datasource="{{pullD.list}}"  ng-model="pullD.d" value_field="id" label_field="text">
					</span>
		    	</td>
		    	<td style="text-align: center;">
                	<span class="cui-icon" style="font-size:14pt;cursor:pointer;color:rgb(255, 68, 0)" ng-click="root.pullDowns.splice($index,1); ">删除</span>
                </td>
		    </tr>
		    <tr>
		        <td class="cap-td" style="text-align: left;width:200px">
		        	<span cui_button id="changeTmp()" ng-click="changeTmp()" label="切换模板" icon="file-text-o"></span>
		        	<div ng-repeat='codemirrorVO in root.codemirrors'>
						<input type="text" ng-model="codemirrorVO.form.ddd"></input>
						<input type="text" ng-model="codemirrorVO.form.ss"></input>
						<span>{{codemirrorVO.out}}</span>
						<span cui_code  id="{{codemirrorVO.id}}" ng-model="codemirrorVO.form" ng-code="codemirrorVO.code" ng-out="codemirrorVO.out"></span>
					</div>
		        </td>
		    </tr>
		</table>
	</div>
</div>
</body>
</html>