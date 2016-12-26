/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.actuator;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.event.Level;
import org.springframework.util.StringUtils;

/**
 * 结果处理器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年8月19日 lizhongwen
 */
public class ResultHandler implements Runnable {
    
    /** 日志 */
    private static final Logger logger = LoggerFactory.getLogger(ResultHandler.class);
    
    /** 默认控制台编码 */
    private static final String SHELL_CHARSET = "GBK";
    
    /** 结果记录编码 */
    // private static final String RET_CHARSET = "UTF-8";
    
    /** 结果输入流 */
    private InputStream input;
    
    /** 日志级别 */
    private Level level;
    
    /**
     * 开始记录日志
     */
    public void start() {
        Thread thread = new Thread(this);
        thread.setDaemon(true);
        thread.start();
    }
    
    /**
     * 构造函数
     * 
     * @param input input
     * @param level 日志级别
     */
    public ResultHandler(InputStream input, Level level) {
        super();
        this.input = input;
        this.level = level;
    }
    
    /**
     * 
     * @see java.lang.Runnable#run()
     */
    @Override
    public void run() {
        BufferedReader reader = null;
        try {
            reader = new BufferedReader(new InputStreamReader(input, SHELL_CHARSET));
            String line = null;
            while ((line = reader.readLine()) != null) {
                if (StringUtils.hasText(line)) {
                    // String msg = new String(line.getBytes(), RET_CHARSET);
                    switch (level) {
                        case INFO:
                            logger.info(line);
                            break;
                        case ERROR:
                            logger.error(line);
                            break;
                        case WARN:
                            logger.warn(line);
                            break;
                        case DEBUG:
                            logger.debug(line);
                            break;
                        case TRACE:
                            logger.trace(line);
                            break;
                        default:
                            logger.info(line);
                            break;
                    }
                    
                }
            }
        } catch (Exception e) {
            logger.info("读取结果失败！", e);
        } finally {
            IOUtils.closeQuietly(reader);
        }
    }
    
}
