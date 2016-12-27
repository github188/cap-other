/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.database.execute;

import com.comtop.cap.bm.metadata.database.dbobject.util.DBType;
import com.comtop.cap.bm.metadata.database.dbobject.util.DBTypeAdapter;

/**
 * SQL执行器工厂类
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年11月1日 许畅 新建
 */
public final class SQLExecutorFactory {
    
    /**
     * 构造函数
     */
    private SQLExecutorFactory() {
        super();
    }
    
    /**
     * 获取SQL执行器
     * 
     * @return SQL执行器
     */
    public static ISQLExecutor getInstance() {
        DBType dbType = DBTypeAdapter.getDBType();
        return getInstance(dbType);
    }
    
    /**
     * 获取SQL执行器
     * 
     * @param dbType 数据库类型
     * @return SQL执行器
     */
    public static ISQLExecutor getInstance(DBType dbType) {
        if (DBType.ORACLE.getValue().equals(dbType.getValue())) {
            return SQLExecutorOracle.getInstance();
        } else if (DBType.MYSQL.getValue().equals(dbType.getValue())) {
            return SQLExecutorMySQL.getInstance();
        }
        return SQLExecutorOracle.getInstance();
    }
}
