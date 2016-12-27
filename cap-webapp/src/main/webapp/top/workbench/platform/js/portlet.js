/*微件管理js文件*/
define(["json2", "cui","workbench/dwr/interface/PortletAction"], function (json2, cui) {
    'use strict';
    var PortletMgr = function (sedarchKey, portletTag) {
        /*搜索关键字*/
        this.searchKey = sedarchKey;
        /*搜索分类标记*/
        this.portletTag = portletTag;
        /*重置搜索条件*/
        this._reset = function (sedarchKey, portletTag) {
            this.searchKey = sedarchKey;
            this.portletTag = portletTag;
        }
    }

    /*查询所有的微件分类*/
    PortletMgr.prototype.queryAllTags = function (flag) {
        var selectData;
        if (flag === 'withAll') {
            selectData = [
                {id: '-1', text: '全部'}
            ];
        } else if (flag === 'NotWithAll') {
            selectData = [];
        } else {
            selectData = [];
        }

        dwr.TOPEngine.setAsync(false);
        PortletAction.queryAllTags(function (tagData) {
            for (var i = 0; i < tagData.length; i++) {
                var obj = {};
                obj.id = tagData[i]+'';
                obj.text = tagData[i];
                selectData.push(obj);
            }
        });
        dwr.TOPEngine.setAsync(true);
        return selectData;
    }
    /*构造一个微件管理对象、供页面使用*/
    var portletMgr = new PortletMgr("", "");
    return portletMgr;
});