<%
    /**********************************************************************
	 * 页面设计器
	 * 2016-10-25 zhuhuanhui 新建
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>table-layout</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/prototype/common/choose/css/choose.css"/>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/cap/bm/dev/page/designer/css/table-layout.css"/>
    <style type="text/css">
    	.m-ui-container{
    		height: 100%;
    	}
    </style>
    <script type='text/javascript' src="${pageScope.cuiWebRoot}/cap/dwr/engine.js"></script>
    <script type='text/javascript' src="${pageScope.cuiWebRoot}/cap/dwr/interface/ComponentTypeFacade.js"></script>
</head>
<body class="noselect">
<div uitype="Borderlayout" id="border" is_root="true" >
    <div position="left" width="240" show_expand_icon="true" collapsable="true" style="backgrounp-color:rgba(204, 204, 204, 0.5)">
        <div id="leftTools" class="left-container">
          	<div class="title u-pullicon" style="background-color:#E5E5E5;color:#666;text-align:right;">
              	<i class="cui-icon u-pull-btn" v-on="click:changeLayout">&#xf079;</i> 
              	<i class="cui-icon u-pull-btn" v-style="isEnd" v-on="click:undoAction">&#xf112;&nbsp;回退</i>
              	<i class="cui-icon u-pull-btn" v-style="isPrev" v-on="click:restoreAction">&#xf064;&nbsp;还原</i>
          	</div>
          	<layouttools></layouttools>
          	<ul class="u-left-menu">
               	<leftmenu v-repeat="treeData" v-ref="item" indent="0" level="1"></leftmenu>
          	</ul>
          	<combinedcomponenttools></combinedcomponenttools>
        </div>
    </div>
    <div position="center" style="position:relative">
        <div class="container unReadonlyArea" v-el="container" id="container" style="padding-bottom:300px;" v-style="w"></div>
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
    <div position="right" v-el="rightEl" width="250" show_expand_icon="true" collapsable="true" resizable="true" max_size="250" style="position:relative;overflow-y: hidden;">
        <div class="m-ui-container" width="100%" height="100%">
            <iframe id="ui-attr" v-attr="src:uisrc"></iframe>
        </div>
    </div>
</div>
<div id="arrow"> >>> </div>
<div class="indicator" id="indicator"></div>
<div class="selectholder" id="selectholder"></div>
<div id="eventcover"></div>
<div id="setExpressionStateDialog"></div>
<!-- 右键菜单 -->
<ul class="right-menu u-menu" id="right-menu">
    <li class="item" v-on="mousedown:copyUI">
        <a href="#">复制</a>
    </li>
    <li class="item" v-on="mousedown:delUI"><a href="#">删除</a></li>
</ul>
<ul class="right-menu u-menu" id="cell-menu">
    <li class="item" v-on="mousedown:newRow(true)"><a href="#">向上新增一行</a></li>
    <li class="item" v-on="mousedown:newRow(false)"><a href="#">向下新增一行</a></li>
    <li class="item" v-on="mousedown:newCol(true)"><a href="#">向左新增一列</a></li>
    <li class="item" v-on="mousedown:newCol(false)"><a href="#">向右新增一列</a></li>
    <li class="item" v-on="mousedown:delRow"><a href="#">删除当前行</a></li>
    <li class="item" v-on="mousedown:pastUI"><a href="#" v-class="isPast">粘帖</a></li>
</ul>
<ul class="right-menu u-menu" id="formArea-menu">
  <li class="item" v-on="mousedown:delRow"><a href="#">删除</a></li>
</ul>
<!-- 扁平模式下 -->
<script type="text/x-template" id="plate">
    <li><input type="checkbox" id="p-{{id}}" v-on="click:selectUI"><label for="p-{{id}}">{{title}}</label></li>
</script>
<script type="text/x-template" id="pullicon">
    <div class="u-pullicon" v-class="open:open" v-el="pullicon">
        <i class="cui-icon u-pull-btn switch_button" title="页面分辨率" v-on="click:changeWith" data-value="{{w}}">&#xf109;&nbsp;{{w}}</i>
    </div>
</script>
<script type="text/x-template" id="t-layoutTools">

        <div class="title">
            布局控件
            <div style="float:right;bottom:2px;margin-right:5px;position:relative;">
                <pull-icon></pull-icon>
            </div>
        </div>
        <ul class="layout-list" v-el="items" v-show="open">
            <li>
                <span class="cui-icon">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&#xf013;</span>
                <span>行</span> <span uitype="input" id="row" mask="Int" value="1" width="40"></span>
                <span>列</span> <span uitype="input" id="col" mask="Int" value="1" width="40"></span>
                <span class="cui-icon drag_button dragtable" v-el="drag" data-method="tablelayout" data-modelId="req.uicomponent.layout.component.tableLayout">&#xf047;&nbsp; 拖动</span>
            </li>
            <li v-el="formDrag" class="dragtable" data-method="formlayout" data-modelId="req.uicomponent.layout.component.formLayout" style="margin-top:10px;">
                <span class="hanlder cui-icon">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&#xf013;&nbsp;快速表单生成布局</span>
            </li>
            <li v-el="borderDrag" class="dragtable" data-method="borderlayout" data-modelId="req.uicomponent.common.component.borderlayout" style="margin-top:10px;">
                <span class="hanlder cui-icon">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&#xf013;&nbsp;边框布局</span>
            </li> 
        </ul>
</script>

<script type="text/x-template" id="t-leftMenu">
    <li v-if="hasChildren" style="text-indent: {{indent}}em;">
        <p class="level{{level}} cui-icon" v-class="on:open" v-on="click:toggleTools">{{title}}</p>
        <ul class="u-left-menu" v-show="open">
            <leftmenu v-repeat="children" indent="{{indent+1.5}}" level="2"></leftmenu>
        </ul>
    </li>
    <li class="component" style="text-indent: {{indent}}em;" v-if="!isFolder" data-modelId="{{componentModelId}}" data-type="{{uiType}}"><span class="hanlder cui-icon">&#xf013;&nbsp;{{text}}&nbsp;{{uiType !='' ? '('+uiType+')' : ''}}</span></li>
</script>


<script type="text/x-template" id="tableTemplate">
    <@if(table.type=="layout"){ @>
        <table cellspacing='0' cellpadding='0' id='<@=table.id@>' class='u-table <@=table.options.class||"table"@>'>
            <tbody>
                <@ _.forEach(table.children,function(tr){ @>
                    <tr id="<@=tr.id@>">
                        <@ _.forEach(tr.children,function(td){@>
                            <@ var defalutWidth = (1/tr.children.length).toPercent();@>
                                <@ var options = sumoption(td,defalutWidth) @>
                                <td  id="<@=td.id@>" class="cell" <@=options.attr@> style="<@=options.style@>">
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

<top:script src="/cap/bm/common/require/js/require.js"></top:script>
<top:script src="/cap/bm/common/cui/js/comtop.ui.all.js"></top:script>
<top:script src="/cap/bm/common/cui/js/comtop.ui.autogennumber.js"></top:script>
<top:script src="/cap/bm/common/cui/js/comtop.ui.editor.min.js"></top:script>
<top:script src="/cap/dwr/util.js"></top:script>
<top:script src="/prototype/common/choose/js/choose.js"></top:script>
<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
<script type="text/javascript">
    var jQuery = $ = comtop.cQuery;
    var namespaces = "<%=request.getParameter("namespaces")%>";
    var reqFunctionSubitemId = "<%=request.getParameter("reqFunctionSubitemId")%>";
    //公用开发建模代码，变量做冗余
    var pageId = namespaces, packageId = namespaces;
    requirejs.config({
        baseUrl:'js',
        shim:{
            'cui/comtop.ui.editor.min':{
                deps:["cui/comtop.ui.all"]
            }
        },
        paths:{
        	jquery:'${pageScope.cuiWebRoot}/cap/bm/common/jquery/js',
            cui:'${pageScope.cuiWebRoot}/cap/bm/common/cui/js',
            common:'${pageScope.cuiWebRoot}/cap/bm/common/base/js',
            vue:'${pageScope.cuiWebRoot}/cap/bm/common/mvvm/vue/js',
            lodash:'${pageScope.cuiWebRoot}/cap/bm/common/lodash/js',
            choose:'${pageScope.cuiWebRoot}/prototype/common/choose/js'
        }
    })
    
    jQuery(document).ready(function(){
	    requirejs(["table"],function(){
	        CAPEditor.init();
	    });
    });
    
    function messageHandle(e) {
    	//第一次初始化数据时，页面未展现，即不占流空间，控件宽高获取有误，页面展现时，需要重新计算遮盖层
		if(e.data.type=="refreshCover" && window.setCover){
			setCover("#container");
		}
	}
	window.addEventListener("message", messageHandle, false);
    
    var stateDialog; //设置UI状态时的弹出框
	function cuiClose(){
		stateDialog.hide();
	}
    
    
   	//统一校验
    function validateAll(){
    	return $("#ui-attr")[0].contentWindow.validateAll();
    }
</script>
</body>
</html>
