/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.model;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 业务对象数据项DTO。目前暂无自己的属性。
 * 此种方式是为了便于在配置模板时方便，通过类名和服务名和唯一性建立和服务一对一的关系。此外，还有业务表单数据项等也是类似的方式。
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月7日 lizhiyong
 */
@DataTransferObject
public class BizObjectDataItemDTO extends DataItemDTO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 业务子项ID */
    private String subitemId;
    
    /** 业务数据质量管理要求 */
    private String quality;
    
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
     * @return 获取 quality属性值
     */
    public String getQuality() {
        return quality;
    }
    
    /**
     * @param quality 设置 quality 属性值为参数值 quality
     */
    public void setQuality(String quality) {
        this.quality = quality;
    }
}
