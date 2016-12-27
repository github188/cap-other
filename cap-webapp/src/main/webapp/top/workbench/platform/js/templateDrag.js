/*
 * 使用jqueryui实现的拖动布局
 */
define([ "jqueryui", "cui"], function ( jqui, cui) {
    var iSmartAbleWidget = {
        jQuery: $,
        settings: {
            columns: '.column',
            widgetSelector: '.widget',
            handleSelector: '.widget-head',
            contentSelector: '.widget-content',
            widgetDefault: {
                movable: true,
                removable: true,
                collapsible: true,
                editable: true,
                colorClasses: ['color-yellow', 'color-red', 'color-blue', 'color-white', 'color-orange', 'color-green', 'color-gray', 'color-burlywood']
            },
            widgetIndividual: {
                intro: {
                    movable: false,
                    removable: false,
                    collapsible: false,
                    editable: false
                }
            }
        },

        init: function () {
            this.addWidgetControls();
            this.makeSortable();
        },

        getWidgetSettings: function (id) {
            var $ = this.jQuery,
                settings = this.settings;
            return (id && settings.widgetIndividual[id]) ? $.extend({}, settings.widgetDefault, settings.widgetIndividual[id]) : settings.widgetDefault;
        },

        addWidgetControls: function () {
            var iSmartAbleWidget = this,
                $ = this.jQuery,
                settings = this.settings;

            $(settings.widgetSelector, $(settings.columns)).each(function () {
                var thisWidgetSettings = iSmartAbleWidget.getWidgetSettings(this.id);
                /*if (thisWidgetSettings.removable) {
                    $('<a href="#" class="remove">关闭</a>').mousedown(function (e) {
                        e.stopPropagation();
                    }).click(function () {
                        var $t = $(this);
                        cui.confirm('是否删除该微件?', {
                            onYes: function () {
                                $t.parents(settings.widgetSelector).animate({
                                    opacity: 0
                                }, function () {
                                    $t.parents('.widget').eq(0).remove();
                                });
                            }
                        });
                        return false;
                    }).appendTo($(settings.handleSelector, this));
                }*/
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
                                    checkColumn();
                                });
                            }
                        });
                        return false;
                    }).appendTo($(settings.handleSelector, this));
                }

                if (thisWidgetSettings.collapsible) {
                    $('<a href="#" class="collapse">收缩</a>').mousedown(function (e) {
                        e.stopPropagation();
                    }).click(function () {
                        if ($(this).data('collapse-status') == 'show')
                            $(this).data('collapse-status', 'hide').css({ backgroundPosition: '-52px 0' }).blur().parents(settings.widgetSelector).find(settings.contentSelector).show(500);
                        else
                            $(this).data('collapse-status', 'show').css({ backgroundPosition: '-38px 0' }).blur().parents(settings.widgetSelector).find(settings.contentSelector).hide(500);

                        return false;
                    }).prependTo($(settings.handleSelector, this));
                }
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

        attachStylesheet: function (href) {
            var $ = this.jQuery;
            return $('<link href="' + href + '" rel="stylesheet" type="text/css" />').appendTo('head');
        },

        makeSortable: function () {
            var iSmartAbleWidget = this;
             var   $ = this.jQuery;
              var  settings = this.settings;

              var  $sortableItems = (function () {
                    var notSortable = '';
                    $(settings.widgetSelector, $(settings.columns)).each(function (i) {
                        if (!iSmartAbleWidget.getWidgetSettings(this.id).movable) {
                            if (!this.id) {
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

            $sortableItems.find(settings.handleSelector).css({
                cursor: 'move'
            }).mousedown(function (e) {
                $sortableItems.css({ width: '' });
                $(this).parent().css({
                    width: $(this).parent().width() + 'px'
                });
            }).mouseup(function () {
                if ($(this).parent().hasClass('dragging')) {
                    $(settings.columns).sortable('disable');
                } else {
                    $(this).parent().css({ width: '' });
                }
            });

            $(settings.columns).sortable({
                items: $sortableItems,
                connectWith: $(settings.columns),
                handle: settings.handleSelector,
                placeholder: 'widget-placeholder',
                forcePlaceholderSize: true,
                revert: 300,
                delay: 100,
                opacity: 0.8,
                containment: 'parent',
                start: function (e, ui) {
                    $(ui.helper).addClass('dragging');
                },
                stop: function (e, ui) {
                    $(ui.item).css({ width: '' }).removeClass('dragging');
                    $(settings.columns).sortable('enable');
                }
            });
        }

    };
    //设置样式
    return iSmartAbleWidget;
});
