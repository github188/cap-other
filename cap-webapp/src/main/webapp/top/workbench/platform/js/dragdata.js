define([], function() {
    var DragData = function(userId) {
        this.userId = userId;
    };
    DragData.prototype = {
        /* 初始化填充工作台demo */
        _initPlatForm : function(drag, callback) {
            callback(drag);
        },
        /* 加载各个微件的url */
        loadUrl : function() {
            $(".widget-content>iframe").each(function() {
                $(this).autoFrameHeight(webPath + $(this).data("url"));//attr('src', webPath + $(this).data("url"));
            });
        },
        // 添加工作台第一步骤、加载后台的工作台模板供选择
        _showTemplates : function() {
            alert('添加工作台');
        },
        // 显示微件列表数据展示json
        _showPortlets : function() {
        },
        // 添加微件
        addPortlet : function(portletobj, callback) {
            callback(portletobj);
        },
        // 卸载
        unInstall : function(appIds, callback) {
            callback(true);
        },
        // 获取应用分类
        getCategory : function(apps) {
            return [];
        }
    };
    return DragData;
});