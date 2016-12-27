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
<title>工作流跟踪图</title>
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

/*增加 表体背景色值 #f5f5f5*/
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
    // 获取传递的参数
    String strNodeId = (String)request.getParameter("nodeId");
	String strFlowId = (String)request.getParameter("flowId");
	String strWorkId = (String)request.getParameter("workId");
	String strFlowControlId = (String)request.getParameter("flowControlId");
	String strSysName = (String)request.getParameter("sysName"); // 该远程节点所在的系统名
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
	// 所有系统的流程跟踪
	WorkFlowTrackInfo objWorkFlowTrackInfo = iWorkFlowUtilBizService.getRemoteTrack(objRemoteActivityInfo);
	List lstAllRemoteTrack = null;
	if (objWorkFlowTrackInfo != null) {
	    lstAllRemoteTrack = objWorkFlowTrackInfo.getTrack();
	}
	if (lstAllRemoteTrack == null) {
%>
	    <div class="node_buttom01" style="float:left;font-size:14px;margin:5px 5px 5px 5px;">
	    <%out.println("<span>获取该步骤的审批情况失败</span>");%>
	    </div>

<%
	    return;
	}

	// 遍历用的变量
	WorkFlowTrackVO trackNode =null;
	List children = null;
%>
<%
	//模块路径
	String strModulePath = request.getParameter("pModulePath");
	if ( null != strModulePath && !"".equals(strModulePath) ){
		 strModulePath = "/"+strModulePath;
	}
	else if(null == strModulePath){
		strModulePath = "";
	}
%>
<script type="text/javascript">
	    //自适应大小
    function  adjustPageRemote() {
		var w=0;
		var h=0;

		//修改资产系统与EIP页面集成时，指定发送人员选择问题
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
				// 还没有远程节点流程细节，则去后台取
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
	// 单个系统的流程跟踪
	List lstSingleTrack = null;
	String strToSysteName = "";
	// 索引
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
						信息无法获取
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

			    String strBackFlag       = "";      //是否是回退的步骤，“T”--是；“F”--否
			    String strActName       = "";      //节点名称
			    String strTransFlag         = "";      //处理标志0--未处理;1--已处理;2--同组人已处理;3--流程被终止;4--已完成;5--协同处理部分分支结束
			    String strTransActor       = "";      //处理人
			    String strDeputy = "";				//委托人
			    String strConFlag       = "";      //结论标志
			    String strNotion        = "";      //处理意见
			    String strRowColor = "";
			    String strTransDate         = "";      //处理日期
			    String strControlId = "";

		%>
		<td width="1%" align="center" style="vertical-align:top;">
			<table>
			<tr><td><%=WFSystemMappingHelper.getSystemNameByCode(strToSysteName) %></td></tr>
			</table>
			<table width="100%">
		<%
		   // 遍历所有节点
	    	while(trackNode != null) {
				// write itself
		        strActName	= trackNode.getTaskName();		//节点名称
		        strTransFlag= trackNode.getTransFlag();	//处理标志
		        strBackFlag		= trackNode.getBackFlag();	//是否是回退的
		        strTransActor = trackNode.getTransActor();//处理人
		        strDeputy = WorkFlowTrackUtil.getDeputyInfo(trackNode.getDeputy());	// 代理人信息
		        strNotion	= trackNode.getNote();			//意见
		        strConFlag	= trackNode.getResultFlag();	//结论

		        strNodeId = trackNode.getTransNodeId();
		        strFlowId = trackNode.getWorkFlowId();
		        strWorkId = trackNode.getWorkId();
		        strControlId = trackNode.getId();


		        //处理日期
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
				// 如果是虚拟开始节点
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
					            	<div id="hiddenDivTip" class="table_node_frame02_but" style="display:none;"><span><a href="#">点击收缩详情</a></span></div>
									<div id="showDivTip" class="table_node_frame01_but"><span><a href="#">点击查看详情</a></span></div>
									<div id="hiddenDiv" style="display:none;"></div>
									<div id="showDiv" >
							            <table width="60%" border="1" cellspacing="0" cellpadding="0" class="table_list table_node_frame01_table" >
											<tr>
							                    <td width="15%" align="left" >流程步骤名称：</td>
							                    <td align="left" ><%=strActName%><font color="red">&nbsp; </font></td>
							                </tr>
							                <tr>
							                    <td width="15%"  align="left">处&nbsp;&nbsp;&nbsp;理&nbsp;&nbsp;&nbsp;人：</td>
							                    <td align="left"   ><font color="red"><%=strTransActor%><%=strDeputy%></font></td>
							                </tr>
							            </table>
							         </div>
						       </div>
			        		</td>
	            		</tr>
         <%
		        } else if (strTransFlag.equals("5")){    // 协同处理部分分支结束
		%>
				    <tr>
				        <td colspan="100" align="center">
				            <table CLASS="table_list"  border="1" cellspacing="0" cellpadding="3" bgcolor=<%=strRowColor%>>
				                <tr >
				                    <td width="15%" align="left" >流程步骤名称：</td>
				                    <td align="left" width="85%" colspan="100"><%=strActName%><font color="red">&nbsp; (等待分支结束)</font></td>
				                </tr>
				                <tr >
				                    <td width="10%"  align="left">处&nbsp;&nbsp;&nbsp;理&nbsp;&nbsp;&nbsp;人：</td>
				                    <td align="left"  colspan="100" ><font color="red"><%=strTransActor%><%=strDeputy%></font></td>
				                </tr>
				            </table>
				        </td>
				    </tr>

		<%

		    	}else if (!strTransFlag.equals("0") && multiTransFinished){    // 已处理节点
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
		                <td width="15%" align="left" >流程步骤名称：</td>
		                <%if(strTransFlag.equals("4")){%>
		                    <td align="left" width="85%" colspan="100"><%=strActName%><font color='red'>&nbsp;（流程审批结束）</font></td>
		                <%}else if(strTransFlag.equals("3")){%>
		                    <td align="left" width="85%" colspan="100"><%=strActName%><font color='red'>&nbsp;（流程终止）</font></td>
		                <%}else{%>
		                    <td align="left" width="85%" colspan="100"><%=strActName%></td>
		                <%}%>
		            </tr>
		            <%
		            //多人处理
		                if(trackNode.isMultitrans() && children != null){
		                    WorkFlowTrackVO tempNode = null;
		                    String[] strRowHTML = new String[]{"","","",""};
		                    for(int i=0,iSize=children.size();i<iSize;i++){
		                        tempNode = (WorkFlowTrackVO)children.get(i);
		                        strTransDate = (tempNode.getTransDate()==null?"&nbsp;":PubFunctions.formatDateTime(tempNode.getTransDate(),"yyyy-MM-dd H:mm"));
		                        strTransActor = tempNode.getTransActor();//处理人
		                        strDeputy = WorkFlowTrackUtil.getDeputyInfo(tempNode.getDeputy());
		                        strNotion   = tempNode.getNote();           //意见
		                        strConFlag  = tempNode.getResultFlag(); //结论
		                        if(strNotion==null){
		                            strNotion="";
		                        }

		                        strRowHTML[0]+="<td align='left' nowrap='true' title='处理日期:"+strTransDate+"'>"+strTransActor+strDeputy+"</td>";
		                        strRowHTML[1]+="<td align='left' nowrap='true'>"+strTransDate+"</td>";
		                        strRowHTML[2]+="<td align='left' nowrap='true'>"+(trackNode.getResult() == null ? "" : trackNode.getResult())+"</td>";
		                        strRowHTML[3]+="<td align='left' nowrap='true'>"+strNotion+"</td>";
							}
		            %>
		            <tr>
		                <td width="15%" align="left" nowrap="true">
		                    处　 理 　人：
		                </td>
		                <%=strRowHTML[0] %>
		             </tr>
		             <tr>
		             	<td>处&nbsp;理&nbsp;时&nbsp;间：</td>
		             	<%=strRowHTML[1] %>
		             </tr>
		            <tr>
		                <td width="15%" align="left" nowrap="true">
		                    结　　　　论：
		                 </td>
		                 <%=strRowHTML[2] %>
		             </tr>
		            <tr>
		                <td width="15%" align="left" nowrap="true">
		                    处&nbsp;&nbsp;理&nbsp;&nbsp;意&nbsp;&nbsp;见：
		                </td>
		                <%=strRowHTML[3] %>
		            </tr>
		            <%
		            }else {//非多人处理
		            %>
		            <tr>
		                <td width="15%" align="left">处&nbsp;&nbsp;理&nbsp;&nbsp;日&nbsp;&nbsp;期：</td>
		                <td align="left" width="35%" ><%=strTransDate%></td>
		                <td width="10%"  align="left">处&nbsp;&nbsp;&nbsp;理&nbsp;&nbsp;&nbsp;人：</td>
		                <td align="left" width="15%" width=""><%=strTransActor%><%=strDeputy%></td>
		                <td width="10%" align="left">结&nbsp;&nbsp;&nbsp;&nbsp论：</td>
		                <td align="left" width="15%" ><%=trackNode.getResult() == null ? "" : trackNode.getResult()%></td>
		            </tr>
		            <tr>
		                <td width="15%" align="left" >处&nbsp;&nbsp;理&nbsp;&nbsp;意&nbsp;&nbsp;见：</td>
		                <td align="left" width="85%" colspan="100" class="break-word"><%=strNotion%></td>
		            </tr>
		            <%} %>
		        </table>
		        </td>
		    </tr>
		<%
		    	}else {// 待处理节点
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
		            //多人处理
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
		                    strTransActor = tempNode.getTransActor();//处理人
		                    strDeputy = WorkFlowTrackUtil.getDeputyInfo(tempNode.getDeputy());
		                    strNotion   = tempNode.getNote();           //意见
		                    strConFlag  = tempNode.getResultFlag(); //结论
		                    if(strNotion==null){
		                        strNotion="";
		                    }
		                    strRowHTML[0]+="<td align='left' nowrap='true' title='处理日期:"+strTransDate+"'>"+strTransActor+strDeputy+"</td>";
		                    strRowHTML[1] += "<td width='"+strWidth+"' align='left' nowrap='true'>" +strTransDate + "</td>";
		                    if("1".equals(strTransFlag)){
		                        strRowHTML[2]+="<td width='"+strWidth+"' align='left' nowrap='true'>已处理</td>";
		                        strRowHTML[3]+="<td width='"+strWidth+"' align='left' nowrap='true'>"+(trackNode.getResult() == null ? "" : trackNode.getResult())+"</td>";
		                        strRowHTML[4]+="<td width='"+strWidth+"' align='left' class='break-word'>"+strNotion+"</td>";
		                    }else {
		                        strRowHTML[2]+="<td width='"+strWidth+"' align='left' nowrap='true'><font color='red'>未处理</font></td>";
		                        strRowHTML[3]+="<td width='"+strWidth+"' align='left' nowrap='true'></td>";
		                        strRowHTML[4]+="<td width='"+strWidth+"' align='left' nowrap='true'></td>";
		                    }
		                  }
		%>
		                <tr >
		                    <td align="left" nowrap='true'>流程步骤名称：</td>
		                    <td align="left" width="85%" colspan="100"  nowrap='true'><%=strActName%><font color="red">&nbsp; (待处理中)</font></td>
		                </tr>
		                <tr>
		                    <td align="left" nowrap="true">
		                        处　 理 　人：
		                    </td>
		                    <%=strRowHTML[0] %>
		                </tr>
		                 <tr>
		                    <td align="left" nowrap="true">
		                        处&nbsp;理&nbsp;时&nbsp;间：
		                    </td>
		                    <%=strRowHTML[1] %>
		                	</tr>
		                <tr>
		                    <td align="left" nowrap="true">
		                        处&nbsp;&nbsp;理&nbsp;&nbsp;状&nbsp;&nbsp;态：
		                    </td>
		                    <%=strRowHTML[2] %>
		                </tr>
		                <tr>
		                    <td align="left" nowrap="true">
		                        结　　　　论：
		                    </td>
		                     <%=strRowHTML[3] %>
		                </tr>
		                <tr>
		                    <td align="left" nowrap="true">
		                        处&nbsp;&nbsp;理&nbsp;&nbsp;意&nbsp;&nbsp;见：
		                    </td>
		                    <%=strRowHTML[4] %>
		                </tr>
		<%
		            }else {//非多人处理
		%>
		                <tr >
		                    <td width="15%" align="left" >流程步骤名称：</td>
		                    <td align="left" width="85%" colspan="100"><%=strActName%><font color="red">&nbsp; (待处理中)</font></td>
		                </tr>
		                <tr >
		                    <td width="10%"  align="left">处&nbsp;&nbsp;&nbsp;理&nbsp;&nbsp;&nbsp;人：</td>
		                    <td align="left" colspan="100" ><font color="red"><%=strTransActor%><%=strDeputy%></font></td>
		                </tr>
		<%          } %>
		            </table>
		        </td>
		    </tr>
		<%
		        }
		        //取出下一个节点的列表
		    	children = trackNode.getChildrenTrack();
		        //获取下一个节点的回退标志
		        String strNextNodeBackFlag = null;
		        if(children!=null && !children.isEmpty()){
		            WorkFlowTrackVO nextNode = (WorkFlowTrackVO)children.get(0);
		            strNextNodeBackFlag = nextNode.getBackFlag();
		        }
		        //协同开始，并且不是回退的
		        if(trackNode.isCooperateBegin() && !"T".equalsIgnoreCase(strNextNodeBackFlag)){
		            WorkFlowTrackVO lastNode = null;
		            WorkFlowTrackVO tempNode = null;
		            List branches = new ArrayList();
		            List listBranchChildren = new ArrayList();
		            List branchChildren = new ArrayList();
		            //合并分支(1个分支可以有多个处理记录)
		            for(int i=0,iSize=children.size();i<iSize;i++){
		                tempNode =(WorkFlowTrackVO) children.get(i);
		                //合并同一个分支的记录(transNodeId和transWorkFlowId相同)
		                if(lastNode!=null && tempNode.getTransNodeId().equals(lastNode.getTransNodeId())
		                        &&tempNode.getTransWorkFlowId().equals(lastNode.getTransWorkFlowId())){
		                    if(!tempNode.isMultitrans()){
		                        lastNode.setTransActor(lastNode.getTransActor()+"、"+tempNode.getTransActor());
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
										String[] strTransActors = lastNode.getTransActor().split("、");
										for(int k = 0;k<strTransActors.length;k++){
											if(strTransActors[k]!=null&&!"".equals(strTransActors[k])&&tempNode.getTransActor().indexOf(strTransActors[k])<0){
												tempNode.setTransActor(strTransActors[k]+"、"+tempNode.getTransActor());
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
		          <td colspan="100" class="td_title" align="center">共有<%=branches.size() %>个流程分支</td>
		    </tr>
		    <tr>
		<%
		            //生成每个分支的代码
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
		            //如果后面没节点则取下一个开始节点
		            if(children==null||children.size()==0){
		                trackNode =getNextBeginNode();
		                children = new ArrayList();
		                children.add(trackNode);
		            }else {//否则取第一个儿子节点
		                trackNode=(WorkFlowTrackVO)children.get(0);
		            }
		            if(trackNode==null){
		                break;
		            }
		            //如果是待处理节点,取所有待处理人的名字
		            String transFlag = trackNode.getTransFlag();
		            if("0".equals(transFlag)&&!trackNode.isMultitrans()){
		                WorkFlowTrackUtil.mergeTransActor(trackNode,children);
		            }
		            //如果是多人处理,检测是否多个人都处理完
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
