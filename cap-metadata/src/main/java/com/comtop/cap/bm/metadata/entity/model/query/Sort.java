/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.entity.model.query;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * orderBy排序对象模型
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年7月26日 许畅 新建
 */
@DataTransferObject
public class Sort extends BaseMetadata {

	/** 序列化版本号 */
	private static final long serialVersionUID = 1L;

	/** 排序属性 */
	private QueryAttribute sortAttribute;

	/** 升/降序 {@link com.comtop.cap.bm.metadata.entity.model.SortType} */
	private String sortType;

	/** 序号,用于上移下移功能 */
	private int sortNo;

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
	 * @return the sortType
	 */
	public String getSortType() {
		return sortType;
	}

	/**
	 * @param sortType
	 *            the sortType to set
	 */
	public void setSortType(String sortType) {
		this.sortType = sortType;
	}

	/**
	 * @return the sortAttribute
	 */
	public QueryAttribute getSortAttribute() {
		return sortAttribute;
	}

	/**
	 * @param sortAttribute
	 *            the sortAttribute to set
	 */
	public void setSortAttribute(QueryAttribute sortAttribute) {
		this.sortAttribute = sortAttribute;
	}

}
