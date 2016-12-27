/**
 * 模块: CUI组件 AutoGenNumber类
 * 描述: 继承自Input组件基础。
 */
;(function(C){
	"use strict";
	var $ = C.cQuery;
	var action = (webPath || '/web') + '/cip/genNumber.ac';
	C.UI.AutoGenNumber = C.UI.Input.extend({
	    options : {
	        uitype: "AutoGenNumber",
	        expression:'',
	        showOnNew:false,
	        params:''
	    },
	
	    /**
	     * 获取输入框文字
	     * @returns {string}
	     */
	    getExpression: function () {
	        return this.options.expression;
	    },
	    
	    /**
	     * 更新控件的值
	     * @returns {string}
	     */
	    updateValue : function(){
	      var opts = this.options, self = this;
	      if(!opts.expression){
	    	  return;
	      }
	      var param = {};
	      if(opts.params){
	    	  param = $.parseJSON(opts.params);
	      }
	      $.ajax({
              url: action,
              method:"post",
              data: {"expression":opts.expression,"params":param},
              dataType:"json",
              async: false,
              success: function(data){
                  if(data.code === "200"){
                	  self.setValue(data.number);
                	  return;
                  }else{
                	  console.log("自动生成编码出错！");
                  }
              },
              error:function(xhr, status, err ){
            	  console.log("自动生成编码出错！" + err);
              }
          });
	    }
	});
})(window.comtop);


/**
 * 扩展Calender组件，支持默认值文当前时间
 */
;(function(C, $){
    var Calender = C.UI.Calender.prototype;
    Calender._init = function(cusOpts){
    	var self = this,
        opts = self.options;

	    if(cusOpts.value){
	        var type = $.type(cusOpts.value);
	        switch(type){
	            case 'string':
	            	if("$current" === cusOpts.value){
	            		var format = cusOpts.format;
	            		if(!format){
	            			format = 'yyyy-MM-dd';
	            		}
	            		var now = new Date();
	            		var current = C.Date.format(now, format);
	            		opts.value = [current];
	            	}else{
		                opts.value = /^(?:\{.*\}|\[.*\])$/.test(cusOpts.value) ?
		                    $.parseJSON(cusOpts.value.replace(/\\'/g, '#@@#').replace(/'/g, '"').replace(/#@@#/g, '\'')):
		                    [cusOpts.value];
	            	}
	                break;
	            case 'array':
	                opts.value = cusOpts.value;
	                break;
	            default:
	                opts.value = [cusOpts.value];
	        }
	    }
	    if(cusOpts.width){
	        if(typeof cusOpts.width === 'string' && /^(\d)+(px|pt|em|PX|PT|EM|%)$/.test(cusOpts.width)){
	            opts.width = cusOpts.width;
	        }else {
	            opts.width = cusOpts.width + 'px';
	        }
	    }
	    opts.value = opts.value === null ? [] : opts.value;
	    //[最大最小限制规则, 生成的限制日期]
	    opts.mindate = [cusOpts.mindate, null];
	    opts.maxdate = [cusOpts.maxdate, null];
	
	    //下面的参数不开放配置
	    opts.uuid = C.guid();                           //组件内部随机ID
	    opts.template = 'calender.html';                //模板名称
	    opts.curModel = [];                             //默认当前模型，这四个数据为后面常用，所以存放起来，方便使用
	    opts.formatList = {                             //默认格式
	        date: 'yyyy-MM-dd',
	        year: 'yyyy',
	        quarter: 'yyyy-q',
	        month: 'yyyy-MM',
	        week: 'yyyy-w'
	    };
	    opts.inputFocusClass = 'C_CR_calInput_focus';   //输入框获焦样式
	    opts.inputDisClass = 'C_CR_calInput_rd';        //输入框不可用样式
	    opts.inputErrClass = 'C_CR_calInput_err';       //输入框报错样式
	    opts.selDate = [];                              //选择的日期
	    opts.cache = {                                  //缓存
	        yearPop: {},
	        selDate: []
	    };
	    opts.isBuild = false;                           //是否创建组件DOM
	    opts.inputEl = null;                            //当前输入框
	    opts.tipTxt = null;                             //组件tip文本
	    opts.pEl = null;                                //日期层JQ对象
	    opts.datePanel = [];                            //日期模式数据
	    opts.yearPanel = [];                            //年度模式数据
	    opts.monthPanel = [];                           //月份模式数据
	    opts.quarterPanel = [];                         //季度模式数据
	    opts.timePanel = [];                            //时间模式数据
	    opts.weekPanel = [];
	    opts.yearPop = {                                //YMer条数据
	        forDate: [],
	        forYear: [],
	        forQuarter: [],
	        forMonth: [],
	        forWeek: []
	    };
	    opts.selIndex = 0;                              //当前活动输入框索引号
	    opts.activePop = null;                          //当前活动的POP层，用于关闭
	    opts.isChangeTag = false;                       //是否执行了标签切换
	    opts.tags = [];                                 //显示model
	    self.$tmp = {};                                 //装放jquery对象
	
	    //处理model种类
	    var tags = opts.model.split(';');
	    if(tags.length === 1){
	        opts.tags = tags[0] === 'all' ? ['date', 'year', 'quarter', 'month', 'week'] : tags;
	    }else{
	        opts.tags = tags;
	        opts.model = 'all';
	    }
	
	    //生成当前功能模式
	    var curModel = opts.tags[0];
	
	    opts.curModel = [
	        curModel, 'for' + curModel.charAt(0).toUpperCase() + curModel.substring(1),
	        curModel + 'Frame', curModel + 'Panel'
	    ];
	
	    //初始化格式
	    if(opts.model === 'all' && cusOpts.format){
	        opts.format = $.parseJSON(cusOpts.format.replace(/\\'/g, '#@@#').replace(/'/g, '"').replace(/#@@#/g, '\''));
	        opts.formatList = $.extend(opts.formatList, opts.format);
	        opts.format = opts.formatList[opts.curModel[0]];
	    }else if(!cusOpts.format){
	        opts.format = opts.formatList[opts.curModel[0]];
	    }else{
	        opts.formatList[opts.curModel[0]] = opts.format;
	    }
	    //如果格式只是输出时分秒，则确定按钮是必须要显示的
	    opts.okbtn = /[y|M|q|w|d]/.test(opts.format) ? opts.okbtn : true;
    };
    
})(window.comtop, window.comtop.cQuery);