/**
 * comtop.ui.Editor ���ı��༭�����
 * 
 */
;(function($, C){

	/**
	 * comtop.UI.Editor
	 */
	comtop.UI.Editor = comtop.UI.Base.extend({

		options: {
			uitype: "Editor",
			width: 0,  			// �����û�����Ӧ���
			min_frame_height: 320,  			// Ĭ��320px
			readonly: false,       //�Ƿ�ֻ��
			initial_content: "", 	// Ĭ���ı�
			readonly: false ,		// �Ƿ�ֻ��
			word_count: true, 		// �Ƿ�������ͳ��
			maximum_words: 10000,		// ��������ַ���
			textmode: false,        //�Ƿ�Ϊֻ��ģʽ
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
		 * ��ȡ�༭������(html)
		 * 
		 * @return {[type]} [description]
		 */
		getHtml: function() {
			return this.ueditor.getContent();
		}, 

		/**
		 * ���ñ༭��������
		 * 
		 * @param {[type]} html [description]
		 * @return {Editor} ���ص�ǰ����
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
		 * ���ñ༭��������,���databind,�Ƕ��⿪��
		 * 
		 * @param {[type]} html [description]
		 * @param isInit {Boolean} �Ƿ���������ã�������ò�����change
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
		 * ��ȡ�ı�����
		 * 
		 * @return {[type]} [description]
		 */
		getText: function() {
			return this.ueditor.getPlainTxt();
		}, 

		/**
		 * ����ֻ��
		 * 
		 * @return {Editor} ���ص�ǰ����
		 */
		disable: function() {
			this.ueditor.setDisabled();
			return this;
		}, 

		/**
		 * ���ÿɶ�д
		 *
		 * @return {Editor} ���ص�ǰ����
		 */
		enable: function() {
			this.ueditor.setEnabled();
			return this;
		}, 

		/**
		 * ��ʾ
		 * @return {Editor} ���ص�ǰ����
		 */
		show: function() {
			this.ueditor.setShow();
			return this;
		}, 

		/**
		 * ����
		 * @return {Editor} ���ص�ǰ����
		 */
		hide: function() {
			this.ueditor.setHide();
			return this;
		}, 

		/**
		 * ����/�Ƴ����
		 * @type {Object}
		 */
		destroy: function() {
			this.ueditor.destroy();
		},
        /**
         * ��֤ʧ��ʱ���������
         * @param obj
         * @param message
         */
        onInValid: function(obj, message) {
			var opts=this.options;
			$(".edui-editor",opts.el).addClass("edui-editor-invalid"); 
            opts.el.attr("tip", message);
        },

        /**
         * ��֤�ɹ�ʱ���������
         * @param obj
         */
        onValid: function(obj) {
			var opts=this.options;
			$(".edui-editor",opts.el).removeClass("edui-editor-invalid");	
            opts.el.attr("tip", ""); 
        }		
	});

})(window.comtop.cQuery, window.comtop);