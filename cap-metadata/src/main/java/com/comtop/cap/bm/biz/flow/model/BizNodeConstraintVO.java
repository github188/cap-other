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
 * 流程节点数据项约束
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-20 CAP
 */
@DataTransferObject
@Table(name = "CAP_BIZ_NODE_CONSTRAINT")
public class BizNodeConstraintVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 主键 */
    @Id
    @Column(name = "ID", length = 40)
    private String id;
    
    /** 节点ID */
    @Column(name = "NODE_ID", length = 40)
    private String nodeId;
    
    /** 数据对象ID */
    @Column(name = "BIZ_OBJ_ID", length = 40)
    private String bizObjId;
    
    /** 业务对象ID */
    @Column(name = "OBJ_DATA_ID", length = 40)
    private String objDataId;
    
    /** 约束规则集合（创建、变更、使用等） */
    @Column(name = "CHECK_RULE", length = 64)
    private String checkRule;
    
    /** 数据对象编码 */
    private String bizObjCode;
    
    /** 数据对象名称 */
    private String bizObjName;
    
    /** 数据项名称 */
    private String itemName;
    
    /** 序号 */
    @Column(name = "SORT_NO", precision = 10)
    private Integer sortNo;
    
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
     * @return 获取 节点ID属性值
     */
    
    public String getNodeId() {
        return nodeId;
    }
    
    /**
     * @param nodeId 设置 节点ID属性值为参数值 nodeId
     */
    
    public void setNodeId(String nodeId) {
        this.nodeId = nodeId;
    }
    
    /**
     * 
     * 获取数据对象ID
     * 
     * @return 数据对象ID
     */
    public String getBizObjId() {
        return bizObjId;
    }
    
    /**
     * 设置数据对象ID
     * 
     * @param bizObjId 数据对象ID
     */
    public void setBizObjId(String bizObjId) {
        this.bizObjId = bizObjId;
    }
    
    /**
     * @return 获取 业务对象ID属性值
     */
    
    public String getObjDataId() {
        return objDataId;
    }
    
    /**
     * @param objDataId 设置 业务对象ID属性值为参数值 objDataId
     */
    
    public void setObjDataId(String objDataId) {
        this.objDataId = objDataId;
    }
    
    /**
     * @return 获取 约束规则集合（创建、变更、使用等）属性值
     */
    
    public String getCheckRule() {
        return checkRule;
    }
    
    /**
     * @param checkRule 设置 约束规则集合（创建、变更、使用等）属性值为参数值 checkRule
     */
    
    public void setCheckRule(String checkRule) {
        this.checkRule = checkRule;
    }
    
    /**
     * 
     * 数据对象编码
     * 
     * @return 数据对象编码
     */
    public String getBizObjCode() {
        return bizObjCode;
    }
    
    /**
     * 
     * 数据对象编码
     * 
     * @param bizObjCode 数据对象编码
     */
    public void setBizObjCode(String bizObjCode) {
        this.bizObjCode = bizObjCode;
    }
    
    /**
     * 
     * 数据对象名称
     * 
     * @return 数据对象名称
     */
    public String getBizObjName() {
        return bizObjName;
    }
    
    /**
     * 
     * 数据对象名称
     * 
     * @param bizObjName 数据对象名称
     */
    public void setBizObjName(String bizObjName) {
        this.bizObjName = bizObjName;
    }
    
    /**
     * 
     * 数据对象项名称
     * 
     * @return 数据对象项名称
     */
    public String getItemName() {
        return itemName;
    }
    
    /**
     * 
     * 数据对象项名称
     * 
     * @param itemName 数据对象项名称
     */
    public void setItemName(String itemName) {
        this.itemName = itemName;
    }
    
}
