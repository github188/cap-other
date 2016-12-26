
package com.comtop.cap.test.design.practice.function;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang.RandomStringUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.page.desinger.model.DataStoreVO;
import com.comtop.cap.bm.metadata.page.desinger.model.LayoutVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageActionVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageConstantVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageUITypeEnum;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.page.external.PageMetadataProvider;
import com.comtop.cap.bm.metadata.sysmodel.facade.SysmodelFacade;
import com.comtop.cap.bm.metadata.sysmodel.model.CapPackageVO;
import com.comtop.cap.test.definition.facade.StepFacade;
import com.comtop.cap.test.definition.model.Argument;
import com.comtop.cap.test.definition.model.DynamicStep;
import com.comtop.cap.test.definition.model.FixedStep;
import com.comtop.cap.test.definition.model.Practice;
import com.comtop.cap.test.definition.model.StepAggregation;
import com.comtop.cap.test.definition.model.StepDefinition;
import com.comtop.cap.test.definition.model.StepReference;
import com.comtop.cap.test.definition.model.StepType;
import com.comtop.cap.test.definition.model.VirtualStep;
import com.comtop.cap.test.design.facade.InvokeFacade;
import com.comtop.cap.test.design.model.Line;
import com.comtop.cap.test.design.model.Step;
import com.comtop.cap.test.design.model.TestCase;
import com.comtop.cap.test.preference.facade.TestmodelDicItemFacade;
import com.comtop.cap.test.preference.model.TestmodelDicItemVO;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.cip.json.JSONArray;
import com.comtop.cip.json.JSONObject;
import com.comtop.top.sys.accesscontrol.func.facade.IFuncFacade;
import com.comtop.top.sys.accesscontrol.func.model.FuncDTO;

/**
 * 最佳实践的基本实现
 *
 *
 * @author 章尊志
 * @since jdk1.6
 * @version 2016年7月20日 章尊志
 */
public abstract class AbstractFunctionTestcaseGenerater implements FunctionTestcaseGenerater {
    
    /** 日志 */
    protected final static Logger logger = LoggerFactory.getLogger(AbstractFunctionTestcaseGenerater.class);
    
    /** tab选择步骤 */
    private final static String CUI_SELECT_TAB = "testStepDefinitions.basics.basic.cui_select_tab";
    
    /** 测试系统的中文名称 配置的字典项KEY */
    private final static String CHINESE_SYSTEM_NAME = "chineseSystemName";
    
    /** 页面元数据提供的相关接口Facade */
    @PetiteInject
    protected PageMetadataProvider pageMetadataProvider;
    
    /** 动态步骤、最佳实践调用接口Facade */
    @PetiteInject
    protected InvokeFacade invokeFacade;
    
    /** 包Facade */
    @PetiteInject
    protected SysmodelFacade sysmodelFacade;
    
    /**
     * 页面/菜单 facade
     */
    @PetiteInject
    protected IFuncFacade funcFacade;
    
    /** 步骤Facade */
    @PetiteInject
    protected StepFacade stepFacade;
    
    /** Service */
    @PetiteInject
    protected TestmodelDicItemFacade testmodelDicItemFacade;
    
    /**
     * 
     * @see com.comtop.cap.test.design.practice.function.FunctionTestcaseGenerater#genTestcase(com.comtop.cap.test.definition.model.Practice,
     *      com.comtop.cap.test.design.model.TestCase, com.comtop.cap.bm.metadata.page.desinger.model.PageVO,String)
     */
    @Override
    public void genTestcase(Practice practice, TestCase testcase, PageVO pageVO, String strActionId) {
        if (practice.getSteps() == null || practice.getSteps().isEmpty()) {
            return;
        }
        Map<String, Object> args = this.wrapperArgs(pageVO, strActionId);
        if (args == null) {
            return;
        }
        this.fixedTestcase(practice, testcase, args);
    }
    
    /**
     * 根据参数完善测试用例
     *
     * @param practice 最佳实践
     * @param testcase 测试用例
     * @param args 参数
     */
    private void fixedTestcase(Practice practice, TestCase testcase, Map<String, Object> args) {
        String preStepId = null;
        for (VirtualStep virtual : practice.getSteps()) {
            if (virtual instanceof StepAggregation) {// 如果为虚拟步骤
                StepAggregation objStepAggregation = (StepAggregation) virtual;
                if ("EditGrid".equals(objStepAggregation.getDefinition()) && args.containsKey("EGridSize")
                    && (Integer) args.get("EGridSize") > 0) {
                    List<StepReference> lstStepReference = objStepAggregation.getSteps();
                    for (int i = 0, len = (Integer) args.get("EGridSize"); i < len; i++) {
                        Map<String, Object> objArgs = (Map<String, Object>) args.get("EGrid" + i);
                        for (StepReference objStepReference : lstStepReference) {
                            Map<String, Object> objRet = generateStep(testcase, objArgs, objStepReference, preStepId);
                            preStepId = (String) objRet.get("preStepId");
                            testcase = (TestCase) objRet.get("testcase");
                        }
                    }
                }
            } else {
                StepReference objStepReference = (StepReference) virtual;
                Map<String, Object> objRet = generateStep(testcase, args, objStepReference, preStepId);
                preStepId = (String) objRet.get("preStepId");
                testcase = (TestCase) objRet.get("testcase");
            }
            
        }
    }
    
    /**
     * 生成步骤定义
     * 
     * @param testcase 测试用例
     * @param args 参数
     * @param objStepReference 步骤定义
     * @param preStepId 步骤ID
     * @return preStepId
     */
    private Map<String, Object> generateStep(TestCase testcase, Map<String, Object> args,
        StepReference objStepReference, String preStepId) {
        Map<String, Object> objRet = new HashMap<String, Object>();
        // tab步骤选择过滤
        if (CUI_SELECT_TAB.equals(objStepReference.getType()) && !args.containsKey("tab-id")) {
            objRet.put("preStepId", preStepId);
            objRet.put("testcase", testcase);
            return objRet;
        }
        
        Step step = new Step();
        String currentStepId = RandomStringUtils.randomAlphabetic(12);
        step.setId(currentStepId);
        step.setName(objStepReference.getName());
        step.setDescription(objStepReference.getDescription());
        String strType = objStepReference.getType();
        // 根据步骤ID获取步骤类型，确定调用的步骤对象
        StepDefinition objStepDefinition = stepFacade.loadStepDefinitionById(strType);
        if (StepType.FIXED.equals(objStepDefinition.getStepType())) {
            FixedStep objFixedStep = (FixedStep) stepFacade.loadStepDefinitionById(strType);
            objStepReference.setSteps(objFixedStep.getSteps());
            setStepArgumentValue(objStepReference.getSteps(), args);
            step.setType(StepType.FIXED);
            step.setReference(objStepReference);// 步骤的输入参数
        } else if (StepType.DYNAMIC.equals(objStepDefinition.getStepType())) {
            DynamicStep objDynamicStep = this.getDynamicStep(strType, args);
            step.setType(StepType.DYNAMIC);
            objStepReference.setSteps(objDynamicStep.getSteps());
        } else {
            step.setType(StepType.BASIC);
        }
        step.setReference(objStepReference);
        
        testcase.addStep(step);
        if (preStepId != null) {
            Line line = new Line();
            line.setForm(preStepId);
            line.setTo(currentStepId);
            testcase.addLine(line);
        }
        preStepId = currentStepId;
        List<Argument> arguments = objStepReference.getArguments();
        objRet.put("preStepId", preStepId);
        objRet.put("testcase", testcase);
        if (arguments == null) {
            return objRet;
        }
        // 设置参数值
        setArgumentValue(arguments, args);
        return objRet;
    }
    
    /**
     * 包装参数
     *
     * @param objPageVO 页面元数据对象
     * @param strActionId 行为ID
     * @return 参数
     */
    public abstract Map<String, Object> wrapperArgs(PageVO objPageVO, String strActionId);
    
    /**
     * 获取动态步骤,空方法，留给有动态步骤的重写该方法
     * 
     * @param strType 步骤类型，实际为步骤的modelId
     * @param args 参数
     * @return 动态步骤
     */
    public DynamicStep getDynamicStep(String strType, Map<String, Object> args) {
        return null;
    }
    
    /**
     * 根据modelID获取页面元数据
     * 
     * @param modelId modelId
     * @return 页面元数据
     */
    protected PageVO getPageByModelId(String modelId) {
        try {
            PageVO objListPageVO = pageMetadataProvider.getPageByModelId(modelId);
            return objListPageVO;
        } catch (OperateException e) {
            logger.error("获取页面元数据出错！", e);
        }
        return null;
    }
    
    /**
     * 设置步骤里面的参数值
     * 
     * @param steps 步骤集合
     * @param objArgs 参数值
     */
    private void setStepArgumentValue(List<StepReference> steps, Map<String, Object> objArgs) {
        for (StepReference objStepReference : steps) {
            if (objStepReference.getArguments() != null) {
                setArgumentValue(objStepReference.getArguments(), objArgs);
            }
        }
    }
    
    /**
     * 设置参数值
     * 
     * @param arguments 参数集合
     * @param objArgs 参数值
     */
    private void setArgumentValue(List<Argument> arguments, Map<String, Object> objArgs) {
        for (Argument argument : arguments) {
            String value = argument.getValue();
            if (value.startsWith("${") && value.endsWith("}")) {
                String key = value.substring(2, value.length() - 1);
                if (objArgs.containsKey(key)) {
                    argument.setValue(String.valueOf(objArgs.get(key)));
                }
            }
        }
        
    }
    
    /**
     * 根据控件类型获取控件Id
     * 
     * @param objListPageVO 列表页面元数据
     * @param strUitype 控件类型
     * @return 控件ID
     */
    protected String getLayoutIdByType(PageVO objListPageVO, String strUitype) {
        if (objListPageVO == null) {
            return "";
        }
        List<String> lstUiType = new ArrayList<String>();
        lstUiType.add(strUitype);
        Map<String, Object> objPageLayoutVO = pageMetadataProvider.queryCmpsByUItypes(objListPageVO.getModelId(),
            lstUiType);// 根据控件类型获取控件对象
        List<LayoutVO> lstLayoutVO = (List<LayoutVO>) objPageLayoutVO.get("dataList");
        if (lstLayoutVO == null || lstLayoutVO.size() == 0) {
            return "";
        }
        return lstLayoutVO.get(0).getId();
    }
    
    /**
     * 根据页面元数据和行为类型（actionType）获取绑定的控件ID
     *
     * @param objPageVO 页面元数据
     * @param strActionType 行为类型
     * @return 绑定的控件ID
     */
    protected String getActionIdByActionType(PageVO objPageVO, String strActionType) {
        List<PageActionVO> lstPageActionVO = objPageVO.getPageActionVOList();
        for (PageActionVO objPageActionVO : lstPageActionVO) {
            if (strActionType.equals(objPageActionVO.getMethodOption().get("actionType"))) {
                List<LayoutVO> lstEditPageLayoutVO;
                try {
                    lstEditPageLayoutVO = pageMetadataProvider.getLayoutVOListFromActionId(objPageVO.getModelId(),
                        objPageActionVO.getPageActionId());
                    for (LayoutVO objLayoutVO : lstEditPageLayoutVO) {
                        String strUiType = objLayoutVO.getUiType();
                        if (strUiType.equals("Button")) {
                            String strId = (String) objLayoutVO.getOptions().get("id");
                            if (StringUtils.isEmpty(strId)) {
                                strId = objLayoutVO.getId();
                            }
                            if (StringUtils.isEmpty(strId)) {
                                strId = "";
                            }
                            
                            return strId;
                        }
                    }
                } catch (OperateException e) {
                    logger.error("根据行为ID获取绑定的控件出错", e);
                }
            }
        }
        return "";
    }
    
    /**
     * 根据页面元数据,行为类型（actionType）和绑定的gridid获取绑定的控件ID
     *
     * @param objPageVO 页面元数据
     * @param strActionType 行为类型
     * @param strEGridId gridId
     * @return 绑定的控件ID
     */
    protected String getEGridActionId(PageVO objPageVO, String strActionType, String strEGridId) {
        List<PageActionVO> lstPageActionVO = objPageVO.getPageActionVOList();
        for (PageActionVO objPageActionVO : lstPageActionVO) {
            if (strActionType.equals(objPageActionVO.getMethodOption().get("actionType"))
                && strEGridId.equals(objPageActionVO.getMethodOption().get("relationGridId"))) {
                List<LayoutVO> lstEditPageLayoutVO;
                try {
                    lstEditPageLayoutVO = pageMetadataProvider.getLayoutVOListFromActionId(objPageVO.getModelId(),
                        objPageActionVO.getPageActionId());
                    for (LayoutVO objLayoutVO : lstEditPageLayoutVO) {
                        String strUiType = objLayoutVO.getUiType();
                        if (strUiType.equals("Button")) {
                            String strId = (String) objLayoutVO.getOptions().get("id");
                            if (StringUtils.isEmpty(strId)) {
                                strId = objLayoutVO.getId();
                            }
                            if (StringUtils.isEmpty(strId)) {
                                strId = "";
                            }
                            return strId;
                        }
                    }
                } catch (OperateException e) {
                    logger.error("根据行为ID获取绑定的控件出错", e);
                }
            }
        }
        return "";
    }
    
    /**
     * 根据行为ID和行为属性名，获取行为属性值
     *
     * @param objPageVO 页面元数据
     * @param strActionType 行为类型
     * @param strOptionName 行为属性名称
     * @return 行为属性名称的值
     */
    protected String getAcitonOptionValueByOptionName(PageVO objPageVO, String strActionType, String strOptionName) {
        String strRet = "";
        List<PageActionVO> lstPageActionVO = objPageVO.getPageActionVOList();
        for (PageActionVO objPageActionVO : lstPageActionVO) {
            if (strActionType.equals(objPageActionVO.getMethodOption().get("actionType"))) {
                strRet = (String) objPageActionVO.getMethodOption().get(strOptionName);
                break;
            }
        }
        return strRet;
    }
    
    /**
     * 根据包ID获取应用编码
     *
     * @param strPackageId 包ID
     * @return 包ID所在的应用编码
     */
    protected CapPackageVO getAppCodeByPackageId(String strPackageId) {
        return sysmodelFacade.readModuleVOById(strPackageId);
    }
    
    /**
     * 根据应用ID获取应用对象
     * 
     * @param strId strId
     * @return FuncDTO
     */
    protected FuncDTO getFuncDTOById(String strId) {
        return funcFacade.getFuncVO(strId);
    }
    
    /**
     * 根据列表页面和行为类型获取跳转的页面对象
     * 
     * @param objPageVO 页面元数据
     * @param strActionType 行为类型
     * @return 跳转的页面元数据
     */
    protected PageVO getEditPageVOByActiontType(PageVO objPageVO, String strActionType) {
        List<PageActionVO> lstPageActionVO = objPageVO.getPageActionVOList();
        for (PageActionVO objPageActionVO : lstPageActionVO) {
            if (strActionType.equals(objPageActionVO.getMethodOption().get("actionType"))) {
                String strPageURL = (String) objPageActionVO.getMethodOption().get("pageURL");
                List<PageConstantVO> pageConstantList = this.getPageConstantList(objPageVO);
                for (PageConstantVO objPageConstantVO : pageConstantList) {
                    if (strPageURL.equals(objPageConstantVO.getConstantName())) {
                        return this.getPageByModelId(String.valueOf(objPageConstantVO.getConstantOption().get(
                            "pageModelId")));
                    }
                }
            }
        }
        return null;
    }
    
    /**
     * 获取页面常量集合
     * 
     * @param objPageVO 页面元数据
     * @return 页面常量集合
     */
    private List<PageConstantVO> getPageConstantList(PageVO objPageVO) {
        List<DataStoreVO> dataStoreVOList = objPageVO.getDataStoreVOList();
        for (DataStoreVO objDataStoreVO : dataStoreVOList) {
            if ("pageConstant".equals(objDataStoreVO.getModelType())) {
                return objDataStoreVO.getPageConstantList();
            }
        }
        return null;
    }
    
    /**
     * 根据页面常量名称获取对应的页面元数据
     * 
     * @param objPageVO 页面元数据
     * @param strConstantName 常量名称
     * @return 页面元数据
     */
    protected PageVO getPageVOByConstantName(PageVO objPageVO, String strConstantName) {
        List<PageConstantVO> lstPageConstantVO = this.getPageConstantList(objPageVO);
        for (PageConstantVO objPageConstantVO : lstPageConstantVO) {
            if (strConstantName.equals(objPageConstantVO.getConstantName())) {
                return this.getPageByModelId((String) objPageConstantVO.getConstantOption().get("pageModelId"));
            }
        }
        return null;
    }
    
    /**
     * 根据页面元数据和行为类型获取编辑页面的列号
     * 
     * @param objPageVO 页面元数据
     * @param strActionType 行为类型
     * @return 编辑页面序号
     */
    protected String getUpdateColByActionType(PageVO objPageVO, String strActionType) {
        if (objPageVO == null) {
            return "";
        }
        List<PageActionVO> lstPageActionVO = objPageVO.getPageActionVOList();
        for (PageActionVO objPageActionVO : lstPageActionVO) {
            if (strActionType.equals(objPageActionVO.getMethodOption().get("actionType"))) {
                String strActionEname = objPageActionVO.getEname();
                List<String> lstUiType = new ArrayList<String>();
                lstUiType.add("Grid");
                Map<String, Object> objPageLayoutVO = pageMetadataProvider.queryCmpsByUItypes(objPageVO.getModelId(),
                    lstUiType);// 根据控件类型获取控件对象
                List<LayoutVO> lstLayoutVO = (List<LayoutVO>) objPageLayoutVO.get("dataList");
                String strSelectrows = (String) lstLayoutVO.get(0).getOptions().get("selectrows");
                JSONArray objColumns = JSONArray.parseArray((String) lstLayoutVO.get(0).getOptions().get("columns"));
                if (objColumns.size() > 0) {
                    for (int i = 0, len = objColumns.size(); i < len; i++) {
                        if (objColumns.get(i) instanceof JSONArray) {
                            // TODO多表头的情况待处理
                            // updateRender((JSONArray) objColumns.get(i), tableHeader);
                        } else {
                            JSONObject objColumn = (JSONObject) objColumns.get(i);
                            String strRender = (String) objColumn.get("render");
                            if (StringUtils.isNotBlank(strRender) && strRender.equals(strActionEname)) {
                                if (StringUtils.isNotEmpty(strSelectrows) && strSelectrows.equals("no")) {
                                    return String.valueOf(i + 1);
                                }
                                return String.valueOf(i + 2);
                            }
                        }
                    }
                    
                }
            }
        }
        
        return null;
    }
    
    /**
     * 获取系统中文名称
     *
     * @return 系统中文名称
     */
    protected String getChineseSystemName() {
        TestmodelDicItemVO objTestmodelDicItemVO = testmodelDicItemFacade.readDicItemVOByCode(CHINESE_SYSTEM_NAME);
        if (objTestmodelDicItemVO == null) {
            return "";
        }
        return objTestmodelDicItemVO.getDictionaryValue();
    }
    
    /**
     * 根据模块包路径获取
     * 
     * @param strModelPackageId 所在模块包id
     * @return 路径集合
     */
    protected Map<String, Object> getEditPagePath(String strModelPackageId) {
        Map<String, Object> objRetMap = new HashMap<String, Object>();
        // 获取模块下的所有页面
        List<PageVO> lstPageVO = this.getPagesByModelId(strModelPackageId);
        // 按页面类型分类模块下的页面
        Map<String, Object> objMap = getModulePageClassify(lstPageVO);
        
        // 获取tab页面集合
        List<PageVO> lstPageVOTab = (List<PageVO>) objMap.get(PageUITypeEnum.FRAME_PAGE.getPageUIType());
        if (lstPageVOTab != null) {
            for (PageVO objPageVO : lstPageVOTab) {
                
                // 获取页面的Tab控件
                LayoutVO objLayoutVO = this.getLayoutVOByType(objPageVO, "Tab").get(0);
                // 根据控件获取各个tab的url
                String objTabs = (String) objLayoutVO.getOptions().get("tabs");
                Pattern pattern = Pattern.compile("\"url\":([\\w]+)");
                Matcher matcher = pattern.matcher(objTabs);
                // 根据url获取页面元数据ID
                while (matcher.find()) {
                    List<PageVO> lstPathPageVO = new LinkedList<PageVO>();
                    // 1 tab页面
                    lstPathPageVO.add(objPageVO);
                    String strUrl = matcher.group(1);
                    PageVO objListPageVO = this.getPageVOByConstantName(objPageVO, strUrl);
                    // 清理被tab占用的页面
                    removePageVO(objMap, objListPageVO);
                    // 2tab页面里面的todo页面
                    lstPathPageVO.add(objListPageVO);
                    String strEditPageUrl = this.getAcitonOptionValueByOptionName(objListPageVO, "editLink", "pageURL");
                    PageVO objEditPageVO = this.getPageVOByConstantName(objListPageVO, strEditPageUrl);
                    // 3 编辑链接的页面
                    if (objEditPageVO != null) {
                        lstPathPageVO.add(objEditPageVO);
                        String strPageType = objListPageVO.getPageUIType();
                        String strMapKey = strPageType + objEditPageVO.getModelName();
                        objRetMap.put(strMapKey, lstPathPageVO);
                    }
                }
            }
        }
        // 处理没有tab页面的情况
        for (String strKey : objMap.keySet()) {
            if (StringUtils.isNotBlank(strKey) && !strKey.equals(PageUITypeEnum.FRAME_PAGE.getPageUIType())
                && !strKey.equals(PageUITypeEnum.EIDT_PAGE.getPageUIType())
                && !strKey.equals(PageUITypeEnum.VIEW_PAGE.getPageUIType())) {
                List<PageVO> lstNotTabPageVO = (List<PageVO>) objMap.get(strKey);
                if (lstNotTabPageVO != null) {
                    for (PageVO objPageVO : lstNotTabPageVO) {
                        List<PageVO> lstPathPageVO = new LinkedList<PageVO>();
                        String strEditPageUrl = this.getAcitonOptionValueByOptionName(objPageVO, "editLink", "pageURL");
                        PageVO objEditPageVO = this.getPageVOByConstantName(objPageVO, strEditPageUrl);
                        if (objEditPageVO != null) {
                            lstPathPageVO.add(objPageVO);
                            lstPathPageVO.add(objEditPageVO);
                            String strPageType = objPageVO.getPageUIType();
                            String strMapKey = strPageType + objEditPageVO.getModelName();
                            objRetMap.put(strMapKey, lstPathPageVO);
                        }
                    }
                }
            }
        }
        return objRetMap;
    }
    
    /**
     * 清除被tab页面占用的list页面
     * 
     * @param objMap 分类页面
     * @param objPageVO 需要清除的vo
     */
    private void removePageVO(Map<String, Object> objMap, PageVO objPageVO) {
        List<PageVO> lstPageVO = (List<PageVO>) objMap.get(objPageVO.getPageUIType());
        for (int i = 0; i < lstPageVO.size(); i++) {
            if (lstPageVO.get(i).getModelId().equals(objPageVO.getModelId())) {
                lstPageVO.remove(lstPageVO.get(i));
            }
        }
    }
    
    /**
     * 把模块下的页面按页面类型分类
     * 
     * @param lstPageVO 模块下的所有页面
     * @return 分类后的集合
     */
    private Map<String, Object> getModulePageClassify(List<PageVO> lstPageVO) {
        Map<String, Object> objMap = new HashMap<String, Object>();
        for (PageVO objPageVO : lstPageVO) {
            if (objPageVO.getPageType() == 2) {// 如果为自定义页面，不做处理
                continue;
            }
            if (objMap.containsKey(objPageVO.getPageUIType())) {
                List<PageVO> lstTempPageVO = (List<PageVO>) objMap.get(objPageVO.getPageUIType());
                lstTempPageVO.add(objPageVO);
            } else {
                List<PageVO> lstTempPageVO = new ArrayList<PageVO>();
                lstTempPageVO.add(objPageVO);
                objMap.put(objPageVO.getPageUIType(), lstTempPageVO);
            }
        }
        
        return objMap;
    }
    
    /**
     * 通过模块包ID获取该模块下所有的页面
     * 
     * @param strModelPackageId 模块包ID
     * @return 所有页面元数据
     */
    protected List<PageVO> getPagesByModelId(String strModelPackageId) {
        List<PageVO> lstPageVO = null;
        try {
            lstPageVO = pageMetadataProvider.getPagesByModelId(strModelPackageId);
        } catch (OperateException e) {
            logger.error("根据模块包ID获取模块下所有页面元数据出错", e);
        }
        return lstPageVO;
    }
    
    /**
     * 根据控件类型获取控件Id
     * 
     * @param objListPageVO 列表页面元数据
     * @param strUitype 控件类型
     * @return 控件ID
     */
    protected List<LayoutVO> getLayoutVOByType(PageVO objListPageVO, String strUitype) {
        List<String> lstUiType = new ArrayList<String>();
        lstUiType.add(strUitype);
        Map<String, Object> objPageLayoutVO = pageMetadataProvider.queryCmpsByUItypes(objListPageVO.getModelId(),
            lstUiType);// 根据控件类型获取控件对象
        return (List<LayoutVO>) objPageLayoutVO.get("dataList");
    }
    
    /**
     * 根据tab页面和tab页面中的list页面获取tab序号
     * 
     * @param objTabPageVO tab页面元数据
     * @param objListPageVO list页面元数据
     * @return tab序号
     */
    protected String getTabIndex(PageVO objTabPageVO, PageVO objListPageVO) {
        List<PageConstantVO> lstPageConstantVO = this.getPageConstantList(objTabPageVO);
        for (PageConstantVO objPageConstantVO : lstPageConstantVO) {
            String strPageModelId = (String) objPageConstantVO.getConstantOption().get("pageModelId");
            if (strPageModelId.equals(objListPageVO.getModelId())) {
                String strConstantName = objPageConstantVO.getConstantName();
                LayoutVO objLayoutVO = this.getLayoutVOByType(objTabPageVO, "Tab").get(0);
                
                // 根据控件获取各个tab的url
                String objTabs = (String) objLayoutVO.getOptions().get("tabs");
                Pattern pattern = Pattern.compile("\"url\":([\\w]+)");
                Matcher matcher = pattern.matcher(objTabs);
                int iCount = 0;
                // 根据url获取页面元数据ID
                while (matcher.find()) {
                    iCount++;
                    String strUrl = matcher.group(1);
                    if (strConstantName.equals(strUrl)) {
                        return String.valueOf(iCount);
                    }
                }
            }
        }
        return null;
    }
    
    /**
     * 根据列表页面获取上级tab页面
     * 
     * @param objLstPageVO 列表页面元数据
     * @return tab页面元数据
     */
    protected PageVO getTabPageVO(PageVO objLstPageVO) {
        // 获取模块下的所有页面
        List<PageVO> lstPageVO = this.getPagesByModelId(objLstPageVO.getModelPackageId());
        // 按页面类型分类模块下的页面
        Map<String, Object> objMap = getModulePageClassify(lstPageVO);
        // 获取tab页面集合
        List<PageVO> lstPageVOTab = (List<PageVO>) objMap.get(PageUITypeEnum.FRAME_PAGE.getPageUIType());
        if (lstPageVOTab != null) {
            for (PageVO objPageVO : lstPageVOTab) {
                // 获取页面的Tab控件
                LayoutVO objLayoutVO = this.getLayoutVOByType(objPageVO, "Tab").get(0);
                String objTabs = (String) objLayoutVO.getOptions().get("tabs");
                Pattern pattern = Pattern.compile("\"url\":([\\w]+)");
                Matcher matcher = pattern.matcher(objTabs);
                // 根据url获取页面元数据ID
                while (matcher.find()) {
                    String strUrl = matcher.group(1);
                    PageVO objListPageVO = this.getPageVOByConstantName(objPageVO, strUrl);
                    if (objListPageVO != null && objListPageVO.getModelId().equals(objLstPageVO.getModelId())) {
                        return objPageVO;
                    }
                }
            }
        }
        return null;
    }
}
