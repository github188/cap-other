<%
  /**********************************************************************
	* SOA首页导航
	* 2015-2-10 欧阳辉  新建
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ page import="com.comtop.soa.common.constant.SoaBaseConstant"%>
<%@ taglib uri="http://www.szcomtop.com/soa/cui" prefix="cui"%>
<html>
 <% 
   pageContext.setAttribute("cuiWebRoot",request.getContextPath());
%>
<head>
	<title>SOA首页导航</title>
	<cui:link href="/soa/top/component/ui/cui/themes/default/css/comtop.ui.min.css"/>
    <cui:link href="/soa/css/soa.css"/>
    <cui:script src="/soa/top/component/ui/cui/js/comtop.ui.min.js"/>
    <cui:script src="/soa/js/jquery.min.js"/>
    <cui:script src="/soa/js/soa.common.js"/>
<style>
body {
	background: #ededed;
	margin: 15px auto;
}
.button {
	display: inline-block;
	zoom: 1; 
	margin: 0 auto;
	outline: none;
	cursor: pointer;
	text-align: center;
	font: 15px;
	padding: .5em 0em .10em;
    color:#226DDD;
}
</style>
</head>
<body>
<center>
	<table id="cui_grid_list" uitype="Grid" class="cui_grid_list" tablewidth='30' selectrows="no" gridwidth="800px" gridheight="auto" datasource="initGridData" primarykey="id" pagination="false" resizewidth="getBodyWidth"  rowstylerender="rowStyleRender">
		<thead>
			<tr>
				<th renderStyle="text-align: left" style="width: 25%;" bindName="name" render="renderName"><font  size="3">功能模块</font></th>
				<th renderStyle="text-align: left" style="width: 75%;" bindName="desc" render="renderDesc"><font  size="3" title="">功能说明</font></th>
			</tr>
		</thead>
	</table>
</center>
<script type="text/javascript">
<!--
var renderName = function (rd, index, col){
	return '<span title="" class="button" onClick="gotoPage(\''+rd.addr+'\');"><b>'+rd.name+'</b></span>';

}
var renderDesc = function (rd, index, col){
	return '<font color="#6C7B8B" size="2" title="">'+rd.desc+'</font>';
} 
function gotoPage(addr){
	window.open(addr,'',' left=0,top=0,width='+ (screen.availWidth - 10) +',height='+ (screen.availHeight-50) +',scrollbars,resizable=yes,toolbar=no');
}
/**
 * 初始化grid数据
 */
function initGridData(obj,query){
	var appAddr="${cuiWebRoot}/soa/servicemanage/ModuleDialog.jsp";
	<%
	if(!SoaBaseConstant.SERVICE_DID_DATA_TARGET.equals("local")){
	%>
	   appAddr="${cuiWebRoot}/top/sys/module/ModuleMain.jsp";
	<%  
	}
	%>
    var data = [
          {id: '1', name: '系统应用管理',addr:appAddr, desc: '1、添加业务系统及模块树结构信息;</br>2、与TOP平台集成时通过TOP平台的系统应用管理界面添加业务系统及应用信息。'},
          {id: '2', name: '应用服务器管理',addr:'<cui:webRoot/>/soa/servicemanage/ProxyServerMain.jsp', desc: '1、配置业务系统代理类型及代理地址；</br>2、配置应用服务器IP及端口信息；</br>3、测试服务器连通性；</br>4、重载服务器信息。'},
          {id: '3', name: '内部服务管理',addr:'<cui:webRoot/>/soa/servicemanage/ModuleMain.jsp', desc: '1、查询已关联业务系统的服务、查询未关联业务系统的服务；</br>2、关联服务、删除关联；</br>3、导出服务、编辑服务名；</br>4、测试服务连通性、测试服务元素连通性、重载服务。'},
          {id: '4', name: '南网服务管理',addr:'<cui:webRoot/>/soa/servicemanage/TBIServiceManage.jsp', desc: '1、南网服务接口查询；</br>2、服务名称编辑、服务启用/停用；</br>3、服务认证类配置、服务访问授权；</br>4、接口测试。'},
          {id: '5', name: '服务装载信息查询',addr:'<cui:webRoot/>/soa/servicemanage/ServiceLoadInfoMain.jsp', desc: '1、查询服务装载成功并确认服务类型正确，说明该服务能正常调用;</br>2、服务类型为本地服务，说明该服务类属于该业务系统;</br>3、服务装载异常，则服务无法正常调用。'},
          {id: '6', name: '服务调用日志查询',addr:'<cui:webRoot/>/soa/servicemanage/ServiceCallLogMain.jsp', desc: '1、查询南网服务调用日志及服务调用异常日志；</br>2、重发服务调用请求。'}
            ];
    obj.setDatasource(data, 10);
}
//宽度自适应
function getBodyWidth () {
    return (document.documentElement.clientWidth || document.body.clientWidth)*3/5;
}
function getBodyHeight () {
    return (document.documentElement.clientHeight || document.body.clientHeight) - 80;
}
function rowStyleRender (rowData) {
        return "height:90px;";
}


window.onload = function(){	
	comtop.UI.scan();   //扫描
}
-->
</script>
</body>
</html>