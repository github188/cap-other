/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.template.model;

import java.util.LinkedHashMap;
import java.util.Map;

import javax.xml.bind.annotation.XmlRootElement;

import com.comtop.cap.bm.metadata.base.model.BaseModel;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 页面模板分类模型
 * 
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2015-6-04 诸焕辉
 */
@DataTransferObject
@XmlRootElement(name = "pageTemplateType")
public class PageTemplateTypeVO extends BaseModel {
    
    /** 标识 */
    private static final long serialVersionUID = 2825877855055900495L;
    
    /** 页面模板分类定义 */
    private Map<String, String> type = new LinkedHashMap<String, String>();
    
    /** 页面模板分类编码 */
    private String templateTypeCode;
    
    /** 页面模板分类名称 */
    private String templateTypeName;
    
    /**
     * 构造函数
     */
    public PageTemplateTypeVO() {
        this.setModelId("template.pageTpl.type");
        this.setModelName("type");
        this.setModelType("pageTpl");
        this.setModelPackage("template");
    }
    
    /**
     * @return 获取 type属性值
     */
    public Map<String, String> getType() {
        return type;
    }
    
    /**
     * @param type 设置 type 属性值为参数值 type
     */
    public void setType(Map<String, String> type) {
        this.type = type;
    }
    
    /**
     * @return 获取 templateTypeCode属性值
     */
    public String getTemplateTypeCode() {
        return templateTypeCode;
    }
    
    /**
     * @param templateTypeCode 设置 templateTypeCode 属性值为参数值 templateTypeCode
     */
    public void setTemplateTypeCode(String templateTypeCode) {
        this.templateTypeCode = templateTypeCode;
    }
    
    /**
     * @return 获取 templateTypeName属性值
     */
    public String getTemplateTypeName() {
        return templateTypeName;
    }
    
    /**
     * @param templateTypeName 设置 templateTypeName 属性值为参数值 templateTypeName
     */
    public void setTemplateTypeName(String templateTypeName) {
        this.templateTypeName = templateTypeName;
    }
}
