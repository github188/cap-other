/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.tmpl.model;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.top.core.base.model.CoreVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 文档模板
 * 
 * @author CAP
 * @since 1.0
 * @version 2015-11-9 CAP
 */
@DataTransferObject
@Table(name = "CAP_DOC_TEMPLATE")
public class CapDocTemplateVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 流水号 */
    @Id
    @Column(name = "ID", length = 40)
    private String id;
    
    /** 名称 */
    @Column(name = "NAME", length = 80)
    private String name;
    
    /**
     * 分组，关联数据字典项；数据字典Key：BIZ_MODEL:业务模型说明书；SRS:需求规格说明书;HLD
     * :概要设计说明书；LLD:详细设计说明书；DBD
     */
    @Column(name = "TYPE", length = 256)
    private String type;
    
    /** 存储地址 */
    @Column(name = "PATH", length = 256)
    private String path;
    
    /** 说明 */
    @Column(name = "REMARK", length = 500)
    private String remark;
    
    /** 模块应用场景类型 public private */
    @Column(name = "DOC_CONFIG_TYPE", length = 10)
    private String docConfigType;
    
    /**
     * @return 获取 docConfigType属性值
     */
    public String getDocConfigType() {
        return docConfigType;
    }
    
    /**
     * @param docConfigType 设置 docConfigType 属性值为参数值 docConfigType
     */
    public void setDocConfigType(String docConfigType) {
        this.docConfigType = docConfigType;
    }
    
    /**
     * @return 获取 流水号属性值
     */
    
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置 流水号属性值为参数值 id
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
     * @return 获取 分组，关联数据字典项；数据字典Key：BIZ_MODEL:业务模型说明书；SRS:需求规格说明书;HLD
     *         :概要设计说明书；LLD:详细设计说明书；DBD属性值
     */
    
    public String getType() {
        return type;
    }
    
    /**
     * @param type 设置 分组，关联数据字典项；数据字典Key：BIZ_MODEL:业务模型说明书；SRS:需求规格说明书;HLD
     *            :概要设计说明书；LLD:详细设计说明书；DBD属性值为参数值 type
     */
    
    public void setType(String type) {
        this.type = type;
    }
    
    /**
     * @return 获取 存储地址属性值
     */
    
    public String getPath() {
        return path;
    }
    
    /**
     * @param path 设置 存储地址属性值为参数值 path
     */
    
    public void setPath(String path) {
        this.path = path;
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
