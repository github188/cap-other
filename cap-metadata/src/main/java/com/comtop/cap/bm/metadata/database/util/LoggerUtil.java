/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.database.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cip.json.JSON;

/**
 * 日志输出工具类
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年12月13日 许畅 新建
 */
public final class LoggerUtil {

	/**
	 * 构造方法
	 */
	private LoggerUtil() {
		super();
	}

	/** logger日志 */
	private static final Logger LOGGER = LoggerFactory
			.getLogger(LoggerUtil.class);

	/**
	 * 输出JSON对象便于调试
	 * 
	 * @param obj
	 *            对象
	 */
	public static void outputObj(Object obj) {
		LOGGER.info("output:\n" + JSON.toJSONString(obj));
	}

}
