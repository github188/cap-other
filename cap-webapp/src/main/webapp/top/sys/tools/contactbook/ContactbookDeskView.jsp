<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
    <head>
        <title>插件管理</title> 
    <%//360浏览器指定webkit内核打开%>
	<meta name="renderer" content="webkit">
	<%//关闭ie兼容模式,使用最高版本文档模式渲染页面%>
	<meta http-equiv="x-ua-compatible" content="IE=edge" >
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/base/css/base.css"/>
      <style type="text/css">
       html,body{
        margin:0;
        padding:0
       }
       </style>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/base/js/base.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/tools/file/underscore/underscore-min.js'></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/ContactbookAction.js"></script>
	<script type="text/javascript" >
 	_.templateSettings = {
 		    interpolate: /\<\@\=(.+?)\@\>/gim,
 		    evaluate: /\<\@([\s\S]+?)\@\>/gim,
		    escape: /\<\@\-([\s\S]+?)\@\>/gim
		}; 
	</script>
    </head>
    <body style="background-color:white">
        <div id="list_id" ></div>
       <script language="javascript">
        	$(document).ready(function(){
        		 var dataSourceList, dataSourceCount, now;
        		 var condition = {pageNo:1,pageSize:10};	
        		 ContactbookAction.queryContactBookList(condition,function(data) {   		     		 
            	    data.dataSourceList = data.list||[];
            	    if(data.dataSourceList.length>5){                    	
            	    	data.dataSourceList =data.dataSourceList.slice(0,5); 
                    }
                    data.dataSourceCount = data.count;
                    now = data.nowDate;
                   var html = _.template($("#template_id").html(), data);
                    $("#list_id").html(html);
                });  
        	});
        </script> 
        
       <!-- 定义模版 -->
        <script type="text/template" id="template_id">
        	<@  if(dataSourceCount==0)  {@>
        		<div style="text-align:center;color:#888888;">暂无记录</div>
  		<div style="text-align:right;color:#888888;">
   				<tr><td colspan="3" align="right"><a  href="javascript:void(0)"  data-url="${pageScope.cuiWebRoot}/top/sys/tools/contactbook/ContactbookList.jsp?isShowHeader=1"  data-mainframe="false">添加</a></td></tr>
</div>       
 	<@  }else{ @>
        	   <table style="width:100%;TABLE-LAYOUT:fixed;WORD-WRAP:break_word;font-size:12px">

                  <@ _.each(dataSourceList,function(item,index){
        				  var year = item.createTime.getFullYear();
                          var month = item.createTime.getMonth() + 1;
                          var date = item.createTime.getDate();
                          var hours = item.createTime.getHours();
                          var minutes = item.createTime.getMinutes();
                          var time =(hours<10?'0' + hours :hours) + ':' + (minutes<10?'0' + minutes:minutes);
 					var sendDate="";
        			    var nowYear = item.createTime.getFullYear();
        				 var nowMonth = item.createTime.getMonth() + 1;
                       var nowDate = item.createTime.getDate();
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
        				<td title="<@= item.contacter @>" style="width:65px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">
        					<@= item.contacter @>
        				</td>
        				<td title="<@= item.tel @>" style="cursor:hand;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
        					&nbsp;&nbsp;<@= item.tel @>
        				</td>
        				<td title="<@= item.remark @>" align="right" style="width:130px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">
        					&nbsp;&nbsp;<@= item.remark @>
        				</td>
        			</tr>	
        			<@ });  @>     	  	
   				<tr><td colspan="3" align="right"><a href="javascript:void(0)"  style="text-decoration:none;color:#08c"  data-url="${pageScope.cuiWebRoot}/top/sys/tools/contactbook/ContactbookList.jsp?isShowHeader=1"  data-mainframe="false">更多</a></td></tr>        	  
        	   </table>
        	<@  } @>
        </script>
        
  </body>
</html>