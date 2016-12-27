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
 * 需求模板明细
 * 
 * @author 姜子豪
 * @since 1.0
 * @version 2015-9-22 姜子豪
 */
@DataTransferObject
@Table(name = "CAP_REQ_TEMPLATE_INFO")
public class TemplateInfoVO extends CoreVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 主键 */
    @Id
    @Column(name = "ID", length = 32)
    private String id;
    
    /** 需求模板类型ID */
    @Column(name = "TEMPLATE_TYPE_ID", length = 32)
    private String templateTypeId;
    
    /** 模板名称 */
    @Column(name = "TEMPLATE_NAME", length = 100)
    private String templateName;
    
    /** 内容 */
    @Column(name = "TEMPLATE_CONTENT", precision = 10000)
    private String templateContent;
    
    /** 描述 */
    @Column(name = "DESC_INFO", length = 500)
    private String descInfo;
    
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
     * @return 获取 需求模板类型ID属性值
     */
    
    public String getTemplateTypeId() {
        return templateTypeId;
    }
    
    /**
     * @param templateTypeId 设置 需求模板类型ID属性值为参数值 templateTypeId
     */
    
    public void setTemplateTypeId(String templateTypeId) {
        this.templateTypeId = templateTypeId;
    }
    
    /**
     * @return 获取 模板名称属性值
     */
    
    public String getTemplateName() {
        return templateName;
    }
    
    /**
     * @param templateName 设置 模板名称属性值为参数值 templateName
     */
    
    public void setTemplateName(String templateName) {
        this.templateName = templateName;
    }
    
    /**
     * @return 获取 内容属性值
     */
    
    public String getTemplateContent() {
        return templateContent;
    }
    
    /**
     * @param templateContent 设置 内容属性值为参数值 templateContent
     */
    
    public void setTemplateContent(String templateContent) {
        this.templateContent = templateContent;
    }
    
    /**
     * @return 获取 描述属性值
     */
    
    public String getDescInfo() {
        return descInfo;
    }
    
    /**
     * @param descInfo 设置 描述属性值为参数值 descInfo
     */
    
    public void setDescInfo(String descInfo) {
        this.descInfo = descInfo;
    }
    
}
