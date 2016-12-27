/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.database.model;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.bm.metadata.entity.model.EntityAttributeVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 表同步实体分析结果
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年11月22日 许畅 新建
 */
@DataTransferObject
public class AnalyzeResult extends BaseMetadata {

	/** {@link com.comtop.cap.bm.metadata.database.datasource.CompareState} */
	private String state;

	/** 字段名称 */
	private String engName;

	/** 字段名称 */
	private String chName;

	/** 详细信息 */
	private String detail;

	/** 实体属性 */
	private EntityAttributeVO attribute;

	/** id */
	private String id;

	/**
	 * @return the state
	 */
	public String getState() {
		return state;
	}

	/**
	 * @param state
	 *            the state to set
	 */
	public void setState(String state) {
		this.state = state;
	}

	/**
	 * @return the chName
	 */
	public String getChName() {
		return chName;
	}

	/**
	 * @param chName
	 *            the chName to set
	 */
	public void setChName(String chName) {
		this.chName = chName;
	}

	/**
	 * @return the detail
	 */
	public String getDetail() {
		return detail;
	}

	/**
	 * @param detail
	 *            the detail to set
	 */
	public void setDetail(String detail) {
		this.detail = detail;
	}

	/**
	 * @return the attribute
	 */
	public EntityAttributeVO getAttribute() {
		return attribute;
	}

	/**
	 * @param attribute
	 *            the attribute to set
	 */
	public void setAttribute(EntityAttributeVO attribute) {
		this.attribute = attribute;
	}

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
	 * @return the engName
	 */
	public String getEngName() {
		return engName;
	}

	/**
	 * @param engName
	 *            the engName to set
	 */
	public void setEngName(String engName) {
		this.engName = engName;
	}

}
