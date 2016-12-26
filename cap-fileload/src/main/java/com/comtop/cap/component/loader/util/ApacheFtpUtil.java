/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.component.loader.util;

import java.io.IOException;
import java.net.SocketException;

import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.component.loader.config.LoaderConfig;
import com.comtop.cap.component.loader.exception.LoadException;

/**
 * ftp工具类
 * @author lixiaoqiang
 *
 */
public class ApacheFtpUtil {
    /**
     * log
     */
    private final static Logger LOG = LoggerFactory.getLogger(ApacheFtpUtil.class);
    /**
     * 打开一个服务器连接,用来进行上传和下载.<br>
     * 主要用于批量上传和下载
     * @param config loader的相关配置信息
     * @return  FTPClient
     */
    public static FTPClient openFtpClient(LoaderConfig config) {
        if (config == null) {
            RuntimeException e = new LoadException("找不到相关ftp连接配置参数,无法连接到ftp服务器！");
            LOG.error(e.getMessage(), e);
            throw e;
        }
        FTPClient ftpClient = new FTPClient();
        // 设置对中文文件名上传下载的支持
        ftpClient.setControlEncoding(config.getEncoding());
        try {
            // 连接远程ftp服务器
            if (config.getPort() == -1) {
                ftpClient.connect(config.getHost());
            } else {
                ftpClient.connect(config.getHost(), config.getPort());
            }
            // 登录
            if (!ftpClient.login(config.getUsername(), config.getPassword())) {
                RuntimeException e = new LoadException("ftp服务器登录失败，请检查连接的用户名和密码！");
                LOG.error(e.getMessage(), e);
                throw e;
            }
            ftpClient.setFileType(FTP.BINARY_FILE_TYPE);
            ftpClient.changeWorkingDirectory(config.getMainDirectory());
           return ftpClient;
        } catch (SocketException e) {
            RuntimeException loadException = new LoadException("ftp服务器连接失败，请检查连接配置。 " +getFtpConfig(config), e);
            LOG.error(loadException.getMessage(), loadException);
            throw loadException;
        } catch (IOException e) {
            RuntimeException loadException = new LoadException("ftp服务器连接失败，请检查连接配置。" + getFtpConfig(config), e);
            LOG.error(loadException.getMessage(), loadException);
            throw loadException;
        }
    }
    
    /**
     * 将保存的服务器连接关闭掉
     * @param ftpClient 要关闭
     */
    public static void closeServer(FTPClient ftpClient) {
        if (ftpClient.isConnected()) {
            try {
                ftpClient.disconnect();
            } catch (IOException e) {
            	LOG.error("ftp关闭失败",e);
            }
        }
    }
    
    /**
     * 获取config中ftp的信息
     * 
     * @param loaderConfig
     *            配置
     * @return ftp的配置信息
     */
    private static String getFtpConfig(LoaderConfig loaderConfig) {
        return "host:" + loaderConfig.getHost() + " username:" + loaderConfig.getUsername() + " password:"
            + loaderConfig.getPassword() + " port:" + loaderConfig.getPort();
    }
}
