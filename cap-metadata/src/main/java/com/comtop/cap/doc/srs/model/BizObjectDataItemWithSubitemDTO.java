/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.srs.model;

import com.comtop.cap.doc.biz.model.DataItemDTO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 业务对象，含功能子项信息的DTO
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年12月28日 lizhongwen
 */
@DataTransferObject
public class BizObjectDataItemWithSubitemDTO extends DataItemDTO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 业务项ID */
    private String itemId;
    
    /** 业务子项ID */
    private String subitemId;
    
    /** 业务子项名称 */
    private String subitemName;
    
    /** 业务对象说明 */
    private String objectDesc;
    
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
     * @return 获取 subitemId属性值
     */
    public String getSubitemId() {
        return subitemId;
    }
    
    /**
     * @param subitemId 设置 subitemId 属性值为参数值 subitemId
     */
    public void setSubitemId(String subitemId) {
        this.subitemId = subitemId;
    }
    
    /**
     * @return 获取 subitemName属性值
     */
    public String getSubitemName() {
        return subitemName;
    }
    
    /**
     * @param subitemName 设置 subitemName 属性值为参数值 subitemName
     */
    public void setSubitemName(String subitemName) {
        this.subitemName = subitemName;
    }
    
    /**
     * @return 获取 objectDesc属性值
     */
    public String getObjectDesc() {
        return objectDesc;
    }
    
    /**
     * @param objectDesc 设置 objectDesc 属性值为参数值 objectDesc
     */
    public void setObjectDesc(String objectDesc) {
        this.objectDesc = objectDesc;
    }
}
