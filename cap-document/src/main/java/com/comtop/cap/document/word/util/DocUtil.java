/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.util;

import java.io.File;
import java.net.URI;
import java.text.MessageFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.lang.StringUtils;

/**
 * 文档操作工具类
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月24日 lizhiyong
 */
public class DocUtil {
    
    /** 日志文件路径样式 */
    public static final String LOG_PATH_STYLE = "{0}/doc-log/{1}-{2}-{3}.log";
    
    /** 时间格式化字符串 年月日 */
    public static final String Format_STR_YYYYMMDD = "yyyyMMdd";
    
    /** 时间格式化字符串 年月日时分秒 */
    public static final String Format_STR_YYYYMMDDHHMMSS = "yyyyMMddHHmmss";
    
    /** 时间格式化字符串 年月日时分秒毫秒 */
    public static final String Format_STR_YYYYMMDDHHMMSSSS = "yyyyMMddHHmmsssss";
    
    /** 文档配置文件路径样式 */
    public static final String DOC_CONFIG_FILE_PATH_STYLE = "{0}/docconfig-{1}-{2}.xml";
    
    /** 文档配置文件路径样式 */
    public static final String DOC_CONFIG_FILE_DIR_STYLE = "{0}/docconfig/";
    
    /**
     * F创建日志文件路径
     *
     * @param rootPath 根路径
     * @param fileName 文件名
     * @param logType 日志类型
     * @return 文件名
     */
    public static String createLogPath(String rootPath, String fileName, String logType) {
        String strLogType = logType;
        if (StringUtils.isBlank(strLogType)) {
            strLogType = "default";
        }
        return MessageFormat.format(LOG_PATH_STYLE, rootPath, StringUtils.lowerCase(strLogType), fileName,
            getTimestampString());
    }
    
    /**
     * 创建新的配置文件
     * 
     * @param docType 文档类型
     *
     * @param documentId word文件名
     * @param configFile 配置文件
     * @return 新的文件名
     */
    public static File createNewConfigFilePath(String docType, String documentId, File configFile) {
        String path = MessageFormat.format(DOC_CONFIG_FILE_PATH_STYLE, configFile.getParent(),
            StringUtils.lowerCase(docType), documentId);
        return new File(path.toString());
    }
    
    /**
     * 获得配置文件存储路径
     *
     * @param uri uri
     * @return 配置文件存储路径 相对于标准目录
     */
    public static String getDocConfigFilePath(URI uri) {
        String path = uri.getPath();
        int index = path.indexOf("/docconfig/");
        return path.substring(index);
    }
    
    /**
     * 获得配置文件存储路径
     *
     * @param file 配置文件
     * @return 配置文件存储路径 相对于标准目录
     */
    public static String getDocConfigFilePath(File file) {
        String path = file.toURI().getPath();
        int index = path.indexOf("/docconfig/");
        return path.substring(index);
    }
    
    /**
     * 获得配置文件存储路径
     *
     * @param rootDir 根路径
     * @return 配置文件存储路径 相对于标准目录
     */
    public static String getDocConfigFileDir(File rootDir) {
        return MessageFormat.format(DOC_CONFIG_FILE_DIR_STYLE, rootDir.getAbsolutePath());
    }
    
    /**
     * 获得时间字符串
     * 
     * @param formatString 格式化字符串
     *
     * @return 时间字符串
     */
    public static String getTimestampString(String formatString) {
        return new SimpleDateFormat(formatString).format(new Date(System.currentTimeMillis()));
    }
    
    /**
     * 获得时间字符串
     *
     * @return 时间字符串
     */
    public static String getTimestampString() {
        return new SimpleDateFormat(Format_STR_YYYYMMDDHHMMSSSS).format(new Date(System.currentTimeMillis()));
    }
}
