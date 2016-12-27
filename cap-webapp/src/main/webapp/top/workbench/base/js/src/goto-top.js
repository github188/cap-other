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