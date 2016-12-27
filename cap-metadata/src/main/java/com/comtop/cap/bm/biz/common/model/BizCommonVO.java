/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.common.model;

import java.util.List;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 业务公共对象
 * 
 * @author 林玉千
 * @since jdk1.6
 * @version 2016-11-3 林玉千
 */
@DataTransferObject
public class BizCommonVO {
    
    /** 关联的业务数据列 */
    private List<BizDataCommonVO> dataItems;
    
    /** 业务对象编号 */
    private String id;
    
    /** 业务对象名称 */
    private String name;
    
    /** 业务对象编码 */
    private String code;
    
    /** 描述 */
    private String description;
    
    /** 业务域Id */
    private String domainId;
    
    /** 包Id */
    private String packageId;
    
    /**
     * @return 获取 dataItems属性值
     */
    public List<BizDataCommonVO> getDataItems() {
        return dataItems;
    }
    
    /**
     * @param dataItems 设置 dataItems 属性值为参数值 dataItems
     */
    public void setDataItems(List<BizDataCommonVO> dataItems) {
        this.dataItems = dataItems;
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
     * @return 获取 name属性值
     */
    public String getName() {
        return name;
    }
    
    /**
     * @param name 设置 name 属性值为参数值 name
     */
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * @return 获取 code属性值
     */
    public String getCode() {
        return code;
    }
    
    /**
     * @param code 设置 code 属性值为参数值 code
     */
    public void setCode(String code) {
        this.code = code;
    }
    
    /**
     * @return 获取 description属性值
     */
    public String getDescription() {
        return description;
    }
    
    /**
     * @param description 设置 description 属性值为参数值 description
     */
    public void setDescription(String description) {
        this.description = description;
    }
    
    /**
     * @return 获取 domainId属性值
     */
    public String getDomainId() {
        return domainId;
    }
    
    /**
     * @param domainId 设置 domainId 属性值为参数值 domainId
     */
    public void setDomainId(String domainId) {
        this.domainId = domainId;
    }
    
    /**
     * @return 获取 packageId属性值
     */
    public String getPackageId() {
        return packageId;
    }
    
    /**
     * @param packageId 设置 packageId 属性值为参数值 packageId
     */
    public void setPackageId(String packageId) {
        this.packageId = packageId;
    }
    
}
