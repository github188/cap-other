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

/**
 * 用于表示元数据一致性校验的属性
 *
 * @author 罗珍明
 * @version jdk1.6
 * @version 2016-6-23 罗珍明
 */
@Retention(RetentionPolicy.RUNTIME)
@Target({ java.lang.annotation.ElementType.FIELD })
public @interface ConsistencyDependOnField {

	/**
	 * 
	 * @return 校验范围，配合expression使用。整个元数据范围，或当前元数据对象方位
	 */
	String checkScope() default CHECK_SCOPE_CURRENT_OBJECT;

	/**
	 * 
	 * @return 检验的类名
	 */
	String checkClass() default "";

	/**
	 * 
	 * @return 属性校验表达式
	 */
	String expression() default "";

	/***/
	public static String CHECK_SCOPE_GLOBAL = "globalCache";

	/***/
	public static String CHECK_SCOPE_CURRENT_OBJECT = "currentObject";

}