/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.design.model;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlType;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 连线
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年6月23日 lizhongwen
 */
@XmlType(name = "line")
@DataTransferObject
public class Line extends Node {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 起点 */
    private String form;
    
    /** 终点Id */
    private String to;
    
    /**
     * @return 获取 form属性值
     */
    @XmlAttribute(name = "from")
    public String getForm() {
        return form;
    }
    
    /**
     * @param form 设置 form 属性值为参数值 form
     */
    public void setForm(String form) {
        this.form = form;
    }
    
    /**
     * @return 获取 to属性值
     */
    @XmlAttribute(name = "to")
    public String getTo() {
        return to;
    }
    
    /**
     * @param to 设置 to 属性值为参数值 to
     */
    public void setTo(String to) {
        this.to = to;
    }
    
}
