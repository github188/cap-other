<%
/**********************************************************************
* 方法参数选择页面
* 2016-07-29 刘城2  
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app='customEditableGridThead'>
<head>
  <title>方法参数选择页面</title>
  <top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <top:link href="/cap/bm/dev/page/uilibrary/css/base.css"/>
    <style type="text/css">
      .tab_panel {
        height: 502px;
        overflow: auto;
      }
      .properties-div{
        height: 420px;
        overflow: auto;
      }
      .custom_div{
        height: auto;
        overflow: auto;
      }
    </style>
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
  <top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
  <top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
  <top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
    <top:script src='/cap/dwr/engine.js'></top:script>
  <top:script src='/cap/dwr/util.js'></top:script>
  <top:script src="/cap/dwr/interface/EntityFacade.js"></top:script>
</head>
<body ng-controller="customEditableGridTheadCtrl" data-ng-init="ready()">
<div>
  <div class="cap-area" style="padding: 2px;">
    <table class="cap-table-fullWidth">
        <tr>
              <td class="cap-td" style="text-align: left;height: 35px;min-width:245px" nowrap="nowrap">
                
              <font id="pageTittle" >方法参数列表</font> 
              </td>
              <td class="cap-td" style="text-align: right;" colspan="3">
                <span id="saveToEntity" uitype="Button" ng-click="selectParam()" label="确定"></span> 
                <span id="closeTemplate" uitype="Button" ng-click="paramClose()" label="关闭"></span> 
              </td>
          </tr>
          <tr style="border-top:1px solid #ddd;" ng-if="paramshowFlag">
              <td class="cap-td" style="text-align: center; padding: 2px; width: 100%;" colspan="4">
                <div class="custom_div">
                  <table class="custom-grid" style="width: 100%;">
                        <thead>
                            <tr>
                              <th style="width:30px">
                                <input type="checkbox"  >
                                </th>
                                <th style="width:16%">
                                    参数名称
                                </th>
                                <th style="width:16%">
                                    中文名称
                                </th>
                                <th style="width:16%">
                                    参数类型
                                </th>
                                <th>
                                    描述
                                </th>
                            </tr>
                        </thead>
                            <tbody>
                                <tr ng-repeat="parameterVo in parameters track by $index " style="background-color: {{parameterVo.check == true ? '#99ccff' : '#ffffff'}}">
                                    <td style="text-align: center;">
                                        <input type="checkbox" name="{{'parameterVo'+($index + 1)}}" ng-model="parameterVo.check" >
                                    </td>
                                    <td style="text-align:center;"  ng-click="tdClick(parameterVo)">
                                      <!--  参数类型为 java.util.Map -->
                                      <span cui_input id="engName" ng-click="editMethodParameter(parameterVo.parameterId)" ng-model="parameterVo.engName" style="cursor:pointer;color:#2b71d9;" readonly="{{!(parameterVo.dataType.type=='java.util.Map' && parameters.length==1)}}" width="100%" />
                                    </td>
                                    <td style="text-align: center;" ng-click="tdClick(parameterVo)">
                                         {{parameterVo.chName}}
                                    </td>
                                    <td style="text-align: center;" ng-click="tdClick(parameterVo)">
                                        {{parameterVo.dataType.type}}
                                    </td>
                                    <td style="text-align: left;" ng-click="tdClick(parameterVo)">
                                        {{parameterVo.description}}
                                    </td>
                                </tr>
                                <tr ng-if="!parameters || parameters.length == 0 ">
                                  <td colspan="5" class="grid-empty"> 本列表暂无记录</td>
                                </tr>
                           </tbody>
                    </table>
                  </div>
              </td>
          </tr>
          <tr ng-if="!paramshowFlag">
            <td class="cap-td" style="text-align: center; padding: 2px; width: 100%;" colspan="4" >
              <div class="custom_div">
                <table class="custom-grid" style="width: 100%;" >
                    <thead>
                        <tr>
                            <th style="width:30px">
                                
                            </th>
                            <th>
                                属性名称
                            </th>
                            <th>
                                中文名称
                            </th>
                            <th>
                                属性类型
                            </th>
                            <th>
                                数据库字段
                            </th>
                        </tr>
                    </thead>
                        <tbody>
                            <tr ng-repeat="attributeVo in attributes track by $index" style="background-color: {{attributeVo.check == true ? '#99ccff' : '#ffffff'}}">
                                <td style="text-align: center;">
                                    <input type="radio" name="attributeVo" ng-checked="attributeVo.check" ng-click="gridAttributeTdClick(attributeVo)">
                                </td>
                                <td style="text-align:left;cursor:pointer" ng-click="gridAttributeTdClick(attributeVo)">
                                    {{attributeVo.engName}}
                                </td>
                                 <td style="text-align:left;cursor:pointer" ng-click="gridAttributeTdClick(attributeVo)">
                                    {{attributeVo.chName}}
                                </td>
                                 <td style="text-align:left;cursor:pointer" ng-click="gridAttributeTdClick(attributeVo)">
                                    {{attributeVo.attributeType.type}}
                                </td>
                                 <td style="text-align:left;cursor:pointer" ng-click="gridAttributeTdClick(attributeVo)">
                                    {{attributeVo.dbFieldId}}
                                </td>
                            </tr>
                       </tbody>
                </table>
              </div>
            </td>
          </tr>
    </table>
  </div>
</div>

<script type="text/javascript">
var scope = {};
var selectEntityMethodVO = window.parent.scope.selectEntityMethodVO;

angular.module('customEditableGridThead', ["cui"]).controller('customEditableGridTheadCtrl', function ($scope, $compile) {
  //数据模型属性（左侧表格数据源）
  //数据模型属性（左侧表格数据源）
  $scope.attributes　=　[];
  $scope.paramshowFlag = true;
  $scope.reBackValue = "";
  $scope.ready=function(){
      scope=$scope;
      comtop.UI.scan();
      //$scope.initAttributes();
      $scope.parameters=jQuery.extend(true,[],selectEntityMethodVO.parameters);//getPureDate(selectEntityMethodVO.parameters);
  }

    //初始化数据属性表格
  $scope.initAttributes = function (modelId){
    //var modelId = "com.comtop.lc.meeting.entity.MeetingRoom";
    dwr.TOPEngine.setAsync(false);
    EntityFacade.getSelfAndParentAttributes(modelId,function(data){
      $scope.attributes = data;
    });
    dwr.TOPEngine.setAsync(true);
  }

   //选择参数
  $scope.editMethodParameter = function(id){

  }
  //选择参数
  $scope.selectParam = function(){
    if (!$scope.parameters||$scope.parameters.length==0) {
      cui.alert("当前方法参数为空，请点击关闭页面");
    }

    var selectParamData = {};
    var count = 0;
    //如果是主列表显示
    if ($scope.paramshowFlag) {
      for (var i = 0; i < $scope.parameters.length; i++) {
        count++;
        if ($scope.parameters[i].check == true) {

          if ($scope.parameters[i].dataType.type == "entity") {
            $scope.paramshowFlag = false;
            $scope.reBackValue = $scope.parameters[i].engName;
            $scope.initAttributes($scope.parameters[i].dataType.value);
          } else {
            $scope.reBackValue = $scope.parameters[i].engName;
            window.parent.scope.setWhereConditionCallBack($scope.reBackValue, $scope.parameters[i].dataType.type);
          }
        }
      }

      if (count == 0) {
        cui.alert("请选择方法参数");
      }
    } else {
      for (var i = 0; i < $scope.attributes.length; i++) {
        selectParamData = $scope.attributes[i];
        count++;
        if (selectParamData.check == true) {
          if ($scope.parameters.length > 1) {
            $scope.reBackValue = $scope.reBackValue + "." + selectParamData.engName;
          } else {
            $scope.reBackValue = selectParamData.engName;
          }
          window.parent.scope.setWhereConditionCallBack($scope.reBackValue, selectParamData.attributeType.type);
        }
      }
      if (count == 0) {
        cui.alert("请选择实体属性");
      }
    }
    
  }

  $scope.tdClick = function(vo){
    vo.check = true;
    for (var i = 0; i < $scope.parameters.length; i++) {
      if ($scope.parameters[i].parameterId!=vo.parameterId) {
        $scope.parameters[i].check = false;
      }
    }
    //其他全部取消选中
  }
  $scope.gridAttributeTdClick=function(attributeVo){
    attributeVo.check = true;
    for (var i = 0; i < $scope.attributes.length; i++) {
      if ($scope.attributes[i].dbFieldId!=attributeVo.dbFieldId) {
        $scope.attributes[i].check = false;
      }
    }
  }

  //关闭页面
  $scope.paramClose = function(){
    window.parent.getWhereConditionDialog.hide();
  }
  
});
    
  

//判断对象不为空
function isNotEmptyObject( obj ) {
    for ( var name in obj ) {
        return true;
    }
    return false;
} 

//判断对象是否为空
function isEmptyObject( obj ) {
    for ( var name in obj ) {
        return false;
    }
    return true;
}

function getPureDate(dataArr){
    var reDataArr = [];
     if (!dataArr) {
      console.log('runhere');
      return reDataArr;
    }
    var tempData ;
    for (var i = 0; i < dataArr.length; i++) {
      tempData = dataArr[i];
      var parameterVo = {};
      parameterVo.chName = tempData.chName;
      parameterVo.description = tempData.description;
      parameterVo.engName = tempData.engName;
      parameterVo.parameterId = tempData.parameterId;
      parameterVo.check = false;
      parameterVo.dataType = {};
      parameterVo.dataType.generic = tempData.dataType.generic;
      parameterVo.dataType.source = tempData.dataType.source;
      parameterVo.dataType.type = tempData.dataType.type;
      parameterVo.dataType.value = tempData.dataType.value;
      reDataArr.push(parameterVo);
    }
    console.log(reDataArr);
    return reDataArr;
  }
</script>
</body>
</html>
