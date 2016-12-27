function getMainHTML(lstNodeTrack,mainHTML){
	for(var i=0,len = lstNodeTrack.length;i < len;i++){ 
	     var bpmsTrackInfo = lstNodeTrack[i]; 
		 var arrColTrackInfo = bpmsTrackInfo.colTransTrackInfo; 
		 var now = getFormatDate(); 
		 var status = bpmsCompleteTypeEnum(bpmsTrackInfo.curNodeInsStatus);
		 mainHTML += "<tr><td id='"+bpmsTrackInfo.trackId+"'>";
		 //如果当前是子流程跟踪
		 if(bpmsTrackInfo.trackType == 3){ 
			 mainHTML += getSubflowHTML(bpmsTrackInfo,""); 	
		 } 
		//如果当前是协同流程跟踪
		 else if(bpmsTrackInfo.trackType == 2){ 
			 mainHTML += getCooperateHTML(bpmsTrackInfo,""); 
		 } 
		//如果当前是发送任务或接收任务
		 else if(bpmsTrackInfo.trackType == 4 || bpmsTrackInfo.trackType == 5){ 
			 mainHTML += getRemoteHTML(bpmsTrackInfo,""); 
		 } 
		 else if(arrColTrackInfo.length > 1){ 
			mainHTML += "<table style='background-color:#e6e7eb;width:100%;min-width:620px;min-height:120px'>";
				mainHTML +="<tr>";
					mainHTML +="<td>";
						mainHTML +="<table>";
							mainHTML +="<tr style='height:35px'>";
								mainHTML +="<td width='80'>\u8282\u70b9\u540d\u79f0:</td>";
								mainHTML +="<td width='220'><div class='text-overhidden-block' title='"+bpmsTrackInfo.curNodeName+"' style='width:220px;'>"+bpmsTrackInfo.curNodeName+"</div></td>";
								mainHTML +="<td width='80'>\u8282\u70b9\u72b6\u6001:</td>";
							if(bpmsTrackInfo.curNodeInsStatus==1){
								mainHTML +="<td width='80'><div class='text-overhidden-block' title='"+status+"' style='width:150px;color:red'>"+status+"</div></td>";
							}else{
								mainHTML +="<td width='80'><div class='text-overhidden-block' title='"+status+"' style='width:150px;'>"+status+"</div></td>";
							}
							mainHTML +="</tr>";
						mainHTML +="</table>";
					mainHTML +="</td>";
				 mainHTML +="</tr>";
				 for(var j=0;j<arrColTrackInfo.length;j++){
				 mainHTML +="<tr>";
					mainHTML +="<td>";
						mainHTML +="<table class='mul-porpel' style='padding-bottom:2px;'>";
							mainHTML +="<tr>";
								mainHTML +="<td style='width:40px;'><img src='./images/flow_people.png' alt='\u5934\u50cf' style='height:41px;'/></td>";
								mainHTML +="<td style='width:80px;algin:left;'>";
									mainHTML +="<table>";
										mainHTML +="<tr>";
											//加上委托的相关信息
											var transActor = arrColTrackInfo[j].actorName;
											if("" != formatString(arrColTrackInfo[j].authorizerId)){
												transActor = transActor+"(\u59d4\u6258\u4eba："+arrColTrackInfo[j].authorizerName+")";
											}
											mainHTML +="<td title='"+transActor+"' class='text-overhidden-block' style='max-width:80px'>"+transActor+"</td>";
										mainHTML +="</tr>";
										mainHTML +="<tr>";
											mainHTML +="<td title='"+formatString(arrColTrackInfo[j].actorDepartmentName)+"' class='text-overhidden-block' style='margin-top:12px;height:15px;line-height:15px;'>"+formatString(arrColTrackInfo[j].actorDepartmentName)+"</td>";	
										mainHTML +="</tr>";
									mainHTML +="</table>";
								mainHTML +="</td>";
								mainHTML +="<td style='width:80px;algin:left;'>";
								if(bpmsTrackInfo.end){ 
									status = "\u6d41\u7a0b\u5ba1\u6279\u7ed3\u675f"; 
									mainHTML +="<img src='./images/people-end-small.png' alt='\u7ed3\u675f' style='height:41px;'/>";
								}else if(arrColTrackInfo[j].transFlag==1 || arrColTrackInfo[j].transFlag==2){
									mainHTML +="<img src='./images/people-load-small.png' alt='\u5f85\u5904\u7406' style='height:41px;'/>";
								}else if(bpmsTrackInfo.curNodeInsStatus==3 && arrColTrackInfo[j].completeType == 3){
									mainHTML +="<img src='./images/people-back-small.png' alt='\u56de\u9000' style='height:41px;'/>";
								}else{
									mainHTML +="<img src='./images/people-next-small.png' alt='\u4e0b\u53d1' style='height:41px;'/>";
								}
								mainHTML +="</td>";
								if(arrColTrackInfo[j].transFlag==1 || arrColTrackInfo[j].transFlag==2){
								mainHTML +="<td width='80'>\u5206\u914d\u65f6\u95f4:</td>";
								mainHTML +="<td width='80'><div class='text-overhidden-block' title='"+formatDate(arrColTrackInfo[j].createTime)+"'>"+formatDate(arrColTrackInfo[j].createTime)+"</div></td>";																							
								mainHTML +="<td width='80'>\u505c\u7559\u65f6\u957f:</td>";
								mainHTML +="<td width='80'><div class='text-overhidden-block' title='"+getStayTime(arrColTrackInfo[j].curDBTime,arrColTrackInfo[j].createTime)+"'>"+getStayTime(arrColTrackInfo[j].curDBTime,arrColTrackInfo[j].createTime)+"</div></td>";
								}else{
								mainHTML +="<td width='80'>\u5904\u7406\u65f6\u95f4:</td>";
								mainHTML +="<td width='80'><div class='text-overhidden-block' title='"+formatDate(arrColTrackInfo[j].overTime)+"'>"+formatDate(arrColTrackInfo[j].overTime)+"</div></td>";						
								mainHTML +="<td width='80'>\u5904\u7406\u8017\u65f6:</td>";
								mainHTML +="<td width='80'><div class='text-overhidden-block' title='"+getStayTime(arrColTrackInfo[j].overTime,arrColTrackInfo[j].createTime)+"'>"+getStayTime(arrColTrackInfo[j].overTime,arrColTrackInfo[j].createTime)+"</div></td>";
								} 
							mainHTML +="</tr>";
							mainHTML +="<tr>";
								mainHTML +="<td colspan='7'>";
									mainHTML +="<table>";
										mainHTML +="<tr style='height:30px'>";
											mainHTML +="<td width='60'>\u6d41\u7a0b\u7ed3\u8bba:</td>";
											mainHTML +="<td width='60'>"+formatString(arrColTrackInfo[j].resultFlag)+"</td>";
											mainHTML +="<td width='60'>\u5ba1\u6279\u610f\u89c1:</td>";
											mainHTML +="<td><div title='"+formatString(arrColTrackInfo[j].msg)+"' style='height:20px;line-height:20px;overflow:hidden;overflow-x:hidden;float:left;' class='text-overhidden-block'>"+formatString(arrColTrackInfo[j].msg)+"</div></td>";
										mainHTML +="</tr>";
									mainHTML +="</table>";
								mainHTML +="</td>";
							mainHTML +="</tr>";
						mainHTML +="</table>";
					mainHTML +="</td>";
				 mainHTML +="</tr>";
				 }
		 	mainHTML +="</table>";
		 }else{
		 	mainHTML +="<table style='background-color:#e6e7eb;width:100%;min-height:120px'>";
		 		mainHTML +="<tr>";
					mainHTML +="<td style='width:40px;'><img src='./images/flow_people.png' alt='\u5934\u50cf' style='height:51px;'/></td>";
					mainHTML +="<td style='width:80px;algin:left;'>";
			 			mainHTML +="<table>";
				 			mainHTML +="<tr>";
					 			//加上委托的相关信息
								var transActor = arrColTrackInfo[0].actorName;
								if("" != formatString(arrColTrackInfo[0].authorizerId)){
									transActor = transActor+"(\u59d4\u6258\u4eba："+arrColTrackInfo[0].authorizerName+")";
								}
					 			mainHTML +="<td title='"+transActor+"' class='text-overhidden-block text-people-info' style='max-width:80px'>"+transActor+"</td>";
							mainHTML +="</tr>";
						 	mainHTML +="<tr>";
								mainHTML +="<td title='"+formatString(arrColTrackInfo[0].actorDepartmentName)+"' class='text-overhidden-block' style='margin-top:12px;height:15px;line-height:15px;'>"+formatString(arrColTrackInfo[0].actorDepartmentName)+"</td>";	
							mainHTML +="</tr>";
						mainHTML +="</table>";
					mainHTML +="</td>";
					mainHTML +="<td width='80px'>";
						if(bpmsTrackInfo.end){
							mainHTML +="<img src='./images/people-end.png' alt='\u7ed3\u675f' style='height:51px;'/>";
						}else if(arrColTrackInfo[0].transFlag==1 || arrColTrackInfo[0].transFlag==2){
							mainHTML +="<img src='./images/people-load.png' alt='\u5f85\u5904\u7406' style='height:51px;'/>";
						}else if(bpmsTrackInfo.curNodeInsStatus==3 && arrColTrackInfo[0].completeType == 3){
							mainHTML +="<img src='./images/people-back.png' alt='\u56de\u9000' style='height:51px;'/>";
						}else{
							mainHTML +="<img src='./images/people-next.png' alt='\u4e0b\u53d1' style='height:51px;'/>";
						}
					mainHTML +="</td>";
					mainHTML +="<td>";
						mainHTML +="<table>";
							mainHTML +="<tr style='height:35px'>";
								mainHTML +="<td width='80'>\u8282\u70b9\u540d\u79f0:</td>";
								mainHTML +="<td width='220'><div class='text-overhidden-block' title='"+bpmsTrackInfo.curNodeName+"' style='width:220px;'>"+bpmsTrackInfo.curNodeName+"</div></td>";
								mainHTML +="<td width='80'>\u8282\u70b9\u72b6\u6001:</td>";
								if(bpmsTrackInfo.curNodeInsStatus==1){
									mainHTML +="<td width='80'><div class='text-overhidden-block' title='"+status+"' style='width:150px;color:red'>"+status+"</div></td>";
								}else{
									mainHTML +="<td width='80'><div class='text-overhidden-block' title='"+status+"' style='width:150px;'>"+status+"</div></td>";
								 } 
							mainHTML +="</tr>";
							mainHTML +="<tr style='height:30px'>";
								if(bpmsTrackInfo.curNodeInsStatus==1){
									mainHTML +="<td width='80'>\u5206\u914d\u65f6\u95f4:</td>";
									mainHTML +="<td width='220'><div class='text-overhidden-block' title='"+formatDate(bpmsTrackInfo.createTime)+"'>"+formatDate(bpmsTrackInfo.createTime)+"</div></td>";
									mainHTML +="<td width='80'>\u505c\u7559\u65f6\u957f:</td>";
									mainHTML +="<td width='150'><div class='text-overhidden-block' title='"+getStayTime(bpmsTrackInfo.colTransTrackInfo[0].curDBTime,bpmsTrackInfo.createTime)+"'>"+getStayTime(bpmsTrackInfo.colTransTrackInfo[0].curDBTime,bpmsTrackInfo.createTime)+"</div></td>";
								}else{ 
									mainHTML +="<td width='80'>\u5904\u7406\u65f6\u95f4:</td>";
									mainHTML +="<td width='220'><div class='text-overhidden-block' title='"+formatDate(bpmsTrackInfo.overTime)+"'>"+formatDate(bpmsTrackInfo.overTime)+"</div></td>";
									mainHTML +="<td width='80'>\u5904\u7406\u8017\u65f6:</td>";
									mainHTML +="<td width='150'><div class='text-overhidden-block' title='"+getStayTime(bpmsTrackInfo.overTime,bpmsTrackInfo.createTime)+"'>"+getStayTime(bpmsTrackInfo.overTime,bpmsTrackInfo.createTime)+"</div></td>";
								}
							mainHTML +="</tr>";
						mainHTML +="</table>";
					mainHTML +="</td>";
				mainHTML +="</tr>";
				mainHTML +="<tr style='height:30px'>";
					mainHTML +="<td width='60'>\u6d41\u7a0b\u7ed3\u8bba:</td>";
					mainHTML +="<td width='60'>"+formatString(arrColTrackInfo[0].resultFlag)+"</td>";
					mainHTML +="<td width='60'>\u5ba1\u6279\u610f\u89c1:</td>";
					mainHTML +="<td ><div title='"+formatString(arrColTrackInfo[0].msg)+"' style='height:20px;line-height:20px;overflow:hidden;overflow-x:hidden;float:left;word-break:break-all;text-overflow:ellipsis;'>"+formatString(arrColTrackInfo[0].msg)+"</div></td>";
				mainHTML +="</tr>";
			mainHTML +="</table>";
		}
		 mainHTML +="</td></tr>";
	} 
	return mainHTML;
}



//获取协作被发送方的流程HTML
function getRemoteHTML(bpmsTrackInfo,sendHTML){
	var curNodeInsId = bpmsTrackInfo.curNodeInsId;
	var curNodeId = bpmsTrackInfo.curNodeId;
	processInsId = bpmsTrackInfo.mainProcessInsId;
	var status = bpmsCompleteTypeEnum(bpmsTrackInfo.curNodeInsStatus);
	sendHTML += "<table style='background-color:#e6e7eb;width:100%;min-width:620px;min-height:120px'>";
		sendHTML += "<tr>";
			sendHTML +="<td style='width:40px;'><img src='./images/system.png' alt='\u7cfb\u7edf\u81ea\u52a8\u5904\u7406'  style='height:51px;'/></td>";
			sendHTML +="<td title='\u7cfb\u7edf\u81ea\u52a8\u5904\u7406' style='width:80px;algin:left;'>\u7cfb\u7edf\u81ea\u52a8\u5904\u7406</td>";
			sendHTML +="<td width='80px'>";
				if(bpmsTrackInfo.trackType == 4){
					sendHTML +="<img src='./images/send.png' onclick='getReceiveFlowTrack(4)' alt='\u53d1\u9001\u6d88\u606f' title='\u70b9\u51fb\u67e5\u770b\u63a5\u6536\u65b9\u6d41\u7a0b\u8ddf\u8e2a' style='cursor:pointer;height:80px;'/>";
				}else{
					sendHTML +="<img src='./images/recei.png' onclick='getReceiveFlowTrack(5)' alt='\u63a5\u6536\u6d88\u606f' title='\u70b9\u51fb\u67e5\u770b\u53d1\u9001\u65b9\u6d41\u7a0b\u8ddf\u8e2a' style='cursor:pointer;height:80px;'/>";
				}
			sendHTML +="</td>";
			sendHTML +="<td>";
				sendHTML +="<table>";
					sendHTML +="<tr style='height:35px'>";
						sendHTML +="<td width='80'>\u8282\u70b9\u540d\u79f0:</td>";
						sendHTML +="<td width='220'><div class='text-overhidden-block' title='"+bpmsTrackInfo.curNodeName+"' style='width:220px;'>"+bpmsTrackInfo.curNodeName+"</div></td>";
						sendHTML +="<td width='80'>\u8282\u70b9\u72b6\u6001:</td>";
						sendHTML +="<td width='220'><div class='text-overhidden-block' title='\u5df2\u5b8c\u6210'>\u5df2\u5b8c\u6210</div></td>";
					sendHTML +="</tr>";
					sendHTML +="<tr style='height:30px'>";
						sendHTML +="<td width='80'>\u5904\u7406\u65f6\u95f4:</td>";
						sendHTML +="<td width='80'><div class='text-overhidden-block' title='"+formatDate(bpmsTrackInfo.createTime)+"'>"+formatDate(bpmsTrackInfo.createTime)+"</div></td>";
						sendHTML +="<td width='80'>\u5904\u7406\u8017\u65f6:</td>";
						sendHTML +="<td width='150'><div class='text-overhidden-block' title='"+getStayTime(bpmsTrackInfo.overTime,bpmsTrackInfo.createTime)+"'>"+getStayTime(bpmsTrackInfo.overTime,bpmsTrackInfo.createTime)+"</div></td>";
					sendHTML +="</tr>";
				sendHTML +="</table>";
			sendHTML +="</td>";
		sendHTML += "</tr>";
		sendHTML += "<tr>";
			sendHTML += "<td colspan='4' align='center' valign='middle'>";
				if(bpmsTrackInfo.trackType == 5){
					sendHTML += "<span style='cursor:pointer' id='"+curNodeId+"' onclick='getRemoteFlowTrack(5)'>\u70b9\u51fb\u67e5\u770b\u53d1\u9001\u65b9\u6d41\u7a0b\u8ddf\u8e2a</span>";
				}else{
					sendHTML += "<span style='cursor:pointer' id='"+curNodeInsId+"'onclick='getRemoteFlowTrack(4)'>\u70b9\u51fb\u67e5\u770b\u63a5\u6536\u65b9\u6d41\u7a0b\u8ddf\u8e2a</span>";
				}
			sendHTML += "</td>";
		sendHTML += "</tr>";
	sendHTML += "</table>";
	return sendHTML;
}


//获取接收方流程跟踪数据
function getRemoteFlowTrack(trackType){
	var obj = window.event.srcElement;
	var title;
	var curNodeId;
	var curNodeInsId;
	var windowId;
	//打开发送方流程
	if(trackType == 5){
		title = "发送方流程跟踪";
		curNodeId = obj.id;
		windowId = processId+processInsId+curNodeId;
		
	}else{
		title = "接收方流程跟踪";
		curNodeInsId = obj.id;
		windowId = processId+processInsId+curNodeInsId;
	}
	var url = "BpmsRemoteFlowTrackList.jsp?processId="+processId+"&processInsId="
	+processInsId+"&trackKey="+trackKey+"&curNodeInsId="+curNodeInsId+"&curNodeId="+curNodeId+"&trackType="+trackType+"&webRootUrl="+webRootUrl;
	var objPWin = window.opener;
	var objCwin;
	if(objPWin){
		window.blur(); 
		objPWin.focus(); 
	}
	else{
		if(!objCwin){
			objCwin = openWindow(url,title);
		}else{
			window.blur(); 
			objCwin.focus(); 
		}
		
	}
}


//打开一个新窗口
function openWindow(url,windowName){
	var iTop = (window.screen.availHeight-900)/2;       //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-820)/2;       //获得窗口的水平位置;
	return window.open(url,"",'height='+900+',width='+820+',top='+iTop+',left='+iLeft+',toolbar=no,menubar=no,directories=no,scrollbars=yes,resizable=yes,location=no,status=no,z-look=yes,alwaysRaised=yes')
}


//获取接收方流程跟踪HTML
function getReceiveFlowTrackHTML(returnData,receiveFlowTrackHTML){
	receiveFlowTrackHTML +=   mainHTML += "<tr><td></td></tr>";
}


//获取协同的HTML
function getCooperateHTML(bpmsTrackInfo,coopHTML){
	 coopHTML += "<table><tr>";
	 var mapBpmsTrackVO = bpmsTrackInfo.mapBpmsTrackVO;
	 //分支数
	 var switchNum = _.size(mapBpmsTrackVO);
	 //计算每个分支
	 var now = getFormatDate(); 
	 for(var curProcessInsId in mapBpmsTrackVO){ 
		coopHTML += "<td id='"+bpmsTrackInfo.trackId+"' valign='top'>";
		var lstBpmsTrackVO = mapBpmsTrackVO[curProcessInsId];
		for(var j=0,len = lstBpmsTrackVO.length;j < len;j++){
			var childBpmsTrackInfo = lstBpmsTrackVO[j];
			var arrChildColTrackInfo = childBpmsTrackInfo.colTransTrackInfo;
			var status = bpmsCompleteTypeEnum(childBpmsTrackInfo.curNodeInsStatus);
			if(childBpmsTrackInfo.trackType == 3){ 
				coopHTML += getSubflowHTML(childBpmsTrackInfo,""); 
			 } 
			 else if(childBpmsTrackInfo.trackType == 2){
				coopHTML += getCooperateHTML(childBpmsTrackInfo,""); 
			 } 
			//如果当前是发送任务或接收任务
			 else if(childBpmsTrackInfo.trackType == 4 || childBpmsTrackInfo.trackType == 5){ 
				 coopHTML += getRemoteHTML(childBpmsTrackInfo,""); 
			 } 
			 else{ 
				 	if(arrChildColTrackInfo.length > 1){
				 		coopHTML += "<div style='padding-top:5px;'><table style='background-color:#e6e7eb;width:100%;min-width:600px;min-height:120px'>";
				 			coopHTML += "<tr>";
				 				coopHTML += "<td>";
				 					coopHTML += "<table>";
				 						coopHTML += "<tr style='height:35px'>";
				 							coopHTML += "<td width='60'>\u8282\u70b9\u540d\u79f0:</td>";
				 								coopHTML += "<td width='80'><div class='text-overhidden-block' title='"+childBpmsTrackInfo.curNodeName+"' style='width:80px;'>"+childBpmsTrackInfo.curNodeName+"</div></td>";
				 									coopHTML += "<td width='60'>\u8282\u70b9\u72b6\u6001:</td>";
										if(childBpmsTrackInfo.curNodeInsStatus==1){
											coopHTML += "<td width='80'><div class='text-overhidden-block' title='"+status+"' style='width:80px;color:red'>"+status+"</div></td>";
										}else{
											coopHTML += "<td width='80'><div class='text-overhidden-block' title='"+status+"' style='width:80px;'>"+status+"</div></td>";
										}
										coopHTML += "</tr>";
									coopHTML += "</table>";
								coopHTML += "</td>";
						coopHTML += "</tr>";
						for(var k=0;k<arrChildColTrackInfo.length;k++){
							coopHTML += "<tr>";
								coopHTML += "<td>";
									coopHTML += "<table class='mul-porpel' style='padding-bottom:2px;'>";
										coopHTML += "<tr>";
											coopHTML += "<td style='width:40px;'><img src='./images/flow_people.png' alt='\u5934\u50cf' style='height:41px;'/></td>";
											coopHTML += "<td style='width:80px;algin:left;'>";
												coopHTML += "<table>";
													coopHTML += "<tr>";
														//加上\u59d4\u6258\u4eba的相关信息
														var transActor = arrChildColTrackInfo[k].actorName;
														if("" != formatString(arrChildColTrackInfo[k].authorizerId)){
															transActor = transActor+"(\u59d4\u6258\u4eba："+arrChildColTrackInfo[k].authorizerName+")";
														}
														coopHTML += "<td title='"+transActor+"' class='text-overhidden-block text-people-info' style='max-width:80px'>"+transActor+"</td>";
													coopHTML += "</tr>";
													coopHTML += "<tr>";
														coopHTML += "<td title='"+formatString(arrChildColTrackInfo[k].actorDepartmentName)+"' class='text-overhidden-block' style='margin-top:12px;height:15px;line-height:15px;'>"+formatString(arrChildColTrackInfo[k].actorDepartmentName)+"</td>";	
													coopHTML += "</tr>";
												coopHTML += "</table>";
											coopHTML += "</td>";
											coopHTML += "<td style='width:80px;algin:left;'>";
												if(childBpmsTrackInfo.end){
												status = "\u6d41\u7a0b\u5ba1\u6279\u7ed3\u675f";
												coopHTML += "<img src='./images/people-end-small.png' alt='\u7ed3\u675f' style='height:41px;'/>";
												}else if(arrChildColTrackInfo[k].transFlag==1 || arrChildColTrackInfo[k].transFlag==2){
												coopHTML += "<img src='./images/people-load-small.png' alt='\u5f85\u5904\u7406' style='height:41px;'/>";
												 }else if(childBpmsTrackInfo.curNodeInsStatus==3 && arrChildColTrackInfo.length == 1 && arrChildColTrackInfo[k].completeType == 3){
												coopHTML += "<img src='./images/people-back-small.png' alt='\u56de\u9000' style='height:41px;'/>";
												}else{
												coopHTML += "<img src='./images/people-next-small.png' alt='\u4e0b\u53d1' style='height:41px;'/>";
												}
											coopHTML += "</td>";
											if(arrChildColTrackInfo[k].transFlag==1 || arrChildColTrackInfo[k].transFlag==2){
											coopHTML += "<td width='60'>\u5206\u914d\u65f6\u95f4:</td>";
											coopHTML += "<td width='80'><div class='text-overhidden-block' title='"+formatDate(arrChildColTrackInfo[k].createTime)+"'>"+formatDate(arrChildColTrackInfo[k].createTime)+"</div></td>";																							
											coopHTML += "<td width='60'>\u505c\u7559\u65f6\u957f:</td>";
											coopHTML += "<td width='80'><div class='text-overhidden-block' title='"+getStayTime(arrChildColTrackInfo[k].curDBTime,arrChildColTrackInfo[k].createTime)+"'>"+getStayTime(arrChildColTrackInfo[k].curDBTime,arrChildColTrackInfo[k].createTime)+"</div></td>";
											}else{
											coopHTML += "<td width='60'>\u5904\u7406\u65f6\u95f4:</td>";
											coopHTML += "<td width='80'><div class='text-overhidden-block' title='"+formatDate(arrChildColTrackInfo[k].overTime)+"'>"+formatDate(arrChildColTrackInfo[k].overTime)+"</div></td>";						
											coopHTML += "<td width='60'>\u5904\u7406\u8017\u65f6:</td>";
											coopHTML += "<td width='80'><div class='text-overhidden-block' title='"+getStayTime(arrChildColTrackInfo[k].overTime,arrChildColTrackInfo[k].createTime)+"'>"+getStayTime(arrChildColTrackInfo[k].overTime,arrChildColTrackInfo[k].createTime)+"</div></td>";
											}
										coopHTML += "</tr>";
										coopHTML += "<tr>";
											coopHTML += "<td colspan='7'>";
												coopHTML += "<table>";
													coopHTML += "<tr style='height:30px'>";
														coopHTML += "<td width='60'>\u6d41\u7a0b\u7ed3\u8bba:</td>";
														coopHTML += "<td width='60'>"+formatString(arrChildColTrackInfo[k].resultFlag)+"</td>";
														coopHTML += "<td width='60'>\u5ba1\u6279\u610f\u89c1:</td>";
														coopHTML += "<td><div height='20px' title='"+formatString(arrChildColTrackInfo[k].msg)+"' style='height:20px;line-height:20px;overflow:hidden;overflow-x:hidden;float:left;word-break:break-all;text-overflow:ellipsis;'>"+formatString(arrChildColTrackInfo[k].msg)+"</div></td>";
													coopHTML += "</tr>";
												coopHTML += "</table>";
											coopHTML += "</td>";
										coopHTML += "</tr>";
									coopHTML += "</table>";
								coopHTML += "</td>";
							coopHTML += "</tr>";							
						}
				coopHTML += "</table></div>";
				}else{
					coopHTML += "<div style='padding-top:5px;'><table style='background-color:#e6e7eb;width:100%;min-width:620px;min-height:120px'>";
						coopHTML += "<tr>";
							coopHTML += "<td style='width:40px;'><img src='./images/flow_people.png' alt='\u5934\u50cf' style='height:41px;'/></td>";
							coopHTML += "<td style='width:80px;algin:left;'>";
								coopHTML += "<table>";
									coopHTML += "<tr>";
										//加上\u59d4\u6258\u4eba的相关信息
										var transActor = arrChildColTrackInfo[0].actorName;
										if("" != formatString(arrChildColTrackInfo[0].authorizerId)){
											transActor = transActor+"(\u59d4\u6258\u4eba："+arrChildColTrackInfo[0].authorizerName+")";
										}
										coopHTML += "<td title='"+arrChildColTrackInfo[0].actorName+"' class='text-overhidden-block' style='max-width:80px'>"+arrChildColTrackInfo[0].actorName+"</td>";
									coopHTML += "</tr>";
									coopHTML += "<tr>";
										coopHTML += "<td title='"+formatString(arrChildColTrackInfo[0].actorDepartmentName)+"' class='text-overhidden-block' style='margin-top:12px;height:15px;line-height:15px;'>"+formatString(arrChildColTrackInfo[0].actorDepartmentName)+"</td>";	
									coopHTML += "</tr>";
							coopHTML += "</table>";
						coopHTML += "</td>";
						coopHTML += "<td width='80px';>";
						if(childBpmsTrackInfo.end){
						coopHTML += "<img src='./images/people-end.png' alt='\u7ed3\u675f' style='height:41px;'/>";
						}else if(arrChildColTrackInfo[0].transFlag==1 || arrChildColTrackInfo[0].transFlag==2){
						coopHTML += "<img src='./images/people-load.png' alt='\u5f85\u5904\u7406' style='height:41px;'/>";
						}else if(childBpmsTrackInfo.curNodeInsStatus==3 && arrChildColTrackInfo.length == 1 && arrChildColTrackInfo[0].completeType == 3){
						coopHTML += "<img src='./images/people-back.png' alt='\u56de\u9000' style='height:41px;'/>";
						}else{
						coopHTML += "<img src='./images/people-next.png' alt='\u4e0b\u53d1' style='height:41px;'/>";
						}
						coopHTML += "</td>";
						coopHTML += "<td>";
						coopHTML += "<table>";
							coopHTML += "<tr style='height:35px'>";
								coopHTML += "<td width='60'>\u8282\u70b9\u540d\u79f0:</td>";
									coopHTML += "<td width='80'><div class='text-overhidden-block' title='"+childBpmsTrackInfo.curNodeName+"' style='width:80px;'>"+childBpmsTrackInfo.curNodeName+"</div></td>";
									coopHTML += "<td width='60'>\u8282\u70b9\u72b6\u6001:</td>";
									if(childBpmsTrackInfo.curNodeInsStatus==1){
									coopHTML += "<td width='80'><div class='text-overhidden-block' title='"+status+"' style='width:80px;color:red'>"+status+"</div></td>";
									}else{
									coopHTML += "<td width='80'><div class='text-overhidden-block' title='"+status+"' style='width:80px;'>"+status+"</div></td>";
									}
									coopHTML += "</tr>";
									coopHTML += "<tr style='height:30px'>";
										if(childBpmsTrackInfo.curNodeInsStatus==1){
										coopHTML += "<td width='60'>\u5206\u914d\u65f6\u95f4:</td>";
										coopHTML += "<td width='80'><div class='text-overhidden-block' title='"+formatDate(childBpmsTrackInfo.createTime)+"'>"+formatDate(childBpmsTrackInfo.createTime)+"</div></td>";
										coopHTML += "<td width='60'>\u505c\u7559\u65f6\u957f:</td>";
										coopHTML += "<td width='80'><div class='text-overhidden-block' title='"+getStayTime(childBpmsTrackInfo.curDBTime,childBpmsTrackInfo.createTime)+"'>"+getStayTime(childBpmsTrackInfo.curDBTime,childBpmsTrackInfo.createTime)+"</div></td>";
										}else{
										coopHTML += "<td width='60'>\u5904\u7406\u65f6\u95f4:</td>";
										coopHTML += "<td width='80'><div class='text-overhidden-block' title='"+formatDate(childBpmsTrackInfo.overTime)+"'>"+formatDate(childBpmsTrackInfo.overTime)+"</div></td>";
										coopHTML += "<td width='60'>\u5904\u7406\u8017\u65f6:</td>";
										coopHTML += "<td width='80'><div class='text-overhidden-block' title='"+getStayTime(childBpmsTrackInfo.overTime,childBpmsTrackInfo.createTime)+"'>"+getStayTime(childBpmsTrackInfo.overTime,childBpmsTrackInfo.createTime)+"</div></td>";
										}
									coopHTML += "</tr>";
								coopHTML += "</table>";
							coopHTML += "</td>";
						coopHTML += "</tr>";
					coopHTML += "<tr style='height:30px'>";
						coopHTML +="<td width='60'>\u6d41\u7a0b\u7ed3\u8bba:</td>";
						coopHTML +="<td width='60'>"+formatString(arrChildColTrackInfo[0].resultFlag)+"</td>";
						coopHTML += "<td width='60'>\u5ba1\u6279\u610f\u89c1:</td>";
						coopHTML += "<td colspan='3'><div title='"+formatString(arrChildColTrackInfo[0].msg)+"' style='height:20px;line-height:20px;overflow:hidden;overflow-x:hidden;float:left;word-break:break-all;text-overflow:ellipsis;'>"+formatString(arrChildColTrackInfo[0].msg)+"</div></td>";
					coopHTML += "</tr>";
				coopHTML += "</table></div>";
				}
			 }
	    }
		coopHTML += "</td>";
	}
	coopHTML += "</tr></table>";
	return coopHTML;
}

//获取子流程的HTML
function getSubflowHTML(bpmsTrackInfo,subflowHTML){
	subflowHTML += "<table style='width:100%;min-width:620px;min-height:120px'>";
	var lstSubflowBpmsTrackVO = bpmsTrackInfo.lstBpmsTrackVO;
	subflowHTML += getMainHTML(lstSubflowBpmsTrackVO,"");
	subflowHTML += "</table>";
	return subflowHTML;
}


//加载主模板
function getMainTemplate(lstTrack,trackAreaId){
	var mainTrackText = $("#track-template").html();
    var mainTrackSource = new comtop.JCT(mainTrackText);
    mainTrackSource.Build();
    trackAreaId = "#"+trackAreaId;
    $(trackAreaId).html(mainTrackSource.GetView({"list":lstTrack})); 
}

Date.prototype.format = function(format){ 
	var o = { 
	"M+" : this.getMonth()+1, //month 
	"d+" : this.getDate(), //day 
	"h+" : this.getHours(), //hour 
	"m+" : this.getMinutes(), //minute 
	"s+" : this.getSeconds(), //second 
	"q+" : Math.floor((this.getMonth()+3)/3), //quarter 
	"S" : this.getMilliseconds() //millisecond 
	} 

	if(/(y+)/.test(format)) { 
		format = format.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length)); 
	} 

	for(var k in o) { 
		if(new RegExp("("+ k +")").test(format)) { 
			format = format.replace(RegExp.$1, RegExp.$1.length==1 ? o[k] : ("00"+ o[k]).substr((""+ o[k]).length)); 
		} 
	} 
	return format; 
} 



//计算耗时情况
function getStayTime(overTime, createTime) {
	if (overTime === "" || null === overTime || !_.isDate(overTime)) {
		return "\u6b63\u5728\u5904\u7406\u4e2d";
	}
	var stayTime = TimeDifference(createTime.format("yyyy-MM-dd hh:mm:ss"),overTime.format("yyyy-MM-dd hh:mm:ss"));
	if(_.isUndefined(stayTime) || stayTime < 0){
		return "\u6b63\u5728\u5904\u7406\u4e2d";
	}
	var day;
	var hour;
	var munite;
	if(stayTime < 60){
		stayTime = (stayTime==0?1:stayTime);
		return stayTime+"\u5206\u949f"; 
	}else if(stayTime >=  60 && stayTime <= 60*24){
		hour = Math.floor(stayTime/60);
		munite = stayTime-hour*60;
		if(munite == 0 ){
			return hour+"\u5c0f\u65f6"; 
		}
		return hour+"\u5c0f\u65f6"+munite+"\u5206\u949f"; 
	} else{
		day = Math.floor(stayTime/(60*24));
		hour = Math.floor((stayTime-day*60*24)/60);
		munite = stayTime-day*60*24 -hour*60;
		if(munite == 0 ){
			return day+"\u5929"+hour+"\u5c0f\u65f6";
		}
		return day+"\u5929"+hour+"\u5c0f\u65f6"+munite+"\u5206\u949f";
	}
} 

//计算time1 > time2 的时间差值，返回\u5206\u949f数
function TimeDifference(time1,time2)
{
	//截取字符串，得到日期部分"2009-12-02",用split把字符串分隔成数组
	var begin1=time1.substr(0,10).split("-");
	var end1=time2.substr(0,10).split("-");
	
	//将拆分的数组重新组合，并实例成化新的日期对象
	var date1=new Date(begin1[0],begin1[1]-1,begin1[2]);
	var date2=new Date(end1[0],end1[1]-1,end1[2]);
	//得到两个日期之间的差值m，以\u5206\u949f为单位
	//Math.abs(date2-date1)计算出以毫秒为单位的差值
	//Math.abs(date2-date1)/1000得到以秒为单位的差值
	//Math.abs(date2-date1)/1000/60得到以\u5206\u949f为单位的差值
	//万恶的火狐不支持两个时间值相减，木有办法，此处多写一点代码了
	var m=parseInt(Math.abs(date2-date1)/1000/60,10);

	//\u5c0f\u65f6数和\u5206\u949f数相加得到总的\u5206\u949f数
	//time1.substr(11,2)截取字符串得到时间的\u5c0f\u65f6数
	//parseInt(time1.substr(11,2))*60把\u5c0f\u65f6数转化成为\u5206\u949f
	var min1=parseInt(time1.substr(11,2),10)*60+parseInt(time1.substr(14,2),10);
	var min2=parseInt(time2.substr(11,2),10)*60+parseInt(time2.substr(14,2),10);
	
	//两个\u5206\u949f数相减得到时间部分的差值，以\u5206\u949f为单位
	var n=min2-min1;

	//将日期和时间两个部分计算出来的差值相加，即得到两个时间相减后的\u5206\u949f数
	var minutes=m+n;
	return minutes;
}

//格式化当前时间
function getFormatDate() {
	return new Date();
}


//格式化当前时间
function formatDate(dateTime) {
	if(_.isDate(dateTime)){
		return dateTime.format("yyyy-MM-dd hh:mm:ss");
	}
	return dateTime;
}


function formatString(value){
	if(_.isNull(value)|| _.isUndefined(value) || "null" == value){
		return "";
	}
	return value;
}

//获取\u8282\u70b9\u72b6\u6001
function bpmsCompleteTypeEnum(bpmsCompleteTypeKey) {
	if(_.isNull(bpmsCompleteTypeKey)|| _.isUndefined(bpmsCompleteTypeKey) || !_.isNumber(bpmsCompleteTypeKey)){
		return "\u672a\u77e5"; 	
	}
	switch(bpmsCompleteTypeKey){
		case 1:
			return "\u5f85\u5904\u7406";
		case 2:
			return "\u5904\u7406\u4e2d";
		case 3: 
			return "\u5df2\u5b8c\u6210";
		case 4:
			return "\u6302\u8d77";
		case 5:
			return "\u7ec8\u6b62";
		default:
			return "\u672a\u77e5";
	}
}

function msg(oEvent,objTagName)
{
  var oEvent = oEvent ? oEvent : window.event;
  var oElem = oEvent.toElement ? oEvent.toElement : oEvent.relatedTarget; // 此做法是为了兼容FF浏览器
  //此处是为了兼容IE8
  if(_.isNull(oElem)|| _.isUndefined(oElem)){
	  oElem = oEvent.srcElement;
  }
  //获取当前点击行的span对象
  message_box.style.visibility='visible';
 //创建灰色背景层
  procbg = document.createElement("div"); 
  procbg.setAttribute("id","mybg");
  procbg.style.margin="0"; 
  procbg.style.overflowX="auto";
  procbg.style.background = "#000"; 
  procbg.style.width = "100%"; 
  procbg.style.height = "100%"; 
  procbg.style.position = "absolute"; 
  procbg.style.top = "0"; 
  procbg.style.left = "0"; 
  procbg.style.zIndex = "500"; 
  procbg.style.opacity = "0.2"; 
  procbg.style.filter = "Alpha(opacity=20)"; 
  //背景层加入页面
  document.body.appendChild(procbg);
  document.body.style.overflow = "hidden";
  //加入意见详情
  $("#msgDetail").html(oElem.innerText);
  
}
//关闭功能
function closeProc()
{
   message_box.style.visibility='hidden';
   procbg.style.visibility = "hidden";
}