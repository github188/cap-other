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
 * 数据库对象参数
 * 
 * 如存储过程的IN\OUT参数，函数的IN\OUT参数及返回值等
 *
 * @author 凌晨
 * @since jdk1.6
 * @version 2015年10月8日 凌晨
 */
@DataTransferObject
public class DBObjectParam extends BaseMetadata {
    
    /** 序列化版本号 */
    private static final long serialVersionUID = 1L;
    
    /** 参数名称 */
    private String paramName;
    
    /** 参数中文名称 */
    private String paramChName;
    
    /** 参数值 */
    private String value;
    
    /**
     * 参数的数据类型,如：VARCHAR2\CLOB\BLOB\TIMESTAMP等 {@link com.comtop.cap.bm.metadata.entity.model.OracleFieldType}
     */
    private String paramType;
    
    /** 参数种类{@link com.comtop.cap.bm.metadata.entity.model.ParamCategory} */
    private String paramCategory;
    
    /** 参数传值方式,如：常量、方法参数等 {@link com.comtop.cap.bm.metadata.entity.model.TransferValPattern} */
    private String transferValPattern;
    
    /**
     * @return 获取 paramName属性值
     */
    public String getParamName() {
        return paramName;
    }
    
    /**
     * @param paramName 设置 paramName 属性值为参数值 paramName
     */
    public void setParamName(String paramName) {
        this.paramName = paramName;
    }
    
    /**
     * @return 获取 value属性值
     */
    public String getValue() {
        return value;
    }
    
    /**
     * @param value 设置 value 属性值为参数值 value
     */
    public void setValue(String value) {
        this.value = value;
    }
    
    /**
     * @return 获取 paramType属性值
     */
    public String getParamType() {
        return paramType;
    }
    
    /**
     * @param paramType 设置 paramType 属性值为参数值 paramType
     */
    public void setParamType(String paramType) {
        this.paramType = paramType;
    }
    
    /**
     * @return 获取 paramCategory属性值
     */
    public String getParamCategory() {
        return paramCategory;
    }
    
    /**
     * @param paramCategory 设置 paramCategory 属性值为参数值 paramCategory
     */
    public void setParamCategory(String paramCategory) {
        this.paramCategory = paramCategory;
    }
    
    /**
     * @return 获取 transferValPattern属性值
     */
    public String getTransferValPattern() {
        return transferValPattern;
    }
    
    /**
     * @param transferValPattern 设置 transferValPattern 属性值为参数值 transferValPattern
     */
    public void setTransferValPattern(String transferValPattern) {
        this.transferValPattern = transferValPattern;
    }
    
    /**
     * @return 获取 paramChName属性值
     */
    public String getParamChName() {
        return paramChName;
    }
    
    /**
     * @param paramChName 设置 paramChName 属性值为参数值 paramChName
     */
    public void setParamChName(String paramChName) {
        this.paramChName = paramChName;
    }
    
}
