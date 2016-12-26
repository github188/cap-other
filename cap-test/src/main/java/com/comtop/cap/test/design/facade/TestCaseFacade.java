/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.design.facade;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.base.model.BaseModel;
import com.comtop.cap.bm.metadata.common.storage.CacheOperator;
import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.common.storage.exception.ValidateException;
import com.comtop.cap.bm.metadata.entity.facade.EntityFacade;
import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.bm.metadata.page.desinger.facade.PageFacade;
import com.comtop.cap.bm.metadata.page.desinger.model.PageActionVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.page.external.PageMetadataProvider;
import com.comtop.cap.bm.metadata.serve.facade.ServiceObjectFacade;
import com.comtop.cap.bm.metadata.serve.model.ServiceObjectVO;
import com.comtop.cap.runtime.base.util.BeanContextUtil;
import com.comtop.cap.test.definition.model.StepDefinition;
import com.comtop.cap.test.definition.model.StepReference;
import com.comtop.cap.test.design.generate.ScriptGenerator;
import com.comtop.cap.test.design.generate.TestcaseGeneratorContext;
import com.comtop.cap.test.design.model.InvokeData;
import com.comtop.cap.test.design.model.Step;
import com.comtop.cap.test.design.model.TestCase;
import com.comtop.cap.test.design.model.TestCaseType;
import com.comtop.cap.test.design.model.Version;
import com.comtop.cap.test.preference.facade.TestServerConfigFacade;
import com.comtop.cap.test.preference.facade.TestmodelDicItemFacade;
import com.comtop.cap.test.preference.model.TestModelDicConstant;
import com.comtop.cap.test.preference.model.TestmodelDicItemVO;
import com.comtop.cap.test.robot.facade.TestResultAnalyseFacade;
import com.comtop.cap.test.robot.model.Statistics;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.corm.resource.util.CollectionUtils;
import com.comtop.top.core.util.constant.NumberConstant;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 测试用例Facade
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年6月24日 lizhongwen
 */
@DwrProxy
@PetiteBean
public class TestCaseFacade {
    
    /** 日志 */
    private final static Logger logger = LoggerFactory.getLogger(TestCaseFacade.class);
    
    /** 版本管理接口 */
    @PetiteInject
    protected VersionFacade versionFacade;
    
    /** 脚本代码生成器 */
    protected ScriptGenerator generator = BeanContextUtil.getBean(ScriptGenerator.class);
    
    /** 测试服务器接口 */
    @PetiteInject
    protected TestServerConfigFacade testServerConfigFacade;
    
    /** 测试建模字典项的配置接口 */
    @PetiteInject
    protected TestmodelDicItemFacade testmodelDicItemFacade;
    
    /** 测试结果接口 */
    @PetiteInject
    protected TestResultAnalyseFacade testResultAnalyseFacade;
    
    /** 实体接口 */
    @PetiteInject
    protected EntityFacade entityFacade;
    
    /** PageMetadataProvider */
    @PetiteInject
    protected PageMetadataProvider pageMetadataProvider;
    
    /** 页面元数据接口 */
    @PetiteInject
    protected PageFacade pageFacade;
    
    /** 服务对象接口 */
    @PetiteInject
    protected ServiceObjectFacade serviceObjectFacade;
    
    /** 实现类接口 */
    @PetiteInject
    protected InvokeFacade invokeFacade;
    
    /** 用例生成器上下文 */
    protected TestcaseGeneratorContext context = BeanContextUtil.getBean(TestcaseGeneratorContext.class);
    
    /**
     * 根据Id获取测试用例
     *
     * @param id id
     * @return 基本步骤
     */
    @RemoteMethod
    public TestCase loadTestCaseById(String id) {
        TestCase ret = null;
        if (StringUtils.isNotBlank(id)) {
            ret = (TestCase) CacheOperator.readById(id);
            if (ret != null) {
                this.updateTestCaseSteps(ret);
            }
        }
        return ret;
    }
    
    /**
     * 根据Id获取测试用例
     *
     * @param id id
     * @return 基本步骤
     */
    @RemoteMethod
    public TestCase loadTestCaseAndSetMetadataById(String id) {
        TestCase ret = null;
        if (StringUtils.isNotBlank(id)) {
            ret = (TestCase) CacheOperator.readById(id);
            if (ret != null) {
                this.updateTestCaseSteps(ret);
                this.setShowMeatadata(ret);
            }
        }
        return ret;
    }
    
    /**
     * 设值显示的元数据值
     *
     * @param ret 测试用例
     */
    private void setShowMeatadata(TestCase ret) {
        if (StringUtils.isBlank(ret.getMetadata())) {
            return;
        }
        String strMetadata = ret.getMetadata();
        ret.setShowMetadata(strMetadata);
        if (TestCaseType.FUNCTION.equals(ret.getType())) { // 界面行为
            // pagemodelid:actionid:actiontype
            String[] pageMetadata = strMetadata.split(":");
            String strPageModelId = pageMetadata[0];
            PageVO objPageVO;
            try {
                objPageVO = pageMetadataProvider.getPageByModelId(strPageModelId);
                List<PageActionVO> lstPageAction = objPageVO.getPageActionVOList();
                for (PageActionVO pageActionVO : lstPageAction) {
                    if (pageActionVO.getPageActionId().equals(pageMetadata[1])) {
                        ret.setShowMetadata(pageActionVO.getActionDefineVO().getModelId());
                    }
                }
            } catch (OperateException e) {
                e.printStackTrace();
            }
            
        } else if (TestCaseType.API.equals(ret.getType())) { // 实体方法
            // entityId.methodName
            String[] pageMetadata = strMetadata.split(":");
            // int index = strMetadata.lastIndexOf('.');
            // String methodName = strMetadata.substring(index + 1);
            ret.setShowMetadata(pageMetadata[1]);
        }
    }
    
    /**
     * 更新测试用例中的步骤
     * 
     * @param tc 测试用例
     */
    private void updateTestCaseSteps(TestCase tc) {
        List<Step> steps = tc.getSteps();
        if (steps == null || steps.isEmpty()) {
            return;
        }
        for (Step step : steps) {
            if (step == null) {
                continue;
            }
            StepReference reference = step.getReference();
            String type = reference.getType();
            StepDefinition definition = (StepDefinition) CacheOperator.readById(type);
            if (definition == null) {
                continue;
            }
            step.setName(definition.getName());
            reference.setIcon(definition.getIcon());
            reference.setName(definition.getName());
            if (reference.getSteps() == null || reference.getSteps().isEmpty()) {
                continue;
            }
            for (StepReference ref : reference.getSteps()) {
                if (ref == null) {
                    continue;
                }
                StepDefinition def = (StepDefinition) CacheOperator.readById(ref.getType());
                if (def == null) {
                    continue;
                }
                ref.setIcon(def.getIcon());
                ref.setName(def.getName());
            }
        }
    }
    
    /**
     * 保存测试用例
     *
     * @param testCase 用例
     * @return 是否保存成功
     * @throws ValidateException 验证异常
     */
    @RemoteMethod
    public boolean saveTestCase(TestCase testCase) throws ValidateException {
        if (StringUtils.isEmpty(testCase.getSortNo())) {// 如果编号为空，则生成编号，用于用例更新的情况
            try {
                List<TestCase> lstTestCases = CacheOperator.queryList(testCase.getModelPackage() + "/testcase",
                    TestCase.class);
                String strPattern = "000";
                java.text.DecimalFormat objDFormat = new java.text.DecimalFormat(strPattern);
                int iCount = 0;
                if (lstTestCases != null && lstTestCases.size() > 0) {
                    for (TestCase objTestCase : lstTestCases) {
                        int iSortNo = Integer.parseInt(objTestCase.getSortNo());
                        if (iSortNo > iCount) {
                            iCount = iSortNo;
                        }
                    }
                }
                testCase.setSortNo(objDFormat.format(iCount + 1));
            } catch (OperateException e) {
                logger.error("获取模块下的测试用例失败", e);
            }
        }
        
        boolean ret = testCase.saveModel();
        if (StringUtils.isNotBlank(testCase.getPractice()) && CollectionUtils.isEmpty(testCase.getSteps())) {
            InvokeData objInvokeData = new InvokeData();
            objInvokeData.setModelId(testCase.getPractice());
            objInvokeData.setTestcase(testCase);
            Map<String, String> objArgMap = new HashMap<String, String>();
            if (TestCaseType.FUNCTION.equals(testCase.getType())) {// 界面行为
                // objArgMap.put("pageActionId", "modelid:actionid:actiontype");
                objArgMap.put("pageActionId", testCase.getMetadata());
            } else if (TestCaseType.API.equals(testCase.getType())) {// 后台API
                // objArgMap.put("metadata", "entityId.methodName");
                objArgMap.put("metadata", testCase.getMetadata());
            }
            objInvokeData.setDatas(objArgMap);
            invokeFacade.practiceImpl(objInvokeData);
        }
        // 更新版本信息
        versionFacade.updateVersion(testCase.getModelId(), testCase.getScriptName());
        return ret;
    }
    
    /**
     * 查询测试用例列表
     * 
     * @param funcFullPath 应用/包全路径
     * @return 测试用例列表
     * @throws OperateException 异常
     */
    @RemoteMethod
    public List<TestCase> queryTestCaseList(String funcFullPath) throws OperateException {
        List<TestCase> lstTestCases = CacheOperator.queryList(funcFullPath + "/testcase", TestCase.class);
        if (lstTestCases == null) {
            lstTestCases = new ArrayList<TestCase>();
        }
        return lstTestCases;
    }
    
    /**
     * 根据条件查询测试用例
     *
     * <pre>
     * 
     * </pre>
     * 
     * @param funcFullPath 应用/包全路径
     * @param strCaseType 测试类型
     * @param strKeyword 搜索关键字
     * @param pageNo pageNo
     * @param pageSize pageSize
     * @return 测试用例列表
     * @throws OperateException 异常
     */
    @RemoteMethod
    public Map<String, Object> queryTestCaseList(String funcFullPath, String strCaseType, String strKeyword,
        int pageNo, int pageSize) throws OperateException {
        Map<String, Object> objRet = new HashMap<String, Object>();
        String strQueryExpression;
        if (StringUtils.isNotEmpty(strCaseType) && StringUtils.isNotEmpty(strKeyword)) {
            strQueryExpression = funcFullPath + "/testcase[type='" + strCaseType + "' and contains(name,'" + strKeyword
                + "')]";
        } else if (StringUtils.isEmpty(strCaseType) && StringUtils.isNotEmpty(strKeyword)) {
            strQueryExpression = funcFullPath + "/testcase[contains(name,'" + strKeyword + "')]";
        } else if (StringUtils.isNotEmpty(strCaseType) && StringUtils.isEmpty(strKeyword)) {
            strQueryExpression = funcFullPath + "/testcase[type='" + strCaseType + "']";
        } else {
            strQueryExpression = funcFullPath + "/testcase";
        }
        // 总数
        List<TestCase> lstTestCaseSize = CacheOperator.queryList(strQueryExpression, TestCase.class);
        // 分页数据
        List<TestCase> lstTestCases = CacheOperator.queryList(strQueryExpression, TestCase.class, pageNo, pageSize);
        objRet.put("list", lstTestCases);
        objRet.put("size", lstTestCaseSize.size());
        return objRet;
    }
    
    /**
     * 根据条件查询测试用例
     *
     * <pre>
     * 
     * </pre>
     * 
     * @param funcFullPath 应用/包全路径
     * @param packageId 系统应用的模块ID
     * @param objTestCase 测试用例对象
     * @return 测试用例列表
     * @throws OperateException 异常
     */
    @RemoteMethod
    public Map<String, Object> queryTestCaseList(String funcFullPath, String packageId, TestCase objTestCase)
        throws OperateException {
        Map<String, Object> objRet = new HashMap<String, Object>();
        String strCaseType = objTestCase.getType().toString();
        String strName = objTestCase.getName();
        String strQueryExpression;
        if (StringUtils.isEmpty(strName)) {
            strQueryExpression = funcFullPath + "/testcase[type='" + strCaseType + "']";
        } else {
            strQueryExpression = funcFullPath + "/testcase[type='" + strCaseType + "' and contains(name,'" + strName
                + "') or contains(metadata,'" + strName + "')]";
        }
        // 总数
        List<TestCase> lstTestCaseSize = CacheOperator.queryList(strQueryExpression, TestCase.class);
        // 分页数据
        List<TestCase> lstTestCases = CacheOperator.queryList(strQueryExpression, TestCase.class,
            objTestCase.getPageNo(), objTestCase.getPageSize());
        // 如果没有测试用例，获取元数据返回
        if (lstTestCases.size() == 0) {
            objRet = queryMetadata(packageId, strCaseType, objTestCase.getPageNo(), objTestCase.getPageSize());
            return objRet;
        }
        // 组装查询的分页数据
        List<TestCase> lstRetTestCase = mergeTestCases(lstTestCases);
        // 设置测试结果
        setTestResult(lstRetTestCase, packageId);
        objRet.put("list", lstRetTestCase);
        objRet.put("size", lstTestCaseSize.size());
        return objRet;
    }
    
    /**
     * 根据模块ID获取元数据集合
     * 
     * @param packageId 系统应用的模块ID
     * @param strCaseType 用例类型
     * @param pageNo pageNo
     * @param pageSize pageSize
     * @return 元数据集合
     * @throws OperateException 异常
     */
    private Map<String, Object> queryMetadata(String packageId, String strCaseType, int pageNo, int pageSize)
        throws OperateException {
        Map<String, Object> objRet = new HashMap<String, Object>();
        if (strCaseType.equals(TestCaseType.FUNCTION.toString())) {// 如果为业务功能，获取页面元数据
            List<PageVO> lstPageSize = pageFacade.queryPageList(packageId);
            List<PageVO> lstPageVO = pageFacade.queryPageList(packageId, pageNo, pageSize);
            List<TestCase> lstTestCase = converMetadataToTestCase(lstPageVO);
            objRet.put("list", lstTestCase);
            objRet.put("size", lstPageSize.size());
        } else if (strCaseType.equals(TestCaseType.API.toString())) {// 如果为后台API,获取实体元数据
            List<EntityVO> lstEntitySize = entityFacade.queryEntityList(packageId);
            List<EntityVO> lstEntityVO = entityFacade.queryEntityList(packageId, pageNo, pageSize);
            List<TestCase> lstTestCase = converMetadataToTestCase(lstEntityVO);
            objRet.put("list", lstTestCase);
            objRet.put("size", lstEntitySize.size());
        } else if (strCaseType.equals(TestCaseType.SERVICE.toString())) {// 如果为业务服务，获取服务元数据
            List<ServiceObjectVO> lstServiceObjectVOSize = serviceObjectFacade.queryServiceObjectList(packageId);
            List<ServiceObjectVO> lstServiceObjectVO = serviceObjectFacade.queryServiceObjectList(packageId, pageNo,
                pageSize);
            List<TestCase> lstTestCase = converMetadataToTestCase(lstServiceObjectVO);
            objRet.put("list", lstTestCase);
            objRet.put("size", lstServiceObjectVOSize.size());
        }
        
        return objRet;
    }
    
    /**
     * 服务VO转换为测试用例 VO
     * 
     * @param lstBaseModel 元数据集合
     * @return 测试用例对象集合
     */
    private List<TestCase> converMetadataToTestCase(List<? extends BaseModel> lstBaseModel) {
        List<TestCase> lstTestCase = new ArrayList<TestCase>();
        TestCase objTestCase;
        for (BaseModel objBaseModel : lstBaseModel) {
            objTestCase = new TestCase();
            objTestCase.setMetadata(objBaseModel.getModelId());
            objTestCase.setMetadataName(objBaseModel.getModelName());
            objTestCase.setModelPackage("");
            objTestCase.setModelType("");
            objTestCase.setModelName("");
            lstTestCase.add(objTestCase);
        }
        return lstTestCase;
    }
    
    /**
     * 组装分页数据，便于前台展示
     * 
     * @param lstTestCases 查询的测试用例集合
     * @return 前台展示用的测试用例集合
     */
    private List<TestCase> mergeTestCases(List<TestCase> lstTestCases) {
        // 把分页的数据根据元数据分组，便于前台展示
        Map<String, List<TestCase>> objGroupMap = new HashMap<String, List<TestCase>>();
        for (TestCase obj : lstTestCases) {
            String strMetadataName;
            if (StringUtils.isEmpty(obj.getMetadata())) {
                strMetadataName = "自定义";
            } else {
                String[] strName = obj.getMetadata().split(":");
                strMetadataName = strName[0].substring(strName[0].lastIndexOf(".") + 1, strName[0].length());
            }
            // 设置元数据名称
            obj.setMetadataName(strMetadataName);
            if (objGroupMap.containsKey(strMetadataName)) {
                List<TestCase> lstTmpTestCase = objGroupMap.get(strMetadataName);
                lstTmpTestCase.add(obj);
            } else {
                List<TestCase> lstTmpTestCase = new ArrayList<TestCase>();
                lstTmpTestCase.add(obj);
                objGroupMap.put(strMetadataName, lstTmpTestCase);
            }
        }
        
        // 把分组的数据组装为一个集合
        List<TestCase> lstRetTestCase = new ArrayList<TestCase>();
        for (String strKey : objGroupMap.keySet()) {
            lstRetTestCase.addAll(objGroupMap.get(strKey));
        }
        return lstRetTestCase;
    }
    
    /**
     * 设置测试结果
     * 
     * @param lstRetTestCase 测试用例集合
     * @param packageId 应用ID
     */
    private void setTestResult(List<TestCase> lstRetTestCase, String packageId) {
        if (lstRetTestCase.size() == 0) {
            return;
        }
        List<String> lstTestCaseName = new ArrayList<String>();
        for (TestCase objTestCase : lstRetTestCase) {
            lstTestCaseName.add(objTestCase.getName());
        }
        
        List<Statistics> lstStatistics = testResultAnalyseFacade.queryTestResultByTestCaseName(lstTestCaseName,
            packageId);
        for (TestCase objTestCase : lstRetTestCase) {
            boolean isNotExit = true;
            for (Statistics objStatistics : lstStatistics) {
                if (objTestCase.getName().equals(objStatistics.getTestcaseName())) {
                    isNotExit = false;
                    if (objStatistics.getPass()) {
                        objTestCase.setPass(NumberConstant.ONE);
                    } else {
                        objTestCase.setPass(NumberConstant.ZERO);
                    }
                }
            }
            if (isNotExit) {
                objTestCase.setPass(NumberConstant.TWO);
            }
        }
    }
    
    /**
     * 获取执行脚本的相关参数
     *
     * @return 执行脚本所需的服务器IP等参数
     */
    @RemoteMethod
    public Map<String, String> getExecuteTestParam() {
        Map<String, String> objMap = new HashMap<String, String>();
        Map<String, String> objServerMap = testServerConfigFacade.getServerConfig();
        objMap.putAll(objServerMap);
        TestmodelDicItemVO objUrl = testmodelDicItemFacade.readDicItemVOByCode(TestModelDicConstant.URL);
        objMap.put(TestModelDicConstant.URL, objUrl.getDictionaryValue());
        TestmodelDicItemVO objUserName = testmodelDicItemFacade.readDicItemVOByCode(TestModelDicConstant.USER_NAME);
        objMap.put(TestModelDicConstant.USER_NAME, objUserName.getDictionaryValue());
        TestmodelDicItemVO objPassWord = testmodelDicItemFacade.readDicItemVOByCode(TestModelDicConstant.PASSWORD);
        objMap.put(TestModelDicConstant.PASSWORD, objPassWord.getDictionaryValue());
        return objMap;
    }
    
    /**
     * 删除模型
     * 
     * @param models ID集合
     * @return 是否成功
     */
    @RemoteMethod
    public boolean delTestCases(String[] models) {
        boolean bResult = true;
        try {
            for (int i = 0; i < models.length; i++) {
                TestCase.deleteModel(models[i]);
            }
        } catch (Exception e) {
            bResult = false;
            logger.error("删除测试用例文件失败", e);
        }
        // 删除版本信息
        versionFacade.removeVersionByTestCases(models);
        return bResult;
    }
    
    /**
     * 查询该应用下是否存在相同的测试用例
     * 
     * @param funcFullPath 包路径
     * @param name 用例名称
     * @param modelId 模型ID
     * @return 是否存在（false： 不存在、true：存在）
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public boolean isExistSameNameTestCase(String funcFullPath, String name, String modelId) throws OperateException {
        boolean bResult = false;
        List<TestCase> lstTestCase = CacheOperator.queryList(funcFullPath + "/testcase", TestCase.class);
        for (TestCase objTestCase : lstTestCase) {
            String strName = objTestCase.getName();
            String strModelId = objTestCase.getModelId();
            if (strName.equals(name) && !strModelId.equals(modelId)) {
                bResult = true;
                break;
            }
        }
        return bResult;
    }
    
    /**
     * 查询该应用下是否存在相同的测试用例
     * 
     * @param funcFullPath 包路径
     * @param engName 用例英文名称
     * @param modelId 模型ID
     * @return 是否存在（false： 不存在、true：存在）
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public boolean isExistSameEngNameTestCase(String funcFullPath, String engName, String modelId)
        throws OperateException {
        boolean bResult = false;
        List<TestCase> lstTestCase = CacheOperator.queryList(funcFullPath + "/testcase", TestCase.class);
        for (TestCase objTestCase : lstTestCase) {
            String strEngName = objTestCase.getModelName();
            String strModelId = objTestCase.getModelId();
            if (strEngName.equals(engName) && !strModelId.equals(modelId)) {
                bResult = true;
                break;
            }
        }
        return bResult;
    }
    
    /**
     * 发送用例
     *
     * @param packageId 包路径
     * @return 是否发送成功
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public Map<String, Boolean> sendTestcases(String packageId) throws OperateException {
        Map<String, Boolean> ret = new HashMap<String, Boolean>();
        Map<String, Boolean> genRet = genScriptByPackage(packageId);
        ret.putAll(genRet);
        try {
            versionFacade.uploadScript(packageId);
            ret.put("uploadScript", Boolean.TRUE);
        } catch (Exception e) {
            logger.error("发送用例脚本失败。", e);
            ret.put("uploadScript", Boolean.FALSE);
        }
        return ret;
    }
    
    /**
     * 生成用例
     *
     * @param packageId 包路径
     * @return 生成用例
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public List<TestCase> genTestcase(String packageId) throws OperateException {
        List<BaseModel> lstBaseMetadata = new ArrayList<BaseModel>();
        List<EntityVO> lstEntityVO = entityFacade.queryEntityListByPkgName(packageId);
        lstBaseMetadata.addAll(lstEntityVO);
        List<PageVO> lstPageVO = pageFacade.queryList(packageId + "/page", PageVO.class);
        lstBaseMetadata.addAll(lstPageVO);
        return context.generate(lstBaseMetadata);
    }
    
    /**
     * 根据选定的元数据生成用例
     *
     * @param metadataIds 元数据集合
     * @return 生成用例
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public List<TestCase> genTestcaseByMetadata(String[] metadataIds) throws OperateException {
        if (metadataIds == null || metadataIds.length == 0) {
            return null;
        }
        List<BaseModel> lstBaseMetadata = new ArrayList<BaseModel>();
        BaseModel metadata;
        for (String id : metadataIds) {
            metadata = (BaseModel) CacheOperator.readById(id);
            lstBaseMetadata.add(metadata);
        }
        return context.generate(lstBaseMetadata);
    }
    
    /**
     * 生成用例脚本
     *
     * @param packageId 包路径
     * @return 结果
     * @throws OperateException 操作异常
     */
    @RemoteMethod
    public Map<String, Boolean> genScriptByPackage(String packageId) throws OperateException {
        Map<String, Boolean> ret = new HashMap<String, Boolean>();
        List<TestCase> lstTestCase = CacheOperator.queryList(packageId + "/testcase", TestCase.class);
        for (TestCase testCase : lstTestCase) {
            try {
                genTestcaseScript(testCase);
                ret.put(testCase.getModelId(), Boolean.TRUE);
            } catch (Exception e) {
                logger.error("{} 生成用例脚本失败。", testCase.getName(), e);
                ret.put(testCase.getModelId(), Boolean.FALSE);
            }
        }
        return ret;
    }
    
    /**
     * 生成用例脚本
     *
     * @param testcaseIds 测试用例Id集合
     * @return 生成脚本版本
     * @throws ValidateException 验证失败
     */
    @RemoteMethod
    public Map<String, Boolean> genScriptByTestcaseIds(String[] testcaseIds) throws ValidateException {
        Map<String, Boolean> ret = new HashMap<String, Boolean>();
        if (testcaseIds == null || testcaseIds.length == 0) {
            logger.error("生成用例脚本失败,没有选择任何用例。");
            ret.put("unselected", Boolean.FALSE);
            return ret;
        }
        for (String id : testcaseIds) {
            try {
                genTestcaseScript(id);
                ret.put(id, Boolean.TRUE);
            } catch (Exception e) {
                logger.error("{} 生成用例脚本失败。", id, e);
                ret.put(id, Boolean.FALSE);
            }
        }
        return ret;
    }
    
    /**
     * 预览用例脚本
     *
     * @param testcaseId 测试用例Id
     * @return 生成脚本版本
     * @throws ValidateException 验证失败
     */
    @RemoteMethod
    public String previewTestcaseScript(String testcaseId) throws ValidateException {
        Version version = this.genTestcaseScript(testcaseId);
        if (version == null) {
            return null;
        }
        return versionFacade.previewScript(version);
    }
    
    /**
     * 生成用例脚本
     *
     * @param testcaseId 测试用例Id
     * @return 生成脚本版本
     * @throws ValidateException 验证失败
     */
    private Version genTestcaseScript(String testcaseId) throws ValidateException {
        TestCase tc = this.loadTestCaseById(testcaseId);
        if (tc == null) {
            return null;
        }
        return this.genTestcaseScript(tc);
    }
    
    /**
     * 生成用例脚本
     *
     * @param testcase 测试用例
     * @return 生成脚本版本
     * @throws ValidateException 验证失败
     */
    private Version genTestcaseScript(TestCase testcase) throws ValidateException {
        Version version = versionFacade.loadVersion(testcase.getModelId());
        if (version == null) {
            version = versionFacade.updateVersion(testcase.getModelId(), testcase.getScriptName());
        }
        int testcaseVersion = version.getCaseVersion();
        int scriptVersion = version.getScriptVersion();
        if (testcaseVersion > scriptVersion) {
            generator.generate(testcase);
        }
        return version;
    }
    
    /**
     * 批量复制用例
     *
     * @param lstTestCases 被保存的对象
     * @return 保存成功记录数
     * @throws OperateException 操作异常
     * @throws ValidateException 校验异常
     */
    @RemoteMethod
    public int copyTestCaseList(List<TestCase> lstTestCases) throws OperateException, ValidateException {
        int iCount = 0;
        String strPattern = "000";
        java.text.DecimalFormat objDFormat = new java.text.DecimalFormat(strPattern);
        try {
            List<TestCase> lstExistTestCases = CacheOperator.queryList(lstTestCases.get(0).getModelPackage()
                + "/testcase", TestCase.class);
            if (lstExistTestCases != null && lstExistTestCases.size() > 0) {
                for (TestCase objTestCase : lstExistTestCases) {
                    int iSortNo = Integer.parseInt(objTestCase.getSortNo());
                    if (iSortNo > iCount) {
                        iCount = iSortNo;
                    }
                }
            }
        } catch (OperateException e) {
            logger.error("获取模块下的测试用例失败", e);
        }
        int iRS = 0;
        for (TestCase testCase : lstTestCases) {
            boolean bResult = false;
            iCount++;
            testCase.setSortNo(objDFormat.format(iCount));
            bResult = testCase.saveModel();
            if (bResult) {
                iRS++;
            }
        }
        return iRS;
    }
}
