/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.definition.model;

import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlEnumValue;
import javax.xml.bind.annotation.XmlType;

/**
 * 步骤分类
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年6月22日 lizhongwen
 */
@XmlType(name = "StepType")
@XmlEnum
public enum StepType {
    /** 基本步骤 */
    @XmlEnumValue("basic")
    BASIC("basic", "basics", "基本步骤"),
    /** 固定组合步骤 */
    @XmlEnumValue("fixed")
    FIXED("fixed", "combinations", "组合步骤"),
    /** 动态组合步骤 */
    @XmlEnumValue("dynamic")
    DYNAMIC("dynamic", "combinations", "组合步骤"),
    /** 最佳实践 */
    @XmlEnumValue("practice")
    PRACTICE("practice", "practices", "最佳实践");
    
    /** 类型 */
    private String type;
    
    /** 路径 */
    private String path;
    
    /** 描述 */
    private String description;
    
    /**
     * 构造函数
     * 
     * @param type 类型
     * @param path 路径
     * @param description 描述
     */
    private StepType(String type, String path, String description) {
        this.type = type;
        this.path = path;
        this.description = description;
    }
    
    /**
     * @return 获取 type属性值
     */
    public String getType() {
        return type;
    }
    
    /**
     * @return 获取 path属性值
     */
    public String getPath() {
        return path;
    }
    
    /**
     * @return 获取 description属性值
     */
    public String getDescription() {
        return description;
    }
}
