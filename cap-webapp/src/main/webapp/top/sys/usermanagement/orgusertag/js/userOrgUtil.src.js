/**
 * ע��ʽDialog
 * ���ڣ�CUIV4.1 �� CUIV4.2��
 * v0.1.0
 * �����о����� �ֳ�Ⱥ 2014-5-8
 */
;(function($){
    cui.extend = cui.extend || {};

    var _emWin = window.top;

    /**
     * ��չ���
     * @param options {Object} Dialog������ò���
     * @param emWin {Window} Ŀ�괰��
     * @returns {emDialog}
     */
    cui.extend.emDialog = function(options, emWin){
        _emWin = emWin || _emWin;
        //���Dialog�͵�ǰ����
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

        //����Dialog��������Ӧ��Dialog����͵�ǰ���ڶ����ŵ�Ŀ��ҳ�������
        _emWin.cuiEMDialog.dialogs[options.id] = _emWin.cui.dialog(options);
        _emWin.cuiEMDialog.wins[options.id] = window;


        //����dialog
        return _emWin.cuiEMDialog.dialogs[options.id];
    };

    //��������cuiEMDialogδ���壬��dialogsΪ�գ����ʾ��window Ϊ ʼwindow
    if(!_emWin.cuiEMDialog || isEmptyObject(_emWin.cuiEMDialog.dialogs)){
    	window._emDialogTopMark = true;
    }

    //ҳ��ж��ʱ������ҳ������dialog��win
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

/**
 * ��ȡ��Աѡ���ǩ��������ϵ��/��֯ѡ�񵯳����ڵĳߴ�
 * �������ھ�����ʾ
 * @param chooseMode ѡ��ģʽ 1��ѡ ���� ��ѡ
 * @returns {width,height,offsetLeft,offsetTop}
 * */
function getPopWinSize(chooseMode){
	var winWidth;//���������
	var winHeight = 536;//�������߶�
	var offsetLeft,offsetTop;//������λ��
	if(comtop.Browser.notIE){//�ȸ������
		winWidth = chooseMode==1?342:505;
	}else{
		winWidth = chooseMode==1?335:505;
	}
	//��ѡ���ֵ����󣬿������
	var isQM = window.top.comtop.Browser.isQM;
	var isIE = window.top.comtop.Browser.isIE;
	var isLtIE8 = false;
	if(isIE){
		var userAgent = window.top.navigator.userAgent.toLowerCase();
		if(userAgent.indexOf("msie 8.0")==-1&&(userAgent.indexOf("msie 7.0")>-1||userAgent.indexOf("msie 6.0")>-1)){
			isLtIE8 = true;
		}
	}
	if(chooseMode!=1){
		winWidth = winWidth+30;
		if(isIE&&(isQM||isLtIE8)){
			winWidth += 18;
		}
	}else{
		winWidth=winWidth-28;
		if(isIE&&(isQM||isLtIE8)){
			winWidth += 15;
		}
	}
	
	offsetLeft = (window.screen.width-20-winWidth)/2;
	offsetTop = (window.screen.height-30-winHeight)/2;
	return {"width":winWidth,"height":winHeight,"offsetLeft":offsetLeft,"offsetTop":offsetTop};
}

	//������Ա��ǩ����
	function displayUserOrgTag(obj) {
		   var winSize = getPopWinSize(obj.chooseMode);
		    //����
			var chooseMode=obj.chooseMode;  //����
			var chooseType=obj.chooseType;  //����
			var orgStructureId=obj.orgStructureId;
			var rootId=obj.rootId;
			var defaultOrgId=obj.defaultOrgId;
			var callback=obj.callback;
			var delCallback=obj.delCallback;
			var jsId = obj.id;
			
			//��֯����
			var showLevel=obj.showLevel;
			var showOrder=obj.showOrder;
			var levelFilter=obj.levelFilter;
			var unselectableCode=obj.unselectableCode;
			var winType = obj.winType;
			//��Ա����
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
			if(!winType||winType==="undefined"){
				winType="dialog";
			}
			userOrgParameter+="&winType="+winType;
			//�������ڲ�����λ
			if(obj.left!=null&&obj.left!="undefined"){
				winSize.offsetLeft=obj.left;
			}
			//�������ڲ�����λ
			if(obj.top!=null&&obj.top!="undefined"){
				winSize.offsetTop=obj.left;
			}
			
			var url = orgPagePath+userOrgParameter;
			//"ѡ����Ա":"ѡ����֯"
			var winTitle =chooseType==='user'?"\u9009\u62e9\u4eba\u5458":"\u9009\u62e9\u7ec4\u7ec7";
			if(winType==="window"){
				window.open(url,"ChoosePage","left="+winSize.offsetLeft+",top="+winSize.offsetTop+",width="+winSize.width+",height="+winSize.height+",menu=no,toolbar=no,resizable=no,scrollbars=no");
			}else{
				var dialogId = "topdialogwithjsopen";
				if(jsId){
					dialogId+=jsId;
				}
				var dialog ;
				if(window.top.cuiEMDialog&&window.top.cuiEMDialog.dialogs){
					dialog = window.top.cuiEMDialog.dialogs[dialogId];
				}
				if(!dialog){
					dialog =cui.extend.emDialog({
						id:dialogId,
						title:winTitle,
						modal:true,
						src:url,
						width:winSize.width,
						height:winSize.height
					});
				}else{
					dialog.reload(url);
				}
				dialog.show();
			}
	}
