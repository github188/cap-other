<%
/**********************************************************************
* 重新发送请求
* 2015-07-23 欧阳辉 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ taglib uri="http://www.szcomtop.com/soa/cui" prefix="cui"%>
<!doctype html>
<html>
<head>
	<title>重发请求</title>
	<cui:link href="/soa/top/component/ui/cui/themes/default/css/comtop.ui.min.css"/>
    <cui:link href="/soa/css/soa.css"/>
    <cui:script src="/soa/top/component/ui/cui/js/comtop.ui.min.js"/>
    <cui:script src="/soa/js/jquery.min.js"/>
    <cui:script src="/soa/js/soa.common.js"/>
</head>
<style>
	.top_header_wrap{
		padding-right:8px;
	}
</style>
<body>
<div uitype="Borderlayout"  id="body" is_root="true">	
	<div class="top_header_wrap" style="padding-top:3px">
		<div class="thw_title">
			<font id = "pageTittle" class="fontTitle"></font> 
		</div>
		<div class="thw_operate" style="height: 26px;">
			<span uitype="button" id="testWsdl" label="重发请求"  on_click="testWsdlConnectivity"></span>
		</div>
	</div>
	<div class="cui_ext_textmode" >
		<table class="form_table" style="table-layout:fixed;">
			<colgroup>
				<col width="12%" />
				<col width="87%" />
                 <col width="1%" />
			</colgroup>
	        <tr>
				<td class="td_label">请求地址：</td>
	            <td><span uitype="input" id="reqAddr" name="reqAddr"  width="658px" databind="oldData.reqAddr" ></span></td>           
	        </tr>
	         <tr>
	            <td class="td_label">请求报文：</td>
	            <td><span uitype="Textarea" id="inputArgs" width="658px" databind="oldData.inputArgs" height="260px"></span></td>	
	        </tr>
	         <tr>
	            <td class="td_label">响应报文：</td>
	            <td><span uitype="Textarea" id="invokeResult" width="658px" id="invokeResult" height="260px"></span></td>	
	        </tr>
		</table>
	</div>
</div>
<script type="text/javascript">
        var oldData={};
        var logId="${param.logId}";
           /**
            * 获取服务详细信息
            */
           function queryServiceCallDetail(){
           	var url = '<cui:webRoot/>/soa/SoaServlet/queryServiceCallDetail?operType=queryServiceCallDetail&logId='+logId+'&timeStamp='+ new Date().getTime();
           	//采用ajax请求提交
               $.ajax({
                    type: "GET",
                    url: url,
                    cache:false,
                    success: function(data,status){
                   	 oldData = jQuery.parseJSON(data);
            		    //扫描
            		    comtop.UI.scan();
                     },
                     error: function(msg, textStatus, errorThrown) {
                   	  
                     }
                });
           }

           /**
            * 测试服务连通性
            */
           function testWsdlConnectivity(){
           	var reqAddr = cui('#reqAddr').getValue();
           	var reqMsg = cui('#inputArgs').getValue();
           	var sid=oldData.methodCode;
   	      cui('#testWsdl').disable(true);
   	        cui('#invokeResult').setValue("正在执行请求...");
           	var url = '<cui:webRoot/>/soa/SoaServlet/doRequest?operType=doRequestWS&reqAddr='+reqAddr+'&sid='+sid+'&timeStamp='+ new Date().getTime();
               	//采用ajax请求提交
                   $.ajax({
                       type: "POST",
                       url: url,
                       contentType: "application/x-www-form-urlencoded; charset=UTF-8", 
                       data:{'reqMsg':reqMsg},
                       beforeSend: function(XMLHttpRequest){
                        	XMLHttpRequest.setRequestHeader("RequestType", "ajax");
                       },
                        cache:false,
                        success: function(data,status){
                   	        cui('#invokeResult').setValue(data);
                           	cui('#testWsdl').disable(false);
                         },
                         error: function(msg, textStatus, errorThrown) {
                             cui('#invokeResult').setValue("测试出现异常。"+msg);
                           	cui('#testWsdl').disable(false);
                         }
                    });
        }
           
   		window.onload = function(){
   		    queryServiceCallDetail();
   		}
	</script>
</body>
</html>