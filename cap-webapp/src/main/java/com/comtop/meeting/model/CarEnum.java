/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.meeting.model;

/**
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年6月27日 许畅 新建
 */
public enum CarEnum {

	/**
	 * 
	 */
	CAR_BENZ("奔驰"),

	/**
	 * 
	 */
	CAR_BMW("宝马");

	/**
	 * @param value
	 *            xxx
	 */
	private CarEnum(String value) {
		this.setKey(value);
	}

	/**
	 * @return the key
	 */
	public String getValue() {
		return value;
	}

	/**
	 * @param value
	 *            the key to set
	 */
	public void setKey(String value) {
		this.value = value;
	}

	/**
	 * xx
	 */
	private String value;

}
