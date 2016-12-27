/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.workbenchconfig.convert;

/**
 * 工作台配置MYSQL构建器
 * 
 * @author 许畅
 * @since JDK1.7
 * @version 2016年12月26日 许畅 新建
 */
public class WorkbenchConfigMySQLBuilder implements IWorkbenchBuilder {

	/**
	 * 构造方法
	 */
	public WorkbenchConfigMySQLBuilder() {

	}

	/**
	 * 构建为MYSQL客户端支持SQL
	 *
	 * @param content
	 *            sql内容
	 * @return MYSQL client sql
	 *
	 * @see com.comtop.cap.bm.metadata.workbenchconfig.convert.IWorkbenchBuilder#buildClientSQL(java.lang.String)
	 */
	@Override
	public String buildClientSQL(String content) {
		StringBuffer fileContent = new StringBuffer();
		fileContent.append(content);
		fileContent.append("\n");
		fileContent.append("commit; \n");
		return fileContent.toString();
	}

}
