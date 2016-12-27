/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.hld.model;

import com.comtop.cap.document.word.docmodel.data.BaseDTO;

/**
 * 实体数据项
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2016年1月4日 lizhiyong
 */
public class EntityItemDTO extends BaseDTO {
    
    /** FIXME */
    private static final long serialVersionUID = 1L;
    
    /** 表代码-表名 */
    private String dbObjectCode;
    
    /** 表名称 */
    private String dbObjectName;
    
    /** 表说明 */
    private String dbObjectDescription;
    
    /** 字段名 */
    private String fieldName;
    
    /** 字段代码 */
    private String fieldCode;
    
    /** 注释 */
    private String fieldDescription;
    
    /** 数据类型 */
    private String dataType;
    
    /** 主键 */
    private String primaryKey;
    
    /** 外键 */
    private String foreignKey;
    
    /** 非空 */
    private String allowNull;
    
    /** 是否主数据项 */
    private String mainDataItem;
    
    /** 引用编码标准 */
    private String codeStandard;
    
    /** 数据质量要求 */
    private String qualityReq;
    
    /** 对应的业务对象 */
    private String bizObjects;
    
    /** 数据项 */
    private String bizObjectDataItem;
    
    /** 实体Id */
    private String entityId;
    
    /** 实体名称 */
    private String entityName;
    
    /** 实体中文名称 */
    private String entityCnName;
    
    /** 实体编码 */
    private String entityCode;
    
    /** 约束 */
    private String constraint;
    
    /** 中文名 */
    private String cnName;
    
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
     * @return 获取 constraint属性值
     */
    public String getConstraint() {
        return constraint;
    }
    
    /**
     * @param constraint 设置 constraint 属性值为参数值 constraint
     */
    public void setConstraint(String constraint) {
        this.constraint = constraint;
    }
    
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
     * @return 获取 dbObjectCode属性值
     */
    public String getDbObjectCode() {
        return dbObjectCode;
    }
    
    /**
     * @param dbObjectCode 设置 dbObjectCode 属性值为参数值 dbObjectCode
     */
    public void setDbObjectCode(String dbObjectCode) {
        this.dbObjectCode = dbObjectCode;
    }
    
    /**
     * @return 获取 dbObjectName属性值
     */
    public String getDbObjectName() {
        return dbObjectName;
    }
    
    /**
     * @param dbObjectName 设置 dbObjectName 属性值为参数值 dbObjectName
     */
    public void setDbObjectName(String dbObjectName) {
        this.dbObjectName = dbObjectName;
    }
    
    /**
     * @return 获取 dbObjectDescription属性值
     */
    public String getDbObjectDescription() {
        return dbObjectDescription;
    }
    
    /**
     * @param dbObjectDescription 设置 dbObjectDescription 属性值为参数值 dbObjectDescription
     */
    public void setDbObjectDescription(String dbObjectDescription) {
        this.dbObjectDescription = dbObjectDescription;
    }
    
    /**
     * @return 获取 fieldName属性值
     */
    public String getFieldName() {
        return fieldName;
    }
    
    /**
     * @param fieldName 设置 fieldName 属性值为参数值 fieldName
     */
    public void setFieldName(String fieldName) {
        this.fieldName = fieldName;
    }
    
    /**
     * @return 获取 fieldCode属性值
     */
    public String getFieldCode() {
        return fieldCode;
    }
    
    /**
     * @param fieldCode 设置 fieldCode 属性值为参数值 fieldCode
     */
    public void setFieldCode(String fieldCode) {
        this.fieldCode = fieldCode;
    }
    
    /**
     * @return 获取 fieldDescription属性值
     */
    public String getFieldDescription() {
        return fieldDescription;
    }
    
    /**
     * @param fieldDescription 设置 fieldDescription 属性值为参数值 fieldDescription
     */
    public void setFieldDescription(String fieldDescription) {
        this.fieldDescription = fieldDescription;
    }
    
    /**
     * @return 获取 dataType属性值
     */
    public String getDataType() {
        return dataType;
    }
    
    /**
     * @param dataType 设置 dataType 属性值为参数值 dataType
     */
    public void setDataType(String dataType) {
        this.dataType = dataType;
    }
    
    /**
     * @return 获取 primaryKey属性值
     */
    public String getPrimaryKey() {
        return primaryKey;
    }
    
    /**
     * @param primaryKey 设置 primaryKey 属性值为参数值 primaryKey
     */
    public void setPrimaryKey(String primaryKey) {
        this.primaryKey = primaryKey;
    }
    
    /**
     * @return 获取 foreignKey属性值
     */
    public String getForeignKey() {
        return foreignKey;
    }
    
    /**
     * @param foreignKey 设置 foreignKey 属性值为参数值 foreignKey
     */
    public void setForeignKey(String foreignKey) {
        this.foreignKey = foreignKey;
    }
    
    /**
     * @return 获取 allowNull属性值
     */
    public String getAllowNull() {
        return allowNull;
    }
    
    /**
     * @param allowNull 设置 allowNull 属性值为参数值 allowNull
     */
    public void setAllowNull(String allowNull) {
        this.allowNull = allowNull;
    }
    
    /**
     * @return 获取 mainDataItem属性值
     */
    public String getMainDataItem() {
        return mainDataItem;
    }
    
    /**
     * @param mainDataItem 设置 mainDataItem 属性值为参数值 mainDataItem
     */
    public void setMainDataItem(String mainDataItem) {
        this.mainDataItem = mainDataItem;
    }
    
    /**
     * @return 获取 codeStandard属性值
     */
    public String getCodeStandard() {
        return codeStandard;
    }
    
    /**
     * @param codeStandard 设置 codeStandard 属性值为参数值 codeStandard
     */
    public void setCodeStandard(String codeStandard) {
        this.codeStandard = codeStandard;
    }
    
    /**
     * @return 获取 qualityReq属性值
     */
    public String getQualityReq() {
        return qualityReq;
    }
    
    /**
     * @param qualityReq 设置 qualityReq 属性值为参数值 qualityReq
     */
    public void setQualityReq(String qualityReq) {
        this.qualityReq = qualityReq;
    }
    
    /**
     * @return 获取 bizObjects属性值
     */
    public String getBizObjects() {
        return bizObjects;
    }
    
    /**
     * @param bizObjects 设置 bizObjects 属性值为参数值 bizObjects
     */
    public void setBizObjects(String bizObjects) {
        this.bizObjects = bizObjects;
    }
    
    /**
     * @return 获取 bizObjectDataItem属性值
     */
    public String getBizObjectDataItem() {
        return bizObjectDataItem;
    }
    
    /**
     * @param bizObjectDataItem 设置 bizObjectDataItem 属性值为参数值 bizObjectDataItem
     */
    public void setBizObjectDataItem(String bizObjectDataItem) {
        this.bizObjectDataItem = bizObjectDataItem;
    }
}
