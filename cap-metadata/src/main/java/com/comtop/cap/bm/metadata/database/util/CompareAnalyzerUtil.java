/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.database.util;

import java.text.MessageFormat;

/**
 * 比较分析工具类
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年11月21日 许畅 新建
 */
public final class CompareAnalyzerUtil {

	/**
	 * 构造方法
	 */
	private CompareAnalyzerUtil() {

	}

	/**
	 * 解析表达式
	 * 
	 * @param expression
	 *            表达式
	 * @param params
	 *            参数
	 * @return str
	 */
	public static String parsingExpression(String expression, Object... params) {
		return MessageFormat.format(expression, params);
	}

}
