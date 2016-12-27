var nameKeyWord = null;
var orgId = null;
var currSelectNodeIndex = -1;//��¼��ǰ��ѡ�Ľڵ��±�
var currSelectNodeId;//��¼��ǰ��ѡ�Ľڵ�ID
var currGridData = {users:[]};//��ǰ����Դ���ݣ�Ĭ��Ϊ��

//�����һ��map�ṹ��keyΪnodeId��valueΪNode�������ڴ洢��ѡ�Ľڵ�����
var selectedNodeUserMap = {};

var cooperationImgMap = {};




var smsCheckedImgPath = "../common/images/userSelect/sms-checked.png";//������ѡͼƬ·��
var smsCannelImgPath = "../common/images/userSelect/sms-cannel.png";//����ȡ��ѡ��ͼƬ·��
var emailCheckedImgPath = "../common/images/userSelect/email-checked.png";//�ʼ���ѡͼƬ·��
var emailCannelImgPath = "../common/images/userSelect/email-cannel.png";//�ʼ�ȡ��ѡ��ͼƬ·��
/**
 * ��ʼ���ڵ�������Ϣ
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

//������ȫ·���ص���һ������"�㶫������˾/��ɽ�����/��ȫ��첿", ��ȡ��� "��ɽ�����/��ȫ��첿"
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

//ҳ���ʼ��ʱ��չʾ�ڵ��б�

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

//�������ڵ㣬��������ڵ��û���û��Ľڵ�
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
        //��map����ȡ���������ֳɵ�ͼ�꣬ȡ�������ȡ�µ�ͼ��
        imgText = cooperationImgMap[cooperationId];
        if ('' == imgText || null == imgText || imgText.length < 1) {
            imgText = '<img src="../common/images/userSelect/'+ iNumber++ +'.png" title="\u534f\u540cID\uff1a' + cooperationId + '"/>';
            cooperationImgMap[cooperationId] = imgText;
        }
    }
    return imgText;
}

//ѡ������ڵ�
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
 * ����ڵ�󣬼��ر������
 * @param i �ڵ�˳��
 */
function switchNode(i) {
    if (i == currSelectNodeIndex) {
        return;
    }
    currSelectNodeIndex = i;//��¼��ǰ��ѡ�Ľڵ��±꣬����ʱ�õ�
    var nodeInfo = nodeinfolist[i];
    if (!nodeInfo) {
        return;
    }
    currSelectNodeId = nodeInfo.nodeId;
    changeColor();//�ڵ�ѡ�б�����ɫ
    controlSelectDeptBtn(isViewSelectDept, nodeInfo);
    resetGridData();
}

function resetGridData() {
    var nodeInfo = nodeinfolist[currSelectNodeIndex];
    if (!nodeInfo) {
        return;
    }

    nameKeyWord = cui('#userFilter').getValue();
    nodeUsers = getNodeAllUsers(nodeInfo.nodeId, nodeInfo.processVersion, nameKeyWord,orgId); //�ڵ����˵�����

    var gridObj = cui("#user_list_table");
    var query = gridObj.getQuery();
    query.pageNo = 1;//ÿ���л��ڵ㣬��ʼҳ�붼Ҫ���1
    gridObj.setQuery(query);//�޸�ҳ�����ݺ�Ҫ�������û�ȥ
    setGridData(nodeUsers, gridObj, query);

    //�л��ڵ��ҳʱ������л���Ľڵ���ǰ����Աѡ�й��������б���Ҳ�ָ�ѡ��
    resetTableChecked();
}

function initDataSource(obj, query) {
    setGridData(currGridData, obj, query);
    //�л��ڵ��ҳʱ������л���Ľڵ���ǰ����Աѡ�й��������б���Ҳ�ָ�ѡ��
    resetTableChecked();
}

/**
 * �л��ڵ��ҳʱ������л���Ľڵ���ǰ����Աѡ�й��������б���Ҳ�ָ�ѡ��
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
 * Ϊ��Ա�����������
 */
function setGridData(userList, obj, query){
    currGridData = userList;//��ǰ����Դ����

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

    //����ȫ����ǰ̨json�У�ͨ��ǰ̨js����json��Ӧ���������չʾʵ�ַ�ҳ
    var newPageData = [];
    for (var i = 0; i < rowCount; i++) {
        //ֻ��ȡ��ʼ�е������е�����
        if (i >= startRowIndex && i <= endRowIndex) {
            newPageData.push(copyUserObject(userList[i]));
        }
    }

    cutDeptPathFromUserArray(newPageData);

    //���½�ȡ��json���ݸ�ֵ��CUI���
    obj.setDatasource(newPageData, rowCount);

 }

/*
 * ��Ҫ���¿���һ�ݣ������������ݸĶ�����Դ���ݱ���
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

//Ҫʵ��ͨ�����ƵĹ��ˣ�ע������ʱ��ǰ�˵�
function search(event, self) {
    nameKeyWord = self.getValue();
    //switchNode(currSelectNodeIndex);
    resetGridData();
}

//��Ӧ�������Ļس��¼�
function searchBarEnterEvent(event, self) {
    if (event.keyCode == "13") {
        search(event, self);
    }
}

//��ѡ��ȡ����ѡ�¼�
function clickCallback(rowData, checked, index) {
    selectOne(rowData, checked, index, false);
}

//���ȫѡ
function selectAll(gridData, checked) {

    var table = cui("#user_list_table");
    if (!checked) {
        gridData = table.getData();//cuiȡ��ȫѡ���᷵���������ݣ��Լ�ȡһ��
    } else if (isSingleSelect) {
        handlerSingleSelect();
    }

    for (var i = 0; i < gridData.length; i++) {
        selectOne(gridData[i], checked, i, true);
    };
}

function selectOne(rowData, checked, index, fromSelectAll) {

    if (!fromSelectAll && checked && isSingleSelect) {//��selectAll�����������ģ�����ҪУ�鵥ѡ����
        handlerSingleSelect();
    }

    var nodeInfo = nodeinfolist[currSelectNodeIndex];//�õ���ǰ��ѡ�еĽڵ���Ϣ

    var user = new User(nodeInfo.nodeId, rowData.userId, rowData.userName, rowData.deptId, rowData.deptPath, rowData.postName,
		false, false);

    var selectedNode = selectedNodeUserMap[currSelectNodeId];//����ѡmap����Node��������
    if (null == selectedNode || undefined == selectedNode) {//��ʾ֮ǰû��ѡ����ýڵ����Ա

        var node = new Node(nodeInfo.nodeId, nodeInfo.nodeName, nodeInfo.nodeType, nodeInfo.nodeInstanceId,
            nodeInfo.cooperationFlag, nodeInfo.cooperationId, nodeInfo.processId, nodeInfo.processVersion);

        node.users[user.getKey()] = user;//����ѡ�е�user�Ž�ȥ
        selectedNodeUserMap[currSelectNodeId] = node;

        addUserToSelectedArea(node, user);
    } else {//�Ѿ�ѡ����ýڵ����Ա����Ҫ����
        var node = selectedNodeUserMap[currSelectNodeId];
        var users = node.users;

        if (checked) { //��ѡ
            if (!$("#"+user.getKey())[0]) {//����
                addUserToSelectedArea(node, user);
            }
        } else { //ȡ����ѡ
			user.sendSMS = user.sendEmail = false;
            removeUserFromSelectedArea(node.nodeId, user.getKey(), user.userId);
        }
    }
}

//�����ڵ�ѡ��ʱ���û�ѡ��ڵ��û������
function handlerSingleSelect() {
    var node;
    var users;
    var bln = false;
    //���֮ǰ��û��ѡ���û�
    for(key in selectedNodeUserMap) {
        node = selectedNodeUserMap[key];
        users = node.users;
        if (getMapLength(users) > 0 && currSelectNodeId != node.nodeId) {
            bln = true;
            break;
        }
    }

    if (bln) {
        //�����̽�֧�ֵ��ڵ�ѡ���Ƿ������һ�ڵ����ݣ�
        cui.confirm('\u6b64\u6d41\u7a0b\u4ec5\u652f\u6301\u5355\u8282\u70b9\u9009\u62e9\uff0c\u662f\u5426\u6e05\u9664\u4e0a\u4e00\u8282\u70b9\u6570\u636e\uff1f', {
            onYes: function() {//�����ǰѡ���
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
            onNo: function() {//������ڵ�ѡ���
                var node = selectedNodeUserMap[currSelectNodeId];
                var users = node.users;
                for(k in users) {
                    removeUserFromSelectedArea(node.nodeId, users[k].getKey(), users[k].userId);
                }
            }
        });
    }
}

//����û�����ѡ����
function addUserToSelectedArea(node, user) {
    var nodeKey = node.getKey();

    selectedNodeUserMap[currSelectNodeId].users[user.getKey()] = user;//����ѡѡ���û���ӵ���ѡmap��

    if (!$('#node_user_' + nodeKey)[0]) {
        $('#selected_user_table').append(createSelectedNodeHtml(node));
    }
    $('#node_user_' + nodeKey).append(createSelectedUserHtml(node, user));

	setSmsEmailCheckedAllValue('sms');
	setSmsEmailCheckedAllValue('email');
}

//����ѡ����ɾ���û�
function removeUserFromSelectedArea(nodeId, userKey, userId) {

    var node = selectedNodeUserMap[nodeId];
    //ɾ����ѡMap�е����ݺ���ѡ�����html
    if (node.nodeType == 'USERTASK' && node.nodeId == nodeId) {
        $("#"+userKey).remove();//ɾ�û������
        delete node.users[userKey];//�ӽڵ��н��û�ɾ��
        if (getMapLength(node.users) < 1) {//����ڵ����û���Ϊ0����ѽڵ�Ҳɾ����
            $("#tr_"+node.getKey()).remove(); //ɾ��tr
            delete selectedNodeUserMap[nodeId];//��map�н��ڵ�ɾ��
        }
    }

    changeGridRowChecked(nodeId, userId, false); //ȡ���б�ѡ��
	setSmsEmailCheckedAllValue('sms');// �������ȫѡ
	setSmsEmailCheckedAllValue('email');// �����ʼ�ȫѡ
}

function getMapLength(map) {
    var i = 0;
    for (key in map) {
        i++;
    }
    return i;
}

//��֤�ڵ��������Ƿ����û��ڵ�
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
		//û����ѡ��Ա�����޷��鿴
		cui.alert('\u6ca1\u6709\u5df2\u9009\u4eba\u5458\uff0c\u6682\u65e0\u6cd5\u67e5\u770b');
	}
}

function resizeMoreDialog(heightSize){
    cui("#more_div").setSize({width:620, height: heightSize});
}

//�ı��б��¼�Ƿ�ѡ�У��磺1.����ѡ�в������������ڵ�ǰ�ڵ��б���ҲҪ���б�Ĺ�ѡȥ�� 2.�л��ڵ�ʱ���ָ�ѡ��
function changeGridRowChecked(nodeId, userId, isChecked) {
    if (nodeId == currSelectNodeId) {
        cui("#user_list_table").selectRowsByPK(userId, isChecked);
    }
}

//������ѡ�û���divС����
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

//������ѡ�ڵ��tr
function createSelectedNodeHtml(node) {
    var key = node.getKey();
    return '<tr id="tr_'+key+'">' +
        '<td class="selected_node_text"  id="node_name_' + key + '"><span title="'+node.nodeName+'\uff1a">' + node.nodeName+ '\uff1a</span></td>' +
        '<td id="node_user_' + key + '" style="width:600px">' +
        '</td>' +
        '</tr>';
}

//���¶�������
function resizeWidth(){
    return 590;
}

//���Ƿ��Ͷ��Ÿ�ֵ����ѡ�û������sendSMS����
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
    	//�ж��Ƿ񴥷�ȫѡ����ѡ
    	if ($(".selected_users").length > 0 && $("img[src$='"+type+"-cannel.png']").length < 1) {
    		$("#"+type+"_img_all")[0].checked = true;
    	} else {
    		$("#"+type+"_img_all")[0].checked = false;
    	}
    }
}

//���Ƿ����ʼ���ֵ����ѡ�û������sendEmail����
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
    //ȡ������ѡ����ɫ
    $("ul > li").each(function(){
        $(this).removeClass().addClass("li_mouseout");
    });
    $("#li_"+currSelectNodeId).removeClass().addClass("li_mouseover");//ѡ�б�ɫ
}

//���ڵ�li�Ļ���Ч��
function changeClass(id, clazz) {
    $('#li_'+id).removeClass().addClass(clazz);
    //����ýڵ�����ѡ�еģ���Ҫ����������ɫ
    if (id == currSelectNodeId) {
        $("#li_"+currSelectNodeId).removeClass().addClass("li_mouseover");//ѡ�б�ɫ
    }
}

function opinionChange(value) {
    if (1 == value) {
        cui('#opinion').setValue("\u540c\u610f\u3002"+ getOpinionFromOtherPage());
    } else if (0 == value) {
        cui('#opinion').setValue("\u4e0d\u540c\u610f\u3002"+ getOpinionFromOtherPage());
    }
}

//������֯ѡ��ҳ��
function onClickDemo(){
    var obj ={};
    obj.chooseMode = 1; //���ƿ�ѡ����0Ĭ��������
    obj.chooseType = 'org';//������֯ѡ��ҳ��
    obj.callback = 'chooseOrgCallback'; //����ص�����   
    obj.winHeight=410;
    displayUserOrgTag(obj);

    //�������ŵ������ĸ߶�
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

//ѡ����ɺ�ˢ�½ڵ����Ա
// �ص�����������1��selected������2��tagId��selected����Ϊ�ڵ���Ϣ��tagIdΪ��ǰѡ��ı�ǩid
function chooseOrgCallback(selected,tagId) {
    if(undefined != selected[0]){
        //1���ص�����ȡ�ڵ���Ա
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
 * ����ѡ���Ű�ť�Ƿ���ʾ
 * ���� 1.���url�д�����isViewSelectDept���������Ѳ���Ϊ׼��true����ʾ��false����
 *        2.���û�д���isViewSelectDept�������鿴openerҳ���Ƿ񸲸�getViewSelectDeptFlag(nodeInfo)������
 *          �����Է���ֵΪ׼��true����ʾ��false����
 *        3.���ʲô��û�У���Ĭ���Խڵ��Ƿ�����ͬ���û�����Ϊ׼�����hasFilterFunctionΪfalse��ֱ�����أ�
 *          ���hasFilterFunctionΪtrue�����ж�functionInfo�����Ƿ���functionCodeֵΪsameOrganizationUsers
 *          �ĺ�����������ʾ����������
 *        4.�����ť���أ������orgId��ͬ���û����ſ��ֵ����֮��ֵ���й��˺ͽ�ȡ
 */
function controlSelectDeptBtn(isViewSelectDept, nodeInfo) {

    var resultFlag = false;

    if (true == isViewSelectDept || false == isViewSelectDept) { //1. �����жϲ��������ֵ�ж��Ƿ���ʾ
        resultFlag = isViewSelectDept;
    } else if (window.opener.getViewSelectDeptFlag){ //2. ���û�д�����������ݻص�����ֵ�Ƿ���ʾ
        var flag = window.opener.getViewSelectDeptFlag(nodeInfo);
        if (true == flag || false == flag) {
            resultFlag = flag;
        }
    } else { //3. û�в�������Ҳû�лص������ݽڵ�ͬ���û������ж��Ƿ���ʾ
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

    // ���ͨ�������߼��ж�����Ҫ��ʾ����ѡ��ť
    if (true == resultFlag) {
        // �ж��Ƿ��лص������������ֱ�ӵ��ûص���������ȡ����ID�Ͳ�������
        if (window.opener.getNodeFilterDeptParam) {
            var param = window.opener.getNodeFilterDeptParam(nodeInfo);
            orgId = param.sameOrgUserOrgStructureId;
            orgId = (undefined == orgId) ? "" : orgId;
            sameOrgUserDeptPath = param.sameOrgUserDeptPath;
            sameOrgUserDeptPath = (undefined == sameOrgUserDeptPath) ? "" : sameOrgUserDeptPath;
        } else {
            //���û�лص���������ʹ�������������Ĳ���ID�Ͳ�������
            orgId = tempSameOrgUserOrgStructureId;
            sameOrgUserDeptPath = tempSameOrgUserDeptPath;
        }
        cui("#selectedOrgName").setValue(sameOrgUserDeptPath.substr(sameOrgUserDeptPath.indexOf("/")+1));
        $(".deptSelect").show();
    } else {
        // ���ͨ�������߼��ж��˲���ʾ����ѡ��ť���򽫲���ID�Ͳ��������ÿգ����ذ�ť
        orgId = '';
        sameOrgUserDeptPath = '';
        cui("#selectedOrgName").setValue('');
        $(".deptSelect").hide();
    }
    
}