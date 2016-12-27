 <%
/**********************************************************************
* 委托管理:代理人员列表
* 2013-04-22 汪超  新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK"/>
    <title>代理人员列表查看</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">    
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">

	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/js/commonUtil.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/UserDelegateAction.js"></script>
    
    <style type="text/css">
    .grid_container input{margin-left: -3px;} 
    th {
	font-weight: bold;
	font-size: 14px;
    }
    </style>
</head>
<body >	
	<div class="list_header_wrap" style="padding-bottom:10px;padding-left:10px;padding-right:12px;">
		<div class="top_float_left">
			<span uitype="ClickInput" id="myClickInput" name="userName"  
				emptytext="请输入代理人姓名" editable="true" width="280" 
				on_iconclick="iconclick"
				icon="search" 
				iconwidth="18px"
				width="250"
				enterable="true">
			</span>
	    </div>
		<div class="top_float_right">
			<span uitype="Button" label="添 加" on_click="showAccess"></span>
			<span uitype="Button" label="删 除" on_click="deleteConsignUser"></span>
		</div>
	</div>

	 <div>
	 <div id="gridWrap" style="padding:0 15px 0 10px">
	<table id="tableList" uitype="Grid" 
		datasource="initData" primarykey="consignId" sortstyle="1"
		resizeheight="resizeHeight" resizewidth="resizeWidth" pagesize_list="[10,20,30]">
		<thead>
			<tr>
				<th width="40px" align="center"><input type="checkbox" /></th>
				<th style="width:15%;" renderStyle="text-align: left" bindName="delegatedUserName"
					render="renderLink">代理人姓名</th>
				<th style="width:15%;" renderStyle="text-align: left" bindName="delegatedOrgName">所属组织</th>
				<th style="width:15%;" renderStyle="text-align: center" bindName="startTime"
					format="yyyy-MM-dd hh:mm:ss">开始日期</th>
				<th style="width:15%;" renderStyle="text-align: center" bindName="endTime"
					format="yyyy-MM-dd hh:mm:ss">结束日期</th>
				<th style="width:15%;" renderStyle="text-align: center" 
					render="renderHasAllAccess">委托情况</th>
				<th style="width:15%;" renderStyle="text-align: center" 
					render="renderState">是否有效</th>
				<th style="width:15%;" renderStyle="text-align: center" bindName="managerAccess"
					render="cosignAccessRenderLink">设置权限</th>
			</tr>
		</thead>
	</table>
	</div>
	</div>
	<script type="text/javascript">
		//委托人
		var userId = globalUserId;
		var name = globalUserName;
		
		var keyword = '';
		var dialog;
		
		//页面入口
		window.onload = function() {
			comtop.UI.scan();
			$('#gridWrap').height(function(){
				return (document.documentElement.clientHeight || document.body.clientHeight) - 60;		
			});
		}
		
		//初始化数据
		function initData(obj, query) {
			//设置查询条件
			var condition = {
				userId : userId,
				delegatedUserName : keyword,
				pageNo : query.pageNo,
				pageSize : query.pageSize,
				sortFieldName : query.sortName[0],
				sortType : query.sortType[0]
			};
			dwr.TOPEngine.setAsync(false);
			UserDelegateAction.queryDelegateInfoOfUser(condition, function(data) {
				//加载数据源
				obj.setDatasource(data.list, data.count);
			});
			dwr.TOPEngine.setAsync(true);
		}

		//自适应宽度
		function resizeWidth() {
			return $('body').width() - 23;
		}
		//自适应高度
		function resizeHeight() {
		  return (document.documentElement.clientHeight || document.body.clientHeight) - 68;
		}
		
		//渲染链接
		function renderLink(rowData) {
			return '<a style="text-decoration: underline;" href="javascript:showAccess(\''
					+ rowData["consignId"]
					+ '\')">'
					+ rowData["delegatedUserName"] + '</a>';
		}
		//渲染是否有效
		function renderState(rowData) {
			if (rowData["state"] == 1) {
				return "<img src='${pageScope.cuiWebRoot}/top/sys/images/check_out.gif' title='有效'/>";
			} else {
				return "<img src='${pageScope.cuiWebRoot}/top/sys/images/check_in.gif' title='无效'/>";
			}
		}
		//渲染是否委托全部权限
		function renderHasAllAccess(rowData) {
			if (rowData["hasAllAccess"] == 0) {
				return "全部";
			} else {
				return "部分";
			}
		}
		//渲染设置委托权限的图标
		function cosignAccessRenderLink(rowData) {
			
			if (rowData["hasAllAccess"] == 0)  {
				return "<img src='${pageScope.cuiWebRoot}/top/sys/images/setting.png' style='cursor: hand;'  onclick='setConsignAccess();' title='设置委托权限'/>";
			} else {
				return "<img src='${pageScope.cuiWebRoot}/top/sys/images/setting.png' style='cursor: hand;'  onclick='setConsignAccess(\""
				+ rowData["consignId"] + "\");' title='设置委托权限'/>";
			}
			
		}
		//设置委托权限
		function setConsignAccess(consignId) {
			
			if(consignId==null||consignId==''){
				cui.alert("全部委托不需要分配权限！");
				return;
			}
			
			var url = "${pageScope.cuiWebRoot}/top/sys/accesscontrol/userdelegate/ConsignAccess.jsp?userId="
					+ userId + "&consignId=" + consignId;
			var setConsignAccessDialog;
			if (!setConsignAccessDialog) {
				setConsignAccessDialog = cui.dialog({
					title : '设置委托应用',
					src : url,
					width : 600,
					height : 350
				})
			}
			setConsignAccessDialog.show(url);
		}
		//查看委托详情
		function showAccess(consignId) {
			
			if(userId=="SuperAdmin"){
				cui.alert("超级管理员不能进行委托处理！")
				return;
			}
			
			var url = '${pageScope.cuiWebRoot}/top/sys/accesscontrol/userdelegate/ConsignEdit.jsp?userId='
					+ userId;
			if (typeof consignId == "string")
				url += "&consignId=" + consignId;
			if (!dialog) {
				dialog = cui.dialog({
					title : '委托信息',
					src : url,
					width : 550,
					height : 380
				})
			}
			dialog.show(url);
		}
		
		//快速查询
		function iconclick() {
			keyword = handleStr(cui('#myClickInput').getValue());
			cui("#tableList").setQuery({
				pageNo : 1
			});
			cui("#tableList").loadData();
		}

		//删除代理人操作
		function deleteConsignUser() {
			var selectIds = cui("#tableList").getSelectedPrimaryKey();
			if (selectIds == null || selectIds.length == 0) {
				cui.alert("请选择要删除的代理人。");
				return;
			}
			
			cui.confirm("删除代理人也会删除代理的权限,确定要删除这" + selectIds.length + "个代理人吗？",
					{
						onYes : function() {
							dwr.TOPEngine.setAsync(false);
							UserDelegateAction.deleteUserDelegate(
									selectIds, function(data) {
										cui("#tableList").removeData(
												cui("#tableList")
														.getSelectedIndex());
										cui("#tableList").loadData();
										cui.message("删除" + selectIds.length+ "个代理人成功。", "success");
									});
							dwr.TOPEngine.setAsync(true);
						}
					});
		}
		//编辑回调
		function editCallBack(type) {
			if (type == 'add') {
				cui('#myClickInput').setValue('');
				keyword = "";
				cui("#tableList").setQuery({
					pageNo : 1,
					sortType : [],
					sortName : []
				});
				cui("#tableList").loadData();
				cui("#tableList").selectRowsByIndex(0);
			} else {
				cui("#tableList").loadData();
			}
		}
	</script>
</body>
</html>


            