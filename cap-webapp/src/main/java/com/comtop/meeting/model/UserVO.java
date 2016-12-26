/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.meeting.model;

import com.comtop.cap.runtime.base.model.CapWorkflowVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;
import javax.persistence.Table;
import javax.persistence.Column;
import javax.persistence.Id;
import java.sql.Timestamp;


/**
 * 用户表
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-5-31 CAP超级管理员
 */
@Table(name = "T_PM_USER")
@DataTransferObject
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
    
    /** flowState */
    @Column(name = "FLOW_STATE",precision=0)
    private Integer flowState;
    
    /** processInsId */
    @Column(name = "PROCESS_INS_ID",length=50,precision=0)
    private String processInsId;
    
    /** birthday */
    @Column(name = "BIRTHDAY",precision=0)
    private Timestamp birthday;
    
	
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
     * @return 获取 flowState 属性值
     */
    @Override
    public Integer getFlowState() {
        return flowState;
    }
    	
    /**
     * @param flowState 设置 flowState 属性值为参数值 flowState
     */
    @Override
    public void setFlowState(Integer flowState) {
        this.flowState = flowState;
    }
    
    /**
     * @return 获取 processInsId 属性值
     */
    @Override
    public String getProcessInsId() {
        return processInsId;
    }
    	
    /**
     * @param processInsId 设置 processInsId 属性值为参数值 processInsId
     */
    @Override
    public void setProcessInsId(String processInsId) {
        this.processInsId = processInsId;
    }
    
    /**
     * @return 获取 birthday 属性值
     */
    public Timestamp getBirthday() {
        return birthday;
    }
    	
    /**
     * @param birthday 设置 birthday 属性值为参数值 birthday
     */
    public void setBirthday(Timestamp birthday) {
        this.birthday = birthday;
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