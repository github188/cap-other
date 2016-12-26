/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.component.loader.config;

import java.util.Properties;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.component.loader.LoaderHelper;

/**
 * loader config factory 用于构建不同config
 * 
 * @author yangsai
 */
public class LoaderConfigFactory {
	
	/**单例对象**/
	private static LoaderConfigFactory factory = new LoaderConfigFactory();
	
	/**ftp配置读取类**/
	private IFtpConfigReader configReader;
	
	/**
	 * @param reader ftp配置读取类
	 * 
	 * **/
	public static void setFtpConfigReader(IFtpConfigReader reader){
		factory.configReader = reader;
	}
	
	/**
	 * 私有构造函数
	 */
	private LoaderConfigFactory(){ 
		
	}
    
    /**
     * 获取classpath中upload.properties文件内容并构建成config对象
     * 
     * @return loaderConfig
     */
    public static LoaderConfig createConfigFromProperties() {
        Properties prop  = getFtpConfigReader().readFtpConfig();
        String fileStoreType = (String) prop.get(IFtpConfigReader.FTP_UPLOAD_FILE_STORE_TYPE);
        if (StringUtils.isBlank(fileStoreType)) {
                fileStoreType = "http";
        }
        if ("http".equals(fileStoreType)) {
        	return getHttpLoadConfig(prop);
        }
        return getFtpLoadConfig(prop);
    }
    
    /**
     * 
     * @return ftp配置读取类
     */
    private static IFtpConfigReader getFtpConfigReader(){
    	if(factory .configReader == null){
    		factory .configReader = new PropertyReader();
    	}
    	return factory .configReader;
    }
    
    /**
     * 获得ftp配置
     *
     * @param prop 属性集
     * @return ftpconfig
     */
    private static LoaderConfig getFtpLoadConfig(Properties prop) {
        String host = (String) prop.get(IFtpConfigReader.FTP_INFO_HOST);
        String username = (String) prop.get(IFtpConfigReader.FTP_INFO_USERNAME);
        String password = (String) prop.get(IFtpConfigReader.FTP_INFO_PASSWORD);
        int port = Integer.parseInt((String) prop.get(IFtpConfigReader.FTP_INFO_PORT));
        String encoding = (String) prop.get(IFtpConfigReader.FTP_INFO_ENCODING);
        String mainDirectory = (String) prop.get(IFtpConfigReader.FTP_INFO_BASEPATH);
        String visitUrl = (String) prop.get(IFtpConfigReader.FTP_FILE_VISIT_URL);
        LoaderConfig config = new LoaderConfig(host, username, password, port, encoding, mainDirectory);
        config.setVisitUrl(visitUrl);
        return config;
    }
    
    /**
     * 获得http配置
     *
     * @param prop 属性集
     * @return httpconfig
     */
    private static LoaderConfig getHttpLoadConfig(Properties prop) {
        String basePath = (String) prop.get(IFtpConfigReader.FTP_HTTP_BASEPATH);
        String visitUrl = (String) prop.get(IFtpConfigReader.FTP_FILE_VISIT_URL);
        if (StringUtils.isBlank(basePath)) {
            basePath = "/uploadedFile";
        }
        basePath = LoaderHelper.replacePathSeparator(basePath);
        // 要是结尾有/那么就去掉/
        if (basePath.endsWith(LoaderHelper.separator)) {
            basePath = basePath.substring(0, basePath.length() - 1);
        }
        LoaderConfig config = new LoaderConfig(basePath);
        config.setVisitUrl(visitUrl);
        return config;
    }
}
