/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.database.datasource;

import java.util.List;
import java.util.Map;

/**
 * 数据库表比较数据源接口
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年11月1日 许畅 新建
 */
public interface ICompareDataSource {

	/**
	 * 初始化列数据集
	 * 
	 * @return 数据集
	 */
	List<Map<String, Object>> initColumn();

	/**
	 * 初始化索引数据集
	 * 
	 * @return 数据集
	 */
	List<Map<String, Object>> initIndex();

	/**
	 * 初始化所有数据
	 * 
	 * @return 数据集
	 */
	List<Map<String, Object>> initAll();

}
