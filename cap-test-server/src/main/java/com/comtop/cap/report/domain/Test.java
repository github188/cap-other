/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.report.domain;

import java.util.List;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.XmlType;

/**
 * 用例
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年9月6日 lizhongwen
 */
@XmlType(name = "test")
public class Test {
    
    /** 用例Id */
    private String id;
    
    /** 用例名称 */
    private String name;
    
    /** 测试状态 */
    private Status status;
    
    /** 关键字 */
    private List<Keyword> keywords;
    
    /** 标签 */
    private List<TextValue> tags;
    
    /**
     * @return 获取 id属性值
     */
    @XmlAttribute(name = "id")
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
    @XmlAttribute(name = "name")
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
     * @return 获取 status属性值
     */
    @XmlElement(name = "status")
    public Status getStatus() {
        return status;
    }
    
    /**
     * @param status 设置 status 属性值为参数值 status
     */
    public void setStatus(Status status) {
        this.status = status;
    }
    
    /**
     * @return 获取 keywords属性值
     */
    @XmlElement(name = "kw")
    public List<Keyword> getKeywords() {
        return keywords;
    }
    
    /**
     * @param keywords 设置 keywords 属性值为参数值 keywords
     */
    public void setKeywords(List<Keyword> keywords) {
        this.keywords = keywords;
    }
    
    /**
     * @return 获取 tags属性值
     */
    @XmlElementWrapper(name = "tags")
    @XmlElement(name = "tag")
    public List<TextValue> getTags() {
        return tags;
    }
    
    /**
     * @param tags 设置 tags 属性值为参数值 tags
     */
    public void setTags(List<TextValue> tags) {
        this.tags = tags;
    }
}
