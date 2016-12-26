<%
    /**********
    *设计器 横屏
    *@author pengxiangwei
    */
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>布局横版</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/usermanagement/orgusertag/css/choose.css"/>
    <link rel="stylesheet" href="css/mini.css"/>
</head>
<body class="noselect" ng-controller="pageDesignerCtr">
<div id="maincontainer">
    <div id="topsection">
         <div class="m-tools">
           <!-- <div class="m-tools-model" ng-repeat="child in toolsdata" ng-if="child.children.length>0">
                <span ng-bind="child.title"></span>
                 <ul>
                    <li class="hanlder cui-icon" data-modelid="{{component.componentModelId}}" ng-class="{true:'dragtable'}[child.componentType=='layout']" data-drag="true" data-jqyoui-options="options" 
                    jqyoui-draggable="{animate:true,placeholder:'keep',deepCopy:true}" ng-repeat="component in child.children">
                        <span ng-bind-template="&#xf013;{{component.text}}({{component.uiType}})"></span>
                    </li>
                </ul>
            </div> -->
            <div class="m-tools-model">
                <span>布局控件</span>
                <ul>
                    <li><a href=""> 
                        行&nbsp;<input type="number" id="row" value="1" min="1" max="99" class="rownumber">
                        列&nbsp;<input type="number" id="col" value="1" min="1" max="99" class="cellnumber">
                        <span class="cui-icon drag_button dragtable" data-drag="true" data-method="tablelayout" data-jqyoui-options="options" jqyoui-draggable="{animate:true,onDrag:'onDrag',onStart:'onStart',onStop:'onStop'}" data-modelId="uicomponent.layout.component.tableLayout">&#xf047;&nbsp; 拖动</span>
                    </a></li>
                    <li class="dragtable" data-drag="true" data-jqyoui-options="options" data-method="formlayout" jqyoui-draggable="{animate:true,onDrag:'onDrag',onStart:'onStart',onStop:'onStop'}"><a href="">快速表单布局</a></li>
                    <li class="dragtable" data-drag="true" data-jqyoui-options="options" data-method="borderlayout" jqyoui-draggable="{animate:true,onDrag:'onDrag',onStart:'onStart',onStop:'onStop'}" data-modelId="uicomponent.common.component.borderlayout"><a href="">边框布局</a></li>
                </ul>
            </div>
            <div class="m-ui-tab">
                <ul class="m-ui-tab-head">
                    <li ng-repeat="child in toolsdata | filter:f" ng-class="{'active':isActiveTab(child.componentType)}" ng-click="switchTab($event,$index,child)" ng-bind="child.title"></li>
                </ul>
                <div ng-repeat="child in toolsdata | filter:f" class="m-ui-tab-content" ng-class="{'active':isActiveTab(child.componentType)}" class="m-ui-tab-content">
                    <ul>
                        <li class="component hanlder cui-icon" data-modelid="{{component.componentModelId}}" data-type="{{component.uiType}}" ng-class="{true:'dragtable'}[child.componentType=='layout']" data-drag="true" data-jqyoui-options="options" 
                        jqyoui-draggable="{animate:true,placeholder:'keep',deepCopy:true}" ng-repeat="component in child.children">
                            <span ng-bind-template="&#xf013;{{component.text}}({{component.uiType}})"></span>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    <!-- 中间内容 -->
    <div id="contentwrapper" ng-style="autoheight">
        <div class="m-center-box">
            <div class="m-center-panel">
                <div class="container" id="container"  data-drop="true" jqyoui-droppable="{onDrop:'onDrop',onOver:'onOver',onOut:'onOut'}" data-jqyoui-options="{accept:'.dragtable'}">
                    
                </div>
                <div id="cIndicator" class="layout-indicator selected" style="display: none;">
                     <div class="dot a"></div>
                     <div class="dot b"></div>
                     <div class="dot c"></div>
                     <div class="dot d"></div>
                     <div class="dot e"></div>
                     <div class="dot f"></div>
                     <div class="dot g"></div>
                     <div class="dot h"></div>
                </div>
            </div>
        </div>
    </div>
    <!-- 右边 -->
    <div id="rightcolumn" ng-style="autoheight">
        <div class="m-attr" ng-style="{height:toggleHeight}">
            <iframe id="ui-attr" ng-src="{{uisrc}}" frameborder="0"></iframe>
        </div>
        <div class="m-treedata" ng-style="{height:!togglehide||'50%'}">
            <div class="attr-title">
                <span class="u-title">树形模式</span>
                <span class="cui-icon u-exchange" ng-click="toggleView()" ng-bind-html="toggleText"></span>
                <span class="cui-icon u-exchange">&#xf014;</span>
                <!-- <span class="cui-icon u-exchange">&#xf0ec;</span> -->
            </div>
            <div uitype="tree" ng-style="{height:!togglehide||'calc(100% - 34px)'}" ng-show="togglehide" id="pageTree" style="overflow:auto;" checkbox="true" on_select="treeNodeSelect" select_mode="2"></div>
        </div>
    </div> 
    <div id="arrow"> >>> </div>   
</div>

<top:script src="/cap/dwr/engine.js"></top:script>
<top:script src="/cap/dwr/util.js"></top:script>
<top:script src="/cap/dwr/interface/ComponentTypeFacade.js"></top:script>    
<top:script src="/top/sys/dwr/interface/ChooseAction.js"></top:script>
<top:script src="/cap/bm/dev/page/designer/js/require.js"></top:script>
<script type="text/x-template" id="tableTemplate">
    <@if(table.type=="layout"){ @>
        <table cellspacing='0' cellpadding='0' id='<@=table.id@>' class='u-table <@=table.options.class||"table"@>'>
            <tbody>
                <@ _.forEach(table.children,function(tr){ @>
                    <tr id="<@=tr.id@>">
                        <@ _.forEach(tr.children,function(td){@>
                            <@ var defalutWidth = (1/tr.children.length).toPercent();@>
                                <@ var options = sumoption(td,defalutWidth) @>
                                <td  id="<@=td.id@>" class="cell" <@=options.attr@> style="<@=options.style@>" data-drop="true" jqyoui-droppable="{onDrop:'uiDrop',onOver:'uiOver',onOut:'uiOut'}" data-jqyoui-options="{accept:'.component'}">
                                    <@=buildCUIHTML(td.children||[])@>
                                </td>
                        <@})@>
                    </tr>
                <@ }) @>
            </tbody>
        </table>
    <@}else if(table.type=="ui"){@>
        <@=buildCUIHTML(table||[])@>
    <@}@>
</script>

<script type="text/javascript">
    var pageId="<%=request.getParameter("modelId")%>";
    var packageId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
    requirejs.config({
        baseUrl:"js",
        shim:{
            "common/angular":{
                exports:"angular"
            },
            "jquery-ui.min":{
                deps:["jquery"]
            },
            "angular-dragdrop":{
                deps:["common/angular","jquery-ui.min"]
            },
            "angular-sanitize":{
                deps:["common/angular"]
            }
        },
        paths:{
            cui:'../../../../common/cui/js',
            common:'../../../../common/base/js',
            jquery:"../../../../common/top/js/jquery",
            choose:'${pageScope.cuiWebRoot}/top/sys/usermanagement/orgusertag/js'
        }
    })
    requirejs(["tablemini"],function(app){
        app.init();
    })
</script>
</body>
</html>
