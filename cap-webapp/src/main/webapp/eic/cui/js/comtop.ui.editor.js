/**
 * comtop.ui.Editor ????????????
 * 
 */
;(function($, C){

	/**
	 * comtop.UI.Editor
	 */
	comtop.UI.Editor = comtop.UI.Base.extend({

		options: {
			uitype: "Editor",
			width: 0,  			// ???????????????
			min_frame_height: 320,  			// ???320px
			readonly: false,       //??????
			initial_content: "", 	// ??????
			readonly: false ,		// ??????
			word_count: true, 		// ????????????
			maximum_words: 10000,		// ????????????
			textmode: false,        //?????????
			focus:true 

		}, 

		ueditor: null, 

		_init: function(options) {	
		 	
 			var opt = this.options;
			var op={
				  initialContent:window[opt.initial_content]?window[opt.initial_content]:opt.initial_content,
				  wordCount:opt.word_count,
				  maximumWords:opt.maximum_words,
				  minFrameHeight:opt.min_frame_height
				};
			$.extend(this.options,op);	
			if(this.options.width) {
				this.options.el.width(this.options.width);
			}
 
		},
        getLabelValue:function(){
              return this.options.initialContent;
        },
		_create: function() {
			this.ueditor = new UE.ui.Editor(this.options);
			this.ueditor.render(this.options.el.get(0));
            if(this.options.word_count){
                this.ueditor.ready(function(){
                    this.ui._wordCount();
                });
            }
			var self=this;
			this.ueditor.addListener("blur",function(){
													 self._triggerHandler("change");
													});
		}, 


		////////////////////////////////////////////////
		//
		//   Public
		//   
		////////////////////////////////////////////////
        set: function (name, value) {
            var opt = this.options,
                val = typeof(value) === "string"? value.replace("px", "") : value;
            if(name === "width") {
                opt.el.width(val);
            }
            else if(name === "height") {
                var self=this;
                this.ueditor.ready(function(){
                    self.ueditor.setHeight(val, true);
                });

            }
            return this;
        },
		
		/**
		 * ???????????(html)
		 * 
		 * @return {[type]} [description]
		 */
		getHtml: function() {
			return this.ueditor.getContent();
		}, 

		/**
		 * ?????????????
		 * 
		 * @param {[type]} html [description]
		 * @return {Editor} ??????????
		 */
		setHtml: function(html,isInit) {
			var self=this;
			this.ueditor.ready(function(){
				self.ueditor.setContent(html);
				isInit ||self._triggerHandler("change");
			});
			
			return this;
		}, 
		/**
		 * ?????????????,???databind,???????
		 * 
		 * @param {[type]} html [description]
		 * @param isInit {Boolean} ???????????????????¨°?????change
		 */		
        setValue:function(html, isInit){
			if(!html){
			  return;
			}
			this.setHtml(html, isInit);
        //    isInit || this._triggerHandler("change");
		},
		getValue:function(){
			return this.getHtml();
		},
		/**
		 * ??????????
		 * 
		 * @return {[type]} [description]
		 */
		getText: function() {
			return this.ueditor.getPlainTxt();
		}, 

		/**
		 * ???????
		 * 
		 * @return {Editor} ??????????
		 */
		disable: function() {
			this.ueditor.setDisabled();
			return this;
		}, 

		/**
		 * ??????§Õ
		 *
		 * @return {Editor} ??????????
		 */
		enable: function() {
			this.ueditor.setEnabled();
			return this;
		}, 

		/**
		 * ???
		 * @return {Editor} ??????????
		 */
		show: function() {
			this.ueditor.setShow();
			return this;
		}, 

		/**
		 * ????
		 * @return {Editor} ??????????
		 */
		hide: function() {
			this.ueditor.setHide();
			return this;
		}, 

		/**
		 * ???/??????
		 * @type {Object}
		 */
		destroy: function() {
			this.ueditor.destroy();
		},
        /**
         * ????????????????
         * @param obj
         * @param message
         */
        onInValid: function(obj, message) {
			var opts=this.options;
			$(".edui-editor",opts.el).addClass("edui-editor-invalid"); 
            opts.el.attr("tip", message);
        },

        /**
         * ????????????????
         * @param obj
         */
        onValid: function(obj) {
			var opts=this.options;
			$(".edui-editor",opts.el).removeClass("edui-editor-invalid");	
            opts.el.attr("tip", ""); 
        }		
	});

})(window.comtop.cQuery, window.comtop);