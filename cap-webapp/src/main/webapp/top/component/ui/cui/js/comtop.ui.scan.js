/** 
 * 扫描器，自动创建组件
 * Author: chaoqun.lin
 * Date: 12-11-15 下午5:55
 * Version: 1.1.0
 */
;(function($, C){
    /**
     * 扫描器
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
    //调试开关
    C.UI.scan.debug = false;
    //开启文本模式
    C.UI.scan.textmode = false;
    //开启不可用模式
    C.UI.scan.disable = false;
    //开启只读模式
    C.UI.scan.readonly = false;
    //执行数据绑定
    C.UI.scan.databind = _initData;
    //表单组件setReadonly
    C.UI.scan.setReadonly = _setReadonly;
    //局部变量
    var $uiCmp, optsList = [], errorLog = [];
    //初始化
    function _init(opts){
        //初始化扫描清空数据
        $uiCmp = null;
        optsList = [];
        errorLog = [];

        $uiCmp = $('[uitype]', opts.range);

        //根据元素，统一实例化（注：创建100个input并获取它们上面的属性，耗时在350mm左右）
        $uiCmp.each(function(){
            var $tg = $(this);
            var uiType = $tg.attr('uitype');
            //如果存在，不再创建
            if($tg.data('uitype') || !C.UI[uiType.charAt(0).toUpperCase() + uiType.substring(1)]){
                $uiCmp = $uiCmp.not($tg);
                //跳至下一个
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
     * 扫描标签，并实例化
     * @param {jQuery} $el 扫描对象
     * @param {String} uiType
     * @return {Object} 返回options数据集
     * @private
     */
    function _scan($el, uiType){
        //如果没有uiType就直接跳过
        if(!uiType && uiType === ''){
            return false;
        }
        /**
         * 关于dialog在页面的模板，默认将display=none这种方式，改为将dialog设置在不可见的区域
         */
        if(uiType.toLocaleLowerCase() === 'dialog'){
            $el.addClass('cui-dialog').css('display','block');
            return {};
        }


        //获取标签上的属性
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

        //尽量删除一些不必要的属性值
        delete opts.uitype;
        delete opts.tipTrigger;
        delete opts.tip;
        delete opts.databind;
        delete opts.validate;

        //如果uiType组件存在，则执行实例化
        var uncapliseUIType = uiType.charAt(0).toLowerCase() + uiType.substring(1);

        //如果开启文本模式，则所有组件的textmode自动设为true
        if(C.UI.scan.textmode){
            opts.textmode = true;
            opts.readonly = false;
            opts.disable = false;
        }
        //如果开启文本模式，则所有组件的disable自动设为true
        if(C.UI.scan.disable){
            opts.textmode = false;
            opts.readonly = false;
            opts.disable = true;
        }
        //如果开启只读模式，则所有组件的readonly自动设为true
        if(C.UI.scan.readonly){
            opts.readonly = true;
            opts.textmode = false;
            opts.disable = false;
        }

        //实例化
        if(C.UI.scan.debug){
            try{
                $el[uncapliseUIType](opts);
            }catch(e){
                errorLog.push('[' + uiType + ':' + $el.attr('id') + ']:' + '组件创建失败，可能参数配置不正确或者组件存在问题；\n');
            }
        }else{
            $el[uncapliseUIType](opts);
        }

        //移除占位符上的name
        $el.removeAttr('name');

        return {
            opts: opts,
            valiOpts: valiOpts,
            dbOpts: dbOpts,
            tipOpts: tipOpts
        };
    }

    /**
     * 执行数据初始化
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
     * 报错功能
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
     * 数据绑定
     * @param {jQuery} $el 扫描对象
     * @param {Object} opts 数据集
     * @return {String} errorLog 错误提示
     * @private
     */
    function _bindData($el, opts){
        //获取校验配置参数
        var db = opts.dbOpts.databind;
        var errorLog = null;
        var debug = C.UI.scan.debug;

        //数据绑定
        if (db) {
            var chain = db.split('.');
            if(chain.length < 2){
                debug && (errorLog = '[' + $el.attr('uitype') + ':' + $el.attr('id') + ']' +
                    ':绑定的数据必须为JSON格式里的成员变量;\n');
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
            //如果dataSource不存在，创建空数据
            /*if(!dataSource){
                dataSource = window[dataSourceName] = {};
                debug && (errorLog = '[' + $el.attr('uitype') + ':' + $el.attr('id') + ']' +
                    ':注意了，数据'+ dataSourceName +'为空;\n');
            }*/
            /*var propName = chain[1];*/

            if(dataSource.nodeName){
                debug && (errorLog = '[' + $el.attr('uitype') + ':' + $el.attr('id') + ']' +
                    ':数据'+ dataSourceName +'与页面的标签ID名相同，请更名;\n');
                return false;
            }
            var databinder = cui(dataSource).databind();
            databinder.addBind($el, propName);
        }
        return errorLog;
    }

    /**
     * 校验绑定
     * @param {jQuery} $el 扫描对象
     * @param {Object} opts 数据集
     * @return {String} errorLog 错误提示
     * @private
     */
    function _bindValidate($el, opts){
        var vd = opts.valiOpts.validate;
        var errorLog = '';

        if(vd){
            var jsonReg = /^(?:\{.*\}|\[.*\])$/;
            //校验绑定
            if(!window.validater){
                window.validater = cui().validate();
            }
            if(jsonReg.test(vd)){
                try{
                    vd = $.parseJSON(vd.replace(/\\'/g, '#@@#').replace(/'/g, '"').replace(/#@@#/g, '\''));
                }catch(e){
                    errorLog = '[' + $el.attr('uitype') + ':' + $el.attr('id') + ']' + ':校验的JSON数据有误;\n';
                }
            }else{
                try{
                    vd = _getObject(vd);
                }catch(e){
                    errorLog = '[' + $el.attr('uitype') + ':' + $el.attr('id') + ']' + ':校验数据有误或不存在;\n';
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
     * 提示绑定
     * @param {jQuery} $el 扫描对象
     * @param {Object} opts 数据集
     * @param {jQuery || String} $tipPos
     * @return {String} errorLog 错误提示
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
                errorLog = '[' + $el.attr('uitype') + ':' + $el.attr('id') + ']' + ':提示创建失败;\n';
            }
        }
        return errorLog;
    }

    /**
     * 获取属性参数
     * @param {HTMLElement} el 扫描的占位符
     * @return {Object} JSON 式 options
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
     * 判断是否是页面变量
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
     * 设置只读
     * @param flag {Boolean} 设为只读，true为只读，false恢复可写
     * @param setRange {jQuery | String} 只读范围
     * @private
     */
    function _setReadonly(flag, setRange){
        flag = typeof flag === 'undefined' ? true : flag;
        setRange = typeof setRange === 'undefined' ? 'body' : setRange;
        var formElements = [];
        var $setRange = $(setRange);
        var i, len;
        //如果是全局扫描，即不做范围检查
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