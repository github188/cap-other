/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.model;

/**
 * 实体来源
 * 
 * @author 林玉千
 * @since jdk1.6
 * @version 2016-11-18 林玉千
 */
public enum EntitySource {
    /** 数据表导入 */
    TABLE_METADATA_IMPORT("table_metadata_import"),
    
    /** 视图导入 */
    VIEW_METADATA_IMPORT("view_metadata_import"),
    
    /** 业务对象导入 */
    BIZ_OBJECT_IMPORT("biz_object_import"),
    
    /** 已有实体录入 ，不能生成代码，后台必须存在其对应的java类 */
    EXIST_ENTITY_INPUT("exist_entity_input"),
    
    /** 用户手工创建，可生成代码 */
    USER_CREATE("user_create");
    
    /** 值 */
    private String value;
    
    /**
     * 构造函数
     * 
     * @param value 枚举值
     */
    private EntitySource(String value) {
        this.value = value;
    }
    
    /**
     * @return 获取 value属性值
     */
    public String getValue() {
        return value;
    }
    
}
