var nameKeyWord = null;
var orgId = null;
var currSelectNodeIndex = -1;//记录当前所选的节点下标
var currSelectNodeId;//记录当前所选的节点ID
var currGridData = {users:[]};//当前表格的源数据，默认为空

//定义的一个map结构，key为nodeId，value为Node对象，用于存储已选的节点数据
var selectedNodeUserMap = {};

var cooperationImgMap = {};




var smsCheckedImgPath = "../common/images/userSelect/sms-checked.png";//短信已选图片路径
var smsCannelImgPath = "../common/images/userSelect/sms-cannel.png";//短信取消选择图片路径
var emailCheckedImgPath = "../common/images/userSelect/email-checked.png";//邮件已选图片路径
var emailCannelImgPath = "../common/images/userSelect/email-cannel.png";//邮件取消选择图片路径
/**
 * 初始化节点数据信息
 */
function init() {
    if (nodeinfolist != null && nodeinfolist.length > 0 && null != nodeinfolist[0]) {
        for (var n = 0; n < nodeinfolist.length; n++) {
            var nodeInfo =  nodeinfolist[n];
            if (nodeInfo.nodeType == 'USERTASK') {
                showNodeList(nodeInfo, n);
            } else {
                showSpecialNodeList(nodeInfo);
            }
        }

    }
}

//将部门全路径截掉第一级，如"广东电网公司/佛山供电局/安全监察部", 截取结果 "佛山供电局/安全监察部"
function cutDeptPathFromUserArray(_users) {
    if (_users) {
        for (var m = 0; m < _users.length; m++) {
            var user = _users[m];
            var deptName = user.deptPath;
            user.sendEmail = false;
            user.sendSMS = false;
            if (sameOrgUserDeptPath && deptName.indexOf(sameOrgUserDeptPath) != -1) {
				var idx = deptName.indexOf(sameOrgUserDeptPath);
				var len = sameOrgUserDeptPath.length;
				var n = ("/" == deptName.charAt(idx + len)) ? (idx + len + 1) : (idx + len);
				user.deptPath = deptName.substr(n);
				if (cui("#selectedOrgName").getValue()) {
					var path = cui("#selectedOrgName").getValue().toString().split("/");
					if (path.length > 1 && user.deptPath != "") {
						user.deptPath = path[path.length-1] + "/" + user.deptPath;
					} else if(path.length > 1 && user.deptPath == "") {
						user.deptPath = path[path.length-1];
					} else if (path.length == 1 && user.deptPath == "") {
						user.deptPath = path[0];
					}
				}
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
var nodeUsers = [];
/**
 * 点击节点后，加载表格数据
 * @param i 节点顺序
 */
function switchNode(i) {
    if (i == currSelectNodeIndex) {
        return;
    }
    currSelectNodeIndex = i;//记录当前所选的节点下标，搜索时用到
    var nodeInfo = nodeinfolist[i];
    if (!nodeInfo) {
        return;
    }
    currSelectNodeId = nodeInfo.nodeId;
    changeColor();//节点选中背景变色
    controlSelectDeptBtn(isViewSelectDept, nodeInfo);
    resetGridData();
}

function resetGridData() {
    var nodeInfo = nodeinfolist[currSelectNodeIndex];
    if (!nodeInfo) {
        return;
    }

    nameKeyWord = cui('#userFilter').getValue();
    nodeUsers = getNodeAllUsers(nodeInfo.nodeId, nodeInfo.processVersion, nameKeyWord,orgId); //节点上人的总数

    var gridObj = cui("#user_list_table");
    var query = gridObj.getQuery();
    query.pageNo = 1;//每次切换节点，开始页码都要变回1
    gridObj.setQuery(query);//修改页码数据后，要重新设置回去
    setGridData(nodeUsers, gridObj, query);

    //切换节点或翻页时，如果切换后的节点以前有人员选中过，则在列表中也恢复选中
    resetTableChecked();
}

function initDataSource(obj, query) {
    setGridData(currGridData, obj, query);
    //切换节点或翻页时，如果切换后的节点以前有人员选中过，则在列表中也恢复选中
    resetTableChecked();
}

/**
 * 切换节点或翻页时，如果切换后的节点以前有人员选中过，则在列表中也恢复选中
 */
function resetTableChecked() {
    var gridObj = cui("#user_list_table");
    if (gridObj && gridObj.data && gridObj.data.length > 0) {
		var currSelectNodeData = selectedNodeUserMap[currSelectNodeId];
		if (currSelectNodeData && currSelectNodeData.users) {
			var currGridSelectedUsers = currSelectNodeData.users;
			for (key in currGridSelectedUsers) {
				var pk = currGridSelectedUsers[key].userId;
				if (gridObj.getIndexByPk(pk) != -1) {
					gridObj.selectRowsByPK(pk, true);
				}
			}
		}
	}
}

/**
 * 为人员表格设置数据
 */
function setGridData(userList, obj, query){
    currGridData = userList;//当前表格的源数据

    if (null == userList || undefined == userList || userList.length == 0 || null == userList[0] || undefined == userList[0]) {
        currGridData = [];
        obj.setDatasource([],0);
        return;
    }

    var pageSize = query.pageSize;
    obj.setQuery(query);
    pageSize = obj.getQuery().pageSize;
    var pageNo = query.pageNo;
    var rowCount = userList.length;
    var startRowIndex = (pageNo - 1) * pageSize;
    var endRowIndex = pageNo * pageSize - 1;

    //数据全部在前台json中，通过前台js拷贝json对应区域的数据展示实现分页
    var newPageData = [];
    for (var i = 0; i < rowCount; i++) {
        //只截取开始行到结束行的数据
        if (i >= startRowIndex && i <= endRowIndex) {
            newPageData.push(copyUserObject(userList[i]));
        }
    }

    cutDeptPathFromUserArray(newPageData);

    //将新截取的json数据赋值给CUI表格
    obj.setDatasource(newPageData, rowCount);

 }

/*
 * 需要重新拷贝一份，以免引用数据改动导致源数据被改
 */
function copyUserObject(user) {
    if (user) {
        var newUser = {};
        newUser.userId = user.userId;
        newUser.userName = user.userName;
        newUser.deptId = user.deptId;
        newUser.deptPath = user.deptPath;
		if (user.postName) {
			newUser.postName = user.postName;
		}
        newUser.sendSMS = user.sendSMS;
        newUser.sendEmail = user.sendEmail;
        return newUser;
    }
    return null;
}

//要实现通过名称的过滤，注意数据时在前端的
function search(event, self) {
    nameKeyWord = self.getValue();
    //switchNode(currSelectNodeIndex);
    resetGridData();
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

    var nodeInfo = nodeinfolist[currSelectNodeIndex];//得到当前被选中的节点信息

    var user = new User(nodeInfo.nodeId, rowData.userId, rowData.userName, rowData.deptId, rowData.deptPath, rowData.postName,
		false, false);

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
            if (!$("#"+user.getKey())[0]) {//验重
                addUserToSelectedArea(node, user);
            }
        } else { //取消勾选
			user.sendSMS = user.sendEmail = false;
            removeUserFromSelectedArea(node.nodeId, user.getKey(), user.userId);
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
                            removeUserFromSelectedArea(node.nodeId, users[k].getKey(), users[k].userId);
                        }
                    }
                }
            },
            onNo: function() {//清除现在的选择的
                var node = selectedNodeUserMap[currSelectNodeId];
                var users = node.users;
                for(k in users) {
                    removeUserFromSelectedArea(node.nodeId, users[k].getKey(), users[k].userId);
                }
            }
        });
    }
}

//添加用户到已选区域
function addUserToSelectedArea(node, user) {
    var nodeKey = node.getKey();

    selectedNodeUserMap[currSelectNodeId].users[user.getKey()] = user;//将当选选择用户添加到已选map中

    if (!$('#node_user_' + nodeKey)[0]) {
        $('#selected_user_table').append(createSelectedNodeHtml(node));
    }
    $('#node_user_' + nodeKey).append(createSelectedUserHtml(node, user));

	setSmsEmailCheckedAllValue('sms');
	setSmsEmailCheckedAllValue('email');
}

//从已选区域删除用户
function removeUserFromSelectedArea(nodeId, userKey, userId) {

    var node = selectedNodeUserMap[nodeId];
    //删除已选Map中的数据和已选区域的html
    if (node.nodeType == 'USERTASK' && node.nodeId == nodeId) {
        $("#"+userKey).remove();//删用户方块儿
        delete node.users[userKey];//从节点中将用户删除
        if (getMapLength(node.users) < 1) {//如果节点下用户数为0，则把节点也删掉掉
            $("#tr_"+node.getKey()).remove(); //删除tr
            delete selectedNodeUserMap[nodeId];//从map中将节点删除
        }
    }

    changeGridRowChecked(nodeId, userId, false); //取消列表选中
	setSmsEmailCheckedAllValue('sms');// 处理短信全选
	setSmsEmailCheckedAllValue('email');// 处理邮件全选
}

function getMapLength(map) {
    var i = 0;
    for (key in map) {
        i++;
    }
    return i;
}

//验证节点数据中是否有用户节点
function isHaveUserNode() {
    var tempData = nodeinfolist;
    if (null != tempData && tempData.length > 0 && null != tempData[0]) {
        for (var n = 0; n < tempData.length; n++) {
            var nodeInfo =  tempData[n];
            if (nodeInfo.nodeType == 'USERTASK') {
                return true;
            }
        }
    }
    return false;
}

function more() {
	if (getMapLength(selectedNodeUserMap) > 0 && isHaveUserNode()) {
        cui("#more_div").dialog({
            title : "\u5df2\u9009",
            src: "more.jsp",
            width: 620,
            height: 200
        }).show();
        cui("#more_div").reload("more.jsp");
	} else {
		//没有已选人员，暂无法查看
		cui.alert('\u6ca1\u6709\u5df2\u9009\u4eba\u5458\uff0c\u6682\u65e0\u6cd5\u67e5\u770b');
	}
}

function resizeMoreDialog(heightSize){
    cui("#more_div").setSize({width:620, height: heightSize});
}

//改变列表记录是否选中，如：1.在已选中叉掉后，如果保持在当前节点列表，则也要把列表的勾选去掉 2.切换节点时，恢复选中
function changeGridRowChecked(nodeId, userId, isChecked) {
    if (nodeId == currSelectNodeId) {
        cui("#user_list_table").selectRowsByPK(userId, isChecked);
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
	var deleteStr = '<a href="javascript:removeUserFromSelectedArea(\''+ node.nodeId +'\', \'' + key + '\', \'' + user.userId + '\');">' + 
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
        '<td id="node_user_' + key + '" style="width:600px">' +
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
    if ((!isSmsColHide && 'sms' == type) || (!isEmailColHide && 'email' == type)) {
    	//判断是否触发全选被勾选
    	if ($(".selected_users").length > 0 && $("img[src$='"+type+"-cannel.png']").length < 1) {
    		$("#"+type+"_img_all")[0].checked = true;
    	} else {
    		$("#"+type+"_img_all")[0].checked = false;
    	}
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

//弹出组织选择页面
function onClickDemo(){
    var obj ={};
    obj.chooseMode = 1; //控制可选数，0默认无限制
    obj.chooseType = 'org';//弹出组织选择页面
    obj.callback = 'chooseOrgCallback'; //定义回调函数   
    obj.winHeight=410;
    displayUserOrgTag(obj);

    //调整部门弹出窗的高度
    var t = setInterval(function(){
        var d = window.frames[0].document.getElementById('choose_page_box');
        if(d && window.frames[0].$){
            try{
                window.frames[0].$(".choose_page_top").height('329px');
                window.frames[0].$(".choose_page_left").height('315px');
                window.frames[0].$(".choose_page_left_bottom").height('235px');
            }catch(e){};
            clearInterval(t);
        }
    },10)
 }

//选择完成后刷新节点和人员
// 回调方法，参数1：selected，参数2：tagId，selected参数为节点信息，tagId为当前选择的标签id
function chooseOrgCallback(selected,tagId) {
    if(undefined != selected[0]){
        //1、回调，获取节点人员
        orgId = selected[0].id;
        sameOrgUserDeptPath = selected[0].fullName;
		//alert(sameOrgUserDeptPath);
        cui("#selectedOrgName").setValue(sameOrgUserDeptPath.substr(sameOrgUserDeptPath.indexOf("/")+1));
		//alert(sameOrgUserDeptPath.substr(sameOrgUserDeptPath.indexOf("/")));
		//alert(cui("#selectedOrgName").getValue());
        tempSameOrgUserDeptPath = sameOrgUserDeptPath;
        tempSameOrgUserOrgStructureId = orgId;
    } else{
        orgId = '';
        cui("#selectedOrgName").setValue('');
        tempSameOrgUserDeptPath = '';
        tempSameOrgUserOrgStructureId = '';
    }
    resetGridData();
}


/**
 * 控制选择部门按钮是否显示
 * 规则： 1.如果url中传入了isViewSelectDept参数，则已参数为准，true则显示，false隐藏
 *        2.如果没有传入isViewSelectDept参数，查看opener页面是否覆盖getViewSelectDeptFlag(nodeInfo)方法，
 *          根据以返回值为准，true则显示，false隐藏
 *        3.如果什么都没有，则默认以节点是否配置同组用户函数为准，如果hasFilterFunction为false，直接隐藏，
 *          如果hasFilterFunction为true，则判断functionInfo里面是否有functionCode值为sameOrganizationUsers
 *          的函数，有则显示，否则隐藏
 *        4.如果按钮隐藏，则清除orgId和同组用户部门框的值，反之赋值进行过滤和截取
 */
function controlSelectDeptBtn(isViewSelectDept, nodeInfo) {

    var resultFlag = false;

    if (true == isViewSelectDept || false == isViewSelectDept) { //1. 优先判断参数传入的值判断是否显示
        resultFlag = isViewSelectDept;
    } else if (window.opener.getViewSelectDeptFlag){ //2. 如果没有传入参数，根据回调返回值是否显示
        var flag = window.opener.getViewSelectDeptFlag(nodeInfo);
        if (true == flag || false == flag) {
            resultFlag = flag;
        }
    } else { //3. 没有参数传入也没有回调，根据节点同组用户函数判断是否显示
        if (nodeInfo) {
            var hasFilterFunction = nodeInfo.hasFilterFunction;
            if (true == hasFilterFunction) {
                var functionInfo = nodeInfo.functionInfo;
                if (functionInfo && functionInfo.length > 0) {
                    for (var i = 0; i < functionInfo.length; i++) {
                        var func = functionInfo[i];
                        if (func && func.functionCode && "sameOrganizationUsers" == func.functionCode) {
                            resultFlag = true;
                            break;
                        }
                    };
                }
            }
        }
    }

    // 如果通过上述逻辑判断了需要显示部门选择按钮
    if (true == resultFlag) {
        // 判断是否有回调函数，如果有直接调用回调函数，获取部门ID和部门名称
        if (window.opener.getNodeFilterDeptParam) {
            var param = window.opener.getNodeFilterDeptParam(nodeInfo);
            orgId = param.sameOrgUserOrgStructureId;
            orgId = (undefined == orgId) ? "" : orgId;
            sameOrgUserDeptPath = param.sameOrgUserDeptPath;
            sameOrgUserDeptPath = (undefined == sameOrgUserDeptPath) ? "" : sameOrgUserDeptPath;
        } else {
            //如果没有回调函数，则使用最初参数传入的部门ID和部门名称
            orgId = tempSameOrgUserOrgStructureId;
            sameOrgUserDeptPath = tempSameOrgUserDeptPath;
        }
        cui("#selectedOrgName").setValue(sameOrgUserDeptPath.substr(sameOrgUserDeptPath.indexOf("/")+1));
        $(".deptSelect").show();
    } else {
        // 如果通过上述逻辑判断了不显示部门选择按钮，则将部门ID和部门名称置空，隐藏按钮
        orgId = '';
        sameOrgUserDeptPath = '';
        cui("#selectedOrgName").setValue('');
        $(".deptSelect").hide();
    }
    
}