/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.hld.model;

import com.comtop.cap.document.word.docmodel.data.BaseDTO;

/**
 * 数据项分布
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月30日 lizhiyong
 */
public class EntityItemDistributionDTO extends BaseDTO {
    
    /** FIXME */
    private static final long serialVersionUID = 1L;
    
    /** 系统id */
    private String systemId;
    
    /** 系统id */
    private String systemName;
    
    /** 系统id */
    private String systemCode;
    
    /** 系统id */
    private String moduleId;
    
    /** 系统id */
    private String moduleName;
    
    /** 系统id */
    private String moduleCode;
    
    /** 实体名称 */
    private String entityName;
    
    /** 实体中文名 */
    private String entityCnName;
    
    /** 实体编码 */
    private String entityCode;
    
    /** 实体id */
    private String entityId;
    
    /** 分布规则 */
    private String distributeRule;
    
    /** 中文名称 */
    private String cnName;
    
    /**
     * @return 获取 cnName属性值
     */
    public String getCnName() {
        return cnName;
    }
    
    /**
     * @param cnName 设置 cnName 属性值为参数值 cnName
     */
    public void setCnName(String cnName) {
        this.cnName = cnName;
    }
    
    /**
     * @return 获取 systemId属性值
     */
    public String getSystemId() {
        return systemId;
    }
    
    /**
     * @param systemId 设置 systemId 属性值为参数值 systemId
     */
    public void setSystemId(String systemId) {
        this.systemId = systemId;
    }
    
    /**
     * @return 获取 systemName属性值
     */
    public String getSystemName() {
        return systemName;
    }
    
    /**
     * @param systemName 设置 systemName 属性值为参数值 systemName
     */
    public void setSystemName(String systemName) {
        this.systemName = systemName;
    }
    
    /**
     * @return 获取 systemCode属性值
     */
    public String getSystemCode() {
        return systemCode;
    }
    
    /**
     * @param systemCode 设置 systemCode 属性值为参数值 systemCode
     */
    public void setSystemCode(String systemCode) {
        this.systemCode = systemCode;
    }
    
    /**
     * @return 获取 moduleId属性值
     */
    public String getModuleId() {
        return moduleId;
    }
    
    /**
     * @param moduleId 设置 moduleId 属性值为参数值 moduleId
     */
    public void setModuleId(String moduleId) {
        this.moduleId = moduleId;
    }
    
    /**
     * @return 获取 moduleName属性值
     */
    public String getModuleName() {
        return moduleName;
    }
    
    /**
     * @param moduleName 设置 moduleName 属性值为参数值 moduleName
     */
    public void setModuleName(String moduleName) {
        this.moduleName = moduleName;
    }
    
    /**
     * @return 获取 moduleCode属性值
     */
    public String getModuleCode() {
        return moduleCode;
    }
    
    /**
     * @param moduleCode 设置 moduleCode 属性值为参数值 moduleCode
     */
    public void setModuleCode(String moduleCode) {
        this.moduleCode = moduleCode;
    }
    
    /**
     * @return 获取 entityName属性值
     */
    public String getEntityName() {
        return entityName;
    }
    
    /**
     * @param entityName 设置 entityName 属性值为参数值 entityName
     */
    public void setEntityName(String entityName) {
        this.entityName = entityName;
    }
    
    /**
     * @return 获取 entityCnName属性值
     */
    public String getEntityCnName() {
        return entityCnName;
    }
    
    /**
     * @param entityCnName 设置 entityCnName 属性值为参数值 entityCnName
     */
    public void setEntityCnName(String entityCnName) {
        this.entityCnName = entityCnName;
    }
    
    /**
     * @return 获取 entityCode属性值
     */
    public String getEntityCode() {
        return entityCode;
    }
    
    /**
     * @param entityCode 设置 entityCode 属性值为参数值 entityCode
     */
    public void setEntityCode(String entityCode) {
        this.entityCode = entityCode;
    }
    
    /**
     * @return 获取 entityId属性值
     */
    public String getEntityId() {
        return entityId;
    }
    
    /**
     * @param entityId 设置 entityId 属性值为参数值 entityId
     */
    public void setEntityId(String entityId) {
        this.entityId = entityId;
    }
    
    /**
     * @return 获取 distributeRule属性值
     */
    public String getDistributeRule() {
        return distributeRule;
    }
    
    /**
     * @param distributeRule 设置 distributeRule 属性值为参数值 distributeRule
     */
    public void setDistributeRule(String distributeRule) {
        this.distributeRule = distributeRule;
    }
    
}
