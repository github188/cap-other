/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.service;

import static java.lang.annotation.ElementType.TYPE;
import static java.lang.annotation.RetentionPolicy.RUNTIME;

import java.lang.annotation.Retention;
import java.lang.annotation.Target;

import com.comtop.cap.document.word.docmodel.data.BaseDTO;

/**
 * 索引构建器注解
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2016年2月18日 lizhiyong
 */
@Target({ TYPE })
@Retention(RUNTIME)
public @interface IndexBuilder {
    
    /**
     * 文档对象名称
     *
     * @return 名称
     */
    String name() default "";
    
    /**
     * 描述文档对象的详细作用
     *
     * @return 文档对象描述
     */
    String description() default "";
    
    /**
     * 对象处理器
     *
     * @return 对象处理器类型
     */
    Class<? extends BaseDTO> dto();
}
