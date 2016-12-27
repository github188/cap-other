<%
/**********************************************************************
* ����������ͨ�Բ���
* 2015-07-23 ŷ���� �½�
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ taglib uri="http://www.szcomtop.com/soa/cui" prefix="cui"%>
<!doctype html>
<html>
<head>
	<title>��������ӿڲ���</title>
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
			<span uitype="button" id="testWsdl" label="����"  on_click="testWsdlConnectivity"></span>
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
				<td class="td_label">WSDL��ַ��</td>
	            <td><span uitype="input" id="wsdlAddr" name="wsdlAddr"  width="675" databind="oldClientData.wsdlAddr" ></span><br/>
	            <span uitype="button" id="testWsdl" label="���»�ȡ������"  on_click="getWsdlReqFormat"></span>
	            <span uitype="button" id="saveReqMsgId" label="��ʱ����������"  on_click="saveReqMsg"></span>
	            </td>           
	        </tr>
	         <tr>
	            <td class="td_label">�����ģ�</td>
	            <td><span uitype="Textarea" id="reqMsg" width="675" databind="oldClientData.reqMsg" height="160px" ></span></td>	
	        </tr>
	         <tr>
	            <td class="td_label">��Ӧ���ģ�</td>
	            <td><span uitype="Textarea" id="respMsg" width="675" databind="oldClientData.respMsg" height="160px" ></span></td>	
	        </tr>
		</table>
	</div>
</div>
<script type="text/javascript">
     var oldClientData={wsdlAddr:"${param.wsdl}",code:"${param.code}"};
        /**
         * ������������
         */
        function testWsdlConnectivity(){
        	var wsdlAddr = cui('#wsdlAddr').getValue();
        	var reqMsg = cui('#reqMsg').getValue();
            cui('#testWsdl').disable(true);
        	cui('#respMsg').setValue("����ִ������...");
        	var url = '<cui:webRoot/>/soa/SoaServlet/doRequestWS?operType=doRequestWS&reqAddr='+wsdlAddr+'&timeStamp='+ new Date().getTime();
        	//����ajax�����ύ
            $.ajax({
                 type: "POST",
                 url: url,
                 contentType: "application/x-www-form-urlencoded; charset=UTF-8", 
                 beforeSend: function(XMLHttpRequest){
                 	XMLHttpRequest.setRequestHeader("RequestType", "ajax");
                 },
                 data:{'reqMsg':reqMsg},
                 cache:false,
                 success: function(data,status){
            	        cui('#respMsg').setValue(data);
                    	cui('#testWsdl').disable(false);
                  },
                  error: function(msg, textStatus, errorThrown) {
                      cui('#respMsg').setValue(msg+"�������쳣���޷����в��ԣ�"+errorThrown);
                      cui('#testWsdl').disable(false);
                  }
             });
        }
        /**
         * ��ȡ�����ĸ�ʽ
         */
        function getWsdlReqFormat(){
        	var wsdlAddr = cui('#wsdlAddr').getValue();
        	var	reqAddr=wsdlAddr.split("/soa/cxf")[0];
        	cui('#reqMsg').setValue("��ȡ���ĸ�ʽ...");
        	var url = '<cui:webRoot/>/soa/SoaServlet/getWsdlReqFormat?operType=getWsdlReqFormat&reqAddr='+reqAddr+'&code='+oldClientData.code+'&timeStamp='+ new Date().getTime();
            //����ajax�����ύ
            $.ajax({
                 type: "GET",
                 url: url,
                 cache:false,
                 success: function(data,status){
            	        cui('#reqMsg').setValue(data);
                  },
                  error: function(msg) {
                      cui('#reqMsg').setValue("�޷���ȡ�����ĸ�ʽ");
                  }
             });
        }
        /**
         * ������������������
         */
        function saveReqMsg(){
        	var reqMsg = cui('#reqMsg').getValue();
        	var code = oldClientData.code;
        	var url = '<cui:webRoot/>/soa/SoaServlet/saveReqMsg?operType=saveReqMsg&timeStamp='+ new Date().getTime();
        	var dataParams={'code':code,'reqMsg':reqMsg};
        	cui('#saveReqMsgId').disable(true);
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
                	 cui('#saveReqMsgId').disable(false);
            	      cui.alert("<font color='red'>����ɹ�,��������Ĳ���ʱ����󣬿����»�ȡԭʼ���ġ�</font>");
            	      
                  },
                 error: function (msg) {
                	 cui('#saveReqMsgId').disable(false);
                	 cui.alert("<font color='red'>����ʧ�ܡ�</font>");
                      }
             });
        }
		window.onload = function(){
		    //ɨ��
		    comtop.UI.scan();
		    //�������ݿ��л�ȡ���ģ�Ϊ�����Ի�ȡԭʼ����
		    getWsdlReqFormat();
		}
	</script>
</body>
</html>