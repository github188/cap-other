<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK" %>
<div class="ct0pList">
    <!--
     <c:if test="${portletList== null || fn:length(portletList) == 0}">
        <div class="noDataTip">û��������΢����Ϣ!</div>
     </c:if>
     -->

    <div id="noDataTip" style="display: none" class="noDataTip">û��������΢����Ϣ!</div>

    <!--������ʾ΢����Ϣ,portletList��һ��list���飬��ʽ��[{portletTag:'',portletName:'',picAddress:''.....},{portletTag:'',portletName:'',picAddress:''.....}] �ϸ�Ҫ���˴��ݹ���������ʱ�Ѿ�����portletTag�ֺ����-->
    <c:forEach items="${portletList}" var="item" varStatus="status">
        <!--�����߼���������һ�غ�currentTag�϶��ǲ����ڵ�(ֻ��ÿ���������õ�ǰtagΪcurrentTag)������item.portletTag�϶���ΪcurrentTag-->
        <c:if test="${fn:length(item.portletTag)==0 || item.portletTag!=currentTag}">
            <!--����һ������-->
            <div class="PortletTagTitle clearfix" tagname="${item.portletTag}"  name="${item.portletId}"  iscom="${item.isCommon }">
                <div class="place-left">${item.portletTag}</div>
                <hr/>
            </div>
        </c:if>
        <!--��ʾ�÷����µ�����΢��,class="PortletTag"Ϊ������class-->
        <span class="PortletTag" ptname="${item.portletName}" data-tag="${item.portletTag}"  iscom="${item.isCommon }"
              onclick="initUpdatePortlet('${item.portletId}')">
            <!--ͼƬ����class="PortletImg"-->
            <span class="PortletImg"><img  data-pic-url="${item.picAddress}"
                                           onerror="this.src='${pageScope.cuiWebRoot}/top/workbench/platform/img/portlet_default.png'"/></span>
            <!--���ƺ�������Ϣ���� class="PortletMsg",��ÿ��΢����tag����dom�У���������΢����ʱ����-->
            <span class="PortletMsg">
                <span class="PortletName" title="${item.portletName}">
                  <span class="sub-text">${item.portletName}</span>
                  <a title="ɾ��" onclick="deletePortlet('${item.portletId}',this,event)"></a>
                </span>
                <span class="PortletDesb">${item.portletDescribe}</span>
            </span>
            <!--ʱ�����-->
            <span class="PortletCreateTime">
                <fmt:formatDate value="${item.portletCreateTime}" pattern="yyyy-MM-dd"></fmt:formatDate>
            </span>
        </span>
        <!--ÿ�غϵ�������õ�ǰcurrentTagΪ��ǰ������ʾ�ķ���-->
        <c:set var="currentTag" value="${item.portletTag}"></c:set>
    </c:forEach>
</div>

<script type="text/javascript">
    $('[data-pic-url]').prop('src',function(){
        this.src = Workbench.formatUrl($(this).data('pic-url'));
    });
    require(["json2", "underscore", "cui"], function (json2, _, ui) {
        comtop.UI.scan();
    });

    /* ɾ��΢��*/
    function deletePortlet(portletId, dom, event) {
        var evt = event || window.event;
        //IE��cancelBubble=true����ֹ��FF����Ҫ��stopPropagation����
        evt.stopPropagation ? evt.stopPropagation() : (evt.cancelBubble = true);
        parent.cui.confirm('ȷ��Ҫɾ����΢����', {
            onYes: function () {
                var $this = $(dom);
                PortletAction.deletePortlet(portletId, function (result) {
                    if (result === '1') {
                        top.cui.message('΢��ɾ���ɹ���', 'success');
                        location.reload();
                    } else {
                        top.cui.error('΢��ɾ��ʧ�ܣ�');
                    }
                });
            }
        });
    }
    /*�޸�΢��*/
    function initUpdatePortlet(portletId) {
        var url = "${ pageContext.request.contextPath }/top/workbench/PortletAction/initUpdatePortlet.ac?portlet.portletId=" + portletId;
        window.parent.location.href = url;
    }

</script>
