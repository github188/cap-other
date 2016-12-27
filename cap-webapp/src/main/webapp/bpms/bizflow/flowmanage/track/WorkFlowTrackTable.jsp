<%@ page contentType="text/html; charset=GBK" %>
<%@page import="com.comtop.lcam.flowtrack.util.StringUtils"%>
<%@page import="com.comtop.lcam.flowtrack.service.IWorkFlowUtilBizService"%>
<%@page import="com.comtop.lcam.flowtrack.service.impl.WorkFlowUtilBizService"%>	
<%@page import="com.comtop.lcam.flowtrack.artifacts.WorkFlowControl"%>
<%@page import="com.comtop.lcam.flowtrack.artifacts.WorkFlowTrackVO"%>
<%@page import="com.comtop.lcam.flowtrack.engine.FinalNote"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.comtop.lcam.flowtrack.artifacts.WorkFlowConclusion"%>
<%@page import="com.comtop.lcam.flowtrack.flowinteract.util.WorkFlowTrackUtil"%>
<%@page import="com.comtop.lcam.flowtrack.flowinteract.model.RemoteActivityInfo"%>
<%@page import="com.comtop.lcam.flowtrack.flowinteract.model.WorkFlowTrackInfo"%>
<%@page import="com.comtop.lcam.flowtrack.flowinteract.util.FlowInteractUtil"%>
<%@page import="com.comtop.lcam.flowtrack.artifacts.WorkFlowCoopeRationVO"%>
<%@page buffer="1024kb"%>
<%@page import="com.comtop.lcam.flowtrack.flowinteract.util.WorkFlowSupportUtil"%>
<%@page import="com.comtop.lcam.flowtrack.flowinteract.interact.WFSystemMappingHelper"%>

<%@page import="java.util.Iterator"%>
<%

String strModulePath = request.getParameter("pModulePath");
            if (null != strModulePath && !"".equals(strModulePath)) {
                if (!strModulePath.startsWith("/")) {
                    strModulePath = "/" + strModulePath;
                }
            } else if (null == strModulePath) {
                strModulePath = "";
            }
            boolean bNewWindow = false;
           // String strNewWindow = request.getParameter("newWindow");
            //if ("true".equals(strNewWindow)) {
            //    bNewWindow = true;
           // }
%>
<html>
<head>
<title>���������ٱ�</title>
<link rel="stylesheet" type="text/css" href="../../common/css/flowtrack-style.css" ></link>
<link rel="stylesheet" type="text/css" href="../../common/css/ct-style.css" ></link>
<style type="text/css">
.arrow{
    padding: 1px;
    text-align: center;
}

.branch{
    margin: 2px;
 }

.break-word{
	word-break:break-all;
	word-wrap:break-word;
}

/*���� ���屳��ɫֵ #f5f5f5*/
.table_list tbody{
 background-color:#f5f5f5;
 font-size:12px;
 color:#000;
 font-family:"\u5b8b\u4f53";
}

.table_list {
	VERTICAL-ALIGN: top;
	WIDTH: 100%;
	BORDER-COLLAPSE: collapse;
    border:1px solid #ccc;border-right:none;border-bottom:none;
}

.table_list td {
	FONT-SIZE: 9pt;
	HEIGHT: 26px;
	FONT-FAMILY: Verdana;
	BORDER-COLLAPSE: separate;
	EMPTY-CELLS: show;
	PADDING-LEFT: 0px;
	vertical-align: middle;
	border:1px solid #ccc;border-top:none;border-left:none;
}

</style>
<script type="text/javascript">
<%if(!bNewWindow){%>
	setInterval("adjustPage()",500);
<%}%>

	//����Ӧ��С
	function  adjustPage() {
		var w=0;
		var h=0;
		//���try...catch,�޸��ʲ�ϵͳ��EIPҳ�漯��ʱ��ָ��������Աѡ������
		try{
	        if(self.location!=top.location) {
	        	try{
		            this.frameElement.width = "100%";
		            this.frameElement.height = document.body.scrollHeight + h;
		             }catch(e){
	            	// ���ڹ�Ӧ�������������ƻ�������ģ���漰���Ĳ鿴����ҳ�棺������������Ƕ����һ����
	
	             }
	        }
		}catch(e){
		}
	}

	function fitPage(iframe) {
	    if(iframe.Document.body != null){
		iframe.height = iframe.Document.body.scrollHeight;
		}
		if(!<%=bNewWindow%>){
			adjustPage();
		}
	}

	function showRemoteNodeFlow(td, nodeId, flowId, workId, controlId, sysName) {
		var divs = td.getElementsByTagName("div");
		var vShowDiv = divs['showDiv'];
		var vHiddenDiv = divs['hiddenDiv'];
		var vShowDivTip = divs['showDivTip'];
		var vHiddenDivTip = divs['hiddenDivTip'];
		var vContainer = divs['container'];

		if (vHiddenDiv.style.display == "none") {
			vShowDiv.style.display = "none";
			vShowDivTip.style.display = "none";
			if (vHiddenDiv.innerHTML == 0) {
				// ��û��Զ�̽ڵ�����ϸ�ڣ���ȥ��̨ȡ
				var vSrc = "RemoteNodeTrack.jsp?pModulePath=<%=strModulePath%>&nodeId=" + nodeId + "&flowId=" + flowId + "&workId=" + workId + "&flowControlId=" + controlId + "&sysName=" + sysName;
				vHiddenDiv.innerHTML = "<iframe onreadystatechange=fitPage(this) id='" + controlId + "' width=100% height=auto frameborder=0 scrolling=yes src='" + vSrc + "'></iframe>";
			}
			vHiddenDiv.style.display = "block";
			vHiddenDivTip.style.display = "block";
			vContainer.className = "table_node_frame02";
		} else {
			vHiddenDiv.style.display = "none";
			vShowDiv.style.display = "block";
			vHiddenDivTip.style.display = "none";
			vShowDivTip.style.display = "block";
			vContainer.className = "table_node_frame01";
		}
		if(!<%=bNewWindow%>){
			adjustPage();
		}
	}

//--������ӡ--  2012-2-28 Ф����
 function doPrint(){
 	try {
	 	PageSetup_default();
	 	document.getElementById("printPart").style.display="none";
	    var WebBrowser = document.getElementById("WebBrowser1");
		WebBrowser1.ExecWB(6,1);
	}catch(e){
		alert("��ӡ�ؼ�û�м��ػ���ز��ɹ�������������ؼ��������У�");
	}
	document.getElementById("printPart").style.display="";
    }

//--������ӡԤ��--  2012-2-28 Ф����
function preview(){
	try {
		PageSetup_default();
		document.getElementById("printPart").style.display="none";
	 	var WebBrowser = document.getElementById("WebBrowser1");
		WebBrowser1.ExecWB(7,1);
	}catch(e){
		alert("��ӡ�ؼ�û�м��ػ���ز��ɹ�������������ؼ��������У�");
	}
	document.getElementById("printPart").style.display="";
}

	// ȥ����ҳ��ӡ��ҳüҳ��
	function PageSetup_Null(){
	    try {
            var Wsh=new ActiveXObject("WScript.Shell");
		    HKEY_Key="header";
		    Wsh.RegWrite(HKEY_Root+HKEY_Key,"");
		    HKEY_Key="footer";
		    Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"");
	    } catch(e){}
    }

	// ���Ӵ�ӡ��ҳüҳ�ţ��˴�ȥ����ҳ���еĵ�ַ&u
    function PageSetup_default(){
	    try {
            var Wsh=new ActiveXObject("WScript.Shell");
		    HKEY_Key="header";
		    Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"&w&bҳ��,&p/&P");
		    HKEY_Key="footer";
		    Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"&b&d");
	    } catch(e){}
    }

/*
 * ����������� 2012-3-8 Ф����
 * param moduleKey String ģ��Code
 * param moduleObjectId String ����ID
 * param rightFlag Ȩ�ޱ�־,����ʱ����ʹ��com.comtop.ss.attachment.AttachmentConstants�ж����Ȩ�޳���
 */
function openAttachList(moduleKey,moduleObjectId,rightFlag,isRead) {
     var vURL='/rpd/component/attachment/AttachmentMain.jsp?moduleCode='+moduleKey+'&moduleObjectId='+moduleObjectId+'&rightFlag='+rightFlag+'&storeType=disk';
     if(isRead!=null && isRead=='true'){
         vURL=vURL+'&isReload=true';
     }
    var newWin = window.open(vURL,'attachmentManager','left=350,top=200,scrollbars=auto,resizable=yes,width=800,height=650');
	newWin.focus();
}

   /**
    * ���ڹر�
    */
    function closeWindow(){
    	try {
	        var WebBrowser = document.getElementById("WebBrowser1");
	        WebBrowser1.ExecWB(45,1);
	    }catch(e){}
        window.close();
    }
</script>

</head>
<body style="margin: 10px;">
<%
			String strRoot = "../../common";
			if (bNewWindow) {
					out.println("<OBJECT ID=\"WebBrowser1\" WIDTH=\"0\" HEIGHT=\"0\"");
					out.println("CLASSID=\"CLSID:8856F961-340A-11D0-A96B-00C04FD705A2\"></OBJECT>");
					out.println(generateButtonString());
			}
            IWorkFlowUtilBizService iWorkFlowUtilBizService = new WorkFlowUtilBizService();
            String strFlowControlId = request.getParameter("flowControlId");
            String workFlowId = request.getParameter("workFlowId");
            String workId = request.getParameter("workId");
            WorkFlowControl workflowControl = null;
            String strTableName = null;
            if (workFlowId != null && !"".equals(workFlowId) && !"null".equals(workFlowId)) {
                strTableName = WorkFlowSupportUtil.getTableName(workFlowId);
            }
            if (strFlowControlId != null && !"".equals(strFlowControlId)
                    && !"null".equals(strFlowControlId) && !"0".equals(strFlowControlId)) {
                workflowControl = iWorkFlowUtilBizService.readWorkFlowControl(strFlowControlId, strTableName);
                workFlowId = workflowControl.getWorkFlowId();
                workId = workflowControl.getWorkId();
            }
            //	add by Ф���� 2012-4-16 �õ����������ò���
            List lstAttachment = iWorkFlowUtilBizService.readWorkFlowConfig(workFlowId, "showAttachment");
            List lstDeptAndDuty = iWorkFlowUtilBizService.readWorkFlowConfig(workFlowId, "showDeptAndDuty");
            boolean bAttachment = false;
            boolean bDeptAndDuty = false;
            if (null != lstAttachment && lstAttachment.size() > 0) {
                bAttachment = true;
            }
            if (null != lstDeptAndDuty && lstDeptAndDuty.size() > 0) {
                bDeptAndDuty = true;
            }
            //end
            List listSourcereport = null;
            listSourcereport = iWorkFlowUtilBizService.readWorkFlowTrackTab(workFlowId, workId, strTableName);
            if (listSourcereport == null || listSourcereport.size() == 0) {
					out.println("�ü�¼δ�ϱ����������̸�����Ϣ�����ܲ鿴���̸��ٱ����Բ鿴����ͼ");
            		return;
            }
%>
<table width="100%" align="center" cellpadding="1px">
<%!
			List listBeginNode = null; // ���ڴ�����̸����и���ʼ�ڵ�
    		int iBeginNodeIndex = 0; // ��ʼ�ڵ������
    		String strSysName4MainTrack = ""; // ���������ڵ�ϵͳ��
%>
<%
	            iBeginNodeIndex = 0;

				String strDebug = request.getParameter("pDebug");
	            boolean isDebug = "true".equalsIgnoreCase(strDebug);

				String strViewType = request.getParameter("flagForView"); // ���̸��ٲ鿴�����ͣ��ǲ鿴����������̣����ǲ鿴�������̣�ֵΪori �� local
	            if (strViewType == null || "".equals(strViewType)) {
	                strViewType = "local";
	            }
	            RemoteActivityInfo objRemoteActivityInfo = new RemoteActivityInfo(); // �������������̸���Զ�̽ڵ���Ϣ����
	            objRemoteActivityInfo.setFlowId(workFlowId);
	            objRemoteActivityInfo.setWorkId(workId);
	            boolean bIsOriSender = true; // ��ǰ�鿴�������Ƿ��ǹ���������������̣�����ڱ���ϵͳ��
	            boolean bIsGetMainFlowSuccess = true; // ��ȡ�����̳ɹ���Ĭ��Ϊ�ɹ�����������ָ�����������
	            bIsOriSender = iWorkFlowUtilBizService.isOriFlow(objRemoteActivityInfo); // ��ȡ��ǰҪ�鿴�������Ƿ��������������
	            // ��������̵Ľ��շ��������ڽ��շ���Ҫ�ԡ���ʾ�������̡��ķ�ʽ��ʾ����
	            if (!bIsOriSender && ("local".equalsIgnoreCase(strViewType))) {
	                listBeginNode = listSourcereport;
	                if (listBeginNode != null && listBeginNode.size() == 0) {
	                    listBeginNode = iWorkFlowUtilBizService.readWorkFlowTrackListTab(workFlowId,
	                            workId, strTableName);
	                }
	                strSysName4MainTrack = FlowInteractUtil.currGlobalSystemName();
	            } else {
	                // ��ȡ����������̵����̸���.
	                WorkFlowTrackInfo objWorkFlowTrackInfo = iWorkFlowUtilBizService
	                        .getMainTrack(objRemoteActivityInfo);
	                if (objWorkFlowTrackInfo != null) {
	                    listBeginNode = objWorkFlowTrackInfo.getTrack();
	                    if (listBeginNode == null || listBeginNode.size() == 0) {
	                        listBeginNode = iWorkFlowUtilBizService.readWorkFlowTrackListTab(workFlowId,
	                                workId, strTableName);
	                    }
	                    strSysName4MainTrack = objWorkFlowTrackInfo.getSysName();
	                } else {
	                    bIsGetMainFlowSuccess = false; // ���û�ȡ������ʧ��
	                }
	            }

	            // ���listBeginNode ����Ϊ null,���������û�н��յ����ݣ�Ҳ���������粻ͨ.
	            if (listBeginNode == null) {
	                bIsGetMainFlowSuccess = false; // ���û�ȡ������ʧ��
	                listBeginNode = listSourcereport; // ��ȡ��������
	                if (listBeginNode != null && listBeginNode.size() == 0) {
	                    listBeginNode = iWorkFlowUtilBizService.readWorkFlowTrackListTab(workFlowId,
	                            workId, strTableName);
	                }
	                strSysName4MainTrack = FlowInteractUtil.currGlobalSystemName();
	            }
	            WorkFlowTrackVO trackNode = null;
	            List children = null;
	            //��ȡ��һ���ڵ�(���ڵ�)
	            trackNode = (WorkFlowTrackVO) getNextBeginNode();
	            if (trackNode == null) {
					out.println(generateDivForNodeStyle("��ȡ���̿�ʼ�ڵ�����ʧ��!","left"));
	            	return;
	            }

	            if (!bIsOriSender && "ori".equalsIgnoreCase(strViewType)) {
	                String strDisplay = WFSystemMappingHelper.getSystemNameByCode(strSysName4MainTrack);
					//out.println(generateDivForNodeStyle(transNullString(strDisplay),"left"));
                    strDisplay = getParmsString(transNullString(strDisplay));
                    out.println(generateDivForNodeStyle(strDisplay,"left"));
				}
	            if (!bIsOriSender) {
	                if (!bIsGetMainFlowSuccess) {
						out.println(generateDivForNodeStyle("��ȡȫ������ʧ��","right"));
	                    strViewType = "local";
	                } else if ("local".equalsIgnoreCase(strViewType)) {
						out.println(generateDivForNodeStyle("<a onclick=reloadTrack('ori')><span>�鿴ȫ������</span></a>","right"));
	                } else {
						out.println(generateDivForNodeStyle("<a onclick=reloadTrack('local')><span>�鿴��������</span></a>","right"));
	                }
	            }

  				int iCount = 0;
	            boolean multiTransFinished = true;
	            String strWorkFlowId = trackNode.getWorkFlowId();
	            String strRowColor = "";

				WorkFlowTrackVO parentTrackNode = null;//��ǰѭ��trackNode�ĸ��ڵ�
	            // �������нڵ�
	            int iCounter = 0;
	            while (trackNode != null) {
	                iCounter++;
	                String strWaitTime = WorkFlowSupportUtil.getWaitTime(trackNode);
	                //�ж��Ƿ���Эͬ���˵Ľڵ�  ������
	                strWorkFlowId = trackNode.getWorkFlowId();
	                if (strWorkFlowId != null && !"".equals(strWorkFlowId)
	                        && !"null".equals(strWorkFlowId)) {
	                    strTableName = WorkFlowSupportUtil.getTableName(strWorkFlowId);
	                }
	                String backMethod = "NOMORL";
                     //�˴�Ϊ�˴�����������̵Ľڵ㣬���ܽ��д��жϲ���
                    //�Ӷ�Ҳ�����������в�����Эͬ����
                    if(trackNode.getTransWorkFlowId().equals(trackNode.getAllocateWorkFlowId())&&trackNode.getTransWorkFlowId().equals(strWorkFlowId)){
	                   backMethod = WorkFlowTrackUtil.cooperatBranchesBackwardState(trackNode,parentTrackNode, strWorkFlowId);
                    }
	                if (iCount % 2 == 0) {
	                    strRowColor = "#ffffff";
	                } else {
	                    strRowColor = "#eff5fe";
	                }
	                iCount++;
	                if (WorkFlowTrackUtil.isNoFlowEntryNode(trackNode)) {//���ϱ��ڵ�
						out.println(generateTrForNoFlowEntryNode(transNullString(trackNode.getTaskName())));
	                } else if (WorkFlowTrackUtil.isReceFlowDefaultEntryNode(trackNode)) {
	                    trackNode = WorkFlowTrackUtil.makeChildrenDefaultEntry(trackNode);
	                    iCount--;
	                    continue;
	                } else if (WorkFlowTrackUtil.isRemoteNode(trackNode)) {//Զ�˽ڵ�
%>
						<tr onclick="showRemoteNodeFlow(this, '<%=trackNode.getTransNodeId() %>', '<%= trackNode.getWorkFlowId() %>', '<%=trackNode.getWorkId() %>', '<%=trackNode.getId() %>', '<%= strSysName4MainTrack %>')">
							<td colspan="100" align="center">
<%
						if (iCount != 1) {
		                        if ((trackNode.getBackFlag() == null) || trackNode.getBackFlag().equalsIgnoreCase("null")
											|| trackNode.getBackFlag().equalsIgnoreCase("F")) {
									out.println(generateDivForImg(strRoot+"/images/arrow4.gif"));
 								} else {
									out.println(generateDivForImg(strRoot+"/images/arrow3.gif"));
 								}
					    }
%>
							<div id="container" class="table_node_frame01">
								<div id="hiddenDivTip" class="table_node_frame02_but"
									style="display:none;"><span><a href="#">�����������</a></span>
								</div>
								<div id="showDivTip" class="table_node_frame01_but"><span><a href="#">����鿴����</a></span>
								</div>
								<div id="hiddenDiv" style="display:none;"></div>
								<div id="showDiv">
<%
						           out.println(generateTableForRemoteTrack(trackNode ,strWaitTime,bDeptAndDuty));
%>
								</div>
							</div>
							</td>
						</tr>
<%
	               } else if (trackNode.getTransFlag().equals("5")) {//�ȴ�Эͬ�����ڵ�
						out.println(WorkFlowSupportUtil.generateTrForWaitCoopEndNode(trackNode,strRowColor));
	          	   } else if (StringUtils.equals(backMethod, "COOPERBACK")
	                        && (trackNode.getBackFlag()).equalsIgnoreCase("T")
	                        && trackNode.getTransFlag().equalsIgnoreCase("0")) { // Эͬ����ʱ
						out.println(WorkFlowSupportUtil.generateTrForCoopBack(trackNode,strRowColor));
	               } else if (trackNode.getTransFlag().equals("7") && trackNode.isCooperateEnd()) {//���жϽڵ�
	                    //���жϽڵ㶼����ʾ
	               } else if (!trackNode.getTransFlag().equals("0") && multiTransFinished) { //�Ѵ���ڵ�
						String strDivImg = WorkFlowSupportUtil.generateDivImgForDoneNode(parentTrackNode,trackNode,
            				strRoot,backMethod,iCount);
						out.println(WorkFlowSupportUtil.generateTrForDoneNode(strDivImg,strRowColor ,
            				trackNode,children,bDeptAndDuty,bAttachment,strWaitTime,strRoot));
					} else {// ������ڵ�
						String strDivImg = WorkFlowSupportUtil.generateDivImgForDoingNode(parentTrackNode,trackNode,
            				strRoot,backMethod,iCount);
						out.println(WorkFlowSupportUtil.generateTrForDoingNode(strDivImg,strRowColor ,
            				trackNode,children,bDeptAndDuty,bAttachment,strWaitTime,strRoot));
	                }

	                //ȡ����һ���ڵ���б�
	                children = trackNode.getChildrenTrack();
	                //modified by ���ڵ��ϱ��·����ܣ�֮ǰ�߼��ֻ������⣬����д�˽����֧ҳ���ҵ���߼�
	                if (isCooperateToBranch(trackNode)) {//Эͬ��֧ ����TrackBranch.jsp
	                    WorkFlowTrackVO lastNode = null;
	                    WorkFlowTrackVO tempNode = null;
	                    List listBranchChildren = getListBranchChildren(children);
 						List branches = new ArrayList();
	                    branches.addAll(getListChildren(children));
	                    if (branches.size() == 0) {
	                        return;
	                    }
	                    if (branches.size() >= 1) {
%>
				<tr>
					<td colspan="100" class="td_title" align="center">����<%=branches.size()%>�����̷�֧</td>
				</tr>
<%
						}
%>
				<tr>
<%
		                //get cooprate end node
		                children = new ArrayList();
		                parentTrackNode = trackNode;//���ò�����֧���ڵ㣬��Эͬ�����ĸ��ڵ�����ΪЭͬ��ʼ
		                trackNode = WorkFlowTrackUtil.getCooperateEndNode(trackNode, children);
		                //���trackNodeΪnull��ȥ��������һ�������˽ڵ㣬����У�
		                //��˵���Ǵ�Эͬ��֧�ڲ����˵������˽ڵ�ģ����û����˵������Эͬ�ڲ�û�г�Эͬ  ������
		                if (trackNode == null) {
		                    trackNode = getNextBeginNode();
		                }
		                //����ÿ����֧�Ĵ���
		                for (int i = 0, iSize = branches.size(); i < iSize; i++) {
		                     tempNode = (WorkFlowTrackVO) branches.get(i);
		                    request.setAttribute("TrackNode", tempNode);
		                        request.setAttribute("iCount", String.valueOf(i));
		                        request.setAttribute("BranchChildren", listBranchChildren.get(i));
		                        request.setAttribute("BranchEndNode", trackNode);
								if (iSize > 1) {
%>
					<td valign="top" class="branch"><jsp:include flush="false" page="TrackBranch.jsp"></jsp:include></td>
<%
								} else {
%>
					<td colspan="100" align="center" width="100%"><jsp:include flush="false" page="TrackBranch.jsp"></jsp:include></td>
<%
								}
								if (isDebug) {
		                            out.println("buffer: " + i + "-" + out.getRemaining());
		                        }
		                    }
%>
				</tr>
<%
	                    //��Эͬ��֧��ʾ��ɺ�Է��صĽڵ��ж�������Ƕ��˴����Ƿ�����  ������ 2011-12-27
	                    if (null != trackNode && trackNode.isMultitrans() && children.size() > 1) {
	                        if (trackNode.getChildrenCount() > 0) {
	                            multiTransFinished = true;
	                        }
	                        //add by � ����Ӷ��˴���ڵ���˵����������̸��ٱ��ڶ��˴�����Ȼ��ʾ���������
	                        else {
	                            //��ȡ��һ�����˻������˽ڵ�
	                            multiTransFinished = false;
	                            WorkFlowTrackVO objEntryWorkFlowTrackVO = getNextBeginNode();
	                            if (null != objEntryWorkFlowTrackVO) {
	                                //ȡ����֮��Ҫ����Ż�ԭ
	                                iBeginNodeIndex--;
	                                WorkFlowTrackVO objWorkFlowTrackVO = null;
	                                for (int i = 0; i < children.size(); i++) {
	                                    objWorkFlowTrackVO = (WorkFlowTrackVO) children.get(i);
	                                    if (objEntryWorkFlowTrackVO.getAllocateNodeId().equals(
	                                            objWorkFlowTrackVO.getTransNodeId())) {
	                                        multiTransFinished = true;
	                                        break;
	                                    }
	                                }
	                            }
	                        }
	                    } else {
	                        multiTransFinished = true;
	                    }
	                } else {
	                    WorkFlowTrackVO tempNode = null;
	                    //�������û�ڵ���ȡ��һ����ʼ�ڵ�
	                    if (children == null || children.size() == 0) {
	                        parentTrackNode=null;
	                        trackNode = getNextBeginNode();
	                        children = new ArrayList();
	                        children.add(trackNode);
	                    } else {//����ȡ��һ�����ӽڵ�
	                        parentTrackNode = trackNode;
	                        trackNode = (WorkFlowTrackVO) children.get(0);
	                    }
	                    if (trackNode == null) {
	                        break;
	                    }
	                    //����Ǵ�����ڵ�,ȡ���д������˵�����
	                    String transFlag = trackNode.getTransFlag();
	                    if ("0".equals(transFlag) && !trackNode.isMultitrans()) {
	                        WorkFlowTrackUtil.mergeTransActor(trackNode, children);
	                    }
	                    //����Ƕ��˴���,����Ƿ����˶�������
	                    if (trackNode.isMultitrans() && children.size() > 1) {
	                        if (trackNode.getChildrenCount() > 0) {
	                            multiTransFinished = true;
	                        }
	                        //add by � ����Ӷ��˴���ڵ���˵����������̸��ٱ��ڶ��˴�����Ȼ��ʾ���������
	                        else {
	                            //��ȡ��һ�����˻������˽ڵ�
	                            multiTransFinished = false;
	                            WorkFlowTrackVO objEntryWorkFlowTrackVO = getNextBeginNode();
	                            if (null != objEntryWorkFlowTrackVO) {
	                                //ȡ����֮��Ҫ����Ż�ԭ
	                                iBeginNodeIndex--;
	                                WorkFlowTrackVO objWorkFlowTrackVO = null;
	                                for (int i = 0; i < children.size(); i++) {
	                                    objWorkFlowTrackVO = (WorkFlowTrackVO) children.get(i);
	                                    if (objEntryWorkFlowTrackVO.getAllocateNodeId().equals(
	                                            objWorkFlowTrackVO.getTransNodeId())) {
	                                        multiTransFinished = true;
	                                        break;
	                                    }
	                                }
	                            } else {//���һ���ڵ�Ϊ���˴���
	                                WorkFlowTrackVO objWorkFlowTrackVO = null;
	                                for (int i = 0; i < children.size(); i++) {
	                                    objWorkFlowTrackVO = (WorkFlowTrackVO) children.get(i);
	                                    if ("4".equals(objWorkFlowTrackVO.getTransFlag())) {
	                                        multiTransFinished = true;
	                                        break;
	                                    }
	                                }
	                            }
	                        }
	                    } else {
	                        multiTransFinished = true;
	                    }
	                }
	            }
%>
</table>
<script language="javascript">
function changeValue(text,idValue){
    var eles = document.getElementsByName("civilize_workflow");
	for(var i=0;i<eles.length;i++){
		if(eles[i].id==idValue){
			eles[i].innerText = text;
		}
	}
}
</script>
</body>
</html>
<%!

		//����Զ�˽ڵ���
		private String generateTableForRemoteTrack(WorkFlowTrackVO trackNode,String waitTime,boolean bDeptAndDuty){
			String tableString = "<table width='60%' border='1' cellspacing='0' cellpadding='0' class='table_list table_node_frame01_table'>"
										    +"<tr><td width='15%' align='left'>���̲������ƣ�</td>"
												+"<td width='15%'>"+transNullString(trackNode.getActName())+"</td>"
												+"<td width='10%'>ͣ&nbsp;&nbsp;��&nbsp;&nbsp;ʱ&nbsp;&nbsp;����</td>"
												+"<td width='20%'>"+waitTime+"</td></tr>";
			if (bDeptAndDuty) {
					tableString += "<tr><td width='10%'>��&nbsp;��&nbsp;�˲�������&nbsp;��</td>";
					tableString += "<td width='20%'>"+transNullString(trackNode.getDepartmentFullName())+"</td>";
					tableString += "<td width='15%' align='left'>��&nbsp;��&nbsp;��&nbsp;ְ&nbsp;&nbsp;��</td>";
					tableString += "<td width='15%'>"+transNullString(trackNode.getDuty())+"</td></tr>";
			}
			tableString +=	"<tr><td width='15%' align='left'>��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;�ˣ�</td>"
					+"<td align='left' colspan='100'><font color='red'>"+transNullString(trackNode.getTransActor())+transNullString(trackNode.getDeputy())+"</font></td></tr>";
			tableString +="</table>";
			return tableString;
		}

		//����ͼƬDIV
		private String generateDivForImg(String imgUrl){
			String divString =  "<div class='arrow'><img src='"+imgUrl+"'></div>";
			return divString;
		}

		//����NoFlowEntryNode�ַ���
		private String generateTrForNoFlowEntryNode(String actName){
			String trString = "<tr><td colspan='100' align='center'>"
								+ "<table width='60%' border='1' cellspacing='0' cellpadding='0' class='table_list'>"
								+ "<tr><td width='25%' align='left'>���̲������ƣ�</td>"
								+ "<td width='25%'>"+actName+"</td>"
								+ "<td width='25%' align='left'>��&nbsp;&nbsp;��&nbsp;&nbsp;ʱ&nbsp;&nbsp;�䣺</td>"
								+ "<td align='left'><font color='red'>&nbsp; </font></td></tr></table></td></tr>";
			return trString;
		}


		//����DIV��ʽ
		private String generateDivForNodeStyle(String str,String agile){
			String divString = "<div class='node_buttom01' "
								+"style='float:"+agile+";font-size:14px;margin:5px 5px 5px 5px;'><span>"
								+str+"</span></div>";
			return divString;
		}

		//���ɰ�ť
		private String generateButtonString(){
				String buttonString ="<div id='printPart'><table width='100%' id='printPart'>" +
					   					"<tr><td align='right'><input type='button' class='btn_href' value='��ӡԤ��' onclick='preview();'>&nbsp;"+
										"<input type='button' class='btn_href' value='��&nbsp;&nbsp;ӡ' onclick='doPrint();'>&nbsp; "+
					  					"<input type='button' class='btn_href' value='��&nbsp;&nbsp;��' onclick='closeWindow();'>&nbsp;</td></tr></table></div>";
				return buttonString;
		}

		/**
     * ��ȡ��һ����ʼ�ڵ�
     */
    WorkFlowTrackVO getNextBeginNode() {
        try {
            return (WorkFlowTrackVO) listBeginNode.get(iBeginNodeIndex++);
        } catch (Exception ex) {
            return null;
        }
    }

	/**
     *  �Ƿ�ΪЭͬ��ʼЭͬ������Эͬ��֧
     *  ֮ǰ���ж��߼�Ϊ��
     *     1.�Ƿ�ΪЭͬ�������˵�Эͬ��֧
     *     2.��ǰ�ڵ�ΪЭͬ��ʼ�ڵ㣬��ǰ�ڵ��ӽڵ㲻ΪЭͬ��ʼ��Эͬ����
     *
     *  �������˿�ڵ��ϱ����·���Эͬ��ʼ�·���һ������Эͬ��֧
     *  �����ڵ��ж��߼�Ϊ��
     *     1.��ǰ�ڵ�ΪЭͬ��ʼ��Эͬ����
     *     2.��ǰ�ڵ��ӽڵ�ΪЭͬ��֧�ڵ�
     *
     *  @param trackNode ��ǰ���̽ڵ����
     */
    private boolean isCooperateToBranch(WorkFlowTrackVO trackNode) {
        if (trackNode.isCooperateBegin() || trackNode.isCooperateEnd()) {
            List children = trackNode.getChildrenTrack();
            if (children != null && !children.isEmpty()) {
                WorkFlowTrackVO nextNode = (WorkFlowTrackVO) children.get(0);
                return isCooperateBranch(nextNode);
            }
        }
        return false;
    }

    /**
     *  ��ǰ�ڵ��Ƿ�ΪЭͬ��֧
     *  @param trackNode ��ǰ���̽ڵ����
     */
    private boolean isCooperateBranch(WorkFlowTrackVO trackNode) {
		//���Ȳ������ֶ����ж��Ƿ���Эͬ��֧��
		if(trackNode.getCooperateFlag()!=null && "B".equals(trackNode.getCooperateFlag())){
            return true;
        }else if(trackNode.getCooperateFlag()!=null && "N".equals(trackNode.getCooperateFlag())){
			return false;
		}else{
			IWorkFlowUtilBizService iWorkFlowUtilBizService = new WorkFlowUtilBizService();
        	String strTransNodeId = getMainFLowTransNodeId(trackNode);
        	String strWorkFlowId = trackNode.getWorkFlowId();
        	WorkFlowCoopeRationVO targetWorkFlowCoopeRationVo = iWorkFlowUtilBizService
                	.getCooperateBranchNodeRation(strWorkFlowId, strTransNodeId);
        	if (null != targetWorkFlowCoopeRationVo
                	&& (WorkFlowCoopeRationVO.COOPERATR_BRANCH).equals(targetWorkFlowCoopeRationVo
                        	.getActType())) {
            	return true;
        	}
        	return false;
		}
    }

    /**
     *  ͨ��trackNode ��������̴���ڵ�ID��
     *   1.trackNode���Ϊ�����̽ڵ㣬ֱ�ӷ���TransNodeId
     *   2.trackNode���Ϊ�����̽ڵ㣬�����������������̵Ľڵ�ID
     *  @param trackNode ��ǰ���̽ڵ����
     */
    private String getMainFLowTransNodeId(WorkFlowTrackVO trackNode){
        String mainWorkflowId = trackNode.getWorkFlowId();
        if(!mainWorkflowId.equals(trackNode.getTransWorkFlowId())){//�����̽ڵ����
            //eg:  null:null,wodexietongceshi:000041
            String strTransFlowMsg = trackNode.getTransFlowMsg();
            List lstTransFlowMsg = StringUtils.split(strTransFlowMsg, ',');
            for (Iterator iter = lstTransFlowMsg.iterator(); iter.hasNext();) {
                String nodeMsg = (String) iter.next();
                List lstNodeMsg = StringUtils.split(nodeMsg, ':');
                if(lstNodeMsg.size() < 2){
                    continue;
                }
                if(mainWorkflowId.equals(lstNodeMsg.get(0))){
                    return (String)lstNodeMsg.get(1);
                }
            }
        }
        return trackNode.getTransNodeId();
    }

	private List getListBranchChildren(List children){
		List listBranchChildren = new ArrayList();
	    //�ϲ���֧(1����֧�����ж�������¼)
	    //����ͬ�ڵ�ĺ��Ӽ��Ϸŵ�һ��branchChildren������������˴��� add by ���� 2012-05-05
	    Map objTempMap = new HashMap(20);
	    for (int i = 0, iSize = children.size(); i < iSize; i++) {
	          WorkFlowTrackVO tempNode = (WorkFlowTrackVO) children.get(i);
	          String nodeKey = tempNode.getTransWorkFlowId() + ":" + tempNode.getTransNodeId();
	          //��MAP�ж�ȡ���Ӽ���
	          List objBranchChildren = (List) objTempMap.get(nodeKey);
	          //���û�иú��Ӽ��ϣ��򴴽����Ӽ��ϣ�keyΪ����ID:�ڵ�ID
	          if (null == objBranchChildren) {
	                objBranchChildren = new ArrayList();
	                objBranchChildren.add(tempNode);
	                objTempMap.put(nodeKey, objBranchChildren);
					listBranchChildren.add(objBranchChildren);
	         } else {
	                 //����Ѿ����ڸú��Ӽ��ϣ��򽫸ýڵ㺢�Ӽ���ü���
	                objBranchChildren.add(tempNode);
	        }
	    }
		return listBranchChildren;
	}

	private List getListChildren(List children){
 		WorkFlowTrackVO lastNode = null;
	    WorkFlowTrackVO tempNode = null;
		List lstChildren = new ArrayList();
	    lstChildren.addAll(children);
	    for (int i = 0; i < lstChildren.size(); i++) {
	       tempNode = (WorkFlowTrackVO) lstChildren.get(i);
	       for (int j = lstChildren.size() - 1; j > i; j--) {
	            lastNode = (WorkFlowTrackVO) lstChildren.get(j);
	            if (lastNode != null&& tempNode.getTransNodeId().equals(lastNode.getTransNodeId())
	                    && tempNode.getTransWorkFlowId().equals(lastNode.getTransWorkFlowId())) {
	                if (!lastNode.isMultitrans()) {
	                     if (tempNode.getTransActor() != null&& lastNode.getTransActor() != null) {
	                          String[] strTransActors = lastNode.getTransActor().split("��");
                              String[] strTransActorIds = lastNode.getTransActorId().split("��");
	                          for (int k = 0; k < strTransActors.length; k++) {
	                                if (strTransActors[k] != null&& !"".equals(strTransActors[k])
	                                          && tempNode.getTransActor().indexOf(strTransActors[k]) < 0) {
	                                      tempNode.setTransActor(strTransActors[k] + "��"+ tempNode.getTransActor());
                                          tempNode.setTransActorId(strTransActorIds[k] + "��"+ tempNode.getTransActorId());
	                                  }
	                          }
	                     }

	                }
	                // 2011-07-06 ����� �޸ģ���remove����if(!lastNode.isMultitrans())���Ƶ�if����档���˴���Ҳ����Ҫɾ����ͬ�ڵ��FlowControl��¼��
	                lstChildren.remove(j);
	            }
	       }
	   }
	   return lstChildren;
	}

	private String transNullString(String nullString){
		return nullString==null?"":nullString;
	}

    private String getParmsString(String strString){
		return "<a><span>"+strString+"</span></a>";
	}
%>

<script type="text/javascript">
	function reloadTrack(flag) {
		 var flowControlId = "<%=strFlowControlId%>";
		 var workFlowId = "<%=workFlowId%>";
		 var workId = "<%=workId%>";
		 var strListURL = "WorkFlowTrackTable.jsp?flowControlId="+flowControlId+"&workFlowId="+workFlowId+"&workId="+workId+"&flagForView="+flag;
		 document.location.target = "_self";
		 document.location.href  = strListURL;
	}
</script>