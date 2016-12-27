/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.util;

import java.util.List;

import com.comtop.cap.bm.metadata.entity.model.DataTypeVO;

/**
 * 实体操作工具类
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年5月26日 许畅 新建
 */
public class EntityOperateUtil {

	/**
	 * 构造方法
	 */
	private EntityOperateUtil() {

	}

	/**
	 * 根据数据类型返回生成代码的实际返回值
	 * 
	 *  <a value="void">void</a>
	 *	<a value="int">int</a>
	 *	<a value="float">float</a>
	 *	<a value="double">double</a>
	 *	<a value="boolean">boolean</a>
	 *	<a value="String">String</a>
	 *	<a value="java.lang.Object">Object</a>
	 *	<a value="java.util.List">java.util.List</a>
	 *	<a value="java.util.Map">java.util.Map</a>
	 *	<a value="java.sql.Timestamp">java.sql.Timestamp</a>
	 *	<a value="entity">Entity</a>
	 *	<a value="thirdPartyType">第三方类型</a>
	 * 
	 * @param returnType
	 *            返回值类型
	 * @return 生成代码的实际返回值 
	 */
	public static String convertToReturnVal(DataTypeVO returnType) {
		List<String> list = returnType.readImportDateType();
		// 无返回值 void
		if (list.size() == 0) {
			return null;
		}

		// 不存在泛型和泛型类型形如:java.lang.String等
		if (list.size() > 0) {
			return returnType.readDataTypeFullName();
		}
		return null;
	}

}
