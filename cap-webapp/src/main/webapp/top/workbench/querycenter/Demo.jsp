<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<html>
    <head>
        <%@ include file="/top/workbench/base/Header.jsp" %>
        <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/base/css/tab.css"/>
        <script type="text/javascript" src='${pageScope.cuiWebRoot}/top/workbench/base/js/bootstrap-tab.js'></script>
        <title>中国南方电网</title>
        <style>
            html,body{
                background-color:transparent;
            }
        </style>
    </head>
    <body>
        <div class="tabbable" id="query-div">
            <ul class="nav nav-tabs">
                <li class="active">
                    <a href="#query-tab" data-toggle="tab">查询条件</a>
                </li>
                <li>
                    <a href="#fliter-tab" data-toggle="tab">过滤器</a>
                </li>
            </ul>
            <div class="tab-content">
                <div class="tab-pane active" id="query-tab">
                    <table style="width:100%;visibility: hidden;" class="form-table">
                        <tbody >
                            <tr>
                                <td  class="form-label">
                                    <label for="input4">分子公司：</label>
                                </td>
                                <td class="form-field">
                                    <span id="defectLevel" uitype="SinglePullDown" auto_complete="true" name="defectLevel"
                                    value_field="id" label_field="text" width="200" value=""> <a value="0">全部</a> <a value="1">广东电网公司</a> <a value="2">广西电网公司</a> <a value="4">云南电网公司</a> <a value="3">贵州电网公司</a> <a value="5">海南电网公司</a> <a value="6">超高压电网公司</a> <a value="8">广州供电局有限公司</a> <a value="9">深圳供电局有限公司</a> </span>
                                </td>
                                <td  class="form-label">
                                    <label for="input4">供电局：</label>
                                </td>
                                <td class="form-field">
                                    <span id="defectLevel" uitype="SinglePullDown" auto_complete="true" name="defectLevel"
                                    value_field="id" label_field="text" width="200" value=""> <a value="0">全部</a> <a value="3">佛山供电局</a> <a value="4">东莞供电局</a> </span>
                                </td>

                                <td  class="form-label">
                                    <label for="input4">缺陷编号：</label>
                                </td>
                                <td class="form-field">
                                    <span uitype="Input" id="createName" name="createName" value=""></span>
                                </td>
                            </tr>
                            <tr>
                                <td  class="form-label">
                                    <label for="input4">缺陷来源：</label>
                                </td>
                                <td class="form-field">
                                    <span id="defectSource" uitype="SinglePullDown" auto_complete="true" name="defectSource"
                                    value_field="id" label_field="text" width="200" value=""> <a value="1">巡视</a> <a value="7">监视</a> <a value="2">预试定检</a> <a value="4">检修</a> <a value="5">工程遗留</a> <a value="3">操作</a> <a value="6">维护</a> <a value="99">其它</a> </span>
                                </td>
                                <td  class="form-label">
                                    <label for="input4">红绿灯：</label>
                                </td>
                                <td class="form-field">
                                    <span id="redGreenLight" uitype="SinglePullDown" auto_complete="true" name="redGreenLight"
                                    value_field="id" label_field="text" width="200" value=""> <a value="0">全部</a> <a value="1">红灯</a> <a value="2">绿灯</a> <a value="3">黄灯</a> </span>
                                </td>

                                <td  class="form-label">
                                    <label for="input4">缺陷等级：</label>
                                </td>
                                <td class="form-field" >
                                    <span id="defectLevel" uitype="SinglePullDown" auto_complete="true" name="defectLevel"
                                    value_field="id" label_field="text" width="200" value=""> <a value="0">全部</a> <a value="1">紧急</a> <a value="2">重大</a> <a value="3">一般</a> <a value="4">其他</a> </span>
                                </td>
                            </tr>
                            <tr>
                                <td  class="form-label">
                                    <label for="input2">电压等级：</label>
                                </td>
                                <td class="form-field">
                                    <span id="nominalVoltage" uitype="SinglePullDown" auto_complete="true" name="nominalVoltage"
                                    value_field="id" label_field="text" width="200" value=""> <a value="0">全部</a> <a value="1">500kV</a> <a value="2">400kV</a> <a value="3">380kV</a> <a value="4">330kV</a> <a value="5">220kV</a> <a value="6">132kV</a> <a value="7">110kV</a> <a value="8">66kV</a> <a value="9">35kV</a> <a value="10">10kV</a> <a value="11">6kV</a> <a value="12">0.4kV</a> <a value="13">0.22kV</a> <a value="14">±800kV</a> <a value="15">±500kV</a> </span>
                                </td>
                                <td  class="form-label">
                                    <label for="input2">消缺状态：</label>
                                </td>
                                <td class="form-field">
                                    <span id="defectState" uitype="SinglePullDown" auto_complete="true" name="defectState"
                                    value_field="id" label_field="text" width="200" value=""> <a value="0">全部</a> <a value="1">未上报</a> <a value="2">审批中</a> <a value="3">待安排消缺</a> <a value="4">消缺中</a> <a value="5">验收中</a> <a value="6">已归档</a> </span>
                                </td>

                                <td  class="form-label">
                                    <label for="input4">发现部门：</label>
                                </td>
                                <td class="form-field">
                                    <span uitype="Input" id="createName" name="createName" value=""></span>
                                </td>
                            </tr>
                            <tr>
                                <td  class="form-label">
                                    <label for="input4">发现班组：</label>
                                </td>
                                <td class="form-field">
                                    <span uitype="Input" id="workMasterName" name="workMasterName" value=""></span>
                                </td>
                                <td  class="form-label">
                                    <label for="input4">发现人：</label>
                                </td>
                                <td class="form-field" >
                                    <input type="hidden" id="findUserUid" name="findUserUid" value="">
                                    <span uitype="ChooseUser" rootId="" id="findUser" callback="findUserCallback" delCallback="findUserDellCallback" height="31px" width="165px"  userType="1" chooseMode="1"></span>
                                </td>

                                <td  class="form-label">
                                    <label for="input4">消缺人：</label>
                                </td>
                                <td class="form-field" >
                                    <input type="hidden" id="findUserUid" name="findUserUid" value="">
                                    <span uitype="ChooseUser" rootId="" id="findUser" callback="findUserCallback" delCallback="findUserDellCallback" height="31px" width="165px"  userType="1" chooseMode="1"></span>
                                </td>
                            </tr>
                            <tr>
                                <td  class="form-label">
                                    <label for="input4">地点：</label>
                                </td>
                                <td class="form-field">
                                    <span uitype="Input" id="createName" name="createName" value=""></span>
                                </td>
                                <td  class="form-label">
                                    <label for="input4">设备名称：</label>
                                </td>
                                <td class="form-field">
                                    <span uitype="Input" id="createName" name="createName" value=""></span>
                                </td>

                                <td  class="form-label">
                                    <label for="input4">设备类别：</label>
                                </td>
                                <td class="form-field" >
                                    <span uitype="Input" id="createName" name="createName" value=""></span>
                                </td>
                            </tr>
                            <tr>
                                <td  class="form-label">
                                    <label for="input4">设备厂家：</label>
                                </td>
                                <td class="form-field">
                                    <span uitype="Input" id="createName" name="createName" value=""></span>
                                </td>
                                <td  class="form-label">
                                    <label for="input4">设备型号：</label>
                                </td>
                                <td class="form-field">
                                    <span uitype="Input" id="createName" name="createName" value=""></span>
                                </td>

                                <td  class="form-label">
                                    <label for="input4">缺陷类别：</label>
                                </td>
                                <td class="form-field">
                                    <span uitype="Input" id="createName" name="createName" value=""></span>
                                </td>
                            </tr>
                            <tr>
                                <td  class="form-label">
                                    <label for="input4">投运日期：</label>
                                </td>
                                <td class="form-field" >
                                    <span id="planStartTime" name="planStartTime" value="" format='yyyy-MM-dd' okbtn="true" entering="true" uitype="Calender" width="200px"></span>
                                </td>
                                <td  class="form-label">
                                    <label for="input4">出厂日期：</label>
                                </td>
                                <td class="form-field" >
                                    <span id="planStartTime" name="planStartTime" value="" format='yyyy-MM-dd' okbtn="true" entering="true" uitype="Calender" width="200px"></span>
                                </td>

                                <td  class="form-label">
                                    <label for="input4">部件：</label>
                                </td>
                                <td class="form-field" >
                                    <span uitype="Input" id="createName" name="createName" value=""></span>
                                </td>
                            </tr>
                            <tr>
                                <td  class="form-label">
                                    <label for="input4">缺陷表象：</label>
                                </td>
                                <td class="form-field" >
                                    <span uitype="Input" id="createName" name="createName" value=""></span>
                                </td>
                                <td  class="form-label">
                                    <label for="input4">缺陷类别：</label>
                                </td>
                                <td class="form-field" >
                                    <span uitype="Input" id="createName" name="createName" value=""></span>
                                </td>

                                <td  class="form-label">
                                    <label for="input4">发现日期：</label>
                                </td>
                                <td class="form-field" >
                                    <span id="planStartTime" name="planStartTime" value="" format='yyyy-MM-dd' okbtn="true" entering="true" uitype="Calender" width="200px"></span>
                                </td>
                            </tr>
                            <tr>

                                <td  class="form-label">
                                    <label for="input4">消缺日期：</label>
                                </td>
                                <td class="form-field" >
                                    <span id="planStartTime" name="planStartTime" value="" format='yyyy-MM-dd' okbtn="true" entering="true" uitype="Calender" width="200px"></span>
                                </td>
                                <td  class="form-label">
                                    <label for="input4">消缺班组：</label>
                                </td>
                                <td class="form-field" >
                                    <span uitype="Input" id="createName" name="createName" value=""></span>
                                </td>

                                <td  class="form-label">
                                    <label for="input2">责任部门：</label>
                                </td>
                                <td class="form-field">
                                    <span uitype="Input" id="createName" name="createName" value=""></span>
                                </td>
                            </tr>
                            <tr>
                                <td  class="form-label">
                                    <label for="input4">验收日期：</label>
                                </td>
                                <td class="form-field" >
                                    <span id="planStartTime" name="planStartTime" value="" format='yyyy-MM-dd' okbtn="true" entering="true" uitype="Calender" width="200px"></span>
                                </td>
                                <td  class="form-label">
                                    <label for="input2">验收部门：</label>
                                </td>
                                <td class="form-field">
                                    <span uitype="Input" id="createName" name="createName" value=""></span>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6" align="right">
                                    <button type="button" id="query_btn" name="query_btn" class="btn">
                                        <i class="icon icon-search"></i>
                                        查询
                                    </button>
                                    <button type="button" id="filter_save_btn" name="filter_save_btn" class="btn">
                                        保存为过滤器
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <div class="selected-filters"></div>
                </div>
                <div class="tab-pane" id="fliter-tab">
                    
                </div>
            </div>
        </div>
        <script type="text/javascript">
            function reQuery() {
                $("#query_btn").click();
            }

            //获取字符串宽度
            function getCurrentStrWidth(text, font) {
                var currentObj = jQuery('<pre></pre>').hide().appendTo(document.body);
                jQuery(currentObj).html(text).css('font', font);
                var width = currentObj.width();
                currentObj.remove();
                return width;
            }

            //重置宽度
            function reWidth(e) {
                var input = jQuery(e.target);
                var width = getCurrentStrWidth(input.val(), input.css("font"));
                if (width < 60) {
                    width = 60;
                }
                input.css("width", width);
            }

            //过滤器编辑事件
            function edit(dom) {
                var filters = jQuery(dom).parents(".launch").find(".filter-private:visible");
                if (filters.length == 0) {
                    return;
                }
                jQuery(dom).hide().next().show();
                filters.each(function(index, item) {
                    var jqItem = jQuery(item);
                    var link = jqItem.children("a").hide();
                    var input = jQuery('<input type="text" class="query-input" maxlength="15"/>').val(link.html());
                    input.keydown(reWidth);
                    input.keyup(reWidth);
                    var icon = jQuery('<span class="icon icon-wrong" title="移除" style="vertical-align:middle;cursor:pointer"></span>').click(function() {//删除事件
                        jqItem.hide();
                    });
                    jqItem.append(input).append(icon);
                    input.keydown();
                });
            }

            //过滤器保存事件
            function save(dom) {
                jQuery(dom).hide().prev().show();
                var filters = jQuery(dom).parents(".launch").find(".filter-private");
                if (filters.find(":visible").length == 0) {
                    jQuery(dom).prev().css("color", "gray");
                }
                var filterList = [];
                filters.each(function(index, item) {
                    var jqItem = jQuery(item);
                    var isRemove = jqItem.is(":hidden");
                    var newFilterName = jQuery.trim(jqItem.children("input").val());
                    if (!newFilterName) {
                        newFilterName = "未命名";
                    }
                    var oldFilterName = jQuery.trim(jqItem.children("a").html());
                    var filter = {};
                    filter.id = jqItem.attr("id");
                    if (isRemove) {
                        filter.usedBusinessQuery = 0;
                        filter.name = oldFilterName;
                        filterList.push(filter);
                    } else {
                        if (newFilterName != oldFilterName) {
                            filter.usedBusinessQuery = 1;
                            filter.name = newFilterName;
                            filterList.push(filter);
                        }
                    }
                    if (!isRemove) {
                        jqItem.children("a").html(newFilterName).show().nextAll().remove();
                    }
                });
                cui.message("保存成功", "success");
                if (filterList != null && filterList.length > 0) {
                    jQuery.ajax({
                        url : "#URL()/common/queryfilter/edit",
                        contentType : "application/json;",
                        data : JSON.stringify(filterList),
                        dataType : "text",
                        type : "POST",
                        success : function(resultData) {
                            cui.message("保存成功", "success");
                        },
                        error : function(xhr) {
                            cui.message(xhr.responseText, "error");
                        }
                    });
                }
            }

            require(["jquery", "cui"], function($) {
                comtop.UI.scan();
                $('.form-table').css('visibility','visible');
                //查询
                $("#query_btn").click(function() {
                    alert(1);
                    $("#query-div").hide();
                    $("#query_btn").hide();
                    $("#re_query_btn").show();
                    $("#defectTable").show();
                    $("#print-btn").show();
                    $("#export-btn").show();
                    cui('#defectGrid').resize();
                    $("#footer-toolbar").show();
                });
                //重新查询
                $("#re_query_btn").click(function() {
                    $("#query-div").show();
                    $("#query_btn").show();
                    $("#re_query_btn").hide();
                    $("#defectTable").hide();
                    $("#print-btn").hide();
                    $("#export-btn").hide();
                    $("#footer-toolbar").hide();
                });
            });
        </script>
    </body>
</html>