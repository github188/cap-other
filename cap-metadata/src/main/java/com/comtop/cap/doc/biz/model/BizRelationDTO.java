/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.model;

import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.document.word.docmodel.data.BaseDTO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 业务关联DTO
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-17 李志勇
 */
@DataTransferObject
public class BizRelationDTO extends BaseDTO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 关联数据项 */
    private List<BizRelationDataItemDTO> dataItemList;
    
    /** 本方一级业务 */
    private String roleaFirstLevelBiz;
    
    /** 本方一级业务 */
    private String roleaSecondLevelBiz;
    
    /** 本方业务事项名称 */
    private String roleaItemName;
    
    /** 本方业务事项id */
    private String roleaItemId;
    
    /** 对方一级业务 */
    private String rolebFirstLevelBiz;
    
    /** 对方二级业务 */
    private String rolebSecondLevelBiz;
    
    /** 对方业务事项名称 */
    private String rolebItemName;
    
    /** 流程节点 */
    private BizProcessNodeDTO roleaProcessNode;
    
    /** 对方业务事项 id */
    private String rolebItemId;
    
    /** 关联类型 */
    private String relType;
    
    /** 0，输入,1，输出 */
    private String relOrient;
    
    /** 触发条件 */
    private String triggerCondition;
    
    /** 本方业务域ID */
    private String roleaDomainId;
    
    /** 本方业务域名称 */
    private String roleaDomainName;
    
    /** 本方业务流程ID */
    private String roleaProcessId;
    
    /** 本方业务流程名称 */
    private String roleaProcessName;
    
    /** 本方节点ID */
    private String roleaNodeId;
    
    /** 本方业务流程节点名称 */
    private String roleaNodeName;
    
    /** 本方业务流程节点编号 */
    private String roleaNodeSerialNo;
    
    /** 本方协同工作内容 */
    private String roleaWorkContext;
    
    /** 本方协同工作要求 */
    private String roleaWorkDemand;
    
    /** 对方业务域ID */
    private String rolebDomainId;
    
    /** 对方业务域名称 */
    private String rolebDomainName;
    
    /** 对方业务流程ID */
    private String rolebProcessId;
    
    /** 对方业务流程名称 */
    private String rolebProcessName;
    
    /** 对方业务流程节点ID */
    private String rolebNodeId;
    
    /** 对方业务流程节点名称 */
    private String rolebNodeName;
    
    /** 对方协同工作内容 */
    private String rolebWorkContext;
    
    /** 对方协同工作要求 */
    private String rolebWorkDemand;
    
    /** 关系描述 */
    private String description;
    
    /**
     * @return 获取 roleaProcessNode属性值
     */
    public BizProcessNodeDTO getRoleaProcessNode() {
        return roleaProcessNode;
    }
    
    /**
     * @param roleaProcessNode 设置 roleaProcessNode 属性值为参数值 roleaProcessNode
     */
    public void setRoleaProcessNode(BizProcessNodeDTO roleaProcessNode) {
        this.roleaProcessNode = roleaProcessNode;
    }
    
    /**
     * @return 获取 roleaNodeSerialNo属性值
     */
    public String getRoleaNodeSerialNo() {
        return roleaNodeSerialNo;
    }
    
    /**
     * @param roleaNodeSerialNo 设置 roleaNodeSerialNo 属性值为参数值 roleaNodeSerialNo
     */
    public void setRoleaNodeSerialNo(String roleaNodeSerialNo) {
        this.roleaNodeSerialNo = roleaNodeSerialNo;
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
     * @return 获取 dataItemList属性值
     */
    public List<BizRelationDataItemDTO> getDataItemList() {
        return dataItemList;
    }
    
    /**
     * @param dataItemList 设置 dataItemList 属性值为参数值 dataItemList
     */
    public void setDataItemList(List<BizRelationDataItemDTO> dataItemList) {
        this.dataItemList = dataItemList;
    }
    
    /**
     * @return 获取 关联类型属性值
     */
    
    public String getRelType() {
        return relType;
    }
    
    /**
     * @param relType 设置 关联类型属性值为参数值 relType
     */
    
    public void setRelType(String relType) {
        this.relType = relType;
    }
    
    /**
     * @return 获取 0，输入,1，输出属性值
     */
    
    public String getRelOrient() {
        return relOrient;
    }
    
    /**
     * @param relOrient 设置 0，输入,1，输出属性值为参数值 relOrient
     */
    
    public void setRelOrient(String relOrient) {
        this.relOrient = relOrient;
    }
    
    /**
     * @return 获取 触发条件属性值
     */
    
    public String getTriggerCondition() {
        return triggerCondition;
    }
    
    /**
     * @param triggerCondition 设置 触发条件属性值为参数值 triggerCondition
     */
    
    public void setTriggerCondition(String triggerCondition) {
        this.triggerCondition = triggerCondition;
    }
    
    /**
     * @return 获取 本方业务域ID属性值
     */
    
    public String getRoleaDomainId() {
        return roleaDomainId;
    }
    
    /**
     * @param roleaDomainId 设置 本方业务域ID属性值为参数值 roleaDomainId
     */
    
    public void setRoleaDomainId(String roleaDomainId) {
        this.roleaDomainId = roleaDomainId;
    }
    
    /**
     * @return 获取 本方业务域名称属性值
     */
    
    public String getRoleaDomainName() {
        return roleaDomainName;
    }
    
    /**
     * @param roleaDomainName 设置 本方业务域名称属性值为参数值 roleaDomainName
     */
    
    public void setRoleaDomainName(String roleaDomainName) {
        this.roleaDomainName = roleaDomainName;
    }
    
    /**
     * @return 获取 本方业务流程ID属性值
     */
    
    public String getRoleaProcessId() {
        return roleaProcessId;
    }
    
    /**
     * @param roleaProcessId 设置 本方业务流程ID属性值为参数值 roleaProcessId
     */
    
    public void setRoleaProcessId(String roleaProcessId) {
        this.roleaProcessId = roleaProcessId;
    }
    
    /**
     * @return 获取 本方业务流程名称属性值
     */
    
    public String getRoleaProcessName() {
        return roleaProcessName;
    }
    
    /**
     * @param roleaProcessName 设置 本方业务流程名称属性值为参数值 roleaProcessName
     */
    
    public void setRoleaProcessName(String roleaProcessName) {
        this.roleaProcessName = roleaProcessName;
    }
    
    /**
     * @return 获取 本方节点ID属性值
     */
    
    public String getRoleaNodeId() {
        return StringUtils.isNotBlank(roleaNodeId) ? roleaNodeId : (roleaProcessNode == null ? null : roleaProcessNode
            .getId());
    }
    
    /**
     * @param roleaNodeId 设置 本方节点ID属性值为参数值 roleaNodeId
     */
    
    public void setRoleaNodeId(String roleaNodeId) {
        this.roleaNodeId = roleaNodeId;
    }
    
    /**
     * @return 获取 本方业务流程节点名称属性值
     */
    
    public String getRoleaNodeName() {
        return roleaNodeName;
    }
    
    /**
     * @param roleaNodeName 设置 本方业务流程节点名称属性值为参数值 roleaNodeName
     */
    
    public void setRoleaNodeName(String roleaNodeName) {
        this.roleaNodeName = roleaNodeName;
    }
    
    /**
     * @return 获取 本方协同工作内容属性值
     */
    
    public String getRoleaWorkContext() {
        return roleaWorkContext;
    }
    
    /**
     * @param roleaWorkContext 设置 本方协同工作内容属性值为参数值 roleaWorkContext
     */
    
    public void setRoleaWorkContext(String roleaWorkContext) {
        this.roleaWorkContext = roleaWorkContext;
    }
    
    /**
     * @return 获取 本方协同工作要求属性值
     */
    
    public String getRoleaWorkDemand() {
        return roleaWorkDemand;
    }
    
    /**
     * @param roleaWorkDemand 设置 本方协同工作要求属性值为参数值 roleaWorkDemand
     */
    
    public void setRoleaWorkDemand(String roleaWorkDemand) {
        this.roleaWorkDemand = roleaWorkDemand;
    }
    
    /**
     * @return 获取 对方业务域ID属性值
     */
    
    public String getRolebDomainId() {
        return rolebDomainId;
    }
    
    /**
     * @param rolebDomainId 设置 对方业务域ID属性值为参数值 rolebDomainId
     */
    
    public void setRolebDomainId(String rolebDomainId) {
        this.rolebDomainId = rolebDomainId;
    }
    
    /**
     * @return 获取 对方业务域名称属性值
     */
    
    public String getRolebDomainName() {
        return rolebDomainName;
    }
    
    /**
     * @param rolebDomainName 设置 对方业务域名称属性值为参数值 rolebDomainName
     */
    
    public void setRolebDomainName(String rolebDomainName) {
        this.rolebDomainName = rolebDomainName;
    }
    
    /**
     * @return 获取 对方业务流程ID属性值
     */
    
    public String getRolebProcessId() {
        return rolebProcessId;
    }
    
    /**
     * @param rolebProcessId 设置 对方业务流程ID属性值为参数值 rolebProcessId
     */
    
    public void setRolebProcessId(String rolebProcessId) {
        this.rolebProcessId = rolebProcessId;
    }
    
    /**
     * @return 获取 对方业务流程名称属性值
     */
    
    public String getRolebProcessName() {
        return rolebProcessName;
    }
    
    /**
     * @param rolebProcessName 设置 对方业务流程名称属性值为参数值 rolebProcessName
     */
    
    public void setRolebProcessName(String rolebProcessName) {
        this.rolebProcessName = rolebProcessName;
    }
    
    /**
     * @return 获取 对方业务流程节点ID属性值
     */
    
    public String getRolebNodeId() {
        return rolebNodeId;
    }
    
    /**
     * @param rolebNodeId 设置 对方业务流程节点ID属性值为参数值 rolebNodeId
     */
    
    public void setRolebNodeId(String rolebNodeId) {
        this.rolebNodeId = rolebNodeId;
    }
    
    /**
     * @return 获取 对方业务流程节点名称属性值
     */
    
    public String getRolebNodeName() {
        return rolebNodeName;
    }
    
    /**
     * @param rolebNodeName 设置 对方业务流程节点名称属性值为参数值 rolebNodeName
     */
    
    public void setRolebNodeName(String rolebNodeName) {
        this.rolebNodeName = rolebNodeName;
    }
    
    /**
     * @return 获取 对方协同工作内容属性值
     */
    
    public String getRolebWorkContext() {
        return rolebWorkContext;
    }
    
    /**
     * @param rolebWorkContext 设置 对方协同工作内容属性值为参数值 rolebWorkContext
     */
    
    public void setRolebWorkContext(String rolebWorkContext) {
        this.rolebWorkContext = rolebWorkContext;
    }
    
    /**
     * @return 获取 对方协同工作要求属性值
     */
    
    public String getRolebWorkDemand() {
        return rolebWorkDemand;
    }
    
    /**
     * @param rolebWorkDemand 设置 对方协同工作要求属性值为参数值 rolebWorkDemand
     */
    
    public void setRolebWorkDemand(String rolebWorkDemand) {
        this.rolebWorkDemand = rolebWorkDemand;
    }
    
    /**
     * @return 获取 roleaFirstLevelBiz属性值
     */
    public String getRoleaFirstLevelBiz() {
        return roleaFirstLevelBiz;
    }
    
    /**
     * @param roleaFirstLevelBiz 设置 roleaFirstLevelBiz 属性值为参数值 roleaFirstLevelBiz
     */
    public void setRoleaFirstLevelBiz(String roleaFirstLevelBiz) {
        this.roleaFirstLevelBiz = roleaFirstLevelBiz;
    }
    
    /**
     * @return 获取 roleaSecondLevelBiz属性值
     */
    public String getRoleaSecondLevelBiz() {
        return roleaSecondLevelBiz;
    }
    
    /**
     * @param roleaSecondLevelBiz 设置 roleaSecondLevelBiz 属性值为参数值 roleaSecondLevelBiz
     */
    public void setRoleaSecondLevelBiz(String roleaSecondLevelBiz) {
        this.roleaSecondLevelBiz = roleaSecondLevelBiz;
    }
    
    /**
     * @return 获取 roleaItemName属性值
     */
    public String getRoleaItemName() {
        return roleaItemName;
    }
    
    /**
     * @param roleaItemName 设置 roleaItemName 属性值为参数值 roleaItemName
     */
    public void setRoleaItemName(String roleaItemName) {
        this.roleaItemName = roleaItemName;
    }
    
    /**
     * @return 获取 roleaItemId属性值
     */
    public String getRoleaItemId() {
        return roleaItemId;
    }
    
    /**
     * @param roleaItemId 设置 roleaItemId 属性值为参数值 roleaItemId
     */
    public void setRoleaItemId(String roleaItemId) {
        this.roleaItemId = roleaItemId;
    }
    
    /**
     * @return 获取 rolebItemName属性值
     */
    public String getRolebItemName() {
        return rolebItemName;
    }
    
    /**
     * @param rolebItemName 设置 rolebItemName 属性值为参数值 rolebItemName
     */
    public void setRolebItemName(String rolebItemName) {
        this.rolebItemName = rolebItemName;
    }
    
    /**
     * @return 获取 rolebItemId属性值
     */
    public String getRolebItemId() {
        return rolebItemId;
    }
    
    /**
     * @param rolebItemId 设置 rolebItemId 属性值为参数值 rolebItemId
     */
    public void setRolebItemId(String rolebItemId) {
        this.rolebItemId = rolebItemId;
    }
    
    /**
     * @return 获取 rolebFirstLevelBiz属性值
     */
    public String getRolebFirstLevelBiz() {
        return rolebFirstLevelBiz;
    }
    
    /**
     * @param rolebFirstLevelBiz 设置 rolebFirstLevelBiz 属性值为参数值 rolebFirstLevelBiz
     */
    public void setRolebFirstLevelBiz(String rolebFirstLevelBiz) {
        this.rolebFirstLevelBiz = rolebFirstLevelBiz;
    }
    
    /**
     * @return 获取 rolebSecondLevelBiz属性值
     */
    public String getRolebSecondLevelBiz() {
        return rolebSecondLevelBiz;
    }
    
    /**
     * @param rolebSecondLevelBiz 设置 rolebSecondLevelBiz 属性值为参数值 rolebSecondLevelBiz
     */
    public void setRolebSecondLevelBiz(String rolebSecondLevelBiz) {
        this.rolebSecondLevelBiz = rolebSecondLevelBiz;
    }
}
