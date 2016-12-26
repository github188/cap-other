/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.definition.model;

import java.util.LinkedList;
import java.util.List;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 步骤集，该对象主要用于最佳实践中，用于封装具备相同功能的一组步骤。
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年8月10日 lizhongwen
 */
@XmlRootElement(name = "aggregation")
@DataTransferObject
public class StepAggregation extends VirtualStep {
    
    /** 定义,步骤集的唯一标识，在一个最佳实践中，该属性必须保证唯一性 */
    private String definition;
    
    /** 步骤集 */
    private List<StepReference> steps;
    
    /**
     * @return 获取 definition属性值
     */
    @XmlAttribute(name = "definition")
    public String getDefinition() {
        return definition;
    }
    
    /**
     * @param definition 设置 definition 属性值为参数值 definition
     */
    public void setDefinition(String definition) {
        this.definition = definition;
    }
    
    /**
     * @return 获取 steps属性值
     */
    @XmlElement(name = "step-ref")
    public List<StepReference> getSteps() {
        return steps;
    }
    
    /**
     * @param steps 设置 steps 属性值为参数值 steps
     */
    public void setSteps(List<StepReference> steps) {
        this.steps = steps;
    }
    
    /**
     * 添加步骤
     *
     * @param step 步骤
     */
    public void addStep(StepReference step) {
        if (this.steps == null) {
            this.steps = new LinkedList<StepReference>();
        }
        this.steps.add(step);
    }
}
