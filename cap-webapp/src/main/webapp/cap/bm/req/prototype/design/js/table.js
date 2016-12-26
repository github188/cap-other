/**
 * Author : chenxuming pengxiangwei
 * Date:    15-4-2
 * Time:    下午3:35
 * To change this template use File | Settings | File Templates.
 */

(function(f, define){
    define(['lodash/lodash.min','vue/vue.min',"renderer",'pageHistory','utils','common/comtop.cap','jquery/jquery.droppable','jquery/jquery.draggable'], f);
})(function(_,Vue,renderer,pageHistory){
    window.uiConfig={};
    window.pageSession = new cap.PageStorage(namespaces);
    var layout = pageSession.get("layout");
    var histroy = new pageHistory;
    var afterRender = $.Callbacks();//渲染之后回调函数管理
    var coordinate={}; //container内坐标Map，用于进行拖动时的碰撞检测
    if (layout) {
        window._cdata = new CData(layout);
    }else{
        window._cdata = new CData();
    }

    histroy.add(_cdata.getData());
    $(window._cdata).bind("change",function(e){
        buildData();
        histroy.add(this.layoutData)
        //用于build完毕之后做其他操作
        afterRender.fire();
        afterRender.empty();
        $("div .bl_box_center").scrollTop(window.CAPEditor.currScrollTop);
    })
    
    function getMinWidth(){
        var pagevo = pageSession.get("page");
        if(pagevo){
            return /[0-9.]+(%|px)/.test(pagevo.minWidth) ? pagevo.minWidth:'Auto'
        }
        return 'Auto';
    }

    /**
     * 拖动生成相应的table到container
     * 新增数据要放在rid的前面或后面，isTop为true，则放在前面
     *
     */
    function buildTable(rid,isTop,modelid){
        var row = parseInt(cui("#row").getValue(),10),col=parseInt(cui("#col").getValue(),10);

        var ntable = Tools.createTable();
        if(rid){
            _cdata.insertTo(rid,isTop||false,ntable);
        }else{
            _cdata.insert(null,ntable);
        }
        for(var i=0;i<row;i++){
              var tr = Tools.createTr()
             _cdata.insert(ntable.id,tr);
            for(var j=0;j<col;j++){
               var td =  Tools.createTd({componentModelId:modelid})
               _cdata.insert(tr.id,td);
            }
        }
    }
    
     /**
     * 渲染数据
     */
    function buildData(){
      uiConfig = {};
      var treeData = {title:"界面",hideCheckbox:true,isFolder:true,children:_cdata.getData(),expand:true};

      _.forEach($("[uitype='PullDown']","#container"),function(n){
          cui(n).destroy();
      })
      $("#container").empty().append(renderer(_cdata.getData()));
      resizeGridOrEdWidth();
      comtop.UI.scan("#container");
      setCover("#container");
      enableComponentDrop();
      vcap.plate = _cdata.getUIData();
    }

    //重新设置grid和edittableGrid宽度
    function resizeGridOrEdWidth(){
    	$("#container table[uiType*=Grid]").each(function(){
      	  	var id = $(this).attr("id"), uitype = $(this).attr("uitype");
            if(uitype == "Grid" || uitype == "EditableGrid"){
            	var ui = _cdata.getMapData().get(id);
          	  	if(!ui.options.gridwidth){
          	  		window.uiConfig[id].gridwidth = getParentWidthByUI(ui, 'gridwidth');
          	  	}
          	  	if(!ui.options.tablewidth){
          	  		window.uiConfig[id].tablewidth = getParentWidthByUI(ui, 'tablewidth');
          	  	}
            }
        });
    }
    
    /**
     * 获取控件所在父容器宽度（td）获取布局面板可绘制宽度
     * @param ui 控件对象
     * @param attr 属性名称
     * @return 宽度值
     */
    function getParentWidthByUI(ui, attr){
 	   var width = $("#" + ui.pid).css("width");
 	   return width.lastIndexOf("-") >= 0 ? (parent.$("body").width() - 515) : parseInt(width.replace(/[^0-9|\_]/ig, ""));
    }
    
    /**
     * 设置遮罩层
     * @param container
     */
    window.setCover=function(container){
          $(".cIndicator",container).each(function(){
              var id =$(this).data("uiid"),
                  foruitype = $(this).data("foruitype"),
                  pdom =document.getElementById(id),dom = pdom.firstChild,that=this,
                  defaultRect = {left: 0, top: 0, width: 0, height: 0};;
                  if(foruitype == "Grid"){
                    dom = $(pdom).closest(".grid-container").get(0);
                  }else if(foruitype == "EditableGrid"){
                    dom = $(pdom).closest(".eg-container").get(0);
                  }else if(foruitype=="Editor"||foruitype=="Borderlayout"){
                    dom = $(pdom).get(0);
                  }else if(foruitype=="ChooseOrg" || foruitype=="ChooseUser"){
                	dom = $(pdom).find(".choose_box_wrap").get(0); 
                	defaultRect.top = -1;
                	defaultRect.height = 2;
                	defaultRect.width = 35;
                  }else if(foruitype=="Image"){
                    cui(pdom).bind("ready",function(){
                      var rect= dom.getBoundingClientRect();
                      var layout = $(dom).position()
                      $(that).css({left:layout.left,top:layout.top,width:rect.width,height:rect.height});
                    })
                  }
                  if(dom){
                    var rect= dom.getBoundingClientRect();
                    var layout = $(dom).position()
                    $(this).css({left:layout.left + defaultRect.left,top:layout.top + defaultRect.top,width:rect.width + defaultRect.width,height:rect.height + defaultRect.height});
                  }
          }).on("mousedown",function(e){
          })
    }

    /**
     * 注册消息事件
     */
    function initMessage(){
        if(window.addEventListener){
            window.addEventListener("message",function(e){
                notify(e.data);
            },false);
        }else if(window.attachEvent){
            window.attachEvent("onmessage",function(e){
                notify(e.data);
            },false);
        }
    }

    /**
     * 接收通知
     * @param msg
     */
    function notify(msg) {
        var layoutVO= msg.data||{};
        if(msg.action ==="dataChange"){
            _cdata.update(layoutVO);
            if(vcap.id.length>0){
                afterRender.add(function(){
                    _.forEach(vcap.id,function(n){
                      $("#"+n+"_indicator").addClass("selected").show();  
                    })
                    if($("#cIndicator:visible").length>0){
                        var tdid = $("#cIndicator").data("uiid");
                        if(msg.data.componentModelId != "req.uicomponent.layout.component.formLayout"){
                        	showIndicator("#"+tdid);
                        } else {
                        	showIndicator("#"+tdid, null, {top:5});
                        }
                    }
                })
            }
        }
    }

    /**
     * 初始化坐标
     */
    function initCoordinate(){
    	coordinate={};
        $(".u-table",$("#container")).each(function(){
            coordinate[this.id]=this.getBoundingClientRect();
        });
    }

    /**
     * 移动占位箭头，做拖动时箭头指示
     * @param e
     */
    function moveArrow(e){
    	var res =  checkCollision(e),css={};
    	if(res.id){
    		css.left = coordinate[res.id].left;
    		css.top = coordinate[res.id].top+(res.isTop?-15:coordinate[res.id].height-5);
    	}else{
    		var $table = $(".u-table:last",$("#container"));
    		if($table.size()){
    			var rect = $table.get(0).getBoundingClientRect();
    			css.left =rect.left;
    			css.top =rect.top+rect.height-5;
    		}
    	}
        $("#arrow").css(css);
    }

    /**
     * 判断点是否在area内
     * @param c
     * @param area
     * @returns {boolean}
     */
    function inArea(c,area){
    	return c.x>area.left&& c.x<area.right&& c.y>area.top&& c.y<area.bottom;
    }

    /**
     * 碰撞检测
     * @param e
     * @returns {{id: *, isTop: *}}
     */
    function checkCollision(e){
        var c ={x:e.pageX,y:e.pageY},id,isTop;
        for(var o in coordinate){
              if(inArea(c,coordinate[o])){
                  id =o;
                  isTop= c.y<coordinate[o].top+coordinate[o].height/2;
                  break;
              }
        }
        return {id:id,isTop:isTop}
    }

    /**
     * 绑定dropable
     */
    function enableComponentDrop(){
        $('.cell',".table").droppable({
            accept:'.component',
            onDragEnter:function(e,source){
                e.stopPropagation();
                $(source).draggable('proxy').css('border','1px solid red');
                $(this).addClass('over');
            },
            onDragLeave:function(e,source){
                e.stopPropagation();
                $(source).draggable('proxy').css('border','1px solid #ccc');
                $(this).removeClass('over');
            },
            onDrop:function(e,source){
                var uitype = source.getAttribute("data-type"),
                	hasCombinedComponent = uitype == null || uitype == '',
                    tdid = $(this).attr("id"),
                    componentModelId = source.getAttribute("data-modelId"),
                    options,
                    ui;
                if(hasCombinedComponent){
                	var b = _.find(filter(toolsdata),{"componentModelId":componentModelId});
                	options = b.options;
                }
                var idArray = componentModelId.split(",");
                _.forEach(idArray, function(value, key){
                	ui = createUI(value, options != null && options.length > key? options[key] : undefined);
                	var data = autoCreateAction(ui.componentVo.events);
                	ui.options = jQuery.extend(false, data, ui.options);
                	_cdata.insert(tdid,ui);
                	vcap.id.$set(0,ui.id);
                });
                if(!hasCombinedComponent){
                	afterRender.add(function(){
                		$("#"+ui.id+"_indicator").addClass("selected").show();
                	})
                }
            }
        }); 
    }
    
    /**
	 * 根据控件事件绑定的默认行为，控件第一次被放在设计器画布中时，自动创建行为
	 * @param events 控件事件集合
	 * @return 事件绑定的对应行为名称以及ID
	 */
	function autoCreateAction(events){
		var data = {};
		var pageActionId = (new Date()).valueOf().toString();
		for(var i in events){
			var eventVo = jQuery.extend(true, {}, events[i]);
			eventVo.actionDefine = eventVo.actionDefine != null && eventVo.actionDefine != '' ? $.parseJSON(eventVo.actionDefine) : {};
			if(isCreateDefaultAction(eventVo)){
	    		var pageActionEname = eventVo.actionDefine.ename;
	    		var pageActions = pageSession.get("action");
	    		var q = new cap.CollectionUtil(pageActions);
	    		var result = q.query("this.ename=='"+pageActionEname+"'");
	    		if(result.length > 0){
	    			data[eventVo.ename] = result[0].ename;
		    		data[eventVo.ename+"_id"] = result[0].pageActionId;
	    			break;
	    		}
	    		eventVo.actionDefine.pageActionId = pageActionId + i;
	    		eventVo.actionDefine.methodTemplate = eventVo.actionDefine.methodTemplate || eventVo.actionDefine.modelId;
	    		//通知行为模块
		    	window.parent.sendMessage('actionFrame',{type:'pageActionChange', data: eventVo.actionDefine});
		    	data[events[i].ename] = pageActionEname;
	    		data[events[i].ename+"_id"] = eventVo.actionDefine.pageActionId;
			}
		}
		return data;
	}
	
	function isCreateDefaultAction(event){
		var result = false;
		if(event && event.actionDefine.ename && event.actionDefine.ename != ''){
			result = event.hasAutoCreate != false;
		} 
		return result;
	}
    
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
    //用于创建UI函数
    function createUI(componentModelId, defaultOpt){
       var b = _.cloneDeep(_.find(filter(toolsdata),{"componentModelId":componentModelId}));
       if(defaultOpt){
    	   b.options = jQuery.extend(false, b.options, defaultOpt);
       }
       return Tools.createUI(b);
    }

    function disSelectAllCpt(){
        vcap.id.splice(0,vcap.id.length);
        $(".cIndicator",$("#container")).removeClass("selected");
        $("#cIndicator").hide();
    }

    /**
	 * 显示遮罩层
	 * @param el 需要遮罩的td 或者 table 元素
	 * @param offset偏移量
	 * @param type 类型 td 普通 form-table 快速布局
	 */
    function  showIndicator(el,type,offset){
        var target = $(el),layout = target.position();
          offset =offset||{}
          offset.top = offset.top||0
          offset.left = offset.left||0;
        return $("#cIndicator").show().data("type",type)
                        .height(target.outerHeight())
                        .width(target.outerWidth())
                        .css({left:layout.left+offset.left,top:layout.top+offset.top});
    }

    /**
     * 根据组件ID选中组件
     * @param id
     * @param flag 是否选中
     */
    function selectCptById(id,flag){
        flag = typeof flag==="undefined"?true:flag;
        if(flag){
           $("#"+id+"_indicator").addClass("selected");
        }else{
           $("#"+id+"_indicator").removeClass("selected");;
        }
    }

    /**
     * 根据遮罩层选中组件
     * @param dom indicator dom
     * @param flag
     */
    function selectCptByIndicator(dom,flag){
        flag = typeof flag==="undefined"?true:flag;
        if(flag){
            $(dom).addClass("selected");
        }else{
            $(dom).removeClass("selected");
        }
    }

    /**
     * 删除子对象
     * @param target
     */
    function deleteChildUI(target){
    	var trid =  target.closest("tr").attr("id");
		//存储当前行里面的所有控件的id
		var childComponent = [];
		//当前行的所有列的数组
		var _tdArray = _cdata.getMapData().get(trid).children;
		//循环每列
		for(var i = 0; i < _tdArray.length; i++){
			var _td = _tdArray[i];
			//判断列是否有控件，有children就表示有控件
			if(_td.children){
				for(var j = 0; j < _td.children.length; j++){
					//把每个控件的id放到数组中
					childComponent.push(_td.children[j].id);
				}
			}
		}
		_.forEach(childComponent, function(value, key){
			_cdata.delete(value);
		});
    }

    /**
     * 原子组件拖动
     */
    function enableComponentDrag(){
        $('.u-left-menu .component').draggable({
            proxy:function(source){
                var p = $('<span class="u-dragicon"></span>');
                p.html($(source).html()).appendTo('body');
                return p;
            },
            revert:true,
            deltaX:0,
            deltaY:0,
            handle:".hanlder",
            cursor:'move'
        });
    }
    //右键菜单展现函数
    //@param menuId
    //@param e event Object
    //@param uiid 点击'ui',td'或者'快速布局'时候需要传入id 便于菜单操作数据
    function _showMenu(menuId,e,uiid){
      $(".right-menu").hide();
      if(e.which===3){//右键才能展现
        var vuemenu = document.getElementById(menuId).__vue__;
        if(vuemenu){
          vuemenu.uiid = uiid;
        }
        var top="", menuEl = $("#"+menuId);
        if(e.pageY+menuEl.height()>$(window).height()){
           top = e.pageY -menuEl.height();
        }else{
           top = e.pageY + 10;
        }
        menuEl.css({left: e.pageX,top: top}).show();
      }
    }
    
    //快速表单编辑弹出
    function _formTable(id){
    	Tools.open('FormArea.jsp?namespaces=' + namespaces + '&reqFunctionSubitemId=' + reqFunctionSubitemId + '&dataId=' + id, 'formtablewin');
    }
    
    //控件排序
    function _componentSort(id){
      Tools.open(webPath +'/cap/bm/dev/page/designer/PageComponentSort.jsp?dataId='+id, 'componentsortwin', 400); 
    }
    
    //初始化页面编辑区域事件
    function iniCAPEditorEvent(){
         $(document).delegate(".cIndicator","mousedown",function(e){//控件点击事件
            var target = $(e.target);
            if(target.attr("data-foruitype")){
            	if(!e.ctrlKey){
            		disSelectAllCpt();
            	}
            	selectCptByIndicator(target);
            	vcap.id.push(target.data("uiid"));
            	_showMenu("right-menu",e,target.data("uiid"));
            }
            e.stopPropagation();
         }).delegate(".table td.cell","mousedown",function(e) { //普通td表格点击事件
            var target = $(e.target);
            disSelectAllCpt();
            vcap.id.$set(0,target.attr("id"));
            _showMenu("cell-menu",e,target.attr("id"));

            $("#cIndicator").data("uiid",target.attr("id"));
            showIndicator(e.target,"table");
            e.stopPropagation();
         })
         .delegate(".form-table","mousedown",function(e){ //快速布局form-table点击事件
            var target = $(e.target);
            disSelectAllCpt();
            //vcap.id.splice(0,vcap.id.length);
            var formTableid = target.closest("table").attr("id");
            vcap.id.$set(0,formTableid);
            _showMenu("formArea-menu",e,formTableid);

            $("#cIndicator").data("uiid",formTableid);
            showIndicator(target.closest("table"),"formTable",{top:5});
            e.stopPropagation();
         }).delegate(".layout-indicator","mousedown",function(e){ //布局遮罩层点击事件
            var target = $(e.target),
                type = target.data("type"),//布局遮罩类型
                uiid = target.data("uiid");
            if(type==="table") { //如果是table普通类型 则右边属性展现
               vcap.id.$set(0,uiid);
               _showMenu("cell-menu",e,uiid);
            }else if(type==="formTable"){
               //vcap.id.splice(0,vcap.id.length);
               vcap.id.$set(0,uiid);
               _showMenu("formArea-menu",e,uiid);
            }
            
            e.stopPropagation();
         }).on("mousedown",function(e){
                $(".right-menu").hide();
                if(!e.ctrlKey){
                    disSelectAllCpt();
                }
          }).delegate(".layout-indicator","dblclick",function(e){
              var target = $(e.target),
                type = target.data("type"),//布局遮罩类型
                uiid = target.data("uiid");
                if(type==="formTable") { //如果是table普通类型 则右边属性展现
                   _formTable(uiid);
                }else if(type==="table"){ //普通表格弹出组件排序框
                   _componentSort(uiid);
                }                      
          }).delegate(".form-table","dblclick",function(e){ //快速布局双击事件
              var table = $(e.target).closest("table");
              _formTable(table.attr("id"))
          }).on("keyup",function(e){
            //删除方式
             if(e.keyCode===46){
                  var component =$("div.selected","#container").add("#cIndicator:visible");
                  if(component.size()>0){
                     cui.confirm("确定删除选中的组件吗?", {
                        onYes: function(){
                        	var _delUIArray = [];
                            $.each(component,function(i,item){
                            	var uiid = $(item).data("uiid");
                            	var target = $("#"+uiid);
                            	if(target[0].tagName === 'TD'){
                            		deleteChildUI(target);
                            	}
                                _cdata.delete($(item).data("uiid"));
                                _delUIArray.push($(item).data("uiid"));
                            })
                            $("#cIndicator").hide();
                        },
                        onNo: function(){}
                    });
                  }
             }
         });
    }
    
    Vue.component("pull-icon",{
        template:"#pullicon",
        data:function(){
          return {w:getMinWidth().replace("px","")}
        },
        methods:{
            changeWith:function(e){
                e.stopPropagation();
                var minWidth = getMinWidth()||"Auto";
                if(this.$root.w.width == "Auto"){
                        this.$root.w.width = minWidth;
                        this.w = minWidth.replace("px","")
                }else{
                        this.w = this.$root.w.width = "Auto";
                }
                 _.defer(function(){
                    $(_cdata).trigger("change");
                })

            }
        }
    });

    //布局拖动效果
    var layoutDrag = {
        tablelayout:{
          proxy:function(source){
                    var row = cui("#row").getValue();
                    var cell = cui("#col").getValue();
                    var p  =$("<div class='u-table-drag' style='display:block'>{0} 行{1} 列</div>".formatValue(row,cell));
                    p.appendTo('body');
                    return p;
          },
          StopDrag:function(e){
            var res = checkCollision(e);
            buildTable(res.id,res.isTop,$(this).data("modelid"));
          }
        },
        formlayout:{
          proxy:function(source){
              var p = $('<span class="u-dragicon"></span>');
              p.html($(source).html()).appendTo('body');
              return p;
          },
          StopDrag:function(e){
        	var componentModelId = this.getAttribute("data-modelId");
        	var ui = createUI(componentModelId);
            var ntable = Tools.createTable($.extend({options:{class:'form-table',label:"快速表单布局区域",uitype:'formLayout'}}, ui.options));
            ntable.componentModelId = componentModelId;
            var res = checkCollision(e);
            var rid = res.id,isTop=res.isTop;
            if(rid){
                _cdata.insertTo(rid,isTop||false,ntable);
            }else{
                _cdata.insert(null,ntable);
            }
              var tr = Tools.createTr()
             _cdata.insert(ntable.id,tr);
              var td =  Tools.createTd()
            _cdata.insert(tr.id,td);
          }
        },
        borderlayout:{
          proxy:function(source){
              var p = $('<span class="u-dragicon"></span>');
              p.html($(source).html()).appendTo('body');
              return p;
          },
          StopDrag:function(e){
            vcap.w.height = "100%";
            var that = this;
            vcap.$nextTick(function(){
                var componentModelId= that.getAttribute("data-modelId");
                var ui = createUI(componentModelId);
                var data = autoCreateAction(ui.componentVo.events);
                ui.options = jQuery.extend(false, data, ui.options);
                _cdata.insert(null,ui);
                vcap.id.$set(0,ui.id);
            })

            
            /*afterRender.add(function(){
                $("#"+ui.id+"_indicator").addClass("selected").show();
            })*/
          }
        }
    }
    
    Vue.component("layouttools",{
      template:"#t-layoutTools",
      data:function(){
        return {open:true}
      },
      ready:function(){
        var that = this;
        // 由于cui borderlayout组件会将包含的元素删除并重新新增，导致draggable失效，故延迟加载，待cui解决问题后在去掉延迟加载
        setTimeout(function () {
          $(".dragtable",that.$$.items).draggable({
             proxy:function(source){
                var method = $(source).data("method");
                return layoutDrag[method].proxy.call(this,source);
              },
             revert:true,
             onDrag:function(e){
                moveArrow(e);
             },
             onStartDrag:function(e){
                initCoordinate();
             },
             onStopDrag:function(e){
                var method = $(this).data("method");
                if(that.$root.incontainer){
                    layoutDrag[method].StopDrag.call(this,e);
                    that.$root.incontainer = false;
                }
             }
          });
        },0);
      }
    });
    Vue.component("leftmenu",{
      template:"#t-leftMenu",
      props:["indent","level"],
      data:function(){
        return {open:true}
      },
      computed:{
        hasChildren:function(){
            return this.children && this.children.length && this.isFolder && this.componentType!='layout';
        }
      },
      methods:{
        toggleTools:function(){
            this.open = !this.open
        }
      }
    })
    /**组件模式**/
    Vue.component("plate",{
        template:"#plate",
        methods:{
            selectUI:function(e){
                var ischeck = $("#p-"+this.id).prop("checked")
                cui("#pageTree").selectNode(this.id,ischeck);
            }
        }
    })

    //编辑框vm
    var vcap = new Vue({
        //el:"#border",
        data:{
            id:[],//组件id
            treeData:"",
            toggleText:"&#xf078;",
            haslayout:false,
            plate:_cdata.getUIData(),//获取组件数量
            plateHeight:0,//右边树形高度
            w:{width:getMinWidth(), height:'100%'},//编辑区域切换宽度
            uisrc:"./uilibrary/Component.jsp?type=req&namespaces=" + namespaces + "&reqFunctionSubitemId=" + reqFunctionSubitemId,
            selectUi:[], //记录Tree和plate模式下选中UIid
            histroy:histroy
        },
        attached:function(){
            comtop.UI.scan(); //执行布局扫描
            var height = $(this.$$.treeData).height();
            this.plateHeight=height-67;
            var that = this;
            //被拖放区域
            $(this.$$.container).droppable({
                accept: '.dragtable',
                onDragEnter:function(e,source){
                     $("#arrow").show();
                     $(source).draggable('proxy').css('border','1px dotted red');
                },
                onDrop:function(e){
                    that.incontainer = true; //用于判断是否进入拖放区
                   $("#arrow").hide();
                },
                onDragLeave:function(e,source){
                    $("#arrow").hide();
                    $(source).draggable('proxy').css('border','1px dotted #ccc');
                }
            });
        },
        computed:{
          isEnd:function(){
             if(this.histroy.i == 0){
               return {"color":"#b5b5b5"};
             }else{
               return {"color":"#666"};
             }
          },
          isPrev:function(){
            if(this.histroy.i == this.histroy.histroy.length-1){
              return {"color":"#b5b5b5"};
            }else{
              return {"color":"#666"};
            }
          }
        },
        watch:{
            treeData:function(val, oldVal){
                enableComponentDrag();  // 原子组件拖动
            }
        },
        events:{
            resize:function () {
                var height = $(this.$$.treeData).height();
                this.plateHeight=height-57;
            }
        },
        methods:{
           changeLayout:function(){
              var newsrc = window.frameElement.src.replace(/PageDesigner/,"PageDesignerMini");
              window.frameElement.src =newsrc;

           },
           changeView:function(){
                this.haslayout = !this.haslayout;
           },
           //撤销
           undoAction:function(){
             if(histroy.isEnd(true)){
               _cdata.refreshMap(histroy.prev());
              //  $(_cdata).trigger("change");
              buildData();
             }
           },
           //还原
           restoreAction:function(){
             if(histroy.isEnd(false)){
               _cdata.refreshMap(histroy.next());
               buildData();
             }
           },
           delUI:function(){
                var idAry = this.selectUi,that = this;
                if(idAry.length>0){
                    cui.confirm("确定删除这些组件吗?", {
                        onYes: function(){
                        	var _delUIArray = [];
                            _.forEach(idAry,function(key){
                                _cdata.delete(key);
                                _delUIArray.push(key);
                            })
                            that.selectUi.splice(0,idAry.length);
                            $("#cIndicator").hide();
                        }
                    });
                }
           }
        }
    });
   /* vcap.$watch("selectUi",function(newVal,oldVal){
        this.$log("selectUi");
    });*/
    vcap.$watch("id",function(newVal){
        $("#ui-attr")[0].contentWindow.postMessage({"type":"pageDesigner","action":"id",id:newVal},"*");
    })
    vcap.$watch("searchText",function(newVal){
        if(newVal){
          this.haslayout = true;
        }
    })
    //td右键菜单vm
    var vcellMenu = new Vue({
        el:"#cell-menu",
        data:{
            uiid:'',
            isPast:"disable"
        },
        methods:{
            newRow:function(isbefore){
                var target = $("#"+this.uiid);
                var trid =  target.closest("tr").attr("id");
                var ptr = _cdata.getMapData().get(trid);
                var tr = Tools.createTr();
                _cdata.insertTo(ptr.id,isbefore,tr)
                for (var i = 0; i < ptr.children.length; i++) {
                    _cdata.insert(tr.id,Tools.createTd())
                };

                $(".right-menu").hide();
                // e.stopPropagation();
            },
            newCol:function(isbefore){
                // 获取td
                var target = $("#"+this.uiid);
                var ptd = _cdata.getMapData().get(this.uiid);
                // 获取tr
                var trid =  target.closest("tr").attr("id");
                var ptr = _cdata.getMapData().get(trid);
                // 判断td所在index
                var index =_.indexOf(ptr.children,ptd);
                index = isbefore ? index : ++index;
                console.log("td index : %s", index);

                // 获取table
                var tableid = target.closest("table").attr("id");
                var table = _cdata.getMapData().get(tableid);
                // 遍历table的tr 然后插入td到指定位置
                $.each(table.children,function(i,item){
                  _cdata.insertToArray(item.children, Tools.createTd(), index);
                })
                $("#cIndicator").hide();
                $(".right-menu").hide();
                // e.stopPropagation();
            },
            delRow:function(e){
            	var target = $("#"+this.uiid);
                deleteChildUI(target);
                _cdata.delete(target.closest("tr").attr("id"));
            },
            pastUI:function(){
                var that = this;
                _.forEach(vuiMenu.copyui,function(uiid){
                    var sourceUI = _cdata.getMapData().get(uiid);
                    var id = Tools.randomId("uiid")
                    var b = _.assign({},_.cloneDeep(sourceUI),{key:id,pid:'',id:id});
                    _cdata.insert(that.uiid,b);
                })
            }
        }
    })

    //快速布局右键菜单
    var vformAreaMenu = new Vue({
      el:"#formArea-menu",
      data:{
        uiid:'' //整个tableid
      },
      methods:{
        delRow:function () {
          _cdata.delete(this.uiid);
        }
      }
    })
    //ui右键菜单
    var vuiMenu = new Vue({
        el:'#right-menu',
        data:{
            uiid:'',
            copyui:[]
        },
        ready:function(){
          $("li",this.$el).hover(function(e){
              $(this).addClass("on")
          },function(e){
              $(this).removeClass("on")
          })
        },
        methods:{ 
            copyUI:function(){
                this.copyui.splice(0,this.copyui.length,vcap.id[0]);
            },
            delUI:function(){
                _cdata.delete(this.uiid);
            }
        }
    });
    vuiMenu.$watch('copyui.length',function(newVal,oldVal){
        //如果copyui里面有数据 则高亮td右键菜单样式
        vcellMenu.isPast = newVal>0 ? "":"disable"
    })
    
    //组件属性区域高度自适应
    var attrAutoHeight = function(){
    	var attrHeight = $("#ui-attr").height()-50;
        var attrArea = document.getElementById("ui-attr");
        if(attrArea.contentWindow.$ && attrArea.contentWindow.$("body").scope){
        	var $scope = attrArea.contentWindow.$("body").scope();
        	if($scope){
        		$scope.componentlayout = {"height":attrHeight,"overflow-y": "auto"}
        		$scope.$digest();
        	}
        }
    }
    
    window.CAPEditor ={
        init:function(){
            vcap.$mount("#border");
            //当size变化时候则触发
            cui("#border").bind("resize",function(){
            	vcap.$emit("resize");
                //$(_cdata).trigger("change");
                setCover("#container");
                attrAutoHeight();
            }).bind("fold",function(){
                vcap.$emit("resize");
                //$(_cdata).trigger("change");
                setCover("#container");
            });
            initMessage(); //注册消息
            //初始化左边树
            window.toolsdata = _.cloneDeep(window.parent.toolsdata) //data;
            vcap.treeData = JSON.parse(JSON.stringify(window.toolsdata));
            //禁用右键功能
            document.oncontextmenu=function(e){return false;}
            //右边区域中点击不能取消选择控件区域块
            $("#right-container").on("mousedown",function(e){
              if(e.target.tagName=="INPUT"){
                return true;
              }
              return false;
            });
            iniCAPEditorEvent();
            buildData()
            //监听滚动条事件
            $("div .bl_box_center").scroll(function() {
            	window.CAPEditor.currScrollTop = $(this).scrollTop();
          	});
            //page对象中的控件选择到设计器会有而外的数据添加进来，所以要重新设值
            var wrapperHistroyPage = pageSession.get("wrapperHistroyPage");
        	wrapperHistroyPage.layoutVO = jQuery.extend(true, {}, pageSession.get("layout"));
        	wrapperHistroyPage.pageActionVOList = jQuery.extend(true, [], pageSession.get("action"));
        },
        //右边节点树选择事件
        treeNodeSelect:function(flag,node){
             var id =node.getData("key"),
                 dom =document.getElementById(id);
            if(!dom){
                return;
            }
            /*if(node.getData("uiType")=="tr"||node.getData("uiType")=="table"){
                vcap.id.splice(0,vcap.id.length);
                return ;
            }*/
            if(flag){
                vcap.selectUi.push(id);
                vcap.id.push(id);
            }else{
                vcap.selectUi.$remove(_.indexOf(vcap.selectUi,id));
                vcap.id.$remove(_.indexOf(vcap.id,id));
            }
            vcap.$broadcast("selectEl",id);
            $("#p-"+id).prop("checked",flag);
            //flag ? vcap.id.push(id): vcap.id.splice(0,vcap.id.length);
            selectCptById(id,flag);
        }
    }
}, typeof define == 'function' && define.amd ? define : function(_, f){ f(); });
