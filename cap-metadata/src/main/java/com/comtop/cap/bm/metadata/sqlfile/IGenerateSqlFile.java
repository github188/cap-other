/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.sqlfile;

import java.util.List;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.top.core.base.model.CoreVO;

/**
 * sqlFile接口
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年3月4日 许畅 新建
 * @param <T>
 *            CoreVO
 */
public interface IGenerateSqlFile<T extends CoreVO> {

	/**
	 * 生成insert sql
	 * 
	 * @param coreVO
	 *            CoreVO
	 * @return str
	 */
	public String createInsertSQL(T coreVO);

	/**
	 * 生成update sql
	 * 
	 * @param coreVO
	 *            CoreVO
	 * @return update sql
	 */
	public String createUpdateSQL(T coreVO);

	/**
	 * 获取sql内容
	 * 
	 * @return 获取sql
	 */
	public StringBuffer getSql();

	/**
	 * 生成数据操作sql文件
	 * 
	 * @param <M>
	 *            BaseMetadata
	 * 
	 * @param metadata
	 *            metadata
	 * @param codePath
	 *            codePath
	 * 
	 */
	public <M extends BaseMetadata> void createDataOptSQLfile(M metadata,
			String codePath);

	/**
	 * 批量生成sql文件
	 * 
	 * @param list
	 *            lst
	 * @param <M>
	 *            BaseMetadata
	 * @param codePath
	 *            生成代码路径
	 */
	public <M extends BaseMetadata> void createBatchOptSQLfile(List<M> list,
			String codePath);

}
