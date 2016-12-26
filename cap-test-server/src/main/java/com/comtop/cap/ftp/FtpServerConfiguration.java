/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.ftp;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.apache.ftpserver.FtpServer;
import org.apache.ftpserver.FtpServerFactory;
import org.apache.ftpserver.ftplet.Authority;
import org.apache.ftpserver.ftplet.FtpException;
import org.apache.ftpserver.ftplet.UserManager;
import org.apache.ftpserver.listener.ListenerFactory;
import org.apache.ftpserver.usermanager.PropertiesUserManagerFactory;
import org.apache.ftpserver.usermanager.impl.BaseUser;
import org.apache.ftpserver.usermanager.impl.WritePermission;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * FTP服务器配置
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年8月18日 lizhongwen
 */
@Configuration
@EnableAutoConfiguration
public class FtpServerConfiguration {
    
    /** 服务器端口 */
    @Value("${ftp.port}")
    private int port;
    
    /** 服务器用户名 */
    @Value("${ftp.username}")
    private String username;
    
    /** 服务器密码 */
    @Value("${ftp.password}")
    private String password;
    
    /** 服务器根目录 */
    @Value("${ftp.home}")
    private String home;
    
    /**
     * @return 服务器
     * @throws FtpException Ftp异常
     */
    @Bean
    public FtpServer ftpServer() throws FtpException {
        File ftpHome = new File(home);
        if (!ftpHome.exists()) {
            ftpHome.mkdirs();
        }
        FtpServerFactory serverFactory = new FtpServerFactory();
        ListenerFactory factory = new ListenerFactory();
        // set the port of the listener
        factory.setPort(port);
        // replace the default listener
        serverFactory.addListener("default", factory.createListener());
        PropertiesUserManagerFactory userManagerFactory = new PropertiesUserManagerFactory();
        // Create a test user.
        UserManager um = userManagerFactory.createUserManager();
        BaseUser user = new BaseUser();
        user.setName(username);
        user.setPassword(password);
        List<Authority> authorities = new ArrayList<Authority>();
        authorities.add(new WritePermission());
        user.setAuthorities(authorities);
        user.setHomeDirectory(ftpHome.getAbsolutePath());
        um.save(user);
        serverFactory.setUserManager(um);
        // create the server
        FtpServer server = serverFactory.createServer();
        return server;
    }
    
}
