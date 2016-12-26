	var webRoot = webPath || '/web';
	//返回事件
	function btnBack() {
		var vUrl = "DocTemplateList.jsp";		
		window.location.href = vUrl;
	}

	/**
	 * 界面初始化前处理事件，在执行init方法前调用该方法
	 * 该方法可自行维护，不需要时可删除
	 */
	function myBeforeInit(){
		//TODO 根据需要自行添加逻辑
	}

	/**
	 * 界面初始化后处理事件，在执行init方法后调用该方法
	 * 该方法可自行维护，不需要时可删除
	 */
	function myAfterInit(){
		//TODO 根据需要自行添加逻辑
	}

	/**
	 * 保存前处理事件，在执行btnSave方法前调用该方法
	 * 该方法可自行维护，不需要时可删除
	 * 默认返回true,可继续执行保存。返回为false，不执行保存。
	 */
	function myBeforeSave(){
		//TODO 根据需要自行添加逻辑
		return true;
	}

	/**
	 * 保存后处理事件，在执行btnSave方法后调用该方法
	 * 该方法可自行维护，不需要时可删除
	 */
	function myAfterSave(){
		//TODO 根据需要自行添加逻辑
	}
	

