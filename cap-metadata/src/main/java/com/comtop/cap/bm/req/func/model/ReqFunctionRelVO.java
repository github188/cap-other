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
 * 功能项关系表
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-12-15 CAP
 */
@DataTransferObject
@Table(name = "CAP_REQ_FUNCTION_REL")
public class ReqFunctionRelVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 流水ID */
    @Id
    @Column(name = "ID", length = 40)
    private String id;
    
    /** 功能项ID */
    @Column(name = "FUNCTION_ITEM_ID", length = 40)
    private String functionItemId;
    
    /** 关联功能项ID */
    @Column(name = "RE_FUNTION_ITEM_ID", length = 40)
    private String reFuntionItemId;
    
    /** 关系标识 */
    @Column(name = "NAME", length = 80)
    private String name;
    
    /** 说明 */
    @Column(name = "REMARK", length = 500)
    private String remark;
    
    /** 来源业务关联，存储业务事项ID */
    @Column(name = "BIZ_ITEMS_IDS", length = 4000)
    private String bizItemIds;
    
    /** 关联功能项名称 */
    private String reFuntionItemName;
    
    /** 来源业务关联名称 */
    private String bizItemNames;
    
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
    
    public String getFunctionItemId() {
        return functionItemId;
    }
    
    /**
     * @param functionItemId 设置 功能项ID属性值为参数值 functionItemId
     */
    
    public void setFunctionItemId(String functionItemId) {
        this.functionItemId = functionItemId;
    }
    
    /**
     * @return 获取 关联功能项ID属性值
     */
    
    public String getReFuntionItemId() {
        return reFuntionItemId;
    }
    
    /**
     * @param reFuntionItemId 设置 关联功能项ID属性值为参数值 reFuntionItemId
     */
    
    public void setReFuntionItemId(String reFuntionItemId) {
        this.reFuntionItemId = reFuntionItemId;
    }
    
    /**
     * @return 获取 关系标识属性值
     */
    
    public String getName() {
        return name;
    }
    
    /**
     * @param name 设置 关系标识属性值为参数值 name
     */
    
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * @return 获取 说明属性值
     */
    
    public String getRemark() {
        return remark;
    }
    
    /**
     * @param remark 设置 说明属性值为参数值 remark
     */
    
    public void setRemark(String remark) {
        this.remark = remark;
    }
    
    /**
     * @return 获取 reFuntionItemName属性值
     */
    public String getReFuntionItemName() {
        return reFuntionItemName;
    }
    
    /**
     * @param reFuntionItemName 设置 reFuntionItemName 属性值为参数值 reFuntionItemName
     */
    public void setReFuntionItemName(String reFuntionItemName) {
        this.reFuntionItemName = reFuntionItemName;
    }
    
    /**
     * @return 获取 bizItemIds属性值
     */
    public String getBizItemIds() {
        return bizItemIds;
    }
    
    /**
     * @param bizItemIds 设置 bizItemIds 属性值为参数值 bizItemIds
     */
    public void setBizItemIds(String bizItemIds) {
        this.bizItemIds = bizItemIds;
    }
    
    /**
     * @return 获取 bizItemNames属性值
     */
    public String getBizItemNames() {
        return bizItemNames;
    }
    
    /**
     * @param bizItemNames 设置 bizItemNames 属性值为参数值 bizItemNames
     */
    public void setBizItemNames(String bizItemNames) {
        this.bizItemNames = bizItemNames;
    }
    
}
