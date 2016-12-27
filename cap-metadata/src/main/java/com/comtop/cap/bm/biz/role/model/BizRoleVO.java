/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.role.model;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.cap.bm.biz.common.model.BizBaseVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 角色表,用于文档管理中角色信息管理
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-11-11 姜子豪
 */
@DataTransferObject
@Table(name = "CAP_BIZ_ROLE")
public class BizRoleVO extends BizBaseVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 主键 */
    @Id
    @Column(name = "ID", length = 40)
    private String id;
    
    /** 角色编码 */
    @Column(name = "ROLE_CODE", length = 36)
    private String roleCode;
    
    /** 角色名称 */
    @Column(name = "ROLE_NAME", length = 200)
    private String roleName;
    
    /** 简称 */
    @Column(name = "SHORT_NAME", length = 200)
    private String shortName;
    
    /** 备注 */
    @Column(name = "REMARK", length = 2000)
    private String remark;
    
    /** 业务层级 */
    @Column(name = "BIZ_LEVEL", length = 200)
    private String bizLevel;
    
    /** 编码表达式 */
    private static final String codeExpr = "BR-${seq('BizRole',6,1,1)}";
    
    /**
     * @return 获取 codeExpr属性值
     */
    public static String getCodeExpr() {
        return codeExpr;
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
    
    /** 关键字 */
    private String keyWords;
    
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
     * @return 获取 简称属性值
     */
    
    public String getShortName() {
        return shortName;
    }
    
    /**
     * @param shortName 设置 简称属性值为参数值 shortName
     */
    
    public void setShortName(String shortName) {
        this.shortName = shortName;
    }
    
    /**
     * @return 获取 备注属性值
     */
    
    public String getRemark() {
        return remark;
    }
    
    /**
     * @param remark 设置 备注属性值为参数值 remark
     */
    
    public void setRemark(String remark) {
        this.remark = remark;
    }
    
    /**
     * @return 获取 keyWords属性值
     */
    public String getKeyWords() {
        return keyWords;
    }
    
    /**
     * @param keyWords 设置 keyWords 属性值为参数值 keyWords
     */
    public void setKeyWords(String keyWords) {
        this.keyWords = keyWords;
    }
    
}
