/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.pdm.convert;

/**
 * 数据类型转换器接口
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年11月17日 许畅 新建
 */
public interface IDataTypeConverter {

	/**
	 * pdm数据库类型转换为元数据类型
	 * 
	 * @param pdmDataType
	 *            pdm数据类型
	 * @return 转换为元数据类型
	 */
	public String convertToMetaDataType(String pdmDataType);

	/**
	 * 转换为数据库对象的数据类型长度
	 * 
	 * @param pdmDataType
	 *            pdm数据类型
	 * @return 数据类型长度
	 */
	public Integer convertToMetaLength(String pdmDataType);

	/**
	 * 转换为数据库对象的数据类型精度
	 * 
	 * @param pdmDataType
	 *            pdm数据类型
	 * @return 数据类型精度
	 */
	public Integer convertToMetaPrecision(String pdmDataType);

}
