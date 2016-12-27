/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.model;

import java.util.regex.Pattern;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.document.word.docmodel.data.BaseDTO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 业务对象数据项DTO
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-10 李志勇
 */
@DataTransferObject
public class DataItemDTO extends BaseDTO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 业务对象基本信息表ID */
    private String objectName;
    
    /** 业务对象基本信息表ID */
    private String objectCode;
    
    /** 对象包id */
    private String objectPackageId;
    
    /** 对象包对象包名称 */
    private String objectPackageName;
    
    /** 编码引用说明 */
    private String codeNote;
    
    /** 单位(譬如：亿kWh) */
    private String unit;
    
    /** 是否必填 1.是，0.否 */
    private String requried;
    
    /** 类型 指的是业务表单数据项或业务对象数据项，一般用不上 */
    private String type;
    
    /** 数据项所属对象类型 */
    private String objectType;
    
    /** 数据项所属对象类型 */
    private String objectId;
    
    /** 字段必填描述样式 */
    private static final Pattern PATTERN_REQUIRED = Pattern.compile("是|必填|不为空|非空");
    
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
        if (StringUtils.isNumeric(requried)) {
            int value = Integer.parseInt(requried);
            if (value > 0) {
                this.requried = "是";
            } else {
                this.requried = "否";
            }
            return;
        }
        this.requried = requried;
    }
    
    /**
     * @return 获取 编码引用说明属性值
     */
    
    public String getCodeNote() {
        return codeNote;
    }
    
    /**
     * @param codeNote 设置 编码引用说明属性值为参数值 codeNote
     */
    
    public void setCodeNote(String codeNote) {
        this.codeNote = codeNote;
    }
    
    /**
     * @return 获取 type属性值
     */
    public String getType() {
        return type;
    }
    
    /**
     * @param type 设置 type 属性值为参数值 type
     */
    public void setType(String type) {
        this.type = type;
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
     * @return 获取 objectType属性值
     */
    public String getObjectType() {
        return objectType;
    }
    
    /**
     * @param objectType 设置 objectType 属性值为参数值 objectType
     */
    public void setObjectType(String objectType) {
        this.objectType = objectType;
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
     * FIXME 方法注释信息
     *
     * @return 获得整型的必填值
     */
    public int getIntRequired() {
        if (StringUtils.isBlank(this.requried)) {
            return 0;
        }
        if (PATTERN_REQUIRED.matcher(this.requried).find()) {
            return 1;
        }
        return 0;
    }
    
    /**
     * 设置是否必填
     *
     * @param intRequired 1 是 0 否
     */
    public void setIntRequired(Integer intRequired) {
        if (intRequired != null && intRequired > 0) {
            this.requried = "是";
        }
    }
}
