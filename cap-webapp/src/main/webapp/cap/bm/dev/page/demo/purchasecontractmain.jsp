<%
/**********************************************************************
* 示例页面
* 2015-5-13 肖威 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<%@ include file="/cap/bm/common/Taglibs.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>采购合同管理</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/cap/bm/dev/page/demo/css/table-layout.css"/>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/top/js/jquery.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/cui/js/comtop.ui.min.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/dev/page/demo/js/data.js"></script>
    <script type="text/javascript">
    
		//页面控件属性配置
   	var uiConfig={
		tab: {
	        uitype: "Tab",
	        width: $($("table td").get(2)).width(),
	        head_width:44,
	        height: 0,
	        tab_width:65,
	        active_index: 0,
	        tabs:  [
	            {
	                title: '采购合同',
	                url: "purchasecontractEdit.jsp"
	            },
	            {
	                title: '采购单',
	                url: 'purchaseEdit.jsp'
	            }
	        ],
	        fill_height : false,
	        reload_on_active: true, //激活时重新加载内容
	        closeable: false, //是否可关闭
	        trigger_type: "click"
	   		 }
          }
		
        jQuery(document).ready(function(){
            comtop.UI.scan();
            initDataBind();
            initValidate();
        });
		
    </script>
</head>
<body>
<table  class="table">
    <tr>
        <td>
            <span id="tab" uitype="Tab"></span>
        </td>
    </tr>
</table>
</body>
</html>