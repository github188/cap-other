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
<title>工作流跟踪表</title>
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
<script type="text/javascript">
<%if(!bNewWindow){%>
	setInterval("adjustPage()",500);
<%}%>

	//自适应大小
	function  adjustPage() {
		var w=0;
		var h=0;
		//添加try...catch,修改资产系统与EIP页面集成时，指定发送人员选择问题
		try{
	        if(self.location!=top.location) {
	        	try{
		            this.frameElement.width = "100%";
		            this.frameElement.height = document.body.scrollHeight + h;
		             }catch(e){
	            	// 用于供应商评估、评估计划、评价模块涉及到的查看流程页面：由于在外面又嵌套了一层框架
	
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
				// 还没有远程节点流程细节，则去后台取
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

//--新增打印--  2012-2-28 肖黎明
 function doPrint(){
 	try {
	 	PageSetup_default();
	 	document.getElementById("printPart").style.display="none";
	    var WebBrowser = document.getElementById("WebBrowser1");
		WebBrowser1.ExecWB(6,1);
	}catch(e){
		alert("打印控件没有加载或加载不成功，请设置允许控件加载运行！");
	}
	document.getElementById("printPart").style.display="";
    }

//--新增打印预览--  2012-2-28 肖黎明
function preview(){
	try {
		PageSetup_default();
		document.getElementById("printPart").style.display="none";
	 	var WebBrowser = document.getElementById("WebBrowser1");
		WebBrowser1.ExecWB(7,1);
	}catch(e){
		alert("打印控件没有加载或加载不成功，请设置允许控件加载运行！");
	}
	document.getElementById("printPart").style.display="";
}

	// 去掉网页打印的页眉页脚
	function PageSetup_Null(){
	    try {
            var Wsh=new ActiveXObject("WScript.Shell");
		    HKEY_Key="header";
		    Wsh.RegWrite(HKEY_Root+HKEY_Key,"");
		    HKEY_Key="footer";
		    Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"");
	    } catch(e){}
    }

	// 增加打印的页眉页脚，此处去掉了页脚中的地址&u
    function PageSetup_default(){
	    try {
            var Wsh=new ActiveXObject("WScript.Shell");
		    HKEY_Key="header";
		    Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"&w&b页码,&p/&P");
		    HKEY_Key="footer";
		    Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"&b&d");
	    } catch(e){}
    }

/*
 * 附件管理调用 2012-3-8 肖黎明
 * param moduleKey String 模块Code
 * param moduleObjectId String 单据ID
 * param rightFlag 权限标志,调用时必须使用com.comtop.ss.attachment.AttachmentConstants中定义的权限常量
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
    * 窗口关闭
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
            //	add by 肖黎明 2012-4-16 得到工作流配置参数
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
					out.println("该记录未上报或者无流程跟踪信息，不能查看流程跟踪表，可以查看流程图");
            		return;
            }
%>
<table width="100%" align="center" cellpadding="1px">
<%!
			List listBeginNode = null; // 用于存放流程跟踪中各开始节点
    		int iBeginNodeIndex = 0; // 开始节点的索引
    		String strSysName4MainTrack = ""; // 主流程所在的系统名
%>
<%
	            iBeginNodeIndex = 0;

				String strDebug = request.getParameter("pDebug");
	            boolean isDebug = "true".equalsIgnoreCase(strDebug);

				String strViewType = request.getParameter("flagForView"); // 流程跟踪查看的类型，是查看最初发起流程，还是查看本地流程，值为ori 和 local
	            if (strViewType == null || "".equals(strViewType)) {
	                strViewType = "local";
	            }
	            RemoteActivityInfo objRemoteActivityInfo = new RemoteActivityInfo(); // 跨流程审批流程跟踪远程节点信息对象
	            objRemoteActivityInfo.setFlowId(workFlowId);
	            objRemoteActivityInfo.setWorkId(workId);
	            boolean bIsOriSender = true; // 当前查看的流程是否是工作流最初发起流程（相对于本地系统）
	            boolean bIsGetMainFlowSuccess = true; // 获取主流程成功，默认为成功，主流程是指最初发起方流程
	            bIsOriSender = iWorkFlowUtilBizService.isOriFlow(objRemoteActivityInfo); // 获取当前要查看的流程是否是最初发起方流程
	            // 如果是流程的接收方，并且在接收方是要以”显示本地流程“的方式显示流程
	            if (!bIsOriSender && ("local".equalsIgnoreCase(strViewType))) {
	                listBeginNode = listSourcereport;
	                if (listBeginNode != null && listBeginNode.size() == 0) {
	                    listBeginNode = iWorkFlowUtilBizService.readWorkFlowTrackListTab(workFlowId,
	                            workId, strTableName);
	                }
	                strSysName4MainTrack = FlowInteractUtil.currGlobalSystemName();
	            } else {
	                // 获取最初发起流程的流程跟踪.
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
	                    bIsGetMainFlowSuccess = false; // 设置获取主流程失败
	                }
	            }

	            // 如果listBeginNode 还是为 null,则表明可能没有接收到数据，也可能是网络不通.
	            if (listBeginNode == null) {
	                bIsGetMainFlowSuccess = false; // 设置获取主流程失败
	                listBeginNode = listSourcereport; // 读取本地流程
	                if (listBeginNode != null && listBeginNode.size() == 0) {
	                    listBeginNode = iWorkFlowUtilBizService.readWorkFlowTrackListTab(workFlowId,
	                            workId, strTableName);
	                }
	                strSysName4MainTrack = FlowInteractUtil.currGlobalSystemName();
	            }
	            WorkFlowTrackVO trackNode = null;
	            List children = null;
	            //获取第一个节点(根节点)
	            trackNode = (WorkFlowTrackVO) getNextBeginNode();
	            if (trackNode == null) {
					out.println(generateDivForNodeStyle("获取流程开始节点数据失败!","left"));
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
						out.println(generateDivForNodeStyle("获取全部流程失败","right"));
	                    strViewType = "local";
	                } else if ("local".equalsIgnoreCase(strViewType)) {
						out.println(generateDivForNodeStyle("<a onclick=reloadTrack('ori')><span>查看全部流程</span></a>","right"));
	                } else {
						out.println(generateDivForNodeStyle("<a onclick=reloadTrack('local')><span>查看本地流程</span></a>","right"));
	                }
	            }

  				int iCount = 0;
	            boolean multiTransFinished = true;
	            String strWorkFlowId = trackNode.getWorkFlowId();
	            String strRowColor = "";

				WorkFlowTrackVO parentTrackNode = null;//当前循环trackNode的父节点
	            // 遍历所有节点
	            int iCounter = 0;
	            while (trackNode != null) {
	                iCounter++;
	                String strWaitTime = WorkFlowSupportUtil.getWaitTime(trackNode);
	                //判断是否是协同回退的节点  王正亮
	                strWorkFlowId = trackNode.getWorkFlowId();
	                if (strWorkFlowId != null && !"".equals(strWorkFlowId)
	                        && !"null".equals(strWorkFlowId)) {
	                    strTableName = WorkFlowSupportUtil.getTableName(strWorkFlowId);
	                }
	                String backMethod = "NOMORL";
                     //此处为了处理对于子流程的节点，不能进行此判断操作
                    //从而也导致子流程中不能有协同操作
                    if(trackNode.getTransWorkFlowId().equals(trackNode.getAllocateWorkFlowId())&&trackNode.getTransWorkFlowId().equals(strWorkFlowId)){
	                   backMethod = WorkFlowTrackUtil.cooperatBranchesBackwardState(trackNode,parentTrackNode, strWorkFlowId);
                    }
	                if (iCount % 2 == 0) {
	                    strRowColor = "#ffffff";
	                } else {
	                    strRowColor = "#eff5fe";
	                }
	                iCount++;
	                if (WorkFlowTrackUtil.isNoFlowEntryNode(trackNode)) {//无上报节点
						out.println(generateTrForNoFlowEntryNode(transNullString(trackNode.getTaskName())));
	                } else if (WorkFlowTrackUtil.isReceFlowDefaultEntryNode(trackNode)) {
	                    trackNode = WorkFlowTrackUtil.makeChildrenDefaultEntry(trackNode);
	                    iCount--;
	                    continue;
	                } else if (WorkFlowTrackUtil.isRemoteNode(trackNode)) {//远端节点
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
									style="display:none;"><span><a href="#">点击收缩详情</a></span>
								</div>
								<div id="showDivTip" class="table_node_frame01_but"><span><a href="#">点击查看详情</a></span>
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
	               } else if (trackNode.getTransFlag().equals("5")) {//等待协同结束节点
						out.println(WorkFlowSupportUtil.generateTrForWaitCoopEndNode(trackNode,strRowColor));
	          	   } else if (StringUtils.equals(backMethod, "COOPERBACK")
	                        && (trackNode.getBackFlag()).equalsIgnoreCase("T")
	                        && trackNode.getTransFlag().equalsIgnoreCase("0")) { // 协同回退时
						out.println(WorkFlowSupportUtil.generateTrForCoopBack(trackNode,strRowColor));
	               } else if (trackNode.getTransFlag().equals("7") && trackNode.isCooperateEnd()) {//被中断节点
	                    //被中断节点都不显示
	               } else if (!trackNode.getTransFlag().equals("0") && multiTransFinished) { //已处理节点
						String strDivImg = WorkFlowSupportUtil.generateDivImgForDoneNode(parentTrackNode,trackNode,
            				strRoot,backMethod,iCount);
						out.println(WorkFlowSupportUtil.generateTrForDoneNode(strDivImg,strRowColor ,
            				trackNode,children,bDeptAndDuty,bAttachment,strWaitTime,strRoot));
					} else {// 待处理节点
						String strDivImg = WorkFlowSupportUtil.generateDivImgForDoingNode(parentTrackNode,trackNode,
            				strRoot,backMethod,iCount);
						out.println(WorkFlowSupportUtil.generateTrForDoingNode(strDivImg,strRowColor ,
            				trackNode,children,bDeptAndDuty,bAttachment,strWaitTime,strRoot));
	                }

	                //取出下一个节点的列表
	                children = trackNode.getChildrenTrack();
	                //modified by 因跨节点上报下发功能，之前逻辑现会有问题，故重写了进入分支页面的业务逻辑
	                if (isCooperateToBranch(trackNode)) {//协同分支 进入TrackBranch.jsp
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
					<td colspan="100" class="td_title" align="center">共有<%=branches.size()%>个流程分支</td>
				</tr>
<%
						}
%>
				<tr>
<%
		                //get cooprate end node
		                children = new ArrayList();
		                parentTrackNode = trackNode;//因拿不到分支父节点，故协同结束的父节点这里为协同开始
		                trackNode = WorkFlowTrackUtil.getCooperateEndNode(trackNode, children);
		                //如果trackNode为null则去找他的下一个申请人节点，如果有，
		                //则说明是从协同分支内部回退到申请人节点的，如果没有则说明是在协同内部没有出协同  王正亮
		                if (trackNode == null) {
		                    trackNode = getNextBeginNode();
		                }
		                //生成每个分支的代码
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
	                    //对协同分支显示完成后对返回的节点判断其如果是多人处理是否处理完  王正亮 2011-12-27
	                    if (null != trackNode && trackNode.isMultitrans() && children.size() > 1) {
	                        if (trackNode.getChildrenCount() > 0) {
	                            multiTransFinished = true;
	                        }
	                        //add by 李欢 解决从多人处理节点回退到申请人流程跟踪表在多人处理任然显示待办的问题
	                        else {
	                            //读取下一个回退换申请人节点
	                            multiTransFinished = false;
	                            WorkFlowTrackVO objEntryWorkFlowTrackVO = getNextBeginNode();
	                            if (null != objEntryWorkFlowTrackVO) {
	                                //取出来之后要将序号还原
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
	                    //如果后面没节点则取下一个开始节点
	                    if (children == null || children.size() == 0) {
	                        parentTrackNode=null;
	                        trackNode = getNextBeginNode();
	                        children = new ArrayList();
	                        children.add(trackNode);
	                    } else {//否则取第一个儿子节点
	                        parentTrackNode = trackNode;
	                        trackNode = (WorkFlowTrackVO) children.get(0);
	                    }
	                    if (trackNode == null) {
	                        break;
	                    }
	                    //如果是待处理节点,取所有待处理人的名字
	                    String transFlag = trackNode.getTransFlag();
	                    if ("0".equals(transFlag) && !trackNode.isMultitrans()) {
	                        WorkFlowTrackUtil.mergeTransActor(trackNode, children);
	                    }
	                    //如果是多人处理,检测是否多个人都处理完
	                    if (trackNode.isMultitrans() && children.size() > 1) {
	                        if (trackNode.getChildrenCount() > 0) {
	                            multiTransFinished = true;
	                        }
	                        //add by 李欢 解决从多人处理节点回退到申请人流程跟踪表在多人处理任然显示待办的问题
	                        else {
	                            //读取下一个回退换申请人节点
	                            multiTransFinished = false;
	                            WorkFlowTrackVO objEntryWorkFlowTrackVO = getNextBeginNode();
	                            if (null != objEntryWorkFlowTrackVO) {
	                                //取出来之后要将序号还原
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
	                            } else {//最后一个节点为多人处理
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

		//生成远端节点表格
		private String generateTableForRemoteTrack(WorkFlowTrackVO trackNode,String waitTime,boolean bDeptAndDuty){
			String tableString = "<table width='60%' border='1' cellspacing='0' cellpadding='0' class='table_list table_node_frame01_table'>"
										    +"<tr><td width='15%' align='left'>流程步骤名称：</td>"
												+"<td width='15%'>"+transNullString(trackNode.getActName())+"</td>"
												+"<td width='10%'>停&nbsp;&nbsp;留&nbsp;&nbsp;时&nbsp;&nbsp;长：</td>"
												+"<td width='20%'>"+waitTime+"</td></tr>";
			if (bDeptAndDuty) {
					tableString += "<tr><td width='10%'>处&nbsp;理&nbsp;人部门名称&nbsp;：</td>";
					tableString += "<td width='20%'>"+transNullString(trackNode.getDepartmentFullName())+"</td>";
					tableString += "<td width='15%' align='left'>处&nbsp;理&nbsp;人&nbsp;职&nbsp;&nbsp;务：</td>";
					tableString += "<td width='15%'>"+transNullString(trackNode.getDuty())+"</td></tr>";
			}
			tableString +=	"<tr><td width='15%' align='left'>处&nbsp;&nbsp;&nbsp;理&nbsp;&nbsp;&nbsp;人：</td>"
					+"<td align='left' colspan='100'><font color='red'>"+transNullString(trackNode.getTransActor())+transNullString(trackNode.getDeputy())+"</font></td></tr>";
			tableString +="</table>";
			return tableString;
		}

		//生成图片DIV
		private String generateDivForImg(String imgUrl){
			String divString =  "<div class='arrow'><img src='"+imgUrl+"'></div>";
			return divString;
		}

		//生成NoFlowEntryNode字符串
		private String generateTrForNoFlowEntryNode(String actName){
			String trString = "<tr><td colspan='100' align='center'>"
								+ "<table width='60%' border='1' cellspacing='0' cellpadding='0' class='table_list'>"
								+ "<tr><td width='25%' align='left'>流程步骤名称：</td>"
								+ "<td width='25%'>"+actName+"</td>"
								+ "<td width='25%' align='left'>处&nbsp;&nbsp;理&nbsp;&nbsp;时&nbsp;&nbsp;间：</td>"
								+ "<td align='left'><font color='red'>&nbsp; </font></td></tr></table></td></tr>";
			return trString;
		}


		//生成DIV样式
		private String generateDivForNodeStyle(String str,String agile){
			String divString = "<div class='node_buttom01' "
								+"style='float:"+agile+";font-size:14px;margin:5px 5px 5px 5px;'><span>"
								+str+"</span></div>";
			return divString;
		}

		//生成按钮
		private String generateButtonString(){
				String buttonString ="<div id='printPart'><table width='100%' id='printPart'>" +
					   					"<tr><td align='right'><input type='button' class='btn_href' value='打印预览' onclick='preview();'>&nbsp;"+
										"<input type='button' class='btn_href' value='打&nbsp;&nbsp;印' onclick='doPrint();'>&nbsp; "+
					  					"<input type='button' class='btn_href' value='关&nbsp;&nbsp;闭' onclick='closeWindow();'>&nbsp;</td></tr></table></div>";
				return buttonString;
		}

		/**
     * 获取下一个开始节点
     */
    WorkFlowTrackVO getNextBeginNode() {
        try {
            return (WorkFlowTrackVO) listBeginNode.get(iBeginNodeIndex++);
        } catch (Exception ex) {
            return null;
        }
    }

	/**
     *  是否为协同开始协同结束到协同分支
     *  之前的判断逻辑为：
     *     1.是否为协同结束回退到协同分支
     *     2.当前节点为协同开始节点，当前节点子节点不为协同开始或协同结束
     *
     *  因增加了跨节点上报或下发，协同开始下发不一定就是协同分支
     *  故现在的判断逻辑为：
     *     1.当前节点为协同开始或协同结束
     *     2.当前节点子节点为协同分支节点
     *
     *  @param trackNode 当前流程节点对象
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
     *  当前节点是否为协同分支
     *  @param trackNode 当前流程节点对象
     */
    private boolean isCooperateBranch(WorkFlowTrackVO trackNode) {
		//首先采用新字段来判断是否是协同分支里
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
     *  通过trackNode 获得主流程处理节点ID：
     *   1.trackNode如果为主流程节点，直接返回TransNodeId
     *   2.trackNode如果为子流程节点，返回子流程在主流程的节点ID
     *  @param trackNode 当前流程节点对象
     */
    private String getMainFLowTransNodeId(WorkFlowTrackVO trackNode){
        String mainWorkflowId = trackNode.getWorkFlowId();
        if(!mainWorkflowId.equals(trackNode.getTransWorkFlowId())){//子流程节点情况
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
	    //合并分支(1个分支可以有多个处理记录)
	    //将相同节点的孩子集合放到一个branchChildren集合里（包括多人处理） add by 龚斌 2012-05-05
	    Map objTempMap = new HashMap(20);
	    for (int i = 0, iSize = children.size(); i < iSize; i++) {
	          WorkFlowTrackVO tempNode = (WorkFlowTrackVO) children.get(i);
	          String nodeKey = tempNode.getTransWorkFlowId() + ":" + tempNode.getTransNodeId();
	          //从MAP中读取孩子集合
	          List objBranchChildren = (List) objTempMap.get(nodeKey);
	          //如果没有该孩子集合，则创建孩子集合，key为流程ID:节点ID
	          if (null == objBranchChildren) {
	                objBranchChildren = new ArrayList();
	                objBranchChildren.add(tempNode);
	                objTempMap.put(nodeKey, objBranchChildren);
					listBranchChildren.add(objBranchChildren);
	         } else {
	                 //如果已经存在该孩子集合，则将该节点孩子加入该集合
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
	                          String[] strTransActors = lastNode.getTransActor().split("、");
                              String[] strTransActorIds = lastNode.getTransActorId().split("、");
	                          for (int k = 0; k < strTransActors.length; k++) {
	                                if (strTransActors[k] != null&& !"".equals(strTransActors[k])
	                                          && tempNode.getTransActor().indexOf(strTransActors[k]) < 0) {
	                                      tempNode.setTransActor(strTransActors[k] + "、"+ tempNode.getTransActor());
                                          tempNode.setTransActorId(strTransActorIds[k] + "、"+ tempNode.getTransActorId());
	                                  }
	                          }
	                     }

	                }
	                // 2011-07-06 阮祥兵 修改：将remove语句从if(!lastNode.isMultitrans())中移到if块后面。多人处理也是需要删除相同节点的FlowControl记录的
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