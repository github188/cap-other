<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK" %>
<div class="ct0pList">
    <!--
     <c:if test="${portletList== null || fn:length(portletList) == 0}">
        <div class="noDataTip">没有搜索到微件信息!</div>
     </c:if>
     -->

    <div id="noDataTip" style="display: none" class="noDataTip">没有搜索到微件信息!</div>

    <!--迭代显示微件信息,portletList是一个list数组，格式：[{portletTag:'',portletName:'',picAddress:''.....},{portletTag:'',portletName:'',picAddress:''.....}] 严格要求后端传递过来的数据时已经根据portletTag分好组的-->
    <c:forEach items="${portletList}" var="item" varStatus="status">
        <!--迭代逻辑，迭代第一回合currentTag肯定是不存在的(只在每会后最后设置当前tag为currentTag)，所以item.portletTag肯定不为currentTag-->
        <c:if test="${fn:length(item.portletTag)==0 || item.portletTag!=currentTag}">
            <!--新起一个分类-->
            <div class="PortletTagTitle clearfix" tagname="${item.portletTag}"  name="${item.portletId}"  iscom="${item.isCommon }">
                <div class="place-left">${item.portletTag}</div>
                <hr/>
            </div>
        </c:if>
        <!--显示该分类下的所有微件,class="PortletTag"为外层包裹class-->
        <span class="PortletTag" ptname="${item.portletName}" data-tag="${item.portletTag}"  iscom="${item.isCommon }"
              onclick="initUpdatePortlet('${item.portletId}')">
            <!--图片包裹class="PortletImg"-->
            <span class="PortletImg"><img  data-pic-url="${item.picAddress}"
                                           onerror="this.src='${pageScope.cuiWebRoot}/top/workbench/platform/img/portlet_default.png'"/></span>
            <!--名称和描述信息包裹 class="PortletMsg",把每个微件的tag置于dom中，方便搜索微件的时候用-->
            <span class="PortletMsg">
                <span class="PortletName" title="${item.portletName}">
                  <span class="sub-text">${item.portletName}</span>
                  <a title="删除" onclick="deletePortlet('${item.portletId}',this,event)"></a>
                </span>
                <span class="PortletDesb">${item.portletDescribe}</span>
            </span>
            <!--时间包裹-->
            <span class="PortletCreateTime">
                <fmt:formatDate value="${item.portletCreateTime}" pattern="yyyy-MM-dd"></fmt:formatDate>
            </span>
        </span>
        <!--每回合的最后设置当前currentTag为当前正在显示的分类-->
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

    /* 删除微件*/
    function deletePortlet(portletId, dom, event) {
        var evt = event || window.event;
        //IE用cancelBubble=true来阻止而FF下需要用stopPropagation方法
        evt.stopPropagation ? evt.stopPropagation() : (evt.cancelBubble = true);
        parent.cui.confirm('确认要删除该微件吗？', {
            onYes: function () {
                var $this = $(dom);
                PortletAction.deletePortlet(portletId, function (result) {
                    if (result === '1') {
                        top.cui.message('微件删除成功！', 'success');
                        location.reload();
                    } else {
                        top.cui.error('微件删除失败！');
                    }
                });
            }
        });
    }
    /*修改微件*/
    function initUpdatePortlet(portletId) {
        var url = "${ pageContext.request.contextPath }/top/workbench/PortletAction/initUpdatePortlet.ac?portlet.portletId=" + portletId;
        window.parent.location.href = url;
    }

</script>
