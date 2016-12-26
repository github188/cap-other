/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.report.domain;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlType;
import javax.xml.bind.annotation.XmlValue;

/**
 * 统计
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年9月6日 lizhongwen
 */
@XmlType(name = "stat")
public class Stat {
    
    /** Id */
    private String id;
    
    /** 用例名称 */
    private String name;
    
    /** 通过个数 */
    private Integer pass;
    
    /** 失败个数 */
    private Integer fail;
    
    /** 显示名称 */
    private String label;
    
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
     * @return 获取 pass属性值
     */
    @XmlAttribute(name = "pass")
    public Integer getPass() {
        return pass;
    }
    
    /**
     * @param pass 设置 pass 属性值为参数值 pass
     */
    public void setPass(Integer pass) {
        this.pass = pass;
    }
    
    /**
     * @return 获取 fail属性值
     */
    @XmlAttribute(name = "fail")
    public Integer getFail() {
        return fail;
    }
    
    /**
     * @param fail 设置 fail 属性值为参数值 fail
     */
    public void setFail(Integer fail) {
        this.fail = fail;
    }
    
    /**
     * @return 获取 label属性值
     */
    @XmlValue
    public String getLabel() {
        return label;
    }
    
    /**
     * @param label 设置 label 属性值为参数值 label
     */
    public void setLabel(String label) {
        this.label = label;
    }
}
