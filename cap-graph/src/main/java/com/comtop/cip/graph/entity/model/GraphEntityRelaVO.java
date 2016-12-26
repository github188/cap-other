/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.entity.model;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 实体关联关系VO
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015-7-22 陈志伟
 */
@DataTransferObject
public class GraphEntityRelaVO {

	/** 源实体ID */
	private String sourceEntityId;

	/** 目标实体ID */
	private String targetEntityId;

	/** 关联关系 */
	private String multiple;

	/**
	 * @return 获取 sourceEntityId属性值
	 */
	public String getSourceEntityId() {
		return sourceEntityId;
	}

	/**
	 * @param sourceEntityId 设置 sourceEntityId 属性值为参数值 sourceEntityId
	 */
	public void setSourceEntityId(String sourceEntityId) {
		this.sourceEntityId = sourceEntityId;
	}

	/**
	 * @return 获取 multiple属性值
	 */
	public String getMultiple() {
		return multiple;
	}

	/**
	 * @param multiple 设置 multiple 属性值为参数值 multiple
	 */
	public void setMultiple(String multiple) {
		this.multiple = multiple;
	}

	/**
	 * @return the targetEntityId
	 */
	public String getTargetEntityId() {
		return targetEntityId;
	}

	/**
	 * @param targetEntityId
	 *            the targetEntityId to set
	 */
	public void setTargetEntityId(String targetEntityId) {
		this.targetEntityId = targetEntityId;
	}
}
