<%@ include file="/top/component/common/Taglibs.jsp" %>
<head>
    <%@ page language="java" contentType="text/html; charset=GBK"    pageEncoding="GBK" %>
    <%@ include file="/top/workbench/base/Header.jsp" %>
    <link rel="stylesheet"           href="${pageScope.cuiWebRoot}/top/workbench/platform/css/portlet.css?v=<%=version%>"/>
	<link rel="stylesheet"
          href="${pageScope.cuiWebRoot}/top/workbench/platform/css/task.css?v=<%=version%>"/>
    <script type="text/javascript"   src="${pageScope.cuiWebRoot}/top/workbench/dwr/interface/PortletAction.js?v=<%=version%>"></script>

    <!--工作台模板拖动需要的css和js文件-->
    <link rel="stylesheet"           href="${pageScope.cuiWebRoot}/top/workbench/platform/css/templateBaseLayout.css?v=<%=version%>"/>
    <link rel="stylesheet"           href="${pageScope.cuiWebRoot}/top/workbench/platform/css/templateDragLayout.css?v=<%=version%>"/>
    <title>统一工作台首页</title>
</head>
<body>

<%@ include file="/top/workbench/base/MainNav.jsp" %>
<div class="app-nav">
    <img src="${pageScope.cuiWebRoot}/top/workbench/platform/img/wj_xinzen.png" class="app-logo">
    <span class="app-name">工作台模板编辑</span>
</div>
<div class="workbench-container">
    <div class="ct0pMain">
        <div class="ct0pSearch clearfix">
            <span id="goBack" class="btnBgWhite">返回</span>
            <span id="addPortlet" class="btnBg">保存</span>
        </div>
        <div class="portletMain">
            <table class="form" border="0">
                <tr>
                    <td style="width: 40px;">模板名称：<input type="hidden" id="templateId" name="tp.templateId" value="${tp.templateId}"/> </td>
                    <td><span uitype="Input" id="templateName" validate="模板名称不能为空" name="tp.templateName" value="${tp.templateName}" emptytext="最多20个文字" maxlength="20"></span></td>
                    <td style="width: 90px;">图标地址：</td>
                    <td><span uitype="Input" id="templatePic" validate="图标地址不能为空" name="tp.templatePic" value="${tp.templatePic}" emptytext="最多60个字符" maxlength="60"></span></td>
                </tr>
                <tr>
                    <td style="width: 60px;">模板类型：</td>
                    <td width="360px">
                        <div id="radio" uitype="RadioGroup" name="tp.radio" value="${tp.radio}">
                            <input type="radio" name="sex" value="0"/>默认模板
                            <input type="radio" name="sex" value="1"/>非默认模板
                            <input type="radio" name="sex" value="-1"/>超级模板
                        </div>
                    </td>
                    <td style="width: 90px;">权限编码：</td>
                    <td><span style="color: #888">${tp.rightCode}</span></td>
                </tr>
                <tr>
                    <td style="vertical-align:top;">描述信息：</td>
                    <td colspan="3">
						<span uitype="textarea" name="tp.describe"  relation="describeTxtNum" id="describe" byte="false" maxlength="200"  value="${tp.describe}" emptytext="请描述模板的主要功能" width="98%"></span>
						<div style="padding-top: 5px;">还可以输<span id="describeTxtNum" style="color: red"></span>个字</div>
					</td>
                </tr>
            </table>
        </div>

        <div class="wb-template">
            <div class="title">
                <h3>系统框架</h3>
                <span class="btnBgWhite" id="addPortletDialog">添加微件</span>
            </div>
            <div class="main">
				<div class="task-portlet-tip">当前工作台为空，是否<a href="#" id="addPortletDialogLink">添加微件</a>？</div>
                <!--<div>当前模板是空的，是否<a href="">添加微件</a>？</div>-->
                <div id="columns" class="clearfix">
                    <ul id="column1" class="column column1">
					 <c:forEach items="${tp.leftPortlet}" var="item" varStatus="status">
						<li class="widget" id="${item.portletId}"  data-target="${item.portletTag}">
                            <div class="widget-head">
                                <h3>${item.portletName}</h3>
                            </div>
                            <div class="widget-content">
                                <p>${item.portletDescribe}</p>
                            </div>
                        </li>
					 </c:forEach>
                    </ul>
                    <ul id="column2" class="column column2">
					<c:forEach items="${tp.rightPortlet}" var="item" varStatus="status">
						<li class="widget" id="${item.portletId}">
                            <div class="widget-head">
                                <h3>${item.portletName}</h3>
                            </div>
                            <div class="widget-content">
                                <p>${item.portletDescribe}</p>
                            </div>
                        </li>
					 </c:forEach>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="portletDialog" class="portlet-dialog">
    <div class="class-list-wrap">
        <ul class="class-list">
        </ul>
    </div>
    <div class="portlet-list-wrap">
        <div class="portlet-list">
        </div>
    </div>
</div>




<%--静态模板文件、该模板用于将json数据转换静态的微件html文件--%>
<script type="text/template" id="portlet-tmpl">
    <@ if(portletAry.length>0){@>
    <@ _.each(portletAry,function(portlet){ @>
    <li class="widget" id="<@= portlet.portletId @>" data-id="<@= portlet.portletId @>" data-target="<@= portlet.portletTag @>" editable="<@= portlet.editAble @>">
        <div class="widget-head">
            <h3>
                <@ if(portlet.selfName!=null){@>
                <@= portlet.selfName @>
                <@ }else{@>
                <@= portlet.portletName @>
                <@ }@>
            </h3>
        </div>
        <div class="widget-content">
            <p><@= portlet.portletDescribe @></p>
        </div>
    </li>
    <@ })}@>
</script>

<script type="text/javascript"
        src="${pageScope.cuiWebRoot}/top/workbench/dwr/interface/TemplateAction.js"></script>
<script type="text/javascript">
	(function(){
		if($('#column1').children().length === 0 && $('#column2').children().length === 0){
			$('.task-portlet-tip').show();
		}
	})();
    require(["json2", "underscore", "cui", "workbench/platform/js/templateDrag"], function (json2, _, cui,templateDrag) {
        comtop.UI.scan();
        //初始化拖拽事件
        templateDrag.init();
    });
	require(["json2", "underscore", "cui", "workbench/platform/js/templateTask"], function (json2, _, cui, PortletDialog) {
		var portletDialog;
        $('#addPortletDialog, #addPortletDialogLink').on('click', function(){
			var portletDialog;
			if(!portletDialog) {
				portletDialog = new PortletDialog();
			}
			portletDialog.show();
			return false;
		});
		
		$('#addPortlet').on('click', function(){
			var valid = window.validater.validElement(),
				isName = false;
			if(!valid[2]){
				return false;
			}
			var data, leftPortletIds = [], rightPortletIds = [];
			$('#column1>li').each(function(a, b){
				leftPortletIds.push($(b).attr('id'));
			});
			$('#column2>li').each(function(a, b){
				rightPortletIds.push($(b).attr('id'));
			});
			data = {
				leftPortletIds: leftPortletIds.join(','),
				rightPortletIds: rightPortletIds.join(','),
				opFlag: "0",
				templateId: "${tp.templateId}",
				templateName: cui('#templateName').getValue(),
				rightCode: "${tp.rightCode}",
				radio: cui('#radio').getValue(),
				describe: cui('#describe').getValue(),
                templatePic:cui('#templatePic').getValue()
			};
			
			cui.handleMask.show();
			
			dwr.TOPEngine.setAsync(false);
			TemplateAction.ifNameExist("${tp.templateId}", data.templateName, function(data){
				isName = data
			});
			dwr.TOPEngine.setAsync(true);
			if(isName){
				setTimeout(function(){
					cui.handleMask.hide();
					cui.error('模板名存在重名', function(){
						cui('#templateName').focus();
					});
				}, 500);
				return false;
			}

			TemplateAction.updateTemplate(json2.stringify(data), function(data) {
				if(data === '1'){
					setTimeout(function(){
						cui.handleMask.hide();
                        cui.message('修改成功', 'success');
                        setTimeout(function(){
                          window.location.href = "${ pageContext.request.contextPath }/top/workbench/platform/templateMain.jsp";
                        }, 1000);
					}, 500);
					return;
				}
				setTimeout(function(){
					cui.handleMask.hide();
					cui.error('修改失败');
				}, 500);
			});
		});
    });


    $("#goBack").click(function () {
        window.location.href = "${ pageContext.request.contextPath }/top/workbench/platform/templateMain.jsp";
    });
</script>
</body>
</html>
