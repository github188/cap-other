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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import com.comtop.cap.bm.metadata.page.desinger.model.LayoutVO;
import com.comtop.cap.bm.metadata.page.external.PageMetadataProvider;
import com.comtop.cap.test.definition.facade.StepFacade;
import com.comtop.cap.test.definition.model.Argument;
import com.comtop.cap.test.definition.model.BasicStep;
import com.comtop.cap.test.definition.model.DynamicStep;
import com.comtop.cap.test.definition.model.EditableGridColumnVO;
import com.comtop.cap.test.definition.model.StepReference;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cip.jodd.util.StringUtil;
import com.comtop.cap.runtime.core.AppBeanUtil;
import com.comtop.top.core.util.JsonUtil;
import com.comtop.top.core.util.constant.NumberConstant;

/**
 * 自动录入表格的实现类
 *
 * @author 李小芬
 * @since jdk1.6
 * @version 2016年7月13日 李小芬
 */
@PetiteBean
public class AutoInputGridDynamicStep implements DynamicStepScanner {
    
    /** 步骤Facade */
    @PetiteInject
    protected StepFacade stepFacade;
    
    /** 日誌 */
    private static final Logger LOGGER = LoggerFactory.getLogger(AppBeanUtil.class);
    
    /**
     * @see com.comtop.cap.test.definition.scan.DynamicStepScanner#scan(java.lang.String, java.util.Map)
     */
    @Override
    public DynamicStep scan(String stepId, Map<String, String> args) {
        // 1、获取参数
        String strPageGrid = args.get("editPageGrid"); // pageModelId;gridId
        String strPageModelId = getPageGridId(strPageGrid, NumberConstant.ZERO); // 页面ID
        String strGridId = getPageGridId(strPageGrid, NumberConstant.ONE); // grid Id
        String strStrategy = getStrategy(args); // 录入策略
        String testCaseModelId = args.get(DynamicConstant.TEST_CASE_MODEL_ID); // 当前测试用例ID
        String currentStepId = args.get(DynamicConstant.CURRENT_STEP_ID); // 当前同步步骤ID
        
        // 2、获取已定义的动态步骤基本信息
        DynamicStep objDynamicStep = (DynamicStep) stepFacade.loadStepDefinitionById(stepId);
        if (objDynamicStep == null) {
            LOGGER.info("根据stepId：" + stepId + "没有找到相关的动态步骤。");
        }
        
        // 3、设置动态步骤的参数值
        setDynamicArgsValue(strPageGrid, strStrategy, objDynamicStep);
        
        // 4、获取已有的动态步骤
        List<StepReference> lstCurrentStepRef = DynamicUtils.queryCurrentStepRef(testCaseModelId, currentStepId);
        
        // 5、查找需要录入的字段配置信息
        // TODO 多表头
        LayoutVO gridLayoutVO = getGridLayout(strGridId, strPageModelId);
        CapMap objCapMap1 = gridLayoutVO.getOptions();
        String strColumns = (String) objCapMap1.get("columns");
        String strEdittype = (String) objCapMap1.get("edittype");
        String strSelectrows = (String) objCapMap1.get("selectrows");
        Map<String, Map<String, String>> objMap = JsonUtil.jsonToObject(strEdittype, java.util.Map.class);
        List<EditableGridColumnVO> lstEditableGridColumn = JsonUtil.jsonToList(strColumns, EditableGridColumnVO.class);
        
        // 6、构造动态步骤的步骤引用信息
        List<StepReference> lstStepReference = new ArrayList<StepReference>();
        StepReference objStepReference;
        EditableGridColumnVO objEditableGridColumnVO;
        for (int i = 0; i < lstEditableGridColumn.size(); i++) {
            objEditableGridColumnVO = lstEditableGridColumn.get(i);
            String strEngName = objEditableGridColumnVO.getBindName();
            String strChName = objEditableGridColumnVO.getName();
            Map<String, String> objUiMap = objMap.get(strEngName);
            if (objUiMap == null) {
                continue;
            }
            if (isExsitStep(objEditableGridColumnVO, lstCurrentStepRef)) {
                continue;
            }
            String strUitype = objUiMap.get("uitype");
            String strMask = objUiMap.get("mask");
            objEditableGridColumnVO.setUitype(strUitype);
            objEditableGridColumnVO.setMask(strMask);
            String strStepDesc = "";
            if (StringUtil.isNotBlank(strChName)) {
                strStepDesc = strChName;
            } else {
                strStepDesc = strEngName;
            }
            objStepReference = new StepReference();
            objStepReference.setDescription(strStepDesc);
            objStepReference.setType(setStepType(objUiMap, strUitype));
            objStepReference.setName(setNameByUiType(objStepReference.getType()));
            objStepReference.setIcon(setIconByUiType(strUitype));
            if (StringUtil.isNotBlank(strSelectrows) && "no".equals(strSelectrows)) {
                objStepReference.setArguments(setRefArguments(objUiMap, strGridId, objEditableGridColumnVO,
                    strStrategy, i + 1));
            } else {
                objStepReference.setArguments(setRefArguments(objUiMap, strGridId, objEditableGridColumnVO,
                    strStrategy, i + 2));
            }
            lstStepReference.add(objStepReference);
        }
        
        // 7、根据已存在步骤集和新步骤集，设置动态步骤的步骤引用信息
        setStepReference(objDynamicStep, lstCurrentStepRef, lstStepReference);
        
        return objDynamicStep;
    }
    
    /**
     * 设置动态步骤的步骤引用信息
     *
     * @param objDynamicStep 动态步骤
     * @param lstCurrentStepRef 已有步骤
     * @param lstStepReference 新步骤
     */
    private void setStepReference(DynamicStep objDynamicStep, List<StepReference> lstCurrentStepRef,
        List<StepReference> lstStepReference) {
        if (lstCurrentStepRef == null) {
            objDynamicStep.setSteps(lstStepReference);
        } else {
            lstCurrentStepRef.addAll(lstStepReference);
            objDynamicStep.setSteps(lstCurrentStepRef);
        }
    }
    
    /**
     * 获取录入策略，为空则设置默认值
     *
     * @param args 参数集合
     * @return 录入策略
     */
    private String getStrategy(Map<String, String> args) {
        String strStrategy = args.get(DynamicConstant.STRATEGY);
        if (StringUtil.isBlank(strStrategy)) {
            return DynamicConstant.STRATEGY_AUTO;
        }
        return strStrategy;
    }
    
    /**
     * 设置动态步骤的参数值
     *
     * @param strPageGrid pageId;GridId
     * @param strStrategy 录入策略
     * @param objDynamicStep 当前动态步骤
     */
    private void setDynamicArgsValue(String strPageGrid, String strStrategy, DynamicStep objDynamicStep) {
        List<Argument> lstArguments = objDynamicStep.getArguments();
        for (Argument argument : lstArguments) {
            if ("editPageGrid".equals(argument.getName())) {
                argument.setValue(strPageGrid);
            } else if ("strategy".equals(argument.getName())) {
                argument.setValue(strStrategy);
            }
        }
    }
    
    /**
     * 获取页面ID和GridId
     *
     * @param pageGrid 拼凑的字符串集
     * @param iIndex 索引
     * @return 页面ID或GridId
     */
    private String getPageGridId(String pageGrid, int iIndex) {
        if (StringUtil.isNotBlank(pageGrid)) {
            String[] arrPageGrid = pageGrid.split(";");
            return arrPageGrid[iIndex];
        }
        return null;
    }
    
    /**
     * 判断步骤是否已存在
     *
     * @param editableGridColumnVO 控件配置信息
     * @param lstCurrentStepRef 已有步骤信息
     * @return 是否已存在
     */
    private boolean isExsitStep(EditableGridColumnVO editableGridColumnVO, List<StepReference> lstCurrentStepRef) {
        if (lstCurrentStepRef == null) {
            return false;
        }
        String strStepDesc = "";
        String strEngName = editableGridColumnVO.getBindName();
        String strChName = editableGridColumnVO.getName();
        if (StringUtil.isNotBlank(strChName)) {
            strStepDesc = strChName;
        } else {
            strStepDesc = strEngName;
        }
        for (StepReference stepReference : lstCurrentStepRef) {
            if (stepReference.getDescription().equals(strStepDesc)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * 根据步骤名称设值
     * 
     * @param stepId 基本步骤Id
     * @return 图标
     */
    private String setNameByUiType(String stepId) {
        BasicStep objBasicStep = DynamicUtils.getStepDefineById(stepId);
        if (objBasicStep != null) {
            return objBasicStep.getName();
        }
        return "";
    }
    
    /**
     * 根据Uitype设值图标
     * 
     * @param strUitype 控件类型
     * @return 图标
     */
    private String setIconByUiType(String strUitype) {
        if ("Input".equals(strUitype)) {
            return "icon-pencil";
        } else if ("PullDown".equals(strUitype)) {
            return "icon-pencil";
        } else if ("CheckboxGroup".equals(strUitype)) { // 点击第一个元素
            return "icon-pencil";
        } else if ("RadioGroup".equals(strUitype)) {
            return "icon-pencil";
        } else if ("Calender".equals(strUitype)) {
            return "icon-calendar-with-spring-binder-and-date-blocks";
        } else if ("Textarea".equals(strUitype)) {
            return "icon-pencil";
        } else if ("Editor".equals(strUitype)) {
            return "icon-pencil";
        } else if ("ClickInput".equals(strUitype)) {
            return "icon-pencil";
        } else if ("ListBox".equals(strUitype)) {
            return "icon-pencil";
        } else if ("ChooseUser".equals(strUitype)) {
            return "icon-user-shape";
        } else if ("ChooseOrg".equals(strUitype)) {
            return "icon-user-md-symbol";
        }
        return "icon-pencil";
    }
    
    /**
     * 根据uitype设置步骤类型
     * 
     * @param uiMap 控件配置信息
     * @param strUitype 开发建模配置的控件类型
     * @return 基本步骤类型
     */
    private String setStepType(Map<String, String> uiMap, String strUitype) {
        if ("Input".equals(strUitype)) {
            return "testStepDefinitions.basics.basic.input_editgrid_text";
        } else if ("PullDown".equals(strUitype)) {
            return "testStepDefinitions.basics.basic.egrid_cui_pulldown_select";
        } else if ("CheckboxGroup".equals(strUitype)) { // 点击第一个元素
            return "testStepDefinitions.basics.basic.select_editgrid_checkbox";
        } else if ("RadioGroup".equals(strUitype)) {
            return "testStepDefinitions.basics.basic.select_editgrid_radio";
        } else if ("Calender".equals(strUitype)) {
            return "testStepDefinitions.basics.basic.select_editgrid_calender";
        } else if ("Textarea".equals(strUitype)) {
            return "testStepDefinitions.basics.basic.input_editgrid_textarea";
        } else if ("ClickInput".equals(strUitype)) {
            return "testStepDefinitions.basics.basic.editgrid_custom_set_value";
        } else if ("ChooseUser".equals(strUitype)) {
            if (uiMap.get("chooseMode") != null && "0".equals(String.valueOf(uiMap.get("chooseMode")))) {
                return "testStepDefinitions.basics.basic.choose_editgrid_user_multi";
            }
            return "testStepDefinitions.basics.basic.choose_editgrid_user_single";
        } else if ("ChooseOrg".equals(strUitype)) {
            if (uiMap.get("chooseMode") != null && "0".equals(String.valueOf(uiMap.get("chooseMode")))) {
                return "testStepDefinitions.basics.basic.choose_editgrid_org_multi";
            }
            return "testStepDefinitions.basics.basic.choose_editgrid_org_single";
        }
        return "testStepDefinitions.basics.basic.editgrid_custom_set_value";
    }
    
    /**
     * 获取当前grid的配置信息
     *
     * @param strGridId gridId
     * @param strPageModelId 页面ID
     * @return 配置信息
     */
    private LayoutVO getGridLayout(String strGridId, String strPageModelId) {
        PageMetadataProvider metadataProvider = new PageMetadataProvider();
        Map<String, Object> objFiledMap = metadataProvider.queryInputTypeCmpsByModelId(strPageModelId);
        List<LayoutVO> lstLayoutVO = (List<LayoutVO>) objFiledMap.get("dataList");
        for (LayoutVO layoutVO : lstLayoutVO) {
            if (layoutVO.getId().equals(strGridId)) {
                return layoutVO;
            }
        }
        return null;
    }
    
    /**
     * 创建引用步骤的参数信息
     * 参数name、value
     * 
     * @param uiMap 控件配置信息
     * @param gridId GridId
     * @param columnVO 列信息
     * @param strStrategy 录入策略
     * @param iNum 当前列的顺序
     * @return 步骤的参数信息
     */
    private List<Argument> setRefArguments(Map<String, String> uiMap, String gridId, EditableGridColumnVO columnVO,
        String strStrategy, int iNum) {
        String strUitype = columnVO.getUitype();
        if ("Input".equals(strUitype)) {
            return this.inputRefArguments(gridId, columnVO, strStrategy, iNum);
        } else if ("PullDown".equals(strUitype)) {
            return this.pulldownRefArguments(gridId, columnVO, strStrategy, iNum);
        } else if ("CheckboxGroup".equals(strUitype)) {
            return this.checkboxGroupRefArguments(gridId, columnVO, strStrategy, iNum);
        } else if ("RadioGroup".equals(strUitype)) {
            return this.radioGroupRefArguments(gridId, columnVO, strStrategy, iNum);
        } else if ("Calender".equals(strUitype)) {
            return this.calendarRefArguments(gridId, columnVO, strStrategy, iNum);
        } else if ("Textarea".equals(strUitype)) {
            return this.textareaRefArguments(gridId, columnVO, strStrategy, iNum);
        } else if ("ClickInput".equals(strUitype)) {
            return this.customRefArguments(gridId, columnVO, strStrategy, iNum);
        } else if ("ChooseUser".equals(strUitype)) {
            if (uiMap.get("chooseMode") != null && "0".equals(String.valueOf(uiMap.get("chooseMode")))) {
                return this.chooseUserMultiRefArguments(gridId, columnVO, strStrategy, iNum);
            }
            return this.chooseUserRefArguments(gridId, columnVO, strStrategy, iNum);
        } else if ("ChooseOrg".equals(strUitype)) {
            if (uiMap.get("chooseMode") != null && "0".equals(String.valueOf(uiMap.get("chooseMode")))) {
                return this.chooseOrgMultiRefArguments(gridId, columnVO, strStrategy, iNum);
            }
            return this.chooseOrgRefArguments(gridId, columnVO, strStrategy, iNum);
        }
        return this.customRefArguments(gridId, columnVO, strStrategy, iNum);
    }
    
    /**
     * chooseOrg choose_editgrid_org_multi 参数
     * eGrid组织单选设值 uiid-7901557899778709 1 8 True
     * tableId 表格定位
     * rowIndex 行索引
     * colIndex 列索引
     * num 多选时选择的数量
     * clear 是否清除以前的选项 default="False"
     * 
     * @param gridId gridId
     * @param columnVO 字段控件信息
     * @param strStrategy 录入策略
     * @param iNum 当前列的顺序值
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> chooseOrgMultiRefArguments(String gridId, EditableGridColumnVO columnVO, String strStrategy,
        int iNum) {
        List<Argument> lstRefArguments = new ArrayList<Argument>();
        Argument objTableId = new Argument();
        objTableId.setName("tableId");
        objTableId.setValue(gridId);
        lstRefArguments.add(objTableId);
        
        Argument objRowIndex = new Argument();
        objRowIndex.setName("rowIndex");
        objRowIndex.setValue("1");
        lstRefArguments.add(objRowIndex);
        
        Argument objColIndex = new Argument();
        objColIndex.setName("colIndex");
        objColIndex.setValue(String.valueOf(iNum));
        lstRefArguments.add(objColIndex);
        
        Argument objNum = new Argument();
        objNum.setName("num");
        objNum.setValue("3");
        lstRefArguments.add(objNum);
        
        Argument objClear = new Argument();
        objClear.setName("clear");
        objClear.setValue("True");
        lstRefArguments.add(objClear);
        return lstRefArguments;
    }
    
    /**
     * chooseOrg choose_editgrid_org_single 参数
     * eGrid组织单选设值 uiid-7901557899778709 1 8 True
     * tableId 表格定位
     * rowIndex 行索引
     * colIndex 列索引
     * clear 是否清除以前的选项 default="False"
     * 
     * @param gridId gridId
     * @param columnVO 字段控件信息
     * @param strStrategy 录入策略
     * @param iNum 当前列的顺序值
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> chooseOrgRefArguments(String gridId, EditableGridColumnVO columnVO, String strStrategy,
        int iNum) {
        List<Argument> lstRefArguments = new ArrayList<Argument>();
        Argument objTableId = new Argument();
        objTableId.setName("tableId");
        objTableId.setValue(gridId);
        lstRefArguments.add(objTableId);
        
        Argument objRowIndex = new Argument();
        objRowIndex.setName("rowIndex");
        objRowIndex.setValue("1");
        lstRefArguments.add(objRowIndex);
        
        Argument objColIndex = new Argument();
        objColIndex.setName("colIndex");
        objColIndex.setValue(String.valueOf(iNum));
        lstRefArguments.add(objColIndex);
        
        Argument objClear = new Argument();
        objClear.setName("clear");
        objClear.setValue("True");
        lstRefArguments.add(objClear);
        return lstRefArguments;
    }
    
    /**
     * chooseUser choose_editgrid_user_multi 参数
     * eGrid人员单选设值 uiid-7901557899778709 1 7 True
     * tableId 表格定位
     * rowIndex 行索引
     * colIndex 列索引
     * num 多选时选择的数量
     * clear 是否清除以前的选项 default="False"
     * 
     * @param gridId gridId
     * @param columnVO 字段控件信息
     * @param strStrategy 录入策略
     * @param iNum 当前列的顺序值
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> chooseUserMultiRefArguments(String gridId, EditableGridColumnVO columnVO,
        String strStrategy, int iNum) {
        List<Argument> lstRefArguments = new ArrayList<Argument>();
        
        Argument objTableId = new Argument();
        objTableId.setName("tableId");
        objTableId.setValue(gridId);
        lstRefArguments.add(objTableId);
        
        Argument objRowIndex = new Argument();
        objRowIndex.setName("rowIndex");
        objRowIndex.setValue("1");
        lstRefArguments.add(objRowIndex);
        
        Argument objColIndex = new Argument();
        objColIndex.setName("colIndex");
        objColIndex.setValue(String.valueOf(iNum));
        lstRefArguments.add(objColIndex);
        
        Argument objNum = new Argument();
        objNum.setName("num");
        objNum.setValue("3");
        lstRefArguments.add(objNum);
        
        Argument objClear = new Argument();
        objClear.setName("clear");
        objClear.setValue("True");
        lstRefArguments.add(objClear);
        return lstRefArguments;
    }
    
    /**
     * chooseUser choose_editgrid_user_single 参数
     * eGrid人员单选设值 uiid-7901557899778709 1 7 True
     * tableId 表格定位
     * rowIndex 行索引
     * colIndex 列索引
     * clear 是否清除以前的选项 default="False"
     * 
     * @param gridId gridId
     * @param columnVO 字段控件信息
     * @param strStrategy 录入策略
     * @param iNum 当前列的顺序值
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> chooseUserRefArguments(String gridId, EditableGridColumnVO columnVO, String strStrategy,
        int iNum) {
        List<Argument> lstRefArguments = new ArrayList<Argument>();
        
        Argument objTableId = new Argument();
        objTableId.setName("tableId");
        objTableId.setValue(gridId);
        lstRefArguments.add(objTableId);
        
        Argument objRowIndex = new Argument();
        objRowIndex.setName("rowIndex");
        objRowIndex.setValue("1");
        lstRefArguments.add(objRowIndex);
        
        Argument objColIndex = new Argument();
        objColIndex.setName("colIndex");
        objColIndex.setValue(String.valueOf(iNum));
        lstRefArguments.add(objColIndex);
        
        Argument objClear = new Argument();
        objClear.setName("clear");
        objClear.setValue("True");
        lstRefArguments.add(objClear);
        return lstRefArguments;
    }
    
    /**
     * custom editgrid_custom_set_value 参数
     * eGrid文本域设值 uiid-7901557899778709 1 4
     * tableId 表格定位
     * rowIndex 行索引
     * colIndex 列索引
     *
     * @param gridId gridId
     * @param columnVO 字段控件信息
     * @param strStrategy 录入策略
     * @param iNum 当前列的顺序值
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> customRefArguments(String gridId, EditableGridColumnVO columnVO, String strStrategy, int iNum) {
        List<Argument> lstRefArguments = new ArrayList<Argument>();
        Argument objTableId = new Argument();
        objTableId.setName("tableId");
        objTableId.setValue(gridId);
        lstRefArguments.add(objTableId);
        
        Argument objRowIndex = new Argument();
        objRowIndex.setName("rowIndex");
        objRowIndex.setValue("1");
        lstRefArguments.add(objRowIndex);
        
        Argument objColIndex = new Argument();
        objColIndex.setName("colIndex");
        objColIndex.setValue(String.valueOf(iNum));
        lstRefArguments.add(objColIndex);
        return lstRefArguments;
    }
    
    /**
     * textarea input_editgrid_textarea 参数
     * eGrid文本域设值 uiid-7901557899778709 1 5 变压器
     * tableId 表格定位
     * rowIndex 行索引
     * colIndex 列索引
     * text 需要输入的文本
     *
     * @param gridId gridId
     * @param columnVO 字段控件信息
     * @param strStrategy 录入策略
     * @param iNum 当前列的顺序值
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> textareaRefArguments(String gridId, EditableGridColumnVO columnVO, String strStrategy,
        int iNum) {
        List<Argument> lstRefArguments = new ArrayList<Argument>();
        Argument objTableId = new Argument();
        objTableId.setName("tableId");
        objTableId.setValue(gridId);
        lstRefArguments.add(objTableId);
        
        Argument objRowIndex = new Argument();
        objRowIndex.setName("rowIndex");
        objRowIndex.setValue("1");
        lstRefArguments.add(objRowIndex);
        
        Argument objColIndex = new Argument();
        objColIndex.setName("colIndex");
        objColIndex.setValue(String.valueOf(iNum));
        lstRefArguments.add(objColIndex);
        
        Argument objText = new Argument();
        objText.setName("text");
        objText.setValue(setArgValue(gridId, columnVO, strStrategy));
        lstRefArguments.add(objText);
        return lstRefArguments;
    }
    
    /**
     * calendar select_editgrid_calender 参数
     * eGrid日期组件设值 uiid-7901557899778709 1 3
     * tableId 表格定位
     * rowIndex 行索引
     * colIndex 列索引
     *
     * @param gridId gridId
     * @param columnVO 字段控件信息
     * @param strStrategy 录入策略
     * @param iNum 当前列的顺序值
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> calendarRefArguments(String gridId, EditableGridColumnVO columnVO, String strStrategy,
        int iNum) {
        List<Argument> lstRefArguments = new ArrayList<Argument>();
        Argument objTableId = new Argument();
        objTableId.setName("tableId");
        objTableId.setValue(gridId);
        lstRefArguments.add(objTableId);
        
        Argument objRowIndex = new Argument();
        objRowIndex.setName("rowIndex");
        objRowIndex.setValue("1");
        lstRefArguments.add(objRowIndex);
        
        Argument objColIndex = new Argument();
        objColIndex.setName("colIndex");
        objColIndex.setValue(String.valueOf(iNum));
        lstRefArguments.add(objColIndex);
        return lstRefArguments;
        
    }
    
    /**
     * radioGroup select_editgrid_radio 参数
     * eGrid单选框设值 uiid-7901557899778709 1 6
     * tableId 表格定位 gridId
     * rowIndex 行索引 1
     * colIndex 列索引 iNum
     * rIndex 选项索引 default="1"
     * 
     * @param gridId gridId
     * @param columnVO 字段控件信息
     * @param strStrategy 录入策略
     * @param iNum 当前列的顺序值
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> radioGroupRefArguments(String gridId, EditableGridColumnVO columnVO, String strStrategy,
        int iNum) {
        List<Argument> lstRefArguments = new ArrayList<Argument>();
        Argument objTableId = new Argument();
        objTableId.setName("tableId");
        objTableId.setValue(gridId);
        lstRefArguments.add(objTableId);
        
        Argument objRowIndex = new Argument();
        objRowIndex.setName("rowIndex");
        objRowIndex.setValue("1");
        lstRefArguments.add(objRowIndex);
        
        Argument objColIndex = new Argument();
        objColIndex.setName("colIndex");
        objColIndex.setValue(String.valueOf(iNum));
        lstRefArguments.add(objColIndex);
        
        Argument objINdex = new Argument();
        objINdex.setName("rIndex");
        objINdex.setValue("1");
        lstRefArguments.add(objINdex);
        return lstRefArguments;
    }
    
    /**
     * checkboxGroup select_editgrid_checkbox 参数
     * eGrid复选框设值 uiid-7901557899778709 1 10 [1]
     * tableId 表格定位 gridId
     * rowIndex 行索引 1
     * colIndex 列索引 iNum
     * rIndexes 选项索引 default="[1]"
     *
     * @param gridId gridId
     * @param columnVO 字段控件信息
     * @param strStrategy 录入策略
     * @param iNum 当前列的顺序值
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> checkboxGroupRefArguments(String gridId, EditableGridColumnVO columnVO, String strStrategy,
        int iNum) {
        List<Argument> lstRefArguments = new ArrayList<Argument>();
        Argument objTableId = new Argument();
        objTableId.setName("tableId");
        objTableId.setValue(gridId);
        lstRefArguments.add(objTableId);
        
        Argument objRowIndex = new Argument();
        objRowIndex.setName("rowIndex");
        objRowIndex.setValue("1");
        lstRefArguments.add(objRowIndex);
        
        Argument objColIndex = new Argument();
        objColIndex.setName("colIndex");
        objColIndex.setValue(String.valueOf(iNum));
        lstRefArguments.add(objColIndex);
        
        Argument objRIndex = new Argument();
        objRIndex.setName("rIndexes");
        objRIndex.setValue("[1]");
        lstRefArguments.add(objRIndex);
        return lstRefArguments;
    }
    
    /**
     * pulldown select_editgrid_pulldown_single 参数
     * eGrid下拉框单选设值 uiid-7901557899778709 1 9
     * tableId 表格定位 gridId
     * rowIndex 行索引 1
     * colIndex 列索引 iNum
     * num 多选时选择的数量 default="1"
     * 
     * @param gridId gridId
     * @param columnVO 字段控件信息
     * @param strStrategy 录入策略
     * @param iNum 当前列的顺序值
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> pulldownRefArguments(String gridId, EditableGridColumnVO columnVO, String strStrategy,
        int iNum) {
        List<Argument> lstRefArguments = new ArrayList<Argument>();
        Argument objTableId = new Argument();
        objTableId.setName("tableId");
        objTableId.setValue(gridId);
        lstRefArguments.add(objTableId);
        
        Argument objRowIndex = new Argument();
        objRowIndex.setName("rowIndex");
        objRowIndex.setValue("1");
        lstRefArguments.add(objRowIndex);
        
        Argument objColIndex = new Argument();
        objColIndex.setName("colIndex");
        objColIndex.setValue(String.valueOf(iNum));
        lstRefArguments.add(objColIndex);
        
        Argument objRIndex = new Argument();
        objRIndex.setName("num");
        objRIndex.setValue("1");
        lstRefArguments.add(objRIndex);
        return lstRefArguments;
    }
    
    /**
     * Input input_editgrid_text 参数
     * eGrid输入文本 uiid-7901557899778709 1 2 1111
     * tableId 表格定位 gridId
     * rowIndex 行索引 1
     * colIndex 列索引 iNum
     * text 需要输入的文本
     * 
     * @param gridId gridId
     * @param columnVO 字段控件信息
     * @param strStrategy 录入策略
     * @param iNum 当前列的顺序值
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> inputRefArguments(String gridId, EditableGridColumnVO columnVO, String strStrategy, int iNum) {
        List<Argument> lstRefArguments = new ArrayList<Argument>();
        Argument objTableId = new Argument();
        objTableId.setName("tableId");
        objTableId.setValue(gridId);
        lstRefArguments.add(objTableId);
        
        Argument objRowIndex = new Argument();
        objRowIndex.setName("rowIndex");
        objRowIndex.setValue("1");
        lstRefArguments.add(objRowIndex);
        
        Argument objColIndex = new Argument();
        objColIndex.setName("colIndex");
        objColIndex.setValue(String.valueOf(iNum));
        lstRefArguments.add(objColIndex);
        
        Argument objText = new Argument();
        objText.setName("text");
        objText.setValue(setArgValue(gridId, columnVO, strStrategy));
        lstRefArguments.add(objText);
        return lstRefArguments;
    }
    
    /**
     * 设置字段值
     * 根据strType设置字段的值：自动生成-值/动态随机-表达式/ 字典获取-不处理/手动录入-不处理
     * 字符串、数值、日期
     * 
     * @param gridId GridId
     * @param columnVO 列信息
     * @param strStrategy 录入策略auto自动生成dynamic动态随机dictionary字典获取manual手动录入
     * @return 具体的值
     */
    private String setArgValue(String gridId, EditableGridColumnVO columnVO, String strStrategy) {
        
        // Input--mask(Datetimes Times Time Datetime Date / Int Dec Num Money )
        // Calender
        String strUitype = columnVO.getUitype();
        String strMask = "";
        if ("Input".equals(strUitype)) {
            strMask = columnVO.getMask();
        }
        if ("auto".equals(strStrategy)) { // java自动生成
            return setCodeAutoValue(strUitype, strMask);
        } else if ("dynamic".equals(strStrategy)) { // 随机函数
            return setRandomValue(strUitype, strMask);
        }
        return setCodeAutoValue(strUitype, strMask);
    }
    
    /**
     * 自动设置值
     *
     * @param strUitype 控件类型
     * @param strMask 控件配置
     * @return 自动设置值
     */
    private String setCodeAutoValue(String strUitype, String strMask) {
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
    
}
