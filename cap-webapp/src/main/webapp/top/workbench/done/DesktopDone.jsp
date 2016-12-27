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
        <title>�����Ѱ�</title>
		<%//360�����ָ��webkit�ں˴�%>
		<meta name="renderer" content="webkit">
		<%//�ر�ie����ģʽ,ʹ����߰汾�ĵ�ģʽ��Ⱦҳ��%>
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
        
        <!-- ����ģ�� -->
        <script type="text/template" id="template_id">
        	<@  if(dataSourceCount==0)  {@>
        		<div style="text-align:center;color:#888888;">���޼�¼</div>
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
        				  	 transdate = "����";
                          }else if(intervalDate==2){
        					 transdate = "ǰ��";
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
        				<tr><td colspan="3" align="right"><a href="javascript:void(0)" style="text-decoration:none;color:#08c;" data-url="/top/workbench/done/gotoDoneCenter.ac" data-mainframe="false">����</a></td></tr>
        	   		<@  } @>
        	   </table>
        	<@  } @>
        </script>
  </body>
</html>