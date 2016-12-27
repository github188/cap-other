/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.workbenchconfig.utils;

/**
 * 工作台配置mybatis的id常量
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年2月26日 许畅 新建
 */
public class WorkbenchConfigConstants {

	/**
	 * 私有化构造方法
	 */
	private WorkbenchConfigConstants() {

	}

	/**
	 * 工作台配置调用存储过程id
	 */
	public static final String CALL_WORKBENCH_CONFIG_ID = "com.comtop.cap.bm.metadata.workbenchconfig.callProCapWbProcesscfg";

	/**
	 * 查询配置数量id
	 */
	public static final String QUERY_COUNT_ID = "com.comtop.cap.bm.metadata.workbenchconfig.queryWorkbenchConfigCount";

	/**
	 * 查询具体信息id
	 */
	public static final String QUERY_LIST_ID = "com.comtop.cap.bm.metadata.workbenchconfig.queryWorkbenchConfigList";

	/**
	 * 删除配置信息id
	 */
	public static final String DELETE_ID = "com.comtop.cap.bm.metadata.workbenchconfig.deleteWorkbenchConfig";
}
