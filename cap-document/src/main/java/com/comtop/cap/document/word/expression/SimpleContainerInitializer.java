/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.expression;

/**
 * 简单的容器初始化
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月18日 lizhongwen
 */
public class SimpleContainerInitializer implements ContainerInitializer {
    
    /**
     * 初始化
     * 
     * @param register 容器注册接口
     * @see com.comtop.cap.document.word.expression.ContainerInitializer#init(com.comtop.cap.document.word.expression.IDocumentRegister)
     */
    @Override
    public void init(IDocumentRegister register) {
        // 初始化结束
        register.registed();
    }
    
}
