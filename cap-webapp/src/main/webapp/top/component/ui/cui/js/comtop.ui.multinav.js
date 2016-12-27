/**
 * �๦�ܵ���
 * ��ʵ�ֵ����Ͷ༶�˵�,�༶���������Բ˵�.
 * @author ��ΰ
 * @since 2013-3-37
 */
(function(C) {
    'use strict';
    var $ = C.cQuery;
    C.UI.MultiNav = C.UI.Base.extend({
        options: {
            uitype            : "MultiNav",
            unfold            : false,         //�༶������Ч,�Ƿ�ȫ��չ���Ӳ˵�
            initchecked       : [],           //Ĭ��ѡ�еĲ˵�,����[0, 1]��ʾ��1���Ӳ˵��µĵ�2���Ӳ˵�����ʼѡ��
            datasource        : [],           //�˵�����,�����ʽjson
            target            : "_self",      //�˵����ӵ�target����,֧��iframe��name����.
            foldercheckable   : false          //�༶������Ч,���Ӳ˵��ĸ��˵��Ƿ���Ա�ѡ��.
        },
        /**
         * ��ʼ������
         * @private
         */
        _init: function () {
            this.pos = -1;
        },
        /**
         * ��ʼ������
         * @private
         */
        _create : function() {
            this.root = this.options.root = this.options.el.children(".multinav").eq(0);
            this._setDatasource(this.options.datasource);
        },
        /**
         * ��ʼѡ�ж�λ
         */
        _initcheck : function(curr) {
            var thisObj = this.root;
            //���� options.initchecked ѡ����Ҫ��ʼѡ�в˵���dom��λ��
            for(var i = 0, j = curr.length; i < j; i++) {
                thisObj = thisObj.children("li").eq(curr[i]);
                var thisObjA = thisObj.find("a").eq(0);
                //�������õ�class�ж��Ƿ����Ӳ˵�.
                if( thisObjA.hasClass("multinav-fold") ) {
                    if(i === j - 1 && this.options.foldercheckable) {
                        thisObjA.addClass("multinav-checked");
                        this.pos = thisObjA.attr("pos");
                    }
                    thisObjA.addClass("multinav-unfold").data("unfold", true);
                    //��λ���Ӳ˵��ĸ�Ԫ�� ul ��ʹ����ʾ.
                    thisObj = thisObj.children("ul").eq(0);
                    thisObj.addClass("multinav-ul-unfold");
                } else {
                    //û���Ӳ˵�,ֱ��ѡ��
                    thisObjA.addClass("multinav-checked");
                    this.pos = thisObjA.attr("pos");
                    break;
                }
            }
        },
        /**
         * Ϊ���� options.datasource{json} �к���"bind"���ԵĲ˵�������¼�
         */
        _bindEvents : function() {
            var self = this;
            var data = null;
            this.root.on("mouseover", function (event) {
                //����ð��
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
                //����ð��
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
         * ���ݲ˵�����json����dom
         */
        setDatasource: function(data, opt){
            //�������
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
                    //������������
                    if(cObj.title) {
                        a.attr("title", cObj.title);
                    }
                    a.attr("pos", pos + i);
                    //���¼���� ��Ҫ���� pos����
                    if(cObj.bind) {
                        a.attr("ev", "1");
                    }
                    //����
                    if( typeof cObj.href === "string" ) {
                        a.attr("href", cObj.href);
                        a.attr("target", cObj.target || options.target);
                    } else {
                        a.attr("href", "javascript:;");
                    }
                    //�����Ӳ˵�,�ݹ�.
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
         * ȫ��չ��
         */
        allUnfold : function() {
            this.root.find("ul").addClass("multinav-ul-unfold").show().end().find(".multinav-fold").addClass("multinav-unfold").data("unfold", true);
        },
        /**
         * ȫ������
         */
        allFold : function() {
            this.root.find("ul").removeClass("multinav-ul-unfold").hide().end().find(".multinav-fold").removeClass("multinav-unfold").data("unfold", false);
        },
        /**
         * Ϊÿ���˵��󶨵���¼�
         */
        _mousedown : function(target) {
            //����a��ǩ
            var currA = $(target);
            currA     = currA.prop("tagName") === "A" ? currA : currA.parent();
            //�Ƿ�����Ŀ¼,���������ģ�����趨
            var pos = currA.attr("pos");
            if( currA.hasClass("multinav-fold") ) {
                //�жϵ�ǰ�Ƿ���չ��״̬
                var unfold = currA.data("unfold");
                unfold     = unfold === undefined ? this.options.unfold : unfold;
                if(unfold) {
                    //��������
                    currA.data("unfold", false).removeClass("multinav-unfold").next("ul").hide();
                } else {
                    //չ������
                    currA.data("unfold", true).addClass("multinav-unfold").next("ul").show();
                }
                //�����չ���˵�(���Ӳ˵��Ĳ˵�)�ɱ�ѡ��,ִ������
                if(this.options.foldercheckable){
                    this.root.find(".multinav-checked").removeClass("multinav-checked");
                    currA.addClass("multinav-checked");
                    this.pos = pos;
                }
            } else {
                //ѡ�в˵�.
                this.root.find(".multinav-checked").removeClass("multinav-checked");
                currA.addClass("multinav-checked");
                this.pos = pos;
            }
        },
        /**
         * ��ȡ��ǰpos��datat
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
         * ��ȡ��ǰ��ѡ�е�ֵ������
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