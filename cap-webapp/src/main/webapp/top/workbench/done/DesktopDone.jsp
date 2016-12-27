<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
    String version = formatter.format(new Date());
%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
    <head>
        <title>桌面已办</title>
		<%//360浏览器指定webkit内核打开%>
		<meta name="renderer" content="webkit">
		<%//关闭ie兼容模式,使用最高版本文档模式渲染页面%>
		<meta http-equiv="x-ua-compatible" content="IE=edge" >
		<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/base/css/base.css?v=<%=version%>"/>
        <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/done/css/done.css?v=<%=version%>"/>
		<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/component/requirejs/require.js?v=<%=version%>"></script>
		<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/component/requirejs/require.config.js?v=<%=version%>"></script>
		<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js?v=<%=version%>"></script>
		<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/base/js/base.js?v=<%=version%>"></script>
		<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/dwr/engine.js?v=<%=version%>"></script>
    </head>
    <body style="background-color:white">
        <div id="list_id" ></div>
        <script language="javascript">
            var dataSourceList, dataSourceCount, now;
            require(['underscore', 'workbench/dwr/interface/DesktopDoneAction'], function() {
                DesktopDoneAction.queryCurrentDoneList(function(data) {
                    dataSourceList = data.list;
                    dataSourceCount = data.count;
                    now = data.nowDate;
                    var html = _.template($("#template_id").html(), dataSourceList);
                    $("#list_id").html(html);
                });
            }); 
        </script>
        
        <!-- 定义模版 -->
        <script type="text/template" id="template_id">
        	<@  if(dataSourceCount==0)  {@>
        		<div style="text-align:center;color:#888888;">暂无记录</div>
        	<@  }else{ @>
        	   <table class="done-table">
        			<@  _.each(dataSourceList,function(item){ 
        				  var year = item.transdate.getFullYear();
         				  var month = item.transdate.getMonth() + 1;
                          var date = item.transdate.getDate();
                          var hours = item.transdate.getHours();
                          var minutes = item.transdate.getMinutes();
                          var time =(hours<10?'0' + hours :hours) + ':' + (minutes<10?'0' + minutes:minutes);
        				  var nowYear = now.getFullYear();
        				  var nowMonth = now.getMonth() + 1;
                          var nowDate = now.getDate();
        				  var transdate;
        				  var intervalDate = Math.abs(new Date((nowYear+"-"+nowMonth+"-"+nowDate).replace(/-/g,'/')) - new Date((year+"-"+month+"-"+date).replace(/-/g,'/')))/(1000*60*60*24)
        				  if(intervalDate==0){
        				  	 transdate = time;
                          }else if(intervalDate==1){
        				  	 transdate = "昨天";
                          }else if(intervalDate==2){
        					 transdate = "前天";
        				  }else if(nowYear != year){
        					  transdate = year;
                          }else{
        				      transdate = month + "-" + date;
                          }
        			@>
        			<tr>
        				<td title="<@= item.processName @>" style="width:72px;" ><@= item.processName @></td>
        				<td title="<@= item.workOperate @><@= replaceSpecialSymbols(item.workTitle) @>" >
							<@  if(item.doneUrl != null && item.isDisplay != 'N')  {@>
        						<a href="javascript:void(0)" style="color:#08c;" target="_blank" data-url="<@= replaceSpecialSymbolsInUrl(item.doneUrl) @>" data-appcode="<@=item.appId@>" data-shownav="false"><@= item.workOperate @><@= replaceSpecialSymbols(item.workTitle) @></a>
        					<@  }else{ @>
								<@= item.workOperate @><@= replaceSpecialSymbols(item.workTitle) @>
							<@  } @>
						</td>
        				<td title="<@= transdate @>"  align="right" style="width:34px;"><@= transdate @></td>
        			</tr>	
        			<@ });  @>
        	  	   	<@  if(dataSourceCount>5)  {@>
        				<tr><td colspan="3" align="right"><a href="javascript:void(0)" style="text-decoration:none;color:#08c;" data-url="/top/workbench/done/gotoDoneCenter.ac" data-mainframe="false">更多</a></td></tr>
        	   		<@  } @>
        	   </table>
        	<@  } @>
        </script>
  </body>
</html>