
<%
	/**********************************************************************
	 * 用户资源列表List
	 * 2015-03-27   石刚  新建
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<title>用户资源列表授权</title>
<link rel="stylesheet"	href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet"	href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css"	type="text/css">
<link rel="stylesheet"	href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">
<script type="text/javascript"	src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript"	src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript"	src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript"	src="${pageScope.cuiWebRoot}/top/sys/dwr/util.js"></script>
<script type="text/javascript"	src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/AuthorityFinderAction.js"></script>

<style type="text/css">
img {
	margin-left: 5px;
}

#addRoleButton {
	margin-right: 5px;
}

.grid_container input {
	margin-left: -3px;
}
.post_label {
       display: inline-block;
       padding: 2px 4px;
       font-size: 12px;
       font-weight: bold;
       line-height: 14px;
       color: #fff; 
       vertical-align: baseline;
       white-space: nowrap;
       text-shadow: 0 -1px 0 rgba(0,0,0,0.25);
       border-radius: 3px;
       cursor: pointer;
       margin:2px 5px;
   }
   .post_name_color{
       background-color: #22A7B8; 
   }
   .post_other_name_color{
   	background-color: #38B3E8; 
   }
</style>
</head>
<body>
	<div uitype="bpanel" position="center" id="centerMain" header_title="资源列表" height="500">
		<div class="list_header_wrap">
			<label class="top_float_left" style="display:none">所属岗位角色信息：</label>
			<div class="top_float_left" id="post_div" style="display:none;margin-right: 5px"></div>
			<div class="top_float_right" style="margin-right: 5px">
				<span uitype="button" label="关闭" id="closeSelf" on_click="closeSelf"></span>
			</div>
		</div>
		<div id="grid_wrap" style="margin-top: 5px">
			<table uitype="grid" id="FuncGrid" sorttype="1" selectrows="no"  lazy="false"
				datasource="initGridData" resizewidth="resizeWidth" resizeheight="resizeHeight" colrender="columnRenderer"
				pagination="false" titlerender="title">
				<tr>
					<th bindName="directoryOne" renderStyle="text-align: left"></th>
					<th bindName="directoryTwo" renderStyle="text-align: left"></th>
					<th bindName="directoryThree" renderStyle="text-align: left"></th>
				</tr>
			</table>
		</div>
	</div>
	<script type="text/javascript">
		var funcId = "<c:out value='${param.funcId}'/>";
		var userId = "<c:out value='${param.userId}'/>";
		
		window.onload = function() {
			comtop.UI.scan();
		}
		
		//关闭窗口
		function closeSelf() {
			window.parent.dialog.hide();
		}
		
		//Grid组件自适应宽度回调函数，返回高度计算结果即可
		function resizeWidth() {
			return $('body').width() - 5;
		}

		//Grid组件自适应高度回调函数，返回宽度计算结果即可
		function resizeHeight() {
			return (document.documentElement.clientHeight || document.body.clientHeight) - 70;
		}
		 
		function columnRenderer(data, field) {
			var fLevel = data["funcLevel"];
			var tfuncId = data["funcId"];
			var funcNodeType = data["funcNodeType"];
			var strImg = getImg(funcNodeType,funcId);
			var funcName = data["funcName"];
			//权限模型
			var permissionType = data["permissionType"];
			if(permissionType == 2 && funcNodeType > 1){
				funcName = '<a href=javascript:getAccessList("'+tfuncId+'")>'+ funcName + '</a>'
			}
			if (field == 'directoryOne' && fLevel == 1) {
				return strImg + funcName;
			}
			if (field == 'directoryOne' && fLevel == 2) {
				return strImg + funcName;
			}
			if (field == 'directoryTwo' && fLevel == 3) {
				return strImg + funcName;
			}
			if (field == 'directoryThree' && fLevel == 4) {
				return strImg + funcName; 
			}
		}
		
		//获取当前菜单所属的查询用户的岗位信息
		function getAccessList(tfuncId){
			var condition = {funcId:tfuncId, userId:userId};
			AuthorityFinderAction.queryPersonPostListByFuncId(condition, function(data){
				var postInfo = data;
				if(postInfo&&postInfo.length>0){
	                 var postName = [];
	                 for(var i=0;i<postInfo.length;i++){
	                	 if(postInfo[i].POST_NAME){
	                		 if(postInfo[i].POST_TYPE == 1){
			                     postName.push($('<label class="post_label post_name_color" title="'+postInfo[i].NAME_FULL_PATH+'">'+postInfo[i].POST_NAME+'</label>').data('post-info',postInfo[i]));
	                		 }else{
	                			 postName.push($('<label class="post_label post_other_name_color" title="'+postInfo[i].NAME_FULL_PATH+'">'+postInfo[i].POST_NAME+'</label>').data('post-info',postInfo[i]));
	                		 }
	                	 }
	                 }
	                 $('.top_float_left').show();
	                 $('#post_div').html(postName);
				}else{//无岗位信息，清空
	                 $('.top_float_left').show();
					 $('#post_div').html("无");
				}
			});
		}
		
		 $('#post_div').on('click','.post_label',function(){
		   var postInfo = $(this).data('post-info');
		   cui.dialog({
		       src:webPath + '/top/sys/accesscontrol/authority/RoleListForPost.jsp?postId='+postInfo.POST_ID 
		    		   	+ '&userId='+ userId + '&funcId=' + funcId,
	            refresh:false,
	            modal: true,
	            title: '角色列表',
	            width:600,
	            height:400
		   }).show();
		});


		function getImg(funcNodeType,funcId) {
			var strImg = "";
			if (funcNodeType == 1) {
				strImg = "<img src='${pageScope.cuiWebRoot}/top/sys/images/func_menu_dir.gif'/>&nbsp;";
			} else if (funcNodeType == 2) {
				strImg = "<img src='${pageScope.cuiWebRoot}/top/sys/images/func_menu.gif'/>&nbsp;";
			} else if (funcNodeType == 4) {
				strImg = "<img src='${pageScope.cuiWebRoot}/top/sys/images/func_page.gif' funcnodetype=4 id='img"+funcId+"' />&nbsp;";
			} else if (funcNodeType == 5) {
				strImg = "<img src='${pageScope.cuiWebRoot}/top/sys/images/func_oper.gif'/>&nbsp;";
			}
			return strImg;
		}
		
		//渲染列表数据
		function initGridData(grid, query) {
			cui(".grid-head").hide();
			var condtion = {funcId:funcId,userId:userId};
			AuthorityFinderAction.queryPersonFuncListByUserId(condtion, function(data) {
				var totalSize = data.count;
				var dataList = data.list;
				grid.setDatasource(dataList, totalSize);
			});
		}
	</script>
</body>
</html>