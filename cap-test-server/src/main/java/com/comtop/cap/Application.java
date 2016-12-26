/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap;

import java.net.InetAddress;
import java.net.UnknownHostException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.Banner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.support.SpringBootServletInitializer;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.core.env.Environment;

/**
 * SpringBoot启动入口
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年8月18日 lizhongwen
 */
@SpringBootApplication
@ComponentScan
public class Application extends SpringBootServletInitializer {
    
    /** 日志 */
    private static final Logger log = LoggerFactory.getLogger(Application.class);
    
    /**
     * @param args 启动入口
     */
    public static void main(String[] args) {
        SpringApplication app = new SpringApplication(Application.class);
        app.setBannerMode(Banner.Mode.OFF);
        Environment env = app.run(args).getEnvironment();
        InetAddress address = null;
        try {
            address = InetAddress.getLocalHost();
        } catch (UnknownHostException e) {
            log.error("获取服务器地址失败.", e);
        }
        log.info("服务器地址:\n----------------------------------------------------------\n\t"
            + "本地: \thttp://127.0.0.1:{}\n\t"
            + "外部: \thttp://{}:{}\n----------------------------------------------------------",
            env.getProperty("server.port"), address == null ? "127.0.0.1" : address.getHostAddress(),
            env.getProperty("server.port"));
    }
    
    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(Application.class);
    }
}
