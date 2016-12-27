/**
 * 注入式Dialog
 * 基于（CUIV4.1 或 CUIV4.2）
 * v0.1.0
 * 技术研究中心 林超群 2014-5-8
 */
;(function($){
    cui.extend = cui.extend || {};

    var _emWin = window.top,
        _ids = [];

    //存放Dialog和当前窗口
    _emWin.cuiEMDialog = {
        dialogs: {},
        wins: {}
    };

    /**
     * 扩展组件
     * @param options {Object} Dialog组件配置参数
     * @param emWin {Window} 目标窗口
     * @returns {emDialog}
     */
    cui.extend.emDialog = function(options, emWin){
        options = $.extend({
            id: 'emDialog_' + new Date().getTime()
        }, options);

        if(_emWin.cuiEMDialog.dialogs[options.id]){
            return _emWin.cuiEMDialog.dialogs[options.id];
        }

        //目标窗口
        _emWin = emWin || _emWin;

        //创建Dialog，并把相应的Dialog对象和当前窗口对象存放到目标页面变量下
        _emWin.cuiEMDialog.dialogs[options.id] = _emWin.cui.dialog(options);
        _emWin.cuiEMDialog.wins[options.id] = window;

        //添加ID
        _ids.push(options.id);

        //返回dialog
        return _emWin.cuiEMDialog.dialogs[options.id];
    };

    //页面卸载时，清理本页面所有dialog和win
    $(window).bind('unload.emDialog', function(){
        for(var i = 0; i < _ids.length; i ++){
            _emWin.cuiEMDialog.dialogs[_ids[i]].destroy();
            delete _emWin.cuiEMDialog.dialogs[_ids[i]];
            delete _emWin.cuiEMDialog.wins[_ids[i]];
        }
    });
})(comtop.cQuery);