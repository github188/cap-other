/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.model;

/**
 * 方法类型
 * 
 * @author 凌晨
 * @since 1.0
 * @version 2015-10-8 凌晨
 */
public enum MethodType {
    
    /** 空方法 */
    BLANK("blank"),
    
    /** 级联操作 */
    CASCADE("cascade"),
    
    /** 函数调用 */
    FUNCTION("function"),
    
    /** 存储过程调用 */
    PROCEDURE("procedure"),
    
    /** 查询建模 */
    QUERY_MODELING("queryModeling"),
    
    /** 查询重写 */
    QUERY_EXTEND("queryExtend"),
    
    /** 自定义SQL调用 */
    USER_DEFINED_SQL("userDefinedSQL"),
    
    /** 分页方法 */
    PAGINATION("pagination");
    
    /** 值 */
    private String value;
    
    /**
     * 构造函数
     * 
     * @param value 枚举值
     */
    private MethodType(String value) {
        this.value = value;
    }
    
    /**
     * @return 获取 value属性值
     */
    public String getValue() {
        return value;
    }
}
