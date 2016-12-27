/*统一工作台核心js文件*/
define(["json2", "jqueryui", "cui"], function(json2, jqui, cui) {
    var Drag = {
        jQuery: $,
        settings: {
            columns: '.column',//列选择器
            widgetSelector: '.widget',//组件选择器
            handleSelector: '.widget-head',//组件头选择器
            contentSelector: '.widget-content',//组件内容部分选择器
            /*portlet的默认配置*/
            widgetDefault: {
                movable: true,
                removable: true,
                collapsible: true,
                editable: true,
                reloadable: true,
                colorClasses: ['color-yellow', 'color-red', 'color-blue', 'color-white', 'color-orange', 'color-green', 'color-gray', 'color-burlywood']
            },
            /*当portlet的id为intro时候的不可拖动的配置*/
            widgetIndividual: {
                movable: false,
                removable: false,
                collapsible: false,
                editable: false,
                reloadable: false,
                colorClasses: ['color-yellow', 'color-red', 'color-blue', 'color-white', 'color-orange', 'color-green', 'color-gray', 'color-burlywood']
            }
        },

        /*初始化入口*/
        init: function () {
            /*第一步：动态加载样式文件${pageScope.cuiWebRoot}/top/workbench/platform/css/iSmartAbleWidget.css*/
            //this.attachStylesheet(webPath + '/top/workbench/platform/css/iSmartAbleWidget.js.css');
            /*第二步：初始化demo*/
            this.addWidgetControls();
            /*第三步：给dom添加拖拽事件*/
            this.makeSortable();
        },

        /*根据Portlet的id属性获取该Portlet的配置信息,也就是根据id熟悉判断该portlet是否是禁止拖动的*/
        getWidgetSettings: function (cssClass) {
            /*this为调用该方法的对象，谁调用，就指向谁*/
            var $ = this.jQuery,
                settings = this.settings;
            /* 下面这行代码的意思是、只有当传入的cssClass不为空并且值为"intro"时候返回settings.widgetIndividual.intro对象
             否则都返回默认的配置settings.widgetDefault*/
            return (cssClass && cssClass === "0") ? settings.widgetIndividual : settings.widgetDefault;
        },

        /*domo渲染方法*/
        addWidgetControls: function () {
            /*在局部变量里面获取了this，也就是全局的iSmartAbleWidget对象*/
            var iSmartAbleWidget = this,
            /*将$和settings重新赋值到局部变量里面，我觉得不用赋值、在局部变量里面其实也可以直接用，这里思考这么做的好处？*/
                $ = this.jQuery,
                settings = this.settings;

            /*循环获取所有class为column的dom里面的class为widget的dom元素、迭代处理*/
            $(settings.widgetSelector, $(settings.columns)).each(function () {

                /*this为当前正在迭代中的Portelt dom对象,每个dom都在前端指定了一个id属性*/

                /* 根据portlet的id属性获取该portlet的配置信息，包括是否可拖动、是否可删除、等*/
                var thisWidgetSettings = iSmartAbleWidget.getWidgetSettings($.trim($(this).attr("editable")));

                /*若果可删除,或者说可关闭,就将一个带有关闭事件的操作图标动态添加到当前portlet的class为widget-head的dom中*/
                if (thisWidgetSettings.removable && $(".remove", this).length < 1) {
                    $('<a href="#" class="remove" title="点击删除">删除</a>').mousedown(function (e) {
                        e.stopPropagation();
                    }).click(function () {
                        var $t = $(this);
                        cui.confirm('是否删除该微件?', {
                            onYes: function () {
                                $t.parents(settings.widgetSelector).animate({
                                    opacity: 0
                                }, function () {
                                    $t.parents('.widget').eq(0).remove();
                                    createTime();
                                    checkColumn();
                                });
                            }
                        });
                        return false;
                    }).appendTo($(settings.handleSelector, this));
                }


                /*若果可编辑,添加编辑图标按钮、以及点击效果*/
                if (thisWidgetSettings.editable && $(".edit", this).length < 1) {
                    /**该功能不实用,生产提出去除该功能
                    $('<a href="#" class="edit" title="点击编辑">编辑</a>').mousedown(function (e) {
                        e.stopPropagation();
                    }).click(function () {
                        //edit-status第一次点击的时候打开编辑框
                        if ($(this).data('edit-status') === 'show') {
                            $(this).data('edit-status', 'hide').removeClass('edited').parents(settings.widgetSelector).find('.edit-box').hide();
                            createTime();
                        } else {
                            $(this).data('edit-status', 'show').addClass('edited').parents(settings.widgetSelector).find('.edit-box').show().find('input').focus();
                        }
                        return false;
                    }).appendTo($(settings.handleSelector, this));
                    **/
                    var EditBoxObj = $('<div class="edit-box" style="display:none;"/>');
                    EditBoxObj.append('<ul><li class="item"><label>修改标题：</label><input value="' + $.trim($('h3', this).text()) + '" class="edit-input"/></li>').append((function () {
                        var colorList = '<li class="item" style="display: none"><label>可用颜色：</label><ul class="colors">';
                        $(thisWidgetSettings.colorClasses).each(function () {
                            colorList += '<li class="' + this + '" title="' + this.split('-')[1] + '"/>';
                        });
                        return colorList + '</ul>';
                    })()).append('</ul>').insertAfter($(settings.handleSelector, this));
                    EditBoxObj.width(EditBoxObj.prev().width());
                }

                //重新加载
                if (thisWidgetSettings.reloadable && $(".reload", this).length < 1) {
                    $('<a href="#" class="reload" title="点击重新加载">重新加载</a>').mousedown(function (e) {
                        e.stopPropagation();
                    }).click(function () {
                        var $t = $(this);

                        var $iframe = $t.parents('.widget').eq(0).find('.widget-iframe'),
                            url = $iframe.attr('src');
                        if(/\?/.test(url)){
                            url = url + '&v=' + new Date().getTime();
                        }else{
                            url = url + '?v=' + new Date().getTime();
                        }
                        $iframe.attr('src', url);

                        return false;
                    }).appendTo($(settings.handleSelector, this));
                }

                /**
                 * 若可以收缩、添加收缩效果
                if (thisWidgetSettings.collapsible && $(".collapse", this).length < 1) {
                    $('<a href="#" class="collapse">收缩</a>').mousedown(function (e) {
                        e.stopPropagation();
                    }).click(function () {
                        if ($(this).data('collapse-status') == 'show')
                            $(this).data('collapse-status', 'hide').css({ backgroundPosition: '-52px 0' }).blur().parents(settings.widgetSelector).find(settings.contentSelector).show(500);
                        else
                            $(this).data('collapse-status', 'show').css({ backgroundPosition: '-38px 0' }).blur().parents(settings.widgetSelector).find(settings.contentSelector).hide(500);
                    }).prependTo($(settings.handleSelector, this));
                }
                */
            });

            $('.edit-box').each(function () {
                $('input', this).keyup(function () {
                    $(this).parents(settings.widgetSelector).find('h3').text($(this).val().length > 20 ? $(this).val().substr(0, 20) + '...' : $(this).val());
                });
                $('ul.colors li', this).click(function () {

                    var colorStylePattern = /\bcolor-[\w]{1,}\b/,
                        thisWidgetColorClass = $(this).parents(settings.widgetSelector).attr('class').match(colorStylePattern)
                    if (thisWidgetColorClass) {
                        $(this).parents(settings.widgetSelector).removeClass(thisWidgetColorClass[0]).addClass($(this).attr('class').match(colorStylePattern)[0]);
                    }
                    return false;

                });
            });

        },

        /*动态加载css文件*/
        attachStylesheet: function (href) {
            var $ = this.jQuery;
            return $('<link href="' + href + '" rel="stylesheet" type="text/css" />').appendTo('head');
        },


        /*给portlet添加拖拽事件*/
        makeSortable: function () {
            var iSmartAbleWidget = this,
                $ = this.jQuery,
                settings = this.settings,
                $sortableItems = (function () {
                    /* notSortable记录所有的不需要移动的的id的集合，类似这样的格式：',#widget-0,#widget-1'*/
                    var notSortable = '';
                    /*遍历所有的portlet*/
                    $(settings.widgetSelector, $(settings.columns)).each(function (i) {
                        /*若当前portlet不能移动*/
                        if (!iSmartAbleWidget.getWidgetSettings($.trim($(this).attr("editable"))).movable) {
                            if (!this.id) {
                                /*如果当前portlet没有id、就给一个id值*/
                                this.id = 'widget-no-id-' + i;
                            }
                            notSortable += ',#' + this.id;
                        }
                    });
                    /*如果不可编辑的个数大于0*/
                    if (notSortable.length > 0) {
                        notSortable = notSortable.substring(1);
                        /*返回所有的能够排序的li节点集合*/
                        return $('> li:not(' + notSortable + ')', settings.columns);
                    } else {
                        /* 否则返回全部可排序元素*/
                        return $('> li', settings.columns);
                    }
                })();


            /*初次隐藏掉所有的可拖动的微件里面的编辑和删除图片*/
            $sortableItems.find(settings.handleSelector).find("a[class='remove'],a[class='edit'],a[class='reload']").hide();

            /*给所有的li（portlet）下面的子元素.header加上鼠标放上去变可移动的样式，另外设置鼠标抬起的时候的一个检测*/
            $sortableItems.find(settings.handleSelector).css({
                cursor: 'move'
            }).mouseover(function (e) {
                e.stopPropagation();
                $("a[class='remove'],a[class='edit'],a[class='reload']", this).show();
            }).mouseleave(function (e) {
                e.stopPropagation();
                $("a[class='remove'],a[class='edit'],a[class='reload']", this).hide();
            }).mouseup(function () {
                if ($(this).parent().hasClass('dragging')) {
                    $(settings.columns).sortable('disable');
                }
            });

            /*拖动的核心代码*/
            $(settings.columns).sortable({
                items: $sortableItems,
                connectWith: $(settings.columns),
                handle: settings.handleSelector,
                placeholder: 'widget-placeholder',
                forcePlaceholderSize: true,
                revert: 300,
                delay: 100,
                opacity: 0.8,
                tolerance: 'pointer',//设置当拖过多少的时候开始重新排序
                containment: 'parent',//设置拖动的范围
                start: function (e, ui) {
                    clearTime();
                    $(ui.helper).parent().addClass('borderline');
                    $(ui.helper).addClass('dragging');
                },
                beforeStop: function (e, ui) {
                    $(ui.helper).parent().removeClass('borderline');
                },
                stop: function (e, ui) {
                    $(ui.item).css({ width: '' }).removeClass('dragging');
                    $(settings.columns).sortable('enable');
                    createTime();

                }
            });
        }
    };

    var dragTime = null;

    function createTime() {
        window._taskHasChange = true;
        clearTime();
        dragTime = setTimeout(function () {
            var $t = $('.task a.cur'),
                id = $t.attr('id'),
                $desktop = $('#desktop' + id),
                left = [], right = [], data = null;

            $('.column1>li',$desktop).each(function (i, t) {
                var $t = $(t);
                left.push({
                    portletId: $t.data('id'),
                    editAble: $t.attr('editable'),
                    ptOrder: i + '',
                    selfName: $t.attr('selfname') || $.trim($t.find('h3').text())
                });
            });
            $('.column2>li',$desktop).each(function (i, t) {
                var $t = $(t);
                right.push({
                    portletId: $t.data('id'),
                    editAble: $t.attr('editable'),
                    ptOrder: i + '',
                    selfName: $t.attr('selfname') || $.trim($t.find('h3').text())
                });
            });
            data = {
                "opFlag": 0,
                "platformName": $t.data('taskName'),
                "templateId": $t.data('template'),
                "platformId": id,
                "userId": $t.data('userId'),
                "platformNumber": $t.data('taskIndex'),
                "isDefaultPlatform": $t.data('default') === true ? '1' : '0',
                "listLeftPortlets": left,
                "listRightPortlets": right
            };

            //清空变更标记
            window._taskHasChange = false;
            PlatFormAction.updatePlatform(json2.stringify(data), function (data) {
                console.log(data);
            });
        }, 1000);
    }

    function clearTime() {
        clearTimeout(dragTime);
    }

    /**
     * 检查微件，如果没有，则显示添加提示，如果只有大微件，没有小微件，则把左侧宽度改为0
     * @private
     */
    function checkColumn(){
        var $cols = $('#desktop' + $('.task a.cur').attr('id')),
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
    }

    return Drag;
});