/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.info.model;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import com.comtop.cap.bm.biz.common.model.BizBaseVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 业务对象数据项
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-10 CAP
 */
@DataTransferObject
@Table(name = "CAP_BIZ_OBJ_DATA_ITEM")
public class BizObjDataItemVO extends BizBaseVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 业务对象基本信息,由CIP自动创建。 */
    private BizObjInfoVO bizObjInfo;
    
    /** 主键 */
    @Id
    @Column(name = "ID", length = 40)
    private String id;
    
    /** 业务对象基本信息表ID */
    @Column(name = "BIZ_OBJ_ID", length = 40)
    private String bizObjId;
    
    /** 名称 */
    @Column(name = "NAME", length = 200)
    private String name;
    
    /** 编码 */
    @Column(name = "CODE", length = 250)
    private String code;
    
    /** 编码引用说明 */
    @Column(name = "CODE_NOTE", length = 100)
    private String codeNote;
    
    /** 备注 业务模型对应“备注”，需求模型对应“业务数据质量管理要求” */
    @Column(name = "REMARK", length = 2000)
    private String remark;
    
    /** 说明 */
    @Column(name = "DESCRIPTION", length = 256)
    private String description;
    
    /** 业务功能子项 */
    @Transient
    private String subitemId;
    
    /** 数据项所属对象类型 */
    @Transient
    private String objectId;
    
    /** 业务对象名称 */
    @Transient
    private String objectName;
    
    /** 业务对象编码 */
    @Transient
    private String objectCode;
    
    /** 业务对象说明 */
    @Transient
    private String objectDesc;
    
    /** 编码表达式 */
    private static final String codeExpr = "OD-${seq('BizObjectData',10,1,1)}";
    
    /**
     * @return 获取 codeExpr属性值
     */
    public static String getCodeExpr() {
        return codeExpr;
    }
    
    /**
     * @return 获取 bizObjInfo属性值
     */
    public BizObjInfoVO getBizObjInfo() {
        return bizObjInfo;
    }
    
    /**
     * @param bizObjInfo 设置 bizObjInfo 属性值为参数值 bizObjInfo
     */
    public void setBizObjInfo(BizObjInfoVO bizObjInfo) {
        this.bizObjInfo = bizObjInfo;
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
     * @return 获取 业务对象基本信息表ID属性值
     */
    
    public String getBizObjId() {
        return bizObjId;
    }
    
    /**
     * @param bizObjId 设置 业务对象基本信息表ID属性值为参数值 bizObjId
     */
    
    public void setBizObjId(String bizObjId) {
        this.bizObjId = bizObjId;
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
     * @return 获取 编码属性值
     */
    
    public String getCode() {
        return code;
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
     * @param code 设置 编码属性值为参数值 code
     */
    
    public void setCode(String code) {
        this.code = code;
    }
    
    /**
     * @return 获取 编码引用说明属性值
     */
    
    public String getCodeNote() {
        return codeNote;
    }
    
    /**
     * @param codeNote 设置 编码引用说明属性值为参数值 codeNote
     */
    
    public void setCodeNote(String codeNote) {
        this.codeNote = codeNote;
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
     * @return 获取 objectDesc属性值
     */
    public String getObjectDesc() {
        return objectDesc;
    }
    
    /**
     * @param objectDesc 设置 objectDesc 属性值为参数值 objectDesc
     */
    public void setObjectDesc(String objectDesc) {
        this.objectDesc = objectDesc;
    }
}
