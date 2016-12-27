/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.template.model;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 实体区域控件中的行数据对象
 * 
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2016-1-7 诸焕辉
 */
@DataTransferObject
public class RowFromEntityAreaVO extends BaseMetadata {
    
    /** 标识 */
    private static final long serialVersionUID = 1L;
    
    /**
     * 实体别名
     */
    private String suffix;
    
    /**
     * 实体英文名称
     */
    private String engName;
    
    /**
     * 实体modelId
     */
    private String modelId;
    
    /**
     * 实体中文名称
     */
    private String chName;
    
    /**
     * 实体别名
     */
    private String entityAlias;
    
    /**
     * @return 获取 suffix属性值
     */
    public String getSuffix() {
        return suffix;
    }
    
    /**
     * @param suffix 设置 suffix 属性值为参数值 suffix
     */
    public void setSuffix(String suffix) {
        this.suffix = suffix;
    }
    
    /**
     * @return 获取 engName属性值
     */
    public String getEngName() {
        return engName;
    }
    
    /**
     * @param engName 设置 engName 属性值为参数值 engName
     */
    public void setEngName(String engName) {
        this.engName = engName;
    }
    
    /**
     * @return 获取 modelId属性值
     */
    public String getModelId() {
        return modelId;
    }
    
    /**
     * @param modelId 设置 modelId 属性值为参数值 modelId
     */
    public void setModelId(String modelId) {
        this.modelId = modelId;
    }
    
    /**
     * @return 获取 chName属性值
     */
    public String getChName() {
        return chName;
    }
    
    /**
     * @param chName 设置 chName 属性值为参数值 chName
     */
    public void setChName(String chName) {
        this.chName = chName;
    }

    /**
     * @return 获取 entityAlias属性值
     */
    public String getEntityAlias() {
        return entityAlias;
    }

    /**
     * @param entityAlias 设置 entityAlias 属性值为参数值 entityAlias
     */
    public void setEntityAlias(String entityAlias) {
        this.entityAlias = entityAlias;
    }
}
