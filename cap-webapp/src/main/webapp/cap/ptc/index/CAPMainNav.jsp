<%
  /**********************************************************************
	* CAP首页内容顶部界面
	* 2015-09-22  李小芬  新增
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
    html,body{
        min-width:990px;
    }
</style>

<div id="main-nav" class="clearfix">
        <a href="${pageScope.cuiWebRoot}/cap/ptc/index/CAPIndex.jsp" target="_self" class="workbench-logo"></a>
        <ul class="menu pull-left " id="nav-menu">
	        <li>
	            <a href="${pageScope.cuiWebRoot}/cap/ptc/index/CAPIndex.jsp" target="_self" class="workbench-index"> 首页 </a>
	        </li>        

	  		<li class="dropdown">
                <a id="capPTCDiv" class="dropdown-toggle" data-toggle="dropdown" data-menu-id="capPTCMenu" href="javascript:void(0)">项目建模<b class="caret"></b></a>
                <ul class="dropdown-menu">
          	 		<li><a href="${pageScope.cuiWebRoot}/cap/bm/biz/MainPage.jsp" target="mainIframe"> <span class="pull-left">业务建模</span></a></li>
                    <li><a href="${pageScope.cuiWebRoot}/cap/bm/req/ReqMainPage.jsp" target="mainIframe"> <span class="pull-left">需求建模</span></a></li>               
                    <li><a href="${pageScope.cuiWebRoot}/cap/ptc/index/BuildModelDevelop.jsp" target="mainIframe"> <span class="pull-left">开发建模</span></a></li>
                    <li><a href="${pageScope.cuiWebRoot}/cap/bm/doc/info/DocManageMain.jsp" target="mainIframe"> <span class="pull-left">文档管理</span></a></li>
               </ul>
           </li>     
	        
		   <li class="dropdown">
                <a id="capPTCDiv" class="dropdown-toggle" data-toggle="dropdown" data-menu-id="capPTCMenu" href="javascript:void(0)">测试发布<b class="caret"></b></a>
                <ul class="dropdown-menu">                    
                    <li><a href="${pageScope.cuiWebRoot}/cap/bm/test/index/TestManage.jsp" target="mainIframe"> <span class="pull-left">测试建模</span></a></li>
                    <li><a href="${pageScope.cuiWebRoot}/cap/bm/cdp/CdpIndex.jsp" target="mainIframe"> <span class="pull-left">发布管理</span></a></li>
               </ul>
           </li>   
             
	      <li class="dropdown">
               <a id="capPTCDiv" class="dropdown-toggle" data-toggle="dropdown" data-menu-id="capPTCMenu" href="javascript:void(0)">平台管理<b class="caret"></b></a>
               <ul class="dropdown-menu">
                   <li><a href="${pageScope.cuiWebRoot}/cap/ptc/team/EmployeeMag.jsp" target="mainIframe"> <span class="pull-left">人员管理</span></a></li>
                   <li><a href="${pageScope.cuiWebRoot}/cap/ptc/team/TeamList.jsp" target="mainIframe"> <span class="pull-left">团队管理</span></a></li>
                   <li><a href="${pageScope.cuiWebRoot}/cap/ptc/notice/NoticeList.jsp" target="mainIframe"> <span class="pull-left">公告管理</span></a></li>
                   <li><a href="${pageScope.cuiWebRoot}/cap/ptc/preferencesconfig/PreferencesConfig.jsp" target="mainIframe"> <span class="pull-left">首选项配置</span></a></li>
               </ul>
           </li>
	                 
        </ul>
         <ul class="menu pull-right">
         	<li>
	            <a href="${pageScope.cuiWebRoot}/top/workbench/PlatFormAction/initPlatform.ac" target="_blank"> TOP首页</a>
	        </li>
	        <li>
	            <a href="javascript:void(0)" class="separate"></a>
	        </li>
	        <li>
	            <a href="${pageScope.cuiWebRoot}/cap/ptc/treeIndex/CIPIndex.jsp" target="_blank"> CAP(树型)首页</a>
	        </li>
         	<li>
	            <a href="javascript:void(0)" class="separate"></a>
	        </li>
	        <li id="nav-user-name">
	            <a href="javascript:void(0)" > 
	                <img class="user-head" src="${pageScope.cuiWebRoot}/top/workbench/base/img/user.png" />
	                <span>${capEmployee.bmEmployeeName}</span> 
	            </a>
	        </li>
	        <li>
	            <a href="javascript:void(0)" class="separate"></a>
	        </li>
	        <li>
	            <a href="javascript:exit()"> 登出 </a>
	        </li>
	    </ul>
    </div>
</div>
<script type='text/javascript' src='${pageScope.cuiWebRoot}/cap/dwr/interface/CapLoginAction.js'></script>
<script type="text/javascript">
	//退出系统
	function exit() {
		CapLoginAction.exit(function(){
	        window.location.href = "${pageScope.cuiWebRoot}/CapInitLogin.ac";
	    });
		setTimeout(function(){
			 window.location.href = "${pageScope.cuiWebRoot}/CapInitLogin.ac";
		},100);
	}
    
    jQuery(document).ready(function($) {
    	// 标题绑定 鼠标移动事件
    	// $("#main-nav").on('mouseover mouseout', '.dropdown', function(event) {
    	// 	event.preventDefault();
    	// 	event.stopPropagation();
    	// 	// console.debug(event.target);
    	// 	if (event.type === 'mouseover') {
    	// 		$(this).addClass('open');
    	// 	} else if(event.type === 'mouseout'){
    	// 		$(this).removeClass('open');
    	// 	}
    	// 	console.count(event.type);
    	// }).on('click', '.dropdown a', function(event) {
    	// 	event.preventDefault();
    	// 	event.stopPropagation();
    	// 	$(this).removeClass('open');
    	// 	console.count(event.type);
    	// });;

    	$("#main-nav").on('click', '.dropdown a[target="mainIframe"]', function(event) {
    		event.preventDefault();
    		event.stopPropagation();
    		$("#mainIframe").attr('src', $(this).attr('href'));
    		/* Act on the event */
    	});

    });
    // require(['sys/dwr/interface/LoginAction'], function() {
     
    // });
    
    //加载cui,主要是为了提示
    // require(['cui'], function() {});
</script>