<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<title>通知订阅</title>
<body>
	<div style="width:100%;background:#fff;heigth:100%;float:left;" id="body-id">
	</div>
	
	<!-- 模版 -->
    <script type="text/template" id="template-id">
	   <ul style="list-style:none;width:100%;min-width:790px;">		
       <@ _.each(list,function(item){  @>
			<li style="float:left;width:33.33333%;">
				<div style="border:1px solid black;margin:10px;height:45px;line-height:40px;font-size:16px;">
					<table width="100%" style="TABLE-LAYOUT:fixed;WORD-WRAP:break_word;">
						<tr>
							<td width="13%" align="right">
								&nbsp;<img src="${pageScope.cuiWebRoot}/top/workbench/personal/img/app.png" style="width:24px;height:24px;">
							</td>
							<td width="57%" title="<@=item.appName@>" align="left"  style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap">
								<@=item.appName@>
							</td>
							<td align="right" width="30%">
								 <input type="checkbox" id="<@=item.appId@>" onclick="setNoticeSubscribe('<@=item.appId@>')"
									<@ if(item.checked==true){ @>
										checked
									<@  } @>
								 >&nbsp;订阅&nbsp;&nbsp;
							</td>
						</tr>
					</table>
				</div>
			</li>
       <@ });@>
	   </ul>
    </script>
	
	<script type="text/javascript">
		require(['underscore','workbench/dwr/interface/NoticeSubscribeAction' ], function() {
			NoticeSubscribeAction.queryNoticeSubscribeList(function(data) {
				var html = _.template($('#template-id').html(), {
	                list : data
	            });
				$('#body-id').html(html);
			});
		});
		
		function setNoticeSubscribe(appId){
			var params = {};
			params.appId=appId;
			params.checked= $("#"+appId).attr("checked")=='checked' ? true : false;
			NoticeSubscribeAction.setNoticeSubscribe(params,function(data) {
				cui.message("设置成功!","success");
			});
		}
	</script>
</body>
</html>