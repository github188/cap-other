/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.database.dbobject;

import com.comtop.cap.bm.metadata.database.dbobject.util.DBType;

/**
 * 数据库类型接口
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年10月20日 许畅 新建
 */
public interface IDBType {

	/**
	 * 获取数据库类型
	 * 
	 * @return 数据库类型
	 */
	public DBType getDataBaseType();

}
