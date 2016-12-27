/**
 * Created with JetBrains WebStorm.
 * User: ????
 * Date: 12-9-14
 * Time: ????9:49
 * function:?§Ò?
 * To change this template use File | Settings | File Templates.
 */
;(function($, C){
	 C.UI.ListBox = C.UI.Base.extend({
	        options:{
	            uitype:'ListBox',
	            //??????
	            width:'200',
	            //??????
	            height:'200',
	            //?????
	            name:'listboxName',
	            //????
	            value:'',
	            //?????????????????
	            value_field: 'id',
	            //????????????????
	            label_field: 'text',
	            //?????
	            multi:false,
	            //?????
	            textmode:false,
	            //???????
	            datasource:null,
	            //????????????
	            on_dbclick:null,
                //?????????????
                on_click:null,
	            //??§Ú???????
	            on_select_change:null,
	            //??????????
	            on_add:null,
	            //??????????
	            on_remove:null,
	            
	            //???¡¤??
	            icon_path:null
	        },
	        //????????
	        $el:null,
	        //????????
	        listbox:null,
	        //???????
	        hiddenEl:null,
	        //?????????
	        //renderTemplate:false,
	        //????????
	        listTemplateName:'cListBox',
	        //????????
	        valueField:null,
	        //???????
	        labelField:null,
	        //???????
	        //loadData:null,
	        //????????????????????
	        priorElement:null,
	        //????????
	        rowTemplateName:'cListBoxRow',
	        /**
	         * @param options  ???????????
	         * @private
	         */
	        _init:function(options){
	            this.$el = $(this.options.el);
	            this._initParams();
	            this.$el.addClass('cui');
	        },
	        _create:function(){
                //???datasource?function???????
                if (typeof this.options.datasource == 'function') {
                    this.options.datasource(this, {});
                }
	        	this.listbox = $('.listbox',this.$el);
	        	this.hiddenEl = $('[type=hidden]',this.$el);
	        	this.valueField = this.options.value_field;
	        	this.labelField = this.options.label_field;
	        	this._setConfiguration();
	        	//??????
	            this._setDefaultText();
	        },
	        //?????????
	        _initParams:function(){
	        	//????html???
	        	this._analysisHtmlTemplate();
	        },
	        /**
	         * ????html??ÈÉ???????
	         */
	        _analysisHtmlTemplate:function(){
	        	var $tag = $('a',this.$el);
	        	if($tag == null || typeof $tag == 'undefine' || $tag.length < 1){
	        		return ;
	        	}
	            var valueField = this.options.value_field;
	            var labelField = this.options.label_field;
	            var dataArray = [];
	            
	            $.each($tag,function(index,item){
	               var record = {};
	               record[labelField] = $.trim($(this).text());
	               record[valueField] = $.trim($(this).attr('value'));
	               dataArray.push(record);
	            });
	            this.$el.html("");
	            this.options.datasource = dataArray;      
	        },
	        /**
	         * ???????? 
	         */
	        _setConfiguration:function(){
	        	this.listbox.width(this.options.width);
	        	this.listbox.height(this.options.height);
	        },


            _selectChangeCallback: function(){
                var selectChange = this.options.on_select_change;

                if($.type(selectChange) === 'string'){
                    window[selectChange](this.getSelectedRows());
                }else if($.isFunction(selectChange)){
                    selectChange(this.getSelectedRows());
                }
            },
	        /**
	         * ???????
	         */
	        setDatasource:function(result){
	        	this.options.datasource = result;
	        	//if(this.renderTemplate){
	            this._renderElement();
	        	//}
	        },
	        /**
	         * ?????????????
	         */
	        setMulti: function (flag) {
	        	var opt = this.options;
	        	if (opt.multi === flag || typeof flag !== 'boolean') {
	        		return;
	        	} else {
	        		opt.multi = flag;
	        		this.cancelSelected();
	        	}
	        },
	        _renderElement:function(){
	        	var $tr = $(".tr",this.$el);
 			    //????????§Ò????
	        	this._buildTemplate($tr,this.rowTemplateName,this.options);
	        },
	        /**
	         * ??????
	         */
	        _setDefaultText:function(){
	        	if(this.options.value){
        		   var $tr = $(".tr",this.$el);
	        	   var valArray = this.options.multi? this.options.value.split(';'):this.options.value;
	        	   var valueField = this.options.value_field;
		           //????
	    		   var componentValue = [];
	    		   var datasource = this.options.datasource;
	    		   var self = this;
	        	   $.each(datasource,function(index,value){
	        		   if(self.options.multi){
	        			   $.each(valArray,function(i,item){
	        				   if(item == value[valueField]){
	        					   $("li[name=" + item +  "]",$tr).addClass('selected');
	        					   componentValue.push(value[valueField]);
	        				   }
	        			   })
	        		   }else{
	        			   if(valArray == value[valueField]){
        					   $("li[name=" + valArray +  "]",$tr).addClass('selected');
        					   componentValue.push(value[valueField]);
        				   }
	        		   }
	        	   });
	        	   this.hiddenEl.val(componentValue.join(';'));
		        	}
	        },
	        /**
	         * ??????????
	         * @param widthVal
	         */
	        setWidth:function(widthVal){
	        	this.listbox.width(widthVal);
	        },
	        /**
	         * ???????????
	         * ????????????
	         * @param keyVal  valueField?§Ö???
	         */
	        getRecordData:function(keyVal){
	        	var self = this;
	        	var recordData = null;
	        	var datasource = this.options.datasource;
	        	//???????
	        	$.each(datasource,function(index,item){
	        	    if(item[self.valueField] == keyVal){
	        	    	recordData = item;
	        	    	return false;
	        	    }
	        	});
	        	return recordData;
	        },
	        /**
	         * ???????????????
	         */
	        getLabelValue:function(){
	        	if(this.options.value == '' || !this.options.textmode){
	                return "";
	            }
	        	var valArray = this.options.value.split(';');
        	    var valueField = this.options.value_field;
	            var labelField = this.options.label_field;
	            //????
    		    var componentValue = [];
        	    $.each(this.options.datasource,function(index,value){
        	       $.each(valArray,function(i,item){
        	         if(item == value[valueField]){
       	            	componentValue.push(value[labelField]);
        	         }
        	       })
        	   });
        	   return componentValue.join(';');
	        	
	        },
	        /**
	         * ?????????
	         * return ????????????
	         */
	        deleteRecordData:function(keyVal){
	        	var self = this;
	        	var recordData = null;
	        	var data = this.options.datasource;
                var componentArray = [];
	            
	            if(this.hiddenEl.val() != ''){
	            	componentArray = this.hiddenEl.val().split(';')
	            }
	        	
	        	//???????
	        	$.each(data,function(index,item){
	        	    if(item[self.valueField] == keyVal){
	        	    	recordData = item;
	        	    	data.splice(index,1);
	        	    	componentArray.pop(keyVal);
	        	    	return false;
	        	    }
	        	});
	        	this.hiddenEl.val(componentArray.join(';'));
	        	return recordData;
	        },
	        /**
	         * ???????
	         * ????????
	         */
	        getValue:function(){
	        	//???:return this.hiddenEl.val()
	        	var value_field = this.options.value_field;
	    		var rowList = [];
	    		var SelectedRows = this.getSelectedRows();
	    		SelectedRows = SelectedRows === null ? [] : (this.options.multi ? SelectedRows : [SelectedRows]);
	    		
	    		$.each(SelectedRows, function(index, item) {
	    			rowList.push(item[value_field]);
	    		});
	    		return rowList.join(';');
	        },
	        /**
	    	 * ????????????
	    	 */
	    	getText:function(){
	        	var self = this;
	    		var rowList = [];
	    		var SelectedRows = this.getSelectedRows();
	    		SelectedRows = SelectedRows === null ? [] : (this.options.multi ? SelectedRows : [SelectedRows]);
	    		$.each(SelectedRows, function(index, item) {
	    			rowList.push(item[self.labelField]);
	    		});
	    		return rowList.join(';');
	    	},
	        /**
	         * ????????
	         * @param arrayVal string ???????;???
	         */
	        setValue:function(value){
	    		//???§»?????????
	    		var strValue = value + '';
	    		//???????
    			var arrayValue = strValue.split(';');
                
    			if(!this.options.multi && arrayValue.length > 1){
    			   //??????¨®?????????????
    			   return ;	
    			}
    			//????
    			var componentValue = [];
    			//?????????
    			this.cancelSelected();
    			//??????????????
    			$(".td",this.$el).each(function(index,item){
    				if($.inArray($(this).attr('name'),arrayValue) >= 0){
    					componentValue.push($(this).attr('name'));
    					$(this).addClass('selected');
    				}
    			});
    			this.hiddenEl.val(componentValue.join(';'));
	        },
	        /**
	         * ?????????
	         * @param rowList
	         */
	        addRows:function(rowList){
	        	var appendDataList = [];
	        	var self = this;
	        	var bFlag = true;
	        	
	        	if(rowList == null || rowList.length <1){
	        	    return ;
	        	}
	        	
	        	var rowArray = rowList;
	        	if($.isPlainObject(rowList)){
	        		rowArray = [];
	        		rowArray.push(rowList);
	        	}
	        	if(this.options.datasource != null){
	        		//???????????
		        	$.each(rowArray,function(index,item){
		        		bFlag = true;
		        		$.each(self.options.datasource,function(i,val){
		        		    if(val[self.valueField] === item[self.valueField]){
		        		        bFlag = false;
		        		        return false;
		        		    }
		        		})
		        	    if(bFlag){
		        	    	appendDataList.push(item);
		        	    }
		        	}); 
		        	if(appendDataList.length < 1){
		        		return ;
		        	}
	        	}else{
	        		appendDataList = rowArray;
	        		self.options.datasource = [];
	        	}
	        	var opt = $.extend({},this.options);
	        	//???????
	        	opt.datasource = appendDataList;
	        	//??????? 
	        	this.options.datasource = this.options.datasource.concat(appendDataList); 	
	        	//????????????
	        	this._buildTemplate($('.tr',this.$el),this.rowTemplateName,opt,true);
	        	
	        	var add = this.options.on_add;
	        	
	        	if($.type(add) === 'string'){
		        	window[add](appendDataList);
		        }else if($.isFunction(add)){
	        		//????????????
		        	add(appendDataList)
	        	}
	        },
	        /**
	         * ?????
	         * @param keyVal id?
	         */
	        removeRow:function(keyVal){
                var self = this;
                var removeData = null;
                var $current = $('li[name=' + keyVal + ']',this.$el);
                
                if($current){
                	removeData = this.deleteRecordData(keyVal);
                	$current.remove();    
                }
                
                var remove = this.options.on_remove;
                
                if($.type(remove) === 'string'){
		        	window[remove]([removeData]);
		        }else if($.isFunction(remove)){
                	//???????????
                	remove([removeData]);
                }
                return removeData;
	        },
	        /**
	         * ????????
	         */
	        removeSelectedRows:function(){
	        	var removedList = [];
	        	var self = this;
	        	
	        	$(".selected",this.$el).each(function(index,item){
	        		removedList.push(self.deleteRecordData($(this).attr('name')));
	        		$(this).remove();
	        	});
	        	
                var remove = this.options.on_remove;
                
                if($.type(remove) === 'string'){
		        	window[remove](removedList);
		        }else if($.isFunction(remove)){
                	//???????????
		        	remove(removedList);
                }
	        	return removedList;	        		
	        },
	        /**
	         * ????????§Ó???????????
	         * @return ??????????
	         */
	        removeAllRows:function(){
	        	var removedList = [];
	        	var self = this;
	        	var resultData ;
	        	var data = this.options.datasource;
	        	
	        	$(".td",this.$el).remove();
	        	if(data != null && data.length > 0){
	        		removedList = data.splice(0,data.length);
	        	}
	        	//???????????
	        	this.hiddenEl.val('');
	        	
                var remove = this.options.on_remove;
                
                if($.type(remove) === 'string'){
		        	window[remove](removedList);
		        }else if($.isFunction(remove)){
                	//???????????
		        	remove(removedList);
                }
	        	return removedList;	
	        },
	        /**
	         * ?????????
	         * @param index ?§Ü???????0??????????
	         * return ?????
	         */
	        getRow:function(index){
                var size = this.getRowSize();
                var recordData = null;
                
                if(index < size){
                   var rowVal = $('.td',this.$el).eq(index).attr('name');
                   recordData = this.getRecordData(rowVal);
                }
                return recordData;
	        },
	        /**
	         * ???????????§Þ??????
	         * return ??????????????
	         */
	        getSelectedRows:function(){
	        	var selectList = this.options.multi?[]:null;
	        	var self = this;
	        	
	        	$(".selected",this.$el).each(function(index,item){
	        		if(self.options.multi){
	        			selectList.push(self.getRecordData($(this).attr('name')));
	        		}else{
	        			selectList = self.getRecordData($(this).attr('name'));
	        		}
	        	});
	        	return selectList;
	        },
	        /**
	         * ????????
	         * @param index  ?§Ü?
	         */
	        selectRow:function(index){
                var componentArray = [];
	            
	            if(this.hiddenEl.val() != ''){
	            	componentArray = this.hiddenEl.val().split(';')
	            }
	        	
	        	if(index >=0 && index < this.getRowSize()){
	        		$('.td',this.$el).eq(index).addClass('selected');
	        		componentArray.push($('.td',this.$el).eq(index).attr('name'));
	        		this.hiddenEl.val(componentArray.join(';'));
	        	}

                this._selectChangeCallback();
	        },
	        /**
	         * ?????????
	         */
	        selectAllRows:function(){
	        	if(!this.options.multi){
		        	   //??????????????????????
		        	   return ;
		        }
	        	var componentArray = [];
	        	
	        	$(".td",this.$el).each(function(index,item){
	        		$(this).addClass('selected');
	        		componentArray.push($(this).attr('name'));
	        	});
	        	this.hiddenEl.val(componentArray.join(';'));

                this._selectChangeCallback();
	        },
	        /**
	         * ????????????
	         */
	        cancelSelected:function(){
	        	$(".selected",this.$el).each(function(index,item){
	        		$(this).removeClass('selected');
	        	});
	        	this.hiddenEl.val('');

                this._selectChangeCallback();
	        },
	        /**
	         * ????????????
	         */
	        getAllRows:function(){
                return this.options.datasource;
	        },
	        /**
	         * ?????
	         * @param srcIndex ????
	         * @param targetIndex ???????????
	         */
	        moveRow:function(srcIndex,targetIndex){
	           var size = this.getRowSize();
	           
               if(srcIndex >= 0 && srcIndex < size && targetIndex >= 0 && targetIndex < size && srcIndex != targetIndex){
            	   var rowEl = $('.td',this.$el);
            	   if(srcIndex < targetIndex){
            		   rowEl.eq(targetIndex).after(rowEl.eq(srcIndex));
            	   }else{
            		   rowEl.eq(targetIndex).before(rowEl.eq(srcIndex));
            	   }
            	   this.options.datasource.splice(targetIndex,0,this.options.datasource.splice(srcIndex,1)[0]);
               }
	        },
	        /**
	    	 * ?????????§Ö???
	    	 */
	        moveUp: function() {
	    		var selectedRows=this.getSelectedRows();
	    		var size = this.getRowSize();
	    		var index ;
	    		
	    		for(var i=0,j=selectedRows.length; i < j;i++){
	    			index=this._getRowIndexByName(selectedRows[i][this.valueField]);
	    			if(index==0){break;}
	    			this.moveRow(index,index-1);
	    		}
	    	},
	    	/**
	    	 * ????????????
	    	 */
	        moveDown: function() {
	    		var selectedRows=this.getSelectedRows();
	    		var rowSize = this.getRowSize();
	    		var index ;
	    		
	    		for(var i=selectedRows.length-1;i>=0;i--){
	    			index=this._getRowIndexByName(selectedRows[i][this.valueField]);
	    			if(index == (rowSize-1) ){break;}
	    			this.moveRow(index,index+1);
	    		}
	    	},
	        /**
	    	 * ???????
	    	 */
	        getRowSize:function(){
	        	return $('.td',this.$el).length;
	        },
	        /**
	         * ????????
	         */
	        _getRowDataByKey:function(keyVal){
	        	var self = this,data = this.options.datasource;
	        	var resultRecord = null;
	        	$.each(data,function(index,item){
	        	    if(item && item[self.valueField] == keyVal){
	        	    	resultRecord = item;
	        	    	return false;
	        	    }
	        	});
	        	return resultRecord;
	        },
	        /*
	         * ???name????§Ü?
	         */
	        _getRowIndexByName:function(rowName){
	        	var index = $('li',this.$el).index($('li[name=' + rowName + ']',this.$el));
	        	return index;
	        },
	        /**
	         * ?????§Õ??????
	         * @param event
	         * @param element
	         * @private
	         */
	        _rowClick:function(event,element,target){
	            var select = 'selected';
	            var $element = $(element);
	            var componentArray = [];
	            
	            if(this.hiddenEl.val() != ''){
	            	componentArray = this.hiddenEl.val().split(';')
	            }
	            //???????§µ??????¦Ä???
	            if($element.hasClass(select)){
	            	this.priorElement = null;
	                $element.removeClass(select);
	                var name = $element.attr('name');
	                for(var i=0,j=componentArray; i<j;i++){
	                	if(componentArray[i] == $element.attr('name')){
	                		componentArray.splice(i,1);
	                		break;
	                	}
	                }
	            }else if(!this.options.multi){
	            	//???????
                    $(".selected",this.$el).each(function(index,item){
                        $(this).removeClass('selected');
                    });
                    this.hiddenEl.val('');

	            	$element.addClass(select);
	            	componentArray = [];
	            	componentArray.push($element.attr('name'));
	            }else if(this.options.multi && event.shiftKey){
	                //???????
	            	if(this.priorElement == null){
	            		this.priorElement = $element.attr('name');
	            		componentArray.push(this.priorElement);
	            	}else{
	            	    var currenIndex = this._getRowIndexByName($element.attr('name'));
	            	    var preIndex = this._getRowIndexByName(this.priorElement);
	            	    var rowEl = $('.td',this.$el);

                        $(".selected",this.$el).each(function(index,item){
                            $(this).removeClass('selected');
                        });
                        this.hiddenEl.val('');

	            	    for(var i = Math.min(currenIndex, preIndex),j = Math.max(currenIndex, preIndex); i <= j; i++) {
	            	    	rowEl.eq(i).addClass(select);
	            	    	componentArray.push(rowEl.eq(i).attr('name'));
		    			}
	            	}
	                $element.addClass(select);
	            }else{
	            	this.priorElement = $element.attr('name');
	            	componentArray.push(this.priorElement);
	                //???????
	            	$element.addClass(select);	            	
	            }	        
	            this.hiddenEl.val(componentArray.join(';'));

                var click = this.options.on_click;
                if($.type(click) === 'string'){
                    var name = $(element).attr('name');
                    window[click](this._getRowDataByKey(name));
                }else if($.isFunction(click)){
                    var name = $(element).attr('name');
                    click(this._getRowDataByKey(name));
                }

                this._selectChangeCallback();
	        },
	        /**
	         * ????§Õ??????
	         * @param event
	         * @param element
	         */
	        _rowDblClick:function(event,element,target){
	        	var dbclick = this.options.on_dbclick;
	        	
	        	if($.type(dbclick) === 'string'){
	        	   var name = $(element).attr('name');
	        	   window[dbclick](this._getRowDataByKey(name));
	        	}else if($.isFunction(dbclick)){
	        	   var name = $(element).attr('name');
	        	   dbclick(this._getRowDataByKey(name));
                }
	        },
	        /**
	         * ???????
	         * @param event
	         * @param element
	         * @private
	         */
	        _trhoverin:function(event,element,target){
	            var hc = 'hover';
	            $(element).addClass(hc);
	        },
	        /**
	         * ??????
	         * @param event
	         * @param element
	         * @private
	         */
	        _trhoverout:function(event,element,target){
	            var hc = 'hover';
	            $(element).removeClass(hc);
	        },
	        //el?????????
	        _setCacheData:function(key,value){
	            //??????????el?????
	        	this.$el.data(key,value);
	        },
	        //el????????????
	        _getCacheData:function(key){
	            return this.$el.data(key);
	        },
	        //el??????????
	        _removeCacheData:function(key){
	        	this.$el.removeData(key);
	        }
	    });
})(window.comtop.cQuery, window.comtop);