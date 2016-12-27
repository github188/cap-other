/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.util;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.database.dbobject.util.DBType;
import com.comtop.cap.bm.metadata.database.util.MetaConnection;
import com.comtop.cap.bm.metadata.preferencesconfig.PreferenceConfigQueryUtil;
import com.comtop.cap.runtime.base.dao.CapBaseCommonDAO;
import com.comtop.cip.common.util.DatabaseType;
import com.comtop.cip.jodd.util.StringUtil;
import com.comtop.top.core.jodd.AppContext;

/**
 * CAP获取数据库连接服务的提供者
 *
 *
 * @author 凌晨
 * @since jdk1.6
 * @version 2016年12月13日 凌晨
 */
public class ConnectionProvider {
    
    /** 日志记录 */
    private static final Logger LOGGER = LoggerFactory.getLogger(ConnectionProvider.class);
    
    /** 取得coreDAO实例 */
    @SuppressWarnings("rawtypes")
    private static final CapBaseCommonDAO DAO = AppContext.getBean(CapBaseCommonDAO.class);
    
    /**
     * 获取MetaConnection.
     *
     * @return 封装的MetaConnection
     */
    @SuppressWarnings("resource")
    public static MetaConnection getMetaConnection() {
        MetaConnection metaConnection = new MetaConnection();
        
        // 获取数据源信息
        String strDriver = PreferenceConfigQueryUtil.getDriverName();
        String strUserName = PreferenceConfigQueryUtil.getJdbcUserName();
        String strPassword = PreferenceConfigQueryUtil.getJdbcPassword();
        String jdbcUrl = PreferenceConfigQueryUtil.getJdbcURL();
        
        Connection conn = getConnection(strDriver, strUserName, strPassword, jdbcUrl);
        if (StringUtil.isBlank(jdbcUrl) || StringUtil.isBlank(strUserName) || StringUtil.isBlank(strPassword)) {
            metaConnection.setLoadFromConnPool(true);
            try {
                DatabaseMetaData metaData = conn.getMetaData();
                jdbcUrl = metaData.getURL();
                strDriver = DriverManager.getDriver(jdbcUrl).getClass().getName();
                strUserName = metaData.getUserName();
            } catch (SQLException e) {
                LOGGER.error("获取数据库信息失败:" + e.getMessage(), e);
            }
        }
        
        // 设置真实数据库连接
        metaConnection.setConn(conn);
        metaConnection.setDriverClass(strDriver);
        metaConnection.setUserName(strUserName);
        metaConnection.setPassword(strPassword);
        metaConnection.setJdbcUrl(jdbcUrl);
        // 数据库类型
        metaConnection.setDbType(convertDatabaseType(strDriver));
        
        // 解析数据库ip、port等
        parseURL4MetaConnection(metaConnection, jdbcUrl);
        
        return metaConnection;
    }
    
    /**
     * @param strDriver
     *            驱动名称
     * @return 驱动名称
     */
    private static int convertDatabaseType(String strDriver) {
        if (null == strDriver) {
            throw new RuntimeException("DB driver is null.");
        }
        
        if (strDriver.indexOf("oracle") != -1) {
            return DatabaseType.TYPE_ORACLE;
        }
        if (strDriver.indexOf("mysql") != -1) {
            return DatabaseType.TYPE_MYSQL;
        }
        
        throw new RuntimeException("can not get DB type from DB driver,please check CAP preference configuration.");
    }
    
    /**
     * @param metaConnection MetaConnection
     * @param jdbcUrl
     *            jdbc连接地址
     */
    private static void parseURL4MetaConnection(MetaConnection metaConnection, String jdbcUrl) {
        if (StringUtil.isBlank(jdbcUrl)) {
            return;
        }
        // JDBCURL的正则表达式
        String jdbcUrlRegExp = "";
        if (metaConnection.getDbType() == DBType.ORACLE.getNumber()) {
            // jdbc:oracle:thin:@10.10.5.223:1521:ORCL
            jdbcUrlRegExp = "jdbc:oracle:[a-z]+:@(localhost|\\d+[.]\\d+[.]\\d+[.]\\d+):(\\d+):(\\w+)\\b";
        } else if (metaConnection.getDbType() == DBType.MYSQL.getNumber()) {
            // jdbc:mysql://10.10.50.7:3306/cap?characterEncoding=utf8
            jdbcUrlRegExp = "jdbc:mysql://(localhost|\\d+[.]\\d+[.]\\d+[.]\\d+):(\\d+)/(\\w+)\\b";
        }
        if (StringUtil.isBlank(jdbcUrlRegExp)) {
            return;
        }
        
        Pattern pattern = Pattern.compile(jdbcUrlRegExp);
        Matcher matcher = pattern.matcher(jdbcUrl);
        if (matcher.find()) {
            try {
                metaConnection.setPort(Integer.parseInt(matcher.group(2)));
            } catch (NumberFormatException e) {
                throw e;
            }
            metaConnection.setHostName(matcher.group(1));
            metaConnection.setDbName(matcher.group(3));
        }
    }
    
    /**
     * 通过传入首选项配置的数据库信息，手动开启JDBC数据库连接；如果首选项不指定数据库信息，则获取当前服务的数据库连接。
     * 
     * @param dbInfo 可变参数；数据库信息，依次传入顺序为驱动、用户名、密码、URL
     * @return 数据库连接
     */
    public static Connection getConnection(String... dbInfo) {
        if (null == dbInfo || dbInfo.length != 4) {
            return DAO.getConnection();
        }
        
        // 获取数据源信息
        String strDriver = dbInfo[0];
        String strUserName = dbInfo[1];
        String strPassword = dbInfo[2];
        String jdbcUrl = dbInfo[3];
        
        // jdbcUrl、strUserName、strPassword有任何一个为空，则从连接池中取链接
        if (StringUtil.isBlank(jdbcUrl) || StringUtil.isBlank(strUserName) || StringUtil.isBlank(strPassword)) {
            return DAO.getConnection();
        }
        
        return openJDBCConnection(strDriver, strUserName, strPassword, jdbcUrl);
    }
    
    /**
     * 通过手动开启JDBC连接
     * 
     * @param strDriver 数据库驱动
     * @param strUserName 数据库用户名
     * @param strPassword 数据库密码
     * @param jdbcUrl 数据库jdbcURL
     * @return 数据库连接
     */
    public static Connection openJDBCConnection(String strDriver, String strUserName, String strPassword, String jdbcUrl) {
        
        if (StringUtil.isBlank(strDriver)) {
            throw new RuntimeException(
                "DB driver is blank,please check CAP preference configuration or contact administrator.");
        }
        
        Properties objProp = new Properties();
        objProp.put("user", strUserName);
        objProp.put("password", strPassword);
        if ("com.mysql.jdbc.Driver".equals(strDriver)) {
            objProp.put("remarks", "true");
            objProp.put("useInformationSchema", "true");
        } else {
            objProp.put("remarksReporting", "true");
        }
        Connection objConn = null;
        try {
            // 加载数据库驱动
            Class.forName(strDriver);
            objConn = DriverManager.getConnection(jdbcUrl, objProp);
        } catch (ClassNotFoundException e) {
            LOGGER.error("can not find driver class named:" + strDriver, e);
        } catch (SQLException e) {
            LOGGER.error(e.getMessage(), e);
        }
        return objConn;
    }
    
}
