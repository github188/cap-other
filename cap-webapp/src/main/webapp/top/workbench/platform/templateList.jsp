<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK" %>
<div class="ct0pList">

    <!-- <c:if test="${fn:length(templateList[0]) == 0&&fn:length(templateList[1]) == 0&&fn:length(templateList[2]) == 0}">
         <div  class="noDataTip">对不起，没有搜索到工作台模板信息!</div>
     </c:if>-->
    <div id="noDataTip" style="display: none" class="noDataTip">没有搜索到工作台模板信息!</div>

    <!--templateList是一个二维数组：retList.add(superTemplateList); retList.add(defaultTemplateList);  retList.add(commonTemplateList);-->
    <c:forEach items="${templateList}" var="outerItem" varStatus="outerStatus">
        <!--如果当前模板类型里面模板个数是大于0的，说明是有模板的，就需要显示模板类型-->
        <c:if test="${fn:length(outerItem) > 0}">
            <div class="PortletTagTitle clearfix" id="templateType_${outerStatus.index}">
                <div class="place-left">
                    <!--索引顺序是根据后端的list存入顺序定的-->
                    <c:if test="${outerStatus.index==0}">超级模板</c:if>
                    <c:if test="${outerStatus.index==1}">默认模板</c:if>
                    <c:if test="${outerStatus.index==2}">非默认模板</c:if>
                </div>
                <hr/>
            </div>
        </c:if>

        <!--为每一个类别的模板外面套一层div 并且id为warp_tp_序号-->
        <div id="warp_tp_${outerStatus.index}" data-index="${outerStatus.index}">
            <c:forEach items="${outerItem}" var="item" varStatus="status">
            <span class="PortletTag" tpname="${item.templateName}" onclick="showTemplateDetail('${item.templateId}')">
                    <span class="PortletImg"><img data-pic-url="${item.templatePic}"
                                                  onerror="this.src='${pageScope.cuiWebRoot}/top/workbench/platform/img/template_default.png'"/></span>
                    <span class="PortletMsg">
                        <span class="PortletName" title="${item.templateName}">
                          <span class="sub-text">${item.templateName}</span>
                          <a title="删除" onclick="deleteTemplate('${item.templateId}',this,event)"></a>
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
    /* 删除模板*/
    function deleteTemplate(templateId, dom, event) {
        var evt = event || window.event;
        //IE用cancelBubble=true来阻止而FF下需要用stopPropagation方法
        evt.stopPropagation ? evt.stopPropagation() : (evt.cancelBubble = true);
        var $this = $(dom);
        parent.cui.confirm('确认要删除该模板吗?', {
            onYes: function () {
                TemplateAction.deleteTemplate(templateId, function (result) {
                    if (result === true) {
                        $this.parents("span.PortletTag").remove();
                        parent.cui.message('模板删除成功！', 'success');
                    } else {
                        parent.cui.message('模板删除失败！', 'error');
                    }
                });
            }
        });


    }
    /*修改模板*/
    function showTemplateDetail(templateId) {
        var url = "${ pageContext.request.contextPath }/top/workbench/TemplateAction/showTemplateDetail.ac?tp.templateId=" + templateId;
        window.parent.location.href = url;
    }
</script>
