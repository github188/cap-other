/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.common.executor;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 连接工具类
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月4日 lizhiyong
 */
public class ConnectionUtil {
    
    /** 日志对象 */
    private static final Logger LOGGER = LoggerFactory.getLogger(ConnectionUtil.class);
    
    /**
     * 关闭连接
     *
     * @param rs 结果集
     */
    public static void closeConnection(ResultSet rs) {
        if (rs != null) {
            try {
                if (!rs.isClosed()) {
                    rs.close();
                }
            } catch (SQLException e) {
                LOGGER.error("关闭结果集发生异常", e);
            }
        }
    }
    
    /**
     * 关闭连接
     *
     * @param stmt stmt
     */
    public static void closeConnection(Statement stmt) {
        if (stmt != null) {
            try {
                if (!stmt.isClosed()) {
                    stmt.close();
                }
            } catch (SQLException e) {
                LOGGER.error("关闭stmt发生异常", e);
            }
        }
    }
    
    /**
     * 关闭连接
     *
     * @param rs 结果集
     * @param stmt stmt
     */
    public static void closeConnection(ResultSet rs, Statement stmt) {
        closeConnection(rs);
        closeConnection(stmt);
    }
    
    /**
     * 关闭连接
     *
     * @param rs 结果集
     * @param stmt stmt
     * @param conn 连接
     */
    public static void closeConnection(ResultSet rs, Statement stmt, Connection conn) {
        closeConnection(rs, stmt);
        closeConnection(conn);
    }
    
    /**
     * 关闭连接
     *
     * @param conn 连接
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                if (!conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException e) {
                LOGGER.error("关闭连接发生异常", e);
            }
        }
    }
}
