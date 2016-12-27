/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.database.analyze;

import java.util.HashMap;
import java.util.Map;

/**
 * 比较Context
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年11月21日 许畅 新建
 */
public class CompareContext {

	/** 源对象 */
	private final static String SOURCE = "SRC";

	/** 目标对象 */
	private final static String TARGET = "TARGET";

	/** 其他参数 */
	private final static String PARAM = "PARAM";

	/** 比较上下文 */
	private final Map<String, Object> context = new HashMap<String, Object>();

	/**
	 * 构造方法
	 * 
	 * @param src
	 *            源对象
	 * @param target
	 *            目标对象
	 */
	public CompareContext(Compareable src, Compareable target) {
		context.put(SOURCE, src);
		context.put(TARGET, target);
	}

	/**
	 * 构造方法
	 * 
	 * @param src
	 *            源对象
	 * @param target
	 *            目标对象
	 * @param param
	 *            参数
	 */
	public CompareContext(Compareable src, Compareable target,
			Map<String, Object> param) {
		context.put(SOURCE, src);
		context.put(TARGET, target);
		context.put(PARAM, param);
	}

	/**
	 * @return 获取源对象
	 */
	public Compareable getSourceObject() {
		return (Compareable) context.get(SOURCE);
	}

	/**
	 * @return 获取目标对象
	 */
	public Compareable getTargetObject() {
		return (Compareable) context.get(TARGET);
	}

	/**
	 * @return 获取参数
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getParam() {
		if (context.containsKey(PARAM))
			return (Map<String, Object>) context.get(PARAM);

		return new HashMap<String, Object>();
	}

	/**
	 * @return the context
	 */
	public Map<String, Object> getContext() {
		return context;
	}

}
