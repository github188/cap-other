<%
/**********************************************************************
* 内部服务信息编辑
* 2015-08-06 欧阳辉 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ taglib uri="http://www.szcomtop.com/soa/cui" prefix="cui"%>
<!doctype html>
<html>
<head>
	<title>内部服务信息编辑</title>
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
		<div class="thw_operate">
			<span uitype="button" id="save" label="保存"  on_click="save" ></span>
		</div>
	</div>
	<div class="cui_ext_textmode" >
		<table class="form_table" style="table-layout:fixed;">
			<colgroup>
				<col width="18%" />
				<col width="79%" />
				<col width="3%" />
			</colgroup>
			<tr>
				<td class="td_label">服务中文名：</td>
				<td><span uitype="input" name="name" id="name" width="320px" databind="oldData.name" maxlength="50"></span></td>
			</tr>
	        <tr>
				<td class="td_label">服务别名：</td>
	            <td><span uitype="input" id="code" name="code"  width="320px" databind="oldData.code" readonly="true"></span></td>           
	        </tr>
			<tr>
				<td class="td_label">所属系统：</td>
				<td><span uitype="input" name="sysName" id="sysName" width="320px" databind="oldData.sysName" maxlength="50" readonly="true"></span></td>
			</tr>
			<tr>
				<td class="td_label">服务目录：</td>
				<td><span uitype="input" name="dirName" id="dirName" width="320px" databind="oldData.dirName" maxlength="50" readonly="true"></span></td>
			</tr>			
			<tr>
				<td class="td_label">服务类/地址：</td>
	            <td><span uitype="input" id="serviceAddress" name="serviceAddress" width="320px" databind="oldData.serviceAddress" readonly="true"></span></td>
			</tr>
	        <tr>         
	            <td class="td_label">服务构造器：</td>
	            <td><span uitype="input" id="builderClass" name="builderClass" width="320px" databind="oldData.builderClass" readonly="true"></span></td>
	        </tr>
		</table>
	</div>
</div>
<script type="text/javascript">
     var sysCode = "${param.sysCode}";
     var dirCode = "${param.dirCode}";
     var oldData;
        /**
         * 保存服务
         */
        function save(){
        	var code = cui('#code').getValue();
        	var builderClass = cui('#builderClass').getValue();
        	var name = cui('#name').getValue();
        	var serviceAddress = cui('#serviceAddress').getValue();
        	var url = '<cui:webRoot/>/soa/SoaServlet/updateService?operType=updateService&timeStamp='+ new Date().getTime();
        	 var dataParams={'serviceCode':code,'builderClass':builderClass,'serviceName':name,'serviceAddress':serviceAddress};
        	cui('#save').disable(true);
        	//采用ajax请求提交
            $.ajax({
                 type: "POST",
                 url: url,
                 contentType:"application/x-www-form-urlencoded; charset=UTF-8",
                 data:dataParams,
                 beforeSend: function(XMLHttpRequest){
                 	XMLHttpRequest.setRequestHeader("RequestType", "ajax"); 
                  }, 
                 success: function(data,status){
            	        var treeData = jQuery.parseJSON(data);
            	        if (!checkStrEmty(data)){
            	        	window.parent.editRefreshTree(treeData.code);
            	        }
            	        window.parent.cui.message('保存成功。', 'success');
            	        window.parent.location.href='<cui:webRoot/>/soa/servicemanage/ServiceList.jsp?sysCode='+sysCode+'&dirCode='+dirCode;
                  },
                 error: function (msg) {
                	 window.parent.cui.message('保存失败。', 'error');
                      }
             });
        }
        /**
         * 获取服务详细信息
         */
        function getSerivceVO(serviceCode){
        	var url = '<cui:webRoot/>/soa/SoaServlet/queryServiceVOByCode?operType=queryServiceVOByCode&serviceCode='+serviceCode+'&timeStamp='+ new Date().getTime();
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
        
		window.onload = function(){
		    getSerivceVO("${param.code}");
		}
	</script>
</body>
</html>