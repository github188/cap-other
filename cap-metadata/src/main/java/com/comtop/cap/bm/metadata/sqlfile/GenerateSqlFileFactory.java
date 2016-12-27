/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.sqlfile;

/**
 * 生成sql文件工厂类
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年3月4日 许畅 新建
 */
public class GenerateSqlFileFactory {

	/**
	 * 构造方法
	 */
	private GenerateSqlFileFactory() {

	}

	/**
	 * 获得TopFunc sql脚本文件处理类
	 * 
	 * @return GenerateTopFuncSqlFile
	 */
	public static IGenerateSqlFile<?> getTopFuncSqlFile() {

		return new GenerateTopFuncSqlFile();
	}

	/**
	 * 获得TopFunc sql脚本文件的最佳实现处理类
	 * 
	 * @return GenFuncSqlFileBestWay
	 */
	public static IGenerateSqlFile<?> getTopFuncSqlFileBestWay() {

		return new GenFuncSqlFileBestWay();
	}

}
