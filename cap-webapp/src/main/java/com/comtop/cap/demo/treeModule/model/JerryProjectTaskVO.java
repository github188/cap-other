/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.demo.treeModule.model;

import com.comtop.cap.runtime.base.model.CapBaseVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;
import javax.persistence.Table;
import javax.persistence.Column;
import javax.persistence.Id;
import java.sql.Timestamp;


/**
 * JerryProjectTask
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-6-14 CAP超级管理员
 */
@Table(name = "OMS_DEMO_JERRY_PROJECT_TASK")
@DataTransferObject
public class JerryProjectTaskVO extends CapBaseVO {

    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** id */
    @Id
    @Column(name = "ID",length=32,precision=0)
    private String id;
    
    /** name */
    @Column(name = "NAME",length=256,precision=0)
    private String name;
    
    /** taskType */
    @Column(name = "TASK_TYPE",length=10,precision=0)
    private String taskType;
    
    /** taskPrior */
    @Column(name = "TASK_PRIOR",length=10,precision=0)
    private String taskPrior;
    
    /** startTime */
    @Column(name = "START_TIME",precision=0)
    private Timestamp startTime;
    
    /** endTime */
    @Column(name = "END_TIME",precision=0)
    private Timestamp endTime;
    
    /** remark */
    @Column(name = "REMARK",length=256,precision=0)
    private String remark;
    
    /** projectId */
    @Column(name = "PROJECT_ID",length=32,precision=0)
    private String projectId;
    
    /** principalId */
    @Column(name = "PRINCIPAL_ID",length=32,precision=0)
    private String principalId;
    
    /** principalName */
    @Column(name = "PRINCIPAL_NAME",length=32,precision=0)
    private String principalName;
    
	
    /**
     * @return 获取 id 属性值
     */
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
     * @return 获取 name 属性值
     */
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
     * @return 获取 taskType 属性值
     */
    public String getTaskType() {
        return taskType;
    }
    	
    /**
     * @param taskType 设置 taskType 属性值为参数值 taskType
     */
    public void setTaskType(String taskType) {
        this.taskType = taskType;
    }
    
    /**
     * @return 获取 taskPrior 属性值
     */
    public String getTaskPrior() {
        return taskPrior;
    }
    	
    /**
     * @param taskPrior 设置 taskPrior 属性值为参数值 taskPrior
     */
    public void setTaskPrior(String taskPrior) {
        this.taskPrior = taskPrior;
    }
    
    /**
     * @return 获取 startTime 属性值
     */
    public Timestamp getStartTime() {
        return startTime;
    }
    	
    /**
     * @param startTime 设置 startTime 属性值为参数值 startTime
     */
    public void setStartTime(Timestamp startTime) {
        this.startTime = startTime;
    }
    
    /**
     * @return 获取 endTime 属性值
     */
    public Timestamp getEndTime() {
        return endTime;
    }
    	
    /**
     * @param endTime 设置 endTime 属性值为参数值 endTime
     */
    public void setEndTime(Timestamp endTime) {
        this.endTime = endTime;
    }
    
    /**
     * @return 获取 remark 属性值
     */
    public String getRemark() {
        return remark;
    }
    	
    /**
     * @param remark 设置 remark 属性值为参数值 remark
     */
    public void setRemark(String remark) {
        this.remark = remark;
    }
    
    /**
     * @return 获取 projectId 属性值
     */
    public String getProjectId() {
        return projectId;
    }
    	
    /**
     * @param projectId 设置 projectId 属性值为参数值 projectId
     */
    public void setProjectId(String projectId) {
        this.projectId = projectId;
    }
    
    /**
     * @return 获取 principalId 属性值
     */
    public String getPrincipalId() {
        return principalId;
    }
    	
    /**
     * @param principalId 设置 principalId 属性值为参数值 principalId
     */
    public void setPrincipalId(String principalId) {
        this.principalId = principalId;
    }
    
    /**
     * @return 获取 principalName 属性值
     */
    public String getPrincipalName() {
        return principalName;
    }
    	
    /**
     * @param principalName 设置 principalName 属性值为参数值 principalName
     */
    public void setPrincipalName(String principalName) {
        this.principalName = principalName;
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