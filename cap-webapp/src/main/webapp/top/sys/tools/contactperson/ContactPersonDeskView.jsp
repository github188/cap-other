<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
    <head>
   <title>联系人管理</title> 
    <%//360浏览器指定webkit内核打开%>
	<meta name="renderer" content="webkit">
	<%//关闭ie兼容模式,使用最高版本文档模式渲染页面%>
	<meta http-equiv="x-ua-compatible" content="IE=edge" >
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/base/css/base.css"/>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/base/js/base.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/tools/file/underscore/underscore-min.js'></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/ContactPersonAction.js"></script>
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
        		 ContactPersonAction.queryContactPersonList(condition,function(data) {   		     		 
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
        	<@  }else{ @>
        	   <table style="width:100%;TABLE-LAYOUT:fixed;WORD-WRAP:break_word;font-size:12px" class="done-table">
                    <@ _.each(dataSourceList,function(item,index){
			var
			 MyDate = item.createTime.substring(5,item.createTime.length-10);
                    @>
        			<tr>
        				<td title="<@= item.contactContent @>" style="width:100%;cursor:hand;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
        					&nbsp;&nbsp;<@= item.contactContent@>
        			</tr>
        			<@ });  @>
        	  	   	<@  if(dataSourceCount>0)  {@>
   				<tr><td colspan="3" align="right"><a href="javascript:void(0)"  data-url="${pageScope.cuiWebRoot}/top/sys/tools/contactperson/ContactPersonList.jsp?isShowHeader=1" data-mainframe="false">更多</a></td></tr>        	  
					</td> 
		<@  } @>
        	   </table>
        	<@  } @>
        </script>
        
  </body>
</html>