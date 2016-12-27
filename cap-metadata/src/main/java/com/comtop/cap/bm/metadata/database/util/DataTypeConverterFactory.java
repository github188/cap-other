/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.database.util;

import com.comtop.cap.bm.metadata.database.dbobject.util.DBType;

/**
 * 数据类型转换器工厂
 * 
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-4-10 李忠文
 */
public final class DataTypeConverterFactory {
    
    /**
     * 构造函数
     */
    private DataTypeConverterFactory() {
        super();
    }
    
    /**
     * 获取SQL生成器
     * 
     * 
     * @param conn 数据库连接元数据
     * @return SQL生成器
     */
    public synchronized static IDataTypeConverter getDataTypeConverter(final MetaConnection conn) {
        if (conn.getDbType() == DBType.ORACLE.getNumber()) {
            return OracleDataTypeConverter.getInstance();
        }
        if (conn.getDbType() == DBType.MYSQL.getNumber()) {
            return MySQLDataTypeConverter.getInstance();
        }
        return null;
    }
}
