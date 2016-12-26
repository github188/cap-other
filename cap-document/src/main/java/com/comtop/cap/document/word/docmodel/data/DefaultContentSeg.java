/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.data;


/**
 * 默认的内容片段
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2016年1月14日 lizhiyong
 */
public class DefaultContentSeg extends BaseDTO {
    
    /** 序列号 */
    private static final long serialVersionUID = 1L;
    
    /** 索引关键字 */
    private String key;
    
    /** 文档类型 */
    private String docType = "Common";
    
    /** 值 */
    private String value;
    
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
    
}
