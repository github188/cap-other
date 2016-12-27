define(['workbench/dwr/interface/AppAction','workbench/dwr/interface/UserDataAction'],function(){
    return QueryCenter = {
        dataCode:'query_center_app',
        /**
         *用户设置缓存 
         */
        userData:{},
        /**
         * 查询用户选中需要显示的应用
         * @param {Object} callback 回调,参数:userApps:选中的应用,hiddenApps:隐藏的应用,apps:所有的应用
         */
        queryUserQueryMenu:function(callback){
            var _self = this;
            AppAction.queryQueryMenu(function(apps) {
                var appMap={},app,i=0;
                for(;i<apps.length;i++){
                    app = apps[i];
                    appMap[app.id] = app;
                }
                UserDataAction.queryUserData(_self.dataCode,function(dataList){
                    var data,userData,key,userApps = [],hiddenApps=[];
                    if(dataList&&dataList.length>0){
                        userData = dataList[0]||{};
                        _self.userData = userData;
                        data = JSON.parse(userData.data);
                        //循环用户自定义数据,将用户设置显示和隐藏的过滤出来
                        for(key in data){
                            app = appMap[key];
                            if(!app)break;
                            if(data[key].display=='show'){
                                userApps.push(app);
                            }else{
                                hiddenApps.push(app);
                            }
                            appMap[key] = null;
                        }
                        //将剩余的用户未设置的应用添加到显示中去
                        for(key in appMap){
                            if(appMap[key]){
                                userApps.push(appMap[key]);
                            }
                        }
                    }else{
                        userApps = apps;
                    }
                    callback(userApps,hiddenApps,apps);
                });                
            });
        },
        /**
         * 保存用户设置
         * @param {Object} data json格式,key,value形式,key为appId,value为{display:show|hidden}
         * @param {Object} callback 回调
         */
        saveUserData:function(data,callback){
            var userData = this.userData||{};
            userData.dataCode = this.dataCode;
            userData.data = JSON.stringify(data);
            UserDataAction.save(userData,function(result){
                callback(result);
            });
        }
    };
});