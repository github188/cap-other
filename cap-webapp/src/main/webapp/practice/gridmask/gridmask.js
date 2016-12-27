/**
 * gridmask v0.0.1
 * require jquery 1.7+
 * MIT License
 */
 (function($, h, c) {
    var a = $([]),
        e = $.resize = $.extend($.resize, {}),
        i, k = "setTimeout",
        j = "resize",
        d = j + "-special-event",
        b = "delay",
        f = "throttleWindow";
    e[b] = 250;
    e[f] = true;
    $.event.special[j] = {
        setup: function() {
            if (!e[f] && this[k]) {
                return false
            }
            var l = $(this);
            a = a.add(l);
            $.data(this, d, {
                w: l.width(),
                h: l.height()
            });
            if (a.length === 1) {
                g()
            }
        },
        teardown: function() {
            if (!e[f] && this[k]) {
                return false
            }
            var l = $(this);
            a = a.not(l);
            l.removeData(d);
            if (!a.length) {
                clearTimeout(i)
            }
        },
        add: function(l) {
            if (!e[f] && this[k]) {
                return false
            }
            var n;
            function m(s, o, p) {
                var q = $(this),
                    r = $.data(this, d);
                r.w = o !== c ? o : q.width();
                r.h = p !== c ? p : q.height();
                n.apply(this, arguments)
            }
            if ($.isFunction(l)) {
                n = l;
                return m
            } else {
                n = l.handler;
                l.handler = m
            }
        }
    };
    function g() {
        i = h[k](function() {
            a.each(function() {
                var n = $(this),
                    m = n.width(),
                    l = n.height(),
                    o = $.data(this, d);
                if (m !== o.w || l !== o.h) {
                    n.trigger(j, [o.w = m, o.h = l])
                }
            });
            g()
        }, e[b])
    }
})(jQuery, this);
;(function($, window, document, undefined) {
    'use strict';

    // Create the defaults once
    var pluginName = "gridmask",
        defaults = {
            target: 'tbody', //the grid that the overlay will attach to
            content: 'Welcome to use Gridmask!', //the content that will display
            fontColor: '#fff',
            textAlign: 'center', //display the content left, center or right
            verticalMiddle: true, //display the content vertical middle or not
            height: '100%', //specify the height of the overlay;
            backgroundColor: '#000', //specify the background color and opacity using rgba
            filter: 'Alpha(Opacity=70)',
            opacity:'0.7'
        };

    function Gridhover(grid, options) {
        this.settings = $.extend({}, defaults, options);
        this.$grid = $(grid) || $(this.settings.target).parents('table');
        this._defaults = defaults;
        this._name = pluginName;
        this.version = 'v0.0.1';
        this.init();
    }

    Gridhover.prototype = {
        init: function() {
            var that = this,
                $target = $(that.settings.target);

            //disable on touch devices
            if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
                return;
            }
            $target.map(function(i, el){
                var $grid = that.$grid,
                    $overlayContainer = that.$overlayContainer = that.createContainer($grid, $(el)),
                    $overlay = $overlayContainer.find('.gridmask-overlay');

                if (!$overlay.length) {
                    $overlay = that.createOverlay(that, $grid);
                    //put the overlay into the container
                    $overlayContainer.html($overlay);
                }
            });

        },
        createContainer: function($grid, $target) {
            //get the properties of the target
            var width = $target.outerWidth(),
                height = $target.outerHeight(),
                top = $target.offset().top - $grid.offset().top,
                left = $target.offset().left - $grid.offset().left,
                zIndex = $target.css("z-index"),
                $col;

            if($target[0].tagName === 'TD' || $target[0].tagName === 'TH'){
                top = 0;
                left = $target.offset().left - $grid.offset().left;
                $col = $grid.find('tbody tr').find('td:eq(' + $target.index() + ')');

                height = 0;
                $col.each(function(i, el){
                    height += $(el).outerHeight();
                });
            }
            /****new***/
            if($target[0].tagName === 'TH'){
                $('th').on('resize', function () {
                    var tWidth=$target.outerWidth();
                    $(".gridmask-container").css({
                        width:tWidth,
                        left:$target.offset().left-$grid.offset().left
                    });
                });
            }
            $(".grid-scroll").on('scroll',function(){
                $(".gridmask-container").css({
                    left:$target.offset().left-$(".grid-container").offset().left
                });
            });
            $(".eg-scroll").on('scroll',function(){
                $(".gridmask-container").css({
                    left:$target.offset().left-$(".eg-container").offset().left
                });
            });
            if($target[0].tagName != 'TR'){
                $(".grid-body,.eg-body").on('scroll',function(){
                    $(".gridmask-container").css({
                        height:$(".gridmask-container").parent().outerHeight()
                    });
                });
            }
            var $overlayContainer = $('<div>', {
                'class': 'gridmask-container'
            }).css({
                width: width,
                height: height,
                position: 'absolute',
                overflow: 'hidden',
                top: top,
                left: left,
                zIndex: zIndex == +zIndex ? (zIndex + 1) : 999 // if the z-index of the target is not number then use 999
            });

            $grid.before($overlayContainer);

            return $overlayContainer;
        },
        createOverlay: function(instance, $grid) {

            var bottom, left, $overlay, $overlayColor, content, $targetAParent,$overlayFilter,$overlayOpacity;

            left = 0;
            bottom = 0

            //if we want to display content vertical middle, we need to wrap the content into a div and set the style with display table-cell
            if (instance.settings.verticalMiddle) {
                var
                    content = $('<div>').css({
                        display: 'table-cell',
                        verticalAlign: 'middle'
                    }).html(instance.settings.content);

            } else {
                content = instance.settings.content;
            }

            $overlay = $('<div>', {
                'class': 'gridmask-overlay'
            });

            $overlayColor = instance.settings.backgroundColor;
            $overlayFilter = instance.settings.filter;
            $overlayOpacity = instance.settings.opacity;

            $overlay.css({
                width: '100%',
                height: instance.settings.height,
                position: 'absolute',
                left: left,
                bottom: bottom,
                display: instance.settings.verticalMiddle ? 'table' : 'inline',
                textAlign: instance.settings.textAlign,
                color: instance.settings.fontColor,
                backgroundColor: $overlayColor,
                filter:$overlayFilter,
                opacity:$overlayOpacity

            }).html(content);
            return $overlay;
        },
        removeOverlay: function() {
            var $overlayContainer = this.$overlayContainer;
            $overlayContainer.remove();
        },

    };
    $.fn[pluginName] = function(options) {
        this.each(function() {
            if (!$.data(this, "plugin_" + pluginName)) {
                $.data(this, "plugin_" + pluginName, new Gridhover(this, options));
            }
        });

        // chain jQuery functions
        return this;
    };
})(jQuery, window, document);