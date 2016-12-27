/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.req.func.model;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.top.core.base.model.CoreVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;


/**
 * 功能分布
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-25 CAP
 */
@DataTransferObject
@Table(name = "CAP_REQ_FUNCTION_DISTRIBUTED")
public class ReqFunctionDistributedVO extends CoreVO  {
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    /** 流水ID */
    @Id
    @Column(name = "ID",length=40)
    private String id;
	
    /** 功能项ID */
    @Column(name = "ITEM_ID",length=40)
    private String itemId;
	
    /** 层级编码 */
    @Column(name = "LEVEL_CODE",length=40)
    private String levelCode;
	
    /** 分布关系 */
    @Column(name = "RELATION",precision=1)
    private Integer relation;
	
    /** 数据来源，1：导入；0：系统创建； */
    @Column(name = "DATA_FROM",precision=1)
    private Integer dataFrom;
	
    /** 文档ID */
    @Column(name = "DOCUMENT_ID",length=40)
    private String documentId;
	

	
    /**
     * @return 获取 流水ID属性值
     */
    
    public String getId() {
        return id;
    }
    	
    /**
     * @param id 设置 流水ID属性值为参数值 id
     */
    
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 功能项ID属性值
     */
    
    public String getItemId() {
        return itemId;
    }
    	
    /**
     * @param itemId 设置 功能项ID属性值为参数值 itemId
     */
    
    public void setItemId(String itemId) {
        this.itemId = itemId;
    }
    
    /**
     * @return 获取 层级编码属性值
     */
    
    public String getLevelCode() {
        return levelCode;
    }
    	
    /**
     * @param levelCode 设置 层级编码属性值为参数值 levelCode
     */
    
    public void setLevelCode(String levelCode) {
        this.levelCode = levelCode;
    }
    
    /**
     * @return 获取 分布关系属性值
     */
    
    public Integer getRelation() {
        return relation;
    }
    	
    /**
     * @param relation 设置 分布关系属性值为参数值 relation
     */
    
    public void setRelation(Integer relation) {
        this.relation = relation;
    }
    
    /**
     * @return 获取 数据来源，1：导入；0：系统创建；属性值
     */
    
    public Integer getDataFrom() {
        return dataFrom;
    }
    	
    /**
     * @param dataFrom 设置 数据来源，1：导入；0：系统创建；属性值为参数值 dataFrom
     */
    
    public void setDataFrom(Integer dataFrom) {
        this.dataFrom = dataFrom;
    }
    
    /**
     * @return 获取 文档ID属性值
     */
    
    public String getDocumentId() {
        return documentId;
    }
    	
    /**
     * @param documentId 设置 文档ID属性值为参数值 documentId
     */
    
    public void setDocumentId(String documentId) {
        this.documentId = documentId;
    }

	@Override
	public String toString() {
		return "ReqFunctionDistributedVO [id=" + id + ", itemId=" + itemId
				+ ", levelCode=" + levelCode + ", relation=" + relation
				+ ", dataFrom=" + dataFrom + ", documentId=" + documentId + "]";
	}
    
    
}