<%
  /**********************************************************************
	* 业务系统及应用服务器管理
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
    <title>业务系统及应用服务器管理</title>
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
             <td class="tdTable">业务系统名称：</td>
             <td class="tdSpan">
                <span id="SystemName" uitype="Input"  readonly="true" width="430px" databind="bussSytsemData.name"></span>
             </td>
           </tr>
           <tr class="trTable">
                <td class="tdTable"> 代&nbsp;&nbsp;&nbsp;理&nbsp;&nbsp;&nbsp;类&nbsp;&nbsp;型：</td>
                <td class="tdSpan">
               		<input type="checkbox" name="tcp" id="tcp" value="1">&nbsp;TCP/IP(<font color="red" size="1">需部署SOA的EJB模块</font>)&nbsp;&nbsp;</input>
               		<input type="checkbox" name="http" id="http"  value="0" onClick="changeHttp()">&nbsp;HTTP(<font color="red" size="1">如：普通HTTP地址、F5代理、Apache代理等</font>)&nbsp;&nbsp;&nbsp;&nbsp;</input>
            	</td>
            </tr>
            <tr class="trTable">
               <td class="tdTable">&nbsp;</td>
               <td class="tdSpan">
	               <div id="httpTrUrl" style="display:none">
	                   HTTP访问地址：
	                   <span id="httpURL" uitype="Input"  tip="请输入代理地址,例如:http://ip:port/appName"  readonly="false" maxlength="80" emptytext="http://127.0.0.1:7001/appName" databind="bussSytsemData.httpUrl"
	                   		  validate="[{ 'type':'format','rule':{'pattern':'http://.?', 'm':'代理地址输入不合法'}}]" width="350">
	                   </span>
	                    <span><img height="20px" width="16px" title="测试代理地址连通性" src="<cui:webRoot/>/soa/css/img/check.jpg" onClick="checkProxyServerConnectivity();" style="cursor: hand"/> </span>
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
                      <th bindName="id" style="width:10%;">序号</th>           
                      <th renderStyle="text-align: center" bindName="ip" style="width:40%;">应用服务器IP</th>
                      <th renderStyle="text-align: center" bindName="port" style="width:30%;">应用服务器端口</th>
                      <th renderStyle="text-align: center" style="width:20%;" render="image" options="{'url': '<cui:webRoot/>/soa/css/img/delete.gif'}">操作
                        <img src="<cui:webRoot/>/soa/css/img/add.bmp" onClick="append()" style="cursor: hand"/>
                      </th>          
                    </tr>    
                  </thead> 
             </table>
             <div style="margin-left: 590px;margin-top: 10px">
               <span id="saveId" uitype="Button" label="保&nbsp;&nbsp;存" on_click="doSaveConfirm"></span>
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
        * 返回soa导航页
        */
       function returnIndex(){
    	   parent.document.location.href="<cui:webRoot/>/soa/index.jsp";
       }
       //根据输入的代理地址的值，勾选checkBox的值
       function selectCheckedBox(newData){
    	   newData.name=bussSytsemData.name;
    	   newData.code=bussSytsemData.code;
           cui(bussSytsemData).databind().setValue(newData);
           //设置文本框与复选框的状态
           setCkeckedValue('http','#httpURL');
           if (newData.supperProtocol==8||newData.supperProtocol==16){
        	   document.getElementById('tcp').checked = true;
           }
           //校验代理地址
           validProtocol();
       }

       //文本框有值,设置文本框可编辑与复选框选中
       //文本框无值,文本框置灰与复选框置灰
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
           //若http被勾选，则增加不为空的校验
           if (!httpCkecked){
               //若http未被勾选,则取消httpURL文本框的校验
               window.validater.disValid(cui('#httpURL'), true);
               cui('#httpURL').setValue("",true);
               cui('#httpURL').setEmptyText('http://127.0.0.1:7001/appName');
           }else {
               window.validater.disValid(cui('#httpURL'), false);
               window.validater.add('httpURL', 'required', {
                   m:'代理地址不能为空。'
                });
           } 
       }
       //业务系统保存确认
       function doSaveConfirm(){
    	   cui.confirm("<font color='red' size='2'>1、操作前请确保代理地址连通性正常；</br>2、操作前请确保应用服务器连通性正常；</br>3、重载过程中可能会影响SOA服务调用；</br>4、预计10秒内重载完成一个应用节点；</br>5、为保证服务器稳定，请勿反复操作。</font>", {
              title:'保存及重载该业务系统服务注册信息',
    		   buttons: [
                         {
                             name: '确定',
                             handler: function () {
                            	 //保存&重载
                            	 doSave(true,1);
                             }
                         },
                         {
                             name: ' 取消',
                             handler: function () {
                            	 //只保存不重载
                            	// doSave(false,1);
                             }
                         }
                     ]
               
           });
       }
       //业务系统数据保存
       function doSave(reloadType,tips){
           var tcpType ='';
           validProtocol();
           var systemName = cui('#SystemName').getValue();
           var httpURL = cui('#httpURL').getValue();
           var httpCkecked = document.getElementById("http").checked;
           var tcpCkecked = document.getElementById("tcp").checked;
           if (!httpCkecked && !tcpCkecked){
               cui.warn("必须选择一个代理类型。");
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
               cui.warn("须填写一条应用服务器信息,代理地址才能生效。");
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
                    //根据输入的代理地址的值，勾选checkBox的值
                   // selectCheckedBox(jQuery.parseJSON(data));
                    cui('#cui_grid_list').setDatasource(systemData,systemData.length);
               		if(data){
               			 var resultData = jQuery.parseJSON(data);
               			 if(resultData.isLocalMode&&reloadType==true){
               				cui.message("保存成功,正在执行重载");
                    	    var  isReLoadSys=resultData.isReLoadSys;
                    	 	reloadAll(bussSytsemData.code,isReLoadSys);
               			 }else{
               				 if(tips==1){
                   				 cui.success("保存成功，但未进行业务系统重载操作，该业务系统下的SOA服务可能还无法正常调用。");
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
        * Grid加载完毕后生成编辑模板
        * @param obj
        */
       function initEdit(obj){
           editGrid.edit(obj);
       }

       /**
        * 创建编辑grid
        * @type {*}
        */
       var editGrid = cui().editGridEX({
           editMode: true,
           //编辑表单组件模板
           tmpl: [
               {
                   //自动生成编号，autoNumber(起始编号),每次追加1，自动编号只用于编号，不作为数据提交
                   htmlElement: '#autoNumber(1)#'
               },
               {
                   uitype: 'Input',
                   validate:[{type:"required", rule:{m: "IP不能为空"}},{type:"length", rule:{"max":20,"maxm": "长度不能超过20"}},{ type:"format",rule:{pattern:"(\\d+)\\.(\\d+)\\.(\\d+)\\.(\\d+)", m:"IP输入不合法"}}],
                   datasource: initGridData,
                   bindname: 'ip'
                       
               },
               {
                   uitype: 'Input',
                   validate:[{type:"required", rule:{m: "端口不能为空"}},{type:"length", rule:{"max":6,"maxm": "长度不能超过6"}},{ type:"format",rule:{pattern:"^[1-9]$|(^[1-9][0-9]$)|(^[1-9][0-9][0-9]$)|(^[1-9][0-9][0-9][0-9]$)|(^[1-9][0-9][0-9][0-9][0-9]$)|(^[1-9][0-9][0-9][0-9][0-9][0-9]$)", m:"端口输入不合法"}}],
                   datasource: initGridData,
                   bindname: 'port'
               },
               {
                   //自定义DOM结构，支持生成非CUI组件和数据类组件
                   htmlElement: '<img title="删除" src="<cui:webRoot/>/soa/css/img/delete.gif" onClick="removeData(this);" style="cursor: hand"/>&nbsp;<img height="20px" width="16px" title="测试连通性" src="<cui:webRoot/>/soa/css/img/check.jpg" onClick="checkSystemConnectivity(this);" style="cursor: hand"/>&nbsp;<img height="20px" width="17px" title="重载服务器" src="<cui:webRoot/>/soa/css/img/loading.png" onClick="reloadServiceConfirm(this);" style="cursor: hand"/>'
               }
           ]
       });
        
        /**
         * 删除数据行
         * @param t
         */
        function removeData(t){
            editGrid.remove(t);
        }

        /**
         * 新增数据，用于在指定数据行后插入空行
         */
        function addData(t){
            //在t后面添加新的数据行
            editGrid.add(t);
        }

        /**
         * 新增空数据行，用于在表格后追加
         */
        function append(){
             editGrid.add();
        }

       /**
        * 初始化grid数据
        */
       function initGridData(obj){
           if (systemCode){
               var url = '<cui:webRoot/>/soa/SoaServlet/queryBussSystem?operType=queryBussSystem&bussSystemCode='+systemCode+'&timeStamp='+ new Date().getTime();
                //采用ajax请求加载对应的业务系统详细信息
               $.ajax({
                    type: "GET",
                    url: url,
                    success: function(data,status){
                         newBussSytsemData = jQuery.parseJSON(data);
                         if (checkStrEmty(newBussSytsemData)){
                        	 obj.setDatasource([]);
                        	 return;
                             }
                         //根据输入的代理地址的值，勾选checkBox的值
                         selectCheckedBox(newBussSytsemData);
                         var appServerListData = newBussSytsemData.appServerList;
                         if (checkStrEmty(appServerListData)){
                        	 obj.setDatasource([]);
                        	 return;
                             }
                         obj.setDatasource(appServerListData,appServerListData.length);
                    },
                    error: function (msg) {
                                 cui.message('加载业务系统失败。', 'error');
                             }
                });
           }else{
               var dataList = [];
               obj.setDatasource(dataList,dataList.length);
           }
       }

       //控制http的input组件是否可读
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
        * 重载应用服务的SOA服务
        */
       function reloadServiceConfirm(param){
          	var $tr = $(param).parents('tr').eq(0);
            var $trID = $tr.attr('id').replace('egex_tr_', '');
            var data=cui(window['egex'+$trID]).databind().getValue();
            var sysCode=bussSytsemData.code;
        	var ip=data.ip;
            var port=data.port;
    	   cui.confirm("<font  size='2'>点击‘确定’将重载该应用服务器下的所有SOA服务，<font color='red' size='2'>重载过程中可能会影响当前应用服务器的SOA服务调用功能</font>；‘取消’不进行重载操作？</font>", {
               onYes: function () {
            	   reloadAppServer(sysCode,ip,port);
               },
               onNo: function () {
               }
           });
       }
     //重载该业务系统下的所有服务器缓存信息
       function reloadAll(sysCode,isReLoadSys){
       	   var url = '<cui:webRoot/>/soa/servicemanage/ReloadAppServer.jsp?operType=reloadAppServer&sysCode='+sysCode+'&isReLoadSys='+isReLoadSys+'&ip=&port=&timeStamp='+ new Date().getTime();
       	    cui("#addServiceDialog").dialog({
       		modal: true, 
       		title: "服务器重载结果显示",
       		src : url,
       		width: 680,
       		height: 500
       	    }).show();
       }
       window.onload = function(){
           //扫描
           comtop.UI.scan();
       }

       /**
        * 重载应用服务器注册信息
        */
       function reloadAppServer(sysCode,ip,port){
       	var url = '<cui:webRoot/>/soa/SoaServlet/reload?operType=reloadAppServer&sysCode='+sysCode+'&ip='+ ip+'&port='+port+'&timeStamp='+ new Date().getTime();
           cui.handleMask.show();
             //采用ajax请求提交
             $.ajax({
                  type: "GET",
                  url: url,
                  success: function(data,status){
                	 var sData = jQuery.parseJSON(data);
                	 var serverData=sData[0];
                   	 if(serverData.operate=='undefined' || serverData.operate=='' ){
                    	 	cui.success('<font color=\"blue\" size=\"2\">服务器重载完成！</font>','', {
                	            title: '服务器重载1:ip='+ip+",port="+port,
                	            width: 430});
                	 }else{
                		     cui.error('<font color=\"red\" size=\"2\">'+serverData.result+'</font>', '', {
                	            title: '服务器重载2:ip='+ip+",port="+port,
                	            width: 430
                	        });
                	 }
                	cui.handleMask.hide();
                  },
                  error: function (msg) {
       		       cui.error('<font color=\"red\" size=\"2\">'+msg+'</font>', '', {
     	            title: '服务器重载3:ip='+ip+",port="+port,
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
              //采用ajax请求提交
              $.ajax({
                   type: "GET",
                   url: url,
                   success: function(data,status){
                  	 var serverData = jQuery.parseJSON(data);
                  	 if(serverData.operate=='undefined' || serverData.operate=='' ){
                      	 	cui.success('<font color=\"blue\" size=\"2\">检查完成,服务器连通性正常！</font>','', {
                  	            title: '服务器信息:'+httpUrl,
                  	            width: 430});
                  	 }else{
                  		     cui.error('<font color=\"blue\" size=\"2\">'+serverData.result+'</font>', '', {
                  	            title: '服务器信息:'+httpUrl,
                  	            width: 430
                  	        });
                  	 }
                    cui.handleMask.hide();
                   },
                   error: function (msg) {
                          cui.handleMask.hide();
                		     cui.error('<font color=\"red\" size=\"2\">'+msg+'</font>', '', {
                   	            title: '服务器信息:'+httpUrl,
                   	            width: 430
                   	    });
                   }
               });
       }
       var  httpType=false;
       /**
        * 应用服务器连通性检查
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
           //采用ajax请求提交
           $.ajax({
                type: "GET",
                url: url,
                success: function(data,status){
               	 var serverData = jQuery.parseJSON(data);
               	 if(serverData.operate=='undefined' || serverData.operate=='' ){
                   	 	cui.success('<font color=\"blue\" size=\"2\">检查完成,服务器连通性正常！</font>','', {
               	            title: '服务器信息:ip='+ip+",port="+port,
               	            width: 430});
               	 }else{
               		     cui.error('<font color=\"red\" size=\"2\">'+serverData.result+'</font>', '', {
               	            title: '服务器信息:ip='+ip+",port="+port,
               	            width: 430
               	        });
               	 }
                 cui.handleMask.hide();
                },
                error: function (msg) {
                       cui.handleMask.hide();
             		     cui.error('<font color=\"red\" size=\"2\">'+msg+'</font>', '', {
                	            title: '服务器信息:ip='+ip+",port="+port,
                	            width: 430
                	    });
                }
            });
       }
       cui.handleMask({
    	    html: '<div class="custom_hmstyle"><span id="process"><font color="red" size="5">正在执行中,此过程可能需要耗费较长时间,请耐心等待……</font></span></div>'
    	});
       --></script>   
</body>
</html>