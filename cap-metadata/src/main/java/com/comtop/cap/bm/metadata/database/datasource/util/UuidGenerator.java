/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.database.datasource.util;

import java.util.UUID;

/**
 * UUID生成器
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年11月2日 许畅 新建
 */
public final class UuidGenerator {

	/**
	 * 构造方法
	 */
	private UuidGenerator() {

	}

	/**
	 * 生成大写UUID
	 * 
	 * @return UUID
	 */
	public static String generateUpperUUID() {
		return UUID.randomUUID().toString().replaceAll("-", "").toUpperCase();
	}

	/**
	 * 生成随机UUID
	 * 
	 * @return UUID
	 */
	public static String generateUUID() {
		return UUID.randomUUID().toString().replaceAll("-", "");
	}
}
