<!DOCTYPE html>
<%
  /**********************************************************************
	* 团队公告显示页面
	* 2015-10-09 姜子豪
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<title>团队公告</title>
<%@ include file="/cap/bm/dev/main/header.jsp" %>
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/cap/bm/common/base/css/base.css"/>
</head>
	<style type="text/css">
		#notice {
			height: 161px;
			padding: 0 4px;
			background-color: #fff;
		}

		#notice table {
			table-layout: fixed;
			overflow: hidden;
			white-space: nowrap;
		}
		
		#notice td{
			overflow: hidden;
			white-space: nowrap;
			text-overflow: ellipsis;
			border-bottom: #dcdcdc 1px dashed;
			font-family:"9ED1";
			font-size: 12px;
		}
		
		#notice a{
			overflow: hidden;
			white-space: nowrap;
			text-overflow: ellipsis;
			font-family:"微软雅黑";
			font-size: 12px;
		}
		
		.more {
			text-align: right;
			padding-right: 2px;
			padding-top: 4px;
			overflow: hidden;
			white-space: nowrap;
			text-overflow: ellipsis;
			font-family:"微软雅黑";
			font-size: 12px;
		}

		.no-notice {
			width: 160px;
			margin-left: auto;
			margin-right: auto;
			line-height: 135px;
			display: none;
			font-size: 14px;
		}
		
	</style>
<body>
	<div id="notice">
 	</div>
<script type="text/template" id="notice-list-html">
	<table width="100%">
		<tbody>
	    <@ _.each(noticeList, function(notice){@>
	   		<tr data-id="<@= notice.id @>">
	   			<td style="width: 80%;">
	   				<a href="###" target="_blank" title="<@= notice.title @>">
	   					<@= notice.title @>
	   				</a>
	   			</td>
	   			<td style="text-align: right;cursor:default;"><@= formateDate(notice.cdt, 'yyyy-MM-dd') @></td>
	   		</tr>
	    <@ });@>
	    </tbody>
	</table>
	<@ if(showMore){@>
		<div class="more"><a id="more-notice" href="###">更多公告</a></div>
	<@ }@>
	<div class="no-notice">暂时没有公告.</div>
</script>

<script type="text/javascript">
	require([ 'jquery', 'underscore','../cap/dwr/interface/CapPtcNoticeAction'], function() {
		
		/* 查询条件 */
		var queryCondition = {
			sortFieldName: "cdt",
			sortType: "DESC",
			pageSize: 6,
			pageNo: 1
		};

		CapPtcNoticeAction.queryCapPtcNoticeList(queryCondition, function(data){
		    var temHtml = _.template($('#notice-list-html').html(), {
		    	'noticeList' : data.list,
		    	'showMore': data.count > queryCondition.pageSize,
                'formateDate':formateDate
            });
            $('#notice').append(temHtml);

            if(data.count === 0) {
            	$(".no-notice").show();
            }
            // parent.resetPanelHeight("noticeTab","notice");
            
            if(data.count > queryCondition.pageSize) {
            	$("#more-notice").on('click', function(event) {
		        	event.preventDefault();
		        	event.stopPropagation();
		        	window.open(webPath + '/cap/ptc/notice/NoticeListView.jsp');
		        });	
            }
		}); 

        $("#notice").on('click', 'a', function(event) {
        	event.preventDefault();
        	event.stopPropagation();
        	var id = $(event.currentTarget).closest("tr").attr('data-id');
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