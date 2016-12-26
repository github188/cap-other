/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.definition.model;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 基本步骤
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年6月22日 lizhongwen
 */
@XmlRootElement(name = "basic")
@DataTransferObject
public class BasicStep extends StepDefinition {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 来源 */
    private String src;
    
    /**
     * 构造函数
     */
    public BasicStep() {
    }
    
    /**
     * @return 获取 src属性值
     */
    @XmlAttribute(name = "src")
    public String getSrc() {
        return src;
    }
    
    /**
     * @param src 设置 src 属性值为参数值 src
     */
    public void setSrc(String src) {
        this.src = src;
    }
    
    /**
     * @return 获取节点类型
     */
    @Override
    @XmlTransient
    public StepType getStepType() {
        return StepType.BASIC;
    }
}
