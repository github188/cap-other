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

    cui.extend.emAlert = function(msg, onClose, options){
        _emWin.cui.alert(msg, onClose, options);
    };
    cui.extend.emWarn = function(msg, onClose, options){
        _emWin.cui.warn(msg, onClose, options);
    };
    cui.extend.emSuccess = function(msg, onClose, options){
        _emWin.cui.success(msg, onClose, options);
    };
    cui.extend.emError = function(msg, onClose, options){
        _emWin.cui.error(msg, onClose, options);
    };
    cui.extend.emMessage = function(msg, type, options){
        _emWin.cui.message(msg, type, options);
    };
    cui.extend.emConfirm = function(msg, options){
        _emWin.cui.confirm(msg, options);
    };

    //如果主框架cuiEMDialog未定义，或dialogs为空，则表示此window 为 始window
    if(!_emWin.cuiEMDialog || isEmptyObject(_emWin.cuiEMDialog.dialogs)){
        window._emWinMark = true;
    }

    //页面卸载时，清理本页面所有dialog和win
    $(window).bind('unload.emDialog', function(){
        if(window._emWinMark){
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