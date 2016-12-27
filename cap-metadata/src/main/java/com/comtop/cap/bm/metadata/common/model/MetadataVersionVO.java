/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.model;

import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import com.comtop.cap.runtime.base.model.BaseVO;
import com.comtop.cip.validator.org.hibernate.validator.constraints.Length;

/**
 * 元数据版本化
 * 
 * 
 * @author 沈康
 * @since 1.0
 * @version 2014-6-6 沈康
 */
@Table(name = "CIP_ENTITY_OPERATE_LOCK")
public class MetadataVersionVO extends BaseVO {
    
    /** 标识 */
    private static final long serialVersionUID = 1L;
    
    /** 主键ID */
    @Id
    @Length(max = 32)
    @Column(name = "LOCK_ID", length = 32)
    private String id;
    
    /**
     * 节点ID
     */
    @Length(max = 32)
    @Column(name = "NODE_ID", length = 32)
    private String nodeId;
    
    /**
     * 锁定标识
     */
    @Column(name = "LOCKED")
    private boolean locked;
    
    /**
     * 操作人员
     */
    @Length(max = 32)
    @Column(name = "OPERATOR", length = 32)
    private String operator;
    
    /**
     * 操作时间
     */
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "OPERATE_TIME")
    private java.sql.Timestamp operateTime;
    
    /**
     * @return 获取 nodeId属性值
     */
    public String getNodeId() {
        return nodeId;
    }
    
    /**
     * @param nodeId 设置 nodeId 属性值为参数值 nodeId
     */
    public void setNodeId(String nodeId) {
        this.nodeId = nodeId;
    }
    
    /**
     * @return 获取 locked属性值
     */
    public boolean getLocked() {
        return locked;
    }
    
    /**
     * @param locked 设置 locked 属性值为参数值 locked
     */
    public void setLocked(boolean locked) {
        this.locked = locked;
    }
    
    /**
     * @return 获取 operator属性值
     */
    public String getOperator() {
        return operator;
    }
    
    /**
     * @param operator 设置 operator 属性值为参数值 operator
     */
    public void setOperator(String operator) {
        this.operator = operator;
    }
    
    /**
     * @return 获取 operateTime属性值
     */
    public Timestamp getOperateTime() {
        return operateTime;
    }
    
    /**
     * @param operateTime 设置 operateTime 属性值为参数值 operateTime
     */
    public void setOperateTime(Timestamp operateTime) {
        this.operateTime = operateTime;
    }
    
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
}
