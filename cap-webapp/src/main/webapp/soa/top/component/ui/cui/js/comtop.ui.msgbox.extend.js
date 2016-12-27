(function(cui) {
    'use strict';
    var type =["alert","warn","success","error","message","confirm"];
    for(var i =0;i<type.length;i++){
        if(typeof cui[type[i]] ==="function"){
            var fn = cui[type[i]],css=type[i];
            cui[css] =(function(fn,css){
                return function(){
                    fn.apply(cui,arguments);
                    var exCss ="";
                    if(css==="message"){
                        if(arguments[1]){
                            exCss= "-"+arguments[1];
                        }else{
                            exCss="-alert";
                        }
                    }
                    cui[css].builded.$container.addClass("cui-msg-extend-"+css+exCss);
                };
            })(fn,css);
        }
    }
})(window.cui);
