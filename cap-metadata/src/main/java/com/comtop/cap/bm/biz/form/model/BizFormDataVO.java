/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.form.model;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import com.comtop.cap.bm.biz.common.model.BizBaseVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * BizFormData
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-11-17 姜子豪
 */
@DataTransferObject
@Table(name = "CAP_BIZ_FORM_DATA")
public class BizFormDataVO extends BizBaseVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 业务表单,由CIP自动创建。 */
    private BizFormVO bizFormByFromtofromdata;
    
    /** 主键 */
    @Id
    @Column(name = "ID", length = 40)
    private String id;
    
    /** 名称 */
    @Column(name = "NAME", length = 200)
    private String name;
    
    /** 表单ID */
    @Column(name = "FORM_ID", length = 40)
    private String formId;
    
    /** 类型 */
    @Column(name = "TYPE", length = 20)
    private String type;
    
    /** 单位(譬如：亿kWh) */
    @Column(name = "UNIT", length = 64)
    private String unit;
    
    /** 是否必填 1.是，0.否 */
    @Column(name = "REQURIED", precision = 1)
    private Integer requried;
    
    /** 备注 */
    @Column(name = "REMARK", length = 2000)
    private String remark;
    
    /** 说明 */
    @Column(name = "DESCRIPTION", length = 256)
    private String description;
    
    /** 功能子项ID */
    @Transient
    private String subitemId;
    
    /** 编码表达式 */
    private static final String codeExpr = "FD-${seq('BizFormData',10,1,1)}";
    
    /**
     * @return 获取 codeExpr属性值
     */
    public static String getCodeExpr() {
        return codeExpr;
    }
    
    /**
     * @return 获取 业务表单,由CIP自动创建。属性值
     */
    
    public BizFormVO getBizFormByFromtofromdata() {
        return bizFormByFromtofromdata;
    }
    
    /**
     * @param bizFormByFromtofromdata 设置 业务表单,由CIP自动创建。属性值为参数值 bizFormByFromtofromdata
     */
    
    public void setBizFormByFromtofromdata(BizFormVO bizFormByFromtofromdata) {
        this.bizFormByFromtofromdata = bizFormByFromtofromdata;
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
     * @return 获取 表单ID属性值
     */
    
    public String getFormId() {
        return formId;
    }
    
    /**
     * @param formId 设置 表单ID属性值为参数值 formId
     */
    
    public void setFormId(String formId) {
        this.formId = formId;
    }
    
    /**
     * @return 获取 类型属性值
     */
    
    public String getType() {
        return type;
    }
    
    /**
     * @param type 设置 类型属性值为参数值 type
     */
    
    public void setType(String type) {
        this.type = type;
    }
    
    /**
     * @return 获取 单位(譬如：亿kWh)属性值
     */
    
    public String getUnit() {
        return unit;
    }
    
    /**
     * @param unit 设置 单位(譬如：亿kWh)属性值为参数值 unit
     */
    
    public void setUnit(String unit) {
        this.unit = unit;
    }
    
    /**
     * @return 获取 是否必填 1.是，0.否属性值
     */
    
    public Integer getRequried() {
        return requried;
    }
    
    /**
     * @param requried 设置 是否必填 1.是，0.否属性值为参数值 requried
     */
    
    public void setRequried(Integer requried) {
        this.requried = requried;
    }
    
    /**
     * @return 获取 备注属性值
     */
    
    public String getRemark() {
        return remark;
    }
    
    /**
     * @param remark 设置 备注属性值为参数值 remark
     */
    
    public void setRemark(String remark) {
        this.remark = remark;
    }
    
    /**
     * @return 获取 description属性值
     */
    public String getDescription() {
        return description;
    }
    
    /**
     * @param description 设置 description 属性值为参数值 description
     */
    public void setDescription(String description) {
        this.description = description;
    }
    
    /**
     * @return 获取 subitemId属性值
     */
    public String getSubitemId() {
        return subitemId;
    }
    
    /**
     * @param subitemId 设置 subitemId 属性值为参数值 subitemId
     */
    public void setSubitemId(String subitemId) {
        this.subitemId = subitemId;
    }
}
