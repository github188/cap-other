<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<%@ include file="/top/workbench/base/Header.jsp"%>
<title>�ҵ�Ӧ��-�й��Ϸ�����</title>
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/workbench/app/css/app.css?v=<%=version%>" />
</head> 
<body>
	<%@ include file="/top/workbench/base/MainNav.jsp"%>
	<div class="app-nav">
		<i class="myapp-icon place-left"></i> <span class="app-name">�ҵ�Ӧ��</span>
	</div> 
	<div id="bg"></div>
	<div class="menu-search">
		<div class="menu-title">
			<p style="padding:6px 0px 0px 10px;margin:0;width:890px;">�˵�����
			<img id="closeMenuSearch" alt="�ر�" src="img/menu-close.png" class="menu-close" />
			</p> 
		</div>
		<div class="menu-header">
			<input class="app-search empty" type="text" id="menu-name" value="�˵�����" empty_text="�˵�����" /> 
			ģ�飺<span id="menuSystem"
					uitype="PullDown"  style="margin-right:10px;" auto_complete="true" mode="Single"
					value_field="systemId" label_field="systemName" select="0"
					on_change="AppAction.systemMenuChange" datasource=""></span>
			��� <span id="menucategory" uitype="PullDown" auto_complete="true" 
				mode="Single" value_field="categoryId" label_field="categoryName" select="0" 
				on_change="AppAction.filterMenu" datasource=""></span> 
			<div id="menu-searchs"></div>
		</div>
	</div> 
	<div class="workbench-container box">
		<div class="myapp-container" id="myapp-container">
			<div class="app-header">
				<input class="app-search empty" type="text" id="app-name"
					value="Ӧ������" empty_text="Ӧ������" /> 
				ģ�飺<span id="system" uitype="PullDown" style="margin-right:10px;" auto_complete="true" mode="Single" value_field="systemId" label_field="systemName" select="0"
					on_change="AppAction.systemChange" datasource=""></span> 
				���<span id="category" uitype="PullDown" auto_complete="true" mode="Single" value_field="categoryId" label_field="categoryName" select="0"
					on_change="AppAction.filterApp" datasource=""></span> 
					<a class="pull-right app-manager" href="${pageScope.cuiWebRoot}/top/workbench/app/AppUpdateRecord.jsp">���¼�¼</a>
					<a class="pull-right menu-manager" id="menuSearchTag"
						href="${pageScope.cuiWebRoot}/top/workbench/app/AppUpdateRecord.jsp">�˵�����</a>
			</div>
			<div id="my-apps"></div>
		</div>
		<div class="goto-top" title="�ص�����"></div>
	</div>
	<div class="nav-anchor">
		<div class="nav-anchor-menu" id="nav" style="display: none;">
			<ul class="nav nav-list" id="nav-list"> 
			</ul>
		</div>
		<a class="btn" id="test" data-toggle="hide" data-target="nav"
			href="javascript:void(0);"> ��ݵ��� </a>
	</div>
	
	<div class="load-tip">Ŭ�������У����Ժ�</div> 
	<script type="text/template" id="menu-tmpl">
            <@ _.each(models,function(category){  @>
                <div class="app-category clearfix" id="<@= category.categoryId @>">
                    <div class="place-left"><@=category.categoryName@></div><hr/>
                </div>
                <div class="app-list">
                <@ _.each(category.apps,function(app,index){@>
                    <a data-url="/top/workbench/app.ac?appCode=<@= app.appCode @>" target="_blank" class="app" category="<@= app.categoryId @>">
                    <div class="app-name<@if(app.hasTodo){@> red-point<@}@>">
                        <@= app.name @>
                    </div>
                    <img src="<@= Workbench.formatUrl(app.logo) @>" class="app-logo">
                	</a>
					<div style="float:right; width:700px;">
						<ul style="list-style:none;width:100%">
							<@ _.each(app.businessMenus, function(businessmenu, index){ @>
								<li style="float:left;margin-top:8px;width:30%">
									<a title="<@=businessmenu.menuNamePath @>" data-url="/top/workbench/app.ac?appCode=<@= app.appCode @>&url=menusearch#menuId=<@=businessmenu.id @>&url=<@=businessmenu.url @>" target='_blank'><@=businessmenu.name @></a>
								</li>
							<@ }); @>
						</ul>
					</div>
                <@ });@>
                </div>
            <@ });@>
        </script>
        
     <script type="text/template" id="app-tmpl">
            <@ _.each(models,function(category){  @>
                <div class="app-category clearfix" id="<@= category.categoryId @>">
                    <div class="place-left"><@=category.categoryName@></div><hr/>
                </div>
                <div class="app-list">
                <@ _.each(category.apps,function(app,index){@>
                    <a data-url="/top/workbench/app.ac?appCode=<@= app.appCode @>" target="_blank" class="app" category="<@= app.categoryId @>">
                    <div class="app-name<@if(app.hasTodo){@> red-point<@}@>">
                        <@= app.name @>
                    </div>
                    <img src="<@= Workbench.formatUrl(app.logo) @>" class="app-logo">
                    <div class="app-op clearfix">
                        <@if(app.isCommon){@>
                            <div class="pull-right op-name cancel-common" data-app-id="<@=app.id@>">ȡ������</div>
                            <div class="pull-right op-state">����</div>
                        <@ }else{@>
                            <div class="pull-right op-name set-common" data-app-id="<@=app.id@>">��Ϊ����</div>
                        <@}@>        
                    </div>
                </a>
                <@ });@>
                </div>
            <@ });@>
        </script>
	<script type="text/javascript">
		var page = 'MyApp';
		require(
				[ 'workbench/app/js/app'],
				function(AppAction) {
					$('#menuSearchTag,#closeMenuSearch').on(
						 'click', function(e){
							 e.preventDefault();
							 e.stopPropagation();
							 $('#menu-searchs')[0].innerHTML = '';
			        		 $('#menu-searchs').html('<div id="menu_tag" flag="false" class="empty-menu">��������Ҫ���ҵĲ˵����ơ�</div>');
			        		 cui('#menucategory').setValue('all'); 
			        		 $('#menu-name').addClass('empty').val($('#menu-name').attr('empty_text'));
			        		 if($("body").eq(0).hasClass('body_overflow')){
			        			 $("body").eq(0).removeClass('body_overflow');
			        		 }else{
				        		 $("body").eq(0).addClass('body_overflow');
			        		 }
			        		 $('#bg').toggle();
							 $('.menu-search').toggle();
						 }
					);
			
					$('#myapp-container')
							.on('click','.set-common',
									function(e) {
										e.preventDefault();
										e.stopPropagation();
										var $e = $(this);
										var appId = $e.data('appId');
										AppAction.attention( [ appId ],
											function() {
												$e.html('ȡ������').removeClass('set-common')
														.addClass('cancel-common');
												$e.after('<div class="pull-right op-state">����</div>');
												cui.message('��ӵ���ҳ����Ӧ�óɹ�','success');
											});
									})
							.on(
									'click', '.cancel-common',
									function(e) {
										e.preventDefault();
										e.stopPropagation();
										var $e = $(this);
										var appId = $e.data('appId');
										AppAction.unattention([ appId ],
												function() {
													$e.html('��Ϊ����').removeClass('cancel-common')
															.addClass('set-common');
													$e.next('.op-state').remove();
													cui.message('ȡ����ҳ����Ӧ�óɹ�','success');
												});
									});
				});
		//��ʼ��ҳ����С�߶�
		$(window).resize(function() {
			$('#myapp-container').setMinHeight($(window).height() - 135);
			$('#nav-list').css('max-height', $(window).height() - 200);
		}).resize();
	</script>
</body>
</html>