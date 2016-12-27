<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK" %>
<div class="ct0pList">

    <!-- <c:if test="${fn:length(templateList[0]) == 0&&fn:length(templateList[1]) == 0&&fn:length(templateList[2]) == 0}">
         <div  class="noDataTip">�Բ���û������������̨ģ����Ϣ!</div>
     </c:if>-->
    <div id="noDataTip" style="display: none" class="noDataTip">û������������̨ģ����Ϣ!</div>

    <!--templateList��һ����ά���飺retList.add(superTemplateList); retList.add(defaultTemplateList);  retList.add(commonTemplateList);-->
    <c:forEach items="${templateList}" var="outerItem" varStatus="outerStatus">
        <!--�����ǰģ����������ģ������Ǵ���0�ģ�˵������ģ��ģ�����Ҫ��ʾģ������-->
        <c:if test="${fn:length(outerItem) > 0}">
            <div class="PortletTagTitle clearfix" id="templateType_${outerStatus.index}">
                <div class="place-left">
                    <!--����˳���Ǹ��ݺ�˵�list����˳�򶨵�-->
                    <c:if test="${outerStatus.index==0}">����ģ��</c:if>
                    <c:if test="${outerStatus.index==1}">Ĭ��ģ��</c:if>
                    <c:if test="${outerStatus.index==2}">��Ĭ��ģ��</c:if>
                </div>
                <hr/>
            </div>
        </c:if>

        <!--Ϊÿһ������ģ��������һ��div ����idΪwarp_tp_���-->
        <div id="warp_tp_${outerStatus.index}" data-index="${outerStatus.index}">
            <c:forEach items="${outerItem}" var="item" varStatus="status">
            <span class="PortletTag" tpname="${item.templateName}" onclick="showTemplateDetail('${item.templateId}')">
                    <span class="PortletImg"><img data-pic-url="${item.templatePic}"
                                                  onerror="this.src='${pageScope.cuiWebRoot}/top/workbench/platform/img/template_default.png'"/></span>
                    <span class="PortletMsg">
                        <span class="PortletName" title="${item.templateName}">
                          <span class="sub-text">${item.templateName}</span>
                          <a title="ɾ��" onclick="deleteTemplate('${item.templateId}',this,event)"></a>
                        </span>
                        <span class="PortletDesb">${item.templateDescribe}</span>
                    </span>
                    <span class="PortletCreateTime"><fmt:formatDate value="${item.templateCreateTime}"
                                                                    pattern="yyyy-MM-dd"></fmt:formatDate></span>
            </span>
            </c:forEach>
        </div>
    </c:forEach>
</div>

<script type="text/javascript">
    $('[data-pic-url]').prop('src',function(){
        this.src = Workbench.formatUrl($(this).data('pic-url'));
    });
    require(["json2", "underscore", "jquery", "cui","workbench/dwr/interface/TemplateAction"], function (json2, _, $, ui) {
        comtop.UI.scan();
    });
    /* ɾ��ģ��*/
    function deleteTemplate(templateId, dom, event) {
        var evt = event || window.event;
        //IE��cancelBubble=true����ֹ��FF����Ҫ��stopPropagation����
        evt.stopPropagation ? evt.stopPropagation() : (evt.cancelBubble = true);
        var $this = $(dom);
        parent.cui.confirm('ȷ��Ҫɾ����ģ����?', {
            onYes: function () {
                TemplateAction.deleteTemplate(templateId, function (result) {
                    if (result === true) {
                        $this.parents("span.PortletTag").remove();
                        parent.cui.message('ģ��ɾ���ɹ���', 'success');
                    } else {
                        parent.cui.message('ģ��ɾ��ʧ�ܣ�', 'error');
                    }
                });
            }
        });


    }
    /*�޸�ģ��*/
    function showTemplateDetail(templateId) {
        var url = "${ pageContext.request.contextPath }/top/workbench/TemplateAction/showTemplateDetail.ac?tp.templateId=" + templateId;
        window.parent.location.href = url;
    }
</script>
