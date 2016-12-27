/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.model;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.document.word.docmodel.data.BaseDTO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 业务表单和业务流程节点的关联DTO
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-17 李志勇
 */
@DataTransferObject
public class BizFormNodeDTO extends BaseDTO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 业务表单ID */
    private String formId;
    
    /** 业务表单ID */
    private String formName;
    
    /** 业务表单编码 */
    private String formCode;
    
    /** 业务流程节点ID */
    private String nodeId;
    
    /** 业务流程节点ID */
    private String nodeName;
    
    /** 业务流程节点ID */
    private String nodeSerialNo;
    
    /** 流程名称 */
    private String processName;
    
    /** 业务事项 */
    private String bizItemName;
    
    /** 流程id */
    private String processId;
    
    /** 业务事项Id */
    private String bizItemId;
    
    /** 流程节点 */
    private BizProcessNodeDTO bizProcessNode;
    
    /**
     * @return 获取 processId属性值
     */
    public String getProcessId() {
        return processId;
    }
    
    /**
     * @param processId 设置 processId 属性值为参数值 processId
     */
    public void setProcessId(String processId) {
        this.processId = processId;
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
     * @return 获取 业务表单ID属性值
     */
    
    public String getFormId() {
        return formId;
    }
    
    /**
     * @return 获取 nodeSerialNo属性值
     */
    public String getNodeSerialNo() {
        return nodeSerialNo;
    }
    
    /**
     * @param nodeSerialNo 设置 nodeSerialNo 属性值为参数值 nodeSerialNo
     */
    public void setNodeSerialNo(String nodeSerialNo) {
        this.nodeSerialNo = nodeSerialNo;
    }
    
    /**
     * @param formId 设置 业务表单ID属性值为参数值 formId
     */
    
    public void setFormId(String formId) {
        this.formId = formId;
    }
    
    /**
     * @return 获取 业务流程节点ID属性值
     */
    
    public String getNodeId() {
        return StringUtils.isNotBlank(nodeId) ? nodeId : (bizProcessNode == null ? null : bizProcessNode.getId());
    }
    
    /**
     * @param nodeId 设置 业务流程节点ID属性值为参数值 nodeId
     */
    
    public void setNodeId(String nodeId) {
        this.nodeId = nodeId;
    }
    
    /**
     * @return 获取 formName属性值
     */
    public String getFormName() {
        return formName;
    }
    
    /**
     * @param formName 设置 formName 属性值为参数值 formName
     */
    public void setFormName(String formName) {
        this.formName = formName;
    }
    
    /**
     * @return 获取 nodeName属性值
     */
    public String getNodeName() {
        return nodeName;
    }
    
    /**
     * @param nodeName 设置 nodeName 属性值为参数值 nodeName
     */
    public void setNodeName(String nodeName) {
        this.nodeName = nodeName;
    }
    
    /**
     * @return 获取 bizProcessNode属性值
     */
    public BizProcessNodeDTO getBizProcessNode() {
        return bizProcessNode;
    }
    
    /**
     * @param bizProcessNode 设置 bizProcessNode 属性值为参数值 bizProcessNode
     */
    public void setBizProcessNode(BizProcessNodeDTO bizProcessNode) {
        this.bizProcessNode = bizProcessNode;
    }
    
    /**
     * @return 获取 formCode属性值
     */
    public String getFormCode() {
        return formCode;
    }
    
    /**
     * @param formCode 设置 formCode 属性值为参数值 formCode
     */
    public void setFormCode(String formCode) {
        this.formCode = formCode;
    }
    
}
