/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.design.practice.function.button;

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
 * 页面按钮行为最佳实践
 *
 * @author zhangzunzhi
 * @since jdk1.6
 * @version 2016年8月2日 zhangzunzhi
 */
@PetiteBean
public class PageButtonPracticeImpl implements PracticeImpl {
    
    /** 日志 */
    private final static Logger logger = LoggerFactory.getLogger(PageButtonPracticeImpl.class);
    
    /** 最佳实践Facade */
    @PetiteInject
    protected PracticeFacade practiceFacade;
    
    /** TestCaseFacade */
    @PetiteInject
    protected TestCaseFacade testCaseFacade;
    
    /** 最佳实践Facade */
    @PetiteInject
    protected ListPageButtonTestcaseGenerater listPageButtonTestcaseGenerater;
    
    /** 最佳实践Facade */
    @PetiteInject
    protected EditPageButtonTestcaseGenerater editPageButtonTestcaseGenerater;
    
    /** 页面元数据提供的相关接口Facade */
    @PetiteInject
    protected PageMetadataProvider pageMetadataProvider;
    
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
        String strMapping = practice.getMapping();
        String strActionId = args.get("pageActionId");
        String[] strActionIds = strActionId.split(":");
        if (!strMapping.equals(strActionIds[2]) && strActionIds.length < 2) {
            return null;
        }
        String strButtonCname = args.get("buttonCname");
        String strButtonEname = args.get("buttonEname");
        String strLayoutId = args.get("layoutId");
        
        // 列表页面元数据对象,新增，更新，删除的行为类型都定义在此页面
        PageVO objPageVO = null;
        try {
            objPageVO = pageMetadataProvider.getPageByModelId(strActionIds[0]);
        } catch (OperateException exception) {
            logger.error("根据页面元数据ID获取页面元数据出错", exception);
        }
        if (objPageVO == null) {
            return null;
        }
        
        TestCase objTestCase = testcase;
        if (objTestCase == null) {
            objTestCase = new TestCase();
            objTestCase.setName(strButtonCname + "_" + objPageVO.getCname());
            objTestCase.setModelPackage(objPageVO.getModelPackage());
            objTestCase.setModelName(strButtonEname.substring(0, 1).toUpperCase() + strButtonEname.substring(1) + "_"
                + objPageVO.getModelName());
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
            generater.genTestcase(practice, objTestCase, objPageVO, strLayoutId);
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
        if ("listPageButton".equals(strActionType)) {
            return listPageButtonTestcaseGenerater;
        } else if ("editPageButton".equals(strActionType)) {
            return editPageButtonTestcaseGenerater;
        }
        return null;
    }
    
}
