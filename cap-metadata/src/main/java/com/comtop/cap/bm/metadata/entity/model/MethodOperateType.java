/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.model;

/**
 * 具体的操作类型，可以是CRUD中的任意一种
 *
 * @author 凌晨
 * @since jdk1.6
 * @version 2015年10月8日 凌晨
 */
public enum MethodOperateType {
    /** 新增（插入） */
    INSERT("insert"),
    
    /** 更新 */
    UPDATE("update"),
    
    /** 查询 */
    QUERY("query"),
    
    /** 删除 */
    DELETE("delete"),
    
    /** 保存 */
    SAVE("save");
    
    /** 枚举项对应的值 */
    private String value;
    
    /**
     * 构造函数
     * 
     * @param value 方法操作类型
     */
    private MethodOperateType(String value) {
        this.value = value;
    }
    
    /**
     * @return 获取 value属性值
     */
    public String getValue() {
        return value;
    }
    
}
