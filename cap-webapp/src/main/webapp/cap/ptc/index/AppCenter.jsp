<%
  /**********************************************************************
	* CAP应用中心 
	* 2015-09-25  李小芬  新增
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/cap/bm/dev/main/header.jsp" %>
<title>我的应用-中国南方电网</title>
<!-- <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/base/css/base.css"/> -->
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/app/css/app.css"/>
<style type="text/css">
	html, body {
	  padding: 0px;
	  margin: 0px;
	  width: 100%;
	  background-color: #FFF;
	  font-size: 12px;
	  font-family: "Microsoft YaHei", sans-serif;
	  color: #333333;
	}
	/**防止ie6绝对定位页面滚动时闪烁*/
	*html {
	  /* 只有IE6支持 */
	  background-image: url(about:blank);
	  /* 使用空背景 */
	  background-attachment: fixed;
	  /* 固定背景 */
	}

	a {
	  color: #0088cc;
	  text-decoration: none;
	  cursor: pointer;
	}

	a:hover {
	  color: #005580;
	  text-decoration: underline;
	}
	a:visited {
	  color: #9700ad;
	}

	.pull-left {
	  float: left !important;
	}
	/*editsssxss*/
	.pull-right {
	  float: right !important;
	}

	.no-data {
		width: 160px;
		margin-left: auto;
		margin-right: auto;
		line-height: 135px;
		display: none;
		font-size: 14px;
		height:120px;
	}
	#my-apps {
		height: 161px;
	}
</style>

</head>
<body>
<div id="my-apps">
	<script type="text/template" id="app-tmpl">
		<div class="app-list">
            <@ _.each(models,function(appVO){@>
		
                <a data-url="<@ if(isTest){ @>/cap/bm/test/index/TestModelMain.jsp<@}else{@>/cap/ptc/index/AppDetail.jsp<@}@>?clickCome=homepage&packageId=<@= appVO.appId @>&id=<@= appVO.id @>" target="_blank" data-mainframe="false" class="app">
                	<div class="app-name">
            			<@= appVO.appName @>
        			</div>
            		<img src="<@ if(appVO.appIconUrl){  @> ${pageScope.cuiWebRoot}<@=appVO.appIconUrl @> <@}else{@> ${pageScope.cuiWebRoot}/top/sys/images/img_sysapp.png <@}@>" class="app-logo">
        			<div class="app-op clearfix">
        			    <@if(appVO.appType == 1){@>
        			        
        			    <@ }else{@>
        			        <div id="<@= appVO.id @>" class="pull-right op-name cancel-common">取消收藏</div>
        			        <div class="pull-right op-state">收藏</div>
        			    <@}@>       
        			</div>
           		</a>
            <@ });@>
		</div>
		<div class="no-data">没有分配或收藏的模块.</div>
	</script>
</div>
</body>

<script type="text/javascript">
	//根据当前登录用户查询分配的应用和收藏的应用。
	require([ 'jquery', 'underscore','cui','../cap/dwr/interface/CapAppAction'], function() {
		// dwr.TOPEngine.setAsync(false);
		var g = window;
		var roleIds = g.globalCapRoleIds.split(';');
		var isTest = false;
		if($.inArray('developer', roleIds) > -1 ){
			isTest = false;
		}else if($.inArray('test', roleIds) > -1 ){
			isTest = true;
		}else{
			isTest = false;
		}
		CapAppAction.queryMyApp(globalCapEmployeeId,true,function(data){
            var temHtml = _.template($('#app-tmpl').html(), {
                models : data,
                'isTest' : isTest
            });
            $('#my-apps').html(temHtml);
            if(data && data.length === 0) {
            	$(".no-data", "#my-apps").show();
            }
            resizePanelHeight();
		});
		// dwr.TOPEngine.setAsync(true);
		//绑定取消收藏事件
		$('#my-apps').on('click', '.cancel-common', function(event) {
			event.preventDefault();
			event.stopPropagation();
			// dwr.TOPEngine.setAsync(false);
			CapAppAction.cancelAppStore({id: $(event.target).attr("id")} ,function(data){
				if(data && data === true) {
					$(event.target).parents("a").remove();
					if($("#my-apps").find("a").length === 0) {	//没有任何应用
						$(".no-data", "#my-apps").show();
					}else {
						resizePanelHeight();
					}
				}
			});
			// dwr.TOPEngine.setAsync(true);
			
		});

		function resizePanelHeight () {
			if (g.parent.resetPanelHeight) {
				g.parent.resetPanelHeight('appCenter', "my-apps");	//更新iframe高度
			};
		}
	});
</script>
</html>