/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.pdm.convert;

import java.util.HashMap;
import java.util.Map;

/**
 * mysql数据类型转换器
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年11月17日 许畅 新建
 */
public class MySQLDataTypeConverter implements IDataTypeConverter {

	/**
	 * 构造方法
	 */
	private MySQLDataTypeConverter() {
		super();
	}

	/** 数据类型映射 */
	private static final Map<String, String> dataType = new HashMap<String, String>();

	/** 数据类型长度 */
	private static final Map<String, Integer> length = new HashMap<String, Integer>();

	/** 数据类型精度 */
	private static final Map<String, Integer> precision = new HashMap<String, Integer>();

	/**
	 * DataTypeConverter
	 */
	private static MySQLDataTypeConverter instance;

	static {
		dataType.put("VARCHAR", "VARCHAR");
		dataType.put("CHAR", "CHAR");
		dataType.put("BLOB", "BLOB");
		dataType.put("TEXT", "TEXT");
		
		dataType.put("INT", "INT");
		dataType.put("INTEGER", "INT");
		dataType.put("BIT", "NUMERIC");
		dataType.put("TINYINT", "NUMERIC");
		dataType.put("SMALLINT", "NUMERIC");
		dataType.put("BIGINT", "NUMERIC");
		dataType.put("FLOAT", "NUMERIC");
		dataType.put("DOUBLE", "NUMERIC");
		dataType.put("DECIMAL", "NUMERIC");
		dataType.put("NUMERIC", "NUMERIC");

		dataType.put("DATE", "TIMESTAMP");
		dataType.put("datetime", "TIMESTAMP");
		dataType.put("TIME", "TIMESTAMP");
		dataType.put("TIMESTAMP", "TIMESTAMP");

		initLength();
	}

	/** 初始化默认类型字段长度 */
	private static void initLength() {
		// 针对pdm中直接选择的默认值类型
		length.put("INTEGER", 10);
		length.put("INT", 10);

		length.put("NUMERIC", 22);
		length.put("BIT", 22);
		length.put("TINYINT", 22);
		length.put("SMALLINT", 22);
		length.put("BIGINT", 22);
		length.put("FLOAT", 22);
		length.put("DOUBLE", 22);
		length.put("DECIMAL", 22);

		length.put("TIMESTAMP", 19);
		precision.put("TIMESTAMP", 0);
		length.put("DATE", 19);
		precision.put("DATE", 0);
		length.put("DATETIME", 19);
		precision.put("DATETIME", 0);
		length.put("TIME", 19);
		precision.put("TIME", 0);
		
		length.put("TEXT", 65535);
		precision.put("TEXT", 0);
	}

	/**
	 * @return 获取DataTypeConverter实例
	 */
	public static MySQLDataTypeConverter getInstance() {
		if (instance == null) {
			synchronized (MySQLDataTypeConverter.class) {
				if (instance == null) {
					instance = new MySQLDataTypeConverter();
				}
			}
		}
		return instance;
	}

	/**
	 * PDM中的数据类型转换为元数据中对应数据类型
	 *
	 * @param pdmDataType
	 *            pdm数据类型
	 * @return 元数据类型
	 *
	 * @see com.comtop.cap.bm.metadata.pdm.convert.IDataTypeConverter#convertToMetaDataType(java.lang.String)
	 */
	@Override
	public String convertToMetaDataType(String pdmDataType) {
		String originalType = pdmDataType.replaceAll("\\(.+\\)", "");// 替换掉()
		if (dataType.containsKey(originalType)) {
			return dataType.get(originalType);
		}
		// 其他类型转换统统转换为VARCHAR
		return dataType.get("VARCHAR");
	}

	/**
	 * 转换为数据库对象的数据类型长度
	 * 
	 * @param pdmDataType
	 *            pdm中的数据类型
	 * @return 长度
	 *
	 * @see com.comtop.cap.bm.metadata.pdm.convert.IDataTypeConverter#convertToMetaLength(java.lang.String)
	 */
	@Override
	public Integer convertToMetaLength(String pdmDataType) {
		if (length.containsKey(pdmDataType)) {
			return length.get(pdmDataType);
		}

		return null;
	}

	/**
	 * 转换为数据库对象的数据类型精度
	 *
	 * @param pdmDataType
	 *            pdm中的数据类型
	 * @return 精度
	 *
	 * @see com.comtop.cap.bm.metadata.pdm.convert.IDataTypeConverter#convertToMetaPrecision(java.lang.String)
	 */
	@Override
	public Integer convertToMetaPrecision(String pdmDataType) {
		if (precision.containsKey(pdmDataType)) {
			return precision.get(pdmDataType);
		}

		return null;
	}

}
