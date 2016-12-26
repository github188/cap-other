/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.tech.test;

import java.text.SimpleDateFormat;
import java.util.Date;

import javax.xml.bind.annotation.adapters.XmlAdapter;

/**
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年11月23日 许畅 新建
 */
public class DateAdapter extends XmlAdapter<String, Date> {

	/**
	 * 
	 */
	private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

	/**
	 *
	 * @param v
	 *            xx
	 * @return xx
	 * @throws Exception
	 *             xx
	 *
	 * @see javax.xml.bind.annotation.adapters.XmlAdapter#unmarshal(java.lang.Object)
	 */
	@Override
	public Date unmarshal(String v) throws Exception {
		return sdf.parse(v);
	}

	/**
	 *
	 * @param v
	 *            xx
	 * @return xx
	 * @throws Exception
	 *             xx
	 *
	 * @see javax.xml.bind.annotation.adapters.XmlAdapter#marshal(java.lang.Object)
	 */
	@Override
	public String marshal(Date v) throws Exception {
		return sdf.format(v);
	}

}
