/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.database.util;

import java.sql.Types;

/**
 * MySQL数据库字段类型
 * <p>
 * 此数据类型均以MySQL数据库为基准
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-4-10 李忠文
 */
public final class OracleDataTypeConverter implements IDataTypeConverter {
    
    /** 转换器实例 */
    private static OracleDataTypeConverter instance;
    
    /** VARCHAR2 */
    public static final String VARCHAR2 = "VARCHAR2";
    
    /**
     * 构造函数
     */
    private OracleDataTypeConverter() {
        super();
    }
    
    /**
     * 获取MySQL数据库类型转换器
     * 
     * @return 转换器实例
     */
    public static synchronized OracleDataTypeConverter getInstance() {
        if (instance == null) {
            instance = new OracleDataTypeConverter();
        }
        return instance;
    }
    
    /**
     * 通过JDBC数据类型获取数据表字段元数据数据类型
     * 
     * @param type JDBC数据类型 ，具体可以参考{@link java.sql.Types}
     * @return 获取对应的数据表字段类型，具体可以参考
     */
    @Override
    public int getFieldDateType(final int type) {
        int iFiledType;
        switch (type) {
            case Types.DECIMAL:
            case Types.NUMERIC:
                iFiledType = FieldDataType.NUMBER;
                break;
            case Types.CHAR:
                iFiledType = FieldDataType.CHAR;
                break;
            case Types.VARCHAR:
                iFiledType = FieldDataType.VARCHAR2;
                break;
            case Types.DATE:
            case Types.TIME:
            case Types.OTHER:
            case Types.TIMESTAMP:
                iFiledType = FieldDataType.TIMESTAMP;
                break;
            case Types.BLOB:
                iFiledType = FieldDataType.BLOB;
                break;
            case Types.CLOB:
                iFiledType = FieldDataType.CLOB;
                break;
            default:
                iFiledType = FieldDataType.VARCHAR2;
                break;
        }
        return iFiledType;
    }
    
    /**
     * 通过数据表字段元数据数据类型获取JDBC数据类型
     * 
     * @param type 数据表字段元数据数据类型，具体可以参考
     * @param length 长度
     * @param precision 精度
     * @return JDBC数据类型 ，具体可以参考{@link java.sql.Types}
     */
    @Override
    public String getSQLDateType(final int type, final int length, final int precision) {
        String strSQLType;
        switch (type) {
            case FieldDataType.NUMBER:
                strSQLType = NUMBER;
                break;
            case FieldDataType.CHAR:
                strSQLType = CHAR;
                break;
            case FieldDataType.DATE:
                strSQLType = DATE;
                break;
            case FieldDataType.TIMESTAMP:
                strSQLType = TIMESTAMP;
                break;
            case FieldDataType.BLOB:
                strSQLType = BLOB;
                break;
            case FieldDataType.CLOB:
                strSQLType = CLOB;
                break;
            default:
                strSQLType = VARCHAR2;
                break;
        }
        return strSQLType;
    }
}
