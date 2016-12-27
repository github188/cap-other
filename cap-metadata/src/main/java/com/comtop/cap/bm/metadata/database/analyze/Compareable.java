/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.database.analyze;

/**
 * 是否能够比较
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年11月18日 许畅 新建
 */
public interface Compareable {

	/**
	 * 比较的源对象
	 * 
	 * @return 获取来源对象
	 */
	public boolean needCompare();

}
