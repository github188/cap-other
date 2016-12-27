/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.template.model;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 编辑网格中的extras扩展属性对象
 * 
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2016-1-7 诸焕辉
 */
@DataTransferObject
public class ExtrasAttrFromEditGridVO extends BaseMetadata {
    
    /** 标识 */
    private static final long serialVersionUID = 1L;
    
    /**
     * 实体Id
     */
    private String entityId;
    
    /**
     * 设计时使用的表头数据
     */
    private String tableHeader;
    
    /**
     * 所选的数据集英文名称
     */
    private String selectedDataStoreEname;
    
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
     * @return 获取 tableHeader属性值
     */
    public String getTableHeader() {
        return tableHeader;
    }
    
    /**
     * @param tableHeader 设置 tableHeader 属性值为参数值 tableHeader
     */
    public void setTableHeader(String tableHeader) {
        this.tableHeader = tableHeader;
    }
    
    /**
     * @return 获取 selectedDataStoreEname属性值
     */
    public String getSelectedDataStoreEname() {
        return selectedDataStoreEname;
    }
    
    /**
     * @param selectedDataStoreEname 设置 selectedDataStoreEname 属性值为参数值 selectedDataStoreEname
     */
    public void setSelectedDataStoreEname(String selectedDataStoreEname) {
        this.selectedDataStoreEname = selectedDataStoreEname;
    }
    
}
