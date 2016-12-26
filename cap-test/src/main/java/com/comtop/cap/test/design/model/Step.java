/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.design.model;

import java.util.LinkedList;
import java.util.List;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlTransient;
import javax.xml.bind.annotation.XmlType;

import com.comtop.cap.test.definition.model.StepReference;
import com.comtop.cap.test.definition.model.StepType;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 用例步骤
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年6月23日 lizhongwen
 */
@XmlType(name = "step")
@DataTransferObject
public class Step extends Node {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 步骤名称 */
    private String name;
    
    /** 步骤类型 */
    private StepType type;
    
    /** 步骤定义 */
    private StepReference reference;
    
    /** 连线 */
    private List<Line> lines;
    
    /** 描述 */
    private String description;
    
    /** 是否包含自定义步骤 */
    private Boolean containCustomizedStep = Boolean.FALSE;
    
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
     * @return 获取 type属性值
     */
    @XmlAttribute(name = "type")
    public StepType getType() {
        return type;
    }
    
    /**
     * @param type 设置 type 属性值为参数值 type
     */
    public void setType(StepType type) {
        this.type = type;
    }
    
    /**
     * @return 获取 reference属性值
     */
    @XmlElement(name = "step-ref")
    public StepReference getReference() {
        return reference;
    }
    
    /**
     * @param reference 设置 reference 属性值为参数值 reference
     */
    public void setReference(StepReference reference) {
        this.reference = reference;
        if (this.reference != null && this.reference.getContainCustomizedStep()) {
            this.containCustomizedStep = Boolean.TRUE;
        }
    }
    
    /**
     * @return 获取 lines属性值
     */
    @XmlElement(name = "line")
    public List<Line> getLines() {
        return lines;
    }
    
    /**
     * @param lines 设置 lines 属性值为参数值 lines
     */
    public void setLines(List<Line> lines) {
        this.lines = lines;
    }
    
    /**
     * @param line 连线
     */
    public void addLine(Line line) {
        if (this.lines == null) {
            this.lines = new LinkedList<Line>();
        }
        this.lines.add(line);
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
    
    /**
     * @return 获取 containCustomizedStep属性值
     */
    @XmlTransient
    public Boolean getContainCustomizedStep() {
        if (this.reference != null && this.reference.getContainCustomizedStep()) {
            this.containCustomizedStep = Boolean.TRUE;
        }
        return containCustomizedStep;
    }
    
}
