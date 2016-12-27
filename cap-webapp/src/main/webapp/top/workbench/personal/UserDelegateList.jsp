<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<%@ include file="/top/workbench/base/Header.jsp"%>
<title>委托记录</title>
</head>
<body>
	<table style="width:100%;">
		<tr>
			<td align="center">
			<table id="myTable" gridheight="400px" uitype="Grid" selectrows="no" pagination="false" class="cui_grid_list" datasource="initData">
				<thead>
				<tr>
					<th renderStyle="text-align: center" bindName="delegatedUserName">委托人</th>
					<th renderStyle="text-align: center" render="renderLink" >委托时段</th>
				</tr>
				</thead>
			</table>
			</td>
		</tr>
	</table>
	
	
	<script type="text/javascript">
		require(['cui', 'workbench/dwr/interface/WorkbenchUserDelegateAction'], function() {
			comtop.UI.scan();
		});
		
		function initData(obj){
			var userDelegateDTO = new Object();
			userDelegateDTO.userId = globalUserId;
			userDelegateDTO.sortFieldName="endTime";
			userDelegateDTO.sortType="DESC"
			WorkbenchUserDelegateAction.queryUserDelegateList(userDelegateDTO,function(data) {
				obj.setDatasource(data.list,data.count);
			});
		}
		
		function renderLink(rd, index, col) {
			var startTime = rd['startTime'];
			var strStartTime =  startTime.getFullYear()+"-"+(startTime.getMonth() + 1)+"-"+startTime.getDate();
			var endTime = rd['endTime'];
			var strEndTime =  endTime.getFullYear()+"-"+(endTime.getMonth() + 1)+"-"+endTime.getDate();
			return strStartTime+"&nbsp;到&nbsp;"+strEndTime;
		}
	</script>
</body>
</html>
