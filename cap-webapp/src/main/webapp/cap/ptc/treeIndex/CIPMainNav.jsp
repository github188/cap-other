<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>

<style>
    html,body{
        min-width:990px;
    }
</style>

<div id="main-nav" class="clearfix">
        <a href="${pageScope.cuiWebRoot}/top/workbench/PlatFormAction/initPlatform.do" class="workbench-logo"></a>
        <ul class="menu pull-left " id="nav-menu">
	        <li>
	            <a href="${pageScope.cuiWebRoot}/top/workbench/PlatFormAction/initPlatform.ac" class="workbench-index"> 首页 </a>
	        </li>
            <li>
                <a href="javascript:;" onclick="openMonitorUI();" class="todo-box">
                    <span class="pull-left">工作流设计</span>
                </a>
            </li>
            <li>
                <a href="javascript:;" onclick="openPreferences();" class="todo-box"> 
                	<span class="pull-left">首选项配置</span>
                </a>
            </li>
              <li>
                <a href="${pageScope.cuiWebRoot}/cap/bm/dev/page/template/PageTemplateTypeMain.jsp?templateManager=true" target="mainIframe" class="todo-box"> 
                	<span class="pull-left">界面模板</span>
                </a>
            </li>
             <li>
                <a href="${pageScope.cuiWebRoot}/cap/bm/graph/ModuleRelationGraphMain.jsp" target="mainIframe" class="todo-box"> 
                	<span class="pull-left">模型可视化</span>
                </a>
            </li>
        </ul>
         <ul class="menu pull-right">
         	<!-- 
		        <li >
		             <a href="#" target="${openMode}"> 项目建模 </a>
		        </li>
	     	-->
	        <li id="nav-user-name">
	            <a href="javascript:void(0)" > 
	                <img class="user-head" src="${pageScope.cuiWebRoot}/top/workbench/base/img/user.png" />
	                <span>${userInfo.employeeName}</span> 
	            </a>
	        </li>
	        <li>
	            <a href="javascript:void(0)" class="separate"></a>
	        </li>
	        <li>
	            <a href="${pageScope.cuiWebRoot}/top/workbench/personal/AccountSet.jsp" target="${openMode}"> 帐号设置 </a>
	        </li>
	        <li>
	            <a href="javascript:void(0)" class="separate"></a>
	        </li>
	        <li>
	            <a href="#" target="${openMode}"> 帮助 </a>
	        </li>
	        <li>
	            <a href="javascript:void(0)" class="separate"></a>
	        </li>
	        <li>
	            <a href="javascript:exit()"> 登出 </a>
	        </li>
	    </ul>
        <!-- /navbar-inner -->
    </div>
</div>
<script type="text/javascript">
	//退出系统
	function exit() {
	    LoginAction.exit(function(){
	        window.location.href = "${pageScope.cuiWebRoot}/login.ac";
	    });
	}
    
    require(['sys/dwr/interface/LoginAction'], function() {
     
     }); 
    
     //加载cui,主要是为了提示
     require(['cui'], function() {});
	
    //打开生成代码窗口
    function openGenCode() {
    	var nodeId = "";
    	var nodeTypeVal = nodeData.getData().data.moduleType;
    	var genNode = nodeData;
    	switch(nodeTypeVal) {
	    	case 4: // 实体
			case 5: // 表
			case 6: // 服务
			case 7: // 查询
			case 8: // 界面
			case 9: // 常用数据类型
			case 10: // 工作流
				genNode = nodeData.parent();
				break;
			default:
    	}
    	if(genNode && genNode.getData() && genNode.getData().key) {
	    	nodeId = genNode.getData().key;
    	}
    	var codeGenUrl = "${pageScope.cuiWebRoot}/cap/ptc/preferencesconfig/GenerateCode.jsp?packageId=" + nodeId;
    	
    	window.open(codeGenUrl,"codeGenWin");
    }
    //打开系统配置窗口
    function openSysConfig() {
    	var sysConfigUrl = "${pageScope.cuiWebRoot}/cap/bm/dev/SystemConfig.jsp";
    	window.open(sysConfigUrl,"sysConfigWin");
    }
    
    function openMonitorUI(){
    	var url = "${pageScope.cuiWebRoot}/bpms/RedirectToBPMSMonitor.jsp";
    	window.open(url,"monitorUIWin");
    }
    
    function openPreferences(){
    	var url = "${pageScope.cuiWebRoot}/cap/ptc/preferencesconfig/PreferencesConfig.jsp";
    	window.open(url,"preferencesConfigWin");
    }

</script>
