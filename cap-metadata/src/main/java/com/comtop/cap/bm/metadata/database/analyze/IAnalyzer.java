/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.database.analyze;

import com.comtop.cap.bm.metadata.database.datasource.CompareState;
import com.comtop.cap.bm.metadata.database.model.CompareVO;

/**
 * 对象比较深入分析器
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年11月18日 许畅 新建
 */
public interface IAnalyzer {

	/**
	 * 将两个对象进行深入分析比较差异
	 * <p>
	 * 分析结果
	 * </p>
	 * 
	 * @return 进行深入分析
	 */
	public CompareVO deepAnalyze();

	/**
	 * 分析新增
	 * 
	 * @return 差异结果集
	 */
	public CompareVO analyzeAddNew();

	/**
	 * 获取详细分析信息
	 * 
	 * @param state
	 *            比较状态
	 * 
	 * @return 详细分析信息
	 */
	public String forDetails(CompareState state);

	/**
	 * 比较前校验
	 * 
	 * @return 比较前校验
	 */
	public boolean validateCompare();

}
