<%
  /**********************************************************************
	* ҵ��ϵͳ��Ӧ�÷���������
  **********************************************************************/
%>
<%@page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@taglib uri="http://www.szcomtop.com/soa/cui" prefix="cui"%>
<% 
   pageContext.setAttribute("cuiWebRoot",request.getContextPath());
%>
<!DOCTYPE HTML>
<html>
<head>
    <title>ҵ��ϵͳ��Ӧ�÷���������</title>
    <cui:link href="/soa/top/component/ui/cui/themes/default/css/comtop.ui.min.css"/>
    <cui:link href="/soa/top/component/ui/editGridEX/themes/default/css/editGridEX.css"/>
    <cui:link href="/soa/css/soa.css"/>
    <cui:script src="/soa/top/component/ui/cui/js/comtop.ui.min.js"/>
    <cui:script src="/soa/top/component/ui/editGridEX/js/comtop.ui.editGridEX.js" cuiTemplate="gridEX.html"/>
    <cui:script src="/soa/js/jquery.min.js"/>
    <cui:script src="/soa/js/soa.common.js"/>
    <style type="text/css">
        img{
          margin-left:5px;
        }
    </style>
</head>
<body class="body_layout">
<cui:borderlayout id="body" is_root="true">
   <cui:bpanel id="topMain" position="top" gap="5px 5px 5px 0px" height="132" >
        <table style="margin-left: 5px;">
           <tr class="trTable">
             <td class="tdTable">ҵ��ϵͳ���ƣ�</td>
             <td class="tdSpan">
                <span id="SystemName" uitype="Input"  readonly="true" width="430px" databind="bussSytsemData.name"></span>
             </td>
           </tr>
           <tr class="trTable">
                <td class="tdTable"> ��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;�ͣ�</td>
                <td class="tdSpan">
               		<input type="checkbox" name="tcp" id="tcp" value="1">&nbsp;TCP/IP(<font color="red" size="1">�貿��SOA��EJBģ��</font>)&nbsp;&nbsp;</input>
               		<input type="checkbox" name="http" id="http"  value="0" onClick="changeHttp()">&nbsp;HTTP(<font color="red" size="1">�磺��ͨHTTP��ַ��F5����Apache�����</font>)&nbsp;&nbsp;&nbsp;&nbsp;</input>
            	</td>
            </tr>
            <tr class="trTable">
               <td class="tdTable">&nbsp;</td>
               <td class="tdSpan">
	               <div id="httpTrUrl" style="display:none">
	                   HTTP���ʵ�ַ��
	                   <span id="httpURL" uitype="Input"  tip="����������ַ,����:http://ip:port/appName"  readonly="false" maxlength="80" emptytext="http://127.0.0.1:7001/appName" databind="bussSytsemData.httpUrl"
	                   		  validate="[{ 'type':'format','rule':{'pattern':'http://.?', 'm':'�����ַ���벻�Ϸ�'}}]" width="350">
	                   </span>
	                    <span><img height="20px" width="16px" title="���Դ����ַ��ͨ��" src="<cui:webRoot/>/soa/css/img/check.jpg" onClick="checkProxyServerConnectivity();" style="cursor: hand"/> </span>
	               </div>            
              </td>
            </tr>
        </table>
	</cui:bpanel>
	<cui:bpanel position="center" id="centerMain" gap="0px 5px 5px 0px" >
	    <div style="margin-left: 5px;padding-top: 5px">
		    <table id="cui_grid_list" name="cui_grid_list" uitype="GridEX" class="cui_gridEX_list" selectrows="no" colhidden="false" gridwidth="640px" gridheight="400px" datasource="initGridData" primarykey="id" loadcomplate_callback="initEdit" pagination="false">    
                   <thead>         
                    <tr>           
                      <th bindName="id" style="width:10%;">���</th>           
                      <th renderStyle="text-align: center" bindName="ip" style="width:40%;">Ӧ�÷�����IP</th>
                      <th renderStyle="text-align: center" bindName="port" style="width:30%;">Ӧ�÷������˿�</th>
                      <th renderStyle="text-align: center" style="width:20%;" render="image" options="{'url': '<cui:webRoot/>/soa/css/img/delete.gif'}">����
                        <img src="<cui:webRoot/>/soa/css/img/add.bmp" onClick="append()" style="cursor: hand"/>
                      </th>          
                    </tr>    
                  </thead> 
             </table>
             <div style="margin-left: 590px;margin-top: 10px">
               <span id="saveId" uitype="Button" label="��&nbsp;&nbsp;��" on_click="doSaveConfirm"></span>
	   		</div>
	   </div>
	</cui:bpanel>
</cui:borderlayout>
 <script type="text/javascript">
 <!--
      var bussSytsemData={code:"${param.sysCode}",name:"${param.sysName}"};
      bussSytsemData.name =   decodeURIComponent(decodeURIComponent(bussSytsemData.name));
      var newBussSytsemData;
      var appServerListData = [];
      var systemCode=bussSytsemData.code;
       /**
        * ����soa����ҳ
        */
       function returnIndex(){
    	   parent.document.location.href="<cui:webRoot/>/soa/index.jsp";
       }
       //��������Ĵ����ַ��ֵ����ѡcheckBox��ֵ
       function selectCheckedBox(newData){
    	   newData.name=bussSytsemData.name;
    	   newData.code=bussSytsemData.code;
           cui(bussSytsemData).databind().setValue(newData);
           //�����ı����븴ѡ���״̬
           setCkeckedValue('http','#httpURL');
           if (newData.supperProtocol==8||newData.supperProtocol==16){
        	   document.getElementById('tcp').checked = true;
           }
           //У������ַ
           validProtocol();
       }

       //�ı�����ֵ,�����ı���ɱ༭�븴ѡ��ѡ��
       //�ı�����ֵ,�ı����û��븴ѡ���û�
       function setCkeckedValue(objChecked,objCheckedCui){
           if (cui(objCheckedCui).getValue() != null && cui(objCheckedCui).getValue() != ""){
               document.getElementById(objChecked).checked = true;
               document.getElementById("httpTrUrl").style.display='block';
           }else {
               document.getElementById(objChecked).checked = false;
               document.getElementById("httpTrUrl").style.display='none';
           }
       }

       function getChecked(paramValue){
           return document.getElementById(paramValue).checked;
       }

       function validProtocol(){
           var httpCkecked = document.getElementById("http").checked;
           //��http����ѡ�������Ӳ�Ϊ�յ�У��
           if (!httpCkecked){
               //��httpδ����ѡ,��ȡ��httpURL�ı����У��
               window.validater.disValid(cui('#httpURL'), true);
               cui('#httpURL').setValue("",true);
               cui('#httpURL').setEmptyText('http://127.0.0.1:7001/appName');
           }else {
               window.validater.disValid(cui('#httpURL'), false);
               window.validater.add('httpURL', 'required', {
                   m:'�����ַ����Ϊ�ա�'
                });
           } 
       }
       //ҵ��ϵͳ����ȷ��
       function doSaveConfirm(){
    	   cui.confirm("<font color='red' size='2'>1������ǰ��ȷ�������ַ��ͨ��������</br>2������ǰ��ȷ��Ӧ�÷�������ͨ��������</br>3�����ع����п��ܻ�Ӱ��SOA������ã�</br>4��Ԥ��10�����������һ��Ӧ�ýڵ㣻</br>5��Ϊ��֤�������ȶ������𷴸�������</font>", {
              title:'���漰���ظ�ҵ��ϵͳ����ע����Ϣ',
    		   buttons: [
                         {
                             name: 'ȷ��',
                             handler: function () {
                            	 //����&����
                            	 doSave(true,1);
                             }
                         },
                         {
                             name: ' ȡ��',
                             handler: function () {
                            	 //ֻ���治����
                            	// doSave(false,1);
                             }
                         }
                     ]
               
           });
       }
       //ҵ��ϵͳ���ݱ���
       function doSave(reloadType,tips){
           var tcpType ='';
           validProtocol();
           var systemName = cui('#SystemName').getValue();
           var httpURL = cui('#httpURL').getValue();
           var httpCkecked = document.getElementById("http").checked;
           var tcpCkecked = document.getElementById("tcp").checked;
           if (!httpCkecked && !tcpCkecked){
               cui.warn("����ѡ��һ���������͡�");
               return 1;
           }
           if(tcpCkecked){
        	   tcpType=8;
           }
           if (!httpCkecked){
               window.validater.disValid(cui('#httpURL'), true);
           }else {
               window.validater.disValid(cui('#httpURL'), false);
           }
           var validAllElement = window.validater.validAllElement();
           if (!validAllElement[2]){
               return;
           }
           
           var validData = editGrid.submit();
           var systemData = validData.data;
           if(!validData.valid)
           {
               return;
           }
           
           var strParam = "";
           if (systemData.length == 0&&tips==1){
               cui.warn("����дһ��Ӧ�÷�������Ϣ,�����ַ������Ч��");
           }
           for (var i = 0;i<systemData.length;i++){
               var serviceIp = systemData[i].ip;
               var servicePort = systemData[i].port;
               strParam += "serviceIp="+serviceIp+","+"servicePort="+servicePort+":";
           }
           
           var url = '<cui:webRoot/>/soa/SoaServlet/editBussSystem?operType=editBussSystem&timeStamp='+ new Date().getTime();
           var dataParams={'bussSystemCode':systemCode,'systemName':systemName,'tcpType':tcpType,'httpURL':httpURL,'strParam':strParam};
           $.ajax({
                type: "POST",
                url: url,
                contentType:"application/x-www-form-urlencoded; charset=UTF-8",
                data:dataParams,
                beforeSend: function(XMLHttpRequest){
                	XMLHttpRequest.setRequestHeader("RequestType", "ajax"); 
                 }, 
                success: function(data){
                    if (checkStrEmty(systemData)){
                    	cui('#cui_grid_list').setDatasource([]);
                   	    return;
                     }
                    //��������Ĵ����ַ��ֵ����ѡcheckBox��ֵ
                   // selectCheckedBox(jQuery.parseJSON(data));
                    cui('#cui_grid_list').setDatasource(systemData,systemData.length);
               		if(data){
               			 var resultData = jQuery.parseJSON(data);
               			 if(resultData.isLocalMode&&reloadType==true){
               				cui.message("����ɹ�,����ִ������");
                    	    var  isReLoadSys=resultData.isReLoadSys;
                    	 	reloadAll(bussSytsemData.code,isReLoadSys);
               			 }else{
               				 if(tips==1){
                   				 cui.success("����ɹ�����δ����ҵ��ϵͳ���ز�������ҵ��ϵͳ�µ�SOA������ܻ��޷��������á�");
               				 }

               			 }
               			}
                         },
                error: function (msg) {
                         cui.error(msg.result);
                         }
            });
       }

       /**
        * Grid������Ϻ����ɱ༭ģ��
        * @param obj
        */
       function initEdit(obj){
           editGrid.edit(obj);
       }

       /**
        * �����༭grid
        * @type {*}
        */
       var editGrid = cui().editGridEX({
           editMode: true,
           //�༭�����ģ��
           tmpl: [
               {
                   //�Զ����ɱ�ţ�autoNumber(��ʼ���),ÿ��׷��1���Զ����ֻ���ڱ�ţ�����Ϊ�����ύ
                   htmlElement: '#autoNumber(1)#'
               },
               {
                   uitype: 'Input',
                   validate:[{type:"required", rule:{m: "IP����Ϊ��"}},{type:"length", rule:{"max":20,"maxm": "���Ȳ��ܳ���20"}},{ type:"format",rule:{pattern:"(\\d+)\\.(\\d+)\\.(\\d+)\\.(\\d+)", m:"IP���벻�Ϸ�"}}],
                   datasource: initGridData,
                   bindname: 'ip'
                       
               },
               {
                   uitype: 'Input',
                   validate:[{type:"required", rule:{m: "�˿ڲ���Ϊ��"}},{type:"length", rule:{"max":6,"maxm": "���Ȳ��ܳ���6"}},{ type:"format",rule:{pattern:"^[1-9]$|(^[1-9][0-9]$)|(^[1-9][0-9][0-9]$)|(^[1-9][0-9][0-9][0-9]$)|(^[1-9][0-9][0-9][0-9][0-9]$)|(^[1-9][0-9][0-9][0-9][0-9][0-9]$)", m:"�˿����벻�Ϸ�"}}],
                   datasource: initGridData,
                   bindname: 'port'
               },
               {
                   //�Զ���DOM�ṹ��֧�����ɷ�CUI��������������
                   htmlElement: '<img title="ɾ��" src="<cui:webRoot/>/soa/css/img/delete.gif" onClick="removeData(this);" style="cursor: hand"/>&nbsp;<img height="20px" width="16px" title="������ͨ��" src="<cui:webRoot/>/soa/css/img/check.jpg" onClick="checkSystemConnectivity(this);" style="cursor: hand"/>&nbsp;<img height="20px" width="17px" title="���ط�����" src="<cui:webRoot/>/soa/css/img/loading.png" onClick="reloadServiceConfirm(this);" style="cursor: hand"/>'
               }
           ]
       });
        
        /**
         * ɾ��������
         * @param t
         */
        function removeData(t){
            editGrid.remove(t);
        }

        /**
         * �������ݣ�������ָ�������к�������
         */
        function addData(t){
            //��t��������µ�������
            editGrid.add(t);
        }

        /**
         * �����������У������ڱ���׷��
         */
        function append(){
             editGrid.add();
        }

       /**
        * ��ʼ��grid����
        */
       function initGridData(obj){
           if (systemCode){
               var url = '<cui:webRoot/>/soa/SoaServlet/queryBussSystem?operType=queryBussSystem&bussSystemCode='+systemCode+'&timeStamp='+ new Date().getTime();
                //����ajax������ض�Ӧ��ҵ��ϵͳ��ϸ��Ϣ
               $.ajax({
                    type: "GET",
                    url: url,
                    success: function(data,status){
                         newBussSytsemData = jQuery.parseJSON(data);
                         if (checkStrEmty(newBussSytsemData)){
                        	 obj.setDatasource([]);
                        	 return;
                             }
                         //��������Ĵ����ַ��ֵ����ѡcheckBox��ֵ
                         selectCheckedBox(newBussSytsemData);
                         var appServerListData = newBussSytsemData.appServerList;
                         if (checkStrEmty(appServerListData)){
                        	 obj.setDatasource([]);
                        	 return;
                             }
                         obj.setDatasource(appServerListData,appServerListData.length);
                    },
                    error: function (msg) {
                                 cui.message('����ҵ��ϵͳʧ�ܡ�', 'error');
                             }
                });
           }else{
               var dataList = [];
               obj.setDatasource(dataList,dataList.length);
           }
       }

       //����http��input����Ƿ�ɶ�
       function changeHttp(){
           var httpCkecked = document.getElementById("http").checked;
           if (!httpCkecked){
        	   httpType=false;
        	   document.getElementById("httpTrUrl").style.display='none';
           }else {
        	   httpType=true;
        	   document.getElementById("httpTrUrl").style.display='block';
           }
       }
       /**
        * ����Ӧ�÷����SOA����
        */
       function reloadServiceConfirm(param){
          	var $tr = $(param).parents('tr').eq(0);
            var $trID = $tr.attr('id').replace('egex_tr_', '');
            var data=cui(window['egex'+$trID]).databind().getValue();
            var sysCode=bussSytsemData.code;
        	var ip=data.ip;
            var port=data.port;
    	   cui.confirm("<font  size='2'>�����ȷ���������ظ�Ӧ�÷������µ�����SOA����<font color='red' size='2'>���ع����п��ܻ�Ӱ�쵱ǰӦ�÷�������SOA������ù���</font>����ȡ�������������ز�����</font>", {
               onYes: function () {
            	   reloadAppServer(sysCode,ip,port);
               },
               onNo: function () {
               }
           });
       }
     //���ظ�ҵ��ϵͳ�µ����з�����������Ϣ
       function reloadAll(sysCode,isReLoadSys){
       	   var url = '<cui:webRoot/>/soa/servicemanage/ReloadAppServer.jsp?operType=reloadAppServer&sysCode='+sysCode+'&isReLoadSys='+isReLoadSys+'&ip=&port=&timeStamp='+ new Date().getTime();
       	    cui("#addServiceDialog").dialog({
       		modal: true, 
       		title: "���������ؽ����ʾ",
       		src : url,
       		width: 680,
       		height: 500
       	    }).show();
       }
       window.onload = function(){
           //ɨ��
           comtop.UI.scan();
       }

       /**
        * ����Ӧ�÷�����ע����Ϣ
        */
       function reloadAppServer(sysCode,ip,port){
       	var url = '<cui:webRoot/>/soa/SoaServlet/reload?operType=reloadAppServer&sysCode='+sysCode+'&ip='+ ip+'&port='+port+'&timeStamp='+ new Date().getTime();
           cui.handleMask.show();
             //����ajax�����ύ
             $.ajax({
                  type: "GET",
                  url: url,
                  success: function(data,status){
                	 var sData = jQuery.parseJSON(data);
                	 var serverData=sData[0];
                   	 if(serverData.operate=='undefined' || serverData.operate=='' ){
                    	 	cui.success('<font color=\"blue\" size=\"2\">������������ɣ�</font>','', {
                	            title: '����������1:ip='+ip+",port="+port,
                	            width: 430});
                	 }else{
                		     cui.error('<font color=\"red\" size=\"2\">'+serverData.result+'</font>', '', {
                	            title: '����������2:ip='+ip+",port="+port,
                	            width: 430
                	        });
                	 }
                	cui.handleMask.hide();
                  },
                  error: function (msg) {
       		       cui.error('<font color=\"red\" size=\"2\">'+msg+'</font>', '', {
     	            title: '����������3:ip='+ip+",port="+port,
     	            width: 430
     	           });
         		 	cui.handleMask.hide();
                  }
              });
       }
       function checkProxyServerConnectivity(){
          cui.handleMask.show();
          var httpUrl =bussSytsemData.httpUrl;
          var url = '<cui:webRoot/>/soa/SoaServlet/checkConnectivity?operType=checkProxyServerConnectivity&httpUrl='+ httpUrl+'&timeStamp='+ new Date().getTime();;
              //����ajax�����ύ
              $.ajax({
                   type: "GET",
                   url: url,
                   success: function(data,status){
                  	 var serverData = jQuery.parseJSON(data);
                  	 if(serverData.operate=='undefined' || serverData.operate=='' ){
                      	 	cui.success('<font color=\"blue\" size=\"2\">������,��������ͨ��������</font>','', {
                  	            title: '��������Ϣ:'+httpUrl,
                  	            width: 430});
                  	 }else{
                  		     cui.error('<font color=\"blue\" size=\"2\">'+serverData.result+'</font>', '', {
                  	            title: '��������Ϣ:'+httpUrl,
                  	            width: 430
                  	        });
                  	 }
                    cui.handleMask.hide();
                   },
                   error: function (msg) {
                          cui.handleMask.hide();
                		     cui.error('<font color=\"red\" size=\"2\">'+msg+'</font>', '', {
                   	            title: '��������Ϣ:'+httpUrl,
                   	            width: 430
                   	    });
                   }
               });
       }
       var  httpType=false;
       /**
        * Ӧ�÷�������ͨ�Լ��
        */
       function checkSystemConnectivity(param){
       cui.handleMask.show();
    	var $tr = $(param).parents('tr').eq(0);
        var $trID = $tr.attr('id').replace('egex_tr_', '');
        var data=cui(window['egex'+$trID]).databind().getValue();
        var sysCode=bussSytsemData.code;
    	var ip=data.ip;
        var port=data.port;
        var httpUrl =bussSytsemData.httpUrl;
        if(httpType){
        	 httpUrl ="";
        }
       	var url = '<cui:webRoot/>/soa/SoaServlet/checkConnectivity?operType=checkSystemConnectivity&ip='+ ip+'&port='+port+'&sysCode='+sysCode+'&httpUrl='+httpUrl+'&timeStamp='+ new Date().getTime();;
           //����ajax�����ύ
           $.ajax({
                type: "GET",
                url: url,
                success: function(data,status){
               	 var serverData = jQuery.parseJSON(data);
               	 if(serverData.operate=='undefined' || serverData.operate=='' ){
                   	 	cui.success('<font color=\"blue\" size=\"2\">������,��������ͨ��������</font>','', {
               	            title: '��������Ϣ:ip='+ip+",port="+port,
               	            width: 430});
               	 }else{
               		     cui.error('<font color=\"red\" size=\"2\">'+serverData.result+'</font>', '', {
               	            title: '��������Ϣ:ip='+ip+",port="+port,
               	            width: 430
               	        });
               	 }
                 cui.handleMask.hide();
                },
                error: function (msg) {
                       cui.handleMask.hide();
             		     cui.error('<font color=\"red\" size=\"2\">'+msg+'</font>', '', {
                	            title: '��������Ϣ:ip='+ip+",port="+port,
                	            width: 430
                	    });
                }
            });
       }
       cui.handleMask({
    	    html: '<div class="custom_hmstyle"><span id="process"><font color="red" size="5">����ִ����,�˹��̿�����Ҫ�ķѽϳ�ʱ��,�����ĵȴ�����</font></span></div>'
    	});
       --></script>   
</body>
</html>