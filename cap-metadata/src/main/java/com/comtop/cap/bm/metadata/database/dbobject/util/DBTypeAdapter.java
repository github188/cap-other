/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.database.dbobject.util;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.bm.metadata.database.util.DBUtils;
import com.comtop.cap.bm.metadata.entity.util.ConnectionProvider;
import com.comtop.cap.bm.metadata.preferencesconfig.PreferenceConfigQueryUtil;
import com.comtop.cip.jodd.util.StringUtil;

/**
 * 数据库类型适配器
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年12月9日 许畅 新建
 */
public final class DBTypeAdapter {
    
    /**
     * 构造方法
     */
    private DBTypeAdapter() {
        super();
    }
    
    /** tomcat等容器连接池缓存 */
    private static final Map<String, Object> connectPoolCache = new HashMap<String, Object>();
    
    /** 日志记录 */
    private static final Logger LOGGER = LoggerFactory.getLogger(DBTypeAdapter.class);
    
    /** oracle正则配置表达式 jdbc:oracle:thin:@10.10.5.223:1521:ORCL */
    private static final String ORACLE_URL_REGEXP = "jdbc:oracle:[a-z]+:@(localhost|\\d+[.]\\d+[.]\\d+[.]\\d+):(\\d+):(\\w+)\\b";
    
    /** mysql正则配置表达式 jdbc:mysql://10.10.50.7:3306/cap?characterEncoding=utf8 */
    private static final String MYSQL_URL_REGEXP = "jdbc:mysql://(localhost|\\d+[.]\\d+[.]\\d+[.]\\d+):(\\d+)/(\\w+)\\b";
    
    static {
        @SuppressWarnings("resource")
        Connection conn = ConnectionProvider.getConnection();
        String connJdbcURL = null;
        try {
            connJdbcURL = conn.getMetaData().getURL();
        } catch (SQLException e) {
            LOGGER.error("获取容器连接池中jdbcURL失败:" + e.getMessage(), e);
        } finally {
            DBUtils.closeConnection(conn, null, null);
        }
        connectPoolCache.put("jdbcURL", connJdbcURL);
    }
    
    /**
     * 根据数据库驱动获取数据库类型
     * 
     * @return DBType
     */
    public static DBType getDBType() {
        String jdbcURL = PreferenceConfigQueryUtil.getJdbcURL();
        String jdbcUserName = PreferenceConfigQueryUtil.getJdbcUserName();
        String jdcbPassword = PreferenceConfigQueryUtil.getJdbcPassword();
        
        // 首选项jdbcURL jdbcUserName jdcbPassword都配置则以首选项的驱动为主
        if (StringUtil.isNotBlank(jdbcURL) && StringUtil.isNotBlank(jdbcUserName)
            && StringUtil.isNotBlank(jdcbPassword)) {
            return getDBType(jdbcURL);
        }
        
        // 首选项没有配置完整则从tomcat连接池中取数据库类型
        String connJdbcURL = String.valueOf(connectPoolCache.get("jdbcURL"));
        
        if (connJdbcURL != null) {
            return getDBType(connJdbcURL);
        }
        
        throw new RuntimeException("can not get DB type.please contact administrator.");
    }
    
    /**
     * @param jdbcURL
     *            jdbcURL
     * @return DBType
     */
    private static DBType getDBType(String jdbcURL) {
        if (validateOracle(jdbcURL) != null)
            return DBType.ORACLE;
        
        if (validateMySQL(jdbcURL) != null)
            return DBType.MYSQL;
        
        throw new RuntimeException("can not get DB type.please contact administrator.");
    }
    
    /**
     * 校验oracle
     * 
     * @param jdbcURL
     *            jdbcURL
     * @return DBType
     */
    private static DBType validateOracle(String jdbcURL) {
        Pattern pattern = Pattern.compile(ORACLE_URL_REGEXP);
        Matcher matcher = pattern.matcher(jdbcURL);
        if (matcher.find()) {
            return DBType.ORACLE;
        }
        return null;
    }
    
    /**
     * 校验mysql
     * 
     * @param jdbcURL
     *            jdbcURL
     * @return DBType
     */
    private static DBType validateMySQL(String jdbcURL) {
        Pattern pattern = Pattern.compile(MYSQL_URL_REGEXP);
        Matcher matcher = pattern.matcher(jdbcURL);
        if (matcher.find()) {
            return DBType.MYSQL;
        }
        return null;
    }
    
}
