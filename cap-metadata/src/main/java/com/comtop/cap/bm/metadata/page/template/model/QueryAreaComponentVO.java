/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.template.model;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 界面配置元数据模版表单产生的数据值
 * 
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2016-1-7 诸焕辉
 */
@DataTransferObject
public class QueryAreaComponentVO extends BaseMetadata {
    
    /** 标识 */
    private static final long serialVersionUID = 1L;
    
    /**
     * 控件Id
     */
    private String id;
    
    /**
     * 选择的实体ID
     */
    private String entityId;
    
    /**
     * 实体别名
     */
    private String entityAlias;
    
    /**
     * 固定查询区域数据集
     */
    private List<FormAreaComponentVO> fixedQueryAreaList = new ArrayList<FormAreaComponentVO>();
    
    /**
     * 更多查询区域数据集
     */
    private List<FormAreaComponentVO> moreQueryAreaList = new ArrayList<FormAreaComponentVO>();
    
    /**
     * @return 获取 id属性值
     */
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置 id 属性值为参数值 id
     */
    public void setId(String id) {
        this.id = id;
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
    
    /**
     * @return 获取 fixedQueryAreaList属性值
     */
    public List<FormAreaComponentVO> getFixedQueryAreaList() {
        return fixedQueryAreaList;
    }
    
    /**
     * @param fixedQueryAreaList 设置 fixedQueryAreaList 属性值为参数值 fixedQueryAreaList
     */
    public void setFixedQueryAreaList(List<FormAreaComponentVO> fixedQueryAreaList) {
        this.fixedQueryAreaList = fixedQueryAreaList;
    }
    
    /**
     * @return 获取 moreQueryAreaList属性值
     */
    public List<FormAreaComponentVO> getMoreQueryAreaList() {
        return moreQueryAreaList;
    }
    
    /**
     * @param moreQueryAreaList 设置 moreQueryAreaList 属性值为参数值 moreQueryAreaList
     */
    public void setMoreQueryAreaList(List<FormAreaComponentVO> moreQueryAreaList) {
        this.moreQueryAreaList = moreQueryAreaList;
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
