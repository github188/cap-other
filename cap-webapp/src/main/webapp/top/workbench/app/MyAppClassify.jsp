<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
    String version = formatter.format(new Date());
%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<html>
<head>
	<%//360浏览器指定webkit内核打开%>
	<meta name="renderer" content="webkit">
	<%//关闭ie兼容模式,使用最高版本文档模式渲染页面%>
	<meta http-equiv="x-ua-compatible" content="IE=edge" >
	<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/workbench/app/css/appClassify.css?v=<%=version%>" />
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/base/css/base.css?v=<%=version%>"/>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/component/requirejs/require.js?v=<%=version%>"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/component/requirejs/require.config.js?v=<%=version%>"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js?v=<%=version%>"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/base/js/base.js?v=<%=version%>"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/dwr/engine.js?v=<%=version%>"></script>
    <title>常用应用-中国南方电网</title>
    <style>
    html, body {
            background-color: #fff;
            overflow-y: auto;
        }
        .app-delete {
            position: absolute;
            right: -5px;
            top: -8px;
            height: 20px;
            width: 20px;
            background: url(${pageScope.cuiWebRoot}/top/workbench/app/img/delete-normal.png);
            cursor: pointer;
            display: none;
        }

        .app-delete:active, .app-delete:hover {
            background: url(${pageScope.cuiWebRoot}/top/workbench/app/img/delete-press.png);
        }

        .app-delete2 {
            position: absolute;
            bottom: 0px;
            right: 4px;
            float: right;
            height: 24px;
            width: 24px;
            background: url(${pageScope.cuiWebRoot}/top/workbench/app/img/delete2-normal.png);
            cursor: pointer;
            display: none;
        }

        .app-delete2:active, .app-delete2:hover {
            background: url(${pageScope.cuiWebRoot}/top/workbench/app/img/delete2-press.png);
        }
    </style>
</head>
    <body>
        <div id="app-container"> </div>
        <a id="app-delete" class="app-delete2"></a>
    	<a id="app-ok">确定</a>
        
        <script type="text/template" id="app-tmpl">
			<@ _.each(models,function(category){  @>
                <div class="app-category clearfix" id="<@= category.categoryId @>">
                    <div class="place-left"><@=category.categoryName@></div><hr/>
                </div>
                <div class="app-list">
                <@ _.each(category.apps,function(app,index){@>
                    <div data-url="/top/workbench/app.ac?appCode=<@= app.appCode @>" data-mainframe="false" target="_blank" class="app" category="<@= app.categoryId @>"
					 id="<@= app.id @>" data-sortable="sortable">        
						<div class="app-hover">
							<div class="logo-warp"></div>
                        	<img src="<@= Workbench.formatUrl(app.logo) @>" class="app-logo">
                  		</div>
						<i class="app-delete" data-app-id="<@= app.id @>"></i>
						<div class="app-name<@if(app.hasTodo){@> red-point<@}@>">
                            <@= app.name @>
                        </div>
                    </div>
                <@ });@>
                </div>
            <@ });@>

                <div data-url="${pageScope.cuiWebRoot}/top/workbench/app/MyApp.jsp" data-mainframe="false" class="app" >
                    <img src="${pageScope.cuiWebRoot}/top/workbench/app/img/app-add.png" class="app-logo">
                    <div class="app-name">
                                                                添加
                    </div>
                </div>
				
			
        </script>
        <script type="text/javascript">
            require(['underscore','workbench/dwr/interface/AppAction','cui','jqueryui'], function(_) {
            	//取消常用
            	$('#app-container').on('click', '.app-delete', function (e) {
                    e.preventDefault();
                    e.stopPropagation();
                    var $e = $(this);
                    var appId = $e.data('appId');
                    AppAction.unattention([appId], function () {
                    	var aId = '#' + appId;
                        var newOrder = $(aId).siblings();
                        var category = $(aId).attr('category');
                        $('#' + appId).remove();    
                        if(newOrder.val() == null){
                        	$('#' + category).css('display','none');
                        }
                        cui.message('取消常用应用成功', 'success');
                        
                    });
                });
            	
                //是否正在编辑中
                var isNotDelete = false;
                //触发删除事件
                	$('#app-delete').click(function () {
                    isNotDelete = true;
                    $('.app-delete').show();
                    $('#app-delete').hide();
                    $('#app-ok').show();
               		 }); 
                
                //退出编辑
                $('#app-ok').click(function () {
                    isNotDelete = false;
                    $('.app-delete').hide();
                    $('#app-delete').show();
                    $('#app-ok').hide();
                });

                $('body').mouseenter(function () {
                    if (isNotDelete) {
                        return;
                    }
                    $('#app-delete').show();
                });

                $('body').mouseleave(function () {
                    if (isNotDelete) {
                        return;
                    }
                    $('#app-delete').hide();
                });
              //删除
           
            	var categorys = [];
              	//将常用应用分类
            	function getCategory(apps){
                    if(!apps||apps.length==0){
                        return [];
                    }
                    //将应用分类
                    var categoryMap = {};
                    var other = {categoryId:'other',categoryName:'其他',apps:[]};
                    var commonApp = {categoryName:'基础应用',apps:[]};
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
                        if(apps[i].categoryName == '基础应用'){
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
                }
            	
            	//查询常用app
                AppAction.queryClassifyCommonApp(function(apps) {
                	var model = getCategory(apps);
                	var temHtml = _.template($('#app-tmpl').html(), {
                 	    models : model
                	});
                	$('#app-container').html(temHtml);
                });
                
                var tempUserDataId = null;
                /*拖动的核心代码*/
                $('#app-container').sortable({
                    items: '[data-sortable=sortable]',
                    handle: '.app-hover',
//                  helper: 'clone',
                    revert: 300,
                    delay: 100,
                    opacity: 0.8,
                    tolerance: 'pointer',//设置当拖过多少的时候开始重新排序
                    containment: 'document',//设置拖动的范围
                    stop: function (e, ui) {
                        SortAppHandle(ui);
                    }
                });
                
                //保存顺序
                function SortAppHandle(ui) {
                    var order = [];
                    var categoryOldId = ui.item.attr("category");
                    var appId = '#' + ui.item.attr("id");
                    var categoryNewId = $(appId).siblings().attr("category");
                    var newOrder = $(appId).parent().children();
                    //判断移动前和移动后的所属分类
                    if(categoryOldId != categoryNewId){
                    	$('#app-container').sortable('cancel');
                    }
                    else{
                    	for(var i = 0;i<categorys.length;i++){
                    		//判断移动所属分类
                    		if(categorys[i].categoryId == categoryOldId){
                    			//记录移动后的应用顺序
                    			for(var k = 0;k<newOrder.length;k++){
                    				for(var j = 0;j<categorys[i].apps.length;j++){
                    					if(newOrder[k].id == categorys[i].apps[j].id){
                    						order.push(categorys[i].apps[j]);
                    						break;
                    					}
                        			}
                    			}
                    			for(var i = 0;i<order.length;i++){
                    				order[i].sortNumber = i+1 ;
                    			}
                    			AppAction.updateFollowFunc(order,function(data){		
                    			});
                    			break;
                    		}
                    		
                    	}
                    }
                }
                
                //点击添加触发函数
                $('#app-container').on('click', '.app:last', function () {
                	var param = '${requestScope.sysCode}'
                	var index = param.indexOf(';');
                	if(index >0){
                		param = param.substr(0,index);
                	}
                	if(param){
                		var dataUrl = $(".app:last").attr("data-url") + "?sysCode=" + param;
                   	 	$(".app:last").attr("data-url",dataUrl);
                	} 
                });  
                
            });
 
        </script>
    </body>
</html>