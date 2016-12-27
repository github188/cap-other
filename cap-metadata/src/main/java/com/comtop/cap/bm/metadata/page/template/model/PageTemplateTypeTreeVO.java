/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.template.model;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;

/**
 * 页面模板分类树
 *
 *
 * @author zhangzunzhi
 * @since 1.0
 * @version 2015-6-17 zhangzunzhi
 */
public class PageTemplateTypeTreeVO extends BaseMetadata {
    
    /** serialVersionUID */
    private static final long serialVersionUID = -1779288548037298473L;
    
    /** 提示 */
    private String title;
    
    /** 树主键 */
    private String key;
    
    /** 是否展开 */
    private boolean expand;
    
    /** 是否展开 */
    private boolean isFolder;
    
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
    
}
