/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.ptc.team.model;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.top.core.base.model.CoreVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 角色管理基本信息
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-10-15 姜子豪
 */
@DataTransferObject
@Table(name = "CAP_PTC_ROLE")
public class CapRoleVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 角色主键 */
    @Id
    @Column(name = "ROLE_ID", length = 32)
    private String id;
    
    /** 角色名称 */
    @Column(name = "ROLE_NAME", length = 200)
    private String roleName;
    
    /** 角色描述 */
    @Column(name = "DESCRIPTION", length = 100)
    private String description;
    
    /** 角色编码 */
    @Column(name = "ROLE_CODE", length = 36)
    private String roleCode;
    
    /**
     * @return 获取 角色主键属性值
     */
    
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置 角色主键属性值为参数值 id
     */
    
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 角色名称属性值
     */
    
    public String getRoleName() {
        return roleName;
    }
    
    /**
     * @param roleName 设置 角色名称属性值为参数值 roleName
     */
    
    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }
    
    /**
     * @return 获取 角色描述属性值
     */
    
    public String getDescription() {
        return description;
    }
    
    /**
     * @param description 设置 角色描述属性值为参数值 description
     */
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    /**
     * @return 获取 角色编码属性值
     */
    
    public String getRoleCode() {
        return roleCode;
    }
    
    /**
     * @param roleCode 设置 角色编码属性值为参数值 roleCode
     */
    
    public void setRoleCode(String roleCode) {
        this.roleCode = roleCode;
    }
    
}
