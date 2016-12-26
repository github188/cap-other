<%
/**********************************************************************
* 应用模式管理编辑页面
* 2016-07-20 CAP超级管理员 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/rt/common/CapRtTaglibs.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>发布建模</title>
    <top:link href="/cap/rt/common/base/css/base.css"/>
    <top:link href="/cap/rt/common/base/css/comtop.cap.rt.css"/>
    <top:link href="/cap/rt/common/cui/themes/default/css/comtop.ui.min.css"/>
    <style type="text/css">
    	.cap-page{
    		width: 1024px;
    	}
    	 html{
            -webkit-box-sizing: border-box;
            -moz-box-sizing: border-box;
            box-sizing: border-box;
            overflow: hidden;
        }
        html,body{
            margin: 0;
            height: 100%;
        }
        div{
            margin: 0;
            padding: 0;
        }
        .cui-layout-nav{
            margin-top: -100px;
            height: 30px;
            background: #ccc;
        }
        .cui-layout-header{
            height: 70px;
            background: #999;
        }
        .cui-layout-footer{
            margin-bottom: -80px;
            height: 80px;
            background: #999;
        }
        .cui-layout-body{
            height: 100%;
            background: #fff;
        }
        .table{
        	border:solid #E5E5E5;
        	border-width:0px 0px 0px 0px;
        	width: 100%;
        }
        .td{
        	border:solid #E5E5E5; 
        	border-width:0px 1px 1px 0px;
        	width:100%;
        	height:100%;
        	text-align:center;
        }
        .span{
        	width:100%;
        	height:100%;
        	line-height:50px;
        	font-size:15px;
        	cursor:pointer;
        	display:block;
        }
        .currentObj{ background-color:#CCC;}
        .iframe{
        	width:100%;
        	height:100%;
        }

    </style>
	<top:script src='/cap/rt/common/base/js/jquery.js'></top:script>
	<top:script src='/cap/rt/common/cui/js/comtop.ui.min.js'></top:script>
	<top:script src='/cap/rt/common/base/js/comtop.cap.rt.js'></top:script>
	<top:script src='/cap/rt/common/cui/js/cui.utils.js'></top:script>
	<top:script src='/cap/rt/common/globalVars.js'></top:script>
	<top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src='/cap/dwr/interface/CdpConfigAction.js'></top:script>
	<top:script src='/cap/bm/cdp/js/CdpCinfigUtils.js'></top:script>
    
</head>
<body>
<div class="cui-layout-body">
    <div uitype="Borderlayout" is_root="false" fixed="{'left': true}" on_sizechange="resizeGrid">
        <div position="left" width="230px" collapsable="true" show_expand_icon="true">
            <!--左侧 内容 start-->
            <table class="table">
	            <tr id="config_repository">
		            <td class="td">
		            	<span id="config" class="span" onclick="clickHandler(this)">配置库管理</span>
		            </td>
	            </tr>
	            <tr id="encontral">
		            <td class="td">
		            	<span id="ev" class="span" onclick="clickHandler(this)">环境管理</span>
		            </td>
	            </tr>
	            <tr id="buildConsole">
		            <td class="td">
		            	<span id="page" class="span" onclick="clickHandler(this)">发布包提取</span>
		            </td>
	            </tr>
	            <tr id="release">
		            <td class="td">
		            	<span id="publish" class="span" onclick="clickHandler(this)">发布管理</span>
		            </td>
	            </tr>
            </table>
            <!--左侧 内容 end-->
        </div>
        <div position="center" class="body-main" style="overflow:hidden;" >
            <!--右侧 内容 start-->
            <iframe id="rightFrame" class ="iframe" ></iframe>
           
            <!--右侧 内容 end-->
        </div>
    </div>
</div>

</body>

<script type="text/javascript">
function clickHandler (obj) {
    if("config"==obj.id){
    	$("#rightFrame").attr("src","${pageScope.cuiWebRoot}/cap/bm/cdp/configRepositoryCroListPage.ac");
    }else if("ev"==obj.id){
    	$("#rightFrame").attr("src","${pageScope.cuiWebRoot}/cap/bm/cdp/evcontralListPage.ac");
    }else if("page"==obj.id){
    	$("#rightFrame").attr("src","${pageScope.cuiWebRoot}/cap/bm/cdp/build/BuildList.jsp");
    }else if("publish"==obj.id){
		$("#rightFrame").attr("src","${pageScope.cuiWebRoot}/cap/bm/cdp/releaseIndexPage.ac");
    }
    $("tr td span").each(function () {
    	if($(this).text() === $(obj).text()){
    		$(this).addClass("currentObj");
    	}else{
    		$(this).removeClass("currentObj");
    	}
    });
}
comtop.UI.scan();
jQuery(document).ready(function(){
	// 选中第一项
	$("#config").addClass("currentObj");
	$("tr td span").hover(
		  function() {
		    $(this).css("background-color","#CCC");
		  }, function() {
		    $(this).css("background-color","");
		  }
	);
	if(cap_cdp_production == getDevEn()){
		$("#config_repository").hide();
		$("#buildConsole").hide();
		$("#rightFrame").attr("src","${pageScope.cuiWebRoot}/cap/bm/cdp/evcontralListPage.ac");
    }else{
    	$("#rightFrame").attr("src","${pageScope.cuiWebRoot}/cap/bm/cdp/configRepositoryCroListPage.ac");
    }
});
</script>
</html>