?
/**
 * comtop.ui.Tree �����
 */
;(function($, C){

    /**
     * Tree
     * @type {[type]}
     */
    comtop.UI.Tree = comtop.UI.Base.extend({

        options: {
            uitype: "Tree",
            children: null, 		// ���Ľڵ�����
            checkbox: false, 	//
            select_mode: 1, 		// 1:��ѡ; 2:��ѡ; 3:��ѡ������;
            persist: false, 	// ʹ��cookie�洢״̬
            icon: "", 		// fasle��ʹ��ͼ��, urlΪ�Զ���ͼ��. Ĭ����ͼ��.Ҫ�Զ����봫url.
            checkbox_style:"",
            on_dbl_click:null,
            on_expand: null, 	// չ��/����ʱ�ص�			function(flag, node) {}
            on_select: null, 	// ѡ��/ȡ��ѡ�лص�		function(flag, node) {}
            on_click: null, 	// ���ʱ�ص�				function(node, event) {}
            on_activate: null, 	// �ڵ㼤��ʱ�Ļص�����;	function(node) {}
            on_focus: null, 	// ��ȡ����ʱ�ص�			function(node) {}
            on_blur: null, 	// ʧ��ʱ�ص�				function(node) {}
            on_lazy_read:null,      // lazy loadʱ�ص� 	function(node) {}
            auto_focus: false, // Set focus to first child, when expanding or lazy-loading.
            keyboard: false,
            click_folder_mode:3,
            min_expand_level:1,
            theme:"cui",//������ʽ���,��ѡclassic,cui;Ĭ����cui ��ʽ
            on_post_init:null ,//Callback(isReloading, isError) when tree was (re)loaded. 
            reactive:true//�Ѽ���Ľڵ��Ƿ���Ҫ����onActivate�¼���Ĭ��true
        },

        dtree: null,

        _init: function(cusOpts) {
            var self = this;
            var opt = this.options;
            // ͼ��

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
                    // �������� on_lazy_read ת���� onLazyRead
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
                         // �¼�ί��
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
                            if(el.nodeName.toLowerCase()==="span"&& /dynatree-expander/.test(el.className)){return;}
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
            }else{  //����������д���������Ⱦ�ɿ���
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
         * ��ȡ��ǰ����ڵ�
         * @return {TreeNode} ���ڵ����
         */
        getActiveNode: function() {
            return this._wrapNode(this.dtree.getActiveNode());
        },

        /**
         * ��ȡָ���ڵ�
         * @param  {string} key ���ڵ��keyֵ
         * @return {TreeNode}     ���ڵ����
         */
        getNode: function(key) {
            return this._wrapNode(this.dtree.getNodeByKey(key));
        },

        /**
         * ѡ��ָ���ڵ�
         * @param  {string} key  ���ڵ��keyֵ
         * @param  {boolean} flag true/false
         * @return {TreeNode}      ���ڵ����
         */
        selectNode: function(key, flag) {
            return this.getNode(key).select(flag);
        },

        /**
         * ʹ������
         * @return {[type]} [description]
         */
        enable: function() {
            this.dtree.enable();
            return this;
        },

        /**
         * ʹ��������
         * @return {[type]} [description]
         */
        disable: function() {
            this.dtree.disable();
            return this;
        },

        /**
         * ����tree������Դ
         * @param data {Object} JSON����
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
         * ��ȡ��������
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
         * ��ȡѡ�еĽڵ�
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
         * ��ȡ���ɼ��Ķ�����ڵ�.���е�һ���Ľڵ��Ǵ˸��ڵ���ӽڵ㡣
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
     * Tree Node�����ڵ����
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
        //@param {boolean}  reActive  �Ѽ���Ľڵ��Ƿ���Ҫ����onActivate�¼���Ĭ��true
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
         * ��ȡnode����
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
         * չ��
         * @param  {boolean} flag չ��/����
         * @return {[type]}      [description]
         */
        expand: function(flag) {
            this.dNode.expand(flag);
            return this;
        },

        /**
         * ɾ���ڵ�
         */
        remove: function() {
            this.dNode.remove();
        },

        removeChildren: function(){
            this.dNode.removeChildren();
            return this;
        },

        /**
         * ѡ��ĳ�ڵ�
         * @param  {boolean} flag ѡ��/��ѡ��
         * @return {Node}    ��ǰ����
         */
        select: function(flag) {
            this.dNode.select(flag);
            return this;
        },

        /**
         * �л�ѡ��״̬
         * @return {[type]} [description]
         */
        toggleSelect: function() {
            this.dNode.toggleSelect();
            return this;
        },

        /**
         * ��ӽڵ�
         * @param {object} data json����
         * @param {Node} beforeNode [��ѡ]���ָ���˽ڵ�,����뵽�˽ڵ�ǰ��.
         */
        addChild: function(data, beforeNode) {
            var node = this.dNode.addChild(data, beforeNode && beforeNode.dNode);
            return this._wrapNode(node);
        },

        /**
         * ���ýڵ����
         * @param {string} title �±���
         */
        setTitle: function(title) {
            return this.dNode.setTitle(title);
        },

        /**
         * ���ýڵ���ʽ
         * @param {string} str �ڵ���ʽ
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
         * ǰһ��
         * @return {Node} [description]
         */
        prev: function() {
            var node = this.dNode.getPrevSibling();
            return node && this._wrapNode(node);
        },

        /**
         * ��һ���ڵ�
         * @return {Node} [description]
         */
        next: function() {
            var node = this.dNode.getNextSibling();
            return node && this._wrapNode(node);
        },

        /**
         * ��һ������
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
         * ���һ��С��
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
         * ��ȡ�����ӽڵ�
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
         * ��ȡ���ڵ�
         * @return {[type]} [description]
         */
        parent: function() {
            var node = this.dNode.getParent();
            return node && this._wrapNode(node);
        },

        /**
         * ���ýڵ�����
         * 1. set(name, value);
         * 2. set(obj); objΪ��ֵ����
         * @return {Node} ��ǰ�ڵ����
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
         * չ���˽ڵ����ظ��ڵ㣬��ʹ�ýڵ�ɼ������������˽ڵ�
         * @return {[type]} [description]
         */
        focus: function() {
            this.dNode.focus();
            return this;
        },

        /**
         * �Ƿ�����ӽڵ�
         * @return {Boolean} [description]
         */
        hasChild: function() {
            return this.dNode.hasChildren();
        },

        /**
         * �Ƿ�otherNode��ֱ���ӽڵ�
         * @return {Boolean} [description]
         */
        isChildOf: function(otherNode) {
            return this.dNode.isChildOf(otherNode.dNode);
        },

        /**
         * �Ƿ�otherNode�ĺ���ڵ�
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
     * comtop.UI.Tree.Node  ���ڵ����.
     * @type {[type]}
     */
    comtop.UI.Tree.Node = Node;


    ////////////////////////////////////////////////
    //
    //   Tools һЩ���߷���
    //
    ////////////////////////////////////////////////

    /**
     * ����ĸ��дq
     * @param  {string} word ����
     * @return {string}      ת����ĵ���
     */
    function upper(word) {
        return word.replace(/(^|\s+)\w/g, function(letter) {
            return letter.toUpperCase();
        });
    }

    /**
     * �ݹ�����ͼ��
     * @param {Array<object>} children [description]
     * @param {string} icon     ͼƬ��url
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