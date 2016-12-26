/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.uml.model;

import javax.persistence.Column;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 实体关联关系VO
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015-7-22 陈志伟
 */
@DataTransferObject
public class GraphEntityExtendVO {
    
    /** 源实体ID */
    @Column(name = "CHILD_ENTITY_ID")
    private String childEntityId;
    
    /** 目标实体ID */
    @Column(name = "PARENT_ENEITY_ID")
    private String parentEntityId;
    
    /**
     * @return 获取 childEntityId属性值
     */
    public String getChildEntityId() {
        return childEntityId;
    }
    
    /**
     * @param childEntityId 设置 childEntityId 属性值为参数值 childEntityId
     */
    public void setChildEntityId(String childEntityId) {
        this.childEntityId = childEntityId;
    }
    
    /**
     * @return 获取 parentEntityId属性值
     */
    public String getParentEntityId() {
        return parentEntityId;
    }
    
    /**
     * @param parentEntityId 设置 parentEntityId 属性值为参数值 parentEntityId
     */
    public void setParentEntityId(String parentEntityId) {
        this.parentEntityId = parentEntityId;
    }
    
}
