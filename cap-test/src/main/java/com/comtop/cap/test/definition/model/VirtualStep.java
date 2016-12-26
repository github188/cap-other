/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.definition.model;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlSeeAlso;
import javax.xml.bind.annotation.XmlTransient;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;

/**
 * 虚步骤
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年8月10日 lizhongwen
 */
@XmlSeeAlso({ StepAggregation.class, StepReference.class })
public abstract class VirtualStep extends BaseMetadata {
    
    /** 名称 ，用于定义步骤集的名称，主要区分步骤集之间的不同功用 */
    private String name;
    
    /** 描述，用于描述步骤集的功用，方便用户明确该步骤集的含义 */
    private String description;
    
    /**
     * @return 获取 name属性值
     */
    @XmlTransient
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
     * @return 获取 description属性值
     */
    @XmlAttribute(name = "desc")
    public String getDescription() {
        return description;
    }
    
    /**
     * @param description 设置 description 属性值为参数值 description
     */
    public void setDescription(String description) {
        this.description = description;
    }
}
