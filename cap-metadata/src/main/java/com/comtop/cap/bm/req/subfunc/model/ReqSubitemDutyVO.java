/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.subfunc.model;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.top.core.base.model.CoreVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 功能子项职责表
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-12-16 CAP
 */
@DataTransferObject
@Table(name = "CAP_REQ_SUBITEM_DUTY")
public class ReqSubitemDutyVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 功能子项,建在功能项下面,由CIP自动创建。 */
    private ReqFunctionSubitemVO reqFunctionSubitemByReqsubitemduty;
    
    /** 职责ID */
    @Id
    @Column(name = "ID", length = 40)
    private String id;
    
    /** 子项ID */
    @Column(name = "SUBITEM_ID", length = 40)
    private String subitemId;
    
    /** 描述 */
    @Column(name = "DESCRIPTION", length = 500)
    private String description;
    
    /** 数据来源，1：导入；0：系统创建； */
    @Column(name = "DATA_FROM", precision = 1)
    private Integer dataFrom;
    
    /** 角色ID */
    @Column(name = "ROLE_ID", length = 40)
    private String roleId;
    
    /** 文档ID */
    @Column(name = "DOCUMENT_ID", length = 40)
    private String documentId;
    /** 角色名称 */
    private String roleName;
    
    /** 角色编码 */
    private String roleCode;
    
    /** 业务级别 */
    private String bizLevel;
    
    /** 角色业务域ID */
    private String domainId;
    
    /**
     * @return 获取 功能子项,建在功能项下面,由CIP自动创建。属性值
     */
    
    public ReqFunctionSubitemVO getReqFunctionSubitemByReqsubitemduty() {
        return reqFunctionSubitemByReqsubitemduty;
    }
    
    /**
     * @param reqFunctionSubitemByReqsubitemduty 设置 功能子项,建在功能项下面,由CIP自动创建。属性值为参数值 reqFunctionSubitemByReqsubitemduty
     */
    
    public void setReqFunctionSubitemByReqsubitemduty(ReqFunctionSubitemVO reqFunctionSubitemByReqsubitemduty) {
        this.reqFunctionSubitemByReqsubitemduty = reqFunctionSubitemByReqsubitemduty;
    }
    
    /**
     * @return 获取 职责ID属性值
     */
    
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置 职责ID属性值为参数值 id
     */
    
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 子项ID属性值
     */
    
    public String getSubitemId() {
        return subitemId;
    }
    
    /**
     * @param subitemId 设置 子项ID属性值为参数值 subitemId
     */
    
    public void setSubitemId(String subitemId) {
        this.subitemId = subitemId;
    }
    
    /**
     * @return 获取 描述属性值
     */
    
    public String getDescription() {
        return description;
    }
    
    /**
     * @param description 设置 描述属性值为参数值 description
     */
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    /**
     * @return 获取 数据来源，1：导入；0：系统创建；属性值
     */
    
    public Integer getDataFrom() {
        return dataFrom;
    }
    
    /**
     * @param dataFrom 设置 数据来源，1：导入；0：系统创建；属性值为参数值 dataFrom
     */
    
    public void setDataFrom(Integer dataFrom) {
        this.dataFrom = dataFrom;
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
    
    /**
     * @return 获取 文档ID属性值
     */
    
    public String getDocumentId() {
        return documentId;
    }
    
    /**
     * @param documentId 设置 文档ID属性值为参数值 documentId
     */
    
    public void setDocumentId(String documentId) {
        this.documentId = documentId;
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
     * @return 获取 domainId属性值
     */
    public String getDomainId() {
        return domainId;
    }
    
    /**
     * @param domainId 设置 domainId 属性值为参数值 domainId
     */
    public void setDomainId(String domainId) {
        this.domainId = domainId;
    }

	@Override
	public String toString() {
		return "ReqSubitemDutyVO [id=" + id
				+ ", subitemId=" + subitemId + ", description=" + description
				+ ", dataFrom=" + dataFrom + ", roleId=" + roleId
				+ ", documentId=" + documentId + ", roleName=" + roleName
				+ ", roleCode=" + roleCode + ", bizLevel=" + bizLevel
				+ ", domainId=" + domainId + "]";
	}
    
    
}
