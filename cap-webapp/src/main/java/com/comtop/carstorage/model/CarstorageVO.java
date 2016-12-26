/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.carstorage.model;

import com.comtop.cap.runtime.base.model.CapBaseVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;
import javax.persistence.Table;
import javax.persistence.Column;
import javax.persistence.Id;


/**
 * 车库管理
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-12-15 CAP超级管理员
 */
@Table(name = "T_PM_CARSTORAGE")
@DataTransferObject
public class CarstorageVO extends CapBaseVO {

    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 车库id */
    @Id
    @Column(name = "ID",length=40,precision=0)
    private String id;
    
    /** 车库名称 */
    @Column(name = "NAME",length=40,precision=0)
    private String name;
    
    /** 车库编码 */
    @Column(name = "STORAGENUMBER",length=40,precision=0)
    private String storagenumber;
    
    /** 车库规模 */
    @Column(name = "STORAGESIZE",precision=2)
    private Double storagesize;
    
    /** 树形id */
    @Column(name = "TREE_ID",length=40,precision=0)
    private String treeId;
    
    /** 树形父节点 */
    @Column(name = "TREE_PARENT_ID",length=40,precision=0)
    private String treeParentId;
    
    /** 树形级别 */
    @Column(name = "TREE_LEVEL",precision=0)
    private Integer treeLevel;
    
    /** 状态 */
    private String status;
    
	
    /**
     * @return 获取 车库id 属性值
     */
    public String getId() {
        return id;
    }
    	
    /**
     * @param id 设置 车库id 属性值为参数值 id
     */
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 车库名称 属性值
     */
    public String getName() {
        return name;
    }
    	
    /**
     * @param name 设置 车库名称 属性值为参数值 name
     */
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * @return 获取 车库编码 属性值
     */
    public String getStoragenumber() {
        return storagenumber;
    }
    	
    /**
     * @param storagenumber 设置 车库编码 属性值为参数值 storagenumber
     */
    public void setStoragenumber(String storagenumber) {
        this.storagenumber = storagenumber;
    }
    
    /**
     * @return 获取 车库规模 属性值
     */
    public Double getStoragesize() {
        return storagesize;
    }
    	
    /**
     * @param storagesize 设置 车库规模 属性值为参数值 storagesize
     */
    public void setStoragesize(Double storagesize) {
        this.storagesize = storagesize;
    }
    
    /**
     * @return 获取 树形id 属性值
     */
    public String getTreeId() {
        return treeId;
    }
    	
    /**
     * @param treeId 设置 树形id 属性值为参数值 treeId
     */
    public void setTreeId(String treeId) {
        this.treeId = treeId;
    }
    
    /**
     * @return 获取 树形父节点 属性值
     */
    public String getTreeParentId() {
        return treeParentId;
    }
    	
    /**
     * @param treeParentId 设置 树形父节点 属性值为参数值 treeParentId
     */
    public void setTreeParentId(String treeParentId) {
        this.treeParentId = treeParentId;
    }
    
    /**
     * @return 获取 树形级别 属性值
     */
    public Integer getTreeLevel() {
        return treeLevel;
    }
    	
    /**
     * @param treeLevel 设置 树形级别 属性值为参数值 treeLevel
     */
    public void setTreeLevel(Integer treeLevel) {
        this.treeLevel = treeLevel;
    }
    
    /**
     * @return 获取 状态 属性值
     */
    public String getStatus() {
        return status;
    }
    	
    /**
     * @param status 设置 状态 属性值为参数值 status
     */
    public void setStatus(String status) {
        this.status = status;
    }
    
	 
    /**
     * 获取主键值
     * @return 主键值
     */
    @Override
    public String getPrimaryValue(){
    		return  this.id;
    }
}