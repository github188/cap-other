<%@ include file="/top/component/common/Taglibs.jsp" %>
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=GBK"/>
    <%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK" %>
    <%@ include file="/top/workbench/base/Header.jsp" %>
    <link rel="stylesheet"
          href="${pageScope.cuiWebRoot}/top/workbench/platform/css/portlet.css?v=<%=version%>"/>
    <script type="text/javascript"
            src="${pageScope.cuiWebRoot}/top/workbench/dwr/interface/PortletAction.js?v=<%=version%>"></script>
    <title>�й��Ϸ�����</title>
</head>
<body>

<%@ include file="/top/workbench/base/MainNav.jsp" %>
<div class="app-nav">
    <img src="${pageScope.cuiWebRoot}/top/workbench/platform/img/wj_xinzen.png" class="app-logo">
    <span class="app-name">����΢��</span>
</div>
<div class="workbench-container">
    <div class="ct0pMain">
        <div class="ct0pSearch">
            <span id="goBack" class="btnBgWhite">����</span>
            <span id="addPortlet" class="btnBg">����</span>
        </div>
        <div id="portletMain">
            <div class="add-container">
                <form id="addForm" action="${pageScope.cuiWebRoot}/top/workbench/PortletAction/addPortlet.ac" method="post">
                    <table border="0" width="1000px">
                        <tr style="line-height: 50px">
                            <td align="right" width="60px"> ΢������<span class="pt-must">*</span>��</td>
                            <td width="300px">
                                <span uitype="Input" id="portletName" name="portlet.portletName"
                                      validate="validatePortletName"></span>
                            </td>
                            <td align="right" width="50px">�Ƿ񹫹�<span class="pt-must">*</span>��</td>
                            <td>
                                <div id="isCommon" uitype="RadioGroup" name="portlet.isCommon" value="1"
                                     on_change="checkIfCommon">
                                    <input type="radio" name="isCommon" value="1"/>��
                                    <input type="radio" name="isCommon" value="0"/>��
                                </div>
                                <span class="pt-must">(ע��ֻ�зǹ���΢�������������������Ȩ�ޱ���)</span>
                            </td>
                        </tr>
                        <tr style="line-height: 50px">
                            <td align="right">��������<span class="pt-must">*</span>��</td>
                            <td><span uitype="PullDown" id="portletTag" name="portlet.portletTag" mode="Single"
                                      validate="validatePortletTag"
                                      must_exist="false"></span>
                                <span class="pt-must">(ע�����ﻹ����ֱ����������������Ϣ)</span>
                            </td>
                            <td align="right">Ȩ�ޱ���<span class="pt-must">*</span>��</td>
                            <td width="240px"><span uitype="Input" id="portletRightCode" readonly="true" emptytext="������Ȩ�ޱ���!"
                                                    name="portlet.portletRightCode" value="PORTLET_COMMON"
                                                    validate="validatePortletRightCode"></span>
                                <span class="pt-must">(ע���ǹ���΢������Ҫ��д)</span>
                            </td>
                        </tr>

                        <tr style="line-height: 50px">
                            <td align="right">΢��λ��<span class="pt-must">*</span>��</td>
                            <td>
                                <div id="portletPostion" uitype="RadioGroup" name="portlet.portletPostion" value="1">
                                    <input type="radio" name="portletPostion" value="0"/>С΢��(ֻ���ڹ���̨�����)
                                    <input type="radio" name="portletPostion" value="1"/>��΢��(ֻ���ڹ���̨�Ҳ���)
                                </div>
                            </td>
                            <td align="right">΢��ͼ��<span class="pt-must">*</span>��</td>
                            <td>
                                <span uitype="Input" id="picAddress" name="portlet.picAddress" value="${portlet.picAddress}" validate="validatePicAddress"></span>
                            </td>
                        </tr>

                        <tr style="line-height: 50px">
                            <td align="right">ҳ��URL<span class="pt-must">*</span>��</td>
                            <td colspan="3"><span uitype="Input" width="390px"  id="portletUrl" name="portlet.portletUrl"
                                      validate="validatePortletUrl"></span></td>
                        </tr>
                        <tr style="height: 150px">
                            <td valign="top" align="right"> ΢������<span class="pt-must">*</span>��</td>
                            <td valign="top" colspan="3">
                                <span uitype="Textarea" id="portletDescribe" relation="describeTxtNum" byte="false" maxlength="200" name="portlet.portletDescribe"
                                      validate="validatePortletDescribe" width="80%" height="140px"></span>
                                <div style="padding-top: 5px;">��������<span id="describeTxtNum" style="color: red"></span>����</div>
                            </td>
                        </tr>
                    </table>
                </form>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    var regStr = '^[\u4e00-\u9fa5_a-zA-Z0-9 ]+$';
    //΢��������֤����
    var validatePortletName = [
        {
            type: 'required',
            rule: {
                m: '΢�����Ʋ���Ϊ��'
            }
        },
        {
            type: 'length',
            rule: {
                min: 2, minm: '΢�����Ƴ��Ȳ���С��2���ַ�',
                max: 40, maxm: '΢�����Ƴ��Ȳ��ܴ���40���ַ�'
            }
        },
        {
            type: 'format',
            rule: {
                pattern: regStr,
                m: '΢������ֻ�������ġ���ĸ�������Լ��»������'
            }
        }
    ];
    //΢��ͼƬ����֤����
    var validatePicAddress= [
        {
            type: 'required',
            rule: {
                m: '΢��ͼ���ַ����Ϊ��'
            }
        },
        {
            type: 'length',
            rule: {
                min: 5, minm: '΢��ͼ���ַ���Ȳ���С��5���ַ�',
                max: 100, maxm: '΢��ͼ���ַ���Ȳ��ܴ���100���ַ�'
            }
        }
    ];
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
    //΢��URL��֤����
    var validatePortletUrl = [
        {
            type: 'required',
            rule: {
                m: 'ҳ��URL����Ϊ��'
            }
        },
        {
            type: 'length',
            rule: {
                max: 150, maxm: 'ҳ��URL���Ȳ��ܴ���150'
            }
        }
    ];

    //΢��������������
    var validatePortletTag = [
        {
            type: 'required',
            rule: {
                m: '��ѡ���������΢����������!'
            }
        }
    ];

    //΢��������֤����
    var validatePortletDescribe = [
        {
            type: 'required',
            rule: {
                m: '΢����������Ϊ��'
            }
        }
    ];

    //��ʱ�����ݿ�ȡ�ķ�����Ϣ
    var tempSelectDataSource;

    var outerJson2;
    require(["json2", "underscore", "cui", "workbench/platform/js/portlet", "autoIframe"], function (json2, _, cui, portletMgr) {
        outerJson2 = json2;
        $('#portletMain>iframe').autoFrameHeight();
        tempSelectDataSource = portletMgr.queryAllTags('NotWithAll');
        comtop.UI.scan();
        //��ȡ����ԴȻ��ֵ
        cui("#portletTag").setDatasource(tempSelectDataSource);
        //����ѡ�й���΢��
        cui("#portletTag").setValue('����΢��');
    });

    //��ѡ�����ǹ�����ʱ��Ĵ����¼�
    function checkIfCommon(val) {
        if (val === '1') {
            //��ȡ����ԴȻ��ֵ
            cui("#portletTag").setDatasource(tempSelectDataSource);
            //����ѡ�й���΢��
            cui("#portletTag").setValue('����΢��');
            cui("#portletRightCode").setValue('PORTLET_COMMON');
            //cui("#portletTag").setReadonly(true);
            cui("#portletRightCode").setReadonly(true);
        } else {
            var tmpAry = tempSelectDataSource.slice(1);
            cui("#portletTag").setDatasource(tmpAry);

//            cui("#portletRightCode").setValue('������Ȩ�ޱ���!');
            cui("#portletRightCode").setValue('');
            cui("#portletTag").setReadonly(false);
            cui("#portletRightCode").setReadonly(false);
        }
    }

    $("#goBack").click(function () {
        window.location.href = "${ pageContext.request.contextPath }/top/workbench/platform/portletMain.jsp";
    });


    $("#addPortlet").click(function () {
        var valid = window.validater.validAllElement();
        /*
         valid[0]//��֤��ͨ������Ϣ
         valid[1]//��֤ͨ������Ϣ
         valid[2]//��������жϱ���֤�Ƿ�ͨ��
         */
        if (valid[2]) {
            var portletName = cui("#portletName").getValue();
            var nameExist;
            dwr.TOPEngine.setAsync(false);
            PortletAction.ifNameExist(null, portletName, function (returnVal) {
                nameExist = returnVal;
            });
            dwr.TOPEngine.setAsync(true);

            if (nameExist) {
                cui.error("�Բ���΢�������ѱ�ռ�ã�");
                return false;
            }

            if (cui("#isCommon").getValue() == '0' && $.trim(cui("#portletTag").getText()) === "����΢��") {
                cui.error('�ǹ���΢�����������಻��ʹ�á�����΢����!');
                return;
            }

            //����������΢��json����
            var portletJson = {};
            portletJson.portletName = cui("#portletName").getValue();
            portletJson.portletRightCode = cui("#portletRightCode").getValue();
            portletJson.portletUrl = cui("#portletUrl").getValue();
            portletJson.isCommon = cui("#isCommon").getValue();
            portletJson.portletTag = cui("#portletTag").getValue();
            portletJson.portletPostion = cui("#portletPostion").getValue();
            portletJson.portletDescribe = cui("#portletDescribe").getValue();
            portletJson.picAddress=cui("#picAddress").getValue();

            //�첽�ύ����
            PortletAction.addPortlet(outerJson2.stringify(portletJson), function (data) {
                if (data === true) {
                    cui.message('��ӳɹ�', 'success');
                    setTimeout(function(){
                        window.location.href = "${pageScope.cuiWebRoot}/top/workbench/platform/portletMain.jsp";
                    }, 1000);
                } else {
                    cui.error("���΢��ʧ��!");
                }
            });
        }
    });
</script>
</body>
</html>
