/**
 * handleMask
 * @author ????
 */
;(function ($, C) {
    var _$overlay = null;
    var options = {};

    /**
     * ????DOM
     * @private
     */
    function _createDOM(){
        var self = cui.handleMask;
        var $wrap = $('#' + options.id);
        //??????????
        _$overlay = new C.UI.Overlay();
        //????DOM
        if($wrap.length === 0){
            var style = 'z-index:' + (options.zIndex + 1) + ';';
            $('body').append('<div id="' + options.id + '" class="handlemask_wrap" style="' + style + '"></div>');
            $wrap = $('#' + options.id);
        }
        $wrap.html(options.html);
        $wrap.css({
            visibility: 'hidden',
            display: 'block'
        });
        _resetPos();
        $wrap.css({
            visibility: 'visible',
            display: 'none'
        });
    }

    /**
     * ???????¦Ë??
     * @private
     */
    function _resetPos(){
        var $wrap = $('#' + options.id);
        $wrap.css({
            margin: '-' + $wrap.height()/2 + 'px 0 0 -' + $wrap.width()/2 + 'px'
        });
    }

    /**
     * ???
     * @private
     */
    function _removeDom(){
        $('#' + options.id).remove();
        if(options.mask){
            _$overlay.hide(0.5);
        }
        _$overlay._dom.remove();
        _$overlay = undefined;
    }

    /**
     * handleMask???
     * @param {Object} opts
     * @returns {Function|*|Function|Function}
     */
	cui.handleMask = function (opts){
        opts = $.type(opts) === 'object' ? opts : {};
        //??????????
        if($('#' + options.id).length !== 0){
            _removeDom();
        }
        options = $.extend(true, {
            html: '<div class="handlemask_image_1"></div>',
            mask: true,
            zIndex: 9999999,
            id: 'handleMask_' + C.guid()
        }, opts);
        _createDOM();
        return cui.handleMask;
    };

    /**
     * ????????
     * @returns {*}
     */
    cui.handleMask.show = function(){
        //?????????????
        if($('div.handlemask_wrap').length === 0){
            cui.handleMask();
        }
        var $wrap = $('#' + options.id);
        if($wrap.attr('isOpen') !== 'true'){
            if(options.mask){
                _$overlay._dom.css('zIndex', options.zIndex)
                    .attr('id', 'ol_' + options.id);
                _$overlay.show(0.5);
            }
            $wrap.show().attr('isOpen', 'true');
        }
        return cui.handleMask;
    };
    /**
     * ????????
     * @returns {*}
     */
    cui.handleMask.hide = function(){
        //????????????
        if($('div.handlemask_wrap').length === 0){
            return;
        }
        var $wrap = $('#' + options.id);
        $wrap.hide().attr('isOpen', 'false');
        if(options.mask){
            _$overlay.hide(0.5);
        }
        return cui.handleMask;
    };
})(window.comtop.cQuery, window.comtop);