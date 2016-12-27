<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<c:if test="${requestScope.app!=null}">
<div class="app-nav">
    <img src="${pageScope.cuiWebRoot}${requestScope.app.logo}" class="app-logo">
    <span class="app-name">${requestScope.app.name}</span>
    <ul class="menu">
        <c:forEach items="${requestScope.app.businessMenus}" var="menu">
            <c:if test="${menu.menuType==1}">
                 <li class="dropdown">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#">${menu.name}<b class="caret"></b> </a>
                    <ul class="dropdown-menu" role=menu tabindex="-1">
                        <c:forEach items="${menu.secondMenus}" var="secondMenu">
                            <li><a href="javascript:void(0)" target="mainFrame" data-url="${secondMenu.url}">${secondMenu.name}</a></li>
                        </c:forEach>
                    </ul>
                </li>
            </c:if>
            <c:if test="${menu.menuType!=1}">
                 <li><a href="javascript:void(0)" target="mainFrame" data-url="${menu.url}">${menu.name}</a></li>
            </c:if>
        </c:forEach>
    </ul>
    <ul class="operate">
        <li>
            <a href="javascript:void(0)"title="ÅÅÐò" class="icon-sort"></a>
        </li>
    </ul>
</div>
</c:if>