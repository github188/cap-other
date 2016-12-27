/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.model;

import com.comtop.cap.document.word.docmodel.data.BaseDTO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 业务关联数据项DTO
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月7日 lizhiyong
 */
@DataTransferObject
public class BizRelationDataItemDTO extends BaseDTO {
    
    /** 序列号 */
    private static final long serialVersionUID = 1L;
    
    /** 数据项id */
    private String dataItemId;
    
    /** 数据项id */
    private String dataItemName;
    
    /** 关联id */
    private String relationId;
    
    /** 关联名称 */
    private String relationName;
    
    /** 业务对象名称 */
    private String objectName;
    
    /** 业务对象编码 */
    private String objectCode;
    
    /** 业务对象id */
    private String objectId;
    
    /** 业务对象名称 */
    private String objectPackageName;
    
    /** 业务对象编码 */
    private String objectPackageCode;
    
    /** 业务对象id */
    private String objectPackageId;
    
    /** 编码引用说明 */
    private String codeNote;
    
    /** 单位(譬如：亿kWh) */
    private String unit;
    
    /** 是否必填 1.是，0.否 */
    private String requried;
    
    /** 说明 */
    private String description;
    
    /**
     * @return 获取 objectPackageName属性值
     */
    public String getObjectPackageName() {
        return objectPackageName;
    }
    
    /**
     * @param objectPackageName 设置 objectPackageName 属性值为参数值 objectPackageName
     */
    public void setObjectPackageName(String objectPackageName) {
        this.objectPackageName = objectPackageName;
    }
    
    /**
     * @return 获取 objectPackageCode属性值
     */
    public String getObjectPackageCode() {
        return objectPackageCode;
    }
    
    /**
     * @param objectPackageCode 设置 objectPackageCode 属性值为参数值 objectPackageCode
     */
    public void setObjectPackageCode(String objectPackageCode) {
        this.objectPackageCode = objectPackageCode;
    }
    
    /**
     * @return 获取 objectPackageId属性值
     */
    public String getObjectPackageId() {
        return objectPackageId;
    }
    
    /**
     * @param objectPackageId 设置 objectPackageId 属性值为参数值 objectPackageId
     */
    public void setObjectPackageId(String objectPackageId) {
        this.objectPackageId = objectPackageId;
    }
    
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
     * @return 获取 relationName属性值
     */
    public String getRelationName() {
        return relationName;
    }
    
    /**
     * @param relationName 设置 relationName 属性值为参数值 relationName
     */
    public void setRelationName(String relationName) {
        this.relationName = relationName;
    }
    
    /**
     * @return 获取 dataItemId属性值
     */
    public String getDataItemId() {
        return dataItemId;
    }
    
    /**
     * @param dataItemId 设置 dataItemId 属性值为参数值 dataItemId
     */
    public void setDataItemId(String dataItemId) {
        this.dataItemId = dataItemId;
    }
    
    /**
     * @return 获取 dataItemName属性值
     */
    public String getDataItemName() {
        return dataItemName;
    }
    
    /**
     * @param dataItemName 设置 dataItemName 属性值为参数值 dataItemName
     */
    public void setDataItemName(String dataItemName) {
        this.dataItemName = dataItemName;
    }
    
    /**
     * @return 获取 objectName属性值
     */
    public String getObjectName() {
        return objectName;
    }
    
    /**
     * @param objectName 设置 objectName 属性值为参数值 objectName
     */
    public void setObjectName(String objectName) {
        this.objectName = objectName;
    }
    
    /**
     * @return 获取 objectCode属性值
     */
    public String getObjectCode() {
        return objectCode;
    }
    
    /**
     * @param objectCode 设置 objectCode 属性值为参数值 objectCode
     */
    public void setObjectCode(String objectCode) {
        this.objectCode = objectCode;
    }
    
    /**
     * @return 获取 objectId属性值
     */
    public String getObjectId() {
        return objectId;
    }
    
    /**
     * @param objectId 设置 objectId 属性值为参数值 objectId
     */
    public void setObjectId(String objectId) {
        this.objectId = objectId;
    }
    
    /**
     * @return 获取 codeNote属性值
     */
    public String getCodeNote() {
        return codeNote;
    }
    
    /**
     * @param codeNote 设置 codeNote 属性值为参数值 codeNote
     */
    public void setCodeNote(String codeNote) {
        this.codeNote = codeNote;
    }
    
    /**
     * @return 获取 unit属性值
     */
    public String getUnit() {
        return unit;
    }
    
    /**
     * @param unit 设置 unit 属性值为参数值 unit
     */
    public void setUnit(String unit) {
        this.unit = unit;
    }
    
    /**
     * @return 获取 requried属性值
     */
    public String getRequried() {
        return requried;
    }
    
    /**
     * @param requried 设置 requried 属性值为参数值 requried
     */
    public void setRequried(String requried) {
        this.requried = requried;
    }
    
    /**
     * @return 获取 description属性值
     */
    @Override
    public String getDescription() {
        return description;
    }
    
    /**
     * @param description 设置 description 属性值为参数值 description
     */
    @Override
    public void setDescription(String description) {
        this.description = description;
    }
    
}
