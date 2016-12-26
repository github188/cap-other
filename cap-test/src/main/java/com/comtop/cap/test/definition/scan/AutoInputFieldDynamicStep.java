/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.definition.scan;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import com.comtop.cap.bm.metadata.page.desinger.model.LayoutVO;
import com.comtop.cap.bm.metadata.page.external.PageMetadataProvider;
import com.comtop.cap.runtime.core.AppBeanUtil;
import com.comtop.cap.test.definition.facade.StepFacade;
import com.comtop.cap.test.definition.model.Argument;
import com.comtop.cap.test.definition.model.BasicStep;
import com.comtop.cap.test.definition.model.DynamicStep;
import com.comtop.cap.test.definition.model.StepReference;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cip.jodd.util.StringUtil;

/**
 * 自动录入字段的实现类
 *
 * @author 李小芬
 * @since jdk1.6
 * @version 2016年7月8日 李小芬
 */
@PetiteBean
public class AutoInputFieldDynamicStep implements DynamicStepScanner {
    
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
        String strPageModelId = args.get(DynamicConstant.PAGE_MODEL_ID); // 页面ID
        String strInputOption = getInputOption(args); // 输入选项：all、 required
        String strStrategy = getStrategy(args); // 录入策略
        String testCaseModelId = args.get(DynamicConstant.TEST_CASE_MODEL_ID); // 当前测试用例ID
        String currentStepId = args.get(DynamicConstant.CURRENT_STEP_ID); // 当前同步步骤ID
        
        // 2、获取已定义的动态步骤基本信息
        DynamicStep objDynamicStep = (DynamicStep) stepFacade.loadStepDefinitionById(stepId);
        if (objDynamicStep == null) {
            LOGGER.info("根据stepId：" + stepId + "没有找到相关的动态步骤。");
        }
        
        // 3、设置动态步骤的参数值
        setDynamicArgsValue(strPageModelId, strInputOption, strStrategy, objDynamicStep);
        
        // 4、获取已有的动态步骤
        List<StepReference> lstCurrentStepRef = DynamicUtils.queryCurrentStepRef(testCaseModelId, currentStepId);
        
        // 5、查找需要录入的字段配置信息
        List<LayoutVO> lstLayoutVO = queryAutoInputFieldLayout(strPageModelId, strInputOption);
        
        // 6、构造动态步骤的步骤引用信息
        List<StepReference> lstStepReference = structureNewStepRef(strStrategy, lstCurrentStepRef, lstLayoutVO);
        
        // 7、根据已存在步骤集和新步骤集，设置动态步骤的步骤引用信息
        setStepReference(objDynamicStep, lstCurrentStepRef, lstStepReference);
        
        return objDynamicStep;
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
     * 获取字段选项，如果没传过来则给定默认值
     *
     * @param args 参数集合
     * @return 字段选项
     */
    private String getInputOption(Map<String, String> args) {
        String strInputOption = args.get(DynamicConstant.INPUT_OPTION);
        if (StringUtil.isBlank(strInputOption)) {
            return DynamicConstant.INPUT_OPTION_ALL;
        }
        return strInputOption;
    }
    
    /**
     * 构造新的步骤引用信息
     *
     * @param strStrategy 录入策略
     * @param lstCurrentStepRef 当前已有子步骤
     * @param lstLayoutVO 字段配置信息
     * @return 新的步骤引用信息
     */
    private List<StepReference> structureNewStepRef(String strStrategy, List<StepReference> lstCurrentStepRef,
        List<LayoutVO> lstLayoutVO) {
        List<StepReference> lstStepReference = new ArrayList<StepReference>();
        for (LayoutVO layoutVO : lstLayoutVO) {
            // 开发建模的配置信息
            CapMap objCapMap = layoutVO.getOptions();
            objCapMap.put(DynamicConstant.ID, getFieldId(objCapMap, layoutVO));
            // 是否已存在子步骤中，存在跳过
            if (isExsitStep(objCapMap, lstCurrentStepRef)) {
                continue;
            }
            // 不存在，则加入新步骤集
            lstStepReference.add(structureStepReferenceVO(objCapMap, strStrategy));
        }
        return lstStepReference;
    }
    
    /**
     * 构造出步骤引用VO
     *
     * @param objCapMap 控件配置信息
     * @param strategy 录入策略
     * @return 步骤引用VO
     */
    private StepReference structureStepReferenceVO(CapMap objCapMap, String strategy) {
        StepReference objStepReference = new StepReference();
        objStepReference.setDescription(getStepRefDesc(objCapMap));
        objStepReference.setType(DynamicUtils.getStepIdByUiType(objCapMap));
        objStepReference.setName(setNameByUiType(objCapMap));
        objStepReference.setIcon(setIconByUiType(objCapMap));
        objStepReference.setArguments(setRefArguments(objCapMap, strategy));
        return objStepReference;
    }
    
    /**
     * 获取步骤名称
     *
     * @param objCapMap 控件信息
     * @return 步骤名称
     */
    private String getStepRefDesc(CapMap objCapMap) {
        String strChName = (String) objCapMap.get(DynamicConstant.LABEL);
        String strEngName = (String) objCapMap.get(DynamicConstant.NAME);
        if (StringUtil.isNotBlank(strChName)) {
            return strChName;
        }
        return strEngName;
    }
    
    /**
     * 获取字段的ID
     *
     * @param objCapMap 控件options配置
     * @param layoutVO 控件外层配置
     * @return 字段ID
     */
    private String getFieldId(CapMap objCapMap, LayoutVO layoutVO) {
        String strId = (String) objCapMap.get(DynamicConstant.ID);
        if (StringUtil.isBlank(strId)) {
            strId = layoutVO.getId();
        }
        return strId;
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
     * 设置动态步骤参数值
     *
     * @param pageModelId 页面ID
     * @param inputOption 字段选项
     * @param strategy 录入策略
     * @param dynamicStep 当前动态步骤
     */
    private void setDynamicArgsValue(String pageModelId, String inputOption, String strategy, DynamicStep dynamicStep) {
        List<Argument> lstArguments = dynamicStep.getArguments();
        for (Argument argument : lstArguments) {
            if (DynamicConstant.PAGE_MODEL_ID.equals(argument.getName())) {
                argument.setValue(pageModelId);
            } else if (DynamicConstant.INPUT_OPTION.equals(argument.getName())) {
                argument.setValue(inputOption);
            } else if (DynamicConstant.STRATEGY.equals(argument.getName())) {
                argument.setValue(strategy);
            }
        }
    }
    
    /**
     * 根据modelId、strInputOption查找页面对应的全部字段或必填字段
     *
     * @param pageModelId 页面ID
     * @param inputOption 输入选项
     * @return 自动录入的字段集合
     */
    @SuppressWarnings("unchecked")
    private List<LayoutVO> queryAutoInputFieldLayout(String pageModelId, String inputOption) {
        PageMetadataProvider metadataProvider = new PageMetadataProvider();
        Map<String, Object> objFiledMap = metadataProvider.queryInputTypeCmpsByModelId(pageModelId, new ArrayList<String>(){{add(DynamicConstant.EDITABLEGRID); }}, DynamicConstant.INPUT_OPTION_REQUIRED.equals(inputOption));
        List<LayoutVO> lstLayoutVO = (List<LayoutVO>) objFiledMap.get("dataList");
//        List<LayoutVO> lstRemoveLayout = new ArrayList<LayoutVO>();
//        for (int i = 0; i < lstLayoutVO.size(); i++) {
//            LayoutVO objLayoutVO = lstLayoutVO.get(i);
//            CapMap objCapMap = objLayoutVO.getOptions();
//            String strUitype = (String) objCapMap.get(DynamicConstant.UI_TYPE);
//            // 移除可编辑Grid
//            if (DynamicConstant.EDITABLEGRID.equals(strUitype)) {
//                lstRemoveLayout.add(lstLayoutVO.get(i));
//                continue;
//            }
//            // 移除非必填字段
//            if (DynamicConstant.INPUT_OPTION_REQUIRED.equals(inputOption)
//                && objCapMap.get(DynamicConstant.INPUT_OPTION_REQUIRED) != null
//                && !(Boolean) objCapMap.get(DynamicConstant.INPUT_OPTION_REQUIRED)) {
//                lstRemoveLayout.add(lstLayoutVO.get(i));
//                continue;
//            }
//            // 移除只读字段
//            if (objCapMap.get(DynamicConstant.READONLY) != null && (Boolean) objCapMap.get(DynamicConstant.READONLY)) {
//                lstRemoveLayout.add(lstLayoutVO.get(i));
//                continue;
//            }
//        }
//        // 移除字段
//        if (lstRemoveLayout.size() > 0) {
//            lstLayoutVO.removeAll(lstRemoveLayout);
//        }
        if (lstLayoutVO != null && lstLayoutVO.size() == 0) {
            LOGGER.info("根据pageModelId：" + pageModelId + ",inputOption:" + inputOption + "没有找到可录入的字段。");
        }
        return lstLayoutVO;
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
        String strId = (String) objCapMap.get("id");
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
     * 根据Uitype设值图标
     * 
     * @param capMap 控件配置信息
     * @return 图标
     */
    private String setIconByUiType(CapMap capMap) {
        String stepId = DynamicUtils.getStepIdByUiType(capMap);
        BasicStep objBasicStep = DynamicUtils.getStepDefineById(stepId);
        if (objBasicStep != null) {
            return objBasicStep.getIcon();
        }
        return "icon-pencil";
    }
    
    /**
     * 根据Uitype设值图标
     * 
     * @param capMap 控件配置信息
     * @return 图标
     */
    private String setNameByUiType(CapMap capMap) {
        String stepId = DynamicUtils.getStepIdByUiType(capMap);
        BasicStep objBasicStep = DynamicUtils.getStepDefineById(stepId);
        if (objBasicStep != null) {
            return objBasicStep.getName();
        }
        return "";
    }
    
    /**
     * 创建引用步骤的参数信息
     * 参数name、value
     *
     * @param capMap 字段控件
     * @param strStrategy 录入策略
     * @return 步骤的参数信息
     */
    private List<Argument> setRefArguments(CapMap capMap, String strStrategy) {
        String strUitype = (String) capMap.get(DynamicConstant.UI_TYPE);
        if (DynamicConstant.INPUT.equals(strUitype)) {
            return this.inputRefArguments(capMap, strStrategy);
        } else if (DynamicConstant.PULLDOWN.equals(strUitype)) {
            return this.pulldownRefArguments(capMap, strStrategy);
        } else if (DynamicConstant.CHECKBOX_GROUP.equals(strUitype)) {
            return this.checkboxGroupRefArguments(capMap, strStrategy);
        } else if (DynamicConstant.RADIO_GROUP.equals(strUitype)) {
            return this.radioGroupRefArguments(capMap, strStrategy);
        } else if (DynamicConstant.CALENDER.equals(strUitype)) {
            return this.calendarRefArguments(capMap, strStrategy);
        } else if (DynamicConstant.TEXTAREA.equals(strUitype)) {
            return this.textareaRefArguments(capMap, strStrategy);
        } else if (DynamicConstant.EDITOR.equals(strUitype)) {
            return this.editorRefArguments(capMap, strStrategy);
        } else if (DynamicConstant.CLICK_INPUT.equals(strUitype)) {
            return this.customRefArguments(capMap, strStrategy);
        } else if (DynamicConstant.LISTBOX.equals(strUitype)) {
            return this.listboxRefArguments(capMap, strStrategy);
        } else if (DynamicConstant.CHOOSE_USER.equals(strUitype)) {
            if (capMap.get("chooseMode") != null && "0".equals(String.valueOf(capMap.get("chooseMode")))) {
                return this.chooseUserMultiRefArguments(capMap, strStrategy);
            }
            return this.chooseUserRefArguments(capMap, strStrategy);
        } else if (DynamicConstant.CHOOSE_ORG.equals(strUitype)) {
            if (capMap.get("chooseMode") != null && "0".equals(String.valueOf(capMap.get("chooseMode")))) {
                return this.chooseOrgMultiRefArguments(capMap, strStrategy);
            }
            return this.chooseOrgRefArguments(capMap, strStrategy);
        }
        return this.customRefArguments(capMap, strStrategy);
    }
    
    /**
     * ChooseOrg choose_multi_org 参数
     * ${id} 控件id
     * num 选择的组织数量 default="3"
     * ${clear} 是否清除以前的选项 default="False"
     *
     * @param capMap 字段控件信息
     * @param strStrategy 录入策略
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> chooseOrgMultiRefArguments(CapMap capMap, String strStrategy) {
        String strId = (String) capMap.get("id");
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
     * @param strStrategy 录入策略
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> chooseOrgRefArguments(CapMap capMap, String strStrategy) {
        String strId = (String) capMap.get("id");
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
     * chooseUser choose_multi_user 参数
     * ${id} 控件id
     * num 选择的人员数量 default="3"
     * ${clear} 是否清除以前的选项 default="False"
     *
     * @param capMap 字段控件信息
     * @param strStrategy 录入策略
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> chooseUserMultiRefArguments(CapMap capMap, String strStrategy) {
        String strId = (String) capMap.get("id");
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
     * @param strStrategy 录入策略
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> chooseUserRefArguments(CapMap capMap, String strStrategy) {
        String strId = (String) capMap.get("id");
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
     * ListBox click_element 参数
     * ${locator} 元素定位
     * xpath=//*[@id="uiid-6445649012980573"]/div/ul/li[1]
     *
     * @param capMap 字段控件信息
     * @param strStrategy 录入策略
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> listboxRefArguments(CapMap capMap, String strStrategy) {
        String strId = (String) capMap.get("id");
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
     * Custom custom_set_value 参数
     * ${id} 控件ID
     *
     * @param capMap 字段控件信息
     * @param strStrategy 录入策略
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> customRefArguments(CapMap capMap, String strStrategy) {
        String strId = (String) capMap.get("id");
        List<Argument> lstRefArguments = new ArrayList<Argument>();
        Argument objLocator = new Argument();
        objLocator.setName("id");
        objLocator.setValue(strId);
        lstRefArguments.add(objLocator);
        return lstRefArguments;
    }
    
    /**
     * Editor execute_javascript 参数
     * ${code} JavaScript代码
     * cui("#uiid-8317132763499204").setHtml('wwww')
     *
     * @param capMap 字段控件信息
     * @param strStrategy 录入策略
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> editorRefArguments(CapMap capMap, String strStrategy) {
        String strId = (String) capMap.get("id");
        List<Argument> lstRefArguments = new ArrayList<Argument>();
        Argument objCode = new Argument();
        objCode.setName("code");
        StringBuffer sbCode = new StringBuffer();
        sbCode.append("cui('#").append(strId).append("')");
        sbCode.append(".setHtml('").append(DynamicUtils.getRandomString(15)).append("')");
        objCode.setValue(sbCode.toString());
        lstRefArguments.add(objCode);
        return lstRefArguments;
    }
    
    /**
     * Textarea cui_input_text 参数
     * ${id} 文本框id
     * ${text} 输入内容
     *
     * @param capMap 字段控件信息
     * @param strStrategy 录入策略
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> textareaRefArguments(CapMap capMap, String strStrategy) {
        String strId = (String) capMap.get("id");
        List<Argument> lstRefArguments = new ArrayList<Argument>();
        Argument objLocator = new Argument();
        objLocator.setName("id");
        objLocator.setValue(strId);
        lstRefArguments.add(objLocator);
        Argument objText = new Argument();
        objText.setName("text");
        objText.setValue(DynamicUtils.setArgValue(capMap, strStrategy));
        lstRefArguments.add(objText);
        return lstRefArguments;
    }
    
    /**
     * Calender calender_set_date参数
     * id 日期组件的id
     *
     * @param capMap 字段控件信息
     * @param strStrategy 录入策略
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> calendarRefArguments(CapMap capMap, String strStrategy) {
        String strId = (String) capMap.get("id");
        List<Argument> lstRefArguments = new ArrayList<Argument>();
        Argument objId = new Argument();
        objId.setName("id");
        objId.setValue(strId);
        lstRefArguments.add(objId);
        return lstRefArguments;
    }
    
    /**
     * Input cui_input_text 参数
     * ${id} 文本框id
     * ${text} 输入内容
     *
     * @param capMap 字段控件信息
     * @param strStrategy 录入策略
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> inputRefArguments(CapMap capMap, String strStrategy) {
        String strId = (String) capMap.get("id");
        List<Argument> lstRefArguments = new ArrayList<Argument>();
        Argument objLocator = new Argument();
        objLocator.setName("id");
        objLocator.setValue(strId);
        lstRefArguments.add(objLocator);
        Argument objText = new Argument();
        objText.setName("text");
        objText.setValue(DynamicUtils.setArgValue(capMap, strStrategy));
        lstRefArguments.add(objText);
        return lstRefArguments;
    }
    
    /**
     * RadioGroup select_radio参数
     * id 控件id
     * index 选项索引 default="1"
     *
     * @param capMap 字段控件信息
     * @param strStrategy 录入策略
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> radioGroupRefArguments(CapMap capMap, String strStrategy) {
        String strId = (String) capMap.get("id");
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
     * CheckboxGroup select_checkbox参数
     * id 控件id
     * indexes 索引 default="[1]"
     *
     * @param capMap 字段控件信息
     * @param strStrategy 录入策略
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> checkboxGroupRefArguments(CapMap capMap, String strStrategy) {
        String strId = (String) capMap.get("id");
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
     * pulldown cui_pulldown_select 参数
     * id 下拉框id
     * num 多选时选择的数量 default="1"
     * CUI下拉框设值 uiid-6605641281473248 1
     *
     * @param capMap 字段控件信息
     * @param strStrategy 录入策略
     * @return 输入文本步骤的参数引用
     */
    private List<Argument> pulldownRefArguments(CapMap capMap, String strStrategy) {
        String strId = (String) capMap.get("id");
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
    
}
