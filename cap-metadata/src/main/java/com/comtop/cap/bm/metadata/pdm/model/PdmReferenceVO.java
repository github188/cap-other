/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.pdm.model;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.metadata.database.dbobject.model.TableVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * PDM字段关联关系VO
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015-10-08 陈志伟
 */
@DataTransferObject
public class PdmReferenceVO {
    
    /** 主表id */
    private String parentTableId;
    
    /** 关联表id */
    private String childTableId;
    
    /** 主表 */
    private TableVO parentTable;
    
    /** 关联表 */
    private TableVO childTable;
    
    /** 字段关联关系 */
    private List<PdmReferenceJoinVO> joins = new ArrayList<PdmReferenceJoinVO>();

	/**
	 * @return the parentTableId
	 */
	public String getParentTableId() {
		return parentTableId;
	}

	/**
	 * @param parentTableId the parentTableId to set
	 */
	public void setParentTableId(String parentTableId) {
		this.parentTableId = parentTableId;
	}

	/**
	 * @return the childTableId
	 */
	public String getChildTableId() {
		return childTableId;
	}

	/**
	 * @param childTableId the childTableId to set
	 */
	public void setChildTableId(String childTableId) {
		this.childTableId = childTableId;
	}

	/**
	 * @return the parentTable
	 */
	public TableVO getParentTable() {
		return parentTable;
	}

	/**
	 * @param parentTable the parentTable to set
	 */
	public void setParentTable(TableVO parentTable) {
		this.parentTable = parentTable;
	}

	/**
	 * @return the childTable
	 */
	public TableVO getChildTable() {
		return childTable;
	}

	/**
	 * @param childTable the childTable to set
	 */
	public void setChildTable(TableVO childTable) {
		this.childTable = childTable;
	}

	/**
	 * @return the joins
	 */
	public List<PdmReferenceJoinVO> getJoins() {
		return joins;
	}

	/**
	 * @param joins the joins to set
	 */
	public void setJoins(List<PdmReferenceJoinVO> joins) {
		this.joins = joins;
	}
    
}
