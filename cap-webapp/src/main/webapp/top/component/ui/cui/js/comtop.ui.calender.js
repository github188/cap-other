/**
 * Calender
 * Author: chaoqun.lin
 * Date: 2013-01-06
 * Version: 2.1.1
 */
;(function ($, C) {
    var calers = null;//已经打开的日期组件
    C.UI.Calender = C.UI.Base.extend({
        options: {
            uitype: 'Calender',
            name: '',
            //id: '',
            model: 'date',              //功能模式，默认值为 date，值有[date|year|quarter|month|time|all]，
            //分别代表[选择日期|选择年份|选择季度|选择月份|选择时间|所有功能]
            isrange: false,             //是否开启范围选择
            trigger: 'click',           //触发事件，默认为click
            value: [],                  //默认日期，存放日期
            format: '',                 //输出格式，如果model为all，format可为数组 ['yyyy-MM-dd','yyyy年第q季度']
            entering: false,            //文本框是否可以输入
            emptytext: '',              //空文本提示
            readonly: false,            //是否可读
            disable: false,             //是否不可用
            icon: true,                 //是否提供图标点击打开日期组件
            textmode: false,            //是否开启文本模式
            panel: 1,                   //显示供选择的月份版块，默认为1
            zindex: 11000,               //层级控制
            width: '200px',             //输入框宽度
            okbtn: false,               //是否启用okbtn，启用okbtn后，需要点击确定才能让选择的值传至输入框
            clearbtn: true,                //是否启用清空按钮
            mindate: null,                  //最小日期
            maxdate: null,                  //最大日期
            nocurrent: false,           //最大最小日期，是否包含当天/当月/当年，默认为包含
            iso8601: false,             //是否启用iso8601标准，开启此标准后，每周默认第一天为星期一，每年的第一个星期四所在的周为第一周
            on_change: null,            //回调函数，在点选日期后执行
            separator: false,           //区间模式下，单日期是否保留间隔符号
            sunday_first: false         //每周的第一天是否是星期天，默认是星期一
        },

        tipPosition: '.C_CR_calInput_bd',  //必须是占位符内的元素

        /**
         * 自定义初始化，数据准备
         * @param {Object} cusOpts 自定义配置参数
         * @private
         */
        _init: function (cusOpts) {
            var self = this,
                opts = self.options;

            if(cusOpts.value){
                var type = $.type(cusOpts.value);
                switch(type){
                    case 'string':
                        opts.value = /^(?:\{.*\}|\[.*\])$/.test(cusOpts.value) ?
                            $.parseJSON(cusOpts.value.replace(/\\'/g, '#@@#').replace(/'/g, '"').replace(/#@@#/g, '\'')):
                            [cusOpts.value];
                        break;
                    case 'array':
                        opts.value = cusOpts.value;
                        break;
                    default:
                        opts.value = [cusOpts.value];
                }
            }
            if(cusOpts.width){
                if(typeof cusOpts.width === 'string' && /^(\d)+(px|pt|em|PX|PT|EM|%)$/.test(cusOpts.width)){
                    opts.width = cusOpts.width;
                }else {
                    opts.width = cusOpts.width + 'px';
                }
            }
            opts.value = opts.value === null ? [] : opts.value;
            //[最大最小限制规则, 生成的限制日期]
            opts.mindate = [cusOpts.mindate, null];
            opts.maxdate = [cusOpts.maxdate, null];

            //下面的参数不开放配置
            opts.uuid = C.guid();                           //组件内部随机ID
            opts.template = 'calender.html';                //模板名称
            opts.curModel = [];                             //默认当前模型，这四个数据为后面常用，所以存放起来，方便使用
            opts.formatList = {                             //默认格式
                date: 'yyyy-MM-dd',
                year: 'yyyy',
                quarter: 'yyyy-q',
                month: 'yyyy-MM',
                week: 'yyyy-w'
            };
            opts.inputFocusClass = 'C_CR_calInput_focus';   //输入框获焦样式
            opts.inputDisClass = 'C_CR_calInput_rd';        //输入框不可用样式
            opts.inputErrClass = 'C_CR_calInput_err';       //输入框报错样式
            opts.selDate = [];                              //选择的日期
            opts.cache = {                                  //缓存
                yearPop: {},
                selDate: []
            };
            opts.isBuild = false;                           //是否创建组件DOM
            opts.inputEl = null;                            //当前输入框
            opts.tipTxt = null;                             //组件tip文本
            opts.pEl = null;                                //日期层JQ对象
            opts.datePanel = [];                            //日期模式数据
            opts.yearPanel = [];                            //年度模式数据
            opts.monthPanel = [];                           //月份模式数据
            opts.quarterPanel = [];                         //季度模式数据
            opts.timePanel = [];                            //时间模式数据
            opts.weekPanel = [];
            opts.yearPop = {                                //YMer条数据
                forDate: [],
                forYear: [],
                forQuarter: [],
                forMonth: [],
                forWeek: []
            };
            opts.selIndex = 0;                              //当前活动输入框索引号
            opts.activePop = null;                          //当前活动的POP层，用于关闭
            opts.isChangeTag = false;                       //是否执行了标签切换
            self.$tmp = {};                                 //装放jquery对象

            //生成当前功能模式
            var curModel = opts.model === 'all' ? 'date' : opts.model;
            opts.curModel = [
                curModel, 'for' + curModel.charAt(0).toUpperCase() + curModel.substring(1),
                    curModel + 'Frame', curModel + 'Panel'
            ];

            //初始化格式
            if(opts.model === 'all' && cusOpts.format){
                opts.format = $.parseJSON(cusOpts.format.replace(/\\'/g, '#@@#').replace(/'/g, '"').replace(/#@@#/g, '\''));
                opts.formatList = $.extend(opts.formatList, opts.format);
                opts.format = opts.formatList[opts.curModel[0]];
            }else if(!cusOpts.format){
                opts.format = opts.formatList[opts.curModel[0]];
            }else{
                opts.formatList[opts.curModel[0]] = opts.format;
            }
            //如果格式只是输出时分秒，则确定按钮是必须要显示的
            opts.okbtn = /[y|M|q|w|d]/.test(opts.format) ? opts.okbtn : true;
        },

        /**
         * 自定义操作
         * @private
         */
        _create: function () {
            var self = this,
                opts = self.options;

            opts.inputEl = opts.el.find(':text').bind('click', function(){
                if(opts.readonly){
                    return;
                }
                self.show();
                $(this).parents('.C_CR_calInput_bd').addClass(opts.inputFocusClass);

                //获焦清空提示文字
                self._setEmptyText(false);

                //获焦时去掉错误认证信息
                self.onValid();
            }).bind('mouseup.calender', function(e){
                e.stopPropagation();
            });

            //获取默认日期
            self._getDefault();
            self.setValue($.extend(true, [], opts.selDate), true);

            //查找空日期的位置
            for(var i = 0; i < opts.cache.selDate.length; i ++){
                if(opts.cache.selDate[i] === null){
                    opts.selIndex = i;
                    break;
                }
            }

            //不可读或不可用处理
            if(opts.disable || opts.readonly){
                opts.el.children('.C_CR_calInput_bd').addClass(opts.inputDisClass);
            }
            if(!opts.entering || opts.disable || opts.readonly){
                if(opts.disable){
                    opts.inputEl.attr('disabled', true);
                }
                if(opts.readonly || !opts.entering){
                    opts.inputEl.attr('readonly', true);
                }
            }

            //如果允许输入
            if(opts.entering){
                self._enter();
            }
        },

        /**
         * 手动输入格式化
         * @private
         */
        _enter: function(){
            var self = this,
                opts = self.options,
                format = opts.format,
                fullFormat = opts.format,
                repFormat = function(fm, st){
                    var reg = [/y+/,/M+/,/d+/,/h+/,/m+/,/s+/,/w+/,/q+/];
                    for(var i = 0; i < reg.length; i ++){
                        fm = fm.replace(reg[i], st[i]);
                    }
                    return fm;
                };

            format = repFormat(format, ['9999', '1x', '3z', '2r', '59', '59', '5k', 'q']);
            fullFormat = repFormat(fullFormat, ['yyyy', 'MM', 'dd', 'hh', 'mm', 'ss', 'ww', 'q']);

            opts.inputEl.data('fmOpts', {
                format: opts.format,
                fullFormat: fullFormat,
                isRange: opts.isrange,
                okBtn: opts.okbtn,
                separator: opts.separator
            }).unmaskCL().maskCL(opts.isrange ? format + '~' + format : format);
        },

        /**
         * 获取默认数据，默认数据的来源有两个：options和input
         * @private
         */
        _getDefault: function () {
            var self = this,
                opts = self.options,
                def = [];

            if(opts.value.length !== 0){
                //获取options的默认值
                def = opts.value;
            }else{
                //获取input的默认值
                if(opts.isrange){
                    def = $.trim(opts.inputEl.eq(0).val()).split('~');
                    def = !def.join('') ? [null, null] : def;
                }else{
                    $.each(opts.inputEl, function(i, inp){
                        def.push($.trim($(this).val()));
                    });
                }
            }
            opts.selDate = _contrastDate(_analysis(def, opts.format));
        },

        /**
         * 创建数据（DOM界面的数据都来自这里）
         * @param {Array} dataSource
         * @param {Number} index
         * @private
         */
        _buildData: function (dataSource, index) {
            var self = this,
                opts = self.options,
                date, m, tmpTime, i, tmpYear, reLoadYM;

            if(opts.isBuild){
                if(index === undefined){
                    opts[opts.curModel[3]] = [];
                    opts.yearPop[opts.curModel[1]] = [];
                }else{
                    //判断是否需要更新年弹出选择面板的数据
                    reLoadYM = !self._isReady('yearPop', index);
                    opts[opts.curModel[3]][index] = [];
                    if(reLoadYM){
                        opts.yearPop[opts.curModel[1]][index] = [];
                    }
                }
            }

            //根据面板数量创建对应的数据，供创建DOM结构使用
            if((!opts.isBuild && opts.model === 'all') || opts.curModel[0] === 'date'){
                if(index === undefined){
                    for(i = 0; i < opts.panel; i ++){
                        date = dataSource[i] ?
                            new Date(dataSource[i][0], dataSource[i][1], 1):
                            new Date(date.getFullYear(), date.getMonth() + 1, 1);
                        opts.yearPop.forDate.push(_getPanelYear(date.getFullYear() - 4, 12));
                        opts.datePanel.push(_getPanelDate.call(self, date));
                    }
                }else{
                    date = new Date(dataSource[0][0], dataSource[0][1], 1);
                    reLoadYM && (opts.yearPop.forDate[index] = _getPanelYear(date.getFullYear() - 4, 12));
                    opts.datePanel[index] = _getPanelDate.call(self, date);
                }
            }
            if((!opts.isBuild && opts.model === 'all') || opts.curModel[0] === 'year'){
                if(index === undefined){
                    for(i = 0; i < opts.panel; i ++){
                        tmpYear = dataSource[i] ? dataSource[i][0] :
                            opts.yearPanel[i - 1].data[11] + 14;
                        opts.yearPop.forYear.push(_getPanelYear(tmpYear - 4, 12));
                        opts.yearPanel.push({year:tmpYear, month:null, data:_getPanelYear(tmpYear - 7, 18)});
                    }
                }else{
                    tmpYear = dataSource[0][0];
                    reLoadYM && (opts.yearPop.forYear[index] = _getPanelYear(tmpYear - 4, 12));
                    opts.yearPanel[index] = {year:tmpYear, month:null, data:_getPanelYear(tmpYear - 7, 18)};
                }
            }
            if((!opts.isBuild && opts.model === 'all') || opts.curModel[0] === 'month'){
                if(index === undefined){
                    for(i = 0; i < opts.panel; i ++){
                        tmpYear = dataSource[i] ? dataSource[i][0] :
                            opts.monthPanel[i - 1].year + 1;
                        opts.yearPop.forMonth.push(_getPanelYear(tmpYear - 4, 12));
                        opts.monthPanel.push({year:tmpYear, month:null, data:_getPanelMonth()});
                    }
                }else{
                    tmpYear = dataSource[0][0];
                    reLoadYM && (opts.yearPop.forMonth[index] = _getPanelYear(tmpYear - 4, 12));
                    opts.monthPanel[index] = {year:tmpYear, month:null, data:_getPanelMonth()};
                }
            }
            if((!opts.isBuild && opts.model === 'all') || opts.curModel[0] === 'quarter'){
                if(index === undefined){
                    for(i = 0; i < opts.panel; i ++){
                        tmpYear = dataSource[i] ? dataSource[i][0] :
                            opts.quarterPanel[i - 1].year + 1;
                        opts.yearPop.forQuarter.push(_getPanelYear(tmpYear - 4, 12));
                        opts.quarterPanel.push({year:tmpYear, month:null, quarter: [1,2,3,4]});
                    }
                }else{
                    tmpYear = dataSource[0][0];
                    reLoadYM && (opts.yearPop.forQuarter[index] = _getPanelYear(tmpYear - 4, 12));
                    opts.quarterPanel[index] = {year:tmpYear, month:null, quarter: [1,2,3,4]};
                }
            }
            if((!opts.isBuild && opts.model === 'all') || opts.curModel[0] === 'date'){
                var len;
                opts.timePanel = [];
                len = opts.isrange ? 2 :1;
                for(m = 0; m < len; m ++){
                    tmpTime = opts.cache.selDate[m] ? opts.cache.selDate[m] : _getDateArray(new Date(), opts.format);
                    opts.timePanel.push([tmpTime[5], tmpTime[6], tmpTime[7]]);
                }
            }
            if((!opts.isBuild && opts.model === 'all') || opts.curModel[0] === 'week'){
                var weekData;
                if(index === undefined){
                    for(i = 0; i < opts.panel; i ++){
                        if(dataSource[i]){
                            weekData = C.Date.getOnWeek(new Date(dataSource[i][0],dataSource[i][1] > 0 ? dataSource[i][1] : 1,
                                    dataSource[i][2] || 1), opts.iso8601, opts.sunday_first);
                        }
                        tmpYear = dataSource[i] ? weekData.year : opts.weekPanel[i - 1].year + 1;
                        opts.yearPop.forWeek.push(_getPanelYear(tmpYear - 4, 12));
                        opts.weekPanel.push({year:tmpYear, month:null, data:_getPanelWeek(tmpYear,opts.iso8601,opts.sunday_first)});
                    }
                }else{
                    tmpYear = dataSource[0][0];
                    reLoadYM && (opts.yearPop.forWeek[index] = _getPanelYear(tmpYear - 4, 12));
                    opts.weekPanel[index] = {year:tmpYear, month:null, data:_getPanelWeek(tmpYear,opts.iso8601,opts.sunday_first)};
                }
            }
            //缓存最初的yearPop数据
            opts.cache.yearPop = $.extend(true, {},opts.yearPop);
        },

        /**
         * 更新/创建数据参数计算
         * @return {Array}
         * @private
         */
        _buildUpdateDate: function(){
            var self = this,
                opts = self.options,
                min, max,
                curDate = new Date(), dataList = [], i, data = [];
            //绕过最大最小区域
            if(opts.model === 'date'){
                min = _getLimitDate.call(self, 'mindate');
                max = _getLimitDate.call(self, 'maxdate');
                min = opts.mindate[0] !== undefined ? min : 0;
                curDate = min === 0 ? curDate : min - curDate > 0 ? min : curDate;
                max = opts.maxdate[0] !== undefined ? max : 0;
                curDate = max === 0 ? curDate : max - curDate < 0 ? max : curDate;
                curDate = curDate || new Date();
            }
            curDate = _getDateArray(curDate, opts.format);
            for(i = 0; i < opts.cache.selDate.length; i ++){
                if(i === 0){
                    data.push(opts.cache.selDate[i] ? opts.cache.selDate[i] : curDate);
                    dataList.push([data[i][2], data[i][3], data[i][4]]);
                }else{
                    if(opts.cache.selDate[i]){
                        data.push(opts.cache.selDate[i]);
                        dataList.push([data[i][2], data[i][3], data[i][4]]);
                    }
                }
            }
            return dataList;
        },

        /**
         * 创建框架DOM结构
         * @private
         */
        _draw: function () {
            var self = this,
                opts = self.options;
            //创建组件数据
            self._buildData(self._buildUpdateDate());
            self._buildTemplate('body', 'calFrame', $.extend(true,{},opts), true);  //32-48mm
            opts.pEl = $('#C_CR_' + opts.uuid);
        },

        /**
         * 创建/更新年子面板
         * @param {String} model 更新的模型名称数组
         * @param {Number} index YMer索引号
         * @private
         */
        _drawYearPop: function(model, index){
            var self = this,
                opts = self.options,
                data,
                $yearPops = opts.pEl.children('.C_CR_YM_wrap').find('div.C_CR_YMer_pop_y');
            //生成数据名
            data = opts.yearPop[model] || [];
            if(typeof index !== 'undefined'){
                self._buildTemplate($yearPops.eq(index), 'yearPopFrame', data[index]);
            }else{
                for(var i = 0; i < data.length; i ++){
                    self._buildTemplate($yearPops.eq(i), 'yearPopFrame', data[i]);
                }
            }
        },

        //====================================================事件处理================================================

        /**
         * 标签切换事件处理
         * @param e
         * @param eventEl
         * @param target
         * @private
         */
        _tagEventHandle: function (e, eventEl, target){
            e.stopPropagation();
            var self = this,
                opts = self.options,
                nodeName = target.nodeName;
            _domPopHandle.call(self);
            if(nodeName === 'A'){
                var $tg = $(target),
                    curModel = $tg.attr('val');
                $tg.parents('ul').find('a').removeClass('C_CR_Tag_cur');
                $tg.addClass('C_CR_Tag_cur');
                opts.curModel = [
                    curModel, 'for' + curModel.charAt(0).toUpperCase() + curModel.substring(1),
                        curModel + 'Frame', curModel + 'Panel'
                ];
                //切换时清空选择
                opts.cache.selDate = [];
                opts.isChangeTag = true;
                self._selectTag(opts.curModel);
            }
        },

        /**
         * binder事件处理
         * @param e
         * @param eventEl
         * @param target
         * @private
         */
        _binderHandler: function (e, eventEl, target){  //328mm
            e.stopPropagation();
            var self = this,
                opts = self.options,
                nodeName = target.nodeName;
            if(opts.readonly || opts.disable){
                return;
            }

            //多次点击同一个触发点，只执行一次show
            if (opts.el.attr('isShow') === 'true') {
                return;
            }
            opts.el.attr('isShow', 'true');

            if(nodeName !== 'INPUT'){
                opts.inputEl.click();
            }
        },

        /**
         * 日期选择部件事件处理
         * @param e
         * @param eventEl
         * @param target
         * @private
         */
        _mainEventHandle: function (e, eventEl, target) {
            e.stopPropagation();
            var self = this,
                $tg = $(target),
                nodeName = $tg[0].nodeName;
            _domPopHandle.call(self);
            if (nodeName !== 'A') {
                return;
            }
            var val = $tg.attr('val').split('|');
            for(var i = 0; i < val.length; i ++){
                val[i] = + val[i];
            }
            self._cachingDate(val, $tg);
        },

        /**
         * 年月选择部件事件处理
         * @param e
         * @param eventEl
         * @param target
         * @private
         */
        _ymEventHandle: function (e, eventEl, target) {
            e.stopPropagation();
            var self = this,
                opts = self.options,
                $tg = $(target),
                nodeName = $tg[0].nodeName,
                val, popIndex;
            //根据target的不同引流至不同的处理点
            if (nodeName === 'A') {
                val = $tg.attr('val');
                popIndex = + $tg.parents('.C_CR_YMer_item:eq(0)').attr('popIndex');
                switch (val) {
                    case 'prevMonth':
                        _domPopHandle.call(self);
                        opts.curModel[0] === 'date' ?
                            self._selectMonthYear('month', null, null, -1):
                                opts.curModel[0] === 'year' ? self._selectMonthYear('year', null, null, -18) :
                            self._selectMonthYear('year', null, null, -1);
                        break;
                    case 'nextMonth':
                        _domPopHandle.call(self);
                        opts.curModel[0] === 'date' ?
                            self._selectMonthYear('month', null, null, 1) :
                                opts.curModel[0] === 'year' ? self._selectMonthYear('year', null, null, 18) :
                            self._selectMonthYear('year', null, null, 1);
                        break;
                    case 'prevPop':
                        self._changeYear(-12, popIndex);
                        break;
                    case 'nextPop':
                        self._changeYear(12, popIndex);
                        break;
                    case 'closePop':
                        _domPopHandle.call(self);
                        break;
                    default:
                        self._closeYMerPop(true);
                        val = Number(val);
                        if ($tg.attr('panel') === 'y') {
                            self._selectMonthYear('year',val, popIndex);
                        }else{
                            self._selectMonthYear('month',val, popIndex);
                        }
                }
            }else if (nodeName === 'INPUT' || nodeName === 'SPAN') {
                $tg = $tg.children('input').size() ? $tg.children('input') : $tg;
                self._closeYMerPop(false, $tg);
                $tg.blur();
            } else{
                _domPopHandle.call(self);
            }
        },

        /**
         * 时间部件事件处理
         * @param e
         * @param eventEl
         * @param target
         * @private
         */
        _timerEventHandle: function (e, eventEl, target) {
            e.stopPropagation();
            var self = this,
                $tg = $(target),
                nodeName = $tg[0].nodeName,
                val, $pop, popType, $timePop;

            if (nodeName === 'SPAN') {
                val = $tg.attr('val');
                switch (val) {
                    case 'up':
                        self._selectTime($tg, 1);
                        break;
                    case 'down':
                        self._selectTime($tg, -1);
                        break;
                }
                _domPopHandle.call(self);
            } else if (nodeName === 'INPUT') {
                $tg.blur();
                switch ($tg.attr('val')){
                    case 'h':
                        $pop = self.$tmp.$timeHour;
                        break;
                    case 'm':
                        $pop = self.$tmp.$timeMin;
                        break;
                    case 's':
                        $pop = self.$tmp.$timeSecond;
                }
                self.$tmp.curTimeTxt = $tg;
                _domPopHandle.call(self, $pop);
            } else if (nodeName === 'A') {
                //如果点击的是上下时间的操作
                if($tg.attr('class') === 'C_CR_Timer_up' || $tg.attr('class') === 'C_CR_Timer_down'){
                    $tg = $tg.children('span');
                    val = $tg.attr('val');
                    switch (val) {
                        case 'up':
                            self._selectTime($tg, 1);
                            break;
                        case 'down':
                            self._selectTime($tg, -1);
                            break;
                    }
                    _domPopHandle.call(self);
                    return;
                }
                //下面是点击面板时的操作
                val = $tg.attr('val');
                if(self.$tmp.curTimeTxt){
                    self.$tmp.curTimeTxt.val(val < 10 ? '0' + val : val);
                }
                _domPopHandle.call(self);
            }
        },

        /**
         * 按钮部件事件处理
         * @param e
         * @param eventEl
         * @param target
         * @private
         */
        _btnEventHandle: function(e, eventEl, target){
            e.stopPropagation();
            var self = this,
                opts = self.options,
                $tg = $(target),
                val = $tg.attr('val'),
                tmpDateArray;
            _domPopHandle.call(self);
            switch (val){
                case 'close':
                    self.hide();
                    break;
                case 'cur':
                    var now = new Date(),
                        dateArray = _getDateArray(now, opts.format);
                    if(opts.curModel[0] === 'quarter'){
                        self._cachingDate([dateArray[2], Math.floor(dateArray[3] / 3) + 1, 1]);
                    }else if(opts.curModel[0] === 'week'){
                        self._cachingDate([dateArray[2], C.Date.getOnWeek(new Date(dateArray[0]), opts.iso8601, opts.sunday_first).week]);
                    }else{
                        self._cachingDate([dateArray[2], dateArray[3], dateArray[4]]);
                    }
                    break;
                case 'clear':
                    _domFocusHandle.call(self, null, 'clear', null);
                    opts.selIndex = 0;
                    self.setValue(opts.isrange ? ['',''] : ['']);
                    if(opts.entering && typeof opts.inputEl.data('fmOpts').clearBuffer === 'function'){
                        opts.inputEl.data('fmOpts').clearBuffer(0, opts.inputEl.data('fmOpts').buffer.length);
                    }
                    break;
                case 'ok':
                    //如果只输出时分秒，按下确定时，将输出当天选定的时间
                    if(opts.curModel[0] === 'date'){
                        tmpDateArray = _getDateArray(new Date, opts.format);
                        opts.cache.selDate = /[y|M|q|w|d]/.test(opts.format) ? opts.cache.selDate :
                            opts.isrange ? [tmpDateArray, tmpDateArray] : [tmpDateArray];
                    }
                    self._export();
            }
        },

        //====================================================功能====================================================
        /**
         * 标签切换
         * @param {Array} model 模型名称数组
         * @private
         */
        _selectTag: function(model) {
            var self = this,
                opts = self.options,
                $main = opts.pEl.children('.C_CR_main_wrap'),
                $load = $main.children('.C_CR_main_loading'),
                $tgWrap = $main.children('.C_CR_main_panel[val='+ model[0] +']'),
                $siblings = $tgWrap.siblings(),
                isBuild = $tgWrap.attr('isBuild') === 'true',
                timeCtrl = [];
            opts.cache.selDate = $.extend(true, [], opts.selDate);
            opts.format = opts.formatList[model[0]];

            //隐藏所有主面板
            $siblings.hide();
            //显示加载等待提示
            $load.show();
            //控制年月选择工具条功能
            if(model[0] !== 'all' && model[0] !== 'date'){
                _domYMerHandle(opts.pEl, 'disMonth');   //年/月/季度模式下月份选择禁用
            }else{
                _domYMerHandle(opts.pEl, 'undo');
            }
            //主面板切换
            if(( !isBuild)){
                self._buildTemplate($tgWrap, model[2], opts);  //16~32MM
                $tgWrap.attr('isBuild', 'true');
            }else if(isBuild && !self._isReady('mainPanel')){
                self._update(self._buildUpdateDate());
            }else{
                _domFocusHandle.call(self, null, 'clear', null);
            }
            $load.hide();
            $tgWrap.show();
            //控制按钮区
            _domBtnHandle.call(self);
            //加载时间区
            if(!opts.isBuild){
                //生成时间
                if(opts.model === 'all' || (model[0] === 'date' && /[h|m|s]/.test(opts.format))){
                    self._buildTemplate(opts.pEl.children('.C_CR_Timer_box'), 'timeFrame', opts);
                    _domTimeInit.call(self);
                }
            }
            //时间控制
            _domTimeHandle.call(self);
            if(opts.model === 'all'){
                _domSetWidth(opts);
                _domResetPos(opts);
            }
            //更新YMer的Label
            self._setYM(model[0]);
            self._scanFocus();
            //关闭所有POP
            opts.isBuild && _domPopHandle.call(self);

            //如果允许输入
            if(opts.entering && opts.isChangeTag){
                self._clear();
                self._enter();
                opts.isChangeTag = false;
            }
        },

        /**
         * 切换年/月
         * @param {String} type 类型，是切换年或月'month'/'year'
         * @param {Number} source 原值
         * @param {Number} index 操作对象索引号
         * @param {Number} step 更新幅度
         * @private
         */
        _selectMonthYear: function(type, source, index, step){
            var self = this,
                opts = self.options,
                data, $YMer,
                dataList = [],
                tyIndex = type === 'month' ? 1 : 0;
            $YMer = $('table.C_CR_YMer', opts.pEl);
            if(typeof index !== 'undefined' && index != null){
                getDate(index);
            }else{
                for(var i = 0; i < $YMer.length; i ++){
                    getDate(i);
                }
            }
            self._update(dataList ,index);
            function getDate(i){
                data = $YMer.eq(i).attr('val').split('|');
                data[tyIndex] = typeof step !== 'undefined' ? Number(data[tyIndex]) + step : source;
                dataList.push([Number(data[0]), Number(data[1])]);
            }
        },

        /**
         * 时间设定
         * @param {jQuery} $tg 点击JQ对象
         * @param {Number} step 更新幅度
         * @private
         */
        _selectTime: function($tg, step){
            var val, $opWrap, $input, sumStep;
            $opWrap = $tg.parents('.C_CR_Timer_op').eq(0);
            $input = $opWrap.prev().children('input');
            val = + $.trim($input.val());
            sumStep = val + step;

            if($input.attr('name') === 'timer_h'){
                if(sumStep > 23){
                    sumStep = 0;
                }else if(sumStep < 0){
                    sumStep = 23;
                }
            }else{
                if(sumStep > 59){
                    sumStep = 0;
                }else if(sumStep < 0){
                    sumStep = 59;
                }
            }

            sumStep = String(sumStep);

            $input.val(sumStep.length === 1 ? (0 + sumStep) : sumStep);
        },

        /**
         * 选择日期
         * @param {Array} val 值
         * @param {jQuery} $tg JQ对象
         * @private
         */
        _cachingDate: function (val, $tg) {
            var self = this,
                opts = self.options,
                time = null,
                date = null,
                selDate = null;

            if (!opts.isrange) {
                self._clear(opts.okbtn);
            } else {
                (opts.selIndex === 2 || opts.selIndex === 0) && self._clear(opts.okbtn);
            }
            switch (opts.curModel[0]){
                case 'date':
                    time = self._getTime(opts.selIndex);
                    date = new Date(val[0], val[1], val[2], time[0], time[1], time[2]);
                    break;
                case 'year':
                    date = new Date(val[0], 0, 1);
                    break;
                case 'month':
                    date = new Date(val[0], val[1], 1);
                    break;
                case 'quarter':
                    date = new Date(val[0], (val[1] - 1) * 3, 1);
                    break;
                case 'week':
                    date = C.Date.getWeekRange(val[0], val[1], opts.iso8601, opts.sunday_first)[0];
            }
            selDate = _getDateArray(date, opts.format);
            opts.cache.selDate[opts.selIndex] = selDate;
            if(opts.isrange){
                opts.selIndex = 0;
                for(var i = 0; i < opts.cache.selDate.length; i ++){
                    if(opts.cache.selDate[i] === null){
                        opts.selIndex = i;
                        break;
                    }else{
                        opts.selIndex ++;
                    }
                }
            }else{
                opts.selIndex ++;
            }

            //获焦
            self._focus([date], 'SEL', $tg);
            opts.okbtn || self._export();
        },

        /**
         * YMer年份板块更换
         * @param {Number} range 切换范围，如，12，是指一次更换12年
         * @param {Number} index YMer索引号
         * @private
         */
        _changeYear: function (range, index) {
            var self = this,
                opts = self.options,
                yearPop = opts.yearPop[opts.curModel[1]],
                tmpYear;
            if(range > 0){
                tmpYear = _getPanelYear(yearPop[index][yearPop[index].length - 1] + 1, range);
            }else if(range < 0){
                tmpYear = _getPanelYear(yearPop[index][0] - 1, range);
            }
            opts.yearPop[opts.curModel[1]][index] = tmpYear;
            self._drawYearPop(opts.curModel[1], index);
        },

        /**
         * 获取时间
         * @param {Number} index 索引
         * @return {Array}
         * @private
         */
        _getTime: function(index){
            var self = this,
                opts = self.options,
                time = [],
                inp = null,
                $tg = $('table.C_CR_Timer', opts.pEl).eq(index);

            inp = $tg.find(':text');
            time.push(
                    + inp.eq(0).val()|| 0,
                    + inp.eq(1).val()|| 0,
                    + inp.eq(2).val()|| 0
            );

            return time;
        },

        //==================UI更新======================

        /**
         * 更新年月日DOM结构
         * @param {Array} dataSource 数据源
         * @param {Number} index 操作对象索引号
         * @private
         */
        _update: function(dataSource, index){
            var self = this,
                opts = self.options,
                updateMark;
            updateMark = opts.pEl.children('.C_CR_main_wrap').children('.C_CR_main_panel[val='+ opts.curModel[0] +']');
            if(typeof index !== 'undefined' && index !== null){
                self._buildData(dataSource, index);
            }else{
                self._buildData(dataSource, undefined);
            }
            self._buildTemplate(updateMark, opts.curModel[2], opts);
            if(opts.model === 'all' || (opts.model === 'date' && /[h|m|s]/.test(opts.format))){
                self._setTime(opts.selDate);
            }

            self._setYM(opts.curModel[0]);
            self._scanFocus();
        },

        /**
         * 设置年月
         * @param {String} model 当前功能模型
         * @private
         */
        _setYM: function(model){
            var self = this,
                opts = self.options,
                data;
            data = opts[model + 'Panel'];
            for(var i = 0, len = data.length; i < len; i ++){
                _domSetYMerLabel(opts.pEl, {
                    year: data[i].year,
                    month: data[i].month != null ? data[i].month + 1 : ''
                }, i);
            }
        },

        /**
         * 设置时间
         * @param {Array} date
         * @private
         */
        _setTime: function(date){
            var self = this,
                opts = self.options,
                $tg, $inp, h, m, s;

            $tg = $('table.C_CR_Timer', opts.pEl);
            for(var i = 0; i < $tg.length; i ++){
                $inp = $tg.eq(i).find(':text');
                if(!date[i]){
                    continue;
                }
                h = date[i][5];
                m = date[i][6];
                s = date[i][7];
                $inp.eq(0).val(h < 10 ? '0' + h : h);
                $inp.eq(1).val(m < 10 ? '0' + m : m);
                $inp.eq(2).val(s < 10 ? '0' + s : s);
            }
        },

        /**
         * 关闭YMerPop
         * @param {Boolean} isCloseAll 是否全部关闭
         * @param {jQuery} $tg  JQ对象
         * @private
         */
        _closeYMerPop: function(isCloseAll, $tg){
            var self = this,
                opts = self.options,
                popType = null,
                popIndex = null,
                $YMItem = $tg ? $tg.parents('.C_CR_YMer_item'): null;

            _domPopHandle.call(self, isCloseAll ? null : $YMItem.children('.C_CR_YMer_pop'), 'ym');

            if($YMItem){
                popType = $YMItem.attr('pop');  //弹出层类型
                popIndex = $YMItem.attr('popIndex');
            }
            if(popType === 'year'){
                if(popIndex !== '' && !self._isReady('yearPop', popIndex)){
                    opts.yearPop = $.extend(true, {}, opts.cache.yearPop);
                    setTimeout(function(){
                        self._drawYearPop(opts.curModel[1], popIndex);
                    },50);
                }
            }
        },

        /**
         * 日期焦点扫描
         * @private
         */
        _scanFocus: function(){
            var self = this,
                opts = self.options,
                index = opts.inputEl.index(self.eventEl),
                focusList = [];
            for(var i = 0; i < opts.cache.selDate.length; i ++){
                opts.cache.selDate[i] && focusList.push(opts.cache.selDate[i][0]);
            }
            self._focus(focusList, 'SEL');
            self._focus([new Date()], 'CUR');
        },

        /**
         * 日期获焦
         * @param {Array} data 日期对象
         * @param {String} type 设焦类型，值分别有“SEL | CUR”，"SEL"是指手动点选择，"CUR'是指当前或从input过来的初始化日期
         * @param {jQuery} $tg
         * @private
         */
        _focus: function(data, type, $tg){
            var self = this,
                opts = self.options,
                dataList = [];

            for(var i = 0; i < data.length; i ++){
                switch (opts.curModel[0]){
                    case 'date':
                        data[i] = [data[i].getFullYear(), data[i].getMonth(), data[i].getDate()];
                        break;
                    case 'year':
                        data[i] = [data[i].getFullYear()];
                        break;
                    case 'month':
                        data[i] = [data[i].getFullYear(), data[i].getMonth()];
                        break;
                    case 'quarter':
                        data[i] = [data[i].getFullYear(), Math.floor(data[i].getMonth() / 3) + 1];
                        break;
                    case 'week':
                        data[i] = [data[i].getFullYear(), C.Date.getOnWeek(data[i]).week];
                }
                dataList.push(data[i]);
            }
            _domFocusHandle.call(self, $tg, type, dataList);
        },

        _clear: function(clearCache){
            var self = this,
                opts = self.options;
            if(!clearCache){
                opts.inputEl.val('');
                opts.value = opts.isrange ? ['',''] : [''];
                opts.selDate = opts.isrange ? [null,null] : [null];
            }
            opts.cache.selDate = opts.isrange ? [null,null] : [null];
            opts.selIndex = 0;
            _domFocusHandle.call(self, null, 'clear', null);
        },


        /**
         * 输出处理
         * @private
         */
        _export: function(){
            var self = this,
                opts = self.options,
                val, time = null, date,
                isClose = true;
            if(opts.isrange){
                //比较日期
                opts.cache.selDate = _contrastDate(opts.cache.selDate);
                //更新时间
                freshTime();
                val = [opts.cache.selDate[0] ? opts.cache.selDate[0][1] : '',
                    opts.cache.selDate[1] ? opts.cache.selDate[1][1] : ''];

                for(var i = 0; i < val.length; i ++){
                    if(!val[i]){
                        isClose = false;
                    }
                }
                isClose = opts.okbtn ? true: isClose;
            }else{
                freshTime();
                val = opts.cache.selDate[0] ? opts.cache.selDate[0][1] : '';
            }
            self.setValue(val);

            if(isClose){
                self.hide();
            }

            function freshTime(){
                var len = opts.cache.selDate.length;
                for(var i = 0; i < len; i ++){
                    if(!opts.cache.selDate[i]){
                        continue;
                    }
                    time = self._getTime(i);
                    date = opts.cache.selDate[i];
                    date = new Date(date[2], date[3], date[4], time[0], time[1], time[2]);
                    date = _getDateArray(date, opts.format);
                    opts.cache.selDate[i] = date;
                }
            }
        },

        /**
         * 检查是否需要重新加载DOM
         * @param {String} type
         * @param {Number} index
         * @return {*}
         * @private
         */
        _isReady: function(type, index){
            var self = this,
                opts = self.options,
                curModel = opts.curModel[0],
                isChangeLimit, isLoad, val, dataSource;
            if(type === 'mainPanel'){
                val = opts.cache.selDate;
                dataSource = opts[opts.curModel[3]];
                isChangeLimit = contrastDate(opts.mindate[1], _getLimitDate.call(self, 'mindate'))
                    || contrastDate(opts.maxdate[1], _getLimitDate.call(self,'maxdate'));
                for(var n = 0; n < val.length; n ++){
                    if(val[n] === null){
                        isLoad = true;
                        continue;
                    }
                    for(var i = 0; i < dataSource.length; i ++){
                        switch (curModel){
                            case 'date':
                                isLoad = val[n][2] === dataSource[i].year && val[n][3] === dataSource[i].month;
                                break;
                            case 'year':
                                for(var m = 0; m < dataSource[i].data.length; m ++){
                                    if(val[n][2] === dataSource[i].data[m]){
                                        isLoad = true;
                                        break;
                                    }else{
                                        isLoad = false;
                                    }
                                }
                                break;
                            case 'week':
                                var weekData = C.Date.getOnWeek(val[n][0], opts.iso8601, opts.sunday_first);
                                isLoad = weekData.year === dataSource[i].year;
                                break;
                            default:
                                isLoad = val[n][2] === dataSource[i].year;
                        }
                        if(isLoad){
                            break;
                        }
                    }
                    if(!isLoad){
                        break;
                    }
                }
                isLoad = isLoad && !isChangeLimit;
            }else if(type === 'yearPop'){
                val = opts[opts.curModel[3]][index].year;
                dataSource = opts.pEl.children('.C_CR_YM_wrap').
                    find('div.C_CR_YMer_pop_y:eq('+ index +')>table').attr('val') || 'none';
                isLoad = $.trim(dataSource).indexOf(val + '') >= 0;
            }

            return isLoad;
            function contrastDate(aDate, bDate){
                aDate = aDate ? aDate.getTime() : aDate;
                bDate = bDate ? bDate.getTime() : bDate;
                return aDate != bDate;
            }
        },
        /**
         * 空提示文字控制
         * @param isEmpty {Boolean} 是否为空
         * @private
         */
        _setEmptyText: function(isEmpty){
            var self = this,
                opts = self.options;
            if(isEmpty){
                opts.el.find('.C_CR_emptytext').html(opts.emptytext);
            }else{
                opts.el.find('.C_CR_emptytext').html('');
            }
        },

        /**
         * 打开组件
         * @return {Object}
         */
        show: function(){
            var self = this,
                opts = self.options;
            if(opts.disable){
                return false;
            }
            //关闭已经打开的日期组件
            calers && calers.hide();

            //第一次打开和非第一次打开的处理
            if(opts.isBuild){
                opts.selDate = _analysis($.extend([], opts.selDate), opts.format);
                opts.cache.selDate = $.extend([],opts.selDate);
                //检查面板数据是否符合选择日期显示要求（减少不必要的重新创建DOM）
                if(!self._isReady('mainPanel')){
                    self._update(self._buildUpdateDate());
                }else{
                    self._scanFocus();
                    if(opts.model === 'all' || (opts.model === 'date' && /[h|m|s]/.test(opts.format))){
                        self._setTime(opts.selDate);
                    }
                }

                //打开组件
                opts.pEl.show();
            }else{
                self._draw();
                //显示组件
                opts.pEl.show();
                //加载主区数据
                self._selectTag(opts.curModel);
            }
            if(!opts.isBuild || opts.model === 'all'){
                _domSetWidth(opts);
            }
            //设置位置
            _domResetPos(opts);

            //把打开的日期组件设为待关闭组件
            calers = self;

            //设置文档监听
            $(document).unbind('mouseup.calender').one('mouseup.calender', function(e){
                e.stopPropagation();
                calers && calers.hide();
                calers = null;
            });

            return self;
        },

        /**
         * 关闭组件
         * @return {Object}
         */
        hide: function(){
            var self = this,
                opts = self.options;
            if(opts.disable || !opts.pEl){
                return self;
            }
            opts.el.attr('isShow','false');
            //关闭所有打开的窗口
            _domPopHandle.call(self);
            //隐藏组件
            opts.pEl.hide();
            //变更输入框样式
            opts.inputEl.parents('.C_CR_calInput_bd').removeClass(opts.inputFocusClass);
            if(opts.inputEl.val() === ''){
                self._setEmptyText(true);
            }
            //清空聚焦
            _domFocusHandle.call(self, null, 'clear', null);
            calers = null;
            return self;
        },

        /**
         * 设置值
         * @param {String|Date|Array} value 设置使用值，支持三种格式
         * 值格式例子：'2012-12-12'或 new Date(),  范围模式下的值格式['2012-12-12', '2012-12-15']或 [new Date(), new Date()]
         * @param {Boolean} isInit 是否是重置设值，如果
         * @return {Object} 组件对象
         */
        setValue: function(value, isInit){
            var self = this,
                opts = self.options,
                def = [], exp = [],
                expFormat = $.extend({}, opts.formatList);
            if(opts.disable){
                return self;
            }
            value = $.type(value) === 'number' ? value + '' : value;
            //值为空或undefined时，统一转化为null
            value = value || null;
            //对于单值，统一放到数组
            value = $.type(value) !== 'array' ? [value] : value;
            //清空
            opts.value = [];

            //解析
            if(value.length !== 0){
                def = _analysis($.extend(true,[],value), opts.format);

                if(!isInit){
                    //判断日期是否符合要求
                    var max = _getLimitDate.call(self, 'maxdate', true);
                    var min = _getLimitDate.call(self, 'mindate', true);

                    $.each(def, function(i, item){
                        if(item != null){
                            if(max && item[0] - max > 0){
                                //则日期已经超过最大日期，选择失效
                                def[i] = null;
                                return true;
                            }
                            if(min && min - item[0] > 0){
                                def[i] = null;
                                return true;
                            }
                        }
                    });
                }

                opts.selDate = $.extend(true, [], def);
                opts.cache.selDate = $.extend(true, [], def);
            }

            opts.selIndex = 0;
            //组织显示文字，并输出
            for(var i = 0; i < def.length; i ++){
                def[i] && opts.selIndex ++;
                opts.value.push(def[i] ? def[i][1] : '');
                exp.push(def[i] ? C.Date.format(def[i][0],expFormat[opts.curModel[0]]) : '');
            }

            exp = exp.join('~');
            //输出到输入框
            if(/^~$/.test(exp)){
                value = '';
            }else if(/^.*~$/.test(exp)){
                value = opts.separator ? exp : (exp = exp.replace('~',''));
            }else{
                value = exp;
            }
            opts.inputEl.eq(0).val(value);

            //设置空提示
            self._setEmptyText(exp === '' ? true : false);
            //触发对象事件, 如果 isInit 为true，则不触发
            if(isInit){
                self.onValid();
            }else{
                self._triggerHandler('change');
            }
            //执行回调
            if(typeof opts.on_change === 'function' && !isInit){//&& opts.isBuild
                opts.on_change.apply(self, $.extend(true, [],def));
            }
            //返回组件对象
            return self;
        },

        /**
         * 返回值
         * @param {String} reType 返回值数据类型，目前支持返回 string | date，默认为string
         * @return {String | Array} 返回值，返回格式 string | [string, string]
         */
        getValue: function(reType){
            var self = this,
                opts = self.options,
                val = [];
            if(opts.disable){
                return '';
            }
            reType = reType ? reType : 'string';
            var len = opts.isrange ? 2 : 1;
            for(var i = 0; i < len; i ++){
                if(!opts.value[i]){
                    val[i] = reType === 'string' ? '' : null;
                    opts.value[i] = reType === 'string' ? '' : null;
                    continue;
                }
                if(reType === 'date'){
                    val[i] = C.Date.parse(opts.value[i], opts.format);
                }else{
                    val[i] = opts.value[i];
                }
            }
            return opts.isrange ? val : val[0];
        },
        /**
         * 设置最大限度
         * @param date
         */
        setMaxDate: function (date) {
            var opts = this.options;
            if (opts.model !== "date" || typeof date !== 'string' || !/\d{4}(\-\d{2}){2}/.test(date)) {
                return;
            }
            opts.maxdate[0] = date;
        },
        /**
         * 设置最小限度
         * @param date
         */
        setMinDate: function (date) {
            var opts = this.options;
            if (opts.model !== "date" || typeof date !== 'string' || !/\d{4}(\-\d{2}){2}/.test(date)) {
                return;
            }
            opts.mindate[0] = date;
        },
        /**
         * 获取日期范围
         * @param {String} reType 返回值数据类型，目前支持返回 string | date，默认为date
         * @return {Array | Date | String} 返回格式如下，Date|[Date, Date]|[[Date, Date], [Date, Date]]
         * String | [String, String] | [[String, String], [String, String]]
         */
        getDateRange: function(reType){
            var self = this,
                opts = self.options,
                selDate = $.extend(true, [], opts.selDate),
                range = [], tmp, empty;
            reType = reType ? reType : 'date';
            empty = reType === 'date' ? null : '';
            for(var i = 0; i < selDate.length; i ++){
                if(!(tmp = selDate[i])){
                    range.push([empty, empty]);
                    continue;
                }
                switch (opts.curModel[0]){
                    case 'month':
                        range.push([
                            getFinalValue(new Date(tmp[2],tmp[3],1,0,0,0,0)),
                            getFinalValue(new Date(tmp[2],tmp[3], new Date(tmp[2], tmp[3] + 1, 0).getDate(),23,59,59,0))
                        ]);
                        break;
                    case 'year':
                        range.push([
                            getFinalValue(new Date(tmp[2],0,1,0,0,0,0)),
                            getFinalValue(new Date(tmp[2],11,31,23,59,59,0))
                        ]);
                        break;
                    case 'quarter':
                        range.push([
                            getFinalValue(new Date(tmp[2], tmp[3], 1, 0,0,0,0)),
                            getFinalValue(new Date(tmp[2], tmp[3] + 2, new Date(tmp[2], tmp[3] + 3, 0).getDate(),23,59,59,0))
                        ]);
                        break;
                    case 'week':
                        range.push([
                            getFinalValue(new Date(tmp[2],tmp[3],tmp[4],0,0,0,0)),
                            getFinalValue(new Date(tmp[2],tmp[3],tmp[4] + 6,23,59,59,0))
                        ]);
                        break;
                    default :
                        range.push([
                            getFinalValue(new Date(tmp[0].getTime())),
                            getFinalValue(new Date(tmp[2], tmp[3], tmp[4], 23, 59, 59, 0))
                        ]);
                }
            }
            if(range.length === 1){
                return opts.curModel[0] === 'date' ? range[0][0] : range[0];
            }else{
                return [range[0][0], range[1][1]];
            }
            function getFinalValue(date){
                if(reType === 'date'){
                    return date;
                }else{
                    return C.Date.format(date, 'yyyy-MM-dd hh:mm:ss');
                }
            }
        },

        /**
         * 设置组件宽度
         * @param width
         */
        setWidth:function(width){
            var $wrap = this.options.el.children('div'),
                cusWidth = this.options.width;
            if(width == null || width === undefined || width === '' || typeof width === 'object'){
                return;
            }
            if(typeof width === 'string' && /^(\d)+(px|pt|em|PX|PT|EM|%)$/.test(width)){
                cusWidth = width;
            }else {
                cusWidth = width + 'px';
            }
            $wrap.css({
                width: width
            });
        },

        /**
         * 设置只读
         * @param {Boolean} flag
         */
        setReadonly: function(flag){
            flag = typeof flag === 'undefined' ? true : flag;
            var self = this,
                opts = self.options,
                handle = flag ? 'addClass' : 'removeClass';
            if(flag === opts.readonly){
                return;
            }
            opts.el.children('.C_CR_calInput_bd')[handle](opts.inputDisClass);
            //如果设readonly为false，且entering为true，则，输入框可以输入
            if(!flag){
                opts.entering && opts.inputEl.prop('readonly', false);
            }else{
                opts.inputEl.prop('readonly', true);
            }
            opts.readonly = flag;
        },

        /**
         * 移除组件
         */
        destroy: function(){
            var self = this,
                opts = self.options;
            self._super();
            opts.el.unbind().remove();
            opts.pEl && opts.pEl.remove();
        },

        /**
         * 设置文本模式
         */
        setTextMode: function(){
            var self = this,
                opts = self.options,
                labelValue = self.getLabelValue();
            if(opts.isrange){
                opts.el.eq(0).html(labelValue[0]+'~'+labelValue[1]);
            }else{
                opts.el.eq(0).html(labelValue[0]);
            }
        },

        /**
         * 获取文本模式所需显示文本
         * @return {Array}
         */
        getLabelValue: function(){
            var self = this,
                opts = self.options,
                labelValue = [],
                varType,
                jsonReg = /^(?:\{.*\}|\[.*\])$/;

            if(opts.value === null || opts.value === undefined){
                opts.value = '';
            }

            varType = $.type(opts.value);
            if(varType === 'string'){
                opts.value = jsonReg.test( opts.value ) ?
                    $.parseJSON(opts.value.replace(/\\'/g, '#@@#').replace(/'/g, '"').replace(/#@@#/g, '\'')):
                    [opts.value];
            }
            for(var i = 0; i < opts.value.length; i ++){
                varType = $.type(opts.value[i]);
                if(varType === 'string'){
                    labelValue.push(opts.value[i]);
                }else if(varType === 'date'){
                    labelValue.push(_getDateArray(opts.value[i], opts.format)[1]);
                }
            }
            return labelValue;
        },

        /**
         * 数据错误回调方法
         * @param {CUI} cuiObj
         * @param {String} msg
         */
        onInValid: function(cuiObj, msg){
            var self = this,
                opts = self.options;
            opts.tipTxt = opts.tipTxt === null ? opts.el.attr('tip') : opts.tipTxt;
            opts.el.attr('tip', msg);
            //设置tip类型，错误
            $(self.tipPosition, opts.el).attr('tipType', 'error');
            opts.el.children('.C_CR_calInput_bd').addClass(opts.inputErrClass);

        },

        /**
         * 数据正确回调方法
         * @param cuiObj
         */
        onValid: function(cuiObj){
            var self = this,
                opts = self.options;
            opts.tipTxt = opts.tipTxt === null ? opts.el.attr('tip') : opts.tipTxt;
            opts.el.attr('tip', opts.tipTxt || '');
            //设置tip类型，正常
            $(self.tipPosition, opts.el).attr('tipType', 'normal');
            opts.el.children('.C_CR_calInput_bd').removeClass(opts.inputErrClass);
        }
    });

    //////////////////////////////////////////////////model//////////////////////////////////////////////////

    /**
     * 数据解析器，根据model的不一样，解析不同的格式
     * @param {Array} val
     * @param {String} format
     * @return {*}
     */
    function _analysis (val, format){
        var valType = null;
        for(var i = 0, len = val.length; i < len; i ++){
            valType = $.type(val[i]);
            if(valType === 'string'){
                val[i] = _getDateArray(C.Date.parse(val[i], format), format) || null;
            }else if(valType === 'date'){
                val[i] = _getDateArray(val[i], format) || null;
            }
        }
        return val;
    }

    /**
     * 获取指定月包含的周
     * @param {Date} date 日期对象
     * @param {Boolean} iso8601 按ISO8601标准计算星期，ISO 8601 规定每年的第一周包含这一年的第一个星期四
     * @param {Boolean} sundayFirst 一周第一天为周日
     * @return {Array} 周数组
     * @private
     */
    function _getGirdWeeks(date, iso8601, sundayFirst){
        var week = [], time, checkDate = new Date(date.getTime()),
            day = sundayFirst ? checkDate.getDay() - 1 : (checkDate.getDay() || 7) - 1;

        for(var i = 0; i < 6; i ++){
            week.push([C.Date.getOnWeek(new Date(checkDate.getTime()), iso8601, sundayFirst).week, 0]);
            checkDate.setDate(checkDate.getDate() + (7 - day));
            day = 0;
        }

        return week;
    }

    /**
     * 根据日期和不可用日期列表，生成数据对象
     * @param {Date} date
     * @return {Object}
     * @private
     */
    function _getPanelDate(date){
        var self = this,
            opts = self.options,
            dates = [], dn = 0, wn = 0, dw = [], i, dis, tmpDate,
            firstDay, prevMonthSize, curMonthSize, weeks,
            curYear = date.getFullYear(),
            curMonth = date.getMonth();

        opts.mindate[1] = _getLimitDate.call(self, 'mindate');
        opts.maxdate[1] = _getLimitDate.call(self, 'maxdate');

        //计算当月的第一天是星期几
        firstDay = new Date(curYear, curMonth, 1).getDay();
        //计算上个月的总天数
        prevMonthSize = new Date(curYear, curMonth, 0).getDate();
        //计算本月的总天数
        curMonthSize = new Date(curYear, curMonth + 1, 0).getDate();

        //如果是以周一为开始
        opts.sunday_first || firstDay --;
        if(firstDay < 0){
            firstDay = 6;
        }

        var isPrevYear = curMonth - 1 < 0 ? true : false,
            isNextYear = curMonth + 1 > 11 ? true : false;

        //生成当月前的补缺日期
        for(i = 0; i < firstDay; i ++){
            tmpDate = new Date(isPrevYear ? curYear - 1 : curYear, isPrevYear ? 11 : curMonth - 1, prevMonthSize, 0, 0, 0, 0);
            if(contrastDate(tmpDate, opts.mindate[1], 'mindate') || contrastDate(tmpDate, opts.maxdate[1], 'maxdate')){
                dis = 0;
            }else{
                dis = 1;
            }
            dates.push([prevMonthSize, dis, tmpDate.getFullYear(), tmpDate.getMonth()]);
            prevMonthSize --;
        }
        dates.reverse();

        //生成当月日期
        for(i = 1; i <= curMonthSize; i++){
            tmpDate = new Date(curYear, curMonth, i, 0, 0, 0, 0);
            if(contrastDate(tmpDate, opts.mindate[1], 'mindate') || contrastDate(tmpDate, opts.maxdate[1], 'maxdate')){
                dis = 0;
            }else{
                dis = 1;
            }
            dates.push([i, dis, curYear, curMonth]);
        }

        //生成当月后的补却日期
        for(i = 1; i<= 42 - curMonthSize - firstDay; i ++){
            tmpDate = new Date(isNextYear ? curYear + 1 : curYear, isNextYear ? 0 : curMonth + 1, i, 0, 0, 0, 0);
            if(contrastDate(tmpDate, opts.mindate[1], 'mindate') || contrastDate(tmpDate, opts.maxdate[1], 'maxdate')){
                dis = 0;
            }else{
                dis = 1;
            }
            dates.push([i, dis, tmpDate.getFullYear(), tmpDate.getMonth()]);
        }

        //生成周
        weeks = _getGirdWeeks(date, opts.iso8601, opts.sunday_first);
        for(i = 0; i < 48; i ++){
            if(i != 0 && i % 8 != 0){
                dw.push(dates[dn]);
                dn ++;
            }else{
                dw.push(weeks[wn]);
                wn ++;
            }
        }

        return {
            year:curYear,
            month:curMonth,
            date:dw
        };

        function contrastDate(sDate, cDate, type){
            if(!cDate){
                return false;
            }
            if(type === 'mindate'){
                return sDate.getTime() < cDate.getTime();
            }else{
                return sDate.getTime() > cDate.getTime();
            }
        }
    }

    /**
     * 获取从指定年份开始，一定范围内的年份数组
     * @param {Number} year 起始年或结束年
     * @param {Number} range 范围，range>0时，year为起始年，range<0时，year为结束年
     * @return {Array}
     * @private
     * @example _getPanelYear(2000, 4);
     *          返回[2000,2001,2002,2003]
     *          _getPanelYear(2000, -4);
     *          返回[1997,1998,1999,2000]
     */
    function _getPanelYear(year, range){
        var arrYear = [];
        if(range > 0){
            for(var i = 0; i < range; i ++){
                arrYear.push(year);
                year ++;
            }
        }else{
            for(var i = 0; i < -range; i ++){
                arrYear.push(year);
                year --;
            }
            arrYear.reverse();
        }

        return arrYear;
    }

    /**
     * 获取指定范围内的月份，默认为12个月
     * @param {Array} range 范围，格式[start, end]，如要取3月至9月，则[2,8]
     * @return {Array}
     * @private
     */
    function _getPanelMonth(range){
        var label = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"],
            ms = [];
        range = range || [0,11];
        for(var i = range[0]; i <= range[1]; i ++){
            ms.push([i, label[i]]);
        }
        return ms;
    }

    function _getPanelWeek(year, iso8601, sundayFirst){
        var week = [], weekIndex;
        //根据ISO8601规范，计算一年有多少周
        for(var i = 31; i > 0; i --){
            weekIndex = C.Date.getOnWeek(new Date(year, 11, i), iso8601, sundayFirst).week;
            if(weekIndex !== 1){
                break;
            }
        }
        for(i = 1; i <= weekIndex; i ++){
            week.push([i,1]);
        }
        return week;
    }

    /**
     * 将日期对象转成常用数据，以数组返回，返回格式如下[日期对象, 格式化后的日期字符串, year, month, date, hour, minute, second]
     * @param {Date} date
     * @param {String} format
     * @return {Array}
     * @private
     */
    function _getDateArray(date, format){
        if(!date){
            return null;
        }
        var arrDate = [];
        arrDate.push(date);
        arrDate.push(C.Date.format(date, format));
        arrDate.push(date.getFullYear(), date.getMonth(), date.getDate());
        arrDate.push(date.getHours(), date.getMinutes(), date.getSeconds());
        return arrDate;
    }

    /**
     * 对比日期大小，并返回正确排列
     * @param {Array} crDate
     * @private
     */
    function _contrastDate(crDate){
        if(!crDate || crDate.length < 2 || !crDate[0] || !crDate[1]){
            return crDate;
        }
        var tmp;
        if(crDate[0][0] > crDate[1][0]){
            tmp = crDate[1];
            crDate[1] = crDate[0];
            crDate[0] = tmp;
        }
        return crDate;
    }


    /**
     * 获取限制日期数据
     * @param type {String} 日期类型 包含“mindate”、“maxdate”
     * @param hasHMS {Boolean} 是否包含时分秒
     * @returns {*}
     * @private
     */
    function _getLimitDate(type, hasHMS){
        var self = this, opts = self.options, $cui,
            date = opts[type][0], noCurrent = opts.nocurrent;
        if(!date){
            return null;
        }
        var reg = /^([\+\-]{1})([0-9]{1,})([yMd]{1})$/,
            limit = [null, null, null];
        if(typeof date === 'string'){
            //字符串分为三种：1、使用简义代表符，如+1M；2、使用日期字符串，如'2012-10-15'；3、使用jQuery表达式，如'#endTime'
            if(/[\+\-]{1}[0-9]{1,}[yMd]{1}/.test(date)){
                var rules = date.split(','), rule, pos, tmpl = [0,0,0],
                    now = [new Date().getFullYear(), new Date().getMonth(), new Date().getDate()];
                //提取限制数据
                for(var i = 0; i < rules.length; i ++){
                    rule = rules[i].match(reg);
                    pos = 'yMd'.indexOf(rule[3]);
                    limit[pos] += (rule[1] === '+' ? 1 : -1) * (+ rule[2]) + now[pos];
                }
                for(i = 0; i < limit.length; i ++){
                    tmpl[i] = limit[i] === null ? 0 : 1;
                }
                switch (tmpl.join('-')){
                    case '1-0-0':
                        date = type === 'mindate' ? new Date(limit[0], 0, 1) : new Date(limit[0], 11, 31);break;
                    case '1-1-0':
                        date = type === 'mindate' ? new Date(limit[0], limit[1], 1) :
                            new Date(limit[0], limit[1], new Date(limit[0], limit[1] + 1, 0).getDate());
                        break;
                    case '1-1-1':
                        noCurrent && (limit[2] = type === 'mindate' ? limit[2] + 1 : limit[2] - 1);
                        date = new Date(limit[0], limit[1], limit[2]);break;
                    case '0-1-1':
                        noCurrent && (limit[2] = type === 'mindate' ? limit[2] + 1 : limit[2] - 1);
                        date = new Date(now[0], limit[1], limit[2]);break;
                    case '0-0-1':
                        noCurrent && (limit[2] = type === 'mindate' ? limit[2] + 1 : limit[2] - 1);
                        date = new Date(now[0], now[1], limit[2]);break;
                    case '0-1-0':
                        date = type === 'mindate' ? new Date(now[0], limit[1], 1) :
                            new Date(now[0], limit[1], new Date(limit[0], limit[1] + 1, 0).getDate());
                        break;
                    case '1-0-1':
                        noCurrent && (limit[2] = type === 'mindate' ? limit[2] + 1 : limit[2] - 1);
                        date = new Date(limit[0], now[1], limit[2]);
                        break;
                }
                date = type === 'maxdate' ? new Date(date.getFullYear(), date.getMonth(), date.getDate(), 23, 59, 59) :
                    new Date(date.getFullYear(), date.getMonth(), date.getDate(), 0, 0, 0);
            }else if($cui = $(date).data('uitype')){
                if(!(date = $cui.getValue('date'))){
                    return null;
                }
                noCurrent && date.setDate(type === 'mindate' ? date.getDate() + 1 : date.getDate() - 1);
            }else{
                if(!/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}|[0-9]{4}\-[0-9]{2}|[0-9]{4}$/.test(date)){
                    return null;
                }
                date = C.Date.parse(date,'yyyy-MM-dd');
                noCurrent && date.setDate(type === 'mindate' ? date.getDate() + 1 : date.getDate() - 1);
                date = type === 'maxdate' ? new Date(date.getFullYear(), date.getMonth(), date.getDate(), 23, 59, 59) :
                    new Date(date.getFullYear(), date.getMonth(), date.getDate(), 0, 0, 0);
            }

        }else{
            date = $.type(date) === 'date' ? date : null;
            noCurrent && date && date.setDate(type === 'mindate' ? date.getDate() + 1 : date.getDate() - 1);
        }

        return hasHMS ? new Date(date.getFullYear(), date.getMonth(), date.getDate(),date.getHours(),date.getMinutes(),date.getSeconds(),0,0) :
            new Date(date.getFullYear(), date.getMonth(), date.getDate(),0,0,0,0,0);
    }

    //////////////////////////////////////////////////view//////////////////////////////////////////////////

    /**
     * YMer工具条操作，提供显示，隐藏，只读等操作
     * @param {jQuery} $pEl 组件jquery
     * @param {String} handle 处理方式，值分别有hide|show|disYear|disMonth|dis|unDis
     * @private
     */
    function _domYMerHandle($pEl, handle){
        var $YMer = $pEl.children('.C_CR_YM_wrap');
        if(handle === 'hide'){
            $YMer.hide();
        }else{
            switch (handle){
                case 'disYear':
                    $YMer.find('span.C_CR_YMer_tx_y').parents('td').eq(0).hide().next().hide();
                    break;
                case 'disMonth':
                    $YMer.find('.C_CR_YMer').each(function(a, b){
                        $(b).children('tbody').children('tr').children('td').slice(2).hide();
                    });
                    break;
                case 'dis':
                    $YMer.find('span.C_CR_YMer_tx_wrap').parents('table').find('td').hide();
                    break;
                case 'unDis':
                default:
                    $YMer.find('span.C_CR_YMer_tx_wrap').parents('table').find('td').show();
            }
            $YMer.show();
        }

    }

    /**
     * 设置YMer的Label
     * @param $pEl
     * @param data
     * @param pos
     * @private
     */
    function _domSetYMerLabel($pEl, data, pos){
        var $input = $('table.C_CR_YMer:eq('+ pos +')', $pEl)
            .attr('val', data.year + '|' + (data.month - 1))
            .find('input.C_CR_tx');
        $input.eq(0).val(data.year);
        $input.eq(1).val(data.month);
    }

    /**
     * 处理pop弹出层
     * @param {jQuery} $tg
     * @param {String} type
     * @private
     */
    function _domPopHandle($tg){
        var self = this,
            opts = self.options;
        if(!opts.activePop && !$tg){
            return;
        }
        if(opts.activePop){
            opts.activePop.hide();
        }
        if($tg){
            $tg.show();
            opts.activePop = $tg;
        }
    }

    /**
     * 按钮操控
     * @private
     */
    function _domBtnHandle(){
        var self = this, opts = self.options,
            $btn = opts.pEl.children('.C_CR_OPBar_wrap').children('a').show(),
            $okbtn = $btn.filter('[val^="ok"]'),
            $clearbtn = $btn.filter('[val^="clear"]'),
            $curbtn = $btn.filter('[val^="cur"]'),
            label = {date: '今&nbsp;天', month: '本&nbsp;月', year: '本&nbsp;年', quarter: '本季度', week: '本&nbsp;周'};
        $curbtn.html(label[opts.curModel[0]]);
        opts.okbtn || $okbtn.hide();
        opts.clearbtn || $clearbtn.hide();
    }

    /**
     * 时间条Dom初始化
     * @private
     */
    function _domTimeInit(){
        var self = this,
            opts = self.options,
            $timeWrap = opts.pEl.children('.C_CR_Timer_box'),
            timeCtrl = [/s/.test(opts.format),/m/.test(opts.format),/h/.test(opts.format)];
        //设置时间显示
        if(!timeCtrl[0]){
            opts.pEl.find('td.C_CR_Timer_com_s').hide().prev().hide();
        }
        if(!timeCtrl[1]){
            opts.pEl.find('td.C_CR_Timer_com_m').hide().prev().hide();
        }
        if(!timeCtrl[2]){
            opts.pEl.find('td.C_CR_Timer_com_h').hide().prev().hide();
        }
        self.$tmp.$timeHour = $('div.C_CR_Timer_pop_h', $timeWrap);
        self.$tmp.$timeMin = $('div.C_CR_Timer_pop_m', $timeWrap);
        self.$tmp.$timeSecond = $('div.C_CR_Timer_pop_s', $timeWrap);
    }

    /**
     * 时间条操控
     * @private
     */
    function _domTimeHandle(){
        var self = this, opts = self.options;
        var $timeWrap = opts.pEl.children('.C_CR_Timer_box');
        if(opts.curModel[0] === 'date' && /[h|s|m]/.test(opts.format)){
            $timeWrap.show();
        }else{
            $timeWrap.hide();
        }
    }

    /**
     * 获焦操作
     * @param {jQuery} $tg 操作JQ元素
     * @param {String} type 操作方式
     * @param {Array} data 数据
     * @private
     */
    function _domFocusHandle($tg, type, data){
        var self = this,
            opts = self.options,
            model = opts.curModel[0],
            focusClass;

        switch (type){
            case 'CUR':
                focusClass = 'C_CR_main_cur';
                break;
            case 'SEL':
                focusClass = 'C_CR_main_cur_d';
                break;
            case 'clear':
                $('td.C_CR_main_cur_d', opts.pEl).removeClass('C_CR_main_cur_d');
                return;
        }
        if($tg){
            $tg.parent('td').addClass(focusClass);
        }else{
            for(var i = 0; i < data.length; i++){
                $('#C_CR_' + model + '_' + data[i].join('_') + '_' + opts.uuid).parent('td').addClass(focusClass);
            }
        }
    }

    /**
     * 设置组件宽度
     * @param {Object} opts 配置数据
     * @private
     */
    function _domSetWidth(opts){
        var num = opts.panel;
        var width = 226 * num;
        opts.pEl.css('width', width + 3 * (opts.panel - 1));

        var domWidth = opts.pEl.outerWidth();
        var domHeight = opts.pEl.outerHeight();

        //针对IE6，JCT会在日期背后添加iframe以遮盖select，所以，这里必须对iframe设置高宽
        if(C.Browser.isIE6 || C.Browser.isQM){
            opts.pEl.find('iframe').css({
                width: domWidth,
                height: domHeight
            });
        }
    }

    /**
     * 计算位置
     * @param {Object} opts 配置数据
     * @private
     */
    function _domResetPos(opts){
        var $win = $(window),
            eventEl = opts.el.children('.C_CR_calInput_bd'),
            inpOffset = eventEl.offset(),
            inpHeight = eventEl.outerHeight(),
            inpWidth = eventEl.outerWidth(),
            winWidth = $win.width(),
            winHeight = $win.height(),
            winSL = $win.scrollLeft(),
            winST = $win.scrollTop(),
            domWidth = opts.pEl.outerWidth(),
            domHeight = opts.pEl.outerHeight(),
            docHeight = $(document).height(),
            css = {};

        if(winWidth - (inpOffset.left - winSL) > domWidth){
            css.left = inpOffset.left;
        }else if(inpOffset.left - winSL + inpWidth > domWidth){
            css.left = inpOffset.left + inpWidth - domWidth;
        }else{
            css.left = 0;
        }

        //首先判断下方是否有空间
        if(docHeight - inpOffset.top -inpHeight > domHeight && winHeight - (inpOffset.top - winST) - inpHeight > domHeight){
            css.top = inpOffset.top + inpHeight;
        //再判断上方是否有空间
        }else if(inpOffset.top - winST > domHeight){
            css.top = inpOffset.top - domHeight;
        //如果都没有空间
        }else{
            css.top = winST + (winHeight - domHeight) /2;
            if(winWidth - (inpOffset.left -winSL + inpWidth) > domWidth){
                css.left = inpOffset.left + inpWidth;
            }else if(inpOffset.left - winSL + inpWidth > domWidth){
                css.left = inpOffset.left - inpWidth;
            }else{
                css.left = 0;
            }
        }

        css.left = css.left < 0 ? 0 : css.left;
        css.top = css.top < 0 ? 0 : css.top;

        opts.pEl.css(css);

        if(!opts.isBuild){
            opts.isBuild = true;
        }
    }
})(window.comtop.cQuery , window.comtop);



/*
 Masked Input plugin for jQuery
 Copyright (c) 2007-2013 Josh Bush (digitalbush.com)
 Licensed under the MIT license (http://digitalbush.com/projects/masked-input-plugin/#license)
 Version: 1.3.1
 */
;(function(C, $) {
    function getPasteEvent() {
        var el = document.createElement('input'),
            name = 'onpaste';
        el.setAttribute(name, '');
        return (typeof el[name] === 'function')?'paste':'input';
    }

    var pasteEventName = getPasteEvent() + ".mask",
        ua = navigator.userAgent,
        iPhone = /iphone/i.test(ua),
        android=/android/i.test(ua),
        caretTimeoutId;
    $.maskCL = {
        //Predefined character definitions
        definitions: {
            '9': "[0-9]",
            '1': "[0-1]",
            '2': "[0-2]",
            '3': "[0-3]",
            '4': "[0-4]",
            '5': "[0-5]",
            '6': "[0-6]",
            '7': "[0-7]",
            '8': "[0-8]",
            'a': "[A-Za-z]",
            '*': "[A-Za-z0-9]",
            'q': "[1-4]",
            'x': "x",
            'r': "r",
            'z': "z",
            'k': "k"
        },
        dataName: "rawMaskFn",
        placeholder: '_'
    };

    $.fn.extend({
        //Helper Function for caretCL positioning
        caretCL: function(begin, end) {
            var range;

            if (this.length === 0 || this.is(":hidden")) {
                return;
            }

            if (typeof begin === 'number') {
                end = (typeof end === 'number') ? end : begin;
                return this.each(function() {
                    if (this.setSelectionRange) {
                        this.setSelectionRange(begin, end);
                    } else if (this.createTextRange) {
                        range = this.createTextRange();
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
                    range = document.selection.createRange();
                    begin = 0 - range.duplicate().moveStart('character', -100000);
                    end = begin + range.text.length;
                }
                return { begin: begin, end: end };
            }
        },
        unmaskCL: function() {
            return this.trigger("unmaskCL");
        },
        maskCL: function(mask, settings) {
            var input,
                defs,
                tests,
                partialPosition,
                firstNonMaskPos,
                len;
            if (!mask && this.length > 0) {
                input = $(this[0]);
                return input.data($.maskCL.dataName)();
            }
            settings = $.extend({
                placeholder: $.maskCL.placeholder, // Load default placeholder
                completed: null
            }, settings);

            defs = $.maskCL.definitions;
            tests = [];
            partialPosition = len = mask.length;
            firstNonMaskPos = null;

            $.each(mask.split(""), function(i, c) {
                if (c === '?') {
                    len--;
                    partialPosition = i;
                } else if (defs[c]) {
                    tests.push(new RegExp(defs[c]));
                    if (firstNonMaskPos === null) {
                        firstNonMaskPos = tests.length - 1;
                    }
                } else {
                    tests.push(null);
                }
            });
            return this.trigger("unmaskCL").each(function() {
                var input = $(this),
                    buffer = $.map(
                        mask.split(""),
                        function(c, i) {
                            if (c !== '?') {
                                return defs[c] ? settings.placeholder : c;
                            }
                        }),
                    focusText = input.val();

                function seekNext(pos) {
                    while (++pos < len && !tests[pos]);
                    return pos;
                }

                function seekPrev(pos) {
                    while (--pos >= 0 && !tests[pos]);
                    return pos;
                }

                function shiftL(begin,end) {
                    var i,
                        j;

                    if (begin<0) {
                        return;
                    }

                    for (i = begin, j = seekNext(end); i < len; i++) {
                        if (tests[i]) {
                            //if (j < len && tests[i].test(buffer[j])) {
                            if (j < len && compare(tests[i], buffer[j], i)) {
                                buffer[i] = buffer[j];
                                buffer[j] = settings.placeholder;
                            } else {
                                break;
                            }

                            j = seekNext(j);
                        }
                    }
                    writeBuffer();
                    input.caretCL(Math.max(firstNonMaskPos, begin));
                }

                function shiftR(pos) {
                    var i,
                        c,
                        j,
                        t;

                    for (i = pos, c = settings.placeholder; i < len; i++) {
                        if (tests[i]) {
                            j = seekNext(i);
                            t = buffer[i];
                            buffer[i] = c;
                            //if (j < len && tests[j].test(t)) {
                            if (j < len && compare(tests[j], t, j)) {
                                c = t;
                            } else {
                                break;
                            }
                        }
                    }
                }

                function compare(exp, charValue, i) {
                    var value, k, inputValue, year, month, day, fDay, lDay;
                    switch(exp.toString().replace(/\//g,'')) {
                        //月
                        case 'x':
                            value = input.val().substring(i - 1, i);
                            k = parseFloat(charValue);
                            if (value === '0') {
                                return (k > 0 && k <= 9);
                            } else if (value === '1') {
                                return (k >= 0 && k < 3);
                            }
                            break;
                        //日
                        case 'z':
                            inputValue = input.val();
                            value = inputValue.substring(i - 1, i);
                            k = parseFloat(charValue);
                            k = parseFloat(charValue);
                            if (value === '0') {
                                return (k > 0 && k <= 9);
                            } else if (value === '1' || value === '2'){
                                return (k >= 0 && k <= 9);
                            } else if (value === '3') {
                                return (k >= 0 && k <= 1);
                            }
                            break;
                        //小时
                        case 'r':
                            value = input.val().substring(i - 1, i);
                            k = parseFloat(charValue);
                            if (value === '0' || value === '1') {
                                return (k >= 0 && k <= 9);
                            } else if (value === '2') {
                                return (k >= 0 && k <= 3);
                            }
                            break;
                        //周
                        case 'k':
                            value = input.val().substring(i - 1, i);
                            k = parseFloat(charValue);
                            if (value === '0') {
                                return (k > 0 && k <= 9);
                            }else if (value === '1' || value === '2' || value === '3' || value === '4') {
                                return (k >= 0 && k <= 9);
                            } else if (value === '5') {
                                return (k >= 0 && k <= 3);
                            }
                            break;
                        default:
                            return exp.test(charValue);
                    }
                }

                function keydownEvent(e) {
                    if(input.prop('readonly')){
                        return;
                    }
                    var k = e.which,
                        pos,
                        begin,
                        end;

                    //backspace, delete, and escape get special treatment
                    if (k === 8 || k === 46 || (iPhone && k === 127)) {
                        pos = input.caretCL();
                        begin = pos.begin;
                        end = pos.end;

                        if (end - begin === 0) {
                            begin=k!==46?seekPrev(begin):(end=seekNext(begin-1));
                            end=k===46?seekNext(end):end;
                        }
                        clearBuffer(begin, end);
                        shiftL(begin, end - 1);

                        e.preventDefault();
                    } else if (k === 27) {//escape
                        input.val(focusText);
                        input.caretCL(0, checkVal());
                        e.preventDefault();
                    }
                }

                function keypressEvent(e) {
                    if(input.prop('readonly')){
                        return;
                    }
                    var k = e.which,
                        pos = input.caretCL(),
                        p,
                        c,
                        next;

                    if (e.ctrlKey || e.altKey || e.metaKey || k < 32) {//Ignore
                        return false;
                    } else if (k) {
                        if (pos.end - pos.begin !== 0){
                            clearBuffer(pos.begin, pos.end);
                            shiftL(pos.begin, pos.end-1);
                        }

                        p = seekNext(pos.begin - 1);
                        if (p < len) {
                            c = String.fromCharCode(k);
                            //if (tests[p].test(c)) {

                            if (compare(tests[p], c, p)) {
                                shiftR(p);

                                buffer[p] = c;
                                writeBuffer();
                                next = seekNext(p);

                                if(android){
                                    setTimeout($.proxy($.fn.caret,input,next),0);
                                }else{
                                    input.caretCL(next);
                                }

                                if (settings.completed && next >= len) {
                                    settings.completed.call(input);
                                }
                            }
                        }
                        e.preventDefault();
                    }
                }

                function clearBuffer(start, end) {
                    var i;
                    for (i = start; i < end && i < len; i++) {
                        if (tests[i]) {
                            buffer[i] = settings.placeholder;
                        }
                    }
                }

                function writeBuffer() {input.val(buffer.join('')); }

                function checkVal(allow) {
                    //try to place characters where they belong
                    var test = input.val(),
                        lastMatch = -1,
                        i,
                        pos,
                        c,
                        opts,
                        fmOpts = input.data('fmOpts'),
                        cuiInput;

                    for (i = 0, pos = 0; i < len; i++) {
                        if (tests[i]) {
                            buffer[i] = settings.placeholder;
                            while (pos++ < test.length) {
                                c = test.charAt(pos - 1);
                                //if (tests[i].test(c)) {
                                if (compare(tests[i], c, i)) {
                                    buffer[i] = c;
                                    lastMatch = i;
                                    break;
                                }
                            }
                            if (pos > test.length) {
                                break;
                            }
                        } else if (buffer[i] === test.charAt(pos) && i !== partialPosition) {
                            pos++;
                            lastMatch = i;
                        }
                    }
                    if (allow) {
                        writeBuffer();
                        input.val(input.val().substring(0, lastMatch + 1));
                    } else if (lastMatch + 1 < partialPosition) {
                        cuiInput = cui(input.parents('span').eq(0));
                        opts = cuiInput.options;
                        if(lastMatch === (partialPosition - 1) / 2 && fmOpts.isRange){
                            writeBuffer();
                            input.val(input.val().substring(0, fmOpts.separator ? lastMatch + 1 : lastMatch));
                        }else {
                            input.val("");
                            if (opts) {
                                cuiInput._clear(input.data('fmOpts').okBtn);
                            }
                            clearBuffer(0, len);
                        }
                    } else {
                        writeBuffer();
                        input.val(input.val().substring(0, lastMatch + 1));
                    }
                    return (partialPosition ? i : firstNonmaskCLPos);
                }

                input.data('fmOpts').buffer = buffer;
                input.data('fmOpts').clearBuffer = clearBuffer;


                input.data($.maskCL.dataName,function(){
                    return $.map(buffer, function(c, i) {
                        return tests[i] && c !== settings.placeholder ? c : null;
                    }).join('');
                });

                //if (!input.attr("readonly")){
                input
                    .one("unmaskCL", function() {
                        input
                            .unbind(".maskCL")
                            .removeData($.maskCL.dataName);
                    })
                    .bind("focus.maskCL", function() {
                        if(input.prop('readonly')){
                            return;
                        }
                        clearTimeout(caretTimeoutId);
                        var pos,
                            date,
                            fmOpts = input.data('fmOpts'),
                            moveCaret;

                        focusText = input.val();

                        if($.trim(focusText) !== ''){
                            if(!fmOpts.isRange){
                                date = C.Date.parse(focusText, fmOpts.format);
                                focusText = input.val(C.Date.format(date, fmOpts.fullFormat));
                            }else{
                                date = focusText.split('~');
                                if(date[0]){
                                    date[0] = C.Date.parse(date[0], fmOpts.format);
                                    focusText = C.Date.format(date[0], fmOpts.fullFormat);
                                }
                                if(date[1]){
                                    date[1] = C.Date.parse(date[1], fmOpts.format);
                                    focusText += '~' + C.Date.format(date[1], fmOpts.fullFormat);
                                }else{
                                    focusText += fmOpts.separator ? '~' : '';// + focusText;
                                }
                                input.val(focusText);
                            }
                        }
                        pos = checkVal(true);

                        caretTimeoutId = setTimeout(function(){
                            writeBuffer();
                            if (pos === mask.length) {
                                input.caretCL(0, pos);
                            } else {
                                input.caretCL(pos);
                            }
                        }, 10);
                    })
                    .bind("blur.maskCL", function() {
                        var fmOpts = input.data('fmOpts'),
                            $t = cui(input.parents('span').eq(0)),
                            date;
                        checkVal();

                        if(input.val() !== ''){
                            if(!fmOpts.isRange){
                                date = C.Date.parse(input.val(), fmOpts.fullFormat);
                                input.val(C.Date.format(date, fmOpts.format));
                            }else{
                                date = input.val().split('~');
                                date[0] = C.Date.parse(date[0], fmOpts.fullFormat);
                                date[1] = C.Date.parse(date[1], fmOpts.fullFormat);
                                if(date[0] === null && date[1] !== null){
                                    date[0] = date[1];
                                }
                                if(date[0] !== null && date[1] !== null){
                                    if(date[0] - date[1] > 0){
                                        date.reverse();
                                    }
                                    input.val(C.Date.format(date[0], fmOpts.format) + '~' + C.Date.format(date[1], fmOpts.format));
                                }
                            }
                        }
                        $t.setValue(date);
                        //下面的change暂时屏蔽
                        /*if (input.val() !== focusText){
                         input.change();
                         }*/
                    })
                    .bind("keydown.maskCL", keydownEvent)
                    .bind("keypress.maskCL", keypressEvent)
                    .bind(pasteEventName, function() {
                        setTimeout(function() {
                            var pos=checkVal(true);
                            input.caretCL(pos);
                            if (settings.completed && pos === input.val().length){
                                settings.completed.call(input);
                            }
                        }, 0);
                    });
                //}
                checkVal(true); //Perform initial check for existing values
            });
        }
    });
})(window.comtop, window.comtop.cQuery);