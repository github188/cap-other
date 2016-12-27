/**
 * ?????
 * update: 2013-03-13 by chaoqun.lin
 */
;(function($, C){
	C.UI.Customform = C.UI.Base.extend({
		options: {
			uitype: 'Customform',
			columnCount: 2,
			datasource: [],
            classname: 'customform'
		},

		_create: function(){
			var datasource = this.options.datasource,
                item,
                type,
				uitype,
                $cui,
                i, len;
            //???????????
            window.validater = window.validater || cui().validate();
            //??????????????§Ö?CUI?????????????????????????
			for (i = 0; i < datasource.length; i++){
				item = datasource[i];
				uitype = item.uitype || item.uiType;
				type = uitype.charAt(0).toLowerCase() + uitype.substring(1);
				cui(item.el)[type](item);
			}
            //????
            for (i = 0; i < datasource.length; i++){
                item = datasource[i];
                this._bindData($(item.el), item.databind);
            }
            //??????tip??
            if(!C.UI.scan.textmode && !comtop.UI.scan.disable){
                for(i = 0, len = datasource.length; i < len; i ++){
                    item = datasource[i];
                    $cui = $(item.el).data('uitype');
                    if($cui && !$cui.options.textmode && !$cui.options.disable){
                        this._bindValidate($cui.options.el, item.validate);
                        this._bindTip($cui.options.el, item, $cui.tipPosition || $cui.options.el);
                    }
                }
            }
		},
        /**
         * ????
         * @param $el {jQuery} ????¦Ë??
         * @param db {String} ?????
         * @private
         */
        _bindData: function($el, db){
            //????
            if (db) {
                var chain = db.split('.');
                var dataSourceName = chain[0];
                var propName = chain[1];
                var dataSource = window[dataSourceName];
                //???dataSource????????????????
                if(!dataSource){
                    dataSource = window[dataSourceName] = {};
                }
                if(dataSource.nodeName){
                    alert('???'+ dataSourceName +'????????ID????????????;');
                    return false;
                }
                var databinder = cui(dataSource).databind();
                databinder.addBind($el, propName);
            }
        },
        /**
         * ?????
         * @param $el {jQuery} ????¦Ë??
         * @param vd {Array | String}  ???????
         * @private
         */
        _bindValidate: function($el, vd){
            if(vd){
                switch ($.type(vd)){
                    case 'array':
                        for(var i = 0; i < vd.length; i ++){
                            if(vd[i].rule){
                                window.validater.add(cui($el), vd[i].type, vd[i].rule);
                            }else{
                                window.validater.add(cui($el), vd[i].type);
                            }
                        }
                        break;
                    case 'string':
                        window.validater.add(cui($el), vd);
                }
            }
        },
        /**
         * ?????
         * @param $el {jQuery} ????¦Ë??
         * @param opts {Object} ???¨°???
         * @param $tipPos {String}  ?????¦Ë??
         * @private
         */
        _bindTip: function($el, opts, $tipPos){
            $tipPos = $($tipPos, $el);
            if(cui($el).options.textmode != undefined && opts.tip == undefined){
                $el.attr('tip', '');
                opts.tip = '';
            }
            if(opts.tip != undefined){
                $el.attr('tip', opts.tip);
                cui.tip($tipPos, {
                    trigger: opts.trigger,
                    tipEl: $el
                });
            }
        }
	});
})(window.comtop.cQuery, window.comtop);