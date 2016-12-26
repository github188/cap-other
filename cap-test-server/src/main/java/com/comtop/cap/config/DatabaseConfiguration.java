/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.config;

import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.sql.DataSource;

import oracle.jdbc.pool.OracleDataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.bind.RelaxedPropertyResolver;
import org.springframework.context.EnvironmentAware;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.util.StringUtils;

import com.mysql.jdbc.jdbc2.optional.MysqlDataSource;

/**
 * 数据库配置
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年9月28日 lizhongwen
 */
@Configuration
@EnableTransactionManagement
public class DatabaseConfiguration implements EnvironmentAware {
    
    /** 日志 */
    private static final Logger log = LoggerFactory.getLogger(DatabaseConfiguration.class);
    
    /** 属性解析 */
    private RelaxedPropertyResolver resolver;
    
    @Override
    public void setEnvironment(Environment env) {
        this.resolver = new RelaxedPropertyResolver(env, "spring.datasource.");
    }
    
    /**
     * JDBC模板
     *
     * @param dataSource 数据源
     * @return JDBC模板
     */
    @Bean
    public JdbcTemplate jdbcTemplate(DataSource dataSource) {
        return new JdbcTemplate(dataSource);
    }
    
    /**
     * 事物管理
     *
     * @param dataSource 数据源
     * @return 事物管理
     */
    @Bean
    public PlatformTransactionManager transactionManager(DataSource dataSource) {
        return new DataSourceTransactionManager(dataSource);
    }
    
    /**
     * 数据源
     *
     * @return 数据源
     * @throws SQLException SQL异常
     */
    @Bean
    public DataSource dataSource() throws SQLException {
        // return DataSourceBuilder.create().driverClassName(resolver.getProperty("driverClassName"))
        // .url(resolver.getProperty("url")).username(resolver.getProperty("username"))
        // .password(resolver.getProperty("password")).build();
        if (StringUtils.isEmpty(resolver.getProperty("driverClassName"))
            || resolver.getProperty("driverClassName").indexOf("oracle") > -1) {
            OracleDataSource dataSource = new OracleDataSource();
            dataSource.setUser(resolver.getProperty("username"));
            dataSource.setPassword(resolver.getProperty("password"));
            dataSource.setURL(resolver.getProperty("url"));
            dataSource.setImplicitCachingEnabled(true);
            // dataSource.setFastConnectionFailoverEnabled(true);
            return dataSource;
        }
        MysqlDataSource objMysqlDataSource = new MysqlDataSource();
        objMysqlDataSource.setUser(resolver.getProperty("username"));
        objMysqlDataSource.setPassword(resolver.getProperty("password"));
        objMysqlDataSource.setURL(resolver.getProperty("url"));
        return objMysqlDataSource;
    }
    
    /**
     * 加载sql文件
     * 
     * @return SQL文件
     *
     */
    @Bean
    public Map<String, String> sqlMap() {
        boolean bOracle = StringUtils.isEmpty(resolver.getProperty("driverClassName"))
            || resolver.getProperty("driverClassName").indexOf("oracle") > -1;
        String strFilePath = "/com/comtop/cap/report/dbconfig/ReportSQL_mysql.properties";
        if (bOracle) {
            strFilePath = "/com/comtop/cap/report/dbconfig/ReportSQL_oracle.properties";
        }
        Map<String, String> objSQLMap = new HashMap<String, String>();
        Properties objProperties = new Properties();
        try (InputStream objInputStream = this.getClass().getResourceAsStream(strFilePath);) {
            objProperties.load(objInputStream);
            for (Object key : objProperties.keySet()) {
                objSQLMap.put((String) key, objProperties.getProperty((String) key));
            }
        } catch (IOException e) {
            log.error("sql配置文件读取错误", e);
        }
        return objSQLMap;
    }
    
}
