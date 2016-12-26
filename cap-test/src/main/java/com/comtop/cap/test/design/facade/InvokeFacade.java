/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.design.facade;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.runtime.base.util.BeanContextUtil;
import com.comtop.cap.test.definition.facade.PracticeFacade;
import com.comtop.cap.test.definition.facade.StepFacade;
import com.comtop.cap.test.definition.model.DynamicStep;
import com.comtop.cap.test.definition.model.Practice;
import com.comtop.cap.test.definition.scan.DynamicStepScanner;
import com.comtop.cap.test.design.model.InvokeData;
import com.comtop.cap.test.design.model.TestCase;
import com.comtop.cap.test.design.practice.PracticeImpl;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import comtop.org.directwebremoting.annotations.DwrProxy;
import comtop.org.directwebremoting.annotations.RemoteMethod;

/**
 * 动态步骤、最佳实践调用接口
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年7月11日 lizhongwen
 */
@PetiteBean
@DwrProxy
public class InvokeFacade {
    
    /** 日志 */
    private final static Logger logger = LoggerFactory.getLogger(InvokeFacade.class);
    
    /** 步骤接口 */
    @PetiteInject
    private StepFacade stepFacade;
    
    /** 最佳实践接口 */
    @PetiteInject
    private PracticeFacade practiceFacade;
    
    /**
     * 执行动态步骤调用接口
     * 
     * @param data 执行数据
     * @return 动态步骤
     */
    @RemoteMethod
    public DynamicStep invoke(InvokeData data) {
        String modelId = data.getModelId();
        if (StringUtils.isBlank(modelId)) {
            logger.error("请求参数错误，缺少动态步骤元数据的ModelId。");
            return null;
        }
        DynamicStep ds = (DynamicStep) stepFacade.loadStepDefinitionById(modelId);
        if (ds == null) {
            logger.error("请求参数错误，找不大定义的动态步骤。");
            return null;
        }
        String clazz = ds.getScan();
        if (StringUtils.isBlank(clazz)) {
            logger.error("动态步骤配置错误，缺少动态步骤扫描类的配置。");
            return null;
        }
        Class<?> impl = null;
        try {
            impl = Class.forName(clazz);
        } catch (ClassNotFoundException e) {
            logger.error("找不到动态步骤扫描类【{}】。", clazz, e);
            return null;
        }
        if (!DynamicStepScanner.class.isAssignableFrom(impl)) {
            logger.error("没有实现动态步骤扫描类接口。", clazz);
            return null;
        }
        DynamicStepScanner scanner = (DynamicStepScanner) BeanContextUtil.getBean(impl);
        if (scanner == null) {
            logger.error("找不到动态步骤扫描类【{}】的实例。", clazz);
            return null;
        }
        DynamicStep ret = null;
        try {
            ret = scanner.scan(data.getModelId(), data.getDatas());
        } catch (Exception e) {
            logger.error("扫描方法执行出错。", e);
        }
        return ret;
    }
    
    /**
     * 最佳实践实现
     *
     * @param data 数据
     * @return 测试用例
     */
    @RemoteMethod
    public TestCase practiceImpl(InvokeData data) {
        String modelId = data.getModelId();
        if (StringUtils.isBlank(modelId)) {
            logger.error("请求参数错误，缺少最佳实践元数据的ModelId。");
            return null;
        }
        Practice practice = practiceFacade.loadPracticeById(modelId);
        if (practice == null) {
            logger.error("请求参数错误，找不大定义的最佳实践。");
            return null;
        }
        String clazz = practice.getImpl();
        if (StringUtils.isBlank(clazz)) {
            logger.error("最佳实践配置错误，缺少最佳实践实现类。");
            return null;
        }
        Class<?> implClass = null;
        try {
            implClass = Class.forName(clazz);
        } catch (ClassNotFoundException e) {
            logger.error("找不到最佳实践实现类【{}】。", clazz, e);
            return null;
        }
        if (!PracticeImpl.class.isAssignableFrom(implClass)) {
            logger.error("没有实现最贱实践实现类接口。", clazz);
            return null;
        }
        PracticeImpl impl = (PracticeImpl) BeanContextUtil.getBean(implClass);
        if (impl == null) {
            logger.error("找不到最佳实践实现类【{}】的实例。", clazz);
            return null;
        }
        TestCase ret = null;
        try {
            ret = impl.impl(data.getModelId(), data.getTestcase(), data.getDatas());
        } catch (Exception e) {
            logger.error("最佳实践实现方法执行出错。", e);
        }
        return ret;
    }
    
}
