/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.design.practice.function.form;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.common.storage.exception.OperateException;
import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;
import com.comtop.cap.bm.metadata.page.external.PageMetadataProvider;
import com.comtop.cap.test.definition.facade.PracticeFacade;
import com.comtop.cap.test.definition.model.Practice;
import com.comtop.cap.test.design.facade.TestCaseFacade;
import com.comtop.cap.test.design.model.TestCase;
import com.comtop.cap.test.design.model.TestCaseType;
import com.comtop.cap.test.design.practice.PracticeImpl;
import com.comtop.cap.test.design.practice.function.FunctionTestcaseGenerater;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;

/**
 * 表单行为最佳实践
 *
 * @author zhangzunzhi
 * @since jdk1.6
 * @version 2016年7月12日 zhangzunzhi
 */
@PetiteBean
public class FormFunctionTestPracticeImpl implements PracticeImpl {
    
    /** 日志 */
    private final static Logger logger = LoggerFactory.getLogger(FormFunctionTestPracticeImpl.class);
    
    /** 最佳实践Facade */
    @PetiteInject
    protected PracticeFacade practiceFacade;
    
    /** 最佳实践Facade */
    @PetiteInject
    protected FormInsertTestcaseGenerater formInsertTestcaseGenerater;
    
    /** 最佳实践Facade */
    @PetiteInject
    protected FormUpdateTestcaseGenerater formUpdateTestcaseGenerater;
    
    /** 最佳实践Facade */
    @PetiteInject
    protected FormDeleteTestcaseGenerater formDeleteTestcaseGenerater;
    
    /** 最佳实践Facade */
    @PetiteInject
    protected FormQueryTestcaseGenerater formQueryTestcaseGenerater;
    
    /** TestCaseFacade */
    @PetiteInject
    protected TestCaseFacade testCaseFacade;
    
    /** 行为类型 */
    private static final Map<String, String> actionTypedMap = new HashMap<String, String>();
    
    /** 页面元数据提供的相关接口Facade */
    @PetiteInject
    protected PageMetadataProvider pageMetadataProvider;
    
    static {
        actionTypedMap.put("insert", "新增");
        actionTypedMap.put("save", "更新");
        actionTypedMap.put("delete", "删除");
        actionTypedMap.put("query", "查询");
    }
    
    /**
     * 
     * @see com.comtop.cap.test.design.practice.PracticeImpl#impl(java.lang.String,
     *      com.comtop.cap.test.design.model.TestCase, java.util.Map)
     */
    @Override
    public TestCase impl(String practiceId, TestCase testcase, Map<String, String> args) {
        Practice practice = practiceFacade.loadPracticeById(practiceId);
        if (practice == null) {
            return null;
        }
        String strMapping = practice.getMapping();// 确定是新增，更新，还是删除
        // 行为选择时候，传递三个参数，一个modelId页面元数据ID，一个页面actionId，一个为行为类型,结构为modelId:actionId:actionType
        String strActionId = args.get("pageActionId");
        String[] strActionIds = strActionId.split(":");
        if (!strMapping.equals(strActionIds[2])) {
            return null;
        }
        // 列表页面元数据对象,新增，更新，删除的行为类型都定义在此页面
        PageVO objListPageVO = null;
        try {
            objListPageVO = pageMetadataProvider.getPageByModelId(strActionIds[0]);
        } catch (OperateException exception) {
            logger.error("根据页面元数据ID获取页面元数据出错", exception);
        }
        if (objListPageVO == null) {
            return null;
        }
        
        TestCase objTestCase = testcase;
        if (objTestCase == null) {
            objTestCase = new TestCase();
            objTestCase.setName(actionTypedMap.get(strMapping) + "_" + objListPageVO.getCname());
            objTestCase.setModelPackage(objListPageVO.getModelPackage());
            objTestCase.setModelName(strMapping.substring(0, 1).toUpperCase() + strMapping.substring(1) + "_"
                + objListPageVO.getModelName());
            objTestCase.setMetadata(strActionId);
            objTestCase.setPractice(practiceId);
            objTestCase.setType(TestCaseType.FUNCTION);// 根据实践类型填充
        }
        String strModelId = objTestCase.getModelId();
        TestCase objExitTestCase = testCaseFacade.loadTestCaseById(strModelId);
        if (objExitTestCase != null) {
            return null;
        }
        FunctionTestcaseGenerater generater = this.getGenerater(strMapping);
        if (generater != null) {
            generater.genTestcase(practice, objTestCase, objListPageVO, "");
        }
        
        return objTestCase;
    }
    
    /**
     * 获取用例生成器
     *
     * @param strActionType 行为类型
     * @return 用例生成器
     */
    private FunctionTestcaseGenerater getGenerater(String strActionType) {
        if ("insert".equals(strActionType)) {
            return formInsertTestcaseGenerater;
        } else if ("save".equals(strActionType)) {
            return formUpdateTestcaseGenerater;
        } else if ("delete".equals(strActionType)) {
            return formDeleteTestcaseGenerater;
        } else if ("query".equals(strActionType)) {
            return formQueryTestcaseGenerater;
        }
        return null;
    }
    
}
