/// <reference path="jquery-1.4.1-vsdoc.js" />
/*
*  This file contains the JS that handles the first init of each jQuery demonstration, and also switching
*  between render modes.
*/
jsPlumb.bind("ready", function () {
    isfirstaddrelation = true;
    clipboardDatastring = "";
    clipboardDataposition = "";

    // chrome fix.
    document.onselectstart = function () { return false; };

    // render mode
    var resetRenderMode = function (desiredMode) {
        var newMode = jsPlumb.setRenderMode(desiredMode);
        $(".rmode").removeClass("selected");
        $(".rmode[mode='" + newMode + "']").addClass("selected");
        $(".rmode[mode='canvas']").attr("disabled", !jsPlumb.isCanvasAvailable());
        $(".rmode[mode='svg']").attr("disabled", !jsPlumb.isSVGAvailable());
        $(".rmode[mode='vml']").attr("disabled", !jsPlumb.isVMLAvailable());
        DragFlow.init();
    };

    $(".rmode").bind("click", function () { 
        var desiredMode = $(this).attr("mode");
        if (DragFlow.reset) DragFlow.reset();
        jsPlumb.reset();
        resetRenderMode(desiredMode);
    });

    // explanation div is draggable
    resetRenderMode(jsPlumb.SVG);
    jsPlumb.DemoList.init();
    $(document).ready(function() {  
    	jsPlumb.DemoList.initDate(window.parent.testCaseVO);
    	jsPlumb.DemoList.initDateRelation(window.parent.testCaseVO);
    	Config.initAllLinesCoordinates();
    }); 
});


