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
import javax.xml.bind.annotation.XmlElements;
import javax.xml.bind.annotation.XmlRootElement;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 最佳实践
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年6月23日 lizhongwen
 */
@XmlRootElement(name = "practice")
@DataTransferObject
public class Practice extends StepDefinition {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 映射，如果是界面功能的话，则应该表示该测试用例对应的是哪个行为，如果是 后台API的话，则映射该最佳实践对应哪个方法 */
    private String mapping;
    
    /** 最佳实践类型 */
    private PracticeType practiceType;
    
    /** 步骤集 */
    private List<VirtualStep> steps;
    
    /** 实现类 */
    private String impl;
    
    /**
     * @return 获取 mapping属性值
     */
    @XmlAttribute(name = "mapping")
    public String getMapping() {
        return mapping;
    }
    
    /**
     * @param mapping 设置 mapping 属性值为参数值 mapping
     */
    public void setMapping(String mapping) {
        this.mapping = mapping;
    }
    
    /**
     * @return 获取 practiceType属性值
     */
    @XmlAttribute(name = "practiceType")
    public PracticeType getPracticeType() {
        return practiceType;
    }
    
    /**
     * @param practiceType 设置 practiceType 属性值为参数值 practiceType
     */
    public void setPracticeType(PracticeType practiceType) {
        this.practiceType = practiceType;
    }
    
    /**
     * @return 获取 steps属性值
     */
    @XmlElements({ @XmlElement(name = "step-ref", type = StepReference.class),
        @XmlElement(name = "aggregation", type = StepAggregation.class) })
    public List<VirtualStep> getSteps() {
        return steps;
    }
    
    /**
     * @param steps 设置 steps 属性值为参数值 steps
     */
    public void setSteps(List<VirtualStep> steps) {
        this.steps = steps;
    }
    
    /**
     * 添加步骤
     *
     * @param step 步骤
     */
    public void addStep(VirtualStep step) {
        if (this.steps == null) {
            this.steps = new LinkedList<VirtualStep>();
        }
        this.steps.add(step);
    }
    
    /**
     * @return 获取 impl属性值
     */
    @XmlElement(name = "impl")
    public String getImpl() {
        return impl;
    }
    
    /**
     * @param impl 设置 impl 属性值为参数值 impl
     */
    public void setImpl(String impl) {
        this.impl = impl;
    }
    
    /**
     * @see com.comtop.cap.test.definition.model.StepDefinition#getStepType()
     */
    @Override
    public StepType getStepType() {
        return StepType.PRACTICE;
    }
}
