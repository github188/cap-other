/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.database.analyze;

import java.util.Map;

import com.comtop.cap.bm.metadata.entity.model.EntityVO;

/**
 * 比较分析工厂类
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年11月21日 许畅 新建
 */
public class CompareAnalyzerFactory {

	/**
	 * 构造方法
	 */
	private CompareAnalyzerFactory() {

	}

	/**
	 * 获取CompareAnalyzer
	 * 
	 * @param src
	 *            源对象
	 * @param param
	 *            参数对象
	 * @return IAnalyzer
	 */
	public static IAnalyzer getCompareAnalyzer(Compareable src,
			Map<String, Object> param) {
		CompareContext context = new CompareContext(src, new EntityVO(), param);
		return new CompareAnalyzer(context);
	}
}
