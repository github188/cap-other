	function itemGridOneClick(){
		oneClick('itemGrid');
	}
	function itemGridAllClick(){
		allClick('itemGrid');
	}
	//按钮单选
	function oneClick(gridId){
		var indexs =  cui("#" + gridId).getSelectedIndex();
		var gridData = cui("#" + gridId).getData();
		if(indexs.length == 0){ //全不选-不能上移下移置顶置底
			setButtonIsDisable(gridId,true,true,true,true);
		}else{
			if(isContinue(indexs)){ // 是连续的-可上移下移
				if(indexs[0] == 0 && indexs[indexs.length-1] != gridData.length-1){ //包含了第一条记录只能下移、置底
					setButtonIsDisable(gridId,true,false,true,false);
				}else if(indexs[indexs.length-1] == gridData.length-1 && indexs[0] != 0 ){ //包含了最后一条记录只能上移、置顶
					setButtonIsDisable(gridId,false,true,false,true);
				}else if(indexs[0] == 0  && indexs[indexs.length-1] == gridData.length-1 ){//不能上移下移置顶置底
					setButtonIsDisable(gridId,true,true,true,true);
				}else{ //可上移下移置顶置底
				   setButtonIsDisable(gridId,false,false,false,false);
				}
			}else{ // 不是连续的
				setButtonIsDisable(gridId,true,true,true,true);
			}
		}
	}
	//按钮全选
	function allClick(gridId){
		setButtonIsDisable(gridId,true,true,true,true);
	}
	
	//设置grid的置灰显示
	function setButtonIsDisable(gridId,up,down,top,bottom){
		cui("#" + gridId + "UpButton").disable(up);
		cui("#" + gridId + "DownButton").disable(down);
		cui("#" + gridId + "TopButton").disable(top);
		cui("#" + gridId + "BottomButton").disable(bottom);
	}
	
	//editgrid上移下移，置顶，置底js
	//按钮区域
	function upItem(event, self, mark){
		up(mark);
	}
	function downItem(event, self, mark){
		down(mark);
	}
	function topItem(event, self, mark){
		myTop(mark);
	}
	function bottomItem(event, self, mark){
		bottom(mark);
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
			
			var temp = currentData.sortNo;
			currentData.sortNo = frontData.sortNo;
			frontData.sortNo = temp;
			
			cui("#" + gridId).changeData(currentData, indexs[i] - 1,true,true);
			cui("#" + gridId).changeData(frontData,indexs[i],true,true);
			cui("#" + gridId).selectRowsByIndex(indexs[i] -1, true);
			cui("#" + gridId).selectRowsByIndex(indexs[i], false);
		}
		var allData= cui("#" + gridId).getData();
		dwr.TOPEngine.setAsync(false);
		BizItemsAction.updateItemList(allData);
		dwr.TOPEngine.setAsync(true);
		cui("#" + gridId).loadData();
		for(var i=0;i<indexs.length;i++){
			cui("#" + gridId).selectRowsByIndex(indexs[i] -1, true);
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
			
			var temp = currentData.sortNo;
			currentData.sortNo = nextData.sortNo;
			nextData.sortNo = temp;
			
			cui("#" + gridId).changeData(currentData, indexs[i] + 1,true,true);
			cui("#" + gridId).changeData(nextData, indexs[i],true,true);
			cui("#" + gridId).selectRowsByIndex(indexs[i], false);
			cui("#" + gridId).selectRowsByIndex(indexs[i] + 1, true);
		}
		var allData= cui("#" + gridId).getData();
		dwr.TOPEngine.setAsync(false);
		BizItemsAction.updateItemList(allData);
		dwr.TOPEngine.setAsync(true);
		cui("#" + gridId).loadData();
		for(var i=indexs.length-1;i>=0;i--){
			cui("#" + gridId).selectRowsByIndex(indexs[i]+1, true);
		}
		//判断按钮是否置灰
		oneClick(gridId);
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
	
	function BizFlowGridOneClick(){
		oneClick('BizFlowGrid');
	}
	function BizFlowGridAllClick(){
		allClick('BizFlowGrid');
	}
	
	//置顶
	function myTop(gridId){
		var datas = cui("#" + gridId).getData();
		for(var i=0;i<(datas.length-1);i++){
			up(gridId);
		}
		//判断按钮是否置灰
		oneClick(gridId);
	}
	
	//置底
	function bottom(gridId){
		var datas = cui("#" + gridId).getData();
		for(var i=0;i<(datas.length-1);i++){
			down(gridId);
		}
			//判断按钮是否置灰
		oneClick(gridId);
	}