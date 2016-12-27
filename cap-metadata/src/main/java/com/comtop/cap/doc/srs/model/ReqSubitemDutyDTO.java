/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.srs.model;

import com.comtop.cap.document.word.docmodel.data.BaseDTO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 功能子项职责DTO
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年12月24日 lizhongwen
 */
@DataTransferObject
public class ReqSubitemDutyDTO extends BaseDTO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 子项ID */
    private String subitemId;
    
    /** 角色ID */
    private String roleId;
    
    /** 角色名称 */
    private String roleName;
    
    /** 角色编码 */
    private String roleCode;
    
    /** 描述 */
    private String description;
    
    /** 业务级别 */
    private String bizLevel;
    
    /**
     * @return 获取 subitemId属性值
     */
    public String getSubitemId() {
        return subitemId;
    }
    
    /**
     * @param subitemId 设置 subitemId 属性值为参数值 subitemId
     */
    public void setSubitemId(String subitemId) {
        this.subitemId = subitemId;
    }
    
    /**
     * @return 获取 roleId属性值
     */
    public String getRoleId() {
        return roleId;
    }
    
    /**
     * @param roleId 设置 roleId 属性值为参数值 roleId
     */
    public void setRoleId(String roleId) {
        this.roleId = roleId;
    }
    
    /**
     * @return 获取 roleName属性值
     */
    public String getRoleName() {
        return roleName;
    }
    
    /**
     * @param roleName 设置 roleName 属性值为参数值 roleName
     */
    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }
    
    /**
     * @return 获取 roleCode属性值
     */
    public String getRoleCode() {
        return roleCode;
    }
    
    /**
     * @param roleCode 设置 roleCode 属性值为参数值 roleCode
     */
    public void setRoleCode(String roleCode) {
        this.roleCode = roleCode;
    }
    
    /**
     * @return 获取 description属性值
     */
    @Override
    public String getDescription() {
        return description;
    }
    
    /**
     * @param description 设置 description 属性值为参数值 description
     */
    @Override
    public void setDescription(String description) {
        this.description = description;
    }
    
    /**
     * @return 获取 bizLevel属性值
     */
    public String getBizLevel() {
        return bizLevel;
    }
    
    /**
     * @param bizLevel 设置 bizLevel 属性值为参数值 bizLevel
     */
    public void setBizLevel(String bizLevel) {
        this.bizLevel = bizLevel;
    }
}
