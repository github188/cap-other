/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.bizmodel;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

/**
 * 模型对象
 * 
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月15日 lizhiyong
 */
public class ModelObject {
    
    /** 对应的模型对象定义URI */
    private String classUri;
    
    /** 对象唯一标识 */
    private String uri;
    
    /** 对象流水号 */
    private String id;
    
    /** 对象顺序号 */
    private int sortNo;
    
    /** 属性集 */
    private final Map<String, Object> attributeMap = new HashMap<String, Object>(16);
    
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
     * 添加属性
     *
     * @param attributeUri 属性URI
     * @param value 属性值
     */
    public void addAttribute(String attributeUri, Object value) {
        attributeMap.put(attributeUri, value);
    }
    
    /**
     * 添加属性
     *
     * @param valueMap 属性值集
     */
    public void addAttributes(Map<String, Object> valueMap) {
        attributeMap.putAll(valueMap);
    }
    
    @Override
    public String toString() {
        StringBuffer sb = new StringBuffer();
        sb.append(this.classUri).append("{");
        Entry<String, Object> entry = null;
        for (Iterator<Entry<String, Object>> it = attributeMap.entrySet().iterator(); it.hasNext();) {
            entry = it.next();
            sb.append(entry.getKey()).append(":").append(entry.getValue()).append("\r\n");
        }
        sb.append("}\r\n");
        
        return sb.toString();
    }
    
    /**
     * @return 获取 id属性值
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
     * @return 获取 sortNo属性值
     */
    public int getSortNo() {
        return sortNo;
    }
    
    /**
     * @param sortNo 设置 sortNo 属性值为参数值 sortNo
     */
    public void setSortNo(int sortNo) {
        this.sortNo = sortNo;
    }
    
    /**
     * @return 获取 attributeMap属性值
     */
    public Map<String, Object> getAttributeMap() {
        return attributeMap;
    }
    
}
