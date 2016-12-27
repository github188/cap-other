/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.model;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 方法参数VO
 * 
 * @author 章尊志
 * @since 1.0
 * @version 2014-9-17 章尊志
 */
@DataTransferObject
public class ParameterVO extends BaseMetadata {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 参数Id */
    private String parameterId;
    
    /** 参数中文名称 */
    private String chName;
    
    /** 参数类型 */
    private DataTypeVO dataType;
    
    /** 参数描述 */
    private String description;
    
    /** 参数英文名称 */
    private String engName;
    
    /** 序号 */
    private int sortNo;
    
    /**
     * @return 获取 parameterId属性值
     */
    public String getParameterId() {
        return parameterId;
    }
    
    /**
     * @param parameterId 设置 parameterId 属性值为参数值 parameterId
     */
    public void setParameterId(String parameterId) {
        this.parameterId = parameterId;
    }
    
    /**
     * @return 获取 chName属性值
     */
    public String getChName() {
        return chName;
    }
    
    /**
     * @param chName 设置 chName 属性值为参数值 chName
     */
    public void setChName(String chName) {
        this.chName = chName;
    }
    
    /**
     * @return 获取 dataType属性值
     */
    public DataTypeVO getDataType() {
        return dataType;
    }
    
    /**
     * @param dataType 设置 dataType 属性值为参数值 dataType
     */
    public void setDataType(DataTypeVO dataType) {
        this.dataType = dataType;
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
     * @return 获取 engName属性值
     */
    public String getEngName() {
        return engName;
    }
    
    /**
     * @param engName 设置 engName 属性值为参数值 engName
     */
    public void setEngName(String engName) {
        this.engName = engName;
    }
    
    /**
     * @return 获取 sortNo属性值
     */
    public int getSortNo() {
        return sortNo;
    }
    
    /**
     * @param sortNo 设置 sortNo 属性值为参数值 sortNo
     */
    public void setSortNo(int sortNo) {
        this.sortNo = sortNo;
    }
    
}
