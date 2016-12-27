/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.uilibrary.model;

import java.util.List;

/**
 * 组件子类型VO对象
 *
 * @author 龚斌
 * @since 1.0
 * @version 2015年8月13日 龚斌
 */
public class ComponentSubTypeVO {
    
    /**
     * 类型编码
     */
    private String typeCode;
    
    /**
     * 类型名称
     */
    private String typeName;
    
    /**
     * 子类型集合
     */
    private List<ComponentSubTypeVO> subType;
    
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
     * @return 获取 subType属性值
     */
    public List<ComponentSubTypeVO> getSubType() {
        return subType;
    }
    
    /**
     * @param subType 设置 subType 属性值为参数值 subType
     */
    public void setSubType(List<ComponentSubTypeVO> subType) {
        this.subType = subType;
    }
    
}
