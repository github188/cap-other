/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.model;

/**
 * 模型类别
 *
 * @author 凌晨
 * @since jdk1.6
 * @version 2015年10月14日 凌晨
 */
public enum ModelTypeConstant {
    /** 实体 */
    ENTITY("entity"),
    
    /** 异常 */
    EXCEPTION("exception");
    
    /** 枚举项对应的值 */
    private String value;
    
    /**
     * 构造函数
     * 
     * @param value 枚举项对应的值
     */
    private ModelTypeConstant(String value) {
        this.value = value;
    }
    
    /**
     * @return 获取 value属性值
     */
    public String getValue() {
        return value;
    }
    
}
