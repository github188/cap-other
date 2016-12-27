/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.pdm.convert;

import com.comtop.cap.bm.metadata.database.dbobject.util.DBType;
import com.comtop.cap.bm.metadata.database.dbobject.util.DBTypeAdapter;

/**
 * 数据类型工厂类
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年11月17日 许畅 新建
 */
public final class DataTypeFactory {

	/**
	 * 构造方法
	 */
	private DataTypeFactory() {

	}

	/**
	 * 数据类型转换器
	 * 
	 * @return IDataTypeConverter
	 */
	public static IDataTypeConverter getDataTypeConverter() {
		DBType dbType = DBTypeAdapter.getDBType();
		if (DBType.ORACLE.getValue().equals(dbType.getValue())) {
			return OracleDataTypeConverter.getInstance();
		} else if (DBType.MYSQL.getValue().equals(dbType.getValue())) {
			return MySQLDataTypeConverter.getInstance();
		}
		return OracleDataTypeConverter.getInstance();
	}

}
