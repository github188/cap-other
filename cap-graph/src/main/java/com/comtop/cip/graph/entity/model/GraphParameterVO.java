/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.entity.model;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 实体参数VO
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015-7-22 陈志伟
 */
@DataTransferObject
public class GraphParameterVO extends GraphBaseVO {

	/** ID */
	private String id;

	/** 类型 */
	private String type;

	/** 序号 */
	private int sortNo;

	/**
	 * @return the id
	 */
	public String getId() {
		return id;
	}

	/**
	 * @param id
	 *            the id to set
	 */
	public void setId(String id) {
		this.id = id;
	}

	/**
	 * @return the type
	 */
	public String getType() {
		return type;
	}

	/**
	 * @param type
	 *            the type to set
	 */
	public void setType(String type) {
		this.type = type;
	}

	/**
	 * @return the sortNo
	 */
	public int getSortNo() {
		return sortNo;
	}

	/**
	 * @param sortNo
	 *            the sortNo to set
	 */
	public void setSortNo(int sortNo) {
		this.sortNo = sortNo;
	}

}
