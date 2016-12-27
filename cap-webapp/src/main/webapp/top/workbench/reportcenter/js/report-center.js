define(['workbench/dwr/interface/AppAction'], function() {
    var ReportCenter = function(){};
    ReportCenter.prototype = {
        apps : [],
        menus : {},
        //获取用户安装的应用
        getInstalled : function(callback) {
            var self = this;
            AppAction.queryReportMenu(function(apps){
                self.apps = apps;
                //构造菜单id和菜单对象的json对,方便根据menuId取menu对象
                for (var i = 0; i < self.apps.length; i++) {
                    var reportMenus = self.apps[i].reportMenus;
                    for (var j = 0; j < reportMenus.length; j++) {
                        var reportMenu = reportMenus[j];
                        var secondMenus = reportMenu.secondMenus;
                        if(secondMenus && secondMenus.length > 0){
                            for (var k = 0; k < secondMenus.length; k++) {
                                var menu = secondMenus[k];
                                menu.appId = self.apps[i].id;
                                menu.appName = self.apps[i].name;
                                //构造menu映射
                                self.menus[menu.id] = menu;
                            }
                        }else if(reportMenu.name && reportMenu.url){
                            reportMenu.appId = self.apps[i].id;
                            reportMenu.appName = self.apps[i].name;
                            self.menus[reportMenu.id] = reportMenu;
                        }
                    }
                }
                //构造我关注的报表对象
                var attentionMenus = self.getAttentionMenu();
                self.apps.unshift(attentionMenus);
                callback(self.apps);
            });
        },
        getApp:function(appId){
            if(appId=='attention'){
                return this.getAttentionMenu();
            }
            for(var i=0;i<this.apps.length;i++){
                if(this.apps[i].id == appId){
                    return this.apps[i];
                }
            }
        },
        //构造我关注的报表对象
        getAttentionMenu : function() {
            var attentionMenus = {
                id : 'attention',
                name : '我的关注',
                logo : '/top/workbench/reportcenter/img/star-big.png',
                reportMenus : []
            };
            var reportMenus = attentionMenus.reportMenus;
            var attentionMenusOfApp = {};
            for (var menuId in this.menus) {
                var menu = this.menus[menuId];
                if (menu.attentionFlag) { 
                    if(!attentionMenusOfApp[menu.appId]){
                        attentionMenusOfApp[menu.appId] = [];
                        reportMenus.push({name:menu.appName,secondMenus:attentionMenusOfApp[menu.appId]});
                    }
                    attentionMenusOfApp[menu.appId].push(menu);
                }
            }
            return attentionMenus;
        },
        //关注
        attention : function(menuId, callback) {
            var self = this;
            AppAction.attention([menuId],function(){
                self.menus[menuId].attentionFlag = true;
                callback(true);
            });
        },
        //取消关注
        unAttention : function(menuId, callback) {
            var self = this;
            AppAction.unattention([menuId],function(){
                self.menus[menuId].attentionFlag = false;
                callback(true);
            });
        }
    };
    return ReportCenter;
});
