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
 * 新版查询建模
 *
 * @author 许畅
 * @since jdk1.6
 * @version 2016年07月25日 许畅 新建
 */
@DataTransferObject
public class QueryModel extends BaseMetadata {

	/** 序列化版本号 */
	private static final long serialVersionUID = 1L;

	/** 查询建模select对象 */
	private Select select;

	/** 查询建模from对象 */
	private From from;

	/** 查询建模where对象 */
	private Where where;

	/** 查询建模orderBy对象 */
	private OrderBy orderBy;

	/** 查询建模groupBy对象 */
	private GroupBy groupBy;

	/** SQL预览 */
	private String previewSQL;

	/**
	 * @return 获取 previewSQL属性值
	 */
	public String getPreviewSQL() {
		return previewSQL;
	}

	/**
	 * @param previewSQL
	 *            设置 previewSQL 属性值为参数值 previewSQL
	 */
	public void setPreviewSQL(String previewSQL) {
		this.previewSQL = previewSQL;
	}

	/**
	 * @return the select
	 */
	public Select getSelect() {
		return select;
	}

	/**
	 * @param select
	 *            the select to set
	 */
	public void setSelect(Select select) {
		this.select = select;
	}

	/**
	 * @return the from
	 */
	public From getFrom() {
		return from;
	}

	/**
	 * @param from
	 *            the from to set
	 */
	public void setFrom(From from) {
		this.from = from;
	}

	/**
	 * @return the where
	 */
	public Where getWhere() {
		return where;
	}

	/**
	 * @param where
	 *            the where to set
	 */
	public void setWhere(Where where) {
		this.where = where;
	}

	/**
	 * @return the orderBy
	 */
	public OrderBy getOrderBy() {
		return orderBy;
	}

	/**
	 * @param orderBy
	 *            the orderBy to set
	 */
	public void setOrderBy(OrderBy orderBy) {
		this.orderBy = orderBy;
	}

	/**
	 * @return the groupBy
	 */
	public GroupBy getGroupBy() {
		return groupBy;
	}

	/**
	 * @param groupBy
	 *            the groupBy to set
	 */
	public void setGroupBy(GroupBy groupBy) {
		this.groupBy = groupBy;
	}

}
