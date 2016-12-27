<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<html>
 <%		
 	SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
 	String version = formatter.format(new Date());
	%>
<head>
	<%//360浏览器指定webkit内核打开%>
	<meta name="renderer" content="webkit">
	<%//关闭ie兼容模式,使用最高版本文档模式渲染页面%>
	<meta http-equiv="x-ua-compatible" content="IE=edge" >
	<meta http-equiv="Content-Type" content="text/html; charset=GBK"/>
   	<title>系统资料及控件管理</title>
   	<link rel="shortcut icon" href="${pageScope.cuiWebRoot}/top/workbench/base/img/logo.ico">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/base/css/base.css?v=<%=version%>"/> 
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js?v=<%=version%>"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/FileAction.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/component/requirejs/require.js?v=<%=version%>"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/component/requirejs/require.config.js?v=<%=version%>"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js?v=<%=version%>"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/base/js/base.js?v=<%=version%>"></script>
</head>

<body style="background-color: #ffffff">
<c:if test="${param.isShowHeader == 1}">
	<%@ include file="/top/workbench/base/MainNav.jsp"%>
</c:if>
<div class="list_header_wrap"  style="margin-right: 12px">
	<div class="thw_title">资料及控件列表</div>
</div>
	<div class="workbench-container" >
        <div id="file-body"></div>
    </div>
	<script type="text/template" id="file-tmpl">
            <a href="javascript:void(0)">
            	<span class="show-span todo-break-word" title="<@=file.fileClassifyName @>">
									<@=file.fileClassifyName @>
							</span>
				<i class="right-arrow min-hide" style="float: right"></i>
			</a>
	</script>
	<script type="text/javascript">
		var fileClassify = "<c:out value='${param.fileClassify}'/>";
		var isShowHeader = "<c:out value='${param.isShowHeader}'/>";
		function initFileClassify(files){
			if(fileClassify==''||fileClassify==null){
				return '0';
			}
			for(var i=0;i<files.length;i++){
				if(fileClassify==files[i].fileClassifyId){
					return fileClassify;
				}
			}
			return '0';
		}
		require(['sidebar','underscore'],function(SideBar,_){
			//默认全部

			FileAction.getFileClassifyInfo(function(data){
				var files = jQuery.parseJSON(data);
				files.unshift({fileClassifyId:'0',fileClassifyName:'全部'});
				var fileClassifyId = initFileClassify(files);
				var sideBar = new SideBar({
					context : '#file-body',
					title : '文件类别',
					model : files,
					iframe : true,
					primaryKey:'fileClassifyId',
					iframeMinHeight:function(){
						if(isShowHeader == 1){
							return (document.documentElement.clientHeight || document.body.clientHeight)-116;
						}
						return (document.documentElement.clientHeight || document.body.clientHeight)-58;
					},
					template : function(file) {
						return _.template($('#file-tmpl').html(), {
							file : file
						});
					},
					click : function(file, e) {
						this.main.load("${pageScope.cuiWebRoot}/top/sys/tools/file/MainFileList.jsp?fileClassifyId=" + file.fileClassifyId);
						return false;
					},
					isDefaultData : function(data, index){
						if(data.fileClassifyId==fileClassifyId){
							return true;
						}
						if (index == 0) {
							return true;
						}
						return false;
					}
				});
				sideBar.render(); 
				$(window).resize(function(){
					$('#file-body').setMinHeight(function(){
						if(isShowHeader == 1){
							return $(window).height()-116;
						}
						return $(window).height()-56;
					});
				}).resize();
			});
		});
		window.onload = function(){
			$('#file-body').height(function(){
				if(isShowHeader == 1){
					return (document.documentElement.clientHeight || document.body.clientHeight)-116;
				}
				return (document.documentElement.clientHeight || document.body.clientHeight)-56;
			});		
		}
	</script>
</body>
</html>