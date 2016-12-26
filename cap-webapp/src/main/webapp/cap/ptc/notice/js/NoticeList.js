	function edit(id){
    	var rd = cui("#CapPtcNoticeGrid").getRowsDataByPK(id)[0];
    	var url = "NoticeEdit.jsp?CapPtcNoticeId="+rd.id;
    	if(rd.taskId){
    		url += "&taskId="+rd.taskId;
    	}
    	if(rd.processInsId){
    		url += "&processInsId="+rd.processInsId;
    	}
    	if(rd.flowState){
    		url += "&flowState="+rd.flowState;
    	}
    	window.open(url);  
    }
    
    function view(id){
    	var rd = cui("#CapPtcNoticeGrid").getRowsDataByPK(id)[0];
    	var url = "NoticeEdit.jsp?CapPtcNoticeId="+rd.id+"&readOnly=true";
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
		var url = "NoticeEdit.jsp";
		window.open(url); 		
	}
	
