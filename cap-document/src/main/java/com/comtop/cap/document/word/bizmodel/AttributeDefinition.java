/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.bizmodel;

import com.comtop.cap.document.word.docmodel.datatype.AttributeType;
import com.comtop.cap.document.word.docmodel.datatype.ValueType;

/**
 * 属性定义
 * 
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月15日 lizhiyong
 */
public class AttributeDefinition implements IDefinition {
    
    /** 流水号 */
    private String id;
    
    /** 名称 */
    private String name;
    
    /** 类URI */
    private String classUri;
    
    /** 属性URI */
    private String uri;
    
    /** 中文名称 */
    private String cnName;
    
    /** 对应列名 */
    private String columnName;
    
    /** 属性URI */
    private AttributeType attributeType;
    
    /** 中文名称 */
    private ValueType valueType;
    
    /** 编码表达式 */
    private String codeExp;
    
    /** 备注 */
    private String remark;
    
    /**
     * @param uri 设置 uri 属性值为参数值 uri
     */
    public void setUri(String uri) {
        this.uri = uri;
    }
    
    @Override
    public String getUri() {
        return uri;
    }
    
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
     * @return 获取 name属性值
     */
    public String getName() {
        return name;
    }
    
    /**
     * @param name 设置 name 属性值为参数值 name
     */
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * @return 获取 classUri属性值
     */
    public String getClassUri() {
        return classUri;
    }
    
    /**
     * @param classUri 设置 classUri 属性值为参数值 classUri
     */
    public void setClassUri(String classUri) {
        this.classUri = classUri;
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
     * @return 获取 columnName属性值
     */
    public String getColumnName() {
        return columnName;
    }
    
    /**
     * @param columnName 设置 columnName 属性值为参数值 columnName
     */
    public void setColumnName(String columnName) {
        this.columnName = columnName;
    }
    
    /**
     * @return 获取 attributeType属性值
     */
    public AttributeType getAttributeType() {
        return attributeType;
    }
    
    /**
     * @param attributeType 设置 attributeType 属性值为参数值 attributeType
     */
    public void setAttributeType(AttributeType attributeType) {
        this.attributeType = attributeType;
    }
    
    /**
     * @return 获取 valueType属性值
     */
    public ValueType getValueType() {
        return valueType;
    }
    
    /**
     * @param valueType 设置 valueType 属性值为参数值 valueType
     */
    public void setValueType(ValueType valueType) {
        this.valueType = valueType;
    }
    
    /**
     * @return 获取 codeExp属性值
     */
    public String getCodeExp() {
        return codeExp;
    }
    
    /**
     * @param codeExp 设置 codeExp 属性值为参数值 codeExp
     */
    public void setCodeExp(String codeExp) {
        this.codeExp = codeExp;
    }
    
    /**
     * @return 获取 remark属性值
     */
    public String getRemark() {
        return remark;
    }
    
    /**
     * @param remark 设置 remark 属性值为参数值 remark
     */
    public void setRemark(String remark) {
        this.remark = remark;
    }
    
}
