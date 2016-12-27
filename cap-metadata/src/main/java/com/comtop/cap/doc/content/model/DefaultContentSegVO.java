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
 * 缺省的文本内容片段
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-24 李小芬
 */
@DataTransferObject
@Table(name = "CAP_DOC_DEFAULT_CONTENT_SEG")
public class DefaultContentSegVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 流水号 */
    @Id
    @Column(name = "ID", length = 40)
    private String id;
    
    /** 索引关键字 */
    @Column(name = "KEY", length = 256, unique = true)
    private String key;
    
    /** 值 */
    @Column(name = "VALUE", length = 4000)
    private String value;
    
    /** 文档类型 */
    @Column(name = "DOC_TYPE", length = 40)
    private String docType;
    
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
     * @return 获取 key属性值
     */
    public String getKey() {
        return key;
    }
    
    /**
     * @param key 设置 key 属性值为参数值 key
     */
    public void setKey(String key) {
        this.key = key;
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
     * @return 获取 docType属性值
     */
    public String getDocType() {
        return docType;
    }
    
    /**
     * @param docType 设置 docType 属性值为参数值 docType
     */
    public void setDocType(String docType) {
        this.docType = docType;
    }
    
}
