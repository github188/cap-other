/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.database.execute;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.entity.util.ConnectionProvider;
import com.comtop.cap.bm.metadata.query.facade.QueryPreviewFacade;
import com.comtop.top.core.jodd.AppContext;
import com.comtop.top.core.util.DBUtil;

/**
 * SQL执行器MySQL版本
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年11月1日 许畅 新建
 */
public class SQLExecutorMySQL implements ISQLExecutor {
    
    /** SQLExecutor饿汉式单实例 */
    private static final SQLExecutorMySQL instance = new SQLExecutorMySQL();
    
    /** QueryPreviewFacade */
    private static final QueryPreviewFacade FACADE = AppContext.getBean(QueryPreviewFacade.class);
    
    /** 日志 */
    private final static Logger LOGGER = LoggerFactory.getLogger(SQLExecutorMySQL.class);
    
    /**
     * 构造方法
     */
    private SQLExecutorMySQL() {
        if (null != instance) {
            throw new RuntimeException("please do not try new SQLExecutorMySQL instance.");
        }
    }
    
    /**
     * 获取SQLExecutor实例
     * 
     * @return 获取SQLExecutor实例
     */
    public static SQLExecutorMySQL getInstance() {
        return instance;
    }
    
    /**
     * 执行单条SQL
     * 
     * @param sql
     *            SQL
     * @return is success
     *
     * @see com.comtop.cap.bm.metadata.database.execute.ISQLExecutor#executeSQL(java.lang.String)
     */
    @Override
    public boolean executeSQL(String sql) {
        if (StringUtils.isBlank(sql))
            return false;
        
        Connection objConnect = null;
        Statement objStmt = null;
        ResultSet result = null;
        SQLException sqlException = null;
        boolean success = false;
        try {
            objConnect = ConnectionProvider.getConnection();
            if (objConnect != null) {
                objStmt = objConnect.createStatement();
            }
            if (objStmt != null) {
                LOGGER.info("执行" + sql + "...");
                objStmt.execute(sql.trim());
            }
        } catch (SQLException e) {
            LOGGER.error("执行SQL失败:" + e.getMessage(), e);
            sqlException = e;
        } finally {
            DBUtil.closeConnection(objConnect, objStmt, result);
        }
        
        if (sqlException != null)
            throw new RuntimeException(sqlException);
        
        return success;
    }
    
    /**
     * 执行全量SQL
     *
     * @param sql
     *            SQL
     * @return is success
     *
     * @see com.comtop.cap.bm.metadata.database.execute.ISQLExecutor#executeCreateTableSQL(java.lang.String)
     */
    @Override
    public boolean executeCreateTableSQL(String sql) {
        if (StringUtils.isBlank(sql))
            return false;
        
        Connection objConnect = null;
        Statement objStmt = null;
        ResultSet result = null;
        SQLException sqlException = null;
        boolean success = false;
        try {
            objConnect = ConnectionProvider.getConnection();
            if (objConnect != null) {
                objStmt = objConnect.createStatement();
            }
            if (objStmt != null) {
                String[] sqls = sql.trim().split(";");
                for (String sqlstr : sqls) {
                    LOGGER.info("执行" + sqlstr.trim() + "...");
                    objStmt.execute(sqlstr.trim());
                }
            }
        } catch (SQLException e) {
            LOGGER.error("执行SQL失败:" + e.getMessage(), e);
            sqlException = e;
        } finally {
            DBUtil.closeConnection(objConnect, objStmt, result);
        }
        
        if (sqlException != null)
            throw new RuntimeException(sqlException);
        
        return success;
    }
    
    /**
     * 执行增量SQL
     * 
     * @param sql
     *            SQL
     * @return is success
     *
     * @see com.comtop.cap.bm.metadata.database.execute.ISQLExecutor#executeIncrementSQL(java.lang.String)
     */
    @Override
    public boolean executeIncrementSQL(String sql) {
        if (StringUtils.isBlank(sql))
            return false;
        
        Connection objConnect = null;
        Statement objStmt = null;
        ResultSet result = null;
        SQLException sqlException = null;
        boolean success = false;
        try {
            objConnect = ConnectionProvider.getConnection();
            if (objConnect != null) {
                objStmt = objConnect.createStatement();
            }
            if (objStmt != null) {
                String[] sqls = sql.trim().split(";");
                for (String sqlstr : sqls) {
                    LOGGER.info("执行" + sqlstr + "...");
                    objStmt.execute(sqlstr);
                }
            }
        } catch (SQLException e) {
            LOGGER.error("执行SQL失败:" + e.getMessage(), e);
            sqlException = e;
        } finally {
            DBUtil.closeConnection(objConnect, objStmt, result);
        }
        
        if (sqlException != null)
            throw new RuntimeException(sqlException);
        
        return success;
    }
    
    /**
     * 返回SQL的所有查询结果集
     * 
     * @param sql
     *            SQL内容
     * @return Map中datas为数据源,columns为所有列名
     *
     * @see com.comtop.cap.bm.metadata.database.execute.ISQLExecutor#executeQuery(java.lang.String)
     */
    @Override
    public Map<String, Object> executeQuery(String sql) {
        return FACADE.sqlExecute(sql);
    }
    
}
