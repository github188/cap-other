<%
/**********************************************************************
* ������Ӧ��/�ͻ�������
* 2014-10-11 ��Сǿ �½�
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ taglib uri="http://www.szcomtop.com/soa/cui" prefix="cui"%>
<!doctype html>
<html>
<head>
	<title>WS������ϸ�༭ҳ��</title>
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
	</div>
	<div class="cui_ext_textmode" >
		<table class="form_table" style="table-layout:fixed;">
			<colgroup>
				<col width="18%" />
				<col width="80%" />
				<col width="2%" />
			</colgroup>
			<tr>
				<td class="td_label">�����������ƣ�</td>
				<td><span uitype="input" name="serviceName" id="serviceName" width="440px" databind="oldData.serviceName" maxlength="40" readonly="true"></span></td>
			</tr>
	        <tr>
				<td class="td_label">����������룺</td>
	            <td><span uitype="input" id="code" name="code"  width="440px" databind="oldData.code" readonly="true"></span></td>           
	        </tr>
	        <tr>
				<td class="td_label">����Ԫ��(SID)��</td>
	            <td><span uitype="input" id="methodCode" name="methodCode"  width="440px" databind="oldData.methodCode" readonly="true"></span></td>           
	        </tr>
	        <tr>         
	            <td class="td_label">���������ࣺ</td>
	            <td><span uitype="input" id="wsClassAddress" name="wsClassAddress" width="440px" databind="oldData.wsClassAddress" readonly="true"></span></td>
	        </tr>
	        <tr>         
	            <td class="td_label">������֤�ࣺ</td>
	            <td><span uitype="input" id="wsAuthenClass" name="wsAuthenClass" width="440px" databind="oldData.wsAuthenClass" readonly="true"></span></td>
	        </tr>
			<tr>
				<td class="td_label">����״̬��</td>
	            <td><span id="flage" uitype="SinglePullDown" name="flag" value_field="id" label_field="label"  databind="oldData.flag" datasource="initTypeData" readonly="true"></span></td>
			</tr>
	         <tr>
	            <td class="td_label">����������</td>
	            <td><span uitype="Textarea" id="serviceDesc" width="440px" databind="oldData.serviceDesc" height="85px" readonly="true"></span></td>	
	        </tr>
		</table>
	</div>
</div>
<script type="text/javascript">
     var data = [];
     var oldData={};
        /**
         * ��ѯ��������
         */
        function getWebServiceVO(){
         	var methodCode ='${param.methodCode}';
        	var url = '<cui:webRoot/>/soa/SoaServlet/getWebserviceBySID?operType=getWebserviceBySID&methodCode='+methodCode+'&timeStamp='+ new Date().getTime();
            //����ajax�����ύ
            $.ajax({
                 type: "GET",
                 url: url,
                 success: function(data,status){
            	        oldData= jQuery.parseJSON(data);
            		    //ɨ��
            		    comtop.UI.scan();
                  },
                 error: function (msg) {
                	 window.parent.cui.message('����ʧ�ܡ�', 'error');
                      }
             });
        }
		window.onload = function(){
			getWebServiceVO();
		}	

	    /**
	     * ְλpulldown���ݳ�ʼ��
	     * @param obj {Object} pulldownʵ������
	     */
	    function initTypeData(obj){
	        var data = [
	            {id:'1',label:'������'},
	            {id:'0',label:'ͣ��'}
	        ];
	        obj.setDatasource(data);
	    }
			
	</script>
</body>
</html>