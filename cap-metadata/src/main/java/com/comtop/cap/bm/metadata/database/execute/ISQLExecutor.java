/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.database.execute;

import java.util.Map;

/**
 * SQL执行器
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年11月1日 许畅 新建
 */
public interface ISQLExecutor {
    
    /**
     * 普通执行SQL
     * 
     * @param sql
     *            SQL
     * @return is success
     */
    public boolean executeSQL(String sql);
    
    /**
     * 全量执行
     * 
     * @param sql
     *            SQL
     * @return boolean success
     */
    public boolean executeCreateTableSQL(String sql);
    
    /**
     * 增量执行
     * 
     * @param sql
     *            SQL
     * @return boolean success
     */
    public boolean executeIncrementSQL(String sql);
    
    /**
     * 执行查询
     * 
     * @param sql
     *            SQL
     * @return 结果集
     */
    public Map<String, Object> executeQuery(String sql);
    
}
