/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.entity.util;

import com.comtop.top.core.jodd.AppCore;
import com.comtop.top.sys.module.facade.IModuleFacade;

/**
 * 代码生成工具类
 * 
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-5-4 李忠文
 */
public final class GenerateUtils {

	/** 模块服务 */
	public static IModuleFacade moduleFacade;

	static {
		AppCore objAppCore = AppCore.getInstance();
		if (!objAppCore.isStarted()) {
			objAppCore.startJoddNoDB();
			objAppCore.startJoddDB();
		}
	}

	/**
	 * 构造函数
	 */
	private GenerateUtils() {
		super();
	}

}
