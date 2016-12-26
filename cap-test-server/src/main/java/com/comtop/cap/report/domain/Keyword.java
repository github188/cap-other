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
 * 关键字
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年9月6日 lizhongwen
 */
@XmlType(name = "kw")
public class Keyword {
    
    /** 名称 */
    private String name;
    
    /** 引用库 */
    private String library;
    
    /** 文档 */
    private TextValue doc;
    
    /** 参数 */
    private List<TextValue> arguments;
    
    /** 消息 */
    private Message message;
    
    /** 状态 */
    private Status status;
    
    /** 子关键字 */
    private List<Keyword> keywords;
    
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
     * @return 获取 library属性值
     */
    @XmlAttribute(name = "library")
    public String getLibrary() {
        return library;
    }
    
    /**
     * @param library 设置 library 属性值为参数值 library
     */
    public void setLibrary(String library) {
        this.library = library;
    }
    
    /**
     * @return 获取 doc属性值
     */
    @XmlElement(name = "doc")
    public TextValue getDoc() {
        return doc;
    }
    
    /**
     * @param doc 设置 doc 属性值为参数值 doc
     */
    public void setDoc(TextValue doc) {
        this.doc = doc;
    }
    
    /**
     * @return 获取 arguments属性值
     */
    @XmlElementWrapper(name = "arguments")
    @XmlElement(name = "arg")
    public List<TextValue> getArguments() {
        return arguments;
    }
    
    /**
     * @param arguments 设置 arguments 属性值为参数值 arguments
     */
    public void setArguments(List<TextValue> arguments) {
        this.arguments = arguments;
    }
    
    /**
     * @return 获取 message属性值
     */
    @XmlElement(name = "msg")
    public Message getMessage() {
        return message;
    }
    
    /**
     * @param message 设置 message 属性值为参数值 message
     */
    public void setMessage(Message message) {
        this.message = message;
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
}
