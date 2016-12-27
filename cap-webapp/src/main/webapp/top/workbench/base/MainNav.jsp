<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ page import=" com.comtop.top.component.common.config.UniconfigManager" %>
<%@ page import=" com.comtop.top.component.app.session.HttpSessionUtil" %>
<%@ page import="com.comtop.top.component.common.systeminit.TopServletListener" %>
<%@ page import="com.comtop.top.sys.login.util.LoginUtil" %>
<%		
	boolean LogoutPageCloseCfg = LoginUtil.getLogoutPageCloseCfg();
%>
<style>
    html,body{
        min-width:990px;
    }
</style>
<%//设置页眉导航菜单打开模式
	String hasToDoAndDone = UniconfigManager.getGlobalConfig("hasToDoAndDone"); 
	if(hasToDoAndDone==null||"".equalsIgnoreCase(hasToDoAndDone)){
	    //默认有已办代办
	    hasToDoAndDone = "true";
	}
	
	String strLoginType ="";
    HttpSession objSession = HttpSessionUtil.getSession();
    UserDTO objUserInfoVO = (UserDTO) HttpSessionUtil.getCurUserInfo();
    String orgId = objUserInfoVO.getOrgId();
    Object objLogin = objSession.getAttribute("loginType");
    if (objLogin != null) {
        strLoginType = (String) objLogin;
    }
    String ssoServerAddress = TopServletListener.getServletContext().getInitParameter("ssoServerAddress");
    String zcServerAddress = TopServletListener.getServletContext().getInitParameter("zcServerAddress");
%>
<c:if test="${openMode == null}">
    <c:set var="openMode" value="_self" />
</c:if>
<div id="main-nav" class="clearfix">
    <a href="<c:out value='${pageScope.cuiWebRoot}'/><%=UniconfigManager.getGlobalConfig("mainFrameURL")%>" class="workbench-logo"></a>
    <ul class="menu pull-left " id="nav-menu">
        <li>
            <a href="<c:out value='${pageScope.cuiWebRoot}'/><%=UniconfigManager.getGlobalConfig("mainFrameURL")%>" class="workbench-index"> 首页 </a>
        </li>
        <li>
            <a href="<c:out value='${pageScope.cuiWebRoot}'/>/top/workbench/app/MyApp.jsp" class="myapp" target="<c:out value='${openMode}'/>"> 应用 </a>
        </li>
        <li>
            <a href="<c:out value='${pageScope.cuiWebRoot}'/>/top/workbench/querycenter/QueryCenter.jsp" class="query-center" target="<c:out value='${openMode}'/>"> 查询 </a>
        </li>
        <%  if("true".equalsIgnoreCase(hasToDoAndDone)){ %>
        <li>
            <a href="<c:out value='${pageScope.cuiWebRoot}'/>/top/workbench/todo/TodoCenter.jsp" class="todo-box" target="<c:out value='${openMode}'/>"> 
                <span class="pull-left">待办</span> 
                <span id="todoId" class="red-box pull-left">0</span> 
            </a>
        </li>
        <li>
            <a href="<c:out value='${pageScope.cuiWebRoot}'/>/top/workbench/done/gotoDoneCenter.ac" class="done-box" target="<c:out value='${openMode}'/>"> 
                <span class="pull-left">已办</span> 
            </a>
        </li>
        <%} %>
    </ul>
    <ul class="menu pull-right" id="nav-menu-right">
        <li >
            <a id="aMessageId" href="<c:out value='${pageScope.cuiWebRoot}'/>/top/workbench/message/gotoMessageCenter.ac" class="message-box" title=""> 
                <span id="messageId" class="red-box pull-left">..</span> 
            </a>
        </li>
        <li>
        	<a href="<c:out value='${pageScope.cuiWebRoot}'/>/top/workbench/personal/AccountSet.jsp" target="<c:out value='${openMode}'/>" title="账号设置">
        	    <img class="user-head" src="<c:out value='${pageScope.cuiWebRoot}'/>/top/workbench/base/img/user.png" />
        	</a>
        </li>
        <li id="nav-user-name">
            <a href="javascript:void(0)" > 
                <span><c:out value = '${userInfo.employeeName}'/></span> 
            </a>
        </li>
        <li>
            <a href="javascript:void(0)" class="separate"></a>
        </li>
        <li class="dropdown">
            <a class="dropdown-toggle" data-toggle="dropdown" id="helpurl" target="_blank"> 帮助<b class="caret"></b></a>
            <ul class="dropdown-menu" role=menu>
                <li><a href="${pageScope.cuiWebRoot}/top/workbench/PlatFormAction/NewVersionNav.ac">新功能介绍</a></li>
            </ul>
        </li>
        <li>
            <a href="javascript:void(0)" class="separate"></a>
        </li>
        <li>
            <a href="javascript:exit()"> 登出 </a>
        </li>
        <li>
            <a href="javascript:void(0)" class="separate"></a>
        </li>
    </ul>
    <!-- /navbar-inner -->
</div>
<script type="text/javascript">
    var ssoServerAddress = '<%=ssoServerAddress%>';
    var zcServerAddress = '<%=zcServerAddress%>';
	var hasToDo = '<%=hasToDoAndDone%>';
	var loginType = '<%=strLoginType%>';
	var orgId = '<%=orgId%>';
    $(function(){
       if($.trim($("#helpurl").data("url")).length<1){
    	   $("#helpurl").css("cursor","default");
       }
    })
    /**
     * 监听登录状态,多页面退出登录时自动关闭多余的页面 
     * 该方法无法完全关闭所有页面,由于chrome的安全限制,只有window.open方法打开的页面才能window.close()关闭
     */
    //是否已登出
    localStorage.isLogout = 'false';
    var loginInterval = setInterval(function(){
        if(localStorage.isLogout==='true'){
            window.opener = null;
            var browserName=navigator.appName; 
            //判断浏览器是否为chrome
           	if (browserName=="Netscape") {
           		window.top.open('about:blank','_top');
           	}else{
                window.top.open('','_self');
           	}
           	window.top.close();
            clearInterval(loginInterval);
        }
    },500);
    
    //退出系统
    function exit() {
    	dwr.TOPEngine.setAsync(false);
    	LoginAction.exit();
    	dwr.TOPEngine.setAsync(true);
    	
    	if(loginType == "1"){
    		//window.location.href = "http://10.100.150.120:7002/isc_sso/logout?service=http://10.100.150.179/web/top/Login.jsp"
    		//window.location.href = "http://10.100.79.32/isc_sso/logout?service=http://10.100.81.120/web/top/Login.jsp"
    		window.location.href = ssoServerAddress+"/isc_sso/logout?service="+zcServerAddress+"/web/top/Login.jsp"
    		//window.location.href = "${pageScope.cuiWebRoot}" + "/signout";
    	}else{
    		var logoutPageClose =  "<%=LogoutPageCloseCfg%>";
    		//window.location.href = "${pageScope.cuiWebRoot}";
    		if(logoutPageClose == "true"){
    			window.location.href = "about:blank";
    			this.closePage();
    		}else{
    			window.location.href = "${pageScope.cuiWebRoot}";
    		}
    	}
    	clearInterval(loginInterval);
    	localStorage.isLogout="true";
    	//LoginAction.destroySession();
    }
    function logoutCallback(loginType){
        clearInterval(loginInterval);
        localStorage.isLogout="true";
        //if (loginType == "1") {
			//window.location.href = "${pageScope.cuiWebRoot}" + "/signout";
		//} else if (loginType == "2") {
			//window.location.href = "${pageScope.cuiWebRoot}" + "/exit4ASSO.ac";
		//} else {
			//window.location.href = "${pageScope.cuiWebRoot}";
		//}
        LoginAction.destroySession();
    }
    
    /**
     *获取动态导航菜单 
     */
    require(['workbench/dwr/interface/NavAction'],function(){
        //获取自定义导航菜单
        NavAction.queryNavs(function(navList){
            if(!navList || navList.length == 0){
                return ;
            }
            var liList = [];
            $(navList).each(function(){
                var nav = this;
                liList.push('<li><a href="javascript:void(0)" target="${openMode}" data-url="'+ nav.url +'">'+ nav.name +'</a></li>');
            });
            if(liList.length == 1){
                $('#nav-menu').append(liList);
            }else{
                var html = [
                    '<li class="dropdown">',
                        '<a class="dropdown-toggle" data-toggle="dropdown">更多<b class="caret"></b></a>',
                            '<ul class="dropdown-menu" role=menu>',
                                liList.join(''),
                            '</ul>',
                    '</li>'
                ];
                $('#nav-menu').append(html.join(''));
            }
        });
        //获取登录到服务平台地址
        NavAction.queryServicePlatformAddress(function(addressList){
            if(!addressList || addressList.length == 0){
                return ;
            }
            var liList = [];
            $(addressList).each(function(){
                var address = this;
                liList.push('<li><a href="'+ address.url +'" target="_blank">'+ address.name +'</a></li>');
            });
            var html = [
                '<li class="dropdown">',
                    '<a class="dropdown-toggle" data-toggle="dropdown">登录服务平台<b class="caret"></b></a>',
                        '<ul class="dropdown-menu"  style="left:-20px;" role=menu>',
                            liList.join(''),
                        '</ul>',
                '</li>'
            ];
            $('#nav-menu-right').append(html.join(''));
        });
        
        //获取可切换的人员组织列表
        NavAction.queryUserAndOrg(function(userAndOrg){
            userAndOrg = userAndOrg || {};
            var $navUserName = $('#nav-user-name');
            var users = userAndOrg.users || [];
            var orgs = userAndOrg.orgs || [];
            if(users.length==0&& orgs.length < 2){
                //$navUserName.children().css('cursor','text');
                $("#nav-user-name").addClass("only-one-itme");
                return ;
            }

            $navUserName.children().addClass('dropdown-toggle').attr('data-toggle','dropdown').append('<b class="caret"></b>');
            $navUserName.addClass('dropdown').append('<ul class="dropdown-menu" role=menu></ul>');
            if(users.length > 0){
                var liList = ['<li class="menu-lable">切换用户</li>'];
                $(users).each(function(){
                    var user = this;
                    liList.push('<li><a href="javascript:void(0)" data-user="'+ user.userId +'">'+ user.userName +'</a></li>');
                });
                $navUserName.children('ul').append(liList.join(''));
            }
            if(orgs.length > 1){
                var liList = ['<li class="menu-lable">切换组织</li>'];
                $(orgs).each(function(){
                    var org = this;
                    liList.push('<li><a href="javascript:void(0)" data-org="'+ org.orgId +'" title="' + org.nameFullPath + '">'+ org.orgName +'</a></li>');
                });
                $navUserName.children('ul').append(liList.join(''));
                $('a[data-org='+ orgId +']').addClass("orgIsSelected").css({"background-color":"#003c78","color":"#FFFFFF"});
            }
            //人员切换
            $(document).on('click','a[data-user]',function(){
                var $this= $(this);
                var userId = $this.data('user');
                var userName = $this.html();
                LoginAction.switchUserProcess(userId,function(){
                    cui.message('已成功切换到用户：\n' + userName,'success');
                    window.setTimeout(function(){
                        window.location.reload();
                    },1000);
                });
            });
            //组织切换
            $(document).on('click','a[data-org]',function(){
                var $this= $(this);
                var orgId = $this.data('org');
                var orgName = $this.html();
                LoginAction.resetUserOrgInfo(orgId,function(){
                    cui.message('已成功切换到组织：\n' + orgName,'success');
                    window.setTimeout(function(){
                        window.location.reload();
                    },1000);
                });
            });
        });
    });
    
    require(['workbench/dwr/interface/DesktopMessageAction'], function() {
    	queryUnreadMessageCount = function  queryUnreadMessageCount(){
    		//调用后台获取未读消息总数
            DesktopMessageAction.queryUnreadMessageCount({callback:function(data) {
            	if(data==-1){
            		$("#aMessageId").attr("title","正在统计消息总数..");
            	}else{
                    $("#messageId").html(data);
            	}
            },errorHandler:function(){
            	
            }});
    	}
    	queryUnreadMessageCount();
    	//5秒钟刷一次未读消息总数
    	setInterval(function(){
    		queryUnreadMessageCount();
    	},500000);
    }); 
    
    if("true"===hasToDo){
	    require(['workbench/dwr/interface/DesktopTodoAction'], function() {
	        queryTodoCount = function queryTodoCount(){
	            //调用后台获取待办总数
	            DesktopTodoAction.queryTodoCount({callback:function(data) {
	                $("#todoId").html(data);
	            },errorHandler:function(){
	                
	            }});
	        }
	        queryTodoCount();
	        //5秒钟刷一次待办总数
	        setInterval(function(){
	            queryTodoCount();
	        },500000);
	
	    });
    }
    
    //加载cui,主要是为了提示
    require(['cui','loginAction'], function() {});

  //关闭当前页面
    function closePage() {
       		self.opener=null;
	    	self.close();
    }
</script>