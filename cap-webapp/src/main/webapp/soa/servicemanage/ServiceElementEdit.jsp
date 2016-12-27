<%
/**********************************************************************
* ����Ԫ�ر༭
* 2015-08-06 ŷ���� �½�
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ taglib uri="http://www.szcomtop.com/soa/cui" prefix="cui"%>
<!doctype html>
<html>
<head>
	<title>����Ԫ�ر༭</title>
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
			<span uitype="button" id="save" label="����"  on_click="save" ></span>
		</div>
	</div>
	<div class="cui_ext_textmode" >
		<table class="form_table" style="table-layout:fixed;">
			<colgroup>
				<col width="22%" />
				<col width="75%" />
				<col width="3%" />
			</colgroup>
	        <tr>
				<td class="td_label">����Ԫ�أ�</td>
	            <td><span uitype="input" id="code" name="code"  width="320px" databind="oldData.code" readonly="true"></span></td>           
	        </tr>
			<tr>
				<td class="td_label">����Ԫ����������</td>
				<td><span uitype="input" name="cnName" id="cnName" width="320px" databind="oldData.cnName" maxlength="50" ></span></td>
			</tr>
			<tr>
				<td class="td_label">����������</td>
	            <td><span uitype="input" id="alias" name="alias" width="320px" databind="oldData.alias" readonly="true"></span></td>
			</tr>
			<tr>
				<td class="td_label">�������ƣ�</td>
	            <td><span uitype="input" id="name" name="name" width="320px" databind="oldData.name" readonly="true"></span></td>
			</tr>
	        <tr>         
	            <td class="td_label">����ǩ����</td>
	            <td><span uitype="Textarea" id=methodDesc name="methodDesc" width="320px" databind="oldData.methodDesc" height="110px" readonly="true"></span></td>
	        </tr>
		</table>
	</div>
</div>
<script type="text/javascript">
     var sysCode = "${param.sysCode}";
     var serviceCode = "${param.serviceCode}";
     var oldData;
        /**
         * �������
         */
        function save(){
        	var code = cui('#code').getValue();
        	var cnName = cui('#cnName').getValue();
        	var url = '<cui:webRoot/>/soa/SoaServlet/updateMethod?operType=updateMethod&timeStamp='+ new Date().getTime();
        	var dataParams={'code':code,'cnName':cnName};
	        cui('#save').disable(true);
        	//����ajax�����ύ
            $.ajax({
                 type: "POST",
                 url: url,
                 contentType:"application/x-www-form-urlencoded; charset=UTF-8",
                 data:dataParams,
                 beforeSend: function(XMLHttpRequest){
                 	XMLHttpRequest.setRequestHeader("RequestType", "ajax");
                  }, 
                 success: function(data,status){
            	        window.parent.cui.message('����ɹ���', 'success');
            	        window.parent.location.href='<cui:webRoot/>/soa/servicemanage/ServiceElementInfo.jsp?sysCode='+sysCode+'&code='+serviceCode+'&timeStamp='+ new Date().getTime();
                  },
                 error: function (msg) {
                	 window.parent.cui.message('����ʧ�ܡ�', 'error');
                      }
             });
        }
		window.onload = function(){
			var alias="${param.alias}";
			var name="${param.name}";
			var cnName="${param.cnName}";
			var methodDesc="${param.methodDesc}";
			if(checkStrEmty(cnName)){
				cnName="";
			}
			if(checkStrEmty(alias)){
				alias="";
			}
			cnName= decodeURIComponent(decodeURIComponent(cnName));
			oldData={code:"${param.methodCode}",alias:alias,name:name,cnName:cnName,methodDesc:methodDesc};
		    comtop.UI.scan();
		    
		}
	</script>
</body>
</html>