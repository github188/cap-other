   	
  //去左右空格;
 	function trim(str){
 	    return str.replace(/(^\s*)|(\s*$)/g, "");
 	}
 	
  //按钮隐藏控制、 页面只读控制
	function pageStausSet(editType){
		if(editType === "read"){
				buttonCanSave(false);
				comtop.UI.scan.setReadonly(true);
				cui('.top_required').hide();
				cui("#formChartId").hide();
				cui("#formChartName").show();
				if(formInfo.attachmentId){
					dwr.TOPEngine.setAsync(false);
					FileLoaderAction.getFileNames("BIZ_PROCESS_INFO",formInfo.attachmentId,function(data){
		   				if(data){
		   					cui("#formChartName").setValue(data);
		   				}
		   			});
		   			dwr.TOPEngine.setAsync(true);
				}
				cui("#formChartName").setReadonly(true);
			}else{
				buttonCanSave(true);
				comtop.UI.scan.setReadonly(false);
				cui("#belongDomain").setReadonly(true);
				cui("#code").setReadonly(true);
				cui('.top_required').show();
				cui("#formChartId").show();
				cui("#formChartName").hide();
			}
	}
	
	//编辑区域按钮控制
	function buttonCanSave(flag){
		if(flag){
			cui("#btnEdit").hide();
			cui("#btnSave").show();
			cui("#btnCancel").show();
			cui("#addRow").show();
			cui("#deleteRow").show();
			
		}else{
			cui("#btnEdit").show();
			cui("#btnSave").hide();
			cui("#btnCancel").hide();
			cui("#addRow").hide();
			cui("#deleteRow").hide();
		}
	}
	
	//编辑grid编辑列属性设置 
	formDataEditType = {
		    "name" : {
		    	uitype: "Input",
				maxlength: 200,
		        validate:formDataName
		    },
		    "type" : {
		    	uitype: "PullDown",
				mode: "Single",
				datasource:formDataType
		    },
		    "unit" : {
		    	uitype: "Input",
				maxlength: 64
		    },
		    "requried" : {
		    	uitype: "RadioGroup",
		        radio_list: [
		            {value: "0", text: "否"},
		            {value: "1", text: "是"}
		        ]
		    },
		    "description" : {
		    	uitype: "Input",
				maxlength: 256
		    }
		};
	
	//检查可编辑列编辑条件
	function formDataeditbefore(rowData, bindName){
		if (bindName == "name") {
			if(editType=="read"){
				return false;
			}
			else{
				return {             
					uitype: "Input",
					maxlength: 200,
			        validate:formDataName
					}
			}
		}
		if (bindName == "type") {
			if(editType=="read"){
				return false;
			}
			else{
				return {             
					uitype: "PullDown",
					mode: "Single",
					datasource:formDataType
					}
			}
		}
		if (bindName == "unit") {
			if(editType=="read"){
				return false;
			}
			else{
				return {             
					uitype: "Input",
					maxlength: 64,
					}
			}
		}
		if (bindName == "requried") {
			if(editType=="read"){
				return false;
			}
			else{
				return {             
					uitype: "RadioGroup",
			        radio_list: [
			            {value: "0", text: "否"},
			            {value: "1", text: "是"}
			        ]
					}
			}
		}
		if (bindName == "description") {
			if(editType=="read"){
				return false;
			}
			else{
				return {             
					uitype: "Input",
					maxlength: 256
					}
			}
		}
	}
	
	//获得数据的最大的排序号 供添加新行初始化sort字段使用
	function getMaxsort(rowDatas){
		var max = 0;
		if(!rowDatas || rowDatas.length == 0){
			return max;
		}
		for(var i=0; i < rowDatas.length; i++){
			if(!rowDatas[i].sortNo){
				continue;
			}
			if(rowDatas[i].sortNo > max){
				max = rowDatas[i].sortNo;
			}
		}
		return max;
	}