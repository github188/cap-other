/**
 * ע��ʽDialog
 * ���ڣ�CUIV4.1 �� CUIV4.2��
 * v0.1.0
 * �����о����� �ֳ�Ⱥ 2014-5-8
 */
;(function($){
    cui.extend = cui.extend || {};

    var _emWin = window.top,
        _ids = [];

    //���Dialog�͵�ǰ����
    _emWin.cuiEMDialog = {
        dialogs: {},
        wins: {}
    };

    /**
     * ��չ���
     * @param options {Object} Dialog������ò���
     * @param emWin {Window} Ŀ�괰��
     * @returns {emDialog}
     */
    cui.extend.emDialog = function(options, emWin){
        options = $.extend({
            id: 'emDialog_' + new Date().getTime()
        }, options);

        if(_emWin.cuiEMDialog.dialogs[options.id]){
            return _emWin.cuiEMDialog.dialogs[options.id];
        }

        //Ŀ�괰��
        _emWin = emWin || _emWin;

        //����Dialog��������Ӧ��Dialog����͵�ǰ���ڶ����ŵ�Ŀ��ҳ�������
        _emWin.cuiEMDialog.dialogs[options.id] = _emWin.cui.dialog(options);
        _emWin.cuiEMDialog.wins[options.id] = window;

        //���ID
        _ids.push(options.id);

        //����dialog
        return _emWin.cuiEMDialog.dialogs[options.id];
    };

    //ҳ��ж��ʱ������ҳ������dialog��win
    $(window).bind('unload.emDialog', function(){
        for(var i = 0; i < _ids.length; i ++){
            _emWin.cuiEMDialog.dialogs[_ids[i]].destroy();
            delete _emWin.cuiEMDialog.dialogs[_ids[i]];
            delete _emWin.cuiEMDialog.wins[_ids[i]];
        }
    });
})(comtop.cQuery);