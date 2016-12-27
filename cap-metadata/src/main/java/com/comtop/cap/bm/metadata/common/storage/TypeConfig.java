/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.common.storage;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * 模型类型配置
 *
 * @author 郑重
 * @version jdk1.5
 * @version 2015-4-28 郑重
 */
@XmlRootElement
public class TypeConfig {

	/**
	 * 模型类型名称
	 */
	private String typeName;

	/**
	 * 模型类
	 */
	@SuppressWarnings("rawtypes")
	private Class type;

	/**
	 * 模型存储文件类型名
	 */
	private String fileType;

	/**
	 * 构造函数
	 */
	public TypeConfig() {

	}

	/**
	 * 构造函数
	 * @param typeName 类型名
	 * @param type 类型
	 * @param fileType 文件类型
	 */
	@SuppressWarnings("rawtypes")
	public TypeConfig(String typeName, Class type, String fileType) {
		this.typeName = typeName;
		this.type = type;
		this.fileType = fileType;
	}

	/**
	 * @return the typeName
	 */
	public String getTypeName() {
		return typeName;
	}

	/**
	 * @param typeName the typeName to set
	 */
	public void setTypeName(String typeName) {
		this.typeName = typeName;
	}

	/**
	 * @return the type
	 */
	@SuppressWarnings("rawtypes")
	public Class getType() {
		return type;
	}

	/**
	 * @param type the type to set
	 */
	@SuppressWarnings("rawtypes")
	public void setType(Class type) {
		this.type = type;
	}

	/**
	 * @return the fileType
	 */
	public String getFileType() {
		return fileType;
	}

	/**
	 * @param fileType the fileType to set
	 */
	public void setFileType(String fileType) {
		this.fileType = fileType;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return "TypeConfig [typeName=" + typeName + ", type=" + type + ", fileType=" + fileType + "]";
	}
}
