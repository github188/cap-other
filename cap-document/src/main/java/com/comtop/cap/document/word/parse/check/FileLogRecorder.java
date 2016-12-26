/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.parse.check;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 文件日志记录器
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月27日 lizhiyong
 */
public class FileLogRecorder implements ILogRecorder {
    
    /** 输出的日志文件 */
    private File outPutFile;
    
    /** 文件输出流 */
    private FileOutputStream fileOutputStream;
    
    /** 日志对象 */
    private final Logger logger = LoggerFactory.getLogger(getClass());
    
    /** 日期格式化器 */
    private SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH-mm-ss-sss");
    
    /**
     * 构造函数
     * 
     * @param logFile 日志文件
     */
    public FileLogRecorder(File logFile) {
        this.outPutFile = logFile;
        try {
            if (!this.outPutFile.getParentFile().exists()) {
                this.outPutFile.getParentFile().mkdirs();
            }
            if (!this.outPutFile.exists()) {
                this.outPutFile.createNewFile();
            }
            fileOutputStream = new FileOutputStream(outPutFile, true);
            logger.info("word操作日志文件路径：" + outPutFile.getAbsolutePath());
        } catch (FileNotFoundException e) {
            logger.error("创建日志文件对象输出流时发生异常", e);
        } catch (IOException e) {
            logger.error("创建校验日志文件发生异常。当前文件路径：" + logFile.getAbsolutePath(), e);
        }
    }
    
    @Override
    protected void finalize() throws Throwable {
        IOUtils.closeQuietly(fileOutputStream);
    }
    
    /**
     * 
     * @see com.comtop.cap.document.word.parse.check.ILogRecorder#output(java.lang.Object)
     */
    @Override
    public void output(Object logMessage) {
        try {
            StringBuffer message = new StringBuffer();
            message.append(getTimestampString()).append(":").append(logMessage).append("\r\n");
            fileOutputStream.write(message.toString().getBytes());
        } catch (IOException e) {
            logger.error("创建日志文件对象输出流时发生异常", e);
        }
    }
    
    /**
     * 获得当前的时间戳字符串
     *
     * @return 时间字符串
     */
    private String getTimestampString() {
        return dateFormat.format(new Date(System.currentTimeMillis()));
    }
    
    /**
     * @return 获取 outPutFile属性值
     */
    public File getOutPutFile() {
        return outPutFile;
    }
    
}
