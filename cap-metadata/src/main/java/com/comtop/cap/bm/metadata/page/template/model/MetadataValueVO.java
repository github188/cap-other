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
public class MetadataValueVO extends BaseMetadata {
    
    /** 标识 */
    private static final long serialVersionUID = 1L;
    
    /**
     * 文本框控件集合
     */
    private List<InputAreaComponentVO> inputComponentList = new ArrayList<InputAreaComponentVO>();
    
    /**
     * 菜单控件集合
     */
    private List<MenuAreaComponentVO> menuComponentList = new ArrayList<MenuAreaComponentVO>();
    
    /**
     * 实体区域控件集合
     */
    private List<EntitySelectionAreaComponentVO> entityComponentList = new ArrayList<EntitySelectionAreaComponentVO>();
    
    /**
     * 查询区域控件集合
     */
    private List<QueryAreaComponentVO> queryComponentList = new ArrayList<QueryAreaComponentVO>();
    
    /**
     * 列表区域控件集合
     */
    private List<GridAreaComponentVO> gridComponentList = new ArrayList<GridAreaComponentVO>();
    
    /**
     * 编辑区域控件集合
     */
    private List<EditAreaComponentVO> editComponentList = new ArrayList<EditAreaComponentVO>();
    
    /**
     * 编辑区域控件集合
     */
    private List<HiddenComponentVO> hiddenComponentList = new ArrayList<HiddenComponentVO>();
    
    /**
     * @return 获取 inputComponentList属性值
     */
    public List<InputAreaComponentVO> getInputComponentList() {
        return inputComponentList;
    }
    
    /**
     * @param inputComponentList 设置 inputComponentList 属性值为参数值 inputComponentList
     */
    public void setInputComponentList(List<InputAreaComponentVO> inputComponentList) {
        this.inputComponentList = inputComponentList;
    }
    
    /**
     * @return 获取 menuComponentList属性值
     */
    public List<MenuAreaComponentVO> getMenuComponentList() {
        return menuComponentList;
    }
    
    /**
     * @param menuComponentList 设置 menuComponentList 属性值为参数值 menuComponentList
     */
    public void setMenuComponentList(List<MenuAreaComponentVO> menuComponentList) {
        this.menuComponentList = menuComponentList;
    }
    
    /**
     * @return 获取 entityComponentList属性值
     */
    public List<EntitySelectionAreaComponentVO> getEntityComponentList() {
        return entityComponentList;
    }
    
    /**
     * @param entityComponentList 设置 entityComponentList 属性值为参数值 entityComponentList
     */
    public void setEntityComponentList(List<EntitySelectionAreaComponentVO> entityComponentList) {
        this.entityComponentList = entityComponentList;
    }
    
    /**
     * @return 获取 queryComponentList属性值
     */
    public List<QueryAreaComponentVO> getQueryComponentList() {
        return queryComponentList;
    }
    
    /**
     * @param queryComponentList 设置 queryComponentList 属性值为参数值 queryComponentList
     */
    public void setQueryComponentList(List<QueryAreaComponentVO> queryComponentList) {
        this.queryComponentList = queryComponentList;
    }
    
    /**
     * @return 获取 gridComponentList属性值
     */
    public List<GridAreaComponentVO> getGridComponentList() {
        return gridComponentList;
    }
    
    /**
     * @param gridComponentList 设置 gridComponentList 属性值为参数值 gridComponentList
     */
    public void setGridComponentList(List<GridAreaComponentVO> gridComponentList) {
        this.gridComponentList = gridComponentList;
    }
    
    /**
     * @return 获取 editComponentList属性值
     */
    public List<EditAreaComponentVO> getEditComponentList() {
        return editComponentList;
    }
    
    /**
     * @param editComponentList 设置 editComponentList 属性值为参数值 editComponentList
     */
    public void setEditComponentList(List<EditAreaComponentVO> editComponentList) {
        this.editComponentList = editComponentList;
    }
    
    /**
     * @return 获取 hiddenComponentList属性值
     */
    public List<HiddenComponentVO> getHiddenComponentList() {
        return hiddenComponentList;
    }
    
    /**
     * @param hiddenComponentList 设置 hiddenComponentList 属性值为参数值 hiddenComponentList
     */
    public void setHiddenComponentList(List<HiddenComponentVO> hiddenComponentList) {
        this.hiddenComponentList = hiddenComponentList;
    }
}
