function validate() {
	//如果结论和意见需要显示
	if (isOpinionDisplay) {
		//1. 我的意见必选
		var opinionRadioValue = cui("#opinionRadioGroup").getValue();
		if (opinionRadioValue != 0 && opinionRadioValue != 1) {
			cui.alert('\u8bf7\u9009\u62e9\u6211\u7684\u610f\u89c1'); //请选择我的意见
			return false;
		}

		if (true == isLimitOpinionValue && (actionType.indexOf('Back') != -1 || actionType.indexOf('back') != -1) && opinionRadioValue != 0) {
			cui.alert('\u56de\u9000\u64cd\u4f5c\u65f6\u5fc5\u987b\u9009\u62e9\u4e0d\u540c\u610f');//回退操作时必须选择不同意
			return false;
		}

		var opinionValue = cui("#opinion").getValue();
		if ((actionType.indexOf('Back') != -1 || actionType.indexOf('back') != -1) && (''==opinionValue || null == opinionValue)) {
			cui.alert('\u56de\u9000\u65f6\u5fc5\u987b\u586b\u610f\u89c1');//回退时必须填意见
			return false;
		}

		//2. 意见必填	
		if (true == isOpinionRequired && (''==opinionValue || null == opinionValue)) {
			cui.alert('\u610f\u89c1\u5fc5\u586b');//意见必填
			return false;
		}
	}

    //3. 如果只填写意见 不需要选人 则不需要校验人员相关信息
	if(!isSelectNodeUser){
		return true;
	}
	
	//4. 不同协同ID下不可同时选择
	var node;
	var cooperationId = '-1';
	for (key in selectedNodeUserMap) {
		node = selectedNodeUserMap[key];
		if (cooperationId != '-1' && cooperationId != node.cooperationId) {
			cui.alert('\u4e0d\u540c\u534f\u540cID\u4e0b\u7684\u8282\u70b9\u4e0d\u53ef\u540c\u65f6\u9009\u62e9');//不同协同ID下的节点不可同时选择
			return false;
		}
		cooperationId = node.cooperationId;
	}

	//5. 人员节点必须选人
	var users;
	if (getMapLength(selectedNodeUserMap) < 1) { //如果没有选择任何节点
		if (isHaveUserNode()) { //如果存在用户节点
			cui.alert('\u8bf7\u9009\u62e9\u5904\u7406\u4eba');//请选择处理人
			return false;
		}
		if (!isHaveUserNode()) {
			cui.alert('\u8bf7\u52fe\u9009\u975e\u4eba\u5458\u8282\u70b9');//请勾选非人员节点
			return false;
		}
	} else { //如果有选择节点
		for (key in selectedNodeUserMap) {
			node = selectedNodeUserMap[key];
			users = node.users;
			if ("USERTASK" == node.nodeType && getMapLength(users) < 1) {
				cui.alert('\u4eba\u5458\u8282\u70b9\u5fc5\u987b\u9009\u4eba');//人员节点必须选人
				return false;
			}
		}
	}
	
	return true;
}