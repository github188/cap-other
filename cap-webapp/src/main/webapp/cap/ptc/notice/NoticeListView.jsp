<!doctype html>
<%
  /**********************************************************************
	* 公告基本信息列表
	* 2015-9-25 CAP 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/dev/main/header.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/cap/bm/common/base/css/base.css">
<html>
<head>
    <title>公告列表</title>
</head>

<style>
 	.notice-list {
	 	margin: 4px auto 0px;
	 	width: 70%;
	 	min-width: 800px;
	 	/*background: #f2f2f2;*/
	 	min-height: 600px;
	 	border:1px solid #DDDDDD;
	}
	
	.notice-list ul {
		padding: 12px 15px 12px 30px;
		list-style-type: none;
	}

	.notice-list ul li {
		border-bottom: #dcdcdc 1px dashed;
		overflow: hidden;
		font: 16px/30px "微软雅黑";
		color: #333;
	}

	.notice-list .notice-time {
		float: right;
		cursor:default;
	}

	.notice-list a {
		overflow: hidden;
		white-space: nowrap;
		text-overflow: ellipsis;
		width: 85%;
		float: left;
 	}

</style>

<body>
<div id="main-nav" class="clearfix">
        <a href="/web/cap/ptc/index/CAPIndex.jsp" target="_self" class="workbench-logo"></a>
    </div>
<div id="notice-list" class="notice-list">
	<ul> </ul>
</div>

<script type="text/template" id="notice-list-html">
    <@ _.each(noticeList,function(notice){@>
    <li data-id="<@= notice.id @>">
    	<a href="###" title="<@= notice.title @>"><@= notice.title @></a><span class="notice-time"><@= formateDate(notice.cdt, 'yyyy-MM-dd') @></span>
    </li>
    <@ });@>
</script>

<script language="javascript">
	require([ 'jquery', 'underscore','cui','../cap/dwr/interface/CapPtcNoticeAction'], function() {

		//查询条件
		var queryCondition = {
			sortFieldName: "cdt",
			sortType: "DESC"
			// pageSize: 20,
			// pageNo: 1
		};

		// dwr.TOPEngine.setAsync(false);
		CapPtcNoticeAction.queryCapPtcNoticeListNoPage(queryCondition,function(data){
		    var temHtml = _.template($('#notice-list-html').html(), {
		    	'noticeList' : data,
                'formateDate':formateDate
            });
            $('#notice-list ul').append(temHtml);
		});

		//on click 事件
		$("#notice-list ul").on('click', 'a', function(event) {
			event.preventDefault();
			event.stopPropagation();
			var id = $(event.currentTarget).closest("li").attr('data-id');
	    	var url = "NoticeView.jsp?CapPtcNoticeId=" + id;
			window.open(url);
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