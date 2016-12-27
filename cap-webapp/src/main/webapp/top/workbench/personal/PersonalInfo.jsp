<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
    String version = formatter.format(new Date());
%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<html>
    <head>
        <title>������Ϣչʾ</title>
		<%//360�����ָ��webkit�ں˴�%>
		<meta name="renderer" content="webkit">
		<%//�ر�ie����ģʽ,ʹ����߰汾�ĵ�ģʽ��Ⱦҳ��%>
		<meta http-equiv="x-ua-compatible" content="IE=edge" >
		<style type="text/css">
            html,body{
                background-color:#fff;
            }
            .department {
                font-size: 16px;
            }
            .user-name {
                font-size: 16px;
                font-weight: bold;
                color: #333;
            }
            .user-post {
                font-size: 14px;
            }
            .user-header{
                width:90px;
                height:90px;
                background:url(./img/default_head.jpg);
            }
            .weather{
                font-size:14px;
            }
            table{
                width:100%;
            }
            table td{
                color:#666;
            }
        </style>
		<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/base/css/base.css?v=<%=version%>"/>
		<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/component/requirejs/require.js?v=<%=version%>"></script>
		<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/component/requirejs/require.config.js?v=<%=version%>"></script>
		<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js?v=<%=version%>"></script>
		<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/base/js/base.js?v=<%=version%>"></script>
		<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/dwr/engine.js?v=<%=version%>"></script>
    </head>
    <body>
        <table style="height:143px">
            <tr>
                <td colspan="2" class="department">
                </td>
            </tr>
            <tr>
                <td width="35%">
                	<img class="user-header"/>
                </td>
                <td>
                    <table width="100%" align="left" height="100px">
                        <tr style ="margin-top:10px">
                            <td class="user-name" >${userInfo.employeeName} </td>
                            <td class="user-post" id="user-post"></td>
                        </tr>
                        <tr>
                            <td colspan="2"  height="20px">�ϴε�¼ʱ��</td>
                        </tr>
                        <tr>
                            <td colspan="2"  height="20px" id="lastLoginDate">����</td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        
        <script>
			var nameFullPath ='${userInfo.nameFullPath}';
			var nameFullPathArray = nameFullPath.split('/');
			var leg = nameFullPathArray.length;
			if(leg > 2){
				nameFullPath = nameFullPathArray[leg-2] + "/" + nameFullPathArray[leg-1];
			}
			$(".department").html(nameFullPath);
			require(['workbench/dwr/interface/UserPersonalizationAction'],function(){
    			UserPersonalizationAction.getUserInfo(function(data) {
    				 var curDate = data.lastLoginDate;
    				 if(curDate != null){
    	                 var year = curDate.getFullYear();
    	                 var month = curDate.getMonth() + 1;
    	                 var date = curDate.getDate();
    	                 var hour = curDate.getHours();
    	                 var minutes = curDate.getMinutes();
    	                 if(minutes<10){
    	                	minutes = "0"+minutes;
    	                 }
    					 $("#lastLoginDate").html(year+"-"+month+"-"+date+" "+hour+":"+minutes);
    				 }
    				 if(data.isHasHead == 'Y'){
    					$(".user-header").attr("src","${pageScope.cuiWebRoot}/top/workbench/workbenchServlet.ac?actionType=displayHead");
    				 }
    				 /**
    				 var postInfo = data.postInfo;
                     if(postInfo&&postInfo.length>0){
                         var postName = [];
                         for(var i=0;i<postInfo.length;i++){
                             postName.push(postInfo[i].postName);
                         }
                         $('#user-post').html(postName.join(';'));
                     }
                     **/
    			});  
			});   	
		</script>
    </body>
</html>
