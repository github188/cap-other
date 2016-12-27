/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.database.loader;

import com.comtop.cap.bm.metadata.database.dbobject.util.DBType;
import com.comtop.cap.bm.metadata.database.util.MetaConnection;

/**
 * 数据库元数据加载器工厂
 * 
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-3-27 李忠文
 */
public final class DatabaseLoaderFactory {
    
    /** Oracle数据库元数据加载器 */
    private static IDatabaseLoader oracleDataBaseLoadder;
    
    /** MySQL数据库元数据加载器 */
    private static IDatabaseLoader mysqlDataBaseLoadder;
    
    /**
     * 构造函数
     */
    private DatabaseLoaderFactory() {
        super();
    }
    
    /**
     * 获取SQL生成器
     * 
     * 
     * @param conn 数据库连接元数据
     * @return SQL生成器
     */
    public synchronized static IDatabaseLoader getDataBaseLoader(final MetaConnection conn) {
        if (conn.getDbType() == DBType.ORACLE.getNumber()) {
            if (oracleDataBaseLoadder == null) {
                oracleDataBaseLoadder = new OracleDatabaseLoader();
            }
            return oracleDataBaseLoadder;
        }
        
        if (conn.getDbType() == DBType.MYSQL.getNumber()) {
            if (mysqlDataBaseLoadder == null) {
                mysqlDataBaseLoadder = new MySQLDatabaseLoader();
            }
            return mysqlDataBaseLoadder;
        }
        return null;
    }
}
