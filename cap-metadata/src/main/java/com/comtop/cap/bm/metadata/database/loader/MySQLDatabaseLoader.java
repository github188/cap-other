/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.database.loader;

import com.comtop.cip.jodd.petite.meta.PetiteBean;

/**
 * MySQL数据库元数据加载器
 * 
 * 
 * @author 沈康
 * @since 1.0
 * @version 2014-5-4 沈康
 */
@PetiteBean
public class MySQLDatabaseLoader extends AbstractMetaDatabaseLoader {
    
    /** 日志 */
    // private static final Logger LOGGER = LoggerFactory.getLogger(MySQLDatabaseLoader.class);
    
    /** 查询索引的SQL */
    public static final String LOAD_INDEX_SQL;
    
    static {
        StringBuilder strSQL = new StringBuilder(200);
        strSQL.append("SELECT NULL AS TABLE_CAT, \n");
        strSQL.append("       I.OWNER AS TABLE_SCHEM, \n");
        strSQL.append("       I.TABLE_NAME, \n");
        strSQL.append("       decode (I.UNIQUENESS, 'UNIQUE', 0, 1) AS NON_UNIQUE, \n");
        strSQL.append("       NULL AS INDEX_QUALIFIER, \n");
        strSQL.append("       I.INDEX_NAME, \n");
        strSQL.append("       I.INDEX_TYPE AS TYPE, \n");
        strSQL.append("       C.COLUMN_POSITION AS ORDINAL_POSITION, \n");
        strSQL.append("       C.COLUMN_NAME, \n");
        strSQL.append("       decode(C.DESCEND, 'ASC', 'A', 'DESC', 'D', NULL) AS ASC_OR_DESC, \n");
        strSQL.append("       I.DISTINCT_KEYS AS CARDINALITY, \n");
        strSQL.append("       I.LEAF_BLOCKS AS PAGES, \n");
        strSQL.append("       NULL AS FILTER_CONDITION, \n");
        strSQL.append("       I.TABLESPACE_NAME, \n");
        strSQL.append("       I.PARTITIONED, \n");
        strSQL.append("       I.COMPRESSION, \n");
        strSQL.append("       I.PREFIX_LENGTH \n");
        strSQL.append("FROM ALL_INDEXES I");
        strSQL.append("  JOIN ALL_IND_COLUMNS C ");
        strSQL.append("    ON I.INDEX_NAME = C.INDEX_NAME \n");
        strSQL.append("   AND I.TABLE_OWNER = C.TABLE_OWNER \n");
        strSQL.append("   AND I.TABLE_NAME = C.TABLE_NAME \n");
        strSQL.append("   AND I.OWNER = C.INDEX_OWNER \n");
        strSQL.append("WHERE I.TABLE_NAME = ? \n");
        strSQL.append("  AND I.OWNER = ? \n");
        strSQL.append("  AND I.INDEX_NAME NOT LIKE 'I_SNAP$%' \n");
        strSQL.append("ORDER BY NON_UNIQUE, TYPE, INDEX_NAME, ORDINAL_POSITION ");
        LOAD_INDEX_SQL = strSQL.toString();
    }
}
