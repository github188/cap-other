
package com.comtop.cap.bm.metadata;

/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

/**
 * @author 罗珍明
 *
 */
public enum CapMetaDataConstant {
    
    /**
    	 * 
    	 */
    META_DATA_TYPE_PAGE("page"),
    
    /**
    	 * 
    	 */
    META_DATA_TYPE_SERIVE("service"),
    
    /**
    	 * 
    	 */
    META_DATA_TYPE_ENTITY("entity"),
    
    /**
     * 界面模版下自定义的input控件类型
     */
    META_COMPONENT_DEFINE_TYPE_INPUT("input"),
    
    /**
     * 界面模版下自定义的menu控件类型
     */
    META_COMPONENT_DEFINE_TYPE_MENU("menu"),
    
    /**
     * 界面模版下自定义的entitySelection控件类型
     */
    META_COMPONENT_DEFINE_TYPE_ENTITYSELECTION("entitySelection"),
    
    /**
     * 界面模版下自定义的queryCodeArea控件类型
     */
    META_COMPONENT_DEFINE_TYPE_QUERYCODEAREA("queryCodeArea"),
    
    /**
     * 界面模版下自定义的listCodeArea控件类型
     */
    META_COMPONENT_DEFINE_TYPE_LISTCODEAREA("listCodeArea"),
    
    /**
     * 界面模版下自定义的editCodeArea控件类型
     */
    META_COMPONENT_DEFINE_TYPE_EDITCODEAREA("editCodeArea");
    
    /**
     * 元数据分类
     */
    private String metaDataType;
    
    /**
     * @return the metaDataType
     */
    public String getMetaDataType() {
        return metaDataType;
    }
    
    /**
     * 枚举构造
     * 
     * @param metaType 元数据分类
     */
    private CapMetaDataConstant(String metaType) {
        this.metaDataType = metaType;
    }
}
