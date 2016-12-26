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
import javax.persistence.Id;


/**
 * cap流程常用意见
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-5-30 CAP超级管理员
 */
@Table(name = "CAP_COMMON_OPINION")
@DataTransferObject
public class OpinionVO extends CapBaseVO {

    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 主键id */
    @Id
    @Column(name = "ID",length=50,precision=0)
    private String id;
    
    /** 人员id */
    @Column(name = "PERSON_ID",length=50,precision=0)
    private String personId;
    
    /** 常用意见 */
    @Column(name = "OPINION",length=1000,precision=0)
    private String opinion;
    
    /** 是否全局控制 */
    @Column(name = "ISGLOBALCTRL",precision=0)
    private Boolean isglobalctrl;
    
    /** 工单id(单据id) */
    @Column(name = "WORK_ID",length=50,precision=0)
    private String workId;
    
	
    /**
     * @return 获取 主键id 属性值
     */
    public String getId() {
        return id;
    }
    	
    /**
     * @param id 设置 主键id 属性值为参数值 id
     */
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 人员id 属性值
     */
    public String getPersonId() {
        return personId;
    }
    	
    /**
     * @param personId 设置 人员id 属性值为参数值 personId
     */
    public void setPersonId(String personId) {
        this.personId = personId;
    }
    
    /**
     * @return 获取 常用意见 属性值
     */
    public String getOpinion() {
        return opinion;
    }
    	
    /**
     * @param opinion 设置 常用意见 属性值为参数值 opinion
     */
    public void setOpinion(String opinion) {
        this.opinion = opinion;
    }
    
    /**
     * @return 获取 是否全局控制 属性值
     */
    public Boolean getIsglobalctrl() {
        return isglobalctrl;
    }
    	
    /**
     * @param isglobalctrl 设置 是否全局控制 属性值为参数值 isglobalctrl
     */
    public void setIsglobalctrl(Boolean isglobalctrl) {
        this.isglobalctrl = isglobalctrl;
    }
    
    /**
     * @return 获取 工单id(单据id) 属性值
     */
    public String getWorkId() {
        return workId;
    }
    	
    /**
     * @param workId 设置 工单id(单据id) 属性值为参数值 workId
     */
    public void setWorkId(String workId) {
        this.workId = workId;
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