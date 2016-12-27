<%
/**********************************************************************
* �����������
* 2015-07-23 ŷ���� �½�
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ taglib uri="http://www.szcomtop.com/soa/cui" prefix="cui"%>
<!doctype html>
<html>
<head>
	<title>�����������</title>
	<cui:link href="/soa/top/component/ui/cui/themes/default/css/comtop.ui.min.css"/>
    <cui:link href="/soa/css/soa.css"/>
    <cui:script src="/soa/top/component/ui/cui/js/comtop.ui.min.js"/>
    <cui:script src="/soa/js/jquery.min.js"/>
    <cui:script src="/soa/js/soa.common.js"/>
</head>
     <style type="text/css">
        html{
            padding-top:35px;  /*�ϲ�����Ϊ50px*/
            -webkit-box-sizing: border-box;
            -moz-box-sizing: border-box;
            box-sizing: border-box;
            overflow:hidden;
        }
        html,body{
            margin:0;
            height: 100%;
            width:100%;
        }
      .top{
            width:100%;
            height:38px;  /*�߶Ⱥ�padding����һ��*/
            margin-top: -35px; /*ֵ��padding����һ��*/                     
            overflow: auto;
            position:relative;
      }
     .main{
          height: 100%;
            width:100%;
            overflow: auto;
     }
    </style>
<body>
<div class="main">
 <div id="editDiv"  class="top_content_wrap cui_ext_textmode" >
   <table class="form_table" style="table-layout:fixed;width: 100%;">
			<colgroup>
				<col width="12%" />
				<col width="87%" />
                 <col width="1%" />
			</colgroup>
	        <tr>
				<td class="td_label">�����ʶ��</td>
	            <td><span uitype="input" id="methodCode" name="methodCode"  width="658px" databind="oldData.methodCode" readonly="true"></span></td>           
	        </tr>
	        <tr>
				<td class="td_label">����ϵͳ��</td>
	            <td><span uitype="input" id="sysName" name="sysName"  width="658px" databind="oldData.sysName" readonly="true"></span></td>           
	        </tr>
	        <tr>
				<td class="td_label">������IP��</td>
	            <td><span uitype="input" id="appIp" name="appIp"  width="658px" databind="oldData.appIp" readonly="true"></span></td>           
	        </tr>
	         <tr>
	            <td class="td_label">�������˿ڣ�</td>
	            <td><span uitype="input" id="appPort" name="appPort"  width="658px" databind="oldData.appPort" readonly="true"></span></td>   
	        </tr>
	        <tr>
				<td class="td_label">�ͻ���IP��</td>
	            <td><span uitype="input" id="clientIp" name="clientIp"  width="658px" databind="oldData.clientIp" readonly="true"></span></td>           
	        </tr>
	         <tr>
	            <td class="td_label">�ͻ��˶˿ڣ�</td>
	            <td><span uitype="input" id="clientPort" name="clientPort"  width="658px" databind="oldData.clientPort" readonly="true"></span></td>   
	        </tr>
	         <tr>
	            <td class="td_label">������Ӧʱ�䣺</td>
	            <td><span uitype="input" id="invokeTime" name="invokeTime"  width="658px" databind="oldData.invokeTime" readonly="true" textmode='false'></span></td>   
	        </tr>
	         <tr>
	            <td class="td_label">״̬��</td>
	            <td><span id="resultStatus" width="658px" uitype="input" readonly="true"></span></td>   
	        </tr>
	         <tr>
	            <td class="td_label">�����ģ�</td>
	            <td><span uitype="Textarea" id="inputArgs" width="658px" databind="oldData.inputArgs" height="160px"></span></td>	
	        </tr>
	         <tr>
	            <td class="td_label">��Ӧ���ģ�</td>
	            <td><span uitype="Textarea" id="invokeResult" width="658px" databind="oldData.invokeResult" height="160px"></span></td>	
	        </tr>
		</table>
</div>
<script type="text/javascript">
     var oldData={};
     var logId="${param.logId}";
        /**
         * ��ȡ������ϸ��Ϣ
         */
        function queryServiceCallDetail(){
        	var url = '<cui:webRoot/>/soa/SoaServlet/queryServiceCallDetail?operType=queryServiceCallDetail&logId='+logId+'&timeStamp='+ new Date().getTime();
        	//����ajax�����ύ
            $.ajax({
                 type: "GET",
                 url: url,
                 cache:false,
                 success: function(data,status){
                	 oldData = jQuery.parseJSON(data);
         		    //ɨ��
         		    comtop.UI.scan();
         		    var statusName='';
         		    if(oldData.resultStatus==0){
         		    	statusName='����ʧ��';
         		    }else if(oldData.resultStatus==1){
         		    	statusName='���óɹ�';
         		    }
         		    cui('#resultStatus').setValue(statusName); 
                  },
                  error: function(msg, textStatus, errorThrown) {
                	  
                  }
             });
        }
		window.onload = function(){
		    queryServiceCallDetail();
		}
		
	</script>
</body>
</html>