/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.sqlfile;

import com.comtop.corm.reflection.MetaObject;
import com.comtop.corm.reflection.factory.DefaultObjectFactory;
import com.comtop.corm.reflection.factory.ObjectFactory;
import com.comtop.corm.reflection.wrapper.DefaultObjectWrapperFactory;
import com.comtop.corm.reflection.wrapper.ObjectWrapperFactory;

/**
 * mybatis SystemMetaObject类
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年3月4日 许畅 新建
 */
public class SystemMetaObject {

	/**
	 * 
	 */
	public static final ObjectFactory DEFAULT_OBJECT_FACTORY = new DefaultObjectFactory();
	/**
	 * 
	 */
	public static final ObjectWrapperFactory DEFAULT_OBJECT_WRAPPER_FACTORY = new DefaultObjectWrapperFactory();
	/**
	 * 
	 */
	public static final MetaObject NULL_META_OBJECT = MetaObject.forObject(
			NullObject.class, DEFAULT_OBJECT_FACTORY,
			DEFAULT_OBJECT_WRAPPER_FACTORY);

	/**
	 * @param object
	 *            MetaObject
	 * @return MetaObject
	 */
	public static MetaObject forObject(Object object) {
		return MetaObject.forObject(object, DEFAULT_OBJECT_FACTORY,
				DEFAULT_OBJECT_WRAPPER_FACTORY);
	}

	/**
	 * 
	 * @author 许畅
	 * @since JDK1.6
	 * @version 2016年3月4日 许畅 新建
	 */
	class NullObject {
		//
	}

}
