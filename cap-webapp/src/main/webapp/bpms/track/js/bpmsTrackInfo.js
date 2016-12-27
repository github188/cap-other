window.onload = function() {
	var divHtml = "<div class='ctip ctip-b ctip-normal' id='tip_div' style='top: 82px; left: 127px; display: none;'>"
			+ "<div class='ctip-content' style='max-width: 260px;'>"
			+ "<div class='ctip-msg' id='ctip_msg'>" +

			"</div>" + "</div>" + "</div>";
	var tipDiv = createNoteTipDiv("ctip ctip-b ctip-normal", "tip_div",
			"top: 82px; left: 127px; display: none;");
	var ctipArrow = createNoteTipDiv("ctip-arrow", "ctip-arrow", null);
	var ctipContent = createNoteTipDiv("ctip-content", "ctip-content", "max-width: 260px;");
	var ctipMsg = createNoteTipDiv("", "ctip_msg", null);
	var tipArrowBorder = createSpan("tip-arrow-border");
	var tipArrowBg = createSpan("tip-arrow-bg");
	ctipArrow.appendChild(tipArrowBorder);
	ctipArrow.appendChild(tipArrowBg);
	ctipContent.appendChild(ctipMsg);
	tipDiv.appendChild(ctipArrow);
	tipDiv.appendChild(ctipContent);
	document.body.appendChild(tipDiv);
}

function reAddMessageDiv() {
	var tipDiv = createNoteTipDiv("ctip ctip-b ctip-normal", "tip_div",
			"top: 82px; left: 127px; display: none;");
	var ctipArrow = createNoteTipDiv("ctip-arrow", "ctip-arrow", null);
	var ctipContent = createNoteTipDiv("ctip-content", "ctip-content", "max-width: 260px;");
	var ctipMsg = createNoteTipDiv("", "ctip_msg", null);
	var tipArrowBorder = createSpan("tip-arrow-border");
	var tipArrowBg = createSpan("tip-arrow-bg");
	ctipArrow.appendChild(tipArrowBorder);
	ctipArrow.appendChild(tipArrowBg);
	ctipContent.appendChild(ctipMsg);
	tipDiv.appendChild(ctipArrow);
	tipDiv.appendChild(ctipContent);
	document.body.appendChild(tipDiv);
}

function createNoteTipDiv(className, id, style) {
	var div = document.createElement("div");
	if (className != null) {
		div.setAttribute("className", className);
		div.setAttribute("class", className);
	}
	if (id != null) {
		div.setAttribute("id", id);
	}
	if (style != null) {
		div.setAttribute("style", style);
	}
	return div;
}

function createSpan(className) {
	var span = document.createElement("span");
	span.setAttribute("class", className);
	// var txt = document.createTextNode("◆");
	// span.appendChild(txt);
	return span;
}

function mouseOver(obj, event) {
	var auditStatus = obj.attributes["auditStatus"].value;
	var webRoot = obj.attributes["webRoot"].value;
	var webRootUrl = "/web";
	if(obj && obj.attributes["webRootUrl"]){
		 webRootUrl = obj.attributes["webRootUrl"].value;
	}
	if (webRoot == "") {
		webRoot = "/web";
	}
	
	var objChild = obj.children[0];
	if(undefined != objChild){//非项目产品部的卡片模式
		var imgSrc = obj.children[0].src;
		if ((undefined == imgSrc || null == imgSrc)&& null!=obj.firstElementChild) {
			imgSrc = obj.children[0].src;
		}
		if(undefined!=obj.children[0].src){
			obj.children[0].src = imgSrc.substr(0, imgSrc.length - 7) + "Over.png";
		}
	}
	if (auditStatus == '3') {
	    //流程已结束，点击查看流程跟踪！
		obj.title = "\u6d41\u7a0b\u5df2\u7ed3\u675f\uff0c\u70b9\u51fb\u67e5\u770b\u6d41\u7a0b\u8ddf\u8e2a\uff01";
		return;
	}
	var trackKey = "";
	var processId = obj.attributes["processId"].value;
	var processInsId = obj.attributes["processInsId"].value;
	/**
	var messageDIV = $('#tip_div');
	if (null == messageDIV) {
		reAddMessageDiv();
		messageDIV = $('#tip_div');
	}**/
	if(document.getElementById("tip_div")==null) {
		reAddMessageDiv();
	}
	// 通过DWR去后台获取根据数据，已经审批完成的不需要出现浮动框，流程未完成的才会出现浮动框
	TrackDWR.handleUserTaskTrack(processId, processInsId, trackKey, function(
			returnData) {
		if (returnData === "" || returnData === null) {
			return false;
		}
		$('#ctip_msg').html("");
		$("#ctip_msg").html(getMessageDetail(returnData, webRoot, webRootUrl));
		$('#tip_div').css("display", "block");
	});
	// 鼠标当前位置
	var e = event || window.event;
	// var x =
	// obj.getBoundingClientRect().left+document.documentElement.scrollLeft;
	// var y =
	// obj.getBoundingClientRect().top+document.documentElement.scrollTop;
	var x = e.clientX;
	var y = e.clientY;
	var xLocation = x;
	var yLocation = y - obj.offsetHeight;
	var dWidth = document.body.offsetWidth;
	var dHeight = document.documentElement.clientHeight;
	// 如果靠近左边(ps：卡片式跟踪需要调整下显示层的高度，向下20)
	if (x < 200) {
		xLocation = x + 2;
	} else if (x > dWidth / 2) {
		xLocation = x - 285;
		yLocation = yLocation + 20;
	}
	$('#tip_div').css("top", yLocation);
	$('#tip_div').css("left", xLocation);
	$('#tip_div').css("position","absolute");
	setDivCss();
	$('#tip_div').mouseout(function() {
		if ($('#tip_div').css("display") == "block") {
			$('#tip_div').css("display", "none");
		}
	});
	$('#tip_div').mouseover(function() {
		if ($('#tip_div').css("display") == "none") {
			$('#tip_div').css("display", "block");
		}
	});
}
function setDivCss() {
	$('#tip_div').css("z-index","99999");
	$('#ctip-content').css("z-index","99999");
	//$('#ctip-content').css("border","1px solid #4585e5");
	//$('#ctip-content').css("color","#333333");
	//$('#ctip-content').css("max-width","480px");
	//$('#ctip-content').css("background-color","#ffffff");
	//$('#ctip-msg').css("z-index","99999");
}
function mouseOut(obj, event) {
    var objChild = obj.children[0];
    if(undefined != objChild){//非项目产品部的卡片模式
		var imgSrc = obj.children[0].src;
		obj.children[0].src = imgSrc.substr(0, imgSrc.length - 8) + "Out.png";
	}
	var div = $('#tip_div');
	/**
	 * //鼠标当前位置 var e = event || window.event; var x=e.clientX; var y=e.clientY;
	 * var divx1 = div.offsetLeft; var divy1 = div.offsetTop; var divx2 =
	 * div.offsetLeft + div.offsetWidth; var divy2 = div.offsetTop +
	 * div.offsetHeight; if( x < divx1 || x > divx2 || y < divy1 || y > divy2){
	 * if ($('#tip_div').css("display") == "block") {
	 * $('#tip_div').css("display", "none"); } }
	 */
	if ($('#tip_div').css("display") == "block") {
		$('#tip_div').css("display", "none");
	}
}

function getMousePos(event) {
	var e = event || window.event;
	return {
		'x' : e.clientX,
		'y' : clientY
	}
}
/**
 * $("#messageSpan").mousemove(function(e) { var x = e.pageX; var y = e.pageY;
 * var css = ""; //$(this).text(x + '---' + y); //alert(x+","+y);
 * //通过DWR去后台获取根据数据
 * TrackDWR.handleUserTaskTrack(processId.value,processInsId.value,trackKey.value,function(returnData){
 * if (returnData === "" || returnData === null) { return false; }
 * $('#ctip_msg').html(""); $("#ctip_msg").html(getMessageDetail(returnData));
 * }); $('#tip_div').css("top", x); $('#tip_div').css("left", y);
 * $('#tip_div').css("display", "block"); });
 */
/*******************************************************************************
 * $("#messageSpan").mouseout(function(e) { $('#tip_div').css("display",
 * "none"); });
 ******************************************************************************/
function splitMsg(msg) {
	var formatMsg = "";
	if (formatString(msg) == "") {
		return formatMsg;
	} else {
		if (msg.length > 24) {
			formatMsg = msg.substring(0, 28) + "...";
		} else {
			formatMsg = msg;
		}
	}
	return formatMsg;
}
/**
Array.prototype.distinct = function() {
	var sameObj = function(a, b) {
		var tag = true;
		if (!a || !b)
			return false;
		for ( var x in a) {
			if (!b[x])
				return false;
			if (typeof (a[x]) === 'object') {
				tag = sameObj(a[x], b[x]);
			} else {
				if (a[x] !== b[x])
					return false;
			}
		}
		return tag;
	}
	var newArr = [], obj = {};
	for ( var i = 0, len = this.length; i < len; i++) {
		if (!sameObj(obj[typeof (this[i]) + this[i]], this[i])) {
			newArr.push(this[i]);
			obj[typeof (this[i]) + this[i]] = this[i];
		}
	}
	return newArr;
}
**/
function getAuditMan(arr) {
	var name = "";
	var length = 0;
	if (arr == null || arr == "")
		return name;
	if (arr.length <= 3) {
		length = arr.length;
	} else {
		length = 3;
	}
	for ( var i = 0; i < length; i++) {
		if (i < length - 1) {
			name += arr[i] + "\u3001";
		} else {
			name += arr[i];
		}
	}
	return name;
}
// function
function formatString(value) {
	if ("null" == value || "" == value || null == value || "undefined" == value) {
		return "";
	}
	return value;
}
function getCompleteType(completeType) {
	var type = "";
	switch (completeType) {
	case 1:
		type = "<span>\u542f\u52a8</span>";
		break;
	case 2:
		type = "<span>\u53d1\u9001</span>";
		break;
	case 3:
		type = "<span style='color:#FF0000'>\u56de\u9000</span>";
		break;
	case 5:
		type = "<span>\u7ec8\u6b62</span>";
		break;
	case 6:
		type = "<span>\u6062\u590d</span>";
		break;
	case 7:
		type = "<span>\u6302\u8d77</span>";
		break;
	case 8:
		type = "<span>\u6539\u6d3e</span>";
		break;
	case -1:
		type = "<span>\u672a\u5904\u7406</span>";
		break;
	}
	return type;
}
function getManNoMsgArray(auditArr, noMsgArr) { // 查找同意且无意见的人
	var arr = [];
	var exist = false;
	for ( var i = 0; i < noMsgArr; i++) {
		var noMsgMan = noMsgArr[i];
		for ( var k = 0; k < auditArr.length; k++) {
			var auditMan = auditArr[k];
			if (noMsgMan == auditMan) {
				exist = true;
				break;
			}
		}
		if (!exist) {
			arr.push(noMsgMan);
		}
	}
	return arr;
}

function splitNodeMsg(msg) {
	var formatMsg = "";
	if (formatString(msg) == "") {
		return formatMsg;
	} else {
		if (msg.length > 8) {
			formatMsg = msg.substring(0,5) + "...";
		} else {
			formatMsg = msg;
		}
	}
	return formatMsg ;
}
//查看是否有意见，大于0则表示有意见
function getIsNote(returnData) {
	// 意见数量
	var msgCount = 0;
	for ( var i = 0; i < returnData.length; i++) {
		var bpmsTrackInfo = returnData[i];
		var colTransTrackInfo = bpmsTrackInfo.colTransTrackInfo;
		for ( var k = 0; k < colTransTrackInfo.length; k++) {
			var msg = colTransTrackInfo[k].msg;
			if (formatString(msg) != "" && formatString(msg) != "\u540c\u610f"//同意
					&& formatString(msg) != "\u540c\u610f\u3002") {
				msgCount++;
			}
		}
	}
	return msgCount > 0;
}

function getMessageDetail(returnData, webRoot, webRootUrl) {
	// 当前审批环节是什么，哪个节点，哪个人，审批中共有几个人填写的意见，意见列表
	var html = "";
	var auditStepArr = [];
	var auditManArr = [];
	var auditManNoMsgArr = [];
	// 意见数量
	var msgCount = 0;
	var processId = "";
	var processInsId = "";
	// 当前处理环节，包括当前处理节点和当前处理人，协同的情况下会有多个
	var headerHtml = "<table cellpadding='0px' cellspacing='0px' class='head_table'>";
	for ( var i = 0; i < returnData.length; i++) {
		var bpmsTrackInfo = returnData[i];
		processId = bpmsTrackInfo.curProcessId;
		processInsId = bpmsTrackInfo.mainProcessInsId;
		var colTransTrackInfo = bpmsTrackInfo.colTransTrackInfo;
		var curNodeName = bpmsTrackInfo.curNodeName;
		var curNodeInsStatus = bpmsTrackInfo.curNodeInsStatus;
		auditStepArr.push(bpmsTrackInfo.curNodeId);
		// 判断是否是正在处理中或者未处理,当前节点实例的运行状态，1表示待办，2处理中（多活动实例，预留），3为处理结束,4挂起，5为终止
		if (curNodeInsStatus == 1 || curNodeInsStatus == 2) {
			headerHtml = headerHtml
					+ "<tr>"
					+ "<td class='head_td'>"
					+ "<span class='bpms_message'>\u5f53\u524d\u73af\u8282\uff1a</span>"//当前环节
					+ "<span class='cur_node_name' title='" + curNodeName + "'>" + splitNodeMsg(curNodeName) + " "
					+ "</span>";
		}
		var transActorCount = 0;
		for ( var k = 0; k <= colTransTrackInfo.length; k++) {
			if (colTransTrackInfo[k] == null)
				continue;
			var msg = colTransTrackInfo[k].msg;
			var actorName = colTransTrackInfo[k].actorName;
			var transFlag = colTransTrackInfo[k].transFlag;
			var completeType = colTransTrackInfo[k].completeType;
			auditManArr.push(colTransTrackInfo[k].actorName);
			// 判断是否是正在处理中或者未处理（transFlag 1为待办，2为处理中，3为处理结束，4为他人办理，5终止，6改派，7挂起）
			if (transFlag == 1 || transFlag == 2) {
				// 当前处理人较多时，只显示前两个
				transActorCount++;
				if(null == actorName || '' == actorName || 'null' == actorName){
					actorName = '\u7cfb\u7edf\u81ea\u52a8\u63a5\u6536';
				}
				if (transActorCount == 1) {
					headerHtml = headerHtml + "<span class='process_message'>"
							+ actorName + " " + "</span>";
				} else if (transActorCount == 2) {
					headerHtml = headerHtml + "<span class='process_message'>"
							+ actorName + "..." + "</span>";
				}
			}
			if (formatString(msg) == "" && transFlag == 3) { // 处理完成且无意见
				auditManNoMsgArr.push(actorName);
			}
			if (formatString(msg) != "" && formatString(msg) != "\u540c\u610f"
					&& formatString(msg) != "\u540c\u610f\u3002") {
				if (msgCount < 3) {
					html += "<table cellpadding='0px' cellspacing='0px' class='msg_table'>"
							+ "<tr>"
							+ "<td width='8%'><img src='"
							+ webRoot
							+ "/bpms/track/images/point.png' /></td>"
							+ "<td><span class='node_name'>"
							+ curNodeName
							+ "</span></td>"
							+ "</tr>"
							+ "<tr>"
							+ "<td width='8%'></td>"
							+ "<td><span class='process_message'>"
							+ actorName
							+ "&nbsp;</span>"
							+ getCompleteType(completeType)
							+ "<span class='bpms_message'>\uff0c\u610f\u89c1\uff1a"
							+ splitMsg(msg)
							+ "</span></td>"
							+ "</tr>"
							+ "</table>";
				}
				msgCount++;
			}
		}
		headerHtml = headerHtml + "</td>";
	}
	headerHtml = headerHtml + "</tr>";
	if (msgCount > 2) {
		html += "<table cellpadding='0px' cellspacing='0px' class='msg_table'>"
				+ "<tr>"
				+ "<td align='right'><span class='process_message'><a class='process_message' target='_blank' href='"
				+ webRoot + "/bpms/flex/BpmsTrack.jsp?processId=" + processId
				+ "&processInsId=" + processInsId + "&webRootUrl=" + webRootUrl
				+ "'>\u66f4\u591a>></a></span></td>" + "</tr>" + "</table>";
	}
	var steArr = auditStepArr;
	var auditArr = auditManArr;
	var noMsgArr = auditManNoMsgArr;
	var arr = getManNoMsgArray(auditArr, noMsgArr);
	// 加上意见数量
	if (msgCount > 0) {
		/**
		 * headerHtml = headerHtml + "
		 * <tr>" + "
		 * <td>" + "<span class='bpms_message'>过程中有</span>" + "<span
		 * class='process_message'>" + msgCount + "</span>" + "<span
		 * class='process_message'>意见</span>" + "</td>" + "</tr>" ;
		 */
	} else {
		html = "<table cellpadding='0px' cellspacing='0px' class='no_message'>"
				+ "<tr>" + "<td><span>\u6682\u65e0\u610f\u89c1</span></td>"
				+ "</tr>" + "</table>";
	}
	headerHtml = headerHtml + "</table>";
	html = headerHtml + html;
	return html;
}