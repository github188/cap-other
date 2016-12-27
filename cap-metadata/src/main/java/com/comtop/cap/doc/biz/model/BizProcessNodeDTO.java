/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.model;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.document.word.docmodel.data.BaseDTO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 业务流程节点DTO
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月19日 lizhiyong
 */
@DataTransferObject
public class BizProcessNodeDTO extends BaseDTO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 根据关系nodeToRel生成业务关联集合,由CIP自动创建。 */
    private List<BizRelationDTO> bizRelations;
    
    /** 流程节点关联的角色。 */
    private List<BizRoleDTO> bizRoles;
    
    /** 流程节点关联的角色。 */
    private List<BizNodeConstraintDTO> bizNodeConstraints;
    
    /** 流程节点关联的角色。 */
    private List<BizFormNodeDTO> bizForms;
    
    /** 角色字符串集 */
    private String roles;
    
    /** 节点编号 */
    private String serialNo;
    
    /** IT实现 */
    private String sysName;
    
    /** 流程ID */
    private String processId;
    
    /** 流程名称 */
    private String processName;
    
    /** 业务事项id */
    private String bizItemId;
    
    /** 业务事项名称 */
    private String bizItemName;
    
    /** 关键业务节点，核心管控节点，一般管控节点 */
    private String nodeFlag;
    
    /** 节点标志集 */
    private Map<String, String> nodeFlagMap;
    
    /** 节点定义 */
    private String nodeDef;
    
    /** 公司总部，分子公司，地市单位，基层单位 */
    private String manageLevel;
    
    /** 公司总部，分子公司，地市单位，基层单位 */
    private String cnManageLevel;
    
    /** 工作要求 */
    private String workDemand;
    
    /** 工作内容 */
    private String workContext;
    
    /** 风险点 */
    private String riskArea;
    
    /** 制度条款 */
    private String clause;
    
    /** 同组id */
    private String groupId;
    
    /**
     * 原始节点组id 对节点而言，每次导入都会创建新的id，关联等数据都挂在新的id下。
     * 但在导入过程中会对节点进行合并 ，每次新建的id值将将被丢弃，此值用于传递原始id你值，保证在合并时能够找到正确的下级
     */
    private String sourceGroupId;
    
    /** 业务流程 */
    private BizProcessDTO bizProcess;
    
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
     * @return 获取 bizRoles属性值
     */
    public List<BizRoleDTO> getBizRoles() {
        return bizRoles;
    }
    
    /**
     * @param bizRoleList 设置 bizRoles 属性值为参数值 bizRoles
     */
    public void addBizRoles(List<BizRoleDTO> bizRoleList) {
        if (bizRoleList != null && bizRoleList.size() > 0) {
            for (BizRoleDTO bizRoleDTO : bizRoleList) {
                addBizRole(bizRoleDTO);
            }
        }
    }
    
    /**
     * @param bizRelations 设置 bizRelations 属性值为参数值 bizRelations
     */
    public void setBizRelations(List<BizRelationDTO> bizRelations) {
        this.bizRelations = bizRelations;
    }
    
    /**
     * @param bizRoles 设置 bizRoles 属性值为参数值 bizRoles
     */
    public void setBizRoles(List<BizRoleDTO> bizRoles) {
        this.bizRoles = bizRoles;
    }
    
    /**
     * @param bizNodeConstraints 设置 bizNodeConstraints 属性值为参数值 bizNodeConstraints
     */
    public void setBizNodeConstraints(List<BizNodeConstraintDTO> bizNodeConstraints) {
        this.bizNodeConstraints = bizNodeConstraints;
    }
    
    /**
     * @param bizForms 设置 bizForms 属性值为参数值 bizForms
     */
    public void setBizForms(List<BizFormNodeDTO> bizForms) {
        this.bizForms = bizForms;
    }
    
    /**
     * 添加一个角色
     *
     * @param bizRoleDTO 角色
     */
    public void addBizRole(BizRoleDTO bizRoleDTO) {
        if (this.bizRoles == null) {
            this.bizRoles = new ArrayList<BizRoleDTO>();
        }
        bizRoles.add(bizRoleDTO);
    }
    
    /**
     * @return 获取 bizNodeConstraints属性值
     */
    public List<BizNodeConstraintDTO> getBizNodeConstraints() {
        return bizNodeConstraints;
    }
    
    /**
     * @param bizNodeConstraintList 设置 bizNodeConstraints 属性值为参数值 bizNodeConstraints
     */
    public void addBizNodeConstraints(List<BizNodeConstraintDTO> bizNodeConstraintList) {
        if (bizNodeConstraintList != null) {
            for (BizNodeConstraintDTO bizNodeConstraintDTO : bizNodeConstraintList) {
                addBizNodeConstraint(bizNodeConstraintDTO);
            }
        }
    }
    
    /**
     * @param bizNodeConstraint 设置 bizNodeConstraints 属性值为参数值 bizNodeConstraints
     */
    public void addBizNodeConstraint(BizNodeConstraintDTO bizNodeConstraint) {
        if (this.bizNodeConstraints == null) {
            bizNodeConstraints = new ArrayList<BizNodeConstraintDTO>(10);
        }
        bizNodeConstraints.add(bizNodeConstraint);
        bizNodeConstraint.setBizProcessNode(this);
    }
    
    /**
     * @return 获取 bizForms属性值
     */
    public List<BizFormNodeDTO> getBizForms() {
        return bizForms;
    }
    
    /**
     * @param bizFormList 设置 bizForms 属性值为参数值 bizForms
     */
    public void addBizForms(List<BizFormNodeDTO> bizFormList) {
        if (bizFormList != null) {
            for (BizFormNodeDTO bizFormNodeDTO : bizFormList) {
                addBizForm(bizFormNodeDTO);
                bizFormNodeDTO.setBizProcessNode(this);
            }
        }
    }
    
    /**
     * @param bizForm 设置 bizForms 属性值为参数值 bizForms
     */
    public void addBizForm(BizFormNodeDTO bizForm) {
        if (this.bizForms == null) {
            bizForms = new ArrayList<BizFormNodeDTO>(10);
        }
        bizForms.add(bizForm);
        bizForm.setBizProcessNode(this);
    }
    
    /**
     * @return 获取 bizRelations属性值
     */
    public List<BizRelationDTO> getBizRelations() {
        return bizRelations;
    }
    
    /**
     * @param bizRelationList 设置 bizRelations 属性值为参数值 bizRelations
     */
    public void addBizRelations(List<BizRelationDTO> bizRelationList) {
        if (bizRelationList != null) {
            for (BizRelationDTO bizRelationDTO : bizRelationList) {
                addBizRelation(bizRelationDTO);
            }
        }
    }
    
    /**
     * @param bizRelation 设置 bizRelations 属性值为参数值 bizRelations
     */
    public void addBizRelation(BizRelationDTO bizRelation) {
        if (this.bizRelations == null) {
            bizRelations = new ArrayList<BizRelationDTO>(10);
        }
        bizRelations.add(bizRelation);
        bizRelation.setRoleaProcessNode(this);
    }
    
    /**
     * @return 获取 processName属性值
     */
    public String getProcessName() {
        return StringUtils.isNotBlank(processName) ? processName : (this.bizProcess == null ? null : bizProcess
            .getName());
    }
    
    /**
     * @param processName 设置 processName 属性值为参数值 processName
     */
    public void setProcessName(String processName) {
        this.processName = processName;
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
        return StringUtils.isNotBlank(processId) ? processId : (this.bizProcess == null ? null : bizProcess.getId());
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
     * @return 获取 roles属性值
     */
    public String getRoles() {
        return roles;
    }
    
    /**
     * @param roles 设置 roles 属性值为参数值 roles
     */
    public void setRoles(String roles) {
        this.roles = roles;
    }
    
    /**
     * @return 获取 bizProcessDTO属性值
     */
    public BizProcessDTO getBizProcess() {
        return bizProcess;
    }
    
    /**
     * @param bizProcessDTO 设置 bizProcessDTO 属性值为参数值 bizProcessDTO
     */
    public void setBizProcess(BizProcessDTO bizProcessDTO) {
        this.bizProcess = bizProcessDTO;
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
    
    /**
     * @return 获取 bizItemId属性值
     */
    public String getBizItemId() {
        return bizItemId;
    }
    
    /**
     * @param bizItemId 设置 bizItemId 属性值为参数值 bizItemId
     */
    public void setBizItemId(String bizItemId) {
        this.bizItemId = bizItemId;
    }
    
    /**
     * @return 获取 bizItemName属性值
     */
    public String getBizItemName() {
        return bizItemName;
    }
    
    /**
     * @param bizItemName 设置 bizItemName 属性值为参数值 bizItemName
     */
    public void setBizItemName(String bizItemName) {
        this.bizItemName = bizItemName;
    }
    
    /**
     * @return 获取 nodeFlagMap属性值
     */
    public Map<String, String> getNodeFlagMap() {
        return nodeFlagMap;
    }
    
    /**
     * @param nodeFlagMap 设置 nodeFlagMap 属性值为参数值 nodeFlagMap
     */
    public void setNodeFlagMap(Map<String, String> nodeFlagMap) {
        this.nodeFlagMap = nodeFlagMap;
    }
    
}
