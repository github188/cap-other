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
import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import com.comtop.cap.bm.metadata.page.preference.model.IncludeFileVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 列表区域控件
 * 
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2016-1-7 诸焕辉
 */
@DataTransferObject
public class GridAreaComponentVO extends BaseMetadata {
    
    /** 标识 */
    private static final long serialVersionUID = 1L;
    
    /**
     * 控件Id
     */
    private String id;
    
    /**
     * 实体Id
     */
    private String entityId;
    
    /**
     * 实体别名
     */
    private String entityAlias;
    
    /**
     * 区域Id
     */
    private String areaId;
    
    /** 区域编码 */
    private String area;
    
    /**
     * 网格属性对象
     */
    private CapMap options = new CapMap();
    
    /**
     * 引用文件集合
     */
    private List<IncludeFileVO> includeFileList = new ArrayList<IncludeFileVO>();
    
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
     * @return 获取 options属性值
     */
    public CapMap getOptions() {
        return options;
    }
    
    /**
     * @param options 设置 options 属性值为参数值 options
     */
    public void setOptions(CapMap options) {
        this.options = options;
    }
    
    /**
     * @return 获取 areaId属性值
     */
    public String getAreaId() {
        return areaId;
    }
    
    /**
     * @param areaId 设置 areaId 属性值为参数值 areaId
     */
    public void setAreaId(String areaId) {
        this.areaId = areaId;
    }
    
    /**
     * @return 获取 area属性值
     */
    public String getArea() {
        return area;
    }
    
    /**
     * @param area 设置 area 属性值为参数值 area
     */
    public void setArea(String area) {
        this.area = area;
    }
    
    /**
     * @return 获取 includeFileList属性值
     */
    public List<IncludeFileVO> getIncludeFileList() {
        return includeFileList;
    }
    
    /**
     * @param includeFileList 设置 includeFileList 属性值为参数值 includeFileList
     */
    public void setIncludeFileList(List<IncludeFileVO> includeFileList) {
        this.includeFileList = includeFileList;
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
