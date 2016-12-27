/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.model;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 实体关系VO
 * 
 * @author 章尊志
 * @since 1.0
 * @version 2014-9-17 章尊志
 */
@DataTransferObject
public class EntityRelationshipVO extends BaseMetadata {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 关联关系的Id */
    private String relationId;
    
    /** 中间实体VOId */
    private String associateEntityId;
    
    /** 中间实体VO中的对应SourceVO的Id */
    private String associateSourceField;
    
    /** 中间实体VO中的对应TargetVO的Id */
    private String associateTargetField;
    
    /** 关系中文名称 */
    private String chName;
    
    /** 关系描述 */
    private String description;
    
    /** 关系英文名称 */
    private String engName;
    
    /** 实体多重性 {@link com.comtop.cap.bm.metadata.entity.model.RelatioMultiple} */
    private String multiple;
    
    /** 源实体字段 */
    private String sourceField;
    
    /** 源实体Id */
    private String sourceEntityId;
    
    /** 目标表主键 */
    private String targetField;
    
    /** 目标实体Id */
    private String targetEntityId;
    
    /**
     * @return 获取 relationId属性值
     */
    public String getRelationId() {
        return relationId;
    }
    
    /**
     * @param relationId 设置 relationId 属性值为参数值 relationId
     */
    public void setRelationId(String relationId) {
        this.relationId = relationId;
    }
    
    /**
     * @return 获取 chName属性值
     */
    public String getChName() {
        return chName;
    }
    
    /**
     * @param chName 设置 chName 属性值为参数值 chName
     */
    public void setChName(String chName) {
        this.chName = chName;
    }
    
    /**
     * @return 获取 description属性值
     */
    public String getDescription() {
        return description;
    }
    
    /**
     * @param description 设置 description 属性值为参数值 description
     */
    public void setDescription(String description) {
        this.description = description;
    }
    
    /**
     * @return 获取 engName属性值
     */
    public String getEngName() {
        return engName;
    }
    
    /**
     * @param engName 设置 engName 属性值为参数值 engName
     */
    public void setEngName(String engName) {
        this.engName = engName;
    }
    
    /**
     * @return 获取 multiple属性值
     */
    public String getMultiple() {
        return multiple;
    }
    
    /**
     * @param multiple 设置 multiple 属性值为参数值 multiple
     */
    public void setMultiple(String multiple) {
        this.multiple = multiple;
    }
    
    /**
     * @return 获取 sourceField属性值
     */
    public String getSourceField() {
        return sourceField;
    }
    
    /**
     * @param sourceField 设置 sourceField 属性值为参数值 sourceField
     */
    public void setSourceField(String sourceField) {
        this.sourceField = sourceField;
    }
    
    /**
     * @return 获取 targetEntityId属性值
     */
    public String getTargetEntityId() {
        return targetEntityId;
    }
    
    /**
     * @param targetEntityId 设置 targetEntityId 属性值为参数值 targetEntityId
     */
    public void setTargetEntityId(String targetEntityId) {
        this.targetEntityId = targetEntityId;
    }
    
    /**
     * @return 获取 targetField属性值
     */
    public String getTargetField() {
        return targetField;
    }
    
    /**
     * @param targetField 设置 targetField 属性值为参数值 targetField
     */
    public void setTargetField(String targetField) {
        this.targetField = targetField;
    }
    
    /**
     * @return 获取 associateEntityId属性值
     */
    public String getAssociateEntityId() {
        return associateEntityId;
    }
    
    /**
     * @param associateEntityId 设置 associateEntityId 属性值为参数值 associateEntityId
     */
    public void setAssociateEntityId(String associateEntityId) {
        this.associateEntityId = associateEntityId;
    }
    
    /**
     * @return 获取 associateSourceField属性值
     */
    public String getAssociateSourceField() {
        return associateSourceField;
    }
    
    /**
     * @param associateSourceField 设置 associateSourceField 属性值为参数值 associateSourceField
     */
    public void setAssociateSourceField(String associateSourceField) {
        this.associateSourceField = associateSourceField;
    }
    
    /**
     * @return 获取 associateTargetField属性值
     */
    public String getAssociateTargetField() {
        return associateTargetField;
    }
    
    /**
     * @param associateTargetField 设置 associateTargetField 属性值为参数值 associateTargetField
     */
    public void setAssociateTargetField(String associateTargetField) {
        this.associateTargetField = associateTargetField;
    }
    
    /**
     * @return the sourceEntityId
     */
    public String getSourceEntityId() {
        return sourceEntityId;
    }
    
    /**
     * @param sourceEntityId the sourceEntityId to set
     */
    public void setSourceEntityId(String sourceEntityId) {
        this.sourceEntityId = sourceEntityId;
    }
}
