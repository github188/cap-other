/** 菜单* */
$(function() {
	resizeToolheight(); 
	$(window).resize(function(){
	  resizeToolheight()
    })
	$(".left-menu .type .title").click(function() {
		$(this).next().toggle();
		$(this).find("img").toggleClass("rotate180");
		if ($(this).next().is(":visible")) {
			$(this).next().find(".unfold").hide();
			$(this).next().find(".fold .icon-fold").removeClass("rotate90");
		}

	})
	$(".list .fold").click(function() {
		$(this).next().toggle();
		$(this).find(".icon-fold").toggleClass("rotate90");

	});
	/** 自定义扩展按钮* */
	var arrow = [ "&#xf0d8;", "&#xf0d7;" ];
	$("#c-bottom").closest(".bl_bottom").prepend(
			"<a class='bl_fold bl_unfold cui-icon test-icon'>" + arrow[0]
					+ "</a>")
   /** 设置中间区域上下的位置和高度 **/
	$(".test-icon").click(function() {
		$(this).toggleClass("rotate180 br-down")
		bottomHeight();
		$(window).resize(function(){			 
		   bottomHeight();
		})
	})
    
	function bottomHeight(){
		 var bh = $("#c-bottom").attr('height');
		    var ch =  $("#c-center").closest(".bl_box_center").height();
		    var vh = $("#testlay").height();
			if ($(".test-icon").hasClass("rotate180 br-down")) {
			$("#c-bottom").closest(".bl_bottom").height(vh);
			$("#c-bottom").closest(".bl_box_bottom").height(vh);
			$(".cui-tab-content").height($(window).height());
			$("#c-center").closest(".bl_middle").css("margin-top",-ch);

		} else {
			$("#c-bottom").closest(".bl_bottom").height(vh-ch);
			$("#c-bottom").closest(".bl_box_bottom").height(vh-ch);
			$(".cui-tab-content").height($(window).height());
			$("#c-center").closest(".bl_middle").css("margin-top",0);
		}	
	}

	function resizeBottom() {
		var rh = $("#c-bottom").height();
		var ch = $("#c-center").height();
		$(".test-icon").click(function() {
			$("#c-bottom").closest(".bl_bottom").height(rh);
			$("#c-bottom").closest(".bl_box_bottom").height(rh);

		})
	}

})

/** 搜索功能** */
function clickQuery() {
	var keyword = cui('#treesearch').getValue();
	var keyword = cui("#treesearch").getValue().replace(new RegExp("/", "gm"),
			"//");
	keyword = keyword.replace(new RegExp("%", "gm"), "/%");
	keyword = keyword.replace(new RegExp("_", "gm"), "/_");
	keyword = keyword.replace(new RegExp("'", "gm"), "''");

	if (keyword == '') {
		$('#left-menu').show();
		$('#fastQueryList').hide();
		if ($('#left-menu .list').is(":visible")) {
			$('#left-menu .list').hide();
			$('#left-menu .list .fold').show();
			$('#left-menu .list li').show();
		}
	} else {
		$(".left-menu .w_lzemay").hide();
		$('#fastQueryList').html("")
		$(".fold").hide();
		fastQuery();

	}
	// 键盘回车键快速查询
	function keyDownQuery() {
		if (event.keyCode == 13) {
			clickQuery();
		}
	}
	function fastQuery() {
		var list = $(".left-menu .w_lzemay");		 
		var listArray = [];		 
		var basicArray = eachStep(toolsData.BASIC);
		var dynamicArray = eachStep(toolsData.DYNAMIC);
		var fixedArray = eachStep(toolsData.FIXED);
		listArray = listArray.concat(fixedArray,dynamicArray,basicArray);
		var nPos;
		var vResult = [];
		var mlist = [];
		for ( var i in listArray) {
			var sTxt = listArray[i] || '';
			nPos = find(keyword, sTxt);
			if (nPos >= 0) {
				vResult[vResult.length] = sTxt;
				mlist.push(listArray.indexOf(sTxt))
			}
		}
		var vLen = vResult.length;
		if (vLen <= 0) {
			$('#left-menu').hide();
			$('#fastQueryList').show();
			$("#fastQueryList")
					.append(
							"<div style='text-align:center;padding:30px;margin-left:-15px;font-size:12px;'>没有数据</div>");
		} else {
			$('#fastQueryList').hide();
			$('#left-menu').show();
			for (var d = 0; d < mlist.length; d++) {
				var mlist_each, listClone, testlist;
				mlist_each = mlist[d];
				testlist = list[mlist_each];
				$(testlist).show();
				$(testlist).closest(".unfold").prev().show();
				if ($(testlist).is(":hidden")) {
					if ($(testlist).closest(".list").is(":hidden")) {
						$(testlist).closest(".type").find(" .title").trigger(
								'click');
						$(testlist).closest(".list").find(".fold").trigger(
								'click');
					} else {
						$(testlist).closest(".unfold").prev()
								.find(".icon-fold").addClass("rotate90");
						$(testlist).closest(".unfold").show();
					}

				}

			}
		}
	}
	/**根据name和description查找节点**/
	function eachStep(stepType){
		var stepArray=[],stepList = [];
		var stepName = [];
		for(var i=0;i<stepType.length;i++){
             stepArray[i] = stepType[i].steps;             
             for(var j=0;j<stepArray[i].length;j++){
             	 stepName.push(stepArray[i][j].description+stepArray[i][j].name);
             }           
		}
		return stepName;
	}
}
function find(sFind, sObj) {
	var nSize = sFind.length;
	var nLen = sObj.length;
	var sCompare;
	if (nSize <= nLen) {
		for (var i = 0; i <= nLen - nSize + 1; i++) {
			sCompare = sObj.substring(i, i + nSize);
			if (sCompare == sFind) {
				return i;
			}
		}
	}
	return -1;
}

var directiveUI = {
	"Input" : "cui_input",
	"ClickInput" : "cui_clickinput",
	"CheckboxGroup" : "cui_checkboxgroup",
	"RadioGroup" : "cui_radiogroup",
	"Calender" : "cui_calender",
	"Pulldown" : "cui_pulldown",
	"Textarea" : "cui_textarea",
	"ListBox" : "cui_listBox",
	"Button" : "cuiButton"
};

/**
 * 根据模型Id获取测试步骤定义
 * 
 * @param toolsData
 *            工具箱
 * @param type
 *            步骤类型（BASIC、FIXED、DYNAMIC）
 * @param modelId
 *            模型Id
 */
function getTestStepDefinitionsByModelId(toolsData, modelId, type) {
	var ret = null;
	if (type) {
		ret = getTestStepDefinitions4StepGroup(toolsData[type], modelId);
	} else {
		for ( var key in toolsData) {
			ret = getTestStepDefinitions4StepGroup(toolsData[key], modelId);
			if (ret) {
				break;
			}
		}
	}
	return ret;
}

/**
 * 在步骤分组中，根据模型Id获取测试步骤定义
 * 
 * @param toolsData
 *            工具箱
 * @param type
 *            步骤类型（BASIC、FIXED、DYNAMIC）
 * @param modelId
 *            模型Id
 */
function getTestStepDefinitions4StepGroup(groups, modelId) {
	var ret = null;
	for ( var i in groups) {
		var stepDefinition = _.find(groups[i].steps, {
			modelId : modelId
		});
		if (stepDefinition) {
			ret = stepDefinition;
			break;
		}
	}
	return ret;
}

/**
 * 发送通知给子页面页面
 * 
 * @param iframeId
 *            嵌入子页面的iframe框架Id
 * @param msgData
 *            发送信息对象
 */
function sendMessage(iframeId, msgData){
   	$("#"+iframeId)[0].contentWindow.postMessage(msgData, "*");
}
/***iframe内流程图容器宽度设置,解决流程图初始化计算偏差**/
var emdrapwidth = $("body", parent.document).width()-10;
$("#demo_emdrap").css("min-width",emdrapwidth);

/**
 * 拖拽和点击步骤时定位到下方展示的当前测试步骤
 * 
 * @param id
 *         步骤Id
 */
function scrolltoTop(id){
	var container = $("#testStepsPropertiesEdit").contents().find(".teststep-table");  
	var scrollTo = $("#testStepsPropertiesEdit").contents().find("#"+id);
	$(scrollTo).find(".step-table").show();
	$(scrollTo).siblings().find(".step-table").hide();
    $(scrollTo).find(".step-title .icon-expand").addClass("rotate180")
    $(scrollTo).siblings().find(".step-title .icon-expand").removeClass("rotate180");
	if(scrollTo && scrollTo.offset() && scrollTo.offset().top){
		container.scrollTop( 
			scrollTo.offset().top - container.offset().top + container.scrollTop()-8 
		);
	}
}

/**
 * 步骤名称修改
 * @param id 步骤id
 */
function resetStepTitleName(id, titleName){
	var stepName = $("#"+id).find("span");
	$(stepName).html(titleName != null ? titleName : ""); 
    var lineFrom = [],
	    lineTo = [];
    $.each(testCaseVO.lines, function (i, line) {                
        lineFrom[i] = (testCaseVO.lines[i].form);                 
    })
    $.each(testCaseVO.lines, function (j, line) {                
        lineTo[j] = (testCaseVO.lines[j].to);                 
    })    
	if(lineFrom.indexOf(id)>=0&&lineTo.indexOf(id)>=0 || lineFrom.indexOf(id)>=0){
		jsPlumb.DemoList.refreshDateRelation(id); 
	}                   
}

/**
 * 重新渲染动态节点子步骤元素
 * @param id 步骤id
 * @param childSteps 子步骤集合
 * @param targetWindow 目标窗口
 * @param hasRefreshRelaLine 是否更新当前步骤的关联的连接线
 */
function resetRenderDynamic(id, childSteps, targetWindow, hasRefreshRelaLine){
	var targetWindow = typeof targetWindow === 'undefined' ? window : targetWindow; 
	targetWindow.$("#"+id).find(".mt15").empty();
    var $iconArray=[];
    if(childSteps && childSteps.length > 0){
        for(var i=0; i<childSteps.length; i++){                  
          var $licon =('<div class="icon-img '+ childSteps[i].icon + '"></div><div class=" icon-img icon-long-arrow-pointing-to-the-right"></div>')
          $iconArray.push($licon);
          var $domIcon = $iconArray.join("");  
        }
        targetWindow.$("#"+id).find(".mt15").append($domIcon) 
        /**组合节点个数超过10个样式处理 **/
       	var dv_num = 0; 
       	var eleImg = targetWindow.$("#"+id).find(".component-node .mt15 .icon-img");  
       	$(eleImg).each(function(){
           dv_num +=1;                                
       	});                             
       	if(dv_num>10){
           $(eleImg).slice(5,-5).hide();
           var omitBefore = $(eleImg).eq(4);
           targetWindow.$(omitBefore).replaceWith( "<div class=' icon-img' style='font-size:30px;margin-top:-17px;color:#999'>...</div>")
       	}
    }
    if(typeof hasRefreshRelaLine != 'undefined' && hasRefreshRelaLine){
    	var lineFrom = [],
    	lineTo = [];
    	$.each(testCaseVO.lines, function (i, line) {                
    		lineFrom[i] = (testCaseVO.lines[i].form);                 
    	})
    	$.each(testCaseVO.lines, function (j, line) {                
    		lineTo[j] = (testCaseVO.lines[j].to);                 
    	})    
    	if(lineFrom.indexOf(id)>=0&&lineTo.indexOf(id)>=0 || lineFrom.indexOf(id)>=0){
    		targetWindow.jsPlumb.DemoList.refreshDateRelation(id); 
    	}             
    }
}

/**设置工具箱高度**/
function resizeToolheight(){
	var toolHeight=$("body", parent.document).height()-40;
	var searchHeight = $("#leftTools .u-search").height();
	$("#left-menu").height(toolHeight-searchHeight-20);
}

//测试用例保存
function saveTestCase(){
	var ret = true;
	dwr.TOPEngine.setAsync(false);
	TestCaseFacade.saveTestCase(testCaseVO, function(result){
		ret = result;
	});
	dwr.TOPEngine.setAsync(true);
	return ret;
}

/**
 * containCustomizedStep属性判断
 * @param id 步骤id
 * @param targetWindow 目标窗口
 */
function customizedStep(id,flag,targetWindow){	
	var targetWindow = typeof targetWindow === 'undefined' ? window : targetWindow;
	var node = targetWindow.$("#"+id)
	node.css("color", flag == true ? "#ff0000" : "#333");
}


