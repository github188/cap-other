/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.definition.model;

import java.util.LinkedList;
import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import com.comtop.cap.bm.metadata.base.model.BaseModel;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 步骤分组聚合
 * 注意：步骤分组的层次为： 步骤类型（基本、组合或者最佳实践）/分组。目前只实现两层，只能在步骤类型下添加分组，不支持在分组下再添加分组
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年6月24日 lizhongwen
 */
@DataTransferObject
@XmlRootElement(name = "step-groups")
public class StepGroups extends BaseModel {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 步骤按类型分组集合 */
    private List<StepGroup> groups;
    
    /**
     * @return 获取 groups属性值
     */
    @XmlElement(name = "group")
    public List<StepGroup> getGroups() {
        return groups;
    }
    
    /**
     * @param groups 设置 groups 属性值为参数值 groups
     */
    public void setGroups(List<StepGroup> groups) {
        this.groups = groups;
    }
    
    /**
     * @param group 添加步骤分组
     */
    public void addGroup(StepGroup group) {
        if (this.groups == null) {
            this.groups = new LinkedList<StepGroup>();
        }
        StepGroup existed = this.findGroupByCode(group.getCode());
        if (existed != null) {
            existed.setName(group.getName());
            existed.setIcon(group.getIcon());
        } else {
            this.groups.add(group);
        }
    }
    
    /**
     * @param code 根据编码删除步骤分组
     */
    public void removeGroup(String code) {
        StepGroup group = this.findGroupByCode(code);
        if (group != null) {
            this.groups.remove(group);
        }
    }
    
    /**
     * 根据编码获取步骤分组
     *
     * @param code 编码
     * @return 步骤分组
     */
    public StepGroup findGroupByCode(String code) {
        if (this.groups == null) {
            return null;
        }
        for (StepGroup group : groups) {
            if (code.equals(group.getCode())) {
                return group;
            }
        }
        return null;
    }
    
    /**
     * 
     * @see com.comtop.cap.bm.metadata.base.model.BaseModel#getModelId()
     */
    @Override
    public String getModelId() {
        return this.getModelPackage() + "." + this.getModelType() + "." + this.getModelName();
    }
    
    /**
     * 
     * @see com.comtop.cap.bm.metadata.base.model.BaseModel#getModelPackage()
     */
    @Override
    public String getModelPackage() {
        return "testStepDefinitions";
    }
    
    /**
     * 
     * @see com.comtop.cap.bm.metadata.base.model.BaseModel#getModelName()
     */
    @Override
    public String getModelName() {
        return "step_groups";
    }
    
    /**
     * 
     * @see com.comtop.cap.bm.metadata.base.model.BaseModel#getModelType()
     */
    @Override
    public String getModelType() {
        return "group";
    }
    
    /**
     * @see com.comtop.cap.bm.metadata.base.model.BaseModel#getCreateTime()
     */
    @Override
    public long getCreateTime() {
        return super.getCreateTime() == 0 ? System.currentTimeMillis() : super.getCreateTime();
    }
}
