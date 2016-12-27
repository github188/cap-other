/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.dao;

import com.comtop.cip.common.util.DatabaseType;

/**
 * 元数据连接中心数据库DAO工厂
 * 
 * 
 * @author 沈康
 * @since 1.0
 * @version 2014-6-10 沈康
 */
public final class MetadataDataBaseDAOFactory {
    
    /**
     * 构造函数
     */
    private MetadataDataBaseDAOFactory() {
        super();
    }
    
    /**
     * 获取SQL生成器
     * 
     * 
     * @param dbType 数据库类型
     * @return SQL生成器
     */
    public synchronized static IMetadataDataBaseDAO getMetadataDataBaseDAO(final int dbType) {
        switch (dbType) {
            case DatabaseType.TYPE_ORACLE:
                return MetadataOracleDataBaseDAO.getInstance();
            case DatabaseType.TYPE_MYSQL:
                return MetadataMySQLDataBaseDAO.getInstance();
            default:
                break;
        }
        return null;
    }
}
