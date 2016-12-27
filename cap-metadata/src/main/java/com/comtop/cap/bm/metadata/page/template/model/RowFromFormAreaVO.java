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
 * 快速表单区域中的行数据对象
 * 
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2016-1-7 诸焕辉
 */
@DataTransferObject
public class RowFromFormAreaVO extends BaseMetadata {
    
    /** 标识 */
    private static final long serialVersionUID = 1L;
    
    /**
     * 控件Id
     */
    private String id;
    
    /**
     * 控件lable名称
     */
    private String cname;
    
    /**
     * 控件modelId
     */
    private String componentModelId;
    
    /**
     * 表格布局有多少列
     */
    private Integer colspan;
    
    /**
     * 表格布局有多少列
     */
    private CapMap options = new CapMap();
    
    /**
     * @return 获取 id属性值
     */
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置id 值为参数值 id
     */
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 cname属性值
     */
    public String getCname() {
        return cname;
    }
    
    /**
     * @param cname 设置 cname 属性值为参数值 cname
     */
    public void setCname(String cname) {
        this.cname = cname;
    }
    
    /**
     * @return 获取 componentModelId属性值
     */
    public String getComponentModelId() {
        return componentModelId;
    }
    
    /**
     * @param componentModelId 设置 componentModelId 属性值为参数值 componentModelId
     */
    public void setComponentModelId(String componentModelId) {
        this.componentModelId = componentModelId;
    }
    
    /**
     * @return 获取 colspan属性值
     */
    public Integer getColspan() {
        return colspan;
    }
    
    /**
     * @param colspan 设置 colspan 属性值为参数值 colspan
     */
    public void setColspan(Integer colspan) {
        this.colspan = colspan;
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
    
}
