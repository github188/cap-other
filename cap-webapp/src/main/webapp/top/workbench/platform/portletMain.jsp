<%@ include file="/top/component/common/Taglibs.jsp" %>
<html>
<head>
    <%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK" %>
    <%@ include file="/top/workbench/base/Header.jsp" %>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/platform/css/portlet.css?v=<%=version%>"/>
    <title>中国南方电网</title>
</head>
<body>

<%@ include file="/top/workbench/base/MainNav.jsp" %>
<div class="app-nav">
    <img src="${pageScope.cuiWebRoot}/top/workbench/platform/img/wj_guanli.png" class="app-logo">
    <span class="app-name">微件管理</span>
</div>
<div class="workbench-container">
    <div class="ct0pMain">
            <input class="search empty" type="text" id="portletSearchKey" value="微件搜索关键字" empty_text="微件搜索关键字"/>
            类别：<span uitype="PullDown" id="portletSearchTag" mode="Single" on_change="doQuery"></span>
            <span id="addPortlet" class="btnBg">新增</span>
        <div id="portletMain">
            
        </div>
    </div>
</div>
<script type="text/javascript">
    var cui;
    var resetTag;
    require(["json2", "underscore", "cui", "workbench/platform/js/portlet", "autoIframe"], function (json2, _, cui, portletMgr) {
        /*将cui和portletMgr暴漏到外层js空间*/
        cui = cui;
        $('#portletMain').load('${ pageContext.request.contextPath }/top/workbench/PortletAction/showPortlet.ac');
        var selectData = portletMgr.queryAllTags('withAll');
        comtop.UI.scan();
        //获取数据源然后赋值
        cui("#portletSearchTag").setDatasource(selectData);
        //让其选中全部
        cui("#portletSearchTag").setValue(-1);

        /*后台传递的操作结果标示
         为"":直接请求到查询页面
         为"1":经过修改或新增成功后请求到该页面
         为"0":经过修改或新增失败后请求到该页面*/
        var opTip = "${param.opTip}";
        if (opTip !== "") {
            if (opTip == 1) {
                cui.message('保存成功！','success');
            }
        }
        //注册搜索框输入后键盘抬起事件
        $("#portletSearchKey").keypress(function (e) {
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
        $("#addPortlet").click(function () {
            window.location.href = "${ pageContext.request.contextPath }/top/workbench/platform/initAddPortlet.jsp";
        });

        /*该方法供子页面做了删除操作后调用*/
        resetTag = function () {
            comtop.UI.scan();
            var selectData = portletMgr.queryAllTags('withAll');
            //获取数据源然后赋值
            cui("#portletSearchTag").setDatasource(selectData);
            //让其选中全部
            cui("#portletSearchTag").setValue(-1);
        }
    });

    //进行搜索工作
    function doQuery() {
        var searchKey = $("#portletSearchKey").val();
        searchKey = $.trim(searchKey) === "微件搜索关键字" ? "" : $.trim(searchKey);
        var portletTag = cui("#portletSearchTag").getText();
        portletTag = $.trim(portletTag) === "全部" ? "" : $.trim(portletTag);

    /*  document.queryForm.searchKey.value=searchKey;
        document.queryForm.portletTag.value=portletTag;
        document.charset='gbk';
        document.queryForm.submit();
        $("#portletMain>iframe").get(0).src ="${ pageContext.request.contextPath }/top/workbench/PortletAction/showPortlet.ac?searchKey=" + searchKey + "&portletTag=" + portletTag;*/

        filterPortlet(searchKey,portletTag);
    }
    /*页面搜索微件*/
    function filterPortlet(searchKey, portletTag) {
        $("#noDataTip").hide();//隐藏搜索不到微件的提示信息
        $(".PortletTagTitle").hide();//隐藏所有分类
        $(".PortletTag").hide();//隐藏所有微件

        if (portletTag.length > 0) {/*搜索某个具体tag分类下的微件*/
            if (searchKey.length > 0) {
                /*有关键字搜索,直接搜索分类名固定的当中名字是否包含关键字*/
                var $portlet = $("span[ptname*='" + searchKey + "'][data-tag='" + portletTag + "']");
                if ($portlet.length > 0) {
                    //$("div[tagname='" + portletTag + "'][iscom='"+$portlet.attr("iscom")+"']").show();//显示微件的分类tag
                    $portlet.each(function () {
						$("div[tagname='" + portletTag + "'][iscom='"+$(this).attr("iscom")+"']").show();//显示微件的分类tag
                        $(this).show();//显示搜索到的微件
                    });
                } else {
                    $("#noDataTip").show();
                }
            } else {
                /*无关键字搜素*/
                $("div[tagname='" + portletTag + "']").show();//显示微件的分类tag
                $("span[data-tag='" + portletTag + "']").show();//显示该分类名下的微件
            }
        } else {/*搜索全部分类中的微件*/
            if (searchKey.length > 0) {
                /*有关键字搜索*/
                var $portlet = $("span[ptname*='" + searchKey + "']");
                if ($portlet.length > 0) {
                    $portlet.each(function () {
                        $(this).show();//显示搜索到的微件
                        $("div[tagname='" + $(this).data("tag") + "'][iscom='"+$(this).attr("iscom")+"']").show();//显示微件的分类tag
                    });
                } else {
                    $("#noDataTip").show();
                }
            } else {
                /*无关键字搜素*/
                $(".PortletTagTitle").show();//显示所有分类
                $(".PortletTag").show();//显示所有微件
            }
        }
    }
</script>
</body>
</html>
