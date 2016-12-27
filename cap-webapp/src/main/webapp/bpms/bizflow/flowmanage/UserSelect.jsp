<%@ page pageEncoding="GBK"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.lang.String"%>
<%@ include file="../common/js/userSelect/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
	<head>
		<title>
			<%="false".equals(request.getParameter("isSelectNodeUser")) ? "�����д" : "��Աѡ��"%>
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
			//�ʼ�ѡ���Ƿ�����
			var isEmailColHide = <%=isEmailColHide%>;

			//����ѡ���Ƿ�����
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
			/*��2���Ǹ���cui����ʽ����ͷ��checkbox��IE8����ģʽ�±߿򱻸��ǣ����������λ��*/
			.grid-container .grid-all-checkbox {
				background: url(../common/cui/themes/default/images/checkbox-radio/checkbox-default.png) no-repeat 1px 2px;
			}
			
			.grid-container .grid-all-checkbox-checked {
				background-image : url(../common/cui/themes/default/images/checkbox-radio/checkbox-checked.png)
			}
			
			/*0818�޸�ȱ�� ȥ����body��ʽ����ӹ�����
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
                                    <span uitype="ClickInput" id="userFilter" name="userFilter" editable="true" emptytext="��������Ա������������" on_iconclick="search" on_keydown="searchBarEnterEvent" icon="search"></span>
                                </div>
                            </td>
                            <td>
                                <div id='deptSelect ' class="deptSelect">
                                     <span uitype="Input" label=" ��ѡ���� "  readonly="true"  id="selectedOrgName" ></span>
                                      <span uitype="Button" label=" ѡ���� "  on_click="onClickDemo"></span>
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
						            <th width="12%" renderStyle="text-align: center;" bindName="userName">����</th>
						            <th renderStyle="text-align: left" bindName="userId" hide="true">�û�ID</th>
						            <th renderStyle="text-align: left" bindName="deptId" hide="true">����ID</th>
						            <th renderStyle="text-align: left" bindName="nodeId" hide="true">�ڵ�ID</th>
						            <th width="64%" renderStyle="text-align: left" bindName="deptPath">����</th>
						            <th width="20%" renderStyle="text-align: left" bindName="postName">��λ</th>
						        </tr>
					        </thead>
						</table>
					</div>
				</div>
			</div>

			<div id="middle_area" class="middle_area">
				<div class="selected_text">
					<div class="selected_control_area">
						<input type="button" id="see_all" value="�鿴ȫ��" onclick="more();"/>
						<%
						if ("false".equals(isSmsColHide) || "false".equals(isEmailColHide)) {
						%>
							֪ͨ��ʽ��
						<%
						}
						if ("false".equals(isSmsColHide)) {
						%>
							<label>
								<input type="checkbox" id="sms_img_all" class="checkbox_all" onclick="smsCheckedAll(this)"/>����<img src="../common/images/userSelect/sms-checked.png"></img>
							</label>
						<%
						}
						if ("false".equals(isEmailColHide)) {
						%>
							<label>
								<input type="checkbox" id="email_img_all" class="checkbox_all" onclick="emailCheckedAll(this)" />�ʼ�<img src="../common/images/userSelect/email-checked.png"></img>
							</label>
						<%
						}
						%>
					</div>
					<span>&nbsp;&nbsp;<b>��ѡ��Ա��</b></span>
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
								<div class="textarea_warn"><b>ע��</b>�������</div>
								<font color="red">*</font><b>�ҵ������</b>
								<span uitype="RadioGroup" value="1" id="opinionRadioGroup" name="opinionRadioGroup" on_change="opinionChange">
									<input type="radio" id="foreOpinion" value="1" text="ͬ��"/>
				    				<input type="radio" id="backOpinion" value="0" text="��ͬ��" />
								</span>
							</div>
						</td>
					</tr>
					<tr id="myOpinionTextTr">
						<td>
							<span uitype="Textarea" id="opinion" relation="relation" maxlength="500" width="730px" height="80px" emptytext="����д���" byte="false"></span>
						</td>
					</tr>
					<tr>
						<td class="buttons">
							<div class="textarea_notice">
								����������<label id="relation" style="color: red;"></label>����
							</div>
							<input id="btnDetermine" type="Button" value=" ȷ�� " style="height: 26px;display: inline-block;cursor: pointer;" onclick="submit()"/>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="Button" value=" ȡ�� " style="height: 26px;display: inline-block;cursor: pointer;"onclick="cancel()"/>
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
			//�������ͣ��·������˵ȣ�
			var actionType = '<%=request.getParameter("actionType")%>'; 

			//����ֵ�����ˣ�
			var opinionForceBack = <%=request.getParameter("opinionForceBack")%>; 
			
			var winWidth = <%=request.getParameter("winWidth")%>;
			var winHeight = <%=request.getParameter("winHeight")%>;
			
			//�Ƿ�ѡ��
			var isSelectNodeUser = <%=request.getParameter("isSelectNodeUser")%>; 

			//���ۺ�����Ƿ���ʾ
			var isOpinionDisplay = <%=request.getParameter("isOpinionDisplay")%>;

			//����Ƿ����
			var isOpinionRequired = <%=request.getParameter("isOpinionRequired")%>; 

			//�Ƿ����ƽ���ֵ���磺����ʱ���Ƿ�����ǲ�ͬ�⣬����ʱ������ͬ��
			var isLimitOpinionValue = <%=request.getParameter("isLimitOpinionValue")%>;
			
			//�Ƿ���ʾѡ���ŵĿ�
			var isViewSelectDept =<%=request.getParameter("isViewSelectDept")%>; 
			//ҵ�񵥱��
			var recordId = '<%=request.getParameter("recordId")%>'; 
			
			//������
			var taskId = '<%=request.getParameter("taskId")%>';

			<%
			String sameOrgUserOrgStructureId = request.getParameter("sameOrgUserOrgStructureId");
			sameOrgUserOrgStructureId = (null == sameOrgUserOrgStructureId) ? "" : sameOrgUserOrgStructureId;
			String sameOrgUserDeptPath = request.getParameter("sameOrgUserDeptPath");
			sameOrgUserDeptPath = (null == sameOrgUserDeptPath) ? "" : sameOrgUserDeptPath;
			%>

            //ͬ���û���֯id����ʾ����ѡ���ʱ��Ҫ�õ�
            var sameOrgUserOrgStructureId = '<%=sameOrgUserOrgStructureId%>';
			var tempSameOrgUserOrgStructureId = sameOrgUserOrgStructureId;

			//ͬ���û���������
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
			
			//�Ƿ���ʾ���ſ�
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

            //�Ӹ�ҳ���ȡ�ڵ��б�json����
            var nodeinfolist = null;
			//�Ƿ�Ϊ��ѡ�ڵ�
			var isSingleSelect = <%=request.getParameter("isSingleSelect")%>;
            if (isSelectNodeUser) {
            	nodeinfolist = window.opener.getNodeInfoList(taskId,recordId);
            	if (true != isSingleSelect && false != isSingleSelect) {
					isSingleSelect = isNodeSingleSelect(nodeinfolist); //��ҵ��ҳ���ȡ��ѡ��ѡ(false/true) 
				}
            }

            //��ȡ�����ڵ���������Ա����ǰ̨��ҳ������»��ô˺�����ȡ�������˺���ǰ̨���з�ҳ��
            function getNodeAllUsers(currSelectNodeId,version,nameKeyWord,orgId){
                return window.opener.getNodeAllUsers(currSelectNodeId,version,nameKeyWord,orgId,taskId,recordId);
            }
			var a = true;
			//�ύ����
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

			    		//�������ʾʱ��Ҳ����ֵ
			    		if (!isOpinionDisplay) {
			    			window.opener.bpmsUserSelectCallback(null, null, JSON.stringify(chosenNodes), actionType);	
			    		} else {
			    			window.opener.bpmsUserSelectCallback(cui("#opinionRadioGroup").getText(), 
			    				cui("#opinion").getValue(), JSON.stringify(chosenNodes), actionType);	
			    		};
			    	} else {
			    		//ҵ��У��ʧ��
			    		validateResult = (undefined == validateResult || '' == validateResult) ? "\u4e1a\u52a1\u6821\u9a8c\u5931\u8d25" : validateResult;
						cui.alert(validateResult);
						$("#btnDetermine").removeAttr('disabled');
			    	}
		    	}else{
			    	$("#btnDetermine").removeAttr('disabled');
		    	}
		    }

		  	//ȡ������
		    function cancel() {
		    	if (window.opener.cancel) {
					window.opener.cancel();
				}
		    	window.close();
		    }
			
			//����Ҫ��ȡ��ҳ������������Ϣ�����ӵ��������
			function getOpinionFromOtherPage() {
				if (window.opener.getOpinionInfo) {
					return window.opener.getOpinionInfo();
				}
				return '';
			}

			//��ҵ��ҳ���ȡ��ѡ��ѡ(false/true)
			function isNodeSingleSelect(nodeinfolist) {
				if (window.opener.isNodeSingleSelect) {
					return window.opener.isNodeSingleSelect(nodeinfolist);
				}
				return true; //Ĭ���ǵ�ѡ
			}

			function businessValidate(selectedNodeUserMap) {
				if (window.opener.businessValidate) {
					return window.opener.businessValidate(selectedNodeUserMap);
				}
				return true;
			}
			
			comtop.UI.scan();
			
			//�������ѡ���ʼֵ
			var rg = cui("#opinionRadioGroup");
			rg.setValue(1);                        //ͳһ�����ó�ͬ��
			if (actionType.indexOf('Back') != -1 || actionType.indexOf('back') != -1) {//���˲���ʱ����Ϊ��ͬ�⣬ͬ��ֻ��
				rg.setValue(0);
				rg.setReadonly(true, ['1']);
			} else if (actionType.indexOf('Fore') != -1 || actionType.indexOf('fore') != -1) {//���Ͳ���ʱ����Ϊͬ�⣬��ͬ��ֻ��
				rg.setReadonly(true, ['0']);
			} else if (actionType.indexOf('Entry') != -1 || actionType.indexOf('entry') != -1) {//�ϱ�����ʱ��������
				rg.hide();
			}
			if(opinionForceBack && null != opinionForceBack && true == opinionForceBack){
				rg.setValue(0);
				rg.setReadonly(true, ['1']);
			}
			opinionChange(cui("#opinionRadioGroup").getValue());
			
			if (nodeinfolist != null && nodeinfolist.length > 0 && null != nodeinfolist[0]) {
				init();//��ʼ���ڵ��б�
				
                for (var n = 0; n < nodeinfolist.length; n++) {
                    var nodeInfo =  nodeinfolist[n];
                    if (nodeInfo.nodeType == 'USERTASK') {
                        switchNode(n); //Ĭ��ѡ�е�һ���ڵ㣬�˴�Ӧ��Ĭ�Ϲ�ѡ��һ���û�����ڵ�
                        break;
                    }
                }
                //��ֻ��һ������Ա�ڵ�ʱ��Ĭ�Ϲ�ѡ��
                if (nodeinfolist.length == 1 && nodeinfolist[0].nodeType != "USERTASK") {
                $(".specialNodeText input")[0].checked = true;
                    checkedSpecialNode(nodeinfolist[0].nodeId, true);
                }
			}
			
			//��Table��Button���ID����
			$(document).ready(function() {
				$(".grid-head table").attr("id","userSelectTableHeader");
				$("#submitBtn span").attr("id","submitBtnSpan");
			});
			
		</script>
	</body>
</html>