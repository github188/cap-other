	function edit(id){
    	var rd = cui("#CapDocTemplateGrid").getRowsDataByPK(id)[0];
    	var url = "DocTemplateEdit.jsp?CapDocTemplateId="+rd.id;
    	if(rd.taskId){
    		url += "&taskId="+rd.taskId;
    	}
    	if(rd.processInsId){
    		url += "&processInsId="+rd.processInsId;
    	}
    	if(rd.flowState){
    		url += "&flowState="+rd.flowState;
    	}
		window.location.href = url;  
    }
    
    function view(id){
    	var rd = cui("#CapDocTemplateGrid").getRowsDataByPK(id)[0];
    	var url = "DocTemplateEdit.jsp?CapDocTemplateId="+rd.id+"&readOnly=true";
    	if(rd.taskId){
    		url += "&taskId="+rd.taskId;
    	}
    	if(rd.processInsId){
    		url += "&processInsId="+rd.processInsId;
    	}
    	if(rd.flowState){
    		url += "&flowState="+rd.flowState;
    	}
		window.location.href = url;  
    }
    
    function imgRender(data,index,col){
		return  "<img src='"+webPath+"/cap/bm/page/designer/images/add.gif' onclick='click();'/>";
    }
    
    
	//新增事件
	function btnAdd(){
		var url = "DocTemplateEdit.jsp";
		window.location.href = url; 		
	}
	
	/**
	 * 列表初始化前处理事件，在执行列表的initData方法前调用该方法
	 * 该方法可自行维护，不需要时可删除
	 */
	function myBeforeInitData(tableObj,query){
		//TODO 根据需要自行添加逻辑
	}

	/**
	 * 列表初始化后处理事件，在执行列表的initData方法后调用该方法
	 * 该方法可自行维护，不需要时可删除
	 */
	function myAfterInitData(tableObj,query){
		//TODO 根据需要自行添加逻辑
	}

	/**
	 * 删除前处理事件，在执行btnDelete方法前调用该方法
	 * 该方法可自行维护，不需要时可删除
	 * 默认返回true,可继续执行删除。返回为false，不执行删除。
	 */
	function myBeforeDelete(){
		//TODO 根据需要自行添加逻辑
		return true;
	}

	/**
	 * 删除后处理事件，在执行btnDelete方法后调用该方法
	 * 该方法可自行维护，不需要时可删除
	 */
	function myAfterDelete(){
		//TODO 根据需要自行添加逻辑
	}
	
