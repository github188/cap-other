/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.tech.test;

import java.io.File;

/**
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年12月26日 许畅 新建
 */
public class FileTest {

	/**
	 * @param args
	 *            xx
	 */
	public static void main(String[] args) {
		//
		File file = new File("D:\\temp\\atm.js");
		// JsonOperator operator = new JsonOperator();
		System.out.println(file.getAbsolutePath());

	}

}
