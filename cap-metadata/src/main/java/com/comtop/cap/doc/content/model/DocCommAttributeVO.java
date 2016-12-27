/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.content.model;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.top.core.base.model.CoreVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 模型对象属性实例。如果扩展的模型对象没有独立的存储结构，则对象本身存储在CAP_DOC_COMM_OBJECT表中，对象属性存储在此表中
 * 
 * @author 李小芬
 * @since 1.0
 * @version 2015-11-12 李小芬
 */
@DataTransferObject
@Table(name = "CAP_DOC_COMM_ATTRIBUTE")
public class DocCommAttributeVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 模型对象实例。如果扩展的模型对象没有独立,由CIP自动创建。 */
    private DocCommObjectVO docCommObjectByReattri;
    
    /** 流水号 */
    @Id
    @Column(name = "ID", length = 40)
    private String id;
    
    /** 所属对象定义URI */
    @Column(name = "CLASS_URI", length = 40)
    private String classUri;
    
    /** 属性定义URI */
    @Column(name = "ATTRIBUTE_URI", length = 80)
    private String attributeUri;
    
    /** 对象流水号 */
    @Column(name = "OBJECT_ID", length = 40)
    private String objectId;
    
    /**
     * 值类型.用于判断value的值从哪里获得。
     * 简单值（Simple）：value字段的值就是最终值。简单值可以再分类，比如字符串、数字等。
     * 文本值（text）：从文本内容表中获取,value字段存储该表的
     * 图片值(graphic)：从图片内容表中获取，value字段存储该表的id
     * 嵌入式对象值(embed)：从嵌入式对象内容中获取，value字段存储该表的id
     */
    @Column(name = "VALUE_TYPE", length = 10)
    private String valueType;
    
    /** 值 */
    @Column(name = "VALUE", length = 256)
    private String value;
    
    /**
     * @return 获取 模型对象实例。如果扩展的模型对象没有独立,由CIP自动创建。属性值
     */
    
    public DocCommObjectVO getDocCommObjectByReattri() {
        return docCommObjectByReattri;
    }
    
    /**
     * @param docCommObjectByReattri 设置 模型对象实例。如果扩展的模型对象没有独立,由CIP自动创建。属性值为参数值 docCommObjectByReattri
     */
    
    public void setDocCommObjectByReattri(DocCommObjectVO docCommObjectByReattri) {
        this.docCommObjectByReattri = docCommObjectByReattri;
    }
    
    /**
     * @return 获取 流水号属性值
     */
    
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置 流水号属性值为参数值 id
     */
    
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 所属对象定义URI属性值
     */
    
    public String getClassUri() {
        return classUri;
    }
    
    /**
     * @param classUri 设置 所属对象定义URI属性值为参数值 classUri
     */
    
    public void setClassUri(String classUri) {
        this.classUri = classUri;
    }
    
    /**
     * @return 获取 属性定义URI属性值
     */
    
    public String getAttributeUri() {
        return attributeUri;
    }
    
    /**
     * @param attributeUri 设置 属性定义URI属性值为参数值 attributeUri
     */
    
    public void setAttributeUri(String attributeUri) {
        this.attributeUri = attributeUri;
    }
    
    /**
     * @return 获取 对象流水号属性值
     */
    
    public String getObjectId() {
        return objectId;
    }
    
    /**
     * @param objectId 设置 对象流水号属性值为参数值 objectId
     */
    
    public void setObjectId(String objectId) {
        this.objectId = objectId;
    }
    
    /**
     * @return 获取 值类型.用于判断value的值从哪里获得。
     *         简单值（Simple）：value字段的值就是最终值。简单值可以再分类，比如字符串、数字等。
     *         文本值（text）：从文本内容表中获取,value字段存储该表的
     *         图片值(graphic)：从图片内容表中获取，value字段存储该表的id
     *         嵌入式对象值(embed)：从嵌入式对象内容中获取，value字段存储该表的id属性值
     */
    
    public String getValueType() {
        return valueType;
    }
    
    /**
     * @param valueType 设置 值类型.用于判断value的值从哪里获得。
     *            简单值（Simple）：value字段的值就是最终值。简单值可以再分类，比如字符串、数字等。
     *            文本值（text）：从文本内容表中获取,value字段存储该表的
     *            图片值(graphic)：从图片内容表中获取，value字段存储该表的id
     *            嵌入式对象值(embed)：从嵌入式对象内容中获取，value字段存储该表的id属性值为参数值 valueType
     */
    
    public void setValueType(String valueType) {
        this.valueType = valueType;
    }
    
    /**
     * @return 获取 值属性值
     */
    
    public String getValue() {
        return value;
    }
    
    /**
     * @param value 设置 值属性值为参数值 value
     */
    
    public void setValue(String value) {
        this.value = value;
    }
    
}
