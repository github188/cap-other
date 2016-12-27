<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<html>
    <head>
        <%@ include file="/top/workbench/base/Header.jsp" %>
        <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/base/css/tab.css"/>
        <script type="text/javascript" src='${pageScope.cuiWebRoot}/top/workbench/base/js/bootstrap-tab.js'></script>
        <title>�й��Ϸ�����</title>
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
                    <a href="#query-tab" data-toggle="tab">��ѯ����</a>
                </li>
                <li>
                    <a href="#fliter-tab" data-toggle="tab">������</a>
                </li>
            </ul>
            <div class="tab-content">
                <div class="tab-pane active" id="query-tab">
                    <table style="width:100%;visibility: hidden;" class="form-table">
                        <tbody >
                            <tr>
                                <td  class="form-label">
                                    <label for="input4">���ӹ�˾��</label>
                                </td>
                                <td class="form-field">
                                    <span id="defectLevel" uitype="SinglePullDown" auto_complete="true" name="defectLevel"
                                    value_field="id" label_field="text" width="200" value=""> <a value="0">ȫ��</a> <a value="1">�㶫������˾</a> <a value="2">����������˾</a> <a value="4">���ϵ�����˾</a> <a value="3">���ݵ�����˾</a> <a value="5">���ϵ�����˾</a> <a value="6">����ѹ������˾</a> <a value="8">���ݹ�������޹�˾</a> <a value="9">���ڹ�������޹�˾</a> </span>
                                </td>
                                <td  class="form-label">
                                    <label for="input4">����֣�</label>
                                </td>
                                <td class="form-field">
                                    <span id="defectLevel" uitype="SinglePullDown" auto_complete="true" name="defectLevel"
                                    value_field="id" label_field="text" width="200" value=""> <a value="0">ȫ��</a> <a value="3">��ɽ�����</a> <a value="4">��ݸ�����</a> </span>
                                </td>

                                <td  class="form-label">
                                    <label for="input4">ȱ�ݱ�ţ�</label>
                                </td>
                                <td class="form-field">
                                    <span uitype="Input" id="createName" name="createName" value=""></span>
                                </td>
                            </tr>
                            <tr>
                                <td  class="form-label">
                                    <label for="input4">ȱ����Դ��</label>
                                </td>
                                <td class="form-field">
                                    <span id="defectSource" uitype="SinglePullDown" auto_complete="true" name="defectSource"
                                    value_field="id" label_field="text" width="200" value=""> <a value="1">Ѳ��</a> <a value="7">����</a> <a value="2">Ԥ�Զ���</a> <a value="4">����</a> <a value="5">��������</a> <a value="3">����</a> <a value="6">ά��</a> <a value="99">����</a> </span>
                                </td>
                                <td  class="form-label">
                                    <label for="input4">���̵ƣ�</label>
                                </td>
                                <td class="form-field">
                                    <span id="redGreenLight" uitype="SinglePullDown" auto_complete="true" name="redGreenLight"
                                    value_field="id" label_field="text" width="200" value=""> <a value="0">ȫ��</a> <a value="1">���</a> <a value="2">�̵�</a> <a value="3">�Ƶ�</a> </span>
                                </td>

                                <td  class="form-label">
                                    <label for="input4">ȱ�ݵȼ���</label>
                                </td>
                                <td class="form-field" >
                                    <span id="defectLevel" uitype="SinglePullDown" auto_complete="true" name="defectLevel"
                                    value_field="id" label_field="text" width="200" value=""> <a value="0">ȫ��</a> <a value="1">����</a> <a value="2">�ش�</a> <a value="3">һ��</a> <a value="4">����</a> </span>
                                </td>
                            </tr>
                            <tr>
                                <td  class="form-label">
                                    <label for="input2">��ѹ�ȼ���</label>
                                </td>
                                <td class="form-field">
                                    <span id="nominalVoltage" uitype="SinglePullDown" auto_complete="true" name="nominalVoltage"
                                    value_field="id" label_field="text" width="200" value=""> <a value="0">ȫ��</a> <a value="1">500kV</a> <a value="2">400kV</a> <a value="3">380kV</a> <a value="4">330kV</a> <a value="5">220kV</a> <a value="6">132kV</a> <a value="7">110kV</a> <a value="8">66kV</a> <a value="9">35kV</a> <a value="10">10kV</a> <a value="11">6kV</a> <a value="12">0.4kV</a> <a value="13">0.22kV</a> <a value="14">��800kV</a> <a value="15">��500kV</a> </span>
                                </td>
                                <td  class="form-label">
                                    <label for="input2">��ȱ״̬��</label>
                                </td>
                                <td class="form-field">
                                    <span id="defectState" uitype="SinglePullDown" auto_complete="true" name="defectState"
                                    value_field="id" label_field="text" width="200" value=""> <a value="0">ȫ��</a> <a value="1">δ�ϱ�</a> <a value="2">������</a> <a value="3">��������ȱ</a> <a value="4">��ȱ��</a> <a value="5">������</a> <a value="6">�ѹ鵵</a> </span>
                                </td>

                                <td  class="form-label">
                                    <label for="input4">���ֲ��ţ�</label>
                                </td>
                                <td class="form-field">
                                    <span uitype="Input" id="createName" name="createName" value=""></span>
                                </td>
                            </tr>
                            <tr>
                                <td  class="form-label">
                                    <label for="input4">���ְ��飺</label>
                                </td>
                                <td class="form-field">
                                    <span uitype="Input" id="workMasterName" name="workMasterName" value=""></span>
                                </td>
                                <td  class="form-label">
                                    <label for="input4">�����ˣ�</label>
                                </td>
                                <td class="form-field" >
                                    <input type="hidden" id="findUserUid" name="findUserUid" value="">
                                    <span uitype="ChooseUser" rootId="" id="findUser" callback="findUserCallback" delCallback="findUserDellCallback" height="31px" width="165px"  userType="1" chooseMode="1"></span>
                                </td>

                                <td  class="form-label">
                                    <label for="input4">��ȱ�ˣ�</label>
                                </td>
                                <td class="form-field" >
                                    <input type="hidden" id="findUserUid" name="findUserUid" value="">
                                    <span uitype="ChooseUser" rootId="" id="findUser" callback="findUserCallback" delCallback="findUserDellCallback" height="31px" width="165px"  userType="1" chooseMode="1"></span>
                                </td>
                            </tr>
                            <tr>
                                <td  class="form-label">
                                    <label for="input4">�ص㣺</label>
                                </td>
                                <td class="form-field">
                                    <span uitype="Input" id="createName" name="createName" value=""></span>
                                </td>
                                <td  class="form-label">
                                    <label for="input4">�豸���ƣ�</label>
                                </td>
                                <td class="form-field">
                                    <span uitype="Input" id="createName" name="createName" value=""></span>
                                </td>

                                <td  class="form-label">
                                    <label for="input4">�豸���</label>
                                </td>
                                <td class="form-field" >
                                    <span uitype="Input" id="createName" name="createName" value=""></span>
                                </td>
                            </tr>
                            <tr>
                                <td  class="form-label">
                                    <label for="input4">�豸���ң�</label>
                                </td>
                                <td class="form-field">
                                    <span uitype="Input" id="createName" name="createName" value=""></span>
                                </td>
                                <td  class="form-label">
                                    <label for="input4">�豸�ͺţ�</label>
                                </td>
                                <td class="form-field">
                                    <span uitype="Input" id="createName" name="createName" value=""></span>
                                </td>

                                <td  class="form-label">
                                    <label for="input4">ȱ�����</label>
                                </td>
                                <td class="form-field">
                                    <span uitype="Input" id="createName" name="createName" value=""></span>
                                </td>
                            </tr>
                            <tr>
                                <td  class="form-label">
                                    <label for="input4">Ͷ�����ڣ�</label>
                                </td>
                                <td class="form-field" >
                                    <span id="planStartTime" name="planStartTime" value="" format='yyyy-MM-dd' okbtn="true" entering="true" uitype="Calender" width="200px"></span>
                                </td>
                                <td  class="form-label">
                                    <label for="input4">�������ڣ�</label>
                                </td>
                                <td class="form-field" >
                                    <span id="planStartTime" name="planStartTime" value="" format='yyyy-MM-dd' okbtn="true" entering="true" uitype="Calender" width="200px"></span>
                                </td>

                                <td  class="form-label">
                                    <label for="input4">������</label>
                                </td>
                                <td class="form-field" >
                                    <span uitype="Input" id="createName" name="createName" value=""></span>
                                </td>
                            </tr>
                            <tr>
                                <td  class="form-label">
                                    <label for="input4">ȱ�ݱ���</label>
                                </td>
                                <td class="form-field" >
                                    <span uitype="Input" id="createName" name="createName" value=""></span>
                                </td>
                                <td  class="form-label">
                                    <label for="input4">ȱ�����</label>
                                </td>
                                <td class="form-field" >
                                    <span uitype="Input" id="createName" name="createName" value=""></span>
                                </td>

                                <td  class="form-label">
                                    <label for="input4">�������ڣ�</label>
                                </td>
                                <td class="form-field" >
                                    <span id="planStartTime" name="planStartTime" value="" format='yyyy-MM-dd' okbtn="true" entering="true" uitype="Calender" width="200px"></span>
                                </td>
                            </tr>
                            <tr>

                                <td  class="form-label">
                                    <label for="input4">��ȱ���ڣ�</label>
                                </td>
                                <td class="form-field" >
                                    <span id="planStartTime" name="planStartTime" value="" format='yyyy-MM-dd' okbtn="true" entering="true" uitype="Calender" width="200px"></span>
                                </td>
                                <td  class="form-label">
                                    <label for="input4">��ȱ���飺</label>
                                </td>
                                <td class="form-field" >
                                    <span uitype="Input" id="createName" name="createName" value=""></span>
                                </td>

                                <td  class="form-label">
                                    <label for="input2">���β��ţ�</label>
                                </td>
                                <td class="form-field">
                                    <span uitype="Input" id="createName" name="createName" value=""></span>
                                </td>
                            </tr>
                            <tr>
                                <td  class="form-label">
                                    <label for="input4">�������ڣ�</label>
                                </td>
                                <td class="form-field" >
                                    <span id="planStartTime" name="planStartTime" value="" format='yyyy-MM-dd' okbtn="true" entering="true" uitype="Calender" width="200px"></span>
                                </td>
                                <td  class="form-label">
                                    <label for="input2">���ղ��ţ�</label>
                                </td>
                                <td class="form-field">
                                    <span uitype="Input" id="createName" name="createName" value=""></span>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6" align="right">
                                    <button type="button" id="query_btn" name="query_btn" class="btn">
                                        <i class="icon icon-search"></i>
                                        ��ѯ
                                    </button>
                                    <button type="button" id="filter_save_btn" name="filter_save_btn" class="btn">
                                        ����Ϊ������
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

            //��ȡ�ַ������
            function getCurrentStrWidth(text, font) {
                var currentObj = jQuery('<pre></pre>').hide().appendTo(document.body);
                jQuery(currentObj).html(text).css('font', font);
                var width = currentObj.width();
                currentObj.remove();
                return width;
            }

            //���ÿ��
            function reWidth(e) {
                var input = jQuery(e.target);
                var width = getCurrentStrWidth(input.val(), input.css("font"));
                if (width < 60) {
                    width = 60;
                }
                input.css("width", width);
            }

            //�������༭�¼�
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
                    var icon = jQuery('<span class="icon icon-wrong" title="�Ƴ�" style="vertical-align:middle;cursor:pointer"></span>').click(function() {//ɾ���¼�
                        jqItem.hide();
                    });
                    jqItem.append(input).append(icon);
                    input.keydown();
                });
            }

            //�����������¼�
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
                        newFilterName = "δ����";
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
                cui.message("����ɹ�", "success");
                if (filterList != null && filterList.length > 0) {
                    jQuery.ajax({
                        url : "#URL()/common/queryfilter/edit",
                        contentType : "application/json;",
                        data : JSON.stringify(filterList),
                        dataType : "text",
                        type : "POST",
                        success : function(resultData) {
                            cui.message("����ɹ�", "success");
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
                //��ѯ
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
                //���²�ѯ
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