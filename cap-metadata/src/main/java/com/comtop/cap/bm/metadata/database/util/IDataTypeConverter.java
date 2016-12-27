/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.database.util;

/**
 * 数据库字段类型转换接口
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-4-10 李忠文
 */
public interface IDataTypeConverter {
    
    /** NUMERIC */
    String NUMBER = "NUMBER";
    
    /** CHAR */
    String CHAR = "CHAR";
    
    /** VARCHAR */
    String VARCHAR = "VARCHAR";
    
    /** DATE */
    String DATE = "DATE";
    
    /** TIMESTAMP */
    String TIMESTAMP = "TIMESTAMP";
    
    /** BLOB */
    String BLOB = "BLOB";
    
    /** CLOB */
    String CLOB = "CLOB";
    
    /** LONG */
    String LONG = "LONG";
    
    /**
     * 通过JDBC数据类型获取数据表字段元数据数据类型
     * 
     * @param type JDBC数据类型 ，具体可以参考{@link java.sql.Types}
     * @return 获取对应的数据表字段类型，具体可以参考
     */
    int getFieldDateType(final int type);
    
    /**
     * 通过数据表字段元数据数据类型获取JDBC数据类型
     * 
     * @param type 数据表字段元数据数据类型，具体可以参考
     * @param length 长度
     * @param precision 精度
     * @return JDBC数据类型 ，具体可以参考{@link java.sql.Types}
     */
    String getSQLDateType(final int type, final int length, final int precision);
}
