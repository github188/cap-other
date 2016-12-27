<%@ page pageEncoding="GBK"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.lang.String"%>
<%@ include file="../common/js/userSelect/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
	<head>
		<title>
			<%="false".equals(request.getParameter("isSelectNodeUser")) ? "意见填写" : "人员选择"%>
		</title>
		<%long time = new Date().getTime();%>		
		<link rel="stylesheet" type="text/css" href="../common/cui/themes/default/css/comtop.ui.min.css?t=<%=time%>">
		<link rel="stylesheet" type="text/css" href="../common/css/userSelect/userSelect.css?t=<%=time%>">
		<script type="text/javascript">
		 	<%
				String isSmsColHide = request.getParameter("isSmsColHide");
				String isEmailColHide = request.getParameter("isEmailColHide");
		 		isEmailColHide = ("false".equals(isEmailColHide) || "true".equals(isEmailColHide)) ? isEmailColHide : "false";
		 		isSmsColHide = ("false".equals(isSmsColHide) || "true".equals(isSmsColHide)) ? isSmsColHide : "false";
		 	%>
			//邮件选项是否隐藏
			var isEmailColHide = <%=isEmailColHide%>;

			//短信选项是否隐藏
			var isSmsColHide = <%=isSmsColHide%>;

			var loginInterval = setInterval(function(){
				if(localStorage.isLogout==='true'){
					window.opener = null;
					window.top.open('','_self');
					window.top.close();
					clearInterval(loginInterval);
				}
			},1000);
		</script>
		
		<script type="text/javascript" src="../common/cui/js/comtop.ui.min.js?t=<%=time%>"></script>
		<script type="text/javascript" src="../common/js/component/jquery/jquery-1.8.2.min.js?t=<%=time%>"></script>
		<script type="text/javascript" src="../common/js/component/jquery/jQuery.md5.js?t=<%=time%>"></script>
		<script type="text/javascript" src="../common/js/userSelect/json2.js?t=<%=time%>"></script>
		<script type="text/javascript" src="../common/js/userSelect/userSelect_model.js?t=<%=time%>" encode="GBK"></script>
		<script type="text/javascript" src="../common/js/userSelect/userSelect.js?t=<%=time%>" encode="GBK"></script>
		<script type="text/javascript" src="../common/js/userSelect/validate.js?t=<%=time%>" encode="GBK"></script>
        <script type="text/javascript" src="../common/js/userSelect/userOrgUtil.js?t=<%=time%>" encode="GBK"></script>
		<script  type="text/javascript" src="../common/js/userSelect/choose.js?t=<%=time%>" cuiTemplate="choose.html" encode="GBK"></script> 				        
		<style type="text/css">
			/*这2个是覆盖cui的样式，表头的checkbox在IE8兼容模式下边框被覆盖，这里调整下位置*/
			.grid-container .grid-all-checkbox {
				background: url(../common/cui/themes/default/images/checkbox-radio/checkbox-default.png) no-repeat 1px 2px;
			}
			
			.grid-container .grid-all-checkbox-checked {
				background-image : url(../common/cui/themes/default/images/checkbox-radio/checkbox-checked.png)
			}
			
			/*0818修改缺陷 去除该body样式，添加滚动条
			body {
				overflow: hidden;
			}*/
		</style>
	</head>
	<body>
		<div class="main_container">
			<div class="top_area">
				<div class="top_left">
					<ul id="node">
					</ul>
				</div>
				<div class="top_right">
                    <table border="0" cellspacing="0">
                        <tr>
                            <td><div class="search_bar">
                                    <span uitype="ClickInput" id="userFilter" name="userFilter" editable="true" emptytext="请输入人员姓名或部门名称" on_iconclick="search" on_keydown="searchBarEnterEvent" icon="search"></span>
                                </div>
                            </td>
                            <td>
                                <div id='deptSelect ' class="deptSelect">
                                     <span uitype="Input" label=" 所选部门 "  readonly="true"  id="selectedOrgName" ></span>
                                      <span uitype="Button" label=" 选择部门 "  on_click="onClickDemo"></span>
                                </div>
                            </td>
                        </tr>
                    </table>
					<div class="user_list">
						<table id="user_list_table" uitype="grid" resizewidth="resizeWidth" gridheight="270px"
                                selectrows="multi" pagination="true" pagination_model="pagination_min_4" pagesize_list="[8, 20, 50]" primarykey="userId"
                                pagesize="50" pageno="1" colhidden="false"  datasource="initDataSource" lazy="false"
						        selectall_callback="selectAll" rowclick_callback="clickCallback">
					        <thead>
						        <tr>
						        	<th width="4%"><input type="checkbox" checked=true /></th>
						            <th width="12%" renderStyle="text-align: center;" bindName="userName">姓名</th>
						            <th renderStyle="text-align: left" bindName="userId" hide="true">用户ID</th>
						            <th renderStyle="text-align: left" bindName="deptId" hide="true">部门ID</th>
						            <th renderStyle="text-align: left" bindName="nodeId" hide="true">节点ID</th>
						            <th width="64%" renderStyle="text-align: left" bindName="deptPath">部门</th>
						            <th width="20%" renderStyle="text-align: left" bindName="postName">岗位</th>
						        </tr>
					        </thead>
						</table>
					</div>
				</div>
			</div>

			<div id="middle_area" class="middle_area">
				<div class="selected_text">
					<div class="selected_control_area">
						<input type="button" id="see_all" value="查看全部" onclick="more();"/>
						<%
						if ("false".equals(isSmsColHide) || "false".equals(isEmailColHide)) {
						%>
							通知方式：
						<%
						}
						if ("false".equals(isSmsColHide)) {
						%>
							<label>
								<input type="checkbox" id="sms_img_all" class="checkbox_all" onclick="smsCheckedAll(this)"/>短信<img src="../common/images/userSelect/sms-checked.png"></img>
							</label>
						<%
						}
						if ("false".equals(isEmailColHide)) {
						%>
							<label>
								<input type="checkbox" id="email_img_all" class="checkbox_all" onclick="emailCheckedAll(this)" />邮件<img src="../common/images/userSelect/email-checked.png"></img>
							</label>
						<%
						}
						%>
					</div>
					<span>&nbsp;&nbsp;<b>已选人员：</b></span>
				</div>
				<div class="selected_user_area" onselectstart="return false">
					<table cellspacing="0" cellpadding="0" align="align" border="0" id="selected_user_table"></table>
				</div>
			</div>
			<div id="div_line"></div>
			<div class="bottom_area">
				<table cellspacing="0" cellpadding="0" align="center" border="0" width="100%">
					<tr id="myOpinionTr">
						<td>
							<div id="myOpinionDiv">
								<div class="textarea_warn"><b>注：</b>意见必填</div>
								<font color="red">*</font><b>我的意见：</b>
								<span uitype="RadioGroup" value="1" id="opinionRadioGroup" name="opinionRadioGroup" on_change="opinionChange">
									<input type="radio" id="foreOpinion" value="1" text="同意"/>
				    				<input type="radio" id="backOpinion" value="0" text="不同意" />
								</span>
							</div>
						</td>
					</tr>
					<tr id="myOpinionTextTr">
						<td>
							<span uitype="Textarea" id="opinion" relation="relation" maxlength="500" width="730px" height="80px" emptytext="请填写意见" byte="false"></span>
						</td>
					</tr>
					<tr>
						<td class="buttons">
							<div class="textarea_notice">
								您还能输入<label id="relation" style="color: red;"></label>个字
							</div>
							<input id="btnDetermine" type="Button" value=" 确定 " style="height: 26px;display: inline-block;cursor: pointer;" onclick="submit()"/>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="Button" value=" 取消 " style="height: 26px;display: inline-block;cursor: pointer;"onclick="cancel()"/>
						</td>
					</tr>
				</table>
			</div>
			<div id="more_div" class="moreUserDialog"></div>
		</div>
		
		<script type="text/javascript">
			<%
			request.setCharacterEncoding("GBK");
			response.setContentType("text/html;charset=GBK");
			%>
			//操作类型（下发、回退等）
			var actionType = '<%=request.getParameter("actionType")%>'; 

			//结论值（回退）
			var opinionForceBack = <%=request.getParameter("opinionForceBack")%>; 
			
			var winWidth = <%=request.getParameter("winWidth")%>;
			var winHeight = <%=request.getParameter("winHeight")%>;
			
			//是否选人
			var isSelectNodeUser = <%=request.getParameter("isSelectNodeUser")%>; 

			//结论和意见是否显示
			var isOpinionDisplay = <%=request.getParameter("isOpinionDisplay")%>;

			//意见是否必填
			var isOpinionRequired = <%=request.getParameter("isOpinionRequired")%>; 

			//是否限制结论值，如：回退时，是否必须是不同意，发送时必须是同意
			var isLimitOpinionValue = <%=request.getParameter("isLimitOpinionValue")%>;
			
			//是否显示选择部门的框
			var isViewSelectDept =<%=request.getParameter("isViewSelectDept")%>; 
			//业务单编号
			var recordId = '<%=request.getParameter("recordId")%>'; 
			
			//任务编号
			var taskId = '<%=request.getParameter("taskId")%>';

			<%
			String sameOrgUserOrgStructureId = request.getParameter("sameOrgUserOrgStructureId");
			sameOrgUserOrgStructureId = (null == sameOrgUserOrgStructureId) ? "" : sameOrgUserOrgStructureId;
			String sameOrgUserDeptPath = request.getParameter("sameOrgUserDeptPath");
			sameOrgUserDeptPath = (null == sameOrgUserDeptPath) ? "" : sameOrgUserDeptPath;
			%>

            //同组用户组织id，显示部门选择框时需要用到
            var sameOrgUserOrgStructureId = '<%=sameOrgUserOrgStructureId%>';
			var tempSameOrgUserOrgStructureId = sameOrgUserOrgStructureId;

			//同组用户部门名称
			var sameOrgUserDeptPath = '<%=sameOrgUserDeptPath%>';
			var tempSameOrgUserDeptPath = sameOrgUserDeptPath;


			if (null != isOpinionDisplay && !isOpinionDisplay) {
				$("#myOpinionTr").hide();
				$("#myOpinionTextTr").hide();
				$(".textarea_notice").hide();
				$(".bottom_area").css("height", "47px");
			}

			if (true == isOpinionRequired) {
				$(".textarea_warn").show();
			}
			
			//是否显示部门框
			if (null == isViewSelectDept || isViewSelectDept == false) {
				$(".deptSelect").hide();
			}else if(null != sameOrgUserDeptPath){
                sameOrgUserDeptPath = (sameOrgUserDeptPath == undefined) ? "" : sameOrgUserDeptPath;
                document.getElementById("selectedOrgName").value = sameOrgUserDeptPath;
            }
			
			if (null != isSelectNodeUser && !isSelectNodeUser) {
				$(".top_area").hide();
				$("#middle_area").hide();
				$("#div_line").hide();
			}

            //从父页面获取节点列表json数据
            var nodeinfolist = null;
			//是否为单选节点
			var isSingleSelect = <%=request.getParameter("isSingleSelect")%>;
            if (isSelectNodeUser) {
            	nodeinfolist = window.opener.getNodeInfoList(taskId,recordId);
            	if (true != isSingleSelect && false != isSingleSelect) {
					isSingleSelect = isNodeSingleSelect(nodeinfolist); //从业务页面获取单选多选(false/true) 
				}
            }

            //获取单个节点上所有人员（在前台分页的情况下会用此函数，取到所有人后在前台进行分页）
            function getNodeAllUsers(currSelectNodeId,version,nameKeyWord,orgId){
                return window.opener.getNodeAllUsers(currSelectNodeId,version,nameKeyWord,orgId,taskId,recordId);
            }
			var a = true;
			//提交数据
		    function submit() {
			    $("#btnDetermine").attr('disabled','true');
				
		    	if (validate()) {
					
		    		var chosenNodes = [];
				    var chosenUsers = [];
				    var node;
				    for (key in selectedNodeUserMap) {
				        node = selectedNodeUserMap[key];
				        var node_json = {};
				        node_json.nodeId = node.nodeId;
				        node_json.nodeName = node.nodeName;
				        node_json.nodeType = node.nodeType;
				        node_json.nodeInstanceId = node.nodeInstanceId;
				        node_json.processId = node.processId;
				        node_json.processVersion = node.processVersion;
				        node_json.cooperationFlag = node.cooperationFlag;
				        node_json.cooperationId = node.cooperationId;

				        var users = node.users;
				        for (k in users) {
				            var user = users[k];
				            var user_json = {};
				            user_json.userId = user.userId;
				            user_json.userName = user.userName;
				            user_json.deptId = user.deptId;
				            user_json.deptPath = user.deptPath;
				            user_json.sendSMS = user.sendSMS;
				            user_json.sendEmail = user.sendEmail;
				            user_json.sendSMS = user.sendSMS;
				            chosenUsers.push(user_json);
				        }

				        node_json.users = chosenUsers;
				        chosenUsers = [];
				        chosenNodes.push(node_json);
				    }

				    var validateResult = businessValidate(JSON.stringify(chosenNodes));
				    if (true == validateResult) {
			    		window.close();

			    		//意见不显示时，也不传值
			    		if (!isOpinionDisplay) {
			    			window.opener.bpmsUserSelectCallback(null, null, JSON.stringify(chosenNodes), actionType);	
			    		} else {
			    			window.opener.bpmsUserSelectCallback(cui("#opinionRadioGroup").getText(), 
			    				cui("#opinion").getValue(), JSON.stringify(chosenNodes), actionType);	
			    		};
			    	} else {
			    		//业务校验失败
			    		validateResult = (undefined == validateResult || '' == validateResult) ? "\u4e1a\u52a1\u6821\u9a8c\u5931\u8d25" : validateResult;
						cui.alert(validateResult);
						$("#btnDetermine").removeAttr('disabled');
			    	}
		    	}else{
			    	$("#btnDetermine").removeAttr('disabled');
		    	}
		    }

		  	//取消操作
		    function cancel() {
		    	if (window.opener.cancel) {
					window.opener.cancel();
				}
		    	window.close();
		    }
			
			//这里要获取父页面的流程意见信息，并加到意见框里
			function getOpinionFromOtherPage() {
				if (window.opener.getOpinionInfo) {
					return window.opener.getOpinionInfo();
				}
				return '';
			}

			//从业务页面获取单选多选(false/true)
			function isNodeSingleSelect(nodeinfolist) {
				if (window.opener.isNodeSingleSelect) {
					return window.opener.isNodeSingleSelect(nodeinfolist);
				}
				return true; //默认是单选
			}

			function businessValidate(selectedNodeUserMap) {
				if (window.opener.businessValidate) {
					return window.opener.businessValidate(selectedNodeUserMap);
				}
				return true;
			}
			
			comtop.UI.scan();
			
			//设置意见选择初始值
			var rg = cui("#opinionRadioGroup");
			rg.setValue(1);                        //统一先设置成同意
			if (actionType.indexOf('Back') != -1 || actionType.indexOf('back') != -1) {//回退操作时结论为不同意，同意只读
				rg.setValue(0);
				rg.setReadonly(true, ['1']);
			} else if (actionType.indexOf('Fore') != -1 || actionType.indexOf('fore') != -1) {//发送操作时结论为同意，不同意只读
				rg.setReadonly(true, ['0']);
			} else if (actionType.indexOf('Entry') != -1 || actionType.indexOf('entry') != -1) {//上报操作时结论隐藏
				rg.hide();
			}
			if(opinionForceBack && null != opinionForceBack && true == opinionForceBack){
				rg.setValue(0);
				rg.setReadonly(true, ['1']);
			}
			opinionChange(cui("#opinionRadioGroup").getValue());
			
			if (nodeinfolist != null && nodeinfolist.length > 0 && null != nodeinfolist[0]) {
				init();//初始化节点列表
				
                for (var n = 0; n < nodeinfolist.length; n++) {
                    var nodeInfo =  nodeinfolist[n];
                    if (nodeInfo.nodeType == 'USERTASK') {
                        switchNode(n); //默认选中第一个节点，此处应该默认勾选第一个用户任务节点
                        break;
                    }
                }
                //当只有一个非人员节点时，默认勾选上
                if (nodeinfolist.length == 1 && nodeinfolist[0].nodeType != "USERTASK") {
                $(".specialNodeText input")[0].checked = true;
                    checkedSpecialNode(nodeinfolist[0].nodeId, true);
                }
			}
			
			//给Table和Button添加ID属性
			$(document).ready(function() {
				$(".grid-head table").attr("id","userSelectTableHeader");
				$("#submitBtn span").attr("id","submitBtnSpan");
			});
			
		</script>
	</body>
</html>