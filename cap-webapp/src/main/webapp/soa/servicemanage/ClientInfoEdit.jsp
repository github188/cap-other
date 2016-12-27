<%
/**********************************************************************
* 第三方应用/客户端数据
* 2014-10-11 李小强 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ taglib uri="http://www.szcomtop.com/soa/cui" prefix="cui"%>
<!DOCTYPE html>
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
				<col width="15%" />
				<col width="35%" />
				<col width="15%" />
				<col width="35%" />
			</colgroup>
			<tr>
				<td class="td_label">客户端名称：</td>
				<td><span uitype="input" name="name" id="name" width="160px" databind="oldClientData.name" maxlength="40" ></span></td>
				
				<td class="td_label">客户端类型：</td>
	            <td><span id="type" width="100px"  uitype="SinglePullDown" name="type" value_field="id" label_field="label"  databind="oldClientData.type" datasource="initTypeData" validate="类型不能为空"></span></td>
			</tr>
	        <tr>
				<td class="td_label">ip地址：</td>
	            <td><span uitype="input" id="ip1" name="ip1" maxlength="16" width="160px" databind="oldClientData.ip1" validate="ipValid"></span></td>           
	            <td class="td_label">端口：</td>
	            <td><span uitype="input" id="prot" name="prot" maxlength="5" width="100px" databind="oldClientData.prot" validate="portValid"></span></td>
	        </tr>
	        
	         <tr>
	            <td class="td_label">描述：</td>
	            <td colspan="3"><span uitype="Textarea" id="memo" width="82%" databind="oldClientData.memo" height="50px" maxlength="100"></span></td>	
	        </tr>
	         <tr>
	           <td colspan="4" align="left" style="font-size: 12px">
		         <span style="color:green;"> &nbsp; &nbsp;客户端类型：<br/>
		         &nbsp; &nbsp; &nbsp;白名单-不需要进行授权，可访问所有服务；<br/>
		         &nbsp; &nbsp; &nbsp;普通客户端-需设置可访问服务范围；<br/>
		         &nbsp; &nbsp; &nbsp;黑名单-不可以访问任何服务<br/></span></td>
	         </tr>
		</table>
	</div>
</div>
<script type="text/javascript">
     var data = [];
     var oldClientData={name:"${param.name}",type:"${param.type}","ip1":"${param.ip1}",prot:"${param.prot}",memo:"${param.memo}"};
     var ipValid=[{type:'format',rule:{pattern:'(\\d+)\\.(\\d+)\\.(\\d+)\\.(\\d+)', 'm':'IP输入不合法'}},{type:'required',rule: {m:'IP不能为空'}}];
     var portValid=[{ 'type':'format','rule':{'pattern':'^[1-9]$|(^[1-9][0-9]$)|(^[1-9][0-9][0-9]$)|(^[1-9][0-9][0-9][0-9]$)|(^[1-9][0-9][0-9][0-9][0-9]$)', 'm':'端口输入不合法'}},{type:'required',rule: {m:'端口不能为空'}}];
     var clientId = "${param.clientId}";
        /**
         * 新增业务系统
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
            	        cui('#save').disable(true);
            	        window.parent.cui.message('保存成功。', 'success');
            			window.parent.location.href='<cui:webRoot/>/soa/servicemanage/ClientInfoMain.jsp';
                  },
                 error: function (msg) {
        		         cui.message('保存失败。', 'error');
                      }
             });
        }
		window.onload = function(){
		    //扫描
		    comtop.UI.scan();
		    
		}	

	    /**
	     * 职位pulldown数据初始化
	     * @param obj {Object} pulldown实例对象
	     */
	    function initTypeData(obj){
	        var data;
	        //TODO 通过dwr或者ajax获取数据，然后执行数据初始化
	        //模拟数据
	        data = [
	            {id:'1',label:'白名单'},
	            {id:'2',label:'普通客户端'},
	            {id:'3',label:'黑名单'}
	        ];
	        obj.setDatasource(data);
	    }
			
	</script>
</body>
</html>