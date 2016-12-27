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
	<%//360�����ָ��webkit�ں˴�%>
	<meta name="renderer" content="webkit">
	<%//�ر�ie����ģʽ,ʹ����߰汾�ĵ�ģʽ��Ⱦҳ��%>
	<meta http-equiv="x-ua-compatible" content="IE=edge" >
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/base/css/base.css?v=<%=version%>"/>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/component/requirejs/require.js?v=<%=version%>"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/component/requirejs/require.config.js?v=<%=version%>"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js?v=<%=version%>"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/base/js/base.js?v=<%=version%>"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/dwr/engine.js?v=<%=version%>"></script>
    <title>����Ӧ��-�й��Ϸ�����</title>
    <style>
        html, body {
            background-color: #fff;
        }

        #app-container {
            position: relative;
        }

        .app {
            display: inline-block;
            *display: inline;
            *zoom: 1;
            vertical-align: top;
            text-align: center;
            margin: 10px;
            cursor: pointer;
            width: 72px;
            position: relative;
        }

        .app .app-logo {
            width: 52px;
            height: 52px;
        }

        .app .app-name {
            margin-top: 5px;
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

        #app-ok {
            position: absolute;
            bottom: 0px;
            right: 0px;
            display: none;
            float: right;
            font-size: 12px;
            padding: 2px;
            color: #fff;
            background: #096BE1;
            text-decoration: none;
            border-radius: 2px;
        }

        .app-hover {
            width: 52px;
            height: 52px;
            border: 1px solid #fff;
            padding: 4px;
            margin: auto;
        }

        .app:hover .app-hover {
            background-color: #EBF2F7;
            border: 1px #ccc solid;
            border-radius: 4px;
            padding: 4px;
            position: relative;
        }

        .app:hover .app-hover .logo-warp{
            position: absolute;
            top:0;
            left: 0;
            height: 100%;
            width: 100%;
            background-color: #ccc;
            opacity:0.01;filter:alpha(opacity=1);
        }
    </style>
</head>
<body>
<div id="app-container">
    <c:forEach items="${requestScope.commonApps}" var="app">
        <div data-url="/top/workbench/app.ac?appCode=${app.appCode}" data-mainframe="false" target="_blank" class="app"
             id="${app.id}" data-sortable="sortable" system="${app.systemId}" category="${app.categoryId}">
            <div class="app-hover">
                <div class="logo-warp"></div>
                <img class="app-logo" data-logo="${app.logo}">
            </div>
            <i class="app-delete" data-app-id="${app.id}"></i>

            <div class="app-name">
                ${app.name}
            </div>
        </div>
    </c:forEach>
    <div data-url="${pageScope.cuiWebRoot}/top/workbench/app/MyApp.jsp" data-mainframe="false" class="app">
        <div class="app-hover">
            <img src="${pageScope.cuiWebRoot}/top/workbench/app/img/app-add.png" class="app-logo">
        </div>
        <div class="app-name">
            ���
        </div>
    </div>
    <a id="app-delete" class="app-delete2"></a>
    <a id="app-ok">ȷ��</a>
</div>


<script type="text/javascript">
    $('[data-logo]').prop('src', function () {
        this.src = Workbench.formatUrl($(this).data('logo'));
    });
    require(['workbench/dwr/interface/UserDataAction', 'workbench/dwr/interface/AppAction', 'cui', 'jqueryui'], function (_) {
        //AppAction.queryCommonApp(function(apps) {
        // var temHtml = _.template($('#app-tmpl').html(), {
        // models : apps
        // });
        // $('#app-container').prepend(temHtml);
        //ɾ��
        $('#app-container').on('click', '.app-delete', function (e) {
            e.preventDefault();
            e.stopPropagation();
            var $e = $(this);
            var appId = $e.data('appId');
            AppAction.unattention([appId], function () {
                $('#' + appId).remove();
                SortAppHandle();
                cui.message('ȡ������Ӧ�óɹ�', 'success');
            });
        });
        //�Ƿ����ڱ༭��
        var isNotDelete = false;
        //����ɾ���¼�
        $('#app-delete').click(function () {
            isNotDelete = true;
            $('.app-delete').show();
            $('#app-delete').hide();
            $('#app-ok').show();
        });
        //�˳��༭
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

        //});
        /*�϶��ĺ��Ĵ���*/
        $('#app-container').sortable({
            items: '[data-sortable=sortable]',
            handle: '.app-hover',
//            helper: 'clone',
            revert: 300,
            delay: 100,
            opacity: 0.8,
            tolerance: 'pointer',//���õ��Ϲ����ٵ�ʱ��ʼ��������
            containment: 'parent',//�����϶��ķ�Χ
            stop: function (e, ui) {
                SortAppHandle();
            }
        });


        var tempUserDataId = null;
        UserDataAction.queryUserData("CommonApp", function (result) {
            if (result.length) {
//                console.log("�������ݣ�" + JSON.stringify(result[0]));
                tempUserDataId = result[0].id;
//                console.log("ȡ����id��" + tempUserDataId);
                var orderApp = JSON.parse(result[0].data).reverse();
                var $tmpApp = null;
                $.each(orderApp, function (index, value) {
//                    console.log("index:" + index + "   value:" + value);
//                    console.log("idΪ" + value + "�ĸ�����" + $("#" + value, "#app-container").length)
                    $("#app-container").prepend($("#" + value, "#app-container"));//�ƶ�Ԫ��
                });
            }
        });

        //����˳��
        function SortAppHandle() {
            var order = [];
            $('[data-sortable=sortable]', '#app-container').each(function () {
                order.push($(this).attr("id"));
            });
            var appOrder = {};
            appOrder.dataCode = "CommonApp";
            appOrder.data = JSON.stringify(order);
            if (tempUserDataId != null) {
                appOrder.id = tempUserDataId;
            }

//            console.log("����ǰ���ݣ�" + JSON.stringify(appOrder));
            UserDataAction.save(appOrder, function (result) {
//                console.log("save order result:" + result);
                if (result !== "true" && result !== "false") {
//                    debugger;
                    tempUserDataId = result;
                }
            });
        }
        
      //�����Ӵ�������
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