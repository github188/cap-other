/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.database.util;

import java.sql.Connection;

import com.comtop.cap.bm.metadata.database.dbobject.util.DBType;

/**
 * 数据库连接元数据
 * 
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-3-26 李忠文
 */
public class MetaConnection {
    
    /** 数据库服务器 */
    private String hostName;
    
    /** 数据库端口 */
    private int port;
    
    /** 数据库名称,Oracle数据库时，为SID */
    private String dbName;
    
    /** 用户名 */
    private String userName;
    
    /** 密码 */
    private String password;
    
    /** 数据库类型 ；0：oracle,1:MySQL */
    private int dbType;
    
    /*** 数据库存连接地址 */
    private String jdbcUrl;
    
    /*** 数据库驱动 **/
    private String driverClass;
    
    /*** 是否从连接池中加载 **/
    private boolean loadFromConnPool;
    
    /** 真实的数据库连接 */
    private Connection conn;
    
    /**
     * @return 获取 hostName属性值
     */
    public String getHostName() {
        return hostName;
    }
    
    /**
     * @param hostName 设置 hostName 属性值为参数值 hostName
     */
    public void setHostName(String hostName) {
        this.hostName = hostName;
    }
    
    /**
     * @return 获取 port属性值
     */
    public int getPort() {
        return port;
    }
    
    /**
     * @param port 设置 port 属性值为参数值 port
     */
    public void setPort(int port) {
        this.port = port;
    }
    
    /**
     * @return 获取 dbName属性值
     */
    public String getDbName() {
        return dbName;
    }
    
    /**
     * @param dbName 设置 dbName 属性值为参数值 dbName
     */
    public void setDbName(String dbName) {
        this.dbName = dbName;
    }
    
    /**
     * @return 获取 userName属性值
     */
    public String getUserName() {
        return userName;
    }
    
    /***
     * 获取数据库驱动
     * 
     * @return 数据库驱动
     */
    public String getDriverClass() {
        return driverClass;
    }
    
    /***
     * 设置数据库驱动>
     * 
     * @param driverClass 数据库驱动>
     */
    public void setDriverClass(String driverClass) {
        this.driverClass = driverClass;
    }
    
    /**
     * @param userName 设置 userName 属性值为参数值 userName
     */
    public void setUserName(String userName) {
        this.userName = userName;
    }
    
    /**
     * @return 获取 password属性值
     */
    public String getPassword() {
        return password;
    }
    
    /**
     * @param password 设置 password 属性值为参数值 password
     */
    public void setPassword(String password) {
        this.password = password;
    }
    
    /**
     * @return 获取 dbType属性值
     */
    public int getDbType() {
        return dbType;
    }
    
    /**
     * @param dbType 设置 dbType 属性值为参数值 dbType
     */
    public void setDbType(int dbType) {
        this.dbType = dbType;
    }
    
    /**
     * 获取数据库Schema
     * 
     * @return 数据库Schema
     */
    public String getSchema() {
        if (this.dbType == DBType.ORACLE.getNumber()) {
            return this.userName.toUpperCase();
        }
        if (this.dbType == DBType.MYSQL.getNumber()) {
            return this.dbName;
        }
        return this.userName;
    }
    
    /***
     * 获取数据库连接地址
     * 
     * @return 数据库连接地址
     */
    public String getJdbcUrl() {
        return jdbcUrl;
    }
    
    /***
     * 设置 数据库连接地址
     * 
     * @param jdbcUrl 数据库连接地址
     */
    public void setJdbcUrl(String jdbcUrl) {
        this.jdbcUrl = jdbcUrl;
    }
    
    /**
     * @return the loadFromConnPool 是否从连接池中加载
     */
    public boolean isLoadFromConnPool() {
        return loadFromConnPool;
    }
    
    /**
     * @param loadFromConnPool the loadFromConnPool to set 是否从连接池中加载
     */
    public void setLoadFromConnPool(boolean loadFromConnPool) {
        this.loadFromConnPool = loadFromConnPool;
    }
    
    /**
     * @return 获取 conn属性值
     */
    public Connection getConn() {
        return conn;
    }
    
    /**
     * @param conn 设置 conn 属性值为参数值 conn
     */
    public void setConn(Connection conn) {
        this.conn = conn;
    }
    
}
