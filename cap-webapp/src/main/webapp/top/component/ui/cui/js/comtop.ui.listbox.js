?;(function($, C){
    C.UI.ListBox = C.UI.Base.extend({
        options:{
            uitype:'ListBox',
            //组件宽度
            width:'200',
            //组件高度
            height:'200',
            //组件名
            name:'listboxName',
            //默认值
            value:'',
            //记录数据集中隐藏列名
            value_field: 'id',
            //记录数据集中显示列名
            label_field: 'text',
            //是否多选
            multi:false,
            //文本模式
            textmode:false,
            //接收数据
            datasource:null,
            //双击触发的方法
            on_dbclick:null,
            //单击触发的方法
            on_click:null,
            //选中改变时触发
            on_select_change:null,
            //添加行时触发
            on_add:null,
            //删除行时触发
            on_remove:null,

            //图标路径
            icon_path:null
        },
        //欲渲染元素
        $el:null,
        //组件根元素
        listbox:null,
        //提交域元素
        hiddenEl:null,
        //是否渲染模板
        //renderTemplate:false,
        //模板变量名
        listTemplateName:'cListBox',
        //主键列名
        valueField:null,
        //显示列名
        labelField:null,
        //加载数据
        //loadData:null,
        //多选时，记录第一次选的元素
        priorElement:null,
        //数据模板名
        rowTemplateName:'cListBoxRow',
        /**
         * @param options  参数配置信息
         * @private
         */
        _init:function(options){
            this.$el = $(this.options.el);
            this._initParams();
            this.$el.addClass('cui');
        },
        _create:function(){
            //如果datasource为function，则执行
            if (typeof this.options.datasource == 'function') {
                this.options.datasource(this, {});
            }
            this.listbox = $('.listbox',this.$el);
            this.hiddenEl = $('[type=hidden]',this.$el);
            this.valueField = this.options.value_field;
            this.labelField = this.options.label_field;
            this._setConfiguration();
            //赋初始值
            this._setDefaultText();
        },
        //初始化参数
        _initParams:function(){
            //解析html模板
            this._analysisHtmlTemplate();
        },
        /**
         * 解析html模板，获取数据源
         */
        _analysisHtmlTemplate:function(){
            var $tag = $('a',this.$el);
            if($tag == null || typeof $tag == 'undefine' || $tag.length < 1){
                return ;
            }
            var valueField = this.options.value_field;
            var labelField = this.options.label_field;
            var dataArray = [];

            $.each($tag,function(index,item){
                var record = {};
                record[labelField] = $.trim($(this).text());
                record[valueField] = $.trim($(this).attr('value'));
                dataArray.push(record);
            });
            this.$el.html("");
            this.options.datasource = dataArray;
        },
        /**
         * 初始化组件
         */
        _setConfiguration:function(){
            this.listbox.width(this.options.width);
            this.listbox.height(this.options.height);
        },


        _selectChangeCallback: function(){
            var selectChange = this.options.on_select_change;

            if($.type(selectChange) === 'string'){
                window[selectChange](this.getSelectedRows());
            }else if($.isFunction(selectChange)){
                selectChange(this.getSelectedRows());
            }
        },
        /**
         * 设置数据
         */
        setDatasource:function(result){
            this.options.datasource = result;
            //if(this.renderTemplate){
            this._renderElement();
            //}
        },
        /**
         * 重新渲染模板元素
         */
        setMulti: function (flag) {
            var opt = this.options;
            if (opt.multi === flag || typeof flag !== 'boolean') {
                return;
            } else {
                opt.multi = flag;
                this.cancelSelected();
            }
        },
        _renderElement:function(){
            var $tr = $(".tr",this.$el);
            //重新加载列表模板
            this._buildTemplate($tr,this.rowTemplateName,this.options);
        },
        /**
         * 赋初始值
         */
        _setDefaultText:function(){
            if(this.options.value){
                var $tr = $(".tr",this.$el);
                var valArray = this.options.multi? this.options.value.split(';'):this.options.value;
                var valueField = this.options.value_field;
                //组件值
                var componentValue = [];
                var datasource = this.options.datasource;
                var self = this;
                $.each(datasource,function(index,value){
                    if(self.options.multi){
                        $.each(valArray,function(i,item){
                            if(item == value[valueField]){
                                $("li[name=" + item +  "]",$tr).addClass('selected');
                                componentValue.push(value[valueField]);
                            }
                        })
                    }else{
                        if(valArray == value[valueField]){
                            $("li[name=" + valArray +  "]",$tr).addClass('selected');
                            componentValue.push(value[valueField]);
                        }
                    }
                });
                this.hiddenEl.val(componentValue.join(';'));
            }
        },
        /**
         * 设置组件宽度
         * @param widthVal
         */
        setWidth:function(widthVal){
            this.listbox.width(widthVal);
        },
        /**
         * 获取指定数据记录
         * 返回指定数据记录
         * @param keyVal  valueField列的记录
         */
        getRecordData:function(keyVal){
            var self = this;
            var recordData = null;
            var datasource = this.options.datasource;
            //遍历数据
            $.each(datasource,function(index,item){
                if(item[self.valueField] == keyVal){
                    recordData = item;
                    return false;
                }
            });
            return recordData;
        },
        /**
         * 供文本模式调用的方法
         */
        getLabelValue:function(){
            if(this.options.value == '' || !this.options.textmode){
                return "";
            }
            var valArray = this.options.value.split(';');
            var valueField = this.options.value_field;
            var labelField = this.options.label_field;
            //组件值
            var componentValue = [];
            $.each(this.options.datasource,function(index,value){
                $.each(valArray,function(i,item){
                    if(item == value[valueField]){
                        componentValue.push(value[labelField]);
                    }
                })
            });
            return componentValue.join(';');

        },
        /**
         * 删除指定数据
         * return 返回删除的数据值
         */
        deleteRecordData:function(keyVal){
            var self = this;
            var recordData = null;
            var data = this.options.datasource;
            var componentArray = [];

            if(this.hiddenEl.val() != ''){
                componentArray = this.hiddenEl.val().split(';')
            }

            //遍历数据
            $.each(data,function(index,item){
                if(item[self.valueField] == keyVal){
                    recordData = item;
                    data.splice(index,1);
                    componentArray.pop(keyVal);
                    return false;
                }
            });
            this.hiddenEl.val(componentArray.join(';'));
            return recordData;
        },
        /**
         * 获取组件值
         * 返回组件值
         */
        getValue:function(){
            //原来:return this.hiddenEl.val()
            var value_field = this.options.value_field;
            var rowList = [];
            var SelectedRows = this.getSelectedRows();
            SelectedRows = SelectedRows === null ? [] : (this.options.multi ? SelectedRows : [SelectedRows]);

            $.each(SelectedRows, function(index, item) {
                rowList.push(item[value_field]);
            });
            return rowList.join(';');
        },
        /**
         * 获得数据显示列值
         */
        getText:function(){
            var self = this;
            var rowList = [];
            var SelectedRows = this.getSelectedRows();
            SelectedRows = SelectedRows === null ? [] : (this.options.multi ? SelectedRows : [SelectedRows]);
            $.each(SelectedRows, function(index, item) {
                rowList.push(item[self.labelField]);
            });
            return rowList.join(';');
        },
        /**
         * 设置组件值
         * @param arrayVal string 每个数用;分隔
         */
        setValue:function(value){
            //将一些数值转为数组
            var strValue = value + '';
            //如果为多选
            var arrayValue = strValue.split(';');

            if(!this.options.multi && arrayValue.length > 1){
                //如果设置成单选，则不能设多值
                return ;
            }
            //组件值
            var componentValue = [];
            //取消所有行
            this.cancelSelected();
            //高亮显示所选数组
            $(".td",this.$el).each(function(index,item){
                if($.inArray($(this).attr('name'),arrayValue) >= 0){
                    componentValue.push($(this).attr('name'));
                    $(this).addClass('selected');
                }
            });
            this.hiddenEl.val(componentValue.join(';'));
        },
        /**
         * 添加数据对象
         * @param rowList
         */
        addRows:function(rowList){
            var appendDataList = [];
            var self = this;
            var bFlag = true;

            if(rowList == null || rowList.length <1){
                return ;
            }

            var rowArray = rowList;
            if($.isPlainObject(rowList)){
                rowArray = [];
                rowArray.push(rowList);
            }
            if(this.options.datasource != null){
                //获取非重复数据
                $.each(rowArray,function(index,item){
                    bFlag = true;
                    $.each(self.options.datasource,function(i,val){
                        if(val[self.valueField] === item[self.valueField]){
                            bFlag = false;
                            return false;
                        }
                    })
                    if(bFlag){
                        appendDataList.push(item);
                    }
                });
                if(appendDataList.length < 1){
                    return ;
                }
            }else{
                appendDataList = rowArray;
                self.options.datasource = [];
            }
            var opt = $.extend({},this.options);
            //转为展示数据
            opt.datasource = appendDataList;
            //加载数据
            this.options.datasource = this.options.datasource.concat(appendDataList);
            //渲染添加数据模板
            this._buildTemplate($('.tr',this.$el),this.rowTemplateName,opt,true);

            var add = this.options.on_add;

            if($.type(add) === 'string'){
                window[add](appendDataList);
            }else if($.isFunction(add)){
                //传入增加的数据
                add(appendDataList)
            }
        },
        /**
         * 移除行
         * @param keyVal id值
         */
        removeRow:function(keyVal){
            var self = this;
            var removeData = null;
            var $current = $('li[name=' + keyVal + ']',this.$el);

            if($current){
                removeData = this.deleteRecordData(keyVal);
                $current.remove();
            }

            var remove = this.options.on_remove;

            if($.type(remove) === 'string'){
                window[remove]([removeData]);
            }else if($.isFunction(remove)){
                //传入删除的数据
                remove([removeData]);
            }
            return removeData;
        },
        /**
         * 移除选中行
         */
        removeSelectedRows:function(){
            var removedList = [];
            var self = this;

            $(".selected",this.$el).each(function(index,item){
                removedList.push(self.deleteRecordData($(this).attr('name')));
                $(this).remove();
            });

            var remove = this.options.on_remove;

            if($.type(remove) === 'string'){
                window[remove](removedList);
            }else if($.isFunction(remove)){
                //传入删除的数据
                remove(removedList);
            }
            return removedList;
        },
        /**
         * 移除所有行并清除所有数据
         * @return 移除的数据集合
         */
        removeAllRows:function(){
            var removedList = [];
            var self = this;
            var resultData ;
            var data = this.options.datasource;

            $(".td",this.$el).remove();
            if(data != null && data.length > 0){
                removedList = data.splice(0,data.length);
            }
            //清除隐藏域的值
            this.hiddenEl.val('');

            var remove = this.options.on_remove;

            if($.type(remove) === 'string'){
                window[remove](removedList);
            }else if($.isFunction(remove)){
                //传入删除的数据
                remove(removedList);
            }
            return removedList;
        },
        /**
         * 获取某行数据
         * @param index 行号，首行为0或者是组件值
         * return 行数据
         */
        getRow:function(index){
            var size = this.getRowSize();
            var recordData = null;

            if(index < size){
                var rowVal = $('.td',this.$el).eq(index).attr('name');
                recordData = this.getRecordData(rowVal);
            }
            return recordData;
        },
        /**
         * 获取所有选中行记录集合
         * return 所有选中数据数组
         */
        getSelectedRows:function(){
            var selectList = this.options.multi?[]:null;
            var self = this;

            $(".selected",this.$el).each(function(index,item){
                if(self.options.multi){
                    selectList.push(self.getRecordData($(this).attr('name')));
                }else{
                    selectList = self.getRecordData($(this).attr('name'));
                }
            });
            return selectList;
        },
        /**
         * 选中指定行
         * @param index  行号
         */
        selectRow:function(index){
            var componentArray = [];

            if(this.hiddenEl.val() != ''){
                componentArray = this.hiddenEl.val().split(';')
            }

            if(index >=0 && index < this.getRowSize()){
                $('.td',this.$el).eq(index).addClass('selected');
                componentArray.push($('.td',this.$el).eq(index).attr('name'));
                this.hiddenEl.val(componentArray.join(';'));
            }

            this._selectChangeCallback();
        },
        /**
         * 选中所有行
         */
        selectAllRows:function(){
            if(!this.options.multi){
                //如果不是多选，则不能选中所有行
                return ;
            }
            var componentArray = [];

            $(".td",this.$el).each(function(index,item){
                $(this).addClass('selected');
                componentArray.push($(this).attr('name'));
            });
            this.hiddenEl.val(componentArray.join(';'));

            this._selectChangeCallback();
        },
        /**
         * 取消所有选中行
         */
        cancelSelected:function(){
            $(".selected",this.$el).each(function(index,item){
                $(this).removeClass('selected');
            });
            this.hiddenEl.val('');

            this._selectChangeCallback();
        },
        /**
         * 获取所有行数据
         */
        getAllRows:function(){
            return this.options.datasource;
        },
        /**
         * 移动行
         * @param srcIndex 原序号
         * @param targetIndex 移动的目标序号
         */
        moveRow:function(srcIndex,targetIndex){
            var size = this.getRowSize();

            if(srcIndex >= 0 && srcIndex < size && targetIndex >= 0 && targetIndex < size && srcIndex != targetIndex){
                var rowEl = $('.td',this.$el);
                if(srcIndex < targetIndex){
                    rowEl.eq(targetIndex).after(rowEl.eq(srcIndex));
                }else{
                    rowEl.eq(targetIndex).before(rowEl.eq(srcIndex));
                }
                this.options.datasource.splice(targetIndex,0,this.options.datasource.splice(srcIndex,1)[0]);
            }
        },
        /**
         * 向上移动选中的行
         */
        moveUp: function() {
            var selectedRows=this.getSelectedRows();
            var size = this.getRowSize();
            var index ;

            for(var i=0,j=selectedRows.length; i < j;i++){
                index=this._getRowIndexByName(selectedRows[i][this.valueField]);
                if(index==0){break;}
                this.moveRow(index,index-1);
            }
        },
        /**
         * 向下移动选中行
         */
        moveDown: function() {
            var selectedRows=this.getSelectedRows();
            var rowSize = this.getRowSize();
            var index ;

            for(var i=selectedRows.length-1;i>=0;i--){
                index=this._getRowIndexByName(selectedRows[i][this.valueField]);
                if(index == (rowSize-1) ){break;}
                this.moveRow(index,index+1);
            }
        },
        /**
         * 获得行数
         */
        getRowSize:function(){
            return $('.td',this.$el).length;
        },
        /**
         * 获取数据记录
         */
        _getRowDataByKey:function(keyVal){
            var self = this,data = this.options.datasource;
            var resultRecord = null;
            $.each(data,function(index,item){
                if(item && item[self.valueField] == keyVal){
                    resultRecord = item;
                    return false;
                }
            });
            return resultRecord;
        },
        /*
         * 根据name获取行号
         */
        _getRowIndexByName:function(rowName){
            var index = $('li',this.$el).index($('li[name=' + rowName + ']',this.$el));
            return index;
        },
        /**
         * 单击行触发事件
         * @param event
         * @param element
         * @private
         */
        _rowClick:function(event,element,target){
            var select = 'selected';
            var $element = $(element);
            var componentArray = [];

            if(this.hiddenEl.val() != ''){
                componentArray = this.hiddenEl.val().split(';')
            }
            //如果是选中，则恢复为未选状态
            if($element.hasClass(select)){
                this.priorElement = null;
                $element.removeClass(select);
                var name = $element.attr('name');
                for(var i=0,j=componentArray; i<j;i++){
                    if(componentArray[i] == $element.attr('name')){
                        componentArray.splice(i,1);
                        break;
                    }
                }
            }else if(!this.options.multi){
                //单选处理
                $(".selected",this.$el).each(function(index,item){
                    $(this).removeClass('selected');
                });
                this.hiddenEl.val('');

                $element.addClass(select);
                componentArray = [];
                componentArray.push($element.attr('name'));
            }else if(this.options.multi && event.shiftKey){
                //多选处理
                if(this.priorElement == null){
                    this.priorElement = $element.attr('name');
                    componentArray.push(this.priorElement);
                }else{
                    var currenIndex = this._getRowIndexByName($element.attr('name'));
                    var preIndex = this._getRowIndexByName(this.priorElement);
                    var rowEl = $('.td',this.$el);

                    $(".selected",this.$el).each(function(index,item){
                        $(this).removeClass('selected');
                    });
                    this.hiddenEl.val('');

                    for(var i = Math.min(currenIndex, preIndex),j = Math.max(currenIndex, preIndex); i <= j; i++) {
                        rowEl.eq(i).addClass(select);
                        componentArray.push(rowEl.eq(i).attr('name'));
                    }
                }
                $element.addClass(select);
            }else{
                this.priorElement = $element.attr('name');
                componentArray.push(this.priorElement);
                //多选处理
                $element.addClass(select);
            }
            this.hiddenEl.val(componentArray.join(';'));

            var click = this.options.on_click;
            if($.type(click) === 'string'){
                var name = $(element).attr('name');
                window[click](this._getRowDataByKey(name));
            }else if($.isFunction(click)){
                var name = $(element).attr('name');
                click(this._getRowDataByKey(name));
            }

            this._selectChangeCallback();
        },
        /**
         * 双击行触发事件
         * @param event
         * @param element
         */
        _rowDblClick:function(event,element,target){
            var dbclick = this.options.on_dbclick;

            if($.type(dbclick) === 'string'){
                var name = $(element).attr('name');
                window[dbclick](this._getRowDataByKey(name));
            }else if($.isFunction(dbclick)){
                var name = $(element).attr('name');
                dbclick(this._getRowDataByKey(name));
            }
        },
        /**
         * 鼠标移入
         * @param event
         * @param element
         * @private
         */
        _trhoverin:function(event,element,target){
            var hc = 'hover';
            $(element).addClass(hc);
        },
        /**
         * 鼠标移除
         * @param event
         * @param element
         * @private
         */
        _trhoverout:function(event,element,target){
            var hc = 'hover';
            $(element).removeClass(hc);
        },
        //el元素缓存数据
        _setCacheData:function(key,value){
            //将数据缓存至el元素中
            this.$el.data(key,value);
        },
        //el元素获取缓存数据
        _getCacheData:function(key){
            return this.$el.data(key);
        },
        //el元素移除缓存数据
        _removeCacheData:function(key){
            this.$el.removeData(key);
        }
    });
})(window.comtop.cQuery, window.comtop);