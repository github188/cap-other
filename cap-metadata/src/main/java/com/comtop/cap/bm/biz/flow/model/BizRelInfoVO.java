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
 * 业务关联
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-26 CAP
 */
@DataTransferObject
@Table(name = "CAP_BIZ_REL_INFO")
public class BizRelInfoVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 业务流程节点,由CIP自动创建。 */
    private BizProcessNodeVO bizProcessNodeVO;
    
    /** 主键 */
    @Id
    @Column(name = "ID", length = 40)
    private String id;
    
    /** 编码 */
    @Column(name = "CODE", length = 250)
    private String code;
    
    /** 名称 */
    @Column(name = "NAME", length = 200)
    private String name;
    
    /** 关联类型 */
    @Column(name = "REL_TYPE", length = 36)
    private String relType;
    
    /** 1，输入,2，输出 */
    @Column(name = "REL_ORIENT", length = 10)
    private String relOrient;
    
    /** 触发条件 */
    @Column(name = "TRIGGER_CONDITION", length = 512)
    private String triggerCondition;
    
    /** 本方业务域ID */
    @Column(name = "ROLEA_DOMAIN_ID", length = 40)
    private String roleaDomainId;
    
    /** 本方业务事项id */
    @Column(name = "ROLEA_ITEM_ID", length = 40)
    private String roleaItemId;
    
    /** 本方业务事项名称 */
    @Column(name = "ROLEA_ITEM_NAME", length = 200)
    private String roleaItemName;
    
    /** 本方业务域名称 */
    @Column(name = "ROLEA_DOMAIN_NAME", length = 200)
    private String roleaDomainName;
    
    /** 本方业务流程ID */
    @Column(name = "ROLEA_PROCESS_ID", length = 40)
    private String roleaProcessId;
    
    /** 本方业务流程名称 */
    @Column(name = "ROLEA_PROCESS_NAME", length = 200)
    private String roleaProcessName;
    
    /** 本方节点ID */
    @Column(name = "ROLEA_NODE_ID", length = 40)
    private String roleaNodeId;
    
    /** 本方业务流程节点名称 */
    @Column(name = "ROLEA_NODE_NAME", length = 200)
    private String roleaNodeName;
    
    /** 本方协同工作内容 */
    @Column(name = "ROLEA_WORK_CONTEXT", length = 512)
    private String roleaWorkContext;
    
    /** 本方协同工作要求 */
    @Column(name = "ROLEA_WORK_DEMAND", length = 512)
    private String roleaWorkDemand;
    
    /** 对方业务域ID */
    @Column(name = "ROLEB_DOMAIN_ID", length = 40)
    private String rolebDomainId;
    
    /** 对方业务域名称 */
    @Column(name = "ROLEB_DOMAIN_NAME", length = 200)
    private String rolebDomainName;
    
    /** 对方业务事项id */
    @Column(name = "ROLEB_ITEM_ID", length = 40)
    private String rolebItemId;
    
    /** 对方业务事项名称 */
    @Column(name = "ROLEB_ITEM_NAME", length = 200)
    private String rolebItemName;
    
    /** 对方业务流程ID */
    @Column(name = "ROLEB_PROCESS_ID", length = 40)
    private String rolebProcessId;
    
    /** 对方业务流程名称 */
    @Column(name = "ROLEB_PROCESS_NAME", length = 200)
    private String rolebProcessName;
    
    /** 对方业务流程节点ID */
    @Column(name = "ROLEB_NODE_ID", length = 40)
    private String rolebNodeId;
    
    /** 对方业务流程节点名称 */
    @Column(name = "ROLEB_NODE_NAME", length = 200)
    private String rolebNodeName;
    
    /** 对方协同工作内容 */
    @Column(name = "ROLEB_WORK_CONTEXT", length = 512)
    private String rolebWorkContext;
    
    /** 对方协同工作要求 */
    @Column(name = "ROLEB_WORK_DEMAND", length = 512)
    private String rolebWorkDemand;
    
    /** 数据来源，1：导入；0：系统创建； */
    @Column(name = "DATA_FROM", precision = 1)
    private Integer dataFrom;
    
    /** 文档ID */
    @Column(name = "DOCUMENT_ID", length = 40)
    private String documentId;
    
    /** 序号 */
    @Column(name = "SORT_NO", precision = 10)
    private Integer sortNo;
    
    /** 查询id */
    private String queryId;
    
    /** 编码表达式 */
    private static final String codeExpr = "RE-${seq('BizRelation',10,1,1)}";
    
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
     * @return 获取 codeExpr属性值
     */
    public static String getCodeExpr() {
        return codeExpr;
    }
    
    /**
     * 
     * 获取业务流程节点
     * 
     * @return 业务流程节点
     */
    public BizProcessNodeVO getBizProcessNodeVO() {
        return bizProcessNodeVO;
    }
    
    /**
     * 
     * 设置业务流程节点
     * 
     * @param bizProcessNodeVO 业务流程节点
     */
    public void setBizProcessNodeVO(BizProcessNodeVO bizProcessNodeVO) {
        this.bizProcessNodeVO = bizProcessNodeVO;
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
     * @return 获取 编码属性值
     */
    
    public String getCode() {
        return code;
    }
    
    /**
     * @param code 设置 编码属性值为参数值 code
     */
    
    public void setCode(String code) {
        this.code = code;
    }
    
    /**
     * @return 获取 名称属性值
     */
    
    public String getName() {
        return name;
    }
    
    /**
     * @param name 设置 名称属性值为参数值 name
     */
    
    public void setName(String name) {
        this.name = name;
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
     * @param relOrient 设置 ，输入，输出属性值为参数值 relOrient
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
        return roleaNodeId;
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
     * 获取查询id
     * 
     * @return 查询id
     */
    public String getQueryId() {
        return queryId;
    }
    
    /**
     * 设置查询id
     * 
     * @param queryId 查询id
     */
    public void setQueryId(String queryId) {
        this.queryId = queryId;
    }
    
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
    
}
