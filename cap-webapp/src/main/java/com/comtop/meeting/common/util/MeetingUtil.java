/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.meeting.common.util;

import java.beans.BeanInfo;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.lang.reflect.Method;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import comtop.soa.org.apache.cxf.common.util.StringUtils;

/**
 * 会议管理工具类
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年1月21日下午2:39:55 许畅 新建
 */
public class MeetingUtil {

	/**
	 * 将字符串转换为sql date类型
	 * 
	 * @param dateStr
	 *            date字符串
	 * @return sql Date
	 */
	public static Timestamp strConvertoSqlDate(String dateStr) {
		if (StringUtils.isEmpty(dateStr))
			return null;

		Timestamp date = null;

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		try {
			date = new Timestamp(sdf.parse(dateStr).getTime());

		} catch (ParseException e) {
			e.printStackTrace();
		}

		return date;
	}

	/**
	 * 日期转换为字符串
	 * 
	 * @param date
	 *            Sql Date
	 * @return string
	 */
	public static String sqlDateConvertoStr(Timestamp date) {
		if (date == null)
			return null;

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		return sdf.format(date);
	}

	/**
	 * 根据小时转换时间
	 * 
	 * @param date
	 *            date
	 * @param hour
	 *            h
	 * @return time
	 */
	public static Timestamp toTimestampByHour(Date date, int hour) {
		String h = Integer.toString(hour);
		if (h.length() == 1)
			h = "0" + h;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String now = sdf.format(date);
		String endDate = now + " " + h + ":00:00";

		SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Timestamp timpestamp = null;
		try {
			timpestamp = new Timestamp(sdf2.parse(endDate).getTime());

		} catch (ParseException e) {

			e.printStackTrace();
		}

		return timpestamp;
	}

	/**
	 * 将map转为bean
	 * 
	 * @param bean
	 *            bean
	 * @return map
	 * @throws Exception
	 *             ex
	 */
	public static Map beanConvertToMap(Object bean) throws Exception {
		Class type = bean.getClass();
		Map returnMap = new HashMap();
		BeanInfo beanInfo = Introspector.getBeanInfo(type);

		PropertyDescriptor[] propertyDescriptors = beanInfo
				.getPropertyDescriptors();
		for (int i = 0; i < propertyDescriptors.length; i++) {
			PropertyDescriptor descriptor = propertyDescriptors[i];
			String propertyName = descriptor.getName();
			if (!propertyName.equals("class")) {
				Method readMethod = descriptor.getReadMethod();
				Object result = readMethod.invoke(bean, new Object[0]);
				if (result != null) {
					returnMap.put(propertyName, result);
				} else {
					returnMap.put(propertyName, "");
				}
			}
		}
		return returnMap;
	}

	/**
	 * @param type
	 *            bean
	 * @param map
	 *            map
	 * @return bean
	 * @throws Exception
	 *             ext
	 */
	public static Object mapConvertToBean(Class type, Map map) throws Exception {
		BeanInfo beanInfo = Introspector.getBeanInfo(type); // 获取类属性
		Object obj = type.newInstance(); // 创建 JavaBean 对象

		// 给 JavaBean 对象的属性赋值
		PropertyDescriptor[] propertyDescriptors = beanInfo
				.getPropertyDescriptors();
		for (int i = 0; i < propertyDescriptors.length; i++) {
			PropertyDescriptor descriptor = propertyDescriptors[i];
			String propertyName = descriptor.getName();

			if (map.containsKey(propertyName)) {
				// 下面一句可以 try 起来，这样当一个属性赋值失败的时候就不会影响其他属性赋值。
				Object value = map.get(propertyName);

				Object[] args = new Object[1];
				args[0] = value;

				descriptor.getWriteMethod().invoke(obj, args);
			}
		}
		return obj;
	}

}
