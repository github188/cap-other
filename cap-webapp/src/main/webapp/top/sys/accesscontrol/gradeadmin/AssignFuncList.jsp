
<%
	/**********************************************************************
	 * �ּ�������Դ������Դ�б�ҳ��
	 * 2014-7-20  л�� �½�
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<title>Ӧ����Ȩ</title>
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css"
	type="text/css">

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
	src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/GradeAdminAction.js"></script>

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
		header_title="��Դ�б�" height="500">

		<div class="list_header_wrap" style="">

			<div class="top_float_right">
				<span uitype="button" id="saveFuncId" label="����" on_click="saveFunc"></span>
			</div>
		</div>

		<div id="grid_wrap">
			<table uitype="grid" id="FuncGrid" sorttype="1" selectrows="no"
				datasource="initGridData" resizewidth="resizeWidth"
				resizeheight="resizeHeight" colrender="columnRenderer"
				pagination="false" titlerender="title" lazy="false">
				<tr>
					<th bindName="directoryOne" renderStyle="text-align: left">������</th>
					<th bindName="directoryTwo" renderStyle="text-align: left">��������</th>
					<th bindName="directoryThree" renderStyle="text-align: left">��ɫ����</th>
				</tr>

			</table>
		</div>
	</div>
	<script type="text/javascript">
		var parentFuncId = "<c:out value='${param.parentFuncId}'/>";
		var subjectId="<c:out value='${param.subjectId}'/>";
		var resourceTypeCode = "FUNC";
		var subjectClassifyCode = "ADMIN";
		var totalSize = 0;
		var oldCheckFuncIds = "";
		$(document).ready(function() {
			comtop.UI.scan();
		});

		//Grid�������Ӧ��Ȼص����������ظ߶ȼ���������
		function resizeWidth() {
			return (document.documentElement.clientWidth || document.body.clientWidth) - 21;
		}

		function saveFunc(){
			var funcIds = '';
			var funcIdArray = [];
			var oldFuncIdArray = [];
			//console.log($('input[checkfunc="checkFunc"]:checked').not(":disabled").length);
			$('input[checkfunc="checkFunc"]:checked').not(":disabled").each(function() {
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

			GradeAdminAction.saveRoleSubjectResource(oldFuncIdArray, funcIdArray,
					subjectId,resourceTypeCode, subjectClassifyCode, globalUserId,
					function(data) {
				         parent.showFuncList();
				         window.parent.cui.message('��Դ��Ȩ�ɹ���','success');
					});
			dwr.TOPEngine.setAsync(true);

		}

		//Grid�������Ӧ�߶Ȼص����������ؿ�ȼ���������
		function resizeHeight() {
			return (document.documentElement.clientHeight || document.body.clientHeight) - 70;
		}
		var leveOne;
		var leveTwo;
		function columnRenderer(data, field) {
			var fLevel = data["funcLevel"];
			var funcId = data["funcId"];
			var isSelect = data["isSelect"];
			var funcNodeType = data["funcNodeType"];
			var strImg = getImg(funcNodeType);
			var funcName = data["funcName"];
			var permissionType = data["permissionType"];
			var isChecked = '';
			if (isSelect == 1) {
				isChecked = "checked";
				oldCheckFuncIds += funcId + ',';

			}
			if (field == 'directoryOne' && fLevel == 1) {
				if(permissionType==1||funcNodeType==1){
					return funcName;
				}else{
				return "<input type='checkbox' id='checkAll' checkfunc='checkFunc' name='func'  funcid='"
						+ funcId
						+ "'  onclick='checkAll(this);'"
						+ isChecked
						+ ">&nbsp;" + funcName;
				}
			}
			if (field == 'directoryOne' && fLevel == 2) {
				leveOne = funcId;
				if(permissionType==1||funcNodeType==1){
					return strImg +funcName;
				}
				else{
				
				return "<input type='checkbox' checkfunc='checkFunc'  name='menu' funcid='"
						+ funcId
						+ "'id='"
						+ funcId
						+ "' leveone='"
						+ leveOne
						+ "'funcNodeType="
						+ funcNodeType
						+ "  onclick='checkBoxClick(this);'"
						+ isChecked
						+ ">"
						+ strImg + funcName;
				}
			}
			if (field == 'directoryTwo' && fLevel == 3) {
				leveTwo = funcId;
				if(permissionType==1||funcNodeType==1){
					return strImg +funcName;
				}
				else{
				
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
						+ isChecked +">" + strImg + funcName;
				}

			}
			if (field == 'directoryThree' && fLevel == 4) {
				if(permissionType==1||funcNodeType==1){
					return strImg +funcName;
				}
				else{
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
						+ ">"
						+ strImg + funcName;
				}
			}
		}

		function getImg(funcNodeType) {
			var strImg = "";
			if (funcNodeType == 1) {
				strImg = "<img src='${pageScope.cuiWebRoot}/top/sys/images/func_menu_dir.gif'/>&nbsp;";
			} else if (funcNodeType == 2) {
				strImg = "<img src='${pageScope.cuiWebRoot}/top/sys/images/func_menu.gif'/>&nbsp;";
			} else if (funcNodeType == 4) {
				strImg = "<img src='${pageScope.cuiWebRoot}/top/sys/images/func_page.gif'/>&nbsp;";
			} else if (funcNodeType == 5) {
				strImg = "<img src='${pageScope.cuiWebRoot}/top/sys/images/func_oper.gif'/>&nbsp;";
			}
			return strImg;
		}
		//��Ⱦ�б�����
		function initGridData(grid, query) {
			cui(".grid-head").hide();
			//����
			if (globalUserId == "SuperAdmin") {
				GradeAdminAction.querySuperAdminFuncList(subjectId,
						parentFuncId, function(data) {
							totalSize = data.count;
							var dataList = data.list;
							grid.setDatasource(dataList, totalSize);
						});
			} else {
				GradeAdminAction.queryGradeAdminFuncList(globalUserId,
						subjectId, parentFuncId, 
						function(data) {
							totalSize = data.count;
							var dataList = data.list;
							grid.setDatasource(dataList, totalSize);
				});
			}
		}
		function checkBoxClick(obj) {
			var leveoneId = $("#" + obj.id).attr("leveone");//��ȡѡ�е�ҳ��id
			var levetwoId = $("#" + obj.id).attr("levetwo");
			var levethreeId = $("#" + obj.id).attr("levethree");
			if (levethreeId != null && obj.checked) {
				$("[levetwo=" + levetwoId + "][name='page']").attr("checked",
						true);
				$("[leveone=" + leveoneId + "][name='menu']").attr("checked",
						true);
				$("[levelthree=" + leveoneId + "][name='operate']").attr(
						"checked", true);
			} else if (levethreeId != null && !obj.checked) {
				$("[levelthree=" + leveoneId + "][name='funcId']").attr(
						"checked", false);
			} else if ((levethreeId == null || levethreeId == '')
					&& levetwoId != null && obj.checked) {
				$("[levetwo=" + levetwoId + "][name='page']").attr("checked",
						true);
				$("[leveone=" + leveoneId + "][name='menu']").attr("checked",
						true);
			} else if ((levethreeId == null || levethreeId == '')
					&& levetwoId != null && !obj.checked) {
				$("[levetwo=" + levetwoId + "][name='page']").attr("checked",
						false);
				$('input[name="operate"][levetwo=' + levetwoId + ']').each(
						function() {
							$(this).attr("checked", false);
						});
			} else if (!obj.checked) {

				$('input[name="page"][leveone=' + leveoneId + ']').each(
						function() {
							$(this).attr("checked", false);
						});
				$('input[name="operate"][leveone=' + leveoneId + ']').each(
						function() {
							$(this).attr("checked", false);
						});
			}
			checkboxAllStatus();
		}
		function checkAll() {
			if ($("#checkAll").prop("checked")) {//�ж�ȫѡ�Ĺ�ѡ״̬
				$("[name='menu']").attr("checked", 'true');//ҳ��ȫѡ
				$("[name='page']").attr("checked", 'true');//ҳ��ȫѡ
				$("[name='operate']").attr("checked", 'true');//ҳ��ȫѡ
			} else {
				$("[name='menu']").removeAttr("checked");//ҳ��ȫѡ
				$("[name='page']").removeAttr("checked");//ҳ��ȫѡ
				$("[name='operate']").removeAttr("checked");//ҳ��ȫѡ
			}
		}
		function checkboxAllStatus() {
			var checkedPageNum = $('input:checked[name=page]').length;
			var checkedMenuNum = $('input:checked[name=menu]').length;
			var checkedOperateNum = $('input:checked[name=operate]').length;
			var checkedNum = checkedPageNum + checkedMenuNum
					+ checkedOperateNum;
			if (checkedNum > 0) {
				$("#checkAll").attr("checked", 'true');
			} else {
				$("#checkAll").removeAttr("checked");
			}
		}

		function addCallBack() {
			//��ղ�ѯ�����������ͷ��������
			cui("#roleGrid").loadData();
		}
		//ȥ��������ظ����ݣ������������������
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