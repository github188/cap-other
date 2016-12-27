/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.model.query;

import java.util.List;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 查询建模OrderBy数据
 *
 * @author 许畅
 * @since jdk1.6
 * @version 2016年07月26日 许畅 新建
 */
@DataTransferObject
public class OrderBy extends BaseMetadata {

	/** 序列化版本号 */
	private static final long serialVersionUID = 1L;

	/** 排序集合 */
	private List<Sort> sorts;

	/** 排序结尾 {@link com.comtop.cap.bm.metadata.entity.model.query.SortEnd} */
	private String sortEnd = SortEnd.BLANK.getValue();

	/** 是否动态排序 */
	private boolean dynamicOrder;

	/** 动态排序属性 */
	private QueryAttribute dynamicAttribute;

	/**
	 * @return the sorts 排序集合
	 */
	public List<Sort> getSorts() {
		return sorts;
	}

	/**
	 * @param sorts
	 *            the sorts to set 排序集合
	 */
	public void setSorts(List<Sort> sorts) {
		this.sorts = sorts;
	}

	/**
	 * @return the sortEnd 排序结尾
	 */
	public String getSortEnd() {
		return sortEnd;
	}

	/**
	 * @param sortEnd
	 *            the sortEnd to set 排序结尾
	 */
	public void setSortEnd(String sortEnd) {
		this.sortEnd = sortEnd;
	}

	/**
	 * @return the dynamicOrder 是否动态排序
	 */
	public boolean isDynamicOrder() {
		return dynamicOrder;
	}

	/**
	 * @param dynamicOrder
	 *            the dynamicOrder to set 是否动态排序
	 */
	public void setDynamicOrder(boolean dynamicOrder) {
		this.dynamicOrder = dynamicOrder;
	}

	/**
	 * @return the dynamicAttribute 动态排序属性
	 */
	public QueryAttribute getDynamicAttribute() {
		return dynamicAttribute;
	}

	/**
	 * @param dynamicAttribute
	 *            the dynamicAttribute to set 动态排序属性
	 */
	public void setDynamicAttribute(QueryAttribute dynamicAttribute) {
		this.dynamicAttribute = dynamicAttribute;
	}

}
