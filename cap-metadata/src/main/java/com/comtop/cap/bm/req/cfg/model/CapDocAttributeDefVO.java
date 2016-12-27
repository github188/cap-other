/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.cfg.model;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.top.core.base.model.CoreVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 需求对象元素
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-9-11 姜子豪
 */
@DataTransferObject
@Table(name = "CAP_DOC_ATTRIBUTE_DEF")
public class CapDocAttributeDefVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 主键 */
    @Id
    @Column(name = "ID", length = 32)
    private String id;
    
    /** 所属类型URI */
    @Column(name = "CLASS_URI", length = 40)
    private String classUri;
    
    /** 统一资源标识，全局唯一 */
    @Column(name = "URI", length = 80)
    private String uri;
    
    /** 元素名英文（）如：sys_target;系统目标 */
    @Column(name = "NAME", length = 50)
    private String engName;
    
    /** 元素中文名 */
    @Column(name = "CH_NAME", length = 100)
    private String chName;
    
    /** 编码表达式 */
    @Column(name = "CODE_EXP", length = 50)
    private String codeExp;
    
    /** 值类型 */
    @Column(name = "VALUE_TYPE", length = 10)
    private String valueType;
    
    /** 属性类型。区分属性是扩展属性还是固定表结构上的数据 */
    @Column(name = "ATTRIBUTE_TYPE", length = 10)
    private String attributeType;
    
    /** 该属性对应的字段名 */
    @Column(name = "COLUMN_NAME", length = 30)
    private String columnName;
    
    /** 描述 */
    @Column(name = "REMARK", length = 500)
    private String remark;
    
    /** 元素控件类型 Editor，Textarea，Input，PullDown，RadioGroup */
    @Column(name = "ELEMENT_TYPE", length = 50)
    private String elementType;
    
    /**
     * @return 获取 主键属性值
     */
    
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置 主键属性值为参数值 id
     */
    
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 元素名英文（）如：sys_target;系统目标属性值
     */
    
    public String getEngName() {
        return engName;
    }
    
    /**
     * @param engName 设置 元素名英文（）如：sys_target;系统目标属性值为参数值 engName
     */
    
    public void setEngName(String engName) {
        this.engName = engName;
    }
    
    /**
     * @return 获取 元素中文名属性值
     */
    
    public String getChName() {
        return chName;
    }
    
    /**
     * @param chName 设置 元素中文名属性值为参数值 chName
     */
    
    public void setChName(String chName) {
        this.chName = chName;
    }
    
    /**
     * @return 获取 元素控件类型 Editor，Textarea，Input，PullDown，RadioGroup属性值
     */
    
    public String getElementType() {
        return elementType;
    }
    
    /**
     * @param elementType 设置 元素控件类型 Editor，Textarea，Input，PullDown，RadioGroup属性值为参数值 elementType
     */
    
    public void setElementType(String elementType) {
        this.elementType = elementType;
    }
    
    /**
     * @return 获取编码表达式
     */
    public String getCodeExp() {
        return codeExp;
    }
    
    /**
     * @param codeExp 设置编码表达式
     */
    public void setCodeExp(String codeExp) {
        this.codeExp = codeExp;
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
     * @return 获取 uri属性值
     */
    public String getUri() {
        return uri;
    }
    
    /**
     * @param uri 设置 uri 属性值为参数值 uri
     */
    public void setUri(String uri) {
        this.uri = uri;
    }
    
    /**
     * @return 获取 valueType属性值
     */
    public String getValueType() {
        return valueType;
    }
    
    /**
     * @param valueType 设置 valueType 属性值为参数值 valueType
     */
    public void setValueType(String valueType) {
        this.valueType = valueType;
    }
    
    /**
     * @return 获取 attributeType属性值
     */
    public String getAttributeType() {
        return attributeType;
    }
    
    /**
     * @param attributeType 设置 attributeType 属性值为参数值 attributeType
     */
    public void setAttributeType(String attributeType) {
        this.attributeType = attributeType;
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
