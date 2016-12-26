/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.demo.treeModule.model;

import com.comtop.cap.runtime.base.model.CapWorkflowVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;
import javax.persistence.Table;
import javax.persistence.Column;
import com.comtop.cap.runtime.base.annotation.AssociateAttribute;
import com.comtop.cap.runtime.base.annotation.DefaultValue;
import java.util.List;
import javax.persistence.Id;
import java.sql.Timestamp;
import com.comtop.cap.demo.treeModule.model.JerryProjectTaskVO;


/**
 * 项目
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-6-14 CAP超级管理员
 */
@Table(name = "OMS_DEMO_JERRY_PROJECT")
@DataTransferObject
public class JerryProjectVO extends CapWorkflowVO {

    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 流水号 */
    @Id
    @Column(name = "ID",length=32,precision=0)
    private String id;
    
    /** 流程实例ID */
    @Column(name = "PROCESS_INS_ID",length=64,precision=0)
    private String processInsId;
    
    /** 状态 */
    @Column(name = "FLOW_STATE",precision=0)
    @DefaultValue(value="0")
    private Integer flowState;
    
    /** 创建者ID */
    @Column(name = "CREATOR_ID",length=32,precision=0)
    private String creatorId;
    
    /** 创建者姓名 */
    @Column(name = "CREATOR_NAME",length=32,precision=0)
    private String creatorName;
    
    /** 项目名称 */
    @Column(name = "NAME",length=256,precision=0)
    private String name;
    
    /** 项目描述 */
    @Column(name = "DESCRIPTION",length=4000,precision=0)
    private String description;
    
    /** 项目预算 */
    @Column(name = "BUDGET",precision=0)
    private Integer budget;
    
    /** 项目类型 */
    @Column(name = "PROJECT_TYPE",length=32,precision=0)
    private String projectType;
    
    /** 计划开始日期 */
    @Column(name = "PLAN_START_DATE",precision=0)
    private Timestamp planStartDate;
    
    /** 计划结束日期 */
    @Column(name = "PLAN_END_DATE",precision=0)
    private Timestamp planEndDate;
    
    /** 项目编码 */
    @Column(name = "CODE",length=32,precision=0)
    private String code;
    
    /** 项目来源 */
    @Column(name = "PROJECT_SOURCE",length=32,precision=0)
    private String projectSource;
    
    /** 建设单位id */
    @Column(name = "CONSTRUCTION_UNIT_ID",length=32,precision=0)
    private String constructionUnitId;
    
    /** 建设单位名称 */
    @Column(name = "CONSTRUCTION_UNIT_NAME",length=32,precision=0)
    private String constructionUnitName;
    
    /** tasks */
    @AssociateAttribute(multiple = "One-Many", associateFieldName = "projectId")
    private List<JerryProjectTaskVO> relationTasks;
    
	
    /**
     * @return 获取 流水号 属性值
     */
    public String getId() {
        return id;
    }
    	
    /**
     * @param id 设置 流水号 属性值为参数值 id
     */
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 流程实例ID 属性值
     */
    @Override
    public String getProcessInsId() {
        return processInsId;
    }
    	
    /**
     * @param processInsId 设置 流程实例ID 属性值为参数值 processInsId
     */
    @Override
    public void setProcessInsId(String processInsId) {
        this.processInsId = processInsId;
    }
    
    /**
     * @return 获取 状态 属性值
     */
    @Override
    public Integer getFlowState() {
        return flowState;
    }
    	
    /**
     * @param flowState 设置 状态 属性值为参数值 flowState
     */
    @Override
    public void setFlowState(Integer flowState) {
        this.flowState = flowState;
    }
    
    /**
     * @return 获取 创建者ID 属性值
     */
    public String getCreatorId() {
        return creatorId;
    }
    	
    /**
     * @param creatorId 设置 创建者ID 属性值为参数值 creatorId
     */
    public void setCreatorId(String creatorId) {
        this.creatorId = creatorId;
    }
    
    /**
     * @return 获取 创建者姓名 属性值
     */
    public String getCreatorName() {
        return creatorName;
    }
    	
    /**
     * @param creatorName 设置 创建者姓名 属性值为参数值 creatorName
     */
    public void setCreatorName(String creatorName) {
        this.creatorName = creatorName;
    }
    
    /**
     * @return 获取 项目名称 属性值
     */
    public String getName() {
        return name;
    }
    	
    /**
     * @param name 设置 项目名称 属性值为参数值 name
     */
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * @return 获取 项目描述 属性值
     */
    public String getDescription() {
        return description;
    }
    	
    /**
     * @param description 设置 项目描述 属性值为参数值 description
     */
    public void setDescription(String description) {
        this.description = description;
    }
    
    /**
     * @return 获取 项目预算 属性值
     */
    public Integer getBudget() {
        return budget;
    }
    	
    /**
     * @param budget 设置 项目预算 属性值为参数值 budget
     */
    public void setBudget(Integer budget) {
        this.budget = budget;
    }
    
    /**
     * @return 获取 项目类型 属性值
     */
    public String getProjectType() {
        return projectType;
    }
    	
    /**
     * @param projectType 设置 项目类型 属性值为参数值 projectType
     */
    public void setProjectType(String projectType) {
        this.projectType = projectType;
    }
    
    /**
     * @return 获取 计划开始日期 属性值
     */
    public Timestamp getPlanStartDate() {
        return planStartDate;
    }
    	
    /**
     * @param planStartDate 设置 计划开始日期 属性值为参数值 planStartDate
     */
    public void setPlanStartDate(Timestamp planStartDate) {
        this.planStartDate = planStartDate;
    }
    
    /**
     * @return 获取 计划结束日期 属性值
     */
    public Timestamp getPlanEndDate() {
        return planEndDate;
    }
    	
    /**
     * @param planEndDate 设置 计划结束日期 属性值为参数值 planEndDate
     */
    public void setPlanEndDate(Timestamp planEndDate) {
        this.planEndDate = planEndDate;
    }
    
    /**
     * @return 获取 项目编码 属性值
     */
    public String getCode() {
        return code;
    }
    	
    /**
     * @param code 设置 项目编码 属性值为参数值 code
     */
    public void setCode(String code) {
        this.code = code;
    }
    
    /**
     * @return 获取 项目来源 属性值
     */
    public String getProjectSource() {
        return projectSource;
    }
    	
    /**
     * @param projectSource 设置 项目来源 属性值为参数值 projectSource
     */
    public void setProjectSource(String projectSource) {
        this.projectSource = projectSource;
    }
    
    /**
     * @return 获取 建设单位id 属性值
     */
    public String getConstructionUnitId() {
        return constructionUnitId;
    }
    	
    /**
     * @param constructionUnitId 设置 建设单位id 属性值为参数值 constructionUnitId
     */
    public void setConstructionUnitId(String constructionUnitId) {
        this.constructionUnitId = constructionUnitId;
    }
    
    /**
     * @return 获取 建设单位名称 属性值
     */
    public String getConstructionUnitName() {
        return constructionUnitName;
    }
    	
    /**
     * @param constructionUnitName 设置 建设单位名称 属性值为参数值 constructionUnitName
     */
    public void setConstructionUnitName(String constructionUnitName) {
        this.constructionUnitName = constructionUnitName;
    }
    
    /**
     * @return 获取 tasks 属性值
     */
    public List<JerryProjectTaskVO> getRelationTasks() {
        return relationTasks;
    }
    	
    /**
     * @param relationTasks 设置 tasks 属性值为参数值 relationTasks
     */
    public void setRelationTasks(List<JerryProjectTaskVO> relationTasks) {
        this.relationTasks = relationTasks;
    }
    
	 
    /**
     * 获取主键值
     * @return 主键值
     */
    @Override
    public String getPrimaryValue(){
    		return  this.id;
    }
}