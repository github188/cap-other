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
 * 查询建模From对象模型
 *
 * @author 许畅
 * @since jdk1.6
 * @version 2016年07月25日 许畅 新建
 */
@DataTransferObject
public class From extends BaseMetadata {

	/** 序列化版本号 */
	private static final long serialVersionUID = 1L;

	/** 主表信息 */
	private Subquery primaryTable;

	/** 子查询信息 */
	private List<Subquery> subquerys;

	/**
	 * @return the subquerys 子查询信息
	 */
	public List<Subquery> getSubquerys() {
		return subquerys;
	}

	/**
	 * @param subquerys
	 *            the subquerys to set 子查询信息
	 */
	public void setSubquerys(List<Subquery> subquerys) {
		this.subquerys = subquerys;
	}

	/**
	 * @return the primaryTable 主表信息
	 */
	public Subquery getPrimaryTable() {
		return primaryTable;
	}

	/**
	 * @param primaryTable
	 *            the primaryTable to set 主表信息
	 */
	public void setPrimaryTable(Subquery primaryTable) {
		this.primaryTable = primaryTable;
	}

}
