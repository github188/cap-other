<%
  /**********************************************************************
			 * 委托管理-主界面
			 * 2013-04-22  汪超  新建
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK"/>
    <title>委托管理</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">

	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/UserDelegateAction.js"></script>

	<style type="text/css">
		ul#menu, ul#menu ul {
		    list-style: none;
		    margin: 0;
		    padding: 0;
		}
		ul#menu{
			position:relative; 
			top:10px;
		    margin:0px 10px 0px 70px;
		
		}
		ul#menu a {
		    text-decoration: none;
		    display: block;
		    color: #000000;
		    margin: 0 0 -1px;
		    padding: 8px;
		    border: 1px solid #e5e5e5;
		
		}
		
		ul#menu li {
		    line-height: 20px;
		    width: 100%;
		}
		
		ul#menu li a:hover{
		    background-color: #f5f5f5;
		}
		ul#menu li ul li a {
		
		    padding-left: 30px;
		
		}
		#menu .componentTitle {
		    font-weight: 700;
		}
	</style>
</head>
<body>
	<div uitype="Borderlayout" is_root="true" gap="0px 0px 0px 0px" id="consignManagementMain">
		
		<div position="left" id="leftMain" width="250">
			 <ul id="menu" >
				 <li>
		        <a href="javascript:addConsign();" class="componentTitle">新建委托任务</a>
		        </li>
		         <li>
		        <a href="javascript:queryConsign();" class="componentTitle">查看历史委托</a>
		        </li>
			</ul>
		</div>
				
		<div position="center" id="centerMain">
		</div>
		
	</div>


        <script type="text/javascript"> 
		// 选中的用户id
    	var userId = globalUserId;
        window.onload=function(){	
  			comtop.UI.scan();
  			addConsign();
	     }
        
        function addConsign(){
        	cui('#consignManagementMain').setContentURL("center", "ConsignEdit.jsp?userId="+userId+"&consignId=");     	
        
        }
        
        function queryConsign(){
        	cui('#consignManagementMain').setContentURL("center", "ConsignUserList.jsp?userId="+userId);     	
        }
  
        </script>
</body>
</html>