?;(function($, C){
    'use strict';
    /**
     * ��json���ݶ���󶨵���ͬ��cuiԪ��
     */
    C.UI.Databind = C.UI.Base.extend({
        options: {
            uitype: 'Databind',
            scope: 'uitype',
            data: {}
        },

        data: {},
        // ���ݳ�ʼ���ݹ�resetʹ��
        initData: {},
        // ��¼propName --> el��mapping��ϵ
        bindMapping: {},

        /**
         * init
         */
        _init: function() {
            this.data = this.options.el.get(0);
            delete this.data.eventID;
            this.initData = $.extend(true, {}, this.data);
            this.bindMapping = {};
        },

        /**
         * ����data����
         */
        setValue: function(data, isInit){
            for (var propName in data) {
                if(propName.toLowerCase().indexOf('jquery') >= 0){
                    continue;
                }
                this.set(propName, data[propName], isInit);
            }
        },

        /**
         * ��ȡdata����
         */
        getValue: function(){
			var data = $.extend({}, this.data);
			for(var i in data){
				if(i.toLowerCase().indexOf('jquery') >= 0){
                    delete data[i];
                }
			}
            return data;
        },

        // �ⲿ�����ֵ�����ı�, ���µ�data����
        _change: function(event) {
            var propName = event.data.propName;
            var el = event.data.el;
            var newValue = cui(el).getValue();
            var oldValue = this.data[propName];
            if (newValue != oldValue) {
                this.data[propName] = newValue;
                this._triggerHandler('change', [propName, oldValue, newValue]);
            }
        },

        /**
         * ��Ԫ�ص�ָ������
         *
         * @param el Ŀ��Ԫ��
         * @param propName �󶨵�������������
         */
        addBind: function(el, propName){
            this.bindMapping[propName] = el;
            var $el = cui(el);
            var value = $el.getValue();
            if(typeof this.data[propName] === 'undefined'){
                if(typeof value === 'string' && value !== ''){
                    this.data[propName] = value;
                }else if($.type(value) === 'array' && value.lenght !== 0){
                    this.data[propName] = value;
                }
            }
            $el.bind('change', {propName: propName, el: el}, $.proxy(this._change, this));
            //����Ӱ�ʱ����������ݲ����ڣ���ִ���������
            if(typeof this.data[propName] !== 'undefined'){
                if(!$el.options.textmode){
                    $el.setValue(this.data[propName], true);
                }else{
                    $el.options.value = this.data[propName];
                    $el.setTextMode();
                }
            }

            return this;
        },

        /**
         * ��������Ԫ�ص�ֵΪ��ʼֵ
         */
        reset: function(){
            for (var key in this.initData) {
                this.set(key, this.initData[key], true);
            }
        },

        /**
         * ��ձ�����
         */
        setEmpty: function(){
            var valType, val = '', key;
            //�����ʾ��ʽ
            for(key in this.bindMapping){
                cui(this.bindMapping[key]).onValid();
            }
            //���ֵ
            for (key in this.data) {
                if(key.toLowerCase().indexOf('jquery') >= 0){
                    continue;
                }
                valType = Object.prototype.toString.call(this.data[key])
                    .match(/\[object\s([A-Za-z]{1,})\]/)[1].toLocaleLowerCase();
                valType = this.data[key] === null ? 'null' : valType;
                switch (valType){
                    case 'number':
                        val = '';
                        break;
                    case 'string':
                        val = '';
                        break;
                    case 'array':
                        val = [];
                        break;
                    case 'object':
                        val = {};
                        break;
                    case 'null':
                        val = null;
                        break;
                    case 'undefined':
                        val = undefined;
                }
                this.set(key, val, true);
            }
        },

        /**
         * ��������ֵ
         * @param {String} propName ����������
         * @param {Object | Number | Array | String | ...} value'
         * @param {Boolean} isReset �Ƿ�ִ������
         */
        set: function(propName, value, isReset){
            var oldValue = this.data[propName];
            if (value != oldValue || isReset) {
                this.data[propName] = value;
                var el = this.bindMapping[propName];
                var $el = cui(el);
                if(el){
                    if(!$el.options.textmode){
                        $el.setValue(value, !!isReset);
                    }else{
                        $el.options.value = value;
                        $el.setTextMode();
                    }
                }
                this._triggerHandler('change', [propName, oldValue, value]);
            }
        },

        /**
         * ��ȡ��ָ���ľ�Դ������ֵ
         */
        get: function(propName) {
            return this.data[propName];
        },

        /**
         * ������е����ݰ�
         */
        destroy: function() {
            this._super();
            for (var key in this.bindMapping) {
                if (key) {
                    cui(this.bindMapping[key]).unbind('change', null, this._change);
                }
            }
        }
    });
})(window.comtop.cQuery, window.comtop);