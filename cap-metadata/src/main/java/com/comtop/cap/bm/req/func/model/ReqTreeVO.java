/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.func.model;

import javax.persistence.Column;
import javax.persistence.Table;

import com.comtop.top.core.base.model.CoreVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 功能项需求视图（包含业务领域、功能项、功能子项）
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-25 CAP
 */
@DataTransferObject
@Table(name = "V_CAP_REQ_TREE")
public class ReqTreeVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 主键ID，业务域ID、功能项ID、功能子项表ID */
    @Column(name = "ID", length = 80)
    private String id;
    
    /** 上级ID */
    @Column(name = "PARENT_ID", length = 80)
    private String parentId;
    
    /** 名称 */
    @Column(name = "NAME", length = 80)
    private String name;
    
    /** 类型,1:业务域、2：功能项、3：功能子项 */
    @Column(name = "TYPE", length = 80)
    private String type;
    
    /** 排序号 */
    @Column(name = "SORT_NO", precision = 10)
    private Integer sortNo;
    
    /** 排序号 */
    @Column(name = "CODE")
    private String code;
    
    /**
     * @return 获取 code属性值
     */
    public String getCode() {
        return code;
    }
    
    /**
     * @param code 设置 code 属性值为参数值 code
     */
    public void setCode(String code) {
        this.code = code;
    }
    
    /**
     * @return 获取 id属性值
     */
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置 id 属性值为参数值 id
     */
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 上级ID
     */
    public String getParentId() {
        return parentId;
    }
    
    /**
     * @param parentId 上级ID
     */
    public void setParentId(String parentId) {
        this.parentId = parentId;
    }
    
    /**
     * @return 获取 name属性值
     */
    public String getName() {
        return name;
    }
    
    /**
     * @param name 设置 name 属性值为参数值 name
     */
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * @return 获取 type属性值
     */
    public String getType() {
        return type;
    }
    
    /**
     * @param type 设置 type 属性值为参数值 type
     */
    public void setType(String type) {
        this.type = type;
    }
    
    /**
     * @return 获取 排序号属性值
     */
    
    public Integer getSortNo() {
        return sortNo;
    }
    
    /**
     * @param sortNo 设置 排序号属性值为参数值 sortNo
     */
    
    public void setSortNo(Integer sortNo) {
        this.sortNo = sortNo;
    }
    
    @Override
    public String toString() {
        return "ReqTreeVO [id=" + id + ", paaentId=" + parentId + ", name=" + name + ", type=" + type + "]";
    }
    
}
