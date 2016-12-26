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
import javax.xml.bind.annotation.XmlType;

/**
 * 测试套件
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年9月6日 lizhongwen
 */
@XmlType(name = "suite")
public class Suite {
    
    /** 用例ID */
    private String id;
    
    /** 用例脚本目录/文件 */
    private String source;
    
    /** 用例名称 */
    private String name;
    
    /** 子测试用例套件 */
    private List<Suite> suties;
    
    /** 测试执行状态 */
    private Status status;
    
    /** 测试用例 */
    private List<Test> tests;
    
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
     * @return 获取 source属性值
     */
    @XmlAttribute(name = "source")
    public String getSource() {
        return source;
    }
    
    /**
     * @param source 设置 source 属性值为参数值 source
     */
    public void setSource(String source) {
        this.source = source;
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
     * @return 获取 tests属性值
     */
    @XmlElement(name = "test")
    public List<Test> getTests() {
        return tests;
    }
    
    /**
     * @param tests 设置 tests 属性值为参数值 tests
     */
    public void setTests(List<Test> tests) {
        this.tests = tests;
    }
}
