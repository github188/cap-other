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
 * 业务表单和业务流程节点关系表
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-24 CAP
 */
@DataTransferObject
@Table(name = "CAP_BIZ_FORM_NODE_REL")
public class BizFormNodeRelVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 主键 */
    @Id
    @Column(name = "ID", length = 40)
    private String id;
    
    /** 业务表单ID */
    @Column(name = "FORM_ID", length = 40)
    private String formId;
    
    /** 业务流程节点ID */
    @Column(name = "NODE_ID", length = 40)
    private String nodeId;
    
    /** 表单编码 */
    private String code;
    
    /** 表单名称 */
    private String name;
    
    /** 说明 */
    private String remark;
    
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
     * @return 获取 业务表单ID属性值
     */
    
    public String getFormId() {
        return formId;
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
        return nodeId;
    }
    
    /**
     * @param nodeId 设置 业务流程节点ID属性值为参数值 nodeId
     */
    
    public void setNodeId(String nodeId) {
        this.nodeId = nodeId;
    }
    
    /**
     * @return 获取 表单编码属性值
     */
    
    public String getCode() {
        return code;
    }
    
    /**
     * @param code 设置 表单编码属性值为参数值 code
     */
    
    public void setCode(String code) {
        this.code = code;
    }
    
    /**
     * @return 获取 表单名称属性值
     */
    
    public String getName() {
        return name;
    }
    
    /**
     * @param name 设置 表单名称属性值为参数值 name
     */
    
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * @return 获取 说明属性值
     */
    
    public String getRemark() {
        return remark;
    }
    
    /**
     * @param remark 设置 说明属性值为参数值 remark
     */
    
    public void setRemark(String remark) {
        this.remark = remark;
    }
}
