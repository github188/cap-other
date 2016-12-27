?;(function($, C){
    'use strict';
    /**
     * 将json数据对像绑定到不同的cui元素
     */
    C.UI.Databind = C.UI.Base.extend({
        options: {
            uitype: 'Databind',
            scope: 'uitype',
            data: {}
        },

        data: {},
        // 备份初始数据供reset使用
        initData: {},
        // 记录propName --> el的mapping关系
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
         * 设置data数据
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
         * 获取data数据
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

        // 外部对像的值发生改变, 更新到data对像
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
         * 绑定元素到指定属性
         *
         * @param el 目标元素
         * @param propName 绑定的数据属性名称
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
            //在添加绑定时，如果绑定数据不存在，则不执行数据填充
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
         * 重置所有元素的值为初始值
         */
        reset: function(){
            for (var key in this.initData) {
                this.set(key, this.initData[key], true);
            }
        },

        /**
         * 清空表单数据
         */
        setEmpty: function(){
            var valType, val = '', key;
            //清空提示样式
            for(key in this.bindMapping){
                cui(this.bindMapping[key]).onValid();
            }
            //清空值
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
         * 设置属性值
         * @param {String} propName 绑定数据名称
         * @param {Object | Number | Array | String | ...} value'
         * @param {Boolean} isReset 是否执行重置
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
         * 获取数指定的据源的属性值
         */
        get: function(propName) {
            return this.data[propName];
        },

        /**
         * 解除所有的数据绑定
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