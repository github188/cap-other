//重新定义console,解决调试代码问题
window.console = window.console || (function(){  
    var c = {}; c.log = c.warn = c.debug = c.info = c.error = c.time = c.dir = c.profile  
    = c.clear = c.exception = c.trace = c.assert = function(){};  
    return c;  
})();
//jquery扩展,设置最小高度
!function($){
    var ieVersion = navigator.userAgent.toLowerCase().match(/msie ([\d.]+)/);
    $.fn.setMinHeight = function(minHeight){
        $this = $(this);
        $this.each(function(index,item){
            var $item = $(item);
            $item.css({'min-height':minHeight});
            if(ieVersion && ieVersion[1] == '6.0'){
                $item.css({'height':minHeight});
            }
        });
    };
}(window.jQuery);

var Workbench = {
    mainFrameUrl:webPath + '/top/workbench/MainFrame.jsp#',
    formatUrl:function(url){
        if(!url){
            return '';
        }
        url +='';
        url = decodeURIComponent(url);
        if(url.indexOf('http')==0){
            return url;
        }
        if(url.indexOf('/')!=0){//非'/'开头
           url = '/' + url; 
        }
        if(url.indexOf(webPath)==0){
            return url;
        }
        return webPath + url;
    },
    openInMainFrame:function(url,target){
        target = target || '_top';
        //如果已存在主框架页面,且指定在主框架页面中打开
        if($('iframe[name=mainFrame]').length>0 && target=='mainFrame'){
            $('iframe[name=mainFrame]').attr('src',this.formatUrl(url));
        }else{
            window.open(this.mainFrameUrl + this.formatUrl(url),target);
        }
    }
};

/**
 *统一页面打开监听,方便以后设置新页面打开还是当前页面打开 
 */
!function($){
    $(document).on('click','[data-url][url-ignore!=true]',function(){
        var url = $(this).data('url');
        //判断是否主框架页面打开,规则为url中包含mainFrame=false或者url所在链接上包含参数mainFrame="false"的,页面配置大于url上的配置
        var openInMainFrame = $.trim(url).toLowerCase().indexOf('mainframe=false') ==-1;
        if($(this).data('mainframe')===false){
            openInMainFrame = false;
        }else if($(this).data('mainframe')===true){
            openInMainFrame = true;
        }
        var target = $(this).attr('target') || '_top';
        var formatUrl = Workbench.formatUrl(url);
        if(openInMainFrame){
            Workbench.openInMainFrame(formatUrl,target);
        }else{
            window.open(formatUrl,target);
        }
        return false;
    });
}(window.jQuery);

/**
 *回到顶部 
 */
!function($){
    $(function(){
        $(window).scroll(function(){
            if($(window).scrollTop() > 0){
                $('.goto-top').show();
            }else{
                $('.goto-top').hide();
            }
        });
        $('.goto-top').click(function(){
            $(window).scrollTop(0);
        });
    });
}(window.jQuery);