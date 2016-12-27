<%
  /**********************************************************************
	* 服务导出
	* 2014-2-13  袁巧林
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ taglib uri="http://www.szcomtop.com/soa/cui" prefix="cui"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>服务导出</title>
	<cui:link href="/soa/top/component/ui/cui/themes/default/css/comtop.ui.min.css"/>
    <cui:link href="/soa/css/soa.css"/>
    <cui:script src="/soa/top/component/ui/cui/js/comtop.ui.min.js"/>
    <cui:script src="/soa/js/jquery.min.js"/>
	<style type="text/css">
		img{
		  margin-left:5px;
		}
		#addRoleButton{
		margin-right:5px;
		}
	</style>
	
	</head>
<body class="body_layout">
     <div id="dt1" uitype="tab" height="436">
      <div data-options='{"tab_width":"70","title":"导入成功"}'>
		<cui:bpanel  position="center" id="centerMain" gap="5px 5px 5px 0px">
        <table id="cui_grid_list" uitype="Grid" class="cui_grid_list" gridwidth="760px" gridheight="400" datasource="initImportSucessGridData" selectrows="no">   
           <thead>       
              <tr>           
                <th renderStyle="text-align: left" style="width:30%;" bindName="code">服务编号</th>
                <th renderStyle="text-align: left" style="width:70%;"  bindName="serviceAddress">服务地址</th>
              </tr>    
           </thead>
         </table>
		</cui:bpanel>
	  </div>
	  <div data-options='{"tab_width":"70","title":"导入失败"}'>
		<cui:bpanel  position="center" id="centerMain" gap="5px 5px 5px 0px">
        <table id="cui_grid_list" uitype="Grid" class="cui_grid_list" gridwidth="760px" gridheight="400" datasource="initImportFailGridData" selectrows="no">   
           <thead>       
              <tr>           
                <th renderStyle="text-align: left" style="width:30%;" bindName="code">服务编号</th>
                <th renderStyle="text-align: left" style="width:50%;"  bindName="serviceAddress">服务地址</th>
                <th renderStyle="text-align: left" style="width:20%;"  bindName="failInfo">失败详情</th>
              </tr>    
           </thead>
         </table>
		</cui:bpanel>
	  </div>
    </div>
    <iframe id="importFrame" style="display: none;" src="about:blank"></iframe>
<script type="text/javascript">
/**
 * 初始化grid数据
 */
function initImportSucessGridData(obj,query){
	var data = <%=request.getAttribute("strSucessJson")%>;
	if (data.length == 0){
		obj.setDatasource([]);
	}else {
		obj.setDatasource(data.slice((query.pageNo - 1) * query.pageSize, query.pageNo * query.pageSize), data.length);
	}
}

function initImportFailGridData(obj,query){
	var data = <%=request.getAttribute("strFailJson")%>;
	if (data.length == 0){
		obj.setDatasource([]);
	}else {
		obj.setDatasource(data.slice((query.pageNo - 1) * query.pageSize, query.pageNo * query.pageSize), data.length);
	}
}

window.onload = function(){
	
	window.parent.exportObj.setSize({width:790, height:439});
	comtop.UI.scan();   //扫描
}
</script>   
</body>
</html>
            