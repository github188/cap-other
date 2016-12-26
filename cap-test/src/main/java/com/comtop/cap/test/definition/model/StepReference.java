/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.definition.model;

import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlTransient;
import javax.xml.bind.annotation.XmlType;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 步骤引用
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年6月23日 lizhongwen
 */
@XmlType(name = "step-ref")
@DataTransferObject
public class StepReference extends VirtualStep {
    
    /** 序列化Id */
    private static final long serialVersionUID = 1L;
    
    /** 标识符 */
    private String id;
    
    /** 引用类型 */
    private String type;
    
    /** 图标，方便展示 */
    private String icon;
    
    /** 参数集 */
    private List<Argument> arguments;
    
    /** 引用步骤集合 */
    private List<StepReference> steps;
    
    /** 是否包含自定义步骤 */
    private Boolean containCustomizedStep = Boolean.FALSE;
    
    /** 客户化步骤 */
    private static final String[] customizedSteps = { "testStepDefinitions.basics.basic.custom_set_value",
        "testStepDefinitions.basics.basic.editgrid_custom_set_value" };
    
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
     * @return 获取 type属性值
     */
    @XmlAttribute(name = "type")
    public String getType() {
        return type;
    }
    
    /**
     * @param type 设置 type 属性值为参数值 type
     */
    public void setType(String type) {
        this.type = type;
        List<String> customizeds = Arrays.asList(customizedSteps);
        if (customizeds.contains(this.type)) {
            this.containCustomizedStep = Boolean.TRUE;
        }
    }
    
    /**
     * @return 获取 icon属性值
     */
    @XmlTransient
    public String getIcon() {
        return icon;
    }
    
    /**
     * @param icon 设置 icon 属性值为参数值 icon
     */
    public void setIcon(String icon) {
        this.icon = icon;
    }
    
    /**
     * @return 获取 arguments属性值
     */
    @XmlElement(name = "arg")
    public List<Argument> getArguments() {
        return arguments;
    }
    
    /**
     * @param arguments 设置 arguments 属性值为参数值 arguments
     */
    public void setArguments(List<Argument> arguments) {
        this.arguments = arguments;
    }
    
    /**
     * 添加参数
     *
     * @param argument 参数
     */
    public void addArgument(Argument argument) {
        if (this.arguments == null) {
            this.arguments = new LinkedList<Argument>();
        }
        this.arguments.add(argument);
    }
    
    /**
     * @return 获取 steps属性值
     */
    @XmlElement(name = "step")
    public List<StepReference> getSteps() {
        return steps;
    }
    
    /**
     * @param steps 设置 steps 属性值为参数值 steps
     */
    public void setSteps(List<StepReference> steps) {
        this.steps = steps;
        if (this.steps != null) {
            List<String> customizeds = Arrays.asList(customizedSteps);
            if (customizeds.contains(this.type)) {
                this.containCustomizedStep = Boolean.TRUE;
                return;
            }
            for (StepReference step : steps) {
                if (customizeds.contains(step.getType())) {
                    this.containCustomizedStep = Boolean.TRUE;
                }
            }
        }
    }
    
    /**
     * 添加步骤引用
     *
     * @param step 步骤引用
     */
    public void addStep(StepReference step) {
        if (this.steps == null) {
            this.steps = new LinkedList<StepReference>();
        }
        if (step != null) {
            this.steps.add(step);
            List<String> customizeds = Arrays.asList(customizedSteps);
            if (customizeds.contains(step.getType()) || customizeds.contains(this.type)) {
                this.containCustomizedStep = Boolean.TRUE;
            }
        }
    }
    
    /**
     * @return 获取 containCustomizeStep属性值
     */
    @XmlTransient
    public Boolean getContainCustomizedStep() {
        if (this.steps != null) {
            List<String> customizeds = Arrays.asList(customizedSteps);
            if (customizeds.contains(this.type)) {
                this.containCustomizedStep = Boolean.TRUE;
                return containCustomizedStep;
            }
            for (StepReference step : steps) {
                if (customizeds.contains(step.getType())) {
                    containCustomizedStep = Boolean.TRUE;
                }
            }
        }
        return containCustomizedStep;
    }
    
    /**
     * @param argName 根据名称查找参数
     * @return 参数对象
     */
    public Argument findAugumentByName(String argName) {
        if (this.arguments == null) {
            return null;
        }
        for (Argument argument : arguments) {
            if (argName.equals(argument.getName())) {
                return argument;
            }
        }
        return null;
    }
    
}
