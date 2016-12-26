/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.definition.model;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.persistence.Id;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlTransient;
import javax.xml.bind.annotation.XmlType;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 步骤分组
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年6月22日 lizhongwen
 */
@XmlType(name = "group")
@DataTransferObject
public class StepGroup extends BaseMetadata {
    
    /** 添加序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 编码 */
    @Id
    private String code;
    
    /** 名称 */
    private String name;
    
    /** 图标 */
    private String icon;
    
    /** 步骤 */
    private List<StepDefinition> steps;
    
    /** 步骤Map */
    private Map<String, StepDefinition> stepMap;
    
    /**
     * 构造函数
     */
    public StepGroup() {
        this.stepMap = new HashMap<String, StepDefinition>();
    }
    
    /**
     * @return 获取 code属性值
     */
    @XmlAttribute(name = "code")
    public String getCode() {
        return code;
    }
    
    /**
     * @param code 设置 code 属性值为参数值 code
     */
    public void setCode(String code) {
        this.code = code;
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
     * @return 获取 icon属性值
     */
    @XmlAttribute(name = "icon")
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
     * @return 获取 steps属性值
     */
    @XmlTransient
    public List<StepDefinition> getSteps() {
        return steps;
    }
    
    /**
     * @param steps 设置 steps 属性值为参数值 steps
     */
    public void setSteps(List<StepDefinition> steps) {
        this.steps = steps;
        this.resetStepMap(steps);
    }
    
    /**
     * 重置StepMap
     * 
     * @param newSteps 新的步骤集合
     *
     */
    private void resetStepMap(List<StepDefinition> newSteps) {
        if (newSteps == null) {
            this.stepMap = null;
            return;
        }
        this.stepMap = new HashMap<String, StepDefinition>();
        for (StepDefinition step : newSteps) {
            if (step == null) {
                continue;
            }
            this.stepMap.put(step.getModelId(), step);
        }
    }
    
    /**
     * 添加步骤
     * 
     * @param step 步骤
     */
    public void addStep(StepDefinition step) {
        if (this.steps == null) {
            this.steps = new LinkedList<StepDefinition>();
            this.resetStepMap(steps);
        }
        if (this.stepMap.containsKey(step.getModelId())) {
            StepDefinition existed = this.stepMap.get(step.getModelId());
            this.steps.remove(existed);
            this.stepMap.remove(step.getModelId());
        }
        this.steps.add(step);
        this.stepMap.put(step.getModelId(), step);
    }
    
    /**
     * 添加步骤
     * 
     * @param step 步骤
     */
    public void removeStep(StepDefinition step) {
        if (this.steps == null) {
            return;
        }
        if (this.stepMap.containsKey(step.getModelId())) {
            StepDefinition existed = this.stepMap.get(step.getModelId());
            this.steps.remove(existed);
            this.stepMap.remove(step.getModelId());
        }
    }
    
    /**
     * @return 获取节点Id
     */
    @XmlTransient
    public String getModelId() {
        return this.code;
    }
    
}
