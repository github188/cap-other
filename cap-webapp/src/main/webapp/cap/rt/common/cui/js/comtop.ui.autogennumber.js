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
	    },
	    /**
	     * 更新控件的值
	     * @param params 参数
	     * @returns {string}
	     */
	    setAutoGenNumValue : function(params){
	      var opts = this.options, self = this;
	      if(!opts.expression){
	    	  return;
	      }
	      var param = {};
	      if(params){
	    	  param = $.parseJSON(params);
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