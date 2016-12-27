/**
 * 多功能导航
 * 可实现单级和多级菜单,多级下类似属性菜单.
 * @author 王伟
 * @since 2013-3-37
 */
(function(C) {
    'use strict';
    var $ = C.cQuery;
    C.UI.MultiNav = C.UI.Base.extend({
        options: {
            uitype            : "MultiNav",
            unfold            : false,         //多级导航有效,是否全部展开子菜单
            initchecked       : [],           //默认选中的菜单,数组[0, 1]表示第1个子菜单下的第2个子菜单被初始选中
            datasource        : [],           //菜单数组,数组格式json
            target            : "_self",      //菜单链接的target属性,支持iframe的name属性.
            foldercheckable   : false          //多级导航有效,有子菜单的父菜单是否可以被选中.
        },
        /**
         * 初始化数据
         * @private
         */
        _init: function () {
            this.pos = -1;
        },
        /**
         * 初始化函数
         * @private
         */
        _create : function() {
            this.root = this.options.root = this.options.el.children(".multinav").eq(0);
            this._setDatasource(this.options.datasource);
        },
        /**
         * 初始选中定位
         */
        _initcheck : function(curr) {
            var thisObj = this.root;
            //根据 options.initchecked 选定需要初始选中菜单的dom树位置
            for(var i = 0, j = curr.length; i < j; i++) {
                thisObj = thisObj.children("li").eq(curr[i]);
                var thisObjA = thisObj.find("a").eq(0);
                //根据设置的class判断是否有子菜单.
                if( thisObjA.hasClass("multinav-fold") ) {
                    if(i === j - 1 && this.options.foldercheckable) {
                        thisObjA.addClass("multinav-checked");
                        this.pos = thisObjA.attr("pos");
                    }
                    thisObjA.addClass("multinav-unfold").data("unfold", true);
                    //定位到子菜单的父元素 ul 并使其显示.
                    thisObj = thisObj.children("ul").eq(0);
                    thisObj.addClass("multinav-ul-unfold");
                } else {
                    //没有子菜单,直接选中
                    thisObjA.addClass("multinav-checked");
                    this.pos = thisObjA.attr("pos");
                    break;
                }
            }
        },
        /**
         * 为数据 options.datasource{json} 中含有"bind"属性的菜单绑定相关事件
         */
        _bindEvents : function() {
            var self = this;
            var data = null;
            this.root.on("mouseover", function (event) {
                //消除冒泡
                event.stopPropagation();
                var currA = $(event.target),
                    pos = currA.attr("pos");
                if (!pos) {
                    currA = currA.parent();
                    pos = currA.attr("pos");
                    if (!pos) {
                        return;
                    }
                }
                data = self._getCheckedData(pos);
                var bind = data.bind,
                    eventType = event.type;
                if (typeof bind !== "object") {
                    return;
                }
                var handler = bind["on_" + eventType];
                if (typeof handler === "function") {
                    event.target = currA[0];
                    handler(event, currA[0], data);
                }
            });
            this.root.on("mouseout dblclick click", function (event) {
                //消除冒泡
                event.stopPropagation();
                var currA = $(event.target),
                    pos = currA.attr("pos");
                if (!pos) {
                    currA = currA.parent();
                    pos = currA.attr("pos");
                    if (!pos) {
                        return;
                    }
                }
                var eventType = event.type,
                    bind = data.bind;
                if (typeof bind !== "object") {
                    return;
                }
                var handler = bind["on_" + eventType];
                if (typeof handler === "function") {
                    event.target = currA[0];
                    handler(event, currA[0], data);
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
         * 根据菜单数据json生成dom
         */
        setDatasource: function(data, opt){
            //配置项覆盖
            this.pos = -1;
            var options = opt ? $.extend(this.options, opt) : this.options;
            function bindEvent (events) {
                return new Function(events);
            }
            function loadTemplate(obj, pos) {
                var frag = $(document.createDocumentFragment());
                for(var i = 0, j = obj.length ; i < j; i++){
                    var cObj = obj[i],
                        li = $(document.createElement("li")),
                        a = $(document.createElement("a"));
                    a.attr("hidefocus", "true");
                    li.append(a);
                    if(cObj.onclick){
                        a.click(bindEvent(cObj.onclick));
                    }
                    if(cObj.ondblclick){
                        a.dblclick(bindEvent(cObj.ondblclick));
                    }
                    if(cObj.onmouseover){
                        a.mouseover(bindEvent(cObj.onmouseover));
                    }
                    if(cObj.onmouseout){
                        a.mouseout(bindEvent(cObj.onmouseout));
                    }
                    //其他属性设置
                    if(cObj.title) {
                        a.attr("title", cObj.title);
                    }
                    a.attr("pos", pos + i);
                    //有事件句柄 需要设置 pos属性
                    if(cObj.bind) {
                        a.attr("ev", "1");
                    }
                    //链接
                    if( typeof cObj.href === "string" ) {
                        a.attr("href", cObj.href);
                        a.attr("target", cObj.target || options.target);
                    } else {
                        a.attr("href", "javascript:;");
                    }
                    //含有子菜单,递归.
                    if(typeof cObj.children === "object") {
                        a.addClass("multinav-fold").append('<span class="multinav-fold-icon cui-icon">&#xf0da;</span><span class="multinav-unfold-icon cui-icon">&#xf0d7;</span>' + cObj.name);
                        var ul = $("<ul></ul>");
                        ul.append( loadTemplate(cObj.children, pos + i + "-") );
                        li.append(ul);
                    } else {
                        a.html(cObj.name);
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
         * 全部展开
         */
        allUnfold : function() {
            this.root.find("ul").addClass("multinav-ul-unfold").show().end().find(".multinav-fold").addClass("multinav-unfold").data("unfold", true);
        },
        /**
         * 全部收缩
         */
        allFold : function() {
            this.root.find("ul").removeClass("multinav-ul-unfold").hide().end().find(".multinav-fold").removeClass("multinav-unfold").data("unfold", false);
        },
        /**
         * 为每个菜单绑定点击事件
         */
        _mousedown : function(target) {
            //查找a标签
            var currA = $(target);
            currA     = currA.prop("tagName") === "A" ? currA : currA.parent();
            //是否有子目录,这个属性在模版中设定
            var pos = currA.attr("pos");
            if( currA.hasClass("multinav-fold") ) {
                //判断当前是否是展开状态
                var unfold = currA.data("unfold");
                unfold     = unfold === undefined ? this.options.unfold : unfold;
                if(unfold) {
                    //收缩动画
                    currA.data("unfold", false).removeClass("multinav-unfold").next("ul").hide();
                } else {
                    //展开动画
                    currA.data("unfold", true).addClass("multinav-unfold").next("ul").show();
                }
                //如果可展开菜单(有子菜单的菜单)可被选中,执行如下
                if(this.options.foldercheckable){
                    this.root.find(".multinav-checked").removeClass("multinav-checked");
                    currA.addClass("multinav-checked");
                    this.pos = pos;
                }
            } else {
                //选中菜单.
                this.root.find(".multinav-checked").removeClass("multinav-checked");
                currA.addClass("multinav-checked");
                this.pos = pos;
            }
        },
        /**
         * 获取当前pos的datat
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
         * 获取当前被选中的值的数据
         * @returns {*}
         */
        getCheckedData : function () {
            var data = this._getCheckedData(this.pos);
            if (data === null || data.children !== undefined && !this.options.foldercheckable) {
                return null;
            }
            return data;
        }
    });
})(window.comtop);