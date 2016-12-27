css.load(webPath + '/top/workbench/message/css/message.css');
var DateUtil = {
    //判断是否同一天
    isSameDay:function(date1,date2){
        if(!date1 || !date2){
            return false;
        }
        return date1.getFullYear()==date2.getFullYear()
                &&date1.getMonth()==date2.getMonth()
                &&date1.getDate()==date2.getDate();
    },
    //判断是否同一月
    isSameMonth:function(date1,date2){
        if(!date1 || !date2){
            return false;
        }
        return date1.getFullYear()==date2.getFullYear()
                &&date1.getMonth()==date2.getMonth();
    },
    formatTime:function(date){
        if(!date){
            return '未知';
        }
        var hours = date.getHours();
        var minutes = date.getMinutes();
        return (hours<10?'0' + hours :hours) + ':' + (minutes<10?'0' + minutes:minutes);
    }
};
!function($){
    //固定头部
    $(window).scroll(function() {
        var scrollTop = $(window).scrollTop();
        $('.message-header').each(function(index) {
            var $this = $(this);
            //记录header离顶部距离的原始位置
            var posTop = $this.data('posTop') || $this.offset().top;
            if (posTop - scrollTop <= ((!$this.hasClass('message-header-flow') && $('.message-header-flow').length > 0) ? $('.message-header-flow').height() : 0)) {
                $('.message-header-flow').removeClass('message-header-flow');
                $this.data('posTop', posTop).addClass('message-header-flow');
            } else if ($this.data('posTop') >= scrollTop + 46) {
                $this.removeClass('message-header-flow').css(top,0);
            }
        });
    
        $('.time-point').each(function(index) {
            var $this = $(this);
            var posTop = $this.data('posTop') || $this.offset().top;
            var $parent = $this.parent();
            if($parent.offset().top+$parent.height()-scrollTop <= 115){
                $this.removeClass('time-point-flow');
                return;
            }
            if (posTop - scrollTop < (!$this.hasClass('time-point-flow') && $('.time-point-flow').length > 0 ? 82 : 46)) {
                $('.time-point-flow').removeClass('time-point-flow');
                $this.data('posTop', posTop).addClass('time-point-flow');
            } else if ($this.data('posTop') >= scrollTop + 82) {
                $this.removeClass('time-point-flow');
            }
        });
    });
}(window.jQuery);