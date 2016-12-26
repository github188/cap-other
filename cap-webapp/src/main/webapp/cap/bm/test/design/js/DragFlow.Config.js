;(function () {
    Config = {
        LoadList: function (id) { },       
        DraggableDrapDiv: function (event, Fwind, ui, newid) {
        	var that = this;
        	if(event.type === "mouseup"){
        		return ;
        	}
        	Fdiv = ui.draggable[0];
        	fid = Fdiv.id;
            var basicCon = $(Fdiv).find("span").html();
            var fic = $(Fdiv).find(".icon-img").attr('class');          
            /**计算坐标**/
            var plx = event.pageX - 300 + $("#c-center").closest(".bl_box_center")[0].scrollLeft; var ply = event.pageY - $(Fwind).offset().top;
            if ($(Fdiv).hasClass("FIXED")||$(Fdiv).hasClass("DYNAMIC")||$(Fdiv).hasClass("BASIC")) {//从工具箱拖拽到绘制页面进入
            	newid = fid + '_m_' + newid;
                var sub_options = $(Fdiv).find(".sub_options").html();
                var modelId=$(Fdiv).attr("modelid");
                //var plx = event.pageX - $("#newid").offset().left; var ply = event.pageY - $(Fwind).offset().top;
                if($(Fdiv).hasClass("FIXED")){                   
                    $(Fwind).append('<li modelid="'+modelId+'" class="w_lzemay lzemay_wModeS component fixoption" style="left:' + plx + 'px;top:' + (ply-41.5) + 'px;" id="' + newid + '" type="FIXED" name  modelid=""><div class="ep_lzemay"></div><div class="component-node"><div class="'+ fic + '"></div><span>' + basicCon +'</span>' +sub_options+ '</div></li>');                              
                }else if($(Fdiv).hasClass("DYNAMIC")){                       
                    $(Fwind).append('<li  modelid="'+modelId+'" class="w_lzemay lzemay_wModeS component" style="left:' + plx + 'px;top:' + (ply-41.5) + 'px;" id="' + newid + '" type="DYNAMIC" name ><div class="ep_lzemay"></div><div class="component-node"><div class=" '+ fic + '"></div><span>' + basicCon +'</span><div class="mt15 fix"></div></div></li>');
                }else if($(Fdiv).hasClass("BASIC")){
                    $(Fwind).append('<li  modelid="'+modelId+'" class="w_lzemay lzemay_wModeS" style="left:' + plx + 'px;top:' + (ply-20) + 'px;" id="' + newid + '" type="BASIC" name > <div class="ep_lzemay"></div><div class="'+ fic + '"></div><span>' + basicCon +'</span></div></li>');    
                }             
                jsPlumb.DemoList.initEleM(newid);             
                var miandrpdiv = $('#' + newid);

                /**拖拽节点坐标小于0时的处理方法**/
                var leftEle = $(miandrpdiv).css("left");                
                var leftlen = leftEle.length;                               
                if(Number(leftEle.substring(0,leftlen-2))<=0){
                    $(miandrpdiv).css("left",0)
                } 
                /**无连接步骤拖拽时容器高度自适应**/
                miandrpdiv.bind("drag",function(){
                    var targetTop = miandrpdiv[0].style.top
                    var targetHeight = Number(targetTop.substring(0,targetTop.length-2))+ Number(miandrpdiv.height());
                    if(targetHeight>$(Fwind).height()){
                       $(Fwind).height(targetHeight)    
                    }
                })                  
                miandrpdiv.bind('mousemove', function (event) { miandrpdiv.find(".ep_lzemay").show(); });
                miandrpdiv.bind('mouseleave', function (event) { miandrpdiv.find(".ep_lzemay").hide(); });
                /**点击拖拽选中当前步骤**/
                miandrpdiv.addClass("stepclick").siblings().removeClass("stepclick");
                /**组合节点个数超过10个样式处理**/
                var dv_num = 0; 
                var eleImg = $(miandrpdiv).find(".component-node .mt15 .icon-img");  
                $(eleImg).each(function(){
                	dv_num +=1;                                
                });                             
                if(dv_num>10){
                	$(eleImg).slice(5,-5).hide();
                	var omitBefore = $(eleImg).eq(4);
                	$(omitBefore).replaceWith( "<div class=' icon-img' style='font-size:30px;margin-top:-17px;color:#999'>...</div>")
                }  
                // 创建步骤对象
                var newStep = tools.createStep($(Fdiv).attr("type"), $(Fdiv).attr("modelid"), newid, $(Fdiv).attr("width"), $(Fdiv).attr("height"), plx, ply);
                if(newStep){
                	tools.insertStep(newStep);
                	//以下逻辑判断当前拖拽的步骤是否压在连接线上，从而自动链接
                	var checkResult = this.collision({offsetLeft: $(miandrpdiv)[0].offsetLeft, offsetTop: $(miandrpdiv)[0].offsetTop, offsetWidth: $(miandrpdiv)[0].offsetWidth, offsetHeight: $(miandrpdiv)[0].offsetHeight});
                	if(!$.isEmptyObject(checkResult)){
                		this.stepAutoConnLine(_.keys(checkResult), newStep.id);
                	}
                }   
            	setCurrSelectedStepId(newid);
            } else {//步骤已创建，在绘制容器中拖拽
            	var step = _.find(testCaseVO.steps, {id: $(Fdiv).attr("id")});            	
                setTimeout(function(){
                    var xlength = $(Fdiv).css("left").length,ylength = $(Fdiv).css("top").length;
                    var stepX = $(Fdiv).css("left").substring(0,xlength-2);
                    var stepY =$(Fdiv).css("top").substring(0,ylength-2);             
                    if(step){
                        step.x = stepX<0?0:stepX ;
                        step.y = stepY<0?0:stepY;
                    }
                	var relaLines = tools.getStepConnLines(step.id);
                	_.forEach(relaLines, function(line, key) {
                		if(line){
                			var conn = _.find(jsPlumb.getConnections(), {sourceId: line.form, targetId: line.to});
                			that.pathConvertJson(conn);
                		}
        			});
                	if(!relaLines.left && !relaLines.right){
                		//以下逻辑判断当前拖拽的步骤是否压在连接线上，从而自动链接
             		    var checkResult = that.collision({offsetLeft: Fdiv.offsetLeft, offsetTop: Fdiv.offsetTop, offsetWidth: Fdiv.offsetWidth, offsetHeight: Fdiv.offsetHeight});
             		    if(!$.isEmptyObject(checkResult)){
             			   that.stepAutoConnLine(_.keys(checkResult), step.id);
             		    }
                	}
                }, 0);
            }
            $("#PositionText").text($("#PositionText").text() + "__" + Math.floor($('#' + fid).position().top));
        },
        //创建DIV
        LoadDrapDiv: function (divid, sid, x, y, upstr, lowerstr, icon, type,subicon,customizedstep) {
            var emaycomparee;
            if (type == "BASIC") {
                var Ttype = divid.split('_m_')[0];
                $("#demo_emdrap").append('<div class="w_lzemay lzemay_wModeS" style="left:' + x + 'px;top:' + y + 'px;" id="' + divid + '" type="BASIC"><div class="ep_lzemay"></div><div class="icon-img '+  icon + '"></div><span>' + lowerstr + '</span></div>');
               
            }else if (type == "FIXED") {
                var newid = divid + '_m_' + sid; 
                var $iconArray=[];
                for(var i=0;i<subicon.length;i++){                  
                    var $licon =('<div class="icon-img '+  subicon[i].icon + '"></div><div class=" icon-img icon-long-arrow-pointing-to-the-right"></div>')
                    $iconArray.push($licon);
                    var $domIcon = $iconArray.join("");  
                }
                $("#demo_emdrap").append('<div class="w_lzemay lzemay_wModeS component fixoption" style="left:' + x + 'px;top:' + y + 'px;" id="' + divid + '" type="FIXED"><div class="ep_lzemay"></div><div class="component-node"><div class="icon-img '+  icon + '"></div><span>' + lowerstr + '</span><div class="mt15 fix">'+$domIcon+'</div></div></div>'); 
    
            }else if (type == "DYNAMIC") {
            	var $iconArray=[],$domIcon;
                if(subicon==null){
                    $domIcon ='';
                }else{
                	for(var i=0;i<subicon.length;i++){                  
                		var $licon =('<div class="icon-img '+  subicon[i].icon + '"></div><div class=" icon-img icon-long-arrow-pointing-to-the-right"></div>')
                		$iconArray.push($licon);
                		$domIcon = $iconArray.join("");  
                	}  
                }                  
                $("#demo_emdrap").append('<div class="w_lzemay lzemay_wModeS component fixoption" style="left:' + x + 'px;top:' + y + 'px;" id="' + divid + '" type="FIXED"><div class="ep_lzemay"></div><div class="component-node"><div class="icon-img '+  icon + '"></div><span>' + lowerstr + '</span><div class="mt15 fix">'+$domIcon+'</div></div></div>'); 
    
            }
            jsPlumb.DemoList.initEleM(divid);
              
            //为解决dorado不能绑定droppable事件的写的rubbish
            var miandrpdiv = $('#' + divid);
            //新加属性
            if(customizedstep == true){
                //miandrpdiv.find("span").before("<font color='red' style='float:left;font-size:36px;position:relative;top:6px;'>*</f>")
                miandrpdiv.css("color","#ff0000")
            } 
            miandrpdiv.bind('mousemove', function (event) { miandrpdiv.find(".ep_lzemay").show(); });
            miandrpdiv.bind('mouseleave', function (event) { miandrpdiv.find(".ep_lzemay").hide(); }); 
            /**组合节点个数超过10个样式处理**/
            var dv_num = 0; 
            var eleImg = $(miandrpdiv).find(".component-node .mt15 .icon-img");  
            $(eleImg).each(function(){
                dv_num +=1;                                
            });                             
            if(dv_num>10){
            	$(eleImg).slice(5,-5).hide();
            	var omitBefore = $(eleImg).eq(4);
            	$(omitBefore).replaceWith( "<div class=' icon-img' style='font-size:30px;margin-top:-17px;color:#999'>...</div>")
            }
        },

        //删除关系
        DelConnection: function (conn) {            
        },
        //删除关系
        DelConnectionBefore: function (conn) {
            return true;
        },
        //添加关系
        AddConnection: function (conn) {
        	if(conn.sourceId === conn.targetId){
                jsPlumb.detach(conn);
        		return;
        	}
            /**判断闭环，出现连接线条等于节点数时删除连接**/
            var steps = tools.testCaseVO.steps; //获取所有的实体
            var connector = tools.testCaseVO.lines
            if(connector.length+1 >= steps.length){
                jsPlumb.detach(conn);
                return;
            }          
//            var newstr = "connectionID:" + conn.connection.id + "初始ID：" + conn.sourceId + "," + conn.targetId; 
//            //设置连线标签 
//            conn.connection.getOverlay("label").setLabel(conn.connection.id); 
//            conn.connection.hideOverlay("label"); 
//            jsPlumb.detach(conn);
//        	if(!this.isAllowConnLine({form: conn.sourceId, to: conn.targetId})){
//        		jsPlumb.detach(conn);
//        		return;
//        	}
        	var isExist = false;
        	for(var i in testCaseVO.lines){
        		var line = testCaseVO.lines[i];
        		if(line.form === conn.sourceId && line.to === conn.targetId){
        			isExist = true;
        			break;
        		} 
        	}
        	if(!isExist){
        		tools.insertLines({form: conn.sourceId, to: conn.targetId});
        	}
        },
        //删除DIV
        DelDrapDiv: function (div) {  
        	var that = this;
        	var stepId = div.id;
            var currStepLines = tools.getStepConnLines(stepId);            
            jsPlumb.detachAllConnections(stepId);
            $('#' + stepId).remove();
            //删除测试用例对应的步骤数据
            tools.deleteStep(stepId);
            setCurrSelectedStepId("");
            if(!$.isEmptyObject(currStepLines) && currStepLines.left && currStepLines.right){
                var common = { anchors: ["Continuous"], connector: ["Flowchart", { curviness: 20}], connectorStyle: { strokeStyle: "black", lineWidth: 1 }, endpoints: ["Blank"] };
                try {
                	jsPlumb.connect({source: currStepLines.left.form, target: currStepLines.right.to}, common);
                } catch (ex) {}
                setTimeout(function(){that.deleteLineCoordinatesByStepId(stepId);}, 0);
            }
        },

        //保存流程图
        SaveFlowMap: function (div) {   
        },     

        //双击DIV
        DrapDivdblclick: function (div) {
        },

        //初始化流程图 
        LoadInitJSON: function (Json) {
            //isfirstaddrelation = false;
            $(".w_lzemay").each(function (i, elm) {

                jsPlumb.detachAllConnections(elm.id);
                $('#' + elm.id).remove();
            });
            jsPlumb.DemoList.initDate(Json);
            jsPlumb.DemoList.initDateRelation(Json);
            //isfirstaddrelation = true;
        },

        refreshDateState: function (Json) {
        	jsPlumb.DemoList.refreshDateState(Json);
        },
        
        //初始化流程图(如果LoadInitJSON没有给值，这个为默认值)
        GetInitData: function () {
            //return jQuery.parseJSON('{"rData":{"Position":[{"IPP":"begin_m_39_emaycn_59.0_emaycn_58.0_emaycn__emaycn_开始_emaycn_1"},{"IPP":"time_m_40_emaycn_309.0_emaycn_58.0_emaycn__emaycn_查询_emaycn_1"},{"IPP":"lsearch_m_41_emaycn_309.0_emaycn_162.0_emaycn__emaycn_查询_emaycn_1"},{"IPP":"kh_clients_m_42_emaycn_863.0_emaycn_143.0_emaycn__emaycn_目标组_emaycn_1"},{"IPP":"intersection_m_69_emaycn_593.0_emaycn_143.0_emaycn__emaycn_交集_emaycn_4"},{"IPP":"mb_note_m_634_emaycn_216.0_emaycn_287.0_emaycn__emaycn_短信_emaycn_4"}],"Relation":[{"IPR":"begin_m_39_emaycn_time_m_40"},{"IPR":"time_m_40_emaycn_lsearch_m_41"},{"IPR":"intersection_m_69_emaycn_kh_clients_m_42"},{"IPR":"lsearch_m_41_emaycn_intersection_m_69"}]}}');
            return '';
        },
        //设置拖动div的显示文字
        SetDrapDivStr: function (DrapDivID, Str, TYPE) { switch (TYPE) { case "TOP": $("#" + DrapDivID + ">.ep_lzemayUP").html(Str); break; case "LOWER": $("#" + DrapDivID + ">.ep_lzemayDown").html(Str); break; } },
         
        PasteDrapDiv: function (SourceId, x, y) {
            var type = $("#"+SourceId).attr("type"),
                lowerstr = $("#"+SourceId).find("span").html(),                
                randomid = Math.floor(Math.random() * 100000 + 1);
            var Copyid = 'copy_m_n_' + randomid;
            var icon = $("#"+SourceId).find(".icon-img:firstchild").attr("class");             
            if(type=='BASIC'){
                $("#demo_emdrap").append('<div class="w_lzemay lzemay_wModeS" style="left:' + x + 'px;top:' + y + 'px;" id="' + Copyid + '" type="BASIC"><div class="ep_lzemay"></div><div class="'+  icon + '"></div><span>' + lowerstr + '</span></div></div>');      
            }else if(type == "FIXED"){             
                var copy_subicon = $("#"+SourceId).find(".mt15")[0].innerHTML;
                $("#demo_emdrap").append('<div class="w_lzemay lzemay_wModeS component fixoption" style="left:' + x + 'px;top:' + y + 'px;" id="' + Copyid + '" type="FIXED"><div class="ep_lzemay"></div><div class="component-node"><div class="'+  icon + '"></div><span>' + lowerstr + '</span><div class="mt15 fix">'+ copy_subicon+'</div></div></div>');     
            }else if (type == "DYNAMIC"){                
                var copy_subicon = $("#"+SourceId).find(".mt15")[0].innerHTML;
                $("#demo_emdrap").append('<div class="w_lzemay lzemay_wModeS component fixoption" style="left:' + x + 'px;top:' + y + 'px;" id="' + Copyid + '" type="FIXED"><div class="ep_lzemay"></div><div class="component-node"><div class="'+  icon + '"></div><span>' + lowerstr + '</span><div class="mt15 fix">'+ copy_subicon+'</div></div></div>');     
            }
            jsPlumb.DemoList.initEleM(Copyid);
            if($("#"+SourceId)[0].style.color=="rgb(255, 0, 0)"){
                $("#"+Copyid).css("color","#ff0000")
            } 
            $("#"+Copyid).bind('mousemove', function (event) { $(this).find(".ep_lzemay").show(); });
            $("#"+Copyid).bind('mouseleave', function (event) { $(this).find(".ep_lzemay").hide(); });
            var sourceStep = _.find(testCaseVO.steps, {id:  $("#"+SourceId).attr("id")});
            var copyStep = $.extend(true, {}, sourceStep);
            if(copyStep){
                copyStep.id = Copyid;
                copyStep.x = x;
                copyStep.y = y;
            }
            tools.insertStep(copyStep);
            $("#"+Copyid).addClass("stepclick").siblings().removeClass("stepclick") ; 
            setCurrSelectedStepId(Copyid);     
        },
        //设置流程图的编辑状态
        SetUnDrap: function (Bol) {
            switch (Bol) {
                case "True":
                    if ($(".lzemay_wModeS").attr("class").indexOf("ui-state-disabled") >= 0) {
                        jsPlumb.setDraggable($(".lzemay_wModeS"), true);
                        jsPlumb.repaintEverything();
                        DragFlow.initEndpoints();
                        jsPlumb.bind("dblclick", function (c) {
                            if (Config.DelConnectionBefore(c)) {
                                jsPlumb.detach(c);
                            }
                        });
                        $('body').append('<div id="myMenu1" style="position: absolute; z-index: 2000; display: none;"><ul><li id="delete"><img src="Images/delete.gif" />删除</li></ul> </div>');
                        DragFlow.makecontextmenu("", true);
                    }
                    break;
                case "False":
                    jsPlumb.unbind("dblclick");
                    jsPlumb.setDraggable($(".lzemay_wModeS"), false);
                    $(".ep_lzemay").unbind();
                    //$(".lzemay_wModeS").unbind("dblclick");
                    $("#myMenu1").remove();
                    break;
                default:
                    jsPlumb.setDraggable($(".lzemay_wModeS"), true);
                    break;
            }
        },
        //判断是否允许连接
        isAllowConnLine: function (newLine) {
        	var ret = true;
        	var lines = jQuery.extend(true, [], tools.testCaseVO.lines);
        	lines.push(newLine);
        	var stepLinesMap = {form: [], to: []};
        	for(var i in lines){
        		stepLinesMap.form.push(lines[i].form);
        		stepLinesMap.to.push(lines[i].to);
        	}            
        	for(var i in tools.testCaseVO.steps){
        		var step = tools.testCaseVO.steps[i];
        		var count = _.filter(stepLinesMap.form, function(n){return n === step.id}).length;
        		if(count > 1){
        			ret = false;
        			break;
        		}
        		count = _.filter(stepLinesMap.to, function(n){return n === step.id}).length;
        		if(count > 1){
        			ret = false;
        			break;
        		}
        	}         
        	if(ret){
        		var notFormCount = _.filter(tools.testCaseVO.lines, function(n){return n.form === newLine.to}).length;
        		var notToCount = _.filter(tools.testCaseVO.lines, function(n){return n.to === newLine.form}).length;
        		if(notFormCount === notToCount && notFormCount > 0 && notToCount > 0){
        			var stepLineMap = {};
        			_.forEach(tools.testCaseVO.steps, function (step, key) {
        				stepLineMap[step.id] = {id: step.id, name: step.name, form: 0, to: 0};
    					_.forEach(tools.testCaseVO.lines, function (line, lineKey) {
    						if(line.form === step.id){
    							++stepLineMap[step.id].form;
    						} 
    					});
    					_.forEach(tools.testCaseVO.lines, function (line, lineKey) {
    						if(line.to === step.id){
    							++stepLineMap[step.id].to;
    						} 
    					});
    				});
					ret = _.filter(stepLineMap, function(n) { return n.to == 0;}).length > 1;
        		}
        	}
        	return ret;
        },
        /**
         * 检查拖拽的步骤是否压线
         * @param point 步骤节点元素
         */
        collision: function (point){
	    	var retObj = {};
	        var bx = point.offsetLeft;
	        var by = point.offsetTop;
	        var bw = point.offsetWidth;
	        var bh = point.offsetHeight;
	        var ax, ay, aw, ah;
	        _.forEach(this.linesCoordinates, function (linesCoords, key) {
	        	_.forEach(linesCoords, function (coords, coordsKey) {
	        		var firstXY = coords[0], lastXY = coords[coords.length-1];
	        		if(firstXY.x === lastXY.x){
	        			aw = 1;
	        			if(firstXY.y < lastXY.y){
	        				ax = firstXY.x;
							ay = firstXY.y;
							ah = lastXY.y - firstXY.y;
	        			} else {
	        				ax = lastXY.x;
							ay = lastXY.y;
							ah = firstXY.y - lastXY.y;
	        			}
	        		} else if(firstXY.y === lastXY.y){
	        			if(firstXY.x < lastXY.x){
	        				ax = firstXY.x;
							ay = firstXY.y;
							aw = lastXY.x - firstXY.x;
	        			} else {
	        				ax = lastXY.x;
							ay = lastXY.y;
							aw = firstXY.x - lastXY.x;
	        			}
	        			ah = 1;
	        		}
	        		if(ax + aw > bx && ax < bx + bw && ay + ah > by && ay < by + bh && retObj[key] == null) {
	        			var connStepIds = key.split("|");
	        			retObj[key] = {form: connStepIds[0], to: connStepIds[1]};
	        		}
				})
			})
			return retObj;
	    },
	    /**
         * 连接线转成坐标值对象
         * @param conn 连接线
         */
	    pathConvertJson: function(conn){
	   		var absoluteLeft = parseInt($(conn.canvas).css("left"));
	   		var absoluteTop = parseInt($(conn.canvas).css("top"));
	   		var d = $(conn.canvas).find("path:first").attr("d");
	   		var subPaths = d.split(/\sM\s|M\s/); 
	   		subPaths.splice(0, 1);
	   		var coords = [];
	   		for (var i = 0, len = subPaths.length; i < len; i++) {
	   			var xyStrAry = subPaths[i].split(" L ");
   				var currLinePaths = [];
	   			for (var j = 0, len2 = xyStrAry.length; j < len2; j++) {
	   				var xyAry = xyStrAry[j].split(/[\s,]/);
	   				currLinePaths.push({x: parseInt(xyAry[0]) + absoluteLeft, y: parseInt(xyAry[1]) + absoluteTop});
	   			}
   				coords.push(currLinePaths);
	   		}
	   		this.linesCoordinates[conn.sourceId + "|" + conn.targetId] = coords;
	   	},
	   	/**
	   	 * 初始化所有连线坐标对象（用于拖拽步骤压线时，自动连接线）
	   	 */
	   	initAllLinesCoordinates: function(){
	   		var that = this;
	   		this.linesCoordinates = {};
	   		_.forEach(jsPlumb.getConnections(), function (conn, key) {
	   			that.pathConvertJson(conn)
			});
	   	},
	   	/**
	   	 * 删除连接线坐标对象
	   	 * @param sourceId 原步骤Id
	   	 * @param targetId 目标步骤Id
	   	 */
	   	deleteLineCoordinates:function(sourceId, targetId){
	   		delete this.linesCoordinates[sourceId + "|" + targetId];
	   	},
	   	
	   	/**
	   	 * 根据步骤Id，删除关联的连接线坐标对象
	   	 * @param stepId 步骤Id
	   	 */
	   	deleteLineCoordinatesByStepId:function(stepId){
	   		var that = this;
	   		var relaCoordinates = [];
	   		//获取跟当前步骤关联的连接线对应的坐标对象
	   		_.forEach(this.linesCoordinates, function (value, key) {
	   			if(key.split("|")[0] === stepId || key.split("|")[1] === stepId){
	   				relaCoordinates.push(key);
	   			}
	   		});
	   		//执行删除操作
	   		_.forEach(relaCoordinates, function (value, key) {
	   			delete that.linesCoordinates[value];
	   		});
	   	},
	   	
	   	/**
	   	 * 新增连接线坐标对象
	   	 * @param conn 连接线
	   	 */
	   	insertLineCoordinates:function(conn){
	   		this.pathConvertJson(conn);
	   	},
	   	/**
	   	 * 步骤自定链接关联线
	   	 * @param collisionLines 被当前步骤挤压到的连接线
	   	 */
	   	stepAutoConnLine:function(collisionLines, currStepId){
		    if(collisionLines.length > 1){
			    var datasource = [];
			    _.forEach(collisionLines, function (value, key) {
			    	var relaStepIds = value.split("|");
			    	tools.queryConnStepObjectByLine({form: relaStepIds[0], to: relaStepIds[1]});
			    	var source = tools.getStep(relaStepIds[0]);
			    	var target = tools.getStep(relaStepIds[1]);
			    	datasource.push({id: value, text: "【" + source.description + "】和" + "【" + target.description + "】关联线"});
				});
			    cui("#multiLines").setDatasource(datasource);
			    cui("#currDragStepId").setValue(currStepId);
			    cui("#selectConnLineDialog").dialog({
		            title: "请选择关联的连接线",
		            width: 330,
		            height: 80,
		            left: "50%",
		            top: "20%"
		        }).show();
		    } else {
			    var relaStepIds = collisionLines[0].split("|");
			    var conn = _.find(jsPlumb.getConnections(), {sourceId: relaStepIds[0], targetId: relaStepIds[1]});
			    if(conn){
			    	jsPlumb.detach(conn);
			    	tools.deleteLine({form: relaStepIds[0], to:relaStepIds[1]});
			    	var common = { anchors: ["Continuous"], connector: ["Flowchart", { curviness: 20}], connectorStyle: { strokeStyle: "black", lineWidth: 1 }, endpoints: ["Blank"] };
			    	try {
			    		jsPlumb.connect({source: relaStepIds[0], target: currStepId}, common);
			    		jsPlumb.connect({source: currStepId, target: relaStepIds[1]}, common);
			    	} catch (ex) {
			    	}
			    }
		   }
	   	},
        /**
        * 删除步骤快捷键功能
        * @param div 当前步骤节点
        */
        fastdeleteStep:function(div){                        
            $(window.parent.document,document).keydown(function(event){
                var path = [],linecolor = [];
                    path = $("path");
                var node = $(".stepclick");  
                for(var i=0;i<path.length;i++){
                    linecolor[i] = $(path[i]).attr("stroke") ;                       
                } 
                if(linecolor.indexOf("#ccc")>=0){
                    return 
                }else  if (event.keyCode == 46 && $(div).hasClass("stepclick") ){
                    for(var i=0;i<node.length;i++){   
                       Config.DelDrapDiv(node[i])
                    }
                }else if(event && event.keyCode == 122){//捕捉F11键盘动作
               　　 window.parent.toggleFullscreenBtnState(true);
                }            
            });            
            $(document).keydown(function(event){
                var path = [],linecolor = [];
                    path = $("path");
                var node = $(".stepclick");    
                for(var i=0;i<path.length;i++){
                    linecolor[i] = $(path[i]).attr("stroke") ; 
                } 
                if(linecolor.indexOf("#ccc")>=0){
                    return 
                }else  if (event.keyCode == 46 && $(div).hasClass("stepclick") ){
                    for(var i=0;i<node.length;i++){   
                       Config.DelDrapDiv(node[i])
                    }
                }      
            });          
        }, 
        /**
        * 删除连线快捷键功能
        * @param connect 当前连线
        * @param event 事件
        */
        fastdeleteLine:function(connect,event){
        	if (event.keyCode == 46) {
        		var connStepObject = tools.queryConnStepObjectByLine({form: connect.sourceId, to: connect.targetId});
                cui.confirm("确定要删除【" + connStepObject.source.name + "】和【" + connStepObject.target.name + "】之间的连线？", {
                	onYes : function() {
                    	tools.deleteLine({form: connect.sourceId, to: connect.targetId});
                        jsPlumb.detach(connect); 
                    }
               	});         		
        	}         
        },
        /**
        * 复制多节点快捷键
        * @param event 键盘事件
        */
        fastCopy:function(event){
            if(event.keyCode == 67 && event.ctrlKey) {
            	var clipnode=$(".stepclick")
                $("#clipboard").data("Clipboard", clipnode);
                $(document).unbind("keydown");  
            }  
        },
        /**
        * 粘贴多节点快捷键
        * @param id  存储数据的节点id
        * @param event 鼠标事件
        */       
        fastPaste:function(id,e){
            var  selectNodes = $("#clipboard").data("Clipboard");          
            if (event.keyCode == 86 && event.ctrlKey && selectNodes!=undefined && ($("#"+id).hasClass("stepclick")||$(".stepclick").length<=0 )){  
                var plx=[],ply=[];
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
        /**
        * 判断是否按住ctr键选择步骤节点
        * @param id 选择的节点id
        * @param event 事件
        */                                               
        isKeyPressed:function(event,id){
        	if(event.ctrlKey==1){
        		$("#"+id).toggleClass("stepclick");
        		var slen = $(".stepclick").length,
                	sid = $(".stepclick").attr("id");
        		slen>1?setCurrSelectedStepId():setCurrSelectedStepId(sid);                               
        	}else{
        		setCurrSelectedStepId(id); 
        		$("#"+id).addClass("stepclick").siblings().removeClass("stepclick");
        	}
        } 
    }
})();
