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
 * 快速表单区域控件
 * 
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2016-1-7 诸焕辉
 */
@DataTransferObject
public class FormAreaComponentVO extends BaseMetadata {
    
    /** 标识 */
    private static final long serialVersionUID = 1L;
    
    /**
     * 控件Id
     */
    private String id;
    
    /**
     * 区域Id
     */
    private String areaId;
    
    /**
     * 区域编码
     */
    private String area;
    
    /**
     * 实体Id
     */
    private String entityId;
    
    /**
     * 表格布局有多少列
     */
    private Integer col;
    
    /**
     * 行数据集
     */
    private List<RowFromFormAreaVO> rowList = new ArrayList<RowFromFormAreaVO>();
    
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
     * @return 获取 col属性值
     */
    public Integer getCol() {
        return col;
    }
    
    /**
     * @param col 设置 col 属性值为参数值 col
     */
    public void setCol(Integer col) {
        this.col = col;
    }
    
    /**
     * @return 获取 rowList属性值
     */
    public List<RowFromFormAreaVO> getRowList() {
        return rowList;
    }
    
    /**
     * @param rowList 设置 rowList 属性值为参数值 rowList
     */
    public void setRowList(List<RowFromFormAreaVO> rowList) {
        this.rowList = rowList;
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
    
}
