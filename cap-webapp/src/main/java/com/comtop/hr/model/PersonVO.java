/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.hr.model;

import com.comtop.cap.runtime.base.model.CapBaseVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;
import javax.persistence.Table;
import javax.persistence.Column;
import javax.persistence.Id;
import java.sql.Timestamp;


/**
 * 部门员工
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-12-16 CAP超级管理员
 */
@Table(name = "T_HR_PERSON")
@DataTransferObject
public class PersonVO extends CapBaseVO {

    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 主键 */
    @Id
    @Column(name = "ID",length=36,precision=0)
    private String id;
    
    /** 人员名称 */
    @Column(name = "NAME",length=10,precision=0)
    private String name;
    
    /** 员工编码 */
    @Column(name = "NUMBER",length=20,precision=0)
    private String number;
    
    /** 员工生日 */
    @Column(name = "BIRTHDAY",precision=0)
    private Timestamp birthday;
    
    /** 住址 */
    @Column(name = "ADDRESS",length=20,precision=0)
    private String address;
    
    /** 部门id */
    @Column(name = "DEPARTMENT_ID",length=20,precision=0)
    private String departmentId;
    
    /** 职位id */
    @Column(name = "POSITION_ID",length=20,precision=0)
    private String positionId;
    
    /** 测试 */
    @Column(name = "TEST",length=65535,precision=0)
    private String test;
    
	
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
     * @return 获取 人员名称 属性值
     */
    public String getName() {
        return name;
    }
    	
    /**
     * @param name 设置 人员名称 属性值为参数值 name
     */
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * @return 获取 员工编码 属性值
     */
    public String getNumber() {
        return number;
    }
    	
    /**
     * @param number 设置 员工编码 属性值为参数值 number
     */
    public void setNumber(String number) {
        this.number = number;
    }
    
    /**
     * @return 获取 员工生日 属性值
     */
    public Timestamp getBirthday() {
        return birthday;
    }
    	
    /**
     * @param birthday 设置 员工生日 属性值为参数值 birthday
     */
    public void setBirthday(Timestamp birthday) {
        this.birthday = birthday;
    }
    
    /**
     * @return 获取 住址 属性值
     */
    public String getAddress() {
        return address;
    }
    	
    /**
     * @param address 设置 住址 属性值为参数值 address
     */
    public void setAddress(String address) {
        this.address = address;
    }
    
    /**
     * @return 获取 部门id 属性值
     */
    public String getDepartmentId() {
        return departmentId;
    }
    	
    /**
     * @param departmentId 设置 部门id 属性值为参数值 departmentId
     */
    public void setDepartmentId(String departmentId) {
        this.departmentId = departmentId;
    }
    
    /**
     * @return 获取 职位id 属性值
     */
    public String getPositionId() {
        return positionId;
    }
    	
    /**
     * @param positionId 设置 职位id 属性值为参数值 positionId
     */
    public void setPositionId(String positionId) {
        this.positionId = positionId;
    }
    
    /**
     * @return 获取 测试 属性值
     */
    public String getTest() {
        return test;
    }
    	
    /**
     * @param test 设置 测试 属性值为参数值 test
     */
    public void setTest(String test) {
        this.test = test;
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