/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.soareg;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.database.dbobject.util.DBType;
import com.comtop.cap.bm.metadata.database.dbobject.util.DBTypeAdapter;

/**
 * 调用soa服务工厂类
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年5月19日 许畅 新建
 */
public class SoaServiceFactory {

	/** 日志记录器 */
	private static final Logger LOGGER = LoggerFactory
			.getLogger(SoaServiceFactory.class);

	/**
	 * 获取soa服务执行器
	 * 
	 * @param cls
	 *            soa服务执行器实现类
	 * @return 获取soa服务执行器
	 */
	@SuppressWarnings("rawtypes")
	public static ISoaServiceManager getSoaServiceExecutor(Class cls) {
		try {
			return (ISoaServiceManager) cls.newInstance();
		} catch (InstantiationException e) {
			LOGGER.error(e.getMessage(), e);
		} catch (IllegalAccessException e) {
			LOGGER.error(e.getMessage(), e);
		}
		return getSoaServiceExecutor();
	}

	/**
	 * 获取默认soa服务执行器
	 * 
	 * @return 获取soa服务执行器
	 */
	public static ISoaServiceManager getSoaServiceExecutor() {
		DBType dbType = DBTypeAdapter.getDBType();
		if (DBType.ORACLE.getValue().equals(dbType.getValue())) {
			return new SoaServiceExecutorOracle();
		} else if (DBType.MYSQL.getValue().equals(dbType.getValue())) {
			return new SoaServiceExecutorMySQL();
		}
		return new SoaServiceExecutorOracle();
	}

}
