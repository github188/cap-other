<%
/**********************************************************************
* 边框布局属性编辑器
* 2015-7-21 郑重 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app='borderlayoutEditor'>
<head>
    <meta charset="UTF-8">
    <title>边框布局属性编辑器</title>
    <top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <style type="text/css">
    	
    </style>
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
	<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
	<top:script src="/cap/bm/common/jct/js/jct.js"></top:script>
    <script type="text/javascript">
    
    var packageId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
    var pageId="<%=request.getParameter("modelId")%>";
    var items=null;
    var fixed=null;
    var pageSession = new cap.PageStorage(pageId);
	var dataStore = pageSession.get("dataStore");
    
  	//将数据集中定义的常量初始化到此页面中
    function initPageConstant(pageDataStores){
 		_.forEach(_.result( _.find(pageDataStores,{modelType:'pageConstant'}), "pageConstantList" ),function (n) {
 			window[n.constantName] = '';
 		});
 		items=<%=request.getParameter("items")%>;
 		fixed=<%=request.getParameter("fixed")%>;
 		for(var i=0;i<items.length;i++){
			//设置fixed属性
			if(items[i].urlstr!="" && items[i].urlstr!=null){
				items[i].url=items[i].urlstr;
			}
			if(fixed[items[i].position] != "" && fixed[items[i].position] != null){
				var position = items[i].position;
				if(position === "left" || position === "right" || position === "center"){
					items[i].fixedWidth = fixed[items[i].position];
				} else if(position === "top" || position === "bottom"){
					items[i].fixedHeight = fixed[items[i].position];
				}
			}
		}
    }
  	
    initPageConstant(dataStore);
    
    var data=items!=null?items:[];
    
    var scope=null;
    angular.module('borderlayoutEditor', ["cui"]).controller('borderlayoutEditorCtrl', function ($scope) {
    	$scope.data=data;
    	$scope.selectBorder=data.length>0?data[0]:{};
    	
    	$scope.ready=function(){
	    	comtop.UI.scan();
	    	scope=$scope;
	    }
    	
    	$scope.borderTdClick=function(item){
    		$scope.selectBorder=item;
	    }
    	
    	$scope.deleteBorder=function(){
    		var ar=[];
    		for(var i=0;i<$scope.data.length;i++){
    			if($scope.data[i].position!=$scope.selectBorder.position){
    				ar.push($scope.data[i]);
    			}
    		}
    		$scope.data=ar;
    		$scope.selectBorder=data.length>0?data[0]:{};
	    }
    	
    	$scope.setBorderlayoutItems=function(){
    		var strBorderlayoutItems="";
    		var fixed = {};
    		if($scope.data.length > 0){
	    		strBorderlayoutItems="[";
	    		for(var i=0;i<$scope.data.length;i++){
	    			//设置fixed属性
	    			if($scope.data[i].position=="left" || $scope.data[i].position=="center" || $scope.data[i].position=="right"){
	    				fixed[$scope.data[i].position]=$scope.data[i].fixedWidth;
					} else {
						fixed[$scope.data[i].position]=$scope.data[i].fixedHeight;
					}
	    			strBorderlayoutItems+=$scope.formateDateByTemplete($scope.data[i])+",";
	    		}
	    		if(strBorderlayoutItems.length>1){
	    			strBorderlayoutItems=strBorderlayoutItems.substring(0,strBorderlayoutItems.length-1);
	    		}
	    		strBorderlayoutItems+="]";
	    		var arr = _.filter($scope.data, function(n){ return n.position == 'left' || n.position == 'right'|| n.position == 'center'});
	    		if(arr.length > 0){
		    		fixed["middle"] = _.every(arr, 'fixedWidth');
	    		}
    		}
    		window.opener.setBorderlayoutItems(strBorderlayoutItems, $scope.data.length > 0 ? cui.utils.stringifyJSON(fixed) : '');
    		window.close();
    	}
        
        $scope.formateDateByTemplete=function(curData){
        	$scope.curData=curData;
    		var instance = new jCT(jQuery('#template').val());
    		instance.Build();
    		return instance.GetView();
        }
        
    });
    
    // 只输入数字和小数点
    function keyPress(event, self) { 
    	//响应鼠标事件，允许左右方向键移动 
        if(event.keyCode == 37 | event.keyCode == 39){ 
            return; 
        } 
        //先把非数字的都替换掉，除了数字和. 
        self.$input[0].value = self.$input[0].value.replace(/[^\d.]/g,""); 
        //必须保证第一个为数字而不是. 
        self.$input[0].value = self.$input[0].value.replace(/^\./g,""); 
        //保证只有出现一个.而没有多个. 
        self.$input[0].value = self.$input[0].value.replace(/\.{2,}/g,"."); 
        //保证.只出现一次，而不能出现两次以上 
        self.$input[0].value = self.$input[0].value.replace(".","$#$").replace(/\./g,"").replace("$#$","."); 
    }    
    
    var menuData = {
    	datasource:[
    		{id:'left',label:'left',fixed:['fixedWidth', true]},
    		{id:'center',label:'center',fixed:['fixedWidth', false]},
    		{id:'right',label:'right',fixed:['fixedWidth', true]},
    		{id:'top',label:'top',fixed:['fixedHeight', true]},
    		{id:'bottom',label:'bottom',fixed:['fixedHeight', true]}
    	],
    	on_click: function(obj){
    		var flag=true;
    		for(var i=0;i<scope.data.length;i++){
    			if(scope.data[i].position==obj.id){
    				flag=false;
    				break;
    			}
    		}
    		if(flag){
    			var item = {position:obj.id};
    			item[obj.fixed[0]] = obj.fixed[1];
    			scope.data.push(item);
    			scope.selectBorder = item;
    			scope.$digest();
    		}
    	}
   }
    
  	//打开数据模型选择界面
    function openDataStoreSelect(flag,isWrap) {
    	var url = '${pageScope.cuiWebRoot}/cap/bm/dev/page/designer/DataStoreSelect.jsp?packageId=' + packageId+"&modelId="+pageId+"&flag="+flag+"&isWrap="+isWrap+"&selectType=url";
    	var top=(window.screen.availHeight-600)/2;
    	var left=(window.screen.availWidth-800)/2;
    	window.open (url,'openDataStoreSelect','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
    }

    //数据模型选择回调
    function importDataStoreVariableCallBack(variableSelect,flag,isWrap){
   		var value=variableSelect;
   		if(!variableSelect || variableSelect === '') {
   			eval(flag+"=null;");
   		}else {
   			eval(flag+"='"+value+"';");	
   		}
    	scope.$digest();
    }
    
    var widthValRule = [{'type':'numeric','rule':{}}];

    //统一校验函数
    function validateAll() {
    	var validate = new cap.Validate();
    	var valRule = {
    		ename : actionEnameValRule,
    		cname : actionCnameValRule
    	};
    	var result = validate.validateAllElement(root.pageActions, valRule);
    	return result;
    }
    
    </script>
</head>
<body style="background-color:#f5f5f5;" ng-controller="borderlayoutEditorCtrl" data-ng-init="ready()">
<div class="cap-page" style="height: 580px;">
	<div class="cap-area" style="width:100%; height:100%; overflow-y: auto">
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        	<span id="formTitle" uitype="Label" value="边框布局属性编辑器" class="cap-label-title"></span>
		        </td>
		        <td class="cap-td" style="text-align: right;">
		        	<span id="code" uitype="Button" label="确定" ng-click="setBorderlayoutItems()"></span>
		        	<span id="code" uitype="Button" label="关闭" onClick="window.close()"></span>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        	<span uitype="Button" label="添加面板" menu="menuData"></span>
		        	<span uitype="Button" label="删除" ng-click="deleteBorder()"></span>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth" style="width:100%; height: 86%;">
		    <tr>
		        <td class="cap-td" style="text-align: left;width:100px">
		        	<table class="custom-grid" style="width: 135px">
		                <thead>
		                    <tr>
		                        <th>
	                            	面板位置
		                        </th>
		                    </tr>
		                </thead>
                        <tbody>
                            <tr ng-repeat="item in data track by $index"  style="background-color: {{selectBorder.position==item.position ? '#99ccff':'#ffffff'}}">
                                <td style="text-align:center;cursor:pointer" ng-click="borderTdClick(item)" >
                                    {{item.position}}
                                </td>
                            </tr>
                       </tbody>
		            </table>
		        </td>
		        <td style="text-align: left;border-right:1px solid #ddd;padding-top:10px">
		        </td>
		        <td class="cap-td" style="text-align: left;">
		        	<table class="cap-table-fullWidth" ng-show="data.length > 0">
		        		<tr>
					        <td class="cap-td" style="text-align: right;width:200px">
					        	position(面板位置)：
					        </td>
					        <td class="cap-td" style="text-align: left;width:200px">
					        	{{selectBorder.position}}
					        </td>
					        <td class="cap-td" style="text-align: left;">
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-td" style="text-align: right;width:200px">
					        	url(页面url)：
					        </td>
					        <td class="cap-td" style="text-align: left;width:200px">
					        	<span cui_clickinput id="url" ng-model="selectBorder.url" onclick="openDataStoreSelect('scope.selectBorder.url',false)"></span>
					        </td>
					        <td class="cap-td" style="text-align: left;">
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-td" style="text-align: right;width:200px">
					        	fixed(固定)：
					        </td>
					        <td class="cap-td" style="text-align: left;width:200px">
					        	<span ng-if="selectBorder.position=='top' || selectBorder.position=='bottom'" ><input type="checkbox" name="fixedHeight" ng-model="selectBorder.fixedHeight"/> 高度</span>
					        	<span ng-if="selectBorder.position=='left' || selectBorder.position=='right' || selectBorder.position=='center'" ><input type="checkbox" name="fixedWidth" ng-model="selectBorder.fixedWidth"/> 宽度</span>
					        </td>
					        <td class="cap-td" style="text-align: left;">
					        </td>
					    </tr>
					    <tr ng-if="selectBorder.position == 'left' || selectBorder.position == 'right' || selectBorder.position == 'center'">
					        <td class="cap-td" style="text-align: right;width:200px">
					        	width(宽度)：
					        </td>
					        <td class="cap-td" style="text-align: left;width:200px">
					        	<span cui_input id="width" ng-model="selectBorder.width" on_keyup="keyPress"></span>
					        </td>
					        <td class="cap-td" style="text-align: left;">
					        	默认值：500
					        </td>
					    </tr>
					    <tr ng-if="selectBorder.position == 'top' || selectBorder.position == 'bottom'">
					        <td class="cap-td" style="text-align: right;width:200px">
					        	height(高度)：
					        </td>
					        <td class="cap-td" style="text-align: left;width:200px">
					        	<span cui_input name="height" ng-model="selectBorder.height" on_keyup="keyPress"></span>
					        </td>
					        <td class="cap-td" style="text-align: left;">
					        	默认值：300
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-td" style="text-align: right;width:200px">
					        	gap(间距)：
					        </td>
					        <td class="cap-td" style="text-align: left;width:200px">
					        	<span cui_input  name="gap" ng-model="selectBorder.gap"></span>
					        </td>
					        <td class="cap-td" style="text-align: left;">
					        	默认值：0px 0px 0px 0px
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-td" style="text-align: right;width:200px">
					        	resizable(是否可以拖动面板)：
					        </td>
					        <td class="cap-td" style="text-align: left;width:200px">
					        	<input type="checkbox" name="resizable" ng-model="selectBorder.resizable"/>
					        </td>
					        <td class="cap-td" style="text-align: left;">
					        	默认值：false
					        </td>
					    </tr>
					    <tr ng-show="selectBorder.resizable">
					        <td class="cap-td" style="text-align: right;width:200px">
					        	min_size(拖动面板的最小值)：
					        </td>
					        <td class="cap-td" style="text-align: left;width:200px">
					        	<span cui_input  name="min_size" ng-model="selectBorder.min_size" on_keyup="keyPress"></span>
					        </td>
					        <td class="cap-td" style="text-align: left;">
					        	默认值：30
					        </td>
					    </tr>
					    <tr ng-show="selectBorder.resizable">
					        <td class="cap-td" style="text-align: right;width:200px">
					        	max_size(拖动面板的最大值)：
					        </td>
					        <td class="cap-td" style="text-align: left;width:200px">
					        	<span cui_input  name="max_size" ng-model="selectBorder.max_size" on_keyup="keyPress"></span>
					        </td>
					        <td class="cap-td" style="text-align: left;">
					        	默认值：30
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-td" style="text-align: right;width:200px">
					        	split_size(分割线的宽度)：
					        </td>
					        <td class="cap-td" style="text-align: left;width:200px">
					        	<span cui_input  name="split_size" ng-model="selectBorder.split_size" on_keyup="keyPress"></span>
					        </td>
					        <td class="cap-td" style="text-align: left;">
					        	默认值：2
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-td" style="text-align: right;width:200px">
					        	is_header(是否带有标题)：
					        </td>
					        <td class="cap-td" style="text-align: left;width:200px">
					        	<input type="checkbox" name="is_header" ng-model="selectBorder.is_header"/>
					        </td>
					        <td class="cap-td" style="text-align: left;">
					        	默认值：false
					        </td>
					    </tr>
					    <tr ng-show="selectBorder.is_header">
					        <td class="cap-td" style="text-align: right;width:200px">
					        	header_content(标题内容)：
					        </td>
					        <td class="cap-td" style="text-align: left;width:200px">
					        	<span cui_input  name="header_content" ng-model="selectBorder.header_content"></span>
					        </td>
					        <td class="cap-td" style="text-align: left;">
					        </td>
					    </tr>
					    <tr ng-show="selectBorder.is_header">
					        <td class="cap-td" style="text-align: right;width:200px">
					        	header_height(标题高度)：
					        </td>
					        <td class="cap-td" style="text-align: left;width:200px">
					        	<span cui_input  name="header_height" ng-model="selectBorder.header_height" on_keyup="keyPress"></span>
					        </td>
					        <td class="cap-td" style="text-align: left;">
					        	默认值：30
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-td" style="text-align: right;width:200px">
					        	collapsable(是否允许折叠)：
					        </td>
					        <td class="cap-td" style="text-align: left;width:200px">
					        	<input type="checkbox" name="collapsable" ng-model="selectBorder.collapsable"/>
					        </td>
					        <td class="cap-td" style="text-align: left;">
					        	默认值：false
					        </td>
					    </tr>
					    <tr ng-show="selectBorder.collapsable">
					        <td class="cap-td" style="text-align: right;width:200px">
					        	show_expand_icon(是否显示折叠按钮)：
					        </td>
					        <td class="cap-td" style="text-align: left;width:200px">
					        	<input type="checkbox" name="show_expand_icon" ng-model="selectBorder.show_expand_icon"/>
					        </td>
					        <td class="cap-td" style="text-align: left;">
					        	默认值：false
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-td" style="text-align: right;width:200px">
					        	id(面板id)：
					        </td>
					        <td class="cap-td" style="text-align: left;width:200px">
					        	<span cui_input  name="id" ng-model="selectBorder.id"></span>
					        </td>
					        <td class="cap-td" style="text-align: left;">
					        </td>
					    </tr>
					</table>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        </td>
		    </tr>
		</table>
	</div>
</div>
<textarea id="template" style="display:none">
  	{
	<!---if(scope.curData.id!="" && scope.curData.id!=null){-->
	'id': '+-scope.curData.id-+', 
	<!---}-->
	<!---if(scope.curData.width!="" && scope.curData.width!=null){-->
	'width': +-scope.curData.width-+,
	<!---}-->
	<!---if(scope.curData.height!="" && scope.curData.height!=null){--> 
	'height': +-scope.curData.height-+,
	<!---}-->
	<!---if(scope.curData.gap!="" && scope.curData.gap!=null){--> 
	'gap': '+-scope.curData.gap-+',
	<!---}-->
	<!---if(scope.curData.resizable!="" && scope.curData.resizable!=null){-->
	'resizable': +-scope.curData.resizable-+,
	<!---}-->
	<!---if(scope.curData.min_size!="" && scope.curData.min_size!=null){--> 
	'min_size': +-scope.curData.min_size-+,
	<!---}-->
	<!---if(scope.curData.max_size!="" && scope.curData.max_size!=null){--> 
	'max_size': +-scope.curData.max_size-+,
	<!---}-->
	<!---if(scope.curData.split_size!="" && scope.curData.split_size!=null){--> 
	'split_size': +-scope.curData.split_size-+,
	<!---}-->
	<!---if(scope.curData.is_header!="" && scope.curData.is_header!=null){--> 
	'is_header': +-scope.curData.is_header-+,
	<!---}-->
	<!---if(scope.curData.header_content!="" && scope.curData.header_content!=null){-->
	'header_content': '+-scope.curData.header_content-+',
	<!---}-->
	<!---if(scope.curData.header_height!="" && scope.curData.header_height!=null){-->
	'header_height': +-scope.curData.header_height-+,
	<!---}-->
	<!---if(scope.curData.collapsable!="" && scope.curData.collapsable!=null){-->
	'collapsable': +-scope.curData.collapsable-+,
	<!---}-->
	<!---if(scope.curData.url!="" && scope.curData.url!=null){-->
	'url': +-scope.curData.url-+,
	'urlstr': '+-scope.curData.url-+',
	<!---}else{-->
	'url': '',
	<!---}-->
	<!---if(scope.curData.show_expand_icon!="" && scope.curData.show_expand_icon!=null){-->
	'show_expand_icon': +-scope.curData.show_expand_icon-+,
	<!---}-->
	'position':'+-scope.curData.position-+'
}
</textarea>
</body>
</html>