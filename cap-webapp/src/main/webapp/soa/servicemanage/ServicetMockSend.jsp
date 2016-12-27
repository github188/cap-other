<%
/**********************************************************************
* 接口测试
* 2015-07-23 欧阳辉 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ taglib uri="http://www.szcomtop.com/soa/cui" prefix="cui"%>
<!doctype html>
<html>
<head>
	<title>接口测试</title>
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
			<span uitype="button" id="testSubmit" label="发送请求"  on_click="callHttpUrl"></span>
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
				<td class="td_label">服务请求方：</td>
				<td><span id="sysId" width="100%" value_field="code"  label_field="name" uitype="PullDown" mode="Single" datasource="renderBussSystem" value="-1" on_change="selectSys"></td>
			   <td>&nbsp;&nbsp;</td>
			</tr>
	        <tr>
				<td class="td_label">服务标识：</td>
	            <td><span uitype="input" id="methodCode"  width="100%" readonly="true"></span></td>           
	        </tr>
	         <tr>
	            <td class="td_label">请求报文：</td>
	            <td><span uitype="Textarea" id="inputArgs" width="100%" height="125px"></span></td>	
	        </tr>
	         <tr>
	            <td class="td_label">响应报文：</td>
	            <td><span uitype="Textarea" id="invokeResult" width="100%" id="invokeResult" height="125px"></span></td>	
	        </tr>
	         <tr>
	            <td class="td_label">&nbsp;&nbsp;</td>
	            <td><font color="red">注：请慎重操作此功能,调用更新操作可能导致数据混乱或产生垃圾数据！</font></td>	
	        </tr>
		</table>
	</div>
</div>
<script type="text/javascript">
   var oldData={};
   var reqSysCode="";
   function renderBussSystem(obj){
    	var url = '<cui:webRoot/>/soa/SoaServlet/query?operType=queryBussSystemList&timeStamp='+ new Date().getTime();
        //采用ajax请求提交
        $.ajax({
             type: "GET",
             url: url,
             success: function(data,status){
      		   var emptydata = jQuery.parseJSON(data);
      		   obj.setDatasource(emptydata);
             }
         });
    }
    function selectSys(obj){
    	 //cui('#reqAddr').setValue(obj.httpUrl);
    	 reqSysCode=obj.code;
    }
    /**
     * 测试服务连通性
     */
    function callHttpUrl(){
    	var sid = cui('#methodCode').getValue();
    	var reqMsg = cui('#inputArgs').getValue();
    	//var reqAddr=cui('#reqAddr').getValue();
    	var url ='<cui:webRoot/>/soa/SoaServlet/doRequest?operType=doRequestService&sysCode='+reqSysCode+'&sid='+sid+'&timeStamp='+ new Date().getTime();
        cui('#testSubmit').disable(true);
        cui('#invokeResult').setValue("正在执行请求...");
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
                	cui('#testSubmit').disable(false);
              },
              error: function(msg, textStatus, errorThrown) {
                  cui('#invokeResult').setValue("测试出现异常。"+msg);
              	  cui('#testSubmit').disable(false);
              }
         });
    }
    /**
     * 获取服务详细信息
     */
    function getReqFormat(){
    	var methodCode = cui('#methodCode').getValue();
    	var sysCode="${param.sysCode}";
    	var url = '<cui:webRoot/>/soa/SoaServlet/query?operType=getReqFormat&methodCode='+methodCode+'&sysCode='+sysCode+'&timeStamp='+ new Date().getTime();
        $.ajax({
             type: "GET",
             url: url,
             cache:false,
             success: function(data,status){
        	    cui('#inputArgs').setValue(data);
              },
              error: function(msg, textStatus, errorThrown) {
            	  
              }
         });
    }
    window.onload = function(){
		    //扫描
		    comtop.UI.scan();
   			cui('#methodCode').setValue("${param.methodCode}");
   			getReqFormat();
   		}
	</script>
</body>
</html>