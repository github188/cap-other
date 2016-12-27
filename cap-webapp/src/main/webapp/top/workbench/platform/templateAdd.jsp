<%@ include file="/top/component/common/Taglibs.jsp" %>
<head>
    <%@ page language="java" contentType="text/html; charset=GBK"    pageEncoding="GBK" %>
    <%@ include file="/top/workbench/base/Header.jsp" %>
    <link rel="stylesheet"           href="${pageScope.cuiWebRoot}/top/workbench/platform/css/portlet.css?v=<%=version%>"/>
	<link rel="stylesheet"
          href="${pageScope.cuiWebRoot}/top/workbench/platform/css/task.css?v=<%=version%>"/>
    <script type="text/javascript"   src="${pageScope.cuiWebRoot}/top/workbench/dwr/interface/PortletAction.js?v=<%=version%>"></script>

    <!--����̨ģ���϶���Ҫ��css��js�ļ�-->
    <link rel="stylesheet"           href="${pageScope.cuiWebRoot}/top/workbench/platform/css/templateBaseLayout.css?v=<%=version%>"/>
    <link rel="stylesheet"           href="${pageScope.cuiWebRoot}/top/workbench/platform/css/templateDragLayout.css?v=<%=version%>"/>
    <title>ͳһ����̨��ҳ</title>
</head>
<body>

<%@ include file="/top/workbench/base/MainNav.jsp" %>
<div class="app-nav">
    <img src="${pageScope.cuiWebRoot}/top/workbench/platform/img/wj_xinzen.png" class="app-logo">
    <span class="app-name">����̨ģ��༭</span>
</div>
<div class="workbench-container">
    <div class="ct0pMain">
        <div class="ct0pSearch clearfix">
            <span id="goBack" class="btnBgWhite">����</span>
            <span id="addPortlet" class="btnBg">����</span>
        </div>
        <div class="portletMain">
            <table class="form" border="0">
                <tr>
                    <td style="width: 60px;">ģ�����ƣ�</td>
                    <td><span uitype="Input" id="templateName" validate="ģ��������Ϊ��" name="tp.templateName" byte="false" emptytext="���20������" maxlength="20"></span></td>
                    <td style="width: 60px;">ͼ���ַ��</td>
                    <td>
                        <span uitype="Input" id="templatePic" validate="ͼ���ַ����Ϊ��" name="tp.templatePic" value="${tp.templatePic}" emptytext="���60���ַ�" maxlength="60"></span><span class="pt-must">��eg��top/workbench/platform/img/template_default.png��</span>
                    </td>
                </tr>
                <tr>
                    <td style="width: 60px;">ģ�����ͣ�</td>
                    <td width="280px">
                        <div id="radio" uitype="RadioGroup" name="tp.radio" value="1">
                            <input type="radio" name="sex" value="0"/>Ĭ��ģ��
                            <input type="radio" name="sex" value="1"/>��Ĭ��ģ��
                            <input type="radio" name="sex" value="-1"/>����ģ��
                        </div>
                    </td>
                    <td style="width: 60px;">Ȩ�ޱ��룺</td>
                    <td><span uitype="Input" id="rightCode" validate="validatePortletRightCode" name="tp.rightCode" ></span><span class="pt-must">��ע������topƽ̨���ɱ�������롢������޷��޸ģ�</span></td>
                </tr>
                <tr>
                    <td style="vertical-align:top;">������Ϣ��</td>
                    <td colspan="3">
						<span uitype="textarea" name="tp.describe" relation="describeTxtNum" id="describe" byte="false" maxlength="200" emptytext="������ģ�����Ҫ����" width="98%"></span>
						<div style="padding-top: 5px;">��������<span id="describeTxtNum" style="color: red"></span>����</div>
					</td>
                </tr>
                <tr>
                    <td colspan="4">
                        <span class="pt-must">
                            ���ѡ��ģ�����ͣ�<br/>
                            <span style="color: #888">
                            ����ģ���ô�����Ĭ��ģ�����Ϊ0��������ȻϵͳĬ��ģ�������Ϊ0����ĳ���û���û��Ȩ�޷������ǣ��Ǵ�ʱ���û����ε�¼ϵͳʱ��ʹ�ó���ģ����Ⱦ�乤��̨����.<br/>
                            Ĭ��ģ���ô�����Ĭ��ģ���������0����ĳ���û��з�������һЩĬ��ģ���Ȩ�ޣ���ô���û����ε�½ϵͳʱ��ʹ����ЩĬ��ģ����Ⱦ�乤��̨����.<br/>
                            ��Ĭ��ģ���ô�����ʹĳ���û��з��ʷ�Ĭ��ģ���Ȩ�ޣ����״ε�½ϵͳҲ����ʹ����Щģ������Ⱦ����̨���棻�������������������ʹ����Щģ���½��Լ��Ĺ���̨����
                            </span>
                        </span></td>

                </tr>
            </table>
        </div>

        <div class="wb-template">
            <div class="title">
                <h3>ϵͳ���</h3>
                <span class="btnBgWhite" id="addPortletDialog">���΢��</span>
            </div>
            <div class="main">
			<div class="task-portlet-tip">��ǰ����̨Ϊ�գ��Ƿ�<a href="#" id="addPortletDialogLink">���΢��</a>��</div>
                <!--<div>��ǰģ���ǿյģ��Ƿ�<a href="">���΢��</a>��</div>-->
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




<%--��̬ģ���ļ�����ģ�����ڽ�json����ת����̬��΢��html�ļ�--%>
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
	//΢��Ȩ�ޱ�����֤����
    var validatePortletRightCode = [
        {
            type: 'required',
            rule: {
                m: 'Ȩ�ޱ��벻��Ϊ��'
            }
        },
        {
            type: 'length',
            rule: {
                min: 3, minm: 'Ȩ�ޱ��볤�Ȳ���С��3',
                max: 30, maxm: 'Ȩ�ޱ��볤�Ȳ��ܴ���30'
            }
        },
        {
            type: 'format',
            rule: {
                pattern: regStr,
                m: 'Ȩ�ޱ���ֻ�������ġ���ĸ�������Լ��»������'
            }
        }
    ];
    require(["json2", "underscore",  "cui", "workbench/platform/js/templateDrag"], function (json2, _, cui,templateDrag) {
        comtop.UI.scan();
        //��ʼ����ק�¼�
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
					cui.error('ģ������������', function(){
						cui('#templateName').focus();
					});
				}, 500);
				return false;
			}

			TemplateAction.addTemplate(json2.stringify(data), function(data) {
				if(data === '1'){
					setTimeout(function(){
					    cui.handleMask.hide();
					    cui.message('��ӳɹ�', 'success');
					    setTimeout(function(){
						  window.location.href = "${ pageContext.request.contextPath }/top/workbench/platform/templateMain.jsp";
						}, 1000);
					}, 500);
					return;
				}
				setTimeout(function(){
					cui.handleMask.hide();
					cui.error('���ʧ��');
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
