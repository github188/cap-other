/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.template.model;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.bm.metadata.common.dwr.CapMap;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 元数据控件定义
 * 
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2015-9-22 诸焕辉
 */
@DataTransferObject
public class MetaComponentDefineVO extends BaseMetadata {
    
    /** 标识 */
    private static final long serialVersionUID = -3780275281125016301L;
    
    /**
     * 控件标签
     */
    private String label;
    
    /**
     * 控件ID
     */
    private String id;
    
    /**
     * 控件类型
     */
    private String uiType;
    
    /**
     * 控件配置参数
     */
    private CapMap uiConfig = new CapMap();
    
    /**
     * @return 获取 label属性值
     */
    public String getLabel() {
        return label;
    }
    
    /**
     * @param label 设置 label 属性值为参数值 label
     */
    public void setLabel(String label) {
        this.label = label;
    }
    
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
     * @return 获取 uiType属性值
     */
    public String getUiType() {
        return uiType;
    }
    
    /**
     * @param uiType 设置 uiType 属性值为参数值 uiType
     */
    public void setUiType(String uiType) {
        this.uiType = uiType;
    }
    
    /**
     * @return 获取 uiConfig属性值
     */
    public CapMap getUiConfig() {
        return uiConfig;
    }
    
    /**
     * @param uiConfig 设置 uiConfig 属性值为参数值 uiConfig
     */
    public void setUiConfig(CapMap uiConfig) {
        this.uiConfig = uiConfig;
    }
    
}
