/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.model;

/**
 * 实体类型
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-4-1 李忠文
 */
public enum EntityType {
    /** 业务实体 */
    BIZ_ENTITY("biz_entity"),
    
    /** 查询实体 */
    QUERY_ENTITY("query_entity"),
    
    /** 数据实体 */
    DATA_ENTITY("data_entity");
    
    /** 枚举项对应的值 */
    private String value;
    
    /**
     * @param Value 枚举值
     */
    private EntityType(String Value) {
        this.value = Value;
    }
    
    /**
     * @return 获取 value属性值
     */
    public String getValue() {
        return value;
    }
    
}
