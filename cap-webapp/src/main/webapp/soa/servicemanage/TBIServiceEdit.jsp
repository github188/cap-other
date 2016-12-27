<%
/**********************************************************************
* 第三方应用/客户端数据
* 2014-10-11 李小强 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ taglib uri="http://www.szcomtop.com/soa/cui" prefix="cui"%>
<!doctype html>
<html>
<head>
	<title>第三方应用/客户端数据管理编辑页面</title>
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
				<col width="80%" />
				<col width="2%" />
			</colgroup>
			<tr>
				<td class="td_label">南网服务名称：</td>
				<td><span uitype="input" name="serviceName" id="serviceName" width="440px" databind="oldData.serviceName" maxlength="50"></span></td>
			</tr>
	        <tr>
				<td class="td_label">南网服务编码：</td>
	            <td><span uitype="input" id="code" name="code"  width="440px" databind="oldData.code" readonly="true"></span></td>           
	        </tr>
	        <tr>
				<td class="td_label">服务元素(SID)：</td>
	            <td><span uitype="input" id="methodCode" name="methodCode"  width="440px" databind="oldData.methodCode" readonly="true"></span></td>           
	        </tr>
	        <tr>
				<td class="td_label">内部服务类：</td>
	            <td><span uitype="input" id="serviceAddress" name="serviceAddress"  width="440px" databind="oldData.serviceAddress" readonly="true"></span></td>           
	        </tr>
	        <tr>         
	            <td class="td_label">南网服务类：</td>
	            <td><span uitype="input" id="wsClassAddress" name="wsClassAddress" width="440px" databind="oldData.wsClassAddress" readonly="true"></span></td>
	        </tr>
	        <tr>         
	            <td class="td_label">服务认证类：</td>
	            <td><span uitype="input" id="wsAuthenClass" name="wsAuthenClass" width="440px" databind="oldData.wsAuthenClass"></span></td>
	        </tr>
			<tr>
				<td class="td_label">服务状态：</td>
	            <td><span uitype="SinglePullDown" id="flag" name="flag" value_field="id" label_field="label"  databind="oldData.flag" datasource="initTypeData" readonly="true"></span></td>
			</tr>
	         <tr>
	            <td class="td_label">服务描述：</td>
	            <td><span uitype="Textarea" id="serviceDesc" width="440px" databind="oldData.serviceDesc" height="85px" maxlength="100"></span></td>	
	        </tr>
		</table>
	</div>
</div>
<script type="text/javascript">
var sysCode = "${param.sysCode}";
var pageNo="${param.pageNo}";
     var data = [];
     var oldData={};
        /**
         * 保存南网服务
         */
        function save(){
        	var serviceName = cui('#serviceName').getValue();
        	var code = cui('#code').getValue();
        	var wsAuthenClass = cui('#wsAuthenClass').getValue();
        	var flag = cui('#flag').getValue();
         	var serviceDesc = cui('#serviceDesc').getValue();
        	var url = '<cui:webRoot/>/soa/SoaServlet/addSaveTBIService?operType=addSaveTBIService&timeStamp='+ new Date().getTime();
        	var dataParams={'code':code,'wsAuthenClass':wsAuthenClass,'serviceName':serviceName,'flag':flag,'serviceDesc':serviceDesc};
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
            	        window.parent.location.href='<cui:webRoot/>/soa/servicemanage/TBIServiceList.jsp?sysCode='+sysCode+'&pageNo='+pageNo;
                  },
                 error: function (msg) {
                	 window.parent.cui.message('保存失败。', 'error');
                      }
             });
        }
		window.onload = function(){
			 getWebServiceVO();
		    
		}	
        /**
         * 查询南网服务
         */
        function getWebServiceVO(){
         	var methodCode ='${param.methodCode}';
        	var url = '<cui:webRoot/>/soa/SoaServlet/getWebserviceBySID?operType=getWebserviceBySID&methodCode='+methodCode+'&timeStamp='+ new Date().getTime();
            //采用ajax请求提交
            $.ajax({
                 type: "GET",
                 url: url,
                 success: function(data,status){
            	        oldData= jQuery.parseJSON(data);
            		    //扫描
            		    comtop.UI.scan();
                  },
                 error: function (msg) {
                	 window.parent.cui.message('查询失败。', 'error');
                      }
             });
        }
	    /**
	     * 职位pulldown数据初始化
	     * @param obj {Object} pulldown实例对象
	     */
	    function initTypeData(obj){
	        var data = [
	            {id:'1',label:'运行中'},
	            {id:'0',label:'停用'}
	        ];
	        obj.setDatasource(data);
	    }
			
	</script>
</body>
</html>