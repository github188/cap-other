/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel;

import java.util.HashMap;
import java.util.Map;

/**
 * MS Office Word 2007以上版本主要属性
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年10月15日 lizhongwen
 */
public class DocxProperties {
    
    /** 属性集 */
    private Map<String, String> properties;
    
    /**
     * 构造函数
     */
    public DocxProperties() {
        this.properties = new HashMap<String, String>();
    }
    
    /**
     * @return 获取 创建者
     */
    public String getCreator() {
        return this.properties.get("creator");
    }
    
    /**
     * @param creator 设置 创建者为参数值 creator
     */
    public void setCreator(String creator) {
        this.properties.put("creator", creator);
    }
    
    /**
     * @return 获取 标题
     */
    public String getTitle() {
        return this.properties.get("title");
    }
    
    /**
     * @param title 设置 标题为参数值 title
     */
    public void setTitle(String title) {
        this.properties.put("title", title);
    }
    
    /**
     * @return 获取 关键字
     */
    public String getKeywords() {
        return this.properties.get("keywords");
    }
    
    /**
     * @param keywords 设置关键字为参数值 keywords
     */
    public void setKeywords(String keywords) {
        this.properties.put("keywords", keywords);
    }
    
    /**
     * @return 获取 类别
     */
    public String getCategory() {
        return this.properties.get("category");
    }
    
    /**
     * @param category 设置 类别为参数值 category
     */
    public void setCategory(String category) {
        this.properties.put("category", category);
    }
    
    /**
     * @return 获取主题
     */
    public String getSubject() {
        return this.properties.get("subject");
    }
    
    /**
     * @param subject 设置 主题为参数值 subject
     */
    public void setSubject(String subject) {
        this.properties.put("subject", subject);
    }
    
    /**
     * @return 获取备注
     */
    public String getDescription() {
        return this.properties.get("description");
    }
    
    /**
     * @param description 设置 备注为参数值 description
     */
    public void setDescription(String description) {
        this.properties.put("description", description);
    }
    
    /**
     * @return 获取 最后修改者
     */
    public String getLastModifiedBy() {
        return this.properties.get("lastModifiedBy");
    }
    
    /**
     * @param lastModifiedBy 设置 最后修改者为参数值 lastModifiedBy
     */
    public void setLastModifiedBy(String lastModifiedBy) {
        this.properties.put("lastModifiedBy", lastModifiedBy);
    }
    
    /**
     * @return 获取 内容状态
     */
    public String getContentStatus() {
        return this.properties.get("contentStatus");
    }
    
    /**
     * @param contentStatus 设置 内容状态为参数值 contentStatus
     */
    public void setContentStatus(String contentStatus) {
        this.properties.put("contentStatus", contentStatus);
    }
    
    /**
     * @return 获取公司
     */
    public String getCompany() {
        return this.properties.get("company");
    }
    
    /**
     * @param company 设置 公司为参数值 company
     */
    public void setCompany(String company) {
        this.properties.put("company", company);
    }
    
    /**
     * @return 获取属性值集合
     */
    public Map<String, String> getProperties() {
        return properties;
    }
}
