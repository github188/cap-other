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
 * 功能项关联业务事项
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-12-10 CAP
 */
@DataTransferObject
@Table(name = "CAP_REQ_FUNCTION_REL_ITEMS")
public class ReqFunctionRelItemsVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 流水ID */
    @Id
    @Column(name = "ID", length = 40)
    private String id;
    
    /** 业务事项ID */
    @Column(name = "BIZ_ITEMS_ID", length = 40)
    private String bizItemsId;
    
    /** 功能项ID */
    @Column(name = "FUNCTION_ID", length = 40)
    private String functionId;
    
    /** 业务事项名称 */
    private String bizItemName;
    
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
     * @return 获取 业务事项ID属性值
     */
    
    public String getBizItemsId() {
        return bizItemsId;
    }
    
    /**
     * @param bizItemsId 设置 业务事项ID属性值为参数值 bizItemsId
     */
    
    public void setBizItemsId(String bizItemsId) {
        this.bizItemsId = bizItemsId;
    }
    
    /**
     * @return 获取 功能项ID属性值
     */
    
    public String getFunctionId() {
        return functionId;
    }
    
    /**
     * @param functionId 设置 功能项ID属性值为参数值 functionId
     */
    
    public void setFunctionId(String functionId) {
        this.functionId = functionId;
    }
    
    /**
     * @return 获取 bizItemName属性值
     */
    public String getBizItemName() {
        return bizItemName;
    }
    
    /**
     * @param bizItemName 设置 bizItemName 属性值为参数值 bizItemName
     */
    public void setBizItemName(String bizItemName) {
        this.bizItemName = bizItemName;
    }
    
}
