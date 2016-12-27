;(function(C){
    "use strict";
    var $ = C.cQuery,
        arrow = {
            "bottom" : "&#xf0d7;",
            "top": "&#xf0d8;",
            "left": "&#xf0d9;",
            "right": "&#xf0da;"
        },arrowDesc = {
            "top" : "&#xf0d7;",
            "bottom": "&#xf0d8;",
            "right": "&#xf0d9;",
            "left": "&#xf0da;"
        };
    C.UI.Borderlayout = C.UI.Base.extend({
        options: {
            uitype : "Borderlayout",
            id : "",
            is_root: true,
            gap : "0px 0px 0px 0px",
            fixed: {
                "top": true,
                "middle": false,
                "left": true,
                "center": false,
                "right": true,
                "bottom": true
            },
            items: [],
            on_sizechange: null
        },
        _init: function () {
        },
        _create: function () {
            var opt = this.options;
            this.id = C.guid();
            this.el = opt.el;
            if (this.el.parent().prop("tagName") === "BODY" ) {
                this.body = true;
                this.el.parent().css({
                    "margin": 0,
                    "overflow": "hidden"
                });
            }
            this._setItems();
            this._createDom();
            this._bindHandler();
        },
        /**
         * 设置item属性
         */
        _setItems: function () {
            var items = this.options.items,
                el = this.el,
                items_default = this.items_default = {
                    position: "left",
                    width: -1,
                    height: -1,
                    gap: "0px 0px 0px 0px",
                    resizable: false,
                    min_size: 30,
                    max_size: 200,
                    split_size: 2,
                    is_header: false,
                    header_content: "",
                    header_height: 30,
                    collapsable: false,
                    url: ".",
                    show_expand_icon: false
                };
            if (items.length) {
                return;
            }
            var type_convert = {
                "string":function (a) {return a;},
                "number": C.Tools.fixedNumber,
                "boolean" : function (a) {
                    return a === "true";
                }
            };
            this.setattr = true;
            el.children('[position]').each(function () {
                var item = {}, att; items.push(item);
                for (var v in items_default) {
                    if (items_default.hasOwnProperty(v)) {
                        att = $(this).attr(v);
                        item[v] = att === undefined ?
                            items_default[v] :
                            type_convert[typeof(items_default[v])]( att );
                    }
                }
            });
        },
        /**
         * 是否有横向划分布局
         * @param position
         * @returns {boolean}
         * @private
         */
        _isCols: function (position) {
            return position === "left" || position ==="center" || position ==="right";
        },
        /**
         * 创建dom
         * @private
         */
        _createDom: function () {
            var items = this.options.items,
                el = this.el,
                setattr = this.setattr,
                html = {},
                widths = {},
                heights = {},
                col_height = [],
                fixed = this.options.fixed,
                p_margin = {top: "bottom", bottom: "top", left: "right", right : "left"},
                box_css = this.box_css = {},
                min_size = this.min_size = {},
                max_size = this.max_size = {},
                collapsable = this.collapsable = {},
                items_default = this.items_default,
                ids = {},
                _isCols = this._isCols;

            for (var i = items.length; i--;) {
                var item = items[i],
                    position = item.position;
                item = setattr ? items[i] : $.extend(items_default, items[i]);

                //heights[ (_isCols(position) ? "middle" : position)] = item.height !== -1 ? item.height : "auto";
                if (_isCols(position)) {
                    widths[position] = item.width !== -1  ? item.width : "auto";
                    col_height.push(item.height);
                } else {
                    heights[position] = item.height !== -1 ? item.height : "auto";
                }
                var gap = item.gap.split(" "),
                    len_gap = gap.length;
                switch (len_gap) {
                    case 1:
                        gap[1] = gap[2] = gap[3] = gap[0];
                        break;
                    case 2:
                        gap[2] = gap[0];
                        gap[3] = gap[1];
                        break;
                    case 3:
                        gap[3] = gap[1];
                        break;
                }
                box_css[position] = {
                    "margin-top": parseInt(gap[0], 10),
                    "margin-right": parseInt(gap[1], 10),
                    "margin-bottom": parseInt(gap[2], 10),
                    "margin-left": parseInt(gap[3], 10)
                };
                if (fixed[position]){
                    min_size[position] = item.min_size;
                    max_size[position] = item.max_size;
                }
                var frag = '<div class="bl_' + position + ' bl_' + position + this.id + '">',
                    move = "",
                    header = "";
                if (position !== "center") {
                    var dir = this._isCols(position) ? "width" : "height";
                    move = '<div class="' + (item.resizable ? 'bl_move' : 'bl_border' ) + '" style="' + dir + ':' + item.split_size + 'px;">' + ( (fixed[position] && item.collapsable && item.show_expand_icon) ? '<a href="javascript:;" class="bl_fold bl_unfold cui-icon">' + arrow[position] + '</a>' : '' ) + '</div>';
                    box_css[position]["margin-" + p_margin [position]] += item.split_size;
                }
                if ( fixed[position] && item.collapsable) {
                    collapsable[position] = item.collapsable;
                }
                if( item.id ) {
                    ids[position] = item.id;
                }
                if (item.is_header) {
                    header = '<div class="bl_header" style="height:' + (item.header_height - 1) + 'px;line-height:' + (item.header_height - 1) + 'px;">' + item.header_content + '</div>';
                }
                frag += '<div class="bl_inner" header="' + (item.is_header ? (item.header_height - 1) : 0) + '">' + header + '<div class="bl_box_' + position + ' bl_box' + this.id + '">' + ( item.url !== "." ? '<iframe url="' + item.url + '" frameborder="0" class="bl_iframe_page"></iframe>' : '' ) + '</div></div>';
                html[position] = (frag += move + '</div>');
            }
            var middle = $("<div class='bl_middle bl_middle" + this.id + "'></div>").append(html.left).append(html.center).append(html.right);
            el.append(html.top).append(middle.html() ? middle : "").append(html.bottom).append("<div class='bl_overlay'></div>");
            el.find(".bl_box" + this.id).each(function() {
                var position = this.className.match(/top|left|center|bottom|right/)[0];
                if ( ids[position] ) {
                    $(this).append($("#" + ids[position], el).css({"height": "100%"}).append($(this).html()));
                } else {
                    $(this).html(el.children('[position=' + position + ']').css({"height": "100%"}).append($(this).html()));
                }
            });
            el.find(".bl_iframe_page").each(function () {
                $(this).attr("src", $(this).attr("url")).removeAttr("url");
            });
            //middle高度修正
            if(fixed.middle) {
                var max_height = Math.max.apply(null, col_height);
                heights.middle = max_height === -1 ? "auto" : max_height;
            } else {
                heights.middle = "auto";
            }
            this._setLayout(widths, heights);
            this._setBoxLayout();
        },
        /**
         * 设置布局
         */
        _setLayout: function (widths, heights) {
            var _self = this,
                gap = this.options.gap,
                el = this.el;
            _self.auto_lays = {"width": [], "height": []};
            var gap_arr = gap.split(" ");
            this.margin_v = parseInt(gap_arr[0], 10) + (gap_arr[2] === undefined ? parseInt(gap_arr[0], 10) : parseInt(gap_arr[2], 10));
            var margin_right = gap_arr[1] === undefined ? parseInt(gap_arr[0], 10) : parseInt(gap_arr[1], 10);
            this.margin_r = margin_right + (gap_arr[3] === undefined ? margin_right : parseInt(gap_arr[3], 10));
            this.scope = {};
            var scope = this.scope = this._getParentLayout();
            widths = this._separateAutoLayout(widths, scope.width, "width");
            heights = this._separateAutoLayout(heights, scope.height, "height");
            this.layout = $.extend(widths, heights);
            this._setPartLayout();
            var client_height = $.client.height(),
                clinet_width = $.client.width();
            $(window).on("resize", function () {
                if (client_height !== $.client.height() || clinet_width !== $.client.width()) {
                    client_height = $.client.height();
                    clinet_width = $.client.width();
                    _self._resizeHandle(true);
                }
            });
            el.addClass("bl_main").css("padding", gap);
        },

        _setPartLayout: function () {
            var layout = this.layout, el = this.el;
            for (var v in layout) {
                el.find(".bl_" + v + this.id).eq(0).css( (this._isCols(v) ? "width" : "height"), layout[v]);
            }
        },

        _resizeHandle: function (resize) {
            var new_scope = this._getParentLayout();
            this._resetLayout(new_scope, this.scope, resize);
            this.scope.width = new_scope.width;
            this.scope.height = new_scope.height;
        },
        _separateAutoLayout: function (obj, all, dir) {
            var auto_lays = [], layout = {}, fixed = this.options.fixed;
            for (var v in obj) {
                if(obj.hasOwnProperty(v)) {
                    if ( !fixed[v] ) {
                        this.auto_lays[dir].push(v);
                        auto_lays.push(v);
                        continue;
                    }
                    obj[v] = typeof obj[v] !== "number" ? ( dir === "width" ? 500 : 300 ) : obj[v];
                    all -= obj[v];
                    layout[v] = obj[v];
                }
            }
            for (var i = auto_lays.length; i--;) {
                layout[ auto_lays[i] ] = all / auto_lays.length;
            }
            return layout;
        },
        /**
         * 获取父元素宽高
         * @returns {{width: (*|number), height: (*|number)}}
         * @private
         */
        _getParentLayout: function () {
            var parent = this.el.parent().css({"positon": "relative", "overflow" : "hidden"}),
                Browser = C.Browser,
                scope = this.scope;
            var layout = document.createElement("div");
            layout.style.width = "100%";
            layout.style.height = "100%";
            layout.style.positon = "absolute";
            layout.style.left = 0;
            layout.style.top = 0;
            parent.append(layout);
            var width = $(layout).width();
            var height = $(layout).height();
            if(this.body) {
                height = Browser.isQM ? ( window.innerHeight || document.documentElement.offsetHeight - 4 ) : $(window).height();
            } else {
                parent.css("overflow" , "");
            }
            $(layout).remove();
            parent.css("positon", "");
            return {
                width: scope.fix_width || (width -  this.margin_r - 1) ,
                height: scope.fix_height || (height -  this.margin_v)};
        },
        /**
         * 设置布局
         * @private
         */
        _setBoxLayout: function () {
            var el = this.el, box_height = this.box_height = {},
                box_css = this.box_css;
            for (var v in box_css) {
                if (box_css.hasOwnProperty(v)) {
                    var box = el.find(".bl_box_" + v).eq(0), inner = box.parent();
                    box_height[v] = inner.parent().css("overflow", "hidden").height() - inner.attr("header") - 0 - box_css[v]["margin-top"] - box_css[v]["margin-bottom"];
                    inner.parent().css("overflow", "");
                    inner.css( box_css[v] );
                    box.css("height", box_height[v]);
                }
            }
        },
        /**
         * 重设布局
         * @param new_scope
         * @param old_scope
         * @param resize
         * @private
         */
        _resetLayout: function (new_scope, old_scope, resize) {
            var width = new_scope.width - old_scope.width;
            var height = new_scope.height - old_scope.height;
            if (width) {
                this._setWidthAndHeight(width, "width", resize);
            }
            if (height) {
                this._setWidthAndHeight(height, "height", resize);
            }
        },
        setWidth: function (value) {
            var value2 = C.Browser.isQM ? (value + this.margin_r) : value;
            this.el.css("width", value2);
            this.scope.fix_width = value;
            this._resizeHandle(false);
        },
        setHeight: function (value) {
            var value2 = C.Browser.isQM ? (value + this.margin_v) : value;
            this.el.css("height", value2);
            this.scope.fix_height = value;
            this._resizeHandle(false);
        },
        _setWidthAndHeight: function (value, dir, resize) {
            var el = this.el, auto_lays = this.auto_lays[dir], lays = auto_lays.length, layout = this.layout, surplus = value, all = 0;
            var i = lays;
            for (; i--;) {
                all += layout[auto_lays[i]];
            }
            for (i = lays; i--;) {
                var change = Math.round( value * layout[auto_lays[i]] / all), lay = el.find(".bl_" + auto_lays[i] + this.id);
                var css = ( i === 0 ? surplus : change );
                surplus -= change;
                lay.css(dir, layout[auto_lays[i]] += css );
                if (dir === "height") {
                    this._setBoxHeight(lay, css);
                }
            }
            if (!resize) {
                this._childrenHandler();
            }
        },
        _setBoxHeight: function (lay, change) {
            var box_height = this.box_height;
            lay.find(".bl_box" + this.id).each( function (j, ele) {
                var position = $(ele).attr("class").match(/top|left|center|bottom|right/)[0];
                var height = box_height[ position ] += change; // = Math.max(box_height[ position ] += change, 0);
                $(ele).css("height", Math.max(height, 0));
                if (!height) {
                    $(ele).hide();
                } else {
                    $(ele).show();
                }
            });
        },
        /**
         * 事件绑定
         */
        _bindHandler: function () {
            var _self = this, el = this.el;
            el.find(".bl_top>.bl_move, .bl_bottom>.bl_move").on("mousedown", function (event) {
                _self._drag(event, this, "height");
            });
            el.find(".bl_left>.bl_move, .bl_center>.bl_move, .bl_right>.bl_move").on("mousedown", function (event) {
                _self._drag(event, this, "width");
            });
            el.find(".bl_top .bl_fold, .bl_bottom .bl_fold").on("mousedown", function (event) {
                _self._fold(event, this, "height");
            });
            el.find(".bl_middle .bl_fold").on("mousedown", function (event) {
                _self._fold(event, this, "width");
            });
        },
        /**
         * 拖动大小,非center
         * 要求:未被折叠
         */
        _drag: function (eve, ele, dir) {
            var $ele = $(ele);
            if(!$ele.find(".bl_unfold").length) {
                return;
            }
            eve.stopPropagation();
            eve.preventDefault();
            var x = eve.pageX,
                y = eve.pageY,
                re,
                _self = this,
                layout = this.layout,
                min_size = this.min_size,
                max_size = this.max_size,
                cur = $ele.parent(),
                prev = cur.prev(),
                next = cur.next(),
                middle = cur.parent().not(".bl_main:eq(0)");
            if (prev.length ){
                next = cur;
            } else {
                prev = cur;
            }
            var po_prev = prev.attr("class").match(/top|left|center|bottom|middle|right/)[0],
                po_next = next.attr("class").match(/top|left|center|bottom|middle|right/)[0],
                layout_prev = layout[po_prev],
                layout_next = layout[po_next],
                min_size_prev = min_size[po_prev],
                min_size_next = min_size[po_next],
                max_size_prev = max_size[po_prev],
                max_size_next = max_size[po_next];
            this.el.children(".bl_overlay").show().css("height", this.scope.height).css("cursor", dir === "width" ? "col-resize" : "row-resize" ).on("mousemove", function (event) {
                event.stopPropagation();
                event.preventDefault();
                var x1 = event.pageX,
                    y1 = event.pageY,
                    change = middle.length ? x1 -x : y1 - y;
                if(change === 0 || change * re > 0) {
                    return;
                }
                re = 0;
                if (max_size_prev !== undefined &&
                    ( layout_prev + change > max_size_prev || layout_prev + change < min_size_prev)) {
                    change = change > 0 ? max_size_prev - layout_prev : min_size_prev - layout_prev;
                    re = change;
                }
                if (max_size_next !== undefined &&
                    ( layout_next - change > max_size_next || layout_next - change < min_size_next)) {
                    change = change < 0 ? layout_next - max_size_next : layout_next - min_size_next;
                    re = change;
                }
                prev.css(dir, layout_prev += change);
                next.css(dir, layout_next -= change);
                if (dir === "height"){
                    _self._setBoxHeight(prev, change);
                    _self._setBoxHeight(next, -change);
                }
                y = y1; x = x1;
                _self._childrenHandler();
            } ).on("mouseup mouseout", function (event) {
                event.stopPropagation();
                $(this).hide().off("mousemove");
                ( layout[po_prev] = layout[po_prev] === layout_prev ? layout[po_prev] : layout_prev );
                ( layout[po_next] = layout[po_next] === layout_next ? layout[po_next] : layout_next );
            });
        },
        /**
         * 折叠
         * 要求:固定,非center
         */
        _fold: function (event, ele, dir) {
            event.stopPropagation();
            if(event.button > 1) {
                return;
            }
            this._foldAction($(ele).parent().parent(), dir);
        },
        _foldAction: function (ele, dir, flag) {
            var layout = this.layout,
                position = ele.attr("class").match(/top|left|center|bottom|right/)[0],
                size = ele.data("fold"),
                button = ele.children(".bl_move,.bl_border").eq(0).children().eq(0);
            if(this.collapsable[position]) {
                if(flag === true && size !== undefined ||
                    flag === false && size === undefined) {
                    return;
                }
                if (size === undefined) {
                    this._setWidthAndHeight( layout[position] , dir);
                    ele.children(".bl_inner").hide();
                    ele.data("fold", layout[position]).css(dir, layout[position] = 0);
                    button.removeClass("bl_unfold").html(arrowDesc[position]);

                    return;
                }
                this._setWidthAndHeight( -size , dir);
                button.addClass("bl_unfold").html(arrow[position]);
                ele.children(".bl_inner").show();
                ele.removeData("fold").css(dir, layout[position] = size).children(".bl_inner");
            }
        },
        _childrenHandler: function () {
            var child_bl = null;
            if(!this.child_bl) {
                child_bl = this.el.find('[uitype=Borderlayout]');
                this.child_bl = child_bl.length === 0 ? null : child_bl;
            }
            child_bl = this.child_bl;
            if(child_bl) {
                child_bl.each(function() {
                    window.cui(this)._resizeHandle();
                });
            }
            var on_sizechange = this.options.on_sizechange;
            if (on_sizechange && typeof on_sizechange === "function") {
                on_sizechange();
            }
        },
        setContentURL: function (position, url) {
            var box = this.el.find(".bl_" + position + this.id).eq(0).find(".bl_box" + this.id).eq(0).children().eq(0);
            var iframe = box.find(".bl_iframe_page");
            if(iframe.length) {
                iframe.eq(0).attr("src", url);
            } else {
                box.append('<iframe class="bl_iframe_page" src="' + url + '" frameborder="0"></iframe>');
            }
        },
        setCollapse: function (position, flag) {
            if (this.options.fixed[position]) {
                this._foldAction($(".bl_" + position + this.id), ( this._isCols(position) ? "width" : "height" ) , flag);
            }
        },
        getCollapseState: function (position) {
            return {
                collapsed : !!this.el.find(".bl_" + position + this.id).eq(0).data("fold"),
                contentHeight : this.box_height[position],
                contentWidth : this.el.find(".bl_" + position + this.id).eq(0).width()
            };
        },
        setGap: function (margin) {
            var gap = this.options.gap = margin,
                gap_arr = gap.split(" ");
            this.el.css("padding", gap);
            this.margin_v = parseInt(gap_arr[0], 10) + (gap_arr[2] === undefined ? parseInt(gap_arr[0], 10) : parseInt(gap_arr[2], 10));
            this._resizeHandle();
        },
        setTittle : function (position, title) {
            $(".bl_" + position + this.id).find(".bl_header").eq(0).html(title);
        },
        setCollapsable: function (position, flag) {
            if (this.options.fixed[position]) {
                this.collapsable[position] = flag;
                var fold = $(".bl_" + position).children(".bl_move,.bl_border").eq(0).children(".bl_fold").eq(0);
                if (flag ) {
                    fold.show();
                    return;
                }
                fold.hide();
            }
        },
        /**
         * 改变面板的宽高
         */
        changeSize: function (position, size) {
            if (!this.options.fixed[position] || !size) {
                return;
            }
            this.layout[position] = this.layout[position] + size;
            this._setPartLayout();
            this._setBoxLayout();
            this._setWidthAndHeight(-size, this._isCols(position) ? "width" : "height");
        }
    });
})(window.comtop);