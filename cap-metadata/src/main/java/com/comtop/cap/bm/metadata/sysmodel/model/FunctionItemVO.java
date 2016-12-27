/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.sysmodel.model;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 功能项（包括功能子项）VO
 *
 * @author 龚斌
 * @since 1.0
 * @version 2016年1月6日 龚斌
 */
@DataTransferObject
public class FunctionItemVO {
    
    /** 功能项id */
    private String itemId;
    
    /** 功能项类型：FUNCTION_ITEM_TYPE为功能项，SUB_FUNCTION_ITEM_TYPE为功能子项 */
    private String itemType;
    
    /**
     * 构造函数
     * 
     */
    public FunctionItemVO() {
    }
    
    /**
     * 构造函数
     * 
     * @param itemId 功能项id
     * @param itemType 功能项类型
     */
    public FunctionItemVO(String itemId, String itemType) {
        this.itemId = itemId;
        this.itemType = itemType;
    }
    
    /**
     * @return 获取 itemId属性值
     */
    public String getItemId() {
        return itemId;
    }
    
    /**
     * @param itemId 设置 itemId 属性值为参数值 itemId
     */
    public void setItemId(String itemId) {
        this.itemId = itemId;
    }
    
    /**
     * @return 获取 itemType属性值
     */
    public String getItemType() {
        return itemType;
    }
    
    /**
     * @param itemType 设置 itemType 属性值为参数值 itemType
     */
    public void setItemType(String itemType) {
        this.itemType = itemType;
    }
    
}
