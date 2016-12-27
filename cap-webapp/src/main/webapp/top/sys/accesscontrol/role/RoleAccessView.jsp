<%@ page language="java" contentType="text/html; charset=GB18030"
    pageEncoding="GB18030"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GB18030">
<title>角色权限视图</title>
<cui:link href="/top/css/top_base.css"/>
    <cui:link href="/top/component/topui/cui/themes/default/css/comtop.ui.min.css"/>
    <cui:script src="/top/component/topui/cui/js/comtop.ui.min.js"/>
    <cui:script src="/dwr/engine.js"/>
    <cui:script src="/top/sys/dwr/interface/RoleAction.js"/>
    <cui:script src="/top/sys/js/commonUtil.js"/>
    <style>
    	body, html{width:100%;margin:0!important;overflow:hidden;}
    </style>
</head>
<body>
<cui:borderlayout  id="border" is_root="true" gap="0px 0px 0px 0px">           
		<cui:bpanel  position="center" id="centerMain">
			<cui:tab id="accessTabs" tabs="accessTabs" fill_height="true"></cui:tab> 
		</cui:bpanel> 
</cui:borderlayout> 
<script type="text/javascript">
        var clickRoleId = "<c:out value='${param.roleId}'/>";
        var clickRoleName = "<c:out value='${param.roleName}'/>";
        var roleType = "<c:out value='${param.roleType}'/>";
        
        //设置tab的属性
        var accessTabs=[
                  {id:"menuAccess",title:"功能权限",tab_width:80,url:"RoleQuerySystemAccessMain.jsp?roleId="+clickRoleId+"&roleName="+clickRoleName},
                  {id:"menuAccess",title:"操作权限",tab_width:80,url:"RoleQuerySystemAccessMain.jsp?roleId="+clickRoleId+"&roleName="+clickRoleName},
        ]; 
        
        //扫描，相当于渲染
       window.onload=function(){
        	/*if("app"==roleType){
        		accessTabs=[{id:"userAccess",title:"人员",tab_width:80,url:"RoleQueryUser.jsp?roleId="+clickRoleId+"&roleName="+clickRoleName}];
        	}*/
		    comtop.UI.scan();
	     }
        </script>
</body>
</html>