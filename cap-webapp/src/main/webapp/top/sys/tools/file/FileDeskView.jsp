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
	<title>资料及控件下载</title> 
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
       		var fileClassify = "<c:out value='${param.fileClassify}'/>";
       		var condition = {};
      		 var dataSourceList, dataSourceCount, now;
      		 require(['underscore','sys/dwr/interface/FileAction'], function() {
      			condition.pageNo=1;
      			condition.pageSize=10;
      			if (fileClassify !=null && fileClassify != '') {
      				condition.fileClassify = fileClassify;
      			}
      			FileAction.queryFileList(condition,function(data) {
                    now = data.nowDate;
          		    dataSourceList =data.list;
                    dataSourceCount = data.count;
            	    if(dataSourceCount>5){                    	
            	    	dataSourceList = dataSourceList.slice(0,5); 
                    }
                    var html = _.template($("#template_id").html(), dataSourceList);
                    $("#list_id").html(html);
                });
      		 });
        	
        	function down(fileId){
        		var url = "${pageScope.cuiWebRoot}/top/sys/tools/file/downloadFile.ac?downloadId="+fileId;
        		window.location=url;
        	}
        </script> 
        
       <!-- 定义模版 -->
        <script type="text/template" id="template_id">
        	<@  if(dataSourceCount==0)  {@>
        		<div style="text-align:center;color:#888888;">暂无记录</div>
        	<@  }else{ @>
        	   <table style="width:100%;TABLE-LAYOUT:fixed;WORD-WRAP:break_word;font-size:12px">
                    <@ _.each(dataSourceList,function(item,index){
        				 var year = item.createTime.getFullYear();
                         var month = item.createTime.getMonth() + 1;
                         var date = item.createTime.getDate();
                         var hours = item.createTime.getHours();
                         var minutes = item.createTime.getMinutes();
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
                    @>
        			<tr> 
        				<td style="cursor:hand;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
        					<a target='a_blank'  onclick='down("<@=item.fileId@>");' title='<@=item.fileName@>'><@=item.fileName@></a>
        				</td>
        				<td title="<@= sendDate @>" align="right" style="width:40px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">
        					&nbsp;&nbsp;<@= sendDate @>
        				</td>
        			</tr>	
        			<@ });  @>
        	  	   	<@  if(dataSourceCount>5)  {@>			
   					<tr>
						<td colspan="2" align="right">
							<a href="javascript:void(0)"  data-url="${pageScope.cuiWebRoot}/top/sys/tools/file/FileList.jsp?isShowHeader=1&fileClassify=<@=fileClassify@>" data-mainframe="false">更多</a>
						</td>
					</tr>
 		<@  } @>
        	   </table>
        	<@  } @>
        </script>
  </body>
</html>