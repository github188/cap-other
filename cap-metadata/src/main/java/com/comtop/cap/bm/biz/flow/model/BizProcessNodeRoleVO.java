/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.flow.model;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.top.core.base.model.CoreVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 业务模型-流程角色关联表
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-12-22 CAP
 */
@DataTransferObject
@Table(name = "CAP_BIZ_PROCESS_NODE_ROLE")
public class BizProcessNodeRoleVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 主键ID */
    @Id
    @Column(name = "ID", length = 40)
    private String id;
    
    /** 流程节点ID */
    @Column(name = "NODE_ID", length = 40)
    private String nodeId;
    
    /** 角色ID */
    @Column(name = "ROLE_ID", length = 1)
    private String roleId;
    
    /** 角色名称 */
    private String roleName;
    
    /** 业务层级 */
    private String bizLevel;
    
    /** 序号 */
    @Column(name = "SORT_NO", precision = 10)
    private Integer sortNo;
    
    /**
     * @return 获取 sortNo属性值
     */
    public Integer getSortNo() {
        return sortNo;
    }
    
    /**
     * @param sortNo 设置 sortNo 属性值为参数值 sortNo
     */
    public void setSortNo(Integer sortNo) {
        this.sortNo = sortNo;
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
    
    /**
     * @return 获取 主键ID属性值
     */
    
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置 主键ID属性值为参数值 id
     */
    
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 流程节点ID属性值
     */
    
    public String getNodeId() {
        return nodeId;
    }
    
    /**
     * @param nodeId 设置 流程节点ID属性值为参数值 nodeId
     */
    
    public void setNodeId(String nodeId) {
        this.nodeId = nodeId;
    }
    
    /**
     * @return 获取 角色ID属性值
     */
    
    public String getRoleId() {
        return roleId;
    }
    
    /**
     * @param roleId 设置 角色ID属性值为参数值 roleId
     */
    
    public void setRoleId(String roleId) {
        this.roleId = roleId;
    }
    
}
