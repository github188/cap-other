/**
 * Calender????·Ú?????????
 * Author: chaoqun.lin
 * Date: 2013-01-06
 * Version: 2.1.1
 */
;(function ($, C) {
    var calers = null;//?????????????
    C.UI.Calender = C.UI.Base.extend({
        options: {
            uitype: 'Calender',
            name: '',
            //id: '',
            model: 'date',              //????????????? date?????[date|year|quarter|month|time|all]??
            //?????[???????|??????|????|????¡¤?|??????|???§Û???]
            isrange: false,             //???????¦¶???
            trigger: 'click',           //?????????????click
            value: [],                  //???????????????
            format: '',                 //???????????model?all??format??????? ['yyyy-MM-dd','yyyy???q????']
            entering: false,            //???????????????
            emptytext: '',              //????????
            readonly: false,            //?????
            disable: false,             //??????
            icon: true,                 //???????????????????
            textmode: false,            //??????????
            panel: 1,                   //??????????¡¤??ï…????1
            zindex: 11000,               //??????
            width: '200px',             //???????
            okbtn: false,               //???????okbtn??????okbtn???????????????????????????????
            clearbtn: true,                //????????????
            mindate: null,                  //??§³????
            maxdate: null,                  //???????
            nocurrent: false,           //?????§³???????????/????/??????????
            iso8601: false,             //???????iso8601????????????????????????????????????????????????????????????
            on_change: null,            //???????????????????
            sunday_first: false         //?????????????????????????????
        },

        tipPosition: '.C_CR_calInput_bd',  //???????¦Ë????????

        /**
         * ?????????????????
         * @param {Object} cusOpts ????????¨°???
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
            //[?????§³???????, ????????????]
            opts.mindate = [cusOpts.mindate, null];
            opts.maxdate = [cusOpts.maxdate, null];

            //?????????????
            opts.uuid = C.guid();                           //?????????ID
            opts.template = 'calender.html';                //??????
            opts.curModel = [];                             //?????????????????????Æü??????????????????????
            opts.formatList = {                             //?????
                date: 'yyyy-MM-dd',
                year: 'yyyy',
                quarter: 'yyyy-q',
                month: 'yyyy-MM',
                week: 'yyyy-w'
            };
            opts.inputFocusClass = 'C_CR_calInput_focus';   //?????????
            opts.inputDisClass = 'C_CR_calInput_rd';        //???????????
            opts.inputErrClass = 'C_CR_calInput_err';       //?????????
            opts.selDate = [];                              //????????
            opts.cache = {                                  //????
                yearPop: {},
                selDate: []
            };
            opts.isBuild = false;                           //???????DOM
            opts.inputEl = null;                            //????????
            opts.tipTxt = null;                             //???tip???
            opts.pEl = null;                                //?????JQ????
            opts.datePanel = [];                            //?????????
            opts.yearPanel = [];                            //????????
            opts.monthPanel = [];                           //?¡¤??????
            opts.quarterPanel = [];                         //?????????
            opts.timePanel = [];                            //????????
            opts.weekPanel = [];
            opts.yearPop = {                                //YMer?????
                forDate: [],
                forYear: [],
                forQuarter: [],
                forMonth: [],
                forWeek: []
            };
            opts.selIndex = 0;                              //???????????????
            opts.activePop = null;                          //???????POP????????

            //???????????
            var curModel = opts.model === 'all' ? 'date' : opts.model;
            opts.curModel = [
                curModel, 'for' + curModel.charAt(0).toUpperCase() + curModel.substring(1),
                curModel + 'Frame', curModel + 'Panel'
            ];

            //????????
            if(opts.model === 'all' && cusOpts.format){
                opts.format = $.parseJSON(cusOpts.format.replace(/\\'/g, '#@@#').replace(/'/g, '"').replace(/#@@#/g, '\''));
                opts.formatList = $.extend(opts.formatList, opts.format);
                opts.format = opts.formatList[opts.curModel[0]];
            }else if(!cusOpts.format){
                opts.format = opts.formatList[opts.curModel[0]];
            }else{
                opts.formatList[opts.curModel[0]] = opts.format;
            }
            //???????????????????????????????????
            opts.okbtn = /[y|M|q|w|d]/.test(opts.format) ? opts.okbtn : true;
        },

        /**
         * ????????
         * @private
         */
        _create: function () {
            var self = this,
                opts = self.options;

            opts.inputEl = opts.el.find(':text');
            //opts.el.attr('id', opts.id);

            //??????????
            self._getDefault();
            self.setValue($.extend(true, [], opts.selDate), true);

            //??????????¦Ë??
            for(var i = 0; i < opts.cache.selDate.length; i ++){
                if(opts.cache.selDate[i] === null){
                    opts.selIndex = i;
                    break;
                }else{
                    opts.selIndex ++;
                }
            }

            //?????????????
            if(opts.disable || opts.readonly){
                opts.el.children('.C_CR_calInput_bd').addClass(opts.inputDisClass);
            }
            if(!opts.entering || opts.disable || opts.readonly){
                opts.disable && opts.inputEl.attr('disabled', true);
                (opts.readonly || !opts.entering) && opts.inputEl.attr('readonly', true);
            }

            //???????????
            if(opts.entering){
                //TODO ???????????
                //self._enterCtrl();
            }
        },

        //TODO ???????§Ö????
        _enterCtrl: function(mask){
            var self = this,
                opts = self.options,
                ft = opts.format,
                maskFtItem = [],
                ftItem = [],
                maskOutFt = '',
                outFt = '',
                y, M, d, h, m, s, w, q;

            y = /y/.test(ft) ? ['9999', 'yyyy'] : '';
            M = /M/.test(ft) ? ['1m', 'MM'] : '';
            d = /d/.test(ft) ? ['td', 'dd'] : '';
            h = /h/.test(ft) ? ['2h', 'hh'] : '';
            m = /m/.test(ft) ? ['59', 'mm'] : '';
            s = /s/.test(ft) ? ['59', 'ss'] : '';
            w = /w/.test(ft) ? ['5w', 'ww'] : '';
            q = /q/.test(ft) ? ['4', 'q'] : '';

            y !== '' && (maskFtItem.push(y[0]), ftItem.push(y[1]));
            M !== '' && (maskFtItem.push(M[0]), ftItem.push(M[1]));
            d !== '' && (maskFtItem.push(d[0]), ftItem.push(d[1]));
            w !== '' && (maskFtItem.push(w[0]), ftItem.push(w[1]));
            q !== '' && (maskFtItem.push(q[0]), ftItem.push(q[1]));
            maskOutFt = maskFtItem.join('-');
            outFt = ftItem.join('-');

            maskFtItem = [];
            ftItem = [];
            h !== '' && (maskFtItem.push(h[0]), ftItem.push(h[1]));
            m !== '' && (maskFtItem.push(m[0]), ftItem.push(m[1]));
            s !== '' && (maskFtItem.push(s[0]), ftItem.push(s[1]));
            maskOutFt += maskFtItem.join(':') !== '' ? ' ' + maskFtItem.join(':') : '';
            outFt += ftItem.join(':') !== '' ? ' ' + ftItem.join(':') : '';
            if(opts.isrange){
                maskOutFt = maskOutFt + '~' + maskOutFt;
                outFt = outFt + '~' + 'outFt';
            }
            C.UI.InputMask.doMask(opts.inputEl, 'Custom', {model:maskOutFt, placeholder:'_', callback:function(){
                var value = $.trim(opts.inputEl.val());
                value = value.split('~');
                for(var i = 0; i < value.length; i ++){
                    value[i] = C.Date.parse(value[i], outFt);
                }
                self.setValue(value);
            }});
        },

        /**
         * ????????????????????????????options??input
         * @private
         */
        _getDefault: function () {
            var self = this,
                opts = self.options,
                def = [];

            if(opts.value.length != 0){
                //???options??????
                def = opts.value;
            }else{
                //???input??????
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
         * ????????DOM?????????????????
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
                    //?§Ø?????????????????????????
                    reLoadYM = !self._isReady('yearPop', index);
                    opts[opts.curModel[3]][index] = [];
                    reLoadYM && (opts.yearPop[opts.curModel[1]][index] = []);
                }
            }

            //?????????????????????????????DOM?????
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
            //?????????yearPop???
            opts.cache.yearPop = $.extend(true, {},opts.yearPop);
        },

        /**
         * ????/?????????????
         * @return {Array}
         * @private
         */
        _buildUpdateDate: function(){
            var self = this,
                opts = self.options,
                curDate, dataList = [], i, data = [];
            curDate = _getDateArray(new Date(), opts.format);
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
         * ???????DOM??
         * @private
         */
        _draw: function () {
            var self = this,
                opts = self.options;
            //??????????
            self._buildData(self._buildUpdateDate());
            self._buildTemplate('body', 'calFrame', $.extend(true,{},opts), true);  //32-48mm
            opts.pEl = $('#C_CR_' + opts.uuid);
        },

        /**
         * ????/???????????
         * @param {String} model ???????????????
         * @param {Number} index YMer?????
         * @private
         */
        _drawYearPop: function(model, index){
            var self = this,
                opts = self.options,
                data,
                $yearPops = opts.pEl.children('.C_CR_YM_wrap').find('div.C_CR_YMer_pop_y');
            //????????
            data = opts.yearPop[model] || [];
            if(index != undefined){
                self._buildTemplate($yearPops.eq(index), 'yearPopFrame', data[index]);
            }else{
                for(var i = 0; i < data.length; i ++){
                    self._buildTemplate($yearPops.eq(i), 'yearPopFrame', data[i]);
                }
            }
        },

        //====================================================???????================================================
        /*_blurHandler: function(e, eventEl, target){
            var self = this,
                opts = self.options;

        },
        _keyupHandler: function(e, eventEl, target){
            var self = this,
                opts = self.options;
            //console.log(opts.inputEl.val());
            //self.setValue('2012-05-09 10:10:50');
        },*/
        /**
         * ????§Ý????????
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
                //?§Ý????????
                opts.cache.selDate = [];
                self._selectTag(opts.curModel);
            }
        },

        /**
         * binder???????
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

            //??¦Å???????????????????show
            if (opts.el.attr('isShow') === 'true') {
                return;
            }
            opts.el.attr('isShow', 'true');
            if(nodeName === 'INPUT'){
                opts.entering || $(target).blur();
            }

            opts.inputEl.parents('.C_CR_calInput_bd').addClass(opts.inputFocusClass);
            self.show();

            //????????????
            if($.trim(opts.inputEl.val()) === opts.emptytext){
                opts.inputEl.val('').removeClass('C_CR_calInput_empty');
            }
        },

        /**
         * ???????????????
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
         * ???????????????
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
            //???target???????????????????
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
         * ????????????
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
                val;

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
                _domPopHandle.call(self, $tg.next());
            } else if (nodeName === 'A') {
                var $timePop = $tg.parents('div.C_CR_Timer_pop').prev();
                val = + $tg.attr('val');
                $timePop.val(val < 10 ? '0' + val : val);
                _domPopHandle.call(self);
            }
        },

        /**
         * ??????????????
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
                    break;
                case 'ok':
                    //???????????????????????????????????????
                    if(opts.curModel[0] === 'date'){
                        tmpDateArray = _getDateArray(new Date, opts.format);
                        opts.cache.selDate = /[y|M|q|w|d]/.test(opts.format) ? opts.cache.selDate :
                            opts.isrange ? [tmpDateArray, tmpDateArray] : [tmpDateArray];
                    }
                    self._export();
            }
        },

        //====================================================????====================================================
        /**
         * ????§Ý?
         * @param {Array} model ??????????
         * @private
         */
        _selectTag: function(model) {
            var self = this,
                opts = self.options,
                $main = opts.pEl.children('.C_CR_main_wrap'),
                $load = $main.children('.C_CR_main_loading'),
                $tgWrap = $main.children('.C_CR_main_panel[val='+ model[0] +']'),
                $siblings = $tgWrap.siblings(),
                isBuild = $tgWrap.attr('isBuild') === 'true';
            opts.cache.selDate = $.extend(true, [], opts.selDate);
            opts.format = opts.formatList[model[0]];

            //?????????????
            $siblings.hide();
            //????????????
            $load.show();
            //??????????????????
            if(model[0] != 'all' && model[0] != 'date'){
                _domYMerHandle(opts.pEl, 'disMonth');   //??/??/?????????¡¤???????
            }else{
                _domYMerHandle(opts.pEl, 'undo');
            }
            //??????§Ý?
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
            //????????
            _domBtnHandle.call(self);
            //?????????
            if(!opts.isBuild){
                //??????
                if(opts.model === 'all' || (model[0] === 'date' && /[h|m|s]/.test(opts.format))){
                    self._buildTemplate(opts.pEl.children('.C_CR_Timer_box'), 'timeFrame', opts);
                }
            }
            //??????
            _domTimeHandle.call(self);
            if(opts.model === 'all'){
                _domSetWidth(opts);
                _domResetPos(opts);
            }
            //????YMer??Label
            self._setYM(model[0]);
            self._scanFocus();
            //???????POP
            opts.isBuild && _domPopHandle.call(self);
        },

        /**
         * ?§Ý???/??
         * @param {String} type ????????§Ý??????'month'/'year'
         * @param {Number} source ??
         * @param {Number} index ?????????????
         * @param {Number} step ???¡¤??
         * @private
         */
        _selectMonthYear: function(type, source, index, step){
            var self = this,
                opts = self.options,
                data, $YMer,
                dataList = [],
                tyIndex = type === 'month' ? 1 : 0;
            $YMer = $('table.C_CR_YMer', opts.pEl);
            if(index != undefined && index != null){
                getDate(index);
            }else{
                for(var i = 0; i < $YMer.length; i ++){
                    getDate(i);
                }
            }
            self._update(dataList ,index);
            function getDate(i){
                data = $YMer.eq(i).attr('val').split('|');
                data[tyIndex] = step != undefined ? Number(data[tyIndex]) + step : source;
                dataList.push([Number(data[0]), Number(data[1])]);
            }
        },

        /**
         * ????Ú…
         * @param {jQuery} $tg ???JQ????
         * @param {Number} step ???¡¤??
         * @private
         */
        _selectTime: function($tg, step){
            var val, $opWrap, $input, sumStep;
            $opWrap = $tg.parents('.C_CR_Timer_op').eq(0);
            $input = $opWrap.prev().children('input');
            val = + $.trim($input.val());
            sumStep = val + step;

            if($input.attr('name') === 'timer_h'){
                $opWrap.children('a').removeClass('C_CR_Timer_disable');
                if(sumStep > 23 || sumStep < 0){
                    $tg.parent().addClass('C_CR_Timer_disable');
                    return;
                }
            }else{
                $opWrap.children('a').removeClass('C_CR_Timer_disable');
                if(sumStep > 59 || sumStep < 0){
                    $tg.parent().addClass('C_CR_Timer_disable');
                    return;
                }
            }

            sumStep = String(sumStep);

            $input.val(sumStep.length === 1 ? (0 + sumStep) : sumStep);
        },

        /**
         * ???????
         * @param {Array} val ?
         * @param {jQuery} $tg JQ????
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
                opts.selIndex === 2 && self._clear(opts.okbtn);
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

            //??
            self._focus([date], 'SEL', $tg);
            opts.okbtn || self._export();
        },

        /**
         * YMer??????
         * @param {Number} range ?§Ý???¦¶???íà12???????¦È?12??
         * @param {Number} index YMer?????
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
         * ??????
         * @param {Number} index ????
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



        //==================UI????======================

        /**
         * ??????????DOM??
         * @param {Array} dataSource ????
         * @param {Number} index ?????????????
         * @private
         */
        _update: function(dataSource, index){
            var self = this,
                opts = self.options,
                updateMark;
            updateMark = opts.pEl.children('.C_CR_main_wrap').children('.C_CR_main_panel[val='+ opts.curModel[0] +']');
            if(index != undefined){
                self._buildData(dataSource, index);
            }else{
                self._buildData(dataSource);
            }
            self._buildTemplate(updateMark, opts.curModel[2], opts);

            self._setYM(opts.curModel[0]);
            self._scanFocus();
        },

        /**
         * ????????
         * @param {String} model ??????????
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
         * ???????
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
         * ???YMerPop
         * @param {Boolean} isCloseAll ?????????
         * @param {jQuery} $tg  JQ????
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
                popType = $YMItem.attr('pop');  //??????????
                popIndex = $YMItem.attr('popIndex');
            }
            if(popType === 'year'){
                if(popIndex != '' && !self._isReady('yearPop', popIndex)){
                    opts.yearPop = $.extend(true, {}, opts.cache.yearPop);
                    setTimeout(function(){
                        self._drawYearPop(opts.curModel[1], popIndex);
                    },50);
                }
            }
        },

        /**
         * ??????????
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
         * ?????
         * @param {Array} data ???????
         * @param {String} type ?éö??????????§³?SEL | CUR????"SEL"???????????"CUR'?????????input??????????????
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
         * ???????
         * @private
         */
        _export: function(){
            var self = this,
                opts = self.options,
                val, time = null, date,
                isClose = true;
            if(opts.isrange){
                //???????
                opts.cache.selDate = _contrastDate(opts.cache.selDate);
                //???????
                freshTime();
                val = [opts.cache.selDate[0] ? opts.cache.selDate[0][1] : '',
                    opts.cache.selDate[1] ? opts.cache.selDate[1][1] : ''];

                for(var i = 0; i < opts.cache.selDate.length; i ++){
                    if(!opts.cache.selDate[i]){
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
         * ????????????????DOM
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
         * ?????
         * @return {Object}
         */
        show: function(){
            var self = this,
                opts = self.options;
            if(opts.disable){
                return false;
            }

            //????????????????
            calers && calers.hide();

            //????¦Ä??????¦Ä?????
            if(opts.isBuild){
                opts.selDate = _analysis($.extend([], opts.selDate), opts.format);
                opts.cache.selDate = $.extend([],opts.selDate);
                //???????????????????????????????????????????DOM??
                if(!self._isReady('mainPanel')){
                    self._update(self._buildUpdateDate());
                }else{
                    self._scanFocus();
                }

                //?????
                opts.pEl.show();
            }else{
                self._draw();
                //??????
                opts.pEl.show();
                //???????????
                self._selectTag(opts.curModel);
            }
            if(!opts.isBuild || opts.model === 'all'){
                _domSetWidth(opts);
            }
            //????¦Ë??
            _domResetPos(opts);

            //?????????????????????
            calers = self;

            //???????????
            $(document).unbind('click.calender').one('click.calender', function(e){
                e.stopPropagation();
                calers && calers.hide();
                calers = null;
            });

            return self;
        },

        /**
         * ??????
         * @return {Object}
         */
        hide: function(){
            var self = this,
                opts = self.options;
            if(opts.disable || !opts.pEl){
                return self;
            }
            opts.el.attr('isShow','false');
            //??????§Õ?????
            _domPopHandle.call(self);
            //???????
            opts.pEl.hide();
            //???????????
            opts.inputEl.parents('.C_CR_calInput_bd').removeClass(opts.inputFocusClass);
            if(opts.inputEl.val() === ''){
                opts.inputEl.val(opts.emptytext).addClass('C_CR_calInput_empty');
            }
            //?????
            _domFocusHandle.call(self, null, 'clear', null);

            calers = null;
            return self;
        },

        /**
         * ?????
         * @param {String|Date|Array} value ???????????????????
         * ?????????'2012-12-12'?? new Date(),  ??¦¶?????????['2012-12-12', '2012-12-15']?? [new Date(), new Date()]
         * @param {Boolean} isInit ?????????????????
         * @return {Object} ???????
         */
        setValue: function(value, isInit){
            var self = this,
                opts = self.options,
                def = null, exp = [],
                expFormat = $.extend({}, opts.formatList);
            if(opts.disable){
                return self;
            }
            value = $.type(value) === 'number' ? value + '' : value;
            //?????undefined?????????null
            value = value || null;
            //?????????????????
            value = $.type(value) !== 'array' ? [value] : value;
            //???
            opts.value = [];

            //????
            if(value.length != 0){
                def = _analysis($.extend(true,[],value), opts.format);

                if(!isInit){
                    //?§Ø?????????????
                    var max = _getLimitDate.call(self, 'maxdate', true);
                    var min = _getLimitDate.call(self, 'mindate', true);

                    $.each(def, function(i, item){
                        if(item != null){
                            if(max && item[0] - max > 0){
                                //?????????????????????????§¹
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

            //?Ú…??????
            expFormat.quarter = 'yyyy???q????';
            expFormat.week = 'yyyy???w??';

            //????????????????
            for(var i = 0; i < def.length; i ++){
                opts.value.push(def[i] ? def[i][1] : '');
                exp.push(def[i] ? C.Date.format(def[i][0],expFormat[opts.curModel[0]]) : '');
            }

            exp = exp.join('~');
            //??????????
            opts.inputEl.eq(0).val(/^.*~$/.test(exp) ? (exp = exp.replace('~','')) : exp);
            if(exp === ''){
                opts.inputEl.val(opts.emptytext).addClass('C_CR_calInput_empty');
            }else{
                opts.inputEl.removeClass('C_CR_calInput_empty');
            }

            //??§Ý??
            if(typeof opts.on_change === 'function' && !isInit){//&& opts.isBuild
                opts.on_change.apply(self, $.extend(true, [],def));
            }
            //???????????, ??? isInit ?true???????
            if(isInit){
                self.onValid();
            }else{
                self._triggerHandler('change');
            }

            //???????????
            return self;
        },

        /**
         * ?????
         * @param {String} reType ????????????????????? string | date??????string
         * @return {String | Array} ????????????? string | [string, string]
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
         * ??????????
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
         * ??????§³???
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
         * ????????¦¶
         * @param {String} reType ????????????????????? string | date??????date
         * @return {Array | Date | String} ???????????Date|[Date, Date]|[[Date, Date], [Date, Date]]
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
         * ??????????
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
         * ???????
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
            opts.readonly = flag;
        },

        /**
         * ??????
         */
        destroy: function(){
            var self = this,
                opts = self.options;
            self._super();
            opts.el.unbind().empty();
            opts.pEl && opts.pEl.remove();
        },

        /**
         * ?????????
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
         * ??????????????????
         * @return {Array}
         */
        getLabelValue: function(){
            var self = this,
                opts = self.options,
                labelValue = [],
                varType,
                jsonReg = /^(?:\{.*\}|\[.*\])$/;

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
         * ????????????
         * @param {CUI} cuiObj
         * @param {String} msg
         */
        onInValid: function(cuiObj, msg){
            var self = this,
                opts = self.options;
            opts.tipTxt = opts.tipTxt === null ? opts.el.attr('tip') : opts.tipTxt;
            opts.el.attr('tip', msg);
            for(var i = 0; i < opts.value.length; i ++){
                if(!opts.value[i]){
                    opts.el.children('.C_CR_calInput_bd').addClass(opts.inputErrClass);
                }
            }

        },

        /**
         * ?????????????
         * @param cuiObj
         */
        onValid: function(cuiObj){
            var self = this,
                opts = self.options;
            opts.tipTxt = opts.tipTxt === null ? opts.el.attr('tip') : opts.tipTxt;
            opts.el.attr('tip', opts.tipTxt || '');
            opts.el.children('.C_CR_calInput_bd').removeClass(opts.inputErrClass);
        }
    });

    //////////////////////////////////////////////////model//////////////////////////////////////////////////

    /**
     * ?????????????model????????????????
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
     * ???????¡ã????
     * @param {Date} date ???????
     * @param {Boolean} iso8601 ??ISO8601????????????ISO 8601 ?ÕÇ?????????????????????????
     * @param {Boolean} sundayFirst ????????????
     * @return {Array} ??????
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
     * ??????????????????§Ò??????????
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

        //??????????????????
        firstDay = new Date(curYear, curMonth, 1).getDay();
        //????????????????
        prevMonthSize = new Date(curYear, curMonth, 0).getDate();
        //?????????????
        curMonthSize = new Date(curYear, curMonth + 1, 0).getDate();

        //??????????????
        opts.sunday_first || firstDay --;
        if(firstDay < 0){
            firstDay = 6;
        }

        var isPrevYear = curMonth - 1 < 0 ? true : false,
            isNextYear = curMonth + 1 > 11 ? true : false;

        //???????????????
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

        //??????????
        for(i = 1; i <= curMonthSize; i++){
            tmpDate = new Date(curYear, curMonth, i, 0, 0, 0, 0);
            if(contrastDate(tmpDate, opts.mindate[1], 'mindate') || contrastDate(tmpDate, opts.maxdate[1], 'maxdate')){
                dis = 0;
            }else{
                dis = 1;
            }
            dates.push([i, dis, curYear, curMonth]);
        }

        //??????????????
        for(i = 1; i<= 42 - curMonthSize - firstDay; i ++){
            tmpDate = new Date(isNextYear ? curYear + 1 : curYear, isNextYear ? 0 : curMonth + 1, i, 0, 0, 0, 0);
            if(contrastDate(tmpDate, opts.mindate[1], 'mindate') || contrastDate(tmpDate, opts.maxdate[1], 'maxdate')){
                dis = 0;
            }else{
                dis = 1;
            }
            dates.push([i, dis, tmpDate.getFullYear(), tmpDate.getMonth()]);
        }

        //?????
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
     * ????????????????????¦¶??????????
     * @param {Number} year ???????????
     * @param {Number} range ??¦¶??range>0???year??????range<0???year???????
     * @return {Array}
     * @private
     * @example _getPanelYear(2000, 4);
     *          ????[2000,2001,2002,2003]
     *          _getPanelYear(2000, -4);
     *          ????[1997,1998,1999,2000]
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
     * ????????¦¶????¡¤??????12????
     * @param {Array} range ??¦¶?????[start, end]??????3????9?????[2,8]
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
        //???ISO8601?œZ??????????§Ø?????
        for(var i = 31; i > 0; i --){
            weekIndex = C.Date.getOnWeek(new Date(year, 11, i), iso8601, sundayFirst).week;
            if(weekIndex != 1){
                break;
            }
        }
        for(i = 1; i <= weekIndex; i ++){
            week.push([i,1]);
        }
        return week;
    }

    /**
     * ????????????????????????ú“?????????????[???????, ???????????????, year, month, date, hour, minute, second]
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
     * ????????§³???????????????
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
     * ??????????????
     * @param type {String} ???????? ??mindate??????maxdate??
     * @param hasHMS {Boolean} ?????????
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
            //??????????1????¨¹????????+1M??2??????????????'2012-10-15'??3?????jQuery????????'#endTime'
            if(/[\+\-]{1}[0-9]{1,}[yMd]{1}/.test(date)){
                var rules = date.split(','), rule, pos, tmpl = [0,0,0],
                    now = [new Date().getFullYear(), new Date().getMonth(), new Date().getDate()];
                //??????????
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
                        date = new Date(limit[0], now[1], limit[2]);break;
                }
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
     * YMer????????????????????????????????
     * @param {jQuery} $pEl ???jquery
     * @param {String} handle ?????????????hide|show|disYear|disMonth|dis|unDis
     * @private
     */
    function _domYMerHandle($pEl, handle){
        var $YMer = $pEl.children('.C_CR_YM_wrap');
        var disStyle = 'C_CR_tx_wrap_disable';
        if(handle === 'hide'){
            $YMer.hide();
        }else{
            switch (handle){
                case 'disYear':
                    $YMer.find('span.C_CR_YMer_tx_y').addClass(disStyle)
                        .parent().children('.C_CR_DisMark').show();
                    break;
                case 'disMonth':
                    var k = $YMer.find('span.C_CR_YMer_tx_m').addClass(disStyle)
                        .parent().children('.C_CR_DisMark').show();
                    break;
                case 'dis':
                    $YMer.find('span.C_CR_YMer_tx_wrap').addClass(disStyle)
                        .parent().children('.C_CR_DisMark').show();
                    break;
                case 'unDis':
                    $YMer.find('span.C_CR_YMer_tx_wrap').removeClass(disStyle)
                        .parent().children('.C_CR_DisMark').hide();
                    break;
                default:
                    $YMer.find('span.C_CR_YMer_tx_wrap').removeClass(disStyle)
                        .parent().children('.C_CR_DisMark').hide();
            }
            $YMer.show();
        }

    }

    /**
     * ????YMer??Label
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
     * ????pop??????
     * @param {jQuery} $tg
     * @param {String} type
     * @private
     */
    function _domPopHandle($tg, type){
        var self = this,
            opts = self.options,
            $pop;
        if(!opts.activePop && !$tg){
            return;
        }
        if(opts.activePop){
            opts.activePop.hide();
            opts.activePop.parents('div.C_CR_YMer_item').eq(0).children('span:eq(0)').removeClass('C_CR_tx_wrap_focus');
            opts.activePop.parent('.C_CR_Timer_tx_wrap').removeClass('C_CR_tx_wrap_focus');
        }
        if($tg){
            $tg.show();
            if(type === 'ym'){
                $pop = $tg.parents('div.C_CR_YMer_item').eq(0).children('span:eq(0)');
            }else{
                $pop = $tg.parent('.C_CR_Timer_tx_wrap');
            }
            $pop.addClass('C_CR_tx_wrap_focus');
            opts.activePop = $tg;
        }
    }

    /**
     * ??????
     * @private
     */
    function _domBtnHandle(){
        var self = this, opts = self.options,
            $btn = opts.pEl.children('.C_CR_OPBar_wrap').children('a').show(),
            $okbtn = $btn.filter('[val^="ok"]'),
            $clearbtn = $btn.filter('[val^="clear"]'),
            $curbtn = $btn.filter('[val^="cur"]'),
            label = {date: '??&nbsp;??', month: '??&nbsp;??', year: '??&nbsp;??', quarter: '??????', week: '??&nbsp;??'};
        $curbtn.html(label[opts.curModel[0]]);
        opts.okbtn || $okbtn.hide();
        opts.clearbtn || $clearbtn.hide();
    }

    /**
     * ????????
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
     * ?????
     * @param {jQuery} $tg ????JQ???
     * @param {String} type ???????
     * @param {Array} data ???
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
     * ??????????
     * @param {Object} opts ???????
     * @private
     */
    function _domSetWidth(opts){
        var num = opts.panel;
        var width = 209 * num;
        opts.pEl.css('width',width + 3 * (opts.panel - 1));

        var domWidth = opts.pEl.outerWidth();
        var domHeight = opts.pEl.outerHeight();

        //???IE6??JCT??????????????iframe?????select???????????????iframe??????
        if(C.Browser.isIE6 || C.Browser.isQM){
            opts.pEl.find('iframe').css({
                width: domWidth,
                height: domHeight
            });
        }
    }

    /**
     * ????¦Ë??
     * @param {Object} opts ???????
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
            css = {};

        if(inpOffset.left + domWidth > winWidth + winSL){
            if(inpOffset.left + inpWidth > domWidth){
                css.left = inpWidth + inpOffset.left - domWidth;
            }else if(winWidth > domWidth || winWidth < domWidth){
                css.left = 0;
            }
        }else{
            css.left = inpOffset.left;
        }

        if(inpOffset.top + inpHeight + domHeight > winHeight + winST){
            if(inpOffset.top - domHeight > 0 && inpOffset.top - winST){
                css.top = inpOffset.top - domHeight;
            }else if(inpOffset.top < winHeight + winST - inpOffset.top - inpHeight){
                css.top = inpOffset.top + inpHeight;
            }
        }else{
            css.top = inpOffset.top + inpHeight;
        }

        opts.pEl.css(css);

        if(!opts.isBuild){
            opts.isBuild = true;
        }
    }
})(window.comtop.cQuery , window.comtop);