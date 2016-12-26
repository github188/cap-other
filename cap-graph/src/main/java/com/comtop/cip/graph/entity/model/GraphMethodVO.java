/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.entity.model;

import java.util.List;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 实体方法VO
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015-7-22 陈志伟
 */
@DataTransferObject
public class GraphMethodVO extends GraphBaseVO {

	/** 方法ID */
	private String id;

	/** 实体ID */
	private String entityId;

	/** 访问权限 */
	private String level;

	/** 返回类型 */
	private String reType;

	/** 返回实体Id */
	private String returnEntityId;

	/** 参数 */
	private List<GraphParameterVO> parameters;

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
	 * @return the reType
	 */
	public String getReType() {
		return reType;
	}

	/**
	 * @param reType
	 *            the reType to set
	 */
	public void setReType(String reType) {
		this.reType = reType;
	}

	/**
	 * @return the returnEntityId
	 */
	public String getReturnEntityId() {
		return returnEntityId;
	}

	/**
	 * @param returnEntityId
	 *            the returnEntityId to set
	 */
	public void setReturnEntityId(String returnEntityId) {
		this.returnEntityId = returnEntityId;
	}

	/**
	 * @return the parameters
	 */
	public List<GraphParameterVO> getParameters() {
		return parameters;
	}

	/**
	 * @param parameters
	 *            the parameters to set
	 */
	public void setParameters(List<GraphParameterVO> parameters) {
		this.parameters = parameters;
	}

}
