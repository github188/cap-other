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
 * oracle PDM数据类型转换器
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年11月17日 许畅 新建
 */
public class OracleDataTypeConverter implements IDataTypeConverter {

	/**
	 * 构造方法
	 */
	private OracleDataTypeConverter() {
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
	private static OracleDataTypeConverter instance;

	static {
		dataType.put("DATE", "TIMESTAMP");
		dataType.put("TIMESTAMP", "TIMESTAMP");
		dataType.put("CHAR", "CHAR");
		dataType.put("VARCHAR", "VARCHAR2");
		dataType.put("VARCHAR2", "VARCHAR2");

		dataType.put("NUMBER", "NUMBER");
		dataType.put("NUMERIC", "NUMBER");
		dataType.put("DECIMAL", "NUMBER");
		dataType.put("INT", "NUMBER");
		dataType.put("INTEGER", "NUMBER");
		dataType.put("LONG", "NUMBER");
		dataType.put("FLOAT", "NUMBER");

		dataType.put("BLOB", "BLOB");
		dataType.put("CLOB", "CLOB");

		// DATE数据库默认值length为7,精度为0,精度和长度无法更改
		length.put("DATE", 7);
		precision.put("DATE", 0);
		// TIMESTAMP length为11,精度为6
		length.put("TIMESTAMP", 11);
		precision.put("TIMESTAMP", 6);
		// 针对pdm中直接设置类型字段,没设置精度的情况
		initLength();
	}

	/** 初始化默认类型字段长度 */
	private static void initLength() {
		// 针对pdm中直接设置的NUMBER类型字段,没设置精度的情况
		length.put("NUMBER", 22);
		length.put("NUMERIC", 22);
		length.put("DECIMAL", 22);
		length.put("INT", 22);
		length.put("INTEGER", 22);
		length.put("LONG", 22);
		length.put("FLOAT", 22);
		precision.put("NUMBER", 0);
		// 处理BLOB和CLOB字段长度默认值
		length.put("BLOB", 4000);
		precision.put("BLOB", 0);
		length.put("CLOB", 4000);
		precision.put("CLOB", 0);
	}

	/**
	 * @return 获取DataTypeConverter实例
	 */
	public static OracleDataTypeConverter getInstance() {
		if (instance == null) {
			synchronized (OracleDataTypeConverter.class) {
				if (instance == null) {
					instance = new OracleDataTypeConverter();
				}
			}
		}
		return instance;
	}

	/**
	 * PDM中的数据类型转换为元数据中对应数据类型
	 * 
	 * @param pdmDataType
	 *            pdm中的数据类型
	 * @return 元数据类型
	 *
	 * @see com.comtop.cap.bm.metadata.pdm.convert.IDataTypeConverter#convertToMetaDataType(java.lang.String)
	 */
	@Override
	public String convertToMetaDataType(String pdmDataType) {
		String originalType = removeBracket(pdmDataType);// 替换掉()
		if (dataType.containsKey(originalType)) {
			return dataType.get(originalType);
		}
		// 其他类型转换统统转换为VARCHAR2
		return dataType.get("VARCHAR2");
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

	/**
	 * 去除括弧
	 * 
	 * @param pdmDataType
	 *            pdm中的数据类型
	 * @return 数据类型
	 */
	private String removeBracket(String pdmDataType) {
		return pdmDataType.replaceAll("\\(.+\\)", "");// 替换掉()
	}

	/**
	 * @return the datatype
	 */
	public static Map<String, String> getDatatype() {
		return dataType;
	}

}
