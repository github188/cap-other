/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.workbenchconfig.convert;

import com.comtop.cap.bm.metadata.database.dbobject.util.DBType;
import com.comtop.cap.bm.metadata.database.dbobject.util.DBTypeAdapter;

/**
 * 工作台类型转换器工厂类
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年12月26日 许畅 新建
 */
public final class WorkbenchConfigBuilderFactory {

	/**
	 * 构造方法
	 */
	private WorkbenchConfigBuilderFactory() {
		super();
	}

	/**
	 * 获取WorkbenchConverter实例
	 * 
	 * @return IWorkbenchConverter
	 */
	public static IWorkbenchBuilder getInstance() {
		DBType dbType = DBTypeAdapter.getDBType();
		if (DBType.ORACLE.getValue().equals(dbType.getValue())) {
			return new WorkbenchConfigOracleBuilder();
		} else if (DBType.MYSQL.getValue().equals(dbType.getValue())) {
			return new WorkbenchConfigMySQLBuilder();
		}
		return new WorkbenchConfigOracleBuilder();
	}

}
