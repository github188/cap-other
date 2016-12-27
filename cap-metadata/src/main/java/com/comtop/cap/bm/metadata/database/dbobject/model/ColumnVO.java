/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.database.dbobject.model;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.bm.metadata.entity.model.CompareIgnore;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 字段VO
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015-10-08 陈志伟
 */
@DataTransferObject
public class ColumnVO extends BaseMetadata {
    
    /** 序列化ID */
    @CompareIgnore
    private static final long serialVersionUID = 4762025163898325166L;
    
    /** id */
    @CompareIgnore
    private String id;
    
    /** 编码 */
    private String code;
    
    /** 中文名称 */
    private String chName;
    
    /** 英文名称 */
    private String engName;
    
    /** 描述 */
    private String description;
    
    /** 数据类型 {@link com.comtop.cap.bm.metadata.database.dbobject.model.DataType} */
    private String dataType;
    
    /** 长度 */
    private int length;
    
    /** 精度 */
    private int precision;
    
    /** 默认值 */
    private String defaultValue;
    
    /** 是否是主键 */
    @CompareIgnore
    private boolean isPrimaryKEY;
    
    /** 是否是外键 */
    @CompareIgnore
    private boolean isForeignKey;
    
    /** 是否是唯一 */
    @CompareIgnore
    private boolean isUnique;
    
    /** 是否能为空 */
    private boolean canBeNull;
    
    /** 表编码 */
    @CompareIgnore
    private String tableCode;
    
    /**
     * @return 获取 id属性值
     */
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置 id 属性值为参数值 id
     */
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 code属性值
     */
    public String getCode() {
        return code;
    }
    
    /**
     * @param code 设置 code 属性值为参数值 code
     */
    public void setCode(String code) {
        this.code = code;
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
     * @return 获取 length属性值
     */
    public int getLength() {
        return length;
    }
    
    /**
     * @param length 设置 length 属性值为参数值 length
     */
    public void setLength(int length) {
        this.length = length;
    }
    
    /**
     * @return 获取 precision属性值
     */
    public int getPrecision() {
        return precision;
    }
    
    /**
     * @param precision 设置 precision 属性值为参数值 precision
     */
    public void setPrecision(int precision) {
        this.precision = precision;
    }
    
    /**
     * @return 获取 defaultValue属性值
     */
    public String getDefaultValue() {
        return defaultValue;
    }
    
    /**
     * @param defaultValue 设置 defaultValue 属性值为参数值 defaultValue
     */
    public void setDefaultValue(String defaultValue) {
        this.defaultValue = defaultValue;
    }
    
    /**
     * 存在默认值
     * 
     * @return true 是 ，false 否
     */
    public boolean existsDefaultValue() {
        if (null != defaultValue && defaultValue.length() > 0) {
            return true;
        }
        return false;
    }
    
    /**
     * @return 获取 isPrimaryKEY属性值
     */
    public boolean getIsPrimaryKEY() {
        return isPrimaryKEY;
    }
    
    /**
     * @param isPrimaryKEY 设置 isPrimaryKEY 属性值为参数值 isPrimaryKEY
     */
    public void setIsPrimaryKEY(boolean isPrimaryKEY) {
        this.isPrimaryKEY = isPrimaryKEY;
    }
    
    /**
     * @return 获取 isForeignKey属性值
     */
    public boolean getIsForeignKey() {
        return isForeignKey;
    }
    
    /**
     * @param isForeignKey 设置 isForeignKey 属性值为参数值 isForeignKey
     */
    public void setIsForeignKey(boolean isForeignKey) {
        this.isForeignKey = isForeignKey;
    }
    
    /**
     * @return 获取 isUnique属性值
     */
    public boolean getIsUnique() {
        return isUnique;
    }
    
    /**
     * @param isUnique 设置 isUnique 属性值为参数值 isUnique
     */
    public void setIsUnique(boolean isUnique) {
        this.isUnique = isUnique;
    }
    
    /**
     * @return 获取 canBeNull属性值
     */
    public boolean getCanBeNull() {
        return canBeNull;
    }
    
    /**
     * @param canBeNull 设置 canBeNull 属性值为参数值 canBeNull
     */
    public void setCanBeNull(boolean canBeNull) {
        this.canBeNull = canBeNull;
    }
    
    /**
     * @return 获取 tableCode属性值
     */
    public String getTableCode() {
        return tableCode;
    }
    
    /**
     * @param tableCode 设置 tableCode 属性值为参数值 tableCode
     */
    public void setTableCode(String tableCode) {
        this.tableCode = tableCode;
    }
    
    /**
     * 是否存在描述
     * 
     * @return true 是 ，false 否
     */
    public boolean existsDescription() {
        if (null != description && description.length() > 0) {
            return true;
        }
        return false;
    }
}
