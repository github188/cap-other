/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.meeting.model;

import com.comtop.cap.runtime.base.model.CapBaseVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;
import javax.persistence.Table;
import javax.persistence.Column;
import com.comtop.cap.runtime.base.annotation.DefaultValue;
import javax.persistence.Id;
import java.sql.Timestamp;


/**
 * 个人(测试表)
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-5-30 CAP超级管理员
 */
@Table(name = "TEST_PERSON")
@DataTransferObject
public class TestPersonVO extends CapBaseVO {

    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 主键Id */
    @Id
    @Column(name = "ID",length=36,precision=0)
    private String id;
    
    /** 姓名 */
    @Column(name = "NAME",length=30,precision=0)
    private String name;
    
    /** 地址 */
    @Column(name = "ADRESS",length=100,precision=0)
    private String adress;
    
    /** 性别 */
    @Column(name = "SEX",precision=0)
    private Integer sex;
    
    /** 电话 */
    @Column(name = "PHONE",length=20,precision=0)
    private String phone;
    
    /** 生日 */
    @Column(name = "BIRTHDAY",precision=6)
    @DefaultValue(value="SYSDATE")
    private Timestamp birthday;
    
    /** 薪水 */
    @Column(name = "SALARY",precision=10)
    private Double salary;
    
    /** 流程状态 */
    @Column(name = "FLOW_STATE",precision=0)
    @DefaultValue(value="0")
    private Integer flowState;
    
    /** 流程实例Id */
    @Column(name = "PROCESS_INS_ID",length=64,precision=0)
    private String processInsId;
    
	
    /**
     * @return 获取 主键Id 属性值
     */
    public String getId() {
        return id;
    }
    	
    /**
     * @param id 设置 主键Id 属性值为参数值 id
     */
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 姓名 属性值
     */
    public String getName() {
        return name;
    }
    	
    /**
     * @param name 设置 姓名 属性值为参数值 name
     */
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * @return 获取 地址 属性值
     */
    public String getAdress() {
        return adress;
    }
    	
    /**
     * @param adress 设置 地址 属性值为参数值 adress
     */
    public void setAdress(String adress) {
        this.adress = adress;
    }
    
    /**
     * @return 获取 性别 属性值
     */
    public Integer getSex() {
        return sex;
    }
    	
    /**
     * @param sex 设置 性别 属性值为参数值 sex
     */
    public void setSex(Integer sex) {
        this.sex = sex;
    }
    
    /**
     * @return 获取 电话 属性值
     */
    public String getPhone() {
        return phone;
    }
    	
    /**
     * @param phone 设置 电话 属性值为参数值 phone
     */
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    /**
     * @return 获取 生日 属性值
     */
    public Timestamp getBirthday() {
        return birthday;
    }
    	
    /**
     * @param birthday 设置 生日 属性值为参数值 birthday
     */
    public void setBirthday(Timestamp birthday) {
        this.birthday = birthday;
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
     * @return 获取 流程状态 属性值
     */
    public Integer getFlowState() {
        return flowState;
    }
    	
    /**
     * @param flowState 设置 流程状态 属性值为参数值 flowState
     */
    public void setFlowState(Integer flowState) {
        this.flowState = flowState;
    }
    
    /**
     * @return 获取 流程实例Id 属性值
     */
    public String getProcessInsId() {
        return processInsId;
    }
    	
    /**
     * @param processInsId 设置 流程实例Id 属性值为参数值 processInsId
     */
    public void setProcessInsId(String processInsId) {
        this.processInsId = processInsId;
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