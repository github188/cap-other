/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.common.storage;

import java.io.File;

/**
 * 模型持久化操作对象创建工厂
 *
 * @author 郑重
 * @version jdk1.5
 * @version 2015-4-28 郑重
 */
public class FileOperatorFactory {

	/**
	 * 文件操作
	 */
	private final static IFileOperator jsonOperator = new JsonOperator();

	/**
	 * 文件操作
	 */
	private final static IFileOperator xmlOperator = new XmlOperator();

	/**
	 * 私有构造
	 */
	private FileOperatorFactory() {

	}

	/**
	 * 根据文件名获取扩展名
	 * @param file 文件
	 * @return 模型类型
	 */
	private static String getExtName(File file) {
		String strFileName = file.getName();
		return strFileName.split("\\.")[2];
	}

	/**
	 * 根据文件名获取文件操作对象
	 * @param file 文件
	 * @return 文件操作对象
	 */
	public static IFileOperator getFileOperator(final File file) {
		IFileOperator objResult = null;
		String strExtName = getExtName(file);
		if ("xml".equals(strExtName)) {
			objResult = xmlOperator;
		} else if ("json".equals(strExtName)) {
			objResult = jsonOperator;
		}
		return objResult;
	}

	/**
	 * 根据对象存储类型获取文件操作对象
	 * @param fileType 文件类型
	 * @return 文件操作对象
	 */
	public static IFileOperator getFileOperator(String fileType) {
		IFileOperator objResult = null;
		if ("xml".equals(fileType)) {
			objResult = xmlOperator;
		} else if ("json".equals(fileType)) {
			objResult = jsonOperator;
		}
		return objResult;
	}

}
