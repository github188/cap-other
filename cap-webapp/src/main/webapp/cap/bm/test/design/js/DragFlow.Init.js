/// <reference path="jquery-1.4.1-vsdoc.js" />
/*
*  DragFlow初始化类，主要包括：
*  1、初始化流程默认显示样式；
*  2、解析流程步骤及步骤关系；
*  3、设置所有元素的可拖拽性、目标节点、源节点等
*  4、设置右键菜单；
*/
(function () {
    window.DragFlow = {
        init: function () {
            //jsplum默认样式
            jsPlumb.importDefaults({
                DragOptions: { cursor: "pointer", zIndex: 2000 },                
                HoverClass: "connector-hover",
                HoverPaintStyle: { strokeStyle: "#ccc" },
                Endpoint: "Rectangle",
                Anchors: ["TopCenter", "TopCenter"],
                 PaintStyle: {
                    lineWidth: 2,
                    strokeStyle: "#009900"
                },
                Overlays: [["PlainArrow", { location: 1, width: 18, length: 8}]
                                ,
               					["Label", {
                					    location: 0.1,
                					    cssClass: "aLabel"
               					}]
                    ]
            });

            var connectorStrokeColor = "rgba(50, 50, 200, 1)",
				connectorHighlightStrokeColor = "rgba(180, 180, 200, 1)",
				hoverPaintStyle = { strokeStyle: "#7ec3d9" }; 		// hover paint style is merged on normal style, so you 
            /***删除连线***/
            jsPlumb.bind("contextmenu", function (conn, originalEvent) {
            	var connStepObject = tools.queryConnStepObjectByLine({form: conn.sourceId, to: conn.targetId});
                cui.confirm("确定要删除【" + connStepObject.source.name + "】和【" + connStepObject.target.name + "】之间的连线？", {
    				onYes : function() {
    					tools.deleteLine({form: conn.sourceId, to: conn.targetId});
                    	jsPlumb.detach(conn); 
    				}
    			});
                
            });
            // 链接创建成功事件，在此事件中可以加入增加链接的逻辑,不能连接自己，不能重复连接
            jsPlumb.bind("jsPlumbConnection", function (conn,originalEvent) { 
                /**步骤连线时高度增加**/              
                var nScrollHight = $("#c-center").closest(".bl_box_center")[0].scrollHeight;
                $("#demo_emdrap").css("min-height",nScrollHight);
                /**步骤连线时宽度增加**/ 
                var nScrollWidth = $("#c-center").closest(".bl_box_center")[0].scrollWidth;
                $("#demo_emdrap").css("width",nScrollWidth+1);
                if (isfirstaddrelation) { 
                    Config.AddConnection(conn);             	 
                };
                setTimeout(function(){Config.pathConvertJson(conn.connection);}, 0);
                conn.connection.bind("mouseenter",function(connn,originalEvent){                        
                    $(window.parent.document).keydown(function(event){ 
                        if($(conn.connection.canvas).find("path").attr("stroke")=="#ccc"){
                            Config.fastdeleteLine(conn,event)
                        }                                                             
                    }); 
                    $(document).keydown(function(event){                                            
                       if($(conn.connection.canvas).find("path").attr("stroke")=="#ccc"){
                            Config.fastdeleteLine(conn,event)
                        }                        
                    });
                    var iframes=document.getElementsByTagName("iframe");
                    for(var i=0;i<iframes.length;i++)
                    {
                       $(iframes[i]).contents().keydown(function(event){                                            
                           if($(conn.connection.canvas).find("path").attr("stroke")=="#ccc"){
                            Config.fastdeleteLine(conn,event);
                           }                        
                       })
                    }                                         
                }); 
            });
            // 删除创建成功事件，在此事件中可以加入删除链接的逻辑
            jsPlumb.bind("jsPlumbConnectionDetached", function (conn) {
                Config.DelConnection(conn);
                Config.deleteLineCoordinates(conn.sourceId, conn.targetId);
            });

            DragFlow.initEndpoints("");
            // 设置所有节点为连接目标节点
            jsPlumb.makeTarget(jsPlumb.getSelector(".lzemay_wModeS"), {
                dropOptions: { hoverClass: "dragHover" },
                //anchor: "Continuous",
                anchor: "LeftMiddle",
                endpoint: "Blank"
                //anchor:"TopCenter"
            });

            // 设置可拖动的div
            jsPlumb.draggable(jsPlumb.getSelector(".lzemay_wModeS"));

            // 设置所有节点的右键菜单
            DragFlow.makecontextmenu("", true);
        }
    };
})();
