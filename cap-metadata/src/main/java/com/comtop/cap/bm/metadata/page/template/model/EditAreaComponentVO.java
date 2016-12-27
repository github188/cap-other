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
 * 编辑区域控件
 * 
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2016-1-7 诸焕辉
 */
@DataTransferObject
public class EditAreaComponentVO extends BaseMetadata {
    
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
     * 分组栏数据集
     */
    private List<GroupingBarComponentVO> groupingBarList = new ArrayList<GroupingBarComponentVO>();
    
    /**
     * 表单区域数据集
     */
    private List<FormAreaComponentVO> formAreaList = new ArrayList<FormAreaComponentVO>();
    
    /**
     * 编辑表格区域数据集
     */
    private List<GridAreaComponentVO> editGridAreaList = new ArrayList<GridAreaComponentVO>();
    
    /**
     * 子控件排版顺序
     */
    private List<String> subComponentLayoutSortList = new ArrayList<String>();
    
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
     * @return 获取 groupingBarList属性值
     */
    public List<GroupingBarComponentVO> getGroupingBarList() {
        return groupingBarList;
    }
    
    /**
     * @param groupingBarList 设置 groupingBarList 属性值为参数值 groupingBarList
     */
    public void setGroupingBarList(List<GroupingBarComponentVO> groupingBarList) {
        this.groupingBarList = groupingBarList;
    }
    
    /**
     * @return 获取 formAreaList属性值
     */
    public List<FormAreaComponentVO> getFormAreaList() {
        return formAreaList;
    }
    
    /**
     * @param formAreaList 设置 formAreaList 属性值为参数值 formAreaList
     */
    public void setFormAreaList(List<FormAreaComponentVO> formAreaList) {
        this.formAreaList = formAreaList;
    }
    
    /**
     * @return 获取 editGridAreaList属性值
     */
    public List<GridAreaComponentVO> getEditGridAreaList() {
        return editGridAreaList;
    }
    
    /**
     * @param editGridAreaList 设置 editGridAreaList 属性值为参数值 editGridAreaList
     */
    public void setEditGridAreaList(List<GridAreaComponentVO> editGridAreaList) {
        this.editGridAreaList = editGridAreaList;
    }
    
    /**
     * @return 获取 subComponentLayoutSortList属性值
     */
    public List<String> getSubComponentLayoutSortList() {
        return subComponentLayoutSortList;
    }
    
    /**
     * @param subComponentLayoutSortList 设置 subComponentLayoutSortList 属性值为参数值 subComponentLayoutSortList
     */
    public void setSubComponentLayoutSortList(List<String> subComponentLayoutSortList) {
        this.subComponentLayoutSortList = subComponentLayoutSortList;
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
