/**
 * iframe自适应高度
 */
define([], function() {
    //浏览器判断
    var browser = {
        isIE:!!window.ActiveXObject || "ActiveXObject" in window,
        ieIE9:(!!window.ActiveXObject || "ActiveXObject" in window) && navigator.appVersion.split(";")[1].replace(/[ ]/g,"")=="MSIE9.0"
    };
    
    $.fn.autoFrameHeight = function(url, getMinHeight) {
        var $window = $(window),$iframe = $(this).eq(0),iframe = $iframe[0],$parent = $iframe.parent(),intervalTime,timeoutResize,iframeDoc,isLoading=false;
        
        _setMinHeight();
        
        if(!browser.isIE){
            //为了能够手动触发调整页面高度
            $window.resize(_setMinHeight);
        }else{
            $window.on('resize',function(){
                //ie在计算高度前会先触发resize事件,所以isLoading=true时,中断resize执行
                if(!isLoading)_setMinHeight();
            });
        }
        $iframe.load(function(){
            //还原设置,数据
            resetData();
            iframeDoc = iframe.contentWindow.document;
            //是否需要重置大小
            if (iframe.contentWindow.not_resize!==true) {
                isLoading = true;
                //设置内部样式禁用滚动,防止页面闪烁
                iframeDoc.body.style['overflow-y'] = 'hidden';
                //设置轮询
                intervalTime = window.setInterval(function(){
                    isLoading = false;
                    _setHeight();
                    //校验是否死循环
                    validateLoopResize();
                },800);
                //当重新加载页面时需将原有页面高度还原为最小高度,防止页面撑开后无法收回
                $(iframe.contentWindow).on('unload',function(){
                    clearInterval(intervalTime);
                    _setMinHeight(true);
                });
                //ie8先设置为10px高度,然后再计算出实际页面高度
                if(browser.isIE&&iframeDoc.compatMode=="CSS1Compat"){
//                    iframe.style.cssText = 'height:1px;min-height:1px;';
                    //console.log('页面初始化高度:'+ iframeDoc.documentElement.scrollHeight);
                    //设置高度
                    _setHeight();
                    _setMinHeight();
                }
            }
        });
        
        var  url = $iframe.data('url') || url;
        if (url) {
            iframe.src = Workbench.formatUrl(url);
        }
        
        function resetData(){
            $iframe.data('body.scrollHeight',null);
            $iframe.data('document.scrollHeight',null);
            $iframe.data('increase-height',null);
            //清除轮询
            clearInterval(intervalTime);
        }
        /**
         *设置iframe实际高度,高度由内容自适应 
         */
        function _setHeight() {
            //是否需要重置大小
            if (iframe.contentWindow.not_resize===true) {
                return;
            }
            var iframeDocHeight = getDocumentHeight(true);
            //出现横向滚动条时需在原有高度上加20px,因为滚动条不计算高度,在ie9下有问题,所以注释掉
            if (hasXScrollBar(iframeDoc)&&!browser.isIE9) {
                iframeDocHeight += scrollbarSize;
            }
            var iframeHeight = $iframe.height();
            //如果发现存在有规律的高度增长,判定为非正常增高,中断设置高度,防止死循环
            if(iframeDocHeight != iframeHeight){
                iframe.style.height = iframeDocHeight + 'px';
                //console.log('设置新的页面高度为:' + iframeDocHeight);
            }
        }
        
        /**
         * 设置iframe最小高度 
         * flag为true则强制设置高度
         */
        function _setMinHeight(flag) {
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
            var iframeMinHeight = $iframe.css('min-height');
            //只有手动改变窗口大小的时候才改变高度,防止代码修改高度引起的死循环
            if(flag || iframeMinHeight != (minHeight+'px')){
                iframe.style.cssText = 'min-height:' + minHeight + 'px;height:' + minHeight + 'px';
                //console.log('_setMinHeight:' + minHeight);
            }
            return minHeight;
        }
        /**
         * 验证页面是否循环触发了resize事件 ,
         * 依据是主页面中高度改变之后400毫秒内如果监听到iframe中页面高度又发生更改,并且是增高的高度是固定的则判定为再次触发了iframe内部页面的reisze,
         * 这时候后终止循环监听
         */
        function validateLoopResize(){
            if(timeoutResize)return;
            timeoutResize = setTimeout(function(){
                var increaseHeightOld = $iframe.data('increase-height');
                var increaseHeightNew = getDocumentHeight() - $iframe.height();
                if(increaseHeightOld>0 && increaseHeightNew==increaseHeightOld){
                    //清除轮询
                    clearInterval(intervalTime);
                    //重置高度,让最小高度生效
                    _setMinHeight(true);
                    //还原iframe中页面的滚动条设置
                    iframeDoc.body.style['overflow-y'] = 'auto';
                    console.log('increaseHeightOld:' + increaseHeightOld +',increaseHeightNew:' + increaseHeightNew);
                    console.log('工作台移除iframe自动高度计算监听，请检查页面中resize计算高度是否正确。');
                }
                $iframe.data('increase-height',increaseHeightNew);
                timeoutResize = null;
            },300);
        }
        /**
         * 获取document的高度 
         * flag:是否记录新的高度
         */
        function getDocumentHeight(flag){
            if(!iframeDoc){
                return 0;
            }
            try{
                //ie8通过增量方式计算高度,记录下初始页面高度,然后计算每次页面高度的增量,在初始页面高度的基础上相加得到最终页面高度
                if(browser.isIE&&iframeDoc.compatMode=="CSS1Compat"){
                    var bodyScrollHeightNew = iframeDoc.body.scrollHeight;
                    var bodyScrollHeightOld = $iframe.data('body.scrollHeight');
                    if(bodyScrollHeightOld==null){
                        bodyScrollHeightOld = bodyScrollHeightNew;
                    }
                    var documentScrollHeightOld = $iframe.data('document.scrollHeight');
                    if(documentScrollHeightOld==null){
                        documentScrollHeightOld = Math.max(iframeDoc.documentElement.scrollHeight,bodyScrollHeightNew);
                    }
                    var documentScrollHeightNew = Math.max(documentScrollHeightOld +  bodyScrollHeightNew - bodyScrollHeightOld,0);
                    if(flag){
                        $iframe.data('body.scrollHeight',bodyScrollHeightNew);
                        $iframe.data('document.scrollHeight',documentScrollHeightNew);
                    }
                    //console.log('documentScrollHeightOld:' + documentScrollHeightOld + ',bodyScrollHeightNew:' + bodyScrollHeightNew + ',bodyScrollHeightOld:' + bodyScrollHeightOld);
                    return documentScrollHeightNew;
                }
                return getHeight();
            }catch(e){return 0;}
        }
        
        function getHeight(){
            //有doctype时用documentElement,没有doctype用body
            return iframeDoc.compatMode=="CSS1Compat" ? iframeDoc.documentElement.scrollHeight : iframeDoc.body.scrollHeight;
        }
    };
    /**
     *判断是否存在横向滚动条 
     */
    function hasXScrollBar(iframeDoc){
        return (!!window.getComputedStyle && window.getComputedStyle(iframeDoc.body)['overflow-x']!='hidden'
                ||!!iframeDoc.body.currentStyle && iframeDoc.body.currentStyle['overflow-x']!='hidden')
                &&iframeDoc.body.scrollHeight != 0 && iframeDoc.documentElement.clientWidth!=0 
                && iframeDoc.documentElement.scrollWidth > iframeDoc.documentElement.clientWidth;
    }
    /**
     *获取滚动条宽度
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
});
