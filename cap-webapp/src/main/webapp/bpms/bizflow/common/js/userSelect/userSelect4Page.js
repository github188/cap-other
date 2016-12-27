var currSelectNodeId = null;//记录当前所选的节点ID
var nameKeyWord = null;
var orgId = null;

//定义的一个map结构，key为nodeId，value为Node对象，用于存储已选的节点数据
var selectedNodeUserMap = {}; 

var cooperationImgMap = {};

//存储从后端获取的节点下所有人员数据，以nodeId为标示
var nodeAllUsersJsonCache = {};

var smsCheckedImgPath = "../common/images/userSelect/sms-checked.png";//短信已选图片路径
var smsCannelImgPath = "../common/images/userSelect/sms-cannel.png";//短信取消选择图片路径
var emailCheckedImgPath = "../common/images/userSelect/email-checked.png";//邮件已选图片路径
var emailCannelImgPath = "../common/images/userSelect/email-cannel.png";//邮件取消选择图片路径
/**
 * 初始化节点数据信息
 */
function init() {
	if (!nodeinfolist  || nodeinfolist.length == 0) {
		return;
	}
	for (var n = 0; n < nodeinfolist.length; n++) {
		var nodeInfo =  nodeinfolist[n];
		if (nodeInfo.nodeType == 'USERTASK') {
			showNodeList(nodeInfo, n);
		} else {
			showSpecialNodeList(nodeInfo);
		}
	}
}



//将部门全路径截掉第一级，如"广东电网公司/佛山供电局/安全监察部", 截取结果 "佛山供电局/安全监察部"
function cutDeptPathFromUserArray(_users) {
	if (_users) {
		for (var m = 0; m < _users.length; m++) {
			var user = _users[m];
			var deptName = user.deptPath;
            if (sameOrgUserDeptPath) {
                user.deptPath = deptName.substr(deptName.indexOf(sameOrgUserDeptPath)+1);   
            } else {
                user.deptPath = deptName.substr(deptName.indexOf("/")+1);   
            }
		}
	}
	return _users;
}

//页面初始化时，展示节点列表
function showNodeList(nodeInfo, n) {
	var ulNode = $('#node');
	if (ulNode.length > 0) {
		var liHtml = 
			'<li id="li_'+nodeInfo.nodeId+'" onmouseover="changeClass(\''+nodeInfo.nodeId+'\', \'li_mouseover\')" onmouseout="changeClass(\''+nodeInfo.nodeId+'\', \'li_mouseout\')">'+
				generateCooperationImgText(nodeInfo) + 
				'<a class="node_title" title="'+nodeInfo.nodeName+'" href="javascript: switchNode('+n+');">'+nodeInfo.nodeName+'</a>'+
			'</li>';
		ulNode.append(liHtml);
	}
}

//添加特殊节点，比如结束节点等没有用户的节点
function showSpecialNodeList(nodeInfo) {
	if (nodeInfo.nodeType != 'USERTASK') {
		var topLeft = $(".top_left");
		var specialNodeDiv = $(".specialNodeDiv");
		if (specialNodeDiv.length < 1) {
			topLeft.append("<div class='specialNodeDiv'></div>");
			specialNodeDiv = $(".specialNodeDiv");
		}
		specialNodeDiv.append('<div class="specialNodeText" title="'+nodeInfo.nodeName+'"><label><input type="checkbox" onclick="checkedSpecialNode(\''+nodeInfo.nodeId+'\', this.checked)"/>'+nodeInfo.nodeName+'</label>' +
			generateCooperationImgText(nodeInfo) + '</div>');
	}
}

var iNumber = 1;
function generateCooperationImgText(nodeInfo) {
	var cooperationId = nodeInfo.cooperationId;
	var imgText = '';
	if ('' != cooperationId && null != cooperationId && cooperationId.length > 0) {
		//从map中能取到，就用现成的图标，取不到则获取新的图标
		imgText = cooperationImgMap[cooperationId];
		if ('' == imgText || null == imgText || imgText.length < 1) {
			imgText = '<img src="../common/images/userSelect/'+ iNumber++ +'.png" title="\u534f\u540cID\uff1a' + cooperationId + '"/>';
			cooperationImgMap[cooperationId] = imgText;
		}
	}
	return imgText;
}

//选择特殊节点
function checkedSpecialNode(nodeId, checked) {
	for (var i = 0; i < nodeinfolist.length; i++) {
		var nodeInfo = nodeinfolist[i];
		if (nodeId == nodeInfo.nodeId) {
			var node = new Node(nodeInfo.nodeId, nodeInfo.nodeName, nodeInfo.nodeType, nodeInfo.nodeInstanceId, 
				nodeInfo.cooperationFlag, nodeInfo.cooperationId, nodeInfo.processId, nodeInfo.processVersion);
			if (checked) {
				selectedNodeUserMap[node.getKey()] = node;
			} else {
				delete selectedNodeUserMap[node.getKey()];
			}
		}
	};
}

/**
 * 点击节点后，加载表格数据，请求两次，第一次请求该节点上的总人数，第二次请求具体的人
 * @param i 节点顺序
 */
function switchNode(i) {
	cui("#userFilter").setValue(null); //切换节点，清空过滤条件
	var selectedNode = nodeinfolist[i];
	currSelectNodeId = selectedNode.nodeId;
    var gridObj = cui("#user_list_table");
	changeColor();//节点选中背景变色
    //第一步：查询节点上人的总数
    var nodeUserCount = getNodeUserCount(currSelectNodeId,nameKeyWord,orgId); //节点上人的总数
    if(undefined == nodeUserCount || nodeUserCount == 0){
        gridObj.setDatasource([],0);
        return;
    }
	//第二步：查询节点上具体的人
    var query = gridObj.getQuery();
    query.pageNo = 1;
    query.pageSize = 8;
    var nodeUsers = getNodeUsers(currSelectNodeId,nameKeyWord,orgId,query.pageNo,query.pageSize); //节点上人的总数
    gridObj.setQuery(query);//修改页码数据后，要重新设置回去
    setGridData(nodeUsers, gridObj,nodeUserCount);
	
	//切换节点时，如果切换后的节点以前有人员选中过，则在列表中也恢复选中
	var currSelectNodeData = selectedNodeUserMap[currSelectNodeId];
	if (currSelectNodeData && selectedNodeUserMap[currSelectNodeId].users) {
		var currGridSelectedUsers = selectedNodeUserMap[currSelectNodeId].users;
		for (key in currGridSelectedUsers) {
			changeGridRowChecked(currSelectNodeId, currGridSelectedUsers[key].getKey(), true);
		}
	}
}



/**
 * 第一次加载数据源和分页时调用此函数
 */
function initDataSource(obj, query) {
    var userList =null;
    if(null != currSelectNodeId) {
         userList = getNodeUsers(currSelectNodeId,nameKeyWord,orgId,query.pageNo,query.pageSize); //节点上人的总数
    }
    setGridData(userList, obj, query);
}


/**
 * 为人员表格设置数据
 */
function setGridData(userList, obj,nodeUserCount){
	if (undefined == userList || userList.length == 0) {
		obj.setDatasource([],0);
		return;
	}

	cutDeptPathFromUserArray(userList);//截取部门路径

	//将新截取的json数据赋值给CUI表格
	obj.setDatasource(userList, nodeUserCount);
}

//要实现通过名称的过滤，注意数据时在前端的
function search(event, self) {
    nameKeyWord = self.getValue();
	if ("" == nameKeyWord || null == nameKeyWord) {
		return;
	}
    var currNodeUsers = getNodeUsers(currSelectNodeId,nameKeyWord,orgId,1,8); //节点上人的总数
	var gridObj = cui("#user_list_table");
	var query = gridObj.getQuery();
	query.pageNo = 1;//每次开始页码都要变回1
    query.pageSize = 8;//每次开始页码都要变回1
	gridObj.setQuery(query);//修改页码数据后，要重新设置回去
	setGridData(currNodeUsers, gridObj, query);
}

//响应搜索条的回车事件
function searchBarEnterEvent(event, self) {
	if (event.keyCode == "13") {
		search(event, self);
	}
}

//勾选或取消勾选事件
function clickCallback(rowData, checked, index) {
	selectOne(rowData, checked, index, false);
}

//表格全选
function selectAll(gridData, checked) {
	
	var table = cui("#user_list_table");
	if (!checked) {
		gridData = table.getData();//cui取消全选不会返回所有数据，自己取一下
	} else if (isSingleSelect) {
		handlerSingleSelect();
	}

	for (var i = 0; i < gridData.length; i++) {
		selectOne(gridData[i], checked, i, true);
	};
}

function selectOne(rowData, checked, index, fromSelectAll) {

	if (!fromSelectAll && checked && isSingleSelect) {//从selectAll方法调过来的，不需要校验单选覆盖
		handlerSingleSelect();
	}
	
	var nodeInfo = nodeinfolist[i];;//得到当前被选中的节点信息

	var user = new User(nodeInfo.nodeId, rowData.userId, rowData.userName, rowData.deptId, rowData.deptPath, rowData.position,
		true, true);

	var selectedNode = selectedNodeUserMap[currSelectNodeId];//从已选map中拿Node对象数据
	if (null == selectedNode || undefined == selectedNode) {//表示之前没有选择过该节点的人员

		var node = new Node(nodeInfo.nodeId, nodeInfo.nodeName, nodeInfo.nodeType, nodeInfo.nodeInstanceId, 
			nodeInfo.cooperationFlag, nodeInfo.cooperationId, nodeInfo.processId, nodeInfo.processVersion);
		
    	node.users[user.getKey()] = user;//将被选中的user放进去
    	selectedNodeUserMap[currSelectNodeId] = node;

    	addUserToSelectedArea(node, user);
	} else {//已经选择过该节点的人员，需要排重
		var node = selectedNodeUserMap[currSelectNodeId];
		var users = node.users;
		
		if (checked) { //勾选			
			if (!verifyRepeat(users, user)) {//验重
    			addUserToSelectedArea(node, user);
    		}
		} else { //取消勾选
			user.sendSMS = user.sendEmail = false;
			removeUserFromSelectedArea(node.nodeId, user.getKey());
		}
	}
}

//处理单节点选择时，用户选多节点用户的情况
function handlerSingleSelect() {
	var node;
	var users;
	var bln = false;
	//检查之前有没有选择用户
	for(key in selectedNodeUserMap) {
		node = selectedNodeUserMap[key];
		users = node.users;
		if (getMapLength(users) > 0 && currSelectNodeId != node.nodeId) {
			bln = true;
			break;
		}
	}

	if (bln) {
		//此流程仅支持单节点选择，是否清除上一节点数据？
		cui.confirm('\u6b64\u6d41\u7a0b\u4ec5\u652f\u6301\u5355\u8282\u70b9\u9009\u62e9\uff0c\u662f\u5426\u6e05\u9664\u4e0a\u4e00\u8282\u70b9\u6570\u636e\uff1f', {
            onYes: function() {//清除以前选择的
            	var node;
				var users;
				for(key in selectedNodeUserMap) {
					node = selectedNodeUserMap[key];
					if ("USERTASK" == node.nodeType && node.nodeId != currSelectNodeId) {
						users = node.users;
						for(k in users) {
							removeUserFromSelectedArea(node.nodeId, users[k].getKey());
						}
					}
				}
            },
            onNo: function() {//清除现在的选择的
            	var node = selectedNodeUserMap[currSelectNodeId];
				var users = node.users;
				for(k in users) {
					removeUserFromSelectedArea(node.nodeId, users[k].getKey());
				}
            }
        });
	}
}

//验证重复选择
function verifyRepeat(users, user) {
	for (key in users) {
		if (users[key].getKey() == user.getKey()) {
			return true;
		} 
	};
	return false;
}

//添加用户到已选区域
function addUserToSelectedArea(node, user) {
	var nodeKey = node.getKey();

	selectedNodeUserMap[currSelectNodeId].users[user.getKey()] = user;//将当选选择用户添加到已选map中

	if (!$('#node_user_' + nodeKey)[0]) {
		$('#selected_user_table').append(createSelectedNodeHtml(node));
	}
	$('#node_user_' + nodeKey).append(createSelectedUserHtml(node, user));
	
	controlMoreLink();//控制更多的显示

	setSmsEmailCheckedAllValue('sms');
	setSmsEmailCheckedAllValue('email');
}

//从已选区域删除用户
function removeUserFromSelectedArea(nodeId, userKey) {
	
	var node = selectedNodeUserMap[nodeId];
	//删除已选Map中的数据
	for (key in selectedNodeUserMap) {
		if (selectedNodeUserMap[key].nodeType == 'USERTASK' && selectedNodeUserMap[key].nodeId == nodeId) {
			delete selectedNodeUserMap[key].users[userKey];
			if (getMapLength(selectedNodeUserMap[key].users) < 1) {//如果节点下用户数为0，则把节点也删掉掉
				delete selectedNodeUserMap[key];
			}
		}
	};
	
	$("#"+userKey).remove();//删用户方块儿
	var nodeKey = node.getKey();
	if ($("#node_user_" + nodeKey).children().length < 1) {
		$("#tr_"+nodeKey).remove(); //删除tr
	}

	changeGridRowChecked(nodeId, userKey, false); //取消列表选中
	controlMoreLink();//控制更多的显示
	setSmsEmailCheckedAllValue('sms');
	setSmsEmailCheckedAllValue('email');
}

function getMapLength(map) {
	var i = 0;
	for (key in map) {
		i++;
	}
	return i;
}

//控制更多的显示
function controlMoreLink() {
	if ($("#selected_user_table").height() > 70) {
		$('#more').show();
	} else {
		$('#more').hide();
	}
}

function more() {
	if (getMapLength(selectedNodeUserMap) > 0) {
		cui("#more_div").dialog({
	        title : "\u5df2\u9009",
	        src: "more.jsp",
	        width: 600,
	        height: 200
	    }).show();
	    cui("#more_div").reload("more.jsp");
	} else {
		//没有已选人员，暂无法查看
		cui.alert('\u6ca1\u6709\u5df2\u9009\u4eba\u5458\uff0c\u6682\u65e0\u6cd5\u67e5\u770b');
	}
}

//改变列表记录是否选中，如：1.在已选中叉掉后，如果保持在当前节点列表，则也要把列表的勾选去掉 2.切换节点时，恢复选中
function changeGridRowChecked(nodeId, userKey, isChecked) {
	var objGrid = cui("#user_list_table");
	var gridData = objGrid.getData();
	var rowData;
	var user;
	for (var i = 0; i < gridData.length; i++) {
		rowData = gridData[i];
		user = new User(nodeId, rowData.userId, rowData.userName, rowData.deptId, rowData.deptPath, rowData.position,
			rowData.sendEmail, rowData.sendSMS);
		if (userKey == user.getKey() && nodeId == currSelectNodeId) {//key相同的被认为是同一条数据
			objGrid.selectRowsByIndex(i, isChecked);
		}
	}
}

//创建已选用户的div小方块
function createSelectedUserHtml(node, user) {
	var key = user.getKey();
	var smsStr = "";
	var emailStr = "";
	if (!isEmailColHide) {
		var srcValue = (user.sendEmail) ? emailCheckedImgPath : emailCannelImgPath;
		emailStr += '<a href="javascript:emailChecked(\'' + key + '\');">' + 
						'<img id="img_email_' + key + '" class="img_email" src="' + srcValue + '" border="0">' +
					'</a>';
	}
	if (!isSmsColHide) {
		var srcValue = (user.sendSMS) ? smsCheckedImgPath : smsCannelImgPath;
		smsStr +=   '<a href="javascript:smsChecked(\'' + key + '\');">' + 
						'<img id="img_sms_' + key + '" class="img_sms" src="' + srcValue + '" border="0">' +
				    '</a>';
	}
	var deleteStr = '<a href="javascript:removeUserFromSelectedArea(\''+ node.nodeId +'\', \'' + key + '\');">' + 
						'<img class="img_delete" src="../common/images/userSelect/remove.png" border="0" onmouseover="this.src=\'../common/images/userSelect/remove-hover.png\'" onmouseout="this.src=\'../common/images/userSelect/remove.png\'" >' +
					'</a>';
	return '<div class="selected_users" title="' + user.deptPath +  ' ' + user.userName + '" id="' + key + '">' +
				user.userName + 
				smsStr +
				emailStr +
				deleteStr +
			'</div>';
}

//创建已选节点的tr
function createSelectedNodeHtml(node) {
	var key = node.getKey();
	return '<tr id="tr_'+key+'">' +
				'<td class="selected_node_text"  id="node_name_' + key + '"><span title="'+node.nodeName+'\uff1a">' + node.nodeName+ '\uff1a</span></td>' +
				'<td id="node_user_' + key + '">' +
				'</td>' +
			'</tr>';
}

//重新定义表格宽度
function resizeWidth(){
	return 590;
}

//将是否发送短信赋值到已选用户对象的sendSMS属性
function smsChecked(userKey, isChecked) {
	var objSmsImg = $('#img_sms_'+userKey)[0];
	if (objSmsImg) {
		for (key in selectedNodeUserMap) {
			var selectedNode = selectedNodeUserMap[key];
			if (selectedNode) {
				var user = selectedNode.users[userKey];
				if (user) {
					if (undefined == isChecked) {
						objSmsImg.src= (user.sendSMS) ? smsCannelImgPath : smsCheckedImgPath;
						user.sendSMS = !user.sendSMS;
					} else {
						objSmsImg.src= (isChecked) ? smsCheckedImgPath : smsCannelImgPath;
						user.sendSMS = isChecked;
					}
					break;
				}
			}
		};
	}

	setSmsEmailCheckedAllValue('sms');
}

function smsCheckedAll(objCheckbox) {
	var isChecked = objCheckbox.checked;
	$(".img_sms").each(function() {
		smsChecked($(this).attr("id").substr(8), isChecked);
	});
}

/**
 * @param type sms|email
 */
function setSmsEmailCheckedAllValue(type) {
	//判断是否触发全选被勾选
	if ($(".selected_users").length > 0 && $("img[src$='"+type+"-cannel.png']").length < 1) {
		$("#"+type+"_img_all")[0].checked = true;
	} else {
		$("#"+type+"_img_all")[0].checked = false;
	}
}

//将是否发送邮件赋值到已选用户对象的sendEmail属性
function emailChecked(userKey, isChecked) {
	var objEmailImg = $('#img_email_'+userKey)[0];
	if (objEmailImg) {
		for (key in selectedNodeUserMap) {
			var selectedNode = selectedNodeUserMap[key];
			if (selectedNode) {
				var user = selectedNode.users[userKey];
				if (user) {
					if (undefined == isChecked) {
						objEmailImg.src= (user.sendEmail) ? emailCannelImgPath :emailCheckedImgPath;
						user.sendEmail = !user.sendEmail;
					} else {
						objEmailImg.src= (isChecked) ? emailCheckedImgPath : emailCannelImgPath;
						user.sendEmail = isChecked;
					}
					break;
				}
			}
		}
	}

	setSmsEmailCheckedAllValue('email');
}


function emailCheckedAll(objCheckbox) {
	var isChecked = objCheckbox.checked;
	$(".img_email").each(function() {
		emailChecked($(this).attr("id").substr(10), isChecked);
	});
}

function changeColor() {
	//取消所有选中颜色
	$("ul > li").each(function(){
		$(this).removeClass().addClass("li_mouseout");
	});
	$("#li_"+currSelectNodeId).removeClass().addClass("li_mouseover");//选中变色
}

//左侧节点li的滑动效果
function changeClass(id, clazz) {
	$('#li_'+id).removeClass().addClass(clazz);
	//如果该节点是已选中的，则要继续保持颜色
	if (id == currSelectNodeId) {
		$("#li_"+currSelectNodeId).removeClass().addClass("li_mouseover");//选中变色
	}
}

function opinionChange(value) {
	if (1 == value) {
		cui('#opinion').setValue("\u540c\u610f\u3002"+ getOpinionFromOtherPage());
	} else if (0 == value) {
		cui('#opinion').setValue("\u4e0d\u540c\u610f\u3002"+ getOpinionFromOtherPage());
	}
}

function resizeMoreDialog(heightSize){
	cui("#more_div").setSize({width:600, height: heightSize});
}


//清掉已选节点人员
function deleteAllSelectNodeUsers() {
    for (key in selectedNodeUserMap) {
        var nodeId = key;
        var nodeInfo = selectedNodeUserMap[key];
        var users = nodeInfo.users;
        for (k in users) {
            var userKey = users[k].getKey();
            removeUserFromSelectedArea(nodeId, userKey);
        }
        delete selectedNodeUserMap[key];
    }
}


//弹出组织选择页面
function onClickDemo(){
    var obj ={};
    obj.chooseMode = 1; //控制可选数，0默认无限制
    obj.chooseType = 'org';//弹出组织选择页面
    obj.height = '160px;';
    obj.callback = 'chooseOrgCallback'; //定义回调函数
    obj.rootId='A';
    obj.orgStructureId='A';
    displayUserOrgTag(obj);
 }


//选择完成后刷新节点和人员
// 回调方法，参数1：selected，参数2：tagId，selected参数为节点信息，tagId为当前选择的标签id
function chooseOrgCallback(selected,tagId) {
    //1、回调，获取节点人员
	var orgId = selected[0].id;
    data = window.opener.bpmsQueryNodeUsersByOrgId(recordId,taskId,orgId);
    //data=window.opener.getData1();
    //2、重新初始化节点人员框
    $('#node')[0].innerHTML = '';
    var specialNodeDiv = $(".specialNodeDiv");
	if (specialNodeDiv.length > 1) {
		 $(".specialNodeDiv")[0].innerHTML = '';
	}
	var fullName = selected[0].fullName;
	cui("#selectedOrgName").setValue( fullName.substr(fullName.indexOf("/")+1) );
    init();
    switchNode(0); //默认选中第一个节点
    //3、清掉已选数据
    deleteAllSelectNodeUsers();
}
function delCallback(){}