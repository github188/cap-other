/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.component.loader.config;

import java.io.IOException;
import java.util.Properties;

/**
 * 
 * 从Property文件中读取配置
 * @author luozhenming 
 *
 */
public class PropertyReader implements IFtpConfigReader {
	@Override
	public Properties readFtpConfig() {
		Properties prop = new Properties();
	    try {
			prop.load(PropertyReader.class.getClassLoader().getResourceAsStream("fileload.properties"));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return prop;
	}
}