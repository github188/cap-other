/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cip.graph.entity.model;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 页面VO
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015-7-22 陈志伟
 */
@DataTransferObject
public class GraphPageVO extends GraphBaseVO {
    
    /** 页面ID */
    private String id;
    
    /** 模块id */
    private String packageId;
    
    /** 路径 */
    private String path;
    
    /** 页面标题 */
    private String title;
    
    /** 所在实体ID */
    private String entityId;
    
    /**
     * @return the id
     */
    public String getId() {
        return id;
    }
    
    /**
     * @param id
     *            the id to set
     */
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return the packageId
     */
    public String getPackageId() {
        return packageId;
    }
    
    /**
     * @param packageId
     *            the packageId to set
     */
    public void setPackageId(String packageId) {
        this.packageId = packageId;
    }
    
    /**
     * @return the path
     */
    public String getPath() {
        return path;
    }
    
    /**
     * @param path
     *            the path to set
     */
    public void setPath(String path) {
        this.path = path;
    }
    
    /**
     * @return 获取 title属性值
     */
    public String getTitle() {
        return title;
    }
    
    /**
     * @param title 设置 title 属性值为参数值 title
     */
    public void setTitle(String title) {
        this.title = title;
    }
    
    /**
     * @return 获取 entityId属性值
     */
    public String getEntityId() {
        return entityId;
    }
    
    /**
     * @param entityId 设置 entityId 属性值为参数值 entityId
     */
    public void setEntityId(String entityId) {
        this.entityId = entityId;
    }
    
}
