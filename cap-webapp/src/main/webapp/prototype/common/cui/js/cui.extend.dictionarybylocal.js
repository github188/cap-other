/**
 * 模块: CUI组件 PullDown、Radio、checkbox类 数据字典重构
 * 林超群 2015-01-09
 */
;(function(C, $){
    var webRoot = (webPath||$('#cuiExtendDictionary').attr('webRoot')) + '/top/cfg/getAllValue.ac';
    var PullDown = C.UI.PullDown.prototype;
    var SinglePullDown = C.UI.SinglePullDown.prototype;
    var MultiPullDown = C.UI.MultiPullDown.prototype;
    var Radio = C.UI.RadioGroup.prototype;
    var CheckBox = C.UI.CheckboxGroup.prototype;
    Radio.options = $.extend(Radio.options, {
        action: webRoot,
        value_field: 'value',
        label_field: 'text',
        dictionary: ''
    });
    CheckBox.options = $.extend(CheckBox.options, {
        action: webRoot,
        value_field: 'value',
        label_field: 'text',
        dictionary: ''
    });
    SinglePullDown.options = $.extend(SinglePullDown.options, {
        action: webRoot
    });
    MultiPullDown.options = $.extend(MultiPullDown.options, {
        action: webRoot
    });
    PullDown._initData = function(){
        var opts = this.options,
            datasource, type,
            list = this.templateBox.find("a[value]"),
            len = list.length,
            i, item, valueField, labelField;
        //通过模版创建
        if (len) {
            valueField = opts.value_field;
            labelField = opts.label_field;
            datasource = [];
            //读取模板，转换成数据
            for (i = 0; i < len; i++) {
                item = datasource[i] = {};
                item[valueField] = list.eq(i).attr("value");
                item[labelField] = $.trim(list.eq(i).html());
            }
        }
        datasource = datasource || opts.datasource;
        type = $.type(datasource);
        if(opts.dictionary === ''){
            if (type === "function") {
                //异步调用常用，如果没有设置值，先不调用，点击时再调用。
                if(opts.value !== '' || opts.select !== -1) {
                    this._callDataSource();
                } else {
                    //隐藏loading
                    this.$btn.removeClass("pulldown-loading");
                }
            } else if(type === "array"){
                this.setDatasource(datasource);
            } else {
                this.setDatasource([]);
            }
        }else{
            var self = this;
            self.setDatasource(cap.getDicByCode(opts.dictionary));
        }

    };

    Radio._create = function(){
        if (this.create) {
            return ;
        }
        var type = this.type,
            list = this.options[type + "_list"],
            listType = $.type(list),
            el = this.el,
            inner = document.createElement("div");
        this.inner = $(inner).html(el.html());
        this.inputs = this.inner.find("input");
        this.size = this.inputs.length;
        inner.className = type + "group-inner";
        if (this.options.border) {
            this.inner.addClass(type + "group-border");
        }
        el.html(inner);
        if(this.options.dictionary === ''){
            //判断数据
            if (listType === "function") {//回调函数
                list(this);
            } else if (listType === "array" && !this.size) {//Json
                this._setDatasource(list);
            } else if (this.size) {
                this._setDatasource(this._initData());
            } else {//都不是
                throw new Error(type + "_list's type not is a array or a function.");
            }
        }else{
            var self = this;
            self.setDatasource(cap.getDicByCode(self.options.dictionary));
        }
        this.create = true;
    };
    Radio._renderHtml = function () {
        var opts = this.options,
            data = this.data,
            name = opts.name,
            readonly = opts.readonly,
            texts = this.texts,
            values = this.values,
            colors = this.colors,
            length = this.size,
            direction = opts.direction,
            br = opts.br,
            brLen = br.length,
            brPosition = {},
            type = this.type,
            guid = this.guid,
            i, j,
            html = [],
            valueI, textI,
            readonlyList = this.readonly_list;
        //确定换行位置
        if (brLen) {
            for (j = brLen; j--;) {
                brPosition[br[j]] = true;
            }
        }
        //生成模版
        for (i = 0; i < length; i ++) {
            if (i !== 0 && direction === "vertical" || brPosition[i]) {
                html.push ('<br />');
            }
            valueI = values[i] = data[i][opts.value_field]+"";
            this.orignalValues.push(data[i][opts.value_field]);
            textI = texts[i] = data[i][opts.label_field];
            if (readonly || data[i].readonly) {
                readonlyList[valueI] = i;
            }
            colors[i] = data[i].color;
            html.push(
                '<label for="', guid, i,'">',
                '<input id="', guid, i, '" type="', type, '" name="', name, '" value="', valueI, '" index="', i, '" hidefocus="true" />',
                textI,
                '</label>'
            );
        }
        this.inner.html(html.join(""));
        this.inner = this.el.children().eq(0);
        this.labels = this.el.find("label");
        this.inputs = this.el.find("input");
        this._inputsAction();
    };
    CheckBox._create = function(){
        if (this.create) {
            return ;
        }
        var type = this.type,
            list = this.options[type + "_list"],
            listType = $.type(list),
            el = this.el,
            inner = document.createElement("div");
        this.inner = $(inner).html(el.html());
        this.inputs = this.inner.find("input");
        this.size = this.inputs.length;
        inner.className = type + "group-inner";
        if (this.options.border) {
            this.inner.addClass(type + "group-border");
        }
        el.html(inner);
        if(this.options.dictionary === ''){
            //判断数据
            if (listType === "function") {//回调函数
                list(this);
            } else if (listType === "array" && !this.size) {//Json
                this._setDatasource(list);
            } else if (this.size) {
                this._setDatasource(this._initData());
            } else {//都不是
                throw new Error(type + "_list's type not is a array or a function.");
            }
        }else{
            var self = this;
            self.setDatasource(cap.getDicByCode(self.options.dictionary));
        }
        this.create = true;
    };
})(window.comtop, window.comtop.cQuery);