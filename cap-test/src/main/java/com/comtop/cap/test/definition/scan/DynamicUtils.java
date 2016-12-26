/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.definition.scan;

import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Random;

import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import com.comtop.cap.test.definition.facade.StepFacade;
import com.comtop.cap.test.definition.model.BasicStep;
import com.comtop.cap.test.definition.model.StepReference;
import com.comtop.cap.test.design.facade.TestCaseFacade;
import com.comtop.cap.test.design.model.Step;
import com.comtop.cap.test.design.model.TestCase;
import com.comtop.cip.jodd.util.StringUtil;
import com.comtop.top.core.jodd.AppContext;

/**
 * 动态步骤帮助类
 *
 * @author 李小芬
 * @since jdk1.6
 * @version 2016年8月11日 李小芬
 */
public final class DynamicUtils {
    
    /** 测试用例操作类 */
    static TestCaseFacade testCaseFacade = AppContext.getBean(TestCaseFacade.class);
    
    /** 步骤处理操作类 */
    static StepFacade StepFacade = AppContext.getBean(StepFacade.class);
    
    /**
     * 构造函数
     */
    private DynamicUtils() {
    }
    
    /**
     * 根据UiType获取步骤ID
     *
     * @param capMap 控件配置信息
     * @return 步骤ID
     */
    public static String getStepIdByUiType(CapMap capMap) {
        String strUitype = (String) capMap.get("uitype");
        if (DynamicConstant.INPUT.equals(strUitype)) {
            return "testStepDefinitions.basics.basic.cui_input_text";
        } else if (DynamicConstant.PULLDOWN.equals(strUitype)) {
            return "testStepDefinitions.basics.basic.cui_pulldown_select";
        } else if (DynamicConstant.CHECKBOX_GROUP.equals(strUitype)) { // 点击第一个元素
            return "testStepDefinitions.basics.basic.select_checkbox";
        } else if (DynamicConstant.RADIO_GROUP.equals(strUitype)) {
            return "testStepDefinitions.basics.basic.select_radio";
        } else if (DynamicConstant.CALENDER.equals(strUitype)) {
            return "testStepDefinitions.basics.basic.calender_set_date";
        } else if (DynamicConstant.TEXTAREA.equals(strUitype)) {
            return "testStepDefinitions.basics.basic.cui_input_text";
        } else if (DynamicConstant.EDITOR.equals(strUitype)) {
            return "testStepDefinitions.basics.basic.execute_javascript";
        } else if (DynamicConstant.CLICK_INPUT.equals(strUitype)) {
            return "testStepDefinitions.basics.basic.custom_set_value";
        } else if (DynamicConstant.LISTBOX.equals(strUitype)) {
            return "testStepDefinitions.basics.basic.click_element";
        } else if (DynamicConstant.CHOOSE_USER.equals(strUitype)) {
            if (capMap.get("chooseMode") != null && "0".equals(String.valueOf(capMap.get("chooseMode")))) {
                return "testStepDefinitions.basics.basic.choose_multi_user";
            }
            return "testStepDefinitions.basics.basic.choose_single_user";
        } else if (DynamicConstant.CHOOSE_ORG.equals(strUitype)) {
            if (capMap.get("chooseMode") != null && "0".equals(String.valueOf(capMap.get("chooseMode")))) {
                return "testStepDefinitions.basics.basic.choose_multi_org";
            }
            return "testStepDefinitions.basics.basic.choose_single_org";
        }
        return "testStepDefinitions.basics.basic.custom_set_value";
    }
    
    /**
     * 根据步骤ID获取步骤定义信息
     *
     * @param stepId 步骤ID
     * @return 步骤定义
     */
    public static BasicStep getStepDefineById(String stepId) {
        return StepFacade.loadBasicStepById(stepId);
    }
    
    /**
     * 获取当前动态步骤的所有子步骤
     *
     * @param testCaseModelId 当前测试用例
     * @param currentStepId 当前动态步骤
     * @return 所有子步骤
     */
    public static List<StepReference> queryCurrentStepRef(String testCaseModelId, String currentStepId) {
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
        return lstCurrentStepRef;
    }
    
    /**
     * 设置字段值
     * 根据strType设置字段的值：自动生成-值/动态随机-表达式/ 字典获取-不处理/手动录入-不处理
     * 字符串、数值、日期
     * 
     * @param capMap 字段配置
     * @param strategy 录入策略auto自动生成dynamic动态随机dictionary字典获取manual手动录入
     * @return 具体的值
     */
    public static String setArgValue(CapMap capMap, String strategy) {
        // Input--mask(Datetimes Times Time Datetime Date / Int Dec Num Money )
        // Calender
        String strUitype = (String) capMap.get("uitype");
        String strMask = "";
        if ("Input".equals(strUitype)) {
            strMask = (String) capMap.get("mask");
        }
        if ("auto".equals(strategy)) { // java自动生成
            return setAutoValue(strUitype, strMask);
        } else if ("dynamic".equals(strategy)) { // 随机函数
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
    public static String setRandomValue(String strUitype, String strMask) {
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
    public static String setAutoValue(String strUitype, String strMask) {
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
     * 生成随机日期
     *
     * @return 随机日期
     */
    public static String getRandomDate() {
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
     * 判断数组是否包含元素
     *
     * @param substring 字符串
     * @param source 数组
     * @return true包含
     */
    public static boolean isInStringArray(String substring, String[] source) {
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
}
