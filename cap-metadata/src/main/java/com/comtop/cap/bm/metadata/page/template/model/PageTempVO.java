/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.template.model;

import com.comtop.cap.bm.metadata.page.desinger.model.PageVO;

/**
 * 页面模板VO
 * 
 * @author 罗珍明
 * @version jdk1.6
 * @version 2016-1-13 罗珍明
 */
public class PageTempVO extends PageVO {
    
    /** 序列化版本号 */
    private static final long serialVersionUID = 1L;
    
    /** 模板关联的页面Id */
    private String pageModelId;
    
    /** 模板关联页面的包路径 */
    private String pageModelPackage;
    
    /** 模板关联页面的英文名称 */
    private String pageModelName;
    
    /** 模板关联页面的modelType */
    private String pageModelType;
    
    /**
     * @return the pageModelId
     */
    public String getPageModelId() {
        return pageModelId;
    }
    
    /**
     * @param pageModelId the pageModelId to set
     */
    public void setPageModelId(String pageModelId) {
        this.pageModelId = pageModelId;
    }
    
    /**
     * @return the pageModelPackage
     */
    public String getPageModelPackage() {
        return pageModelPackage;
    }
    
    /**
     * @param pageModelPackage the pageModelPackage to set
     */
    public void setPageModelPackage(String pageModelPackage) {
        this.pageModelPackage = pageModelPackage;
    }
    
    /**
     * @return the pageModelName
     */
    public String getPageModelName() {
        return pageModelName;
    }
    
    /**
     * @param pageModelName the pageModelName to set
     */
    public void setPageModelName(String pageModelName) {
        this.pageModelName = pageModelName;
    }
    
    /**
     * @return 获取 pageModelType属性值
     */
    public String getPageModelType() {
        return pageModelType;
    }
    
    /**
     * @param pageModelType 设置 pageModelType 属性值为参数值 pageModelType
     */
    public void setPageModelType(String pageModelType) {
        this.pageModelType = pageModelType;
    }
    
}
