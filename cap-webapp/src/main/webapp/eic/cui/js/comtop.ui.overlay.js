;(function($,win) {
     var isIE=$.browser.msie,
         isIE6=isIE&&$.browser.version==="6.0",
         isIEQ=isIE&&!$.support.boxModel;
	function _overlay() {
        overlayObj.init();
        return  overlayObj;
	}

	var overlayObj= {
        init:function(){
            var dom;
            if (!this.overlayBuild) {
                dom = $(document.createElement("div"));
                dom.addClass("cui_overlay");
                $("body").append(dom);
                this.overlayBuild=true;
                this._dom=dom;
            }
        },
		show : function(opacity) {
			var opa = this._dom.data("opa") || 0;
			opacity = opa + parseInt( opacity * 100 );
            if(isIE6||isIEQ){
                $("html,body").addClass("cui_overlay_ie6");
            }
			this._dom.data("opa", opacity).css("opacity", opacity / 100 ).show();
		},

		hide : function(opacity) {
			var opa = this._dom.data("opa");
			opacity = opa - parseInt( opacity * 100 );
			this._dom.data("opa",  opacity);
			this._dom.css("opacity", opacity / 100 );
			if(opacity <= 0 ) {
				this._dom.hide();
                if(isIE6||isIEQ){
                    $("html,body").removeClass("cui_overlay_ie6");
                }
			}
		}
	};
     if(win.comtop&&win.comtop.UI){
         comtop.UI.Overlay = _overlay;
     }
     win._overlay=_overlay;
})(window.comtop?window.comtop.cQuery:window.jQuery,window);