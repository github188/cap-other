<%
  /**********************************************************************
	* CAP首页主页面 
	* 2015-09-22  李小芬  新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
<title>CAP首页</title>
	<top:link  href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
</head>
<style>
html,body{
	height: 100%;
}

.main {
	width:100%;
	height:100%;
	overflow:auto;
}
.leftpanle {
	float:left;
	width:30%;
	border:1px;
	height:auto;
}
.rightpanel {
	height:auto;
	border:1px;
	width:auto;
	margin-left:30%;
	padding-left:2px;
	padding-top:1px;
}
.demoContainer {
	margin-top: 5px;
}

.userinfo {
	padding-left:15px;
	padding-top:15px;
	float:left;
	height:170px;
	width:70%;
	font-size:12px;
}

.infoLeft {
	float:left;
	border:1px solid #909090;
}

.infoCenter {
	margin: 50px 0px 5px 130px;
}

.infoRight {
	margin: 50px 0px 0px 10px;
	float:left;
	color:#909090;
	font-size:12px;
}

.imgSize {
	width:120px;
	height:150px;
}

</style>
<body>
<div id="main" class="main"> 
	<div id="left" class="leftpanle"> 
		<div class="demoContainer">
		    <div  uitype="panel" header_title="个人信息" url="">
			    <div class="userinfo">
			    	<div class="infoLeft"><img class="imgSize" id="userImg" src="../index/image/person.jpg"/></div>
			    	<div class="infoCenter">
			    		<span id="userName" style="font-size:14px;font-weight:bold;color:#5f5f5f;"></span>
			    	</div>
			    	<div class="infoRight">
			    	<span style="">上次登录时间</span>
			    	<br><span id="lastestTime" style=""></span>
			    	</div>
			    </div>
		    </div>
		</div>
		<div class="demoContainer">
			<div  uitype="panel" header_title="<a href='<%=request.getContextPath() %>/cap/ptc/notice/NoticeView.jsp'>团队公告</a>" url="<%=request.getContextPath() %>/cap/ptc/notice/NoticeTab.jsp"></div>
		</div>
	</div> 
	<div id="right" class="rightpanel"> 
		<div class="demoContainer">
		    <div  uitype="panel" header_title="应用中心" url="<%=request.getContextPath() %>/cap/ptc/index/AppCenter.jsp"></div>
		</div>
		<div class="demoContainer">
		    <div uitype="panel" height="900px" header_title="系统模块管理图" url="<%=request.getContextPath() %>/cap/bm/graph/ModuleRelationGraph.jsp?moduleId=E520E65B42334972ADE9460A87B3B544"></div>
		</div>
	</div> 
</div> 
<script type="text/javascript">
    comtop.UI.scan();
    cui("#userName").html("${capEmployee.bmEmployeeName}");
    cui("#lastestTime").html("2015-09-25 17:26 ");
</script>
</body>
</html>