/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.soareg.model;

/**
 * 用于soa注册时使用 ，作为公共基础的VO对象
 * 
 * @author 林玉千
 * @since jdk1.6
 * @version 2016-6-28 林玉千
 */
public class SoaBaseVO {
    
    /** 对象英文名称 */
    private String engName;
    
    /** 关联的流程Id */
    private String processId;
    
    /** 对象别名 */
    private String aliasName;
    
    /** 模型包 */
    private String modelPackage;
    
    /** 模型ID */
    private String modelId;
    
    /** 实体类型 */
    private String entityType;
    
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
     * @return 获取 processId属性值
     */
    public String getProcessId() {
        return processId;
    }
    
    /**
     * @param processId 设置 processId 属性值为参数值 processId
     */
    public void setProcessId(String processId) {
        this.processId = processId;
    }
    
    /**
     * @return 获取 aliasName属性值
     */
    public String getAliasName() {
        return aliasName;
    }
    
    /**
     * @param aliasName 设置 aliasName 属性值为参数值 aliasName
     */
    public void setAliasName(String aliasName) {
        this.aliasName = aliasName;
    }
    
    /**
     * @return 获取 modelPackage属性值
     */
    public String getModelPackage() {
        return modelPackage;
    }
    
    /**
     * @param modelPackage 设置 modelPackage 属性值为参数值 modelPackage
     */
    public void setModelPackage(String modelPackage) {
        this.modelPackage = modelPackage;
    }
    
    /**
     * @return 获取 modelId属性值
     */
    public String getModelId() {
        return modelId;
    }
    
    /**
     * @param modelId 设置 modelId 属性值为参数值 modelId
     */
    public void setModelId(String modelId) {
        this.modelId = modelId;
    }
    
    /**
     * @return 获取 entityType属性值
     */
    public String getEntityType() {
        return entityType;
    }
    
    /**
     * @param entityType 设置 entityType 属性值为参数值 entityType
     */
    public void setEntityType(String entityType) {
        this.entityType = entityType;
    }
    
}
