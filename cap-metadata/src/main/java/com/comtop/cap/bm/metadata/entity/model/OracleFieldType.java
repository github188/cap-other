/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.model;

/**
 * OracleFieldType
 * 
 * @author 章尊志
 * @since 1.0
 * @version 2014-9-17 章尊志
 */
public enum OracleFieldType {
	/** CHAR */
	CHAR("CHAR"),

	/** VARCHAR2 */
	VARCHAR2("VARCHAR2"),

	/** NVARCHAR2 */
	NVARCHAR2("NVARCHAR2"),

	/** VARCHAR */
	VARCHAR("VARCHAR"),

	/** NUMERIC */
	NUMERIC("NUMERIC"),

	/** NUMBER */
	NUMBER("NUMBER"),

	/** DATE */
	DATE("DATE"),

	/** TIMESTAMP */
	TIMESTAMP("TIMESTAMP"),

	/** BLOB */
	BLOB("BLOB"),

	/** CLOB */
	CLOB("CLOB"),

	/** INT */
	INT("INT"),

	/** TEXT */
	TEXT("TEXT"),

	/** INTEGER */
	INTEGER("INTEGER");

	/** 值 */
	private String value;

	/**
	 * 构造函数
	 * 
	 * @param value
	 *            枚举值
	 */
	private OracleFieldType(String value) {
		this.value = value;
	}

	/**
	 * @return 获取 value属性值
	 */
	public String getValue() {
		return value;
	}

	/**
	 * 获取字段类型的字符串表达
	 * 
	 * @param fieldDataType
	 *            字段类型
	 * @param precision
	 *            精度
	 * @return 字段类型的字符串表达
	 */
	public static String getAttributeDataType(final String fieldDataType,
			final int precision) {
		String strTypeValue = "";
		if (fieldDataType.equals(CHAR.getValue())
				|| fieldDataType.equals(VARCHAR2.getValue())
				|| fieldDataType.equals(NVARCHAR2.getValue())
				|| fieldDataType.equals(VARCHAR.getValue())
				|| fieldDataType.equals(TEXT.getValue())) {
			strTypeValue = AttributeType.STRING.getValue();
		} else if (fieldDataType.equals(NUMBER.getValue())
				|| fieldDataType.equals(NUMERIC.getValue())) {
			if (0 == precision) {
				strTypeValue = AttributeType.INT.getValue();
			} else {
				strTypeValue = AttributeType.DOUBLE.getValue();
			}
		} else if (fieldDataType.equals(DATE.getValue())) {
			strTypeValue = AttributeType.JAVA_SQL_DATE.getValue();
		} else if (fieldDataType.equals(TIMESTAMP.getValue())) {
			strTypeValue = AttributeType.JAVA_SQL_TIMESTAMP.getValue();
		} else if (fieldDataType.equals(BLOB.getValue())) {
			strTypeValue = AttributeType.JAVA_SQL_BLOB.getValue();
		} else if (fieldDataType.equals(CLOB.getValue())) {
			strTypeValue = AttributeType.JAVA_SQL_CLOB.getValue();
		} else if (fieldDataType.equals(INT.getValue())
				|| fieldDataType.equals(INTEGER.getValue())) {
			strTypeValue = AttributeType.INTEGER.getValue();
		}
		return strTypeValue;
	}
}
