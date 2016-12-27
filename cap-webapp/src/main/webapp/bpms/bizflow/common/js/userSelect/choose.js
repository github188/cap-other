/**
 * 注入式Dialog
 * 基于（CUIV4.1 或 CUIV4.2）
 * v0.1.0
 * 技术研究中心 林超群 2014-5-8
 */
;(function($){
    cui.extend = cui.extend || {};

    var _emWin = window.top;

    /**
     * 扩展组件
     * @param options {Object} Dialog组件配置参数
     * @param emWin {Window} 目标窗口
     * @returns {emDialog}
     */
    cui.extend.emDialog = function(options, emWin){
        _emWin = emWin || _emWin;
        //存放Dialog和当前窗口
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

        //创建Dialog，并把相应的Dialog对象和当前窗口对象存放到目标页面变量下
        _emWin.cuiEMDialog.dialogs[options.id] = _emWin.cui.dialog(options);
        _emWin.cuiEMDialog.wins[options.id] = window;


        //返回dialog
        return _emWin.cuiEMDialog.dialogs[options.id];
    };

    //如果主框架cuiEMDialog未定义，或dialogs为空，则表示此window 为 始window
    if(!_emWin.cuiEMDialog || isEmptyObject(_emWin.cuiEMDialog.dialogs)){
    	window._emDialogTopMark = true;
    }

    //页面卸载时，清理本页面所有dialog和win
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
	
	/**定义键盘特殊键值常量*/
	//上箭头编码38
	var KEYCODE_ARROW_UP=38;
	//下箭头编码40
	var KEYCODE_ARROW_DOWN=40;
	var KEYCODE_ARROW_LEFT=37;
	//回车键编码13
	var KEYCODE_ENTRY=13;
	//退格键编码8
	var KEYCODE_BACKSPACE=8;
	
	// 检索框<a>标签的id前缀，检索出的部门标签格式为：<a><span></span><span></span></a>
	var prefixOfQueryA = "a_query_";
	//快速查询结果框分割线样式 
	var lineClassName="cutoff_line";
	
    /**
     * @class Choose
     * @extends C.UI.Base
     * 组织人员选择组件<br>
     *
     * @author 孙晓帆
     * @version 1.0
     * @history 2012-10-17 孙晓帆 新建
     * @demo doc/chooseDoc.html
     */
    C.UI.Choose = C.UI.Base.extend({
        options: {
//            template: 'choose.html',
            id: '',
            value: [],//选择的数据对象集合：[{id:xx,name:xx,isOther:xx},{},...]
            width: '',//宽度
            height: '',//高度
            chooseMode: 0,//选择模式：1单选，0多选，N>1最多选择N个
            readonly: false,//是否只读
            isAllowOther: false,//是否允许输入外部数据
            callback: null,//回调方法
            orgStructureId: '',//组织结构ID
            rootId: '',//根节点ID
            delCallback: null,//删除
            textmode: false,//文本模式
            isSearch: true,//是否支持快速匹配查询
            _defaultInputWidth:0, //默认的input框宽度
            defaultOrgId: '',//初始默认组织节点ID，级别比rootId低时，以defaultOrgId为根节点
            maxLength:-1,//input框允许的最大输入长度,当isAllowOther为true时起作用
            canSelect:true,//是否允许选择操作,当指定为false时，默认开启isAllowOther
            byByte: true,             //最大长度计算方式，true按字节计算，false按字符计算
            formName:'',//表单名表单提交的名字
            idName:'', //表单中的id隐藏域名
            valueName:'',//表单中的value隐藏域名
            opts:''//隐藏域扩展字段
        },
        tipPosition: '.choose_box_wrap',
        pageSize:10,
        pageNo:1,
        cacheData:null,//快速查询结果的缓存数据
        fastQueryFunc:null,
 		tempNoDataFunc:null,
        
        /**
         * 初始化属性方法
         */
        _init:function(cusOptions){
        	if(!this.options.id){
        		this.options.id = 'Choose_' + C.guid();
        	}
        	this.options.el.attr('id', this.options.id);
        	if(!this.options.width){
        		this.options.width = '500px';
        	}
            if (typeof this.options.width === "string" && !/%/.test(this.options.width)) {
	        	//去除px
	        	this.options.width=this.options.width.substring(0,this.options.width.length-2);
	        	var iWidth = parseInt(this.options.width,10)-2;//减去两边的实线宽度
	        	this.options.width = iWidth+"px";
            }
        	this.options.el.attr('width', this.options.width);
        	if(!this.options.height){
        		this.options.height = '200px';
        	}
        	if (typeof this.options.height === "string" && !/%/.test(this.options.height)) {
        		//去除px
        		this.options.height=this.options.height.substring(0,this.options.height.length-2);
        		var iheight = parseInt(this.options.height,10)-2;//减去两边的实线宽度
        		this.options.height = iheight+"px";
            }
        	this.options.el.attr('height', this.options.height);
        	this.$el = $("#"+this.options.id);
        	
        	if(!this.options.canSelect){ //不允许选择
        		this.options.isAllowOther= true;
        		this.options.isSearch= false;
        	}
        	if(this.options.opts){
        		if (typeof this.options.opts === "string" && typeof window[this.options.opts] === "object") {
        			this.options.opts = window[this.options.opts];
        		}else{
        			this.options.opts = $.parseJSON(this.options.opts.replace(/\'/g, '\"'));
        		}
        	}
        	
        	//从隐藏域中获取值，放入value属性中
        	this._setValueFormHidden();
        },
        //将隐藏域中的值放到value中。以便在初始化时回显
        _setValueFormHidden:function(){
        	var opts = this.options;
        	var formEle;
        	if(opts.formName){
        		formEle =document.forms[opts.formName];
        	}
         	//if(formEle&&typeof(formEle)!== 'undefined' ){
         	   //先根据id来查询，找不到用name查找
         		var ids = this._getHiddenVal(formEle,opts.idName);
         		if(ids){
         			var idArray = ids.split(";");
         			
         			// 如果isAllowOther为false ，即不允许外部输入，则直接后台查询。否则检查name是否传递值，有则用，没有则后台查询
     				//如果已经传递了需要的id/name，则不再去后台查询。只传递id时去后台查询
             		var names = this._getHiddenVal(formEle,opts.valueName);
             		if(names){
             			var nameArray =names.split(";");
             			var codeArray = [];
             			if(opts.opts&&opts.opts.codeName){
             				//扩展的暂时这么写。
             				var codes = this._getHiddenVal(formEle,opts.opts.codeName);
             				if(codes){
             					codeArray = codes.split(";");
             				}
             			}
                 		var selected = [];//记录循环过的id。去除重复数据
                 		var data = [];
                 		var jsonString= "";
                 		for(var i=0;i<idArray.length;i++){
	         				if($.inArray(idArray[i], selected)>-1){
	         					//已经处理过的，跳过
	         					continue;
	         				}
	         				if(i>=nameArray.length){
	         					//如果名称已经没有了，则跳出
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
         			//根据传递的id从后台获取选择的数据
         			var selected = this._getSelectedById(ids);
         			if(!selected){
         				selected = [];
         			}
         			this.options.value=selected;
         		}
         	//}
        },
        /**
         * 获取指定隐藏域的值。优先以id查找，查找不到时用name查找
         * @param formEle 表单对象
         * @param eleName 标签的id/name
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
         * 获取表单隐藏域中的值
         * 将隐藏域中的值以JSON对象格式返回
         * */
        getFormData:function(){
        	var formEle,opts = this.options;
        	if(opts.formName){
        		formEle =document.forms[opts.formName];
        	}
        	var jsonArray = [];
         	//if(formEle&&typeof(formEle)!== 'undefined' ){
         		if(opts.idName){
         			jsonArray.push("\""+opts.idName+"\":\""+ this._getHiddenVal(formEle,opts.idName)+"\"");
         		}
         		if(opts.valueName){
         			jsonArray.push("\""+opts.valueName+"\":\""+this._getHiddenVal(formEle,opts.valueName)+"\"");
         		}
         		if(opts.opts&&opts.opts.codeName){
         			jsonArray.push("\""+ opts.opts.codeName+"\":\""+this._getHiddenVal(formEle,opts.opts.codeName)+"\"");
         		}
         	//}
         	return $.parseJSON("{"+jsonArray.join(",")+"}");
        },
        /**
         * 文字模式函数，文字模式下不再调用_create()。
         * 在Base中调用
         */
        setTextMode: function(){
          this._createDom();
          //设置文本模式的样式
  		 this.__renderTextMode();
        },
        /**
         * 渲染文本模式
         * */
        __renderTextMode:function(){
        	$('#'+this.options.id+'_choose_box').attr('class','cui_ext_textmode');
  			$('#'+this.options.id+'_open').hide();
    		$('#'+this.options.id+'_choose_input').hide();
    		this.options.el.attr("tip", '');
        },
        /**
         * 初始化模板方法
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
        	}
        	if(opts.isSearch){
        		this._bindMouseEvent();
        	}
        },
        
        /**
         * 绑定点击事件
         * */
        _bindClickEvent:function(){
        	var self = this,opts=this.options;
        	$("#"+this.options.id+"_choose_box").off().on("click.choose",function(e){ 
        		self._clickHandler(e);
        	});
        	 if(opts.canSelect){
	             $("#"+this.options.id+"_open").off().on("click.choose",function(e){ 
	             	self._aHandler(this);
	             	return false;
	             });
        	 }
        	 if(opts.isSearch){
        		 $("#moreData_"+this.options.id).off().on("click.choose",function(){
        			 if($("#moreData_"+self.options.id).hasClass("more_data")){
        				 self._showMoreData();
        			 } 
        			 return false;
        		 });
        	 }
        },
        /**
         * 绑定鼠标事件
         * */
        _bindMouseEvent:function(){
        	var self = this;
        	var current_class,className ;
        	current_class= this.options.uitype==='ChooseOrg'?"current_dept":"current_user";
        	className =this.options.uitype==='ChooseOrg'?".dept_query":".user_query";
        	var queryDataArea= $("#queryDataArea_"+this.options.id);
        	queryDataArea.off().on("mouseover.choose",function(e){
        		if(self.pageX==e.pageX&&self.pageY==e.pageY){
        			//鼠标没动，不处理
        			return;
        		}
        		//进入时记录光标位置
        		self.pageX = e.pageX;
        		self.pageY= e.pageY;
        		if(self.t){
        			clearTimeout(self.t);
        		}
        		delete self.t;
        		var $currObj =$(e.target).closest("a");
        		var $queryDataArea= $("#queryDataArea_"+self.options.id);
        		$queryDataArea.children().removeClass(current_class);//先清除样式 避免跟键盘冲突
        		$currObj.addClass(current_class);
        		self.__clearHover();
        	}).on("mouseout.choose",function(e){
        		//离开时不记录位置
        		if(self.pageX==e.pageX&&self.pageY==e.pageY){
        			//鼠标没动，不处理
        			return;
        		}
        		if(self.t){
        			clearTimeout(self.t);
        		}
        		self.t=setTimeout(function(){
	        		var $queryDataArea= $("#queryDataArea_"+self.options.id);
	    			$queryDataArea.children().removeClass(current_class);//先清除样式 避免跟键盘冲突
        		},200);
        	});
        	//数据显示层，选择某个值
        	queryDataArea.on("click.choose",function(e){ 
    			self.hoverIndex = parseInt($(e.target).closest("a").attr("index"),10);
    			self._selectRow();
    			e.preventDefault();
        	});
        	
        	$(document).on("click.choose",function(event){
        		var $searchDiv =$("#searchDiv_"+self.options.id); 
        		if($searchDiv.length){
        			if(!$.contains($searchDiv.get(0),event.target)&&$searchDiv.css("display")!=="none"){
        				$("#"+self.options.id+"_choose_input").val('');
        				self._closeFastDataDiv("searchDiv_"+self.options.id);
        			}
        		}
        	});
        },
        
        /**
         * 输入框的按键事件
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
           input.unbind("keyup.choose").bind("keyup.choose", function (event) {
            	self._keyup(event);
            });
           if((opts.isAllowOther||!opts.canSelect)&&opts.maxLength > -1){
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
           		}
           });
           input.blur(function(){
        	   var outer = $("#"+opts.id+"_choose_box");
        	   outer.removeClass('choose_input_focus');
           });
        },
        /**
         * 限制输入长度
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
         * 计算字符串长度
         * @param value {String} 字符串
         * @returns {Number|*}
         * @private
         */
        _getStringLength: function(value){
            var opts = this.options;
            return opts.byByte ? C.String.getBytesLength(value) : value.length;
        },
        /**
         * 截取字符串
         * @param value {String} 字符串
         * @param length {Number} 载取长度
         * @returns {*}
         * @private
         */
        _interceptString: function(value, length){
            var opts = this.options;
            return opts.byByte ? C.String.intercept(value, length) : C.String.interceptString(value, length);
        },
        /**
         * 创建保存选择结果的隐藏域
         * */
        _createHiddenInput:function(){
        	var opts = this.options;
        	var formEle = null;
        	 //隐藏域
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
         * 创建指定名称的隐藏域
         * @param formEle 表单对象
         * @param eleName 元素名称
         * 返回html代码
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
         * 创建标签的dom
         * 并把DOM存入Root属性中
         * @private
         */
        _createDom: function () {
            var opts = this.options,
                $el = this.$el,
                inputHtml,chooseData,searchDiv,
                pullBox, iframe = "";
            	chooseData= [];
            	searchDiv= [];
        	if(!$.isArray(this.options.value)){
        		this.options.value=[this.options.value]; 
      		}
        	if(opts.chooseMode==1&&this.options.value.length>1){
        		//单选时如果传递了多个，取第一个
        		this.options.value=[this.options.value[0]];
        	}
            	
            if(this.options.value.length&&this.options.value.length>0){
            	var len = this.options.value.length;
            	if(this.options.textmode){
            		for(var i=0;i<len;i++){
            			if(this.options.value[i].title == null || this.options.value[i].title == ''){  	
            				this.options.value[i].title = this.options.value[i].name;
            			}
            			chooseData.push(this.options.value[i].title);
                    }
            	}else{
            		chooseData = this._buildSelect();
            	}
            }
            if(!this.options.textmode&&(this.options.isAllowOther||this.options.isSearch)){
            	chooseData.push('<input id="');
            	chooseData.push(this.options.id+'_choose_input"  class="choose_input" ');
            	if(opts.chooseMode==1&&this.options.value.length==1){
            		chooseData.push(" style='display:none;' ");
            	}
            	chooseData.push(' type="text"/>');
            }
            if(!this.options.textmode&&this.options.isSearch){  
            	searchDiv.push('<div id="searchDiv_'+this.options.id+ '" class="search_div">');
            	searchDiv.push('<div id="queryDataArea_'+this.options.id+'" class="queryList" ></div>');
            	//更多数据...
            	searchDiv.push('<div id="moreData_'+this.options.id+'" class="more_data"><a href="#" hidefocus="true">\u66f4\u591a\u6570\u636e...</a></div>');
            	searchDiv.push('</div>');
            	$('body').append(searchDiv.join(""));
            } 
            
            //隐藏域
            this._createHiddenInput();
            //标签初始化的时候，去除这个给隐藏域设置值的语句，给隐藏域设置值需要通过setValue方法来。因为下面这个逻辑在资产会导致将人家之前的值给清空
            //this._setHiddenElement(this.options.value);
            var varOpenWin = '<a id="'+this.options.id+'_open" flag="openWin" href="#" class="'+(this.options.uitype==="ChooseOrg"?"icon_org":"icon_user")+'" ></a>';
            if(!this.options.canSelect){
            	varOpenWin = "";
            }
            
            //元素结构
            inputHtml = [
                         '<div class="choose_box_wrap" style="width:',
                          this.options.width,'">',
                          '<div id="',
                          this.options.id,'_choose_box" class="choose_box" style="height:',
                          this.options.height,';width: 100%;">',
                          chooseData.join(this.options.textmode?";":""),
						'</div>',
						//searchDiv.join(""),
						'</div>',
						varOpenWin
            ];
            $el.html(inputHtml.join(""));
        },
        
        /**选择后，将选择的值写入隐藏域中
         * @param formEle 表单元素
         * @param eleName 隐藏域元素名称 
         * @param value 要设置的值
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
         * 根据表单名创建表单元素
         * data为空时，清空隐藏域的值
         */
        _setHiddenElement:function(data){
        	var opts = this.options;
        	if(opts.idName){
        		//根据idName属性判断，如果未指定，则不处理
        		var ids=[],names=[],codes=[];
        		var nameKey = "name";
        		if(opts.uitype==='ChooseOrg'&&opts.showLevel!=-1&&opts.isFullName){
        			//组织标签且指定fullName
        			nameKey="fullName";
        		}
        		for(var i=0,j=data.length;i<j;i++){
        			ids.push(data[i]["id"]);
        			names.push(data[i][nameKey]);
        			codes.push(data[i]["orgCode"]);
        		}
        		
        		//if(opts.formName == '' || opts.formName == null){
        		//	return ;
        		//}
        		var formElement ;
        		if(opts.formName){
        			formElement= document.forms[opts.formName];
        		}
        		
        		this._setValueToHidden(formElement,opts.idName,ids.join(";"));
        		this._setValueToHidden(formElement,opts.valueName,names.join(";"));
        		this._setValueToHidden(formElement,opts.opts.codeName,codes.join(";"));
        		//if(typeof(formElement) == 'undefined'){
        			//未找到表单元素
        		//	cui.alert("\u672a\u627e\u5230\u8868\u5355\u5143\u7d20" + opts.formName);
        		//	return ;
        		//}
        		
        		/*var idEle =formElement[opts.idName],valueEle =formElement[opts.valueName],codeEle;
        		if(opts.opts&&opts.opts.codeName){
        			codeEle=formElement[opts.opts.codeName];  
        		}
        		if(idEle){
        			idEle.value=ids.join(";");
        		}
        		if(valueEle){
        			valueEle.value=names.join(";");
        		}
        		if(codeEle){
        			codeEle.value=codes.join(";");
        		}*/
        	}
        },
        
        /**
         * 全局点击处理
         * @param {Event} e 
         */
        _clickHandler:function(e){
        	var target = e.target;
    		switch(target.nodeName){
    		case 'A':
    			this._aHandler(target);
    			//e.preventDefault();
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
         * 按向上键
         * @private
         */
        __keyDownUPHandler: function () {
        	var className = this.options.uitype==='ChooseOrg'?".dept_query":".user_query";
        	var currentClassName = this.options.uitype==='ChooseOrg'?"current_dept":"current_user";
            var queryDataArea = $("#queryDataArea_"+this.options.id),
            	len = queryDataArea.find(className).length,
                list, hoverIndex;
            if (len) {
                list = queryDataArea.find(className);
                hoverIndex = this.hoverIndex;
                if (typeof hoverIndex === "undefined") {
                    //刚展开状态
                    hoverIndex = len - 1;
                    list.removeClass(currentClassName);
                    list.eq(hoverIndex).addClass(currentClassName);
                } else {
                	 //移除前一条高亮
                    list.eq(hoverIndex || 0).removeClass(currentClassName);
                    //实现循环
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
         * 按向下键
         * @private
         */
        __keyDownDownHandler: function () {
        	var className = this.options.uitype==='ChooseOrg'?".dept_query":".user_query";
        	var currentClassName = this.options.uitype==='ChooseOrg'?"current_dept":"current_user";
            var queryDataArea = $("#queryDataArea_"+this.options.id),
                len = queryDataArea.find(className).length,
                list,
                hoverIndex;
            if (len) {
                list =queryDataArea.find(className);
                hoverIndex = this.hoverIndex;
                if (typeof hoverIndex === "undefined") {
                    //刚展开状态
                    hoverIndex = 0;
                    list.removeClass(currentClassName);
                    list.eq(hoverIndex).addClass(currentClassName);
                } else {
                    //移除前一条高亮
                    list.eq(hoverIndex || 0).removeClass(currentClassName);
                    //实现循环
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
         * 清除高亮
         * @private
         */
        __clearHover: function () {
            var hoverIndex = this.hoverIndex;
            if (typeof hoverIndex !== "undefined") {
            	var className = this.options.uitype==='ChooseOrg'?".dept_query":".user_query";
            	var currentClassName = this.options.uitype==='ChooseOrg'?"current_dept":"current_user";
                var queryDataArea = $("#queryDataArea_"+this.options.id),
                    list;
                list =queryDataArea.find(className);
                list.eq(hoverIndex).removeClass(currentClassName);
                delete this.hoverIndex;
            }
        },
        
        /**
         * DIV标签点击处理
         * @param {HTMLElement} tg 
         */
        _divHandler:function(tg){
        	$('#'+this.options.id+'_choose_input').focus();
        },
        /**
         * a标签点击处理
         * @param {HTMLElement} tg 
         */
        _aHandler:function(tg){
        	var $tg = $(tg);
    		if($tg.attr('flag') == 'del'){
    			this._deleteData($tg.parent().attr('id'));
    		}else{
    			var winWidth;//弹出窗宽度
            	var winHeight = 536;//弹出窗高度
            	var offsetLeft;//弹出窗位置
	        	var offsetTop;//弹出窗位置
    			if($.browser.chrome){//谷歌浏览器
    				winWidth = this.options.chooseMode==1?342:505;
    				
    				offsetLeft=300;
					offsetTop=130;
    			}else{
    				winWidth = this.options.chooseMode==1?335:505;
    				 
    				offsetLeft=300;
					offsetTop=250;
    			}
    			var dialog ;
    			if(window.top.cuiEMDialog&&window.top.cuiEMDialog.dialogs){
    				dialog = window.top.cuiEMDialog.dialogs["topdialog_"+this.options.id];
    			}
    			var url;
    			url = webPath + "/top/sys/usermanagement/orgusertag/ChoosePage.jsp?id=" + this.options.id+"&chooseType="+this.options.uitype;
    			//"选择人员":"选择组织"
    			var winTitle =this.options.uitype==='ChooseUser'?"\u9009\u62e9\u4eba\u5458":"\u9009\u62e9\u7ec4\u7ec7";
    			//多选布局调整后，宽度增加
    			if(this.options.chooseMode!=1){
    				winWidth = winWidth+30;
    			}else{
    				winWidth=winWidth-28;
    			}
    			if(!dialog){
	    			dialog =cui.extend.emDialog({
	    				id:"topdialog_"+this.options.id,
	    				title:winTitle,
	    				//为了修改了editablegrid结合时的缺陷，去掉了滚动条属性
	    				modal:true,
	    				src:url,
	    				width:winWidth,
	    				height:winHeight
	    			});
    			}else{
    				dialog.reload(url);
    			}
    		 	dialog.show();
    		}
        },
        /**
         * 删除数据
         * @param {主键} id 
         */
        _deleteData:function(id){
            //已选择的数据
        	var selected = this.options.value;
        	var data;
        	//把传进来的id减去程序加上的当前标签id
        	id= id.replace(this.options.id,"")
    		for(var i=0;i<selected.length;++i){
    			if(selected[i].id==id){
    				 //移除删掉的数据并保存被删除的数据
    				data = selected.splice(i,1);
    			}
    		}

    		this.setValue(selected);
    		if(this.options.chooseMode == 1&&this.options._defaultInputWidth>0){ 
				//因为选中的时候进行了调整
				$(".choose_input").width(this.options._defaultInputWidth);
			}
    		if(this.options.delCallback){
				this.options.delCallback(data,this.options.id);
			}
    	},
    	/**
         * 判断数据是否已被选择
         * @param {主键} id 
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
         * 追加选择数据
         * @param {数据} data
         */
    	_appendData:function(data){
    		if(this.options.chooseMode>0&&this.options.value.length==this.options.chooseMode){
//    			cui.alert('最多选择'+this.options.chooseMode+'条记录');
    			cui.alert('\u6700\u591a\u9009\u62e9'+this.options.chooseMode+'\u6761\u8bb0\u5f55');
    			return;
    		}
    		if(!this._isSelected(data.id)){
    			this.options.value.push(data);
    			this.setValue(this.options.value);
    			if(this.options.callback){
    				this.options.callback(this.options.value,this.options.id);
    			}
    		}
    	},
    	/**
         * 去除选择数据
         */
    	_popData:function(){
			var data = this.options.value[this.options.value.length-1];
			if(data){
				var id = data.id;
				this._deleteData(id);
			}
    	},
    	/**
         * 设置选择数据
         * @param {数据集合} data 
         */
        setValue:function(data, isInit){
    		if(!data){
    			data = [];
    		}
    		if(!$.isArray(data)){
    			  data=[data]; 
    		}
    		data = $.extend(true, [], data);
    		this.options.value = data;
    		var len = this.options.value.length;
    		
    		//先清除之前的
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
//    			this.$el.html(html.join(";"));
    			chooseBox.html(html.join(";"));
    			this.__renderTextMode();
//    			return;
    		}else if(this.options.isSearch||this.options.isAllowOther){
    			var chooseInput = $("#"+this.options.id+"_choose_input",this.options.el);
    			var html=this._buildSelect();
    			chooseInput.before(html.join(""));
    			chooseInput.val("");
    			if(this.options.chooseMode==1&&this.options.chooseMode == this.options.value.length){
    				chooseInput.hide();
    			}else{
    				chooseInput.show();
    			}
//    			chooseInput.focus();
    		}else{
    			var chooseBox = $("#"+this.options.id+"_choose_box");
    			var html = this._buildSelect();
    			chooseBox.append(html.join(""));
    		}
    		
        	//设置表单提交域的值
        	this._setHiddenElement(data);
    		//如果是只能选一个，那么要调整下input框的宽度  this.options.chooseMode == 1&&
        	var _inputWidth = $(".choose_input").width();
			if(_inputWidth != null &&_inputWidth !=undefined&&this.options.value!=null&&len >0){
				var _inputWidthInt = 0;
				if(!$.isNumeric(_inputWidth)){ //转换成数值
					_inputWidth = _inputWidth.replace("px","");
					_inputWidthInt = parseInt(_inputWidth);
				}else{
					_inputWidthInt = _inputWidth;
				}
			}
        	isInit || this._triggerHandler('change');
        },
      
        //判断是否多选
        _getMultiStype:function(){
        	return this.options.chooseMode!=1?"block_cross_multi":"";
        },
        /**
         * 拼接已经选择记录的html块
         * */
        _buildSelect:function(){
        	var html = [],len = this.options.value.length;
        	var multiStyle = this._getMultiStype();
        	var blockStyle="";
			for(var i=0;i<len;i++){
				if(!this.options.value[i].title){  	
    				this.options.value[i].title = this.options.value[i].name;
    			}
    			if(this.options.value[i].title && this.options.value[i].id){  
    				blockStyle = this.options.value[i].isOther?"block_cross_other":"block_cross";
    				html.push('<div class="'+blockStyle+' '+ multiStyle + '" title="'+this.options.value[i].title+'" id="'+this.options.id+this.options.value[i].id+'"><span class="c_content">'+this.options.value[i].title+'</span><a flag="del" href="#" class="block_delete"></a></div>');
    			}
			}
			return html;
        },
        /**
         * 获取选择数据 
         */
        getValue:function(){
        	return $.extend(true, [], this.options.value);
        },
        /**
         * 设置是否只读
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
         * 设置属性
         * @param {属性名} name 
         * @param {属性值} value 
         */
        setAttr: function(name,value){
        	if(name=='rootId'){
        		this.options.rootId=value;
        		this.options.el.attr('rootId', value);
        	}
         	if(name=='defaultOrgId'){
        		this.options.defaultOrgId=value;
        		this.options.el.attr('defaultOrgId', value);
        	}
         	if(this.options.uitype==="ChooseOrg"&&name==="unselectableCode"){
         		this.options.el.attr("unselectableCode",value);
         	}
         	
        },
        /**
         * 数据错误回调方法
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
	        //设置tip类型，错误
            $(self.tipPosition, opts.el).attr('tipType', 'error');
        },

        /**
         * 数据正确回调方法
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
        		//隐藏提示
        		var $cuiTip = cui.tipList[tipID];
        		typeof $cuiTip !== 'undefined' && $cuiTip.hide();
        	}
        	opts.el.attr("tip", opts.tipTxt);
        	//设置tip类型，正常
        	$(self.tipPosition, opts.el).attr('tipType', 'normal');
        },
        
        /**
         * 快速匹配输入框失去焦点处理
         * @param e 事件
         */
        _blurHandler: function(){
//        	var input = $("#"+this.options.id+"_choose_input");
//        	input.val('');
        	this._closeFastDataDiv("searchDiv_"+this.options.id);
//        	input.focus();
        },
        
        /**  从新版人员组织标签迁移开始  *  */
        /**
         * 截取部门全名中的本部门名，用于部门快速搜索的提示框中显示
         */
        _subDepartmentFullName:function(deptFullName,name){
        	// 获得部门全名中最后一个"/"的位置
        	var iEnd = deptFullName.lastIndexOf($.trim(name));
        	// 返回截取后的部门
        	if(iEnd > 0){
        		return deptFullName.substring(0,iEnd);
        	}else{
        		return "";
        	}
        },
        
        /**
         * 组装检索下拉div数据
         * @param divObj 检索框相关divid 
         * @param data 数据
         * @param operatorType 操作类别
         */
        _installData:function(divObj,data,operatorType){
        	var totalPage = Math.ceil(data.count/this.pageSize) ;
        	var objDiv = this._buildListItemTemplate(data);
        	
        	// 如果是组织结构tab页的检索框
        	if(operatorType=="add"){
        		$('#'+divObj.queryDataAreaDiv).append(objDiv);
        	}else if(operatorType=="replace"){
        		$('#'+divObj.queryDataAreaDiv).height("");
        		$('#'+divObj.queryDataAreaDiv).html(objDiv);
        	}
        	// 如果是根部门，则单行显示
//        	if(this.options.rootId != ""&&this.options.uitype==="ChooseOrg"){
//        		$("#"+prefixOfQueryA+this.options.rootId).css("height","20px");
//        	}
        	//如果查询出来的数据条数大于每页显示条数，则显示更多数据。
        	if(this.pageNo==totalPage){
        		$("#"+divObj.moreDataDiv).css('display','none');
        	}else{
        		$("#"+divObj.moreDataDiv).css('display','block');
        	}
        },
        
        /**
         * 滚动到焦点位置
         * @param {number} positionIndex
         * @private
         */
        __scrollHoverPosition: function (positionIndex) {
        	var currentClassName = this.options.uitype==='ChooseOrg'?".current_dept":".current_user";
        	var $box= $("#queryDataArea_"+this.options.id),
        	scrollTop = $box.scrollTop(),
            $ele = $(currentClassName),
            boxHeight = $box.height(),
            lineHeight = $ele.outerHeight(),
            offsetTop = $ele[0].offsetTop;
    	    if (scrollTop > offsetTop) {
    	    	$box.scrollTop(offsetTop);
    	    } else if (scrollTop < offsetTop + lineHeight - boxHeight) {
    	    	$box.scrollTop(offsetTop + lineHeight - boxHeight);
    	    }
        },
        /**
         * 搜索结果下拉框的展示或隐藏方法
         */
         _showOrDisplay:function(objDiv,queryClass){
        	var outDiv = $("#"+objDiv.containerDiv).parent();//获取标签外层的div
        	var tmpSearchDiv = $("#"+objDiv.searchDiv);
        	var $queryDataArea=$('#'+objDiv.queryDataAreaDiv);
        	// 先隐藏模板拼接的数据，避免数据量大把document撑大，在后面再show()
//        	var scollLocation =$queryDataArea.scrollTop();
        	$queryDataArea.hide();
        	var pageHeight = $(document).height();
        	// 展现模板拼接的数据
        	$queryDataArea.show();
        	$queryDataArea.scrollTop(0);
        	var searchDivMaxHeight;
        	//下面空白的高度
        	var downHeight = pageHeight - outDiv.offset().top-outDiv.height();
        	//上面的高度
        	var upHeight =outDiv.offset().top;
        	var defaultHeight = 200;
        	//是否在上面显示
        	var displaySpecial = false;
        	//下面的高度不够，并且上面高度比下面的高时
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
        	// 判断是否有“更多数据”,5个像素是测试时，发现上下偏移5个像素才能显示边框，具体原因需后面跟踪
        	if("none" !=$("#"+objDiv.moreDataDiv).css('display')){
        		var heightOfMoreDataDiv = $("#"+objDiv.moreDataDiv).height();
        		searchDivMaxHeight = searchDivMaxHeight - heightOfMoreDataDiv - 5
        	}
        	var listLength = $("."+queryClass).length;
        	//判断是否有返回内容
        	if(listLength > 0){
        		this._openFastDataDiv(objDiv.searchDiv,searchDivMaxHeight,displaySpecial);
        	}else{
        		this._closeFastDataDiv(objDiv.searchDiv);
        	}
        },
        /**
         * 关闭快速查询的数据DIV
         */
        _closeFastDataDiv:function(searchDiv){
        	// 收回div时重置currentIndex
        	this.__clearHover();
    		this.cacheData = null;
    		this.pageNo = 1;
        	var tmpSearchDiv = $("#"+searchDiv);
        	tmpSearchDiv.css("z-index",'');
        	var queryDataArea = $("#queryDataArea_"+this.options.id);
        	queryDataArea.children().remove();
        	tmpSearchDiv.children().hide();
        	tmpSearchDiv.slideUp("fast");
        	var input = $("#"+this.options.id+"_choose_input");
        	if(!input.is(":hidden")){
        		//没有隐藏
        		input.val('');
        		input.focus();
        	}
        },
        /**
         * 显示快速查询的数据DIV
         */
         _openFastDataDiv:function(searchDiv,searchDivMaxHeight,displaySpecial){
        	//打开查询框时初始化当前页码
//        	this.pageNo = 1;
        	var hiddenFrame = $("#"+searchDiv);
        	hiddenFrame.show();
        	var $chooseBoxWrap = $("#"+this.options.id +"_choose_box").parent();
//        	$("#"+searchDiv).parent().css("z-index",999);
        	var tepWidth = $chooseBoxWrap.innerWidth();//$("#"+searchDiv).prev().innerWidth();
//        	/*if(tepWidth<300){ //此处会导致宽度不一致
//        		tepWidth =300;
//        	}*/
        	$("#moreData_"+this.options.id).css("width",tepWidth);
        	$("#"+searchDiv).width(tepWidth+"px");
        	$("#"+searchDiv).slideDown("fast");
//        	//设置搜索框的高度
        	var dataArea = $('#queryDataArea_'+this.options.id);
        	if(dataArea.height() > searchDivMaxHeight){
        		dataArea.css('height',searchDivMaxHeight+'px')
        	}
        	var frameHeight  = dataArea.height();
        	// 如果有“更多数据”
        	if("none" !=$("#moreData_"+this.options.id).css('display')){
        		var heightOfMoreDataDiv = $("#moreData_"+this.options.id).height();
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
        	hiddenFrame.css("width",($("#"+searchDiv).width())+"px");
        	hiddenFrame.css("height",frameHeight+"px");
        },
    	
    	//处理快速查询关键字字符串
    	 _handleStr:function(str){
    		str = str.replace(new RegExp("/", "gm"), "//");
    		str = str.replace(new RegExp("%", "gm"), "/%");
    		str = str.replace(new RegExp("_", "gm"), "/_");
    		str = str.replace(new RegExp("'", "gm"), "''");
    		return str;
    	},
    	
    	/**
    	 * 展示更多数据
    	 */
    	 _showMoreData:function(){
    		this.pageNo++;
    		var moreData = $("#moreData_"+this.options.id);
    		moreData.removeClass("more_data");
    		moreData.addClass("more_data_disable");
    		this._fastQuery("add");
    		$("#"+this.options.id+"_choose_input").focus();
    	},
        
    	/**
         * 输入框键盘按下处理
         * @param {Event} e 
         */
        _keyup:function(e){
    		if(!(e.keyCode>=KEYCODE_ARROW_LEFT&&e.keyCode<=KEYCODE_ARROW_DOWN)){//非向下向上键
        		this.pageNo=1;
        		var self = this;
    			window.clearTimeout(this.fastQueryFunc);
    			window.clearTimeout(this.tempNoDataFunc);
    			
        		this.fastQueryFunc = setTimeout(function(){
 		   		  		self._fastQuery("replace");
 		   		  	},100);
        	}
        },
        
        /**
         * 回车
         * @private
         */
        __keyDownEnterHandler: function(){
        	this._selectRow();
        }
        
    });
    
    /**
	 * 定义设置全局配置的方法
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
    		uitype: 'ChooseUser',//组件类型
    		userType: 0//用户类型：1在职，2离职，0全部
    	},
    	/**
    	 * 根据传递过来的id，查询相关信息*/
    	_getSelectedById:function(ids){
    		var tData = null;
    		dwr.TOPEngine.setAsync(false);
    		ChooseAction.getUsersByIds(ids,this.options.userType,function(data){
    			tData = data;
    		});
    		dwr.TOPEngine.setAsync(true);
    		return tData;
    	},
        /**
         * 获取当前选中的行
         * */
        _selectRow:function(){
        	var hoverIndex = this.hoverIndex;
        	var data={};
        	if (typeof hoverIndex !== "undefined"&&this.cacheData!=null&&this.cacheData.length>0) {
        		var record = this.cacheData[hoverIndex];
				data.id = record.key;
				data.orgCode = record.orgcode;
				data.name =record.title;
    			data.fixPhone = record.fixPhone;
    			data.mobilePhone = record.mobilePhone;
    			data.orgName = record.orgName;
    			data.orgId = record.orgId;
	    		if(this.options.showLevel == -1){
					data.title = record.title;
				}
	    		this._appendData(data);
        	}else if(this.options.isAllowOther&&$.trim($('#'+this.options.id+'_choose_input').val())){//保存外部数据
        		this._textCounter();
            	data.id = $('#'+this.options.id+'_choose_input').val();
            	data.name = $('#'+this.options.id+'_choose_input').val();
            	data.isOther = true;
            	this._appendData(data);
    		}
        	
        	this._blurHandler();
        },
        
    	/**
         * 快速查询用户
         * @param {Event} e 
         */
        _fastQuery:function(operatorType){
    		var keyword =$.trim( this._handleStr($('#'+this.options.id+'_choose_input').val()));
    		 
    		if(keyword==""){
    		   this._closeFastDataDiv('searchDiv_'+this.options.id);
               this._closed=true;
    		   return;
    		}
    		
    		this._closed=false;
    		 
    		var self = this;
    		var obj = {};
    		obj.keyword = keyword;
    		obj.userType = this.options.userType;
			obj.orgStructureId = this.options.orgStructureId;
			obj.rootDepartmentId = this.options.rootId;
			obj.pageNo = this.pageNo;
			obj.pageSize = this.pageSize;
			var divObj = {};
			divObj.searchDiv="searchDiv_"+this.options.id;
			divObj.queryDataAreaDiv = "queryDataArea_"+this.options.id;
			divObj.moreDataDiv = "moreData_"+this.options.id;
			divObj.containerDiv = this.options.id+"_choose_box";
			dwr.TOPEngine.setAsync(false);
    		ChooseAction.fastQueryUserPagination(obj,function(data){
    			if(self._closed===true){
    				return;
    			} 
    			if(data.count==0){
    				self.cacheData=null;
		   		  	$("#moreData_"+self.options.id).css('display','none');
		   		  	$('#queryDataArea_'+self.options.id).height("");
		   		  	//未查到该人员
		   		  	$('#queryDataArea_'+self.options.id).html('<span class="no_data" >&nbsp;\u672a\u67e5\u5230\u8be5\u4eba\u5458</span>');
		   		  	self._showOrDisplay(divObj,"no_data");
	   		  		clearTimeout(self.tempNoDataFunc);
		   		  	self.tempNoDataFunc = setTimeout(function(){
		   		  		self._closeFastDataDiv("searchDiv_"+self.options.id);
		   		  	},2000);
		   		}else{
		   			if(operatorType==="replace"){
		   				self.__clearHover();
		   				self.cacheData = data.list;
		   			}else{
		   				$.each(data.list,function(){
		   					self.cacheData.push(this);
		   				});
		   			}
		   			self._installData(divObj,data,operatorType);
					self._showOrDisplay(divObj,"user_query")
					var moreData = $("#"+divObj.moreDataDiv);
					moreData.removeClass("more_data_disable");
					moreData.addClass("more_data");
		   		}
    		});
    		dwr.TOPEngine.setAsync(true);
        },
        /**
         * 标示出人员名称相同的数据，方面后续展现不同的效果
         */
         _sameNameDispose:function(data,tempCount){
        	var sameCount = 1;
        	for(var i =0;i<tempCount;i+=sameCount){
        		//人员名称相同时重标示出来
        		//由于后台数据查询时已经将根据人员名称排序，所以部门名称相同的数据都放在一起了，只需要比较相邻的数据即可
        		sameCount = 1;
        		for(var j=i+1;j<tempCount;j++){
        			if(data[i].title == data[j].title){
        				data[i].hasSameName = true;
        				data[j].hasSameName = true;
        				//避免重复比较
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
         * 获取人员搜索下拉框模板html代码
         * @param data,查询结果，包括count,list
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
         * 获取搜索下拉框模板
         */
        _getMenuItemTemplate:function(data,i) {
        	var iCurrent = i+this.pageSize*(this.pageNo-1);
        	//如果是同名的人员，使用两行的样式展现。
        	if(data.hasSameName){
        		// 获得用户所在部门的上级部门全名
        		var subDeptFullName = this._subDepartmentFullName(data.fullName,data.orgName);
        		//由于在给每个搜索结果添加事件时，要用到className，所以给他添加user_query的class，但是同名的人员要用另外一种样式展现，所以加上style属性，覆盖user_query样式。
        		var userClass= "";
        		if(data.hasCutoffLine){
        			userClass = "user_query user-same-name user-same-name-last"
        		}else{
        			userClass = "user_query user-same-name";
        		}
        		var bufferDouble = [
        		               		"<a href='#' class='"+userClass+"' " +
        		               		"id='",prefixOfQueryA,data.key,"' index='",iCurrent,"'>",
        		        	    		"<span class='user-name' title='",data.title, "'>",data.title,"</span>",
        		        	    		"<span class='user-deptname'>",data.orgName,"</span>",
        		        	    		"<span class='user-deptfullname' title='",subDeptFullName,"'>",subDeptFullName,"</span>",
        		            		"</a>"
        		        	    	];
	        	return bufferDouble.join("");
        	}else{
        		var bufferDouble = [
        		               		"<a href='#' class='user_query' id='",prefixOfQueryA,data.key,"' index='",iCurrent,"'>",
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
    		uitype: 'ChooseOrg',//组件类型
    		showLevel:-1, //组织标签中输入框的展示层级,-1:当前选中的节点名,1:全路径展示,其他数字为展示的初始层级	
    		showOrder:"order",  //全路径显示顺序，reverse:倒序，order:正序
    		levelFilter:999,	//组织标签中树型展示时，展示到的级别。-1:全部显示,其它值：则根据top_org_type_relation中的org_type_id
    		//展示到指定的级别
    		unselectableCode:"",//不允许选择的组织Code
    		isFullName:false//指定当使用了showLevel属性、valueName属性时，valueName隐藏域中的值是否也保存全路径，默认为false
    	},
    	/**
    	 * 根据传递过来的id，查询相关信息*/
    	_getSelectedById:function(ids){
    		var tData = null;
    		dwr.TOPEngine.setAsync(false);
    		ChooseAction.getOrgsByIds(ids,function(data){
    			tData = data;
    		});
    		dwr.TOPEngine.setAsync(true);
    		return tData;
    	},
        /**
    	 * 获取搜索下拉框模板;
    	 * @param obj :
    	 * prefixOfQueryA
    	 * className
    	 * firstClassName
    	 * lastClassName
    	 * lineClassName
    	 * 还包括数据节点对象
    	 */
    	_getMenuItemTemplate:function(obj,i) {
    		//单行显示判断，指定rootId时根据rootId来判断，否则根据路径判断
    		var subDeptFullName = "";
    		var tmpRootId = this.options.rootId;
    		if(tmpRootId&&tmpRootId===obj.key){
    			//如果是根节点，则直接显示名称
    			subDeptFullName = obj.fullName;
    		}else{
    			// 获得部门的上级部门全名
    			subDeptFullName = this._subDepartmentFullName(obj.fullName,obj.title);
    		}
    		var iCurrent = i+this.pageSize*(this.pageNo-1);
    		// 如果是系统根部门，即部门fullname中没有上级部门，则采用单行显示
    		if(subDeptFullName == ""){
    			// 创建单行模板
    			var bufferSingle = [
    		       		"<a href='#' class='",
    		       		obj.className,"' id='",prefixOfQueryA,obj.key,"'","orgreadonly='",obj.unselectable, "' index='",iCurrent,"' style='height:20px;'>",
    			    		"<span class='", obj.firstClassName, "'>",obj.title,"</span>",
    		    		"</a>"
    			       	];
    			return bufferSingle.join("");
    		}else{
    			// 非根部门则采用双行显示
    			var bufferDouble = [
    		       		"<a href='#' class='",obj.className,"' id='",prefixOfQueryA,obj.key,"'","orgreadonly='",obj.unselectable, "' index='",iCurrent,"'>",
    			    		"<span class='", obj.firstClassName, "'>",obj.title,"</span>",
    			    		"<span class='", obj.lastClassName, "' title='",subDeptFullName,"'>",subDeptFullName,"</span>",
    		    		"</a>"
    			       	];
    			return bufferDouble.join("");
    		}
    	},
    	
        /**
         * 获取人员搜索下拉框模板html代码
         * @param data,查询结果，包括count,list
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
         * 获取当前选中的行
         * */
        _selectRow:function(){
        	var hoverIndex = this.hoverIndex;
        	var data={};
        	if (typeof hoverIndex !== "undefined"&&this.cacheData!=null&&this.cacheData.length>0) {
        		var curDept = $("#queryDataArea_"+this.options.id).find(".dept_query").eq(hoverIndex);
        		var readonly =$(curDept).attr("orgreadonly"); 
        		if(readonly==="true"||readonly==true){
        			return false;
        		}
        		var record = this.cacheData[hoverIndex];
				var fullName = record.fullName;
				data.id = record.key;
				data.orgCode = record.orgCode;
				data.name = record.title;
    			if(fullName){
    				data.fullName = fullName+data.name;
    			}else{
    				data.fullName = data.name;
    			}
    		
	    		if(this.options.showLevel == -1){
					data.title = record.title;
				}else if(this.options.showLevel == 1){
					if(this._spliceFullPath){
						data.title = this._spliceFullPath(record.fullName);
					}else{
						data.title = record.fullName;
					}
				}else{
					dwr.TOPEngine.setAsync(false);
					ChooseAction.obtainShowOrgTitle(this.options.orgStructureId,data.id,this.options.showLevel,function(title){
						if(this._spliceFullPath){
							data.title = this._spliceFullPath(title);
						}else{
							data.title = title;
						}
					});
					dwr.TOPEngine.setAsync(true);
				}
	    		this._appendData(data);
        	}else if(this.options.isAllowOther&&$.trim($('#'+this.options.id+'_choose_input').val())){//保存外部数据
        		this._textCounter();
            	data.id = $('#'+this.options.id+'_choose_input').val();
            	data.name = $('#'+this.options.id+'_choose_input').val();
            	data.isOther = true;
            	this._appendData(data);
    		}
        	this._blurHandler();
        },
    	/**
         * 快速查询组织
         * @param paramObj 参数对象 keyword,orgStructureId,rootDepartmentId
         * @param divObj 快速查询显示框相关div的id containerDiv,searchDiv,queryDataAreaDiv,moreDataDiv
         * @param operatorType 操作类别 replace add
         */
        _fastQuery:function(operatorType){
        	var self = this;
        	var keyword = this._handleStr($('#'+this.options.id+'_choose_input').val());
    		keyword=$.trim(keyword);
    		if(keyword==''){
    			this._closeFastDataDiv('searchDiv_'+this.options.id);
    			this._closed===true;
    			return;
    		}
    		this._closed=false;
    		var obj = {};
    		obj.keyword = keyword;
    		obj.orgStructureId = this.options.orgStructureId;
    		obj.rootDepartmentId = this.options.rootId;
    		obj.pageNo = this.pageNo;
    		obj.pageSize = this.pageSize;
    		obj.levelFilter = this.options.levelFilter;
    		
			var divObj = {};
			divObj.searchDiv="searchDiv_"+this.options.id;
			divObj.queryDataAreaDiv = "queryDataArea_"+this.options.id;
			divObj.moreDataDiv = "moreData_"+this.options.id;
			divObj.containerDiv = this.options.id+"_choose_box";
			dwr.TOPEngine.setAsync(false);
    		ChooseAction.fastQueryOrgPagination(obj,this.options.unselectableCode,function(data){
    			if(self._closed===true){
    				return;
    			} 
    			if(data.count==0){
    				 self.cacheData = null;
			   		 $("#"+divObj.moreDataDiv).css('display','none');
			   		 $('#'+divObj.queryDataAreaDiv).height("");
			   		 // 未查到该组织
	  				 $('#'+divObj.queryDataAreaDiv).html('<span class="no_data" >&nbsp;\u672a\u67e5\u5230\u8be5\u7ec4\u7ec7</span>');
	  				 self._showOrDisplay(divObj,"no_data");
	  				 clearTimeout(self.tempNoDataFunc);
			   		  self.tempNoDataFunc = setTimeout(function(){
			   		  	 self._closeFastDataDiv(divObj.searchDiv);
			   		  },2000);
		   		}else{
		   			if(operatorType==="replace"){
		   				self.cacheData = data.list;
		   			}else{
		   				$.each(data.list,function(){
		   					self.cacheData.push(this);
		   				});
		   			}
		   			self._installData(divObj,data,operatorType);
		   			self._showOrDisplay(divObj,"dept_query");
		   			var moreData = $("#"+divObj.moreDataDiv);
					moreData.removeClass("more_data_disable");
					moreData.addClass("more_data");
		   		}
    		});
    		dwr.TOPEngine.setAsync(true);
        },
        
        /**
         * 拼接显示全路径
         */
        _spliceFullPath:function(fullPathName){
        	var strFullPathName = fullPathName;
        	if(this.options.showOrder == 'reverse'){
        		var pathName = strFullPathName.split('/').reverse();
        		strFullPathName = pathName.join('/');
        	}
        	return strFullPathName;
        }
    });
	
})(window.comtop.cQuery, window.comtop);

