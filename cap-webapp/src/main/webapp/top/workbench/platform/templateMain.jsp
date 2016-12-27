<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK" %>
<html>
<head>
    <%@ include file="/top/workbench/base/Header.jsp" %>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/platform/css/portlet.css?v=<%=version%>"/>
    <title>中国南方电网</title>
</head>
<body>

<%@ include file="/top/workbench/base/MainNav.jsp" %>
<div class="app-nav">
    <img src="${pageScope.cuiWebRoot}/top/workbench/platform/img/wj_guanli.png" class="app-logo">
    <span class="app-name">工作台模板管理</span>
</div>
<div class="workbench-container">
    <div class="ct0pMain">
        <div class="ct0pSearch">
        	<div style="float: left;">
	            <input class="search empty" type="text" id="searchKey" value="工作台模板搜索关键字" empty_text="工作台模板搜索关键字"/>
	            <span id="searchType" uitype="RadioGroup" name="searchType" value="-1" on_change="doQuery">
	                <input type="radio" name="searchType" value="-1"/>全部
	                <input type="radio" name="searchType" value="0"/>超级模板
	                <input type="radio" name="searchType" value="1"/>默认模板
	                <input type="radio" name="searchType" value="2"/>非默认模板
	            </span>
            </div>
            <div style="float: right;">
            	<span id="templateAdd" class="btnBg">新增</span>
            </div>
        </div>

        <div id="portletMain">
            
        </div>
    </div>
</div>
<script type="text/javascript">
    var cui;
    require(["json2", "underscore", "cui"], function (json2, _, cui) {
        cui = cui;
        $('#portletMain').load('${ pageContext.request.contextPath }/top/workbench/TemplateAction/queryTemplate.ac');
        comtop.UI.scan();
        /*        if ('${opTip}') {
         cui.message('保存成功！', 'success');
         }*/

        //注册事件
        $("#searchKey").keypress(function (e) {
            if (e.which == 13) {
                doQuery();
            }
        }).blur(function () {
            var $this = $(this);
            if (!$.trim($this.val())) {
                $this.addClass('empty').val($this.attr('empty_text'));
            }
            doQuery();
        }).focus(function () {
            var $this = $(this);
            if ($this.hasClass('empty')) {
                $(this).removeClass('empty').val('');
            }
        });

        //注册新增微件事件
        $("#templateAdd").click(function () {
            window.location.href = "${ pageContext.request.contextPath }/top/workbench/platform/templateAdd.jsp";
        });
    });
	


    //进行搜索工作
    function doQuery() {
        var searchKey = $("#searchKey").val();
        searchKey = $.trim(searchKey) === "工作台模板搜索关键字" ? "" : $.trim(searchKey);
        var searchType = cui("#searchType").getValue();

/*        $("#portletMain>iframe").get(0).src =
                "${ pageContext.request.contextPath }/top/workbench/TemplateAction/queryTemplate.ac?searchKey="
                + searchKey + "&searchType=" + searchType;*/
//        console.log("....进入查询"+portletListIFR.queryTemplates);
         queryTemplates(searchKey,searchType);
    }
    /*父页面的搜索操作*/
    var queryTemplates = function (searchKey, searchType) {
        switch (searchType) {
            case '-1'://全部
                handleSearchAll(searchKey);
                break;
            case '0'://超级模板
            case '1'://默认模板
            case '2'://非默认模板
                handleSearch(searchKey, searchType);
                break;
            default :
                break;
        }
    }

    /*搜索所有模板时候的处理函数*/
    var handleSearchAll = function (searchKey) {
        $("#noDataTip").hide();
        if (searchKey.length > 0) {
            $(".PortletTagTitle", ".ct0pList").hide();//隐藏所有分类
            $("div[id^='warp_tp_']").hide();//隐藏所有包裹
            $(".PortletTag").hide();//隐藏所有模板

            /*获取搜索到的对象,注意是全局搜索*/
            var $searchedAry = $("span[tpname*='" + searchKey + "']");
            /*如果搜到了，显示搜到的微件信息和分类*/
            if ($searchedAry.length > 0) {
                //逐个处理搜索到的模板
                $searchedAry.each(function () {
                    $(this).show();//显示模板
                    $(this).parent().show();//显示其包裹
                    $("#templateType_" + $(this).parent().data("index")).show();//显示当前微件分类
                });
            } else {
                //如果搜不到，直接显示没有搜索到微件信息
                $("#noDataTip").show();
            }
        } else {
            //如果搜索关键字是空的
            $(".PortletTagTitle", ".ct0pList").show();//显示所有分类
            $("div[id^='warp_tp_']").show();//显示所有包裹
            $(".PortletTag").show();//显示所有模板
        }
    }

    /*搜索其他固定分类模板的处理函数*/
    var handleSearch = function (searchKey, type) {
        /*构造当前包裹对象*/
        var warpId = "#warp_tp_" + type;
        var templateTypeId = "#templateType_" + type;
        /*第一步：隐藏所有的分类,隐藏所有的模板外包裹层,但是没有隐藏包裹里面的模板，显示所有的模板*/
        $("#noDataTip").hide();
        $(".PortletTagTitle", ".ct0pList").hide();
        $(".PortletTag").show();
        $("div[id^='warp_tp_']").hide();

        /*第二部：根据搜索关键字是否为空进行下一步判断和操作*/
        if (searchKey.length > 0) {
            /*获取当前分类下搜索到的对象*/
            var $searchedAry = $("span[tpname*='" + searchKey + "']", warpId);
            /*如果搜到了，显示搜到的微件信息和分类*/
            if ($searchedAry.length > 0) {
                $(templateTypeId, ".ct0pList").show();//显示分类
                $(warpId).show();//显示包裹
                $(".PortletTag", warpId).hide();//隐藏包裹里面的模板
                $searchedAry.show();//显示包裹里面搜索到的模板
            } else {
                //如果搜不到，直接显示没有搜索到微件信息
                $("#noDataTip").show();
            }
        } else {
            //如果搜索关键字是空的
            $(templateTypeId, ".ct0pList").show();//显示当前分类
            $(warpId, ".ct0pList").show();//显示当前分类下的所有模板
        }
    }

</script>
</body>
</html>
