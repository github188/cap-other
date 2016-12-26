<!doctype html>
<%
  /**********************************************************************
	* 公告基本信息列表
	* 2015-9-25 CAP 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/dev/main/header.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<link rel="stylesheet"  href="${cuiWebRoot}/cap/bm/common/base/css/base.css" type="text/css">
<html>
<head>
    <title>公告详情</title>
</head>
<style>
	.notice {
	 	margin: 4px auto 0;
	 	width: 70%;
	 	min-width: 800px;
	 	background: #f2f2f2;
	 	min-height: 600px;
	}

	.notice .notice-title {
		text-align: center;
		display: inline-block;
		width: 100%;
	}

	.notice .publish-info {
		text-align: center;
	}

	.notice .publisher {
		padding-right: 190px;
	}

	.notice .publish-time {
		padding-left: 40px;
	}

	.notice .notice-content {
		clear: both;
		padding: 0 30px;
		word-wrap:break-word;
		word-break:break-all;
	} 	
</style>

<body>
	<div id="main-nav" class="clearfix">
	    <a href="/web/cap/ptc/index/CAPIndex.jsp" target="_self" class="workbench-logo"></a>
	</div>
	

<script type="text/template" id="notice-html">
    <div class="notice">
    	<h1 class="notice-title"><@= notice.title @></h1>
    	<p class="publish-info"><span class="publisher">发布人：<@= notice.creatorName @></span><span class="publish-time">发布时间：<@= formateDate(notice.cdt, 'yyyy-MM-dd') @></span></p>
    	<div class="notice-content"><@= notice.content @></div>
    </div>
</script>

<script language="javascript">
	require([ 'jquery', 'underscore','cui','../cap/dwr/interface/CapPtcNoticeAction'], function() {

		// dwr.TOPEngine.setAsync(false);
		CapPtcNoticeAction.queryCapPtcNoticeById("${param.CapPtcNoticeId}",function(CapPtcNotice){
		    var temHtml = _.template($('#notice-html').html(), {
		    	'notice' : CapPtcNotice,
                'formateDate':formateDate
            });
            $("body").append(temHtml);
		});

		/**
		 * 将 Date 转化为指定格式的String 
		 * @param  Date date js日期对象
		 * @param  string fmt  格式化字符串月(M)、日(d)、小时(h)、分(m)、秒(s)、季度(q) 可以用 1-2 个占位符，
		 * @return string      格式化后的日期字符串
		 */
		function formateDate (date, fmt) {
			var o = { 

				"M+" : date.getMonth()+1,                 //月份 

				"d+" : date.getDate(),                    //日 

				"h+" : date.getHours(),                   //小时 

				"m+" : date.getMinutes(),                 //分 

				"s+" : date.getSeconds(),                 //秒 

				"q+" : Math.floor((date.getMonth()+3)/3), //季度 

				"S"  : date.getMilliseconds()             //毫秒 

			}; 

			if(/(y+)/.test(fmt)){
				fmt=fmt.replace(RegExp.$1, (date.getFullYear()+"").substr(4 - RegExp.$1.length)); 
 			}

			for(var k in o) {
				if(new RegExp("("+ k +")").test(fmt)) {
 					fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));
				}

			}
			return fmt; 
		}

	});
 </script>
</body>
</html>