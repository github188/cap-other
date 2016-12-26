<%
    /**********************************************************************
	 * 用例设计页面
	 * 2016-7-1  张琳  新建、诸焕辉 修改
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<html ng-app='pageDesigner'>
	<head>
		<meta charset="UTF-8">
		<title>用例设计主页面</title>
		<top:link href="/cap/rt/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
		<top:link href="/cap/bm/test/design/css/table-layout.css"></top:link>
		<top:link href="/cap/bm/test/design/css/pageDesigner.css"></top:link>
		<top:link href="/cap/bm/test/design/css/icons.css"></top:link>
		<!--流程图-->
		<top:link href="/cap/bm/test/design/css/EmayPower.css"></top:link>
		<top:link href="/cap/bm/test/design/css/EmayPowerDemo.css"></top:link>
	</head>
	<body class="noselect" ng-controller="pageDesignerCtrl" data-ng-init="ready()">
		<div uitype="Borderlayout" id="border" is_root="true">
		    <div position="left"  width="240" show_expand_icon="true" collapsable="true" style="backgrounp-color:rgba(204, 204, 204, 0.5)">
		      <div id="leftTools" class="left-container">
		          <div class="title u-search ">
		             <span id='treesearch' uitype="ClickInput" enterable='true' editable='true' icon='search' width='220' on_iconclick="clickQuery" on_keydown="keyDownQuery" style="margin: 10px 0 0 10px;" emptytext="请输入步骤名称关键字查询"></span>
		          </div> 
		          <div class="left-menu" id="left-menu">
<!-- 		              <div class='type fix' id="best-example"> -->
<!-- 		                <div class="title"> -->
<!-- 		                   <p>最佳实践</p> -->
<!-- 		                   <img src="Images/list_arrow.png"> -->
<!-- 		                </div> -->
<!-- 		              </div> -->
		              <div class='type component fix' id="component">
		                <div class="title">
		                   <p>组合步骤</p>
		                   <img src="Images/list_arrow.png">
		                </div>
		                <ul class="list fix"></ul>                             
		              </div>
		   
		              <div class='type basic fix' id="basic">
		                <div class="title">
		                   <p>基本步骤</p>
		                   <img src="Images/list_arrow.png">
		                </div>
		                <ul class="list fix"></ul>
		              </div>                  
		          </div>
		          <div class="list fix" id="fastQueryList" style="display: none;"></div>                 
		      </div>
		    </div>
		    <div id='main-center' position="center">
		        <div class="main-panel">
		          <div id='testlay' uitype="Borderlayout" is_root='true' on_sizechange="resizeBottom">
		            <div id='c-center' class='c-center' position='center'  resizable='true' max_size='800' collapsable='true' show_expand_icon='true'> 
		                <div id="demo_emdrap"   class="ui-droppable" style="width: 100%;height: 100%"></div>
		            </div>        
		            <div id='c-bottom' class="c-bottom" position='bottom' height='320'  resizable='true' max_size='700' collapsable='true' show_expand_icon='true'>
		            	<iframe id="testStepsPropertiesEdit" frameborder="0" style="height: 100%; width: 100%;"></iframe>
		            </div>              
		         </div> 
		        </div>                                                        
		    </div>                          
		    <div position="right" width="250" show_expand_icon="true" collapsable="true" resizable="true" max_size="250" style="position:relative;overflow-y: hidden;">
		    	<iframe id="stepPropsEdit" frameborder="0" style="height: 100%; width: 100%;"></iframe>
		    </div>
		</div>
		<!--菜单栏-->
	    <div id="myMenu1" style="position: absolute; z-index: 2000; display: none;">
	        <ul>
	            <li id="copy">
	                <img src="Images/copy.gif" />
	                复制</li>	           
	            <li id="delete">
	                <img src="Images/delete.gif" />
	                删除</li>
                <li id="deleteAll">
                    <img src="Images/delete.gif" />
                    删除所有</li>          
	        </ul>
	    </div>
	    <div id="myMenu2" style="position: absolute; z-index: 2000; display: none; ">
	        <ul>           
	            <li id="paste">
	                <img src="Images/paste.gif" />
	                粘贴</li>
	            <li id="deleteAll">
	                <img src="Images/delete.gif" />
	                删除所有</li>
	        </ul>
	    </div>
	    <div id="postionconfirey" style="position: absolute; z-index: 2001; height: 1px;
	        width: 100%; background-color: Red; display: none;">
	    </div>
	    <!--快捷复制粘贴-->
		<div id="clipboard" style="display: none;"></div>
		<!--菜单end-->
		<!--未有连接线的步骤，拖拽时同时压在其他线上弹出选择窗口-->
		<div id="selectConnLineDialog" style="display: none; padding: 10px;">
			<div><span id="multiLines" uitype="PullDown" value_field="id" label_field="text" select="0" datasource="[]" width="254px"></span>&nbsp;&nbsp;<span uitype="Button" id="ensure" label="确认" on_click="selectedAutoConnLine"></span></div>
			<div style="margin-top: 8px; background-color: #F4FFEF; border: 1px solid #D6E9C6; border-left-width: 3px;"><span id="currDragStepId" uitype="Input" name="input" style="display: none;"></span><font color="red" size="1">注：如果不选择关联的位置，则不自动关联。</font></div>
		</div>
	<top:script src="/cap/bm/test/design/js/jquery.min.js"></top:script>
	<top:script src="/cap/rt/common/cui/js/comtop.ui.all.js"></top:script>
	<top:script src="/cap/bm/test/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/test/js/angular.js"></top:script>
	<top:script src="/cap/bm/test/js/cui2angularjs.js"></top:script>
	<top:script src="/cap/bm/test/js/lodash.min.js"></top:script>
	<top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src="/cap/dwr/interface/StepFacade.js"></top:script>
	<!--模板-->
	<script id="basicTemplate" type="text/template">
		<!---
			for(var i in this.data){
		-->
		<div class="fold">
        	<div class="icon-img icon-fold icon-arrowhead-pointing-to-the-right"></div>
       		<div class="+-this.data[i].icon-+ icon-img"></div>
       		<div>+-this.data[i].name-+</div>
    	</div>  
		<ul class="unfold">
		<!---
     		for(var j in this.data[i].steps){ 
		-->   
      		<li class="w_lzemay lzemay_wMode +-this.data[i].steps[j].stepType-+" modelid="+-this.data[i].steps[j].modelId-+" type="+-this.data[i].steps[j].stepType-+">
         		<div class="ep_lzemay"></div>                        
         		<div class="icon-img +-this.data[i].steps[j].icon-+"></div>
         		<span>+-this.data[i].steps[j].name-+</span>        
      		</li>      
     	<!---
     		} 
		-->  
    	</ul>   
    	<!---
			}	 
		-->
	</script>
	<script id="componentTemplate" type="text/template"> 
		<!---
			for(var i in this.data){
		-->
    	<div class="fold">
       		<div class="icon-img icon-fold icon-arrowhead-pointing-to-the-right"></div>
       		<div class="+-this.data[i].icon-+ icon-img"></div>
       		<div>+-this.data[i].name-+</div>
    	</div>   
    	<ul class="unfold">
     	<!---
     		for(var j in this.data[i].steps){ 
		-->  
      		<li class="w_lzemay lzemay_wMode +-this.data[i].steps[j].stepType-+" modelid="+-this.data[i].steps[j].modelId-+" type="+-this.data[i].steps[j].stepType-+">
         		<div class="ep_lzemay"></div>                        
         		<div class="icon-img +-this.data[i].steps[j].icon-+"></div>
         		<span>+-this.data[i].steps[j].name-+</span>
         		<div class="sub_options" style="display: none">
             		<div class="mt15 fix">
             		<!---
     					for(var k in this.data[i].steps[j].steps){ 
					-->                
                 		<div class="icon-img +-this.data[i].steps[j].steps[k].icon-+"></div>
                 		<div class=" icon-img icon-long-arrow-pointing-to-the-right"></div>             
              		<!---
						}	 
					-->	
             		</div>                
         		</div>      
      		</li>      
     		<!---
				}	 
			-->	
    	</ul> 
		<!---
			}	 
		-->	
	</script>
	<script type="text/javascript"> 
		var modelId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
	    var packageId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
	    var moduleCode = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("moduleCode"))%>;
	    var openType = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("openType"))%>;
	    var pageSession = new cap.PageStorage(modelId);
		var testCaseVO = pageSession.get("testCase");
	    var toolsData = pageSession.get("toolsData");
	    var scope = {};
	    angular.module('pageDesigner', ["cui"]).controller('pageDesignerCtrl', function ($scope) {
			$scope.data = {currSelectedStepId: null, index: 0};// 绑定对象
			
			$scope.ready=function(){
	    		scope = $scope;
	    		initIframe();
				initLeftNav(toolsData);
			    comtop.UI.scan();
		    }
			
			//监听data数据
			$scope.$watch("data.currSelectedStepId", function(newValue, oldValue){
				if(newValue != oldValue){
					sendMessage('stepPropsEdit', {type: "pageDesigner", id: newValue});
				} 
				//步骤流程中的没有步骤被选中，则隐藏右侧编辑器
				//cui("#border").setCollapse("right", newValue == null || newValue == "" ? true : false);
	    	}, true);
	    });
	    
	    /**
	     * 设置当前选中的步骤id
	     * @param stepId 步骤Id
	     */
	    function setCurrSelectedStepId(stepId){
	    	//删除步骤节点
	    	if(stepId === ""){
				sendMessage('testStepsPropertiesEdit', {type: "pageDesigner"});
		    	if(_.findIndex(testCaseVO.steps, {id: scope.data.currSelectedStepId}) == -1){
		    		scope.data.currSelectedStepId = "";
			    	scope.data.index = -1;
		    	}
	    	} else {
		    	scope.data.currSelectedStepId = stepId;
		    	scope.data.index = _.findIndex(testCaseVO.steps, {id: stepId});
		    	scrolltoTop(stepId); 
	    	}
	    	cap.digestValue(scope);
	    }
	    
	    /**
	     * 根据Id获取基本步骤
	     * @param modelId 步骤定义模型Id
	     * @return 基本步骤对象
	     */
	    function getBasicStepById(modelId){
	    	var ret = {};
	    	dwr.TOPEngine.setAsync(false);
	    	StepFacade.loadBasicStepById(modelId, function(_data){
	    		ret = _data;
		   	});
	    	dwr.TOPEngine.setAsync(true);
	    	return ret;
	    }
	    
	    //初始化左侧工具箱数据
	    function initLeftNav(data){
	    	if(data.BASIC){
	        	var jct4BasicTemplate = new jCT($('#basicTemplate').html());
	        	jct4BasicTemplate.data = data.BASIC;
	        	$(".basic .list").append(jct4BasicTemplate.Build().GetView());
        	}
        	if(data.FIXED){
        		var jct4Fixed = new jCT($('#componentTemplate').html());
	        	jct4Fixed.data = data.FIXED;
	        	$(".component .list").append(jct4Fixed.Build().GetView());
        	}
        	if(data.DYNAMIC){
        		var jct4Dynamic = new jCT($('#componentTemplate').html());
	        	jct4Dynamic.data = data.DYNAMIC;
	        	$(".component .list").append(jct4Dynamic.Build().GetView());
        	}
	    }
	    
	  	//初始化iframe
	   	function initIframe(){
		   	var attr = "modelId=" + modelId + "&packageId=" + packageId + "&moduleCode=" + moduleCode;
		   	$("#stepPropsEdit").attr("src","StepPropertiesEdit.jsp?" + attr);
		   	$("#testStepsPropertiesEdit").attr("src","TestStepsPropertiesEdit.jsp?" + attr);
	   	}
	    
	   	window.addEventListener("message", messageHandle, false);
	   	
	   	/**
	     * 接收通知
	     * @param msg
	     */
	    function messageHandle(e) {
	        if(e.data.action ==="stepDataChange"){ //步骤数据变更（右侧属性编译器）
	        	if(e.data.hasStepTitleName){
		        	resetStepTitleName(e.data.step.id, e.data.step.description);
	        	}
	        	if(e.data.step.type === "DYNAMIC" && e.data.hasRenderDynamic){
	        		customizedStep(e.data.step.id, e.data.step.containCustomizedStep, window);
	        		resetRenderDynamic(e.data.step.id, e.data.step.reference.steps, window, true);
	        	}
	           	//通知测试步骤页面，测试用例数据发生变更
	           	sendMessage('testStepsPropertiesEdit', {type: "pageDesigner"});
	        } else if(e.data.action === "stepsDataChange"){ //测试用例的测试步骤数据变更（底部属性编译器）
	        	if(scope.data.currSelectedStepId != null && scope.data.currSelectedStepId != ''){
		        	sendMessage('stepPropsEdit', {type: "pageDesigner", id: scope.data.currSelectedStepId});
	        	}
	        } else if(e.data.action === "selectedStep" && scope.data.currSelectedStepId != e.data.stepId){ //测试用例的测试步骤数据变更（底部属性编译器）
	    		$("#"+e.data.stepId).addClass("stepclick").siblings().removeClass("stepclick");
	        	scope.data.currSelectedStepId = e.data.stepId;
		    	scope.data.index = _.findIndex(testCaseVO.steps, {id: e.data.stepId});
	    		cap.digestValue(scope);
	        }
	    }
	   	
	    //选择关联线（只针对拖拽步骤同时压多根线的选择）
	   	function selectedAutoConnLine(event, self, mark){
	    	var collisionLines = cui("#multiLines").getValue();
    		var currDragStepId = cui("#currDragStepId").getValue();
	    	if(collisionLines != '' && currDragStepId != ''){
	    		var relaStepIds = collisionLines.split("|");
		    	var conn = _.find(jsPlumb.getConnections(), {sourceId: relaStepIds[0], targetId: relaStepIds[1]});
                jsPlumb.detach(conn);
	            tools.deleteLine({form: relaStepIds[0], to: relaStepIds[1]});
	            var common = { anchors: ["Continuous"], connector: ["Flowchart", { curviness: 20}], connectorStyle: { strokeStyle: "black", lineWidth: 1 }, endpoints: ["Blank"] };
	            try {
	        	    jsPlumb.connect({source: relaStepIds[0], target: currDragStepId}, common);
	        	    jsPlumb.connect({source: currDragStepId, target: relaStepIds[1]}, common);
	            } catch (ex) {
	            }
	    	}
            cui("#selectConnLineDialog").hide();
	   	}
	   	
	    /**兼容iframe快捷复制删除功能**/
	   	$("iframe").on("load",function(){
            var iframes=document.getElementsByTagName("iframe");
            /**快捷键复制**/
            for(var i=0;i<iframes.length;i++)
            {
                $(iframes[i]).contents().bind("keydown",function(event){
                    Config.fastCopy(event) 
                })
            }
            /**快捷删除***/
            $("#stepPropsEdit").contents().bind("click",function(){
                iframeFastDelete(iframes)
            })             
            $("#testStepsPropertiesEdit").contents().click(function(){           iframeFastDelete(iframes)
            })    		
        });

        /**iframe页面快捷删除特殊处理**/
        function iframeFastDelete(iframes){
    	    for(var i=0;i<iframes.length;i++){
               	$(iframes[i]).contents().find("input").keydown(function(event){
                      event.stopPropagation();
               	})
               	$(iframes[i]).contents().find("textarea").keydown(function(event){
                      event.stopPropagation();
               	})
           		$(iframes[i]).contents().keydown(function(event){
           			if(event.keyCode != 46){
           				return
           			}
                    var path = [],linecolor = [];
                    path = $("path");
                    var node = $(".stepclick");     
                    for(var j=0;j<path.length;j++){
                        linecolor[j] = $(path[j]).attr("stroke") ; 
                    } 
                    if(linecolor.indexOf("#ccc")>=0){
                        return 
                    }else  if (event.keyCode == 46 &&  $(".stepclick").length>0){
                    	 for(var k=0;k<node.length;k++){ 
                        Config.DelDrapDiv(node[k])
                        }                      
                    }                            
                }) 
            }   
        }
	</script>
	<!--流程图-->   
	<top:script src="/cap/bm/test/design/js/jquery-ui.min.js"></top:script>
	<top:script src="/cap/bm/test/design/js/jquery.jsPlumb-1.3.16-all-min.js"></top:script>
	<!--菜单-->
	<top:script src="/cap/bm/test/design/js/jquery.contextmenu.r2.packed.js"></top:script>
	<!--jsplumb配置-->
	<top:script src="/cap/bm/test/design/js/DragFlow.Config.js"></top:script>
	<top:script src="/cap/bm/test/design/js/DragFlow.Init.js"></top:script>
	<top:script src="/cap/bm/test/design/js/DragFlow.Render.js"></top:script>
	<top:script src="/cap/bm/test/design/js/DragFlow.JQuery.js"></top:script>
	<top:script src="/cap/bm/test/design/js/DragFlow.Tools.js"></top:script>
	<top:script src="/cap/bm/test/design/js/DragFlow.Load.js"></top:script>
	<top:script src="/cap/bm/test/design/js/pageDesign.js"></top:script>
	<top:script src="/cap/bm/test/design/js/testCase.utlis.js"></top:script>
	<top:script src="/cap/bm/test/js/jct.js"></top:script>
	</body>
</html>