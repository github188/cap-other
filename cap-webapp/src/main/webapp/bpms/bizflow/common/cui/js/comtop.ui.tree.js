
/**
 * comtop.ui.Tree 树组件
 */
;(function($, C){

    /**
     * Tree
     * @type {[type]}
     */
    comtop.UI.Tree = comtop.UI.Base.extend({

        options: {
            uitype: "Tree",
            children: null, 		// 树的节点数据
            checkbox: false, 	//
            select_mode: 1, 		// 1:单选; 2:多选; 3:多选并级联;
            persist: false, 	// 使用cookie存储状态
            icon: "", 		// fasle不使用图标, url为自定义图标. 默认无图标.要自定义须传url.
            checkbox_style:"",
            on_dbl_click:null,
            on_expand: null, 	// 展开/收缩时回调			function(flag, node) {}
            on_select: null, 	// 选中/取消选中回调		function(flag, node) {}
            on_click: null, 	// 点击时回调				function(node, event) {}
            on_activate: null, 	// 节点激活时的回调函数;	function(node) {}
            on_focus: null, 	// 获取焦点时回调			function(node) {}
            on_blur: null, 	// 失焦时回调				function(node) {}
            on_lazy_read:null,      // lazy load时回调 	function(node) {}
            auto_focus: false, // Set focus to first child, when expanding or lazy-loading.
            keyboard: false,
            click_folder_mode:3,
            min_expand_level:1,
            theme:"cui",//树的样式风格,可选classic,cui;默认是cui 样式
            on_post_init:null ,//Callback(isReloading, isError) when tree was (re)loaded. 
            reactive:true//已激活的节点是否需要触发onActivate事件，默认true
        },

        dtree: null,

        _init: function(cusOpts) {
            var self = this;
            var opt = this.options;
            // 图标

            if(opt.icon!=="false"&&opt.icon!==""&&opt.theme==="cui") {
                setIcon(opt.children, opt.icon);
            }else if(opt.theme==="classic"){
                setIcon(opt.children, null);
            }

            if(typeof opt.checkbox_style==="string"&&opt.checkbox_style!==""){
                opt.classNames= {checkbox: "dynatree-radio"};
            }
            if(typeof opt.children === "function"){
                opt.initDataFn = opt.children;
                opt.children = [];
            }
            $.each(this.options,function(item,value){
                var pos=item.indexOf("_");
                if(pos&&pos!==-1){
                    var _item="";
                    // 处理形如 on_lazy_read 转换成 onLazyRead
                    $.each(item.split("_"),function(i){
                        if(i===0){
                            _item+=this;
                        }else{
                            _item+= this.charAt(0).toUpperCase()+this.substring(1);
                        }
                    });
                    var handler=value;
                    if(typeof handler ==="function"){
                        self._proxyEvent(handler,opt,_item);
                        /*
                         // 事件委托
                         opt[_item]=function(){
                         var proxyThis=this;
                         // "activate", "focus", "blur","lazy"
                         if(arguments.length === 1) {
                         handler.call(null, self._wrapNode(arguments[0]));
                         }

                         // "expand", "select", "click"
                         else if(arguments.length === 2) {

                         // "expand", "select"
                         if(typeof arguments[0] === "boolean") {
                         if(typeof arguments[1] === "boolean"){
                         handler.apply(proxyThis,arguments);
                         }else{
                         handler.call(null, arguments[0], self._wrapNode(arguments[1]));
                         }

                         } else {  // "click"
                         // alert(arguments[0].getEventTargetType(arguments[1]));
                         if(_item=="onClick"){
                         var el=arguments[1].target||arguments[1].srcElement;
                         if(el.nodeName.toLowerCase()=="span"&&el.className=="dynatree-expander"){return;}
                         }
                         handler.call(null, self._wrapNode(arguments[0]), arguments[1]);
                         }
                         }

                         };*/
                    }else{
                        opt[_item]=value;
                    }
                }
            });

        },
        _proxyEvent:function(handler,opt,item){
            var self=this;
            opt[item]=function(){
                var proxyThis=this;
                // "activate", "focus", "blur","lazy"
                if(arguments.length === 1) {
                    handler.call(null, self._wrapNode(arguments[0]));
                }

                // "expand", "select", "click"
                else if(arguments.length === 2) {

                    // "expand", "select"
                    if(typeof arguments[0] === "boolean") {
                        if(typeof arguments[1] === "boolean"){
                            handler.apply(proxyThis,arguments);
                        }else{
                            handler.call(null, arguments[0], self._wrapNode(arguments[1]));
                        }

                    } else {  // "click"
                        // alert(arguments[0].getEventTargetType(arguments[1]));
                        if(item==="onClick"){
                            var el=arguments[1].target||arguments[1].srcElement;
                            if(el.nodeName.toLowerCase()==="span"&&el.className==="dynatree-expander"){return;}
                        }
                        handler.call(null, self._wrapNode(arguments[0]), arguments[1]);
                    }
                }

            };
        },
        _create: function() {
            var opt = this.options;
            if($.isArray(opt.children)){
                if(opt.children.length){
                    opt.children[0]._firstNode=true;
                }
            }else if(opt.children&&typeof opt.children==="object"){
                opt.children._firstNode=true;
                opt.children=[opt.children];
            }else{  //处理其它乱写的情况，渲染成空树
                opt.children=[];
            }
            this.dtree = $(this.options.el).dynatree(this.options).dynatree("getTree");
            opt.el.addClass("tree_"+opt.theme);
            if(opt.initDataFn){
                opt.initDataFn(this, opt);
            }
        },

        ////////////////////////////////////////////////
        //
        //   Public
        //
        ////////////////////////////////////////////////

        /**
         * 获取当前激活节点
         * @return {TreeNode} 树节点对象
         */
        getActiveNode: function() {
            return this._wrapNode(this.dtree.getActiveNode());
        },

        /**
         * 获取指定节点
         * @param  {string} key 树节点的key值
         * @return {TreeNode}     树节点对象
         */
        getNode: function(key) {
            return this._wrapNode(this.dtree.getNodeByKey(key));
        },

        /**
         * 选中指定节点
         * @param  {string} key  树节点的key值
         * @param  {boolean} flag true/false
         * @return {TreeNode}      树节点对象
         */
        selectNode: function(key, flag) {
            return this.getNode(key).select(flag);
        },

        /**
         * 使树可用
         * @return {[type]} [description]
         */
        enable: function() {
            this.dtree.enable();
            return this;
        },

        /**
         * 使树不可用
         * @return {[type]} [description]
         */
        disable: function() {
            this.dtree.disable();
            return this;
        },

        /**
         * 设置tree的数据源
         * @param data {Object} JSON数据
         * @return {*}
         */
        setDatasource: function(data){
            if("object" !== typeof data || data===null){return;}
            if($.isArray(data)){
                if(data.length){
                    data[0]._firstNode=true;
                }
            }else{
                data._firstNode=true;
                data=[data];
            }
            this.options.children = data;
            this.getRoot().removeChildren().addChild(data);
            return this;
        },
        /**
         * 获取树的数据
         * @return [{*}]
         */
        getDatasource:function(){
            var data=this.dtree.toDict();
            return data.children;
        },
        getDataSource:function(){
            return this.getDatasource();
        },
        /**
         * 获取选中的节点
         * @param  {boolean} stopOnParents [description]
         * @return {[type]}               [description]
         */
        getSelectedNodes: function(stopOnParents) {
            var self = this,
                nodes = this.dtree.getSelectedNodes(stopOnParents);
            return $.map(nodes, function(node, index) {
                return self._wrapNode(node);
            });
        },
        /**
         * 获取不可见的顶层根节点.所有第一级的节点是此根节点的子节点。
         * @return {[type]} [description]
         */
        getRoot: function() {
            return this._wrapNode(this.dtree.getRoot());
        },
        bind:function(type,fn){
            if(typeof type!="string"||typeof fn !="function"){
                return;
            }
            var type= "on"+type.charAt(0).toUpperCase()+type.substring(1),
                eventType=	this.dtree.options[type];
            if(typeof eventType==="undefined"){return;}
            this._proxyEvent(fn, this.dtree.options, type);

        },
        unbind:function(type){
            if(typeof type=="string"){
                var type= "on"+type.charAt(0).toUpperCase()+type.substring(1);
                var eventType=	this.dtree.options[type];
                if(typeof eventType==="undefined"){return;}
                this.dtree.options[type]=null;
            }else{
                $.extend(this.dtree.options,{
                    onClick: null,  onDblClick: null,
                    onKeydown: null,
                    onKeypress: null,
                    onFocus: null,
                    onBlur: null,
                    onQueryActivate: null,
                    onQuerySelect: null,
                    onQueryExpand: null,
                    onPostInit: null,
                    onActivate: null,
                    onDeactivate: null,
                    onSelect: null,
                    onExpand: null,
                    onCustomRender: null,
                    onCreate: null,
                    onRender: null
                });
            }

        },

        ////////////////////////////////////////////////
        //
        //   Private
        //
        ////////////////////////////////////////////////

        /**
         * wrap Node
         * @param  {[type]} node [description]
         * @return {[type]}      [description]
         */
        _wrapNode: function(node) {
            if(!node){return null;}
            return new Node(node);
        }
    });

    /**
     * Tree Node　树节点对象
     * @param {[type]} node [description]
     */
    /*	var DTNodeStatus_Error = -1;
     var DTNodeStatus_Loading = 1;
     var DTNodeStatus_Ok = 0;*/

    var Node = function(node) {

        this.dNode = node;

    };

    Node.prototype = {
        error:-1,
        loading:1,
        ok:0,
        //Activate this node - according to flag - and fire a onActivate event.
        //@param {boolean}  reActive  已激活的节点是否需要触发onActivate事件，默认true
        activate:function(reActive){
            if(typeof reActive=="undefined"){
                reActive=true;
            }
            this.dNode.activate(reActive);
        },
        deactivate:function(){
            this.dNode.deactivate();
        },
        /**
         * 获取node数据
         * @param  {string|}
         * @return {[type]}  string | object
         */
        getData:function(name){
            if(typeof name =="string"){
                return this.dNode.data[name];
            }
            return this.dNode.data;
        },
        /*
         appendAjax:function(){
         this.dNode.appendAjax.apply(this.dNode,arguments);
         },
         */
        /**
         * 展开
         * @param  {boolean} flag 展开/收缩
         * @return {[type]}      [description]
         */
        expand: function(flag) {
            this.dNode.expand(flag);
            return this;
        },

        /**
         * 删除节点
         */
        remove: function() {
            this.dNode.remove();
        },

        removeChildren: function(){
            this.dNode.removeChildren();
            return this;
        },

        /**
         * 选中某节点
         * @param  {boolean} flag 选中/不选中
         * @return {Node}    当前对象
         */
        select: function(flag) {
            this.dNode.select(flag);
            return this;
        },

        /**
         * 切换选中状态
         * @return {[type]} [description]
         */
        toggleSelect: function() {
            this.dNode.toggleSelect();
            return this;
        },

        /**
         * 添加节点
         * @param {object} data json数据
         * @param {Node} beforeNode [可选]如果指定此节点,则插入到此节点前面.
         */
        addChild: function(data, beforeNode) {
            var node = this.dNode.addChild(data, beforeNode && beforeNode.dNode);
            return this._wrapNode(node);
        },

        /**
         * 设置节点标题
         * @param {string} title 新标题
         */
        setTitle: function(title) {
            return this.dNode.setTitle(title);
        },

        /**
         * 设置节点样式
         * @param {string} str 节点样式
         */
        setStyle:function(str){
            $(this.dNode.span).find("a").attr("style",str);

            this.dNode.data._customStyle=str;

            return this;

        },
        removeStyle:function(){
            $(this.dNode.span).find("a").removeAttr("style");
            this.dNode.data._customStyle=null;
            return this;

        },

        /**
         * 前一个
         * @return {Node} [description]
         */
        prev: function() {
            var node = this.dNode.getPrevSibling();
            return node && this._wrapNode(node);
        },

        /**
         * 后一个节点
         * @return {Node} [description]
         */
        next: function() {
            var node = this.dNode.getNextSibling();
            return node && this._wrapNode(node);
        },

        /**
         * 第一个孩子
         * @return {[type]} [description]
         */
        firstChild: function() {
            var nodes = this.children();
            if(nodes==null||nodes==undefined){
                return nodes;
            }
            return nodes.length > 0 ? nodes[0] : null;
        },

        /**
         * 最后一个小孩
         * @return {[type]} [description]
         */
        lastChild: function() {
            var nodes = this.children();
            if(nodes==null||nodes==undefined){
                return nodes;
            }
            return nodes.length > 0 ? nodes[nodes.length - 1] : null;
        },

        /**
         * 获取所有子节点
         * @return {Array<Node>} [description]
         */
        children: function() {
            var self = this,
                nodes = this.dNode.getChildren();
            if(nodes==null||nodes==undefined){
                return nodes;
            }

            return $.map(nodes, function(node, idx) {
                return self._wrapNode(node);
            });
        },

        /**
         * 获取父节点
         * @return {[type]} [description]
         */
        parent: function() {
            var node = this.dNode.getParent();
            return node && this._wrapNode(node);
        },

        /**
         * 设置节点属性
         * 1. set(name, value);
         * 2. set(obj); obj为键值对象
         * @return {Node} 当前节点对象
         */
        setData: function(data) {
            if(arguments.length === 1) {
                for(var prop in data) {
                    this.dNode.data[prop] = data[prop];
                }
            } else {
                var name = arguments[0],
                    val = arguments[1];
                this.dNode.data[name] = val;
            }
            this.dNode.render();
            return this;
        },

        /**
         * 展开此节点的相关父节点，以使该节点可见，并滚动到此节点
         * @return {[type]} [description]
         */
        focus: function() {
            this.dNode.focus();
            return this;
        },

        /**
         * 是否存在子节点
         * @return {Boolean} [description]
         */
        hasChild: function() {
            return this.dNode.hasChildren();
        },

        /**
         * 是否otherNode的直接子节点
         * @return {Boolean} [description]
         */
        isChildOf: function(otherNode) {
            return this.dNode.isChildOf(otherNode.dNode);
        },

        /**
         * 是否otherNode的后代节点
         * @param  {Node}  otherNode [description]
         * @return {Boolean}           [description]
         */
        isDescendantOf: function(otherNode) {
            return this.dNode.isDescendantOf(otherNode.dNode);
        },

        setLazyNodeStatus:function(){

            this.dNode.setLazyNodeStatus.apply(this.dNode,arguments);

        },
        getEventTargetType:function(e){
            return this.dNode.getEventTargetType(e);
        },
        /**
         * Move this node to targetNode. Possible mode:
         child: append this node as last child of targetNode. This is the default.
         before: add this node as sibling before targetNode.
         after: add this node as sibling after targetNode.
         * */
        move:function(targetNode, mode){
            if(!targetNode.dNode){return;}
            this.dNode.move(targetNode.dNode, mode);
        },
        disable:function(){
            this.dNode.disable();
            return this;
        },
        enable:function(){
            this.dNode.enable();
            return this;
        },
        ////////////////////////////////////////////////
        //
        //   Private
        //
        ////////////////////////////////////////////////

        /**
         * Wrap Node
         * @param  {Node} node [description]
         * @return {[type]}      [description]
         */
        _wrapNode: function(node) {
            if(!node){return null;}
            return new Node(node);
        }

    };

    /**
     * comtop.UI.Tree.Node  树节点对象.
     * @type {[type]}
     */
    comtop.UI.Tree.Node = Node;


    ////////////////////////////////////////////////
    //
    //   Tools 一些工具方法
    //
    ////////////////////////////////////////////////

    /**
     * 首字母大写q
     * @param  {string} word 单词
     * @return {string}      转换后的单词
     */
    function upper(word) {
        return word.replace(/(^|\s+)\w/g, function(letter) {
            return letter.toUpperCase();
        });
    }

    /**
     * 递归设置图标
     * @param {Array<object>} children [description]
     * @param {string} icon     图片的url
     */
    function setIcon(children, icon) {
        if(children.length > 0) {
            $.each(children, function(index, node) {
                if(node.icon===undefined) {
                    node["icon"] = icon;
                }
                if(node.children) {
                    setIcon(node.children, icon);
                }
            });
        }
    }

})(window.comtop.cQuery, window.comtop);

