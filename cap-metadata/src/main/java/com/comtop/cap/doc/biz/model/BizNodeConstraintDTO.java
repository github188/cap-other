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
 * 业务约束DTO 指 业务对象在某个流程节点（流程环节）时可以进行的操作，比如可以创建某些属性的值，可以修改某些属性的值，只能读取等
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月17日 lizhiyong
 */
@DataTransferObject
public class BizNodeConstraintDTO extends BaseDTO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 数据项名称 */
    private String dataItemName;
    
    /** 数据项id */
    private String dataItemId;
    
    /** 业务对象名称 */
    private String objectName;
    
    /** 业务对象code */
    private String objectCode;
    
    /** 业务对象包id */
    private String objectPackageId;
    
    /** 业务对象包id */
    private String objectPackageName;
    
    /** 业务对象id */
    private String objectId;
    
    /** 节点id */
    private String nodeId;
    
    /** 节点名称 */
    private String nodeName;
    
    /** 节点编号 */
    private String nodeSerialNo;
    
    /** 流程节点 */
    private BizProcessNodeDTO bizProcessNode;
    
    /** 流程id */
    private String processId;
    
    /** 流程名称 */
    private String processName;
    
    /** 业务事项名称 */
    private String bizItemName;
    
    /** 业务事项Id */
    private String bizItemId;
    
    /**
     * @return 获取 objectPackageName属性值
     */
    public String getObjectPackageName() {
        return objectPackageName;
    }
    
    /**
     * @param objectPackageName 设置 objectPackageName 属性值为参数值 objectPackageName
     */
    public void setObjectPackageName(String objectPackageName) {
        this.objectPackageName = objectPackageName;
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
    
    /** 约束 */
    private String checkRule;
    
    /**
     * @return 获取 objectPackageId属性值
     */
    public String getObjectPackageId() {
        return objectPackageId;
    }
    
    /**
     * @param objectPackageId 设置 objectPackageId 属性值为参数值 objectPackageId
     */
    public void setObjectPackageId(String objectPackageId) {
        this.objectPackageId = objectPackageId;
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
     * @return 获取 nodeId属性值
     */
    public String getNodeId() {
        return StringUtils.isNotBlank(nodeId) ? nodeId : (bizProcessNode == null ? null : bizProcessNode.getId());
    }
    
    /**
     * @param nodeId 设置 nodeId 属性值为参数值 nodeId
     */
    public void setNodeId(String nodeId) {
        this.nodeId = nodeId;
    }
    
    /**
     * @return 获取 checkRule属性值
     */
    public String getCheckRule() {
        return checkRule;
    }
    
    /**
     * @param checkRule 设置 checkRule 属性值为参数值 checkRule
     */
    public void setCheckRule(String checkRule) {
        this.checkRule = checkRule;
    }
    
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
     * @return 获取 objectName属性值
     */
    public String getObjectName() {
        return objectName;
    }
    
    /**
     * @param objectName 设置 objectName 属性值为参数值 objectName
     */
    public void setObjectName(String objectName) {
        this.objectName = objectName;
    }
    
    /**
     * @return 获取 objectCode属性值
     */
    public String getObjectCode() {
        return objectCode;
    }
    
    /**
     * @param objectCode 设置 objectCode 属性值为参数值 objectCode
     */
    public void setObjectCode(String objectCode) {
        this.objectCode = objectCode;
    }
    
    /**
     * @return 获取 objectId属性值
     */
    public String getObjectId() {
        return objectId;
    }
    
    /**
     * @param objectId 设置 objectId 属性值为参数值 objectId
     */
    public void setObjectId(String objectId) {
        this.objectId = objectId;
    }
    
    /**
     * @return 获取 dataItemName属性值
     */
    public String getDataItemName() {
        return dataItemName;
    }
    
    /**
     * @param dataItemName 设置 dataItemName 属性值为参数值 dataItemName
     */
    public void setDataItemName(String dataItemName) {
        this.dataItemName = dataItemName;
    }
    
    /**
     * @return 获取 dataItemId属性值
     */
    public String getDataItemId() {
        return dataItemId;
    }
    
    /**
     * @param dataItemId 设置 dataItemId 属性值为参数值 dataItemId
     */
    public void setDataItemId(String dataItemId) {
        this.dataItemId = dataItemId;
    }
}
