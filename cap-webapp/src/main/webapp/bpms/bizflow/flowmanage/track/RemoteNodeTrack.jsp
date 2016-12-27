<%@page contentType="text/html; charset=GBK" %>
<%@page import="com.comtop.lcam.flowtrack.service.IWorkFlowUtilBizService"%>
<%@page import="com.comtop.lcam.flowtrack.service.impl.WorkFlowUtilBizService"%>
<%@page import="com.comtop.lcam.flowtrack.artifacts.WorkFlowTrackVO"%>
<%@page import="com.comtop.lcam.flowtrack.util.PubFunctions"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.comtop.lcam.flowtrack.flowinteract.util.WorkFlowTrackUtil"%>
<%@page import="com.comtop.lcam.flowtrack.flowinteract.model.RemoteActivityInfo"%>
<%@page import="com.comtop.lcam.flowtrack.flowinteract.model.WorkFlowTrackInfo"%>
<%@page import="com.comtop.lcam.flowtrack.flowinteract.interact.WFSystemMappingHelper"%>
<%@page buffer="1024kb"%>
<html>
<head>
<title>����������ͼ</title>
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

.table_node_frame01{
	border:3px solid #73adff;
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

<%
    String strRoot = "../../common";
    // ��ȡ���ݵĲ���
    String strNodeId = (String)request.getParameter("nodeId");
	String strFlowId = (String)request.getParameter("flowId");
	String strWorkId = (String)request.getParameter("workId");
	String strFlowControlId = (String)request.getParameter("flowControlId");
	String strSysName = (String)request.getParameter("sysName"); // ��Զ�̽ڵ����ڵ�ϵͳ��
	RemoteActivityInfo objRemoteActivityInfo = new RemoteActivityInfo();
	objRemoteActivityInfo.setNodeId(strNodeId);
	objRemoteActivityInfo.setFlowId(strFlowId);
	objRemoteActivityInfo.setWorkId(strWorkId);
	objRemoteActivityInfo.setFlowControlId(strFlowControlId);
	System.out.println(strFlowControlId);
	if (strFlowControlId == null || "".equals(strFlowControlId) || "null".equalsIgnoreCase(strFlowControlId)) {
	    objRemoteActivityInfo.setSenderNoFlow(true);
	}
	objRemoteActivityInfo.setGlobalName(strSysName);
	IWorkFlowUtilBizService iWorkFlowUtilBizService = new WorkFlowUtilBizService();
	// ����ϵͳ�����̸���
	WorkFlowTrackInfo objWorkFlowTrackInfo = iWorkFlowUtilBizService.getRemoteTrack(objRemoteActivityInfo);
	List lstAllRemoteTrack = null;
	if (objWorkFlowTrackInfo != null) {
	    lstAllRemoteTrack = objWorkFlowTrackInfo.getTrack();
	}
	if (lstAllRemoteTrack == null) {
%>
	    <div class="node_buttom01" style="float:left;font-size:14px;margin:5px 5px 5px 5px;">
	    <%out.println("<span>��ȡ�ò�����������ʧ��</span>");%>
	    </div>

<%
	    return;
	}

	// �����õı���
	WorkFlowTrackVO trackNode =null;
	List children = null;
%>
<%
	//ģ��·��
	String strModulePath = request.getParameter("pModulePath");
	if ( null != strModulePath && !"".equals(strModulePath) ){
		 strModulePath = "/"+strModulePath;
	}
	else if(null == strModulePath){
		strModulePath = "";
	}
%>
<script type="text/javascript">
	    //����Ӧ��С
    function  adjustPageRemote() {
		var w=0;
		var h=0;

		//�޸��ʲ�ϵͳ��EIPҳ�漯��ʱ��ָ��������Աѡ������
		try{
	        if(self.location!=top.location) {
	            this.frameElement.width = "100%";
	            this.frameElement.height = document.body.scrollHeight + h;
	        }
	    }catch(e){
		}
    }

	function fitPageRemote(iframe) {
		iframe.height = iframe.Document.body.scrollHeight;
		adjustPageRemote();
	}
	function showRemoteNodeFlowRemote(td, nodeId, flowId, workId, controlId, sysName) {
		// alert(nodeId + ' ' + flowId + ' ' + workId + ' ' + controlId + ' ' + sysName);
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
				vHiddenDiv.innerHTML = "<iframe onreadystatechange=fitPageRemote(this) id='" + controlId + "' width=100% height=auto frameborder=0 scrolling=yes src='" + vSrc + "'></iframe>";
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
		adjustPageRemote();
	}

</script>

</head>
<body style="height:auto;">
<%!
	// ����ϵͳ�����̸���
	List lstSingleTrack = null;
	String strToSysteName = "";
	// ����
	int iBeginNodeIndex = 0;

	WorkFlowTrackVO getNextBeginNode()  {
        try{
            return (WorkFlowTrackVO)lstSingleTrack.get(iBeginNodeIndex++);
        } catch (Exception ex){
            return null;
        }
    }

%>
<table id="ta" border="3" cellspacing="5" cellpadding="5" class="table_list" >
	<tr>
		<%
			for (int z = 0, zSize = lstAllRemoteTrack.size(); z < zSize; z++) {
			    String strDisplayName = "";
			    WorkFlowTrackInfo objTemp = (WorkFlowTrackInfo) lstAllRemoteTrack.get(z);
			    if (objTemp != null) {
				    lstSingleTrack = objTemp.getTrack();
				    strToSysteName = objTemp.getSysName();
			    } else {
			        lstSingleTrack = null;
			        strToSysteName = "";
			    }

			    if (lstSingleTrack == null || lstSingleTrack.size() == 0) {
		%>
			<td width="1%" align="center" style="vertical-align:top;">
				<table width="100%">
					<tr><td>
						<% strDisplayName = WFSystemMappingHelper.getSystemNameByCode(strToSysteName);
						   out.print(strDisplayName == null ? "" : strDisplayName);
						%>
						��Ϣ�޷���ȡ
					</td></tr>
				</table>
			</td>
		<%
					continue;
			    }


			    iBeginNodeIndex = 0;
			    trackNode = getNextBeginNode();
			    if (trackNode == null) {
			        continue;
			    }

			    int iCount=0;
			    boolean multiTransFinished = true ;
			    String strWorkFlowId = trackNode.getWorkFlowId();

			    String strBackFlag       = "";      //�Ƿ��ǻ��˵Ĳ��裬��T��--�ǣ���F��--��
			    String strActName       = "";      //�ڵ�����
			    String strTransFlag         = "";      //�����־0--δ����;1--�Ѵ���;2--ͬ�����Ѵ���;3--���̱���ֹ;4--�����;5--Эͬ�����ַ�֧����
			    String strTransActor       = "";      //������
			    String strDeputy = "";				//ί����
			    String strConFlag       = "";      //���۱�־
			    String strNotion        = "";      //�������
			    String strRowColor = "";
			    String strTransDate         = "";      //��������
			    String strControlId = "";

		%>
		<td width="1%" align="center" style="vertical-align:top;">
			<table>
			<tr><td><%=WFSystemMappingHelper.getSystemNameByCode(strToSysteName) %></td></tr>
			</table>
			<table width="100%">
		<%
		   // �������нڵ�
	    	while(trackNode != null) {
				// write itself
		        strActName	= trackNode.getTaskName();		//�ڵ�����
		        strTransFlag= trackNode.getTransFlag();	//�����־
		        strBackFlag		= trackNode.getBackFlag();	//�Ƿ��ǻ��˵�
		        strTransActor = trackNode.getTransActor();//������
		        strDeputy = WorkFlowTrackUtil.getDeputyInfo(trackNode.getDeputy());	// ��������Ϣ
		        strNotion	= trackNode.getNote();			//���
		        strConFlag	= trackNode.getResultFlag();	//����

		        strNodeId = trackNode.getTransNodeId();
		        strFlowId = trackNode.getWorkFlowId();
		        strWorkId = trackNode.getWorkId();
		        strControlId = trackNode.getId();


		        //��������
		        strTransDate = (trackNode.getTransDate()==null?"&nbsp;":PubFunctions.formatDateTime(trackNode.getTransDate(),"yyyy-MM-dd H:mm"));
		        if (strActName == null){
		        strActName = "";
		        }
		        strNotion = (strNotion==null?"":PubFunctions.nlTobr(strNotion).trim());

		    	if(iCount % 2 == 0){
		    		strRowColor = "#ffffff";
		    	}else{
		    		strRowColor = "#eff5fe";
		    	}
		    	iCount++;
				// ��������⿪ʼ�ڵ�
		    	if (WorkFlowTrackUtil.isRemoteEntryNode(trackNode) || WorkFlowTrackUtil.isReceFlowDefaultEntryNode(trackNode)) {
					trackNode = WorkFlowTrackUtil.makeChildrenDefaultEntry(trackNode);
					iCount --;
					continue;
		    	} else if (WorkFlowTrackUtil.isRemoteNode(trackNode)) {
		%>
			    	    <tr onclick="showRemoteNodeFlowRemote(this, '<%=strNodeId %>', '<%= strFlowId %>', '<%=strWorkId %>', '<%=strControlId %>', '<%= strToSysteName %>')">
							<td colspan="100" align="center">
							<% if (iCount != 1) { %>
								<div class="arrow">
					                <% if((strBackFlag==null)||strBackFlag.equalsIgnoreCase("null")||strBackFlag.equalsIgnoreCase("F")){    %>
					                <img src="<%=strRoot%>/images/arrow4.gif" >
					                <%}else{%>
					                <img src="<%=strRoot%>/images/arrow3.gif" >
					                <%}%>
					            </div>
			            	<% } %>
					            <div id="container" class="table_node_frame01">
					            	<div id="hiddenDivTip" class="table_node_frame02_but" style="display:none;"><span><a href="#">�����������</a></span></div>
									<div id="showDivTip" class="table_node_frame01_but"><span><a href="#">����鿴����</a></span></div>
									<div id="hiddenDiv" style="display:none;"></div>
									<div id="showDiv" >
							            <table width="60%" border="1" cellspacing="0" cellpadding="0" class="table_list table_node_frame01_table" >
											<tr>
							                    <td width="15%" align="left" >���̲������ƣ�</td>
							                    <td align="left" ><%=strActName%><font color="red">&nbsp; </font></td>
							                </tr>
							                <tr>
							                    <td width="15%"  align="left">��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;�ˣ�</td>
							                    <td align="left"   ><font color="red"><%=strTransActor%><%=strDeputy%></font></td>
							                </tr>
							            </table>
							         </div>
						       </div>
			        		</td>
	            		</tr>
         <%
		        } else if (strTransFlag.equals("5")){    // Эͬ�����ַ�֧����
		%>
				    <tr>
				        <td colspan="100" align="center">
				            <table CLASS="table_list"  border="1" cellspacing="0" cellpadding="3" bgcolor=<%=strRowColor%>>
				                <tr >
				                    <td width="15%" align="left" >���̲������ƣ�</td>
				                    <td align="left" width="85%" colspan="100"><%=strActName%><font color="red">&nbsp; (�ȴ���֧����)</font></td>
				                </tr>
				                <tr >
				                    <td width="10%"  align="left">��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;�ˣ�</td>
				                    <td align="left"  colspan="100" ><font color="red"><%=strTransActor%><%=strDeputy%></font></td>
				                </tr>
				            </table>
				        </td>
				    </tr>

		<%

		    	}else if (!strTransFlag.equals("0") && multiTransFinished){    // �Ѵ���ڵ�
		%>
		    <tr>
		        <td colspan="100" align="center">
		            <%if(!trackNode.isCooperateEnd()&& iCount!=1){ %>
		            <div class="arrow">

		                <% if((strBackFlag==null)||strBackFlag.equalsIgnoreCase("null")||strBackFlag.equalsIgnoreCase("F")){    %>
		                <img src="<%=strRoot%>/images/arrow4.gif" >
		                <%}else{%>
		                <img src="<%=strRoot%>/images/arrow3.gif" >
		                <%}%>
		            </div>
		            <%} %>
		        <table class="table_list"  border="1" cellspacing="0" cellpadding="3" bgcolor=<%=strRowColor%>>
		            <tr >
		                <td width="15%" align="left" >���̲������ƣ�</td>
		                <%if(strTransFlag.equals("4")){%>
		                    <td align="left" width="85%" colspan="100"><%=strActName%><font color='red'>&nbsp;����������������</font></td>
		                <%}else if(strTransFlag.equals("3")){%>
		                    <td align="left" width="85%" colspan="100"><%=strActName%><font color='red'>&nbsp;��������ֹ��</font></td>
		                <%}else{%>
		                    <td align="left" width="85%" colspan="100"><%=strActName%></td>
		                <%}%>
		            </tr>
		            <%
		            //���˴���
		                if(trackNode.isMultitrans() && children != null){
		                    WorkFlowTrackVO tempNode = null;
		                    String[] strRowHTML = new String[]{"","","",""};
		                    for(int i=0,iSize=children.size();i<iSize;i++){
		                        tempNode = (WorkFlowTrackVO)children.get(i);
		                        strTransDate = (tempNode.getTransDate()==null?"&nbsp;":PubFunctions.formatDateTime(tempNode.getTransDate(),"yyyy-MM-dd H:mm"));
		                        strTransActor = tempNode.getTransActor();//������
		                        strDeputy = WorkFlowTrackUtil.getDeputyInfo(tempNode.getDeputy());
		                        strNotion   = tempNode.getNote();           //���
		                        strConFlag  = tempNode.getResultFlag(); //����
		                        if(strNotion==null){
		                            strNotion="";
		                        }

		                        strRowHTML[0]+="<td align='left' nowrap='true' title='��������:"+strTransDate+"'>"+strTransActor+strDeputy+"</td>";
		                        strRowHTML[1]+="<td align='left' nowrap='true'>"+strTransDate+"</td>";
		                        strRowHTML[2]+="<td align='left' nowrap='true'>"+(trackNode.getResult() == null ? "" : trackNode.getResult())+"</td>";
		                        strRowHTML[3]+="<td align='left' nowrap='true'>"+strNotion+"</td>";
							}
		            %>
		            <tr>
		                <td width="15%" align="left" nowrap="true">
		                    ���� �� ���ˣ�
		                </td>
		                <%=strRowHTML[0] %>
		             </tr>
		             <tr>
		             	<td>��&nbsp;��&nbsp;ʱ&nbsp;�䣺</td>
		             	<%=strRowHTML[1] %>
		             </tr>
		            <tr>
		                <td width="15%" align="left" nowrap="true">
		                    �ᡡ�������ۣ�
		                 </td>
		                 <%=strRowHTML[2] %>
		             </tr>
		            <tr>
		                <td width="15%" align="left" nowrap="true">
		                    ��&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;����
		                </td>
		                <%=strRowHTML[3] %>
		            </tr>
		            <%
		            }else {//�Ƕ��˴���
		            %>
		            <tr>
		                <td width="15%" align="left">��&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;�ڣ�</td>
		                <td align="left" width="35%" ><%=strTransDate%></td>
		                <td width="10%"  align="left">��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;�ˣ�</td>
		                <td align="left" width="15%" width=""><%=strTransActor%><%=strDeputy%></td>
		                <td width="10%" align="left">��&nbsp;&nbsp;&nbsp;&nbsp�ۣ�</td>
		                <td align="left" width="15%" ><%=trackNode.getResult() == null ? "" : trackNode.getResult()%></td>
		            </tr>
		            <tr>
		                <td width="15%" align="left" >��&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;����</td>
		                <td align="left" width="85%" colspan="100" class="break-word"><%=strNotion%></td>
		            </tr>
		            <%} %>
		        </table>
		        </td>
		    </tr>
		<%
		    	}else {// ������ڵ�
		%>
		    <tr>
		        <td colspan="100" align="center">
		            <%if(!trackNode.isCooperateEnd() && iCount!=1){ %>
		            <div class="arrow">
		                <% if((strBackFlag==null)||strBackFlag.equalsIgnoreCase("null")||strBackFlag.equalsIgnoreCase("F")){    %>
		                <img src="<%=strRoot%>/images/arrow1.gif" >
		                <%}else{%>
		                <img src="<%=strRoot%>/images/arrow2.gif" >
		                <%}%>
		            </div>
		            <%} %>
		            <table CLASS="table_list"  border="1" cellspacing="0" cellpadding="3" bgcolor=<%=strRowColor%>>
		<%
		            //���˴���
		    	    if(trackNode.isMultitrans()){
		                WorkFlowTrackVO tempNode = null;
		                String[] strRowHTML = new String[]{"","","","","",""};
		                String strWidth = 100/children.size()+"%";
		                for(int i=0,iSize=children.size();i<iSize;i++){
		                    tempNode = (WorkFlowTrackVO)children.get(i);
		                    strTransFlag = tempNode.getTransFlag();
		                    if(tempNode.getTransDate() == null || !"1".equals(strTransFlag)){
		                        strTransDate = "&nbsp;";
		                    } else {
		                        strTransDate = PubFunctions.formatDateTime(tempNode.getTransDate(),"yyyy-MM-dd H:mm");
		                    }
		                    strTransActor = tempNode.getTransActor();//������
		                    strDeputy = WorkFlowTrackUtil.getDeputyInfo(tempNode.getDeputy());
		                    strNotion   = tempNode.getNote();           //���
		                    strConFlag  = tempNode.getResultFlag(); //����
		                    if(strNotion==null){
		                        strNotion="";
		                    }
		                    strRowHTML[0]+="<td align='left' nowrap='true' title='��������:"+strTransDate+"'>"+strTransActor+strDeputy+"</td>";
		                    strRowHTML[1] += "<td width='"+strWidth+"' align='left' nowrap='true'>" +strTransDate + "</td>";
		                    if("1".equals(strTransFlag)){
		                        strRowHTML[2]+="<td width='"+strWidth+"' align='left' nowrap='true'>�Ѵ���</td>";
		                        strRowHTML[3]+="<td width='"+strWidth+"' align='left' nowrap='true'>"+(trackNode.getResult() == null ? "" : trackNode.getResult())+"</td>";
		                        strRowHTML[4]+="<td width='"+strWidth+"' align='left' class='break-word'>"+strNotion+"</td>";
		                    }else {
		                        strRowHTML[2]+="<td width='"+strWidth+"' align='left' nowrap='true'><font color='red'>δ����</font></td>";
		                        strRowHTML[3]+="<td width='"+strWidth+"' align='left' nowrap='true'></td>";
		                        strRowHTML[4]+="<td width='"+strWidth+"' align='left' nowrap='true'></td>";
		                    }
		                  }
		%>
		                <tr >
		                    <td align="left" nowrap='true'>���̲������ƣ�</td>
		                    <td align="left" width="85%" colspan="100"  nowrap='true'><%=strActName%><font color="red">&nbsp; (��������)</font></td>
		                </tr>
		                <tr>
		                    <td align="left" nowrap="true">
		                        ���� �� ���ˣ�
		                    </td>
		                    <%=strRowHTML[0] %>
		                </tr>
		                 <tr>
		                    <td align="left" nowrap="true">
		                        ��&nbsp;��&nbsp;ʱ&nbsp;�䣺
		                    </td>
		                    <%=strRowHTML[1] %>
		                	</tr>
		                <tr>
		                    <td align="left" nowrap="true">
		                        ��&nbsp;&nbsp;��&nbsp;&nbsp;״&nbsp;&nbsp;̬��
		                    </td>
		                    <%=strRowHTML[2] %>
		                </tr>
		                <tr>
		                    <td align="left" nowrap="true">
		                        �ᡡ�������ۣ�
		                    </td>
		                     <%=strRowHTML[3] %>
		                </tr>
		                <tr>
		                    <td align="left" nowrap="true">
		                        ��&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;����
		                    </td>
		                    <%=strRowHTML[4] %>
		                </tr>
		<%
		            }else {//�Ƕ��˴���
		%>
		                <tr >
		                    <td width="15%" align="left" >���̲������ƣ�</td>
		                    <td align="left" width="85%" colspan="100"><%=strActName%><font color="red">&nbsp; (��������)</font></td>
		                </tr>
		                <tr >
		                    <td width="10%"  align="left">��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;�ˣ�</td>
		                    <td align="left" colspan="100" ><font color="red"><%=strTransActor%><%=strDeputy%></font></td>
		                </tr>
		<%          } %>
		            </table>
		        </td>
		    </tr>
		<%
		        }
		        //ȡ����һ���ڵ���б�
		    	children = trackNode.getChildrenTrack();
		        //��ȡ��һ���ڵ�Ļ��˱�־
		        String strNextNodeBackFlag = null;
		        if(children!=null && !children.isEmpty()){
		            WorkFlowTrackVO nextNode = (WorkFlowTrackVO)children.get(0);
		            strNextNodeBackFlag = nextNode.getBackFlag();
		        }
		        //Эͬ��ʼ�����Ҳ��ǻ��˵�
		        if(trackNode.isCooperateBegin() && !"T".equalsIgnoreCase(strNextNodeBackFlag)){
		            WorkFlowTrackVO lastNode = null;
		            WorkFlowTrackVO tempNode = null;
		            List branches = new ArrayList();
		            List listBranchChildren = new ArrayList();
		            List branchChildren = new ArrayList();
		            //�ϲ���֧(1����֧�����ж�������¼)
		            for(int i=0,iSize=children.size();i<iSize;i++){
		                tempNode =(WorkFlowTrackVO) children.get(i);
		                //�ϲ�ͬһ����֧�ļ�¼(transNodeId��transWorkFlowId��ͬ)
		                if(lastNode!=null && tempNode.getTransNodeId().equals(lastNode.getTransNodeId())
		                        &&tempNode.getTransWorkFlowId().equals(lastNode.getTransWorkFlowId())){
		                    if(!tempNode.isMultitrans()){
		                        lastNode.setTransActor(lastNode.getTransActor()+"��"+tempNode.getTransActor());
		                    }
		                }else {
		                    branchChildren = new ArrayList();
		                    listBranchChildren.add(branchChildren);
		                    lastNode = tempNode;
		                }
		                branchChildren.add(tempNode);
		                if(lastNode==null){
		                    lastNode=tempNode;
		                }
		            }
		            List lstChildren = new ArrayList();
		            lstChildren.addAll(children);
		            for(int i=0;i<lstChildren.size();i++){
		            	tempNode = (WorkFlowTrackVO) lstChildren.get(i);
		            	for(int j=lstChildren.size()-1;j>i;j--){
		            		lastNode = (WorkFlowTrackVO) lstChildren.get(j);
		            		if(lastNode!=null && tempNode.getTransNodeId().equals(lastNode.getTransNodeId())
		                            &&tempNode.getTransWorkFlowId().equals(lastNode.getTransWorkFlowId())){
		            			if(!lastNode.isMultitrans()){
		            				if(tempNode.getTransActor()!=null&&lastNode.getTransActor()!=null){
										String[] strTransActors = lastNode.getTransActor().split("��");
										for(int k = 0;k<strTransActors.length;k++){
											if(strTransActors[k]!=null&&!"".equals(strTransActors[k])&&tempNode.getTransActor().indexOf(strTransActors[k])<0){
												tempNode.setTransActor(strTransActors[k]+"��"+tempNode.getTransActor());
											}
										}
		            				}
		            				lstChildren.remove(j);
		                        }
		            		}
		            	}
		            }
		            branches.addAll(lstChildren);
		%>
		    <tr>
		          <td colspan="100" class="td_title" align="center">����<%=branches.size() %>�����̷�֧</td>
		    </tr>
		    <tr>
		<%
		            //����ÿ����֧�Ĵ���
		            for(int i=0,iSize=branches.size();i<iSize;i++){
		                tempNode =(WorkFlowTrackVO) branches.get(i);
		                //write a branch
		                request.setAttribute("TrackNode",tempNode);
		                request.setAttribute("BranchChildren",listBranchChildren.get(i));
		%>
		    <td valign="top" class="branch"><jsp:include flush="false" page="TrackBranch.jsp"></jsp:include></td>
		<%

		            }
		%>
		    </tr>
		<%
		            // get cooprate end node
		            children = new ArrayList();
		            trackNode = WorkFlowTrackUtil.getCooperateEndNode(trackNode,children);
		        }else {
		            WorkFlowTrackVO tempNode = null;
		            //�������û�ڵ���ȡ��һ����ʼ�ڵ�
		            if(children==null||children.size()==0){
		                trackNode =getNextBeginNode();
		                children = new ArrayList();
		                children.add(trackNode);
		            }else {//����ȡ��һ�����ӽڵ�
		                trackNode=(WorkFlowTrackVO)children.get(0);
		            }
		            if(trackNode==null){
		                break;
		            }
		            //����Ǵ�����ڵ�,ȡ���д������˵�����
		            String transFlag = trackNode.getTransFlag();
		            if("0".equals(transFlag)&&!trackNode.isMultitrans()){
		                WorkFlowTrackUtil.mergeTransActor(trackNode,children);
		            }
		            //����Ƕ��˴���,����Ƿ����˶�������
		            if(trackNode.isMultitrans()&&children.size()>1){
		                multiTransFinished = (trackNode.getChildrenCount()>0);
		            }else {
		                multiTransFinished = true;
		            }
		        }
		    }
		%>
	</table>
	</td>

	<%
			}
	%>
	</tr>
</table>
</body>
</html>
