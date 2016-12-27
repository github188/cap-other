/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.database.execute;

/**
 * 增量SQL构建器
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年11月2日 许畅 新建
 */
public class IncrementSQLBuilder implements IBuilder {

	/** SQL内容 */
	private final StringBuffer sql;

	/**
	 * 构造方法
	 */
	public IncrementSQLBuilder() {
		sql = new StringBuffer();
	}

	/**
	 * 构建SQL
	 * 
	 * @param str
	 *            SQL内容
	 * @return SQL
	 */
	@Override
	public StringBuffer append(String str) {
		return sql.append(str);
	}

	/**
	 * 获取SQL内容
	 * 
	 * @return this String sql
	 */
	@Override
	public String getSql() {
		return sql.toString();
	}

	/**
	 * 构建SQL
	 * 
	 * @param sb
	 *            StringBuffer
	 * @return sb
	 */
	@Override
	public StringBuffer append(StringBuffer sb) {
		return sql.append(sb + "/n");
	}
}
