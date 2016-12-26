	
  	//检查业务域编码是否重复 
   	function checkCode(){
   		domainVO=cui(domainInfo).databind().getValue();
   		domainVO.code=trim(domainVO.code);
   		var isRepeat=0;
   		dwr.TOPEngine.setAsync(false);
		BizDomainAction.checkDomainCode(domainVO,function(data){
			isRepeat=data;
		});
		dwr.TOPEngine.setAsync(true);
		if(isRepeat>0){
			return false;
		}
   		return true;
   	}
	
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
   		}else{
   			buttonCanSave(true);
   			comtop.UI.scan.setReadonly(false);
   			cui("#parentName").setReadonly(true);
   			cui("#code").setReadonly(true);
   			cui('.top_required').show();
   		}
	}
	
	//编辑区域按钮控制
	function buttonCanSave(flag){
		if(flag){
			cui("#btnEdit").hide();
			if(selectDomainId){
				cui("#btnMove").show();
			}
			else{
				cui("#btnMove").hide();
			}
			cui("#btnSave").show();
			cui("#btnCancel").show();
			cui("#addRole").show();
			cui("#deleteRole").show();
			
		}else{
			cui("#btnEdit").show();
			cui("#btnMove").hide();
			cui("#btnSave").hide();
			cui("#btnCancel").hide();
			cui("#addRole").hide();
			cui("#deleteRole").hide();
		}
	}
	
	//排序业务域
	function sortDomian(domainList){
		if(domainList.length>1){
			var temp;
			for(var i=0;i<domainList.length-1;i++){
				for(var j=i+1;j<domainList.length;j++){
					if(domainList[i].sortNo>domainList[j].sortNo){
						temp=domainList[i];
						domainList[i]=domainList[j];
						domainList[j]=temp;
					}
				}
			}
		}
		return domainList;
	}