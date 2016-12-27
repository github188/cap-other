css.load(webPath + '/top/workbench/component/sidebar/css/sidebar.css');
define(['underscore', 'text!' + webPath + '/top/workbench/component/sidebar/template/sidebar.html','autoIframe'], function( _, template) {
    var SideBar = function(option) {
        if (!option || !option.model || !option.template || !option.context) {
            //console.log('��ർ��û�г�ʼ�����ݣ�');
            return;
        }
        $.extend(this, option);
        //��ʼ��dom�ṹ
        this.context = $(this.context);
        var sideBarHtml = _.template($(template).filter('#sidebar-tmp').html(), {
            title : this.title||'',
            toggle : this.toggle,
            width : this.width,
            iframe : this.iframe,
            frameName:this.frameName,
            margin : this.margin,
            search : this.search
        });
        this.context.html(sideBarHtml);
        this.side = $(this.side, this.context);
        this.main = $(this.main, this.context);
        //��ʼ��,�¼�����
        this.iniEvent();
    };
    SideBar.prototype = {
        //��Ⱦ������
        context : 'body',
        //��������ͷ
        title : '',
        //�������
        width : 200,
        //������Ŀ��
        minWidth : 50,
        //������˵������
        subMenuMaxWidth:700,
        //������˵����߶�
        subMenuMaxHeight:600,
        //������˵���С�߶�
        subMenuMinHeight:400,
        //�Ƿ������
        toggle : false,
        //����ѡ����
        side : '.side',
        //ҳ���������ѡ����
        main : '.main',
        //�Ƿ���iframe�д�
        iframe : false,
        //frame���ƺ�id
        frameName:'sideFrame',
        //frame�߶��Ƿ�����Ӧ
        iframeAutoHeight: true,
        //������ҳ��֮����
        margin : 10,
        //��Ⱦ�����ݶ���
        model : [],
        //�Ƿ�֧�ֲ�ѯ
        search:false,
        //���ݶ�������,��Ҫ���ڲ�ѯ����
        primaryKey:null,
        iframeMinHeight:function(){
            return 'auto';
        },
        //�����б�
        filterList:function(searchValue){
            var self = this;
            for(var i =0;i<self.model.length;i++){
                var isIn = self.filter(self.model[i],searchValue);
                var li = $('#' + self.model[i][self.primaryKey]);
                if(isIn){
                    li.show();
                }else{
                    li.hide();
                }
            }
        },
        //���˵�������,����false����
        filter:function(data,searchValue){
            return true;
        },
        //�Ƿ�Ĭ�ϼ��ص�����
        isDefaultData : function(data, index) {
            if (index == 0) {
                return true;
            }
            return false;
        },
        //ģ��
        template : function() {
            return '';
        },
        //�Ӳ˵�ģ��
        subTemplate : function(){
          return '';  
        },
        click : function(data, el) {//��ർ������¼�,Ĭ����ֹ�¼�ð��
            var url = $(el).data('url');
            if (url) {
                this.main.load(url);
            }
            return false;
        },
        subClick : function(data, el) {//�����˵�����¼�,Ĭ����ֹ�¼�ð��
            var url = $(el).data('url');
            if (url) {
                this.main.load(url);
            }
            return false;
        },
        formatUrl:function(url){
            if(!url){
                return '';
            }
            try{
            	//�����޷�����Ķ����⣨��������ΪʲôҪ�����أ�û�����б���ĵط�������catch����ɣ�
                url = decodeURIComponent(url);
            }catch(e){
            	
            }
            if(url.indexOf('http')==0){
                return url;
            }
            if(url.indexOf('/')!=0){//��'/'��ͷ
               url = '/' + url; 
            }
            if(url.indexOf(webPath)==0){
                return url;
            }
            return webPath + url;
        },
        //�����¼�
        iniEvent : function() {
            var self = this;
            if(self.search){
                //�����¼�
                $('.search').bind('keypress',function(e){
                    if(e.which==13){
                        var searchValue = $.trim($(this).val());
                        self.filterList(searchValue);
                    }
                }).bind('blur',function(){
                    var $this = $(this);
                    var searchValue = $.trim($this.val());
                    if(!searchValue){
                        $this.addClass('empty').val($this.attr('empty_text'));
                    }
                    self.filterList(searchValue);
                }).bind('focus',function(){
                    var $this = $(this);
                    if($this.hasClass('empty')){
                        $(this).removeClass('empty').val('');
                    }
                });
            }
            //�����˵�����¼�
            $(self.side).off('click', '.sub-menu a').on('click', '.sub-menu a', function(e) {
                e.preventDefault();
                //e.stopPropagation();
                var el = $(this);
                var li = el.parents('li');
                li.siblings().removeClass('active');
                li.addClass('active');
                var data = li.data('bar-data');
                return self.subClick(data, this);
            });
            
            //��ർ���¼�����
            $(self.side).off('click', '.side-menu li > a').on('click', '.side-menu li > a', function(e) {
                e.preventDefault();
                //e.stopPropagation();
                var el = $(this);
                var li = el.parents('li');
                if(li.children('.sub-menu').length == 0){
                    li.siblings().removeClass('active');
                    li.addClass('active');
                }
                var data = li.data('bar-data');
                return self.click(data, this);
            });
            //��ർ�����л�Ч��
            $(self.side).off('click', '.toggle-btn').on('click', '.toggle-btn', function(e) {
                e.preventDefault();
                e.stopPropagation();
                var side = self.side;
                var main = self.main;
                var width = self.width;
                var margin = self.margin;
                if (!side.parent().hasClass('min-sidebar')) {
                    width = self.minWidth;
                }
                //����Ԫ����Ϊ�����
                side.children().width(self.width);
                //��sidebar��Ϊ���
                side.parent().removeClass('min-sidebar');
                side.animate({
                    width : width
                }, function() {
                    if (width == self.minWidth) {
                        side.parent().addClass('min-sidebar');
                    }
                    side.children().width('auto');
                    main.css('margin-left', width + margin);
                });
                main.animate({
                    'margin-left' : width + margin
                }, function() {
                    main.css('margin-left', width + margin);
                });
            });
            //hoverЧ��
            $(self.side).off('mouseenter', '.side-menu li').on('mouseenter', '.side-menu li', function(e) {
                e.preventDefault();
                e.stopPropagation();
                var el = $(this);
                el.children('a').addClass('menu-hove');
                var subMenu = el.children('.sub-menu');
                if(subMenu.length > 0){//����sub menu �Ŀ�ߺ�λ��
                    var width = Math.min(self.main.width(),self.subMenuMaxWidth);
                    //���¸�����10px����
                    var margin = 10;
                    var winHeight = $(window).height() - margin*2;
                    var maxHeight = Math.min(winHeight,self.subMenuMaxHeight);
                    var minHeight = Math.min(winHeight,self.subMenuMinHeight);
                    el.siblings().children('.sub-menu').hide();
                    subMenu.css({width : width,'max-height':maxHeight,'min-height':minHeight}).show();
                    
                    var top = 0;
                    var pos = el.offset();
                    var topToWin = pos.top - $(window).scrollTop();
                    if(topToWin < 0){
                        top = Math.abs(topToWin) + margin;
                    }else{
                        top = Math.min(winHeight - topToWin - subMenu.height() + margin,0);
                    }
                    subMenu.css({top:top});
                }
            });
            //hoverЧ��
            $(self.side).off('mouseleave', '.side-menu li').on('mouseleave', '.side-menu li', function(e) {
                e.preventDefault();
                e.stopPropagation();
                var el = $(this);
                el.children('.sub-menu').hide();
                el.children('a').removeClass('menu-hove');
            });

            //���ifame�¼�
            if (self.iframe) {
                //����load������Ϊiframe�м���
            	var iframeAutoHeight = self.iframeAutoHeight;
                self.main.load = function(url) {
                    $('iframe', self.main).attr('src', self.formatUrl(url));
                };
                function iframeMinHeight(){
                    return self.iframeMinHeight.call(self);
                }
                if(iframeAutoHeight){
                	$('iframe', self.main).autoFrameHeight('',iframeMinHeight);
                }
            }
        },
        //��Ⱦ
        render : function() {
            var self = this;
            var optList = $('#opt-list', self.side);
            var index = 0;
            var defaultEl = null;
            $(self.model).each(function() {
                var tmp = self.template(this);
                if (tmp) {
                    var li = $('<li></li>').html(tmp).data('bar-data', this);
                    if(self.primaryKey){
                        li.attr('id',this[self.primaryKey]);
                    }
                    if (index == 0) {
                        li.addClass('first-child');
                    }
                    optList.append(li);
                    if (self.isDefaultData(this, index++)) {
                        defaultEl = li.children('a');
                    }
                    
                    var subTmp = self.subTemplate(this);
                    if(subTmp){
                        li.append(subTmp);
                    }
                }
            });
            //Ĭ�ϼ���
            if (defaultEl) {
                defaultEl.click();
            }
            
            $(window).resize();
            return self;
        }
    };
    return SideBar;
});
