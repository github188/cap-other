/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.listener;

import org.apache.ftpserver.FtpServer;
import org.apache.ftpserver.ftplet.FtpException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.ContextStoppedEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

/**
 * 应用监听
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年8月18日 lizhongwen
 */
@Component
public class ApplicationListener {
    
    /** 日志 */
    private static final Logger logger = LoggerFactory.getLogger(ApplicationListener.class);
    
    /** FTP服务器 */
    @Autowired
    private FtpServer ftpServer;
    
    /**
     * @param event 应用启动完毕事件
     */
    @EventListener
    public void handleContextStartedEvent(ApplicationReadyEvent event) {
        try {
            ftpServer.start();
        } catch (FtpException e) {
            logger.error("FTP服务器启动失败。", e);
        }
    }
    
    /**
     * @param event 上下文关闭事件
     */
    @EventListener
    public void handleContextStoppedEvent(ContextStoppedEvent event) {
        ftpServer.stop();
    }
}
