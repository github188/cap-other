/******************************************************************************
 * Copyright (C) 2012 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.model;

import java.util.List;

import javax.persistence.Id;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.bm.metadata.common.storage.annotation.IgnoreField;
import com.comtop.cip.json.annotation.JSONField;
import com.comtop.top.component.common.systeminit.WebGlobalInfo;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * CUI树节点vo
 * 
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2016-5-20 诸焕辉
 */
@DataTransferObject
public class CuiTreeNodeVO extends BaseMetadata {
    
    /**
     * id
     */
    @Id
    private String id;
    
    /**
     * 显示标题
     */
    private String title;
    
    /**
     * 键值
     */
    private String key;
    
    /**
     * 父节点Id
     */
    private String parentId;
    
    /**
     * 获得鼠标移上去的提示文本
     */
    private String tooltip;
    
    /**
     * 是否为目录
     */
    private boolean isFolder;
    
    /**
     * 初始化节点为active状态
     */
    @IgnoreField
    private Boolean isActivate;
    
    /**
     * 初始化节点为focus状态
     */
    @IgnoreField
    private Boolean isFocus;
    
    /**
     * 初始化节点展开
     */
    @IgnoreField
    private Boolean isExpand;
    
    /**
     * 初始化节点选中
     */
    @IgnoreField
    private Boolean isSelect;
    
    /**
     * 此节点不显示checkbox
     */
    @IgnoreField
    private Boolean isHideCheckbox;
    
    /**
     * 此节点不显示此节点不允许选中
     */
    @IgnoreField
    private Boolean isUnselectable;
    
    /**
     * 节点的自定义图标。false: 表示不使用图标
     */
    @JSONField(serialize=false)
    private String icon;
    
    /**
     * 是否懒加载数据
     */
    private Boolean isLazy;
    
    /**
     * 子节点
     */
    private List<CuiTreeNodeVO> children;
    
    /**
     * @return 获取 isLazy属性值
     */
    public String getTooltip() {
        return tooltip;
    }
    
    /**
     * @param tooltip
     *            设置 tooltip 属性值为参数值 tooltip
     */
    public void setTooltip(String tooltip) {
        this.tooltip = tooltip;
    }
    
    /**
     * @return 获取 isActivate属性值
     */
    public Boolean getIsActivate() {
        return isActivate;
    }
    
    /**
     * @param isActivate
     *            设置 isActivate 属性值为参数值 isActivate
     */
    public void setIsActivate(Boolean isActivate) {
        this.isActivate = isActivate;
    }
    
    /**
     * @return 获取 isFocus属性值
     */
    public Boolean getIsFocus() {
        return isFocus;
    }
    
    /**
     * @param isFocus
     *            设置 isFocus 属性值为参数值 isFocus
     */
    public void setIsFocus(Boolean isFocus) {
        this.isFocus = isFocus;
    }
    
    /**
     * @return 获取 isExpand属性值
     */
    public Boolean getIsExpand() {
        return isExpand;
    }
    
    /**
     * @param isExpand
     *            设置 isExpand 属性值为参数值 isExpand
     */
    public void setIsExpand(Boolean isExpand) {
        this.isExpand = isExpand;
    }
    
    /**
     * @return 获取 isSelect属性值
     */
    public Boolean getIsSelect() {
        return isSelect;
    }
    
    /**
     * @param isSelect
     *            设置 isSelect 属性值为参数值 isSelect
     */
    public void setSelect(Boolean isSelect) {
        this.isSelect = isSelect;
    }
    
    /**
     * @return 获取 isHideCheckbox属性值
     */
    public Boolean getIsHideCheckbox() {
        return isHideCheckbox;
    }
    
    /**
     * @param isHideCheckbox
     *            设置 isHideCheckbox 属性值为参数值 isHideCheckbox
     */
    public void setIsHideCheckbox(Boolean isHideCheckbox) {
        this.isHideCheckbox = isHideCheckbox;
    }
    
    /**
     * @return 获取 isUnselectable属性值
     */
    public Boolean getIsUnselectable() {
        return isUnselectable;
    }
    
    /**
     * @param isUnselectable
     *            设置 isUnselectable 属性值为参数值 idisUnselectable
     */
    public void setIsUnselectable(Boolean isUnselectable) {
        this.isUnselectable = isUnselectable;
    }
    
    /**
     * @return 获取 icon属性值
     */
    public String getIcon() {
        return this.getIsFolder() ? WebGlobalInfo.getWebContextPath() + "/top/sys/images/closeicon.gif" : icon;
    }
    
    /**
     * @param icon
     *            设置 icon 属性值为参数icon id
     */
    public void setIcon(String icon) {
        this.icon = icon;
    }
    
    /**
     * @return 获取 id属性值
     */
    public String getId() {
        return id;
    }
    
    /**
     * @param id
     *            设置 id 属性值为参数值 id
     */
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 isLazy属性值
     */
    public Boolean getIsLazy() {
        return isLazy;
    }
    
    /**
     * @param isLazy
     *            设置 isLazy 属性值为参数值 isLazy
     */
    public void setIsLazy(Boolean isLazy) {
        this.isLazy = isLazy;
    }
    
    /**
     * @return 获取 title属性值
     */
    public String getTitle() {
        return title;
    }
    
    /**
     * @param title
     *            设置 title 属性值为参数值 title
     */
    public void setTitle(String title) {
        this.title = title;
    }
    
    /**
     * @return 获取 key属性值
     */
    public String getKey() {
        return key;
    }
    
    /**
     * @param key
     *            设置 key 属性值为参数值 key
     */
    public void setKey(String key) {
        this.key = key;
    }
    
    /**
     * @return 获取 isFolder属性值
     */
    public boolean getIsFolder() {
        return isFolder;
    }
    
    /**
     * @param isFolder
     *            设置 isFolder 属性值为参数值 isFolder
     */
    public void setIsFolder(boolean isFolder) {
        this.isFolder = isFolder;
    }
    
    /**
     * @return 获取 children属性值
     */
    public List<CuiTreeNodeVO> getChildren() {
        return children;
    }
    
    /**
     * @param children
     *            设置 children 属性值为参数值 children
     */
    public void setChildren(List<CuiTreeNodeVO> children) {
        this.children = children;
    }

    /**
     * @return 获取 parentId属性值
     */
    public String getParentId() {
        return parentId;
    }

    /**
     * @param parentId
     *            设置 parentId 属性值为参数值 parentId
     */
    public void setParentId(String parentId) {
        this.parentId = parentId;
    }

}
