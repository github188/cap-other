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
    <title>中国南方电网</title>
</head>
<body>

<%@ include file="/top/workbench/base/MainNav.jsp" %>
<div class="app-nav">
    <img src="${pageScope.cuiWebRoot}/top/workbench/platform/img/wj_xinzen.png" class="app-logo">
    <span class="app-name">新增微件</span>
</div>
<div class="workbench-container">
    <div class="ct0pMain">
        <div class="ct0pSearch">
            <span id="goBack" class="btnBgWhite">返回</span>
            <span id="addPortlet" class="btnBg">保存</span>
        </div>
        <div id="portletMain">
            <div class="add-container">
                <form id="addForm" action="${pageScope.cuiWebRoot}/top/workbench/PortletAction/addPortlet.ac" method="post">
                    <table border="0" width="1000px">
                        <tr style="line-height: 50px">
                            <td align="right" width="60px"> 微件名称<span class="pt-must">*</span>：</td>
                            <td width="300px">
                                <span uitype="Input" id="portletName" name="portlet.portletName"
                                      validate="validatePortletName"></span>
                            </td>
                            <td align="right" width="50px">是否公共<span class="pt-must">*</span>：</td>
                            <td>
                                <div id="isCommon" uitype="RadioGroup" name="portlet.isCommon" value="1"
                                     on_change="checkIfCommon">
                                    <input type="radio" name="isCommon" value="1"/>是
                                    <input type="radio" name="isCommon" value="0"/>否
                                </div>
                                <span class="pt-must">(注：只有非公共微件才能输入所属分类和权限编码)</span>
                            </td>
                        </tr>
                        <tr style="line-height: 50px">
                            <td align="right">所属分类<span class="pt-must">*</span>：</td>
                            <td><span uitype="PullDown" id="portletTag" name="portlet.portletTag" mode="Single"
                                      validate="validatePortletTag"
                                      must_exist="false"></span>
                                <span class="pt-must">(注：这里还可以直接输入所属分类信息)</span>
                            </td>
                            <td align="right">权限编码<span class="pt-must">*</span>：</td>
                            <td width="240px"><span uitype="Input" id="portletRightCode" readonly="true" emptytext="请输入权限编码!"
                                                    name="portlet.portletRightCode" value="PORTLET_COMMON"
                                                    validate="validatePortletRightCode"></span>
                                <span class="pt-must">(注：非公共微件才需要填写)</span>
                            </td>
                        </tr>

                        <tr style="line-height: 50px">
                            <td align="right">微件位置<span class="pt-must">*</span>：</td>
                            <td>
                                <div id="portletPostion" uitype="RadioGroup" name="portlet.portletPostion" value="1">
                                    <input type="radio" name="portletPostion" value="0"/>小微件(只能在工作台左侧用)
                                    <input type="radio" name="portletPostion" value="1"/>大微件(只能在工作台右侧用)
                                </div>
                            </td>
                            <td align="right">微件图标<span class="pt-must">*</span>：</td>
                            <td>
                                <span uitype="Input" id="picAddress" name="portlet.picAddress" value="${portlet.picAddress}" validate="validatePicAddress"></span>
                            </td>
                        </tr>

                        <tr style="line-height: 50px">
                            <td align="right">页面URL<span class="pt-must">*</span>：</td>
                            <td colspan="3"><span uitype="Input" width="390px"  id="portletUrl" name="portlet.portletUrl"
                                      validate="validatePortletUrl"></span></td>
                        </tr>
                        <tr style="height: 150px">
                            <td valign="top" align="right"> 微件描述<span class="pt-must">*</span>：</td>
                            <td valign="top" colspan="3">
                                <span uitype="Textarea" id="portletDescribe" relation="describeTxtNum" byte="false" maxlength="200" name="portlet.portletDescribe"
                                      validate="validatePortletDescribe" width="80%" height="140px"></span>
                                <div style="padding-top: 5px;">还可以输<span id="describeTxtNum" style="color: red"></span>个字</div>
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
    //微件名称验证区域
    var validatePortletName = [
        {
            type: 'required',
            rule: {
                m: '微件名称不能为空'
            }
        },
        {
            type: 'length',
            rule: {
                min: 2, minm: '微件名称长度不能小于2个字符',
                max: 40, maxm: '微件名称长度不能大于40个字符'
            }
        },
        {
            type: 'format',
            rule: {
                pattern: regStr,
                m: '微件名称只能由中文、字母、数字以及下划线组成'
            }
        }
    ];
    //微件图片的验证规则
    var validatePicAddress= [
        {
            type: 'required',
            rule: {
                m: '微件图标地址不能为空'
            }
        },
        {
            type: 'length',
            rule: {
                min: 5, minm: '微件图标地址长度不能小于5个字符',
                max: 100, maxm: '微件图标地址长度不能大于100个字符'
            }
        }
    ];
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
    //微件URL验证区域
    var validatePortletUrl = [
        {
            type: 'required',
            rule: {
                m: '页面URL不能为空'
            }
        },
        {
            type: 'length',
            rule: {
                max: 150, maxm: '页面URL长度不能大于150'
            }
        }
    ];

    //微件所属分类区域
    var validatePortletTag = [
        {
            type: 'required',
            rule: {
                m: '请选择或者输入微件所属分类!'
            }
        }
    ];

    //微件描述验证区域
    var validatePortletDescribe = [
        {
            type: 'required',
            rule: {
                m: '微件描述不能为空'
            }
        }
    ];

    //临时从数据库取的分类信息
    var tempSelectDataSource;

    var outerJson2;
    require(["json2", "underscore", "cui", "workbench/platform/js/portlet", "autoIframe"], function (json2, _, cui, portletMgr) {
        outerJson2 = json2;
        $('#portletMain>iframe').autoFrameHeight();
        tempSelectDataSource = portletMgr.queryAllTags('NotWithAll');
        comtop.UI.scan();
        //获取数据源然后赋值
        cui("#portletTag").setDatasource(tempSelectDataSource);
        //让其选中公共微件
        cui("#portletTag").setValue('公共微件');
    });

    //当选择了是公共的时候的触发事件
    function checkIfCommon(val) {
        if (val === '1') {
            //获取数据源然后赋值
            cui("#portletTag").setDatasource(tempSelectDataSource);
            //让其选中公共微件
            cui("#portletTag").setValue('公共微件');
            cui("#portletRightCode").setValue('PORTLET_COMMON');
            //cui("#portletTag").setReadonly(true);
            cui("#portletRightCode").setReadonly(true);
        } else {
            var tmpAry = tempSelectDataSource.slice(1);
            cui("#portletTag").setDatasource(tmpAry);

//            cui("#portletRightCode").setValue('请输入权限编码!');
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
         valid[0]//验证不通过的信息
         valid[1]//验证通过的信息
         valid[2]//根据这个判断表单验证是否通过
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
                cui.error("对不起、微件名称已被占用！");
                return false;
            }

            if (cui("#isCommon").getValue() == '0' && $.trim(cui("#portletTag").getText()) === "公共微件") {
                cui.error('非公共微件的所属分类不能使用“公共微件”!');
                return;
            }

            //构造新增的微件json数据
            var portletJson = {};
            portletJson.portletName = cui("#portletName").getValue();
            portletJson.portletRightCode = cui("#portletRightCode").getValue();
            portletJson.portletUrl = cui("#portletUrl").getValue();
            portletJson.isCommon = cui("#isCommon").getValue();
            portletJson.portletTag = cui("#portletTag").getValue();
            portletJson.portletPostion = cui("#portletPostion").getValue();
            portletJson.portletDescribe = cui("#portletDescribe").getValue();
            portletJson.picAddress=cui("#picAddress").getValue();

            //异步提交新增
            PortletAction.addPortlet(outerJson2.stringify(portletJson), function (data) {
                if (data === true) {
                    cui.message('添加成功', 'success');
                    setTimeout(function(){
                        window.location.href = "${pageScope.cuiWebRoot}/top/workbench/platform/portletMain.jsp";
                    }, 1000);
                } else {
                    cui.error("添加微件失败!");
                }
            });
        }
    });
</script>
</body>
</html>
