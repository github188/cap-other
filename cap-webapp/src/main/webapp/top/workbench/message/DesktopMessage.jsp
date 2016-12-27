<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
    String version = formatter.format(new Date());
%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
    <head>
        <title>桌面消息</title>
        <%//360浏览器指定webkit内核打开%>
		<meta name="renderer" content="webkit">
		<%//关闭ie兼容模式,使用最高版本文档模式渲染页面%>
		<meta http-equiv="x-ua-compatible" content="IE=edge" >
		<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/base/css/base.css?v=<%=version%>"/>
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
            require(['underscore','workbench/dwr/interface/DesktopMessageAction'], function() {
                DesktopMessageAction.queryCurrentMessageList(function(data) {
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
        	   <table style="width:100%;TABLE-LAYOUT:fixed;WORD-WRAP:break_word;font-size:12px">
                    <@ _.each(dataSourceList,function(item,index){
        				  var year = item.sendDate.getFullYear();
                          var month = item.sendDate.getMonth() + 1;
                          var date = item.sendDate.getDate();
                          var hours = item.sendDate.getHours();
                          var minutes = item.sendDate.getMinutes();
                          var time =(hours<10?'0' + hours :hours) + ':' + (minutes<10?'0' + minutes:minutes);
        			      var nowYear = now.getFullYear();
        				  var nowMonth = now.getMonth() + 1;
                          var nowDate = now.getDate();
        				  var sendDate;
        				  var intervalDate = Math.abs(new Date((nowYear+"-"+nowMonth+"-"+nowDate).replace(/-/g,'/')) - new Date((year+"-"+month+"-"+date).replace(/-/g,'/')))/(1000*60*60*24)
        				  if(intervalDate==0){
        				  	 sendDate = time;
                          }else if(intervalDate==1){
        				  	 sendDate = "昨天";
                          }else if(intervalDate==2){
        					 sendDate = "前天";
        				  }else if(nowYear != year){
        					  sendDate = year;
                          }else{
        				      sendDate = month + "-" + date;
                          }
                            
						  if(item.messageUrl){
				  			if(item.messageUrl.indexOf('?')>-1){
				      		  item.messageUrl += '&messageId='+ item.messageId;
				  		  	}else{
					  		  item.messageUrl += '?messageId='+ item.messageId;
				  		  	}
						  }
                    @>
        			<tr>
        				<td title="<@= item.messageTitle @>" style="width:50px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">
        					<@= item.messageTitle @>
        				</td>
        				<td title="<@= replaceSpecialSymbols(item.messageBody) @>" style="cursor:hand;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
							<@  if(item.messageUrl)  {@>
        						&nbsp;&nbsp;<a style="color:#08c;" href="javascript:void(0)" target="_blank" data-url="<@=item.messageUrl@>" data-appcode="<@=item.appId@>" data-shownav="false"><@= replaceSpecialSymbols(item.messageBody) @></a>
        					<@  }else{ @>
								&nbsp;&nbsp;<@= replaceSpecialSymbols(item.messageBody) @>
							<@  } @>
						</td>
        				<td title="<@= sendDate @>" align="right" style="width:40px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">
        					&nbsp;&nbsp;<@= sendDate @>
        				</td>
        			</tr>	
        			<@ });  @>
        	  	   	<@  if(dataSourceCount>5)  {@>
        				<tr><td colspan="3" align="right"><a href="javascript:void(0)" style="text-decoration:none;color:#08c" data-url="/top/workbench/message/gotoMessageCenter.ac" data-mainframe="false">更多</a></td></tr>
        	   		<@  } @>
        	   </table>
        	<@  } @>
        </script>
    </body>
</html>