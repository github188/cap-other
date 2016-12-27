<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK" %>
<html>
<head>
    <%@ include file="/top/workbench/base/Header.jsp" %>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/platform/css/portlet.css?v=<%=version%>"/>
    <title>�й��Ϸ�����</title>
</head>
<body>

<%@ include file="/top/workbench/base/MainNav.jsp" %>
<div class="app-nav">
    <img src="${pageScope.cuiWebRoot}/top/workbench/platform/img/wj_guanli.png" class="app-logo">
    <span class="app-name">����̨ģ�����</span>
</div>
<div class="workbench-container">
    <div class="ct0pMain">
        <div class="ct0pSearch">
        	<div style="float: left;">
	            <input class="search empty" type="text" id="searchKey" value="����̨ģ�������ؼ���" empty_text="����̨ģ�������ؼ���"/>
	            <span id="searchType" uitype="RadioGroup" name="searchType" value="-1" on_change="doQuery">
	                <input type="radio" name="searchType" value="-1"/>ȫ��
	                <input type="radio" name="searchType" value="0"/>����ģ��
	                <input type="radio" name="searchType" value="1"/>Ĭ��ģ��
	                <input type="radio" name="searchType" value="2"/>��Ĭ��ģ��
	            </span>
            </div>
            <div style="float: right;">
            	<span id="templateAdd" class="btnBg">����</span>
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
         cui.message('����ɹ���', 'success');
         }*/

        //ע���¼�
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

        //ע������΢���¼�
        $("#templateAdd").click(function () {
            window.location.href = "${ pageContext.request.contextPath }/top/workbench/platform/templateAdd.jsp";
        });
    });
	


    //������������
    function doQuery() {
        var searchKey = $("#searchKey").val();
        searchKey = $.trim(searchKey) === "����̨ģ�������ؼ���" ? "" : $.trim(searchKey);
        var searchType = cui("#searchType").getValue();

/*        $("#portletMain>iframe").get(0).src =
                "${ pageContext.request.contextPath }/top/workbench/TemplateAction/queryTemplate.ac?searchKey="
                + searchKey + "&searchType=" + searchType;*/
//        console.log("....�����ѯ"+portletListIFR.queryTemplates);
         queryTemplates(searchKey,searchType);
    }
    /*��ҳ�����������*/
    var queryTemplates = function (searchKey, searchType) {
        switch (searchType) {
            case '-1'://ȫ��
                handleSearchAll(searchKey);
                break;
            case '0'://����ģ��
            case '1'://Ĭ��ģ��
            case '2'://��Ĭ��ģ��
                handleSearch(searchKey, searchType);
                break;
            default :
                break;
        }
    }

    /*��������ģ��ʱ��Ĵ�����*/
    var handleSearchAll = function (searchKey) {
        $("#noDataTip").hide();
        if (searchKey.length > 0) {
            $(".PortletTagTitle", ".ct0pList").hide();//�������з���
            $("div[id^='warp_tp_']").hide();//�������а���
            $(".PortletTag").hide();//��������ģ��

            /*��ȡ�������Ķ���,ע����ȫ������*/
            var $searchedAry = $("span[tpname*='" + searchKey + "']");
            /*����ѵ��ˣ���ʾ�ѵ���΢����Ϣ�ͷ���*/
            if ($searchedAry.length > 0) {
                //���������������ģ��
                $searchedAry.each(function () {
                    $(this).show();//��ʾģ��
                    $(this).parent().show();//��ʾ�����
                    $("#templateType_" + $(this).parent().data("index")).show();//��ʾ��ǰ΢������
                });
            } else {
                //����Ѳ�����ֱ����ʾû��������΢����Ϣ
                $("#noDataTip").show();
            }
        } else {
            //��������ؼ����ǿյ�
            $(".PortletTagTitle", ".ct0pList").show();//��ʾ���з���
            $("div[id^='warp_tp_']").show();//��ʾ���а���
            $(".PortletTag").show();//��ʾ����ģ��
        }
    }

    /*���������̶�����ģ��Ĵ�����*/
    var handleSearch = function (searchKey, type) {
        /*���쵱ǰ��������*/
        var warpId = "#warp_tp_" + type;
        var templateTypeId = "#templateType_" + type;
        /*��һ�����������еķ���,�������е�ģ���������,����û�����ذ��������ģ�壬��ʾ���е�ģ��*/
        $("#noDataTip").hide();
        $(".PortletTagTitle", ".ct0pList").hide();
        $(".PortletTag").show();
        $("div[id^='warp_tp_']").hide();

        /*�ڶ��������������ؼ����Ƿ�Ϊ�ս�����һ���жϺͲ���*/
        if (searchKey.length > 0) {
            /*��ȡ��ǰ�������������Ķ���*/
            var $searchedAry = $("span[tpname*='" + searchKey + "']", warpId);
            /*����ѵ��ˣ���ʾ�ѵ���΢����Ϣ�ͷ���*/
            if ($searchedAry.length > 0) {
                $(templateTypeId, ".ct0pList").show();//��ʾ����
                $(warpId).show();//��ʾ����
                $(".PortletTag", warpId).hide();//���ذ��������ģ��
                $searchedAry.show();//��ʾ����������������ģ��
            } else {
                //����Ѳ�����ֱ����ʾû��������΢����Ϣ
                $("#noDataTip").show();
            }
        } else {
            //��������ؼ����ǿյ�
            $(templateTypeId, ".ct0pList").show();//��ʾ��ǰ����
            $(warpId, ".ct0pList").show();//��ʾ��ǰ�����µ�����ģ��
        }
    }

</script>
</body>
</html>
