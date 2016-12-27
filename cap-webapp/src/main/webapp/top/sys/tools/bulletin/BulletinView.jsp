
<%
    /**********************************************************************
			 * 电子公告列表
			 * 2012-10-24 陈佳山  新建
			 * 2013-2-22 谭国华 重构
			 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<title>电子公告查看页面</title>
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css"/>
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css"/>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js" ></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.editor.min.js" ></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js" ></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/BulletinAction.js" ></script>
	<style type="text/css">
      html,body{}
      .button_box{ *margin-right:6px;}
	</style>
</head>
<body>
<div class="top_header_wrap">
	<div class="thw_title">
		公告信息查看
	</div>
	<div class="thw_operate">
	</div>
</div>
<div class="top_content_wrap">
	<table class="form_table">
		<tr>
			<td class="td_label" width="12%">公告标题 ：</td>
			<td>
				<span id="title"></span>
			</td>
		</tr>
		<tr>
			<td class="td_label">公告内容：</td>
			<td>
    				<span id="contentClob"></span>
			</td>
		</tr>
	
			<tr>
			<td class="td_label">&nbsp;</td>
			<td> 
			<ul class="daylist" id="fileList">
			</ul>		 
			</td>
		</tr>	
		
	</table>
</div>
<script type='text/javascript'>
var bulletinId = "<c:out value='${param.bulletinId}'/>";
var data = {};

window.onload = function(){
	//初始化页面
    if (bulletinId) {//编辑页面
        dwr.TOPEngine.setAsync(false);
        BulletinAction.readBulletin(bulletinId, function(bulletinData){
            data = bulletinData;
            $("#title").text(bulletinData['title']);
            $("#contentClob").html(bulletinData['contentClob']);
            if(bulletinData['urgent']!=null && bulletinData['urgent']==0){
            	$("#urgent").text('普通');
            }else if(bulletinData['urgent']!=null && bulletinData['urgent']==0){
            	$("#urgent").text('紧急');
            }
        });
        dwr.TOPEngine.setAsync(true);
    }
    comtop.UI.scan();
}



</script>
</body>
</html>