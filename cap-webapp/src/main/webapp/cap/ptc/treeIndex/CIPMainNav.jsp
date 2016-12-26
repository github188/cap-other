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
	            <a href="${pageScope.cuiWebRoot}/top/workbench/PlatFormAction/initPlatform.ac" class="workbench-index"> ��ҳ </a>
	        </li>
            <li>
                <a href="javascript:;" onclick="openMonitorUI();" class="todo-box">
                    <span class="pull-left">���������</span>
                </a>
            </li>
            <li>
                <a href="javascript:;" onclick="openPreferences();" class="todo-box"> 
                	<span class="pull-left">��ѡ������</span>
                </a>
            </li>
              <li>
                <a href="${pageScope.cuiWebRoot}/cap/bm/dev/page/template/PageTemplateTypeMain.jsp?templateManager=true" target="mainIframe" class="todo-box"> 
                	<span class="pull-left">����ģ��</span>
                </a>
            </li>
             <li>
                <a href="${pageScope.cuiWebRoot}/cap/bm/graph/ModuleRelationGraphMain.jsp" target="mainIframe" class="todo-box"> 
                	<span class="pull-left">ģ�Ϳ��ӻ�</span>
                </a>
            </li>
        </ul>
         <ul class="menu pull-right">
         	<!-- 
		        <li >
		             <a href="#" target="${openMode}"> ��Ŀ��ģ </a>
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
	            <a href="${pageScope.cuiWebRoot}/top/workbench/personal/AccountSet.jsp" target="${openMode}"> �ʺ����� </a>
	        </li>
	        <li>
	            <a href="javascript:void(0)" class="separate"></a>
	        </li>
	        <li>
	            <a href="#" target="${openMode}"> ���� </a>
	        </li>
	        <li>
	            <a href="javascript:void(0)" class="separate"></a>
	        </li>
	        <li>
	            <a href="javascript:exit()"> �ǳ� </a>
	        </li>
	    </ul>
        <!-- /navbar-inner -->
    </div>
</div>
<script type="text/javascript">
	//�˳�ϵͳ
	function exit() {
	    LoginAction.exit(function(){
	        window.location.href = "${pageScope.cuiWebRoot}/login.ac";
	    });
	}
    
    require(['sys/dwr/interface/LoginAction'], function() {
     
     }); 
    
     //����cui,��Ҫ��Ϊ����ʾ
     require(['cui'], function() {});
	
    //�����ɴ��봰��
    function openGenCode() {
    	var nodeId = "";
    	var nodeTypeVal = nodeData.getData().data.moduleType;
    	var genNode = nodeData;
    	switch(nodeTypeVal) {
	    	case 4: // ʵ��
			case 5: // ��
			case 6: // ����
			case 7: // ��ѯ
			case 8: // ����
			case 9: // ������������
			case 10: // ������
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
    //��ϵͳ���ô���
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
