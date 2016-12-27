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
    mainFrameUrl:webPath + '/top/workbench/MainFrame.jsp?url=',
    formatUrl:function(url){
        if(!url){
            return '';
        }
        if(url.indexOf('http')==0){
            return url;
        }
        if(url.indexOf('/')!=0){//��'/'��ͷ
           url = '/' + url; 
        }
        if(url.indexOf(webPath)==0){
            return url;
        }
        return webPath + url;
    },
    openInMainFrame:function(url,target){
        target = target || '_top';
        //����Ѵ��������ҳ��,��ָ���������ҳ���д�
        if($('iframe[name=mainFrame]').length>0 && target=='mainFrame'){
            $('iframe[name=mainFrame]')[0].src = this.formatUrl(url);
            //window.open(this.formatUrl(url),target);
        }else{
            window.open(this.mainFrameUrl + encodeURIComponent(this.formatUrl(url)),target);
        }
    }
};

/**
 *ͳһҳ��򿪼���,�����Ժ�������ҳ��򿪻��ǵ�ǰҳ��� 
 */
!function($){
    $(document).on('click','[data-url][url-ignore!=true]',function(){
        var url = $(this).data('url');
        //�ж��Ƿ������ҳ���,����Ϊurl�а���mainFrame=false����url���������ϰ�������mainFrame="false"��,ҳ�����ô���url�ϵ�����
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
    });
}(window.jQuery);