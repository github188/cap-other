<%@ include file="/top/component/common/Taglibs.jsp" %>
<head>
    <%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK" %>
    <%@ include file="/top/workbench/base/Header.jsp" %>
    <link rel="stylesheet"
          href="${pageScope.cuiWebRoot}/top/workbench/platform/css/iSmartAbleWidget.css?v=<%=version%>"/>
    
    <title>首页-中国南方电网</title>
<style type="text/css">
	::-webkit-scrollbar{width:9px;height:9px;box-sizing:border-box}::-webkit-scrollbar-button{width:9px;height:12px;background:url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADwAAAAUCAYAAADRA14pAAADr0lEQVRYR71Yy04iQRQtE10IRiSBOLbOUvZmfkIlLHXjI+jCDzAm8w8TJKxZyENdqEui8BPuDVtsHCNGQcFEWUzdSt/KtbqqqZ44U0kn1V2n69xz63W6x5h9iXFoNADe521dftnibJlt+7PCjdmycpzz9vbmmvCTk5PzvK0NuNvbWyNuYWEBcbbUX8obSvBgMDAKiUQiUrDLi0nNPC9eYqwFfyWvTvAPHsm1JhqHEl9dXbHV1VUJo4Lv7u6k4JOTE7a5uSlxc3Nz/0ww5VXjR15VMIjFoop2+v2+EAJisaDoaDQqR/j+/l7gjo+PJW5ra0vUZ2dnqWDko1zqM+fi4kL0RxOMMaytrUneXC4ncMhFYzg4OBA4KpiK1Yl2Xl9fXSqWip6ampLEDw8PbrVa9U2S7e1tlkwmdYIBC6J1CXfOz8/ljAHRNIbFxcXs0tJShb/rHB4eShxw0RgymczPVCr1CwWrRCOJeQesVqtJUevr61JwPp+XxHt7e6xYLErc/v6+OqVHJvrl5cWt1+u+BEIMNzc3UvDj46NbqYD2zwViaLfbWsGBU+vs7EwIASIow+GQYSA8e5K4UCgIHBBBeX9/Z+VyWdT5CAliJabApdTr9UR/VDTGQPeO5+dngUMuGgPiQu3S3W7XHR8fl2IxaHjWbDalYAhwYmJCNH98fEht8KzVaukEA8a4WQIvdgKiacJjsZicWZgYwJZKJZlwiGF6etq3hpWk+24dzKAOODMzI4lhrZs6I2t9FB+2+3ghcZjIIF4YCJiFUJA31AjbCrY8N/9aMH2RCrbhDSP4OydKBETZ4W09fn3jV8SAG/Dnv/kFFtS22PC2eGdWOJNg3fnos3iXl5ci6HQ6zTxryVRbeXp6KjAbGxvMYCt1XDQZgpdy0UbV0lI+ikNuk9NCLN21fU4LQXA2ersgbP+fXBZiwG05jqNzWUE7NLwueHVmBxrpLg3c4OwoJ9aR+6udFgvhsugA/DeHZ3JaWi+tOi1q9bxdkHU6nU8uCxwPlkQiEeSjTaKFw8M+1JGmDg+4EUddFsSA3KFGWGcAVlZWBId3zrGnpyff4Z/NZgUmHo+bBIc2Hgqv+Cy14Q61hlUDgNkEcs8AMPXwR8zOzo48/Olc5vWRaxh4qctCsdCPajzAcFBOrI8yHtpdWj2HG42G6G95eZl55yHDLyokOjo6EtXd3V1Gvqh061e3jAAnjAfloi/Tcxi4KR/FIXeYc9jmFwpw2PwGUgY58NaG1/rX0h9d1DUzJEP0JgAAAABJRU5ErkJggg==);background-color:transparent;background-repeat:no-repeat}::-webkit-scrollbar-button:vertical:start{background-position:0px 0px}::-webkit-scrollbar-button:vertical:start:hover{background-position:-10px 0}::-webkit-scrollbar-button:vertical:start:active{background-position:-20px 0}::-webkit-scrollbar-button:vertical:end{background-position:-30px 0}::-webkit-scrollbar-button:vertical:end:hover{background-position:-40px 0}::-webkit-scrollbar-button:vertical:end:active{background-position:-50px 0}::-webkit-scrollbar-button:horizontal:start{background-position:0 -11px}::-webkit-scrollbar-button:horizontal:start:hover{background-position:-10px -11px}::-webkit-scrollbar-button:horizontal:start:active{background-position:-19px -11px}::-webkit-scrollbar-button:horizontal:end{background-position:-30px -11px}::-webkit-scrollbar-button:horizontal:end:hover{background-position:-40px -11px}::-webkit-scrollbar-button:horizontal:end:active{background-position:-50px -11px}::-webkit-scrollbar-track-piece{background-color:rgba(0,0,0,0.15);-webkit-border-radius:5px}::-webkit-scrollbar-thumb{background-color:#E7E7E7;border:1px solid rgba(0,0,0,0.21);-webkit-border-radius:5px}::-webkit-scrollbar-thumb:hover{background-color:#F6F6F6;border:1px solid rgba(0,0,0,0.21)}::-webkit-scrollbar-thumb:active{background:-webkit-gradient(linear, left top, left bottom, from(#e4e4e4), to(#f4f4f4))}::-webkit-scrollbar-corner{background-color:#f1f1f1;-webkit-border-radius:1px}
.ikonw{
  cursor:pointer;
  float: right;
  line-height: 30px;
  margin-top: 7px;
  margin-right: 20px;
  font-size: 12px;
  font-weight: bold;
  background-color: #0c6cdd;
  padding-left: 5px;
  padding-right: 5px;
  border-radius:10px;
/*   color: #666; */
  color: #FFF; 
}
.ikonw:hover{
	color:#2D9AFF
}
</style>

	
<script type="text/javascript">

function getCurrentTab(){
    var $curLink = $('.active > a[data-url]');
    return {id:$curLink.data('menuId'),name:$curLink.html()};
}
</script>
	
	
</head>
<body>

<%@ include file="/top/workbench/base/MainNav.jsp" %>


<div class="app-nav clearfix" id="app-nav">
    <%//logo延后加载,先处理url路径%>
    <img class="app-logo" src="<top:webRoot/>/top/workbench/newversion/images/ico2.png">
    <span class="app-name">新功能介绍</span>
    <span id="btn-ikown" class="ikonw">我知道了</span>
    <ul id="systemMenu" class="menu clearfix">
<!--         <li><a id="" href="javascript:void(0)" target="mainFrame" data-url="/web/top/workbench/newversion/NewVersionPicShow.jsp" data-menu-id="4">投资计划及项目</a></li> -->
    </ul>
</div>
<div class="workbench-container" id="main-container">
    <div class="frame-wrap">
        <iframe id="mainFrame"  name="mainFrame" src="about:blank" frameborder="0" allowTransparency="true"></iframe>
    </div>
</div>
<script>
    var b;
    <c:if test="${requestScope.menusJson}!=null">
    	b = ${requestScope.menusJson};
    </c:if>
	
    require([webPath + '/top/workbench/base/js/MainFrame.js'], function() {
    	
    	var data = ${dragJson};
    	if(data&&data.length>0){
    		var html = "";
    		for(var i=0;i<data.length;i++){
    			if(data[i].defaultSystem==="defaultSystem"){
    				html += "<li><a id='"+ data[i].defaultSystem +"' href='javascript:void(0)' target='mainFrame' data-url='<top:webRoot/>/top/workbench/newversion/NewVersionPicShow.jsp' data-menu-id='"+data[i].sysCode+"'>"+data[i].sysName+"</a></li>";
    			}else{
    				html += "<li><a id='' href='javascript:void(0)' target='mainFrame' data-url='<top:webRoot/>/top/workbench/newversion/NewVersionPicShow.jsp' data-menu-id='"+data[i].sysCode+"'>"+data[i].sysName+"</a></li>";
    			}		
    		}
    		$("#systemMenu").prepend(html);
    		if($('#defaultSystem')&&$('#defaultSystem').size()>0){
    			$('#defaultSystem').click();
    		}else{
    			$('#app-nav a[data-url]:first').click();
    		}
    	}
    	$("#mainFrame").height($(window).height()-112)
    	$("#btn-ikown").on("click",function(e){
    		window.location.replace('<top:webRoot/>/top/workbench/PlatFormAction/initPlatform.ac');
    	})
        //初始化数据
        /* MainFrame.init({
           //设置菜单数据源
           menuList : b ||{},
           //匹配菜单后回调,激活选中的菜单,设置效果
           activeMenu : function(menuId){
                var $menu = $('#' + menuId);
                MainFrame.activeMenu($menu);
                resetAllMenu();
           },
           //iframe自动高度回调
           getHeight : function() {
               return $(window).height() - 112;
           }
        });
        
        var menuInfo = MainFrame.getHashMenuInfo();
        //设置默认加载链接
        if(!menuInfo) {
            $('#app-nav a[data-url]:first').click();
        } else {
            MainFrame.$frame[0].src = menuInfo.url;
        } */

        
        //resetAllMenu();
        /*
        $(window).resize(function(){
            resetAllMenu();
        });
        */
        /**
         *重置菜单宽度,防止菜单换行 
         */
        function resetAllMenu(){
            var $menu = $('#app-nav > .menu'),
                ulWidth = $('#app-nav').width() + $('#app-nav').offset().left - $menu.children('li:eq(0)').offset().left + 10;
            MainFrame.resetMenu(ulWidth,$menu);
        } 
    });
</script>