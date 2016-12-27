<%@ page pageEncoding="GBK"%>
<%@ page import="java.util.Date"%>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<%long time = new Date().getTime();%>
		<meta http-equiv="Content-Type" content="text/html;charset=GBK"/>
		<link rel="stylesheet" type="text/css" href="../common/cui/themes/default/css/comtop.ui.min.css?t=<%=time%>">
		<link rel="stylesheet" type="text/css" href="../common/css/userSelect/userSelect.css?t=<%=time%>">

		<style type="text/css">
			body {
				margin: 0px;
			}
			body, #selected_user_table {
				width: 600px;
			}
			.selected_node_text {
				text-align: left;
			}
			.selected_node_text span {
				margin-left: 10px;
			}
		</style>
		
		<script type="text/javascript" src="../common/cui/js/comtop.ui.min.js?t=<%=time%>"></script>
		<script type="text/javascript" src="../common/js/component/jquery/jquery-1.8.2.min.js?t=<%=time%>"></script>
		<script type="text/javascript" src="../common/js/component/jquery/jQuery.md5.js?t=<%=time%>"></script>
		<script type="text/javascript" src="../common/js/userSelect/userSelect_model.js?t=<%=time%>"></script>
		<script type="text/javascript" src="../common/js/userSelect/userSelect.js?t=<%=time%>"></script>
	</head>
	<body>
		<div class="more_container">
			<table cellspacing="0" cellpadding="0" align="center" border="0" id="selected_user_table">
				

			</table>
		</div>
		<script type="text/javascript">
			function getParent() {
				return window.parent;
			}

			function init() {
				var map = getParent().selectedNodeUserMap;
				for (key in map) {
					var node = map[key];
					var users = node.users;
					var nodeKey = node.getKey();
					if (!$('#node_user_' + nodeKey)[0]) {
						$('#selected_user_table').append(getParent().createSelectedNodeHtml(node));
					}
					for(k in users) {
						$('#node_user_' + nodeKey).append(getParent().createSelectedUserHtml(node, users[k]));
					}
				}
				var maxHeight = ((document.body.clientHeight + 10) > 400) ? 400 : (document.body.clientHeight + 10);
				getParent().resizeMoreDialog(maxHeight);
			}
			init();

			function removeUserFromSelectedArea(nodeId, userKey, userId) {
				var node = getParent().selectedNodeUserMap[nodeId];
				var nodeKey = node.getKey();

				getParent().removeUserFromSelectedArea(nodeId, userKey, userId);
				$("#"+userKey).remove();
				if ($("#node_user_" + nodeKey).children().length < 1) {
					$("#tr_"+nodeKey).remove();
				}
			}

			//将是否发送短信赋值到已选用户对象的sendSMS属性
			function smsChecked(userKey, isChecked) {
				getParent().smsChecked(userKey, isChecked);

				//切换本页面的图片
				var objSmsImg = $('#img_sms_'+userKey)[0];
				var isChecked = (objSmsImg.src.indexOf("sms-checked.png") > 0);
				objSmsImg.src= (isChecked) ? smsCannelImgPath : smsCheckedImgPath;
			}

			//将是否发送邮件赋值到已选用户对象的sendEmail属性
			function emailChecked(userKey, isChecked) {
				getParent().emailChecked(userKey, isChecked);

				//切换本页面的图片
				var objEmailImg = $('#img_email_'+userKey)[0];
				var isChecked = (objEmailImg.src.indexOf("email-checked.png") > 0);
				objEmailImg.src= (isChecked) ? emailCannelImgPath : emailCheckedImgPath;
			}
		</script>
	</body>
</html>