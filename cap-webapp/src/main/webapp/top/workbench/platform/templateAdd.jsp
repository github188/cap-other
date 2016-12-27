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
                    <td style="width: 60px;">模板名称：</td>
                    <td><span uitype="Input" id="templateName" validate="模板名不能为空" name="tp.templateName" byte="false" emptytext="最多20个文字" maxlength="20"></span></td>
                    <td style="width: 60px;">图标地址：</td>
                    <td>
                        <span uitype="Input" id="templatePic" validate="图标地址不能为空" name="tp.templatePic" value="${tp.templatePic}" emptytext="最多60个字符" maxlength="60"></span><span class="pt-must">（eg：top/workbench/platform/img/template_default.png）</span>
                    </td>
                </tr>
                <tr>
                    <td style="width: 60px;">模板类型：</td>
                    <td width="280px">
                        <div id="radio" uitype="RadioGroup" name="tp.radio" value="1">
                            <input type="radio" name="sex" value="0"/>默认模板
                            <input type="radio" name="sex" value="1"/>非默认模板
                            <input type="radio" name="sex" value="-1"/>超级模板
                        </div>
                    </td>
                    <td style="width: 60px;">权限编码：</td>
                    <td><span uitype="Input" id="rightCode" validate="validatePortletRightCode" name="tp.rightCode" ></span><span class="pt-must">（注：请在top平台生成编码后填入、保存后将无法修改）</span></td>
                </tr>
                <tr>
                    <td style="vertical-align:top;">描述信息：</td>
                    <td colspan="3">
						<span uitype="textarea" name="tp.describe" relation="describeTxtNum" id="describe" byte="false" maxlength="200" emptytext="请描述模板的主要功能" width="98%"></span>
						<div style="padding-top: 5px;">还可以输<span id="describeTxtNum" style="color: red"></span>个字</div>
					</td>
                </tr>
                <tr>
                    <td colspan="4">
                        <span class="pt-must">
                            如何选择模板类型？<br/>
                            <span style="color: #888">
                            超级模板用处：当默认模板个数为0、或者虽然系统默认模板个数不为0，但某个用户都没有权限访问他们，那此时该用户初次登录系统时会使用超级模板渲染其工作台桌面.<br/>
                            默认模板用处：若默认模板个数大于0，且某个用户有访问其中一些默认模板的权限，那么该用户初次登陆系统时会使用这些默认模板渲染其工作台桌面.<br/>
                            非默认模板用处：即使某个用户有访问非默认模板的权限，其首次登陆系统也不会使用这些模板来渲染工作台桌面；但可用在添加桌面里面使用这些模板新建自己的工作台桌面
                            </span>
                        </span></td>

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
                    </ul>
                    <ul id="column2" class="column column2">
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
	var regStr = '^[\u4e00-\u9fa5_a-zA-Z0-9]+$';
	//微件权限编码验证区域
    var validatePortletRightCode = [
        {
            type: 'required',
            rule: {
                m: '权限编码不能为空'
            }
        },
        {
            type: 'length',
            rule: {
                min: 3, minm: '权限编码长度不能小于3',
                max: 30, maxm: '权限编码长度不能大于30'
            }
        },
        {
            type: 'format',
            rule: {
                pattern: regStr,
                m: '权限编码只能由中文、字母、数字以及下划线组成'
            }
        }
    ];
    require(["json2", "underscore",  "cui", "workbench/platform/js/templateDrag"], function (json2, _, cui,templateDrag) {
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
				opFlag: "1",
				templateId: "",
				templateName: cui('#templateName').getValue(),
				rightCode: cui('#rightCode').getValue(),
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

			TemplateAction.addTemplate(json2.stringify(data), function(data) {
				if(data === '1'){
					setTimeout(function(){
					    cui.handleMask.hide();
					    cui.message('添加成功', 'success');
					    setTimeout(function(){
						  window.location.href = "${ pageContext.request.contextPath }/top/workbench/platform/templateMain.jsp";
						}, 1000);
					}, 500);
					return;
				}
				setTimeout(function(){
					cui.handleMask.hide();
					cui.error('添加失败');
				}, 500);
			});
		});
    });
	
	$(window).on('error', function(){
		cui.handleMask.hide();
	});

    $("#goBack").click(function () {
        window.location.href = "${ pageContext.request.contextPath }/top/workbench/platform/templateMain.jsp";
    });
</script>
</body>
</html>
