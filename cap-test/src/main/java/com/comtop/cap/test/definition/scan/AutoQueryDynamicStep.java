/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.definition.scan;

import java.util.ArrayList;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Map;
import java.util.Random;

import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import com.comtop.cap.bm.metadata.page.desinger.model.LayoutVO;
import com.comtop.cap.bm.metadata.page.external.PageMetadataProvider;
import com.comtop.cap.test.definition.facade.StepFacade;
import com.comtop.cap.test.definition.model.Argument;
import com.comtop.cap.test.definition.model.BasicStep;
import com.comtop.cap.test.definition.model.DynamicStep;
import com.comtop.cap.test.definition.model.StepReference;
import com.comtop.cap.test.design.facade.TestCaseFacade;
import com.comtop.cap.test.design.model.Step;
import com.comtop.cap.test.design.model.TestCase;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cip.jodd.util.StringUtil;

/**
 * 自动生成查询步骤的实现类
 *
 * @author 李小芬
 * @since jdk1.6
 * @version 2016年8月2日 李小芬
 */
@PetiteBean
public class AutoQueryDynamicStep implements DynamicStepScanner {
    
    /** 步骤Facade */
    @PetiteInject
    protected StepFacade stepFacade;
    
    /** 步骤Facade */
    @PetiteInject
    protected TestCaseFacade testCaseFacade;
    
    /**
     * 
     * @see com.comtop.cap.test.definition.scan.DynamicStepScanner#scan(java.lang.String, java.util.Map)
     */
    @Override
    public DynamicStep scan(String stepId, Map<String, String> args) {
        // 1、前台传入的参数-页面ID
        String strPageModelId = args.get("listPage");
        // 录入策略auto自动生成dynamic动态随机dictionary字典获取manual手动录入
        String strStrategy = args.get("strategy");
        
        // 测试用例ID
        String testCaseModelId = args.get("testCaseModelId");
        // 当前步骤ID
        String currentStepId = args.get("currentStepId");
        
        // 2、根据步骤ID获取步骤定义信息
        DynamicStep objDynamicStep = (DynamicStep) stepFacade.loadStepDefinitionById(stepId);
        
        // 3、根据modelId查找全部的查询字段
        PageMetadataProvider metadataProvider = new PageMetadataProvider();
        Map<String, Object> objFiledMap = metadataProvider.queryInputTypeCmpsByModelId(strPageModelId);
        List<LayoutVO> lstLayoutVO = (List<LayoutVO>) objFiledMap.get("dataList");
        
        // 4、返回动态步骤中步骤定义的参数值
        List<Argument> lstArguments = objDynamicStep.getArguments();
        for (Argument argument : lstArguments) {
            if ("editPage".equals(argument.getName())) {
                argument.setValue(strPageModelId);
            } else if ("strategy".equals(argument.getName())) {
                argument.setValue(strStrategy);
            }
        }
        
        // 5、获取已有的动态步骤
        List<StepReference> lstCurrentStepRef = null;
        if (StringUtil.isNotBlank(testCaseModelId) && StringUtil.isNotBlank(currentStepId)) {
            TestCase objTestCase = testCaseFacade.loadTestCaseById(testCaseModelId);
            List<Step> lstStep = objTestCase.getSteps();
            for (Step step : lstStep) {
                if (step.getId().equals(currentStepId)) {
                    lstCurrentStepRef = step.getReference().getSteps();
                }
            }
        }
        
        // 6、构造动态步骤的步骤引用信息
        List<StepReference> lstStepReference = new ArrayList<StepReference>();
        int iCount = 0;
        for (LayoutVO layoutVO : lstLayoutVO) {
            iCount++;
            if (iCount > 3) {
                continue;
            }
            // 开发建模的配置信息
            CapMap objCapMap = layoutVO.getOptions();
            String strId = (String) objCapMap.get("id");
            if (StringUtil.isBlank(strId)) {
                strId = (String) objCapMap.get("uid");
            }
            if (StringUtil.isBlank(strId)) {
                objCapMap.put("id", layoutVO.getId());
            }
            if (isExsitStep(objCapMap, lstCurrentStepRef)) {
                continue;
            }
            String strUitype = (String) objCapMap.get("uitype");
            if ("Input".equals(strUitype)) {
                lstStepReference.addAll(getInputStepReference(objCapMap, strStrategy));
            } else if ("PullDown".equals(strUitype)) {
                lstStepReference.addAll(getPullDownStepReference(objCapMap));
            } else if ("CheckboxGroup".equals(strUitype)) { // 点击第一个元素
                lstStepReference.addAll(getCheckboxGroupStepReference(objCapMap));
            } else if ("RadioGroup".equals(strUitype)) {
                lstStepReference.addAll(getRadioGroupStepReference(objCapMap));
            } else if ("Calender".equals(strUitype)) {
                lstStepReference.addAll(getCalenderStepReference(objCapMap));
            } else if ("Textarea".equals(strUitype)) {
                lstStepReference.addAll(getTextareaStepReference(objCapMap, strStrategy));
            } else if ("Editor".equals(strUitype)) {
                lstStepReference.addAll(getEditorStepReference(objCapMap));
            } else if ("ClickInput".equals(strUitype)) {
                lstStepReference.addAll(getCustomStepReference(objCapMap));
            } else if ("ListBox".equals(strUitype)) {
                lstStepReference.addAll(getListBoxStepReference(objCapMap));
            } else if ("ChooseUser".equals(strUitype)) {
                lstStepReference.addAll(getChooseUserStepReference(objCapMap));
            } else if ("ChooseOrg".equals(strUitype)) {
                lstStepReference.addAll(getChooseOrgStepReference(objCapMap));
            } else {
                lstStepReference.addAll(getCustomStepReference(objCapMap));
            }
        }
        // 6、如果有查询按钮，再执行一步点击查询按钮的步骤 #点击查询
        String strButtonId = "";
        Map<String, Object> objButtonMap = metadataProvider.queryCmpByActionType(strPageModelId, "query");
        List<LayoutVO> lstActionLayoutVO = (List<LayoutVO>) objButtonMap.get("dataList");
        for (LayoutVO actionLayoutVO : lstActionLayoutVO) {
            if ("Button".equals(actionLayoutVO.getUiType())) {
                CapMap objOptionsMap = actionLayoutVO.getOptions();
                strButtonId = (String) objOptionsMap.get("id");
                if (StringUtil.isBlank(strButtonId)) {
                    strButtonId = (String) objOptionsMap.get("uid");
                }
                if (StringUtil.isBlank(strButtonId)) {
                    strButtonId = actionLayoutVO.getId();
                }
            }
        }
        StepReference objClickQueryButton = new StepReference();
        objClickQueryButton.setDescription("点击查询");
        objClickQueryButton.setName("点击查询");
        objClickQueryButton.setIcon(getIconByStepModelId("testStepDefinitions.basics.basic.click_element"));
        objClickQueryButton.setType("testStepDefinitions.basics.basic.click_element");
        objClickQueryButton.setArguments(clickElementRefArguments(strButtonId));
        if (!isButtonExsitStep(strButtonId, lstCurrentStepRef)) {
            lstStepReference.add(objClickQueryButton);
        }
        if (lstCurrentStepRef == null) {
            objDynamicStep.setSteps(lstStepReference);
        } else {
            lstCurrentStepRef.addAll(lstStepReference);
            objDynamicStep.setSteps(lstCurrentStepRef);
        }
        return objDynamicStep;
    }
    
    /**
     * 点击按钮步骤是否已存在
     *
     * @param strButtonId 按钮ID
     * @param lstCurrentStepRef 已有步骤信息
     * @return 是否已存在
     */
    private boolean isButtonExsitStep(String strButtonId, List<StepReference> lstCurrentStepRef) {
        if (lstCurrentStepRef == null) {
            return false;
        }
        StringBuffer sbLocator = new StringBuffer();
        sbLocator.append("id=").append(strButtonId);
        for (StepReference stepReference : lstCurrentStepRef) {
            List<Argument> args = stepReference.getArguments();
            for (Argument argument : args) {
                if ("locator".equals(argument.getName()) && sbLocator.toString().equals(argument.getValue())) {
                    return true;
                }
            }
        }
        return false;
    }
    
    /**
     * 判断步骤是否已存在
     *
     * @param objCapMap 控件配置信息
     * @param lstCurrentStepRef 已有步骤信息
     * @return 是否已存在
     */
    private boolean isExsitStep(CapMap objCapMap, List<StepReference> lstCurrentStepRef) {
        if (lstCurrentStepRef == null) {
            return false;
        }
        String strUitype = (String) objCapMap.get("uitype");
        String strId = getCapMapId(objCapMap);
        if ("ListBox".equals(strUitype)) {
            StringBuffer sbLocator = new StringBuffer();
            sbLocator.append("xpath=//*[@id='");
            sbLocator.append(strId).append("']/div/ul/li[1]");
            for (StepReference stepReference : lstCurrentStepRef) {
                List<Argument> args = stepReference.getArguments();
                for (Argument argument : args) {
                    if ("locator".equals(argument.getName()) && sbLocator.toString().equals(argument.getValue())) {
                        return true;
                    }
                }
            }
        } else if ("Editor".equals(strUitype)) {
            StringBuffer sbCode = new StringBuffer();
            sbCode.append("cui('#").append(strId).append("')");
            sbCode.append(".setHtml('");
            for (StepReference stepReference : lstCurrentStepRef) {
                List<Argument> args = stepReference.getArguments();
                for (Argument argument : args) {
                    if ("code".equals(argument.getName()) && argument.getValue().startsWith(sbCode.toString())) {
                        return true;
                    }
                }
            }
        } else {
            for (StepReference stepReference : lstCurrentStepRef) {
                List<Argument> args = stepReference.getArguments();
                for (Argument argument : args) {
                    if ("id".equals(argument.getName()) && strId.equals(argument.getValue())) {
                        return true;
                    }
                }
            }
        }
        return false;
    }
    
    /**
     * 点击查询按钮 click_element 参数
     * ${locator} 元素定位
     * 
     * @param strButtonId 按钮ID
     * @return 步骤参数
     */
    private List<Argument> clickElementRefArguments(String strButtonId) {
        List<Argument> lstRefArguments = new ArrayList<Argument>();
        Argument objLocator = new Argument();
        objLocator.setName("locator");
        objLocator.setValue("id=" + strButtonId);
        lstRefArguments.add(objLocator);
        return lstRefArguments;
    }
    
    /**
     * Input框的查询步骤（回车）
     *
     * @param capMap 控件配置信息
     * @return 查询步骤
     */
    private List<StepReference> getChooseOrgStepReference(CapMap capMap) {
        List<StepReference> lstStepReference = new ArrayList<StepReference>();
        StepReference objStepReference = new StepReference();
        objStepReference.setDescription(getUiDescription(capMap));
        objStepReference.setName(getUiDescription(capMap));
        objStepReference.setIcon(getIconByStepModelId("testStepDefinitions.basics.basic.choose_single_org"));
        if (capMap.get("chooseMode") != null && "0".equals(String.valueOf(capMap.get("chooseMode")))) {
            objStepReference.setType("testStepDefinitions.basics.basic.choose_multi_org");
            objStepReference.setArguments(chooseOrgMultiRefArguments(capMap));
        } else {
            objStepReference.setType("testStepDefinitions.basics.basic.choose_single_org");
            objStepReference.setArguments(chooseOrgRefArguments(capMap));
        }
        lstStepReference.add(objStepReference);
        return lstStepReference;
    }
    
    /**
     * ChooseOrg choose_multi_org 参数
     * ${id} 控件id
     * num 选择的组织数量 default="3"
     * ${clear} 是否清除以前的选项 default="False"
     *
     * @param capMap 字段控件信息
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> chooseOrgMultiRefArguments(CapMap capMap) {
        String strId = getCapMapId(capMap);
        List<Argument> lstRefArguments = new ArrayList<Argument>();
        Argument objId = new Argument();
        objId.setName("id");
        objId.setValue(strId);
        lstRefArguments.add(objId);
        Argument objNum = new Argument();
        objNum.setName("num");
        objNum.setValue("3");
        lstRefArguments.add(objNum);
        Argument objClear = new Argument();
        objClear.setName("clear");
        objClear.setValue("true");
        lstRefArguments.add(objClear);
        return lstRefArguments;
    }
    
    /**
     * ChooseOrg choose_single_org 参数
     * ${id} 控件id
     * ${clear} 是否清除以前的选项 default="False"
     *
     * @param capMap 字段控件信息
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> chooseOrgRefArguments(CapMap capMap) {
        String strId = getCapMapId(capMap);
        List<Argument> lstRefArguments = new ArrayList<Argument>();
        Argument objId = new Argument();
        objId.setName("id");
        objId.setValue(strId);
        lstRefArguments.add(objId);
        Argument objClear = new Argument();
        objClear.setName("clear");
        objClear.setValue("true");
        lstRefArguments.add(objClear);
        return lstRefArguments;
    }
    
    /**
     * Input框的查询步骤（回车）
     *
     * @param capMap 控件配置信息
     * @return 查询步骤
     */
    private List<StepReference> getChooseUserStepReference(CapMap capMap) {
        List<StepReference> lstStepReference = new ArrayList<StepReference>();
        StepReference objStepReference = new StepReference();
        objStepReference.setDescription(getUiDescription(capMap));
        objStepReference.setName(getUiDescription(capMap));
        objStepReference.setIcon(getIconByStepModelId("testStepDefinitions.basics.basic.choose_single_user"));
        if (capMap.get("chooseMode") != null && "0".equals(String.valueOf(capMap.get("chooseMode")))) {
            objStepReference.setType("testStepDefinitions.basics.basic.choose_multi_user");
            objStepReference.setArguments(chooseUserMultiRefArguments(capMap));
        } else {
            objStepReference.setType("testStepDefinitions.basics.basic.choose_single_user");
            objStepReference.setArguments(chooseUserRefArguments(capMap));
        }
        lstStepReference.add(objStepReference);
        return lstStepReference;
    }
    
    /**
     * chooseUser choose_multi_user 参数
     * ${id} 控件id
     * num 选择的人员数量 default="3"
     * ${clear} 是否清除以前的选项 default="False"
     *
     * @param capMap 字段控件信息
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> chooseUserMultiRefArguments(CapMap capMap) {
        String strId = getCapMapId(capMap);
        List<Argument> lstRefArguments = new ArrayList<Argument>();
        Argument objId = new Argument();
        objId.setName("id");
        objId.setValue(strId);
        lstRefArguments.add(objId);
        Argument objNum = new Argument();
        objNum.setName("num");
        objNum.setValue("3");
        lstRefArguments.add(objNum);
        Argument objClear = new Argument();
        objClear.setName("clear");
        objClear.setValue("true");
        lstRefArguments.add(objClear);
        return lstRefArguments;
    }
    
    /**
     * chooseUser choose_single_user 参数
     * ${id} 控件id
     * ${clear} 是否清除以前的选项 default="False"
     *
     * @param capMap 字段控件信息
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> chooseUserRefArguments(CapMap capMap) {
        String strId = getCapMapId(capMap);
        List<Argument> lstRefArguments = new ArrayList<Argument>();
        Argument objId = new Argument();
        objId.setName("id");
        objId.setValue(strId);
        lstRefArguments.add(objId);
        Argument objClear = new Argument();
        objClear.setName("clear");
        objClear.setValue("true");
        lstRefArguments.add(objClear);
        return lstRefArguments;
    }
    
    /**
     * Input框的查询步骤（回车）
     *
     * @param capMap 控件配置信息
     * @return 查询步骤
     */
    private List<StepReference> getListBoxStepReference(CapMap capMap) {
        List<StepReference> lstStepReference = new ArrayList<StepReference>();
        StepReference objStepReference = new StepReference();
        objStepReference.setDescription(getUiDescription(capMap));
        objStepReference.setName(getUiDescription(capMap));
        objStepReference.setIcon(getIconByStepModelId("testStepDefinitions.basics.basic.click_element"));
        objStepReference.setType("testStepDefinitions.basics.basic.click_element");
        objStepReference.setArguments(listboxRefArguments(capMap));
        lstStepReference.add(objStepReference);
        return lstStepReference;
    }
    
    /**
     * ListBox click_element 参数
     * ${locator} 元素定位
     * xpath=//*[@id="uiid-6445649012980573"]/div/ul/li[1]
     *
     * @param capMap 字段控件信息
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> listboxRefArguments(CapMap capMap) {
        String strId = getCapMapId(capMap);
        List<Argument> lstRefArguments = new ArrayList<Argument>();
        Argument objLocator = new Argument();
        objLocator.setName("locator");
        StringBuffer sbLocator = new StringBuffer();
        sbLocator.append("xpath=//*[@id='");
        sbLocator.append(strId).append("']/div/ul/li[1]");
        objLocator.setValue(sbLocator.toString());
        lstRefArguments.add(objLocator);
        return lstRefArguments;
    }
    
    /**
     * Input框的查询步骤（回车）
     *
     * @param capMap 控件配置信息
     * @return 查询步骤
     */
    private List<StepReference> getCustomStepReference(CapMap capMap) {
        List<StepReference> lstStepReference = new ArrayList<StepReference>();
        StepReference objStepReference = new StepReference();
        objStepReference.setDescription(getUiDescription(capMap));
        objStepReference.setName(getUiDescription(capMap));
        objStepReference.setIcon(getIconByStepModelId("testStepDefinitions.basics.basic.custom_set_value"));
        objStepReference.setType("testStepDefinitions.basics.basic.custom_set_value");
        objStepReference.setArguments(customRefArguments(capMap));
        lstStepReference.add(objStepReference);
        return lstStepReference;
    }
    
    /**
     * Custom custom_set_value 参数
     * ${id} 控件ID
     *
     * @param capMap 字段控件信息
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> customRefArguments(CapMap capMap) {
        String strId = getCapMapId(capMap);
        List<Argument> lstRefArguments = new ArrayList<Argument>();
        Argument objLocator = new Argument();
        objLocator.setName("id");
        objLocator.setValue(strId);
        lstRefArguments.add(objLocator);
        return lstRefArguments;
    }
    
    /**
     * Input框的查询步骤（回车）
     *
     * @param capMap 控件配置信息
     * @return 查询步骤
     */
    private List<StepReference> getEditorStepReference(CapMap capMap) {
        List<StepReference> lstStepReference = new ArrayList<StepReference>();
        StepReference objStepReference = new StepReference();
        objStepReference.setDescription(getUiDescription(capMap));
        objStepReference.setName(getUiDescription(capMap));
        objStepReference.setIcon(getIconByStepModelId("testStepDefinitions.basics.basic.execute_javascript"));
        objStepReference.setType("testStepDefinitions.basics.basic.execute_javascript");
        objStepReference.setArguments(editorRefArguments(capMap));
        lstStepReference.add(objStepReference);
        return lstStepReference;
    }
    
    /**
     * Editor execute_javascript 参数
     * ${code} JavaScript代码
     * cui("#uiid-8317132763499204").setHtml('wwww')
     *
     * @param capMap 字段控件信息
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> editorRefArguments(CapMap capMap) {
        String strId = getCapMapId(capMap);
        List<Argument> lstRefArguments = new ArrayList<Argument>();
        Argument objCode = new Argument();
        objCode.setName("code");
        StringBuffer sbCode = new StringBuffer();
        sbCode.append("cui('#").append(strId).append("')");
        sbCode.append(".setHtml('").append(getRandomString(15)).append("')");
        objCode.setValue(sbCode.toString());
        lstRefArguments.add(objCode);
        return lstRefArguments;
    }
    
    /**
     * Input框的查询步骤（回车）
     *
     * @param capMap 控件配置信息
     * @param strStrategy 录入策略
     * @return 查询步骤
     */
    private List<StepReference> getTextareaStepReference(CapMap capMap, String strStrategy) {
        List<StepReference> lstStepReference = new ArrayList<StepReference>();
        StepReference objStepReference = new StepReference();
        objStepReference.setDescription(getUiDescription(capMap));
        objStepReference.setName(getUiDescription(capMap));
        objStepReference.setIcon(getIconByStepModelId("testStepDefinitions.basics.basic.input_text"));
        objStepReference.setType("testStepDefinitions.basics.basic.input_text");
        objStepReference.setArguments(textareaRefArguments(capMap, strStrategy));
        lstStepReference.add(objStepReference);
        return lstStepReference;
    }
    
    /**
     * Textarea input_text 参数
     * ${locator} 输入框定位 name=xxx
     * ${text} 输入内容 xxx
     *
     * @param capMap 字段控件信息
     * @param strStrategy 录入策略
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> textareaRefArguments(CapMap capMap, String strStrategy) {
        // 字段英文值
        String strEngName = (String) capMap.get("name");
        List<Argument> lstRefArguments = new ArrayList<Argument>();
        Argument objLocator = new Argument();
        objLocator.setName("locator");
        objLocator.setValue("name=" + strEngName);
        lstRefArguments.add(objLocator);
        Argument objText = new Argument();
        objText.setName("text");
        objText.setValue(setArgValue(capMap, strStrategy));
        lstRefArguments.add(objText);
        return lstRefArguments;
    }
    
    /**
     * Input框的查询步骤（回车）
     *
     * @param capMap 控件配置信息
     * @return 查询步骤
     */
    private List<StepReference> getCalenderStepReference(CapMap capMap) {
        List<StepReference> lstStepReference = new ArrayList<StepReference>();
        StepReference objStepReference = new StepReference();
        objStepReference.setDescription(getUiDescription(capMap));
        objStepReference.setName(getUiDescription(capMap));
        objStepReference.setIcon(getIconByStepModelId("testStepDefinitions.basics.basic.calender_set_date"));
        objStepReference.setType("testStepDefinitions.basics.basic.calender_set_date");
        objStepReference.setArguments(calendarRefArguments(capMap));
        lstStepReference.add(objStepReference);
        return lstStepReference;
    }
    
    /**
     * Calender calender_set_date参数
     * id 日期组件的id
     *
     * @param capMap 字段控件信息
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> calendarRefArguments(CapMap capMap) {
        String strId = getCapMapId(capMap);
        List<Argument> lstRefArguments = new ArrayList<Argument>();
        Argument objId = new Argument();
        objId.setName("id");
        objId.setValue(strId);
        lstRefArguments.add(objId);
        return lstRefArguments;
    }
    
    /**
     * Input框的查询步骤（回车）
     *
     * @param capMap 控件配置信息
     * @return 查询步骤
     */
    private List<StepReference> getRadioGroupStepReference(CapMap capMap) {
        List<StepReference> lstStepReference = new ArrayList<StepReference>();
        StepReference objStepReference = new StepReference();
        objStepReference.setDescription(getUiDescription(capMap));
        objStepReference.setName(getUiDescription(capMap));
        objStepReference.setIcon(getIconByStepModelId("testStepDefinitions.basics.basic.select_radio"));
        objStepReference.setType("testStepDefinitions.basics.basic.select_radio");
        objStepReference.setArguments(radioGroupRefArguments(capMap));
        lstStepReference.add(objStepReference);
        return lstStepReference;
    }
    
    /**
     * RadioGroup select_radio参数
     * id 控件id
     * index 选项索引 default="1"
     *
     * @param capMap 字段控件信息
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> radioGroupRefArguments(CapMap capMap) {
        String strId = getCapMapId(capMap);
        List<Argument> lstRefArguments = new ArrayList<Argument>();
        Argument objId = new Argument();
        objId.setName("id");
        objId.setValue(strId);
        lstRefArguments.add(objId);
        Argument objIndex = new Argument();
        objIndex.setName("index");
        objIndex.setValue("1");
        lstRefArguments.add(objIndex);
        return lstRefArguments;
    }
    
    /**
     * Input框的查询步骤（回车）
     *
     * @param capMap 控件配置信息
     * @return 查询步骤
     */
    private List<StepReference> getCheckboxGroupStepReference(CapMap capMap) {
        List<StepReference> lstStepReference = new ArrayList<StepReference>();
        StepReference objStepReference = new StepReference();
        objStepReference.setDescription(getUiDescription(capMap));
        objStepReference.setName(getUiDescription(capMap));
        objStepReference.setIcon(getIconByStepModelId("testStepDefinitions.basics.basic.select_checkbox"));
        objStepReference.setType("testStepDefinitions.basics.basic.select_checkbox");
        objStepReference.setArguments(checkboxGroupRefArguments(capMap));
        lstStepReference.add(objStepReference);
        return lstStepReference;
    }
    
    /**
     * CheckboxGroup select_checkbox参数
     * id 控件id
     * indexes 索引 default="[1]"
     *
     * @param capMap 字段控件信息
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> checkboxGroupRefArguments(CapMap capMap) {
        String strId = getCapMapId(capMap);
        List<Argument> lstRefArguments = new ArrayList<Argument>();
        Argument objId = new Argument();
        objId.setName("id");
        objId.setValue(strId);
        lstRefArguments.add(objId);
        Argument objIndex = new Argument();
        objIndex.setName("indexes");
        objIndex.setValue("[1]");
        lstRefArguments.add(objIndex);
        return lstRefArguments;
        
    }
    
    /**
     * Input框的查询步骤（回车）
     *
     * @param capMap 控件配置信息
     * @return 查询步骤
     */
    private List<StepReference> getPullDownStepReference(CapMap capMap) {
        List<StepReference> lstStepReference = new ArrayList<StepReference>();
        StepReference objStepReference = new StepReference();
        objStepReference.setDescription(getUiDescription(capMap));
        objStepReference.setName(getUiDescription(capMap));
        objStepReference.setIcon(getIconByStepModelId("testStepDefinitions.basics.basic.cui_pulldown_select"));
        objStepReference.setType("testStepDefinitions.basics.basic.cui_pulldown_select");
        objStepReference.setArguments(pulldownRefArguments(capMap));
        lstStepReference.add(objStepReference);
        return lstStepReference;
    }
    
    /**
     * pulldown cui_pulldown_select 参数
     * id 下拉框id
     * num 多选时选择的数量 default="1"
     * 下拉框单选设值 uiid-6605641281473248 1
     *
     * @param capMap 字段控件信息
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> pulldownRefArguments(CapMap capMap) {
        String strId = getCapMapId(capMap);
        List<Argument> lstRefArguments = new ArrayList<Argument>();
        Argument objId = new Argument();
        objId.setName("id");
        objId.setValue(strId);
        lstRefArguments.add(objId);
        Argument objIndex = new Argument();
        objIndex.setName("num");
        objIndex.setValue("1");
        lstRefArguments.add(objIndex);
        return lstRefArguments;
    }
    
    /**
     * 获取配置的控件ID
     *
     * @param capMap 控件的配置信息
     * @return 控件ID
     */
    private String getCapMapId(CapMap capMap) {
        String strId = (String) capMap.get("id");
        if (StringUtil.isBlank(strId)) {
            strId = (String) capMap.get("uid");
        }
        return strId;
    }
    
    /**
     * Input框的查询步骤（回车）
     * 输入文本 name=remark 这是一条新增的入库记录
     * testStepDefinitions.basics.basic.input_text
     * 按键 name=remark \\13
     * testStepDefinitions.basics.basic.press_key
     * 
     * @param capMap 控件配置信息
     * @param strStrategy 录入策略
     * @return 查询步骤
     */
    private List<StepReference> getInputStepReference(CapMap capMap, String strStrategy) {
        List<StepReference> lstStepReference = new ArrayList<StepReference>();
        StepReference objStepReference = new StepReference();
        objStepReference.setDescription(getUiDescription(capMap));
        objStepReference.setName(getUiDescription(capMap));
        objStepReference.setType("testStepDefinitions.basics.basic.input_text");
        objStepReference.setIcon(getIconByStepModelId("testStepDefinitions.basics.basic.input_text"));
        objStepReference.setArguments(inputRefArguments(capMap, strStrategy));
        lstStepReference.add(objStepReference);
        StepReference objEnterStepReference = new StepReference();
        objEnterStepReference.setDescription("执行回车");
        objEnterStepReference.setName("执行回车");
        objEnterStepReference.setIcon(getIconByStepModelId("testStepDefinitions.basics.basic.press_key"));
        objEnterStepReference.setType("testStepDefinitions.basics.basic.press_key");
        objEnterStepReference.setArguments(enterRefArguments(capMap, strStrategy));
        lstStepReference.add(objEnterStepReference);
        return lstStepReference;
    }
    
    /**
     * 根据步骤查询图标
     *
     * @param stepId 步骤ID
     * @return 图标
     */
    private String getIconByStepModelId(String stepId) {
        BasicStep objBasicStep = DynamicUtils.getStepDefineById(stepId);
        if (objBasicStep != null) {
            return objBasicStep.getIcon();
        }
        return "icon-pencil";
    }
    
    /**
     * Input input_text 参数
     * ${locator} 输入框定位 name=xxx
     * ${text} 输入内容 xxx
     *
     * @param capMap 字段控件信息
     * @param strStrategy 录入策略
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> inputRefArguments(CapMap capMap, String strStrategy) {
        // 字段英文值
        String strEngName = (String) capMap.get("name");
        List<Argument> lstRefArguments = new ArrayList<Argument>();
        Argument objLocator = new Argument();
        objLocator.setName("locator");
        objLocator.setValue("name=" + strEngName);
        lstRefArguments.add(objLocator);
        Argument objText = new Argument();
        objText.setName("text");
        objText.setValue(setArgValue(capMap, strStrategy));
        lstRefArguments.add(objText);
        return lstRefArguments;
    }
    
    /**
     * press_key press_key 参数
     * ${locator} 元素定位 name=xxx
     * ${key} 按键值 \\13
     *
     * @param capMap 字段控件信息
     * @param strStrategy 录入策略
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> enterRefArguments(CapMap capMap, String strStrategy) {
        // 字段英文值
        String strEngName = (String) capMap.get("name");
        List<Argument> lstRefArguments = new ArrayList<Argument>();
        Argument objLocator = new Argument();
        objLocator.setName("locator");
        objLocator.setValue("name=" + strEngName);
        lstRefArguments.add(objLocator);
        Argument objKey = new Argument();
        objKey.setName("key");
        objKey.setValue("\\\\13");
        lstRefArguments.add(objKey);
        return lstRefArguments;
    }
    
    /**
     * 设置字段值
     * 根据strType设置字段的值：自动生成-值/动态随机-表达式/ 字典获取-不处理/手动录入-不处理
     * 字符串、数值、日期
     * 
     * @param capMap 字段配置
     * @param strStrategy 录入策略auto自动生成dynamic动态随机dictionary字典获取manual手动录入
     * @return 具体的值
     */
    private String setArgValue(CapMap capMap, String strStrategy) {
        // Input--mask(Datetimes Times Time Datetime Date / Int Dec Num Money )
        // Calender
        String strUitype = (String) capMap.get("uitype");
        String strMask = "";
        if ("Input".equals(strUitype)) {
            strMask = (String) capMap.get("mask");
        }
        if ("auto".equals(strStrategy)) { // java自动生成
            return setAutoValue(strUitype, strMask);
        } else if ("dynamic".equals(strStrategy)) { // 随机函数
            return setRandomValue(strUitype, strMask);
        }
        return setAutoValue(strUitype, strMask);
    }
    
    /**
     * 设置动态随机值
     *
     * @param strUitype 控件类型
     * @param strMask 控件配置
     * @return 动态随机值
     */
    private String setRandomValue(String strUitype, String strMask) {
        String[] dates = { "Datetimes", "Times", "Time", "Datetime", "Date" };
        String[] numbers = { "Int", "Dec", "Num", "Money" };
        if ("Calender".equals(strUitype) || isInStringArray(strMask, dates)) { // 日期型值
            return "fn(time.strftime('%Y-%m-%d',time.localtime(time.time())))";
        } else if (isInStringArray(strMask, numbers)) { // Number值
            return "fn(random.randint(0,99))";
        }
        return "fn(''.join(random.sample(string.ascii_letters,8)))";
    }
    
    /**
     * 自动设置值
     *
     * @param strUitype 控件类型
     * @param strMask 控件配置
     * @return 自动设置值
     */
    private String setAutoValue(String strUitype, String strMask) {
        // Input--mask(Datetimes Times Time Datetime Date / Int Dec Num Money )
        // Calender
        String[] dates = { "Datetimes", "Times", "Time", "Datetime", "Date" };
        String[] numbers = { "Int", "Dec", "Num", "Money" };
        Random objRandom = new Random();
        if ("Calender".equals(strUitype) || isInStringArray(strMask, dates)) { // 日期型值
            return getRandomDate();
        } else if (isInStringArray(strMask, numbers)) { // Number值
            return String.valueOf(objRandom.nextInt(6));
        }
        return getRandomString(15);
    }
    
    /**
     * 判断数组是否包含元素
     *
     * @param substring 字符串
     * @param source 数组
     * @return true包含
     */
    public boolean isInStringArray(String substring, String[] source) {
        if (source == null || source.length == 0) {
            return false;
        }
        for (int i = 0; i < source.length; i++) {
            String aSource = source[i];
            if (aSource.equals(substring)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * 生成随机日期
     *
     * @return 随机日期
     */
    private String getRandomDate() {
        long time = System.currentTimeMillis();
        Date dat = new Date(time);
        GregorianCalendar gc = new GregorianCalendar();
        gc.setTime(dat);
        java.text.SimpleDateFormat format = new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
        return format.format(gc.getTime());
    }
    
    /**
     * 生成固定长度的随机字符串
     *
     * @param length 生成字符串的长度
     * @return 随机字符串
     */
    public static String getRandomString(int length) {
        String base = "abcdefghijklmnopqrstuvwxyz0123456789";
        Random random = new Random();
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < length; i++) {
            int number = random.nextInt(base.length());
            sb.append(base.charAt(number));
        }
        return sb.toString();
    }
    
    /**
     * 获取描述信息
     *
     * @param capMap 控件配置信息
     * @return 描述信息
     */
    private String getUiDescription(CapMap capMap) {
        String strEngName = (String) capMap.get("name");
        String strChName = (String) capMap.get("label");
        if (StringUtil.isNotBlank(strChName)) {
            return "查询" + strChName;
        }
        return "查询" + strEngName;
    }
    
}
