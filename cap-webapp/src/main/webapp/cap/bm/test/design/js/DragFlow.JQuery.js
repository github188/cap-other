/// <reference path="jquery-1.4.1-vsdoc.js" />
/*
*  DragFlow JQuery方法类，主要包括：
*  1、初始化端点、设置目标节点、源节点；
*  2、设置右键菜单；
*  3、设置所有元素的可拖拽性、目标节点、源节点等
*  4、设置右键菜单；
*/
(function ($) {
    // 初始化端点，把所有带有ep样式元素的父节点设置为源节点
    DragFlow.initEndpoints = function (nextColour) {
        $(".ep_lzemay").each(function (i, e) {
            var p = $(e).parent();
            jsPlumb.makeSource($(e),
            {
                //parent: e,
                parent: p,
                // anchor: "Continuous",
                anchor: "RightMiddle",
                //anchor: "Continuous",
                connector: ["Flowchart", { curviness: 20}],
                connectorStyle: { strokeStyle: "#009900", lineWidth: 1 },
                endpoint: "Blank",
                maxConnections: 1,
                deleteEndpointsOnDetach: true  
            });
        });
    };
    // 设置元素为连接源节点
    DragFlow.makeSourceById = function (newid) {
        jsPlumb.makeSource($("#" + newid + "").find(".ep_lzemay"),
                            {
                                parent: newid,
                                // anchor: "Continuous",
                                anchor: "RightMiddle",
                                connector: ["Flowchart", { curviness: 20}],
                                connectorStyle: { strokeStyle: "#009900", lineWidth: 2 },
                                endpoint: "Blank",
                                maxConnections: 1
                               
                            });
    };
    // 设置连接目标节点
    DragFlow.makeTargetById = function (newid) {
        jsPlumb.makeTarget(newid, {
            dropOptions: { hoverClass: "dragHover" },
            //anchor: "Continuous",
            anchor: "LeftMiddle",
            endpoint: "Blank",
            maxConnections: 1
            //anchor:"TopCenter"
        });
    };
    // 设置元素右键菜单
    DragFlow.makecontextmenu = function (newid, isAllElements) {
        var els = $("#" + newid);
        if (isAllElements) {
            els = $(".c-center .lzemay_wMode");
        };
        els.contextMenu('myMenu1',
             {
                 onContextMenu: function (e) {
                     var plx = e.pageX - $("#demo_emdrap").offset().left;
                     var ply = e.pageY - $("#demo_emdrap").offset().top;
                     clipboardDataposition = plx + '_m_' + ply;
                     if(els.hasClass("stepclick")){
                         return true
                     }else{
                         return 
                     }                                     
                 },
                 onShowMenu: function (e, menu) {
                     if (clipboardDatastring == '') {
                         $('#paste', menu).remove();
                     }
                     return menu;
                 },
                 //菜单样式
                  menuStyle: {
                    border: '1px solid #ccc',
                    width:'140px',
                    color:'#333',
                    padding:'0'                    
                  },
                  //菜单项样式
                  itemStyle: {
                    fontFamily : 'verdana',
                    backgroundColor : '#fff',                     
                    border: 'none',
                    padding: '0px 10px',
                    lineHeight:'30px'
                    
                  },
                  //菜单项鼠标放在上面样式
                  itemHoverStyle: {
                    color: '#fff',
                    backgroundColor: '#4585e5',
                    border: 'none'
                  },
                 bindings:
                  {
                      'copy': function (t) {
                        if($(".stepclick").length>0){
                          var clipArray = [];
                          var clipnode=$(".stepclick");
                          for(var i=0;i<$(".stepclick").length;i++){
                            $("#clipboard").data("Clipboard", clipnode);                           
                          }                          
                        }else{
                          $("#clipboard").data("Clipboard", [t]);    
                          //clipboardDatastring = t.id;
                        }
                      },

                      'delete': function (t) {
                        var path = [],linecolor = [];
                        path = $("path");
                        var node = $(".stepclick");
                        for(var i=0;i<path.length;i++){
                            linecolor[i] = $(path[i]).attr("stroke") ;                       
                        } 
                        if(node.length>0){
                          for(var i=0;i<node.length;i++){                              
                             Config.DelDrapDiv(node[i])
                          }                     
                        }else{
                          Config.DelDrapDiv(t);
                        }                          
                      },
                      'deleteAll': function (t) {                           
                         cui.confirm("确认删除所有步骤?", {
                            onYes : function() {
                              $(".c-center .lzemay_wModeS").each(function (i, val) {
                                 Config.DelDrapDiv(val);
                              });
                            }
                         });
                      },                      
                  }
             });
          }

          //此对象应该放Render.js 在load的时候做一次性初始化
          $("#demo_emdrap").contextMenu('myMenu2',
                         {
                             onContextMenu: function (e) {
                                 var plx = e.pageX - $("#demo_emdrap").offset().left;
                                 var ply = e.pageY - $("#demo_emdrap").offset().top;

                                 clipboardDataposition = plx + '_m_' + ply;
                                 if ( $("#clipboard").data("Clipboard")==undefined|| testCaseVO.steps.length<=0 || $(".cui_overlay").is(":visible")) { return false; }                                 
                                 return true;
                             },
                             onShowMenu: function (e, menu) {
                                 //如果粘贴字符为空那右菜单不显示(因为drodra那边右健只有一个粘贴菜单)
                                 if ($("#clipboard").data("Clipboard")==undefined) {
                                     $('#paste', menu).remove();
                                 }
                                 return menu;
                             },
                             //菜单样式
                              menuStyle: {
                                border: '1px solid #ccc',
                                width:'140px',
                                color:'#333',
                                padding:'0'                    
                              },
                              //菜单项样式
                              itemStyle: {
                                fontFamily : 'verdana',
                                backgroundColor : '#fff',                     
                                border: 'none',
                                padding: '0px 10px',
                                lineHeight:'30px'
                                
                              },
                              //菜单项鼠标放在上面样式
                              itemHoverStyle: {
                                color: '#fff',
                                backgroundColor: '#4585e5',
                                border: 'none'
                              },
                             bindings:
                              {
                                  'paste': function (t) {
                                    var  selectNodes = $("#clipboard").data("Clipboard");
                                    var plx=[],ply=[];
                                    if ($("#clipboard").data("Clipboard")!="") {
                                         for(var i=0;i<selectNodes.length;i++){
                                            plx[0] = $("#clipboard").data("clipPositionX")>0?$("#clipboard").data("clipPositionX"):0;
                                            ply[0] = $("#clipboard").data("clipPositionY")>0?$("#clipboard").data("clipPositionY"):0;
                                            /**多节点计算坐标**/
                                            if(plx[i-1]>=0){
                                                plx[i]=plx[i-1]+$(selectNodes[i-1]).width()+50
                                            }
                                            if(ply[i-1]>=0){
                                                ply[i]=ply[i-1];
                                                if(plx[i]+$(selectNodes[i]).width()+100>=$("#demo_emdrap").width()){
                                                   ply[i]=ply[i-1]+ $(selectNodes[i-1]).height()+50;
                                                   plx[i]=plx[0] 
                                                } 
                                            }
                                            Config.PasteDrapDiv($(selectNodes[i]).attr("id"), plx[i], ply[i]);
                                        }  
                                         
                                      }
                                  },
                                  'deleteAll': function (t) {
                                     cui.confirm("确认删除所有步骤?", {
                                        onYes : function() {
                                           $(".c-center .lzemay_wModeS").each(function (i, val) {
                                           Config.DelDrapDiv(val);
                                        });
                                      }
                                  });
                              },

                              }
                         });
      })(jQuery);

  
