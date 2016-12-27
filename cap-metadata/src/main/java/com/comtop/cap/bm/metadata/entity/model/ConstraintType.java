/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.model;

/**
 * 约束类型
 * 
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-4-9 李忠文
 */
public enum ConstraintType {
    
    /** 正则表达式 */
    REGULAR_TYPE("regular"),
    
    /** 脚本 */
    SCRIPT_TYPE("script"),
    
    /** 数值 */
    NUMERICAL_TYPE("numerical");
    
    /** 值 */
    private String value;
    
    /**
     * 构造函数
     * @param value 枚举值
     */
    private ConstraintType(String value) {
        this.value = value;
    }
    
    /**
     * @return 获取 value属性值
     */
    public String getValue() {
        return value;
    }
}
