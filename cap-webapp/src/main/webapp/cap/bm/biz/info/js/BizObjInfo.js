	var webRoot = webPath || '/web';
	//返回事件
	function btnBack() {
		var vUrl = "BizObjInfoList.jsp";		
		window.location.href = vUrl;
	}

	//按钮全选
	function allClick(gridId){
		setButtonIsDisable(gridId,true,true,true,true);
	}
    
	//选择业务域
	function chooseDomain(){
		var url = "../domain/jsp/DomainTree.jsp";
		var title="业务域选择";
		var height = 500;
		var width = 350;
		
		dialog = cui.dialog({
			id:"selectDomainPage",
			title : title,
			src : url,
			width : width,
			height : height
		});
		dialog.show(url);
	}
	/**初始化业务对象*/
	function initDomainData(domainId){
		dwr.TOPEngine.setAsync(false);
		BizDomainAction.queryDomainById(domainId,function(data){
			if(data && data!=null){
				chooseDomainCallback(domainId,data.name);
			}else{
				chooseDomainCallback(domainId,"");
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//选择业务域-回调方法
	function chooseDomainCallback(key,title){
		BizObjInfo.domainId=key;
		cui('#domainName').setValue(title);	
		search();
	}
	
	
	function edit(id){
    	var rd = cui("#BizObjInfoGrid").getRowsDataByPK(id)[0];
    	var url = "BizObjInfoEdit.jsp?BizObjInfoId="+rd.id;
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
    	var rd = cui("#BizObjInfoGrid").getRowsDataByPK(id)[0];
    	var url = "BizObjInfoEdit.jsp?BizObjInfoId="+rd.id+"&readOnly=true";
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
		var url = "BizObjInfoEdit.jsp";
		window.location.href = url; 		
	}
	
	//判断数组是否是连续数组
	function isContinue(array){
		var len=array.length;
		var n0=array[0];
		var sortDirection=1;//默认升序
		if(array[0]>array[len-1]){
		        //降序
				sortDirection=-1;
		}
		if((n0*1+(len-1)*sortDirection) !== array[len-1]){
		        return false;
		}
		var isContinuation=true;
			for(var i=0;i<len;i++){
		        if(array[i] !== (i+n0*sortDirection)){
		            isContinuation=false;
		            break;
				}
			 }
			return isContinuation;
	}
	
	
	//上移
	function up(gridId){
		var indexs =  cui("#" + gridId).getSelectedIndex();
		var index = indexs[0];
		if(index == 0){
			return;
		}
		for(var i=0;i<indexs.length;i++){
			var datas = cui("#" + gridId).getData();
			var currentData   = datas[indexs[i]];
			var  frontData = datas[indexs[i]-1];
			
			var temp = currentData.sortNO;
			currentData.sortNO = frontData.sortNO;
			frontData.sortNO = temp;
			
			if(currentData.areaItemId && !frontData.areaItemId){
				frontData.areaItemId = currentData.areaItemId;
				frontData.areaId = currentData.areaId;
				delete currentData.areaItemId;
				delete currentData.areaId;
			}
			if(!currentData.areaItemId && frontData.areaItemId){
				currentData.areaItemId = frontData.areaItemId;
				currentData.areaId = frontData.areaId;
				delete frontData.areaItemId;
				delete frontData.areaId;
			}
			
			cui("#" + gridId).changeData(currentData, indexs[i] - 1,true,true);
			cui("#" + gridId).changeData(frontData,indexs[i],true,true);
			cui("#" + gridId).selectRowsByIndex(indexs[i] -1, true);
			cui("#" + gridId).selectRowsByIndex(indexs[i], false);
		}
		//判断按钮是否置灰
		oneClick(gridId);
	}
	
	//下移
	function down(gridId){
		var indexs =  cui("#" + gridId).getSelectedIndex();
		var index = indexs[indexs.length-1];
		var datas = cui("#" + gridId).getData();
		if(index === datas.length - 1){
			return;
		}
		for(var i=indexs.length-1;i>=0;i--){
			var datas = cui("#" + gridId).getData();
			var currentData = datas[indexs[i]];
			var nextData = datas[indexs[i] + 1];
			
			var temp = currentData.sortNO;
			currentData.sortNO = nextData.sortNO;
			nextData.sortNO = temp;
			
			if(currentData.areaItemId && !nextData.areaItemId){
				nextData.areaItemId = currentData.areaItemId;
				nextData.areaId = currentData.areaId;
				delete currentData.areaItemId;
				delete currentData.areaId;
			}
			
			if(!currentData.areaItemId && nextData.areaItemId){
				currentData.areaItemId = nextData.areaItemId;
				currentData.areaId = nextData.areaId;
				delete nextData.areaItemId;
				delete nextData.areaId;
			}
			
			cui("#" + gridId).changeData(currentData, indexs[i] + 1,true,true);
			cui("#" + gridId).changeData(nextData, indexs[i],true,true);
			cui("#" + gridId).selectRowsByIndex(indexs[i], false);
			cui("#" + gridId).selectRowsByIndex(indexs[i] + 1, true);
		}
		//判断按钮是否置灰
		oneClick(gridId);
	}
	
	//置顶
	function myTop(gridId){
		var indexs =  cui("#" + gridId).getSelectedIndex();
		var datas = cui("#" + gridId).getData();
		var firstSortNo = datas[0].sortNO;
		var largeIndex = indexs[indexs.length-1];
		for(var i=indexs.length-1;i>=0;i--){
			firstSortNo--;
			var datas = cui("#" + gridId).getData();
			var currentData = datas[largeIndex];
			currentData.sortNO = firstSortNo;
			
			if(currentData.areaItemId){
				delete currentData.areaItemId;
				delete currentData.areaId;
			}
			//咨询CUI，没提供move方法，先采用先删后增
			cui("#" + gridId).deleteRowByIndex(largeIndex);
			cui("#" + gridId).insertRow(currentData,0);
			cui("#" + gridId).selectRowsByIndex(0, true);
		}
		//判断按钮是否置灰
		oneClick(gridId);
	}
	
	//置底
	function bottom(gridId){
		var indexs =  cui("#" + gridId).getSelectedIndex();
		var datas = cui("#" + gridId).getData();
		var lastSortNo = datas[datas.length-1].sortNO;
		var minIndex = indexs[0];
		for(var i=0;i<indexs.length;i++){
			lastSortNo++;
			var datas = cui("#" + gridId).getData();
			var currentData = datas[minIndex];
			currentData.sortNO = lastSortNo;
			
			if(currentData.areaItemId){
				delete currentData.areaItemId;
				delete currentData.areaId;
			}
			//咨询CUI，没提供move方法，先采用先删后增
			cui("#" + gridId).deleteRowByIndex(minIndex);
			cui("#" + gridId).insertRow(currentData,datas.length-1);
			cui("#" + gridId).selectRowsByIndex(datas.length-1, true);
		}
		//判断按钮是否置灰
		oneClick(gridId);
	}

