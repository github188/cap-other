/*
 Masked Input plugin for jQuery
 Copyright (c) 2007-@Year Josh Bush (digitalbush.com)
 Licensed under the MIT license (http://digitalbush.com/projects/masked-input-plugin/#license)
 Version: @version
 */
;(function($, C) {

    C.UI.InputMask = {
        // 日期时间模版包含秒
        Datetimes: '9999-1m-td 2h:59:59',
        // 时间模板
        Times: '2h:59:59',
        // 时间模板
        Time: '2h:59',
        // 日期时间模版不包含秒
        Datetime: '9999-1m-td 2h:59',
        /*Datetime: '9999-1m-td 2h:59',  */
        // 日期模板
        Date: '9999-1m-td',
        // 正整数字模板， {小数精确位数， 货币符号， 分隔符号}
        // precision == null，则表示不限制小数位数， precision === 0，则表示不保留小数
        Int: {precision:0, prefix:'', separator:','},
        // 小数数字模板
        Dec: {precision:null, prefix:'', separator:','},
        // 数字模板
        Num: {precision:0, prefix:'', separator:''},
        // 金额模板
        Money: {precision:2, prefix:'', separator:',',negative:false},
        // 数字模板，此属性可能已经在使用，为了向下兼容，保留此模板，但是不建议使用；使用此模板，会调用旧的处理方法
        Integer: {precision:0, prefix:''},


        //Predefined character definitions
        definitions: {
            '9': "[0-9]",
            'a': "[A-Za-z]",
            '*': "[A-Za-z0-9]",
            'd': 'd',
            'm': 'm',
            'h': 'h',
            't': 't',
            //'w': 'w',
            '1': "[0-1]",
            '2': "[0-2]",
            '3': "[0-3]",
            '4': "[0-4]",
            '5': "[0-5]",
            '6': "[0-6]",
            '7': "[0-7]",
            '8': "[0-8]"
        },
        dataName:"rawMaskFn",


        /**
         * 格式化
         * @params element {jQuery | String | HTMLElement} 元素
         * @params mask {String} 格式化方式
         * @params settings {Object} 设置
         */
        doMask: function(element, mask, settings) {
            var maskLC = mask.toLocaleLowerCase();
            var $el = $(element);
            switch (maskLC){
                case 'int':
                case 'num':
                case 'dec':
                case 'money':
                    var inputMaskModel;
                    //合并配置
                    inputMaskModel = $.extend(true, {}, this[mask], settings);
                    //正整数和数字不能配置precision
                    if(maskLC === 'int' || maskLC === 'num'){
                        inputMaskModel.precision = 0;
                    }

                    //将格式化规则写入当前元素的data内
                    $el.data('inputMaskModel', inputMaskModel);

                    $el.numberFormat(mask, inputMaskModel);
                    break;
                //向下兼容，保留
                case 'integer':
                    $el.scrapNumFormat(this[mask].precision, this[mask].prefix);
                    break;
                case 'custom':
                    if (settings && settings.model){
                        $el.mask(settings.model, settings);
                    }
                    break;
                default:
                    if(this[mask]){
                        $el.mask(this[mask], settings);
                    }
            }
        },

        /**
         * 获取非格式化的值
         * @params element {jQuery | String | HTMLElement} 元素
         * @params mask {String} 格式化方式
         * @params settings {Object} 设置
         */
        unMaskValue: function(element, mask, settings) {
            function inDefinitions(model_i, definitions) {
                var flag = false;
                $.each(definitions, function(key, value) {
                    if (model_i == key) {
                        flag = true;
                    }
                });
                return flag;
            }

            var maskLC = mask.toLocaleLowerCase();
            var $el = $(element);
            switch (maskLC){
                case 'int':
                case 'num':
                case 'dec':
                case 'money':
                    //获取格式化规则
                    var inputMaskModel = $el.data('inputMaskModel');
                    var regTxt = $.trim(inputMaskModel.prefix + inputMaskModel.separator);
                    var valTxt = $.trim($el.val());
                    if(valTxt !== ''){
                        if(regTxt === ''){
                            //返回数值必须去掉.00这类数据
                            return valTxt.replace(/(?:\.(?:0+)?|(\.[1-9]+)0+)$/,'$1');
                        }else{
                            var reg = new RegExp('[' + regTxt + ']','g');
                            return $el.val().replace(reg, '').replace(/(?:\.(?:0+)?|(\.[1-9]+)0+)$/,'$1');
                        }
                    }else{
                        return '';
                    }
                    break;
                //向下兼容，保留
                case 'integer':
                    return $(element).val().replace(/,/g, '');
                case 'custom':
                    return $(element).mask();
                default:
                    return $(element).val();
            }
        }
    };

    var pasteEventName = (C.Browser.isIE ? 'paste' : 'input') + ".mask";
    var iPhone = (window.orientation != undefined);

    $.fn.extend({
        //Helper Function for Caret positioning
        caret: function(begin, end) {
            if (this.length == 0) return;
            if (typeof begin == 'number') {
                end = (typeof end == 'number') ? end : begin;
                $("#test").val(begin + ":" + end);
                return this.each(function() {
                    if (this.setSelectionRange) {
                        this.setSelectionRange(begin, end);
                    } else if (this.createTextRange) {
                        var range = this.createTextRange();
                        range.collapse(true);
                        range.moveEnd('character', end);
                        range.moveStart('character', begin);
                        range.select();
                    }
                });
            } else {
                if (this[0].setSelectionRange) {
                    begin = this[0].selectionStart;
                    end = this[0].selectionEnd;
                } else if (document.selection && document.selection.createRange) {
                    var range = document.selection.createRange();
                    begin = 0 - range.duplicate().moveStart('character', -100000);
                    end = begin + range.text.length;
                }
                return { begin: begin, end: end };
            }
        },

        /**
         * 解除事件绑定
         * @returns {*}
         */
        unmask: function() { return this.trigger("unmask"); },


        mask: function(mask, settings) {
            if (!mask && this.length > 0) {
                var input = $(this[0]);
                return input.data(C.UI.InputMask.dataName)();
            }
            settings = $.extend({
                placeholder: "_",
                completed: null
            }, settings);

            var defs = C.UI.InputMask.definitions;
            var tests = [];
            var partialPosition = mask.length;
            var firstNonMaskPos = null;
            var len = mask.length;

            $.each(mask.split(""), function(i, c) {
                if (c == '?') {
                    len--;
                    partialPosition = i;
                } else if (defs[c]) {
                    tests.push(defs[c]);
                    if(firstNonMaskPos==null)
                        firstNonMaskPos =  tests.length - 1;
                } else {
                    tests.push(null);
                }
            });

            return this.trigger("unmask").each(function() {
                var input = $(this);
                var buffer = $.map(mask.split(""), function(c, i) { if (c != '?') return defs[c] ? settings.placeholder : c });
                var focusText = input.val();

                function seekNext(pos) {
                    while (++pos <= len && !tests[pos]);
                    return pos;
                }
                function seekPrev(pos) {
                    while (--pos >= 0 && !tests[pos]);
                    return pos;
                }

                function compare(exp, charValue, i) {
                    switch(exp) {
                        case 'm':
                            var value = input.val().substring(i - 1, i);
                            var k = parseFloat(charValue);
                            if (value === '0') {
                                return (k > 0 && k <= 9);
                            } else if (value === '1') {
                                return (k >= 0 && k < 3);
                            }
                            break;
                        case 'd':
                            var inputValue = input.val();
                            var value = inputValue.substring(i - 1, i);
                            var year = inputValue.substring(0, 4);
                            var month = inputValue.substring(5, 7);
                            var day = new Date(year, month, 0).getDate();
                            var fDay = (day + "").split("")[0];
                            var lDay = (day + "").split("")[1];
                            var k = parseFloat(charValue);
                            if (value < fDay) {
                                if (value === 0) {
                                    return (k > 0 && k <= 9);
                                } else {
                                    return (k >= 0 && k <= 9);
                                }
                            } else {
                                return (k >= 0 && k <= lDay);
                            }
                            break;
                        case 'h':
                            var value = input.val().substring(i - 1, i);
                            var k = parseFloat(charValue);
                            if (value === '0' || value === '1') {
                                return (k >= 0 && k <= 9);
                            } else if (value === '2') {
                                return (k >= 0 && k <= 3);
                            }
                            break;
                        /*case 'w':
                         var value = input.val().substring(i - 1, i);
                         if(isNaN(value - 0)){
                         return false;
                         }
                         var k = parseFloat(charValue);
                         if (value === '0' || value === '1') {
                         return (k >= 0 && k <= 9);
                         } else if (value === '5') {
                         return (k >= 0 && k <= 3);
                         }
                         break;*/
                        case 't':
                            var inputValue = input.val();
                            var year = inputValue.substring(0, 4);
                            var month = inputValue.substring(5, 7);
                            var day = new Date(year, month, 0).getDate();
                            var fDay = (day + "").split("")[0];
                            var k = parseFloat(charValue);
                            return k >= 0 && k <= fDay;
                            break;
                        default:
                            return new RegExp(exp).test(charValue);
                    }
                }

                function shiftL(begin,end) {
                    if(begin<0)
                        return;
                    for (var i = begin,j = seekNext(end); i < len; i++) {
                        if (tests[i]) {
                            if (j < len && compare(tests[i], buffer[j], i)) {
                                buffer[i] = buffer[j];
                                buffer[j] = settings.placeholder;
                            } else
                                break;
                            j = seekNext(j);
                        }
                    }
                    writeBuffer();
                    var temp = firstNonMaskPos > begin ? firstNonMaskPos : begin;
                    input.caret(temp);
                }

                function shiftR(pos) {
                    for (var i = pos, c = settings.placeholder; i < len; i++) {
                        if (tests[i]) {
                            var j = seekNext(i);
                            var t = buffer[i];
                            buffer[i] = c;
                            if (j < len && compare(tests[j], t, j))
                                c = t;
                            else
                                break;
                        }
                    }
                }

                function keydownEvent(e) {
                    var k=e.which;
                    //backspace, delete, and escape get special treatment
                    if(k == 8 || k == 46 || (iPhone && k == 127)){
                        var pos = input.caret(),
                            begin = pos.begin,
                            end = pos.end;

                        if(end-begin==0){
                            begin=k!=46?seekPrev(begin):(end=seekNext(begin-1));
                            end=k==46?seekNext(end):end;
                        }
                        clearBuffer(begin, end);
                        shiftL(begin,end-1);

                        return false;
                    } else if (k == 27) {//escape
                        input.val(focusText);
                        input.caret(0, checkVal());
                        return false;
                    }
                }

                function keypressEvent(e) {
                    var k = e.which,
                        pos = input.caret();
                    if (e.ctrlKey || e.altKey || e.metaKey || k<32) {//Ignore
                        return true;
                    } else if (k) {
                        if(pos.end-pos.begin!=0){
                            clearBuffer(pos.begin, pos.end);
                            shiftL(pos.begin, pos.end-1);
                        }

                        var p = seekNext(pos.begin - 1);
                        if (p < len) {
                            var c = String.fromCharCode(k);
                            if (compare(tests[p], c, p)) {
                                shiftR(p);
                                buffer[p] = c;
                                writeBuffer();
                                var next = seekNext(p);
                                input.caret(next);
                                if (settings.completed && next >= len)
                                    settings.completed.call(input);
                            }
                        }
                        return false;
                    }
                }

                function clearBuffer(start, end) {
                    for (var i = start; i < end && i < len; i++) {
                        if (tests[i])
                            buffer[i] = settings.placeholder;
                    }
                }

                function writeBuffer() {
                    return input.val(buffer.join('')).val();
                }

                function checkVal(allow) {
                    //try to place characters where they belong
                    var test = input.val();
                    var lastMatch = -1;
                    for (var i = 0, pos = 0; i < len; i++) {
                        if (tests[i]) {
                            buffer[i] = settings.placeholder;
                            while (pos++ < test.length) {
                                var c = test.charAt(pos - 1);
                                if (compare(tests[i], c, i) !== false) {
                                    buffer[i] = c;
                                    lastMatch = i;
                                    break;
                                }
                            }
                            if (pos > test.length){
                                break;
                            }
                        } else if (buffer[i] == test.charAt(pos) && i!=partialPosition) {
                            pos++;
                            lastMatch = i;
                        }
                    }
                    if (!allow && lastMatch + 1 < partialPosition) {
                        input.val("");
                        clearBuffer(0, len);
                    } else if (allow || lastMatch + 1 >= partialPosition) {
                        writeBuffer();
                        if (!allow) input.val(input.val().substring(0, lastMatch + 1));
                    }
                    return (partialPosition ? i : firstNonMaskPos);
                }

                input.data(C.UI.InputMask.dataName,function(){
                    return $.map(buffer, function(c, i) {
                        return tests[i]&&c!=settings.placeholder ? c : null;
                    }).join('');
                });

                if (!input.attr("readonly"))
                    input
                        .one("unmask", function() {
                            input
                                .unbind(".mask")
                                .removeData(C.UI.InputMask.dataName);
                        })
                        .bind("focus.mask", function() {
                            focusText = input.val();
                            var pos = checkVal();
                            writeBuffer();
                            var moveCaret=function(){
                                if (pos == mask.length)
                                    input.caret(0, pos);
                                else
                                    input.caret(pos);
                            };
                            ($.browser.msie ? moveCaret:function(){setTimeout(moveCaret,0)})();
                        })
                        .bind("blur.mask", function() {
                            checkVal();
                            if (input.val() != focusText)
                                input.change();

                            //判断是否有回调函数，存在则执行。
                            if (settings.callback) {
                                settings.callback();
                            }
                        })
                        .bind("keydown.mask", keydownEvent)
                        .bind("keypress.mask", keypressEvent)
                        .bind(pasteEventName, function() {
                            setTimeout(function() { input.caret(checkVal(true)); }, 0);
                        });

                checkVal(); //Perform initial check for existing values
            });
        },

        /**
         * 旧版格式控制，已经弃用，因向下兼容需要，保留
         * @param n
         * @param prefix
         */
        scrapNumFormat: function(n, prefix) {
            var $el = this, oldValue = $el.val();

            var formatNum = function(num, n, prefix){
                var numStr = num.toString(),
                    pointIndex = numStr.indexOf('.'),
                    beforePoint,
                    afterPoint;
                if(pointIndex < 0){
                    beforePoint = numStr;
                    afterPoint = '';
                }else{
                    beforePoint = numStr.substring(0, pointIndex);
                    if(typeof n == 'undefined'){
                        afterPoint = numStr.substring(pointIndex);
                    }else{
                        afterPoint = numStr.substring(pointIndex, pointIndex + n + 1);
                    }
                }
                var re = /(-?\d+)(\d{3})/;
                while(re.test(beforePoint)){
                    beforePoint = beforePoint.replace(re,"$1,$2");
                }

                return prefix ? prefix + beforePoint + afterPoint : beforePoint + afterPoint;

            };

            var checkInput = function(){
                var val = $el.val();
                if(!val.match(/^[\+\-]?\d*?\.?\d*?$/)){
                    $el.val(oldValue);
                } else {
                    oldValue = val;
                }
            };

            var doBlur = function() {
                $el.val(formatNum($el.val(), n, prefix));
            };

            var doFocus = function() {
                var value = $el.val();
                if(prefix){
                    value = value.replace(prefix, '');
                }
                value = value.replace(/,/g, '');
                $el.val(value);
                checkInput();
            };

            if (!$el.attr("readonly")) {
                $el.one('unmask', function() {
                    $el.unbind(".mask");
                })
                    .bind('keyup.mask', checkInput)
                    .bind(pasteEventName, checkInput)
                    .bind('blur.mask', doBlur)
                    .bind('focus.mask', doFocus);
            }

        },

        /**
         * 数字类格式控制
         * @param mask {String} 格式名称
         * @param masker {Object} 格式配置参数
         */
        numberFormat: function(mask, masker){
            var $el = this, oldValue = $el.val();
            if(!/^[-\d\.]*$/.test(oldValue)){
                $el.val('');
                oldValue = '';
                return;
            }

            var formatNum = function(num, precision, prefix, separator){
                var numStr = num.toString(),
                    pointIndex, beforePoint, afterPoint,
                    re = /(-?\d+)(\d{3})/;
                //金额四舍五入，采用字符操作
                if(mask === 'Money' && precision !== null && precision !== 'null'){
                    numStr = C.Number.round(numStr, precision - 0) || numStr;
                }

                //如果组件使用了emptyText，且设置了mask，这里需要过滤，中文的时候直接返回中文
                if(typeof C.Number.round(numStr) === 'undefined'){
                    return numStr;
                }

                pointIndex = numStr.indexOf('.');
                if(pointIndex < 0){
                    beforePoint = numStr;
                    afterPoint = '';
                }else{
                    beforePoint = numStr.substring(0, pointIndex);
                    switch (precision){
                        case 'null':
                        case null:
                            afterPoint = numStr.substring(pointIndex);
                            break;
                        case '0':
                            afterPoint = '';
                            break;
                        default:
                            afterPoint = numStr.substring(pointIndex, pointIndex + precision + 1);
                    }
                }

                //分隔符替换
                if(!!separator || separator !== ''){
                    while(re.test(beforePoint)){
                        beforePoint = beforePoint.replace(re,'$1' + separator + '$2');
                    }
                }
                //追加0值小数
                if(precision > 0){
                    if(/\./.test(afterPoint)){
                        precision = precision - (afterPoint.length - 1);
                    }
                    for (var i = 0; i < precision; i++) {
                        afterPoint += '0';
                    }
                    if(!/\./.test(afterPoint)){
                        afterPoint = '.' + afterPoint;
                    }
                }

                return prefix ? prefix + beforePoint + afterPoint : beforePoint + afterPoint;

            };
            var regList = {
                intReg: /^[\+\-]?([1-9]\d*|0)?$/,
                numReg: /^\d*$/,
                decReg:    /^[\+\-]?([1-9]\d*\.?\d*?|0\.\d*?|0)?$/,
                moneyReg : /^[\+\-]?([1-9]\d*\.?\d*?|0\.\d*?|0)?$/
            };
            if(masker.negative === false && mask === "Money"){ //money can not be negative
                regList.moneyReg=/^([1-9]\d*\.?\d*?|0\.\d*?|0)?$/;
            }
            var checkInput = function(){
                var val = $el.val();
                if(!regList[mask.toLocaleLowerCase() + 'Reg'].test(val)){
                    $el.val(oldValue);
                } else {
                    oldValue = val;
                }
            };

            var doBlur = function() {
                var val = $el.val();
                $el.data("orgValue", val);//缓存原始值
                if($.trim(val) === ''){
                    return;
                }

                var formatVal = formatNum(val, masker.precision, masker.prefix, masker.separator);
                if(/^[\-\+]$/.test(val)){
                    formatVal = '';
                }
                $el.val(formatVal);
            };

            var doFocus = function() {
                if($el.prop('readonly')){
                    return;
                }
                var value = $.trim($el.val()) === '' ? '' : ($el.data("orgValue") || '');
                if(masker.prefix){
                    value = value.replace(masker.prefix, '');
                }

                value = value.replace(/,/g, '');

                if($.trim(value) === ''){
                    $el.val('');
                }else{
                    $el.val(value);
                }

                if(C.Browser.isIE){
                    var rng = $el.get(0).createTextRange();
                    rng.move("textedit");
                    rng.select();
                }
                checkInput();
            };
            if(oldValue !== ''){
                doBlur();
            }

            //if (!$el.attr("readonly")) {
                $el.one('unmask', function() {
                    $el.unbind(".mask");
                }).unbind(".mask")
                    .bind('keyup.mask', checkInput)
                    .bind(pasteEventName, checkInput)
                    .bind('blur.mask', doBlur)
                    .bind('focus.mask', doFocus);
            //}
        }
    });

    // $.mask不允许对外公开，但旧版本已经对外公开，这里保留兼容
    $.mask = {};
    $.mask.definitions = C.UI.InputMask.definitions;
})(window.comtop.cQuery, window.comtop);