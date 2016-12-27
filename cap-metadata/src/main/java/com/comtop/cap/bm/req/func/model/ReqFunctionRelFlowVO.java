/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.func.model;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.top.core.base.model.CoreVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 功能项与流程关联表
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-12-10 CAP
 */
@DataTransferObject
@Table(name = "CAP_REQ_FUNCTION_REL_FLOW")
public class ReqFunctionRelFlowVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 主键 */
    @Id
    @Column(name = "ID", length = 40)
    private String id;
    
    /** 功能项ID */
    @Column(name = "FUNCTION_ITEM_ID", length = 40)
    private String functionItemId;
    
    /** 业务流程ID */
    @Column(name = "BIZ_FLOW_ID", length = 40)
    private String bizFlowId;
    
    /** 业务流程名称 */
    private String bizFlowName;
    
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
     * @return 获取 功能项ID属性值
     */
    
    public String getFunctionItemId() {
        return functionItemId;
    }
    
    /**
     * @param functionItemId 设置 功能项ID属性值为参数值 functionItemId
     */
    
    public void setFunctionItemId(String functionItemId) {
        this.functionItemId = functionItemId;
    }
    
    /**
     * @return 获取 业务流程ID属性值
     */
    
    public String getBizFlowId() {
        return bizFlowId;
    }
    
    /**
     * @param bizFlowId 设置 业务流程ID属性值为参数值 bizFlowId
     */
    
    public void setBizFlowId(String bizFlowId) {
        this.bizFlowId = bizFlowId;
    }
    
    /**
     * @return 获取 bizFlowName属性值
     */
    public String getBizFlowName() {
        return bizFlowName;
    }
    
    /**
     * @param bizFlowName 设置 bizFlowName 属性值为参数值 bizFlowName
     */
    public void setBizFlowName(String bizFlowName) {
        this.bizFlowName = bizFlowName;
    }
    
}
