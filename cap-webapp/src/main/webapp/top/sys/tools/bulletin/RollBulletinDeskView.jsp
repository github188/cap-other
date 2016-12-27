 <%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp" %> 
<html>
<head>
<link href="css/bulletin.css" rel="stylesheet"></link>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/BulletinAction.js"></script>
<title>滚动公告</title>
</head>

<body>
 <div id="showData"> 
 
 </div>
 <script language="javascript">
 var not_resize=true;
	$(function () {
	    getRollBulletinInfo();
	});

	/*
	 * 读取滚动公告信息
	 */
	function getRollBulletinInfo() {
	    var vRollHtml = "";
	    var objBulletinVO = {pageNo:1,pageSize:1000};
	    BulletinAction.queryBulletinList(objBulletinVO, function (data) {
	    	var dataSourceList = data.list;
	    	var dataSourceCount = data.count;
	        var num = 0;
	        if (dataSourceCount == 0 || dataSourceList == null) {
	            vRollHtml += "暂无滚动公告。";
	        }else {
	          for (var i = 0; i < dataSourceList.length; i++) {
	              num++;
	              vRollHtml += "<div class='pop'><h3>" + (i + 1) + "." + dataSourceList[i].title + "</h3><div class='pop_content'>" + dataSourceList[i].contentClob + " </div> ";
	              vRollHtml += '</div>';
	          }
	       }
	        $("#showData").html(vRollHtml);
	    });
	}

	</script>
</body>
</html>
	
