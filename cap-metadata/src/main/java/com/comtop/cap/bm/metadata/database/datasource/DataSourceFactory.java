/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.database.datasource;

import java.util.List;

import com.comtop.cap.bm.metadata.database.dbobject.model.TableCompareResult;

/**
 * 数据源工厂
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年11月2日 许畅 新建
 */
public final class DataSourceFactory {

	/**
	 * 构造方法
	 */
	private DataSourceFactory() {

	}

	/**
	 * 获取比较结果集数据源
	 * 
	 * @param tableCompareResults
	 *            表比较结果集
	 * @return CompareDataProvider
	 */
	public static ICompareDataSource getDataProvider(
			List<TableCompareResult> tableCompareResults) {
		return new CompareDataProvider(tableCompareResults);
	}

}
