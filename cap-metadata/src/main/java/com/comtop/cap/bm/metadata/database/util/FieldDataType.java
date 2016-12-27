/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.database.util;

import com.comtop.cap.bm.metadata.database.dbobject.util.DBType;
import com.comtop.cap.bm.metadata.database.dbobject.util.DBTypeAdapter;

/**
 * 数据表字段类型
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-4-10 李忠文
 */
public final class FieldDataType {

	/**
	 * 构造函数
	 */
	private FieldDataType() {
		super();
	}

	/** CHAR */
	public static final int CHAR = 0;

	/** VARCHAR2 */
	public static final int VARCHAR2 = 1;

	/** NVARCHAR2 */
	public static final int NVARCHAR2 = 2;

	/** NUMBER */
	public static final int NUMBER = 3;

	/** Date */
	public static final int DATE = 4;

	/** TIMESTAMP */
	public static final int TIMESTAMP = 5;

	/** BLOB */
	public static final int BLOB = 6;

	/** CLOB */
	public static final int CLOB = 7;

	/** VARCHAR */
	public static final int VARCHAR = 8;

	/** NUMERIC */
	public static final int NUMERIC = 9;
	
	/** INTEGER */
	public static final int INTEGER = 10;
	
	/** TEXT */
	public static final int TEXT = 11;

	/** CHAR */
	public static final String CHAR_VALUE = "CHAR";

	/** VARCHAR2 */
	public static final String VARCHAR2_VALUE = "VARCHAR2";

	/** VARCHAR */
	public static final String VARCHAR_VALUE = "VARCHAR";

	/** NVARCHAR2 */
	public static final String NVARCHAR2_VALUE = "NVARCHAR2";

	/** NUMBER */
	public static final String NUMBER_VALUE = "NUMBER";

	/** Date */
	public static final String DATE_VALUE = "DATE";

	/** TIMESTAMP */
	public static final String TIMESTAMP_VALUE = "TIMESTAMP";

	/** BLOB */
	public static final String BLOB_VALUE = "BLOB";

	/** CLOB */
	public static final String CLOB_VALUE = "CLOB";

	/** TEXT */
	public static final String TEXT_VALUE = "TEXT";

	/** NUMERIC */
	public static final String NUMERIC_VALUE = "NUMERIC";
	
	/** INTEGER */
	public static final String INTEGER_VALUE = "INT";

	/**
	 * 获取字段类型的字符串表达
	 * 
	 * @param fieldDataType
	 *            字段类型
	 * @return 字段类型的字符串表达
	 */
	public static String getFieldTypeValue(final int fieldDataType) {
		DBType dbType = DBTypeAdapter.getDBType();
		if (DBType.ORACLE.getValue().equals(dbType.getValue())) {
			return getFieldTypeValueOracle(fieldDataType);
		}
		if (DBType.MYSQL.getValue().equals(dbType.getValue())) {
			return getFieldTypeValueMySQL(fieldDataType);
		}

		return getFieldTypeValueOracle(fieldDataType);
	}

	/**
	 * 获取字段类型的字符串表达ORCLE
	 * 
	 * @param fieldDataType
	 *            字段类型
	 * @return 字段类型的字符串表达
	 */
	private static String getFieldTypeValueOracle(final int fieldDataType) {
		String strTypeValue;
		switch (fieldDataType) {
		case CHAR:
			strTypeValue = CHAR_VALUE;
			break;
		case VARCHAR2:
			strTypeValue = VARCHAR2_VALUE;
			break;
		case NVARCHAR2:
			strTypeValue = NVARCHAR2_VALUE;
			break;
		case NUMBER:
			strTypeValue = NUMBER_VALUE;
			break;
		case DATE:
			strTypeValue = DATE_VALUE;
			break;
		case TIMESTAMP:
			strTypeValue = TIMESTAMP_VALUE;
			break;
		case BLOB:
			strTypeValue = BLOB_VALUE;
			break;
		case CLOB:
			strTypeValue = CLOB_VALUE;
			break;
		default:
			strTypeValue = VARCHAR2_VALUE;
			break;
		}
		return strTypeValue;
	}

	/**
	 * 获取字段类型的字符串表达MySQL
	 * 
	 * @param fieldDataType
	 *            字段类型
	 * @return 字段类型的字符串表达
	 */
	private static String getFieldTypeValueMySQL(final int fieldDataType) {
		String strTypeValue;
		switch (fieldDataType) {
		case CHAR:
			strTypeValue = CHAR_VALUE;
			break;
		case VARCHAR:
			strTypeValue = VARCHAR_VALUE;
			break;
		case NUMERIC:
			strTypeValue = NUMERIC_VALUE;
			break;
		case INTEGER:
			strTypeValue = INTEGER_VALUE;
			break;
		case DATE:
			strTypeValue = DATE_VALUE;
			break;
		case TIMESTAMP:
			strTypeValue = TIMESTAMP_VALUE;
			break;
		case BLOB:
			strTypeValue = BLOB_VALUE;
			break;
		case TEXT:
			strTypeValue = TEXT_VALUE;
			break;
		default:
			strTypeValue = VARCHAR_VALUE;
			break;
		}
		return strTypeValue;
	}
}
