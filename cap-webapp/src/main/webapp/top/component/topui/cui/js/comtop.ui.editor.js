/**
 * comtop.ui.Editor 富文本编辑器组件
 * 
 */
;(function($, C){

	/**
	 * comtop.UI.Editor
	 */
	comtop.UI.Editor = comtop.UI.Base.extend({

		options: {
			uitype: "Editor",
			width: 0,  			// 不设置会自适应宽度
			min_frame_height: 320,  			// 默认320px
			readonly: false,       //是否只读
			initial_content: "", 	// 默认文本
			readonly: false ,		// 是否只读
			word_count: true, 		// 是否开启字数统计
			maximum_words: 10000,		// 允许最大字符数
			textmode: false,        //是否为只读模式
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
		 * 获取编辑器内容(html)
		 * 
		 * @return {[type]} [description]
		 */
		getHtml: function() {
			return this.ueditor.getContent();
		}, 

		/**
		 * 设置编辑器的内容
		 * 
		 * @param {[type]} html [description]
		 * @return {Editor} 返回当前对象
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
		 * 设置编辑器的内容,针对databind,非对外开放
		 * 
		 * @param {[type]} html [description]
		 * @param isInit {Boolean} 是否是清空重置，清空重置不触发change
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
		 * 获取文本内容
		 * 
		 * @return {[type]} [description]
		 */
		getText: function() {
			return this.ueditor.getPlainTxt();
		}, 

		/**
		 * 设置只读
		 * 
		 * @return {Editor} 返回当前对象
		 */
		disable: function() {
			this.ueditor.setDisabled();
			return this;
		}, 

		/**
		 * 设置可读写
		 *
		 * @return {Editor} 返回当前对象
		 */
		enable: function() {
			this.ueditor.setEnabled();
			return this;
		}, 

		/**
		 * 显示
		 * @return {Editor} 返回当前对象
		 */
		show: function() {
			this.ueditor.setShow();
			return this;
		}, 

		/**
		 * 隐藏
		 * @return {Editor} 返回当前对象
		 */
		hide: function() {
			this.ueditor.setHide();
			return this;
		}, 

		/**
		 * 销毁/移除组件
		 * @type {Object}
		 */
		destroy: function() {
			this.ueditor.destroy();
		},
        /**
         * 验证失败时组件处理方法
         * @param obj
         * @param message
         */
        onInValid: function(obj, message) {
			var opts=this.options;
			$(".edui-editor",opts.el).addClass("edui-editor-invalid"); 
            opts.el.attr("tip", message);
        },

        /**
         * 验证成功时组件处理方法
         * @param obj
         */
        onValid: function(obj) {
			var opts=this.options;
			$(".edui-editor",opts.el).removeClass("edui-editor-invalid");	
            opts.el.attr("tip", ""); 
        }		
	});

})(window.comtop.cQuery, window.comtop);