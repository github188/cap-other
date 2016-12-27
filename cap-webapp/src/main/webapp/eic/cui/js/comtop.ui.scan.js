/** 
 * ?????????????????
 * Author: chaoqun.lin
 * Date: 12-11-15 ????5:55
 * Version: 1.1.0
 */
;(function($, C){
    /**
     * ?????
     */
    C.UI.scan = function(){
        var options = {};
        for(var i = 0; i < arguments.length; i ++){
            switch (typeof arguments[i]){
                case 'string':
                case 'object':
                    options.range = $(arguments[i]);
                    break;
                case 'boolean':
                    options.databind = arguments[i];
                    break;
            }
        }
        options = $.extend({
            range: document,
            databind: true
        }, options);
        _init(options);
    };
    //???????
    C.UI.scan.debug = false;
    //?????????
    C.UI.scan.textmode = false;
    //????????????
    C.UI.scan.disable = false;
    //?????????
    C.UI.scan.readonly = false;
    //???????
    C.UI.scan.databind = _initData;
    //?????setReadonly
    C.UI.scan.setReadonly = _setReadonly;
    //???????
    var $uiCmp, optsList = [], errorLog = [];
    //?????
    function _init(opts){
        //??????????????
        $uiCmp = null;
        optsList = [];
        errorLog = [];

        $uiCmp = $('[uitype]', opts.range);

        //???????????????????100??input????????????????????????350mm?????
        $uiCmp.each(function(){
            var $tg = $(this);
            var uiType = $tg.attr('uitype');
            //??????????????
            if($tg.data('uitype') || !C.UI[uiType.charAt(0).toUpperCase() + uiType.substring(1)]){
                $uiCmp = $uiCmp.not($tg);
                //?????????
                return true;
            }
            optsList.push(_scan($tg, uiType));
        });

        var $tg = null;
        if(opts.databind){
            _initData();
        }
        if(!C.UI.scan.textmode && !C.UI.scan.disable){
            for(var i = 0, len = $uiCmp.length; i < len; i ++){
                $tg = $uiCmp.eq(i).data('uitype');
                if($tg && !$tg.options.textmode && !$tg.options.disable){
                    errorLog.push(_bindValidate($uiCmp.eq(i), optsList[i]));
                    errorLog.push(_bindTip($uiCmp.eq(i), optsList[i], $tg.tipPosition || $tg.options.el));
                }
            }
        }

        if(C.UI.scan.debug){
            _debug(opts.databind);
        }
        opts = undefined;
    }

    /**
     * ????????????
     * @param {jQuery} $el ??????
     * @param {String} uiType
     * @return {Object} ????options????
     * @private
     */
    function _scan($el, uiType){
        //??????uiType????????
        if(!uiType && uiType === ''){
            return false;
        }
        /**
         * ????dialog????????ÈÉ????display=none?????????????dialog???????????????
         */
        if(uiType.toLocaleLowerCase() === 'dialog'){
            $el.addClass('cui-dialog').css('display','block');
            return {};
        }


        //?????????????
        var opts = _getParam($el[0]);
        var valiOpts = {
            validate: opts.validate
        };
        var dbOpts = {
            databind: opts.databind
        };
        var tipOpts = {
            tip: opts.tip,
            trigger: opts.tipTrigger ? opts.tipTrigger : 'hover'
        };

        //????????§»????????????
        delete opts.uitype;
        delete opts.tipTrigger;
        delete opts.tip;
        delete opts.databind;
        delete opts.validate;

        //???uiType????????????????
        var uncapliseUIType = uiType.charAt(0).toLowerCase() + uiType.substring(1);

        //???????????????????????textmode??????true
        if(C.UI.scan.textmode){
            opts.textmode = true;
            opts.readonly = false;
            opts.disable = false;
        }
        //???????????????????????disable??????true
        if(C.UI.scan.disable){
            opts.textmode = false;
            opts.readonly = false;
            opts.disable = true;
        }
        //???????????????????????readonly??????true
        if(C.UI.scan.readonly){
            opts.readonly = true;
            opts.textmode = false;
            opts.disable = false;
        }

        //???
        if(C.UI.scan.debug){
            try{
                $el[uncapliseUIType](opts);
            }catch(e){
                errorLog.push('[' + uiType + ':' + $el.attr('id') + ']:' + '?????????????????????¨°???????????????????\n');
            }
        }else{
            $el[uncapliseUIType](opts);
        }

        return {
            opts: opts,
            valiOpts: valiOpts,
            dbOpts: dbOpts,
            tipOpts: tipOpts
        };
    }

    /**
     * ??????????
     * @private
     */
    function _initData(){
		if(!$uiCmp || $uiCmp.length === 0){
			return;
		}
        for(var i = 0, len = $uiCmp.length; i < len; i ++){
            $uiCmp.eq(i).data('uitype') && errorLog.push(_bindData($uiCmp.eq(i), optsList[i]));
        }
    }

    /**
     * ??????
     * @private
     */
    function _debug(databind){
        if(C.UI.scan.debug){
            var tmpErrorLog = [];
            for(var i = 0, len = errorLog.length; i < len; i ++){
                errorLog[i] && tmpErrorLog.push(errorLog[i]);
            }
            tmpErrorLog.length > 0 && alert(tmpErrorLog.join(''));
        }
        errorLog = [];
        if(!databind){
            $uiCmp = undefined;
            optsList = [];
        }
    }

    /**
     * ????
     * @param {jQuery} $el ??????
     * @param {Object} opts ????
     * @return {String} errorLog ???????
     * @private
     */
    function _bindData($el, opts){
        //???§µ?????¨°???
        var db = opts.dbOpts.databind;
        var errorLog = null;
        var debug = C.UI.scan.debug;

        //????
        if (db) {
            var chain = db.split('.');
            if(chain.length < 2){
                debug && (errorLog = '[' + $el.attr('uitype') + ':' + $el.attr('id') + ']' +
                    ':??????????JSON????????????;\n');
                return false;
            }
            var dataSourceName = [];
            var dataSource;
            var propName;
            for(var i = 0, iLen = chain.length; i < iLen; i++){
                if(i < iLen - 1){
                    dataSourceName.push(chain[i]);
                }else{
                    propName = chain[i];
                }
            }
            dataSource = C.namespace(dataSourceName.join('.'));
            //???dataSource????????????????
            /*if(!dataSource){
                dataSource = window[dataSourceName] = {};
                debug && (errorLog = '[' + $el.attr('uitype') + ':' + $el.attr('id') + ']' +
                    ':?????????'+ dataSourceName +'???;\n');
            }*/
            /*var propName = chain[1];*/

            if(dataSource.nodeName){
                debug && (errorLog = '[' + $el.attr('uitype') + ':' + $el.attr('id') + ']' +
                    ':???'+ dataSourceName +'????????ID????????????;\n');
                return false;
            }
            var databinder = cui(dataSource).databind();
            databinder.addBind($el, propName);
        }
        return errorLog;
    }

    /**
     * §µ???
     * @param {jQuery} $el ??????
     * @param {Object} opts ????
     * @return {String} errorLog ???????
     * @private
     */
    function _bindValidate($el, opts){
        var vd = opts.valiOpts.validate;
        var errorLog = '';

        if(vd){
            var jsonReg = /^(?:\{.*\}|\[.*\])$/;
            //§µ???
            if(!window.validater){
                window.validater = cui().validate();
            }
            if(jsonReg.test(vd)){
                try{
                    vd = $.parseJSON(vd.replace(/\\'/g, '#@@#').replace(/'/g, '"').replace(/#@@#/g, '\''));
                }catch(e){
                    errorLog = '[' + $el.attr('uitype') + ':' + $el.attr('id') + ']' + ':§µ???JSON???????;\n';
                }
            }else{
                try{
                    vd = _getObject(vd);
                }catch(e){
                    errorLog = '[' + $el.attr('uitype') + ':' + $el.attr('id') + ']' + ':§µ?????????????;\n';
                }
            }
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
        return errorLog;
    }

    /**
     * ?????
     * @param {jQuery} $el ??????
     * @param {Object} opts ????
     * @param {jQuery || String} $tipPos
     * @return {String} errorLog ???????
     * @private
     */
    function _bindTip($el, opts, $tipPos){
        var errorLog = '';
        $tipPos = $($tipPos, $el);
        //if(opts.valiOpts.validate && !opts.tipOpts.tip){
        if(cui($el).options.textmode != undefined && !opts.tipOpts.tip){
            $el.attr('tip', '');
            opts.tipOpts.tip = '';
        }
        if(opts.tipOpts.tip != undefined){
            try{
                cui.tip($tipPos, {
                    trigger: opts.tipOpts.trigger,
                    tipEl: $el
                });
            }catch(e){
                errorLog = '[' + $el.attr('uitype') + ':' + $el.attr('id') + ']' + ':??????????;\n';
            }
        }
        return errorLog;
    }

    /**
     * ??????????
     * @param {HTMLElement} el ?????¦Ë??
     * @return {Object} JSON ? options
     * @private
     */
    function _getParam(el){
        var $el = $(el);

        return {
            isScanner: true,
            databind: $el.attr('databind'),
            validate: $el.attr('validate'),
            tip: $el.attr('tip'),
            tipTrigger: $el.attr('tip_trigger')
        };
    }

    /**
     * ?§Ø????????????
     * @param nodeValue
     * @return {window}
     * @private
     */
    function _getObject(nodeValue){
        var objStr = nodeValue.split('.'),
            objParent = window;
        for(var k = 0; k < objStr.length; k ++){
            objParent = objParent[objStr[k]];
        }
        return (typeof objParent === 'object' && !objParent.nodeName) ? objParent : nodeValue;
    }

    /**
     * ???????
     * @param flag {Boolean} ????????true??????false?????§Õ
     * @param setRange {jQuery | String} ?????¦¶
     * @private
     */
    function _setReadonly(flag, setRange){
        flag = typeof flag === 'undefined' ? true : flag;
        setRange = typeof setRange === 'undefined' ? 'body' : setRange;
        var formElements = [];
        var $setRange = $(setRange);
        var i, len;
        //??????????Ñk????????¦¶???
        if(setRange !== 'document' && setRange !== 'body' && setRange !== 'html'){
            for(i = 0, len = C.UI.componentList.length; i < len; i ++){
                if($setRange.find(C.UI.componentList[i].options.el).length){
                    formElements.push(C.UI.componentList[i]);
                }
            }
        }else{
            formElements = C.UI.componentList;
        }

        for(i = 0, len = formElements.length; i < len; i ++){
            if(typeof formElements[i].setReadonly === 'function'){
                formElements[i].setReadonly(flag);
            }
        }
    }
})(window.comtop.cQuery, window.comtop);