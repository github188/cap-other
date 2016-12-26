/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.definition.scan;

/**
 * 动态步骤常量类型
 *
 * @author 李小芬
 * @since jdk1.6
 * @version 2016年8月11日 李小芬
 */
public final class DynamicConstant {
    
    /**
     * 构造函数
     */
    private DynamicConstant() {
        super();
    }
    
    /** 页面模型ID */
    public final static String PAGE_MODEL_ID = "editPage";
    
    /** 字段选项 */
    public final static String INPUT_OPTION = "inputOption";
    
    /** 字段选项-all */
    public final static String INPUT_OPTION_ALL = "all";
    
    /** 字段选项-required */
    public final static String INPUT_OPTION_REQUIRED = "required";
    
    /** 字段只读-readonly */
    public final static String READONLY = "readonly";
    
    /** 录入策略 */
    public final static String STRATEGY = "strategy";
    
    /** 录入策略-auto */
    public final static String STRATEGY_AUTO = "auto";
    
    /** 录入策略-dynamic */
    public final static String STRATEGY_DYNAMIC = "dynamic";
    
    /** 测试用例模型ID */
    public final static String TEST_CASE_MODEL_ID = "testCaseModelId";
    
    /** 当前步骤ID */
    public final static String CURRENT_STEP_ID = "currentStepId";
    
    /** 控件关键字-id */
    public final static String ID = "id";
    
    /** 控件关键字-uitype */
    public final static String UI_TYPE = "uitype";
    
    /** 控件关键字-name */
    public final static String NAME = "name";
    
    /** 控件关键字-label */
    public final static String LABEL = "label";
    
    /** 控件类型-Input */
    public final static String INPUT = "Input";
    
    /** 控件类型-PullDown */
    public final static String PULLDOWN = "PullDown";
    
    /** 控件类型-CheckboxGroup */
    public final static String CHECKBOX_GROUP = "CheckboxGroup";
    
    /** 控件类型-RadioGroup */
    public final static String RADIO_GROUP = "RadioGroup";
    
    /** 控件类型-Calender */
    public final static String CALENDER = "Calender";
    
    /** 控件类型-Textarea */
    public final static String TEXTAREA = "Textarea";
    
    /** 控件类型-Editor */
    public final static String EDITOR = "Editor";
    
    /** 控件类型-ClickInput */
    public final static String CLICK_INPUT = "ClickInput";
    
    /** 控件类型-ListBox */
    public final static String LISTBOX = "ListBox";
    
    /** 控件类型-ChooseUser */
    public final static String CHOOSE_USER = "ChooseUser";
    
    /** 控件类型-ChooseOrg */
    public final static String CHOOSE_ORG = "ChooseOrg";
    
    /** 控件类型-EditableGrid */
    public final static String EDITABLEGRID = "EditableGrid";
    
}
