<!DOCTYPE html>
<meta http-equiv="X-UA-Compatible"content="IE=Edge">
<%
  /**********************************************************************
	* CAP首页主页面 
	* 2015-09-22  李小芬  新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/dev/main/header.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<html>
<head>
<title>CAP首页</title>
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
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
	width:40%;
	border:1px;
	height:auto;
}
.rightpanel {
	height:auto;
	border:1px;
	width:auto;
	margin-left:40%;
	padding-left:2px;
}
.demoContainer {
	margin-top: 5px;
}

.userinfo {
	padding-left:15px;
	padding-top:15px;
	float:left;
	height:170px;
	width:60%;
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
	<script type="text/template" id="app-tmpl">
		<@ if(isPM) {@>
			<div id="left" class="leftpanle">
				<!-- <div class="demoContainer">
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
				</div> -->
			
				<div class="demoContainer">
					<div id="noticeTab" height="197" uitype="panel" header_title="团队公告" url="<%=request.getContextPath() %>/cap/ptc/notice/NoticeTab.jsp"></div>
				</div>
				<div class="demoContainer">
				    <div uitype="panel" height="452" header_title="系统整体资源统计" url="<%=request.getContextPath() %>/cap/ptc/report/SystemPieChart.jsp"></div>
				</div>
				<div class="demoContainer">
				    <div  uitype="panel" height="352" header_title="项目模块复杂度分析" url="<%=request.getContextPath() %>/cap/ptc/report/SystemModuleChart.jsp"></div>
				</div>
				<div class="demoContainer">
				    <div id="phasedChart" uitype="panel" header_title="阶段性资源变化统计" url="<%=request.getContextPath() %>/cap/ptc/report/SystemPhasedChart.jsp"></div>
				</div>
			</div>
			<div id="right" class="rightpanel"> 
				<div class="demoContainer">
				    <div id="appCenter" uitype="panel" header_title="应用中心" url="<%=request.getContextPath() %>/cap/ptc/index/AppCenter.jsp"></div>
				</div>
				<div class="demoContainer">
				    <div id="testChart" uitype="panel" height="600" header_title="系统模块测试报表" url="<%=request.getContextPath() %>/cap/ptc/report/SystemModuleTestReportChart.jsp"></div>
				</div>
				<div class="demoContainer">
				    <div id="ModuleGraph" uitype="panel" header_title="系统模块管理图" url="<%=request.getContextPath() %>/cap/bm/graph/HomeModuleRelationGraph.jsp"></div>
				</div>
			</div>
		<@ }else { @>
			<div id="left" class="leftpanle">
				<div class="demoContainer">
					<div id="noticeTab" height="197" uitype="panel" header_title="团队公告" url="<%=request.getContextPath() %>/cap/ptc/notice/NoticeTab.jsp"></div>
				</div>
				<div class="demoContainer">
				    <div id="appCenter" uitype="panel" header_title="应用中心" url="<%=request.getContextPath() %>/cap/ptc/index/AppCenter.jsp"></div>
				</div>
				
			</div>
			<div id="right" class="rightpanel"> 
				<div class="demoContainer">
				    <div id="ModuleGraph" uitype="panel" header_title="系统模块管理图" url="<%=request.getContextPath() %>/cap/bm/graph/HomeModuleRelationGraph.jsp"></div>
				</div>
			</div>	
		<@ } @>
	</script>
</div>
<script type="text/javascript">
	require([ 'jquery', 'cui', 'underscore'], function() {
		var g = window;
		var employeeId = g.globalCapEmployeeId;
		var roleIds = g.globalCapRoleIds.split(';');
		var temHtml = _.template($('#app-tmpl').html(), {
            'isPM' : $.inArray('pm', roleIds) > -1 
        });
        $('#main').html(temHtml);

		comtop.UI.scan();

	    // 用于防止绑定多个resize事件
	    var resizeBindArray = [];

	    /**
	     * reset panel height 调用点在各位panel页面内
	     * @param  string panelId  uitype="panel"的id名称
	     * @param  string elemId 该元素id的height会设置为iframe高度，若不填就会获取iframe body的高度
	     * @param  fixHeight 需要修正的高度值 单位(px)
	     */
	    g.resetPanelHeight = function (panelId, elemId, fixHeight) {
	    	var $iframe = $("#" + panelId).find('iframe');
	    	if(elemId) {
	    		elemId = "#" + elemId;
	    	}else {
	    		elemId = "body";
	    	}
	   		// console.debug("(set)%s",panelId);
			setFrameHeight ($iframe, elemId, fixHeight);
	    	if($iframe && $.inArray(panelId, resizeBindArray) < 0) {
				resizeBindArray.push(panelId);
	    		//增加对应 resize 事件用于调整frame大小
		    	$(g.parent).on("resize", function (event) {
					// console.debug("(resize):%s",panelId);
		    		setFrameHeight ($iframe, elemId, fixHeight);
		    	});
	    	}
	    }

	    /**
	     * 设置对应iframe的高度
	     * @param {jquery object} $iframe   需要设置的iframe对象
	     * @param  string elemId 该元素id的height会设置为iframe高度
	     * @param  fixHeight 需要修正的高度值 单位(px)
	     */
	    function setFrameHeight ($iframe, elemId, fixHeight) {
	    	if($(elemId, $iframe[0].contentDocument)[0]&&$(elemId, $iframe[0].contentDocument)[0].scrollHeight){
		    	var height = $(elemId, $iframe[0].contentDocument)[0].scrollHeight;
				//修正高度
				if (fixHeight) {
					height = height + fixHeight;
				};
				// $iframe.removeAttr("style");
				// console.debug("height:",height);
	    		// $iframe.attr("height", height);
	    		$iframe.height(height);
	    	}
	    }
	});
</script>
</body>
</html>