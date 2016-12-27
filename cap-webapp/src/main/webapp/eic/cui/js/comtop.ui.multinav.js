/**
 * ???????
 * ??????????????,??????????????.
 * @author ???
 * @since 2013-3-37
 */
(function(C) {
    'use strict';
    var $ = C.cQuery;
    C.UI.MultiNav = C.UI.Base.extend({
        options: {
            uitype            : "MultiNav",
            unfold            : false,         //????????§¹,?????????????
            initchecked       : [],           //?????§Ö???,????[0, 1]?????1??????????2??????????????
            datasource        : [],           //???????,??????json
            target            : "_self",      //????????target????,???iframe??name????.
            foldercheckable   : false          //????????§¹,??????????????????????.
        },
        /**
         * ????????
         * @private
         */
        _init: function () {
            this._pos = -1;
        },
        /**
         * ?????????
         * @private
         */
        _create : function() {
            this.root = this.options.root = this.options.el.children(".multinav").eq(0);
            this._setDatasource(this.options.datasource);
        },
        /**
         * ?????§Ø?¦Ë
         */
        _initcheck : function(curr) {
            var this_obj = this.root;
            //??? options.initchecked ???????????§Ó????dom??¦Ë??
            for(var i = 0, j = curr.length; i < j; i++) {
                this_obj = this_obj.children("li").eq(curr[i]);
                var this_obj_a = this_obj.find("a").eq(0);
                //????????class?§Ø??????????.
                if( this_obj_a.hasClass("multinav_fold") ) {
                    if(i === j - 1 && this.options.foldercheckable) {
                        this_obj_a.addClass("checked");
                        this._pos = this_obj_a.attr("pos");
                    }
                    this_obj_a.addClass("multinav_unfold").data("unfold", true);
                    //??¦Ë???????????? ul ????????.
                    this_obj = this_obj.children("ul").eq(0);
                    this_obj.addClass("multinav_ul_unfold");
                } else {
                    //???????,??????
                    this_obj_a.addClass("checked");
                    this._pos = this_obj_a.attr("pos");
                    break;
                }
            }
        },
        /**
         * ???? options.datasource{json} ?§Ü???"bind"???????????????
         */
        _bindEvents : function() {
            var self = this;
            var data = null;
            this.root.on("mouseover", function (event) {
                //??????
                event.stopPropagation();
                var curr_a = $(event.target),
                    pos = curr_a.attr("pos");
                if (!pos) {
                    curr_a = curr_a.parent();
                    pos = curr_a.attr("pos");
                    if (!pos) {
                        return;
                    }
                }
                data = self._getCheckedData(pos);
                var bind = data.bind,
                    event_type = event.type;
                if (typeof bind !== "object") {
                    return;
                }
                var handler = bind["on_" + event_type];
                if (typeof handler === "function") {
                    event.target = curr_a[0];
                    handler(event, curr_a[0], data);
                }
            });
            this.root.on("mouseout dblclick click", function (event) {
                //??????
                event.stopPropagation();
                var curr_a = $(event.target),
                    pos = curr_a.attr("pos");
                if (!pos) {
                    curr_a = curr_a.parent();
                    pos = curr_a.attr("pos");
                    if (!pos) {
                        return;
                    }
                }
                var event_type = event.type,
                    bind = data.bind;
                if (typeof bind !== "object") {
                    return;
                }
                var handler = bind["on_" + event_type];
                if (typeof handler === "function") {
                    event.target = curr_a[0];
                    handler(event, curr_a[0], data);
                }
                return false;
            });
        },

        _setDatasource: function(data) {
            this.setDatasource(data, undefined);
            this._bindEvents();
            this._initcheck(this.options.initchecked);
            var self = this;
            this.root.on("mousedown", function (event) {
                event.stopPropagation();
                self._mousedown(event.target);
            });
        },
        /**
         * ????????json???dom
         */
        setDatasource: function(data, opt){
            //????????
            this._pos = -1;
            var options = opt ? $.extend(this.options, opt) : this.options;
            function bindEvent (events) {
                return new Function(events);
            }
            function loadTemplate(obj, pos) {
                var frag = $(document.createDocumentFragment());
                for(var i = 0, j = obj.length ; i < j; i++){
                    var c_obj = obj[i],
                        li = $(document.createElement("li")),
                        a = $(document.createElement("a"));
                    a.attr("hidefocus", "true");
                    li.append(a);
                    if(c_obj.onclick){
                        a.click(bindEvent(c_obj.onclick));
                    }
                    if(c_obj.ondblclick){
                        a.dblclick(bindEvent(c_obj.ondblclick));
                    }
                    if(c_obj.onmouseover){
                        a.mouseover(bindEvent(c_obj.onmouseover));
                    }
                    if(c_obj.onmouseout){
                        a.mouseout(bindEvent(c_obj.onmouseout));
                    }
                    //????????????
                    if(c_obj.title) {
                        a.attr("title", c_obj.title);
                    }
                    a.attr("pos", pos + i);
                    //???????? ??????? pos????
                    if(c_obj.bind) {
                        a.attr("ev", "1");
                    }
                    //????
                    if( typeof c_obj.href === "string" ) {
                        a.attr("href", c_obj.href);
                        a.attr("target", c_obj.target || options.target);
                    } else {
                        a.attr("href", "javascript:;");
                    }
                    //????????,???.
                    if(typeof c_obj.children === "object") {
                        a.addClass("multinav_fold").append("<span>" + c_obj.name + "</span>");
                        var ul = $("<ul></ul>");
                        ul.append( loadTemplate(c_obj.children, pos + i + "-") );
                        li.append(ul);
                    } else {
                        a.html(c_obj.name);
                    }
                    frag.append(li);
                }
                return frag;
            }
            this.options.datasource = data;
            options.root.html( loadTemplate(data, "") );
            if(options.unfold) {
                this.allUnfold();
            }
            if(opt && opt.initchecked) {
                this._initcheck(opt.initchecked);
            }
        },
        /**
         * ??????
         */
        allUnfold : function() {
            this.root.find("ul").addClass("multinav_ul_unfold").show().end().find(".multinav_fold").addClass("multinav_unfold").data("unfold", true);
        },
        /**
         * ???????
         */
        allFold : function() {
            this.root.find("ul").removeClass("multinav_ul_unfold").hide().end().find(".multinav_fold").removeClass("multinav_unfold").data("unfold", false);
        },
        /**
         * ??????????????
         */
        _mousedown : function(target) {
            //????a???
            var curr_a = $(target);
            curr_a     = curr_a.prop("tagName") === "A" ? curr_a : curr_a.parent();
            //?????????,???????????????Ú…
            var pos = curr_a.attr("pos");
            if( curr_a.hasClass("multinav_fold") ) {
                //?§Ø?????????????
                var unfold = curr_a.data("unfold");
                unfold     = unfold === undefined ? this.options.unfold : unfold;
                if(unfold) {
                    //????????
                    curr_a.data("unfold", false).removeClass("multinav_unfold").next("ul").hide();
                } else {
                    //???????
                    curr_a.data("unfold", true).addClass("multinav_unfold").next("ul").show();
                }
                //??????????(??????????)??????,???????
                if(this.options.foldercheckable){
                    this.root.find(".checked").removeClass("checked");
                    curr_a.addClass("checked");
                    this._pos = pos;
                }
            } else {
                //??§Ó??.
                this.root.find(".checked").removeClass("checked");
                curr_a.addClass("checked");
                this._pos = pos;
            }
        },
        /**
         * ??????pos??datat
         * @param pos
         * @returns {*}
         * @private
         */
        _getCheckedData: function (pos) {
            if(pos === -1) {
                return null;
            }
            var data = this.options.datasource;
            pos = pos.split("-");
            var len = pos.length;
            for (var i = 0; i < len - 1; i++) {
                data = data[parseInt(pos[i], 10)].children;
            }
            data = data[parseInt(pos[i], 10)];
            return data;
        },
        /**
         * ??????????§Ö???????
         * @returns {*}
         */
        getCheckedData : function () {
            var data = this._getCheckedData(this._pos);
            if (data === null || data.children !== undefined && !this.options.foldercheckable) {
                return null;
            }
            return data;
        }
    });
})(window.comtop);