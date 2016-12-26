(function(f, define){
    define(['lodash/lodash'], f);
})(function(){

(function(window,undefined){
  //获取URL参数?key=vlue
  window.URL = (function(){
      var result = {}, queryString = location.search.substring(1),
            re = /([^&=]+)=([^&]*)/g, m;
        while (m = re.exec(queryString)) {
            result[decodeURIComponent(m[1])] = decodeURIComponent(m[2]);
        }
        return result;
    })();
    
  //转换百分比
  Number.prototype.toPercent = function(){
      return (Math.round(this * 10000)/100).toFixed(2) + '%';
  }
  //格式化数据
  String.prototype.formatValue = function(){
        var that = arguments;
        var myReg = /{([^{}]+)?}/ig;
        return this.replace(myReg,function(){
            var value = that[arguments[1]];
            return value;
        })
    }
//=======================HashMap===============//
function HashMap() {
  // 定义长度
  var length = 0;
  // 创建一个对象
  var obj = new Object();
  /**
   * 判断Map是否为空
   */
  this.isEmpty = function() {
    return length == 0;
  };

  /**
   * 判断对象中是否包含给定Key
   */
  this.containsKey = function(key) {
    return (key in obj);
  };

  /**
   * 判断对象中是否包含给定的Value
   */
  this.containsValue = function(value) {
    for ( var key in obj) {
      if (obj[key] == value) {
        return true;
      }
    }
    return false;
  };

  /**
   * 向map中添加数据
   */
  this.put = function(key, value) {
    if (!this.containsKey(key)) {
      length++;
    }
    obj[key] = value;
  };

  /**
   * 根据给定的Key获得Value
   */
  this.get = function(key) {
    return this.containsKey(key) ? obj[key] : null;
  };

  /**
   * 根据给定的Key删除一个值
   */
  this.remove = function(key) {
    if (this.containsKey(key) && (delete obj[key])) {
      length--;
    }
  };

  /**
   * 获得Map中的所有Value
   */
  this.values = function() {
    var _values = new Array();
    for ( var key in obj) {
      _values.push(obj[key]);
    }
    return _values;
  };

  /**
   * 获得Map中的所有Key
   */
  this.keySet = function() {
    var _keys = new Array();
    for ( var key in obj) {
      _keys.push(key);
    }
    return _keys;
  };

  /**
   * 获得Map的长度
   */
  this.size = function() {
    return length;
  };

  /**
   * 清空Map
   */
  this.clear = function() {
    length = 0;
    obj = new Object();
  };
}
//======================End======================
var Tools = {
    open:function(url,title,width){
        var top=(window.screen.availHeight-500)/2;
        var left=(window.screen.availWidth-800)/2;
        var width = width || 800;
      return window.open(url,title,'height=500,width='+width+',top='+top+'px,left='+left+'px,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no');
    },
    getInitByid:function(componentModelId){
      //获取所有菜单子类
      function filter(data){
          var ary = []
          _.forEach(data,function(n){
              if(n.isFolder){
                ary = ary.concat(filter(n.children));
              }else{
                ary.push(n);
              }
          })
          return ary  
       }
       var b = _.cloneDeep(_.find(filter(toolsdata),{"componentModelId":componentModelId}));
       return b;
    },
    tdOption:"width;height;text-align;padding;margin;vertical-align;border-right;border-bottom;border-left;color;background-color",
    defaultInit:{
        Tree:{
          "children":[
              { title: "我不能被选择",  key: "k1",  unselectable: true },
              { title: "Folder 2", key: "k2", isFolder: true, expand:true,children: [
                  { title: "无形资产",  key: "k2-1" },
                  { title: "有形资产",  key: "k2-2" , expand:true,isFolder:true, children:[
                      { title:"hello" }]
                }]
              },
              { title: "其他", key: "k3", hideCheckbox: true }
            ]
        },
        Grid:{
            uitype:'Grid',
            datasource:function(gridObj,page){
                gridObj.setDatasource([],0);
            },
            primarykey:'ID',
            gridwidth:700,
            gridheight:"300",
            tablewidth:700,
            columns:[
                {bindName:"name",name:"姓名"},
                {bindName:"class",name:"班级"},
                {bindName:"chemistry1",name:"化学1"} ]
        },
        EditableGrid:{
          uitype:"EditableGrid",
          datasource:function(gridObj,page){
              gridObj.setDatasource([],0);
          },
          primarykey:'ID',
          gridwidth:700,
          gridheight:300,
          tablewidth:1200,
          adaptive:true,
          columns:[
            {bindName:"1",name:"序号"},
            {bindName:"Input",name:"Input"}
          ],
          edittype: {
            "Input" : {
              uitype: "Input",
                  validate: [
                      {
                          type: 'required',
                          rule: {
                              m: '不能为空'
                          }
                      }
                  ]
            }
          }
        }
    },
    randomId:function(prefix){
      return prefix +"-"+ (90*Math.random()+10).toString().replace(".","");
    },
    craeteMenu:function(id,name){
      return '<span id="{0}"><a class="u-menu" >{1}</a></span>'.formatValue(id,name)
    },
    createUI:function(ui){
      // var newUidata ={
      //       uiType:uitype,
      //       id:id,
      //       type:"ui",
      //       componentModelId:componentModelId,
      //       title:uitype,
      //       key:id,
      //       options:$.extend(true,{uitype:uitype},Tools.defaultInit[uitype])
      //   }
        //ui中包含componentModelId,options,text,uiType这几个属性
        var id = this.randomId("uiid");
        if(ui.options.uitype === 'AtmSep'){
       		id = id.replace('uiid-', 'atm_div_');
       		//给附件options设置个初始化的值。
       		//id属性是需要的，在gird中某列渲染成附件链接，上传附件后回写附件数量的时候需要这个Id
       		ui.options.id = id;
       	}
        //给ui给个对象值

        ui.objectOptions = _.mapValues(_.cloneDeep(ui.options),function(value,key){
            switch (ui.propertiesType[key]) {
                case "Json":
                case "Array":
                  return(new Function("return "+value))();
                  break;
                case "Number":
                  return Number(value);
                  break;
                case "Boolean":
                  return value=="true"? true:false;
                  break;
                default:
                return value;
            }
        })
        if(ui.options.uitype === 'RadioGroup' || ui.options.uitype === 'CheckboxGroup'){
        	var key = ui.options.uitype.replace('Group','').toLowerCase()+'_list';
        	if(ui.options.uitype === 'RadioGroup'){
        		ui.options.name = (new Date()).valueOf().toString();
        	}
        	ui.objectOptions[key] = ui.objectOptions[key] != null && ui.objectOptions[key] != '' ? ui.objectOptions[key] : [{text:"值1",value:1},{text:"值2",value:2},{text:"值3",value:3}];
        } 
        ui.options = _.mapValues( ui.options,function(value,key){
          switch (ui.propertiesType[key]) {
              case "Number":
                return Number(value);
                break;
              case "Boolean":
                return value=="true"? true:false;
                break;
              default:
              return value;
          }
        })
        return $.extend(true,{
          id:id,
          type:"ui",
          title:ui.uiType,
          key:id
        },ui)
    },
    createTable:function(obj){
      obj = obj||{};
      if(!obj.id){
        obj.id= this.randomId("tableid");
      }
      return $.extend({
        pid:"0",
        id:"",
        key:obj.id,
        expand:true,
        options:{uitype:"table",label:'表格布局'},
        title:"table",
        type:"layout",
        uiType:"table"
      },obj);
    },
    createTr:function(obj){
      obj = obj||{};
      if(!obj.id){
        obj.id= this.randomId("trid");
      }
      return $.extend({
        pid:"",
        id:"",
        key:obj.id,
        expand:true,
        options:{uitype:"tr"},
        title:"tr",
        type:"layout",
        uiType:"tr"
      },obj);
    },
    createTd:function(obj){
      var b = this.getInitByid("req.uicomponent.layout.component.tableLayout");
      obj = obj||{};
      if(!obj.id){
        obj.id= this.randomId("tdid");
      }
      return $.extend({
        pid:"",
        id:obj.id,
        key:obj.id,
        componentModelId:obj.componentModelId||"req.uicomponent.layout.component.tableLayout",
        options:b.options,
        expand:true,
        title:"td",
        type:"layout",
        uiType:"td"
      },obj);
    },
    //设置设计器右下脚显示的UI名称
    setShowName:function(_obj){
    	if(_obj.options.label){
    		_obj.title = _obj.uiType+'('+_obj.options.label+')';
        }else if(_obj.options.name){
        	_obj.title = _obj.uiType+'('+_obj.options.name+')';
        }else{
        	_obj.title = _obj.uiType;
        }
    }
  }
//================================  
//模型数据封装
  function CData(layoutData){
    this.map = new HashMap();
    if(!layoutData){
      this.layoutData = [];
    }else{
      this.layoutData = layoutData.children;
      this._toMap(layoutData.children,"0");
    }
  }

  _.assign(CData.prototype,{
    refreshMap:function (layoutData) {
      if(layoutData){
        this.layoutData = layoutData;
      }
      this.map.clear();
      this._toMap(this.layoutData,"0");
    },
    
    _toMap:function(layoutData,pid){
      if(_.isArray(layoutData)){
        var that = this;
        _.forEach(layoutData,function(item){
            item.pid = item.pid||pid;
            item.key = item.id;
            item.expand = true;
            //设置显示名称
            Tools.setShowName(item);
            that.map.put(item.id,item);
            if(item.children){
              that._toMap(item.children,item.id);
            }
        })
      }
    },
    //这里是在0.3秒之内触发N次算一次触发，防止API连续调用导致重复Render多次
    _trigger:_.debounce(function(){
        $(this).trigger("change");
    },100),
    //持久化到SessionStorage
    _toStorage:function(){
      this._trigger();
      var pageSession = new cap.PageStorage(pageId);
      var layout = {title:"界面",hideCheckbox:true,id:"0",type:"root",uiType:"root",isFolder:true,children:this.layoutData,expand:true};
     // pageSession.set("layout",JSON.stringify(layout));
    },
    clearData:function(){
      this.layoutData = [];
      this.map.clear();
      this._toStorage();
      return this;
    },
    /**
    *@param id 元素id
    *@param isbefore 放入其元素中前面还是后面，true为前面
    *@param obj插入的对象
    * Eg:[对象1,对象2,对象3] =>insertTo(对象1.id,true,对象4)=>[对象4,对象1,对象2,对象3]
    */
    insertTo:function(id,isbefore,obj){
          var sb = this.map.get(id);
          var parentObj = this.map.get(sb.pid),sbArray;
          if(parentObj){
            sbArray = parentObj.children;
            obj.pid = parentObj.id;
          }else{
            sbArray = this.layoutData;
            obj.pid = "0";
          }
          var index =_.indexOf(sbArray,sb);
          this.insertToArray(sbArray, obj, isbefore?index:++index);
          return this;
    },

    /**
     * 插入数据到数组指定的位置
     * @param  {Array} array 插入数组
     * @param  {Object} obj   插入数据
     * @param  {int} index   插入数组索引
     * @return {this}       this
     */
    insertToArray: function (array, obj, index) {
      if(index || index === 0) {
        array.splice(index, 0, obj);
      }else {
        array.push(obj);
      }
      this.map.put(obj.id,obj);
      this._toStorage();
      return this;
    },

    /**
    *@param parentId 需要追加对象的父对象
    *@param obj需要追加的对象
    *Eg:{id:123,children:[对象1]} => insert(123,对象1)=>{id:123,children:[对象1,对象2]}
    */
    insert:function(parentId,obj){
      if(!parentId){
        obj.pid = "0" ;
        this.layoutData.push(obj);
        this.map.put(obj.id,obj);
      }else{
        obj.pid = parentId;
        var parentObj = this.map.get(parentId);
        if(!parentObj.children){
            parentObj.children = [obj];
        }else{
           //this.addWatch();
          parentObj.children.push(obj);
        }
        this.map.put(obj.id,obj);
      }
      //设置显示名称
      Tools.setShowName(obj);
      
      this._toStorage();
      return this;
    },
    /**
    *@param obj需要更新的对象
    *Eg:{id:123,children:[对象1]} => update(对象2)=>{id:123,children:[对象2]}
    *(对象1和对象2 id必须一样)
    */
    update:function(obj){
      var selfobj = this.map.get(obj.id);
      if(selfobj){
    	  this.refreshAssociationObj(selfobj, obj);
          $.extend(true,selfobj,obj);
          if(obj.options){
        	  selfobj.options = $.extend(true,{},obj.options);
        	  selfobj.objectOptions = $.extend(true,{},obj.objectOptions);
          }
      }
      //设置显示名称
      Tools.setShowName(selfobj);
      this._toStorage();
      return this;
    },
    /**
    *@param id需要删除的对象id
    *Eg:{id:123,children:[对象1]} => update(对象1.id)=>{id:123,children:[对象2]}
    */
    delete:function(id){
    	var selfobj = this.map.get(id);
    	if(selfobj.pid!=="0"){
    		var parentObj = this.map.get(selfobj.pid);
    		var index = _.indexOf(parentObj.children,_.find(parentObj.children,{id:id}));
    		parentObj.children.splice(index,1);
    		if(selfobj.uiType=="td"||selfobj.uiType=="tr"){
    			if(parentObj.children.length==0){
    				this.delete(parentObj.id)
    			} 
    		}
    	}else{
    		var that = this;
    		_.forEach(selfobj.children,function(trChild){
    			_.forEach(trChild.children,function(uiChild){
    				_.forEach(uiChild.children,function(uiChild){
    					if(uiChild && uiChild.id){
    						that.delete(uiChild.id);
    					}
    				});
    			});
    		});
    		if(selfobj.uiType == 'table' || selfobj.uiType == 'Borderlayout'){
    			var index = _.indexOf(this.layoutData,_.find(this.layoutData,{id:id}));
    			this.layoutData.splice(index, 1);
    		}
    	}
    	this.map.remove(id);
    	this._toStorage();
    	return this;
    },
    //清除chiildren为空函数
    clearChildren:function(id){
      var selfobj = this.map.get(id);
      selfobj.children.splice(0,selfobj.children.length);
      this._toStorage();
    },
    updateopt:function(id,options){
      var selfobj = this.map.get(id);
      $.extend(selfobj.options,options);
      this._toStorage();
    },
    move:function(id,tid){
      var ui = this.map.get(id);
      var targetTd = this.map.get(tid);
      this.delete(id);
      this.insert(tid,$.extend(true,{},ui));
      this._toStorage();
    },
    getData:function(){
      return this.layoutData;
    },
    getMapData:function(){
      return this.map;
    },
    getTransformData:function(id){
      var layout = this.getMapData().get(id);
      var cloneO = $.extend(true,{},layout);
      cloneO.options = _.transform(cloneO.options,function(result, value, key){
              if(_.isArray(value) || _.isPlainObject(value)){
                result[key] = JSON.stringify(value)
              }else{
                result[key] = value;
              }
      })
      return cloneO;
    },
    getUIData:function(){
      if(!this.map.isEmpty()){
        return _.filter(this.map.values(),function(item){
            if(item.type=="ui"){
              return item;
            }
        })
      }
    },
    /**
     * 快速布局：主控件validate发生变更，则相应的label控件的数据也要发生相应变化（reddot）
     *@param selfobj对象原数据、obj对象新数据
     */
    refreshAssociationObj:function(selfobj, obj){
    	if(selfobj.objectOptions != null && (selfobj.objectOptions.validate || obj.objectOptions.validate)){
  		  var oldValue = _.find(selfobj.objectOptions.validate, {type: 'required'});
  		  var newValue = _.find(obj.objectOptions.validate, {type: 'required'});
  		  if(!(oldValue && newValue || !oldValue && !newValue)){// 如果旧值和新值都是必填类型或都不是必填类型则不进入以下逻辑
  			  var reddot = false;
  			  if(oldValue && !newValue){
  				  reddot = false;
  			  } else if(!oldValue && newValue){
  				  reddot = true;
  			  }
  			  var tdobj = this.map.get(selfobj.pid);
  			  if(tdobj){
  				  var trobj = this.map.get(tdobj.pid);
  				  if(trobj){
  					  var tableobj = this.map.get(trobj.pid);
  					  if(tableobj.options.bindObject){// 是否是快速布局控件
  						 var leftLabelId = null;
  						 var currComponentIndex = _.findIndex(tdobj.children, {id: obj.id});
  						 if(currComponentIndex == 0){
  							 var selfTbIndex = _.findIndex(trobj.children, {id: tdobj.id});
  							 if(selfTbIndex > 0){
  								 leftLabelId = trobj.children[selfTbIndex-1].children[0].id;
  								 var leftLabel = this.map.get(leftLabelId);
  								 if(leftLabel && leftLabel.uiType === 'Label'){
  									 leftLabel.objectOptions.isReddot = reddot;
  									 leftLabel.options.isReddot = reddot;
  								 }
  							 }
  						 }
  					  }
  				  }
  			  }
  		  } 
  	  }
    }
  });

  window.CData = CData;
  window.Tools = Tools;
})(window);

}, typeof define == 'function' && define.amd ? define : function(_, f){ f(); });