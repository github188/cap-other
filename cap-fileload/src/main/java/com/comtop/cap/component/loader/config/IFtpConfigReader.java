/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.component.loader.config;

import java.util.Properties;


/**
 * 读取FTP相关配置,比如 ip, userName, password等
 * @author sai.yang
 *
 */
public interface IFtpConfigReader {
	
	/***/
	String FTP_DEFAULT_VALUE_PORT = "2121";
	
	/***/
	String FTP_DEFAULT_VALUE_ENCODING = "UTF-8";
	
	/***/
	String FTP_DEFAULT_FILE_UPLOAD_TYPE = "ftp";
	
	/***/
	String FTP_DEFAULT_VALUE_FTP_BASEPATH = "/";
	
	/***/
	String FTP_DEFAULT_VALUE_HTTP_BASEPATH = "/http/uplod";
		
	/***/
	String FTP_UPLOAD_FILE_STORE_TYPE="upload.fileStoreType";
	
	/***/
	String FTP_INFO_HOST="ftp.host";
	
	/***/
	String FTP_INFO_USERNAME="ftp.username";
	
	/***/
	String FTP_INFO_PASSWORD="ftp.password";
	
	/***/
	String FTP_INFO_PORT="ftp.port";
	
	/***/
	String FTP_INFO_ENCODING="ftp.encoding";
	
	/***/
	String FTP_INFO_BASEPATH="ftp.basepath";
	
	/***/
	String FTP_FILE_VISIT_URL="visitUrl";
	
	/***/
	String FTP_HTTP_BASEPATH="http.basepath";
	
	/**
	 * 读取Ftp服务的配置信息
	 * @return Properties
	 */
	Properties readFtpConfig();
}
