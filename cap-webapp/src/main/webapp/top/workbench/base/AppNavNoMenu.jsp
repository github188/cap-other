<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<c:if test="${requestScope.app!=null && requestScope.app.navType ==2}">
<div class="app-nav clearfix" id="app-nav">
    <%//logo延后加载,先处理url路径%>
    <img class="app-logo">
    <span class="app-name">${requestScope.app.name}</span>
</div>
</c:if>
<div class="workbench-container" id="main-container">
    <div class="frame-wrap">
        <iframe id="mainFrame"  name="mainFrame" src="about:blank" frameborder="0" class="" allowTransparency="true"></iframe>
    </div>
</div>
<script>
    require([webPath + '/top/workbench/base/js/MainFrame.js'], function() {
       $('#mainFrame').autoFrameHeight('',function(){
           return $(window).height() - MainFrame.$frame.offset().top - 10;
       });
       var menuInfo = MainFrame.getHashMenuInfo();
       if(!menuInfo){
           $('#mainFrame')[0].src=Workbench.formatUrl('${requestScope.app.home}');
       }else{
           $('#mainFrame')[0].src=Workbench.formatUrl(menuInfo.url);
       }
   });
</script>
