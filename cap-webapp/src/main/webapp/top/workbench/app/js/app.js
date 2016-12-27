define(['underscore', 'workbench/dwr/interface/AppAction','workbench/dwr/interface/ModuleAction', 'cui'], function(_){
    //格式化数据,组装成分类数据格式
    AppAction.getCategory = function(apps){
        if(!apps||apps.length==0){
            return [];
        }
        //将应用分类
        var categorys = [];
        var categoryMap = {};
        var other = {categoryId:'other',categoryName:'其他',apps:[]};
        var commonApp = {categoryCode:'commonApps',categoryName:'公共应用',apps:[]};
        for(var i=0;i<apps.length;i++){
            if(!apps[i].categoryId){
                apps[i].categoryId = 'other';
                apps[i].categoryName = '其他';
            }
            //其他
            if(apps[i].categoryId == 'other'){
                other.apps.push(apps[i]);
                continue;
            }
            //公共应用
            if(apps[i].categoryCode == 'commonApps'){
                commonApp.categoryId = apps[i].categoryId;
                commonApp.apps.push(apps[i]);
                continue;
            }
            var appsOfCat = categoryMap[apps[i].categoryId];
            if(appsOfCat){
                appsOfCat.push(apps[i]);
            }else{
                categoryMap[apps[i].categoryId] = [apps[i]];
                categorys.push({categoryId:apps[i].categoryId,categoryName:apps[i].categoryName,apps:categoryMap[apps[i].categoryId]});
            }
        }
        if(other.apps.length>0){
            categorys.push(other);
        }
        //将公共应用压入最前边
        if(commonApp.apps.length>0){
            categorys.unshift(commonApp);
        }
        return categorys;
    };
    
    
    var oldAppName = '';
    var oldCategoryId = '';
    var oldSystemId = '';
    var i=0;
    //过滤数据
    AppAction.filterApp = function(){
        var appName = '';
        if(!$('#app-name').hasClass('empty')){
            appName = $.trim($('#app-name').val());
        }
        var categoryId = cui('#category').getValue();
        var systemId = cui('#system').getValue();
        if(oldCategoryId==categoryId && oldAppName == appName && oldSystemId == systemId){
            return;
        }
        var apps = _.filter(AppAction.apps,function(app){
            var isIn = true;
            if(systemId && systemId != 'all'){
            	isIn = (systemId == app.systemId);
            }
            if(categoryId && categoryId!='all'){
                isIn = (categoryId == app.categoryId);
            }
            if(isIn && appName){
                isIn = (app.name.indexOf(appName) != -1);
            }
            return isIn;
        });
        if(apps==null||apps.length==0){
            $('#my-apps')[0].innerHTML = '';
            $('#my-apps').html('<div class="empty-app">没有找到与搜索条件匹配的应用，请清除条件后再试。</div>');
        }else{
            var models = apps;
            if(page == 'MyApp'){
                models = AppAction.getCategory(apps);
            }
            var temHtml = _.template($('#app-tmpl').html(), {
                models : models
            });
            $('#my-apps')[0].innerHTML = '';
            $('#my-apps').html(temHtml);
            //设置我的应用内容框高度，便于通过快捷菜单准确定位
            if(i==0){
            //仅当我的应用分类列表大于1时才设置高度。
              if(models.length>1){
            	$('#my-apps').height($('#my-apps').height()+490);
              }
              i=1;
            }
        }
        if(categoryId && categoryId!='all'){
            $('#nav').hide();
        }
        oldAppName = appName;
        oldCategoryId = categoryId;
        oldSystemId = systemId;
    };
    //加载事件
    $('#app-name').keypress(function(e){
        if(e.which==13){
            AppAction.filterApp();
        }
    }).blur(function(){
        AppAction.filterApp();
        var $this = $(this);
        if(!$.trim($this.val())){
            $this.addClass('empty').val($this.attr('empty_text'));
        }
    }).focus(function(){
        var $this = $(this);
        if($this.hasClass('empty')){
            $(this).removeClass('empty').val('');
        }
    });
    
  //加载事件
    $('#menu-name').keypress(function(e){
        if(e.which==13){
            AppAction.filterMenu();
        }
    }).blur(function(){
        AppAction.filterMenu();
        var $this = $(this);
        if(!$.trim($this.val())){
            $this.addClass('empty').val($this.attr('empty_text'));
        }
    }).focus(function(){
        var $this = $(this);
        if($this.hasClass('empty')){
            $(this).removeClass('empty').val('');
        }
    });
    //格式化数据,组装成分类数据格式
    AppAction.getCategoryMenu = function(apps){
        if(!apps||apps.length==0){
            return [];
        }
        //将应用分类
        var categorys = [];
        var categoryMap = {};
        var other = {categoryId:'other',categoryName:'其他',apps:[]};
        for(var i=0;i<apps.length;i++){
            if(!apps[i].categoryId){
                apps[i].categoryId = 'other';
                apps[i].categoryName = '其他';
            }
            //其他
            if(apps[i].categoryId == 'other'){
                other.apps.push(apps[i]);
                continue;
            } 
            var appsOfCat = categoryMap[apps[i].categoryId];
            if(appsOfCat){
                appsOfCat.push(apps[i]);
            }else{
                categoryMap[apps[i].categoryId] = [apps[i]];
                categorys.push({categoryId:apps[i].categoryId,categoryName:apps[i].categoryName,apps:categoryMap[apps[i].categoryId]});
            }
        }
        if(other.apps.length>0){
            categorys.push(other);
        }
        return categorys;
    };
    
    var oldMenuCategoryId = '';
    var oldMenuName = '';
    var oldMenuSystemId = '';
   
    //格式化数据，组装系统下的分类类别 
    AppAction.getCategorySystem = function(apps){
    	var systems = [];
    	var systemMap = {};
    	for(var i=0;i<apps.length;i++){
    		var appsOfCat = systemMap[apps[i].systemId];
            if(appsOfCat){
            	var isCopy = false;
            	for(var j=0;j<appsOfCat.length;j++){
            		if(appsOfCat[j] == apps[i].categoryId){
            			isCopy = true;
            		}
            	}
            	if(!isCopy){
            		appsOfCat.push(apps[i].categoryId);
            	}
            }else{
            	systemMap[apps[i].systemId] = [apps[i].categoryId];
            	systems.push({systemId:apps[i].systemId,systemName:apps[i].systemName,categorys:systemMap[apps[i].systemId]});
            }
    	}
    	return systems;
    }
    
    //过滤数据
    AppAction.filterMenu = function(){
    	var menuName = '';
    	if($('#menu_tag').attr('flag') == 'false'){
    		oldMenuName = '';
    		oldMenuCategoryId = '';
    		oldMenuSystemId = '';
    		$('#menu_tag').attr('flag','true');
    	}
        if(!$('#menu-name').hasClass('empty')){
            menuName = $.trim($('#menu-name').val());
        }
        var menuCategoryId = cui('#menucategory').getValue();
        var systemId = cui('#menuSystem').getValue();
        if((oldMenuCategoryId==menuCategoryId && oldMenuName == menuName && oldMenuSystemId == systemId)||(menuName == '')){
            return;
        }
        AppAction.queryAppMenu(menuCategoryId, menuName,systemId, function(menus){
        	  if(menus == null || menus.length == 0){
        		  $('#menu-searchs')[0].innerHTML = '';
        		  $('#menu-searchs').html('<div class="empty-menu">没有找到与搜索条件匹配的菜单，请清除条件后再试。</div>');
        	  }else{
        		  var models = AppAction.getCategoryMenu(menus);
        		  var temHtml = _.template($('#menu-tmpl').html(),{
        			  models : models
        		  });
        		  $('#menu-searchs')[0].innerHTML = '';
                  $('#menu-searchs').html(temHtml);
        	  }
        });
        oldMenuName = menuName;
        oldMenuCategoryId = menuCategoryId;
        oldMenuSystemId = systemId;
    };
    
    //菜单搜索中模块下拉框改变调用函数
    AppAction.systemChange = function(categoryId){
    	var value = cui('#system').getValue();
    	var appName = '';
        if(!$('#app-name').hasClass('empty')){
            appName = $.trim($('#app-name').val());
        }
    	if(value == 'all' || !categoryId){
    		cui('#system').setValue('all');
    		cui('#category').setDatasource([{categoryId:'all',categoryName:'全部'}].concat(categorys));
    		cui('#category').setValue('all');
    	}
    	else{
    		var hasSystemId = true;
        	var i = 0;
        	var data = [];
    		while(hasSystemId  && i < systems.length){
        		if(systems[i].systemId == value){
        			var category = systems[i].categorys;
        			for(var j =0;j<category.length;j++){
        				var tag = true;
        				var k = 0;
        				while(tag && k < categorys.length){
        						if(categorys[k].categoryId == category[j]){
            						data.push(categorys[k]);
            						tag = false;
            					}
        					k++;
        				}
        	    	}
        			hasSystemId = false;
        		}
        		i++;
        	}
    		if(data.length != 1){
    			cui('#category').setDatasource([{categoryId:'all',categoryName:'全部'}].concat(data));
        		cui('#category').setValue('all');
    		}
    		else{
    			cui('#category').setDatasource(data);
    			cui('#category').setValue(data[0].categoryId);
    		}
    		
    		if (typeof categoryId == 'object' && categoryId){
                var apps =[];
                for(var i = 0;i<data.length;i++){
                    var fliterApps = _.filter(AppAction.apps,function (app){
                      var isIn = true;
                      if(data[i].categoryId && data[i].categoryId!='all'){
                          isIn = (data[i].categoryId == app.categoryId);
                      }
                      if(isIn && appName){
                          isIn = (app.name.indexOf(appName) != -1);
                      }
                      return isIn;
                  });
                    for(var j = 0;j< fliterApps.length;j++){
                    	apps.push(fliterApps[j]);
                    }
                    
               }if(apps==null||apps.length==0){
                   $('#my-apps')[0].innerHTML = '';
                   $('#my-apps').html('<div class="empty-app">没有找到与搜索条件匹配的应用，请清除条件后再试。</div>');
               }else{
            	   var models = apps;
                   if(page == 'MyApp'){
                       models = AppAction.getCategory(apps);
                   }
                   var temHtml = _.template($('#app-tmpl').html(), {
                       models : models
                   });
                   $('#my-apps')[0].innerHTML = '';
                   $('#my-apps').html(temHtml);
                   //设置我的应用内容框高度，便于通过快捷菜单准确定位
                   if(i==0){
                   //仅当我的应用分类列表大于1时才设置高度。
                     if(models.length>1){
                   	$('#my-apps').height($('#my-apps').height()+490);
                     }
                     i=1;
                   }
               }
               oldCategoryId = '';
          }
    		
    	  else{
    			cui('#category').setValue(categoryId);
    	  }
    	}
    };
    
    //菜单搜索中模块下拉框改变调用函数
    AppAction.systemMenuChange = function(categoryId){
    	var value = cui('#menuSystem').getValue();
    	var menuCategoryId = cui('#menucategory').getValue();
    	//获取菜单搜索框输入值
    	var menuName = '';
    	if($('#menu_tag').attr('flag') == 'false'){
    		oldMenuName = '';
    		oldMenuCategoryId = '';
    		$('#menu_tag').attr('flag','true');
    	}
        if(!$('#menu-name').hasClass('empty')){
            menuName = $.trim($('#menu-name').val());
        }
        
    	if(value == 'all' || !categoryId){
    		cui('#menuSystem').setValue('all');
    		cui('#menucategory').setDatasource([{categoryId:'all',categoryName:'全部'}].concat(menuCatagorys));
    		cui('#menucategory').setValue('all');
    		
    	}
    	else{
    		var hasSystemId = true;
        	var i = 0;
        	var data = [];
    		while(hasSystemId && i< menuSystems.length){
        		if(menuSystems[i].systemId == value){
        			var category = systems[i].categorys;
        			for(var j =0;j<category.length;j++){
        				var tag = true;
        				var k = 0;
        				while(tag && k < menuCatagorys.length){
        					if(menuCatagorys[k].categoryId){
        						if(menuCatagorys[k].categoryId == category[j]){
            						data.push(menuCatagorys[k]);
            						tag = false;
            					}
        					}
        					k++;
        				}
        	    	}
        			hasSystemId = false;
        		}
        		i++;
        	}
    		if(data.length != 1){
    			cui('#menucategory').setDatasource([{categoryId:'all',categoryName:'全部'}].concat(data));
        		cui('#menucategory').setValue('all');
    		}
    		else{
    			cui('#menucategory').setDatasource(data);
    			cui('#menucategory').setValue(data[0].categoryId);
    		}
    		if(menuName != ''){
    			AppAction.queryAppMenu(menuCategoryId, menuName,value, function(menus){
    	          	  if(menus == null || menus.length == 0){
    	          		  $('#menu-searchs')[0].innerHTML = '';
    	          		  $('#menu-searchs').html('<div class="empty-menu">没有找到与搜索条件匹配的菜单，请清除条件后再试。</div>');
    	          	  }else{
    	          		  var models = AppAction.getCategoryMenu(menus);
    	          		  var temHtml = _.template($('#menu-tmpl').html(),{
    	          			  models : models
    	          		  });
    	          		  $('#menu-searchs')[0].innerHTML = '';
    	                    $('#menu-searchs').html(temHtml);
    	          	  }
    	          });
    			oldMenuCategoryId = '';
    		}
    		
    		/*if(data.length!=0){
    			cui('#menucategory').setValue(data[0].categoryId);
    		}*/
    	}
    };
    
    
    var categorys = [];
    var systems = [];
    var menuCatagorys = [];
    var menuSystems = [];
    comtop.UI.scan();
    AppAction.queryAllApp(function(apps) {
    	//获取工作台传来的url中的参数
    	var param = window.location.search;
    	var exp = /(sysCode=(\w+))/i;
    	var systemIdHash = param.match(exp);
        $('.load-tip').hide();
        AppAction.apps = apps;
        //将应用分类
        categorys = AppAction.getCategory(apps);
		systems = AppAction.getCategorySystem(apps);
		//页面是从常用应用进入
		if(systemIdHash){
			cui('#system').setDatasource([{systemId:'all',systemName:'全部'}].concat(systems));
			//如果url中有sysCode，则把模块设置为相应数据
			if(systemIdHash[2]){
				ModuleAction.getModule(systemIdHash[2],function(data){
					if(data){
						var i = 0;
						var tag = true;
						while(i<systems.length && tag){
							if(systems[i].systemId == data.moduleId){
								cui('#system').setValue(systems[i].systemId);
								tag = false;
							}
							i++;
						}
					}
					else{
						cui('#system').setValue('all');
					}
				});
			}
			else{
				cui('#system').setValue('all');
			}
		}
		//页面是从应用菜单进入
		else{
			cui('#system').setDatasource([{systemId:'all',systemName:'全部'}].concat(systems));
	        cui('#system').setValue('all');
			cui('#category').setDatasource([{categoryId:'all',categoryName:'全部'}].concat(categorys));
	        cui('#category').setValue('all');
		}
		
        //菜单搜索下拉框设置
        menuCatagorys = AppAction.getCategory(apps);
        menuCatagorys.shift();
        if(systems[0].categorys.length == 1){
        	menuSystems = AppAction.getCategorySystem(apps);
        	menuSystems.shift();
        }
        else{
        	menuSystems = systems;
        }
        var i = 0;
        cui('#menucategory').setDatasource([{categoryId:'all',categoryName:'全部'}].concat(menuCatagorys));
        cui('#menucategory').setValue('all');
        cui('#menuSystem').setDatasource([{systemId:'all',systemName:'全部'}].concat(menuSystems));
        cui('#menuSystem').setValue('all');
        if($('#nav-list').length>0){
            var navList = '';
            for(var i=0;i<categorys.length;i++){
                var category = categorys[i];
                navList += '<li><a href="#'+category.categoryId+'">'+category.categoryName+'</a></li>';
            }
            $('#nav-list').html(navList);
            //导航
            $(document.body).scrollspy({target:"#nav"});
        }
    });
    $(document.body).on('click','[data-toggle=hide]',function(){
        var targetId = $(this).data('target');
        $('#' + targetId).toggle();
        if($('#' + targetId).is(':hidden')){
            $(this).removeClass('active');
        }else{
            $(this).addClass('active');
        }
    });
    return AppAction;
});