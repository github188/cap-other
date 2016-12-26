/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.budget.model;

import com.comtop.cap.runtime.base.model.CapBaseVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;
import javax.persistence.Table;
import javax.persistence.Column;
import javax.persistence.Id;


/**
 * 职位
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-10-8 CAP超级管理员
 */
@Table(name = "T_PM_POSITION")
@DataTransferObject
public class PositionVO extends CapBaseVO {

    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 主键 */
    @Id
    @Column(name = "ID",length=50,precision=0)
    private String id;
    
    /** 职位名称 */
    @Column(name = "NAME",length=50,precision=0)
    private String name;
    
    /** 用户id */
    @Column(name = "USER_ID",length=50,precision=0)
    private String userId;
    
    /** 薪水 */
    @Column(name = "SALARY",precision=2)
    private Double salary;
    
    /** 职位级别 */
    @Column(name = "POSITION_LEVEL",precision=0)
    private Integer positionLevel;
    
	
    /**
     * @return 获取 主键 属性值
     */
    public String getId() {
        return id;
    }
    	
    /**
     * @param id 设置 主键 属性值为参数值 id
     */
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 职位名称 属性值
     */
    public String getName() {
        return name;
    }
    	
    /**
     * @param name 设置 职位名称 属性值为参数值 name
     */
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * @return 获取 用户id 属性值
     */
    public String getUserId() {
        return userId;
    }
    	
    /**
     * @param userId 设置 用户id 属性值为参数值 userId
     */
    public void setUserId(String userId) {
        this.userId = userId;
    }
    
    /**
     * @return 获取 薪水 属性值
     */
    public Double getSalary() {
        return salary;
    }
    	
    /**
     * @param salary 设置 薪水 属性值为参数值 salary
     */
    public void setSalary(Double salary) {
        this.salary = salary;
    }
    
    /**
     * @return 获取 职位级别 属性值
     */
    public Integer getPositionLevel() {
        return positionLevel;
    }
    	
    /**
     * @param positionLevel 设置 职位级别 属性值为参数值 positionLevel
     */
    public void setPositionLevel(Integer positionLevel) {
        this.positionLevel = positionLevel;
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