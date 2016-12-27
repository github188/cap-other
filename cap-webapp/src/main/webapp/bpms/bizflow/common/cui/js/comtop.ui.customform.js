/**
 * 动态表单
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
            //创建验证对象
            window.validater = window.validater || cui().validate();
            //为了加快渲染速度，只有当CUI全部创建完成后才进行数据绑定和验证绑定
			for (i = 0; i < datasource.length; i++){
				item = datasource[i];
				uitype = item.uitype || item.uiType;
				type = uitype.charAt(0).toLowerCase() + uitype.substring(1);
				cui(item.el)[type](item);
			}
            //数据绑定
            for (i = 0; i < datasource.length; i++){
                item = datasource[i];
                this._bindData($(item.el), item.databind);
            }
            //验证绑定和tip绑定
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
         * 数据绑定
         * @param $el {jQuery} 组件占位符
         * @param db {String} 绑定数据
         * @private
         */
        _bindData: function($el, db){
            //数据绑定
            if (db) {
                var chain = db.split('.');
                var dataSourceName = chain[0];
                var propName = chain[1];
                var dataSource = window[dataSourceName];
                //如果dataSource不存在，创建空数据
                if(!dataSource){
                    dataSource = window[dataSourceName] = {};
                }
                if(dataSource.nodeName){
                    alert('数据'+ dataSourceName +'与页面的标签ID名相同，请更名;');
                    return false;
                }
                var databinder = cui(dataSource).databind();
                databinder.addBind($el, propName);
            }
        },
        /**
         * 验证绑定
         * @param $el {jQuery} 组件占位符
         * @param vd {Array | String}  验证配置
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
         * 提示绑定
         * @param $el {jQuery} 组件占位符
         * @param opts {Object} 配置参数
         * @param $tipPos {String}  提示绑定位置
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