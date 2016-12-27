/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.model;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.cap.bm.metadata.base.model.AbstractBaseMetaDataVO;
import com.comtop.cap.bm.metadata.base.model.IMetaNode;
import com.comtop.cip.validator.org.hibernate.validator.constraints.Length;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 目录树导航表
 * 
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-3-17 李忠文
 */
@DataTransferObject
@Table(name = "CIP_DIRECTORY")
public class DirectoryVO extends AbstractBaseMetaDataVO implements IMetaNode {
    
    /** 标识 */
    private static final long serialVersionUID = 1L;
    
    /** 树节点ID */
    @Id
    @Length(max = 32)
    @Column(name = "NODE_ID", length = 32)
    private String id;
    
    /**
     * 树节点类型，
     * 分为普通包、模块、实体、表、查询；后续还可能增加类型；
     * 可以分别用固定的英文标识,
     * 如package,module,entity,table.query
     */
    @Length(max = 30)
    @Column(name = "NODE_TYPE", length = 30)
    private String nodeType;
    
    /** 上级节点导航ID */
    @Length(max = 32)
    @Column(name = "PARENT_NODE_ID", length = 32)
    private String parentNodeId;
    
    /** 项目ID */
    @Length(max = 32)
    @Column(name = "PROJECT_ID", length = 32)
    private String projectId;
    
    /** 节点状态,0表示与中央库一致，1表示本地新增，2表示本地修改，3表示本地删除 */
    @Column(name = "NODE_STATE")
    private int nodeStatus;
    
    /** 实体对应的表名称 */
    @Column(name = "ENTITY_TABLE_NAME")
    private String tableName;
    
    /**
     * @return 获取 id属性值
     * @see com.comtop.cap.runtime.base.model.BaseVO#getId()
     */
    @Override
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置 id 属性值为参数值 id
     * @see com.comtop.cap.runtime.base.model.BaseVO#setId(java.lang.String)
     */
    @Override
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 nodeType属性值
     */
    @Override
    public String getNodeType() {
        return nodeType;
    }
    
    /**
     * @param nodeType 设置 nodeType 属性值为参数值 nodeType
     */
    public void setNodeType(String nodeType) {
        this.nodeType = nodeType;
    }
    
    /**
     * @return 获取 parentNodeId属性值
     */
    public String getParentNodeId() {
        return parentNodeId;
    }
    
    /**
     * @param parentNodeId 设置 parentNodeId 属性值为参数值 parentNodeId
     */
    public void setParentNodeId(String parentNodeId) {
        this.parentNodeId = parentNodeId;
    }
    
    /**
     * 获取节点Id
     * 
     * @return 节点Id
     * @see com.comtop.cap.bm.metadata.base.model.IMetaNode#getNodeId()
     */
    @Override
    public String getNodeId() {
        return this.id;
    }
    
    /**
     * @return 获取 projectId属性值
     */
    public String getProjectId() {
        return projectId;
    }
    
    /**
     * @param projectId 设置 projectId 属性值为参数值 projectId
     */
    public void setProjectId(String projectId) {
        this.projectId = projectId;
    }
    
    /**
     * @return 获取 nodeStatus属性值
     */
    public int getNodeStatus() {
        return nodeStatus;
    }
    
    /**
     * @param nodeStatus 设置 nodeStatus 属性值为参数值 nodeStatus
     */
    public void setNodeStatus(int nodeStatus) {
        this.nodeStatus = nodeStatus;
    }
    
    /**
     * @return 获取 tableName属性值
     */
    @Override
    public String getTableName() {
        return tableName;
    }
    
    /**
     * @param tableName 设置 tableName 属性值为参数值 tableName
     */
    public void setTableName(String tableName) {
        this.tableName = tableName;
    }
    
}
