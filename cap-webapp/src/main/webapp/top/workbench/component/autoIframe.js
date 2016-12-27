/**
 * iframe????????
 */
define([], function() {
    //??????§Ø?
    var browser = {
        isLtIE8:'\v'=='v'
    };
    $.fn.autoFrameHeight = function(url, getMinHeight) {
        var $frames = $(this);
        if($frames.length ==1){
            _setMinHeight($frames.eq(0), getMinHeight);
        }
        $frames.each(function(index, b) {
            var $t = $(b);
            url = $t.data('url') || url;
            $t.load(function() {
                //console.log('load');
                //????????????????????Ú…iframe???
                _setMinHeight($t,getMinHeight);
                _setHeightTimeout($t);
                //??????
                if(!browser.isLtIE8){
                    $t[0].contentWindow.addEventListener('DOMSubtreeModified', function() {
                        //console.log('DOMSubtreeModified');
                        _setHeightTimeout($t);
                    });
                    if(getMinHeight){
                        //??????????????éí?????????????§³???,????????????????
                        $t[0].contentWindow.addEventListener("unload", function() {
                            //console.log('unload');
                            _setMinHeight($t, getMinHeight);
                        });
                    }
                }else {
                    //ie??????????????
                    $t[0].contentWindow.focus();
                    //?????IE8????????§³??????iframe????resize
                    $t.css('height', '1px');
                    $t[0].contentWindow.attachEvent("onresize", function() {
                        //console.log('onresize');
                        _setMinHeight($t,getMinHeight);
                        _setHeightTimeout($t);
                        
                    });
                    if(getMinHeight){
                        //??????????????éí?????????????§³???,????????????????
                        $t[0].contentWindow.attachEvent("onunload", function() {
                            //console.log('onunload');
                            _setMinHeight($t, getMinHeight);
                        });
                    }
                }
            });
            if (url) {
                $t[0].src = Workbench.formatUrl(url);
            }
        });
        //??ie????????????resize???
        //???iframe?????§³???,?????????????
        if (document.addEventListener) {
            $(window).resize(function() {
                //console.log('resize');
                $frames.each(function(index, b) {
                    var $this = $(this);
                    _setMinHeight($this, getMinHeight);
                    _setHeightTimeout($this);
                });
            });
        }
    };
    /**
     *??????,????????????????? 
     */
    function _setHeightTimeout($t) {
        var executeTimeout = $t.data('timeout');
        if (executeTimeout) {
            window.clearTimeout(executeTimeout);
        }
        $t.data('timeout',window.setTimeout(function() {
            $t.data('timeout',null);
            _setHeight($t);
        }, 50));
    }
    /**
     *????iframe?????,?????????????? 
     */
    function _setHeight($t,getMinHeight) {
        var frame = $t[0];
        //??????????????
        try{
            if (!frame.contentWindow || !frame.contentWindow.document || !frame.contentWindow.document.documentElement || !frame.contentWindow.document.body) {
                return;
            }
        }catch(e){
            return;
        }
        var frameDoc = frame.contentWindow.document;
        //var docScrollHeight = $t.data('docScrollHeight');
        //var bodyScrollHeight = $t.data('bodyScrollHeight');
        //console.log('documentElement:' + frameDoc.documentElement.scrollHeight + ',body:' + frameDoc.body.scrollHeight + ',iframe:' + $t.height());
        //??›Ì?????????????????????§Ø?,????????
        //if(frameDoc.body.scrollHeight == bodyScrollHeight 
        //    && frameDoc.documentElement.scrollHeight == docScrollHeight ){
            ////console.log('return');
        //}
        //??iframe??????0???éíiframe?????????,???iframe???????????
        //$t.parent().height($t.parent().height());
        //??????iframe?????????????éíiframe?????????0????iframe??document??????auto,??????????????????????
        //frame.style.height = '20px';
        var height = frameDoc.documentElement.scrollHeight;
        //???????????????????§Ú?????20px,?????????????????
        //if (hasXScrollBar(frameDoc)) {
        //    height += scrollbarSize;
        //}
        //console.log('height:' + height );
        //height = height < minHeight?minHeight:height;
        if(height==$t.height()){
            return;
        }
        frame.style.height = height + 'px';
        //$t.data('bodyScrollHeight',frameDoc.body.scrollHeight);
        //$t.data('docScrollHeight',frameDoc.documentElement.scrollHeight);
        //$t.parent().height('auto');
    }
    
    /**
     *?§Ø??????????????? 
     */
    function hasXScrollBar(frameDoc){
        return frameDoc.body.scrollHeight != 0 && frameDoc.documentElement.clientWidth!=0 && frameDoc.documentElement.scrollWidth > frameDoc.documentElement.clientWidth;
    }
    /**
     *????????????
     */
    var scrollbarSize = _getScrollbarSize() || 20;
    function _getScrollbarSize() {
        var dv = document.createElement('div');
        dv.style.overflow = "scroll";
        dv.style.position = 'absolute';
        dv.style.left = '-1000px';
        dv.style.top = '-1000px';
        dv.style.width = "100px";
        dv.style.height = "100px";
        document.body.appendChild(dv);
        var bar_size = 100 - dv.clientWidth;
        document.body.removeChild(dv);
        return bar_size;
    }

    /**
     *ie?????body???margin??padding 
     * @param {Object} body
     */
    function _getBodyHeight(body) {
        var height = body.scrollHeight;
        if (body.currentStyle) {
            var currentStyle = body.currentStyle;
            var margin = _getIntOfStyle(currentStyle.marginTop) + _getIntOfStyle(currentStyle.marginBottom);
            var padding = _getIntOfStyle(currentStyle.paddingTop) + _getIntOfStyle(currentStyle.paddingBottom);
            if(margin){
                height += margin ;
            }
            if(padding){
                height += padding;
            }
        }
        return height;
    }
    /**
     * ????????int?
     * @param {Object} style
     */
    function _getIntOfStyle(style) {
        style = style.replace('px','');
        return parseInt(style);
    }
    /**
     * ????iframe??§³???
     * @param {Object} $t
     * @param {Object} getMinHeight
     */
    function _setMinHeight($t, getMinHeight) {
        if(!getMinHeight){
            return;
        }
        var minHeight = null;
        if ( typeof getMinHeight == 'function') {
            minHeight = getMinHeight();
        } else if ( typeof getMinHeight == 'number' || typeof getMinHeight == 'string') {
            minHeight = getMinHeight;
        }
        if (!minHeight) {
            minHeight = 'auto';
        }
        if(!browser.isLtIE8){//ie????????????
            $t.height(minHeight);
        }
        $t.setMinHeight(minHeight);
        //console.log('minHeight:' + minHeight );
    }

});