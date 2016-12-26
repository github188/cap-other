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
 * 出席者分录表(主表属于meeting)
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-5-30 CAP超级管理员
 */
@Table(name = "OMS_DEMO_XC_PRESENTENTRY")
@DataTransferObject
public class XcPresententryVO extends CapBaseVO {

    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 出席者主键id */
    @Id
    @Column(name = "PRESENTENTRYID",length=40,precision=0)
    private String presententryid;
    
    /** 会议管理主键id */
    @Column(name = "MEETINGID",length=44,precision=0)
    private String meetingid;
    
    /** 用户的主键id */
    @Column(name = "USERID",length=40,precision=0)
    private String userid;
    
    /** username */
    @Column(name = "USERNAME",length=100,precision=0)
    private String username;
    
	
    /**
     * @return 获取 出席者主键id 属性值
     */
    public String getPresententryid() {
        return presententryid;
    }
    	
    /**
     * @param presententryid 设置 出席者主键id 属性值为参数值 presententryid
     */
    public void setPresententryid(String presententryid) {
        this.presententryid = presententryid;
    }
    
    /**
     * @return 获取 会议管理主键id 属性值
     */
    public String getMeetingid() {
        return meetingid;
    }
    	
    /**
     * @param meetingid 设置 会议管理主键id 属性值为参数值 meetingid
     */
    public void setMeetingid(String meetingid) {
        this.meetingid = meetingid;
    }
    
    /**
     * @return 获取 用户的主键id 属性值
     */
    public String getUserid() {
        return userid;
    }
    	
    /**
     * @param userid 设置 用户的主键id 属性值为参数值 userid
     */
    public void setUserid(String userid) {
        this.userid = userid;
    }
    
    /**
     * @return 获取 username 属性值
     */
    public String getUsername() {
        return username;
    }
    	
    /**
     * @param username 设置 username 属性值为参数值 username
     */
    public void setUsername(String username) {
        this.username = username;
    }
    
	 
    /**
     * 获取主键值
     * @return 主键值
     */
    @Override
    public String getPrimaryValue(){
    		return  this.presententryid;
    }
}