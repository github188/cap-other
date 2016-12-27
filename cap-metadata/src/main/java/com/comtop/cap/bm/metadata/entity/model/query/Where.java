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
 * 查询建模Where数据模型
 *
 * @author 许畅
 * @since jdk1.6
 * @version 2016年07月26日 许畅 新建
 */
@DataTransferObject
public class Where extends BaseMetadata {

	/** 序列化版本号 */
	private static final long serialVersionUID = 1L;

	/** 查询条件集合 */
	private List<WhereCondition> whereConditions;

	/** 是否引用公共查询条件 */
	private boolean refCommonCondtion;

	/**
	 * @return the whereConditions 查询条件集合
	 */
	public List<WhereCondition> getWhereConditions() {
		return whereConditions;
	}

	/**
	 * @param whereConditions
	 *            the whereConditions to set 查询条件集合
	 */
	public void setWhereConditions(List<WhereCondition> whereConditions) {
		this.whereConditions = whereConditions;
	}

	/**
	 * @return the refCommonCondtion 是否引用公共查询条件
	 */
	public boolean isRefCommonCondtion() {
		return refCommonCondtion;
	}

	/**
	 * @param refCommonCondtion
	 *            the refCommonCondtion to set 是否引用公共查询条件
	 */
	public void setRefCommonCondtion(boolean refCommonCondtion) {
		this.refCommonCondtion = refCommonCondtion;
	}

}
