/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.report.domain;

import java.time.Instant;
import java.util.List;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;

import com.comtop.cap.report.xml.InstantAdapter;
import com.comtop.cap.report.xml.InstantSerializer;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

/**
 * 测试用例根元素
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年9月6日 lizhongwen
 */
@XmlRootElement(name = "robot")
public class Robot {
    
    /** 生成时间 */
    private Instant generated;
    
    /** 生成版本 */
    private String generator;
    
    /** 子测试用例套件 */
    private List<Suite> suties;
    
    /** 统计分析 */
    private Statistics statistics;
    
    /** 错误消息 */
    private List<Message> errors;
    
    /**
     * @return 获取 generated属性值
     */
    @XmlAttribute(name = "generated")
    @XmlJavaTypeAdapter(type = Instant.class, value = InstantAdapter.class)
    @JsonSerialize(using = InstantSerializer.class)
    public Instant getGenerated() {
        return generated;
    }
    
    /**
     * @param generated 设置 generated 属性值为参数值 generated
     */
    public void setGenerated(Instant generated) {
        this.generated = generated;
    }
    
    /**
     * @return 获取 generator属性值
     */
    @XmlAttribute(name = "generator")
    public String getGenerator() {
        return generator;
    }
    
    /**
     * @param generator 设置 generator 属性值为参数值 generator
     */
    public void setGenerator(String generator) {
        this.generator = generator;
    }
    
    /**
     * @return 获取 suties属性值
     */
    @XmlElement(name = "suite")
    public List<Suite> getSuties() {
        return suties;
    }
    
    /**
     * @param suties 设置 suties 属性值为参数值 suties
     */
    public void setSuties(List<Suite> suties) {
        this.suties = suties;
    }
    
    /**
     * @return 获取 statistics属性值
     */
    @XmlElement
    public Statistics getStatistics() {
        return statistics;
    }
    
    /**
     * @param statistics 设置 statistics 属性值为参数值 statistics
     */
    public void setStatistics(Statistics statistics) {
        this.statistics = statistics;
    }
    
    /**
     * @return 获取 errors属性值
     */
    @XmlElementWrapper(name = "errors")
    @XmlElement(name = "msg")
    public List<Message> getErrors() {
        return errors;
    }
    
    /**
     * @param errors 设置 errors 属性值为参数值 errors
     */
    public void setErrors(List<Message> errors) {
        this.errors = errors;
    }
}
