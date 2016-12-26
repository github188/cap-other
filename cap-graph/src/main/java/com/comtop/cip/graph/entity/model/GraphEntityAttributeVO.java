/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.entity.model;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 实体属性VO
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015-7-22 陈志伟
 */
@DataTransferObject
public class GraphEntityAttributeVO extends GraphBaseVO {

	/** 属性ID */
	private String id;

	/** 实体ID */
	private String entityId;

	/** 访问权限 */
	private String level;

	/** 属性类型 */
	private String attriType;

	/** 排序 */
	private int sortNo;

	/** 属性长度 */
	private int attributeLength;

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
	 * @return the entityId
	 */
	public String getEntityId() {
		return entityId;
	}

	/**
	 * @param entityId
	 *            the entityId to set
	 */
	public void setEntityId(String entityId) {
		this.entityId = entityId;
	}

	/**
	 * @return the level
	 */
	public String getLevel() {
		return level;
	}

	/**
	 * @param level
	 *            the level to set
	 */
	public void setLevel(String level) {
		this.level = level;
	}

	/**
	 * @return the attriType
	 */
	public String getAttriType() {
		return attriType;
	}

	/**
	 * @param attriType
	 *            the attriType to set
	 */
	public void setAttriType(String attriType) {
		this.attriType = attriType;
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

	/**
	 * @return the attributeLength
	 */
	public int getAttributeLength() {
		return attributeLength;
	}

	/**
	 * @param attributeLength
	 *            the attributeLength to set
	 */
	public void setAttributeLength(int attributeLength) {
		this.attributeLength = attributeLength;
	}

}
