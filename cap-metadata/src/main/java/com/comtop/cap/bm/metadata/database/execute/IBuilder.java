/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.database.execute;

/**
 * 构建接口
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年11月2日 许畅 新建
 */
public interface IBuilder {

	/**
	 * 追加字符串
	 * 
	 * @param str
	 *            字符串
	 * @return sb
	 */
	public StringBuffer append(String str);

	/**
	 * 追加StringBuffer
	 * 
	 * @param sb
	 *            StringBuffer
	 * @return StringBuffer
	 */
	public StringBuffer append(StringBuffer sb);

	/**
	 * 获取SQL内容
	 * 
	 * @return sql
	 */
	public String getSql();

}
