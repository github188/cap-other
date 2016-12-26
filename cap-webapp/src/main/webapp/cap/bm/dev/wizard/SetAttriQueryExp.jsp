<%
/**********************************************************************
* 设置实体属性查询规则页面
* 2016-08-13 凌晨
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8" deferredSyntaxAllowedAsLiteral="true"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app='setAttriQueryExp'>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>设置实体属性的查询规则</title>
	<top:link href="/cap/bm/common/base/css/base.css"/>
	<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
    <top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src='/cap/dwr/interface/EntityFacade.js'></top:script>
	<style type="text/css">
		
	</style>
	<script type="text/javascript" charset="UTF-8">
		//获取当前页面的父页面
		var parentWindow = cap.searchParentWindow("setAttriQueryExpDialog");
		var winClosePattern = "dialog";
		if(!parentWindow){
			parentWindow = window.opener;
			winClosePattern = "window";
		}
		/*var entityAttrubuteVO = {
				"accessLevel":"private",
				"allowNull":true,
				"associateListAttr":false,
				"attributeLength":1,
				"attributeType":{
					"source":"primitive",
					"type":"int",
					"value":""
				},
				"chName":"性别",
				"dbFieldId":"SEX",
				"description":"性别",
				"engName":"sex",
				"precision":"0",
				"primaryKey":false,
				"queryExpr":"T1.SEX =  #{sex}",
				"queryField":true,
				"queryMatchRule":"1",
				"relationId":"",
				"sortNo":4
			};*/
		
		//从父页面上获取当前实体属性
		var entityAttrubuteVO = null;
		if(parentWindow["getCurrentAttriVO"] && Object.prototype.toString.call(parentWindow["getCurrentAttriVO"]) === "[object Function]"){
			entityAttrubuteVO = parentWindow["getCurrentAttriVO"].call({});
		}
		
		var _ = cui.utils;
		//拿到angularJS的scope
		var scope=null;
		angular.module('setAttriQueryExp', ["cui"]).controller('setAttriQueryExpCtrl',['$scope',function ($scope) {
			
			$scope.parentWindow = parentWindow;
			//当前属性对象
			$scope.selectEntityAttributeVO = entityAttrubuteVO;
			
		   	$scope.ready=function(){
		    	comtop.UI.scan();
		    	scope=$scope;
		    };
		   	
		  	//查询字段切换，填充查询规则
		   	$scope.queryMatchRuleChange=function(){
		   		if($scope.selectEntityAttributeVO.queryField == "true"){
		   			var attributeTypeType = $scope.selectEntityAttributeVO.attributeType.type;
			   		cui("#queryMatchRule").setDatasource(queryMatchRuleData[attributeTypeType]);
			   		//如果是数据库字段,则默认把规则设置为“=”，并把查询表达式拼出来。
			   		if($scope.selectEntityAttributeVO.dbFieldId){ 
			   			$scope.selectEntityAttributeVO.queryMatchRule = "1";
			   			$scope.selectEntityAttributeVO.queryExpr = "T1." + $scope.selectEntityAttributeVO.dbFieldId + " = #{" + $scope.selectEntityAttributeVO.engName + "}";
			   		}
		   		}else{
		   			$scope.selectEntityAttributeVO.queryMatchRule="";
		   			$scope.selectEntityAttributeVO.queryExpr="";
		   		}
		   	};
		   	
		  	//查询规则改变事件
		   	$scope.queryMatchRuleChangeEvent=function(){
		   		var rule= $scope.selectEntityAttributeVO.queryMatchRule;
		   		var coll = $scope.selectEntityAttributeVO.dbFieldId;//"TOP_USER";
				var attr = $scope.selectEntityAttributeVO.engName;//"topUser";
				dwr.TOPEngine.setAsync(false);
				EntityFacade.genQueryExpression(rule,coll,attr,function(data){
					//如果是查询规则为范围,把表达式拆分成两个范围表达式1和范围表达式2
					if(rule == "11"){ 
						$scope.selectEntityAttributeVO.queryExpr = null;
						//var _regex = new RegExp(".*\\sAND\\s.*", "g");
						var _regex = /(.*)\sAND\s(.*)/;
						var _resultArray = _regex.exec(data);
						if(_resultArray != null){
							$scope.selectEntityAttributeVO.queryRange_1 = _resultArray[1] ? _resultArray[1] : "";
							$scope.selectEntityAttributeVO.queryRange_2 = _resultArray[2] ? _resultArray[2] : "";
						}
					}else{
						$scope.selectEntityAttributeVO.queryExpr =data;
						$scope.selectEntityAttributeVO.queryRange_1 = null;
						$scope.selectEntityAttributeVO.queryRange_2 = null;
					}
				});
				dwr.TOPEngine.setAsync(true);
				
				//处理范围查询的查询字段的生成
				$scope.processRangeAttributes(rule);
		   	};
		   	
		   	/**
		   	 * 处理范围查询的查询字段的生成
		   	 *
		   	 * @param queryRuleCode 查询规则的code
		   	 */
		   	$scope.processRangeAttributes = function(queryRuleCode){
		   		//若选择的“查询规则”为“范围”，则自动生成2个范围查询的属性
		   		$scope.range_1_obj = null;
				$scope.range_2_obj = null;
				if(queryRuleCode == "11"){
					//取得生成的属性的engName
					var autoAttrRegex = /.*[#$]{(.+)}.*/;
					var rang_1_result = autoAttrRegex.exec($scope.selectEntityAttributeVO.queryRange_1);
					var rang_2_result = autoAttrRegex.exec($scope.selectEntityAttributeVO.queryRange_2);
					var rang_1_ename = rang_1_result ? rang_1_result[1] : "";
					var rang_2_ename = rang_2_result ? rang_2_result[1] : "";
					
					//当查询规则为范围查询（rule=11）时，生成的两个范围对象
					$scope.range_1_obj = $scope.createEntityAttribute($.trim(rang_1_ename),"（开始查询）");
					$scope.range_2_obj = $scope.createEntityAttribute($.trim(rang_2_ename),"（结束查询）");
				}
		   	};
		   	
		   	/**
		   	 * 选择范围查询，生成查询属性
		   	 *
		   	 * @param _ename 属性英文名称
		   	 * @param _cname 属性中文名称（追加）
		   	 */
		   	$scope.createEntityAttribute = function(_ename, _cname){
		   		var _obj = _.parseJSON(_.stringifyJSON($scope.selectEntityAttributeVO));
		   		_obj.allowNull = true;
		   		_obj.associateListAttr = false;
		   		_obj.chName += _cname;
		   		_obj.engName = _ename;
		   		_obj.dbFieldId = "";
		   		_obj.description += _cname;
		   		_obj.primaryKey = false;
		   		_obj.queryExpr = null;
		   		_obj.queryRange_1 = null;
		   		_obj.queryRange_2 = null;
		   		_obj.queryField = "false";
		   		_obj.queryMatchRule = "";
		   		_obj.relationId = null;
 		   		//_obj.sortNo = $scope.root.entityAttributes.length+1;
		   		_obj.dataItemIds = null;
		   		_obj.queryRangeBy = $scope.selectEntityAttributeVO.dbFieldId;
		   		return _obj;
		   	};
		   	
		   	/**
		   	 * 获取点击确认按钮需要返回的数据
		   	 */
		   	$scope.getReturnResultData = function(){
		   		//定义页面点击确定按钮后需要返回的数据
		   		$scope.resultData = [];
		   		//第一个元素为当前属性自身
		   		$scope.resultData.push($scope.selectEntityAttributeVO);
		   		if($scope.range_1_obj && $scope.range_2_obj){
			   		$scope.resultData.push($scope.range_1_obj);
			   		$scope.resultData.push($scope.range_2_obj);
		   		}
		   		
		   		return $scope.resultData;
		   	};
		   	
		   	/**
		   	 *	确定
		   	 */
		   	$scope.confirm = function(){
		   		var callback = $scope.parentWindow ? $scope.parentWindow["changeAttiQueryExp"] : null;
		   		if(callback && Object.prototype.toString.call(callback) === "[object Function]"){
		   			callback.call({},$scope.getReturnResultData());
		   		}
		   		$scope.close();
		   	};
		   	
		   	/**
		   	 * 关闭窗口
		   	 */
		   	$scope.close = function(){
		   		if(winClosePattern == "window"){
			   		window.close();
		   		}else{
		   			$scope.parentWindow["setAttriQueryExpDialog"].hide();
		   		}
		   	};
		}]);
		
		
		//查询规则的数组
		var queryMatchRuleData = {
	            "int": [
				   {queryMatchRule:"0",queryMatchRuleName:"请选择"},
	               {queryMatchRule:"1",queryMatchRuleName:"="},
	               {queryMatchRule:"6",queryMatchRuleName:"!="},
	               {queryMatchRule:"7",queryMatchRuleName:">"},
	               {queryMatchRule:"8",queryMatchRuleName:">="},
	               {queryMatchRule:"9",queryMatchRuleName:"<"},
	               {queryMatchRule:"10",queryMatchRuleName:"<="},
	               {queryMatchRule:"11",queryMatchRuleName:"范围"}
	            ],
	            "String" :[
				   {queryMatchRule:"0",queryMatchRuleName:"请选择"},
	               {queryMatchRule:"1",queryMatchRuleName:"="},
	               {queryMatchRule:"2",queryMatchRuleName:"全匹配 "},
	               {queryMatchRule:"3",queryMatchRuleName:"右匹配"},
	               {queryMatchRule:"4",queryMatchRuleName:"左匹配"},
	               {queryMatchRule:"5",queryMatchRuleName:"in"}
	            ],
	            "boolean" :[
	   			   {queryMatchRule:"0",queryMatchRuleName:"请选择"},
	               {queryMatchRule:"1",queryMatchRuleName:"是"},
	               {queryMatchRule:"2",queryMatchRuleName:"否 "}
	            ],
	            "double" :[
	   			   {queryMatchRule:"0",queryMatchRuleName:"请选择"},
	               {queryMatchRule:"1",queryMatchRuleName:"="},
	               {queryMatchRule:"6",queryMatchRuleName:"!="},
	               {queryMatchRule:"7",queryMatchRuleName:">"},
	               {queryMatchRule:"8",queryMatchRuleName:">="},
	               {queryMatchRule:"9",queryMatchRuleName:"<"},
	               {queryMatchRule:"10",queryMatchRuleName:"<="},
	               {queryMatchRule:"11",queryMatchRuleName:"范围"}
	            ],
	            "byte" :[
	   			   {queryMatchRule:"0",queryMatchRuleName:"请选择"},
	               {queryMatchRule:"1",queryMatchRuleName:"="},
	               {queryMatchRule:"6",queryMatchRuleName:"!="},
	               {queryMatchRule:"7",queryMatchRuleName:">"},
	               {queryMatchRule:"8",queryMatchRuleName:">="},
	               {queryMatchRule:"9",queryMatchRuleName:"<"},
	               {queryMatchRule:"10",queryMatchRuleName:"<="},
	               {queryMatchRule:"11",queryMatchRuleName:"范围"}
	            ],
	            "short" :[
	           			   {queryMatchRule:"0",queryMatchRuleName:"请选择"},
	                       {queryMatchRule:"1",queryMatchRuleName:"="},
	                       {queryMatchRule:"6",queryMatchRuleName:"!="},
	                       {queryMatchRule:"7",queryMatchRuleName:">"},
	                       {queryMatchRule:"8",queryMatchRuleName:">="},
	                       {queryMatchRule:"9",queryMatchRuleName:"<"},
	                       {queryMatchRule:"10",queryMatchRuleName:"<="},
	                       {queryMatchRule:"11",queryMatchRuleName:"范围"}
	            ],
	            "char" :[
	           			   {queryMatchRule:"0",queryMatchRuleName:"请选择"},
	                       {queryMatchRule:"1",queryMatchRuleName:"="},
	                       {queryMatchRule:"6",queryMatchRuleName:"!="},
	                       {queryMatchRule:"7",queryMatchRuleName:">"},
	                       {queryMatchRule:"8",queryMatchRuleName:">="},
	                       {queryMatchRule:"9",queryMatchRuleName:"<"},
	                       {queryMatchRule:"10",queryMatchRuleName:"<="},
	                       {queryMatchRule:"11",queryMatchRuleName:"范围"}
	            ],
	            "float" :[
	         			   {queryMatchRule:"0",queryMatchRuleName:"请选择"},
	                     {queryMatchRule:"1",queryMatchRuleName:"="},
	                     {queryMatchRule:"6",queryMatchRuleName:"!="},
	                     {queryMatchRule:"7",queryMatchRuleName:">"},
	                     {queryMatchRule:"8",queryMatchRuleName:">="},
	                     {queryMatchRule:"9",queryMatchRuleName:"<"},
	                     {queryMatchRule:"10",queryMatchRuleName:"<="},
	                     {queryMatchRule:"11",queryMatchRuleName:"范围"}
	           ],
	          "long" :[
	       			   {queryMatchRule:"0",queryMatchRuleName:"请选择"},
	                   {queryMatchRule:"1",queryMatchRuleName:"="},
	                   {queryMatchRule:"6",queryMatchRuleName:"!="},
	                   {queryMatchRule:"7",queryMatchRuleName:">"},
	                   {queryMatchRule:"8",queryMatchRuleName:">="},
	                   {queryMatchRule:"9",queryMatchRuleName:"<"},
	                   {queryMatchRule:"10",queryMatchRuleName:"<="},
	                   {queryMatchRule:"11",queryMatchRuleName:"范围"}
	            ],
	            "java.sql.Date" :[
	   			   {queryMatchRule:"0",queryMatchRuleName:"请选择"},
	               {queryMatchRule:"1",queryMatchRuleName:"="},
	               {queryMatchRule:"7",queryMatchRuleName:">"},
	               {queryMatchRule:"8",queryMatchRuleName:">="},
	               {queryMatchRule:"9",queryMatchRuleName:"<"},
	               {queryMatchRule:"10",queryMatchRuleName:"<="},
	               {queryMatchRule:"11",queryMatchRuleName:"范围"}
	           ],
	           "java.sql.Timestamp" :[
	  			   {queryMatchRule:"0",queryMatchRuleName:"请选择"},
	               {queryMatchRule:"1",queryMatchRuleName:"="},
	               {queryMatchRule:"7",queryMatchRuleName:">"},
	               {queryMatchRule:"8",queryMatchRuleName:">="},
	               {queryMatchRule:"9",queryMatchRuleName:"<"},
	               {queryMatchRule:"10",queryMatchRuleName:"<="},
	               {queryMatchRule:"11",queryMatchRuleName:"范围"}
	           ],
	          "java.util.List": [
	   			    {queryMatchRule:"0",queryMatchRuleName:"请选择"},
	                {queryMatchRule:"5",queryMatchRuleName:"in"},
	                {queryMatchRule:"11",queryMatchRuleName:"范围"}
	           ]
	        };
		//初始化查询规则
		if(entityAttrubuteVO && entityAttrubuteVO.attributeType){
			var initQueryMatchRuleData = queryMatchRuleData[entityAttrubuteVO.attributeType.type];
		}
	</script>
</head>
<body class="body_layout" ng-controller="setAttriQueryExpCtrl" data-ng-init="ready()">
	<div class="cap-page">
	    <div class="cap-area" style="border-top:1px solid #ccc;width:100%;">
			<table class="cap-table-fullWidth">
			    <tr>
			        <td  class="cap-form-td" style="text-align: left;">
			        	<table class="cap-table-fullWidth">
			        		<tr>
			        			<td  class="cap-form-td" style="text-align: left;padding-left:5px; width:250px">
									<span class="cap-group" style="font-weight:bold">设置实体属性的查询规则</span>
						        </td>
			        			<td  class="cap-form-td" style="text-align: right;padding-right:5px" ng-show="parentWindow != null">
									<span cui_button id="confim" button_type="green-button" ng-click="confirm()" label="确定"></span>
									<span cui_button id="close" ng-click="close()" label="关闭"></span>
						        </td>
			        		</tr>
			        	</table>
			        </td>
			    </tr>
			    <tr>
			        <td style="text-align: left;">
			    		<table class="cap-table-fullWidth">
			    		    <tr>
						        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
						        	<span uitype="Label" value="属性英文名："></span>
						        </td>
						        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
						        	<span cui_input readonly="true" id="engName" ng-model="selectEntityAttributeVO.engName" validate="" width="100%"/>
						        </td>
						        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
						        	<span uitype="Label" value="属性中文名："></span>
						        </td>
						         <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
			                        <span cui_input readonly="true" id="chName" ng-model="selectEntityAttributeVO.chName" validate="" width="100%"/>
						        </td>
						    </tr>
						   <tr>
						        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
						        	<span uitype="Label" value="对应字段："></span>
						        </td>
						        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
						        	<span cui_input readonly="true" id="dbFieldVOEngName" ng-model="selectEntityAttributeVO.dbFieldId" validate="" width="100%"/>
						        </td>
						         <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
						        	<span uitype="Label" value="查询字段："></span>
						        </td>
						         <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
			                        <span cui_radiogroup readonly="false" name="queryField" id="queryField" ng-model="selectEntityAttributeVO.queryField" ng-change="queryMatchRuleChange()">
			                            <input type="radio" value="true" name="queryField"  />是
			                            <input type="radio" value="false" name="queryField" />否
			                        </span>
						        </td>
						    </tr>
						    <tr ng-show="selectEntityAttributeVO.queryField=='true'&&selectEntityAttributeVO.attributeType.type!=''">
						        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
						        	查询规则：
						        </td>
						        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap" >
						          <span cui_pulldown id="queryMatchRule" ng-model="selectEntityAttributeVO.queryMatchRule" datasource="initQueryMatchRuleData" ng-change="queryMatchRuleChangeEvent()"  value_field="queryMatchRule" label_field="queryMatchRuleName" width="100%" >
								  </span>
								</td>
						        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
						        </td>
						         <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
						        </td>
						    </tr>
						    
						    <tr ng-show="selectEntityAttributeVO.queryField=='true'&&selectEntityAttributeVO.attributeType.type!=''&&selectEntityAttributeVO.queryMatchRule==11">
						        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
						        	范围表达式1：
						        </td>
						        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap" >
						          <span cui_input id="queryRange_1" ng-model="selectEntityAttributeVO.queryRange_1"  width="100%"/>
								</td>
						        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
						        	范围表达式2：
						        </td>
						        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
							         <span cui_input id="queryRange_2" ng-model="selectEntityAttributeVO.queryRange_2"  width="100%"/>
						        </td>
						    </tr>
						    
						    <tr ng-show="selectEntityAttributeVO.queryField=='true'&&selectEntityAttributeVO.attributeType.type!=''&&selectEntityAttributeVO.queryMatchRule!=11">
						        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
						        	查询表达式：
						        </td>
						         <td class="cap-td" style="text-align: left;width:auto" colspan="3" nowrap="nowrap">
	      		                   <span cui_textarea id="queryExpr" ng-model="selectEntityAttributeVO.queryExpr" width="100%" height="80px" ></span>
						        </td>
						    </tr>
						    <tr ng-show="selectEntityAttributeVO.queryField=='true'&&selectEntityAttributeVO.attributeType.type!=''">
			                    <td >
			                    </td>	
		                        <td colspan="3"><span><font style="color: #B5B5B5">&nbsp;表别名必须为<span style="color:red;">T1</span>,多条SQL语句请用“;”加换行进行分隔。</font></span></td>
		                     </tr>
						  </table>
						  </br>
					 </td>
			    </tr>
			</table>
		</div>	
	</div>
</body>
</html>