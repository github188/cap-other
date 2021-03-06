/**
 * 注入式Dialog
 * 基于（CUIV4.1 或 CUIV4.2）
 * v0.1.0
 * 技术研究中心 林超群 2014-5-8
 */
;(function($){
    cui.extend = cui.extend || {};

    var _emWin = window.top;

    /**
     * 扩展组件
     * @param options {Object} Dialog组件配置参数
     * @param emWin {Window} 目标窗口
     * @returns {emDialog}
     */
    cui.extend.emDialog = function(options, emWin){
        _emWin = emWin || _emWin;
        //存放Dialog和当前窗口
        _emWin.cuiEMDialog = _emWin.cuiEMDialog || {
            dialogs: {},
            wins: {}
        };
        options = $.extend({
            id: 'emDialog_' + new Date().getTime()
        }, options);

        if(_emWin.cuiEMDialog.dialogs[options.id]){
            return _emWin.cuiEMDialog.dialogs[options.id];
        }

        //创建Dialog，并把相应的Dialog对象和当前窗口对象存放到目标页面变量下
        _emWin.cuiEMDialog.dialogs[options.id] = _emWin.cui.dialog(options);
        _emWin.cuiEMDialog.wins[options.id] = window;


        //返回dialog
        return _emWin.cuiEMDialog.dialogs[options.id];
    };

    //如果主框架cuiEMDialog未定义，或dialogs为空，则表示此window 为 始window
    if(!_emWin.cuiEMDialog || isEmptyObject(_emWin.cuiEMDialog.dialogs)){
    	window._emDialogTopMark = true;
    }

    //页面卸载时，清理本页面所有dialog和win
    $(window).bind('unload.emDialog', function(){
        if(window._emDialogTopMark){
            if(_emWin.cuiEMDialog && _emWin.cuiEMDialog.dialogs){
                for(var i in _emWin.cuiEMDialog.dialogs){
                    if(_emWin && _emWin.cuiEMDialog && _emWin.cuiEMDialog.dialogs){
                        _emWin.cuiEMDialog.dialogs[i].destroy();
                        delete _emWin.cuiEMDialog.dialogs[i];
                        delete _emWin.cuiEMDialog.wins[i];
                    }
                }
            }
        }
    });

    function isEmptyObject( obj ) {
        for ( var name in obj ) {
            return false;
        }
        return true;
    }
})(comtop.cQuery);
	
	//弹出人员标签窗口
	function displayUserOrgTag(obj) {
		   
			var winWidth;//弹出窗宽度
	      	var winHeight;//弹出窗高度
	      	var offsetLeft;//弹出窗位置
	      	var offsetTop;//弹出窗位置
	      	winHeight = obj.winHeight||536;
			if(_getExplorer()=="Chrome"){//谷歌浏览器
				winWidth = obj.chooseMode==1?342:505;
				offsetLeft=300;
				offsetTop=130;
			}else{
				winWidth = obj.chooseMode==1?335:505;
//				winHeight = 530;
				offsetLeft=300;
				offsetTop=250;
			}
		  
		    //参数
			var chooseMode=obj.chooseMode;  //必填
			var chooseType=obj.chooseType;  //必填
			var orgStructureId=obj.orgStructureId;
			var rootId=obj.rootId;
			var defaultOrgId=obj.defaultOrgId;
			var callback=obj.callback;
			var delCallback=obj.delCallback;
			var jsId = obj.id;
			
			//组织参数
			var showLevel=obj.showLevel;
			var showOrder=obj.showOrder;
			var levelFilter=obj.levelFilter;
			var unselectableCode=obj.unselectableCode;
			
			//人员参数
			var userType=obj.userType;
		
			var userOrgParameter="?chooseMode="+obj.chooseMode+"&chooseType="+chooseType;
//			var userPagePath=webPath +"/top/sys/usermanagement/orgusertag/ChooseUserPage.jsp";
			var orgPagePath=webPath +"/top/sys/usermanagement/orgusertag/ChoosePage.jsp"
			
			if(jsId!=null&&jsId!="undefined"){
				userOrgParameter+="&jsId="+jsId;				
			}
			if(orgStructureId!=null&&orgStructureId!="undefined"){
				userOrgParameter+="&orgStructureId="+orgStructureId;
			}
			if(rootId!=null&&rootId!="undefined"){
				userOrgParameter+="&rootId="+rootId;
			}
			if(defaultOrgId!=null&&defaultOrgId!="undefined"){
				userOrgParameter+="&defaultOrgId="+defaultOrgId;
			}
			if(callback!=null&&callback!="undefined"){
				userOrgParameter+="&callback="+callback;
			}
			if(delCallback!=null&&delCallback!="undefined"){
				userOrgParameter+="&delCallback="+delCallback;
			}
			if(showLevel!=null&&showLevel!="undefined"){
				userOrgParameter+="&showLevel="+showLevel;
			}else{
				userOrgParameter+="&showLevel=-1";
			}
			if(showOrder!=null&&showOrder!="undefined"){
				userOrgParameter+="&showOrder="+showOrder;
			}else{
				userOrgParameter+="&showOrder=order";
			}
			if(levelFilter!=null&&levelFilter!="undefined"){
				userOrgParameter+="&levelFilter="+levelFilter;
			}else{
				userOrgParameter+="&levelFilter=999";
			}
			if(unselectableCode!=null&&unselectableCode!="undefined"){
				userOrgParameter+="&unselectableCode="+unselectableCode;
			}
			if(userType!=null&&userType!="undefined"){
				userOrgParameter+="&userType="+userType;
			}else{
				userOrgParameter+="&userType=0";
			}
			//弹出窗口参数定位
			if(obj.left!=null&&obj.left!="undefined"){
				 offsetLeft=obj.left;
			}
			//弹出窗口参数定位
			if(obj.top!=null&&obj.top!="undefined"){
				offsetTop=obj.left;
			}
			
//		  if(obj.chooseType == 'user'){ //弹出人员的界面
//			  window.open(userPagePath+userOrgParameter,"ChooseUserPage","left="+offsetLeft+",top="+offsetTop+",width="+winWidth+",height="+winHeight+",menu=no,toolbar=no,resizable=no,scrollbars=no");
//			}else{ //弹出组织的界面
//			  window.open(orgPagePath+userOrgParameter,"ChoosePage","left="+offsetLeft+",top="+offsetTop+",width="+winWidth+",height="+winHeight+",menu=no,toolbar=no,resizable=no,scrollbars=no");
//			}
			
			var dialogId = "topdialogwithjsopen";
			if(jsId){
				dialogId+=jsId;
			}
			var url = orgPagePath+userOrgParameter;
			var dialog ;
			if(window.top.cuiEMDialog&&window.top.cuiEMDialog.dialogs){
				dialog = window.top.cuiEMDialog.dialogs[dialogId];
			}
			//"选择人员":"选择组织"
			var winTitle =chooseType==='user'?"\u9009\u62e9\u4eba\u5458":"\u9009\u62e9\u7ec4\u7ec7";
			if(chooseMode!=1){
				winWidth = winWidth+30;
			}else{
				winWidth=winWidth-28;
			}
			
			if(!dialog){
    			dialog =cui.extend.emDialog({
    				id:dialogId,
    				title:winTitle,
    				modal:true,
    				src:url,
    				width:winWidth,
    				height:winHeight
    			});
			}else{
				dialog.reload(url);
			}
			dialog.show();
	}
	
	
	//获取浏览器类型
	function _getExplorer() {
		var explorer = window.navigator.userAgent ;
		//ie 浏览器
		if (explorer.indexOf("MSIE") >= 0) {
			return "ie";
		}
		//firefox 火狐浏览器
		else if (explorer.indexOf("Firefox") >= 0) {
			return "Firefox";
		}
		//Chrome 谷歌浏览器
		else if(explorer.indexOf("Chrome") >= 0){
			return "Chrome";
		}
		//Opera 浏览器
		else if(explorer.indexOf("Opera") >= 0){
			return "Opera";
		}
		//Safari
		else if(explorer.indexOf("Safari") >= 0){
			return "Safari";
		}
	}