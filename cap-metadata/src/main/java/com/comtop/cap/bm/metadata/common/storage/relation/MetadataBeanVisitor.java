/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.storage.relation;

import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.Id;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cip.jodd.bean.BeanUtil;
import com.comtop.cip.jodd.bean.BeanVisitor;
import com.comtop.cip.jodd.introspector.ClassDescriptor;
import com.comtop.cip.jodd.introspector.ClassIntrospector;
import com.comtop.cip.jodd.introspector.FieldDescriptor;
import com.comtop.cip.jodd.introspector.MethodDescriptor;
import com.comtop.cip.jodd.introspector.PropertyDescriptor;

/**
 * 元数据访问器
 *
 * @author  郑重
 * @since   jdk1.6
 * @version 2015年8月7日 郑重
 */
public class MetadataBeanVisitor extends BeanVisitor {
	
	/** 日志 */
    private final static Logger LOG = LoggerFactory.getLogger(MetadataBeanVisitor.class);
	
	/**基本类型**/
	private static final List<Class> baseDataTypeList = new ArrayList<Class>(10);
	
	static{
		baseDataTypeList.add(String.class);
		baseDataTypeList.add(Integer.class);
		baseDataTypeList.add(Byte.class);
		baseDataTypeList.add(Long.class);
		baseDataTypeList.add(Double.class);
		baseDataTypeList.add(Float.class);
		baseDataTypeList.add(Character.class);
		baseDataTypeList.add(Short.class);
		baseDataTypeList.add(BigDecimal.class);
		baseDataTypeList.add(BigInteger.class);
		baseDataTypeList.add(Boolean.class);
	}
	
	/**
	 * 判断是否对象类型
	 * @param value value
	 * @return boolean
	 */
	protected boolean isObjectType(Object value) {
		if (value != null) {
			if (isBaseDataType(value.getClass())) {
				return false;
			}
			return true;
		}
		return false;
	}

	/**
	 * 两个对象是否相对
	 * @param curdescValue descValue
	 * @param cursrcValue srcValue
	 * @return boolean
	 */
	protected boolean isEquals(Object curdescValue, Object cursrcValue) {
		boolean bResult = false;
		Field[] fields = curdescValue.getClass().getDeclaredFields();
		String strPKField = null;
		for (Field field : fields) {
			if (field.getAnnotation(Id.class) != null) {
				strPKField = field.getName();
			}
		}
		if (strPKField != null) {
			Object objDescPKValue = BeanUtil.getDeclaredProperty(curdescValue, strPKField);
			Object objSrcPKValue = BeanUtil.getDeclaredProperty(cursrcValue, strPKField);
			if (objDescPKValue != null && objSrcPKValue != null && objDescPKValue.equals(objSrcPKValue)) {
				bResult = true;
			}
		}
		return bResult;
	}

	/**
	 * 返回对象所有属性
	 * @param type type
	 * @param isDeclared declared
	 * @return String[]
	 */
	@SuppressWarnings("rawtypes")
	protected String[] getAllBeanPropertyNames(Class type, boolean isDeclared) {
		ClassDescriptor classDescriptor = ClassIntrospector.lookup(type);
		PropertyDescriptor[] propertyDescriptors = classDescriptor.getAllPropertyDescriptors();
		ArrayList<String> names = new ArrayList<String>(propertyDescriptors.length);
		for (PropertyDescriptor propertyDescriptor : propertyDescriptors) {
			MethodDescriptor getter = propertyDescriptor.getReadMethodDescriptor();
			if (getter != null) {
				if (getter.matchDeclared(isDeclared)) {
					names.add(propertyDescriptor.getName());
				}
			} else {
				FieldDescriptor field = propertyDescriptor.getFieldDescriptor();
				if (field != null) {
					if (field.matchDeclared(isDeclared)) {
						names.add(field.getField().getName());
					}
				}
			}
		}
		return names.toArray(new String[names.size()]);
	}

	/**
	 * 返回属性定义
	 * @param srcClass 类
	 * @param name srcValue
	 * @return Field
	 */
	@SuppressWarnings("rawtypes")
	protected static Field getField(Class srcClass, String name) {
		Field objResultField = null;
		if (srcClass != Object.class) {
			try {
				objResultField = srcClass.getDeclaredField(name);
			} catch (Exception e) {
				LOG.debug("error", e);
				//忽略异常
			}
			if (objResultField == null) {
				objResultField = getField(srcClass.getSuperclass(), name);
			}
		}
		return objResultField;
	}

	/**
	 * 判断一个类是否为基本数据类型。
	 * @param clazz 要判断的类。
	 * @return true 表示为基本数据类型。
	 */
	@SuppressWarnings("rawtypes")
	protected boolean isBaseDataType(Class clazz) {
		return (baseDataTypeList.contains(clazz) || clazz.isPrimitive());
	}

	/* (non-Javadoc)
	 * @see jodd.bean.BeanVisitor#visitProperty(java.lang.String, java.lang.Object)
	 */
	@Override
	protected boolean visitProperty(String s, Object obj) {
		return false;
	}
}
