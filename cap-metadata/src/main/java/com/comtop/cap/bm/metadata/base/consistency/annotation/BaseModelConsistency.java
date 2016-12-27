/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.base.consistency.annotation;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import com.comtop.cap.bm.metadata.base.consistency.DefaultConsistencyCheck;
import com.comtop.cap.bm.metadata.base.consistency.IConsistencyCheck;

/**
 * 用于表示元数据一致性校验的指定实现类
 *
 * @author 罗珍明
 * @version jdk1.6
 * @version 2016-6-21 罗珍明 新建
 */
@Retention(RetentionPolicy.RUNTIME)
@Target({ java.lang.annotation.ElementType.TYPE })
public @interface BaseModelConsistency {

	/**
	 * @return 检验的类名
	 */
	Class<? extends IConsistencyCheck> checkClass() default DefaultConsistencyCheck.class;

}