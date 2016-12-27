/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.template.model;

import java.util.List;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 元数据模板分类展示VO
 *
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2015-10-13 诸焕辉
 */
@DataTransferObject
public class MetadataTmpTypeViewVO {
    
    /**
     * 显示标题
     */
    private String title;
    
    /**
     * 键值
     */
    private String key;
    
    /**
     * 是否为目录
     */
    private boolean isFolder;
    
    /**
     * 是否展开
     */
    private boolean expand;
    
    /**
     * 界面元数据配置模版ID
     */
    private String metadataPageConfigModelId;
    
    /**
     * 是否是默认模版
     */
    private boolean defaultTemplate;
    
    /**
     * 子节点
     */
    private List<MetadataTmpTypeViewVO> children;
    
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
     * @return 获取 key属性值
     */
    public String getKey() {
        return key;
    }
    
    /**
     * @param key 设置 key 属性值为参数值 key
     */
    public void setKey(String key) {
        this.key = key;
    }
    
    /**
     * @return 获取 isFolder属性值
     */
    public boolean isFolder() {
        return isFolder;
    }
    
    /**
     * @param isFolder 设置 isFolder 属性值为参数值 isFolder
     */
    public void setFolder(boolean isFolder) {
        this.isFolder = isFolder;
    }
    
    /**
     * @return 获取 expand属性值
     */
    public boolean isExpand() {
        return expand;
    }
    
    /**
     * @param expand 设置 expand 属性值为参数值 expand
     */
    public void setExpand(boolean expand) {
        this.expand = expand;
    }
    
    /**
     * @return 获取 children属性值
     */
    public List<MetadataTmpTypeViewVO> getChildren() {
        return children;
    }
    
    /**
     * @param children 设置 children 属性值为参数值 children
     */
    public void setChildren(List<MetadataTmpTypeViewVO> children) {
        this.children = children;
    }
    
    /**
     * @return 获取 metadataPageConfigModelId属性值
     */
    public String getMetadataPageConfigModelId() {
        return metadataPageConfigModelId;
    }
    
    /**
     * @param metadataPageConfigModelId 设置 metadataPageConfigModelId 属性值为参数值 metadataPageConfigModelId
     */
    public void setMetadataPageConfigModelId(String metadataPageConfigModelId) {
        this.metadataPageConfigModelId = metadataPageConfigModelId;
    }
    
    /**
     * @return 获取 defaultTemplate属性值
     */
    public boolean isDefaultTemplate() {
        return defaultTemplate;
    }
    
    /**
     * @param defaultTemplate 设置 defaultTemplate 属性值为参数值 defaultTemplate
     */
    public void setDefaultTemplate(boolean defaultTemplate) {
        this.defaultTemplate = defaultTemplate;
    }
}
