/**
 * 任务栏组件群（包含任务栏、任务窗口和微件窗口）
 * 2014-7-15
 */
define(["json2","workbench/platform/js/templateDrag","underscore", "jqueryui", "cui"], function(json2, Drag, _, jqui, cui) {
    'use strict';
    /**
     * Portlet窗口类
     * @param options
     * @returns {PortletDialog}
     * @constructor
     */
    function PortletDialog(templateId){
        var self = this;
        self.options = {
            templateId: templateId
        };
        //创建PortletDialog对象
        self._dialog = null;
        //创建portletDialog对象
        self.$portletDialog = $('#portletDialog');
        //整理过后的数据
        self._data = {};
        //数据备份
        self._dataBak = {};
        //添加的portlet数据
        self._addData = [];
        //分类数量
        self._classNum = [];
        self._init();
        return self;
    }
    PortletDialog.prototype = {
        _init: function(){
            var self = this;
            //创建Dialog
            self._create();
            //事件绑定
            self._bindEvent();
            //获取数据
            //self._getData();
        },
        /**
         * 创建窗口
         * @private
         */
        _create: function(){
            var self = this;
            //判断创建任务项Dialog是否已经存在，如果存在，则直接打开
            self._dialog = cui('#portletDialog').dialog({
                title: '添加微件',
                width: 680,
                height: 420,
                page_scroll: false,
                onClose: function(){
                    self._reset();
                },
                buttons: [
                    {
                        name: '确定',
                        handler: function(){
                            self._save();
                            this.hide();
                        }
                    },
                    {
                        name: '取消',
                        handler: function(){
                            this.hide();
                        }
                    }
                ]
            });
        },
        /**
         * 事件绑定
         * @private
         */
        _bindEvent: function(){
            var self = this, id;
            self.$portletDialog.delegate('.class-list a, .portlet-list a', 'click.task', function(e){
                var $t = $(e.target);
                if($t[0].nodeName === 'A'){
                    switch ($t.data('action')){
                        case 'tag':
                            id = $t.attr('id');
                            self.selectTag(id);
                            self._createPortletList(id);
                            break;
                        case 'portlet':
                            self._pushPortlet($t.data('id'));
                            break;
                        default :
                            break;
                    }
                }else if($t[0].nodeName === 'SPAN' && $t.parent().data('action') === 'tag'){
                    id = $t.parent().attr('id');
                    self.selectTag(id);
                    self._createPortletList(id);
                }

                return false;
            });
        },
        /**
         * 获取数据
         * @private
         */
        _getData: function(){
            var self = this;
            TemplateAction.getAllPortlet(function(data) {
                data = json2.parse(data);
                self._dataHandle(data);
            });
        },
        /**
         * 数据处理
         * @param data
         * @private
         */
        _dataHandle: function(data){
            var self = this, html = [], tag, tags = [], id, reg,
                i, iLen, uuid = new Date().getTime();
            //所有portletDialog数据
            self._dataBak.portlet = data.portlet;
            self._dataBak.tag = data.tag;


            //创建分类DOM
            html.push('<li><a id="ptAll" href="#" class="cur" data-action="tag">全部（<span>', data.portlet.length ,'</span>）</a></li>');
            data.tag.reverse();
            for(i = 0, iLen = data.tag.length; i < iLen ;i ++){
                tag = data.tag[i];
                id = 'pt' + (uuid ++);
                self._data[id] = [];
                tags.push(tag.portletTag + '||' + id);
                html.push(
                    '<li>',
                    '<a id="', id ,'" href="#" data-action="tag">',
                    tag.portletTag, '(<span>', tag.count,'</span>)',
                    '</a>',
                    '</li>'
                );
            }
            self.$portletDialog.find('.class-list').html(html.join(''));

            //portlet按分类划分
            tags = tags.join(';') + ';';
            for(i = 0, iLen = data.portlet.length; i < iLen; i ++){
                tag = data.portlet[i];
                reg = new RegExp(tag.portletTag + '\\|\\|(pt[0-9]*)\\;');
                id = tags.match(reg)[1];
                self._data[id].push(tag);
            }
            self._createPortletList();
        },
        /**
         * 重设
         * @private
         */
        _reset: function(){
            var self = this;
            self._data = {};
            self._dataBak = {};
            self._addData = [];
            self._classNum = [];
            self._getData();
        },
        /**
         * 保存创建微件
         * @private
         */
        _save: function(){
            var data = this._addData,
                self = this,
                leftData = [], rightData = [];

            for(var i = 0, len = data.length; i < len; i ++) {
                data[i].editAble = '1';
                if (data[i].portletPosition === '0') {
                    leftData.push(data[i]);
                } else {
                    rightData.push(data[i]);
                }
            }
            self._createColumn({
                "listLeftPortlets": leftData,
                "listRightPortlets": rightData
            },'append');

            checkColumn();
            
        },
        /**
         * 计算微件数量
         * @param data
         * @private
         */
        _countNum: function(data){
            var self = this;
            for(var i = 0, len = self._dataBak.tag.length; i < len; i ++){
                self._classNum[i] = self._classNum[i] === undefined ? 0 : self._classNum[i];
                if(self._dataBak.tag[i].portletTag === data.portletTag){
                    self._classNum[i] += 1;
                }
            }
        },
        /**
         * 创建portletList列表
         * @param id {String} 分类ID
         * @private
         */
        _createPortletList: function(id){
            var self = this,
                html = [],
                data,
                dataList = self._data[id] || self._data;

            if(!id || id === 'ptAll'){
                for(var p in dataList){
                    html = html.concat(createHTML(dataList[p]));
                }
            }else{
                html = createHTML(dataList);
            }
            self.$portletDialog.find('.portlet-list').html(html.join(''));

            function createHTML(data){
                var html = [];
                for(var i = 0; i < data.length; i ++){
                    //如果已经存在，则不再渲染出来
                    if($('#' + data[i].portletId).length){
                        continue;
                    }
                    id || self._countNum(data[i]);
                    html.push(
                        '<dl>',
                        '<dt>',
                        '<span><img src="', (data[i].picAddress === null ? webPath + '/top/workbench/platform/img/blank.png' :
                            webPath + '/top/workbench/platform/img/' + data[i].picAddress) ,'" alt=""/></span>',
                        (!data[i].isCreate ? ('<a href="#" data-action="portlet" data-id="'+ data[i].portletId +
                            '" id="pl'+ data[i].portletId +'">添加</a>'):'<i>已添加</i>') ,
                        '</dt>',
                        '<dd>',
                        '<strong>', data[i].portletName ,'</strong>',
                        '<span>', data[i].portletDescribe ,'</span>',
                        '</dd>',
                        '</dl>'
                    );
                }
                return html;
            }
            if(id){
                return;
            }
            var $classList = $('.class-list>li'),
                total = 0;

            //如果没有微件可以添加，则清空统计数据
            if(self._classNum.length === 0){
                for(var i = 1, len = self._dataBak.tag.length + 1; i < len; i ++){
                    $classList.eq(i).find('span').text(0);
                }
            }
            for(var i = 1, iLen = self._classNum.length + 1; i < iLen ;i ++){
                total += self._classNum[i - 1];
                $classList.eq(i).find('span').text(self._classNum[i - 1]);
            }
            $classList.eq(0).find('span').text(total);
            self._classNum = [];
        },
        /**
         * 加入portlet列表
         * @param id
         */
        _pushPortlet: function(id){
            var self = this,
                data = self._dataBak.portlet;
            for(var i = 0, len = data.length; i < len; i ++){
                if(data[i].portletId === id + ''){
                    data[i].isCreate = true;
                    data = data[i];
                    break;
                }
            }
            //添加portlet默认是1
            data.editable = '1';
            self._addData.push(data);
            $('#pl'+id).replaceWith('<i>已选择</i>');
        },
        /**
         * 添加列数据
         * @param data
         * @param type
         * @private
         */
        _createColumn: function(data){
            var column1, column2, html = $('#portlet-tmpl').html();

            //加载左侧html
            column1 = _.template(html, {
                portletAry : data.listLeftPortlets
            });
            //加载右侧html
            column2 = _.template(html, {
                portletAry : data.listRightPortlets
            });

            $('#columns').children('.column1').append(column1);
            $('#columns').children('.column2').append(column2);

            //初始化portlet组件
            Drag.init();

        },
        /**
         * 标签样式切换
         * @param id
         */
        selectTag: function(id){
            var self = this,
                $tags = self.$portletDialog.find('.class-list a');
            id = id || 'ptAll';
            $tags.removeClass('cur');
            $('#' + id).addClass('cur');
        },
        show: function(id){
            var self = this;
            self.options.taskID = id;
            self._reset();
            self._dialog.show();
            return self;
        },
        hide: function(){
            var self = this;
            self._dialog.hide();
            return self;
        }
    };

    window.checkColumn = function(){
        var $cols = $('#columns'),
            $col1Length = $cols.children('.column1').children().length,
            $col2Length = $cols.children('.column2').children().length;
        if($col1Length === 0){
            $cols.addClass('column-full');
        }else{
            $cols.removeClass('column-full');
        }

        if($col1Length === 0 && $col2Length === 0){
            $('.task-portlet-tip').show();
        }else{
            $('.task-portlet-tip').hide();
        }

    };

    //暴露任务栏类
    return PortletDialog;
});