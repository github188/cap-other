;(function($, C){
    /**
     * ??json?????????????cui???
     */
    C.UI.Databind = C.UI.Base.extend({
        options: {
            uitype: 'Databind',
            scope: 'uitype',
            data: {}
        },

        data: {},
        // ??????????reset???
        initData: {},
        // ???propName --> el??mapping???
        bindMapping: {},

        /**
         * ???????:
         * change(event, propertyName, oldValue, newValue)
         */

        /**
         * init
         */
        _init: function() {
            this.data = this.options.el.get(0);
            this.initData = $.extend(true, {}, this.data);
            this.bindMapping = {};
        },

        /**
         * ????data???
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
         * ???data???
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

        // ??????????????, ?????data????
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
         * ?????????????
         *
         * @param el ??????
         * @param propName ?????????????
         */
        addBind: function(el, propName){
            this.bindMapping[propName] = el;
            //this.initData[propName] = null;
            var $el = cui(el);
            $el.bind('change', {propName: propName, el: el}, $.proxy(this._change, this));
            if(!$el.options.textmode){
                $el.setValue(this.data[propName], true);
            }else{
                $el.options.value = this.data[propName];
                $el.setTextMode();
            }

            return this;
        },

        /**
         * ??????????????????
         */
        reset: function(){
            for (var key in this.initData) {
                this.set(key, this.initData[key], true);
            }
        },

        /**
         * ???????
         */
        setEmpty: function(){
            var valType, val = '', key;
            //?????????
            for(key in this.bindMapping){
                cui(this.bindMapping[key]).onValid();
            }
            //????
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
         * ?????????
         * @param {String} propName ????????
         * @param {Object | Number | Array | String | ...} value'
         * @param {Boolean} isReset ??????????
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
         * ???????????????????
         */
        get: function(propName) {
            return this.data[propName];
        },

        /**
         * ??????§Ö?????
         */
        destroy: function() {
            this._super();
            for (var key in this.bindMapping) {
                if (key) {
                    cui(this.bindMapping[key]).unbind('change', null, this._change);
                }
            }
        }
    })
})(window.comtop.cQuery, window.comtop);