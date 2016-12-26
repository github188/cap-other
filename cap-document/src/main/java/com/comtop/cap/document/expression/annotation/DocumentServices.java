/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.annotation;

import static java.lang.annotation.ElementType.TYPE;
import static java.lang.annotation.RetentionPolicy.RUNTIME;

import java.lang.annotation.Retention;
import java.lang.annotation.Target;

/**
 * 文档服务集合
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月9日 lizhongwen
 */
@Target({ TYPE })
@Retention(RUNTIME)
public @interface DocumentServices {
    
    /**
     * 文档服务
     *
     * @return 名称
     */
    DocumentService[] value();
    
}
