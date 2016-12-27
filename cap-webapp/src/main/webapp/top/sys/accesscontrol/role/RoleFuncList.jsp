
<%
	/**********************************************************************
	 * 角角色资源List
	 * 2014-7-21 杨卫清 新建
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<html>
<head>
<title>应用授权</title>
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css"
	type="text/css">
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/util.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/RoleAction.js"></script>

<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/RoleResourceAction.js"></script>
<script type="text/javascript"
	src='${pageScope.cuiWebRoot}/top/sys/dwr/interface/ModuleAction.js'></script>

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
</style>
</head>
<body>
	<div uitype="bpanel" position="center" id="centerMain"
		header_title="资源列表" height="500">
		<div class="list_header_wrap">
			<div class="top_float_right" style="margin-right: 5px">
				<% if(!isHideSystemBtn){ %>
				<span uitype="button" id="saveFuncId" label="保存" on_click="saveFunc"></span>
				<% } %>
				&nbsp;<span uitype="button" label="关闭" id="closeSelf"
					on_click="closeSelf"></span>
			</div>
		</div>

		<div id="grid_wrap" style="margin-top: 5px">
			<table uitype="grid" id="FuncGrid" sorttype="1" selectrows="no"  lazy="false"
				datasource="initGridData" resizewidth="resizeWidth"
				resizeheight="resizeHeight" colrender="columnRenderer"
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
		var roleId = "<c:out value='${param.roleId}'/>";
		var parentFuncId = "<c:out value='${param.moduleId}'/>";
		var parentFuncType = "MODULE";
		var totalSize = 0;
		var oldCheckFuncIds = "";
		var chooes_type = "<c:out value='${param.chooes_type}'/>";
		//var chooes_type = 0;
		window.onload = function() {
			comtop.UI.scan();
			//cui('#body').setContentURL("left",'${pageScope.cuiWebRoot}/top/sys/accesscontrol/role/SysModuleThree.jsp');
			if (chooes_type == 2) {

				cui("#saveFuncId").hide();
			}

		}
		//关闭窗口
		function closeSelf() {
			window.parent.parent.dialog.hide();
		}
		//Grid组件自适应宽度回调函数，返回高度计算结果即可
		function resizeWidth() {
			return $('body').width() - 5;
		}

		//Grid组件自适应高度回调函数，返回宽度计算结果即可
		function resizeHeight() {
			return (document.documentElement.clientHeight || document.body.clientHeight) - 70;
		}
		var leveOne;
		var leveTwo;
		function columnRenderer(data, field) {
			var fLevel = data["funcLevel"];
			var funcId = data["funcId"];
			
			var isSelect =0;
			if(chooes_type != 2){
				isSelect=data["isSelect"];
			}
			
			
			var funcNodeType = data["funcNodeType"];
			var strImg = getImg(funcNodeType,funcId);
			var funcName = data["funcName"];
			var permissionType = data["permissionType"];
			var isChecked = '';
			if (isSelect == 1) {
				isChecked = "checked";
				oldCheckFuncIds += funcId + ',';

			}
			if (field == 'directoryOne' && fLevel == 1) {
				if (permissionType == 1 || funcNodeType == 1) {
					return funcName;
				} else {
					if (chooes_type == 2) {
						return strImg + funcName;
					} else {
						return "<input type='checkbox' id='checkAll'  checkfunc='checkFunc' name='func'  funcid='"
								+ funcId
								+ "'  onclick='checkAll(this);'"
								+ isChecked + ">&nbsp;" + funcName;
					}
				}
			}
			if (field == 'directoryOne' && fLevel == 2) {
				leveOne = funcId;
				if (permissionType == 1 || funcNodeType == 1) {
					return strImg + funcName;
				} else {
				
					if (chooes_type == 2) {
						return strImg + funcName;
					} else {
						return "<input type='checkbox' checkfunc='checkFunc'  name='menu' funcid='"
								+ funcId
								+ "'id='"
								+ funcId
								+ "' leveone='"
								+ leveOne
								+ "'funcNodeType="
								+ funcNodeType
								+ "  onclick='checkBoxClick(this);'"
								+ isChecked + ">" + strImg + funcName;
					}
				}
			}
			if (field == 'directoryTwo' && fLevel == 3) {
				leveTwo = funcId;
				if (permissionType == 1 || funcNodeType == 1) {
					return strImg + funcName;
				} else {
					if (chooes_type == 2) {
						return strImg + funcName;
					} else {
						
						return "<input type='checkbox' checkfunc='checkFunc' name='page' funcid='"
								+ funcId
								+ "'id='"
								+ funcId
								+ "' leveone='"
								+ leveOne
								+ "' levetwo='"
								+ leveTwo
								+ "'funcNodeType="
								+ funcNodeType
								+ " onclick='checkBoxClick(this);'"
								+ isChecked
								+ ">" + strImg + funcName;
					}
				}

			}
			if (field == 'directoryThree' && fLevel == 4) {
				if (permissionType == 1 || funcNodeType == 1) {
					return strImg + funcName;
				} else {
					if (chooes_type == 2) {
						return strImg + funcName;
					} else {
						return "<input type='checkbox' checkfunc='checkFunc' name='operate' funcid='"
								+ funcId
								+ "'id='"
								+ funcId
								+ "' leveone='"
								+ leveOne
								+ "' levetwo='"
								+ leveTwo
								+ "' levethree='"
								+ funcId
								+ "'funcNodeType="
								+ funcNodeType
								+ " onclick='checkBoxClick(this);'"
								+ isChecked
								+ ">" + strImg + funcName;
					}
				}
			}

		}

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
			if (chooes_type == 2 && globalUserId != "SuperAdmin") {
				RoleResourceAction.queryGradeAdminFuncViewList(parentFuncId,
						parentFuncType, roleId, function(data) {
							totalSize = data.count;
							var dataList = data.list;
							grid.setDatasource(dataList, totalSize);
						});
			} else if (chooes_type == 1 && globalUserId != "SuperAdmin") {
				RoleResourceAction.queryGradeAdminFuncList(parentFuncId, roleId,
						globalUserId, function(data) {
							totalSize = data.count;
							var dataList = data.list;
							grid.setDatasource(dataList, totalSize);
						});
			} else {
				RoleResourceAction.queryFuncList(parentFuncId, parentFuncType,
						roleId, function(data) {
							console.info(data);
							totalSize = data.count;
							var dataList = data.list;
							grid.setDatasource(dataList, totalSize);
						});
			}
		}
		function checkBoxClick(obj) {
			
			var leveoneId = $("#" + obj.id).attr("leveone");//获取选中的页面id
			var levetwoId = $("#" + obj.id).attr("levetwo");
			var levethreeId = $("#" + obj.id).attr("levethree");
			
			 if(levethreeId){
				 if(obj.checked){
					 	$("[levetwo=" + levetwoId + "][name='page']").attr("checked",true);
					 	$("[leveone=" + leveoneId + "][name='menu']").attr("checked",true);
				 }
			}else if(!levethreeId && levetwoId ){
				 if(obj.checked){
					 //if($(obj).attr("funcnodetype")!=4){
					 	$("[leveone=" + leveoneId + "][name='menu']").attr("checked",true);
					 //}
				 }else{
					 $('input[name="operate"][levetwo=' + levetwoId + ']').prop("checked",false);
				 }
			}else if(!obj.checked){
				$('input[name="page"][leveone=' + leveoneId + ']').prop("checked",false);
				$('input[name="operate"][leveone=' + leveoneId + ']').prop("checked",false);
			}
			checkboxAllStatus();
		}
		function checkAll() {
			if ($("#checkAll").prop("checked")) {//判断全选的勾选状态
				$("[name='menu']").attr("checked", 'true');//页面全选
				$("[name='page']").attr("checked", 'true');//页面全选
				
				$("[name='operate']").attr("checked", 'true');//页面全选
			} else {
				$("[name='menu']").removeAttr("checked");//页面全选
				$("[name='page']").removeAttr("checked");//页面全选
				$("[name='operate']").removeAttr("checked");//页面全选
			}
		}
		function checkboxAllStatus() {
			var checkedPageNum = $('input:checked[name=page][funcnodetype!=4]').length;
			var checkedMenuNum = $('input:checked[name=menu][funcnodetype!=4]').length;
			var checkedOperateNum = $('input:checked[name=operate]').length;
			var checkedNum = checkedPageNum + checkedMenuNum
					+ checkedOperateNum;
			//如果是类型为funcnodetype为5 也就是操作类型的父级是Page类型则不算
			$("input:checked[funcnodetype=5]").each(function(i,item){
				var one = $("#img"+$(item).attr("leveone")).attr("funcnodetype");
				var two = $("#img"+$(item).attr("levetwo")).attr("funcnodetype");
				if(one==4 || two==4){
					checkedNum--
				}
			})
			
			if (checkedNum > 0) {
				$("#checkAll").attr("checked", 'true');
			} else {
				$("#checkAll").removeAttr("checked");
			}
		}
		function saveFunc() {
			var funcIds = '';
			var funcIdArray = [];
			var oldFuncIdArray = [];
			$('input[checkfunc="checkFunc"]:checked').each(function() {
				var strType = $(this).attr("funcNodeType");
				if (strType != 1) {
					funcIds += $(this).attr("funcid") + ',';
				}
			});

			funcIds = funcIds.substring(0, funcIds.length - 1);
			if (funcIds != "") {
				funcIdArray = funcIds.split(",");
				funcIdArray = removeRepeatArray(funcIdArray);
			}
			if (oldCheckFuncIds != "") {
				oldFuncIdArray = oldCheckFuncIds.split(",");
				oldFuncIdArray = removeRepeatArray(oldFuncIdArray);
			}
			dwr.TOPEngine.setAsync(false);

			RoleResourceAction.saveResourceAccessRole(roleId, oldFuncIdArray,
					funcIdArray, function(data) {
						window.parent.showFuncList();
						window.parent.cui.message('权限设置成功。',"success");
					});
			dwr.TOPEngine.setAsync(true);
		}

		function addCallBack() {
			//清空查询条件，清除题头排序条件
			cui("#roleGrid").loadData();
		}
		//去除数组的重复数据，可提出到公共方法中
		function removeRepeatArray(array) {
			var temp = {};
			var len = array.length;
			for (var i = 0; i < len; i++) {
				if (typeof temp[array[i]] == "undefined") {
					temp[array[i]] = 1;
				}
			}
			array.length = 0;
			len = 0;
			for ( var i in temp) {
				array[len++] = i;
			}
			return array;
		}
	</script>
</body>
</html>