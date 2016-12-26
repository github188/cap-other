/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop;

import java.io.File;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * 配置切换
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年12月21日 lizhongwen
 */
public class ConfigSwitcher {
    
    /** 资源文件名称 */
    private static final String[] FILES = new String[] { "applicationContext_bpmsengine_bpms_evn.xml",
        "applicationContext_bpmsmonitor.xml", "eic_config.properties", "soa-config.properties", "top-sql-config.xml" };
    
    /** 相对路径 */
    public static final String RELATIVE = "../../../resources";
    
    /** Tomcat配置 */
    public static final String TOMCAT_CONTEXT_CONFIG = "D:/apache-tomcat-7.0.70/conf/context.xml";
    
    /**
     * 入口
     *
     * @param args 主方法
     */
    public static void main(String[] args) {
        ClassLoader loader = Thread.currentThread().getContextClassLoader();
        URL url = loader.getResource("");
        try {
            Path path = Paths.get(url.toURI()).resolve(RELATIVE);
            if ("mysql".equals(detect(path))) {
                mysqlToOracle(path);
            } else if ("oracle".equals(detect(path))) {
                oracleToMySQL(path);
            }
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }
        
    }
    
    /**
     * 检测当前环境
     *
     * @param root 路径
     * @return 当前环境
     */
    private static String detect(Path root) {
        File oracleFile;
        File mysqlFile;
        int mysqlCount = 0, oracleCount = 0;
        for (String str : FILES) {
            mysqlFile = root.resolve(str + ".mysql").toFile();
            oracleFile = root.resolve(str + ".oracle").toFile();
            if (mysqlFile.exists()) {
                mysqlCount++;
            } else if (oracleFile.exists()) {
                oracleCount++;
            }
        }
        return mysqlCount == FILES.length ? "oracle" : (oracleCount == FILES.length ? "mysql" : "unknown");
    }
    
    /**
     * MySQL配置切换为oracle
     * 
     * @param root 配置文件根目录
     */
    public static void mysqlToOracle(Path root) {
        switchConfig(root, "mysql", "oracle");
        Path contextPath = Paths.get(TOMCAT_CONTEXT_CONFIG);
        switchConfiguration(contextPath, "mysql", "oracle");
    }
    
    /**
     * oracle配置切换为MySQL
     * 
     * @param root 配置文件根目录
     */
    public static void oracleToMySQL(Path root) {
        switchConfig(root, "oracle", "mysql");
        Path contextPath = Paths.get(TOMCAT_CONTEXT_CONFIG);
        switchConfiguration(contextPath, "oracle", "mysql");
    }
    
    /**
     * 切换配置
     *
     * @param root 配置文件根目录
     * @param source 源
     * @param target 目标
     */
    public static void switchConfig(Path root, String source, String target) {
        Path path;
        for (String str : FILES) {
            path = root.resolve(str);
            switchConfiguration(path, source, target);
        }
    }
    
    /**
     * 切换配置文件
     *
     * @param path 配置文件路径
     * @param source 源
     * @param target 目标
     */
    public static void switchConfiguration(Path path, String source, String target) {
        File file = path.toFile();
        File oracleFile = Paths.get(path.toString() + "." + target).toFile();
        File mysqlFile = Paths.get(path.toString() + "." + source).toFile();
        if (file.exists() && oracleFile.exists()) {
            file.renameTo(mysqlFile);
            oracleFile.renameTo(file);
        }
    }
}
