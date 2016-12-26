define(['require',"common/angular","renderer","lodash.min","angular-dragdrop","angular-sanitize","cui/comtop.ui.all","common/comtop.cap","utils"],function(require,angular,renderer,_){
	//获取左边UI树
	var coordinate;
	window.uiConfig={};
	var afterRender = $.Callbacks();//渲染之后回调函数管理
	dwr.TOPEngine.setAsync(false);
	ComponentTypeFacade.queryList(function(data){
		window.toolsdata = data;
    });
    dwr.TOPEngine.setAsync(true);

    var pageSession = new cap.PageStorage(pageId);
	var layout = pageSession.get("layout");
	if (layout) {
        window._cdata = new CData(layout);
    }else{
        window._cdata = new CData();
    }

	$(window._cdata).bind("change",function(e){
		buildData();
		afterRender.fire();
        afterRender.empty();
	});

	/**
     * 拖动生成相应的table到container
     * 新增数据要放在rid的前面或后面，isTop为true，则放在前面
     *
     */
    function buildTable(rid,isTop,modelid){
        var row = parseInt($("#row").val(),10),col=parseInt($("#col").val(),10);

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
    function checkCollision(c){
        var id,isTop;
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
    function moveArrow(p){
      var res =  checkCollision(p),css={};
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
    function createUI(componentModelId){
       var b = _.cloneDeep(_.find(filter(toolsdata),{"componentModelId":componentModelId}));
       return Tools.createUI(b);
    }
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
            var ntable = Tools.createTable({options:{class:'form-table',label:"快速表单布局区域",uitype:'table'}});
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
          StopDrag:function(e,el){
            //vcap.w.height = "100%";
            var that = this;
            var scope = $("body").scope();
        	var componentModelId = el.data("modelid");
            var ui = createUI(componentModelId);
	        	// var data = autoCreateAction(ui.componentVo.events);
            	// ui.options = jQuery.extend(false, data, ui.options);
	            _cdata.insert(null,ui);
		        scope.$apply(function(){
		        	scope.id = [ui.id];
		        })
          }
        }
    }
    /**
     * 接收通知
     * @param msg
     */
    function notify(msg) {
        var layoutVO= msg.data||{},scope = $("body").scope();
        if(msg.action ==="dataChange"){
            _cdata.update(layoutVO);
            
            if(scope.id.length>0){
                afterRender.add(function(){
                    _.forEach(scope.id,function(n){
                      $("#"+n+"_indicator").addClass("selected").show();  
                    })
                    if($("#cIndicator:visible").length>0){
                        var  tdid = $("#cIndicator").data("uiid");
                        showIndicator("#"+tdid);
                    }
                })
            }

        }
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
    function disSelectAllCpt(){
        var scope = $("body").scope();
        scope.$apply(function(){
        	scope.id = [];
        })
        $(".cIndicator",$("#container")).removeClass("selected");
        $("#cIndicator").hide();
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
   //显示遮罩层
    //@param el 需要遮罩的td 或者 table 元素
    //@param offset偏移量
    //@param type 类型 td 普通 form-table 快速布局
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
    //快速表单编辑弹出
    function _formTable(id){
    	Tools.open('area/FormArea.jsp?packageId='+packageId+'&pageId='+pageId+'&dataId='+id,'formtablewin');
    }
    function _componentSort(id){
      Tools.open('PageComponentSort.jsp?packageId='+packageId+'&pageId='+pageId+'&dataId='+id,'componentsortwin',400); 
    }
    //初始化页面编辑区域事件
    function iniCAPEditorEvent(){
         $(document).delegate(".cIndicator","mousedown",function(e){//控件点击事件
            var target = $(e.target);
            if(!e.ctrlKey){
                disSelectAllCpt();
            }
            selectCptByIndicator(target);
            var scope = $("body").scope();
            scope.$apply(function(){
            	scope.id.push(target.data("uiid"));
            	console.log(scope.id,"fff")
            })
            //_showMenu("right-menu",e,target.data("uiid"));
            e.stopPropagation();
         }).delegate(".table td.cell","mousedown",function(e) { //普通td表格点击事件
            var target = $(e.target);
            disSelectAllCpt();
            //_showMenu("cell-menu",e,target.attr("id"));
        	var scope = $("body").scope();
            scope.$apply(function(){
            	scope.id = [target.attr("id")];
            })
            $("#cIndicator").data("uiid",target.attr("id"));
            showIndicator(e.target,"table");
            
            e.stopPropagation();
         })
         .delegate(".form-table","mousedown",function(e){ //快速布局form-table点击事件
            var target = $(e.target);
            disSelectAllCpt();
            var scope = $("body").scope();
            scope.$apply(function(){
            	scope.id = [];
            })
            var formTableid = target.closest("table").attr("id");
            //_showMenu("formArea-menu",e,formTableid);

            $("#cIndicator").data("uiid",formTableid);
            showIndicator(target.closest("table"),"formTable",{top:5});
            e.stopPropagation();
         }).delegate(".layout-indicator","mousedown",function(e){ //布局遮罩层点击事件
            var target = $(e.target),
                type = target.data("type"),//布局遮罩类型
                uiid = target.data("uiid"),
                scope = $("body").scope();
            if(type==="table") { //如果是table普通类型 则右边属性展现
	            scope.$apply(function(){
	            	scope.id = [uiid];
	            })
               //_showMenu("cell-menu",e,uiid);
            }else if(type==="formTable"){
            	scope.$apply(function(){
	            	scope.id = [];
	            })
               //_showMenu("formArea-menu",e,uiid);
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
                                _cdata.delete($(item).data("uiid"));
                                _delUIArray.push($(item).data("uiid"));
                            })
                            $("#cIndicator").hide();
                            window.parent.sendMessage('pageStateFrame',{type:'delUIChange',data:_delUIArray})
                        },
                        onNo: function(){}
                    });
                  }
             }
         });
    }

	function setCover(container){
		$(".cIndicator",container).each(function(){
          var id =$(this).data("uiid"),
              foruitype = $(this).data("foruitype"),
              pdom =document.getElementById(id),dom = pdom.firstChild,that=this;
              if(foruitype == "Grid"){
                dom = $(pdom).closest(".grid-container").get(0);
              }else if(foruitype == "EditableGrid"){
                dom = $(pdom).closest(".eg-container").get(0);
              }else if(foruitype=="Editor"||foruitype=="Borderlayout"|| foruitype=="ChooseOrg"|| foruitype=="ChooseUser"){
                dom = $(pdom).get(0);
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
                $(this).css({left:layout.left,top:layout.top,width:rect.width,height:rect.height});
              }
      })
	}
	function buildData(){
		var injector = angular.element(document.body).injector()
		var $compile = injector.get("$compile");
		var scope = $("body").scope();
		scope.$apply(function(){
			var node = $compile(renderer(_cdata.getData()))(scope);
			$("#container").empty().append(node);
			comtop.UI.scan("#container");
			setCover("#container");
		})

		var treeData = {title:"界面",hideCheckbox:true,isFolder:true,children:_cdata.getData(),expand:true};
		cui("#pageTree").setDatasource(treeData);
	}
 
	this.switchHideArea = function(){

	}
	require(['domReady!'],function(document){
		var app = angular.module("pageDesigner",['ngDragDrop','ngSanitize']);
		app.controller("pageDesignerCtr",function($scope,$timeout,$sce,$compile){
			
			$scope.uisrc=$sce.trustAsResourceUrl("../uilibrary/Component.jsp?pageId={0}&packageId={1}".formatValue(pageId,packageId));
			
			$scope.toolsdata = window.toolsdata;
			$scope.datastreamAdded = function(e,item){
				var p = $('<span class="component u-dragicon cui-icon"></span>');
                p.html($(this).html());
				return p;
			}
			
			$scope.onDrag = function(e,item){
				var offset = item.helper.offset();
				moveArrow({x:offset.left,y:offset.top+item.helper.height()});
			}
			$scope.onStart = function(e){
				initCoordinate();
			}
			$scope.onStop = function(e,item){
				$("#arrow").hide();
			}
			$scope.onDrop = function(e,item){
				var method = item.draggable.data("method");
				var offset = item.helper.offset();
				console.log(item.draggable.data())
				layoutDrag[method].StopDrag.call(this,{x:offset.left,y:offset.top+item.helper.height()},item.draggable);
			};
			$scope.onOut = function(e,ui){
				ui.helper.css('border','1px dotted #ccc');
				$("#arrow").hide();
			}
			$scope.onOver = function(e,ui){
				ui.helper.css('border','1px dotted red');
				$("#arrow").show();
			}
			$scope.uiOut = function(e,ui){
				ui.helper.css('border','1px dotted #ccc');
			}
			$scope.uiOver = function(e,ui){
				ui.helper.css('border','1px dotted red');
			}
			$scope.uiDrop = function(e,ui){
				var uitype = ui.draggable.data("type");
				var tdid = $(e.target).attr("id"),
				componentModelId= ui.draggable.data("modelid"),
				ui = createUI(componentModelId),scope = $("body").scope();
				_cdata.insert(tdid,ui);

				scope.id=[ui.id];
				afterRender.add(function(){
                    $("#"+ui.id+"_indicator").addClass("selected").show();
                })
			}
			//组件中的配置
			$scope.options = {helper:$scope.datastreamAdded,revert: 'invalid',appendTo: 'body'};
			
			$scope.f = function(a){
				return a.children.length>0 &&  a.componentType!='layout';
			}

			$scope.currentTab = "common";
			$scope.isActiveTab = function(tabtitle){
				return tabtitle == $scope.currentTab;
			};

			$timeout(function(){
				$scope.autoheight = {height:"calc(100% - "+$("#topsection").outerHeight()+"px)"};
			})
			
			$scope.switchTab = function(e,index,child){
				$scope.currentTab = child.componentType;
				$timeout(function(){$scope.autoheight = {height:"calc(100% - "+$("#topsection").outerHeight()+"px)"}});
			}
			$scope.id = [];
			$scope.$watch("id",function(newVal){
				console.log(newVal);
        		$("#ui-attr")[0].contentWindow.postMessage({"type":"pageDesigner","action":"id",id:newVal},"*");
    		},true);
    		$scope.togglehide = true;
			$scope.toggleHeight = "50%";
    		$scope.toggleText = $sce.trustAsHtml("&#xf078;");
    		$scope.toggleView = function(){
    			if($scope.toggleHeight=="50%"){
    			  $scope.togglehide = false;
                  $scope.toggleHeight = ($('#rightcolumn').height()-34)+"px";
                  $scope.toggleText = "&#xf077;";
                }else{
                  $scope.togglehide = true;
                  $scope.toggleHeight = "50%";
                  $scope.toggleText = "&#xf078;";
                }
    		}
			//初始化树
			comtop.UI.scan("#rightcolumn");
		});

        angular.bootstrap(document,['pageDesigner']);
        buildData();
        initMessage();
    });

	this.treeNodeSelect = function(){
		alert(1)
	}
    return {
    	init:function(){
    		console.log("初始化");
    		iniCAPEditorEvent();
    	}
    }
})