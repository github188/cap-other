<%
/**********************************************************************
* ������Ӧ��/�ͻ�������
* 2014-10-11 ��Сǿ �½�
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ taglib uri="http://www.szcomtop.com/soa/cui" prefix="cui"%>
<!DOCTYPE html>
<html>
<head>
	<title>������Ӧ��/�ͻ������ݹ���༭ҳ��</title>
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
				<col width="15%" />
				<col width="35%" />
				<col width="15%" />
				<col width="35%" />
			</colgroup>
			<tr>
				<td class="td_label">�ͻ������ƣ�</td>
				<td><span uitype="input" name="name" id="name" width="160px" databind="oldClientData.name" maxlength="40" ></span></td>
				
				<td class="td_label">�ͻ������ͣ�</td>
	            <td><span id="type" width="100px"  uitype="SinglePullDown" name="type" value_field="id" label_field="label"  databind="oldClientData.type" datasource="initTypeData" validate="���Ͳ���Ϊ��"></span></td>
			</tr>
	        <tr>
				<td class="td_label">ip��ַ��</td>
	            <td><span uitype="input" id="ip1" name="ip1" maxlength="16" width="160px" databind="oldClientData.ip1" validate="ipValid"></span></td>           
	            <td class="td_label">�˿ڣ�</td>
	            <td><span uitype="input" id="prot" name="prot" maxlength="5" width="100px" databind="oldClientData.prot" validate="portValid"></span></td>
	        </tr>
	        
	         <tr>
	            <td class="td_label">������</td>
	            <td colspan="3"><span uitype="Textarea" id="memo" width="82%" databind="oldClientData.memo" height="50px" maxlength="100"></span></td>	
	        </tr>
	         <tr>
	           <td colspan="4" align="left" style="font-size: 12px">
		         <span style="color:green;"> &nbsp; &nbsp;�ͻ������ͣ�<br/>
		         &nbsp; &nbsp; &nbsp;������-����Ҫ������Ȩ���ɷ������з���<br/>
		         &nbsp; &nbsp; &nbsp;��ͨ�ͻ���-�����ÿɷ��ʷ���Χ��<br/>
		         &nbsp; &nbsp; &nbsp;������-�����Է����κη���<br/></span></td>
	         </tr>
		</table>
	</div>
</div>
<script type="text/javascript">
     var data = [];
     var oldClientData={name:"${param.name}",type:"${param.type}","ip1":"${param.ip1}",prot:"${param.prot}",memo:"${param.memo}"};
     var ipValid=[{type:'format',rule:{pattern:'(\\d+)\\.(\\d+)\\.(\\d+)\\.(\\d+)', 'm':'IP���벻�Ϸ�'}},{type:'required',rule: {m:'IP����Ϊ��'}}];
     var portValid=[{ 'type':'format','rule':{'pattern':'^[1-9]$|(^[1-9][0-9]$)|(^[1-9][0-9][0-9]$)|(^[1-9][0-9][0-9][0-9]$)|(^[1-9][0-9][0-9][0-9][0-9]$)', 'm':'�˿����벻�Ϸ�'}},{type:'required',rule: {m:'�˿ڲ���Ϊ��'}}];
     var clientId = "${param.clientId}";
        /**
         * ����ҵ��ϵͳ
         */
        function save(){
            cui('#save').disable(false);
        	var name = cui('#name').getValue();
        	var ip1 = cui('#ip1').getValue();
        	var type = cui('#type').getValue();
        	var prot = cui('#prot').getValue();
         	var memo = cui('#memo').getValue();
            var validAllElement = window.validater.validAllElement();
            if (!validAllElement[2]){
                return;
            }
        	var url = '<cui:webRoot/>/soa/SoaServlet/addSaveClient?operType=addSaveClient&timeStamp='+ new Date().getTime();
        	var dataParams={'clientId':clientId,'name':name,'ip1':ip1,'type':type,'prot':prot,'memo':memo};
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
            	        cui('#save').disable(true);
            	        window.parent.cui.message('����ɹ���', 'success');
            			window.parent.location.href='<cui:webRoot/>/soa/servicemanage/ClientInfoMain.jsp';
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

	    /**
	     * ְλpulldown���ݳ�ʼ��
	     * @param obj {Object} pulldownʵ������
	     */
	    function initTypeData(obj){
	        var data;
	        //TODO ͨ��dwr����ajax��ȡ���ݣ�Ȼ��ִ�����ݳ�ʼ��
	        //ģ������
	        data = [
	            {id:'1',label:'������'},
	            {id:'2',label:'��ͨ�ͻ���'},
	            {id:'3',label:'������'}
	        ];
	        obj.setDatasource(data);
	    }
			
	</script>
</body>
</html>