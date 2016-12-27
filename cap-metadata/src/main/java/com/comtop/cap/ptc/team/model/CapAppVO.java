/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.ptc.team.model;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.cip.validator.org.hibernate.validator.constraints.Length;
import com.comtop.top.core.base.model.CoreVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 个人应用VO
 * 
 * @author 李小芬
 * @since 1.0
 * @version 2015-10-9 李小芬
 */
@DataTransferObject
@Table(name = "CAP_PTC_APP")
public class CapAppVO extends CoreVO {
    
    /** 标识 */
    private static final long serialVersionUID = 1L;
    
    /** ID */
    @Id
    @Length(max = 32)
    @Column(name = "ID", length = 32)
    private String id;
    
    /** 负责人ID */
    @Length(max = 32)
    @Column(name = "EMPLOYEE_ID", length = 32)
    private String employeeId;
    
    /** 应用ID */
    @Length(max = 32)
    @Column(name = "APP_ID", length = 32)
    private String appId;
    
    /** 应用类型(1.负责,2收藏) */
    @Column(name = "APP_TYPE", precision = 1)
    private int appType;
    
    /** 应用名称 */
    private String appName;
    
    /** 应用图标 */
    private String appIconUrl;
    
    /** 团队ID */
    private String teamId;
    
    /**
     * @return 获取 id属性值
     * @see com.comtop.cap.runtime.base.model.BaseVO#getId()
     */
    public String getId() {
        return this.id;
    }
    
    /**
     * @param id 设置 id 属性值为参数值 id
     * 
     * @see com.comtop.cap.runtime.base.model.BaseVO#setId(java.lang.String)
     */
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取employeeId属性值
     */
    public String getEmployeeId() {
        return employeeId;
    }
    
    /**
     * @param employeeId 设置为employeeId
     */
    public void setEmployeeId(String employeeId) {
        this.employeeId = employeeId;
    }
    
    /**
     * @return 获取appId属性值
     */
    public String getAppId() {
        return appId;
    }
    
    /**
     * @param appId 设置为appId
     */
    public void setAppId(String appId) {
        this.appId = appId;
    }
    
    /**
     * @return 获取appType属性值
     */
    public int getAppType() {
        return appType;
    }
    
    /**
     * @param appType 设置为appType
     */
    public void setAppType(int appType) {
        this.appType = appType;
    }
    
    /**
     * @return 获取appName属性值
     */
    public String getAppName() {
        return appName;
    }
    
    /**
     * @param appName 设置为appName
     */
    public void setAppName(String appName) {
        this.appName = appName;
    }
    
    /**
     * @return 获取appIconUrl属性值
     */
    public String getAppIconUrl() {
        return appIconUrl;
    }
    
    /**
     * @param appIconUrl 设置为appIconUrl
     */
    public void setAppIconUrl(String appIconUrl) {
        this.appIconUrl = appIconUrl;
    }
    
    /**
     * @return 获取teamId属性值
     */
    public String getTeamId() {
        return teamId;
    }
    
    /**
     * @param teamId 设置为teamId
     */
    public void setTeamId(String teamId) {
        this.teamId = teamId;
    }
    
}
