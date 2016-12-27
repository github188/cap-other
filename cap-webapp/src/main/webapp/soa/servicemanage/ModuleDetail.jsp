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
	<title>ҵ��ϵͳ����ҳ��</title>
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
		<span uitype="button" id="new_sub" label="" on_click="insertSubSys"></span>
		<span uitype="button" id="save" label="����"  on_click="save" ></span>
		<span uitype="button" id="delete" label="ɾ��"  on_click="deleteBussSystem" ></span>
		</div>
	</div>
	<div class="cui_ext_textmode" style="padding-top:15px;width: 100%">
		<table class="form_table" style="table-layout:fixed;">
			<colgroup>
				<col width="15%" />
				<col width="85%" />
			</colgroup>
			<tr style = "display:none">
				<td>
					<span id="moduleTypeGroup" uitype="RadioGroup" name="moduleType" databind="data.moduleType"
			      readonly="true"></span>
				</td>
			</tr>
			<tr>
				<td class="td_label">�ϼ����ƣ�</td>
				<td>
				<span uitype="input" name="parentNodeName" id="parentNodeName" databind="data.parentNodeName" width="290px" readonly="true"></span>
				</td>
			</tr>
	        <tr>
	            <td class="td_label"> ϵͳ���ƣ�</td>
	            <td>
	               <span uitype="input" id="sysName" name="sysName" databind="data.sysName" maxlength="36" width="290px"
	                validate="validateModuleName">
	                </span>
	            </td>
	        	
	        </tr>
	        <tr>
	        	<td class="td_label"> ϵͳ���룺</td>
				<td>
					<span uitype="input" id="sysCode" name="sysCode" databind="data.sysCode" maxlength="28" width="290px"
	               validate="validateModuleCode" readonly="true"></span>
				</td>
	        </tr>
		</table>
	</div>
</div>
<script type="text/javascript">
        var sysCode = "${param.sysCode}";
		var sysName = "${param.sysName}";
		var parentNodeName = "${param.parentNodeName}";
		var type = "${param.moduleType}";

		var data = {sysCode:sysCode, sysName:sysName, parentNodeName:parentNodeName};

        /**
         * ����ҵ��ϵͳ����
         */
        function save(){
            var editSysName = cui('#sysName').getValue();
        	var url = '<cui:webRoot/>/soa/SoaServlet/editSysName?operType=editSysName&sysName='+editSysName+'&sysCode='+sysCode+'&timeStamp='+ new Date().getTime();
            //����ajax�����ύ
            $.ajax({
                 type: "GET",
                 url: url,
                 success: function(data,status){
            			window.parent.initData(window.parent.cui('#moduleTree'));
            			cui.message('����ɹ���', 'success');
                  },
                 error: function (msg) {
        		         cui.message('����ʧ�ܡ�', 'error');
                      }
             });
        }

        /**
         * ɾ��ҵ��ϵͳ
         */
        function deleteBussSystem(){
        	var url = '<cui:webRoot/>/soa/SoaServlet/deleteBussSystem?operType=deleteBussSystem&sysCode='+sysCode+'&timeStamp='+ new Date().getTime();
            //����ajax�����ύ
            $.ajax({
                 type: "GET",
                 url: url,
                 success: function(data,status){
            			//ˢ��Tree��չʾ���ڵ�
            	        window.parent.editRefreshTree('root');
            	        //չʾ�ڵ���Ϣ
            	        window.location.href='<cui:webRoot/>/soa/servicemanage/ModuleDetail.jsp?&sysCode=root&sysName=����ϵͳ&moduleType=0';
            			cui.message('ɾ���ɹ���', 'success');
                  },
                 error: function (msg) {
                	  cui.message('ɾ��ʧ�ܡ�', 'error');
                      }
             });
        }

        /**
         * �л�չʾbutton���ƣ������¼�ϵͳ�������¼�Ӧ�ã�
         */
    	function insertSubSys(){
    		if (type == 0){
    			//�����¼�ϵͳ
    			window.parent.cui('#body').setContentURL("center","<cui:webRoot/>/soa/servicemanage/ModuleEdit.jsp?parentNodeName="+sysName);
		    }else{
		    	//�����¼�Ӧ��
		    	window.parent.cui('#body').setContentURL("center","<cui:webRoot/>/soa/servicemanage/DirEdit.jsp?parentNodeID="+sysCode+"&parentNodeName="+sysName+"&moduleType=1");
		    }
    		 
    	}

		window.onload = function(){
		    //ɨ��
		    comtop.UI.scan();
		    if (type == 0){
		    	cui('#new_sub').setLabel("�����¼�ϵͳ");
		    }else{
		    	cui('#new_sub').setLabel("�����¼�Ӧ��");
		    }

		    //���ڵ㲻����ɾ�����޸�
		    if (sysCode=='root'){
		    	cui('#save').disable(true);
		    	cui('#delete').disable(true);
		    	cui('#sysName').setReadonly(true);
		    }
			    
		}
	</script>
</body>
</html>