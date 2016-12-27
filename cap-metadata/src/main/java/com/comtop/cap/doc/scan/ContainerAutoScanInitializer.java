/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.scan;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.document.expression.annotation.DocumentService;
import com.comtop.cap.document.expression.annotation.DocumentServices;
import com.comtop.cap.document.word.expression.ContainerInitializer;
import com.comtop.cap.document.word.expression.IDocumentRegister;
import com.comtop.cap.runtime.core.AppBeanUtil;

/**
 * CAP内容初始化助手
 * 
 * @author 李小强
 * @since 1.0
 * @version 2015-11-18 李小强
 */

public class ContainerAutoScanInitializer implements ContainerInitializer {
    
    /** 扫描DocObject表达式 */
    private final String[] scanServiceRegex;
    
    /** 扫描Function表达式 */
    private final String[] scanFuncRegex;
    
    /** 日志对象 */
    private static final Logger LOGGER = LoggerFactory.getLogger(ContainerAutoScanInitializer.class);
    
    /***
     * 构造器
     * 
     * @param scanServiceRegex 扫描文档对象表达式
     * @param scanFunctionRegex 扫描Function表达式
     */
    public ContainerAutoScanInitializer(String[] scanServiceRegex, String[] scanFunctionRegex) {
        super();
        this.scanServiceRegex = scanServiceRegex;
        this.scanFuncRegex = scanFunctionRegex;
    }
    
    /**
     * 初始化
     * 
     * @param register 容器
     */
    @Override
    public void init(IDocumentRegister register) {
        // 注册VO
        List<Class<?>> lstServiceClazz = ClassScanner.scanClass(scanServiceRegex);
        for (Class<?> objClazz : lstServiceClazz) {
            try {
                DocumentService objService = objClazz.getAnnotation(DocumentService.class);
                DocumentServices objServices = objClazz.getAnnotation(DocumentServices.class);
                if (objService == null && objServices == null) {
                    continue;
                }
                
                register.registerService(objClazz, AppBeanUtil.getBean(objClazz));
            } catch (Throwable e) {
                LOGGER.error("向容器注册对象：" + objClazz.getName() + "失败，原因：" + e.getMessage(), e);
            }
        }
        // Function
        List<Class<?>> lstFunClazz = ClassScanner.scanClass(scanFuncRegex);
        for (Class<?> objClass : lstFunClazz) {
            try {
                register.registerFunction(objClass);
            } catch (Throwable e) {
                LOGGER.error("向容器注册方法：" + objClass.getName() + "失败，原因：" + e.getMessage(), e);
            }
        }
        // 初始化结束
        register.registed();
    }
    
}
