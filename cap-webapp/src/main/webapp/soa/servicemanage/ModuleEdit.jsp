<%
  /**********************************************************************
	* �༭ҵ��ϵͳ
	* 2014-2-19  Ԭ���� �½�
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ taglib uri="http://www.szcomtop.com/soa/cui" prefix="cui"%>
<!DOCTYPE html>
<html>
<head>
	<title>ҵ��ϵͳ�༭ҳ��</title>
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
<div uitype="Borderlayout"  id="body" is_root="true" style="width: 50%">	
	<div class="top_header_wrap" style="padding-top:5px;width: 56%">
		<div class="thw_title">
			<font id = "pageTittle" class="fontTitle"></font> 
		</div>
		<div class="thw_operate">
			<span uitype="button" id="save" label="����"  on_click="save" ></span>
		</div>
	</div>
	<div class="cui_ext_textmode" style="padding-top:15px;width: 100%">
		<table class="form_table" style="table-layout:fixed;">
			<colgroup>
				<col width="20%" />
				<col width="80%" />
			</colgroup>
			<tr>
				<td class="td_label">�ϼ����ƣ�</td>
				<td>
				<span uitype="input" name="parentName" id="parentName" databind="data.parentNodeName" width="290px" readonly="true"></span>
				</td>
			</tr>
	        <tr>
	            <td class="td_label"> ϵͳ���ƣ�</td>
	            <td>
	               <span uitype="input" id="sysName" name="sysName" databind="data.sysName" maxlength="40" width="290px"
	                validate="validateModuleName">
	                </span>
	            </td>
	        	
	        </tr>
		</table>
	</div>
</div>
<script type="text/javascript">
     var parentNodeName = "${param.parentNodeName}";
     var data = {parentNodeName:parentNodeName};
     
        /**
         * ����ҵ��ϵͳ
         */
        function save(){
        	var systemName = cui('#sysName').getValue();
        	var url = '<cui:webRoot/>/soa/SoaServlet/addBussSystem?operType=addBussSystem&timeStamp='+ new Date().getTime();
        	var dataParams={'systemName':systemName};
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
            	        var treeData = jQuery.parseJSON(data);
            	        if (!checkStrEmty(data)){
            	        	window.parent.editRefreshTree(treeData.code);
            	        }
            			cui.message('����ɹ���', 'success');
                  },
                 error: function (msg) {
        		         cui.message('����ʧ�ܡ�', 'error');
                      }
             });
        }
		
		window.onload = function(){
		    //ɨ��
		    comtop.UI.scan();
		    
		}
	</script>
</body>
</html>