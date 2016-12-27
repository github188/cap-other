/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.flow.model;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.cap.bm.biz.common.model.BizBaseVO;
import com.comtop.cap.bm.biz.form.model.BizFormVO;
import com.comtop.cap.bm.biz.role.model.BizRoleVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 业务流程节点
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-17 CAP
 */
@DataTransferObject
@Table(name = "CAP_BIZ_PROCESS_NODE")
public class BizProcessNodeVO extends BizBaseVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 根据关系nodeToRel生成业务关联集合,由CIP自动创建。 */
    private List<BizRelInfoVO> bizRelInfos;
    
    /** 业务流程,由CIP自动创建。 */
    private BizProcessInfoVO bizProcessInfo;
    
    /** 流程节点关联的角色。 */
    private List<BizRoleVO> bizRoles;
    
    /** 流程节点关联的角色。 */
    private List<BizNodeConstraintVO> bizNodeConstraints;
    
    /** 流程节点关联的角色。 */
    private List<BizFormVO> bizForms;
    
    /** 主键 */
    @Id
    @Column(name = "ID", length = 40)
    private String id;
    
    /** 节点名称 */
    @Column(name = "NODE_NAME", length = 36)
    private String name;
    
    /** 节点编号 */
    @Column(name = "NODE_NO", length = 32)
    private String serialNo;
    
    /** IT实现 */
    @Column(name = "SYS_NAME", length = 10)
    private String sysName;
    
    /** 流程ID */
    @Column(name = "PROCESS_ID", length = 40)
    private String processId;
    
    /** 角色ID集合 */
    @Column(name = "ROLE_IDS", length = 256)
    private String roleIds;
    
    /** 角色名称集合 */
    private String roleNames;
    
    /** 关键业务节点，核心管控节点，一般管控节点 */
    @Column(name = "NODE_FLAG", length = 10)
    private String nodeFlag;
    
    /** 节点定义 */
    @Column(name = "NODE_DEF", length = 512)
    private String nodeDef;
    
    /** 公司总部，分子公司，地市单位，基层单位 */
    @Column(name = "MANAGE_LEVEL", length = 64)
    private String manageLevel;
    
    /** 管理层级 中文 公司总部，分子公司，地市单位，基层单位 */
    private String cnManageLevel;
    
    /** 工作要求 */
    @Column(name = "WORK_DEMAND", length = 4000)
    private String workDemand;
    
    /** 工作内容 */
    @Column(name = "WORK_CONTEXT", length = 4000)
    private String workContext;
    
    /** 风险点 */
    @Column(name = "RISK_AREA", length = 256)
    private String riskArea;
    
    /** 制度条款 */
    @Column(name = "CLAUSE", length = 256)
    private String clause;
    
    /** 备注 */
    @Column(name = "REMARK", length = 2000)
    private String remark;
    
    /** 业务域名称 */
    private String domainName;
    
    /** 流程名称 */
    private String processName;
    
    /** 同组id */
    @Column(name = "GROUP_ID", length = 4000)
    private String groupId;
    
    /** 原始的组id 每次导入时内存生成 */
    private String sourceGroupId;
    
    /** 编码表达式 */
    private static final String codeExpr = "PN-${seq('BizProcessNode',10,1,1)}";
    
    /**
     * @return 获取 codeExpr属性值
     */
    public static String getCodeExpr() {
        return codeExpr;
    }
    
    /**
     * @return 获取 sourceGroupId属性值
     */
    public String getSourceGroupId() {
        return sourceGroupId;
    }
    
    /**
     * @param sourceGroupId 设置 sourceGroupId 属性值为参数值 sourceGroupId
     */
    public void setSourceGroupId(String sourceGroupId) {
        this.sourceGroupId = sourceGroupId;
    }
    
    /**
     * @return 获取 bizForms属性值
     */
    public List<BizFormVO> getBizForms() {
        return bizForms;
    }
    
    /**
     * @param bizForms 设置 bizForms 属性值为参数值 bizForms
     */
    public void setBizForms(List<BizFormVO> bizForms) {
        this.bizForms = bizForms;
    }
    
    /**
     * @return 获取 cnManageLevel属性值
     */
    public String getCnManageLevel() {
        return cnManageLevel;
    }
    
    /**
     * @param cnManageLevel 设置 cnManageLevel 属性值为参数值 cnManageLevel
     */
    public void setCnManageLevel(String cnManageLevel) {
        this.cnManageLevel = cnManageLevel;
    }
    
    /**
     * @return 获取 bizNodeConstraints属性值
     */
    public List<BizNodeConstraintVO> getBizNodeConstraints() {
        return bizNodeConstraints;
    }
    
    /**
     * @param bizNodeConstraints 设置 bizNodeConstraints 属性值为参数值 bizNodeConstraints
     */
    public void setBizNodeConstraints(List<BizNodeConstraintVO> bizNodeConstraints) {
        this.bizNodeConstraints = bizNodeConstraints;
    }
    
    /**
     * @return 获取 bizRoles属性值
     */
    public List<BizRoleVO> getBizRoles() {
        return bizRoles;
    }
    
    /**
     * @param bizRoles 设置 bizRoles 属性值为参数值 bizRoles
     */
    public void setBizRoles(List<BizRoleVO> bizRoles) {
        this.bizRoles = bizRoles;
    }
    
    /**
     * @return 获取 bizRelInfos属性值
     */
    public List<BizRelInfoVO> getBizRelInfos() {
        return bizRelInfos;
    }
    
    /**
     * @param bizRelInfos 设置 bizRelInfos 属性值为参数值 bizRelInfos
     */
    public void setBizRelInfos(List<BizRelInfoVO> bizRelInfos) {
        this.bizRelInfos = bizRelInfos;
    }
    
    /**
     * @return 获取 bizProcessInfo属性值
     */
    public BizProcessInfoVO getBizProcessInfo() {
        return bizProcessInfo;
    }
    
    /**
     * @param bizProcessInfo 设置 bizProcessInfo 属性值为参数值 bizProcessInfo
     */
    public void setBizProcessInfo(BizProcessInfoVO bizProcessInfo) {
        this.bizProcessInfo = bizProcessInfo;
    }
    
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
     * @return 获取 节点名称属性值
     */
    
    public String getName() {
        return name;
    }
    
    /**
     * @param name 设置 节点名称属性值为参数值 name
     */
    
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * @return 获取 节点编号属性值
     */
    
    public String getSerialNo() {
        return serialNo;
    }
    
    /**
     * @param serialNo 设置 节点编号属性值为参数值 serialNo
     */
    
    public void setSerialNo(String serialNo) {
        this.serialNo = serialNo;
    }
    
    /**
     * @return 获取 IT实现属性值
     */
    
    public String getSysName() {
        return sysName;
    }
    
    /**
     * @param sysName 设置 IT实现属性值为参数值 sysName
     */
    
    public void setSysName(String sysName) {
        this.sysName = sysName;
    }
    
    /**
     * 
     * 获取流程ID
     * 
     * @return 流程ID
     */
    public String getProcessId() {
        return processId;
    }
    
    /**
     * 设置流程ID
     * 
     * @param processId 流程ID
     */
    public void setProcessId(String processId) {
        this.processId = processId;
    }
    
    /**
     * 
     * 获取角色ID集合
     * 
     * @return 角色ID集合
     */
    public String getRoleIds() {
        return roleIds;
    }
    
    /**
     * 
     * 设置角色ID集合
     * 
     * @param roleIds 角色ID集合
     */
    public void setRoleIds(String roleIds) {
        this.roleIds = roleIds;
    }
    
    /**
     * 
     * 获取角色名称集合
     * 
     * @return 角色名称集合
     */
    public String getRoleNames() {
        return roleNames;
    }
    
    /**
     * 
     * 设置角色名称
     * 
     * @param roleNames 角色名称集合
     */
    public void setRoleNames(String roleNames) {
        this.roleNames = roleNames;
    }
    
    /**
     * @return 获取 关键业务节点，核心管控节点，一般管控节点属性值
     */
    
    public String getNodeFlag() {
        return nodeFlag;
    }
    
    /**
     * @param nodeFlag 设置 关键业务节点，核心管控节点，一般管控节点属性值为参数值 nodeFlag
     */
    
    public void setNodeFlag(String nodeFlag) {
        this.nodeFlag = nodeFlag;
    }
    
    /**
     * @return 获取 节点定义属性值
     */
    
    public String getNodeDef() {
        return nodeDef;
    }
    
    /**
     * @param nodeDef 设置 节点定义属性值为参数值 nodeDef
     */
    
    public void setNodeDef(String nodeDef) {
        this.nodeDef = nodeDef;
    }
    
    /**
     * @return 获取 公司总部，分子公司，地市单位，基层单位属性值
     */
    
    public String getManageLevel() {
        return manageLevel;
    }
    
    /**
     * @param manageLevel 设置 公司总部，分子公司，地市单位，基层单位属性值为参数值 manageLevel
     */
    
    public void setManageLevel(String manageLevel) {
        this.manageLevel = manageLevel;
    }
    
    /**
     * @return 获取 工作要求属性值
     */
    
    public String getWorkDemand() {
        return workDemand;
    }
    
    /**
     * @param workDemand 设置 工作要求属性值为参数值 workDemand
     */
    
    public void setWorkDemand(String workDemand) {
        this.workDemand = workDemand;
    }
    
    /**
     * @return 获取 工作内容属性值
     */
    
    public String getWorkContext() {
        return workContext;
    }
    
    /**
     * @param workContext 设置 工作内容属性值为参数值 workContext
     */
    
    public void setWorkContext(String workContext) {
        this.workContext = workContext;
    }
    
    /**
     * @return 获取 风险点属性值
     */
    
    public String getRiskArea() {
        return riskArea;
    }
    
    /**
     * @param riskArea 设置 风险点属性值为参数值 riskArea
     */
    
    public void setRiskArea(String riskArea) {
        this.riskArea = riskArea;
    }
    
    /**
     * @return 获取 制度条款属性值
     */
    
    public String getClause() {
        return clause;
    }
    
    /**
     * @param clause 设置 制度条款属性值为参数值 clause
     */
    
    public void setClause(String clause) {
        this.clause = clause;
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
     * @return 获取 domainName属性值
     */
    public String getDomainName() {
        return domainName;
    }
    
    /**
     * @param domainName 设置 domainName 属性值为参数值 domainName
     */
    public void setDomainName(String domainName) {
        this.domainName = domainName;
    }
    
    /**
     * @return 获取 processName属性值
     */
    public String getProcessName() {
        return processName;
    }
    
    /**
     * @param processName 设置 processName 属性值为参数值 processName
     */
    public void setProcessName(String processName) {
        this.processName = processName;
    }
    
    /**
     * @return 获取 groupId属性值
     */
    public String getGroupId() {
        return groupId;
    }
    
    /**
     * @param groupId 设置 groupId 属性值为参数值 groupId
     */
    public void setGroupId(String groupId) {
        this.groupId = groupId;
    }
}
