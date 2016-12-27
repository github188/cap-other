/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.database.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 数据库工具类
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年12月6日 许畅 新建
 */
public final class DBUtils {

	/** 日志 */
	private final static Logger LOGGER = LoggerFactory.getLogger(DBUtils.class);

	/**
	 * 构造方法
	 */
	private DBUtils() {
		super();
	}

	/**
	 * 获取数据库Connection
	 * 
	 * @param driver
	 *            驱动名称
	 * @param url
	 *            数据库连接url
	 * @param username
	 *            用户名称
	 * @param password
	 *            用户密码
	 * @return Connection
	 * @throws ClassNotFoundException
	 *             ClassNotFoundException
	 * @throws SQLException
	 *             SQLException
	 */
	public static Connection getConnection(String driver, String url,
			String username, String password) throws ClassNotFoundException,
			SQLException {
		Connection conn = null;
		Class.forName(driver);
		conn = DriverManager.getConnection(url, username, password);
		return conn;
	}

	/**
	 * 是否连接数据库成功
	 * 
	 * @param driver
	 *            驱动名称
	 * @param url
	 *            数据库连接url
	 * @param username
	 *            用户名称
	 * @param password
	 *            用户密码
	 * @return Connection
	 */
	public static boolean isConnection(String driver, String url,
			String username, String password) {
		boolean flag = false;
		Connection conn = null;
		try {
			conn = getConnection(driver, url, username, password);
			if (conn != null)
				flag = true;
		} catch (ClassNotFoundException e) {
			LOGGER.error("驱动class找不到:" + e.getMessage(), e);
		} catch (SQLException e) {
			LOGGER.error("获取连接失败:" + e.getMessage(), e);
		} finally {
			closeConnection(conn, null, null);
		}
		return flag;
	}

	/**
	 * 关闭数据库连接
	 * 
	 * @param connection
	 *            Connection
	 * @param stmt
	 *            Statement
	 * @param rs
	 *            ResultSet
	 */
	public static void closeConnection(Connection connection, Statement stmt,
			ResultSet rs) {
		if (rs != null) {
			try {
				rs.close();
			} catch (SQLException e) {
				LOGGER.error("关闭游标池出错：" + e.getMessage(), e);
			}
		}

		if (stmt != null) {
			try {
				stmt.close();
			} catch (SQLException e) {
				LOGGER.error("关闭statement出错：" + e.getMessage(), e);
			}
		}
		if (connection == null)
			return;
		try {
			connection.close();
		} catch (SQLException e) {
			LOGGER.error("关闭数据库连接出错：" + e.getMessage(), e);
		}
	}

}
