/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.workbenchconfig.convert;

/**
 * 工作台类型SQL构建器
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年11月26日 许畅 新建
 */
public interface IWorkbenchBuilder {

	/**
	 * 转换为SQL客户端需要的内容
	 * 
	 * @param content
	 *            SQL内容
	 * @return 转换为SQL客户端需要的内容
	 */
	public String buildClientSQL(String content);

}
