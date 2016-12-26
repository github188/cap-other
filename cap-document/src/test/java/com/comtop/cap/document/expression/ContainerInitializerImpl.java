/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression;

import com.comtop.cap.document.util.CollectionUtils;
import com.comtop.cap.document.word.expression.ContainerInitializer;
import com.comtop.cap.document.word.expression.IDocumentRegister;

/**
 * 模拟容器初始化
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月25日 lizhongwen
 */
public class ContainerInitializerImpl implements ContainerInitializer {
    
    /**
     * 初始化
     * 
     * @param register 容器
     * @see com.comtop.cap.document.word.expression.ContainerInitializer#init(com.comtop.cap.document.word.expression.IDocumentRegister)
     */
    @Override
    public void init(final IDocumentRegister register) {
        register.registerFunction(CollectionUtils.class);
        register.registerService(new BizDataItemService());
        register.registerService(new BizObjectService());
        register.registerService(new TestService());
        register.registerService(new CourseService());
        register.registerService(new ExaminationService());
        register.registerService(new ContentSegService());
        register.registerService(new BranchService());
        register.registerService(new ListDataService());
        register.registerService(new VitaeService());
        register.registed();
    }
    
}
