<%@ include file="/top/component/common/Taglibs.jsp" %>
<html>
<head>
    <%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK" %>
    <%@ include file="/top/workbench/base/Header.jsp" %>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/platform/css/portlet.css?v=<%=version%>"/>
    <title>�й��Ϸ�����</title>
</head>
<body>

<%@ include file="/top/workbench/base/MainNav.jsp" %>
<div class="app-nav">
    <img src="${pageScope.cuiWebRoot}/top/workbench/platform/img/wj_guanli.png" class="app-logo">
    <span class="app-name">΢������</span>
</div>
<div class="workbench-container">
    <div class="ct0pMain">
            <input class="search empty" type="text" id="portletSearchKey" value="΢�������ؼ���" empty_text="΢�������ؼ���"/>
            ���<span uitype="PullDown" id="portletSearchTag" mode="Single" on_change="doQuery"></span>
            <span id="addPortlet" class="btnBg">����</span>
        <div id="portletMain">
            
        </div>
    </div>
</div>
<script type="text/javascript">
    var cui;
    var resetTag;
    require(["json2", "underscore", "cui", "workbench/platform/js/portlet", "autoIframe"], function (json2, _, cui, portletMgr) {
        /*��cui��portletMgr��©�����js�ռ�*/
        cui = cui;
        $('#portletMain').load('${ pageContext.request.contextPath }/top/workbench/PortletAction/showPortlet.ac');
        var selectData = portletMgr.queryAllTags('withAll');
        comtop.UI.scan();
        //��ȡ����ԴȻ��ֵ
        cui("#portletSearchTag").setDatasource(selectData);
        //����ѡ��ȫ��
        cui("#portletSearchTag").setValue(-1);

        /*��̨���ݵĲ��������ʾ
         Ϊ"":ֱ�����󵽲�ѯҳ��
         Ϊ"1":�����޸Ļ������ɹ������󵽸�ҳ��
         Ϊ"0":�����޸Ļ�����ʧ�ܺ����󵽸�ҳ��*/
        var opTip = "${param.opTip}";
        if (opTip !== "") {
            if (opTip == 1) {
                cui.message('����ɹ���','success');
            }
        }
        //ע����������������̧���¼�
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

        //ע������΢���¼�
        $("#addPortlet").click(function () {
            window.location.href = "${ pageContext.request.contextPath }/top/workbench/platform/initAddPortlet.jsp";
        });

        /*�÷�������ҳ������ɾ�����������*/
        resetTag = function () {
            comtop.UI.scan();
            var selectData = portletMgr.queryAllTags('withAll');
            //��ȡ����ԴȻ��ֵ
            cui("#portletSearchTag").setDatasource(selectData);
            //����ѡ��ȫ��
            cui("#portletSearchTag").setValue(-1);
        }
    });

    //������������
    function doQuery() {
        var searchKey = $("#portletSearchKey").val();
        searchKey = $.trim(searchKey) === "΢�������ؼ���" ? "" : $.trim(searchKey);
        var portletTag = cui("#portletSearchTag").getText();
        portletTag = $.trim(portletTag) === "ȫ��" ? "" : $.trim(portletTag);

    /*  document.queryForm.searchKey.value=searchKey;
        document.queryForm.portletTag.value=portletTag;
        document.charset='gbk';
        document.queryForm.submit();
        $("#portletMain>iframe").get(0).src ="${ pageContext.request.contextPath }/top/workbench/PortletAction/showPortlet.ac?searchKey=" + searchKey + "&portletTag=" + portletTag;*/

        filterPortlet(searchKey,portletTag);
    }
    /*ҳ������΢��*/
    function filterPortlet(searchKey, portletTag) {
        $("#noDataTip").hide();//������������΢������ʾ��Ϣ
        $(".PortletTagTitle").hide();//�������з���
        $(".PortletTag").hide();//��������΢��

        if (portletTag.length > 0) {/*����ĳ������tag�����µ�΢��*/
            if (searchKey.length > 0) {
                /*�йؼ�������,ֱ�������������̶��ĵ��������Ƿ�����ؼ���*/
                var $portlet = $("span[ptname*='" + searchKey + "'][data-tag='" + portletTag + "']");
                if ($portlet.length > 0) {
                    //$("div[tagname='" + portletTag + "'][iscom='"+$portlet.attr("iscom")+"']").show();//��ʾ΢���ķ���tag
                    $portlet.each(function () {
						$("div[tagname='" + portletTag + "'][iscom='"+$(this).attr("iscom")+"']").show();//��ʾ΢���ķ���tag
                        $(this).show();//��ʾ��������΢��
                    });
                } else {
                    $("#noDataTip").show();
                }
            } else {
                /*�޹ؼ�������*/
                $("div[tagname='" + portletTag + "']").show();//��ʾ΢���ķ���tag
                $("span[data-tag='" + portletTag + "']").show();//��ʾ�÷������µ�΢��
            }
        } else {/*����ȫ�������е�΢��*/
            if (searchKey.length > 0) {
                /*�йؼ�������*/
                var $portlet = $("span[ptname*='" + searchKey + "']");
                if ($portlet.length > 0) {
                    $portlet.each(function () {
                        $(this).show();//��ʾ��������΢��
                        $("div[tagname='" + $(this).data("tag") + "'][iscom='"+$(this).attr("iscom")+"']").show();//��ʾ΢���ķ���tag
                    });
                } else {
                    $("#noDataTip").show();
                }
            } else {
                /*�޹ؼ�������*/
                $(".PortletTagTitle").show();//��ʾ���з���
                $(".PortletTag").show();//��ʾ����΢��
            }
        }
    }
</script>
</body>
</html>
