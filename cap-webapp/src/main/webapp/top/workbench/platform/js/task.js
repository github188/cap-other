/**
 * 任务栏组件群（包含任务栏、任务窗口和微件窗口）
 * 2014-7-15
 */
define(["json2","workbench/platform/js/drag","underscore", "jqueryui",
    "cui",'cui.storage'], function(json2, Drag, _, jqui, cui, _cst) {
    'use strict';
    //桌面DOM缓存
    window._taskDeskTopCache = {};
    //桌面是否存在变更
    window._taskHasChange = false;

    /**
     * Task窗口类
     * @param options
     * @returns {TaskDialog}
     * @constructor
     */
    function TaskDialog(options){
        var self = this;
        self.options = $.extend({
            defaultTemplate: 'blankTemplate',       //默认桌面模板名称
            okHandle: null                  //确定按钮处理事件
        }, options);

        //创建任务Dialog对象
        self._dialog = null;
        //创建任务Dialog内部内容JQ对象
        self.$taskDialog = $('#taskDialog');
        //模板JQ对象
        self.$taskTemplate = null;//self.$taskDialog.find('a');
        //上一个选择的模板
        self.$lastSelectTemplate = null;
        //taskName CUI对象
        self.cuiTaskName = null;
        //任务数据
        self.taskData = {};
        //状态，默认是新增  new/set
        self.state = 'new';

        self._init();
        return self;
    }
    TaskDialog.prototype = {
        /**
         * 任务栏初始化
         * @private
         */
        _init: function(){
            var self = this;
            self._create();
            //事件绑定
            self._bindEvent();
            //self._createTemplate();
        },
        /**
         * 创建Dialog
         * @private
         */
        _create: function(){
            var self = this;
            //判断创建任务项Dialog是否已经存在，如果存在，则直接打开
            self._dialog = cui('#taskDialog').dialog({
                title: '新建桌面',
                width: 520,
                height: 370,
                page_scroll: false,
                buttons: [
                    {
                        name: '确定',
                        handler: function(){
                            var taskName = $.trim(self.cuiTaskName.getValue());
                            if(taskName === ''){
                                cui.error('桌面名称不能为空！', function(){
                                    self.cuiTaskName.focus();
                                });
                                return false;
                            }else{
                                self.taskData.taskName = taskName;
                                self.options.okHandle && self.options.okHandle(self.taskData, self.state);
                                self.setTaskData();
                                this.hide();
                            }
                        }
                    },
                    {
                        name: '取消',
                        handler: function(){
                            self.setTaskData();
                            this.hide();
                        }
                    }
                ]
            });
            comtop.UI.scan(self.$taskDialog);
            self.cuiTaskName = cui('#txtTaskName');
        },
        /**
         * 创建模板DOM
         */
        _createTemplate: function(){
            var self = this, html = [];
            PlatFormAction.queryVisbleTemplate(function(data){
                data = json2.parse(data);
                self.state === 'new' && data.push({
                    templateDescribe: '空白模板',
                    templateId: 'blankTemplate',
                    templateName: "空白模板",
                    templatePic: webPath + '/top/workbench/platform/img/blank.png'
                });
                data.reverse();
                for(var i = 0, len = data.length; i < len; i ++){
                    html.push(
                        '<li>',
                            '<a href="#" data-template="', data[i].templateId ,'">',
                            '<span><img  onerror="this.src=\'',webPath + '/top/workbench/platform/img/template_default.png','\'"  src="', (data[i].templatePic === null ? webPath + '/top/workbench/platform/img/blank.png' : data[i].templatePic) ,
                                '" alt=""/></span><strong>', data[i].templateName ,'</strong>',
                            '</a>',
                        '</li>'
                    );
                }
                self.$taskDialog.find('.desktop-template ul')[0].innerHTML = html.join('');
                self.$taskTemplate = self.$taskDialog.find('.desktop-template a');
                self.$lastSelectTemplate = self.$taskTemplate.eq(0);
                if(self.state === 'new'){
                    self.$lastSelectTemplate.addClass('cur');
                }
           });
        },
        /**
         * 事件绑定
         * @private
         */
        _bindEvent: function(){
            var self = this;
            self.$taskDialog.delegate('a','click.taskDialog', function(){
                var $t = $(this);
                self.$lastSelectTemplate && self.$lastSelectTemplate.removeClass('cur');
                self.$lastSelectTemplate = $t.addClass('cur');
                self.taskData.template = $t.data('template');
                return false;
            });
        },
        /**
         * 设置任务项数据
         * @param taskName {String} 任务项名称
         * @param template {String} 任务项模板
         * @param id {String} 任务项ID
         * @returns {TaskDialog}
         */
        setTaskData: function(data){
            var self = this;
            self.taskData = $.extend({
                opFlag: '1',
                userId: '',
                taskName: '',
                template: self.options.defaultTemplate,
                isDefault: '0',
                id: ''
            }, data);
            
            self.cuiTaskName.setValue(self.taskData.taskName);
            self.$lastSelectTemplate && self.$lastSelectTemplate.removeClass('cur');
            if(self.$taskTemplate){
                self.$lastSelectTemplate = self.$taskTemplate.filter('[data-template="'+ self.taskData.template +'"]').addClass('cur');
            }
            return self;
        },
        /**
         * 设置标题
         * @param title
         */
        setTitle: function(title){
            this._dialog.setTitle(title);
        },
        /**
         * 显示Dialog
         * @returns {TaskDialog}
         */
        show: function(state){
            var self = this;
            self.state = state;
            self._dialog.show();
            self._createTemplate();
            return self;
        },
        /**
         * 隐藏Dialog
         * @returns {TaskDialog}
         */
        hide: function(){
            var self = this;
            self._dialog.hide();
            return self;
        }
    };

    /**
     * Portlet窗口类
     * @param options
     * @returns {PortletDialog}
     * @constructor
     */
    function PortletDialog(options){
        var self = this;
        self.options = $.extend({
            taskID: '',
            createHandle: null,
            task: null
        }, options);
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
            //加入搜索款
            self.$portletDialog.find('.portlet-list').before('<div class="portlet-search"><span id="search" style="text-align:left;"></span></div>');
            cui('#search').clickInput({
                icon:'search',
                editable:true,
                emptytext:"微件名称",
                enterable:true,
				width:227,
                on_iconclick: function(){
                    var id = $(".class-list a.cur").attr('id');
                    self._searchPortlet(id,this.getValue());
                }
            });
        },
        /**
         * 事件绑定
         * @private
         */
        _bindEvent: function(){
            var self = this, id;
            self.$portletDialog.delegate('.class-list a, .portlet-list a, .portlet-list i', 'click.task', function(e){
                var $t = $(e.target);
                if($t[0].nodeName === 'A'){
                    switch ($t.data('action')){
                        case 'tag':
                            id = $t.attr('id');
                            self.selectTag(id);
                            cui("#search").setValue("");
                            self._createPortletList(id);
                            break;
                        case 'portlet':
                            self._pushPortlet($t.data('id'));
                            break;
                        default :
                            break;
                    }
                }else if($t[0].nodeName === 'I'){
                    self._removePortalet($t.data('id'));
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
            PlatFormAction.queryVisablePortlet(self.options.taskID, function(data) {
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
            html.push('<li><a id="ptAll" href="#" class="cur" data-action="tag">全部（', data.portlet.length ,'）</a></li>');
            data.tag.reverse();
            for(i = 0, iLen = data.tag.length; i < iLen ;i ++){
                tag = data.tag[i];
                id = 'pt' + (uuid ++);
                self._data[id] = [];
                tags.push(tag.portletTag + '||' + id);
                html.push(
                    '<li>',
                    '<a id="', id ,'" href="#" data-action="tag">',
                    tag.portletTag, '(', tag.count,')',
                    '</a>',
                    '</li>'
                );
            }
            self.$portletDialog.find('.class-list').html(html.join(''));

            //portlet按分类划分
            tags = tags.join(';') + ';';
            for(i = 0, iLen = data.portlet.length; i < iLen; i ++){
                tag = data.portlet[i];
                //reg = new RegExp(tag.portletTag + '\\|\\|(pt[0-9]*)\\;');
                var re = new RegExp('\^'+tag.portletTag+'\\|\\|(pt[0-9]*)\\;\|\\;'+tag.portletTag+'\\|\\|(pt[0-9]*)\\;');
                var ID = tags.match(re)[1]?tags.match(re)[1]:tags.match(re)[2];
                //id = tags.match(reg)[1];
                self._data[ID].push(tag);
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
            self.options.task._createColumn({
                "listLeftPortlets": leftData,
                "listRightPortlets": rightData
            },'append');

            self.options.task._save();
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
                    html = html.concat(self._createHTML(dataList[p]));
                }
            }else{
                html = self._createHTML(dataList);
            }
            self.$portletDialog.find('.portlet-list').html(html.join('')||"<div class='empty-content'>暂无数据</div>");
        },
        /**
         *根据数据生成右边HTML
         *@param data Json数组对象
         */
        _createHTML:function(data){
            var html = [];
                for(var i = 0; i < data.length; i ++){
                    html.push(
                        '<dl>',
                        '<dt>',
                        '<span><img src="', (data[i].picAddress === null ? webPath + '/top/workbench/platform/img/blank.png' :
                            webPath + '/top/workbench/platform/img/' + data[i].picAddress) ,'" alt=""/></span>',
                        (!data[i].isCreate ? ('<a href="#" data-action="portlet" data-id="'+ data[i].portletId +
                            '" id="pl'+ data[i].portletId +'">添加</a>'):'<i data-id="'+ data[i].portletId +
                            '" id="pl'+ data[i].portletId +'">已选择</i>') ,
                        '</dt>',
                        '<dd>',
                        '<strong title="',data[i].portletName,'">', data[i].portletName ,'</strong>',
                        '<span>', data[i].portletDescribe ,'</span>',
                        '</dd>',
                        '</dl>'
                    );
                }
                return html;
        },
        /**
         *搜索Portlet列表
         *@param tag标签Id
         *@param query搜索的关键字
         */
        _searchPortlet:function(id,query){
            var self = this,dataary;
            if (!id || id === 'ptAll') {
                dataary =  $.grep(this._dataBak.portlet,function(item,i){
                    return item.portletName.indexOf(query) >= 0;
                });
            }else{
                var dataList = self._data[id];
                dataary =  $.grep(dataList,function(item,i){
                    return item.portletName.indexOf(query) >= 0;
                });
            };
            self.$portletDialog.find('.portlet-list').html(self._createHTML(dataary).join('')||"<div class='empty-content'>暂无数据</div>");
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
            var p = $('#pl'+id).replaceWith('<i data-id="'+id+'" id="pl'+id+'">已选择</i>');
        },
        /**
         *取消已经选中的Portalet
         *@param id 微件ID
         */
        _removePortalet:function(id){
            var self = this,
                data = self._addData;
                $.each(data, function(index, item) {
                    if(item.portletId === id + ''){
                        self._addData.splice(index,1);
                        return false;
                    }
                });
                //剔除dataBak中的已经创建标示
                $.each(self._dataBak.portlet,function(index, item) {
                    if(item.portletId === id + ''){
                        item.isCreate = false;
                        return false;
                    }
                });
            $('#pl'+id).replaceWith('<a href="#" data-action="portlet" data-id="'+id+'" id="pl'+id+'">添加</a>');
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

    /**
     * 任务栏类
     * @param options
     * @returns {*}
     * @constructor
     */
    function Task(options){
        var self = this;
        self.options = $.extend({
            platformData: [],
            taskData: [],
            currentTaskIndex: 0,
            maxTask: 6,                     //最大任务数量
            createPortletHandle: null,      //添加微件事件回调
            createTaskHandle: null,
            changeTaskHandle: null,               //切换task后的回调
            resetTaskHandle: null,                //重置task后的回调
            removeTaskHandle: null                //删除task后的回调
        }, options);

        //任务外框
        self.$taskWrap = $('.task-wrap');
        //任务容器
        self.$taskUL = $('.task>ul', self.$taskWrap);
        //最后一个激活的任务项
        self.$lastActiveTask = null;
        //添加任务项按钮
        self.$addTask = $('.add-task', self.$taskWrap);
        //编辑桌面菜单
        self.$desktopMenu = $('.tools-menu', self.$taskWrap);
        //当前任务总数
        self.taskNum = 0;
        //创建任务Dialog对象
        self.taskDialog = null;
        //创建PortletDialog对象
        self.portletDialog = null;
        //空桌面提示
        self.$portletTip = $('.task-portlet-tip');
        //本地缓存
        self.cachePortletTask = cst.use('portletTask');

        self._init();
        return self;
    }
    Task.prototype = {
        /**
         * 任务栏初始化
         * @private
         */
        _init: function(){
            var self = this, 
                opts = self.options,
                cacheActive,
                dataTmp;
            for(var i = 0, len = opts.taskData.length; i < len; i ++){
                dataTmp = opts.taskData[i];
                self._createTaskItem({
                    taskName: dataTmp.platformName,
                    template: dataTmp.templateId,
                    id: dataTmp.platformId,
                    isDefault: dataTmp.isDefaultPlatform,
                    userId: dataTmp.userId
                });
            }
            //如果有缓存，则激活缓存task
            cacheActive = self.cachePortletTask.get('activeTask');
            self.activeTask(typeof cacheActive === 'undefined' ? opts.currentTaskIndex : $('#' + cacheActive).data('taskIndex'));
            //事件绑定
            self._bindEvent();
        },
        /**
         * 事件绑定
         * @private
         */
        _bindEvent: function(){
            var self = this;
            self.$taskWrap.on('click.task', function(e){
                var $t = $(e.target);
                $t = $t[0].nodeName === 'SPAN' ? $t.parent(): $t;
                if($t[0].nodeName === 'A'){
                    switch ($t.data('action')){
                        //切换任务
                        case 'activeTask':
                            self.activeTask($t.data('taskIndex'));
                            break;
                        //添加任务
                        case 'addTask':
                            self._showTaskDialog({
                                opFlag: '1',
                                isDefault: '0',
                                userId: self.options.taskData[0].userId
                            }, '新建桌面');
                            break;
                        //添加微件
                        case 'addPortlet':
                            self._showPortletDialog();
                            break;
                        //编辑桌面
                        case 'editDesktop':
                            self.$desktopMenu.show().focus();
                            break;
                        //设置桌面
                        case 'setDesktop':
                            self._showTaskDialog({
                                opFlag: '0',
                                taskName: self.$lastActiveTask.data('taskName'), 
                                template: self.$lastActiveTask.data('template'), 
                                id: self.$lastActiveTask.attr('id'),
                                isDefault: self.$lastActiveTask.data('default') ? '1' : '0',
                                userId: self.options.taskData[0].userId
                            }, '编辑桌面');
                            break;
                        //重置桌面
                        case 'resetDesktop':
                            cui.confirm('确定要重置"' + self.$lastActiveTask.data('taskName') + '"吗？',{
                                onYes: function(){
                                    self.resetDesktop('reset');
                                }
                            });
                            break;
                        //删除任务项
                        case 'removeTask':
                            cui.confirm('确定要删除"' + self.$lastActiveTask.data('taskName') + '"吗？',{
                                onYes: function(){
                                    self.removeTask();
                                }
                            });
                            break;
                        default :
                            break;
                    }
                }
                return false;
            });
            self.$desktopMenu.on('blur', function(){
                var $t = $(this);
                setTimeout(function(){
                    $t.hide();
                    $t = undefined;
                },200);
            });
            self.$portletTip.children('a').on('click.portletTip', function(){
                self._showPortletDialog();
                return false;
            });
        },
        /**
         * 打开任务项创建窗口
         * @private
         */
        _showTaskDialog: function(data, title){
            var self = this;
            if(!self.taskDialog) {
                self.taskDialog = new TaskDialog({
                    okHandle: function(returnData, state){
                        self.addTask(returnData, state);
                    }
                });
            }
            self.taskDialog.setTaskData(data);
            self.taskDialog.setTitle(title);
            self.taskDialog.show(title === '编辑桌面' ? 'set' : 'new');
            cui("#txtTaskName").focus();
        },
        /**
         * 打开微件创建窗口
         * @private
         */
        _showPortletDialog: function(){
            var self = this;
            if(!self.portletDialog) {
                self.portletDialog = new PortletDialog({
                    taskID: self.$lastActiveTask.attr('id'),
                    createHandle: self.options.createPortletHandle,
                    task: self
                });
            }
            self.portletDialog.show(self.$lastActiveTask.attr('id'));
        },
        /**
         * 创建任务项DOM
         * @param taskName {String} 任务项名称
         * @param template {String} 模板ID
         * @param id {String} 任务项ID
         * @param isDefault {String} 是否为默认任务项，默认不允许删除
         * @returns {number} 任务项索引号
         * @private
         */
        _createTaskItem: function(data){
            var self = this,
                $taskItem = $('#' + data.id),
                taskIndex, html = [];
            if($taskItem.length){
                $taskItem.children('span').text(data.taskName);
                $taskItem.data('template', data.template);
                $taskItem.data('taskName', data.taskName);
                taskIndex = $taskItem.data('taskIndex');
            }else{
                data.id = data.id || 'newTaskTempID';
                taskIndex = self.taskNum;
                html.push(
                    '<li>',
                        '<a id="', data.id ,'" href="#" data-user-id="', data.userId ,'" data-default="', (data.isDefault === '0' ? false : true) ,'" data-action="activeTask" data-task-name="', data.taskName ,
                        '" data-template="', data.template ,'" data-task-index="', taskIndex ,'">',
                            '<span>', data.taskName ,'</span>',
                        '</a>',
                    '</li>'
                );
                self.$taskUL.append(html.join(''));
                self.taskNum ++;
                //如果任务数量达到最大，则隐藏添加按钮
                if(self.taskNum === self.options.maxTask){
                    self.$addTask.hide();
                }
            }
            return taskIndex;
        },
        /**
         * 添加桌面
         * @param id {String}
         * @param index {Number}
         * @private
         */
        _createDesktop: function(id, index){
            var self = this,
                platData = self.options.platformData;
            //判断是否存在桌面数据，如果不存在，则获取
            if($('#'+id).data('taskIndex') + '' !== '0'){
                dwr.TOPEngine.setAsync(false);
                PlatFormAction.changePlatform(index + '', function(data){
                    platData = json2.parse(data);
                    self.updateTask(platData.listPlatform[index]);
                });
                dwr.TOPEngine.setAsync(true);
            }
            //缓存标签ID
            self.cachePortletTask.set('activeTask', platData.listPlatform[index].platformId);
            //合并模板，并插入到桌面
            setTimeout(function(){
                self._createColumn(platData, 'html');
            },50);
            //self.options.platformData = null;
        },
        /**
         * 添加列数据
         * @param data
         * @param type
         * @private
         */
        _createColumn: function(data, type){
            var self = this,
                id = self.$lastActiveTask.attr('id'),
                column1, column2, html = $('#portlet-tmpl').html();

            //加载左侧html
            column1 = _.template(html, {
                portletAry : data.listLeftPortlets
            });
            //加载右侧html
            column2 = _.template(html, {
                portletAry : data.listRightPortlets
            });

            switch (type){
                case 'html':
                    if($('#desktop' + id).length === 0){
                        $('#columns').append([
                            '<div id="desktop', id ,'">',
                            '<ul class="column column1 clearfix">', column1, '</ul>',
                            '<ul class="column column2 clearfix">', column2, '</ul>',
                            '</div>'
                        ].join(''));
                    }else{
                        $('#desktop' + id).children('.column1').html(column1);
                        $('#desktop' + id).children('.column2').html(column2);
                    }

                    break;
                case'append':
                    $('#desktop' + id).children('.column1').append(column1);
                    $('#desktop' + id).children('.column2').append(column2);
                    break;
            }
            self.checkColumn();
            $('.task-portlet-load-tip').hide();
            //初始化portlet组件
            Drag.init();
            //加载URL
            //$('#desktop' + id + ' .widget-content iframe').autoFrameHeight();
            checkAutoHeight(id);
        },
        /**
         * 保存桌面
         * @param left
         * @param right
         * @private
         */
        _save: function(){
            var self = this,
                $t = self.$lastActiveTask,
                $desktop = $('#desktop' + $t.attr('id')),
                left = [],
                right = [];

            $('.column1>li', $desktop).each(function(i, t){
                var $t = $(t);
                left.push({
                    portletId : $t.data('id'),
                    editAble: $t.attr('editable'),
                    ptOrder: i + '',
                    selfName: $t.attr('selfname') || $.trim($t.find('h3').text())
                });
            });
            $('.column2>li', $desktop).each(function(i, t){
                var $t = $(t);
                right.push({
                    portletId : $t.data('id'),
                    editAble: $t.attr('editable'),
                    ptOrder: i + '',
                    selfName: $t.attr('selfname') || $.trim($t.find('h3').text())
                });
            });

            var tmpData = {
                "opFlag": 0,
                "platformName": $t.data('taskName'),
                "templateId": $t.data('template'),
                "platformId": $t.attr('id'),
                "userId": $t.data('userId'),
                "platformNumber": $t.data('taskIndex'),
                "isDefaultPlatform": $t.data('default') === true ? '1' : '0',
                "listLeftPortlets": left,
                "listRightPortlets": right
            };

            window._taskHasChange = false;
            PlatFormAction.updatePlatform(json2.stringify(tmpData), function(data) {
                //data = json2.parse(data);
                //console.log(data);
            });
        },
        /**
         * 检查微件，如果没有，则显示添加提示，如果只有大微件，没有小微件，则把左侧宽度改为0
         * @private
         */
        checkColumn: function(){
            var self = this,
                $cols = $('#desktop' + self.$lastActiveTask.attr('id')),
                $col1Length = $cols.children('.column1').children().length,
                $col2Length = $cols.children('.column2').children().length;
            if($col1Length === 0){
                $cols.addClass('column-full');
            }else{
                $cols.removeClass('column-full');
            }

            if($col1Length === 0 && $col2Length === 0){
                self.$portletTip.show();
            }else{
                self.$portletTip.hide();
            }

        },
        /**
         * 创建任务项
         * @param data {Object} 数据
         * @param state {String} 状态
         * @returns {Task}
         */
        addTask: function(data, state){
            var self = this,
                taskIndex;


            if(state === 'new'){
                taskIndex = self._createTaskItem(data);
                var tmpData = {
                    "opFlag": data.opFlag,
                    "platformName": data.taskName,
                    "templateId": data.template === 'blankTemplate' ? '' : data.template,
                    "platformId": "",//data.id + '',
                    "platformNumber": taskIndex + '',
                    "isDefaultPlatform": data.isDefault,
                    "listLeftPortlets": [],
                    "listRightPortlets": []
                };

                PlatFormAction.savaPlatform(json2.stringify(tmpData),function(result){
                    if(result==="1"){
                        self.activeTask(taskIndex);
                    }else{
                        cui.error('桌面创建失败！');
                        self.removeTask();
                    }
                });
            }else if(state === 'set'){
                PlatFormAction.settingPlatform(data.id, data.template, $.trim(data.taskName), function(result){
                    if(result==="1"){
                        //self.activeTask(taskIndex);
                        self._createTaskItem(data);
                        self.resetDesktop('set');
                    }else{
                        cui.error('编辑桌面失败！');
                    }
                });
            }

            return self;
        },
        /**
         * 更新任务项ID
         * @param data
         */
        updateTask: function(data){
            $('#newTaskTempID').attr('id', data.platformId).data('template', data.templateId);
        },
        /**
         * 激活指定任务项
         * @param taskIndex {Number} 任务项索引号
         * @returns {Task}
         */
        activeTask: function(taskIndex){
            taskIndex = typeof taskIndex === 'undefined' ? 0 : taskIndex;
            var self = this,
                lastID;

            if(self.$lastActiveTask){
                lastID = self.$lastActiveTask.removeClass('cur').attr('id');
                if(window._taskHasChange){
                    self._save();
                }
            }

            self.$lastActiveTask = self.$taskUL.find('a:eq('+ taskIndex +')').addClass('cur');
            if(self.$lastActiveTask.data('default')){
                $('a[data-default="true"]', self.$desktopMenu).parent().hide();
            }else{
                $('a[data-default="true"]', self.$desktopMenu).parent().show();
            }

            self.changeDesktop(taskIndex, lastID);

            return self;
        },
        /**
         * 删除当前任务项
         * @returns {Task}
         */
        removeTask: function(){
            var self = this,
                $lastActiveTask = self.$lastActiveTask,
                id = $lastActiveTask.attr('id'),
                taskIndex = $lastActiveTask.data('taskIndex');
            if($lastActiveTask.data('default')){
                return self;
            }
            delete window._taskDeskTopCache[id];
            $lastActiveTask.parent('li').remove();
            self.activeTask(taskIndex > 0 ? taskIndex - 1 : taskIndex + 1);
            self.taskNum --;
            //如果任务数量达到最大，则隐藏添加按钮
            if(self.taskNum < self.options.maxTask){
                self.$addTask.show();
            }
            //重新排序
            self.$taskUL.children('li').each(function(i, li){
                var $a = $(li).children('a');
                $a.data('taskIndex', i);
            });
            //删除任务
            PlatFormAction.deletePlatform(id, function(result){
                //删除成功
                if(result === "1"){

                }else{
                    cui.error('删除失败');
                }
            });
            return self;
        },
        /**
         * 重置桌面
         * @returns {Task}
         */
        resetDesktop: function(state){
            var self = this;
            switch (state){
                case 'reset':
                    PlatFormAction.resetPlatform(self.$lastActiveTask.attr('id'), function(data){
                        switch (data){
                            case '1':
                                dwr.TOPEngine.setAsync(false);
                                PlatFormAction.changePlatform(self.$lastActiveTask.data('taskIndex') + '', function(data){
                                    self._createColumn(json2.parse(data), 'html');
                                });
                                dwr.TOPEngine.setAsync(true);
                                break;
                            case '0':
                                cui.error('重置失败');
                                break;
                            case '-1':
                                cui.alert('模板已经删除，不能重置');
                        }
                    });
                    break;
                case 'set':
                    dwr.TOPEngine.setAsync(false);
                    PlatFormAction.changePlatform(self.$lastActiveTask.data('taskIndex') + '', function(data){
                        self._createColumn(json2.parse(data), 'html');
                    });
                    dwr.TOPEngine.setAsync(true);
                    break;
            }

            //self.resetTaskHandle && self.resetTaskHandle();
            return self;
        },
        /**
         * 切换桌面
         * @param index {Number} 桌面索引号
         */
        changeDesktop: function(index, lastID){
            var self = this,
                id = self.$taskUL.find('a').eq(index).attr('id');

            if(lastID){
                //保存旧数据
                $('#desktop' + lastID).hide();
            }

            if(!$('#desktop' + id).length){
                $('.task-portlet-load-tip').show();
                self._createDesktop(id, index);
            }else{
                self.checkColumn();
                $('#desktop' + id).show();
                self.cachePortletTask.set('activeTask', id);
                checkAutoHeight(id);
            }
        }
    };

    var intervalTime;
    function checkAutoHeight(id){
        if(intervalTime){
            clearInterval(intervalTime);
        }
        intervalTime = setInterval(function(){
            var scrollTop = $(window).scrollTop();
            $('#desktop' + id + ' .widget-content iframe').each(function(a, b){
                var frame = b;
                //文档是否已加载完成
                try{
                    if (!frame.contentWindow || !frame.contentWindow.document || !frame.contentWindow.document.documentElement || !frame.contentWindow.document.body) {
                        return;
                    }
                }catch(e){
                    return;
                }
                var frameDoc = frame.contentWindow.document;
                if(!!window.ActiveXObject || "ActiveXObject" in window){
                    //frame.style.height = '20px';
                }
                var height = frameDoc.documentElement.scrollHeight;
                var width = frameDoc.documentElement.scrollWidth;
                var hasHScroll = $(frameDoc.documentElement).width() < width ? true : false;
                var frameHeight = $(frame).height();
                if(height === (hasHScroll ? frameHeight + 16 : frameHeight)){
                    return;
                }
                $(frame).height(height);


                //去掉滚动条，规避动态高度
                $(frameDoc).find('body').css('overflow', 'hidden');
                if(hasHScroll){
                    $(frame).height(height + 16);
                }else{
                    $(frame).height(height);
                }

                //frameDoc.documentElement.scrollLeft = left;
                //恢复滚动条状态
                $(frameDoc).find('body').css('overflowX', 'auto');
            });
            $(window).scrollTop(scrollTop);
        }, 500);
    }

    //暴露任务栏类
    return Task;
});