/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.req.template.model;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import com.comtop.top.core.base.model.CoreVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 需求模板类型
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-9-22 姜子豪
 */
@DataTransferObject
@Table(name = "CAP_REQ_TEMPLATE_TYPE")
public class TemplateTypeVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 主键 */
    @Id
    @Column(name = "ID", length = 32)
    private String id;
    
    /** 类型名称 */
    @Column(name = "TYPE_NAME", length = 50)
    private String typeName;
    
    /** 类型父ID */
    @Column(name = "PATER_ID", length = 32)
    private String paterId;
    
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
     * @return 获取 类型名称属性值
     */
    
    public String getTypeName() {
        return typeName;
    }
    
    /**
     * @param typeName 设置 类型名称属性值为参数值 typeName
     */
    
    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }
    
    /**
     * @return 获取 类型父ID属性值
     */
    
    public String getPaterId() {
        return paterId;
    }
    
    /**
     * @param paterId 设置 类型父ID属性值为参数值 paterId
     */
    
    public void setPaterId(String paterId) {
        this.paterId = paterId;
    }
    
}
