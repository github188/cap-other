/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.pdm.model;

import com.comtop.cap.bm.metadata.database.dbobject.model.ColumnVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * PDM字段关联关系VO
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015-10-08 陈志伟
 */
@DataTransferObject
public class PdmReferenceJoinVO {
    
    /** id */
    private String id;
    
    /** 父实体字段编码 */
    private String parentTableColumnCode;
    
    /** 关联实体字段编码 */
    private String childTableColumnCode;
    
    /** 父实体字段 */
    private ColumnVO parentTableColumn;
    
    /**
	 * @return the id
	 */
	public String getId() {
		return id;
	}

	/**
	 * @param id the id to set
	 */
	public void setId(String id) {
		this.id = id;
	}

	/**
	 * @return the parentTableColumnCode
	 */
	public String getParentTableColumnCode() {
		return parentTableColumnCode;
	}

	/**
	 * @param parentTableColumnCode the parentTableColumnCode to set
	 */
	public void setParentTableColumnCode(String parentTableColumnCode) {
		this.parentTableColumnCode = parentTableColumnCode;
	}

	/**
	 * @return the childTableColumnCode
	 */
	public String getChildTableColumnCode() {
		return childTableColumnCode;
	}

	/**
	 * @param childTableColumnCode the childTableColumnCode to set
	 */
	public void setChildTableColumnCode(String childTableColumnCode) {
		this.childTableColumnCode = childTableColumnCode;
	}

	/**
	 * @return the parentTableColumn
	 */
	public ColumnVO getParentTableColumn() {
		return parentTableColumn;
	}

	/**
	 * @param parentTableColumn the parentTableColumn to set
	 */
	public void setParentTableColumn(ColumnVO parentTableColumn) {
		this.parentTableColumn = parentTableColumn;
	}

	/**
	 * @return the childTableColumn
	 */
	public ColumnVO getChildTableColumn() {
		return childTableColumn;
	}

	/**
	 * @param childTableColumn the childTableColumn to set
	 */
	public void setChildTableColumn(ColumnVO childTableColumn) {
		this.childTableColumn = childTableColumn;
	}

	/** 关联实体字段 */
    private ColumnVO childTableColumn;
    
}
