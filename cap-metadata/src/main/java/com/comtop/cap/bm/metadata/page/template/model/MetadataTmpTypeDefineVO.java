/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.template.model;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.Id;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 元数据模板分类
 * 
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2015-9-22 诸焕辉
 */
@DataTransferObject
public class MetadataTmpTypeDefineVO extends BaseMetadata {
    
    /** 标识 */
    private static final long serialVersionUID = 6115425017003955530L;
    
    /**
     * 类型编码
     */
    @Id
    private String typeCode;
    
    /**
     * 类型名称
     */
    private String typeName;
    
    /**
     * 类型定义
     */
    private List<MetadataTmpTypeDefineVO> type = new ArrayList<MetadataTmpTypeDefineVO>();
    
    /**
     * @return 获取 typeCode属性值
     */
    public String getTypeCode() {
        return typeCode;
    }
    
    /**
     * @param typeCode 设置 typeCode 属性值为参数值 typeCode
     */
    public void setTypeCode(String typeCode) {
        this.typeCode = typeCode;
    }
    
    /**
     * @return 获取 typeName属性值
     */
    public String getTypeName() {
        return typeName;
    }
    
    /**
     * @param typeName 设置 typeName 属性值为参数值 typeName
     */
    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }
    
    /**
     * @return 获取 type属性值
     */
    public List<MetadataTmpTypeDefineVO> getType() {
        return type;
    }
    
    /**
     * @param type 设置 type 属性值为参数值 type
     */
    public void setType(List<MetadataTmpTypeDefineVO> type) {
        this.type = type;
    }
}
