/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.database.dbobject.model;

/**
 * 数据类型枚举
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年11月7日 许畅 新建
 */
public enum DataType {

	/** CHAR */
	CHAR("CHAR"),

	/** VARCHAR2 */
	VARCHAR2("VARCHAR2"),

	/** NVARCHAR2 */
	NVARCHAR2("NVARCHAR2"),

	/** NUMBER */
	NUMBER("NUMBER"),
	
	/** NUMERIC */
	NUMERIC("NUMERIC"),

	/** Date */
	DATE("DATE"),

	/** TIMESTAMP */
	TIMESTAMP("TIMESTAMP"),

	/** BLOB */
	BLOB("BLOB"),

	/** CLOB */
	CLOB("CLOB");

	/** 值 */
	private String value;

	/**
	 * 构造方法
	 * 
	 * @param value
	 *            值
	 */
	private DataType(String value) {
		this.setValue(value);
	}

	/**
	 * @return the value
	 */
	public String getValue() {
		return value;
	}

	/**
	 * @param value
	 *            the value to set
	 */
	public void setValue(String value) {
		this.value = value;
	}

}
