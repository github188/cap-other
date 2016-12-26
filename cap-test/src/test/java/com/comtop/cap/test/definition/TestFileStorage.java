/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.definition;

import java.io.File;

import org.junit.Assert;
import org.junit.Test;

import com.comtop.cap.bm.metadata.common.storage.XmlOperator;
import com.comtop.cap.test.definition.model.Argument;
import com.comtop.cap.test.definition.model.BasicStep;
import com.comtop.cap.test.definition.model.CtrlDefinition;
import com.comtop.cap.test.definition.model.DynamicStep;
import com.comtop.cap.test.definition.model.FixedStep;
import com.comtop.cap.test.definition.model.StepGroup;
import com.comtop.cap.test.definition.model.StepGroups;
import com.comtop.cap.test.definition.model.StepReference;
import com.comtop.cap.test.definition.model.StepType;
import com.comtop.cap.test.definition.model.ValueType;
import com.comtop.cap.test.design.model.Line;
import com.comtop.cap.test.design.model.Step;
import com.comtop.cap.test.design.model.TestCase;
import com.comtop.cap.test.design.model.TestCaseType;

/**
 * 测试文件存储
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年6月22日 lizhongwen
 */
public class TestFileStorage {
    
    /**
     * 保存
     */
    @Test
    public void testSaveBasic() {
        BasicStep step = new BasicStep();
        step.setName("打开浏览器");
        step.setDefinition("open_browser");
        step.setGroup("common");
        step.setIcon("browser");
        step.setDescription("打开浏览器,并将浏览器最大化。");
        step.setHelp("打开浏览器,并将浏览器最大化。");
        step.setSrc("element.txt");
        step.addLibrary("Selenium2Library");
        
        // arg-url
        Argument argUrl = new Argument();
        argUrl.setName("url");
        argUrl.setValueType(ValueType.STRING);
        argUrl.setRequired(true);
        argUrl.setDescription("系统地址");
        argUrl.setHelp("请输入系统地址");
        CtrlDefinition ctrlUrl = new CtrlDefinition();
        ctrlUrl.setType("Input");
        ctrlUrl
            .setOptions("{ \n                        'id': 'url',\n                        'name': 'url',\n                        'required':'true'\n                    }");
        argUrl.setCtrl(ctrlUrl);
        step.addArgument(argUrl);
        
        // arg-type
        Argument argType = new Argument();
        argType.setName("type");
        argType.setValueType(ValueType.STRING);
        argType.setRequired(true);
        argType.setDescription("浏览器类型");
        argType.setHelp("请选择浏览器类型");
        CtrlDefinition ctrlType = new CtrlDefinition();
        ctrlType.setType("Pulldown");
        ctrlType
            .setOptions("{ \n                        'id': 'url',\n                        'name': 'url',\n                        'required':'true'\n                    }");
        argType.setCtrl(ctrlType);
        step.addArgument(argType);
        
        step.setMacro("打开浏览器 ${url} ${type} #打开浏览器,并将浏览器最大化。");
        
        XmlOperator operator = new XmlOperator();
        operator.saveFile(step, new File("./basic.xml"), false);
    }
    
    /**
     * 保存
     */
    @Test
    public void testSaveFixed() {
        FixedStep step = new FixedStep();
        step.setGroup("common");
        step.setDefinition("login_in_app");
        step.setName("登录并进入应用");
        step.setIcon("login");
        step.setDescription("登录并进入应用");
        step.setHelp("登录并进入应用");
        step.addLibrary("Selenium2Library");
        step.addLibrary("AutoItLibrary");
        step.addResource("element.txt");
        
        Argument arg1 = new Argument();
        arg1.setName("url");
        arg1.setValueType(ValueType.STRING);
        arg1.setRequired(true);
        arg1.setDescription("系统地址");
        arg1.setHelp("请输入系统地址");
        CtrlDefinition ctrl1 = new CtrlDefinition();
        ctrl1.setType("Input");
        ctrl1
            .setOptions("{ \n                        'id': 'url',\n                        'name': 'url',\n                        'required':'true'\n                    }");
        arg1.setCtrl(ctrl1);
        step.addArgument(arg1);
        
        Argument arg2 = new Argument();
        arg2.setName("type");
        arg2.setValueType(ValueType.STRING);
        arg2.setRequired(true);
        arg2.setDescription("浏览器类型");
        arg2.setHelp("请选择浏览器类型");
        CtrlDefinition ctrl2 = new CtrlDefinition();
        ctrl2.setType("Pulldown");
        ctrl2
            .setOptions("{ \n                        'id': 'url',\n                        'name': 'url',\n                        'required':'true'\n                    }");
        arg2.setCtrl(ctrl2);
        step.addArgument(arg2);
        
        Argument arg3 = new Argument();
        arg3.setName("username");
        arg3.setValueType(ValueType.STRING);
        arg3.setRequired(true);
        arg3.setDescription("系统用户名");
        arg3.setHelp("请输入系统用户名");
        CtrlDefinition ctrl3 = new CtrlDefinition();
        ctrl3.setType("Input");
        ctrl3
            .setOptions("{ \n                        'id': 'username',\n                        'name': 'username',\n                        'required':'true'\n                    }");
        arg3.setCtrl(ctrl3);
        step.addArgument(arg3);
        
        Argument arg4 = new Argument();
        arg4.setName("password");
        arg4.setValueType(ValueType.STRING);
        arg4.setRequired(true);
        arg4.setDescription("系统密码");
        arg4.setHelp("请输入系统密码");
        CtrlDefinition ctrl4 = new CtrlDefinition();
        ctrl4.setType("Input");
        ctrl4
            .setOptions("{ \n                        'id': 'password',\n                        'name': 'password',\n                        'required':'true'\n                    }");
        arg4.setCtrl(ctrl4);
        step.addArgument(arg4);
        
        Argument arg5 = new Argument();
        arg5.setName("appname");
        arg5.setValueType(ValueType.STRING);
        arg5.setRequired(true);
        arg5.setDescription("应用名称");
        arg5.setHelp("请输入应用名称");
        CtrlDefinition ctrl5 = new CtrlDefinition();
        ctrl5.setType("Input");
        ctrl5
            .setOptions("{ \n                        'id': 'appname',\n                        'name': 'appname',\n                        'required':'true'\n                    }");
        arg5.setCtrl(ctrl5);
        step.addArgument(arg5);
        
        StepReference step1 = new StepReference();
        step1.setType("testStepDefinitions.basics.basic.common_login");
        step1.setName("登录系统");
        step1.setDescription("登录系统");
        step.addStep(step1);
        
        StepReference step2 = new StepReference();
        step2.setType("testStepDefinitions.basics.basic.common_query_app");
        step2.setName("查询应用");
        step2.setDescription("查询应用");
        step2.addArgument(new Argument("app-name", "appname"));
        step.addStep(step2);
        
        StepReference step3 = new StepReference();
        step3.setType("testStepDefinitions.basics.basic.common_in_app");
        step3.setName("进入应用");
        step3.setDescription("进入应用");
        step.addStep(step3);
        
        XmlOperator operator = new XmlOperator();
        operator.saveFile(step, new File("./fixed.xml"), false);
    }
    
    /**
     * 保存
     */
    @Test
    public void testSaveDynamic() {
        DynamicStep step = new DynamicStep();
        step.setGroup("common");
        step.setDefinition("inputEditPageField");
        step.setName("录入编辑页面字段");
        step.setIcon("icon-cog-wheel-silhouette");
        step.setDescription("录入编辑页面字段");
        step.setHelp("录入编辑页面字段");
        step.addLibrary("Selenium2Library");
        step.addLibrary("AutoItLibrary");
        step.addResource("element.txt");
        step.setScan("com.comtop.cap.test.scan.ScanEditPage");
        
        Argument arg1 = new Argument();
        arg1.setName("editPage");
        arg1.setValueType(ValueType.STRING);
        arg1.setRequired(true);
        arg1.setDescription("编辑页面");
        arg1.setHelp("请输入编辑页面");
        CtrlDefinition ctrl1 = new CtrlDefinition();
        ctrl1.setType("ClickInput");
        ctrl1
            .setOptions("{ \n                         'id': 'editPage',,\n                        'name': 'editPage',\n                        'required':'true',\n                    'on_iconclick':'openSelectEditPageWindow(${appId},${editPage})'\n                    }");
        ctrl1
            .setScript("function openSelectEditPageWindow(appId,editPage) {                        var url = '${pageScope.cuiWebRoot}/cap/bm/test/common/selectEditPage.jsp?appId=' + appId + '&editPage=' + editPage;                        var title = '编辑页面选择';                        var height = 550;                        var width = 700;                         dialog = cui.dialog({                            title: title,                            src: url,                            width: width,                            height: height                        })                        dialog.show(url);                    }");
        arg1.setCtrl(ctrl1);
        step.addArgument(arg1);
        
        Argument arg2 = new Argument();
        arg2.setName("inputOption");
        arg2.setValueType(ValueType.STRING);
        arg2.setRequired(true);
        arg2.setDescription("输入选项");
        arg2.setHelp("请选择输入选项");
        CtrlDefinition ctrl2 = new CtrlDefinition();
        ctrl2.setType("Pulldown");
        ctrl2
            .setOptions("{ \n                        'id': 'url',\n                        'name': 'url',\n                        'required':'true'\n                    'datasource':\"[{id:'all',text:'填写所有的字段'},{id:'required',text:'只填写必填项'},{id:'notReqired',text:'有不必填项未填写'},{id:'nulAll',text:'所有字段为空'}]\"}");
        arg2.setCtrl(ctrl2);
        step.addArgument(arg2);
        
        Argument arg3 = new Argument();
        arg3.setName("strategy");
        arg3.setValueType(ValueType.STRING);
        arg3.setRequired(true);
        arg3.setDescription("输入策略");
        arg3.setHelp("请选择输入策略");
        CtrlDefinition ctrl3 = new CtrlDefinition();
        ctrl3.setType("Pulldown");
        ctrl3
            .setOptions("{ \n                        'id': 'url',\n                        'name': 'url',\n                        'required':'true'\n                    'datasource':\"[{id:'auto',text:'自动生成'},{id:'dynamic',text:'动态随机'},{id:'dictionary',text:'字典获取'},{id:'manual',text:'手动录入'}]\"}");
        arg3.setCtrl(ctrl3);
        step.addArgument(arg3);
        
        XmlOperator operator = new XmlOperator();
        operator.saveFile(step, new File("./dynamic.xml"), false);
    }
    
    /**
     * 保存
     */
    @Test
    public void testSaveGroup() {
        StepGroups groups = new StepGroups();
        StepGroup group = new StepGroup();
        group.setCode("common");
        group.setName("常用步骤");
        group.setIcon("icon-dddd");
        groups.addGroup(group);
        XmlOperator operator = new XmlOperator();
        operator.saveFile(groups, new File("./groups.xml"), false);
    }
    
    /**
     * 保存
     */
    @Test
    public void testSaveTestCase() {
        TestCase tc = new TestCase();
        tc.setName("新增信息化合同简单测试");
        tc.setModelName("addContractSimpleTest");
        tc.setModelPackage("com.comtop.info.contract");
        tc.setType(TestCaseType.FUNCTION);
        tc.setMetadata("com.comtop.info.contract.InfoContractListPage.addContract");
        tc.setScene("这是对新增信息化合同的简单功能测试！");
        tc.setDescription("这是对新增信息化合同的简单功能测试！");
        
        // 添加节点
        Step step1 = new Step();
        step1.setId("1");
        step1.setType(StepType.FIXED);
        step1.setDescription("进入信息化合同管理");
        tc.addStep(step1);
        StepReference ref1 = new StepReference();
        ref1.setType("testStepDefinitions.combinations.fixed.login_in_app");
        ref1.setDescription("进入信息化合同管理");
        step1.setReference(ref1);
        
        Argument arg1_1 = new Argument();
        arg1_1.setName("url");
        arg1_1.setValue("${global.sys.url}");
        ref1.addArgument(arg1_1);
        
        Argument arg1_2 = new Argument();
        arg1_2.setName("username");
        arg1_2.setValue("${global.sys.username}");
        ref1.addArgument(arg1_2);
        
        Argument arg1_3 = new Argument();
        arg1_3.setName("password");
        arg1_3.setValue("${global.sys.password}");
        ref1.addArgument(arg1_3);
        
        Argument arg1_4 = new Argument();
        arg1_4.setName("appname");
        arg1_4.setValue("信息化合同管理");
        ref1.addArgument(arg1_4);
        
        StepReference ref1_1 = new StepReference();
        ref1_1.setId("11");
        ref1_1.setType("testStepDefinitions.basics.basic.login");
        ref1_1.setDescription("登录系统");
        ref1.addStep(ref1_1);
        
        Argument arg1_1_1 = new Argument();
        arg1_1_1.setName("url");
        arg1_1_1.setValue("${global.sys.url}");
        ref1_1.addArgument(arg1_1_1);
        
        Argument arg1_1_2 = new Argument();
        arg1_1_2.setName("username");
        arg1_1_2.setValue("${global.sys.username}");
        ref1_1.addArgument(arg1_1_2);
        
        Argument arg1_1_3 = new Argument();
        arg1_1_3.setName("password");
        arg1_1_3.setValue("${global.sys.password}");
        ref1_1.addArgument(arg1_1_3);
        
        StepReference ref1_2 = new StepReference();
        ref1_2.setId("12");
        ref1_2.setType("testStepDefinitions.basics.basic.search_app");
        ref1_2.setDescription("查询应用");
        ref1.addStep(ref1_2);
        
        Argument arg1_2_1 = new Argument();
        arg1_2_1.setName("appname");
        arg1_2_1.setValue("信息化合同管理");
        ref1_2.addArgument(arg1_2_1);
        
        StepReference ref1_3 = new StepReference();
        ref1_3.setId("13");
        ref1_3.setType("testStepDefinitions.basics.basic.enter_app");
        ref1_3.setDescription("进入应用");
        ref1.addStep(ref1_3);
        
        // 点击按钮
        Step step2 = new Step();
        step2.setId("2");
        step2.setType(StepType.BASIC);
        step2.setDescription("点击按钮");
        tc.addStep(step2);
        StepReference ref2 = new StepReference();
        ref2.setType("testStepDefinitions.basics.basic.click_button");
        ref2.setDescription("进入信息化合同管理");
        step2.setReference(ref2);
        
        Argument arg2_1 = new Argument();
        arg2_1.setName("locator");
        arg2_1.setValue("xpath=//*[@id='add-btn']");
        ref2.addArgument(arg2_1);
        
        // 选择窗口
        Step step3 = new Step();
        step3.setId("3");
        step3.setType(StepType.BASIC);
        step3.setDescription("选择窗口");
        tc.addStep(step3);
        StepReference ref3 = new StepReference();
        ref3.setType("testStepDefinitions.basics.basic.select_window");
        ref3.setDescription("选择窗口");
        step3.setReference(ref3);
        
        Argument arg3_1 = new Argument();
        arg3_1.setName("locator");
        arg3_1.setValue("title=新增信息化合同");
        ref3.addArgument(arg3_1);
        
        // 动态输入信息化合同必填字段
        Step step4 = new Step();
        step4.setId("4");
        step4.setType(StepType.DYNAMIC);
        step4.setDescription("动态输入信息化合同必填字段");
        tc.addStep(step4);
        StepReference ref4 = new StepReference();
        ref4.setType("testStepDefinitions.combinations.dynamic.inputEditPageField");
        ref4.setDescription("动态输入信息化合同必填字段");
        step4.setReference(ref4);
        
        Argument arg4_1 = new Argument();
        arg4_1.setName("editPage");
        arg4_1.setValue("com.comtop.info.contract.InfoContractEditPage");
        ref4.addArgument(arg4_1);
        
        Argument arg4_2 = new Argument();
        arg4_2.setName("strategy");
        arg4_2.setValue("dynamic");
        ref4.addArgument(arg4_2);
        
        StepReference ref4_1 = new StepReference();
        ref4_1.setId("41");
        ref4_1.setType("testStepDefinitions.basics.basic.input_text");
        ref4_1.setDescription("输入编码");
        ref4.addStep(ref4_1);
        
        Argument arg4_1_1 = new Argument();
        arg4_1_1.setName("locator");
        arg4_1_1.setValue("name=code");
        ref4_1.addArgument(arg4_1_1);
        
        Argument arg4_1_2 = new Argument();
        arg4_1_2.setName("value");
        arg4_1_2.setValue("${fn.genStr('CT',5,1)}");
        ref4_1.addArgument(arg4_1_2);
        
        StepReference ref4_2 = new StepReference();
        ref4_2.setId("42");
        ref4_2.setType("testStepDefinitions.basics.basic.input_text");
        ref4_2.setDescription("输入编码");
        ref4.addStep(ref4_2);
        
        Argument arg4_2_1 = new Argument();
        arg4_2_1.setName("locator");
        arg4_2_1.setValue("name=startTime");
        ref4_2.addArgument(arg4_2_1);
        
        Argument arg4_2_2 = new Argument();
        arg4_2_2.setName("value");
        arg4_2_2.setValue("${fn.now()-fn.genNum(10,1)*24}");
        ref4_2.addArgument(arg4_2_2);
        
        StepReference ref4_3 = new StepReference();
        ref4_3.setId("43");
        ref4_3.setType("testStepDefinitions.basics.basic.input_text");
        ref4_3.setDescription("输入合同金额");
        ref4.addStep(ref4_3);
        
        Argument arg4_3_1 = new Argument();
        arg4_3_1.setName("locator");
        arg4_3_1.setValue("name=amount");
        ref4_3.addArgument(arg4_3_1);
        
        Argument arg4_3_2 = new Argument();
        arg4_3_2.setName("value");
        arg4_3_2.setValue("${fn.genFloat(6,2)}");
        ref4_3.addArgument(arg4_3_2);
        
        StepReference ref4_4 = new StepReference();
        ref4_4.setId("44");
        ref4_4.setType("testStepDefinitions.basics.basic.select_second_organization");
        ref4_4.setDescription("选择甲方");
        ref4.addStep(ref4_4);
        
        Argument arg4_4_1 = new Argument();
        arg4_4_1.setName("secondOrg");
        arg4_4_1.setValue("xxxxx");
        ref4_4.addArgument(arg4_4_1);
        
        Argument arg4_4_2 = new Argument();
        arg4_4_2.setName("rootOrg");
        arg4_4_2.setValue("ddddd");
        ref4_4.addArgument(arg4_4_2);
        
        // 点击按钮
        Step step5 = new Step();
        step5.setId("5");
        step5.setType(StepType.BASIC);
        step5.setDescription("保存提交");
        tc.addStep(step5);
        StepReference ref5 = new StepReference();
        ref5.setType("testStepDefinitions.basics.basic.click_button");
        ref5.setDescription("保存提交");
        step5.setReference(ref5);
        
        Argument arg5_1 = new Argument();
        arg5_1.setName("locator");
        arg5_1.setValue("xpath=//*[@id='save-btn']");
        ref5.addArgument(arg5_1);
        
        Line line1 = new Line();
        line1.setForm("1");
        line1.setTo("2");
        tc.addLine(line1);
        
        Line line2 = new Line();
        line2.setForm("2");
        line2.setTo("3");
        tc.addLine(line2);
        
        Line line3 = new Line();
        line3.setForm("3");
        line3.setTo("4");
        tc.addLine(line3);
        
        Line line4 = new Line();
        line4.setForm("4");
        line4.setTo("5");
        tc.addLine(line4);
        
        XmlOperator operator = new XmlOperator();
        operator.saveFile(tc, new File("./testcase.xml"), false);
        
    }
    
    /**
     * 读取
     *
     */
    @Test
    public void readXml() {
        XmlOperator operator = new XmlOperator();
        Object ret = operator.readFile(new File("./testcase.xml"), TestCase.class, false);
        Assert.assertNotNull(ret);
    }
}
