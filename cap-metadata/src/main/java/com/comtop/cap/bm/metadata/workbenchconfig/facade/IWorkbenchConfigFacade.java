/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.bm.metadata.workbenchconfig.facade;

import java.util.Map;

import com.comtop.cap.bm.metadata.workbenchconfig.model.WorkbenchConfigVO;

/**
 * 工作流工作台配置facade接口
 * 
 * @author 许畅
 * @since JDK1.6
 * @version 2016年2月24日 许畅 新建
 */
public interface IWorkbenchConfigFacade {

	/**
	 * 保存
	 * 
	 * @param page
	 *            page
	 * @return str
	 */
	String save(final WorkbenchConfigVO page);

	/**
	 * 删除
	 * 
	 * @param parameter
	 *            parameter
	 */
	void delete(Map<String, Object> parameter);

	/**
	 * 获取列表数据
	 * 
	 * @param map
	 *            map
	 * @return map
	 */
	Map<String, Object> getWorkbenchConfigListData(Map<String, Object> map);

}
