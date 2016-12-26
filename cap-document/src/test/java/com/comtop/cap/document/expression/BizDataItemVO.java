/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression;

import java.io.Serializable;

/**
 * 业务对象数据项
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月18日 lizhongwen
 */
public class BizDataItemVO implements Serializable {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 业务对象基本信息,由CIP自动创建。 */
    private BizObjectVO bizObjInfo;
    
    /** 主键 */
    private String id;
    
    /** 业务对象基本信息表ID */
    private String bizObjId;
    
    /** 名称 */
    private String name;
    
    /** 编码 */
    private String code;
    
    /** 编码引用说明 */
    private String codeNote;
    
    /** 序号 */
    private Integer sortNo;
    
    /** 备注 */
    private String remark;
    
    /** 说明 */
    private String description;
    
    /**
     * @return 获取 bizObjInfo属性值
     */
    public BizObjectVO getBizObjInfo() {
        return bizObjInfo;
    }
    
    /**
     * @param bizObjInfo 设置 bizObjInfo 属性值为参数值 bizObjInfo
     */
    public void setBizObjInfo(BizObjectVO bizObjInfo) {
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
     * @return 获取 序号属性值
     */
    
    public Integer getSortNo() {
        return sortNo;
    }
    
    /**
     * @param sortNo 设置 序号属性值为参数值 sortNo
     */
    
    public void setSortNo(Integer sortNo) {
        this.sortNo = sortNo;
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
     * 
     * @see java.lang.Object#toString()
     */
    @Override
    public String toString() {
        return "BizDataItemVO [id=" + id + ", bizObjId=" + bizObjId + ", name=" + name + ", code=" + code
            + ", codeNote=" + codeNote + ", sortNo=" + sortNo + ", remark=" + remark + ", description=" + description
            + "] \n";
    }
}
