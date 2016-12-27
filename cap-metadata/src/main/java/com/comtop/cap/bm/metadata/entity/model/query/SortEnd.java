/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.entity.model.query;

/**
 * 排序结尾枚举
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年7月26日 许畅 新建
 */
public enum SortEnd {

	/**
	 * null排序在最后面
	 */
	NULLS_LAST("NULLS LAST"),

	/**
	 * null排序在最前面
	 */
	NULLS_FIRST("NULLS FIRST"),

	/**
	 * 空白不以任何值结尾
	 */
	BLANK("");

	/**
	 * 枚举值
	 */
	private String value;

	/**
	 * @param value
	 *            值
	 */
	private SortEnd(String value) {
		this.value = value;
	}

	/**
	 * @return the value
	 */
	public String getValue() {
		return value;
	}
}
