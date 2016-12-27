/**
 * Calender
 * Author: chaoqun.lin
 * Date: 2013-01-06
 * Version: 2.1.1
 */
;(function ($, C) {
    var calers = null;//�Ѿ��򿪵��������
    C.UI.Calender = C.UI.Base.extend({
        options: {
            uitype: 'Calender',
            name: '',
            //id: '',
            model: 'date',              //����ģʽ��Ĭ��ֵΪ date��ֵ��[date|year|quarter|month|time|all]��
            //�ֱ����[ѡ������|ѡ�����|ѡ�񼾶�|ѡ���·�|ѡ��ʱ��|���й���]
            isrange: false,             //�Ƿ�����Χѡ��
            trigger: 'click',           //�����¼���Ĭ��Ϊclick
            value: [],                  //Ĭ�����ڣ��������
            format: '',                 //�����ʽ�����modelΪall��format��Ϊ���� ['yyyy-MM-dd','yyyy���q����']
            entering: false,            //�ı����Ƿ��������
            emptytext: '',              //���ı���ʾ
            readonly: false,            //�Ƿ�ɶ�
            disable: false,             //�Ƿ񲻿���
            icon: true,                 //�Ƿ��ṩͼ�������������
            textmode: false,            //�Ƿ����ı�ģʽ
            panel: 1,                   //��ʾ��ѡ����·ݰ�飬Ĭ��Ϊ1
            zindex: 11000,               //�㼶����
            width: '200px',             //�������
            okbtn: false,               //�Ƿ�����okbtn������okbtn����Ҫ���ȷ��������ѡ���ֵ���������
            clearbtn: true,                //�Ƿ�������հ�ť
            mindate: null,                  //��С����
            maxdate: null,                  //�������
            nocurrent: false,           //�����С���ڣ��Ƿ��������/����/���꣬Ĭ��Ϊ����
            iso8601: false,             //�Ƿ�����iso8601��׼�������˱�׼��ÿ��Ĭ�ϵ�һ��Ϊ����һ��ÿ��ĵ�һ�����������ڵ���Ϊ��һ��
            on_change: null,            //�ص��������ڵ�ѡ���ں�ִ��
            separator: false,           //����ģʽ�£��������Ƿ����������
            sunday_first: false         //ÿ�ܵĵ�һ���Ƿ��������죬Ĭ��������һ
        },

        tipPosition: '.C_CR_calInput_bd',  //������ռλ���ڵ�Ԫ��

        /**
         * �Զ����ʼ��������׼��
         * @param {Object} cusOpts �Զ������ò���
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
            //[�����С���ƹ���, ���ɵ���������]
            opts.mindate = [cusOpts.mindate, null];
            opts.maxdate = [cusOpts.maxdate, null];

            //����Ĳ�������������
            opts.uuid = C.guid();                           //����ڲ����ID
            opts.template = 'calender.html';                //ģ������
            opts.curModel = [];                             //Ĭ�ϵ�ǰģ�ͣ����ĸ�����Ϊ���泣�ã����Դ������������ʹ��
            opts.formatList = {                             //Ĭ�ϸ�ʽ
                date: 'yyyy-MM-dd',
                year: 'yyyy',
                quarter: 'yyyy-q',
                month: 'yyyy-MM',
                week: 'yyyy-w'
            };
            opts.inputFocusClass = 'C_CR_calInput_focus';   //��������ʽ
            opts.inputDisClass = 'C_CR_calInput_rd';        //����򲻿�����ʽ
            opts.inputErrClass = 'C_CR_calInput_err';       //����򱨴���ʽ
            opts.selDate = [];                              //ѡ�������
            opts.cache = {                                  //����
                yearPop: {},
                selDate: []
            };
            opts.isBuild = false;                           //�Ƿ񴴽����DOM
            opts.inputEl = null;                            //��ǰ�����
            opts.tipTxt = null;                             //���tip�ı�
            opts.pEl = null;                                //���ڲ�JQ����
            opts.datePanel = [];                            //����ģʽ����
            opts.yearPanel = [];                            //���ģʽ����
            opts.monthPanel = [];                           //�·�ģʽ����
            opts.quarterPanel = [];                         //����ģʽ����
            opts.timePanel = [];                            //ʱ��ģʽ����
            opts.weekPanel = [];
            opts.yearPop = {                                //YMer������
                forDate: [],
                forYear: [],
                forQuarter: [],
                forMonth: [],
                forWeek: []
            };
            opts.selIndex = 0;                              //��ǰ������������
            opts.activePop = null;                          //��ǰ���POP�㣬���ڹر�
            opts.isChangeTag = false;                       //�Ƿ�ִ���˱�ǩ�л�
            self.$tmp = {};                                 //װ��jquery����

            //���ɵ�ǰ����ģʽ
            var curModel = opts.model === 'all' ? 'date' : opts.model;
            opts.curModel = [
                curModel, 'for' + curModel.charAt(0).toUpperCase() + curModel.substring(1),
                    curModel + 'Frame', curModel + 'Panel'
            ];

            //��ʼ����ʽ
            if(opts.model === 'all' && cusOpts.format){
                opts.format = $.parseJSON(cusOpts.format.replace(/\\'/g, '#@@#').replace(/'/g, '"').replace(/#@@#/g, '\''));
                opts.formatList = $.extend(opts.formatList, opts.format);
                opts.format = opts.formatList[opts.curModel[0]];
            }else if(!cusOpts.format){
                opts.format = opts.formatList[opts.curModel[0]];
            }else{
                opts.formatList[opts.curModel[0]] = opts.format;
            }
            //�����ʽֻ�����ʱ���룬��ȷ����ť�Ǳ���Ҫ��ʾ��
            opts.okbtn = /[y|M|q|w|d]/.test(opts.format) ? opts.okbtn : true;
        },

        /**
         * �Զ������
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

                //�������ʾ����
                self._setEmptyText(false);

                //��ʱȥ��������֤��Ϣ
                self.onValid();
            }).bind('mouseup.calender', function(e){
                e.stopPropagation();
            });

            //��ȡĬ������
            self._getDefault();
            self.setValue($.extend(true, [], opts.selDate), true);

            //���ҿ����ڵ�λ��
            for(var i = 0; i < opts.cache.selDate.length; i ++){
                if(opts.cache.selDate[i] === null){
                    opts.selIndex = i;
                    break;
                }
            }

            //���ɶ��򲻿��ô���
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

            //�����������
            if(opts.entering){
                self._enter();
            }
        },

        /**
         * �ֶ������ʽ��
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
         * ��ȡĬ�����ݣ�Ĭ�����ݵ���Դ��������options��input
         * @private
         */
        _getDefault: function () {
            var self = this,
                opts = self.options,
                def = [];

            if(opts.value.length !== 0){
                //��ȡoptions��Ĭ��ֵ
                def = opts.value;
            }else{
                //��ȡinput��Ĭ��ֵ
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
         * �������ݣ�DOM��������ݶ��������
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
                    //�ж��Ƿ���Ҫ�����굯��ѡ����������
                    reLoadYM = !self._isReady('yearPop', index);
                    opts[opts.curModel[3]][index] = [];
                    if(reLoadYM){
                        opts.yearPop[opts.curModel[1]][index] = [];
                    }
                }
            }

            //�����������������Ӧ�����ݣ�������DOM�ṹʹ��
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
            //���������yearPop����
            opts.cache.yearPop = $.extend(true, {},opts.yearPop);
        },

        /**
         * ����/�������ݲ�������
         * @return {Array}
         * @private
         */
        _buildUpdateDate: function(){
            var self = this,
                opts = self.options,
                min, max,
                curDate = new Date(), dataList = [], i, data = [];
            //�ƹ������С����
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
         * �������DOM�ṹ
         * @private
         */
        _draw: function () {
            var self = this,
                opts = self.options;
            //�����������
            self._buildData(self._buildUpdateDate());
            self._buildTemplate('body', 'calFrame', $.extend(true,{},opts), true);  //32-48mm
            opts.pEl = $('#C_CR_' + opts.uuid);
        },

        /**
         * ����/�����������
         * @param {String} model ���µ�ģ����������
         * @param {Number} index YMer������
         * @private
         */
        _drawYearPop: function(model, index){
            var self = this,
                opts = self.options,
                data,
                $yearPops = opts.pEl.children('.C_CR_YM_wrap').find('div.C_CR_YMer_pop_y');
            //����������
            data = opts.yearPop[model] || [];
            if(typeof index !== 'undefined'){
                self._buildTemplate($yearPops.eq(index), 'yearPopFrame', data[index]);
            }else{
                for(var i = 0; i < data.length; i ++){
                    self._buildTemplate($yearPops.eq(i), 'yearPopFrame', data[i]);
                }
            }
        },

        //====================================================�¼�����================================================

        /**
         * ��ǩ�л��¼�����
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
                //�л�ʱ���ѡ��
                opts.cache.selDate = [];
                opts.isChangeTag = true;
                self._selectTag(opts.curModel);
            }
        },

        /**
         * binder�¼�����
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

            //��ε��ͬһ�������㣬ִֻ��һ��show
            if (opts.el.attr('isShow') === 'true') {
                return;
            }
            opts.el.attr('isShow', 'true');

            if(nodeName !== 'INPUT'){
                opts.inputEl.click();
            }
        },

        /**
         * ����ѡ�񲿼��¼�����
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
         * ����ѡ�񲿼��¼�����
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
            //����target�Ĳ�ͬ��������ͬ�Ĵ����
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
         * ʱ�䲿���¼�����
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
                //��������������ʱ��Ĳ���
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
                //�����ǵ�����ʱ�Ĳ���
                val = $tg.attr('val');
                if(self.$tmp.curTimeTxt){
                    self.$tmp.curTimeTxt.val(val < 10 ? '0' + val : val);
                }
                _domPopHandle.call(self);
            }
        },

        /**
         * ��ť�����¼�����
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
                    //���ֻ���ʱ���룬����ȷ��ʱ�����������ѡ����ʱ��
                    if(opts.curModel[0] === 'date'){
                        tmpDateArray = _getDateArray(new Date, opts.format);
                        opts.cache.selDate = /[y|M|q|w|d]/.test(opts.format) ? opts.cache.selDate :
                            opts.isrange ? [tmpDateArray, tmpDateArray] : [tmpDateArray];
                    }
                    self._export();
            }
        },

        //====================================================����====================================================
        /**
         * ��ǩ�л�
         * @param {Array} model ģ����������
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

            //�������������
            $siblings.hide();
            //��ʾ���صȴ���ʾ
            $load.show();
            //��������ѡ�񹤾�������
            if(model[0] !== 'all' && model[0] !== 'date'){
                _domYMerHandle(opts.pEl, 'disMonth');   //��/��/����ģʽ���·�ѡ�����
            }else{
                _domYMerHandle(opts.pEl, 'undo');
            }
            //������л�
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
            //���ư�ť��
            _domBtnHandle.call(self);
            //����ʱ����
            if(!opts.isBuild){
                //����ʱ��
                if(opts.model === 'all' || (model[0] === 'date' && /[h|m|s]/.test(opts.format))){
                    self._buildTemplate(opts.pEl.children('.C_CR_Timer_box'), 'timeFrame', opts);
                    _domTimeInit.call(self);
                }
            }
            //ʱ�����
            _domTimeHandle.call(self);
            if(opts.model === 'all'){
                _domSetWidth(opts);
                _domResetPos(opts);
            }
            //����YMer��Label
            self._setYM(model[0]);
            self._scanFocus();
            //�ر�����POP
            opts.isBuild && _domPopHandle.call(self);

            //�����������
            if(opts.entering && opts.isChangeTag){
                self._clear();
                self._enter();
                opts.isChangeTag = false;
            }
        },

        /**
         * �л���/��
         * @param {String} type ���ͣ����л������'month'/'year'
         * @param {Number} source ԭֵ
         * @param {Number} index ��������������
         * @param {Number} step ���·���
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
         * ʱ���趨
         * @param {jQuery} $tg ���JQ����
         * @param {Number} step ���·���
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
         * ѡ������
         * @param {Array} val ֵ
         * @param {jQuery} $tg JQ����
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

            //��
            self._focus([date], 'SEL', $tg);
            opts.okbtn || self._export();
        },

        /**
         * YMer��ݰ�����
         * @param {Number} range �л���Χ���磬12����ָһ�θ���12��
         * @param {Number} index YMer������
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
         * ��ȡʱ��
         * @param {Number} index ����
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

        //==================UI����======================

        /**
         * ����������DOM�ṹ
         * @param {Array} dataSource ����Դ
         * @param {Number} index ��������������
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
         * ��������
         * @param {String} model ��ǰ����ģ��
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
         * ����ʱ��
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
         * �ر�YMerPop
         * @param {Boolean} isCloseAll �Ƿ�ȫ���ر�
         * @param {jQuery} $tg  JQ����
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
                popType = $YMItem.attr('pop');  //����������
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
         * ���ڽ���ɨ��
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
         * ���ڻ�
         * @param {Array} data ���ڶ���
         * @param {String} type �轹���ͣ�ֵ�ֱ��С�SEL | CUR����"SEL"��ָ�ֶ���ѡ��"CUR'��ָ��ǰ���input�����ĳ�ʼ������
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
         * �������
         * @private
         */
        _export: function(){
            var self = this,
                opts = self.options,
                val, time = null, date,
                isClose = true;
            if(opts.isrange){
                //�Ƚ�����
                opts.cache.selDate = _contrastDate(opts.cache.selDate);
                //����ʱ��
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
         * ����Ƿ���Ҫ���¼���DOM
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
         * ����ʾ���ֿ���
         * @param isEmpty {Boolean} �Ƿ�Ϊ��
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
         * �����
         * @return {Object}
         */
        show: function(){
            var self = this,
                opts = self.options;
            if(opts.disable){
                return false;
            }
            //�ر��Ѿ��򿪵��������
            calers && calers.hide();

            //��һ�δ򿪺ͷǵ�һ�δ򿪵Ĵ���
            if(opts.isBuild){
                opts.selDate = _analysis($.extend([], opts.selDate), opts.format);
                opts.cache.selDate = $.extend([],opts.selDate);
                //�����������Ƿ����ѡ��������ʾҪ�󣨼��ٲ���Ҫ�����´���DOM��
                if(!self._isReady('mainPanel')){
                    self._update(self._buildUpdateDate());
                }else{
                    self._scanFocus();
                    if(opts.model === 'all' || (opts.model === 'date' && /[h|m|s]/.test(opts.format))){
                        self._setTime(opts.selDate);
                    }
                }

                //�����
                opts.pEl.show();
            }else{
                self._draw();
                //��ʾ���
                opts.pEl.show();
                //������������
                self._selectTag(opts.curModel);
            }
            if(!opts.isBuild || opts.model === 'all'){
                _domSetWidth(opts);
            }
            //����λ��
            _domResetPos(opts);

            //�Ѵ򿪵����������Ϊ���ر����
            calers = self;

            //�����ĵ�����
            $(document).unbind('mouseup.calender').one('mouseup.calender', function(e){
                e.stopPropagation();
                calers && calers.hide();
                calers = null;
            });

            return self;
        },

        /**
         * �ر����
         * @return {Object}
         */
        hide: function(){
            var self = this,
                opts = self.options;
            if(opts.disable || !opts.pEl){
                return self;
            }
            opts.el.attr('isShow','false');
            //�ر����д򿪵Ĵ���
            _domPopHandle.call(self);
            //�������
            opts.pEl.hide();
            //����������ʽ
            opts.inputEl.parents('.C_CR_calInput_bd').removeClass(opts.inputFocusClass);
            if(opts.inputEl.val() === ''){
                self._setEmptyText(true);
            }
            //��վ۽�
            _domFocusHandle.call(self, null, 'clear', null);
            calers = null;
            return self;
        },

        /**
         * ����ֵ
         * @param {String|Date|Array} value ����ʹ��ֵ��֧�����ָ�ʽ
         * ֵ��ʽ���ӣ�'2012-12-12'�� new Date(),  ��Χģʽ�µ�ֵ��ʽ['2012-12-12', '2012-12-15']�� [new Date(), new Date()]
         * @param {Boolean} isInit �Ƿ���������ֵ�����
         * @return {Object} �������
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
            //ֵΪ�ջ�undefinedʱ��ͳһת��Ϊnull
            value = value || null;
            //���ڵ�ֵ��ͳһ�ŵ�����
            value = $.type(value) !== 'array' ? [value] : value;
            //���
            opts.value = [];

            //����
            if(value.length !== 0){
                def = _analysis($.extend(true,[],value), opts.format);

                if(!isInit){
                    //�ж������Ƿ����Ҫ��
                    var max = _getLimitDate.call(self, 'maxdate', true);
                    var min = _getLimitDate.call(self, 'mindate', true);

                    $.each(def, function(i, item){
                        if(item != null){
                            if(max && item[0] - max > 0){
                                //�������Ѿ�����������ڣ�ѡ��ʧЧ
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
            //��֯��ʾ���֣������
            for(var i = 0; i < def.length; i ++){
                def[i] && opts.selIndex ++;
                opts.value.push(def[i] ? def[i][1] : '');
                exp.push(def[i] ? C.Date.format(def[i][0],expFormat[opts.curModel[0]]) : '');
            }

            exp = exp.join('~');
            //����������
            if(/^~$/.test(exp)){
                value = '';
            }else if(/^.*~$/.test(exp)){
                value = opts.separator ? exp : (exp = exp.replace('~',''));
            }else{
                value = exp;
            }
            opts.inputEl.eq(0).val(value);

            //���ÿ���ʾ
            self._setEmptyText(exp === '' ? true : false);
            //���������¼�, ��� isInit Ϊtrue���򲻴���
            if(isInit){
                self.onValid();
            }else{
                self._triggerHandler('change');
            }
            //ִ�лص�
            if(typeof opts.on_change === 'function' && !isInit){//&& opts.isBuild
                opts.on_change.apply(self, $.extend(true, [],def));
            }
            //�����������
            return self;
        },

        /**
         * ����ֵ
         * @param {String} reType ����ֵ�������ͣ�Ŀǰ֧�ַ��� string | date��Ĭ��Ϊstring
         * @return {String | Array} ����ֵ�����ظ�ʽ string | [string, string]
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
         * ��������޶�
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
         * ������С�޶�
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
         * ��ȡ���ڷ�Χ
         * @param {String} reType ����ֵ�������ͣ�Ŀǰ֧�ַ��� string | date��Ĭ��Ϊdate
         * @return {Array | Date | String} ���ظ�ʽ���£�Date|[Date, Date]|[[Date, Date], [Date, Date]]
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
         * ����������
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
         * ����ֻ��
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
            //�����readonlyΪfalse����enteringΪtrue����������������
            if(!flag){
                opts.entering && opts.inputEl.prop('readonly', false);
            }else{
                opts.inputEl.prop('readonly', true);
            }
            opts.readonly = flag;
        },

        /**
         * �Ƴ����
         */
        destroy: function(){
            var self = this,
                opts = self.options;
            self._super();
            opts.el.unbind().remove();
            opts.pEl && opts.pEl.remove();
        },

        /**
         * �����ı�ģʽ
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
         * ��ȡ�ı�ģʽ������ʾ�ı�
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
         * ���ݴ���ص�����
         * @param {CUI} cuiObj
         * @param {String} msg
         */
        onInValid: function(cuiObj, msg){
            var self = this,
                opts = self.options;
            opts.tipTxt = opts.tipTxt === null ? opts.el.attr('tip') : opts.tipTxt;
            opts.el.attr('tip', msg);
            //����tip���ͣ�����
            $(self.tipPosition, opts.el).attr('tipType', 'error');
            opts.el.children('.C_CR_calInput_bd').addClass(opts.inputErrClass);

        },

        /**
         * ������ȷ�ص�����
         * @param cuiObj
         */
        onValid: function(cuiObj){
            var self = this,
                opts = self.options;
            opts.tipTxt = opts.tipTxt === null ? opts.el.attr('tip') : opts.tipTxt;
            opts.el.attr('tip', opts.tipTxt || '');
            //����tip���ͣ�����
            $(self.tipPosition, opts.el).attr('tipType', 'normal');
            opts.el.children('.C_CR_calInput_bd').removeClass(opts.inputErrClass);
        }
    });

    //////////////////////////////////////////////////model//////////////////////////////////////////////////

    /**
     * ���ݽ�����������model�Ĳ�һ����������ͬ�ĸ�ʽ
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
     * ��ȡָ���°�������
     * @param {Date} date ���ڶ���
     * @param {Boolean} iso8601 ��ISO8601��׼�������ڣ�ISO 8601 �涨ÿ��ĵ�һ�ܰ�����һ��ĵ�һ��������
     * @param {Boolean} sundayFirst һ�ܵ�һ��Ϊ����
     * @return {Array} ������
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
     * �������ںͲ����������б��������ݶ���
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

        //���㵱�µĵ�һ�������ڼ�
        firstDay = new Date(curYear, curMonth, 1).getDay();
        //�����ϸ��µ�������
        prevMonthSize = new Date(curYear, curMonth, 0).getDate();
        //���㱾�µ�������
        curMonthSize = new Date(curYear, curMonth + 1, 0).getDate();

        //���������һΪ��ʼ
        opts.sunday_first || firstDay --;
        if(firstDay < 0){
            firstDay = 6;
        }

        var isPrevYear = curMonth - 1 < 0 ? true : false,
            isNextYear = curMonth + 1 > 11 ? true : false;

        //���ɵ���ǰ�Ĳ�ȱ����
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

        //���ɵ�������
        for(i = 1; i <= curMonthSize; i++){
            tmpDate = new Date(curYear, curMonth, i, 0, 0, 0, 0);
            if(contrastDate(tmpDate, opts.mindate[1], 'mindate') || contrastDate(tmpDate, opts.maxdate[1], 'maxdate')){
                dis = 0;
            }else{
                dis = 1;
            }
            dates.push([i, dis, curYear, curMonth]);
        }

        //���ɵ��º�Ĳ�ȴ����
        for(i = 1; i<= 42 - curMonthSize - firstDay; i ++){
            tmpDate = new Date(isNextYear ? curYear + 1 : curYear, isNextYear ? 0 : curMonth + 1, i, 0, 0, 0, 0);
            if(contrastDate(tmpDate, opts.mindate[1], 'mindate') || contrastDate(tmpDate, opts.maxdate[1], 'maxdate')){
                dis = 0;
            }else{
                dis = 1;
            }
            dates.push([i, dis, tmpDate.getFullYear(), tmpDate.getMonth()]);
        }

        //������
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
     * ��ȡ��ָ����ݿ�ʼ��һ����Χ�ڵ��������
     * @param {Number} year ��ʼ��������
     * @param {Number} range ��Χ��range>0ʱ��yearΪ��ʼ�꣬range<0ʱ��yearΪ������
     * @return {Array}
     * @private
     * @example _getPanelYear(2000, 4);
     *          ����[2000,2001,2002,2003]
     *          _getPanelYear(2000, -4);
     *          ����[1997,1998,1999,2000]
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
     * ��ȡָ����Χ�ڵ��·ݣ�Ĭ��Ϊ12����
     * @param {Array} range ��Χ����ʽ[start, end]����Ҫȡ3����9�£���[2,8]
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
        //����ISO8601�淶������һ���ж�����
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
     * �����ڶ���ת�ɳ������ݣ������鷵�أ����ظ�ʽ����[���ڶ���, ��ʽ����������ַ���, year, month, date, hour, minute, second]
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
     * �Ա����ڴ�С����������ȷ����
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
     * ��ȡ������������
     * @param type {String} �������� ������mindate������maxdate��
     * @param hasHMS {Boolean} �Ƿ����ʱ����
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
            //�ַ�����Ϊ���֣�1��ʹ�ü�����������+1M��2��ʹ�������ַ�������'2012-10-15'��3��ʹ��jQuery���ʽ����'#endTime'
            if(/[\+\-]{1}[0-9]{1,}[yMd]{1}/.test(date)){
                var rules = date.split(','), rule, pos, tmpl = [0,0,0],
                    now = [new Date().getFullYear(), new Date().getMonth(), new Date().getDate()];
                //��ȡ��������
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
     * YMer�������������ṩ��ʾ�����أ�ֻ���Ȳ���
     * @param {jQuery} $pEl ���jquery
     * @param {String} handle ����ʽ��ֵ�ֱ���hide|show|disYear|disMonth|dis|unDis
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
     * ����YMer��Label
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
     * ����pop������
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
     * ��ť�ٿ�
     * @private
     */
    function _domBtnHandle(){
        var self = this, opts = self.options,
            $btn = opts.pEl.children('.C_CR_OPBar_wrap').children('a').show(),
            $okbtn = $btn.filter('[val^="ok"]'),
            $clearbtn = $btn.filter('[val^="clear"]'),
            $curbtn = $btn.filter('[val^="cur"]'),
            label = {date: '��&nbsp;��', month: '��&nbsp;��', year: '��&nbsp;��', quarter: '������', week: '��&nbsp;��'};
        $curbtn.html(label[opts.curModel[0]]);
        opts.okbtn || $okbtn.hide();
        opts.clearbtn || $clearbtn.hide();
    }

    /**
     * ʱ����Dom��ʼ��
     * @private
     */
    function _domTimeInit(){
        var self = this,
            opts = self.options,
            $timeWrap = opts.pEl.children('.C_CR_Timer_box'),
            timeCtrl = [/s/.test(opts.format),/m/.test(opts.format),/h/.test(opts.format)];
        //����ʱ����ʾ
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
     * ʱ�����ٿ�
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
     * �񽹲���
     * @param {jQuery} $tg ����JQԪ��
     * @param {String} type ������ʽ
     * @param {Array} data ����
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
     * ����������
     * @param {Object} opts ��������
     * @private
     */
    function _domSetWidth(opts){
        var num = opts.panel;
        var width = 226 * num;
        opts.pEl.css('width', width + 3 * (opts.panel - 1));

        var domWidth = opts.pEl.outerWidth();
        var domHeight = opts.pEl.outerHeight();

        //���IE6��JCT�������ڱ������iframe���ڸ�select�����ԣ���������iframe���ø߿�
        if(C.Browser.isIE6 || C.Browser.isQM){
            opts.pEl.find('iframe').css({
                width: domWidth,
                height: domHeight
            });
        }
    }

    /**
     * ����λ��
     * @param {Object} opts ��������
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

        //�����ж��·��Ƿ��пռ�
        if(docHeight - inpOffset.top -inpHeight > domHeight && winHeight - (inpOffset.top - winST) - inpHeight > domHeight){
            css.top = inpOffset.top + inpHeight;
        //���ж��Ϸ��Ƿ��пռ�
        }else if(inpOffset.top - winST > domHeight){
            css.top = inpOffset.top - domHeight;
        //�����û�пռ�
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
                        //��
                        case 'x':
                            value = input.val().substring(i - 1, i);
                            k = parseFloat(charValue);
                            if (value === '0') {
                                return (k > 0 && k <= 9);
                            } else if (value === '1') {
                                return (k >= 0 && k < 3);
                            }
                            break;
                        //��
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
                        //Сʱ
                        case 'r':
                            value = input.val().substring(i - 1, i);
                            k = parseFloat(charValue);
                            if (value === '0' || value === '1') {
                                return (k >= 0 && k <= 9);
                            } else if (value === '2') {
                                return (k >= 0 && k <= 3);
                            }
                            break;
                        //��
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
                        //�����change��ʱ����
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