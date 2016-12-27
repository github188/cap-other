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
 * TeamAndEmployeeRel
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-10-15 姜子豪
 */
@DataTransferObject
@Table(name = "CAP_PTC_TEAM_EMPLOYEE_REL")
public class TeamAndEmployeeRelVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 主键 */
    @Id
    @Column(name = "ID", length = 32)
    private String id;
    
    /** 团队ID */
    @Column(name = "TEAM_ID", length = 32)
    private String teamId;
    
    /** 人员ID */
    @Column(name = "EMPLOYEE_ID", length = 32)
    private String employeeId;
    
    /** 角色ID集合如developer,test,pm,cm */
    @Column(name = "ROLE_ID", length = 200)
    private String roleId;
    
    /** 角色名称集合如项目责任人,开发人员，测试人员 */
    @Column(name = "ROLE_NAME", length = 200)
    private String roleName;
    
    /**
     * @return 获取 主键属性值
     */
    
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置 主键属性值为参数值 id
     */
    
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 团队ID属性值
     */
    
    public String getTeamId() {
        return teamId;
    }
    
    /**
     * @param teamId 设置 团队ID属性值为参数值 teamId
     */
    
    public void setTeamId(String teamId) {
        this.teamId = teamId;
    }
    
    /**
     * @return 获取 人员ID属性值
     */
    
    public String getEmployeeId() {
        return employeeId;
    }
    
    /**
     * @param employeeId 设置 人员ID属性值为参数值 employeeId
     */
    
    public void setEmployeeId(String employeeId) {
        this.employeeId = employeeId;
    }
    
    /**
     * @return 获取 角色ID集合如developer,test,pm,cm属性值
     */
    
    public String getRoleId() {
        return roleId;
    }
    
    /**
     * @param roleId 设置 角色ID集合如developer,test,pm,cm属性值为参数值 roleId
     */
    
    public void setRoleId(String roleId) {
        this.roleId = roleId;
    }
    
    /**
     * @return 获取 角色名称集合如项目责任人,开发人员，测试人员属性值
     */
    
    public String getRoleName() {
        return roleName;
    }
    
    /**
     * @param roleName 设置 角色名称集合如项目责任人,开发人员，测试人员属性值为参数值 roleName
     */
    
    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }
    
}
