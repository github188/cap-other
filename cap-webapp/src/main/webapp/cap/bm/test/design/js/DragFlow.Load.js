 (function () {
    jsPlumb.DemoList = {
        initEleM: function (id) {
            DragFlow.makeSourceById(id);
            jsPlumb.draggable(id);
            DragFlow.makeTargetById(id);
            DragFlow.makecontextmenu(id, false);        
            Config.fastdeleteStep($("#"+id)[0]);
            $("#"+id).click(function(event){
                Config.isKeyPressed(event,id);
                DragFlow.makecontextmenu(id, false);
                Config.fastdeleteStep($("#"+id)[0]);                                   
            });
            $("#"+id).bind("drag",function(event){                
                Config.isKeyPressed(event,id);
                Config.fastdeleteStep($("#"+id)[0]);                
                                              
            });
            /**快捷复制粘贴**/
            $(document).bind("keydown",function(event){
                Config.fastCopy(event)
            });
            $(window.parent.document,document).bind("keydown",function(event){
                Config.fastCopy(event)
            });
            $("#demo_emdrap").on("mousedown",function(e){
                var mdx = e.pageX - $("#leftTools").width()-20 + $("#c-center").closest(".bl_box_center")[0].scrollLeft;
                var mdy = e.pageY + $("#main-center").closest(".bl_box_center")[0].scrollTop+$("#c-center").closest(".bl_box_center")[0].scrollTop;
                $("#clipboard").data("clipPositionX", mdx);
                $("#clipboard").data("clipPositionY", mdy);
                $(document).keydown(function(event){
                    Config.fastPaste(id,e)
                })                   
            });      
            /**控制拖动边界**/
            var odiv = $("#"+id);
            $("#"+id).bind("mousedown",function(ev){            
                var oEvent = ev || event;
                var gapX = oEvent.clientX - odiv.offset().left;
                var gapY = oEvent.clientY - odiv.offset().top;
                document.onmousemove = function (ev) {
                    var oEvent = ev || event;
                    var l = odiv.css("left").substring(0,odiv.css("left").length-2);
                    var t = odiv.css("top").substring(0,odiv.css("top").length-2);
                    var lineFrom = [],
                        lineTo = [];
                        $.each(testCaseVO.lines, function (i, line) {                
                            lineFrom[i] = (testCaseVO.lines[i].form);                 
                        })
                        $.each(testCaseVO.lines, function (j, line) {                
                            lineTo[j] = (testCaseVO.lines[j].to);                 
                    })
                    if (l < 0) {
                        odiv.css("left",0 + "px");
                        document.onmouseup=function(){                            
                            if( lineTo.indexOf(id)>=0 || lineFrom.indexOf(id)>=0){
                               jsPlumb.DemoList.refreshDateRelation(id); 
                            } 
                        }             
                    }
                    if (t < 0) {
                        odiv.css("top",0 + "px");
                        document.onmouseup=function(){ 
                            if( lineTo.indexOf(id)>=0 || lineFrom.indexOf(id)>=0){
                                jsPlumb.DemoList.refreshDateRelation(id); 
                            }
                        } 
                    } 
                }
            })                      
        },
        find: function (id) {
            for (var i = 0; i < entries.length; i++) {
                if (entries[i].id === id) {
                    var next = i < entries.length - 1 ? i + 1 : 0,
						prev = i > 0 ? i - 1 : entries.length - 1;
                    return {
                        current: entries[i],
                        prev: entries[prev],
                        next: entries[next],
                        idx: i
                    };
                }
            }
        },
        initDate: function (ejson) {
            var rData = Config.GetInitData();
            if ($.fn.isJson(ejson)) {
                rData = ejson;
            }
            var rDataP = ejson.steps, rDataR = ejson.lines;
            if (typeof (rDataP) != 'undefined'&& rDataP.length > 0 && rDataP[0].x==null) {
                $.each(rDataP, function (j, itemP) {
                    /**计算x y轴为null**/
                    rDataP[0].x=60;
                    rDataP[0].y=0; 
                    if(rDataP[j-1]){
                        rDataP[j].x=292+rDataP[j-1].x;                           
                        if(rDataP[j].x>window.screen.width-390){
                            for(var k=j;k<rDataP.length;k++){                                  
                                rDataP[k].x=60;                     
                                rDataP[k].y=100+rDataP[j-1].y;                                                                         
                            }
                        }else{
                               // rDataP[j].y+=50
                        }                            
                    }
                    if(itemP.type=="BASIC"){
                        itemP.y+=21.5;
                    }                                                        
                    Config.LoadDrapDiv(itemP.id, '', itemP.x, itemP.y, '', itemP.description, itemP.reference.icon, itemP.type,itemP.reference.steps,itemP.containCustomizedStep);
                })
            }else if(typeof (rDataP) != 'undefined'){
                $.each(rDataP, function (j, itemP){                       
                    Config.LoadDrapDiv(itemP.id, '', itemP.x, itemP.y, '', itemP.description, itemP.reference.icon, itemP.type,itemP.reference.steps,itemP.containCustomizedStep);
                })
            }
        },
        initDateRelation: function (ejson) {
        	isfirstaddrelation = false;
            var rData = Config.GetInitData();
            if ($.fn.isJson(ejson)) {
                rData = ejson;
            }
            var rDataP = ejson.steps, rDataR = ejson.lines;
            if (typeof (rDataR) != 'undefined') {
                $.each(rDataR, function (j, itemR) {
                    var IPRArray = itemR;
                    var common = { anchors: ["Continuous"], connector: ["Flowchart", { curviness: 20}], connectorStyle: { strokeStyle: "black", lineWidth: 1 }, endpoints: ["Blank"] };
                    try {
                        jsPlumb.connect({ source: IPRArray.form, target: IPRArray.to }, common);
                    } catch (ex) { }
                })
            }
            isfirstaddrelation = true;
            /**初始化连接时高度自适应***/
            var nScrollHight = $("#c-center").closest(".bl_box_center")[0].scrollHeight;
            $("#demo_emdrap").css("min-height",nScrollHight);
        },
        
        refreshDateRelation: function (id) {
           var currStepLines = tools.getStepConnLines(id);
           if(!$.isEmptyObject(currStepLines)&&currStepLines.right){
                var common = { anchors: ["Continuous"], connector: ["Flowchart", { curviness: 20}], connectorStyle: { strokeStyle: "black", lineWidth: 1 }, endpoints: ["Blank"] };
                try {
                    var conn = _.find(jsPlumb.getConnections(), {sourceId: currStepLines.right.form, targetId: currStepLines.right.to});
                    if(conn){
                        jsPlumb.detach(conn);
                    }
                    isfirstaddrelation = false;
                    jsPlumb.connect({source: currStepLines.right.form, target: currStepLines.right.to}, common);
                    isfirstaddrelation = true;
                } catch (ex) {                 
                }
            }
        },
        init: function () {           
            $(".left-container  .w_lzemay").draggable({ helper: "clone", containment:"window",stack: ".w_lzemay"
            });     
            $("#demo_emdrap").droppable({
                drop: function (event, ui) {
                     var Fdiv = ui.draggable[0];
                     var newid = Math.floor(Math.random() * 100000 + 1);
                     Config.DraggableDrapDiv(event, this, ui, newid); 
                     /**流程步骤容器高度自适应**/ 
                     var nScrollHight = $("#c-center").closest(".bl_box_center")[0].scrollHeight;
                     $("#demo_emdrap").css("min-height",nScrollHight);                                                   
                }                
            });
        }
    };
})();
