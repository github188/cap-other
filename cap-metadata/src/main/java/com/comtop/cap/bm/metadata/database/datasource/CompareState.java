/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.database.datasource;

/**
 * 表结构比较状态枚举
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年11月2日 许畅 新建
 */
public enum CompareState {

	/** 新增 */
	ADD("新增"),

	/** 修改 */
	MODIFY("修改"),

	/** 删除 */
	DELETE("删除"),

	/** 其他 */
	OTHER("其他");

	/** 值 */
	private String value;

	/**
	 * @param value
	 *            值
	 */
	private CompareState(String value) {
		setValue(value);
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
