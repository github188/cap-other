/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.database.dbobject.model;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.bm.metadata.common.storage.annotation.IgnoreField;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 字段关联关系VO
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015-10-08 陈志伟
 */
@DataTransferObject
public class ReferenceVO extends BaseMetadata {
    
    /** 序列化ID */
    private static final long serialVersionUID = -5909726520744923494L;
    
    /** 主表id */
    @IgnoreField
    private String parentTableId;
    
    /** 关联表id */
    private String childTableId;
    
    /** 关联表 */
    private TableVO childTable;
    
    /** 主表 */
    @IgnoreField
    private TableVO parentTable;
    
    /** 关联关系 */
    private String cardinality;
    
	/** 字段关联关系 */
    private List<ReferenceJoinVO> joins = new ArrayList<ReferenceJoinVO>();
    
    /**
	 * @return 获取 cardinality属性值
	 */
	public String getCardinality() {
		return cardinality;
	}

	/**
	 * @param cardinality 设置 cardinality 属性值为参数值 cardinality
	 */
	public void setCardinality(String cardinality) {
		this.cardinality = cardinality;
	}
    
    /**
     * @return 获取 parentTableId属性值
     */
    public String getParentTableId() {
        return parentTableId;
    }
    
    /**
     * @param parentTableId 设置 parentTableId 属性值为参数值 parentTableId
     */
    public void setParentTableId(String parentTableId) {
        this.parentTableId = parentTableId;
    }
    
    /**
     * @return 获取 parentTable属性值
     */
    public TableVO getParentTable() {
        return parentTable;
    }
    
    /**
     * @param parentTable 设置 parentTable 属性值为参数值 parentTable
     */
    public void setParentTable(TableVO parentTable) {
        this.parentTable = parentTable;
    }
    
    /**
     * @return 获取 childTableId属性值
     */
    public String getChildTableId() {
        return childTableId;
    }
    
    /**
     * @param childTableId 设置 childTableId 属性值为参数值 childTableId
     */
    public void setChildTableId(String childTableId) {
        this.childTableId = childTableId;
    }
    
    /**
     * @return 获取 childTable属性值
     */
    public TableVO getChildTable() {
        return childTable;
    }
    
    /**
     * @param childTable 设置 childTable 属性值为参数值 childTable
     */
    public void setChildTable(TableVO childTable) {
        this.childTable = childTable;
    }
    
    /**
     * @return 获取 joins属性值
     */
    public List<ReferenceJoinVO> getJoins() {
        return joins;
    }
    
    /**
     * @param joins 设置 joins 属性值为参数值 joins
     */
    public void setJoins(List<ReferenceJoinVO> joins) {
        this.joins = joins;
    }
    
    /**
     * @param pdmReferenceJoin 设置 joins 属性值为参数值 joins
     */
    public void addReferenceJoin(ReferenceJoinVO pdmReferenceJoin) {
        joins.add(pdmReferenceJoin);
    }
    
}
