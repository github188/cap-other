/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.consistency.entity;

import com.comtop.cap.bm.metadata.consistency.entity.validate.EntityBeingDependOnValidater;

/**
 * 实体被依赖校验工厂类
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年7月1日 许畅 新建
 */
public class EntityBeingDependOnFactory {

	/**
	 * 私有化构造方法
	 */
	private EntityBeingDependOnFactory() {

	}

	/**
	 * 获取实体被依赖校验器
	 * 
	 * @return 实体被依赖校验器
	 */
	@SuppressWarnings("rawtypes")
	public static IBeingDependOnValidate getBeingDependOnValidater() {
		// 默认需要开关
		return EntityBeingDependOnValidater.getInstance();
	}

	/**
	 * 实体依赖校验无需开关控制直接校验
	 * 
	 * @return 直接校验
	 */
	@SuppressWarnings("rawtypes")
	public static IBeingDependOnValidate getNoSwtichValidater() {

		return EntityBeingDependOnValidater.getNoSwitchInstance();
	}

}
