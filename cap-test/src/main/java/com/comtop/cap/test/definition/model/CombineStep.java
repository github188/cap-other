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

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlTransient;

/**
 * 组合步骤
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年6月23日 lizhongwen
 */
@XmlTransient
public abstract class CombineStep extends StepDefinition {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 步骤集 */
    private List<StepReference> steps;
    
    /** 是否包含自定义步骤 */
    private Boolean containCustomizedStep = Boolean.FALSE;
    
    /** 客户化步骤 */
    private static final String[] customizedSteps = { "testStepDefinitions.basics.basic.custom_set_value",
        "testStepDefinitions.basics.basic.editgrid_custom_set_value" };
    
    /**
     * @return 获取 steps属性值
     */
    @XmlElement(name = "basic")
    public List<StepReference> getSteps() {
        return steps;
    }
    
    /**
     * @param steps 设置 steps 属性值为参数值 steps
     */
    public void setSteps(List<StepReference> steps) {
        this.steps = steps;
        if (this.steps != null) {
            for (StepReference step : steps) {
                if (Arrays.asList(customizedSteps).contains(step.getType())) {
                    containCustomizedStep = Boolean.TRUE;
                }
            }
        }
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
        if (step != null) {
            this.steps.add(step);
            if (Arrays.asList(customizedSteps).contains(step.getType())) {
                containCustomizedStep = Boolean.TRUE;
            }
        }
    }
    
    /**
     * @return 获取 containCustomizeStep属性值
     */
    @XmlTransient
    public Boolean getContainCustomizedStep() {
        if (this.steps != null) {
            for (StepReference step : steps) {
                if (Arrays.asList(customizedSteps).contains(step.getType())) {
                    containCustomizedStep = Boolean.TRUE;
                }
            }
        }
        return containCustomizedStep;
    }
}
