/**
 * ע��ʽDialog
 * ���ڣ�CUIV4.1 �� CUIV4.2��
 * v0.1.0
 * �����о����� �ֳ�Ⱥ 2014-5-8
 */
;(function($){
    cui.extend = cui.extend || {};

    var _emWin = window.top;

    /**
     * ��չ���
     * @param options {Object} Dialog������ò���
     * @param emWin {Window} Ŀ�괰��
     * @returns {emDialog}
     */
    cui.extend.emDialog = function(options, emWin){
        _emWin = emWin || _emWin;
        //���Dialog�͵�ǰ����
        _emWin.cuiEMDialog = _emWin.cuiEMDialog || {
            dialogs: {},
            wins: {}
        };
        options = $.extend({
            id: 'emDialog_' + new Date().getTime()
        }, options);

        if(_emWin.cuiEMDialog.dialogs[options.id]){
            return _emWin.cuiEMDialog.dialogs[options.id];
        }

        //����Dialog��������Ӧ��Dialog����͵�ǰ���ڶ����ŵ�Ŀ��ҳ�������
        _emWin.cuiEMDialog.dialogs[options.id] = _emWin.cui.dialog(options);
        _emWin.cuiEMDialog.wins[options.id] = window;


        //����dialog
        return _emWin.cuiEMDialog.dialogs[options.id];
    };

    //��������cuiEMDialogδ���壬��dialogsΪ�գ����ʾ��window Ϊ ʼwindow
    if(!_emWin.cuiEMDialog || isEmptyObject(_emWin.cuiEMDialog.dialogs)){
    	window._emDialogTopMark = true;
    }

    //ҳ��ж��ʱ������ҳ������dialog��win
    $(window).bind('unload.emDialog', function(){
        if(window._emDialogTopMark){
            if(_emWin.cuiEMDialog && _emWin.cuiEMDialog.dialogs){
                for(var i in _emWin.cuiEMDialog.dialogs){
                    if(_emWin && _emWin.cuiEMDialog && _emWin.cuiEMDialog.dialogs){
                        _emWin.cuiEMDialog.dialogs[i].destroy();
                        delete _emWin.cuiEMDialog.dialogs[i];
                        delete _emWin.cuiEMDialog.wins[i];
                    }
                }
            }
        }
    });

    function isEmptyObject( obj ) {
        for ( var name in obj ) {
            return false;
        }
        return true;
    }
})(comtop.cQuery);


;(function($, C){
	/**������������ֵ����*/
	//�ϼ�ͷ����38
	var KEYCODE_ARROW_UP=38;
	//�¼�ͷ����40
	var KEYCODE_ARROW_DOWN=40;
	var KEYCODE_ARROW_LEFT=37;
	//�س�������13
	var KEYCODE_ENTRY=13;
	//�˸������8
	var KEYCODE_BACKSPACE=8;
	
	// ������<a>��ǩ��idǰ׺���������Ĳ��ű�ǩ��ʽΪ��<a><span></span><span></span></a>
	var prefixOfQueryA = "a_query_";
	//���ٲ�ѯ�����ָ�����ʽ 
	var lineClassName="cutoff_line";
	var prefixOfSearchDiv="searchDiv_",
		prefixOfQueryDataAreaDiv="queryDataArea_",
		prefixOfMoreDataDiv="moreData_";
	
    /**
     * @class Choose
     * @extends C.UI.Base
     * ��֯��Աѡ�����<br>
     *
     * @author ������
     * @version 1.0
     * @history 2012-10-17 ������ �½�
     * @demo doc/chooseDoc.html
     */
    C.UI.Choose = C.UI.Base.extend({
        options: {
            id: '',
            value: [],//ѡ������ݶ��󼯺ϣ�[{id:xx,name:xx,isOther:xx},{},...]
            width: '',//���
            height: '',//�߶�
            chooseMode: 0,//ѡ��ģʽ��1��ѡ��0��ѡ��N>1���ѡ��N��
            readonly: false,//�Ƿ�ֻ��
            isAllowOther: false,//�Ƿ����������ⲿ����
            callback: null,//�ص�����
            orgStructureId: '',//��֯�ṹID
            rootId: '',//���ڵ�ID
            delCallback: null,//ɾ��
            openCallback:null,//��ѡ�񴰿�ǰ�Ļص����ص���Ҫ����true |false  ֻ�з���Ϊtrue �Ŵ򿪡����򲻴�
            textmode: false,//�ı�ģʽ
            isSearch: true,//�Ƿ�֧�ֿ���ƥ���ѯ
            _defaultInputWidth:20, //Ĭ�ϵ�input����
            defaultOrgId: '',//��ʼĬ����֯�ڵ�ID�������rootId��ʱ����defaultOrgIdΪ���ڵ�
            maxLength:-1,//input�������������볤��,��isAllowOtherΪtrueʱ������
            canSelect:true,//�Ƿ�����ѡ�����,��ָ��Ϊfalseʱ��Ĭ�Ͽ���isAllowOther
            byByte: true,             //��󳤶ȼ��㷽ʽ��true���ֽڼ��㣬false���ַ�����
            formName:'',//�������ύ������
            idName:'', //���е�id��������
            valueName:'',//���е�value��������
            opts:'',//��������չ�ֶ�
            winType:"dialog"//�������ڵ����� dialog|window Ĭ��Ϊdialog
        },
        tipPosition: '.choose_box_wrap',
        pageSize:10,
        pageNo:1,
        fastQueryFunc:null,
 		tempNoDataFunc:null,
        
        /**
         * ��ʼ�����Է���
         */
        _init:function(cusOptions){
        	if(!this.options.id){
        		this.options.id = 'Choose_' + C.guid();
        	}
        	this.options.el.attr('id', this.options.id);
        	//��װ��ѯ���id
        	if(this.options.isSearch){
        		this.searchDivId=prefixOfSearchDiv+this.options.id,
        		this.queryDataAreaDivId=prefixOfQueryDataAreaDiv+this.options.id,
        		this.moreDataDivId=prefixOfMoreDataDiv+this.options.id;
        	}
        	if(!this.options.width){
        		this.options.width = '200px';
        	}
            if (typeof this.options.width === "string" && !/%/.test(this.options.width)) {
	        	//ȥ��px
	        	this.options.width=this.options.width.substring(0,this.options.width.length-2);
	        	var iWidth = parseInt(this.options.width,10)-2;//��ȥ���ߵ�ʵ�߿��
	        	this.options.width = iWidth+"px";
            }
        	this.options.el.attr('width', this.options.width);
        	if(!this.options.height){
        		//�޸�Ĭ�ϸ߶�100% ʵ�ָ߶�����Ӧ
        		this.options.height = '100%';
        	}
        	if (typeof this.options.height === "string" && !/%/.test(this.options.height)) {
        		//ȥ��px
        		this.options.height=this.options.height.substring(0,this.options.height.length-2);
        		var iheight = parseInt(this.options.height,10)-2;//��ȥ���ߵ�ʵ�߿��
        		this.options.height = iheight+"px";
            }
        	this.options.el.attr('height', this.options.height);
        	this.$el = $("#"+this.options.id);
        	
//        	if(!this.options.canSelect){ //������ѡ��
//        		this.options.isAllowOther= true;
//        		this.options.isSearch= false;
//        	}
        	if(this.options.opts){
        		if (typeof this.options.opts === "string" && typeof window[this.options.opts] === "object") {
        			this.options.opts = window[this.options.opts];
        		}else{
        			this.options.opts = $.parseJSON(this.options.opts.replace(/\'/g, '\"'));
        		}
        	}
        	
        	//���������л�ȡֵ������value������
        	this._setValueFormHidden();
        },
        //���������е�ֵ�ŵ�value�С��Ա��ڳ�ʼ��ʱ����
        _setValueFormHidden:function(){
        	var opts = this.options;
        	var formEle;
        	if(opts.formName){
        		formEle =document.forms[opts.formName];
        	}
         	   //�ȸ���id����ѯ���Ҳ�����name����
     		var ids = this._getHiddenVal(formEle,opts.idName);
     		if(ids){
     			var idArray = ids.split(";");
 				//����Ѿ���������Ҫ��id/name������ȥ��̨��ѯ��ֻ����idʱȥ��̨��ѯ
         		var names = this._getHiddenVal(formEle,opts.valueName);
         		if(names){
         			var nameArray =names.split(";");
         			var codeArray = [];
         			if(opts.opts&&opts.opts.codeName){
         				//��չ����ʱ��ôд��
         				var codes = this._getHiddenVal(formEle,opts.opts.codeName);
         				if(codes){
         					codeArray = codes.split(";");
         				}
         			}
             		var selected = [];//��¼ѭ������id��ȥ���ظ�����
             		var data = [];
             		var jsonString= "";
             		for(var i=0;i<idArray.length;i++){
         				if($.inArray(idArray[i], selected)>-1){
         					//�Ѿ�������ģ�����
         					continue;
         				}
         				if(i>=nameArray.length){
         					//��������Ѿ�û���ˣ�������
         					break;
         				}
         				selected.push(idArray[i]);
         				jsonString ="{\"id\":\""+idArray[i]+"\",";
         				jsonString +="\"name\":\""+nameArray[i];
         				if(codeArray&&i<codeArray.length){
         					jsonString +="\",\"orgCode\":\""+codeArray[i]+"\"}";
         				}else{
         					jsonString +="\"}";
         				}
         				data.push($.parseJSON(jsonString)); 
             		}
             		this.options.value=data;
         			return;
         		}
         		//���ݴ��ݵ�id�Ӻ�̨��ȡѡ�������
     			var selected = this._loadValueFromDb(ids);
     			if(!selected){
     				selected = [];
     			}
     			this.options.value=selected;
     		}
        },
        /**
         * ��ȡָ���������ֵ��������id���ң����Ҳ���ʱ��name����
         * @param formEle ������
         * @param eleName ��ǩ��id/name
         * @return value
         * */
        _getHiddenVal:function(formEle,eleName){
        	var nameEle = $("#"+eleName);
     		var names = "";
     		if(nameEle.length==0&&formEle){
     			nameEle = formEle[eleName];
     			if(nameEle){
     				names = nameEle.value;
     			}
     		}else{
     			names=nameEle.val();
     		}
     		return names;
        },
        /**
         * ��ȡ���������е�ֵ
         * ���������е�ֵ��JSON�����ʽ����
         * */
        getFormData:function(){
        	var formEle,opts = this.options;
        	if(opts.formName){
        		formEle =document.forms[opts.formName];
        	}
         	//opts.valueName����Ҫ�Ǵ���\�����ַ�תjson�ᱨ�� ���� 2015��11��13�� //
            ////////////////////////////////////////////////////////////////////////
            var returnData = {};
            if(opts.idName){
                returnData[opts.idName] = this._getHiddenVal(formEle,opts.idName);
            }
            if(opts.valueName){
                returnData[opts.valueName] = this._getHiddenVal(formEle,opts.valueName);
            }
            if(opts.opts&&opts.opts.codeName){
                returnData[opts.opts.codeName] = this._getHiddenVal(formEle,opts.opts.codeName);
            }
            return returnData;
        },
        /**
         * ����ģʽ����������ģʽ�²��ٵ���_create()��
         * ��Base�е���
         */
        setTextMode: function(){
          this._createDom();
          //�����ı�ģʽ����ʽ
  		 this.__renderTextMode();
        },
        /**
         * ��Ⱦ�ı�ģʽ
         * */
        __renderTextMode:function(){
        	$('#'+this.options.id+'_choose_box').attr('class','cui_ext_textmode');
  			$('#'+this.options.id+'_open').hide();
    		$('#'+this.options.id+'_choose_input').hide();
    		this.options.el.attr("tip", '');
        },
        /**
         * ��ʼ��ģ�巽��
         */
        _create:function(){
        	var opts = this.options;
        	this._createDom();
        	if(this.options.readonly){
        		$('#'+this.options.id+'_open').hide();
        		$('#'+this.options.id+'_choose_input').hide();
        		$('#'+this.options.id+'_choose_box').attr('class','choose_box_readonly');
        	}
        	this._bindClickEvent();
        	if(opts.isAllowOther||opts.isSearch){
        		this._bindKeyEvent();
        		//����input�����
        		var input = $('#'+this.options.id+'_choose_input');
        		input.css("max-width",(input.parent(".choose_box").eq(0).width()-5));
        	}
        	if(opts.isSearch){
        		this._bindMouseEvent();
        	}
        },
        
        /**
         * �󶨵���¼�
         * */
        _bindClickEvent:function(){
        	var self = this,opts=this.options;
        	$("#"+this.options.id+"_choose_box").off().on("click.choose",function(e){ 
        		self._clickHandler(e);
        		return false;
        	});
        	 if(opts.canSelect){
	             $("#"+this.options.id+"_open").off().on("click.choose",function(e){ 
	             	self._aHandler(this);
	             	return false;
	             });
        	 }
        	 if(opts.isSearch){
        		 var $moreDataDiv = $("#"+this.moreDataDivId);
        		 $moreDataDiv.off().on("click.choose",function(){
        			 if($("#"+self.moreDataDivId).hasClass("more_data")){
        				 self._showMoreData();
        			 } 
        			 return false;
        		 });
        		 $moreDataDiv.on("mouseup",function(){
        			 self.hideAble=true; 
        		 }).on("mousedown",function(){
        			 self.hideAble=false;
        		 });
        	 }
        },
        /**
         * ������¼�
         * */
        _bindMouseEvent:function(){
        	var self = this;
        	var current_class = "current_select";
        	var queryDataArea= $("#"+this.queryDataAreaDivId);
        	queryDataArea.off().on("mouseover.choose",function(e){
        		if(self.pageX==e.pageX&&self.pageY==e.pageY){
        			//���û����������
        			return;
        		}
        		//����ʱ��¼���λ��
        		self.pageX = e.pageX;
        		self.pageY= e.pageY;
        		if(self.t){
        			clearTimeout(self.t);
        		}
        		delete self.t;
        		var $currObj =$(e.target).closest("a");
        		var $queryDataArea= $("#"+self.queryDataAreaDivId);
        		$queryDataArea.children().removeClass(current_class);//�������ʽ ��������̳�ͻ
        		$currObj.addClass(current_class);
        		self.__clearHover();
        	}).on("mouseout.choose",function(e){
        		//�뿪ʱ����¼λ��
        		if(self.pageX==e.pageX&&self.pageY==e.pageY){
        			//���û����������
        			return;
        		}
        		if(self.t){
        			clearTimeout(self.t);
        		}
        		self.t=setTimeout(function(){
	        		var $queryDataArea= $("#"+self.queryDataAreaDivId);
	    			$queryDataArea.children().removeClass(current_class);//�������ʽ ��������̳�ͻ
        		},200);
        	});
        	queryDataArea.on("mouseup",function(event){
        		self.hideAble=true;        		
        	}).on("mousedown",function(){
        		self.hideAble=false;
        	});
        	//������ʾ�㣬ѡ��ĳ��ֵ
        	queryDataArea.on("click.choose",function(e){
        		var queryDataArea= $("#"+this.queryDataAreaDivId);
    			self.hoverIndex =queryDataArea.children().index($(e.target).closest("a")) ;
    			self._selectRow();
    			return false;
        	});
        },
        
        /**
         * �����İ����¼�
         * @private
         */
        _bindKeyEvent: function() {
            var self = this,opts= this.options,
                keyCode;
            	
            var input = $("#"+this.options.id+"_choose_input");
            input.unbind("keydown.choose").bind("keydown.choose", function (event) {
                keyCode = event.keyCode;
                switch(keyCode) {
                	case KEYCODE_BACKSPACE:
	                	if(!$('#'+self.options.id+'_choose_input').val()){
	            			self._popData();
	            		};
	            		break;
                    case KEYCODE_ARROW_UP : //up
                        if (opts.isSearch&&self.__keyDownUPHandler) {
                            self.__keyDownUPHandler();
                        }
                        break;
                    case KEYCODE_ARROW_DOWN : //down
                        if (opts.isSearch&&self.__keyDownDownHandler) {
                            self.__keyDownDownHandler();
                        }
                        break;
                    case KEYCODE_ENTRY : //enter
                        if (self.__keyDownEnterHandler) {
                    		self.__keyDownEnterHandler();
                        }
                        break;
                }
            });
            if(self.options.isSearch){ //ֻ��������ѯ�Ű�
	           input.unbind("keyup.choose").bind("keyup.choose", function (event) {
	        		self._keyup(event);
	           });
            }
            input.bind("keyup.choose", function (event) {
      	   	  var actWidth =self._textWidth($(this));
      	   	  var width =$(this).width(); 
      	   	  if(actWidth>width){
      	   		$(this).width(actWidth);
      	   	  }
          });
           if(opts.isAllowOther&&opts.maxLength > -1){
               opts.byByte || input.attr('maxLength', opts.maxLength);
               input.on("propertychange.choose", function(e){
                   opts.byByte && self._textCounter();
               });
               this._textCounter();
           }
           
           input.focus(function(){
        	   var inInput = $("#"+self.options.id+"_choose_input");
           		if(!inInput.is(":hidden")){
           			var outer = $("#"+opts.id+"_choose_box");
           			outer.addClass('choose_input_focus');
           			//���ù�굽����
           			var value = inInput.val();
           			inInput.val(value);
           		}
           	  self.onValid();
           });
           input.blur(function(){ 
			   var outer = $("#"+opts.id+"_choose_box");
        	   outer.removeClass('choose_input_focus');
        	   self._blurHandler();
           });
        },
        
        /**
         * ��̬�ı�input���С
         * @param which input ����
         * */
        _textWidth:function(which){
        	var text = which.val(),text=$("<div style='display:none'/>").text(text).html(),font =which.css("font");
        	var sensor = $('<pre>'+ text +'</pre>').css({display: 'none'}); 
            $('body').append(sensor); 
            sensor.css("font",font)
            var width = sensor.width();
            sensor.remove(); 
            return width;
        },
        
        /**
         * �������볤��
         * @return {Boolean}
         * @private
         */
        _textCounter: function() {
            var opts = this.options;
            var input = $("#"+this.options.id+"_choose_input");
            var value= input.val().toString();
            if (opts.isAllowOther&&opts.maxLength > -1) {
                var currentLen =  this._getStringLength(value);
                if (currentLen > opts.maxLength) {
                    input.val(this._interceptString(value, opts.maxLength));
                } else {
                    return false;
                }
            }
            return false;
        },
        /**
         * �����ַ�������
         * @param value {String} �ַ���
         * @returns {Number|*}
         * @private
         */
        _getStringLength: function(value){
            var opts = this.options;
            return opts.byByte ? C.String.getBytesLength(value) : value.length;
        },
        /**
         * ��ȡ�ַ���
         * @param value {String} �ַ���
         * @param length {Number} ��ȡ����
         * @returns {*}
         * @private
         */
        _interceptString: function(value, length){
            var opts = this.options;
            return opts.byByte ? C.String.intercept(value, length) : C.String.interceptString(value, length);
        },
        /**
         * ��������ѡ������������
         * */
        _createHiddenInput:function(){
        	var opts = this.options;
        	var formEle = null;
        	 //������
            if(opts.formName){
            	formEle = document.forms[opts.formName];
        	}
        	var hiddenInput= "";
        	hiddenInput += this._createHiddens(formEle,opts.idName);
        	hiddenInput += this._createHiddens(formEle,opts.valueName);
        	var codeEle =null;
        	if(opts.opts&&opts.opts.codeName){
        		hiddenInput += this._createHiddens(formEle,opts.opts.codeName);
        	}
        	if(hiddenInput){
        		if(formEle&&typeof(formEle)!== 'undefined' ){
        			var $form = $(formEle)
        			$form.append(hiddenInput);
        		}else{
        			this.$el.before(hiddenInput);
        		}
        	}
        },
        
        /**
         * ����ָ�����Ƶ�������
         * @param formEle ������
         * @param eleName Ԫ������
         * ����html����
         * */
        _createHiddens:function(formEle,eleName){
        	var sHtml = "";
        	if(eleName){
        		var $eleE = $("#"+eleName);
        		var bExist = false;
        		if($eleE.length>0){
        			bExist = true;
        		}
        		if(formEle&&formEle[eleName]){
        			bExist = true;
        		}
        		if(!bExist){
        			sHtml = '<input type="hidden" name="'+eleName+'" id="'+eleName+'"/>';
        		}
        	}
        	return sHtml;
        },
        /**
         * ������ǩ��dom
         * ����DOM����Root������
         * @private
         */
        _createDom: function () {
            var opts = this.options,
                $el = this.$el,
                inputHtml,chooseData;
            	chooseData= [];
        	if(!$.isArray(this.options.value)){
        		this.options.value=[this.options.value]; 
      		}
        	if(opts.chooseMode==1&&this.options.value.length>1){
        		//��ѡʱ��������˶����ȡ��һ��
        		this.options.value=[this.options.value[0]];
        	}
            	
       		chooseData.push(this._buildSelect());
            if(!this.options.textmode&&(this.options.isAllowOther||this.options.isSearch)){
            	chooseData.push('<input id="');
            	chooseData.push(this.options.id+'_choose_input"  class="choose_input" ');
            	if(opts.chooseMode==1&&this.options.value.length==1){
            		chooseData.push(" style='display:none;' ");
            	}
            	chooseData.push(' type="text"/>');
            }
            if(!this.options.textmode&&this.options.isSearch){  
            	var searchDiv=[];
        		searchDiv.push('<div id="'+this.searchDivId+ '" class="search_div">');
        		searchDiv.push('<div id="'+this.queryDataAreaDivId+'" class="queryList" ></div>');
        		//��������...
        		searchDiv.push('<div id="'+this.moreDataDivId+'" class="more_data"><a href="#" hidefocus="true">\u66f4\u591a\u6570\u636e...</a></div>');
        		searchDiv.push('</div>');
        		$('body').append(searchDiv.join(""));
            } 
            
            //������
            this._createHiddenInput();
            //��ǩ��ʼ����ʱ��ȥ�����������������ֵ����䣬������������ֵ��Ҫͨ��setValue����������Ϊ��������߼����ʲ��ᵼ�½��˼�֮ǰ��ֵ�����
            //this._setHiddenElement(this.options.value);
            var varOpenWin = '<a id="'+this.options.id+'_open" flag="openWin" href="#" class="'+(this.options.uitype==="ChooseOrg"?"icon_org":"icon_user")+'" ></a>';
            if(!this.options.canSelect){
            	varOpenWin = "";
            }
            
            //Ԫ�ؽṹ
            inputHtml = [
                         '<div class="choose_box_wrap" style="width:',
                          this.options.width,'">',
                          '<div id="',
                          this.options.id,'_choose_box" class="choose_box" style="height:',
                          this.options.height,';width: 100%;">',
                          chooseData.join(""),
						'</div>',
						//searchDiv.join(""),
						'</div>',
						varOpenWin
            ];
            $el.html(inputHtml.join(""));
            
            //������ʽ
            if(chooseData.length){
            	this._setMaxWidth($(".block_cross_other",this.options.el));
            	this._setMaxWidth($(".block_cross",this.options.el));
            }
        },
        
        /**���������
         * */
        _setMaxWidth:function(whichs){
        	if(whichs&&whichs.length){
        		var maxWidth = whichs.eq(0).parent(".choose_box").width()-37;
        		for(var i=0;i<whichs.length;i++){
        			whichs.eq(i).css("max-width",maxWidth);
        		}
        	}
        },
        /**ѡ��󣬽�ѡ���ֵд����������
         * @param formEle ��Ԫ��
         * @param eleName ������Ԫ������ 
         * @param value Ҫ���õ�ֵ
         * */
        _setValueToHidden:function(formEle,eleName,value){
        	if(eleName){
        		var $ele=$("#"+eleName);
        		if($ele.length==0){
        			if(formEle&&formEle[eleName]){
        				$ele = $(formEle[eleName]);
        			}
        		}
        		if($ele.length==1){
        			$ele.val(value);
        		}
        	}
        },
        /**
         * ���ݱ���������Ԫ��
         * dataΪ��ʱ������������ֵ
         */
        _setHiddenElement:function(data){
        	var opts = this.options;
        	if(opts.idName){
        		//����idName�����жϣ����δָ�����򲻴���
        		var ids=[],names=[],codes=[];
        		var nameKey = "name";
        		if(opts.uitype==='ChooseOrg'&&opts.showLevel!=-1&&opts.isFullName){
        			//��֯��ǩ��ָ��fullName
        			nameKey="fullName";
        		}
        		for(var i=0,j=data.length;i<j;i++){
        			ids.push(data[i]["id"]);
        			names.push(data[i][nameKey]);
        			codes.push(data[i]["orgCode"]);
        		}
        		
        		var formElement ;
        		if(opts.formName){
        			formElement= document.forms[opts.formName];
        		}
        		
        		this._setValueToHidden(formElement,opts.idName,ids.join(";"));
        		this._setValueToHidden(formElement,opts.valueName,names.join(";"));
        		this._setValueToHidden(formElement,opts.opts.codeName,codes.join(";"));
        	}
        },
        
        /**
         * ȫ�ֵ������
         * @param {Event} e 
         */
        _clickHandler:function(e){
        	var target = e.target;
    		switch(target.nodeName){
    		case 'A':
    			this._aHandler(target);
    			return false;
    			break;
    		case 'SPAN':
    			break;
    		case 'DIV':
    			this._divHandler(target);
    			break;
    		}
        },
        
        /**
         * �����ϼ�
         * @private
         */
        __keyDownUPHandler: function () {
        	var className = this.options.uitype==='ChooseOrg'?".dept_query":".user_query";
        	var currentClassName = "current_select";
            var queryDataArea = $("#"+this.queryDataAreaDivId),
            	len = queryDataArea.find(className).length,
                list, hoverIndex;
            if (len) {
                list = queryDataArea.find(className);
                hoverIndex = this.hoverIndex;
                if (typeof hoverIndex === "undefined") {
                    //��չ��״̬
                    hoverIndex = len - 1;
                    list.removeClass(currentClassName);
                    list.eq(hoverIndex).addClass(currentClassName);
                } else {
                	 //�Ƴ�ǰһ������
                    list.eq(hoverIndex || 0).removeClass(currentClassName);
                    //ʵ��ѭ��
                    if (--hoverIndex === -1) {
                        hoverIndex = len - 1;
                    }
                    list.eq(hoverIndex).addClass(currentClassName);
                }
                this.hoverIndex = hoverIndex;
                this.__scrollHoverPosition(hoverIndex);
            }
        },
        /**
         * �����¼�
         * @private
         */
        __keyDownDownHandler: function () {
        	var className = this.options.uitype==='ChooseOrg'?".dept_query":".user_query";
        	var currentClassName = "current_select";
            var queryDataArea = $("#"+this.queryDataAreaDivId),
                len = queryDataArea.find(className).length,
                list,
                hoverIndex;
            if (len) {
                list =queryDataArea.find(className);
                hoverIndex = this.hoverIndex;
                if (typeof hoverIndex === "undefined") {
                    //��չ��״̬
                    hoverIndex = 0;
                    list.removeClass(currentClassName);
                    list.eq(hoverIndex).addClass(currentClassName);
                } else {
                    //�Ƴ�ǰһ������
                    list.eq(hoverIndex || 0).removeClass(currentClassName);
                    //ʵ��ѭ��
                    if (len === ++hoverIndex) {
                        hoverIndex = 0;
                    }
                    list.eq(hoverIndex).addClass(currentClassName);
                }
                this.hoverIndex = hoverIndex;
                this.__scrollHoverPosition(hoverIndex);
            }
        },
        
        /**
         * �������
         * @private
         */
        __clearHover: function () {
            var hoverIndex = this.hoverIndex;
            if (typeof hoverIndex !== "undefined") {
            	var className = this.options.uitype==='ChooseOrg'?".dept_query":".user_query";
            	var currentClassName ="current_select";
                var queryDataArea = $("#"+this.queryDataAreaDivId),
                    list;
                list =queryDataArea.find(className);
                list.eq(hoverIndex).removeClass(currentClassName);
                delete this.hoverIndex;
            }
        },
        
        /**
         * DIV��ǩ�������
         * @param {HTMLElement} tg 
         */
        _divHandler:function(tg){
        	$('#'+this.options.id+'_choose_input').focus();
        },
    	/**
    	 * ��ȡ��Աѡ���ǩ��������ϵ��/��֯ѡ�񵯳����ڵĳߴ�
    	 * �������ھ�����ʾ
    	 * @returns {width,height,offsetLeft,offsetTop}
    	 * */
    	 _getWindowSize:function(){
    		var chooseMode= this.options.chooseMode;
    		var winWidth;//���������
    		var winHeight = 536;//�������߶�
    		var offsetLeft,offsetTop;//������λ��
    		if(comtop.Browser.notIE){//�ȸ������
    			winWidth = chooseMode==1?342:505;
    		}else{
    			winWidth = chooseMode==1?335:505;
    		}
    		//��ѡ���ֵ����󣬿������
    		var isQM = window.top.comtop.Browser.isQM;
    		var isIE = window.top.comtop.Browser.isIE;
    		var isLtIE8 = false;//    		window.top.comtop.Browser.isIE6||window.top.comtop.Browser.isIE7;
    		if(isIE){
	    		var userAgent = window.top.navigator.userAgent.toLowerCase();
	    		if(userAgent.indexOf("msie 8.0")==-1&&(userAgent.indexOf("msie 7.0")>-1||userAgent.indexOf("msie 6.0")>-1)){
	    			isLtIE8 = true;
	    		}
    		}
    		if(chooseMode!=1){
    			winWidth = winWidth+30;
    			if(isIE&&(isQM||isLtIE8)){
    				winWidth += 18;
    			}
    		}else{
    			winWidth=winWidth-28;
    			if(isIE&&(isQM||isLtIE8)){
    				winWidth += 15;
    			}
    		}
    		
    		offsetLeft = (window.screen.width-20-winWidth)/2;
    		offsetTop = (window.screen.height-30-winHeight)/2;
    		return {"width":winWidth,"height":winHeight,"offsetLeft":offsetLeft,"offsetTop":offsetTop};
    	},

        /**
         * a��ǩ�������
         * @param {HTMLElement} tg 
         */
        _aHandler:function(tg){
        	var $tg = $(tg);
    		if($tg.attr('flag') == 'del'){
    			this._deleteData($tg.parent().attr('id'));
    		}else{
    			if(this.options.openCallback){
    				var bOpen = this.options.openCallback(this.options.id);
    				if(!bOpen){
    					return ;
    				}
    			}
    			
    			var url;
    			url = webPath + "/top/sys/usermanagement/orgusertag/ChoosePage.jsp?id=" + this.options.id+"&chooseType="+this.options.uitype+"&chooseMode="+this.options.chooseMode+"&winType="+this.options.winType;
    			//"ѡ����Ա":"ѡ����֯"
    			var winTitle =this.options.uitype==='ChooseUser'?"\u9009\u62e9\u4eba\u5458":"\u9009\u62e9\u7ec4\u7ec7";
    			var winSize = this._getWindowSize();
    			if(this.options.winType==="window"){
    				window.open(url,"ChoosePage","left="+winSize.offsetLeft+",top="+winSize.offsetTop+",width="+winSize.width+",height="+winSize.height+",menu=no,toolbar=no,resizable=no,scrollbars=no");
    			}else{
    				var dialog ;
    				if(window.top.cuiEMDialog&&window.top.cuiEMDialog.dialogs){
    					dialog = window.top.cuiEMDialog.dialogs["topdialog_"+this.options.id];
    				}
    				if(!dialog){
    					dialog =cui.extend.emDialog({
    						id:"topdialog_"+this.options.id,
    						title:winTitle,
    						//Ϊ���޸���editablegrid���ʱ��ȱ�ݣ�ȥ���˹���������
    						modal:true,
    						src:url,
    						width:winSize.width,
    						height:winSize.height
    					});
    				}else{
    					dialog.reload(url);
    				}
    				dialog.show();
    			}
    		}
        },
        /**
         * ɾ������
         * @param {����} id 
         */
        _deleteData:function(id){
            //��ѡ�������
        	var selected = this.options.value;
        	var data;
        	//�Ѵ�������id��ȥ������ϵĵ�ǰ��ǩid
        	id= id.replace(this.options.id,"")
    		for(var i=0;i<selected.length;++i){
    			if(selected[i].id==id){
    				 //�Ƴ�ɾ�������ݲ����汻ɾ��������
    				data = selected.splice(i,1);
    			}
    		}

    		this.__setValue(selected);
    		if(this.options.delCallback){
				this.options.delCallback(data,this.options.id);
			}
    	},
    	/**
         * �ж������Ƿ��ѱ�ѡ��
         * @param {����} id 
         */
    	_isSelected:function(id){
    		var selected = this.options.value;
    		for(var i=0;i<selected.length;++i){
    			if(selected[i].id==id){
    				return true;
    			}
    		}
    		return false;
    	},
    	/**
         * ׷��ѡ������
         * @param {����} data
         */
    	_appendData:function(data){
    		if(this.options.chooseMode>0&&this.options.value.length==this.options.chooseMode){
    			if(this.options.uitype == 'user' || this.options.uitype == 'ChooseUser'){//cui.alert('���ѡ��'+this.options.chooseMode+'����Ա');
    				cui.alert('\u6700\u591A\u9009\u62E9' + this.options.chooseMode + '\u4e2a\u4eba\u5458');
    			} else{ //cui.alert('���ѡ��'+this.options.chooseMode+'����֯');
    				cui.alert('\u6700\u591A\u9009\u62E9' + this.options.chooseMode + '\u4e2a\u7ec4\u7ec7');
    			}
    			return;
    		}
    		if(!this._isSelected(data.id)){
    			var dataVo = data;
    			if(!data.isOther){
    				var dbVo = this._loadValueFromDb(data.id);
    				dataVo = dbVo[0];
    			}
    			this.options.value.push(dataVo);
    			this.__setValue(this.options.value);
    			if(this.options.callback){
    				this.options.callback(this.options.value,this.options.id);
    			}
    		}
    	},
    	/**
         * ȥ��ѡ������
         */
    	_popData:function(){
			var data = this.options.value[this.options.value.length-1];
			if(data){
				var id = data.id;
				this._deleteData(id);
			}
    	},
    	
    	/**
    	 * ����ѡ�������ֵ
    	 * @param selected ѡ�е����� ������Ϊ�����ݿ��ѯ������ݡ�������Ҫ���ص������ֶ�
    	 * */
    	__setValue:function(data,isInit){

    		if(!data){
    			data = [];
    		}
    		if(!$.isArray(data)){
    			  data=[data]; 
    		}
    		data = $.extend(true, [], data);
    		//�ж��Ƿ񳬹����õ��������,����ʱ���ص�������������
        	if(this.options.chooseMode>0&&data.length>=this.options.chooseMode){
        		data=data.slice(0,this.options.chooseMode);
    		}
    		this.options.value = data;
    		var len = this.options.value.length;
    		
    		//�����֮ǰ��
    		$(".block_cross_other",this.options.el).remove();
    		$(".block_cross",this.options.el).remove();
    		
    		if(this.options.textmode){
    			var chooseBox = $("#"+this.options.id+"_choose_box");
    			var html=[];
    			for(var i=0;i<len;i++){
    				if(!this.options.value[i].title){
    					this.options.value[i].title = this.options.value[i].name;
            		}
    				html.push(this.options.value[i].title);
    			}
    			chooseBox.html(html.join(";"));
    			this.__renderTextMode();
    		}else if(this.options.isSearch||this.options.isAllowOther){
    			var chooseInput = $("#"+this.options.id+"_choose_input",this.options.el);
    			var html=this._buildSelect();
    			chooseInput.before(html);
    			chooseInput.val("");
    			if(this.options.chooseMode==1&&this.options.chooseMode == this.options.value.length){
    				chooseInput.hide();
    			}else{
    				chooseInput.show();
    			}
    		}else{
    			var chooseBox = $("#"+this.options.id+"_choose_box");
    			var html = this._buildSelect();
    			chooseBox.append(html);
    		}
    		//������ʽ
    		this._setMaxWidth($(".block_cross_other",this.options.el));
        	this._setMaxWidth($(".block_cross",this.options.el));
    		
        	//readonlyʱͨ��setValue����ֵ�ģ�����ɾ��
        	if(this.options.readonly){
        		this.setReadonly(true);
        	}
        	//���ñ��ύ���ֵ
        	this._setHiddenElement(data);
    		//ѡ��ֵ�� ���µ���input�ĳ�ʼ���
        	this._resizeInputWidth();
        	isInit || this._triggerHandler('change');
    	},
    	
    	/**
    	 * ����ѡ���id���Ӻ�̨�������ݶ���VO
    	 * @param ���ݽ��������ݣ� array |string
    	 * @returns ��Ӧ���ݵ�VO. ����null
    	 * */
    	_loadValueFromDb:function(data){
    		if(!data){
    			return null;
    		}
    		var selectedId = [];
    		var copyData = [];
    		if($.isArray(data)&&data.length>0){
    			copyData = data.slice(0);//���ݽ��������ݸ���һ��
    			for(var i=0;i<data.length;i++){
					selectedId.push(data[i].id);
    			}
    		}else if(typeof data==="string"){
    			selectedId = data.split(";");
    		}
    		
    		if(!selectedId||selectedId.length==0){
    			//û����Ҫ��ѯ���ݿ�ģ�ֱ�ӷ���
    			return copyData;
    		}
    		//��������id���ɺ�̨��ѯ���ݳ���
    		dwr.TOPEngine.setAsync(false);
    		var dbVo ;
    		var chooseType = this.options.uitype==="ChooseOrg"?"org":"user";
    		ChooseAction.querySelectedDataByIds(selectedId,{"chooseType":chooseType,"showLevel":this.options.showLevel||0,"showOrder":this.options.showOrder||""},function(result){
    			if(!result){
    				result = [];
    			}
    			dbVo =  result;
    		});
    		dwr.TOPEngine.setAsync(true);
    		//��ԭ�����ݹ��������ݱ���һ�ݣ�����ѯ���������Աȣ�û�в��ҵ������ݣ�ֱ��ʹ�ô��ݽ�����
    		if(copyData&&copyData.length){ //����У�����ӵ�ָ����λ��
    			var mergedResult = [];//�������飬׼���ϲ����
    			var lastIndex = -1;//�ϴ�ƥ���λ��
    			for(var i=0;i<copyData.length;i++){
    				if(lastIndex<dbVo.length-1&&copyData[i].id===dbVo[lastIndex+1].id){ //ƥ�����ˣ�ȡ��̨������
    					mergedResult.push(dbVo[lastIndex+1])
    					lastIndex++;
    				}else{//δƥ���ϣ�ֱ��ȡ���ݽ���������
    					copyData[i].isOther= true;
    					mergedResult.push(copyData[i]);
    				}
    			}
    			return mergedResult;
    		}
    		return dbVo;
    	},
    	
    	/**
         * ����ѡ������
         * @param {���ݼ���} data 
         */
        setValue:function(data, isInit){
        	var dbVo=this._loadValueFromDb(data);
        	this.__setValue(dbVo,isInit);
        },
      
        /**
         * ����input���ΪĬ�Ͽ��*/
        _resizeInputWidth:function(){
        	$("#"+this.options.id+"_choose_input",this.options.el).width(this.options._defaultInputWidth);
        },
        
        //�ж��Ƿ��ѡ
        _getMultiStype:function(){
        	return this.options.chooseMode!=1?"block_cross_multi":"";
        },
        /**
         * ƴ���Ѿ�ѡ���¼��html��
         * @return html �����
         * */
        _buildSelect:function(){
        	var html = [],len = this.options.value.length;
        	//������ı�ģʽ
        	if(this.options.textmode){
        		var showName="";
        		for(var i=0;i<len;i++){
        			showName = !this.options.value[i].showName?this.options.value[i].name:this.options.value[i].showName;
        			//��ʾʱ��showName
        			html.push(showName);
        		}
        		return html.join(";");
        	}else{
        		var multiStyle = this._getMultiStype();
        		var blockStyle="";
        		var showName="";
        		for(var i=0;i<len;i++){
    				blockStyle = this.options.value[i].isOther?"block_cross_other":"block_cross";
    				showName = !this.options.value[i].showName?this.options.value[i].name:this.options.value[i].showName;
    				html.push('<div class="'+blockStyle+' '+ multiStyle + '" title="'+showName+'" id="'+this.options.id+this.options.value[i].id+'"><span class="c_content">'+showName+'</span><a flag="del" href="#" class="block_delete"></a></div>');
        		}
        		return html.join("");
        	}
        },
        /**
         * ��ȡѡ������ 
         */
        getValue:function(){
        	return $.extend(true, [], this.options.value);
        },
        /**
         * �����Ƿ�ֻ��
         */
        setReadonly: function(flag){
        	this.options.readonly = flag;
        	if(flag){
        		$('#'+this.options.id+'_open').hide();
        		$('#'+this.options.id+'_choose_input').hide();
        		$('#'+this.options.id+'_choose_box').attr('class','choose_box_readonly');
        		this.options.el.attr("tip", '');
        		$('#'+this.options.id+'_choose_box').children().children('.block_delete').hide();
        	}else{
        		$('#'+this.options.id+'_open').show();
        		$('#'+this.options.id+'_choose_input').show();
        		$('#'+this.options.id+'_choose_box').removeClass('choose_box_readonly');
        		$('#'+this.options.id+'_choose_box').addClass('choose_box');
        		$('#'+this.options.id+'_choose_box').children().children('.block_delete').show();
        	}
        },
        /**
         * ��������
         * @param {������} name 
         * @param {����ֵ} value 
         */
        setAttr: function(name,value){
        	if(name==='rootId'){
        		this.options.rootId=value;
        		this.options.el.attr('rootId', value);
        	}
         	if(name==='defaultOrgId'){
        		this.options.defaultOrgId=value;
        		this.options.el.attr('defaultOrgId', value);
        	}
         	if(name==='orgStructureId'){
         		this.options.orgStructureId=value;
         		this.options.el.attr('orgStructureId', value);
         	}
         	if(this.options.uitype==="ChooseOrg"&&name==="unselectableCode"){
         		this.options.el.attr("unselectableCode",value);
         	}
         	
        },
        /**
         * ���ݴ���ص�����
         * @param {CUI} cuiObj
         * @param {String} msg
         */
        onInValid: function(cuiObj, msg){
        	$('#'+this.options.id+'_choose_box').addClass("choose_invalid");
        	var self = this,
            opts = self.options;
	        if (opts.tipTxt == null) {
	            opts.tipTxt = opts.el.attr("tip") || "";
	        }
	        opts.el.attr("tip", msg);
	        //����tip���ͣ�����
            $(self.tipPosition, opts.el).attr('tipType', 'error');
        },

        /**
         * ������ȷ�ص�����
         * @param cuiObj
         */
        onValid: function(cuiObj){
        	var self = this,
        	opts = self.options,
        	tipID = $(self.tipPosition, opts.el).attr('tipID');
        	$('#'+this.options.id+'_choose_box').removeClass("choose_invalid");
        	if (opts.tipTxt == null) {
        		opts.tipTxt = opts.el.attr("tip") || "";
        	}
        	if(tipID !== undefined){
        		//������ʾ
        		var $cuiTip = cui.tipList[tipID];
        		typeof $cuiTip !== 'undefined' && $cuiTip.hide();
        	}
        	opts.el.attr("tip", opts.tipTxt);
        	//����tip���ͣ�����
        	$(self.tipPosition, opts.el).attr('tipType', 'normal');
        },
        
        /**
         * ����ƥ�������ʧȥ���㴦��
         */
        _blurHandler: function(){
        	if(this.hideAble==false){
        		return;
        	}
        	this._closeFastDataDiv();
        	this._resizeInputWidth();
        },
        
        /**  ���°���Ա��֯��ǩǨ�ƿ�ʼ  *  */
        /**
         * ��ȡ����ȫ���еı������������ڲ��ſ�����������ʾ������ʾ
         */
        _subDepartmentFullName:function(deptFullName,name){
        	// ��ò���ȫ�������һ��"/"��λ��
        	var iEnd = deptFullName.lastIndexOf($.trim(name));
        	// ���ؽ�ȡ��Ĳ���
        	if(iEnd > 0){
        		return deptFullName.substring(0,iEnd);
        	}else{
        		return "";
        	}
        },
        
        /**
         * ��װ��������div����
         * @param divObj ���������divid 
         * @param data ����
         * @param operatorType �������
         */
        _installData:function(data,operatorType){
        	var totalPage = Math.ceil(data.count/this.pageSize) ;
        	var objDiv = this._buildListItemTemplate(data);
        	
        	var $queryDataArea=$('#'+this.queryDataAreaDivId);
        	// �������֯�ṹtabҳ�ļ�����
        	if(operatorType=="add"){
        		$queryDataArea.append(objDiv);
        	}else if(operatorType=="replace"){
        		$queryDataArea.height("");
        		$queryDataArea.html(objDiv);
        	}
        	//�����ѯ������������������ÿҳ��ʾ����������ʾ�������ݡ�
        	if(this.pageNo==totalPage){
        		$("#"+this.moreDataDivId).css('display','none');
        	}else{
        		$("#"+this.moreDataDivId).css('display','block');
        	}
        },
        
        /**
         * ����������λ��
         * @param {number} positionIndex
         * @private
         */
        __scrollHoverPosition: function (positionIndex) {
        	var $box= $("#"+this.queryDataAreaDivId),
        	scrollTop = $box.scrollTop(),
        	children = $box.children(),
            $ele =children.eq(positionIndex),
            boxHeight = $box.height(),
            lineHeight = $ele.outerHeight(),
            offsetTop = $ele[0].offsetTop;
    	    if (scrollTop > offsetTop) {
    	    	$box.scrollTop(offsetTop);
    	    } else if (scrollTop < offsetTop + lineHeight - boxHeight) {
    	    	$box.scrollTop(offsetTop + lineHeight - boxHeight);
    	    }
        },
        /**�������ײ���������ʾ����ʱ������һ�濪ʼ��ʾ
         *  @param {number} positionIndex
         * */
        __scrollHoverToBottom:function(positionIndex){
        	var $box= $("#"+this.queryDataAreaDivId),
        	scrollTop = $box.scrollTop(),
        	children = $box.children(),
        	size = children.length,
            $ele =children.eq(Math.min(size-1,positionIndex)),
            offsetTop = $ele[0].offsetTop;
	    	$box.scrollTop(offsetTop);
        },
        /**
         * ��������������չʾ�����ط���
         * 
         */
         _showOrDisplay:function(queryClass){
        	var outDiv = $("#"+this.options.id+"_choose_box").parent();//��ȡ��ǩ����div
        	var tmpSearchDiv = $("#"+this.searchDivId);
        	var $queryDataArea=$('#'+this.queryDataAreaDivId);
        	// ������ģ��ƴ�ӵ����ݣ��������������document�Ŵ��ں�����show()
        	$queryDataArea.hide();
        	var pageHeight = $(window).height();//��ȡ���ڵĿ��Ӹ߶ȣ�����dialog���������ȡ�߶Ȳ�׼��������ʾ��ȫ
        	var searchDivMaxHeight;
        	//����հ׵ĸ߶�
        	var downHeight = pageHeight - outDiv.offset().top-outDiv.height();
        	//����ĸ߶�
        	var upHeight =outDiv.offset().top;
        	var defaultHeight = 200;
        	//�Ƿ���������ʾ
        	var displaySpecial = false;
        	//����ĸ߶Ȳ�������������߶ȱ�����ĸ�ʱ
        	if(downHeight-defaultHeight<0 && upHeight>downHeight){
        		displaySpecial =true;
        	}
        	if(queryClass==="no_data"&&downHeight>20){
        		displaySpecial = false;
        	}
        	
        	tmpSearchDiv.css("overflow-y","");
        	if(displaySpecial){
        		var tmpHeigth = (outDiv.parent().outerHeight(false)+outDiv.parent().offset().top-outDiv.offset().top);
        		tmpSearchDiv.css("bottom",tmpHeigth);
        		tmpSearchDiv.css("border-top","1px solid #ddd");
        		tmpSearchDiv.css("top",'');
        		searchDivMaxHeight = upHeight>defaultHeight?defaultHeight:upHeight;
        	}else{
        		var tmpHeigth = (outDiv.outerHeight(false)-outDiv.parent().offset().top+outDiv.offset().top) ;
        		tmpSearchDiv.css("top",tmpHeigth);
        		tmpSearchDiv.css("border-bottom","1px solid #ddd");
        	 	tmpSearchDiv.css("bottom",'');
        	 	tmpSearchDiv.css("border-top",'1px solid #ddd');
        		searchDivMaxHeight = downHeight>defaultHeight?defaultHeight:downHeight;
        	}
        	// �ж��Ƿ��С��������ݡ�,5�������ǲ���ʱ����������ƫ��5�����ز�����ʾ�߿򣬾���ԭ����������
        	if("none" !=$("#"+this.moreDataDivId).css('display')){
        		var heightOfMoreDataDiv = $("#"+this.moreDataDivId).height();
        		searchDivMaxHeight = searchDivMaxHeight - heightOfMoreDataDiv - 5
        	}
        	var listLength = $("."+queryClass).length;
        	//�ж��Ƿ��з�������
        	if(listLength > 0){
        		this._openFastDataDiv(searchDivMaxHeight,displaySpecial);
        		// չ��ģ��ƴ�ӵ�����
        		$queryDataArea.show();
        		$queryDataArea.scrollTop(0);
        	}else{
        		this._closeFastDataDiv();
        	}
        },
        /**
         * �رտ��ٲ�ѯ������DIV
         */
        _closeFastDataDiv:function(){
        	// �ջ�divʱ����currentIndex
        	this.__clearHover();
    		this.pageNo = 1;
    		this.tempNoDataFunc=null;
    		this.fastQueryFunc=null;
        	var tmpSearchDiv = $("#"+this.searchDivId);
        	tmpSearchDiv.css("z-index",'');
        	var queryDataArea = $("#"+this.queryDataAreaDivId);
    		queryDataArea.children().remove();
    		tmpSearchDiv.children().hide();
        	tmpSearchDiv.slideUp("fast");
        	var input = $("#"+this.options.id+"_choose_input");
        	if(!input.is(":hidden")){
        		//û������
        		input.val('');
        	}
        },
        /**
         * ��ʾ���ٲ�ѯ������DIV
         */
         _openFastDataDiv:function(searchDivMaxHeight,displaySpecial){
        	//�򿪲�ѯ��ʱ��ʼ����ǰҳ��
        	var hiddenFrame = $("#"+this.searchDivId);
        	hiddenFrame.show();
        	var $chooseBoxWrap = $("#"+this.options.id +"_choose_box").parent();
        	var tepWidth = $chooseBoxWrap.innerWidth();//$("#"+searchDiv).prev().innerWidth();
        	$("#"+this.moreDataDivId).css("width",tepWidth);
        	var $searchDiv = $("#"+this.searchDivId);
        	$searchDiv.width(tepWidth+"px");
        	$searchDiv.slideDown("fast");
//        	//����������ĸ߶�
        	var dataArea = $('#'+this.queryDataAreaDivId);
        	if(dataArea.height() > searchDivMaxHeight){
        		dataArea.css('height',searchDivMaxHeight+'px')
        	}
        	var frameHeight  = dataArea.height();
        	// ����С��������ݡ�
        	if("none" !=$("#"+this.moreDataDivId).css('display')){
        		var heightOfMoreDataDiv = $("#"+this.moreDataDivId).height();
        		frameHeight = frameHeight+heightOfMoreDataDiv;
        	}
        	var frameTop = $chooseBoxWrap.offset().top;
        	if(displaySpecial){
        		frameTop = frameTop-frameHeight;
        	}else{
        		frameTop = frameTop+$chooseBoxWrap.height()-1;
        	}
        	var object = {};
        	object.left = $chooseBoxWrap.offset().left;
        	object.top = frameTop;
        	hiddenFrame.offset(object);
        	hiddenFrame.css("width",($("#"+this.searchDivId).width())+"px");
        	hiddenFrame.css("height",frameHeight+"px");
        },
    	
    	//������ٲ�ѯ�ؼ����ַ���
    	 _handleStr:function(str){
    		str = str.replace(new RegExp("/", "gm"), "//");
    		str = str.replace(new RegExp("%", "gm"), "/%");
    		str = str.replace(new RegExp("_", "gm"), "/_");
    		str = str.replace(new RegExp("'", "gm"), "''");
    		return str;
    	},
    	
    	/**
    	 * չʾ��������
    	 */
    	 _showMoreData:function(){
    		this.pageNo++;
    		var moreData = $("#"+this.moreDataDivId);
    		moreData.removeClass("more_data");
    		moreData.addClass("more_data_disable");
    		var keyword = this._handleStr($('#'+this.options.id+'_choose_input').val());
    		keyword=$.trim(keyword);
    		if(keyword==''){
    			this._closeFastDataDiv();
    			this._closed===true;
    			return;
    		}else{
    			this._fastQuery(keyword,"add");
    		}
    	},
        
    	/**
         * �������̰��´���
         * @param {Event} e 
         */
        _keyup:function(e){
    		if(!(e.keyCode>=KEYCODE_ARROW_LEFT&&e.keyCode<=KEYCODE_ARROW_DOWN)){//���������ϼ�
        		this.pageNo=1;
        		var self = this;
        		if(this.fastQueryFunc){
        			window.clearTimeout(this.fastQueryFunc);
        		}
        		if(this.tempNoDataFunc){
        			window.clearTimeout(this.tempNoDataFunc);
        		}
    			var keyword = this._handleStr($('#'+this.options.id+'_choose_input').val());
        		keyword=$.trim(keyword);
        		if(keyword==''){
        			this._closeFastDataDiv();
        			this._closed===true;
        			return;
        		}else{
        			this.fastQueryFunc = setTimeout(function(){
        				self._fastQuery(keyword,"replace");
        			},300);
        		}
        		
        	}
        },
        
        /**
         * �س�
         * @private
         */
        __keyDownEnterHandler: function(){
        	this._selectRow();
        },
        /**
         * ��ȡ��ǰѡ�е���
         * */
        _selectRow:function(){
        	var hoverIndex = this.hoverIndex;
        	var data={};
        	if (typeof hoverIndex !== "undefined") {
        		if(this._beforeSelect&&!this._beforeSelect(hoverIndex)){
    				return false;
        		}
            	var currentClassName = ".current_select";
                var queryDataArea = $("#"+this.queryDataAreaDivId);
        		var record = queryDataArea.find(currentClassName);
        		if(record&&record.length){
        			var id = record.attr("id").replace(prefixOfQueryA,"");
        			data.id = id;
        			this._appendData(data);
        		}
        	}else if(this.options.isAllowOther&&$.trim($('#'+this.options.id+'_choose_input').val())){//�����ⲿ����
        		this._textCounter();
        		//����ת��������ֹXSS����20160418
        		var inputVal = $("<div style='display:none'/>").text($('#'+this.options.id+'_choose_input').val()).html();
        		//ID�滻������Ϊʮ���������ļ����š��������ϲ���ɾ��20160418
            	data.id = inputVal.replace(/&lt;/g,"\u300a").replace(/&gt;/g,"\u300b");
            	data.name = inputVal;
            	data.isOther = true;
            	this._appendData(data);
    		}
        	//�ù������Զ��������±�
        	var boxDiv = $("#"+this.options.id+"_choose_box");
        	if(boxDiv.scrollTop()>0){ //�й�����
        		boxDiv.scrollTop(boxDiv[0].scrollHeight);
        	}
        	//ѡ���Ҫ�жϴ���
        	this._blurHandler();
        	$("#"+this.options.id+"_choose_input").focus();
        },
        
        /**
         * ���ٲ�ѯ�ص�����װ��ѯ�����չʾ
         * @param type ��ʶ����ʾ����Ա��ѯ��������֯��ѯ
         * @param operatorType ��������
         * @param ��ѯ��������
         * */
        _queryCallBack:function(type,operatorType,data){
        	if(this._closed===true){
				return;
			} 
			var self = this;
			if(data.count==0){
		   		 $("#"+this.moreDataDivId).css('display','none');
		   		 $('#'+this.queryDataAreaDivId).height("");
		   		 var nodataHtml = "";
		   		 if(type==="user"){
		   			 nodataHtml='<span class="no_data" >&nbsp;\u672a\u67e5\u5230\u8be5\u4eba\u5458</span>';
		   		 }else if(type==="org"){
		   			 // δ�鵽����֯
		   			 nodataHtml = '<span class="no_data" >&nbsp;\u672a\u67e5\u5230\u8be5\u7ec4\u7ec7</span>';
		   		 }
  				 $('#'+this.queryDataAreaDivId).html(nodataHtml);
  				this._showOrDisplay("no_data");
  				 clearTimeout(this.tempNoDataFunc);
  				this.tempNoDataFunc = setTimeout(function(){
		   		  	 self._closeFastDataDiv();
		   		  },2000);
	   		}else{
	   			var $box= $("#"+this.queryDataAreaDivId),
	   			children = $box.children(),
	   			len =children.length ;
	   			if(operatorType==="replace"){
	   				this.__clearHover();
	   			}
	   			this._installData(data,operatorType);
	   			var usrOrOrg = "";
	   			if(type==="user"){
	   				usrOrOrg="user_query";
	   			}else if(type==="org"){
	   				usrOrOrg="dept_query";
	   			}
	   			
	   			this._showOrDisplay(usrOrOrg);
	   			var moreData = $("#"+this.moreDataDivId);
				moreData.removeClass("more_data_disable");
				moreData.addClass("more_data");
				if(operatorType==="add"){ //����ǵ�����࣬��Ҫ����
					this.__scrollHoverToBottom(len-1);
					$("#"+this.options.id+"_choose_input").focus();
				}
	   		}
        }
        
    });
    
    /**
	 * ��������ȫ�����õķ���
	 * */
	C.UI.Choose.setChooseOpt=function(config){
    	var p,ui=this,opt;
    	if(typeof config==="object"){
    		for(p in config){
    			if(typeof p ==="string"&&p==="ChooseUser"){
    				$.extend(comtop.UI.ChooseUser.prototype.options,config[p]);
    			}
    			if(typeof p ==="string"&&p==="ChooseOrg"){
    				$.extend(comtop.UI.ChooseOrg.prototype.options,config[p]);
    			}
    		}
    	}
	};
    
    C.UI.ChooseUser = C.UI.Choose.extend({
    	options: {
    		uitype: 'ChooseUser',//�������
    		userType: 0//�û����ͣ�1��ְ��2��ְ��0ȫ��
    	},
        
    	/**
         * ���ٲ�ѯ�û�
         * @param {Event} e 
         */
        _fastQuery:function(keyword,operatorType){
    		this._closed=false;
    		var self = this;
    		var obj = {};
    		obj.keyword = keyword;
    		obj.userType = this.options.userType;
			obj.orgStructureId = this.options.orgStructureId;
			obj.rootDepartmentId = this.options.rootId;
			obj.pageNo = this.pageNo;
			obj.pageSize = this.pageSize;
    		ChooseAction.fastQueryUserPagination(obj,function(data){
    			self._queryCallBack("user",operatorType,data);
    		});
        },
        /**
         * ��ʾ����Ա������ͬ�����ݣ��������չ�ֲ�ͬ��Ч��
         */
         _sameNameDispose:function(data,tempCount){
        	var sameCount = 1;
        	for(var i =0;i<tempCount;i+=sameCount){
        		//��Ա������ͬʱ�ر�ʾ����
        		//���ں�̨���ݲ�ѯʱ�Ѿ���������Ա�����������Բ���������ͬ�����ݶ�����һ���ˣ�ֻ��Ҫ�Ƚ����ڵ����ݼ���
        		sameCount = 1;
        		for(var j=i+1;j<tempCount;j++){
        			if(data[i].title == data[j].title){
        				data[i].hasSameName = true;
        				data[j].hasSameName = true;
        				//�����ظ��Ƚ�
        				sameCount++;
        			}else{
        				if(data[j-1].hasSameName){
        					data[j-1].hasCutoffLine = true;
        				}
        				break;
        			}
        		}

        	}
        	return data;
        },
               
        /**
         * ��ȡ��Ա����������ģ��html����
         * @param data,��ѯ���������count,list
         * */
        _buildListItemTemplate:function(data){
        	var objDiv = "";
        	var tempCount = data.list.length;
        	var tmpData = data.list;
        	tmpData = this._sameNameDispose(tmpData,tempCount);
        	for(var i=0;i<tempCount;i++){
        		objDiv += this._getMenuItemTemplate(tmpData[i],i);
        	}
        	return objDiv;
        },
    	
        /**
         * ��ȡ����������ģ��
         */
        _getMenuItemTemplate:function(data,i) {
        	//�����ͬ������Ա��ʹ�����е���ʽչ�֡�
        	if(data.hasSameName){
        		// ����û����ڲ��ŵ��ϼ�����ȫ��
        		var subDeptFullName = this._subDepartmentFullName(data.fullName,data.orgName);
        		//�����ڸ�ÿ�������������¼�ʱ��Ҫ�õ�className�����Ը������user_query��class������ͬ������ԱҪ������һ����ʽչ�֣����Լ���style���ԣ�����user_query��ʽ��
        		var userClass= "";
        		if(data.hasCutoffLine){
        			userClass = "user_query user-same-name user-same-name-last"
        		}else{
        			userClass = "user_query user-same-name";
        		}
        		var bufferDouble = [
        		               		"<a href='#' class='"+userClass+"' " +
        		               		"id='",prefixOfQueryA,data.key,"'>",
        		        	    		"<span class='user-name' title='",data.title, "'>",data.title,"</span>",
        		        	    		"<span class='user-deptname' title='",data.orgName,"'>",data.orgName,"</span>",
        		        	    		"<span class='user-deptfullname' title='",subDeptFullName,"'>",subDeptFullName,"</span>",
        		            		"</a>"
        		        	    	];
	        	return bufferDouble.join("");
        	}else{
        		var bufferDouble = [
        		               		"<a href='#' class='user_query' id='",prefixOfQueryA,data.key,"'>",
        		        	    		"<span class='user_first' title='",data.title, "'>",data.title,"</span>",
        		        	    		"<span class='user_last' title='",data.fullName,"'>",data.fullName,"</span>",
        		            		"</a>"
        		        	       	];
	        	return bufferDouble.join("");
        	}

        }
        
    });
    
    C.UI.ChooseOrg = C.UI.Choose.extend({
    	options: {
    		uitype: 'ChooseOrg',//�������
    		showLevel:-1, //��֯��ǩ��������չʾ�㼶,-1:��ǰѡ�еĽڵ���,1:ȫ·��չʾ,��������Ϊչʾ�ĳ�ʼ�㼶	
    		showOrder:"order",  //ȫ·����ʾ˳��reverse:����order:����
    		levelFilter:999,	//��֯��ǩ������չʾʱ��չʾ���ļ���-1:ȫ����ʾ,����ֵ�������top_org_type_relation�е�org_type_id
    		//չʾ��ָ���ļ���
    		unselectableCode:"",//������ѡ�����֯Code
    		isFullName:false//ָ����ʹ����showLevel���ԡ�valueName����ʱ��valueName�������е�ֵ�Ƿ�Ҳ����ȫ·����Ĭ��Ϊfalse
    	},
        /**
    	 * ��ȡ����������ģ��;
    	 * @param obj :
    	 * prefixOfQueryA
    	 * className
    	 * firstClassName
    	 * lastClassName
    	 * lineClassName
    	 * ���������ݽڵ����
    	 */
    	_getMenuItemTemplate:function(obj,i) {
    		//������ʾ�жϣ�ָ��rootIdʱ����rootId���жϣ��������·���ж�
    		var subDeptFullName = "";
    		var tmpRootId = this.options.rootId;
    		if(tmpRootId&&tmpRootId===obj.key){
    			//����Ǹ��ڵ㣬��ֱ����ʾ����
    			subDeptFullName = obj.fullName;
    		}else{
    			// ��ò��ŵ��ϼ�����ȫ��
    			subDeptFullName = this._subDepartmentFullName(obj.fullName,obj.title);
    		}
    		// �����ϵͳ�����ţ�������fullname��û���ϼ����ţ�����õ�����ʾ
    		if(subDeptFullName == ""){
    			// ��������ģ��
    			var bufferSingle = [
    		       		"<a href='#' class='",
    		       		obj.className,"' id='",prefixOfQueryA,obj.key,"'","orgreadonly='",obj.unselectable, "' style='height:20px;'>",
    			    		"<span class='", obj.firstClassName,  "' title='",obj.title,"'>",obj.title,"</span>",
    		    		"</a>"
    			       	];
    			return bufferSingle.join("");
    		}else{
    			// �Ǹ����������˫����ʾ
    			var bufferDouble = [
    		       		"<a href='#' class='",obj.className,"' id='",prefixOfQueryA,obj.key,"'","orgreadonly='",obj.unselectable, "'>",
    			    		"<span class='", obj.firstClassName, "' title='",obj.title, "'>",obj.title,"</span>",
    			    		"<span class='", obj.lastClassName, "' title='",subDeptFullName,"'>",subDeptFullName,"</span>",
    		    		"</a>"
    			       	];
    			return bufferDouble.join("");
    		}
    	},
    	
        /**
         * ��ȡ��Ա����������ģ��html����
         * @param data,��ѯ���������count,list
         * */
        _buildListItemTemplate:function(data){
        	var objDiv = "";
        	var tempCount = data.list.length;
        	var oneNode;
        	for(var i=0;i<tempCount;i++){
        		oneNode = data.list[i];
        		if(oneNode.unselectable){
        			oneNode.className= "dept_query dept_query_readonly";
        		}else{
        			oneNode.className="dept_query";
        		}
        		oneNode.firstClassName="dept_first";
        		oneNode.lastClassName="dept_last";
        		objDiv += this._getMenuItemTemplate(oneNode,i);
        	}
        	return objDiv;
        },
        /**
         * ���ٲ�ѯʱ��ѡ���¼ǰ�����ж��Ƿ�����ѡ��
         * @param hoverIndex ѡ��ļ�¼��
         * @return true ����ѡ��false������ѡ��
         * **/
        _beforeSelect:function(hoverIndex){
        	var curDept = $("#"+this.queryDataAreaDivId).find(".dept_query").eq(hoverIndex);
    		var readonly =$(curDept).attr("orgreadonly"); 
    		if(readonly==="true"||readonly==true){
    			return false;
    		}
    		return true;
        },
    	/**
         * ���ٲ�ѯ��֯
         * @param paramObj �������� keyword,orgStructureId,rootDepartmentId
         * @param operatorType ������� replace add
         */
        _fastQuery:function(keyword,operatorType){
        	var self = this;
    		this._closed=false;
    		var obj = {};
    		obj.keyword = keyword;
    		obj.orgStructureId = this.options.orgStructureId;
    		obj.rootDepartmentId = this.options.rootId;
    		obj.pageNo = this.pageNo;
    		obj.pageSize = this.pageSize;
    		obj.levelFilter = this.options.levelFilter;
    		ChooseAction.fastQueryOrgPagination(obj,this.options.unselectableCode,function(data){
    			self._queryCallBack("org",operatorType,data);
    		});
        }
    });
	
})(window.comtop.cQuery, window.comtop);

