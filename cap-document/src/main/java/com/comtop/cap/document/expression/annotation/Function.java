/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.annotation;

import static java.lang.annotation.RetentionPolicy.RUNTIME;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.Target;

/**
 * 函数注解
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月18日 lizhongwen
 */
@Target({ ElementType.METHOD })
@Retention(RUNTIME)
public @interface Function {
    
    /**
     * 函数对象名称
     *
     * @return 名称
     */
    String name();
    
    /**
     * 描述函数对象的详细作用
     *
     * @return 文档对象描述
     */
    String description() default "";
}
