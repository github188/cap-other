/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.budget.model;

import com.comtop.cap.runtime.base.model.CapWorkflowVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;
import com.comtop.cap.runtime.base.annotation.EntityAlias;
import javax.persistence.Table;
import javax.persistence.Column;
import com.comtop.cap.runtime.base.annotation.AssociateAttribute;
import java.util.List;
import javax.persistence.Id;
import java.sql.Timestamp;
import com.comtop.budget.model.PositionVO;


/**
 * 用户表
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-10-8 CAP超级管理员
 */
@Table(name = "T_PM_USER")
@DataTransferObject
@EntityAlias(value = "user2")
public class UserVO extends CapWorkflowVO {

    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** id主键 */
    @Id
    @Column(name = "ID",length=50,precision=0)
    private String id;
    
    /** 名称 */
    @Column(name = "NAME",length=50,precision=0)
    private String name;
    
    /** 编码 */
    @Column(name = "USER_NUMBER",length=50,precision=0)
    private String userNumber;
    
    /** 流程状态 */
    @Column(name = "FLOW_STATE",precision=0)
    private Integer flowState;
    
    /** 流程实例id */
    @Column(name = "PROCESS_INS_ID",length=50,precision=0)
    private String processInsId;
    
    /** 生日 */
    @Column(name = "BIRTHDAY",precision=0)
    private Timestamp birthday;
    
    /** 性别 */
    @Column(name = "SEX",precision=0)
    private Integer sex;
    
    /** 一对多 */
    @AssociateAttribute(multiple = "One-Many", associateFieldName = "userId")
    private List<PositionVO> relationOneToMany;
    
	
    /**
     * @return 获取 id主键 属性值
     */
    public String getId() {
        return id;
    }
    	
    /**
     * @param id 设置 id主键 属性值为参数值 id
     */
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 名称 属性值
     */
    public String getName() {
        return name;
    }
    	
    /**
     * @param name 设置 名称 属性值为参数值 name
     */
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * @return 获取 编码 属性值
     */
    public String getUserNumber() {
        return userNumber;
    }
    	
    /**
     * @param userNumber 设置 编码 属性值为参数值 userNumber
     */
    public void setUserNumber(String userNumber) {
        this.userNumber = userNumber;
    }
    
    /**
     * @return 获取 流程状态 属性值
     */
    @Override
    public Integer getFlowState() {
        return flowState;
    }
    	
    /**
     * @param flowState 设置 流程状态 属性值为参数值 flowState
     */
    @Override
    public void setFlowState(Integer flowState) {
        this.flowState = flowState;
    }
    
    /**
     * @return 获取 流程实例id 属性值
     */
    @Override
    public String getProcessInsId() {
        return processInsId;
    }
    	
    /**
     * @param processInsId 设置 流程实例id 属性值为参数值 processInsId
     */
    @Override
    public void setProcessInsId(String processInsId) {
        this.processInsId = processInsId;
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
     * @return 获取 一对多 属性值
     */
    public List<PositionVO> getRelationOneToMany() {
        return relationOneToMany;
    }
    	
    /**
     * @param relationOneToMany 设置 一对多 属性值为参数值 relationOneToMany
     */
    public void setRelationOneToMany(List<PositionVO> relationOneToMany) {
        this.relationOneToMany = relationOneToMany;
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