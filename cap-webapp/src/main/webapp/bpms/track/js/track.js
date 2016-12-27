var msgCount = 0.89;
var hasMsgCount = 0;
var globaleTrackKey = "";
var totalTime = 0;
function generateTrackTable(trackData, trackKey) {
	//alert(window.innerWidth+":"+window.innerHeight);
	var htmlText = "";
	var leftHtml = "";
	var middleHtml = "";
	globaleTrackKey = trackKey;
	htmlText += createToDoRow(trackData);
	htmlText += createStartNodeRow();
	for (var i = 0; i < trackData.length; i++) {
		var bpmsTrackInfo = trackData[i]; 
		var cur_node_status = bpmsTrackInfo.curNodeInsStatus;
		var arrColTrackInfo = bpmsTrackInfo.colTransTrackInfo;
		var cur_node_name = bpmsTrackInfo.curNodeName;
		var cur_node_create_time = bpmsTrackInfo.createTime;
		var cur_node_over_time = bpmsTrackInfo.overTime;
		var trackType = bpmsTrackInfo.trackType;
		var curNodeInsId = bpmsTrackInfo.curNodeInsId;
		var mainProcessInsId = bpmsTrackInfo.mainProcessInsId;
		var curNodeId = bpmsTrackInfo.curNodeId;
		var end = bpmsTrackInfo.end;
		var timeEclipse;
		if (i % 2 == 0) { // 设置单元行背景色
			htmlText += "<tr class=\'tr_nomal_node_with_background\'>";
		} else {
			htmlText += "<tr class=\'tr_nomal_node_no_background\'>";
		}
		middleHtml += createMiddleColumn(cur_node_status, cur_node_name, arrColTrackInfo, trackType, curNodeInsId, mainProcessInsId, curNodeId, end);
		leftHtml += createLeftColumn(cur_node_status, end);
		htmlText += leftHtml;
		htmlText += middleHtml;
		middleHtml = "";
		leftHtml = "";
		msgCount = 0.89;
		hasMsgCount = 0;
		if ((cur_node_status == 3 || cur_node_status == 5)&& !end) { // 当前节点处理完成 则计算耗时
			timeEclipse = getStayTime(cur_node_over_time, cur_node_create_time);
			calcTotalTime(timeEclipse);
			htmlText += "<td class=\'td_right\' valign='middle'><span class=\'elapse_time\'>\u8017\u65f6\uff1a"+timeEclipse+"</span></td>";//耗时
		} else {
			htmlText += "<td class=\'td_right\' valign='middle'></td>";
		}
		htmlText += "</tr>";
	}
	totalTime = secondsToTime();
	return htmlText;
}
function secondsToTime() { //秒转成时间
	var day = 0;
	var hour = 0;
	var minute = 0;
	var time = "";
	day = totalTime/60/60/24;
	day = Math.floor(day);
	hour = (totalTime-day*60*60*24)/60/60;
	hour = Math.floor(hour);
	minute = (totalTime-day*60*60*24-hour*60*60)/60;
	minute = Math.floor(minute);
	if (day > 0) {
		time = day + "\u5929";
	}
	if (hour > 0) {
		time = time + hour + "\u5c0f\u65f6";
	}
	if (minute > 0) {
		time = time + minute + "\u5206\u949f";
	}
	return time;
}
function calcTotalTime(time) {//将time转成秒
	var day = 0;
	var hour = 0;
	var minute = 0;
	var seconds = 0;
	var dayUTF = "\u5929";
	var hourUTF = "\u65f6";
	var minuteUTF = "\u5206";
	var t1 = time;
	t1 = t1.replace("\u5c0f\u65f6",hourUTF).replace("\u5206\u949f",minuteUTF);
	/**
	if (t1.indexOf(dayUTF) != -1) {
		day = t1.substring(0,t1.indexOf(dayUTF));
		day = parseInt(day)*60*60*24;
	}
	if (t1.indexOf(hourUTF) != -1) {
		hour = t1.substring(t1.indexOf(dayUTF), t1.indexOf(hourUTF));
		hour = parseInt(hour)*60*60;
	}
	if (t1.indexOf(minuteUTF) != -1) {
		minute = t1.substring(t1.indexOf(hourUTF), t1.indexOf(minuteUTF));
		minute = parseInt(minute)*60;
	}
	seconds = day + hour + minute;
	totalTime += seconds;
	**/
	if (t1.indexOf(dayUTF) != -1) { //取天
		day = t1.substring(0,t1.indexOf(dayUTF));
		day = parseInt(day)*60*60*24;
	}
	if (t1.indexOf(hourUTF) != -1) { //取时
		if (t1.indexOf(dayUTF) != -1) {
			hour = t1.substring(t1.indexOf(dayUTF) + 1, t1.indexOf(hourUTF));
		} else {
			hour = t1.substring(0, t1.indexOf(hourUTF));
		}
		hour = parseInt(hour)*60*60;
	}
	if (t1.indexOf(minuteUTF) != -1) { //取分
		if (t1.indexOf(hourUTF) != -1) {
			minute = t1.substring(t1.indexOf(hourUTF) + 1, t1.indexOf(minuteUTF));
		} else if (t1.indexOf(hourUTF) == -1 && t1.indexOf(dayUTF) != -1) {
			minute = t1.substring(t1.indexOf(dayUTF) + 1, t1.indexOf(minuteUTF));
		} else if (t1.indexOf(hourUTF) == -1 && t1.indexOf(dayUTF) == -1) {
			minute = t1.substring(0, t1.indexOf(minuteUTF));
		}
		minute = parseInt(minute)*60;
	}
	seconds = day + hour + minute;
	totalTime += seconds;
}
function createStartNodeRow() { //创建开始节点行HTML
	var startHtml = "<tr class='tr_start_node'>" + 
						"<td class='td_left'><img src='images/start_process.png' style='padding-top:10px'></img></td>" +
						"<td class='td_middle'><div style='height: 44px;'></div></td>" +
						"<td class='td_right'><span class='floatDiv' id='floatDiv'></span></td>" +
					"</tr>";
	return startHtml;
}
function createToDoRow(trackData) {
	var hasTodo = false;
	for (var j = 0; j < trackData.length; j++) {
		var bpmsTrackInfo = trackData[j];
		var curNodeInsStatus = bpmsTrackInfo.curNodeInsStatus;
		var arrColTrackInfo = bpmsTrackInfo.colTransTrackInfo;
		var trackType = bpmsTrackInfo.trackType;
		if (arrColTrackInfo == null) {
			continue;
		}
		var cur_node_name = bpmsTrackInfo.curNodeName;
		var col_operator_name = "";
		var toDoHtml = "<tr class='tr_current_node'>";//当前节点
		toDoHtml += "<td class='td_left'><div class='node_current'>\u5f53\u524d\u8282\u70b9</div></td>";
		toDoHtml += "<td class='td_middle'>";
		
		var curNodeActorNameList='';
		var displayName='';
		//只取4个人的名字显示具体的去正式节点位置看,其他用tip
		
		var k=1;
		for (var i = 0; i < arrColTrackInfo.length; i++) {
		   var transFlag = arrColTrackInfo[i].transFlag;
		   if(trackType!=4 && trackType!=5){
				if((transFlag == 1 || transFlag == 2) && (curNodeInsStatus == 1 || curNodeInsStatus == 2)){
		       
			      if(k<arrColTrackInfo.length){
			      curNodeActorNameList += arrColTrackInfo[i].actorName+",";
				  }else{
				   curNodeActorNameList += arrColTrackInfo[i].actorName;   
				  }
			      
				  //0817修改缺陷  增加显示的人数数量，处理最后一个人员后逗号问题
				  if(k<=4){
					  if(k<arrColTrackInfo.length){
						  displayName += arrColTrackInfo[i].actorName+",";
						  }else{
							  displayName += arrColTrackInfo[i].actorName;   
						  }  
				  }else if(k==5){
				     displayName+="...";   
				  }
				  
				  k++;
			   }
		   }
		}
		
		for (var i = 0; i < arrColTrackInfo.length; i++) {
			var transFlag = arrColTrackInfo[i].transFlag;
			var handleTime = arrColTrackInfo[i].handleTime;
			var overTime = arrColTrackInfo[i].overTime;
			var createTime = arrColTrackInfo[i].createTime;
			if (trackType == 4) {
				col_operator_name = "\u53d1\u9001\u4efb\u52a1";//发送任务
			} else if (trackType == 5) {
				col_operator_name = "\u63a5\u6536\u4efb\u52a1";//接收任务
			}
			if ((transFlag == 1 || transFlag == 2) && (curNodeInsStatus == 1 || curNodeInsStatus == 2)) {
				hasTodo = true;
				toDoHtml += "<span class='node_font'>" + cur_node_name + "</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
				if (trackType == 4 || trackType == 5) {
					toDoHtml += "<span class='user_font'>" + col_operator_name + "</span>";
				} else {
					toDoHtml += "<span class='user_font'  title='" + curNodeActorNameList + "' >" + displayName + "</span>";
				}
				toDoHtml += "</td>";//停留时间
				toDoHtml += "<td class='td_right'><span class='elapse_time'>\u505c\u7559\u65f6\u95f4\uff1a"+ getStayTime(new Date(), createTime) +"</span></td>";
				toDoHtml += "</tr>";
				break;
			}
		}
		if (hasTodo) {
			break;
		}
	}
	
	return hasTodo ? toDoHtml : "";
}

//function 
function formatString(value){
	if(_.isNull(value)|| _.isUndefined(value) || "null" == value){
		return "";
	}
	return value;
}
function createMiddleColumn(cur_node_status, cur_node_name, arrColTrackInfo, trackType, curNodeInsId, mainProcessInsId, curNodeId, end) { //创建第二列的HTML
	var middleColumn = "<td class=\'td_middle\' align='left'>";
	middleColumn += "<table cellpadding=\'0\' cellspacing=\'0\' width='100%' height='100%'>";
	for (var k = 0; arrColTrackInfo != null && k < arrColTrackInfo.length; k++) {
		var transTrackInfo = arrColTrackInfo[k];
		var actorName = transTrackInfo.actorName;
		var transFlag = transTrackInfo.transFlag;
		var completeType = transTrackInfo.completeType;
		var msg = transTrackInfo.msg;
		var handleTime = transTrackInfo.handleTime;
		var overTime = transTrackInfo.overTime;
		msgCount++;
		if (trackType == 5) {
			actorName = "\u63a5\u6536\u4efb\u52a1";//接收任务
			continue;
		}
		if (k == 0) { // 有多个处理人需要控制对齐方式
			middleColumn += "<tr height='20px;'><td>";
			middleColumn += "<span class=\'node_font\'>" + cur_node_name +"</span>&nbsp;&nbsp;" + 
			"<span class=\'user_font\'>" +actorName+ "</span>";
		} else {
			middleColumn += "<tr height='20px;'><td>";
			middleColumn += "&nbsp;&nbsp;" + createSpace(cur_node_name) +
			"<span class=\'user_font\'>" +actorName+ "</span>";
		}
		if (transFlag == 1 || transFlag == 2) { //处理中
			middleColumn += "&nbsp;<span class='operate'>\u5904\u7406\u4e2d</span>";
			middleColumn += "</td></tr>";
		}
		if (transFlag == 3 || transFlag == 4 || transFlag == 5) { //处理完成
			middleColumn += "&nbsp;<span class='elapse_time'>"+ overTime.format('yyyy-MM-dd hh:mm') + "</span>";
			middleColumn += "&nbsp;<span class='operate'>"+ getCompleteType(completeType) + "</span>";
			middleColumn += "</td></tr>";
		}
		if (formatString(msg) != "") { // 添加意见
			hasMsgCount++;
			middleColumn += "<tr height='20px;'><td>&nbsp;&nbsp;" + createSpace(cur_node_name);
			middleColumn += "<div class=\'msg_font\'><b>\u610f\u89c1\uff1a</b>" + html_encode(msg) + "</div>";
			middleColumn += "</td></tr>";
		}
	}
	
	//0817修改缺陷  添加html代码转义方法，处理流程意见填写html代码问题
	function html_encode(str)   
	{   
	  var s = "";   
	  if (str.length == 0) return "";   
	  s = str.replace(/&/g, "&amp;");   
	  s = s.replace(/</g, "&lt;");   
	  s = s.replace(/>/g, "&gt;");   
	  s = s.replace(/ /g, "&nbsp;");   
	  s = s.replace(/\'/g, "&#39;");   
	  s = s.replace(/\"/g, "&quot;");   
	  s = s.replace(/\n/g, "<br>");   
	  return s;   
	}   

	if (trackType == 5 || trackType == 4) {
		msgCount++;
		var name = "";
		var url = "";
		middleColumn += "<tr height='20px;'><td>";
		if (trackType == 4) {
			name = "\u53d1\u9001\u4efb\u52a1";
			url = "&nbsp;<span class='operate' style='cursor: pointer;' processInsId='"+mainProcessInsId+"' nodeInsId='"+curNodeInsId+"' onclick='javascirpt:queryRecieverTrack(this)'>\u70b9\u51fb\u67e5\u770b\u63a5\u6536\u65b9\u6d41\u7a0b\u8ddf\u8e2a</span>"
		} else if (trackType == 5) {
			name = "\u63a5\u6536\u4efb\u52a1";
			url = "&nbsp;<span class='operate' style='cursor: pointer;' processInsId='"+mainProcessInsId+"' nodeId='"+curNodeId+"' onclick='javascirpt:querySenderTrack(this)'>\u70b9\u51fb\u67e5\u770b\u53d1\u9001\u65b9\u6d41\u7a0b\u8ddf\u8e2a</span>"
		}
		middleColumn += "<span class=\'node_font\'>" +cur_node_name+ "</span>&nbsp;&nbsp;";
		middleColumn += "<span class=\'user_font\'>" + name +"</span>&nbsp;&nbsp;" ;
		middleColumn += url;
		middleColumn += "</td></tr>";
	}
	if (end) {
		msgCount++;
		var name = "\u6d41\u7a0b\u7ed3\u675f";
		middleColumn += "<tr height='20px;'><td>";
		middleColumn += "<span class=\'node_font\'>" +cur_node_name+ "</span>&nbsp;&nbsp;";
		middleColumn += "<span class=\'user_font\'>" + name +"</span>&nbsp;&nbsp;" ;
		middleColumn += "</td></tr>";
	}
	middleColumn += "</table>";
	middleColumn += "</td>";
	return middleColumn;
}
function countTrackTimes() {
	var corporateClickTimes = formatString(remoteRecorder);
	if (corporateClickTimes != "" && parseInt(corporateClickTimes) >= 1) {
		//alert("\u9875\u9762\u5c06\u81ea\u52a8\u5237\u65b0\u4ee5\u663e\u793a\u539f\u8ddf\u8e2a\u4fe1\u606f");
		remoteRecorder = 0;
		window.location.reload();
		return false;
	}
	return true;
}
function querySenderTrack(obj) { //查看发送方流程
	var nodeId = obj.attributes["nodeId"].value;
	var processInsId = obj.attributes["processInsId"].value;
	var async = null;
	if(typeof(dwr) != "undefined"){
		if(typeof(dwr.TOPEngine) != "undefined"){
			async = dwr.TOPEngine;
		}else{
			async = dwr.engine;
		}
	}else{
		async = DWREngine;
	}
	if (countTrackTimes()) {
		$('#trackTable').html("");
		//通过DWR去后台获取根据数据
		async.setAsync(false);
		TrackDWR.getRemoteUserSendTrack(processInsId,nodeId,globaleTrackKey,function(trackData){
			if (trackData === "" || trackData === null) {
				$('#trackTable').hide();
				alert("\u65e0\u6cd5\u83b7\u53d6\u670d\u52a1\u7aef\u6570\u636e\uff0c\u8bf7\u68c0\u67e5\uff01");//后台无数据返回！
				return false;
			}
			$('#trackTable').append(generateTrackTable(trackData, globaleTrackKey));
		});
		async.setAsync(true);
		remoteRecorder++;
	}
}
function queryRecieverTrack(obj) { //查看接收方流程
	var nodeInsId = obj.attributes["nodeInsId"].value;
	var processInsId = obj.attributes["processInsId"].value;
	var async = null;
	if(typeof(dwr) != "undefined"){
		if(typeof(dwr.TOPEngine) != "undefined"){
			async = dwr.TOPEngine;
		}else{
			async = dwr.engine;
		}
	}else{
		async = DWREngine;
	}
	if (countTrackTimes()) {
		$('#trackTable').html("");
		//通过DWR去后台获取根据数据
		async.setAsync(false);
		TrackDWR.getRemoteUserReceTrack(nodeInsId,globaleTrackKey,function(trackData){
			if (trackData === "" || trackData === null) {
				$('#trackTable').hide();
				alert("\u540e\u53f0\u65e0\u6570\u636e\u8fd4\u56de\uff01");//后台无数据返回！
				return false;
			}
			$('#trackTable').append(generateTrackTable(trackData, globaleTrackKey));
		});
		async.setAsync(true);
		remoteRecorder++;
	}
}
function createSpace(str) {
	var spaceHtml = "";
	var strlen = 0;
	for(var i = 0;i < str.length; i++)
	{
		if(str.charCodeAt(i) > 255) //如果是汉字，则字符串长度加2
			strlen += 3;
		else  
			strlen += 1.5;
	}
	for (var i = 0; i < strlen; i++) {
		spaceHtml += "&nbsp;";
	}
	return spaceHtml;
}
function splitMsg(msg) {
	var formatMsg = "";
	if (formatString(msg) == "") {
		return formatMsg;
	} else {
		if (msg.length > 18) {
			formatMsg = msg.substring(0,18) + "...";
		} else {
			formatMsg = msg;
		}
	}
	return formatMsg ;
}
function getCompleteType(completeType) {
	var type = "";
	switch(completeType) {
		case 1: 
			type = "\u542f\u52a8";//启动
			break;
		case 2:
			type = "\u53d1\u9001";//发送
			break;
		case 3:
			type = "\u56de\u9000";//回退
			break;
		case 5:
			type = "\u7ec8\u6b62";//终止
			break;
		case 6:
			type = "\u6062\u590d";//恢复
			break;
		case 7:
			type = "\u6302\u8d77";//挂起
			break;
		case 8:
			type = "\u6539\u6d3e";//改派
			break;
		case -1:
			type = "\u672a\u5904\u7406";//未处理
			break;
	}
	return type;
}
function createLeftColumn(cur_node_status, end) { //创建第一列的HTML
	var leftColumnHTML = "";
	var height = 22*msgCount/1.6;
	var msgHeight = (msgCount-hasMsgCount)*6.83;
	if (msgCount > 2) {
		height += msgCount*3.6;
		height = height - msgHeight;
	}
	if (end) {
		leftColumnHTML += "<td style='width:20%;height:100%;textAlign:center;padding-left:55px;vertical-align:top' valign='top' align='center'><img src='images/end.png' style='padding-top:-20px'></img></td>";
	} else if (cur_node_status == 3) {
		leftColumnHTML += "<td class=\'td_left\'>" +
				"<table cellpadding=\'0\' cellspacing=\'0\'>" + 
					"<tr><td align=\'center\'><div style=\'border: none; width: 1px; background-color: #999999; height: " + height +"px;\'></div></td></tr>" +
					"<tr><td align=\'center\'><img src=\'images/green.png\'></img></td></tr>" +
					"<tr><td align=\'center\'><div style=\'border: none; width: 1px; background-color: #999999; height: " + height +"px;\'></div></td></tr>" +
				"</table>" +
			"</td>";
	} else if (cur_node_status == 1 || cur_node_status == 2) {
		leftColumnHTML += "<td class=\'td_left\'>" +
				"<table cellpadding=\'0\' cellspacing=\'0\'>" + 
					"<tr><td align=\'center\'><div style=\'border: none; width: 1px; background-color: #999999; height: " + height +"px;\'></div></td></tr>" +
					"<tr><td align=\'center\'><img src=\'images/grey.png\'></img></td></tr>" +
					"<tr><td align=\'center\'><div style=\'border: none; width: 1px; background-color: #999999; height: " + height +"px;\'></div></td></tr>" +
				"</table>" +
			"</td>";
	} else if (cur_node_status == 4 || cur_node_status == 5) {
		leftColumnHTML += "<td class=\'td_left\'>" +
				"<table cellpadding=\'0\' cellspacing=\'0\'>" + 
					"<tr><td align=\'center\'><div style=\'border: none; width: 1px; background-color: #999999; height: " + height +"px;\'></div></td></tr>" +
					"<tr><td align=\'center\'><img src=\'images/red.png\'></img></td></tr>" +
					"<tr><td align=\'center\'><div style=\'border: none; width: 1px; background-color: #999999; height: " + height +"px;\'></div></td></tr>" +
				"</table>" +
			"</td>";
	}
	return leftColumnHTML;
}

//
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
//
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
//
function getStayTime(overTime, createTime) {
	
	if (overTime === "" || null === overTime || !_.isDate(overTime)) {
		return "\u6b63\u5728\u5904\u7406\u4e2d";//正在处理中
	}
	var stayTime = TimeDifference(createTime.format("yyyy-MM-dd hh:mm:ss"),overTime.format("yyyy-MM-dd hh:mm:ss"));
	if(_.isUndefined(stayTime) || stayTime < 0){
		return "\u6b63\u5728\u5904\u7406\u4e2d";//正在处理中
	}
	var day;
	var hour;
	var munite;
	if(stayTime < 60){
		stayTime = (stayTime==0?1:stayTime);
		return stayTime+"\u5206\u949f"; //分钟
	}else if(stayTime >=  60 && stayTime <= 60*24){
		hour = Math.floor(stayTime/60);
		munite = stayTime-hour*60;
		if(munite == 0 ){
			return hour+"\u5c0f\u65f6"; //小时
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
	/**
	var endTime = overTime.getTime();
	var startTime = createTime.getTime();
	var diffTime = endTime - startTime;
	var hour = 0;
	var day = 0;
	var minute = 0;
	var seconds = 0;
	if (diffTime < 60*1000) { //计算秒
		return diffTime/1000+"\u79d2";
	} else if (diffTime >= 60*1000 && diffTime < 60*60*1000) { //计算分钟
		minute = diffTime/1000/60;
		minute = minute.toString().substring(0,minute.toString().indexOf("."));
		seconds = (diffTime-parseInt(minute)*60*1000)/1000;
		if (Math.floor(seconds) != 0) {
			return minute + "\u5206\u949f" + Math.floor(seconds) + "\u79d2";
		} else {
			return minute + "\u5206\u949f";
		}
	} else if (diffTime >= 60*60*1000 && diffTime < 60*60*1000*24) { //计算小时
		hour = diffTime/1000/60/60;
		hour = hour.toString().substring(0,hour.toString().indexOf("."));
		minute = (diffTime - parseInt(hour)*60*60*1000)/60/1000;
		if (Math.floor(minute) != 0) {
			minute = minute.toString().substring(0,minute.toString().indexOf("."));
		}
		seconds = (diffTime - parseInt(hour)*60*60*1000 - parseInt(minute)*60*1000)/60/1000;
		if (Math.floor(minute) != 0 && Math.floor(seconds) != 0) {
			return hour + "\u5c0f\u65f6" + minute + "\u5206\u949f" + Math.floor(seconds) + "\u79d2";
		} else if (Math.floor(minute) == 0 && Math.floor(seconds) != 0) {
			return hour + "\u5c0f\u65f6" + Math.floor(seconds) + "\u79d2";
		} else if (Math.floor(minute) != 0 && Math.floor(seconds) == 0) {
			return hour + "\u5c0f\u65f6" + minute + "\u5206\u949f";
		}
	} else if (diffTime >= 60*60*1000*24) { // 计算天
		day = diffTime/1000/60/60/24;
		day = day.toString().substring(0,day.toString().indexOf("."));
		hour = (diffTime - parseInt(day)*1000*60*60*24)/1000/60/60;
		if (Math.floor(hour) != 0) {
			hour = hour.toString().substring(0,hour.toString().indexOf("."));
		}
		minute = (diffTime - parseInt(day)*1000*60*60*24 - parseInt(hour)*1000*60*60)/1000/60;
		if (Math.floor(minute) != 0) {
			minute = minute.toString().substring(0,minute.toString().indexOf("."));
		}
		seconds = (diffTime - parseInt(day)*1000*60*60*24 - parseInt(hour)*60*60*1000 - parseInt(minute)*60*1000)/60/1000;
		if (Math.floor(hour) != 0 && Math.floor(minute) != 0 && Math.floor(seconds) != 0) {
			return day + "\u5929" + hour + "\u5c0f\u65f6" + minute + "\u5206\u949f" + Math.floor(seconds) + "\u79d2";
		} else if (Math.floor(hour) != 0 && Math.floor(minute) == 0 && Math.floor(seconds) != 0) {
			return day + "\u5929" + hour + "\u5c0f\u65f6" + Math.floor(seconds) + "\u79d2";
		} else if (Math.floor(hour) != 0 && Math.floor(minute) != 0 && Math.floor(seconds) == 0) {
			return day + "\u5929" + hour + "\u5c0f\u65f6" + minute + "\u5206\u949f";
		} else if (Math.floor(hour) != 0 && Math.floor(minute) == 0 && Math.floor(seconds) == 0) {
			return day + "\u5929" + hour + "\u5c0f\u65f6";
		} else if (Math.floor(hour) == 0 && Math.floor(minute) != 0 && Math.floor(seconds) != 0) {
			return day + "\u5929" + minute + "\u5206\u949f" + Math.floor(seconds) + "\u79d2";
		} else if (Math.floor(hour) == 0 && Math.floor(minute) == 0 && Math.floor(seconds) != 0) {
			return day + "\u5929" + Math.floor(seconds) + "\u79d2";
		} else if (Math.floor(hour) == 0 && Math.floor(minute) != 0 && Math.floor(seconds) == 0) {
			return day + "\u5929" + minute + "\u5206\u949f";
		} else if (Math.floor(hour) == 0 && Math.floor(minute) == 0 && Math.floor(seconds) == 0) {
			return day + "\u5929";
		}
		
	}
	**/
	
}