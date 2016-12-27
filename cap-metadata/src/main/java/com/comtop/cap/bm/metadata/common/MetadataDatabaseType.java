/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common;

/**
 * 数据库类型
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-3-26 李忠文
 */
public final class MetadataDatabaseType {
    
    /**
     * 构造函数
     */
    private MetadataDatabaseType() {
        super();
    }
    
    /** oracle数据库 */
    public static final String TYPE_ORACLE = "ORACLE";
    
    /** MySQL数据库 */
    public static final String TYPE_MYSQL = "MySQL";
    
}
